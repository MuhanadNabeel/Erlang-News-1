%%%-------------------------------------------------------------------
%%% @author Magnus Thulin <magnus@dhcp-203195.eduroam.chalmers.se>
%%% @copyright (C) 2012, Magnus Thulin
%%% @doc
%%% This module fetches the end URL's from the RSS links. 
%%% Currently supporting Coder.io / GoogleNews / Reddit.
%%% @end
%%% Created :  8 Oct 2012 by Magnus Thulin <magnus@dhcp-203195.eduroam.chalmers.se>
%%%-------------------------------------------------------------------

-module(endUrl).
-export([getUrl/2]).


getUrl(coder,Url)->    
    inets:start(),   
    HTTPOptions = [{autoredirect, false}],
    {ok, {{_Version, 302, _StatusMsg}, Headers, Body}} =
    httpc:request(get, {Url, []}, HTTPOptions, []),
    Location = proplists:get_value("location", Headers);

getUrl(google,Url)->   
    getUrl(coder,Url);
       
getUrl(reddit,Url)->
    inets:start(),
    Tag = ".xml",
    { ok, {Status, Headers, Body }} = httpc:request(Url ++ Tag),
    { Xml, Rest } = xmerl_scan:string(Body),
    Extract ="//channel/item/description[1]/text()[11]",
    [{_,_,_,_,[_|U1],_}] = xmerl_xpath:string(Extract, Xml),
    U1.

  


    
		       
