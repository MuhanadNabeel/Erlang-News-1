%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(ernews_html).
-compile(export_all).
-record(state, {url="", source="", ts=""}).

%% Writting the sources required for this module
start(Record) ->
%% Sending sources to the init() 
    spawn(?MODULE, init, [Record]).
   
%% Init assining the sources to the records received by the loop function
init(Record) ->
    end_url(Record),
		      ok.
    


%% parse receives the sources and messages 
end_url(Record) ->
   case NewURL = html:end_url(Record#state.url) of
       bad_url ->
	   gen_server:cast(ernews_linkerv,{NewURL});
       _ ->
	   check_duplicate(Record)
   end.

check_duplicate(Record) ->  
   case CHECK_DUPLICATE = html:check_duplicate(Record#state.url) of
       url_exists ->
	   gen_server:cast(ernews_linkserv, {CHECK_DUPLICATE});
       _ ->
	   read_url(Record)
   end.
	         
    
read_url(Record) ->
   case READING_URL = html:read_url(Record#state.url) of
       bad_reading ->
	   gen_server:cast(ernews_linkserv, {READING_URL});

       _ ->
	   relevence(Record)
   end.

relevence(Record) ->
    case RELEVENCE = html:relevence(Record#state.url) of
	bad_relevence ->
	    gen_server:cast(ernews_linkserv, {RELEVENCE});

	_ ->
	    write_to_db(Record)
   end.

write_to_db(Record) ->	      
    case WRITE_DB = html:write_to_db(Record#state.url) of
	bad_reading ->
	    gen_server:cast(ernews_linkserv, {WRITE_DB});
	    
	_ ->
	    gen_server:cast(ernews_linkserv, {submit, Record#state.source, Record#state.ts})

   end.
   
            

            
            

   

						     
    
    
