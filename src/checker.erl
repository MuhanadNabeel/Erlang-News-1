%% @autohr Khashayar Abdoli
-module(checker).
-compile(export_all).

-record(state, {source, time_stamp , next_check , items}).

start(Source) ->
    Pid = spawn(?MODULE , init , [Source]),
    Pid.

