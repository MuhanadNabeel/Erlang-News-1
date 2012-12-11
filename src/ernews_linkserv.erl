%%%-------------------------------------------------------------------
%%% @author Khashayar Abdoli
%%% @copyright (C) 2012, Khashayar Abdoli
%%% @doc
%%% Center of the communication 
%%% @end
%%% Created :  8 Oct 2012 by Khashayar Abdoli
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
    %io:format("LINK SERVER IS COMING UP ~n",[]),
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%% It reads the important word from database and saves them in the state of the
%% server for further use
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    Words = ernews_defuns:read_words(),
    io:format("INITING ~n",[]),
    {ok, Words}.

%%--------------------------------------------------------------------
%% @doc
%% Handling cast messages
%% 
%% handles 3 diffrent messages 
%% 
%% parse message which is comming from rssread will start a html process 
%% with the arguments received within the message
%% 
%% submit message which is comming from html process, this will end up writing 
%% to database by calling db functions
%%
%% error message which comming from html process, this will end up writing 
%% to database with the reason of the error by calling db functions
%% 
%% there is also one condition that catches everything , so it wont crash and 
%% result will be return to the error logger
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast({parse, Source, Url, Ts}, State) ->
    %io:format("Parsing Source ~p : ~p~n" , [Source,Url]),
    ernews_html:start_link(Url, Source, Ts,State),
    {noreply, State};
handle_cast({submit, Source, Url, Title, Description, 
	     PubDate, Icon, Image, Tags}, State) ->
%   io:format("SUBMITTTTTTING " , []),
    Result = ernews_db:write(news, 
		    {Source, Url, Title, Description, 
		     Icon, Image ,PubDate , Tags}),
    error_logger:info_report(["New Article",{url,Url},{source,Source},
			      {result,Result}]),
    {noreply, State};
handle_cast({error, Reason, Url, Source}, State) ->
    %error_logger:info_report(["Broken",{url,Url},{source,Source},
%			      {reason,Reason}]),
    ernews_db:write(broken, {Url, Reason, Source}),
    {noreply, State};
handle_cast(Msg ,State) ->
    error_logger:info_report(["WTF",{message,Msg}]),
    {noreply, State}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% The rest are just in case of anything unusual happens, so it won't end 
%% in crashing. non of them will act on any kind of message
%% @end
%%--------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(Reason, _State) ->
    io:format("Reason ~p~n",[Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


    
