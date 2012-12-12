%%% @author Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%% E-unit test for ernews_htmlfuns
%%% Covering TC19, TC5
%%% @end
%%% Created :  3 Dec 2012 by Magnus Thulin <magnus@dhcp-198246.eduroam.chalmers.se>

-module(db_test).
-include_lib("eunit/include/eunit.hrl").


%--------------------------------------------------------------------------------%
%%% @test Case: TC19
%%% @requirement: BE-FREQ#9
%--------------------------------------------------------------------------------%
db_connect_test()->
   ernews_db:connect(),
   ?assertNotEqual(undefined, whereis(mysql_dispatcher)).
    
db_write_test()->
    ?assertEqual({ok,updated},ernews_db:write(broken,{"test","test","test"})), 
    ?assertEqual(true,ernews_db:exists(broken,{"Url","test"})), 
    ?assertEqual({ok,updated},ernews_db:qFunc(write,"Delete from ernews_broken where Url = 'test'")), 
    ?assertEqual(false,ernews_db:exists(broken,{"Url","test"})). 


%--------------------------------------------------------------------------------%
%%% @test Case: TC5
%%% @requirement: BE-FREQ#8
%--------------------------------------------------------------------------------%
db_duplicate_test()->
    ?assertEqual(false,ernews_db:qFunc(exists,"select count(a.Url) from ernews_news a, ernews_news b where a.Url = b.Url AND a.newsID != b.newsID")).


