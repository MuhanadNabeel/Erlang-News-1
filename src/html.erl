-module(html).
-compile(export_all).
-record(state, {url="", ref="", resource="", ts="", tags=""}).

%% Writting the sources required for this module
start(URL, Ref, Source, Ts, Tags) ->
%% Sending sources to the init() 
    spawn(?MODULE, init, [URL, Ref, Source, Ts, Tags]).
   
%% Init assining the sources to the records received by the loop function
init(URL, Ref, Source, Ts, Tags) ->
    loop(#state{url=URL, ref=Ref, resource=Resource, ts=Ts, tags=Tags}).



%% loop receives the sources and messages 
loop(#state{}) ->
    receive
	_ ->
	    ok
    after 0 ->
	    %end url must be here!
	    %checking if the URL exists
	    check_duplicate(_message) ->
		    ok.
            %% divide to html tags
            %% get meta data
            %% write to db

           write_to_db(URL, Description, Title, Image, Icon) ->
           %% send message to the CHECKER!

	    ok
    end.


%% Find the end url

end_url(URL, Description, Title, Image, Icon) ->
    ok.


%% checking if the URL exists in the database
check_duplicate(News, URL) ->
    
    case db:exist{News, URL} of
         true -> 'blabla';
	    %% do something
       
         false -> 'bla'
	    %% return error
    end.
%% fetching the html source 

fetch_html_source(URL, Description, Title, Image, Icon) ->
    ok.

%% Dividing the URL into tags

divide_to_tags(_Sources) ->	
    ok.
    		 

%% Getting the meta data

get_meta_data(_Data) ->
    ok.



%% passing the sources to the database  
write_to_db(URL, Description, Title, Image, Icon) ->
    db:write(news, {URL, Description, Title, Image, Icon}) ->
	ok.					     
    
    
