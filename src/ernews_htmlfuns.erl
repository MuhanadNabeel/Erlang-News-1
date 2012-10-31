%%%-------------------------------------------------------------------
%%% @author Magnus Thulin <magnus@dhcp-199078.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%%
%%% @end
%%% Created :  9 Oct 2012 by Magnus Thulin <magnus@dhcp-199078.eduroam.chalmers.se>
%%%-------------------------------------------------------------------

-module(ernews_htmlfuns).
%-export([get_description/1, get_title/1, end_url/2]).
%-export([get_content_from_list/4,get_content_from_list/3,
	 %check_content/2,pull_content/2]).
-compile(export_all).
    
%----------------------------END URL-------------------------------------------------%

end_url(iocoder,Url)->   
    Result  = ernews_defuns:read_web(iocoder, Url),
    case Result of
	{success,{Header, _}}->
	    End_Url =proplists:get_value("location", Header),
	    case End_Url of
		[] ->
		    {error, not_found};
		_ ->
		    End_Url
	    end;
	{error, Reason}->
	    {error, Reason}

    end;

end_url(reddit,Url)->
    Tag = ".xml",
    Result = ernews_defuns:read_web(default, Url++Tag),
    case Result of
	{success,{_,Body}}->
	    { Xml, _ } = xmerl_scan:string(Body),

	    Extract ="//channel/item/description[1]/text()[11]",
	    [{_,_,_,_,[_|Link],_}] = xmerl_xpath:string(Extract, Xml),
	    Link,
	
	    % If the XML returns a link that starts with http:// 
	    % Think link redirects to another wepage
	    % If it doesn't, then the link is originating from self.reddit 
	    % Return the Url from rssfuns 
	    case lists:sublist(Link, 7) =:= "http://" of 
	        true ->
		    Link;
		_ ->
		    Url
	    end;

	{error,Reason}->
	   {error, Reason}
    end;

end_url(google,Url)->   
    end_url(iocoder,Url);
      
end_url(_,_) ->
    {error, unknown_source}. 

%----------------------------HTML META DATA-------------------------------------------%



%%--------------------------------------------------------------------
%% @doc 
% Get's the description from the HTML in the following casses:
% a) First ensure connectivity to the host is successful (Inets does not catch any errors)
% b) Get the description from the description tag (the most common)
% c) If it doesnt exist, then get the description from the og:description tag
% d) If that doesnt return anything, get the descirption from the <p> tags
%    According to the Facebooks' implementation of posting URL's, <p> tags must contain
%    More than 120 characters (breaklist function) to return the article
% e) Catch an error message if no description is found in all cases
%% @spec
%% @end
%%--------------------------------------------------------------------


break_list([])->
    [];
break_list([{_,_,V}|T])->
    case counter(V , 0 ) > 120  of
	true ->
	    V;
	false ->
	    break_list(T)
    end.

get_description(Url)->
    Result = ernews_defuns:read_web(default,Url),
   
    case Result of

	{success, {_, Body}}->
	    Html = mochiweb_html:parse(Body),
	    List = get_value([Html],"meta" ,[]),
	    Description = 
		get_content_from_list(List , 
				      {"name" ,"description"} , "content"),
	    case Description of
		[]->
		    
		    NextDescription = get_content_from_list(List , 
				      {"name" ,"og:description"} , "content"),
		    
		    case NextDescription of
		      	[]->
			    PTags= get_value([Html],"p" ,[]),
			    PTagArticle = break_list(lists:reverse(PTags)),
			    
			    case PTagArticle of
				[] ->
				    {error, not_found};
				_ ->
				    
		        	ParsedToHtml = mochiweb_html:to_html({"html",[],PTagArticle}),
				  
				    {ok, bitstring_to_list(iolist_to_binary(ParsedToHtml))}
		        
			    end;
			
			_ -> {ok,NextDescription}
		    end;
		
			_ ->
			    {ok,Description}
	    end;

	{error, Reason} ->
	    {error,Reason}
		
    end.


get_title(Url)->
    Result = ernews_defuns:read_web(default,Url),
    case Result of
	{success, {_, Body}}->
	    Html = mochiweb_html:parse(Body),
	    
	    case get_value([Html],"title" ,[]) of
		[{_,_,[Val|_]}] ->
		    {ok,bitstring_to_list(Val)};
		_ ->
		    {error, not_found}
	    end;

	{error,Reason}->
	    {error,Reason}
    end.

