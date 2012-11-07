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
-export([start_link/5]).

%% gen_fsm callbacks
-export([init/1, duplicate/2 , read_url/2, end_url/2, handle_event/3,
	 handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(SERVER, ?MODULE).

-record(state, {url="", source="", ts="", 
		title="", description="", check_counter}).

%%%===================================================================
%%% API
%%%===================================================================


start_link(Url,Source,Ts, Title, Description) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts,Title,Description], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================


init([Url, Source, Ts, Title, Description]) ->
    State = #state{url=Url, source=Source, title=Title, 
		   description=Description, ts=Ts , check_counter = 0},
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
    Title = mix(ernews_htmlfuns:get_title(Record#state.url), Record#state.title),
    Description = mix(ernews_htmlfuns:get_description(Record#state.url), Record#state.description),	    		    
    case check_all([Title, Description]) of
	ok ->
	    {stop, submit , 
	     Record#state{title = element(2, Title) ,
			  description = element(2, Description)}};
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
terminate(submit, _StateName, Record = #state{}) ->
    gen_server:cast(ernews_linkserv,
		    {submit, Record#state.source , Record#state.url,
		     Record#state.title, Record#state.description, 
		     Record#state.ts});
terminate(Reason , _ , _ ) ->
    io:format("========================================================~n", []),
    io:format("UNKNOWN --  ~p~n", [Reason]),
    io:format("========================================================~n", []), 
    ok.

%------------------------------------------------------------------------

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.



    
%%%===================================================================
%%% Internal functions
%%%===================================================================

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

mix({ok,Main},_) ->
    {ok,Main};
mix({error,Reason}, undefined) ->
    {error,Reason};
mix(_,Source) ->
    Source.
