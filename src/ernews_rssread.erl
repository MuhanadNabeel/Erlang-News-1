-module(ernews_rssread).

-export([start_link/2,start/2]).

-export([init/2]).

-include("records.hrl").

start_link(Atom,Source) ->
	spawn_link(?MODULE, init,[Atom,Source]).

start(Atom,Source) ->
	spawn(?MODULE, init,[Atom,Source]).


%% Start process
%% Reads the RSS source using function from ernews_defuns
%% Sends the result from the read to function
init(Atom,Source) ->
	read(start,ernews_defuns:read_web(default,Source),Atom).
	

%% Receives error atom when reading RSS
%% Returns error message
read(start,{error,Reason},_Atom) ->
	{error,Reason};
	
%% Receives success atom when reading RSS
%% Starts parsing of document with get_rss
read(start,{success,{Head,Body}},Atom) ->
	read({Head,Body},Atom).
	
	
read({_Headers, Body},Atom) ->
	read(Atom,iterate(Atom,Body));

read(Atom,[#rss_item{link=Link,pubDate=PubDate}|T]) ->
	io:format("~p~n",[{Link,PubDate}]),
	gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
	read(Atom,T);

read(_Atom,[]) ->
	ok.
	

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
