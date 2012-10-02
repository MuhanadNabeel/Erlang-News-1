% Author: Ingimar

-module(parse_rss).
-compile(export_all).

-include("records.hrl").

% Used temporarly
read() ->
	inets:start(),
	{ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} =
		httpc:request("http://www.planeterlang.org/en/planet/rss_2.0"),
%		httpc:request("http://coder.io/tag/erlang.rss"),
%		httpc:request("http://www.reddit.com/r/erlang.rss"),
	Body.

	
devide(Atom,List,TimeStamp) ->
	[_|T] = parse(List),
	iterate(Atom,T,TimeStamp,[]).
	
iterate(_Atom,[],_TimeStamp,List) ->
	List;
	
iterate(Atom,[H|T],TimeStamp,List) ->
	%Keys = proplists:get_value("keywords", H),
	%Index = string:rstr(Keys, "erlang"),
	if
		Atom == planeterlang ->
			PubDate = proplists:get_value("date",H);
		true ->
			PubDate = proplists:get_value("pubDate",H)
	end,
	Compare = compare_dates(Atom,TimeStamp,PubDate),
	if 
		Compare >= 0 -> % Index > 0, 
			URL = proplists:get_value("link",H),
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			%   % If using keywords                                     %
			%Tags = list_tags(Atom,proplists:get_value("keywords",H)),  %
			%iterate(Atom,T,TimeStamp,[#rss_item{link=URL, 	            %
			%	pubDate=convert_pubDate_to_datetime(PubDate),           %
			%	tags=Tags}|List]);							            %		
			%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
			iterate(Atom,T,TimeStamp,[#rss_item{link=URL,
				pubDate=convert_pubDate_to_datetime(Atom,PubDate)}|List]);
		true ->
			iterate(Atom,T,TimeStamp,List)
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
% Depricated - keywords will be genereated %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%list_tags(coder,[[]|T],List) ->
%	list_tags(coder,T,List);
%	
%list_tags(coder,["]"|T],List) ->
%	list_tags(coder,T,List);
%	
%list_tags(coder,[H|T],List) ->
%	list_tags(coder,T,[H|List]);
%	
%list_tags(coder,[],List) ->
%	List;
%	
%list_tags(coder,String) ->
%	[_|T] = re:split(String,"[\",\"]",[{return,list}]),
%	list_tags(coder,T,[]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

compare_dates(Atom,Date1,Date2) ->
	calendar:datetime_to_gregorian_seconds(convert_pubDate_to_datetime(Atom,Date2))
	-
	calendar:datetime_to_gregorian_seconds(Date1).
	
	
	%% {{2012,9,17},{13,53,19}}
	%% 2012-09-18T08:12:29+00:00
	
list_string_to_int(L) ->
	list_string_to_int(L,[]).
	
list_string_to_int([H|T],List) ->
	list_string_to_int(T,[element(1,string:to_integer(H))|List]);

list_string_to_int([],List) ->
	lists:reverse(List).
	
convert_pubDate_to_datetime([]) ->
	[];
	
convert_pubDate_to_datetime([H|T]) ->
	[string:to_integer(H)] ++ convert_pubDate_to_datetime(T).

convert_pubDate_to_datetime(planeterlang,undefined) ->
	{{2013,9,17},{13,53,19}};
	
convert_pubDate_to_datetime(planeterlang,DateTime) ->
	[H|T] = re:split(DateTime,"[T]",[{return,list}]),
	Date = re:split(H,"[-]",[{return,list}]),
	[F|_] = re:split(hd(T),"[+]",[{return,list}]),
	Time = re:split(F,"[:]",[{return,list}]),
	{list_to_tuple(list_string_to_int(Date)),
	list_to_tuple(list_string_to_int(Time))};
		
% Author:  Khashayar
convert_pubDate_to_datetime(_,DateTime) ->
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