%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <gusnabemu@student.gu.se>
%%% @copyright (C) 2012, Jáble Muhanad Nabeel
%%% @doc
%%%     This module is about passing and checking if the information recieved
%%%     is vaild 
%%% @end
%%% Created : 10 Oct 2012 by Muhanad Nabeel <gusnabemu@student.gu.se>
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
%%% @author Muhanad Nabeel
%%% @doc
%%% The start_link includes the nessecary sources for the functions to handle
%%% and from there the gen_fsm starts 
%%% @end
start_link(Url,Source,Ts,Words) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts,Words], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================
%%% @author Muhanad Nabeel
%%% @doc
%%% Assigning the data to the state
%%% and passing the state to the end_url function. 
%%%       
%%% @end
init([Url, Source, Ts, Words]) ->
    State = #state{url=Url, source=Source, ts=Ts,
		   check_counter = 0 ,words = Words},
    gen_fsm:send_event(self(), end_url),
    {ok, end_url, State}.


%------------------------------------------------------------------------
%%% @author Muhanad Nabeel
%%% @doc
%%% The end_url function check if the url and the source is valid with a 
%%% function from htmlfuns, if an error is returned then checking if it's 
%%% bigger then 3 from the check_counter recieved at the beginning
%%% then pass it to the terminate otherwise call the same function and puls
%%% the checker with +1.
%%% If the function return a vaild url then pass it to the duplicate function
%%% with a new state    
%%%       
%%% @end
end_url(end_url, Record=#state{}) ->
    case ernews_htmlfuns:end_url(
		    Record#state.source, Record#state.url) of
	{error, Reason} ->
	    case Record#state.check_counter > 3 of
		true ->
		    {stop, {shutdown, Reason}, Record};
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
%%% @author Muhanad Nabeel
%%% @doc
%%% The duplicate function check if the url already exists in the dataebase
%%% with the help from the function exists from ernews_db module
%%% if it's true pass it to the terminate otherwise pass it to the read_url
%%% function 
%%%       
%%% @end
duplicate(duplicate, Record=#state{}) ->
    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
	true ->
	    {stop, {shutdown, already_exists}, Record};
	false ->
	    gen_fsm:send_event(self(), read_url),
	    {next_state, read_url, Record};
	{error, Reason} ->
	    {stop, {shutdown, Reason} , Record}
    end.


%------------------------------------------------------------------------
%%% @author Muhanad Nabeel
%%% @doc
%%% The read_url function passes the url to htmlfuns function and 
%%% gets information back from that module, those will be checked
%%% by the function check_all which handles all the possible outcomes
%%% from get_info function in the module ernews_htmlfuns and pass them
%%% to the state which is going to the check_relevency function
%%% if the function returns an error then go through the function again
%%% and add to the check_counter +1 if it's more then 3 then pass it 
%%% to the terminate
%%%       
%%% @end
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
		  {stop,{shutdown, Reason}, Record};
		false ->
		  gen_fsm:send_event(self(), read_url),
		  {next_state, read_url, 
		   Record#state{check_counter = Record#state.check_counter+1}}
	    end
    end.


%------------------------------------------------------------------------
%%% @author Muhanad Nabeel
%%% @doc
%%% This function pass the new information stored in the state
%%% to the function in the module htmlfuns if the function returns
%%% "ok" then submit it to the terminate otherwise terminate it with error
%%% message  
%%%       
%%% @end
check_relevancy(check_relevancy, Record=#state{}) ->
    case ernews_htmlfuns:relevancy_check(Record#state.url, Record#state.words) of
	{ok, Tags} ->
	    {stop, {shutdown,submit}, Record#state{tags= Tags}};
	{error, Reason} ->
	    {stop, {shutdown, Reason} , Record}
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
%%% @author Muhanad Nabeel
%%% @doc
%%% This function recieves the error messages and pass them to 
%%% the linkserver. The already_exists error will be passed to the 
%%% linkserver and other errors with a reason. 
%%% Other wise submit the vaild information also to the linkserver
%%%       
%%% @end



terminate({shutdown, already_exists} , _StateName, _State) ->
    normal;
terminate({shutdown, Reason} , _StateName, Record = #state{}) ->
    gen_server:cast(ernews_linkserv, 
		    {error, Reason, Record#state.url, Record#state.source}),
    normal;
terminate({shutdown, submit}, _StateName,Record = #state{}) -> 
    gen_server:cast(ernews_linkserv,
		    {submit, Record#state.source , Record#state.url,
		     Record#state.title, Record#state.description, 
		     Record#state.ts, Record#state.icon, 
		     Record#state.image, Record#state.tags
		    }),
    normal;
terminate(Reason , StateName , Record = #state{}) -> 
    error_logger:error_report(["Error in HtmlFuns",{state,StateName},
			       {source,Record#state.source},
			       {url,Record#state.url},{reason,Reason}]),
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

%%% @author Khashayar Abdoli, Muhanad Nabeel
%%% @doc
%%% This function checks all the possible messages recieved from
%%% the function get_info from the module htmlfuns and add it 
%%% to the buffer.
%%%       
%%% @end


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

