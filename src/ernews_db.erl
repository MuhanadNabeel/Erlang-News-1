%% Interface written by Jóel "Captain Awesome" Hjaltason, 

-module(ernews_db).
-compile(export_all).


connect() ->
    mysql:start(p1, "db.student.chalmers.se", 
				3306, "abdoli", "kgcH8v7c", "abdoli").


%% News-table should also have date and default votes, rank and visits
write(news, {Source, Url, Title, Description , Icon , 
			Image , PubDate, Tags}) ->
    Now = calendar:local_time(),
    Query =  "insert into abdoli.ernews_news " ++
	"(Source, Url, Title, Description, Icon, "++
	"Image, PubDate, TimeStamp, LastClicked) Values('"
	++ qFix(Source) ++ "', '" ++ qFix(Url) ++ "', '" 
	++ remove_html_tags(qFix(Title)) ++ "', '" 
	++  remove_html_tags(qFix(Description)) ++ "', '" 
	++ qFix(Icon) ++ "', '" ++ qFix(Image) ++ "', '"
	++ qFix(PubDate) ++ "', '" ++ qFix(Now) ++ "', '"
	++ qFix(Now) ++ "')", 
    case qFunc(write,Query) of
	{error,Reason} ->
	    {error,Reason};
	{ok, updated} ->
	    ID=qFunc(get, "Select newsID FROM ernews_news WHERE URL='" ++ 
						qFix(Url) ++ "'"),
	    write(tag, Tags, integer_to_list(ID))
    end;
			
	
%% Broken-news-table should also have default date
write(broken,{URL, Reason, Source}) ->
    qFunc(write, 
	  "INSERT INTO abdoli.ernews_broken(URL, Reason, Source) 
	  VALUES('" 
	  ++ qFix(URL) ++ "','" ++ qFix(Reason) ++ "','" 
	  ++ qFix(Source) ++ "')");
	
write(time,{Source, URL, Time_stamp}) ->
    qFunc(write, 
	  "INSERT INTO abdoli.ernews_time(Source, URL, Time_stamp) VALUES('" 
	  ++ qFix(Source) ++ "','" ++ qFix(URL) ++ "','" 
	  ++ qFix(Time_stamp) ++ "')").
				
write(tag, [],_ID) ->
	{ok, updated};
	
write(tag, [H|T], ID) ->
    qFunc(write, "INSERT INTO abdoli.ernews_articletags(newsID, tagID) VALUES(" 
	      ++ ID ++ ", (SELECT id FROM ernews_tag WHERE tag = '" ++ H ++ "'))"),
    write(tag, T, ID).
	
	
qFix(A) when is_atom(A) ->
    qFix(atom_to_list(A),[]);
	
qFix({{YY,MM,DD},{HH,Mm,SS}}) ->
    integer_to_list(YY) ++ "-" ++
        integer_to_list(MM) ++ "-" ++
	integer_to_list(DD) ++ " " ++
	integer_to_list(HH) ++ ":" ++
	integer_to_list(Mm) ++ ":" ++
	integer_to_list(SS);
qFix(A) when is_tuple(A) ->
    qFix(lists:concat(tuple_to_list(A)), []);
qFix(Str) ->
    qFix(Str, []).	

qFix([], Buff) ->
    Buff;
	
qFix([39|T], Buff) ->
    qFix(T, Buff ++ [92, 39]);
	
qFix([38,35,51,57,59|T], Buff) ->
    qFix(T, Buff ++ [92, 39]);
	
qFix([34|T], Buff) ->
    qFix(T, Buff ++ [92, 34]);
	
qFix([H|T], Buff) when is_list(H)->
    qFix(T, Buff ++ qFix(H,[]));
	
qFix([H|T], Buff) ->
    qFix(T, Buff ++ [H]).
	
	
qFunc(write, Q) ->
    try mysql:fetch(p1, Q) of 
	Result ->
	    {R,{_,_,_,_,_,_,_,_}} = Result,
	    case R of 
		updated -> 
		    {ok, updated};
		error -> 
		    io:format("SQL SYNTAX ERROR :~n~s~n-----------~n",[Q]),
		    {error, sql_syntax};
		_ -> 
		    {error, R}
	    end
    catch 
	exit:_Exit -> 
	    %{Res, _} = Exit,
	    {error, no_connection}
    end;
	%io:format("~s~n", [Tag]);

qFunc(exists, Q) ->	
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
	
qFunc(get, Q) ->
%    {_,{_,_,[[Result]],_,_,_,_,_}} = mysql:fetch(p1, Q),
%    Result;
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
	
qFunc(getList, Q) ->
%    {_,{_,_,Result,_,_,_,_,_}} = mysql:fetch(p1, Q),
%    Result.
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
		
		
%% Does URL exist in news table
exists(Table,{Column, Keyword}) ->
    Query = "SELECT COUNT(*) FROM abdoli.ernews_" ++ qFix(Table) 
	++ " WHERE " ++ qFix(Column) ++ "='" ++ qFix(Keyword) ++ "'",
    L=qFunc(exists, Query),
    L.
	
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
	case List = qFunc(getList, Q) of
		[H|T] = List ->
			sendList(List, []);
		H = List ->
			H;	
		_ ->
			else
	end,		
	sendList(List, []).

%% Return all tags/relevant/irrelevant from DB
sendList([H|T], NL) ->
	[P] = H,
	NL ++ [bitstring_to_list(P)] ++ sendList(T, NL);
	
sendList([], NL) ->
	[].
	

%% Removes tags from string - except <a></a>	
remove_tags(List) ->
	remove_tags(List,false,[]).
remove_tags([60,97,32,104,114,101,102,61,34,104,116,116,112,58,47,47|T], _, Buffer) ->
	remove_tags(T, false, Buffer ++ [60,97,32,104,114,101,102,61,34,104,116,116,112,58,47,47]);	
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

	
	
tester() ->
	write(news, {"testSource", "testUrl", "testTitle", "<html>WARNING: This program is
	rated<a href=\"http://en.wikipedia.org/wiki/Not_safe_for_work\">NSFW</a>. It conta
	ins stronglanguage and BDSM themes. Very dark. It is intended only for matureaud
	iences. Viewer discretion advised. Seriously, itâ?Ts fucked up.</html>" , "testIcon" , 
			"testImage" , "2012-03-31 15:18:44", ["Riak"]}).
