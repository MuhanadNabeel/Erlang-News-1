%% file: mysql_test.erl
%% author: Yariv Sadan (yarivvv@gmail.com)
%% for license see COPYING

-module(mysql_test).
-compile(export_all).

test() ->
    %% Start the MySQL dispatcher and create the first connection
    %% to the database. 'p1' is the connection pool identifier.
    mysql:start_link(p1, "localhost", 3307, "root", "root", "jable"),

    %% Add 2 more connections to the connection pool
    %mysql:connect(p1, "localhost", undefined, "root", "password", "test",
	%	  true),
    %mysql:connect(p1, "localhost", undefined, "root", "password", "test",
	%	  true),
    
    %mysql:fetch(p1, <<"DELETE FROM developer">>),
%
 %   mysql:fetch(p1, <<"INSERT INTO developer(name, country) VALUES "
	%	     "('Claes (Klacke) Wikstrom', 'Sweden'),"
	%	%%%     "('Ulf Wiger', 'USA')">>),%

    %% Execute a query (using a binary)
    Result1 = mysql:fetch(p1, <<"SELECT string FROM test">>),
    io:format("Result1: ~p~n", [Result1]).