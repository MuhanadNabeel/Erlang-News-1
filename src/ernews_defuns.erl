-module(ernews_defuns).
-compile(export_all).


% read_web Authors: Magnus and Ingimar
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
read_web(_) ->
	{error,unkown_error}.

read_web(default,Src) ->
	inets:start(),
	read_web(httpc:request(Src));
	
read_web(iocoder,Src) ->
	inets:start(),
	read_web(httpc:request(get, {Src, []}, [{autoredirect, false}], [])).
	
compare_dates(Date1,Date2) ->
	calendar:datetime_to_gregorian_seconds(convert_pubDate_to_datetime(Date2))
	-
	calendar:datetime_to_gregorian_seconds(Date1).
	
% Author:  Khashayar Two
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
