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
start(Url,Source,Ts) ->
%% Sending sources to the init()
    spawn(?MODULE, init, [Url,Source,Ts]).

   

start_link(Url,Source,Ts) ->
    %%io:format("~s  ~p ~p ~n", [Url,Source,Ts]),
    spawn_link(?MODULE, init, [Url,Source,Ts]).

%% Init assining the sources to the records received by the loop function
init(Url,Source,Ts) ->
    end_url(#state{url=Url, source=Source, ts=Ts}),
		      ok.
    


%% parse receives the sources and messages 
end_url(Record= #state{}) ->
    case NewUrl = ernews_htmlfuns:end_url(
		    Record#state.source, Record#state.url) of
	{error, Reason} ->
	    gen_server:cast(ernews_linkerv,
			    {error, Reason, Record#state.url, Record#state.ts});
       _ ->
%	    io:format("END URL FINDING = ~p ~n", [NewUrl]), 
	    check_duplicate(Record#state{url = NewUrl})
	       
   end.

check_duplicate(Record= #state{}) ->
%    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
%       false ->
%	   gen_server:cast(ernews_linkserv, 
%			   {error, duplicate, Record#state.url, 
%			    Record#state.ts});
%      true ->
	   read_url(Record).
%   end.
	         
    
read_url(Record= #state{}) ->
    Title = ernews_htmlfuns:get_title(Record#state.url),
    Description = ernews_htmlfuns:get_description(Record#state.url),
    case {Title,Description} of
	{null,null} ->
	    gen_server:cast(ernews_linkserv, 
			    {error,no_title_description,
			     Record#state.url,Record#state.ts});
	{null,_} ->
	    gen_server:cast(ernews_linkserv, 
			    {error,no_title,Record#state.url,Record#state.ts});
	{_,null} ->
	    gen_server:cast(ernews_linkserv, 
			   {error,no_description,Record#state.url,Record#state.ts});
	{{error,_},{error,_}} ->
	    gen_server:cast(ernews_linkserv, 
			    {error,no_title_description,
			     Record#state.url,Record#state.ts});	
    	{{error,_},_} ->
	    gen_server:cast(ernews_linkserv, 
			    {error,no_description,
			     Record#state.url,Record#state.ts});	
    	{_,{error,_}} ->
	    gen_server:cast(ernews_linkserv, 
			    {error,no_title,
			     Record#state.url,Record#state.ts});	    

	  {_,_} ->
	    write_to_db(Record,Title,Description)
   end.

%relevence(Record) ->
%    case RELEVENCE = html:relevence(Record#state.url) of
%	bad_relevence ->
%	    gen_server:cast(ernews_linkserv, {RELEVENCE});
%
%	_ ->
%	    write_to_db(Record)
%   end.

write_to_db(Record= #state{} , Description, Title) ->	      
    io:format("In WRITE TO DB ~n", []),
    case WRITE_DB = ernews_db:write(news,
				    {Record#state.url, 
				     Description, Title , " " , " "}) of
	bad_reading ->
	    gen_server:cast(ernews_linkserv, {WRITE_DB});
	    
	_ ->
	    gen_server:cast(ernews_linkserv, {submit, Record#state.source, Record#state.ts})

    end,
    io:format("HOOOOOOORAYYYYYYYYY ~n", []).
    
