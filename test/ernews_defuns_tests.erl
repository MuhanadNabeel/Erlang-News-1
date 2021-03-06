%%% @author Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%%
%%% @end
%%% Created :  3 Dec 2012 by Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>

-module(ernews_defuns_tests).
-include_lib("eunit/include/eunit.hrl").


%--------------------------------------------------------------------------------%
%%% Code Test
%--------------------------------------------------------------------------------%
read_web_test()->
    Coder = "http://coder.io/~9899fad313",
    Dzone = "http://www.dzone.com/links/r/erlang_monitoring.html",
    Default = "https://jable.teamworkpm.net",


    {Verdict_1,{_,_}} = ernews_defuns:read_web(default,Default),
    {Verdict_2,{_,_}} = ernews_defuns:read_web(iocoder,Coder),
    {Verdict_3,{_,_}} = ernews_defuns:read_web(dzone,Dzone),
 
    
    ?assertEqual(success, Verdict_1),
    ?assertEqual(success, Verdict_2),
    ?assertEqual(success, Verdict_3).

%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
convert_date_test()->
    Date = "Mon, 19 Nov 2012 14:06:14 -0800",  
    ?assertEqual({{2012,11,19},{14,6,14}},ernews_defuns:convert_date(Date)).    


%--------------------------------------------------------------------------------%
%%% Code Test
%--------------------------------------------------------------------------------%
count_words_test()->
    Sentence = string:tokens("Erlang is cool because ERLANG is Swedish erlang"," "),
    Word = ["ERLANG"],
    ?assertEqual(3,ernews_defuns:count_words(Sentence,Word)).


%--------------------------------------------------------------------------------%
%%% Code Test
%--------------------------------------------------------------------------------%
remove_duplicate_test()->
    Sentence = string:tokens("Fault Fault Fault hello"," "),
    ?assertEqual(["hello","Fault"], ernews_defuns:remove_duplist(Sentence)).


%--------------------------------------------------------------------------------%
%%% Code Test
%--------------------------------------------------------------------------------%
split_text_test()->
    Sentence = "a b c d e f g",
    Split = ["a","b","c","d","e","f","g"],
    ?assertEqual(Split, ernews_defuns:split_text(Sentence)).


%--------------------------------------------------------------------------------%
%%% Code Test
%--------------------------------------------------------------------------------%
is_domain_test()->
    ?assertEqual(true, ernews_defuns:isDomain("http://www.google.com")),
    ?assertEqual(false, ernews_defuns:isDomain("http://www.google.com/a/b/c/d/e")).
