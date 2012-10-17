%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%-------------------------------------------------------------------
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @copyright (C) 2012, Khashayar
%%% @doc
%%%
%%% @end
%%% Created :  8 Oct 2012 by Khashayar <khashayar@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(ernews_supervisor).

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
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    Restart = permanent,
    Shutdown = 2000,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Rss_Agent = {ernews_rssagent , {ernews_rssagent , start_link , []},
	       Restart , Shutdown , worker, [ernew_rssagent]},
    Link_Serv = {ernews_linkserv , {ernews_linkserv , start_link , []},
		 Restart , Shutdown , worker , [ernew_linkserv]},
    
    {ok, {SupFlags, [Link_Serv, Rss_Agent]}}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
