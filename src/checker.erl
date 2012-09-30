%% @autohr Khashayar Abdoli
-module(checker).
-compile(export_all).

-record(state, {source, time_stamp , next_check , items}).

