%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <Muhanad@dhcp-233-117.nomad.chalmers.se>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%
%%% @end
%%% Created : 22 Oct 2012 by Muhanad Nabeel <Muhanad@dhcp-233-117.nomad.chalmers.se>
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

%%--------------------------------------------------------------------
%% @doc
%% Creates a gen_fsm process which calls Module:init/1 to
%% initialize. To ensure a synchronized start-up procedure, this
%% function does not return until Module:init/1 has returned.
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link(Url,Source,Ts) ->
    gen_fsm:start(?MODULE, [Url,Source,Ts], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm is started using gen_fsm:start/[3,4] or
%% gen_fsm:start_link/[3,4], this function is called by the new
%% process to initialize.
%%
%% @spec init(Args) -> {ok, StateName, State} |
%%                     {ok, StateName, State, Timeout} |
%%                     ignore |
%%                     {stop, StopReason}
%% @end
%%--------------------------------------------------------------------
init([Url, Source, Ts]) ->
    State = #state{url=Url, source=Source, ts=Ts},
    gen_fsm:send_event(self(), end_url),
    {ok, end_url, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_event/2, the instance of this function with the same
%% name as the current state name StateName is called to handle
%% the event. It is also called if a timeout occurs.
%%
%% @spec state_name(Event, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
end_url(end_url, Record=#state{}) ->
    case NewUrl = ernews_htmlfuns:end_url(
		    Record#state.source, Record#state.url) of
	{error, Reason} ->
	    %gen_server:cast(ernews_linkerv,
	%		    {error, Reason, Record#state.url, Record#state.ts}),
	    {stop, {error,{error, Reason, Record#state.url, Record#state.ts}}, Record};
       _ ->
%	    io:format("END URL FINDING = ~p ~n", [NewUrl]), 
	   % check_duplicate(Record#state{url = NewUrl})
	    gen_fsm:send_event(self(), duplicate),
	    {next_state, duplicate, Record#state{url = NewUrl}}
    end.





duplicate(duplicate, Record=#state{}) ->
    case ernews_db:exists("news", {"URL" ,Record#state.url}) of
	true ->
	    %gen_server:cast(ernews_linkserv, 
	%		    {error, duplicate, Record#state.url, 
	%		     Record#state.ts});
	    {stop, {error,{error, already_exists}}, Record};
	false ->
	    gen_fsm:send_event(self(), read_url),
	    {next_state, read_url, Record}
	%    read_url(Record)
   end.


read_url(read_url, Record=#state{}) ->
    Title_Tuple = ernews_htmlfuns:get_title(Record#state.url),
    
    Description_Tuple = ernews_htmlfuns:get_description(Record#state.url),
    io:format("TITLE +++++++++++ = ~p ~n", [Title_Tuple]),
    io:format("DESCRPITION +++++++++++ = ~p ~n", [Description_Tuple]),  
    case {Title_Tuple, Description_Tuple} of
	{{ok,Title}, {ok,Description}} ->
	    gen_fsm:send_event(self() , {write, Title, Description}),
	    {next_state, write_to_db, Record};
	{{error,Reason_Title} , {error, Reason_Desc}} ->
	    {stop, {error,{error,{Reason_Title , Reason_Desc}, Record#state.url,Record#state.ts}} , Record};
	{{error,Reason} , _} ->
	    {stop, {error,{error,Reason, Record#state.url,Record#state.ts}} , Record};
	{_ , {error,Reason}} ->
	    {stop, {error,{error,Reason, Record#state.url,Record#state.ts}} , Record}
    end.

write_to_db({write, Title, Description} , Record= #state{}) ->	      
    io:format("In WRITEEEEEEEEEEEEEEEEEEEEEEEEEEE TO DB ~n", []),
    case WRITE_DB = ernews_db:write(news,
				    {Record#state.url, 
				     Description, Title , 
				     erlang:atom_to_list(Record#state.source),
				     " "}) of
	bad_reading ->
	    {stop, {error,{error, bad_db}} , Record};
	_ ->
	    {stop, {submit, {submit, Record#state.source, Record#state.ts}} , Record}
    end.
 
%%--------------------------------------------------------------------
%% @private
%% @doc
%% There should be one instance of this function for each possible
%% state name. Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_event/[2,3], the instance of this function with
%% the same name as the current state name StateName is called to
%% handle the event.
%%
%% @spec state_name(Event, From, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------
state_name(_Event, _From, State) ->
    Reply = ok,
    {reply, Reply, state_name, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:send_all_state_event/2, this function is called to handle
%% the event.
%%
%% @spec handle_event(Event, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
handle_event(_Event, StateName, State) ->
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Whenever a gen_fsm receives an event sent using
%% gen_fsm:sync_send_all_state_event/[2,3], this function is called
%% to handle the event.
%%
%% @spec handle_sync_event(Event, From, StateName, State) ->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {reply, Reply, NextStateName, NextState} |
%%                   {reply, Reply, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState} |
%%                   {stop, Reason, Reply, NewState}
%% @end
%%--------------------------------------------------------------------
handle_sync_event(_Event, _From, StateName, State) ->
    Reply = ok,
    {reply, Reply, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it receives any
%% message other than a synchronous or asynchronous event
%% (or a system message).
%%
%% @spec handle_info(Info,StateName,State)->
%%                   {next_state, NextStateName, NextState} |
%%                   {next_state, NextStateName, NextState, Timeout} |
%%                   {stop, Reason, NewState}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, StateName, State) ->
    {next_state, StateName, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_fsm when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_fsm terminates with
%% Reason. The return value is ignored.
%%
%% @spec terminate(Reason, StateName, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate({error, Reason}, _StateName, _State) ->
    io:format("ERORORING ~p~n" , [Reason]);
%    gen_server:cast(ernews_linkerv, Reason);
terminate({submit, Message}, _StateName, _State) ->
    io:format("ERORORING ~p~n" , [Message]).
%   gen_server:cast(ernews_linkerv, Message).

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, StateName, State, Extra) ->
%%                   {ok, StateName, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, StateName, State, _Extra) ->
    {ok, StateName, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================




%%%-------------------------------------------------------------------
%%% @author Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%
%%% @end
%%% Created : 10 Oct 2012 by Muhanad Nabeel <Muhanad@Muhanads-MacBook-Pro.local>
%%%-------------------------------------------------------------------



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    
