% Author: Ingimar

-module(parse_rss).
-compile(export_all).

-include("records.hrl").

% Used temporarly
read() ->
	inets:start(),
	{ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
		  httpc:request("http://coder.io/tag/erlang.rss"),
	Body.

	
devide(coder,List,TimeStamp) ->
	[_|T] = parse(List),
	iterate(T,TimeStamp,[]).
	
iterate([],_TimeStamp,List) ->
	List;
	
iterate([H|T],TimeStamp,List) ->
	Keys = proplists:get_value("keywords", H),
	Index = string:rstr(Keys, "erlang"),
	PubDate = proplists:get_value("pubDate",H),	
	Compare = compare_dates(TimeStamp,PubDate),
	if 
		Index > 0, Compare >= 0 ->
			URL = proplists:get_value("link",H),
			Tags = proplists:get_value("keywords",H),
			iterate(T,TimeStamp,[#rss_item{link=URL,
										pubDate=convert_pubDate_to_datetime(PubDate),
										tags=Tags}|List]);
		true ->
			iterate(T,TimeStamp,List)
	end.

compare_dates(Date1,Date2) ->
	calendar:datetime_to_gregorian_seconds(convert_pubDate_to_datetime(Date2))
	-
	calendar:datetime_to_gregorian_seconds(convert_pubDate_to_datetime(Date1)).

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