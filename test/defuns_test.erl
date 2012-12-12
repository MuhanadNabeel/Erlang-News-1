%%% @author Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%%
%%% @end
%%% Created :  3 Dec 2012 by Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>

-module(defuns_test).
-include_lib("eunit/include/eunit.hrl").
-compile([ernews_htmlfuns.erl, mochiweb_html, mochiweb_charref,mochiutf8]).

%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
read_web_test()->
    Coder = "http://coder.io/~9899fad313",
    Dzone = "http://www.dzone.com/links/r/erlang_monitoring.html",
    Default = "https://jable.teamworkpm.net",
    Google = "http://google.com",

    {Verdict_1,{_,_}} = ernews_defuns:read_web(default,Default),
    {Verdict_2,{_,_}} = ernews_defuns:read_web(iocoder,Coder),
    {Verdict_3,{_,_}} = ernews_defuns:read_web(dzone,Dzone),
    {Verdict_4,{_,_}} = ernews_defuns:read_web(unknown,Google),
    
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
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
count_words_test()->
    Sentence = string:tokens("Erlang is cool because ERLANG is Swedish erlang"," "),
    Word = ["ERLANG"],
    ?assertEqual(3,ernews_defuns:count_words(Sentence,Word)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
remove_duplicate_test()->
    Sentence = string:tokens("Fault Fault Fault hello"," "),
    ?assertEqual(["hello","Fault"], ernews_defuns:remove_duplist(Sentence)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
split_text_test()->
    Sentence = "a b c d e f g",
    Split = ["a","b","c","d","e","f","g"],
    ?assertEqual(Split, ernews_defuns:split_text(Sentence)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
is_domain_test()->
    ?assertEqual(true, ernews_defuns:isDomain("http://www.google.com")),
    ?assertEqual(false, ernews_defuns:isDomain("http://www.google.com/a/b/c/d/e")).
