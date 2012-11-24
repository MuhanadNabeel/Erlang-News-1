%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson <ingimar@student.gu.se>
%%% @author Khashayar Abdoli <khashayar@localhost.localdomain>
%%% @author Magnus Tulin <magnus@localhost.localdomain>
%%% @author Muhanad Nabeel <muhanad@localhost.localdomain>
%%% @copyright (C) 2012, Jablé
%%% @doc
%%%	Various functions
%%% @end
%%% Created : 8 Oct 2012 by Ingimar <ingimar@student.gu.se>
%%%-------------------------------------------------------------------


-module(ernews_defuns).
%%-export([read_web/2,convert_date/1,read_words/0,is_relevant/4,split_text/1]).
-compile(export_all).

test_rel(Src) ->
	ernews_htmlfuns:relevancy_check(Src,read_words()).
test1(A,B) ->
	list_words_occur_insens(A,string:tokens(B," ")).


%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson & Magnus Tulin
%%% @doc
%%%	Attempts to fetch and read a document from URL
%%% @end
read_web({ok, {{_Version, _, _ReasonPhrase}, Headers, Body}}) ->
	{success,{Headers,Body}};
read_web({error,no_scheme})->
    {error,broken_html};
read_web({error,{failed_connect,_}})->
    {error,connection_failed}; % broken link
read_web({error,{ehostdown,_}})->
    {error,host_is_down};
read_web({error,{ehostunreach,_}})->
    {error,host_unreachable};
read_web({error,{etimedout,_}})->
    {error,connection_timed_out};
read_web({error,{ebadrqc,_}})->
    {error,bad_request_code};
read_web({error,{ecomm,_}})->
    {error, communication_error};
read_web({error,{econnrefused,_}})->
    {error, connection_refused};
read_web({error,{enetdown,_}})->
    {error, network_down};
read_web({error,{enetunreach,_}})->
    {error, network_unreachable};
read_web(Reason) ->
	{error,Reason}.
read_web(default,Src) ->
    ssl:start(),
    inets:start(),
    read_web(httpc:request(Src));
read_web(iocoder,Src) ->
    ssl:start(),
    inets:start(),
    read_web(httpc:request(get, {Src, []}, [{autoredirect, false}], []));
read_web(dzone,Src) ->
    ssl:start(),
    inets:start(),
    read_web(httpc:request(get, {Src, [{"User-Agent","Jable"}]}, 
			   [{autoredirect, false}], [])).
%%%-------------------------------------------------------------------

%%%-------------------------------------------------------------------
%%% @author Khashayar Abdoli
%%% @doc
%%%	Converts pubDate from RSS document to Erlang date
%%% @end
convert_date(DateTime) ->
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
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Returns three lists from database in a tuble:
%%% Relevant words, Irrelevant words, Tags
%%% @end
read_words() ->
	{ernews_db:getList(relevant),
		ernews_db:getList(irrelevant),
		ernews_db:getList(tag)}.
%%%-------------------------------------------------------------------
		
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Generate tags for articles
%%% @end
get_tags([],_) ->
	[];	
get_tags([H|T],List) ->
	case list_words_occur_insens(H,List) of
		true ->
			[H] ++ get_tags(T,List);
		false ->
			get_tags(T,List)
	end.
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Counts how many times a word occurs in a list
%%% @end
count_words(WordList,CheckList) ->
	count_words(WordList,CheckList,0).
count_words([],_,Counter) ->
	Counter;
count_words([H|T],List,Counter) ->
	case list_words_occur_insens(H,List) of
		true ->
			count_words(T,List,Counter+1);
		false ->
			count_words(T,List,Counter)
	end.
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Removes duplicates from a list
%%% @end
remove_duplist(List) ->
	remove_duplist(List,[]).
remove_duplist([H|T],List) ->
	case lists:member(H,List) of
		true ->
			remove_duplist(T,List);
		false ->
			remove_duplist(T,[H|List])
	end;
remove_duplist([],List) ->
	List.
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Checks for relevancy of article using a list of words from db
%%% @end
is_relevant(List,Good,Bad,Tags) ->
	Html = string:tokens(List," "),
	is_relevant(count_words(Good,Html),
				count_words(Bad,Html),
				{Html,Tags}).
is_relevant(0,_,_) ->
	{error,not_relevant};
is_relevant(_,0,{Html,Tags}) ->
	{ok,remove_duplist( get_tags(Tags,Html) )};
is_relevant(_,_,_) ->
	{error,wrong_content}.
%%%-------------------------------------------------------------------

