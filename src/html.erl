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
    after T ->
	    ok
    end.

%% checking if the URL exists in the database
check_duplicate(News, URL) ->
    
    case db:exist{News, URL} of
         true -> 'blabla';
	    %% do something
       
         false -> 'bla'
	    %% return erro
    end.


	
    		       

    
    
