%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason <joelhjalta@gmail.com>
%%% @copyright (C) 2012, Jablé
%%% @doc
%%%	This module handles communication with the database.
%%% It meets the requirements with id BE-FREQ8 and BE-FREQ9.
%%% @end
%%% Created : 8 Oct 2012 by author
%%%-------------------------------------------------------------------

-module(ernews_db).
-compile(export_all).

%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	Cleans up the data using quote_fixer and remove_tags 
%%% before sending it to query_function to be written to the database. 
%%% The first parameter is a tag that determines which table to write to.
%%% @end

write(news, {Source, Url, Title, Description , Icon , 
			Image , PubDate, Tags}) ->
    Now = calendar:local_time(),
    Query =  "insert into abdoli.ernews_news " ++
	"(Source, Url, Title, Description, Icon, "++
	"Image, PubDate, TimeStamp, LastClicked) Values('"
	++ quote_fixer(Source) ++ "', '" ++ quote_fixer(Url) ++ "', '" 
	++ remove_tags(quote_fixer(Title)) ++ "', '" 
	++  remove_tags(quote_fixer(Description)) ++ "', '" 
	++ quote_fixer(Icon) ++ "', '" ++ quote_fixer(Image) ++ "', '"
	++ quote_fixer(PubDate) ++ "', '" ++ quote_fixer(Now) ++ "', '"
	++ quote_fixer(Now) ++ "') on duplicate key update PubDate = '" 
	++ quote_fixer(PubDate) ++ "'",
    query_function(write,Query);
			
