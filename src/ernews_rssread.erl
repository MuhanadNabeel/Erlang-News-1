-module(ernews_rssread).

-export([start_link/3,start/3]).

-export([init/3]).

-include("records.hrl").

start_link(Atom,Source,Timeout) ->
	spawn_link(?MODULE, init,[Atom,Source,(Timeout*1000)]).

start(Atom,Source,Timeout) ->
	spawn(?MODULE, init,[Atom,Source,(Timeout*1000)]).


init(Atom,Source,Timeout) ->
	read({Atom,Source,Timeout}).


read({Atom,Source,Timeout}) ->
	inets:start(),
	Read = httpc:request(Source),
	get_rss(Read,Atom,Timeout).

read(Atom,[],Timeout) ->
	timer:sleep(Timeout),
	io:format("~n~nSUCCESS timeout(~p, ~p) ~n~n",[Timeout,Atom]);

read(Atom,[#rss_item{link=Link,pubDate=PubDate}|T],Timeout) ->
	io:format("~p~n",[{Link,PubDate}]),
	gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
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
	iterate(hacker, T,
		[#rss_item{link=URL, pubDate=erlang:universaltime()}
		 |List]);

iterate(_Atom,[H|T],List) ->
	iterate(_Atom, T,
		[#rss_item{link=proplists:get_value("link",H),
			   pubDate=ernews_defuns:convert_pubDate_to_datetime(
				     proplists:get_value("pubDate",H))
			  }
		 |List]).


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
