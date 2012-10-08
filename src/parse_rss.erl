% Author: Ingimar

-module(parse_rss).
-compile(export_all).

-include("records.hrl").

% Used temporarly, not included
read() ->
	inets:start(),
	{ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
%		httpc:request("http://news.google.com/news/feeds?hl=en&gl=us&q=erlang&um=1&ie=UTF-8&output=rss"),
%		httpc:request("http://coder.io/tag/erlang.rss"),
		httpc:request("http://www.reddit.com/r/erlang.rss"),
%		httpc:request("http://news.ycombinator.com/rss"),
	Body.

	
%% Called from process, Atom = hacker, else Atom = default
devide(Atom,List,TimeStamp) ->
	[_|T] = parse(List),
	iterate(Atom,T,TimeStamp,[]).
	
iterate(_Atom,[],_TimeStamp,List) ->
	List;

iterate(hacker,[H|T],_TimeStamp,List) ->
	URL = proplists:get_value("link",H),
	iterate(hacker,T,_TimeStamp,[#rss_item{link=URL}|List]);
				
iterate(_Atom,[H|T],TimeStamp,List) ->
	PubDate = proplists:get_value("pubDate",H),
	Compare = compare_dates(TimeStamp,PubDate),
	if 
		Compare >= 0 ->
			URL = proplists:get_value("link",H),
			iterate(_Atom,T,TimeStamp,[#rss_item{link=URL,
				pubDate=convert_pubDate_to_datetime(PubDate)}|List]);
		true ->
			iterate(_Atom,T,TimeStamp,List)
	end.
	
compare_dates(Date1,Date2) ->
	calendar:datetime_to_gregorian_seconds(convert_pubDate_to_datetime(Date2))
	-
	calendar:datetime_to_gregorian_seconds(Date1).
	
	
	%% {{2012,9,17},{13,53,19}}
	%% 2012-09-18T08:12:29+00:00
	
% Author:  Khashayar
convert_pubDate_to_datetime(DateTime) ->
    {ok,[_Day, Date, MonthS, Year,HH,MM,SS], _} = 
	io_lib:fread("~3s, ~2d ~3s ~4d ~2d:~2d:~2d" , DateTime),
    Month = case MonthS of
		"Jan" ->
		    1;
		"Feb" ->
		    2;
		"Mar" ->
		    3;
		"Apr" ->
		    4;
		"May" ->
		    5;
		"Jun" ->
		    6;
		"Jul" ->
		    7;
		"Aug" ->
		    8;
		"Sep" ->
		    9;
		"Oct" ->
		    10;
		"Nov" ->
		    11;
		"Dec" ->
		    12
	    end,
    {{Year,Month,Date},{HH,MM,SS}}.


parse(File) ->
    {ok, {Quotes, _}, _} = xmerl_sax_parser:stream(
                             File, 
                             [{event_fun, fun event/3},
                              {event_state, {[], ""}}]),
    lists:reverse(Quotes).

%% For the end field event, use the last set of characters 
%% encountered as the value for that field
-define(QUOTE_VALUE(Title),
        event(_Event = {endElement, _, Title, _}, 
              _Location, 
              _State = {[Quote|Rest], Chars}) ->
               Updated = [{Title, Chars}|Quote],
               {[Updated|Rest], undefined}).


%% Start "FutureQuote" creates a new, empty key-value list
%% for the quote
event(_Event = {startElement, _, "item", _, _}, 
      _Location, 
      _State = {Quotes, _}) ->
    {[[]|Quotes], ""};

%% Characters are stores in the parser state
event(_Event = {characters, Chars}, 
      _Location, 
      _State = {Quotes, _}) ->
    {Quotes, Chars};

?QUOTE_VALUE("pubDate");
?QUOTE_VALUE("link");
?QUOTE_VALUE("keywords");

%% Catch-all. Pass state on as-is    
event(_Event, _Location, State) ->
    State.