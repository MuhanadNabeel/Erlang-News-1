%%%-------------------------------------------------------------------
%%% @author Ingimar
%%% @copyright (C) 2012, Ingimar
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by Ingimar
%%%-------------------------------------------------------------------
-module(ernews_rssread).

-behaviour(gen_server).

%% API
-export([start_link/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-define(SERVER, ?MODULE). 
-include("records.hrl").

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
start_link(Atom,Source,TimeOut) ->
    gen_server:start_link({local, Atom}, ?MODULE, [Atom,Source,TimeOut], []).

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
init([Atom,Source,Timeout]) ->
    read({Atom,Source,Timeout*1000}),
    io:format("DONE READING~n" , []),
    {ok , []}.

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
handle_cast({ok,done}, State) ->
    {stop, done ,State}.

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
terminate(Reason, _State) ->
    io:format("TERMINATEDDDD ~p~n",[Reason]),
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

read({Atom,Source,Timeout}) ->
        io:format("WE ARE IN READ RSS1~n" ,[]),
	inets:start(),
	Read = httpc:request(Source),
	get_rss(Read,Atom,Timeout).
	
read(Atom,[],Timeout) ->
    timer:sleep(Timeout),
    io:format("~n~nSUCCESS timeout(~p, ~p) ~n~n With NORMAL",[Timeout,Atom]),
    gen_server:cast(Atom,{ok,done});
	
read(Atom,[#rss_item{link=Link,pubDate=PubDate}|T],Timeout) ->
	io:format("~p~n",[{Link,PubDate}]),
	%gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
	read(Atom,T,Timeout).
	

get_rss({ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}},Atom,Timeout) ->
	read(Atom,iterate(Atom,Body),Timeout);
	
get_rss(_,Atom,Timeout) ->
	timer:sleep(Timeout),
	io:format("~n~nERROR timeout(~p, ~p) ~n~n",[Timeout,Atom]).
	
iterate(Atom,List) ->
	[_|T] = parse(List),
	iterate(Atom,T,[]).
	
	
iterate(_Atom,[],List) ->
	List;

iterate(hacker,[H|T],List) ->
	URL = proplists:get_value("link",H),
	iterate(hacker,T,[#rss_item{link=URL,pubDate=erlang:universaltime()}|List]);
				
iterate(_Atom,[H|T],List) ->
	iterate(_Atom,T,[#rss_item{link=proplists:get_value("link",H),
		pubDate=ernews_defuns:convert_pubDate_to_datetime(proplists:get_value("pubDate",H))}|List]).
		
		
		
%% <Accumulated from="http://www.1011ltd.com/web/blog/post/elegant_xml_parsing">
parse(File) ->
    {ok, {Quotes, _}, _} = xmerl_sax_parser:stream(
                             File, 
                             [{event_fun, fun event/3},
                              {event_state, {[], ""}}]),
    lists:reverse(Quotes).

-define(QUOTE_VALUE(Title),
        event(_Event = {endElement, _, Title, _}, 
              _Location, 
              _State = {[Quote|Rest], Chars}) ->
               Updated = [{Title, Chars}|Quote],
               {[Updated|Rest], undefined}).


event(_Event = {startElement, _, "item", _, _}, 
      _Location, 
      _State = {Quotes, _}) ->
    {[[]|Quotes], ""};

event(_Event = {characters, Chars}, 
      _Location, 
      _State = {Quotes, _}) ->
    {Quotes, Chars};

?QUOTE_VALUE("pubDate");
?QUOTE_VALUE("link");
?QUOTE_VALUE("keywords");

event(_Event, _Location, State) ->
    State.
	
%% </Accumulated>
