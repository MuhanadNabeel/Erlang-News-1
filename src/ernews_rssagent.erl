%%%-------------------------------------------------------------------
%%% @author Khashayar Abdoli
%%% @copyright (C) 2012, Khashayar Abdoli
%%% @doc
%%% Time scheduler for reading different sources
%%% @end
%%% Created :  8 Oct 2012 by Khashayar Abdoli
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
%% In the initialize we setup all the sources that we want, we setup the time 
%% to now as the first run, each source has an atom name, a URL , an interval 
%% and time that specifies the time to run
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
    Hacker_Source = "https://news.ycombinator.com/rss",
    Twitter_Source = "http://search.twitter.com/search.atom?q=%23erlang",
    DZone_Source = "http://www.dzone.com/links/feed/search/erlang/rss.xml",
    


    Coder = #rss_source{name = iocoder , source = Coder_Source ,
		    delay = 600 , time = Now},
    Reddit = #rss_source{name = reddit , source = Reddit_Source ,
		    delay = 300 , time = Now},
    Google = #rss_source{name = google , source = Google_Source ,
		    delay = 1200 , time = Now},
    Hacker = #rss_source{name = hacker , source = Hacker_Source ,
		    delay = 120 , time = Now},
    Twitter = #rss_source{name = twitter , source = Twitter_Source ,
		    delay = 30 , time = Now},
    DZone = #rss_source{name = dzone , source = DZone_Source ,
		    delay = 150 , time = Now},
    
    gen_fsm:send_event(?RSSAGENT, run),
    {ok, run, [Twitter,Reddit,Google,Coder,Hacker,DZone]}.

%%--------------------------------------------------------------------
%% @doc
%% 
%% We have two main states which together they create an infinite loop,
%% first state (run), runs all the sources if its their time to run
%% and forwards to waiting state by a Delay figured in the setup function which
%% indicates the delay till next run
%% second state (wait) is just a state for delaying and after the delay
%% it goes back to the run state
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
%% The rest are just in case of anything unusual happens, so it won't end 
%% in crashing. non of them will act on any kind of message
%% @end
%%--------------------------------------------------------------------

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

terminate(_Reason, _StateName, _State) ->
    ok.

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% This function gets the state from run state, It checks the time of each
%% source and if it's time for them to run it spawns the rssread process
%% and setup the next run-time with the interval
%% in the end it calculate the minimum delay needed till the next time to run
%% a source
%% @end
%%--------------------------------------------------------------------

setup(List) ->
    setup(List, 24*3600, []).

setup([S=#rss_source{} | T], Delay, New_List) ->
    Now = calendar:datetime_to_gregorian_seconds(calendar:local_time()),
    Run_Time = S#rss_source.time - Now,
    case Run_Time =< 0 of
	true ->
	    ernews_rssread:start(S#rss_source.name, 
				 S#rss_source.source),
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



