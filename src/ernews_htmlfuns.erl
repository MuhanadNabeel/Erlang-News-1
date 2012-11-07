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
    
%----------------------------END URL <iocoder> ----------------------------------------------%
    

end_url(iocoder,Url)->   
    Result  = ernews_defuns:read_web(iocoder, Url),
    case Result of
	{success,{Header, _}}->
	    End_Url =proplists:get_value("location", Header),
	    case End_Url of
		[] ->
		    {error, end_url_not_found};
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
	    case lists:sublist(Link, 4) =:= "http" of 
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

get_info(Url)->
    Result = ernews_defuns:read_web(default,Url),
    case Result of
	{success, {_, Body}}->
	    Html = mochiweb_html:parse(Body),
	    [get_title(Html),get_description(Html),get_icon(Html),get_image(Html,Url)];
	   %  [get_title(Html),get_description(Html),get_icon(Html)];
        
	{error, Reason} ->
	    {error,Reason}
		
    end.

break_list([])->
    [];
break_list([{_,_,V}|T])->

    %% Check if the size of the article is bigger than 120 characters
    %% As implemented in the posting of links on Facebook
    case counter(V , 0 ) > 120  of
	true ->
	    V;
	false ->
	    break_list(T)
    end.

get_description(Html)->
   
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
			    {error, description_not_found};
			_ ->
			    
			    ParsedToHtml = mochiweb_html:to_html({"html",[],PTagArticle}),
			    
			    {ok, bitstring_to_list(iolist_to_binary(ParsedToHtml))}
		        
		    end;
			
		_ -> {ok,NextDescription}
	    end;
		
	_ ->
	    {ok,Description}

		
    end.


get_title(Html)-> 
    case get_value([Html],"title" ,[]) of
	[{_,_,[Val|_]}] ->
	    {ok,[bitstring_to_list(Val)]};
	_ ->
	    case get_value([Html],"TITLE" ,[]) of
		[{_,_,[Val|_]}] ->
		    {ok,bitstring_to_list(Val)};
		_->
		    
		    {error, title_not_found}
	    end
			
    end.




get_image(Html,Url)->
    List = get_value([Html],"meta" ,[]),
    Image = 
	get_content_from_list(List , 
			      {"property" ,"og:image"} , "content"),
    case Image of
	[] ->
	    List2 = get_value([Html],"img" ,[]),
	    case find_image(List2,[],Url) of
		[] ->
		    {error, image_not_found};
		Images ->
		    lists:max(Images)
	    end;
	_ ->
	    % Ensure images are larger than 45x45
	    {success, {_, Body}} =  ernews_defuns:read_web(default,						   "http://recallin.com/?url="
							   ++Url),
	    {Height,Width}=seperate(Body,[]),
	    
	    case Height*Width > 1600 of
		true -> {ok, Image};
		false -> {error, image_not_found}
	    end
	    
    end.
		

get_icon(Html)->
    List = get_value([Html],"link" ,[]),
    Icon = 
	get_content_from_list(List , 
			      {"rel" ,"shortcut icon"} , "href"),
    case Icon of
	[] ->
	    Icon2 = get_content_from_list(List, {"rel","icon"},"href"),
	    
	    case Icon2 of
		[]->
		    {error, icon_not_found};
		_ ->
		    {ok, Icon2}
	    end;
	
	_ ->
	    {ok, Icon}
		
    end.

    
relevancy_check(Url)->
    Result = ernews_defuns:read_web(default,Url),
    case Result of
	{success, {_, Body}}->
	    Html = mochiweb_html:parse(Body),
	    PTags= get_value([Html],"p" ,[]),
	    ParsedToHtml = mochiweb_html:to_html({"html",[],PTags}),
	   % io:format("~p~s",[bitstring_to_list(iolist_to_binary(ParsedToHtml))]);
	    ernews_defuns:is_relevant(bitstring_to_list(iolist_to_binary(ParsedToHtml)));
	{error, Reason} -> {error, Reason}
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


%--------------------------------IMG Inner Functions------------------------------------%

seperate([$||_],[])->
    {0,0};
seperate([$||T],Buff)->
    {list_to_integer(Buff),list_to_integer(T)};
seperate([H|T],Buff) ->
    seperate(T,Buff++[H]).

