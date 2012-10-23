%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%%-------------------------------------------------------------------
-module(ernews_html).

-behaviour(gen_fsm).

%% API
-export([start_link/3]).

%% gen_fsm callbacks
-export([init/1, duplicate/2 , write_to_db/2, read_url/2, end_url/2, handle_event/3,
	 handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(SERVER, ?MODULE).

-record(state, {url="", source="", ts=""}).

%%%===================================================================
%%% API
%%%===================================================================


start_link(Url,Source,Ts) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================


init([Url, Source, Ts]) ->
    State = #state{url=Url, source=Source, ts=Ts},
    gen_fsm:send_event(self(), end_url),
    {ok, end_url, State}.


%------------------------------------------------------------------------

end_url(end_url, Record=#state{}) ->
    case NewUrl = ernews_htmlfuns:end_url(
		    Record#state.source, Record#state.url) of
	{error, Reason} ->
	    %gen_server:cast(ernews_linkerv,
	%		    {error, Reason, Record#state.url, Record#state.ts}),
	    {stop, {error, 
		    atom_to_list(Reason), Record#state.url, Record#state.source},
	     Record};
       _ ->
%	    io:format("END URL FINDING = ~p ~n", [NewUrl]), 
	   % check_duplicate(Record#state{url = NewUrl})
	    gen_fsm:send_event(self(), duplicate),
	    {next_state, duplicate, Record#state{url = NewUrl}}
    end.




%------------------------------------------------------------------------

duplicate(duplicate, Record=#state{}) ->
    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
	true ->
	    {stop, {error, "already_exists", 
		    Record#state.url, Record#state.source}, 
	     Record};
	false ->
	    gen_fsm:send_event(self(), read_url),
	    {next_state, read_url, Record}
	%    read_url(Record)
   end.


%------------------------------------------------------------------------
read_url(read_url, Record=#state{}) ->
    Title_Tuple = ernews_htmlfuns:get_title(Record#state.url),
    Description_Tuple = ernews_htmlfuns:get_description(Record#state.url),
    case {Title_Tuple, Description_Tuple} of
	{{ok,Title}, {ok,Description}} ->
	    gen_fsm:send_event(self() , {write, Title, Description}),
	    {next_state, write_to_db, Record};
	{{error,Reason_Title} , {error, Reason_Desc}} ->
	    {stop, {error,
		    atom_to_list(Reason_Title) ++ atom_to_list(Reason_Desc), 
		    Record#state.url,Record#state.source} , 
	     Record};
	{{error,Reason} , _} ->
	    {stop, {error,
		    atom_to_list(Reason), Record#state.url,Record#state.source},
	     Record};
	{_ , {error,Reason}} ->
	    {stop, {error,
		    atom_to_list(Reason), Record#state.url,Record#state.source},
	     Record}
    end.

%------------------------------------------------------------------------
write_to_db({write, Title, Description} , Record= #state{}) ->	      
    case ernews_db:write(news,{Record#state.url, 
				     Description, Title , 
				     erlang:atom_to_list(Record#state.source),
				     " "}) of
	bad_reading ->
	    {stop, {error,{error, bad_db}} , Record};
	_ ->
	    {stop, {submit, 
		    {submit, Record#state.source, Record#state.ts}}, 
	     Record}
    end.
 
%------------------------------------------------------------------------

state_name(_Event, _From, State) ->
    Reply = ok,
    {reply, Reply, state_name, State}.

%------------------------------------------------------------------------

handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%------------------------------------------------------------------------

handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%------------------------------------------------------------------------

handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%------------------------------------------------------------------------

terminate({error,Reason ,URL, Source}, _StateName , _State) ->
    io:format("========================================================~n", []),
    io:format(" STATE CRASHING IN ~p : ERRORR URL ~p , Reason ~p , Source ~p ~n" , [_StateName, URL,Reason,Source]),
    io:format("========================================================~n", []),
    ernews_db:write(broken, {URL, Reason, Source});
    
terminate({submit, Message}, _StateName, _State) ->
    io:format("========================================================~n", []),
    io:format("Submited -- ~p~n", [Message]),
    io:format("========================================================~n", []), 
    ok;
terminate(Reason , _ , _ ) ->
    io:format("========================================================~n", []),
    io:format("UNKNOWN --  ~p~n", [Reason]),
    io:format("========================================================~n", []), 
    ok.

%------------------------------------------------------------------------

code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.



    
