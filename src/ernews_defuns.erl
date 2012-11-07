%%%-------------------------------------------------------------------
%%% @author Ingimar <ingimar@student.gu.se>
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @author Magnus <magnus@localhost.localdomain>
%%% @copyright (C) 2012, Ingimar
%%% @copyright (C) 2012, Khashayar
%%% @copyright (C) 2012, Magnus
%%% @doc
%%%
%%% @end
%%% Created : 8 Oct 2012 by Ingimar <ingimar@student.gu.se>
%%%-------------------------------------------------------------------
-module(ernews_defuns).
-compile(export_all).


%% <function author="Magnus & Ingimar">
%% read_web: Attempts to fetch and read a document from an URL

%% Reading document was a success
%% Return Header and Body tuple with success Atom
read_web({ok, {{_Version, _, _ReasonPhrase}, Headers, Body}}) ->
	{success,{Headers,Body}};
	
%% read_web/2 - next 5 functions:
%% Reading document returns errors
%% Return tuple with error Atom and associated reason Atom
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




	
%% For anything else - return unkown_error
read_web(Reason) ->
	{error,Reason}.

%% Default reader
read_web(default,Src) ->
    ssl:start(),
    inets:start(),
    read_web(httpc:request(Src));
	
%% Reader for coder.io
read_web(iocoder,Src) ->
    ssl:start(),
    inets:start(),
    read_web(httpc:request(get, {Src, []}, [{autoredirect, false}], [])).
%% </function>

% <function author="Khashayar">
% Converts pubDate from RSS document to Erlang date
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
%% </function>

get_description(List, iocoder) ->
    coder_description(List,[] , false);
get_description(List, google) ->
    Desc = google_description(List,[] , 0),
    %io:format("DESC : ~s~n", [Desc]),
    google_tag_remover(Desc, [] , true).

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
	

%% <function author="Ingimar & Muhanad">

get_single_tag(W,[H|T]) ->
	Word = string:to_lower(W),
	Html = string:to_lower(H),
	case Word == string:left(Html,length(Word)) of
		true ->
			[Word];
		false ->
			get_single_tag(W,T)
	end;
	
get_single_tag(_W,[]) ->
	[].

	
get_tags(List) ->
	get_tags(readlines("include/words_tags.txt"),List).
	
get_tags([H|T],List) ->
	get_single_tag(H,List) ++ get_tags(T,List);
	
get_tags([],_List) ->
	[].
	
	
test_rel() ->
	Html = "erlang jobs available, processing jobs",
	is_relevant(Html,
			readlines("include/words_bad.txt"),
			readlines("include/words_good.txt"),
			readlines("include/words_tags.txt")).
	
	
is_relevant(List,Bad,Good,Tags) ->
	Html = split_text(List),
	is_relevant(
		list_word_occur(Html,Good),
		list_word_occur(Html,Bad),
		{Html,Tags}
		).
	
is_relevant(0,_,_) ->
	{error,not_relevant};
is_relevant(_,0,{Html,Tags}) ->
	{ok,get_tags(Tags,Html)};
is_relevant(_,_,_) ->
	{error,bad_language}.
	
	
word_counter(W,[H|T],Counter) ->
	Word = string:to_lower(W),
	Html = string:to_lower(H),
	case Word == Html of
		true ->
			word_counter(Word,T,Counter+1);
		false ->
			word_counter(Word,T,Counter)
	end;
	
word_counter(_Word,[],Counter) ->
	Counter.
			
	
list_word_occur(L1,L2) ->
	list_word_occur(L1,L2,0).
list_word_occur([],_List,Counter) ->
	Counter;
list_word_occur([H|T],List,Counter) ->
	list_word_occur(T,List,Counter + word_counter(H,List,0)).
	
	
readlines(Src) ->
    {ok, Device} = file:open(Src, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

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

	
read_words() ->
	{readlines("include/words_good.txt"),
		readlines("include/words_bad.txt"),
		readlines("include/words_tags.txt")}.
	
%% </function>
	
