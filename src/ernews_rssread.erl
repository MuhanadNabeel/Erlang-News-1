-module(ernews_rssread).
-compile(export_all).
-include("records.hrl").

% "http://news.google.com/news/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss"
% "http://coder.io/tag/erlang.rss"
% "http://www.reddit.com/r/erlang.rss"
% "http://news.ycombinator.com/rss"


init(Atom,Source) ->
	spawn_link(?MODULE, read,[{Atom,Source}]).

read({Atom,Source}) ->
	inets:start(),
	{ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
		httpc:request(Source),
	read(Atom,devide(Atom,Body)).
	
read(_Atom,[]) ->
	done;
	
read(Atom,[#rss_item{link=Link,pubDate=PubDate}|T]) ->
	io:format("~p~n",[{Link,PubDate}]),
	gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
	read(Atom,T).
	

devide(Atom,List) ->
	[_|T] = parse(List),
	iterate(Atom,T,[]).
	
	
iterate(_Atom,[],List) ->
	List;

iterate(hacker,[H|T],List) ->
	URL = proplists:get_value("link",H),
	iterate(hacker,T,[#rss_item{link=URL}|List]);
				
iterate(_Atom,[H|T],List) ->
	iterate(_Atom,T,[#rss_item{link=proplists:get_value("link",H),
		pubDate=ernews_rssfuns:convert_pubDate_to_datetime(proplists:get_value("pubDate",H))}|List]).
		
		
		
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