get_main_url(Url) ->		
    get_main_url(Url,0,"").
get_main_url([$/|_],2,Buff) ->	
    Buff;
get_main_url([$/|T],C,Buff) ->	
    get_main_url(T,C+1,Buff++[$/]);
get_main_url([H|T],C,Buff) ->	
    get_main_url(T,C,Buff ++ [H]).

find_image([],Buffer,_)->
    % Filters the list to only allow images with the size of 45x45
    lists:filter(fun({Size,_}) ->  Size > 1600 end, Buffer);


  

find_image([{Key,List,_}|T], Buffer,Url)  ->
    case Key == list_to_bitstring("img") of
	true ->
	    % Size default set to 1 
	    find_image(T,[get_image_property(List,{1,""},Url)|Buffer],Url);
	false ->
	    find_image(T,Buffer,Url)
    end.

get_image_property([],{Size,Source},_)->
    {Size,Source};
%The bitlist from mochiweb contains Key,Value structure of the images tag
get_image_property([{Key, Value}|T],{Size,Source},Url) ->
    case bitstring_to_list(Key) of

	"src" ->
	     % Source URL found, add it to the buffer
	    % Check if the src url does not contain the proper structure
	     case lists:sublist(bitstring_to_list(Value), 1) =:= "/" of 
		 true	->   
		     {success, {_, Body}} = 
			 % Call PHP function to get the width and height of the image
			 % Some links don't contain a full URL
			 % Add the image url + source url together 
			 ernews_defuns:read_web(default,
					        "http://recallin.com/?url="
						++get_main_url(Url)
						++bitstring_to_list(Value)),
		     {Height,Width}=seperate(Body,[]),
		     {Height*Width,get_main_url(Url)++ bitstring_to_list(Value)};
		 false ->
		      io:format("~p~n",[bitstring_to_list(Value)]),
		     {success, {_, Body}} = 
			
			 ernews_defuns:read_web(default,
						"http://recallin.com/?url="
						++bitstring_to_list(Value)),
		    
		     {Height,Width}=seperate(Body,[]),
		     {Height*Width,bitstring_to_list(Value)}
	     end;
  
	
	"class" ->
	    % Ingnore all images that are avatars (Mainly from blogs)
	    case bitstring_to_list(Value) of
		[$a,$v,$a,$t,$a,$r|_] ->
		    % If an avatar is found, set the size to 0 so it is ignored
		    get_image_property(T,{0,Source},Url);
		_ ->
		    get_image_property(T,{Size,Source},Url)
	    end;
	_ ->		
	    get_image_property(T,{Size,Source},Url)
    end.

%%-------------------------------------------------------------------%%







test()->
    
    	{success, {_, Body}} = ernews_defuns:read_web(default,"http://localhost:8888/_img_size.php?url=http://basho.com/images/raspi-boot.jpg"),
    Body.
    %Html = mochiweb_html:parse(H).
%    file:write_file("/Users/magnus/Desktop/image.txt", io_lib:fwrite("~s", [Body])).

    
    %PTags= get_value([Html],"image" ,[]).

   % {success, {_, Body}} = ernews_defuns:read_web(default,Url),
   % get_description(readlines("/Users/magnus/Desktop/html.txt")).

%  Html = mochiweb_html:pars(readlines("/Users/magnus/Desktop/html.txt")),
  %  PTags= get_value([Html],"p" ,[]),
 %  % PTagArticle = break_list(lists:reverse(PTags)),
    
    
   % T = mochiweb_html:to_html({"html",[],PTagArticle}),
    
   % {ok, bitstring_to_list(iolist_to_binary(T))}.
		        
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
hello.
   % Test = {<<"html">>,[],[{pi, <<"xml:namespace">>,[{<<"prefix">>,<<"o">>},
%{<<"ns">>,<<"urn:schemas-microsoft-com:office:office">>}]}]},

 %   T2 = {"",[],[<<"We have finally released ">>,{<<"a">>,[{<<"href">>,
%<<"http://elixir-lang.org/">>}],[<<"Elixir">>]},<<" v0.5.0! This marks %
%the first release since the language was rewritten. In this blog post, we will discu">>]},

%bitstring_to_list(iolist_to_binary(mochiweb_html:to_html(T2))).

%%-------------------------------------------------------------%%

