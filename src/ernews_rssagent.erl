%%%-------------------------------------------------------------------
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @copyright (C) 2012, Khashayar
%%% @doc
%%%
%%% @end
%%% Created : 17 Oct 2012 by Khashayar <khashayar@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(ernews_rssagent).

-behaviour(gen_fsm).

%% API
-export([start_link/0]).

%% gen_fsm callbacks
-export([init/1, wait/2, run/2, handle_event/3,
	 handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(RSSAGENT, ?MODULE).

-include("records.hrl").

%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Creates a gen_fsm process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_fsm:start_link({local, ?RSSAGENT}, ?MODULE, [], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm is started using gen_fsm:start/[3,4] or
%% gen_fsm:start_link/[3,4], this function is called by the new
%% process to initialize.
%%
%% @spec init(Args) -> {ok, StateName, State} |
%%                     {ok, StateName, State, Timeout} |
%%                     ignore |
%%                     {stop, StopReason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    Now = calendar:datetime_to_gregorian_seconds(calendar:local_time()),

    Google_Source = "http://news.google.com/news" ++
	"/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss", 
    Coder_Source = "http://coder.io/tag/erlang.rss" ,
    Reddit_Source = "http://www.reddit.com/r/erlang.rss" ,
    Hacker_Source = "http://news.ycombinator.com/rss",

    Coder = #rss_source{name = iocoder , source = Coder_Source ,
		    delay = 10 , time = Now},
    Reddit = #rss_source{name = reddit , source = Reddit_Source ,
		    delay = 7 , time = Now},
    Google = #rss_source{name = google , source = Google_Source ,
		    delay = 3 , time = Now},
    Hacker = #rss_source{name = hacker , source = Hacker_Source ,
		    delay = 3 , time = Now},
    
    gen_fsm:send_event(?RSSAGENT, run),
    {ok, run, [Coder, Reddit, Google]}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_event/2, the instance of this function with the same
%% name as the current state name StateName is called to handle
%% the event. It is also called if a timeout occurs.
%%
%% @spec state_name(Event, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
run(run, State) ->
    {New_State, Delay} = setup(State),
    gen_fsm:send_event(?RSSAGENT, Delay),    
    {next_state, wait, New_State}.

wait(Delay, State) ->
    timer:sleep(Delay*1000),
    gen_fsm:send_event(?RSSAGENT, run),
    {next_state, run, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_event/[2,3], the instance of this function with
%% the same name as the current state name StateName is called to
%% handle the event.
%%
%% @spec state_name(Event, From, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------

%% IF WE WANT TO ADD SYNC CALL

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

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_fsm terminates with
%% Reason. The return value is ignored.
%%
%% @spec terminate(Reason, StateName, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _StateName, _State) ->
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

setup(List) ->
    setup(List, 24*3600, []).

setup([S=#rss_source{} | T], Delay, New_List) ->
    Now = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    Run_Time = S#rss_source.time - Now,
    case Run_Time =< 0 of
	true ->
	    io:format("spawing Rss Read ~p -- ~p~n",
		      [S#rss_source.name, S#rss_source.source]),
	    Next_Time = Now + S#rss_source.delay;
	false ->
	    Next_Time = S#rss_source.time
    end,
    New_Delay = Next_Time - Now,
    case New_Delay < Delay of
	true ->
	    setup(T, New_Delay, [S#rss_source{time=Next_Time}|New_List]);
	false ->
	    setup(T, Delay, [S#rss_source{time=Next_Time}|New_List])
    end;
setup([], Delay , New_List) ->
    {New_List, Delay}.