write(broken,{URL, Reason, Source}) ->
    query_function(write, 
	  "INSERT INTO abdoli.ernews_broken(URL, Reason, Source) 
	  VALUES('" 
	  ++ quote_fixer(URL) ++ "','" ++ quote_fixer(Reason) ++ "','" 
	  ++ quote_fixer(Source) ++ "')");
	
write(time,{Source, URL, Time_stamp}) ->
    query_function(write, 
	  "INSERT INTO abdoli.ernews_time(Source, URL, Time_stamp) VALUES('" 
	  ++ quote_fixer(Source) ++ "','" ++ quote_fixer(URL) ++ "','" 
	  ++ quote_fixer(Time_stamp) ++ "')").
				
write(tag, [],_ID) ->
	{ok, updated};
	
write(tag, [H|T], ID) ->
    query_function(write, "INSERT INTO abdoli.ernews_articletags(newsID, tagID) VALUES(" 
	      ++ ID ++ ", (SELECT id FROM ernews_tag WHERE tag = '" ++ H ++ "'))"),
    write(tag, T, ID).
%%%-------------------------------------------------------------------	
	
	
%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	Fixes the quotation marks in a given text so as to not get a sql error
%%% @end
	
quote_fixer(A) when is_atom(A) ->
    quote_fixer(atom_to_list(A),[]);
	
quote_fixer({{YY,MM,DD},{HH,Mm,SS}}) ->
    integer_to_list(YY) ++ "-" ++
        integer_to_list(MM) ++ "-" ++
	integer_to_list(DD) ++ " " ++
	integer_to_list(HH) ++ ":" ++
	integer_to_list(Mm) ++ ":" ++
	integer_to_list(SS);
	
quote_fixer(A) when is_tuple(A) ->
    quote_fixer(lists:concat(tuple_to_list(A)), []);
	
quote_fixer(Str) ->
    quote_fixer(Str, []).	

quote_fixer([], Buff) ->
    Buff;
	
quote_fixer([39|T], Buff) ->
    quote_fixer(T, Buff ++ [92, 39]);
	
quote_fixer([38,35,51,57,59|T], Buff) ->
    quote_fixer(T, Buff ++ [92, 39]);
	
quote_fixer([34|T], Buff) ->
    quote_fixer(T, Buff ++ [92, 34]);
	
quote_fixer([H|T], Buff) when is_list(H)->
    quote_fixer(T, Buff ++ quote_fixer(H,[]));
	
quote_fixer([H|T], Buff) ->
    quote_fixer(T, Buff ++ [H]).
%%%-------------------------------------------------------------------	
	
	
%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	A function that executes the database queries and handles the errors
%%% @end	

query_function(write, Q) ->
    try mysql:fetch(p1, Q) of 
	Result ->
	    {R,{_,_,_,_,_,_,_,_}} = Result,
	    case R of 
		updated -> 
		    {ok, updated};
		error -> 
		    {error, sql_syntax};
		_ -> 
		    {error, R}
	    end
    catch 
	exit:_Exit -> 
	    {error, no_connection}
    end;

query_function(exists, Q) ->	
	try mysql:fetch(p1, Q) of 
		Result ->
			case mysql:fetch(p1, Q) of 
				{_,{_,_,[[R]],_,_,_,_,_}} = Result ->
					case R>0 of
						false ->
							false;
						true ->
							true
					end;		
				{R,{_,_,_,_,_,_,_,_}} = Result ->
					R
			end
	catch 
	exit:_Exit -> 
		%{Res, _} = Exit,
		{error, no_database_connection}
	end;
	
query_function(get, Q) ->
	try mysql:fetch(p1, Q) of 
		Result ->
			case mysql:fetch(p1, Q) of 
				{_,{_,_,[[R]],_,_,_,_,_}} = Result ->
					R;		
				{R,{_,_,_,_,_,_,_,_}} = Result ->
					R
			end
	catch 
	exit:_Exit -> 
		%{Res, _} = Exit,
		{error, no_connection}
	end;
	
query_function(getList, Q) ->
	try mysql:fetch(p1, Q) of 
		Result ->
			case mysql:fetch(p1, Q) of 		
				{data,{_,_,P,_,_,_,_,_}} = Result ->
					P;
				_ ->
				{error, else}
				
			end
	catch 
	exit:_Exit -> 
		%{Res, _} = Exit,
		{error, no_connection}
	end.
%%%-------------------------------------------------------------------		
	

%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	Some detailed sens about the fml function
%%% @end	
%% Does URL exist in news table
exists(Table,{Column, Keyword}) ->
    Query = "SELECT COUNT(*) FROM abdoli.ernews_" ++ quote_fixer(Table) 
	++ " WHERE " ++ quote_fixer(Column) ++ "='" ++ quote_fixer(Keyword) ++ "'",
    L=query_function(exists, Query),
    L.
%%%-------------------------------------------------------------------
	

%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	Some detailed sens about the fml function
%%% @end		
%% Fetch all tags in the DB
getList(tag) ->
	getList("SELECT tag FROM ernews_tag");
	
%% Fetch all relevant words
getList(relevant) ->
	getList("SELECT word FROM ernews_relevant");
	
%% Fetch all irrelevant words
getList(irrelevant) ->
	getList("SELECT word FROM ernews_irrelevant");	
	
getList(Q) ->
	case List = query_function(getList, Q) of
		[H|T] = List ->
			sendList(List, []);
		H = List ->
			H;	
		_ ->
			else
	end,		
	sendList(List, []).
%%%-------------------------------------------------------------------	

%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%% Return all tags/relevant/irrelevant from DB
%%% @end		

sendList([H|T], NL) ->
	[P] = H,
	NL ++ [bitstring_to_list(P)] ++ sendList(T, NL);
	
sendList([], NL) ->
	[].
%%%-------------------------------------------------------------------	

%%%-------------------------------------------------------------------
%%% @author Jóel Hjaltason
%%% @doc
%%%	Some detailed sens about the fml function
%%% @end		
%% Removes tags from string - except <a></a>	
remove_tags(List) ->
	remove_tags(List,false,[]).
remove_tags(
	[60,97,32,104,114,101,102,61,34,104,116,116,112,58,47,47|T], _, Buffer) ->
		remove_tags(T, false, Buffer ++ 
		[60,97,32,104,114,101,102,61,34,104,116,116,112,58,47,47]);	
remove_tags([60, 47, 97, 62|T],_,List) ->
	remove_tags(T,false,List ++ [60, 47, 97, 62]);
remove_tags([60|T],_,List) ->
	remove_tags(T,true,List);	
remove_tags([62|T],_,List) ->
	remove_tags(T,false,List);
remove_tags([H|T],false,List) ->
	remove_tags(T,false,List++[H]);
remove_tags([_|T],true,List) ->
	remove_tags(T,true,List);
remove_tags([],_,List) ->
	List.		
%%%-------------------------------------------------------------------