%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%%-------------------------------------------------------------------
-module(ernews_html).

-behaviour(gen_fsm).

%% API
-export([start_link/4 , check_all/1]).

%% gen_fsm callbacks
-export([init/1, duplicate/2 , read_url/2, end_url/2, check_relevancy/2,
	 handle_event/3,
	 handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(SERVER, ?MODULE).

-record(state, {url="", source="", ts="", image = "", icon = "", words,
		tags = [] , title="", description="", check_counter}).

%%%===================================================================
%%% API
%%%===================================================================

%% The start_link includes the nessecary sources for the functions to handle
%% and from there the gen_fsm starts 

start_link(Url,Source,Ts,Words) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts,Words], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

%% Assigning the data to the state
%% and passing the state to the end_url function.

init([Url, Source, Ts, Words]) ->
    State = #state{url=Url, source=Source, ts=Ts,
		   check_counter = 0 ,words = Words},
    gen_fsm:send_event(self(), end_url),
    {ok, end_url, State}.


%------------------------------------------------------------------------

%% the end_url function check if the url and the source is valid with a 
%% function from htmlfuns, if an error is returned then checking if it's 
%% bigger then 3 from the check_counter recieved at the beginning
%% then pass it to the terminate otherwise call the same function and puls
%% the checker with +1
%% If the function return a vaild url then pass it to the duplicate function
%% with a new state
end_url(end_url, Record=#state{}) ->
    case ernews_htmlfuns:end_url(
		    Record#state.source, Record#state.url) of
	{error, Reason} ->
	    case Record#state.check_counter > 3 of
		true ->
		    {stop, {error, Reason}, Record};
		false ->
		    gen_fsm:send_event(self(), end_url),
		    {next_state, end_url, 
		     Record#state{check_counter = Record#state.check_counter+1}}
	    end;
       NewUrl ->
	    gen_fsm:send_event(self(), duplicate),
	    {next_state, duplicate, Record#state{url = NewUrl}}
    end.




%------------------------------------------------------------------------
%% The duplicate function check if the url already exists in the dataebase
%% with the help from the function exists from ernews_db module
%% if it's true pass it to the terminate otherwise pass it to the read_url
%% function 

duplicate(duplicate, Record=#state{}) ->
    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
	true ->
	    {stop, {error, already_exists}, Record};
	false ->
	    gen_fsm:send_event(self(), read_url),
	    {next_state, read_url, Record}
    end.


%------------------------------------------------------------------------

%% The read_url function passes the url to htmlfuns function and 
%% gets information back from that module, those will be checked
%% by the function check_all which handles all the possible outcomes
%% from get_info function in the module ernews_htmlfuns and pass them
%% to the state which is going to the check_relevency function
%% if the function returns an error then go through the function again
%% and add to the check_counter +1 if it's more then 3 then pass it 
%% to the terminate

read_url(read_url, Record=#state{}) ->
    Info_List = ernews_htmlfuns:get_info(Record#state.url),
    case check_all(Info_List) of
	ok ->
	  gen_fsm:send_event(self(), check_relevancy),
	  {next_state, check_relevancy, 
	   Record#state{title = element(2, hd(lists:sublist(Info_List,1,1))),
	       	  description = element(2, hd(lists:sublist(Info_List,2,1))),
       		  icon = element(2, hd(lists:sublist(Info_List,3,1))),
		  image = element(2, hd(lists:sublist(Info_List,4,1)))}};
	{error, Reason} ->
	    case Record#state.check_counter > 3 of
		true ->
		  {stop,{error, Reason}, Record};
		false ->
		  gen_fsm:send_event(self(), read_url),
		  {next_state, read_url, 
		   Record#state{check_counter = Record#state.check_counter+1}}
	    end
    end.


%------------------------------------------------------------------------

%% This function pass the new information stored in the state
%% to the function in the module htmlfuns if the function returns
%% ok then submit it to the terminate otherwise terminate it with error
%% message

check_relevancy(check_relevancy, Record=#state{}) ->
    case ernews_htmlfuns:relevancy_check(Record#state.url, Record#state.words) of
	{ok, Tags} ->
	    {stop, submit, Record#state{tags= Tags}};
	{error, Reason} ->
	    {stop, {error, Reason} , Record}
    end.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_all_state_event/2, this function is called to handle
%% the event.
%%
%% @spec handle_event(Event, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_all_state_event/[2,3], this function is called
%% to handle the event.
%%
%% @spec handle_sync_event(Event, From, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it receives any
%% message other than a synchronous or asynchronous event
%% (or a system message).
%%
%% @spec handle_info(Info,StateName,State)->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%------------------------------------------------------------------------


%% This function recieves the error messages and pass them to the linkserver
%% The already_exists error will be passed to the linkserver and other errors 
%% with a reason. Other wise submit the vaild information also to the linkserver

terminate({error, already_exists} , _StateName, _State) ->
    ok;
terminate({error, Reason} , _StateName, Record = #state{}) ->
    gen_server:cast(ernews_linkserv, 
		    {error, Reason, Record#state.url, Record#state.source});
terminate(submit, _StateName,Record = #state{}) -> 
    gen_server:cast(ernews_linkserv,
		    {submit, Record#state.source , Record#state.url,
		     Record#state.title, Record#state.description, 
		     Record#state.ts, Record#state.icon, Record#state.image,
		     Record#state.tags
		    });
terminate(Reason , _ , Record = #state{}) -> 
    io:format("====================================================~n",[]),
    io:format("UNKNOWN - URL ~p~n-  ~p~n", [Record#state.url, Reason ]),
    io:format("====================================================~n",[]), 
    ok.



%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, StateName, State, Extra) ->
%%                   {ok, StateName, NewState}
%% @end
%%--------------------------------------------------------------------


code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.



    
%%%===================================================================
%%% Internal functions
%%%===================================================================

%% This function checks all the possible messages recieved from
%% the function get_info from the module htmlfuns and add it to the buffer.

check_all({error,Reason}) ->
    {error,Reason};
check_all(List) ->
    check_all(List,"").
check_all([],[]) ->
    ok;
check_all([], Reason) ->
    {error, Reason};
check_all([{error,Reason}|T] , Buff) ->
    check_all(T, Buff ++ "-" ++ atom_to_list(Reason));
check_all([_H|T], Buff) ->
    check_all(T, Buff).

