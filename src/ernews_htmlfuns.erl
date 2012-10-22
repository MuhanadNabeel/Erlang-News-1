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
%	 check_content/2,pull_content/2]).
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
	    Link;

	{error,Reason}->
	   {error, Reason}
    end;

end_url(google,Url)->   
    end_url(iocoder,Url);
       
end_url(_,_) ->
    {error, unknown_source}. 

%----------------------------HTML META DATA-------------------------------------------%
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
		    null;
		_ ->
		    Description
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
		    bitstring_to_list(Val);
		_ ->
		    null
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
						     
%get_content([Attr|T] , Filter , Value) ->
%   case check_content(Attr , Filter) of
%	true ->
%	    pull_content(Attr , Value);
%	false ->
%	    get_content(T,Filter,Value)
%    end;
%get_content([] , _ , _) ->
%    not_fount.

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
