%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%%-------------------------------------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-module(ernews_html).
-compile(export_all).
-record(state, {url="", source="", ts=""}).

%% Writting the sources required for this module
start(Record) ->
%% Sending sources to the init()
    
    spawn(?MODULE, init, [Record]).
   

start_link(Url,Source,Ts) ->
    %%io:format("~s  ~p ~p ~n", [Url,Source,Ts]),
    spawn_link(?MODULE, init, [Url,Source,Ts]).

%% Init assining the sources to the records received by the loop function
init(Url,Source,Ts) ->
    end_url(#state{url=Url, source=Source, ts=Ts}),
		      ok.
    


%% parse receives the sources and messages 
end_url(Record= #state{}) ->
   case NewURL = ernews_htmlfuns:end_url(Record#state.source, Record#state.url) of
       {error, Reason} ->
	   gen_server:cast(ernews_linkerv,{error, Reason, Record#state.url, Record#state.ts});
       _ ->
	   check_duplicate(NewURL)
	       
   end.

check_duplicate(NewURL) ->  
   case CHECK_DUPLICATE = html:check_duplicate(NewURL) of
       url_exists ->
	   gen_server:cast(ernews_linkserv, {CHECK_DUPLICATE});
       _ ->
	   read_url(NewURL)
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
