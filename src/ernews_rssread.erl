%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson <ingimar@student.gu.se>
%%% @copyright (C) 2012, Jablé
%%% @doc
%%%	Parses documents and sends messages to Link Server
%%% @end
%%% Created : 8 Oct 2012 by Ingimar <ingimar@student.gu.se>
%%%-------------------------------------------------------------------


-module(ernews_rssread).

-compile(export_all).
%-export([start_link/2,start/2]).
%-export([init/2]).
-include("records.hrl").


% http://search.twitter.com/search.atom?q=%23erlang
bla() ->
	{_,{_,B}} = ernews_defuns:read_web(default,"http://search.twitter.com/search.atom?q=%23erlang"),
	twitter(B).
	


%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Starts the process. Called from rssagent
%%% @end
start_link(Atom,Source) ->
    spawn_link(?MODULE, init,[Atom,Source]).
start(Atom,Source) ->
    spawn(?MODULE, init,[Atom,Source]).
%%%-------------------------------------------------------------------

%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Reads the source document and starts read/3
%%% @end
init(dzone,Source) ->
    read(start,ernews_defuns:read_web(dzone,Source),dzone);
init(Atom,Source) ->
    read(start,ernews_defuns:read_web(default,Source),Atom).
%%%-------------------------------------------------------------------
	

%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Reads parsed document and sends messages to Link Server
%%% @end
read(start,{error,Reason},_Atom) ->
    {error,Reason};	
read(start,{success,{_Head,Body}},Atom) ->
    read(Atom,iterate(Atom,Body)).
read(Atom,[#rss_item{link=Link,pubDate=PubDate}|T]) ->
    gen_server:cast(ernews_linkserv,{parse,Atom,Link,PubDate}),
    read(Atom,T);
read(_Atom,[]) ->
    ok.
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Iterates through the parsed document
%%% Returns a list of tuples, consisting of date and URL.
%%% @end
iterate(twitter,List) ->
    iterate(twitter,twitter(List),[]);
iterate(Atom,List) ->
    iterate(Atom,parse(List),[]).
iterate(hacker,[H|T],List) ->
    URL = proplists:get_value("link",H),
    iterate(hacker, T,
	    [#rss_item{link=URL, pubDate=erlang:universaltime()}
	     |List]);
iterate(twitter,[H|T],List) ->
    iterate(twitter, T,
	    [#rss_item{link=H, pubDate=erlang:universaltime()}
	     |List]);
iterate(reddit,[H|T],List) ->
    case proplists:get_value("link",H) of
	undefined ->
	    iterate(reddit, T, List);
	_Else ->
	    iterate(reddit, T,
		    [#rss_item{link=proplists:get_value("link",H),
			       pubDate=ernews_defuns:convert_date(
					 proplists:get_value("pubDate",H))
					 }
		     |List])
    end;
iterate(Atom,[H|T],List) ->
    iterate(Atom, T,
	    [#rss_item{link=proplists:get_value("link",H),
		       pubDate=ernews_defuns:convert_date(
				 proplists:get_value("pubDate",H))
				 }
	     |List]);
iterate(_Atom,[],List) ->
    List.
%%%-------------------------------------------------------------------

%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Retrieves URL's starting with "http://t.co~p~n" from document
%%% Returns a list of URL's
%%% @end
twitter(List) ->
	twitter(List,false,[],[]).
twitter(T,Result,Buffer) ->
	case {string:str(Buffer,"twitter"),string:str(Buffer,"twimg")} of
		{0,0} ->
			%io:format("http://t.co~p~n",[Buffer]),
			twitter(T,false,["http://t.co" ++ Buffer|Result],[]);
		_ ->
			twitter(T,false,Result,[])
	end.
twitter([104,116,116,112,58,47,47,116,46,99,111|T],_,Result,_) ->
	twitter(T,true,Result,[]);
twitter([32|T],true,Result,Buffer) ->
	twitter(T,Result,Buffer);
twitter([38,108,116,59|T],true,Result,Buffer) ->
	twitter(T,Result,Buffer);
twitter([38,103,116,59|T],true,Result,Buffer) ->
	twitter(T,Result,Buffer);
twitter([60|T],true,Result,Buffer) ->
	twitter(T,Result,Buffer);
twitter([34|T],true,Result,Buffer) ->
	twitter(T,Result,Buffer);
twitter([H|T],true,Result,Buffer) ->
	twitter(T,true,Result,Buffer++[H]);
twitter([_|T],false,Result,_) ->
	twitter(T,false,Result,[]);
twitter([],_,Result,[]) ->
	ernews_defuns:remove_duplist(Result);
twitter([],_,Result,Buffer) ->
	ernews_defuns:remove_duplist([Buffer|Result]).
%%%-------------------------------------------------------------------
	

%%%-------------------------------------------------------------------
%%% @author Benjamin Nortier
%%% @doc
%%%	Parses RSS document
%%% http://www.1011ltd.com/web/blog/post/elegant_xml_parsing
%%% @end
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

event(_Event, _Location, State) ->
    State.
%%%-------------------------------------------------------------------
