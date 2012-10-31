%%%-------------------------------------------------------------------
%%% @author Ingimar <ingimar@student.gu.se>
%%% @copyright (C) 2012, Ingimar Samuelsson
%%% @doc
%%%
%%% @end
%%% Created : 8 Oct 2012 by Ingimar <ingimar@student.gu.se>
%%%-------------------------------------------------------------------

%% http://news.google.com/news/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss
%% http://coder.io/tag/erlang.rss
%% http://www.reddit.com/r/erlang.rss

-module(ernews_rssread).

-export([start_link/2,start/2]).

-export([init/2]).

-include("records.hrl").

start_link(Atom,Source) ->
	spawn_link(?MODULE, init,[Atom,Source]).

start(Atom,Source) ->
	spawn(?MODULE, init,[Atom,Source]).


%% Start process
%% Reads the RSS source using ernews_defuns:read_web/2
%% Sends the result to read/3
init(Atom,Source) ->
	read(start,ernews_defuns:read_web(default,Source),Atom).
	

%% Receives error atom when reading RSS
%% Returns error message
read(start,{error,Reason},_Atom) ->
	{error,Reason};
	
%% Receives success atom when reading RSS
%% Parses document with iterate/2
read(start,{success,{_Head,Body}},Atom) ->
	read(Atom,iterate(Atom,Body)).

%% Iterate through the parsed list
%% Sends message to gen_server with URL and PubDate
read(Atom,[#rss_item{link=Link,pubDate=PubDate,title=Title,description=Description}|T]) ->
	io:format("~p~n",[{Link,PubDate,Title,Description}]),
	%%gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
	read(Atom,T);

%% Iterating through parsed list done
read(_Atom,[]) ->
	ok.
	
%% Start iterating through parsed RSS doc
iterate(Atom,List) ->
	iterate(Atom,parse(List),[]).

%% Iterating through parsed RSS doc
%% Hacker RSS only has links - date is added
iterate(hacker,[H|T],List) ->
	URL = proplists:get_value("link",H),
	iterate(hacker, T,
		[#rss_item{link=URL, pubDate=erlang:universaltime()}
		 |List]);
		 
%% Iterating through parsed RSS doc
%% For default Atoms
iterate(_Atom,[H|T],List) ->
	iterate(_Atom, T,
		[#rss_item{link=proplists:get_value("link",H),
				   pubDate=ernews_defuns:convert_pubDate_to_datetime(proplists:get_value("pubDate",H)),
				   description=proplists:get_value("description",H),
				   title=proplists:get_value("title",H)
			  }
		 |List]);
		 
%% Iteration done
%% Return List of #rss_item
iterate(_Atom,[],List) ->
	List.


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
?QUOTE_VALUE("description");
?QUOTE_VALUE("title");

event(_Event, _Location, State) ->
    State.

%% </Accumulated>
