-record(checker_state,{source, time_stamp , next_check, items}).
-record(sup_state,{processes,sources}).
-record(checker,{pid,source_name,source}).

