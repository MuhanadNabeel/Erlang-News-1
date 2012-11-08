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


start_link(Url,Source,Ts,Words) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts,Words], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================


init([Url, Source, Ts, Words]) ->
    State = #state{url=Url, source=Source, ts=Ts,
		   check_counter = 0 ,words = Words},
    gen_fsm:send_event(self(), end_url),
    {ok, end_url, State}.


%------------------------------------------------------------------------

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

duplicate(duplicate, Record=#state{}) ->
    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
	true ->
	    {stop, {error, already_exists}, Record};
	false ->
	    gen_fsm:send_event(self(), read_url),
	    {next_state, read_url, Record}
    end.


%------------------------------------------------------------------------
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

check_relevancy(check_relevancy, Record=#state{}) ->
    case ernews_htmlfuns:relevancy_check(Record#state.url, Record#state.words) of
	{ok, Tags} ->
	    {stop, submit, Record#state{tags= Tags}};
	{error, Reason} ->
	    {stop, {error, Reason} , Record}
    end.

%-------------------------------------------------------------------------------
handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%------------------------------------------------------------------------

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%------------------------------------------------------------------------

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%------------------------------------------------------------------------

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
    io:format("========================================================~n", []),
    io:format("UNKNOWN - URL ~p~n-  ~p~n", [Record#state.url, Reason ]),
    io:format("========================================================~n", []), 
    ok.

%------------------------------------------------------------------------

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.



    
%%%===================================================================
%%% Internal functions
%%%===================================================================
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