%----------------------------HTML LIST BREAKDOWN----------------------------------------%
%% @author Khashayar Abdoli 
get_content_from_list(List,Filter,Value) ->
    get_content_from_list(List,Filter,Value,[]).

get_content_from_list([{_,Attr,_} | T] , Filter , Value , Buff) ->
    case check_content(Attr,Filter) of 
	true ->
	    Res = pull_content(Attr,Value),
	    get_content_from_list(T,Filter,Value , [Res | Buff]);
	false ->
	    get_content_from_list(T,Filter,Value , Buff)
    end;

get_content_from_list([],_,_ , Buff) ->
    Buff. 
						     

pull_content([{Key,Val}|T] , FKey) ->
    case bitstring_to_list(Key) == FKey of
	true ->
	   bitstring_to_list(Val);
	false ->
	    pull_content(T,FKey)
    end;
pull_content([] , _) ->
    not_found.

check_content([{Key,Val}|T] , {FKey , FVal}) ->
    KeyCheck = bitstring_to_list(Key) == FKey,
    ValCheck = bitstring_to_list(Val) == FVal,
    case {KeyCheck , ValCheck} of
	{true,true} ->
	    true;
	{_,_} ->
	    check_content(T , {FKey , FVal})
    end;
check_content([],_) ->
    false.

%--------------------------------HTML DATA RECIEVER------------------------------------%
%% @author Khashayar Abdoli

get_value([{Key,Attr,Val=[{_IK,_IA,_IV}|_IT]}|T] , Filter , Buff) ->
    case bitstring_to_list(Key) == Filter of
	true ->
	    get_value(T,Filter,[{Key,Attr,Val}|Buff]);
	false ->
	    get_value(T,Filter,get_value(Val,Filter,[])++Buff)
    end;
get_value([{Key,Attr,Val}|T] , Filter , Buff) ->
    case bitstring_to_list(Key) == Filter of
	true ->
	    get_value(T,Filter,[{Key,Attr,Val}|Buff]);
	false ->
	    get_value(T,Filter,Buff)
    end;
get_value([_|T] , Filter , Buff) ->
    get_value(T,Filter,Buff);
get_value([] , _ , Buff) ->
    Buff.



counter([H|T] , Acc) ->
    case is_bitstring(H) of
	true ->
	    counter(T , Acc + length(bitstring_to_list(H)));
	false ->
	    counter(T , Acc)
    end;
counter([] , Acc) ->
    Acc.




%%-------------------------------------------------------------%%

test()->
    
   % {success, {_, Body}} = ernews_defuns:read_web(default,Url),
   % get_description(readlines("/Users/magnus/Desktop/html.txt")).
   Html = mochiweb_html:parse(readlines("/Users/magnus/Desktop/html.txt")),
    PTags= get_value([Html],"p" ,[]),
    PTagArticle = break_list(lists:reverse(PTags)),
    
    
    T = mochiweb_html:to_html({"html",[],PTagArticle}),
    
    {ok, bitstring_to_list(iolist_to_binary(T))}.
		        
    % io:format("~p~n",[Html]),
%    [{_,_,[Val|_]}] =  get_value([Html],"title" ,[]),
%    Val.
	

	   % {ok,bitstring_to_list(Val)}.
   % PTags = get_value([Html],"p" ,[]),
   % PTagArticle = break_list(lists:reverse(PTags)),
   % case PTagArticle of
%	[] ->
%	    {error, not_found};
%	_ ->
%	    ParsedArticle = 
%		mochiweb_html:to_html({"html",[],PTagArticle}),
%	    io:format("~s~n", [bitstring_to_list(iolist_to_binary(ParsedArticle))])
%	    
		
 %   end.
   %io:format("~s",[Html]).
    %PTags= get_value([Html],"p" ,[]).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try get_all_lines(Device)
      after file:close(Device)
    end.

get_all_lines(Device) ->
    case io:get_line(Device, "") of
        eof  -> [];
        Line -> Line ++ get_all_lines(Device)
    end.



test2()->
    Test = {<<"html">>,[],[{pi, <<"xml:namespace">>,[{<<"prefix">>,<<"o">>},
{<<"ns">>,<<"urn:schemas-microsoft-com:office:office">>}]}]},

    T2 = {"",[],[<<"We have finally released ">>,{<<"a">>,[{<<"href">>,
<<"http://elixir-lang.org/">>}],[<<"Elixir">>]},<<" v0.5.0! This marks 
the first release since the language was rewritten. In this blog post, we will discu">>]},

bitstring_to_list(iolist_to_binary(mochiweb_html:to_html(T2))).

%%-------------------------------------------------------------%%

