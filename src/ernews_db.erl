%% Interface written by Ingimar Samuelsson, Lantbruksgatan 20	

-module(db).
-compile(export_all).

%% News-table should also have date and default votes, rank and visits
write(news,{URL,Description,Title,Image,Icon}) ->
	ok;
	
%% Broken-news-table should also have default date
write(broken,{URL,Reason}) ->
	ok;
	
%% Add new tag to Tag-table
write(tag,Tag_name) ->
	ok;
	
%% Subscripe table
write(subscribe,Email) ->
	ok;
	
%% Add News-ID to News-Tag-table
write(assign_tag,{News_ID,Tag_ID}) ->
	ok.
	
%% Get News-link Table-ID
get(news_id,URL) ->
	ok;
	
%% Get news order by rank
get(news_ranked,{Limit,Offset}) ->
	ok;
	
%% Get news order by date
get(news_dated,{Limit,Offset}) ->
	ok;
	
%% Get news order by visits
get(news_visits,{Limit,Offset}) ->
	ok;
	
%% Get news - 1 item
get(news_single,News_id) ->
	ok;
	
%% Get broken-link Table ID
get(broken_id,URL) ->
	ok;
	
%% Get broken news order by dates
get(broken,{Limit,Offset}) ->
	ok;
	
%% Get broken news - 1 item
get(broken_single,Broken_id) ->
	ok.
	
%% Does URL exist in news table
exists(news,URL) ->
	ok;
	
%% Does URL exist in broken table
exists(broken,URL) ->
	ok.
	
%% Delete subscribe
delete(subscribe,Subscribe_id) ->
	ok;
	
%% Delete from news table
delete(news,News_id) ->
	ok;
	
%% Delete from broken table
delete(broken,News_id) ->
	ok.
	
%% Update news info
update(news,News_id,{URL,Description,Title,Image,Icon}) ->
	ok.

	

	
