%% Interface written by Ingimar Samuelsson, Lantbruksgatan 20	

-module(ernews_db).
-compile(export_all).


%% News-table should also have date and default votes, rank and visits
write(news,{URL,Description,Title,Image,Icon}) ->			
    qFunc(write,
	  "INSERT INTO abdoli.ernews_news(URL, Title, Description, Image, Icon) VALUES('" 
	  ++ URL ++ "', '" ++ Title ++ "', '" 
	  ++ Description ++ "', '" ++ Image ++ "', '" 
	  ++ Icon ++ "')");

%% Broken-news-table should also have default date
write(broken,{URL,_Reason}) ->
    qFunc(write, 
	  "INSERT INTO abdoli.ernews_broken(URL) VALUES('" ++ URL ++ "')");
	
write(time,{Source, URL, Time_stamp}) ->
    qFunc(write, 
	  "INSERT INTO abdoli.ernews_Time(Source, URL, Time_stamp) VALUES('" 
	  ++ Source ++ "','" ++ URL ++ "','" ++ Time_stamp ++ "')").
				 
%% Add new tag to Tag-table
%%write(tag,_Tag_name) ->
%%	ok;
	
%% Add News-ID to News-Tag-table
%%write(assign_tag,{_News_ID,_Tag_ID}) ->
%%	ok.
	
qFunc(get, Q) ->
    mysql:start_link(p1, "db.student.chalmers.se", 
		     3306, "abdoli", "kgcH8v7c", "abdoli"),
	{_,{_,_,Result,_,_,_,_,_}} = mysql:fetch(p1, Q),
	Result;
	
qFunc(write, Q) ->
    mysql:start_link(p1, 
		     "db.student.chalmers.se", 3306, 
		     "abdoli", "kgcH8v7c", "abdoli"),
    mysql:fetch(p1, Q);

qFunc(exists, Q) ->	
    mysql:start_link(p1, "db.student.chalmers.se", 
		     3306, "abdoli", "kgcH8v7c", "abdoli"),
	{_,{_,_,R,_,_,_,_,_}} = mysql:fetch(p1, Q),
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
    Query = "SELECT * FROM abdoli.ernews_" ++ Table 
	++ " WHERE " ++ Column ++ "='" ++ Keyword ++ "'",
    io:format("QUERYYYY ~s~n" ,[Query]), 
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
