-module(html).
-compile(export_all).
-record(state, {url="", ref="", resource="", ts="", tags=""}).

%% Writting the sources required for this module
start(_URL, _Ref, _Source, _Ts, _Tags) ->
%% Sending sources to the init() 
    spawn(?MODULE, init, [_URL, _Ref, _Source, _Ts, _Tags]).
   
%% Init assining the sources to the records received by the loop function
init(_URL, _Ref, _Source, _Ts, _Tags) ->
   %% loop(#state{url=URL, ref=Ref, resource=Resource, ts=Ts, tags=Tags}) ->
					      ok.



%% loop receives the sources and messages 
loop(#state{}) ->
   ok.
   %% receive
   %%	_ ->
	   
   %%  after 0 ->
	    %end url must be here!
	    %checking if the URL exists
	    %%check_duplicate(_message) ->
		    
            %% divide to html tags
            %% get meta data
            %% write to db

            %%write_to_db(_URL, _Description, _Title, _Image, _Icon) ->
            %% send message to the CHECKER!

	    
   %% end.


%% Find the end url

end_url(_URL, _Description, _Title, _Image, _Icon) ->
    ok.


%% checking if the URL exists in the database
check_duplicate(_News, _URL) ->
       ok.  
   %% case db:exist{_News, _URL} of
   %%      true -> 'blabla';
	    %% do something
       
   %%       false -> 'bla'
	    %% return error
   %%  end.
%% fetching the html source 

fetch_html_source(_URL, _Description, _Title, _Image, _Icon) ->
    ok.

%% Dividing the URL into tags

divide_to_tags(_Sources) ->	
    ok.
    		 

%% Getting the meta data

get_meta_data(_Data) ->
    ok.



%% passing the sources to the database  
write_to_db(_URL, _Description, _Title, _Image, _Icon) ->
    ok.
 %% db:write(news, {_URL, _Description, _Title, _Image, _Icon}) ->
						     
    
    
