%%%-------------------------------------------------------------------
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @copyright (C) 2012, Khashayar
%%% @doc
%%%
%%% @end
%%% Created :  8 Oct 2012 by Khashayar <khashayar@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(ernews_rsssup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the supervisor
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a supervisor is started using supervisor:start_link/[2,3],
%% this function is called by the new process to find out about
%% restart strategy, maximum restart frequency and child
%% specifications.
%%
%% @spec init(Args) -> {ok, {SupFlags, [ChildSpec]}} |
%%                     ignore |
%%                     {error, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    io:format("WE ARE IN SUPER INIT~n" ,[]),
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = permanent,
    Shutdown = 2000,
    Type = worker,

    Google_Source = "http://news.google.com/news/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss", 
    Coder_Source = "http://coder.io/tag/erlang.rss" ,
    Reddit_Source = "http://www.reddit.com/r/erlang.rss" ,
    Hacker_Source = "http://news.ycombinator.com/rss",

    Coder = {iocoder_reader, 
	     {ernews_rssread, start_link, [iocoder, Coder_Source, 2]},
	     Restart, Shutdown, Type, [ernews_rssread]},
    Google = {google_reader, 
	      {ernews_rssread, start_link , [google, Google_Source, 12]},
	     Restart, Shutdown, Type, [ernews_rssread]},
    Reddit = {reddit_reader, 
	      {ernews_rssread, start_link, [reddit, Reddit_Source , 9]},
	     Restart, Shutdown, Type, [ernews_rssread]},    
    Hacker = {hacker_reader, 
	      {ernews_rssread, start_link, [hacker, Hacker_Source , 18]},
	     Restart, Shutdown, Type, [ernews_rssread]},
    io:format("WE ARE IN SUPER INIT Created~n" ,[]),
    {ok, {SupFlags, [Coder]}}. %, Google, Reddit, Hacker]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
