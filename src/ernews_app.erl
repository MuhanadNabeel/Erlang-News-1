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

