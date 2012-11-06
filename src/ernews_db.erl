%% Interface written by Ingimar Samuelsson, Lantbruksgatan 20	

-module(ernews_db).
-compile(export_all).

connect() ->
    mysql:start(p1, "db.student.chalmers.se", 3306, 
		"abdoli", "kgcH8v7c", "abdoli").
	 
%% News-table should also have date and default votes, rank and visits
write(news, {Source, Url, Title, Description , Icon , Image , PubDate}) ->
    Now = calendar:local_time(),
    Query =  "insert into abdoli.ernews_news " ++
	"(Source, Url, Title, Description, Icon, "++
	"Image, PubDate, TimeStamp, LastClicked) Values('"
	++ qFix(Source) ++ "', '" ++ qFix(Url) ++ "', '" 
	++ qFix(Title) ++ "', '" ++  qFix(Description) ++ "', '" 
	++ qFix(Icon) ++ "', '" ++ qFix(Image) ++ "', '"
	++ qFix(PubDate) ++ "', '" ++ qFix(Now) ++ "', '"
	++ qFix(Now) ++ "')", 
    qFunc(write,Query);
	
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
				 
%% Add new tag to Tag-table
%%write(tag,_Tag_name) ->
%%	ok;
	
%% Add News-ID to News-Tag-table
%%write(assign_tag,{_News_ID,_Tag_ID}) ->
%%	ok.

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
		    else
	    end
    catch 
	exit:Exit -> 
	    %{Res, _} = Exit,
	    {error, no_connection}
    end;
	%io:format("~s~n", [Tag]);


qFunc(exists, Q) ->	
    {_,{_,_,R,_,_,_,_,_}} = mysql:fetch(p1,Q),
    R.

	
%% Get News-link Table-ID
get(NewsID) ->
    qFunc(get, "SELECT * FROM abdoli.ernews_news WHERE newsID=" ++ NewsID).	

%% General Get
get(Table, {Column, Keyword}) ->
    qFunc(get, 
	  "SELECT * FROM abdoli.ernews_" ++ Table 
	  ++ " WHERE " ++ Column ++ "=" ++ Keyword);	

%% Get news order by rank
get(news_ranked,{_Limit,_Offset}) ->
    ok;
	
%% Get news order by date
get(news_dated,{_Limit,_Offset}) ->
    ok;
	
%% Get news order by visits
get(news_visits,{_Limit,_Offset}) ->
    ok;
	
%% Get news - 1 item
get(news_single,_News_id) ->
    ok;
	
%% Get broken-link Table ID
get(broken_id,_URL) ->
    ok;
	
%% Get broken news order by dates
get(broken,{_Limit,_Offset}) ->
    ok;
	
%% Get broken news - 1 item
get(broken_single,_Broken_id) ->
    ok.
	
%% Does URL exist in news table
exists(Table,{Column, Keyword}) ->
    Query = "SELECT * FROM abdoli.ernews_" ++ qFix(Table) 
	++ " WHERE " ++ qFix(Column) ++ "='" ++ qFix(Keyword) ++ "'",
    L=length(qFunc(exists, Query)),
    L>0;
	
%% Does URL exist in broken table
exists(broken,_URL) ->
	ok.
	
%% Delete subscribe
delete(subscribe,_Subscribe_id) ->
	ok;
	
%% Delete from news table
delete(news,_News_id) ->
	ok;
	
%% Delete from broken table
delete(broken,_News_id) ->
	ok.
	
%% Update news info
update(news,_News_id,{_URL,_Description,_Title,_Image,_Icon}) ->
    ok.
