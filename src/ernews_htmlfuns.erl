%%%-------------------------------------------------------------------
%%% @author Magnus Thulin <magnus@dhcp-199078.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%%
%%% @end
%%% Created :  9 Oct 2012 by Magnus Thulin <magnus@dhcp-199078.eduroam.chalmers.se>
%%%-------------------------------------------------------------------

-module(ernews_htmlfuns).
-export([get_description/1, get_title/1, end_url/2]).
-export([get_content_from_list/4,get_content_from_list/3,
	 check_content/2,pull_content/2]).

    
%----------------------------END URL-------------------------------------------------%

end_url(coder,Url)->    
    inets:start(),   
    HTTPOptions = [{autoredirect, false}],
    Result = httpc:request(get, {Url, []}, HTTPOptions, []),
    case Result of
	{ok, {{_Version, 302, _StatusMsg}, Headers, Body}} ->
	    Location = proplists:get_value("location", Headers);
	{_,_}->
	    broken_link
    end;

end_url(reddit,Url)->
    inets:start(),
    Tag = ".xml",
    Result  = httpc:request(Url ++ Tag),
    case Result of
	{ ok, {Status, Headers, Body }} ->
	    { Xml, Rest } = xmerl_scan:string(Body),
	    Extract ="//channel/item/description[1]/text()[11]",
	    [{_,_,_,_,[_|Link],_}] = xmerl_xpath:string(Extract, Xml),
	    Link;
	{_,_}->
	    broken_link
    end;

end_url(google,Url)->   
    end_url(coder,Url);
       
end_url(_,Url) ->
    unknown_source. 

%----------------------------HTML META DATA-------------------------------------------%
 
get_description(Url)->
    inets:start(),
    Result = httpc:request(Url),
    case Result of
	 {ok, {{Version, 200, ReasonPhrase}, Headers, Body}} ->
	    Html = mochiweb_html:parse(Body),
	    List = get_value([Html],"meta" ,[]),
	    lists:concat(get_content_from_list(List , {"name" ,"description"} , "content"));
	{_,_}->
	    broken_html
    end;
get_description([]) ->
    description/title_not_exist.




get_title(Url)->
    inets:start(),
    Result = httpc:request(Url),
    case Result of
	 {ok, {{Version, 200, ReasonPhrase}, Headers, Body}}->
	    Html = mochiweb_html:parse(Body),
	    [{K,Attr,[Val|T]}] = (get_value([Html],"title" ,[])),
	    bitstring_to_list(Val);
	{_,_}->
	    broken_html
    end;
get_title([]) ->
    description/title_not_exist.

    

%----------------------------HTML LIST BREAKDOWN----------------------------------------%
%% @author Khashayar Abdoli 
get_content_from_list(List,Filter,Value) ->
    get_content_from_list(List,Filter,Value,[]).

get_content_from_list([{Key,Attr,Val} | T] , Filter , Value , Buff) ->
    case check_content(Attr,Filter) of 
	true ->
	    Res = pull_content(Attr,Value),
	    get_content_from_list(T,Filter,Value , [Res | Buff]);
	false ->
	    get_content_from_list(T,Filter,Value , Buff)
    end;

get_content_from_list([],_,_ , Buff) ->
    Buff. 
						     
get_content([Attr|T] , Filter , Value) ->
    case check_content(Attr , Filter) of
	true ->
	    pull_content(Attr , Value);
	false ->
	    get_content(T,Filter,Value)
    end;
get_content([] , _ , _) ->
    not_fount.

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
get_value(_ , Filter , Buff) ->
    Buff.