%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson
%%% @doc
%%%	Checks if word(s) occur in a String - not case sensetive
%%% @end
list_words_occur_insens(Words,List) ->
	Split = string:tokens(Words," "),
	list_words_occur_insens(lists:concat(Split),List,length(Split)).
list_words_occur_insens(_,List,Length) when length(List) < Length ->
	false;
list_words_occur_insens(WordConcat,List,Length) ->
	ListConcat = lists:concat(lists:sublist(List,1,Length)),
	%CompareLength = length(ListConcat) == length(WordConcat),
	%Compare = string:to_lower(ListConcat) == string:to_lower(WordConcat),
%	io:format("~p = ~p = ~p~n",[ListConcat,WordConcat,Compare]),
	case compare_concat_str(WordConcat,ListConcat) of
		true ->
			true;
		_ ->
			list_words_occur_insens(WordConcat,tl(List),Length)
	end.
%%%-------------------------------------------------------------------
	
%%%-------------------------------------------------------------------
%%% @author Ingimar Samuelsson	
%%% @doc
%%%	Compare two strings
%%% @end
compare_concat_str(Str1,Str2) ->
	Left = string:to_lower(string:left(Str2,string:len(Str1))),
	Right = string:to_lower(string:right(Str2,string:len(Str1))),
	Word = string:to_lower(Str1),
	if
		Word == Left ->
			true;
		Word == Right ->
			true;
		true ->
			false
	end.
%%%-------------------------------------------------------------------
		
%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel
%%% @doc
%%%	Split string into a list, devided with " "
%%% @end
split_text(Str) ->
	split_text(Str, [], []).
split_text([], [], Words) ->
	lists:reverse(Words);
split_text([], Word, Words) ->
	lists:reverse([lists:reverse(Word) | Words]);
split_text([$ | Str], [], Words) ->
	split_text(Str, [], Words);
split_text([$ | Str], Word, Words) ->
	split_text(Str, [], [lists:reverse(Word) | Words]);
split_text([X | Str], Word, Words) ->
	split_text(Str, [X | Word], Words).
%%%-------------------------------------------------------------------

	
	
	
	
%%
%% Remaining code is note in current version
%%
	
	

%% Author: Muhanad Nabeel & Ingimar Samuelsson
readlines(Src) ->
    {ok, Device} = file:open(Src, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

%% Author: Muhanad Nabeel & Ingimar Samuelsson
get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> 
			Last = string:right(Line,1),
			if 
				Last == "\n" ->
					[string:left(Line,length(Line)-1) | get_all_lines(Device)];
				true ->
					[Line | get_all_lines(Device)]
			end
	end.
	
%% Author: Khashayar Abdoli
%% Gets description
get_description(List, iocoder) ->
    coder_description(List,[] , false);
get_description(List, google) ->
    Desc = google_description(List,[] , 0),
    %io:format("DESC : ~s~n", [Desc]),
    google_tag_remover(Desc, [] , true).

%% Author: Khashayar Abdoli
coder_description([] , Buff , _) ->
    Buff;
coder_description([$<,$/,$b,$l,$o,$c,$k,$q,$u,$o,$t,$e,$>|_T] , Buff , _) ->
    Buff;
coder_description([$<,$b,$l,$o,$c,$k,$q,$u,$o,$t,$e,$>|T] , Buff , _) ->
    coder_description(T, Buff, true);
coder_description([H|T], Buff, true) ->
    coder_description(T, Buff ++ [H], true);
coder_description([_|T], Buff, false) ->
    coder_description(T, Buff, false).

%% Author: Khashayar Abdoli
google_description([], Buff, _) ->
    Buff;
google_description([$&,$l,$t,$;,$f,$o,$n,$t,$ ,
		    $s,$i,$z,$e,$=,$",$-,$1,$",$>|T], Buff, Counter) ->
    google_description(T, Buff, Counter+1);
google_description([$&,$l,$t,$;,$/,$f,$o,$n,$t,$>|_T], Buff, 2) ->
    Buff;
google_description([H|T], Buff, 2) ->
    google_description(T, Buff ++ [H], 2);
google_description([_H|T], Buff, Counter) ->
    google_description(T, Buff, Counter).
				     

%% Author: Khashayar Abdoli
google_tag_remover([], Buff, _) ->
    Buff;
google_tag_remover([$&,$l,$t,$;|T], Buff , _) ->
    google_tag_remover(T, Buff, false);
google_tag_remover([$>|T], Buff, _) ->
    google_tag_remover(T, Buff, true);
google_tag_remover([H|T], Buff, true) ->
    google_tag_remover(T, Buff ++ [H], true);
google_tag_remover([_H|T] , Buff, false) ->
    google_tag_remover(T, Buff, false).
