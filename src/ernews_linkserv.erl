%%%-------------------------------------------------------------------
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @copyright (C) 2012, Khashayar
%%% @doc
%%%
%%% @end
%%% Created :  8 Oct 2012 by Khashayar <khashayar@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(ernews_linkserv).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 


%%%===================================================================
%%% API
%%%===================================================================

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    {ok, dict_init()}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({parse, Source, Url, Ts}, State) ->
    case ernews_rssfuns:checkdate(Ts , dict:fetch(Source,State)) of
	true ->
	    ernews_htmlparser:start(Source,Url,Ts),
	    {noreply, State};
	false ->
	    {noreply, State}
    end;
handle_cast({submit, Source, Ts}, State) ->
    case ernews_rssfuns:checkdate(Ts , dict:fetch(Source,State)) of
	true ->
	    {noreply, dict:store(Source, Ts, State)};
	false ->
	    {noreplt, State}
    end;
handle_cast({error, Url, Ts, Reason}, State) ->
    case Reason of
	bad_url ->
	    %LOG
	    ok;
	duplicate ->
	    ok;
	not_relevent ->
	    ok;
	unknown ->
	    ok
    end.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

dict_init() ->
    DateTime = {{1990,1,1},{0,0,0}},
    Dic1 = dict:store(iocoder, DateTime, dict:new()),
    Dic2 = dict:store(google, DateTime, Dic1),
    Dic3 = dict:store(reddit, DateTime, Dic2),
    Dic4 = dict:store(hacker, DateTime, Dic3),
    Dic4.
    
