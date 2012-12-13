%%% @author Muhanad Nabeel <Muhanad@dhcp-207005.eduroam.chalmers.se>
%%% @copyright (C) 2012, Muhanad Nabeel
%%% @doc
%%%     This module is the application module starting the supervisor
%%%     including the error loggers to generate report file
%%%     And also stops it
%%% @end
%%% Created : 13 Dec 2012 by Muhanad Nabeel <Muhanad@dhcp-207005.eduroam.chalmers.se>


%%% API module for the pool
-module(ernews_app).
-behaviour(application).
-export([start/2, stop/1]).

start(normal, _Args) ->
    error_logger:tty(false),
    error_logger:logfile({open, log_report}),
    ernews_supervisor:start_link().

stop(_State) ->
    ok.

