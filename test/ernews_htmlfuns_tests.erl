%%% @author Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%% E-unit test for ernews_htmlfuns
%%% Covering TC6, TC4, TC9
%%% @end
%%% Created :  3 Dec 2012 by Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>

-module(ernews_htmlfuns_tests).
-include_lib("eunit/include/eunit.hrl").


%------------------------------------------------------------------------------%
%%% @test Case: TC6
%%% @requirement: BE-FREQ#3  
%------------------------------------------------------------------------------%
end_url_test()->
    R1 = "http://www.reddit.com/r/erlang/comments/13xzmq/erlang_r15b03_has_been_released/",
    R2 = "https://groups.google.com/forum/#!topic/erlang-programming/Djb6TvMbKyo",
    ?assertEqual(R2,ernews_htmlfuns:end_url(reddit,R1)),
    
    C1 = "http://coder.io/~9899fad313",
    C2 = "http://blog.monitis.com/index.php/2012/11/27/this-week-in-website-performance-6/",
    ?assertEqual(C2,ernews_htmlfuns:end_url(iocoder,C1)),
    
    H1 = "http://jsfiddle.net/uzMPU/",
    H2 = "http://jsfiddle.net/uzMPU/",
    ?assertEqual(H2,ernews_htmlfuns:end_url(hacker,H1)),

    T1 = "http://t.co/QrxReWnA",	
    T2 = "http://www.meetup.com/erlangusergroup/events/90363522/",
    ?assertEqual(T2,ernews_htmlfuns:end_url(twitter,T1)),

    G1 = "http://news.google.com/news/url?sa=t&;fd=R&usg=AFQjCNHbrV5qHhP6dSK1aiXd7LiOC6i4hQ&url=http://www.pr.com/press-release/454590",
    G2 = "http://www.pr.com/press-release/454590",
    ?assertEqual(G2,ernews_htmlfuns:end_url(google,G1)),
    ?assertEqual({error, unknown_source},ernews_htmlfuns:end_url(unknown,G1)).

%--------------------------------------------------------------------------------%
%%% @test Case: TC4
%%% @requirement: BE-FREQ#4
%--------------------------------------------------------------------------------%
get_info_test()->
    Url = "http://reddit.com/r/erlang",
    {success, {_, Body}} = ernews_defuns:read_web(default,Url),
    Html = mochiweb_html:parse(Body),
    
    {Title_Status,_} = ernews_htmlfuns:get_title(Html),
    {Description_Status,_} = ernews_htmlfuns:get_descriptions(desc,Html),  
    {Image_Status,_} = ernews_htmlfuns:get_image(Html,Url),
    {Icon_Status,_} = ernews_htmlfuns:get_icon(Html,Url),
    
    ?assertEqual(ok,Title_Status),
    ?assertEqual(ok,Description_Status),
    ?assertEqual(ok,Image_Status),
    ?assertEqual(ok,Icon_Status).

%--------------------------------------------------------------------------------%
%%% @test Case: TC9
%%% @requirement: BE-FREQ#5
%--------------------------------------------------------------------------------%
relevency_test()->
    
    Article = "The company’s platform is built on Erlang, +Sandvik says, which helps it to scale. The platform migration to an Erlang-based system was first revealed in October, when Soundrop updated its mobile and web apps with more interactivity. At the time, it announced 340 million tracks played through its services.",

    Article2 = "The company’s platform is built on Java, +Sandvik says, which helps it to scale. The platform migration to an Java-based system was first revealed in October, when Soundrop updated its mobile and web apps with more interactivity. At the time, it announced 340 million tracks played through its services.",
    
    GoodWords = ["Erlang","Riak","CouchDB","Fault-Tolerant"],
    BadWords = ["Erlang Calculator","Erlang Formula"],
    
    
    ?assertEqual({ok,[]},ernews_defuns:is_relevant(Article,GoodWords,BadWords,[])),
    ?assertEqual({error,not_relevant},ernews_defuns:is_relevant(Article2,GoodWords,BadWords,[])).
    

%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
get_content_test()->
    Source = "<html><meta name=\"description\" content=\"test\"/><html>",
    
    Html = mochiweb_html:parse(Source),
    Meta_Tag = ernews_htmlfuns:get_value([Html],"meta" ,[]),
    Description_Tag = ernews_htmlfuns:get_content_from_list(Meta_Tag ,  
					    {"name","description"},"content"),
    ?assertEqual(["test"],Description_Tag).
    

%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
get_image_test()->
    Source = "<html><img src=\"http://blog.monitis.com/wp-content/uploads/2012/04/Monitis-Logo-Small-1.png\" alt=\"All-In-One Monitoring\"/><html>",
    
    Html = mochiweb_html:parse(Source),
    Img_Tags = ernews_htmlfuns:get_value([Html],"img" ,[]),
    [{Size,_,_}] = ernews_htmlfuns:find_image(Img_Tags,[],""),
    ?assertEqual(16200,Size).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
avatar_image_test()->
    Source = "<html><img src=\"http://blog.monitis.com/avatar/wp-content/uploads/2012/04/Monitis-Logo-Small-1.png\" alt=\"All-In-One Monitoring\"/><html>",
    
    Html = mochiweb_html:parse(Source),
    Img_Tags = ernews_htmlfuns:get_value([Html],"img" ,[]),
    Image = ernews_htmlfuns:find_image(Img_Tags,[],""),
    ?assertEqual([],Image).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
image_ratio_test()->
    ?assertEqual(true, ernews_htmlfuns:image_ratio(100,200)),
    ?assertEqual(false, ernews_htmlfuns:image_ratio(0,0)),
    ?assertEqual(false, ernews_htmlfuns:image_ratio(10000,100)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
main_url_test()->
    L1 = "http://a.com",
    L2 = "http://a.com/b/c/d/e/f/g/h/i/j/k/l",
    ?assertEqual(L1,ernews_htmlfuns:get_main_url(L2)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
icon_link_test()->
    L1 = "http://t.com/img.png",
    L2 = "http://t.com/a/b/c/d/e",
    ?assertEqual({ok,L1},ernews_htmlfuns:get_icon_link(["/img.png"], L2)).


%--------------------------------------------------------------------------------%
%%% @test Case: TC
%%% @requirement: BE-FREQ# 
%--------------------------------------------------------------------------------%
is_html_test()->
    
    URL1 = "http://www.google.com",
    URL2 = "http://erlang.org",
    URL3 = "http://llvm.org/devmtg/2012-11/Gregor-Modules.pdf?=submit",
    
    {success, {H1, _}} = ernews_defuns:read_web(default,URL1),
    ?assertEqual(true,ernews_htmlfuns:is_html(H1)),

    {success, {H2, _}} = ernews_defuns:read_web(default,URL2),
    ?assertEqual(true,ernews_htmlfuns:is_html(H2)),

    {success, {H3, _}} = ernews_defuns:read_web(default,URL3),
    ?assertEqual(false,ernews_htmlfuns:is_html(H3)).
	  

	  
