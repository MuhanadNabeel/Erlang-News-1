%%%-------------------------------------------------------------------
%%% @author Khashayar <khashayar@localhost.localdomain>
%%% @copyright (C) 2012, Khashayar
%%% @doc
%%%
%%% @end
%%% Created : 30 Sep 2012 by Khashayar <khashayar@localhost.localdomain>
%%%-------------------------------------------------------------------
-module(checker).

-record(state, {source, time_stamp , next_check, items}). 

start(Source) ->
    Pid = spawn(?MODULE , init , [Source]),
    Pid.

start_link(Source) ->
    Pid = spawn_link(?MODULE , init , [Source]),
    Pid.

init(Source) ->
    loop(#state{source = Source , time_stamp = {{1990,4,5},{0,0,0}} , 
		next_check = {{1990,4,5},{0,0,0}} , items = []}).

loop(State = #state{}) ->
    receive
	stop ->
	    io:format("DONE HERE",[]);
	{ok , TS} ->
	    loop(State#state{time_stamp = TS});
	{bad , TS} ->
	    loop(State#state{time_stamp = TS})
    after 0 ->
	    
	    Now = erlang:localtime(), 
	    case Now > State#state.next_check of
		true ->    
		    New_last_check = calendar:gregorian_seconds_to_datetime(
				       calendar:datetime_to_gregorian_seconds(
					 erlang:localtime()) + 3600),
		    inets:start(),
		    {ok, {{_Version, 200, _ReasonPhrase}, _Headers, Body}} = 
			httpc:request(State#state.source),
		    %% NewItems = parse_rss:run(Body),
		    loop(State#state{last_check = New_last_check , 
				     items = NewItems}),
		_ ->
		    ok
	       
	    end,

	    case State#state.items of
		[Head|Tail] ->
		    %% Create The URL finder process here!!! :D:D:D:D
		    loop(State#state{items = Tail});
		[] ->
		    loop(State)
	    end
    end.
