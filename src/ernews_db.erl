%% Interface written by Jóel "Captain Awesome" Hjaltason, 

-module(ernews_db).
-compile(export_all).


connect() ->
    mysql:start(p1, "db.student.chalmers.se", 3306, "abdoli", "kgcH8v7c", "abdoli").
	 
	 
%% News-table should also have date and default votes, rank and visits
write(news, {Source, Url, Title, Description , Icon , Image , PubDate, Tags}) ->
    Now = calendar:local_time(),
    Query =  "insert into abdoli.ernews_news " ++
	"(Source, Url, Title, Description, Icon, "++
	"Image, PubDate, TimeStamp, LastClicked) Values('"
	++ qFix(Source) ++ "', '" ++ qFix(Url) ++ "', '" 
	++ qFix(Title) ++ "', '" ++  qFix(Description) ++ "', '" 
	++ qFix(Icon) ++ "', '" ++ qFix(Image) ++ "', '"
	++ qFix(PubDate) ++ "', '" ++ qFix(Now) ++ "', '"
	++ qFix(Now) ++ "')", 
    case qFunc(write,Query) of
	{error,Reason} ->
	    {error,Reason};
	{ok, updated} ->
	    ID=qFunc(get, "Select newsID FROM ernews_news WHERE URL='" ++ qFix(Url) ++ "'"),
	    write(tag, Tags, integer_to_list(hd(hd(ID))))
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
	
	
qFunc(get, Q) ->
    {_,{_,_,Result,_,_,_,_,_}} = mysql:fetch(p1, Q),
    Result;
	
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
		{error, no_connection}
	end.
		
		
%% Does URL exist in news table
exists(Table,{Column, Keyword}) ->
    Query = "SELECT COUNT(*) FROM abdoli.ernews_" ++ qFix(Table) 
	++ " WHERE " ++ qFix(Column) ++ "='" ++ qFix(Keyword) ++ "'",
    L=qFunc(exists, Query),
    L.

