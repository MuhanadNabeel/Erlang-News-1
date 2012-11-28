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
   

%------------------------------------------------------------------------------%
 
%%% @author Magnus Thulin
%%% @doc
%%% Get info is the outer-function called externally. 
%%% It returns title, description, icon and image from a URL
%%% @end

get_info(Url)->
    Result = ernews_defuns:read_web(default,Url),
    case Result of
	{success,{_,[]}}->
	    {error, empty_body};

	{success, {Headers, Body}}->
	    case is_html(Headers) of
		true ->
		    Html = mochiweb_html:parse(Body),
		    [get_title(Html), get_descriptions(desc,Html),
		     get_icon(Html,Url), get_image(Html,Url)];
		false ->
		    {error, page_not_text}
	    end;
	{error, Reason} ->
	    {error,Reason}
	        
    end.

%------------------------------------------------------------------------------%

%%% @author Magnus Thulin
%%% @doc
%%% According to the RSS source, the function returns the end URL for a given RSS 
%%% url. The genuine Read web function from defuns is called to open the httpd 
%%% connection. iocoder returns a link with auto-redirect disabled. Reddit 
%%% returns the end-url from source by parsing XHTML.
%%% @end


end_url(iocoder,Url)->   
    Result  = ernews_defuns:read_web(iocoder, Url),
    case Result of
	{success,{Header, _}}->
	    End_Url =proplists:get_value("location", Header),
	    case End_Url of
	        undefined ->
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

	{success,{_,[]}}->
	    {error, empty_body};

	{success,{_,Body}}->
	    { Xml, _ } = xmerl_scan:string(Body),
	    
	    Extract ="//channel/item/description[1]/text()[11]",
	    [{_,_,_,_,[_|Link],_}] = xmerl_xpath:string(Extract, Xml),
	    Link,
	    
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
      
end_url(twitter, Url)->
    end_url(iocoder,Url);

end_url(dzone, Url)->
  Result  = ernews_defuns:read_web(dzone, Url),
    case Result of
	
	{success,{Header, _}}->
	    End_Url =proplists:get_value("location", Header),
	    case End_Url of
	        undefined ->
		    {error, end_url_not_found};
		_ ->
		    End_Url
	    end;
	{error, Reason}->
	    {error, Reason}

    end;

end_url(hacker,Url)->
    Url;

end_url(_,_) ->
    {error, unknown_source}. 



%------------------------------------------------------------------------------%

%%% @author Magnus Thulin
%%% @doc
% According to the Facebook implementation of posting URL's, the function first
% looks to find the 'description' tag in the meta. If that is not found, it will
% return the 'OG:Description' tag from meta. Lastly, it will return the article
% in the '<p>' tag which is larger than 120 characters. 
%%% @end


get_descriptions(desc,Html)->
    Meta_Data = get_value([Html],"meta" ,[]),
    Description_Tag = get_content_from_list(Meta_Data ,  
					    {"name","description"},"content"),
    case length(lists:concat(Description_Tag)) < 20 of 
	true -> get_descriptions(ogdesc,Html);
	false -> {ok, Description_Tag}
    end;

get_descriptions(ogdesc,Html) ->
    Meta_Data = get_value([Html],"meta" ,[]),
    OGDescription_Tag = get_content_from_list(Meta_Data , 
					      {"name" ,"og:description"},"content"),
    case length(lists:concat(OGDescription_Tag)) < 20 of 
	true -> get_descriptions(capdesc,Html);
	false -> {ok, OGDescription_Tag}
    end;   

get_descriptions(capdesc,Html) ->
    Meta_Data3 = get_value([Html],"meta" ,[]),
    CapDescription_Tag = get_content_from_list(Meta_Data3 , 
					       {"name" ,"Description"},"content"),
    
    case length(lists:concat(CapDescription_Tag)) < 20 of 
	true -> get_descriptions(ptag,Html);
	false -> {ok, CapDescription_Tag}
    end;   

get_descriptions(ptag,Html) ->
    PTag_Data= get_value([Html],"p" ,[]),
    PTag_Article = break_list(lists:reverse(PTag_Data)),
    ParsedToHtml = mochiweb_html:to_html({"html",[],PTag_Article }),
    PTag_Description = bitstring_to_list(iolist_to_binary(ParsedToHtml)), 
    case length(PTag_Description) < 20 of
	true -> {error, description_not_found};
	false ->{ok,PTag_Description}
    end.
    


%-------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% Returns the article value from the Mochiweb parsed HTML data which is bigger
% than 120 characters. 
%%% @end

break_list([])->
    [];
break_list([{_,_,V}|T])->
    
    case counter(V , 0 ) > 120  of
	true ->
	    V;
	false ->
	    break_list(T)
    end.

%------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% From the parsed HTML the function, extract the title.
%%% @end


get_title(Html)-> 
    case get_value([Html],"title" ,[]) of
	[{_,_,[Val|_]}] ->
	    {ok,bitstring_to_list(Val)};
	_ ->
	    case get_value([Html],"TITLE" ,[]) of
		[{_,_,[Val|_]}] ->
		    {ok,bitstring_to_list(Val)};
		_->
		    
		    {error, title_not_found}
	    end
			
    end.

%------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% From the parsed HTML the function, extract the image from the meta tag. If
% it doesnt exist, return the largest image from the body of the HTML. The
% size of the image is determined by calling a PHP function. 
% Only allow images are larger than 80x80 
% Diminishes possibility of non-related image
%%% @end


get_image(Html,Url)->
    Meta_Data = get_value([Html],"meta" ,[]),
    Meta_OGImage = 
	get_content_from_list(Meta_Data , 
			      {"property" ,"og:image"} , "content"),
    case Meta_OGImage of
	[] ->
	    Img = get_value([Html],"img" ,[]),

	    case find_image(Img,[],Url) of
		[] ->
		    {ok, "undef"};
	All_Images ->
		   
		   {ok, element(2,lists:max(All_Images))}

	    end;

	_ ->
	    
	   case  ernews_defuns:read_web(default,
					"http://recallin.com/_img_size.php?url="
					++hd(Meta_OGImage)) of
	       {success, {_, Body}} ->
		   {Height,Width}=seperate(Body,[]),
		   case Height*Width >  5625 of
		       true -> {ok, hd(Meta_OGImage)++"|"
				++integer_to_list(Width) ++ "*" 
				++integer_to_list(Height)};
		       false -> {ok, "undef"}
		   end;
	       _ ->
		   {0,""}
	   end
	    
		       
	    
    end.

%------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% Returns the icon from the meta data in the HTML. Some icon links do not
% contain the entire URL (eg. /favicon.icon) therefore the function checks
% and compiles a complete link.
%%% @end

get_icon(Html,Url)->
    Meta_Data = get_value([Html],"link" ,[]),
    Shortcut_Icon = 
	get_content_from_list(Meta_Data , 
			      {"rel" ,"shortcut icon"} , "href"),
    case Shortcut_Icon of
	[] ->
	    Icon = get_content_from_list(Meta_Data, {"rel","icon"},"href"),
	    
	    case Icon of
		[]->
		    {ok, "undef"};
		_ ->
		    
		    case lists:sublist(hd(Icon),1) =:="/" of
			true ->
			    {ok,get_main_url(Url)++hd(Icon)};
			 false ->
			    {ok, Icon}
		    end
			
	    end;
	
	_ ->
	    
	    case lists:sublist(hd(Shortcut_Icon),1) =:="/" of
		true ->
		    {ok,get_main_url(Url)++hd(Shortcut_Icon)};
		false ->
		    {ok,  Shortcut_Icon}
	    end
		
    end.

%------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% Calls the relevency function. 
%%% @end

relevancy_check(Url,{Good,Bad,Tags})->
    Result = ernews_defuns:read_web(default,Url),
    case Result of
	{success, {_, Body}}->
	    Html = mochiweb_html:parse(Body),
	    {ok,Title} = get_title(Html),
	    P_Tags= get_value([Html],"p" ,[]),
	    ParsedToHtml = mochiweb_html:to_html({"html",[],P_Tags}),
	    ernews_defuns:is_relevant(bitstring_to_list(iolist_to_binary(
						  ParsedToHtml)) 
				      ++ Title,Good,Bad,Tags);
	{error, Reason} -> 
	    {error, Reason}
    end.



%-------------------------------------------------------------------------------%
%% @author Khashayar Abdoli 
is_html(Headers) ->
    case proplists:get_value("content-type",Headers) of
	undefined ->
	    true;
	R ->
	    case string:str(R, "html") of
		0 ->
		    false;
		_ ->
		    true
	    end
    end.

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

%-------------------------------------------------------------------------------%
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


%-------------------------------------------------------------------------------%
%%% @author Khashayar Abdoli
%%% @doc
%
%%% @end

get_main_url(Url) ->		
    get_main_url(Url,0,"").
get_main_url([$/|_],2,Buff) ->	
    Buff;
get_main_url([$/|T],C,Buff) ->	
    get_main_url(T,C+1,Buff++[$/]);
get_main_url([H|T],C,Buff) ->	
    get_main_url(T,C,Buff ++ [H]).

%------------------------------------------------------------------------------%
%%% @author Khashayar Abdoli
%%% @doc
%
%%% @end

seperate([$||_],[])->
    {0,0};
seperate([$||T],Buff)->
    {list_to_integer(Buff),list_to_integer(T)};
seperate([H|T],Buff) ->
    seperate(T,Buff++[H]);
seperate(_,_) ->
    {0,0}.


%------------------------------------------------------------------------------%
%%% @author Khashayar Abdoli & Magnus Thulin
%%% @doc
% 
%%% @end

find_image([],Buffer,_)->
    % Filters the list to only allow images with the size of 45x45
    lists:filter(fun({Size,_}) ->  Size > 5625 end, Buffer);

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
    case {bitstring_to_list(Key),string:str(bitstring_to_list(Value), "avatar")} of
       
	{"src",0} ->
	     % Source URL found, add it to the buffer
	    % Check if the src url does not contain the proper structure
	     case lists:sublist(bitstring_to_list(Value), 1) =:= "/" of 
		 true	->   
		     
			 % Call PHP function to get  width and height
			 % Some links don't contain a full URL
			 % Add the image url + source url together 
		     case  ernews_defuns:read_web(default,
					        "http://recallin.com/_img_size.php?url="
						++get_main_url(Url)
						++bitstring_to_list(Value)) of
			 {success, {_, Body}} -> 		
			
			     {Height,Width}=seperate(Body,[]),
			    get_image_property(T,{Height*Width,
			      get_main_url(Url)++ bitstring_to_list(
						    Value) ++ "|"
						  ++integer_to_list(Width) ++ "*" 
						  ++integer_to_list(Height)},Url);
			 _ ->
			     {0,""}
		     end;
		 false ->

		     case ernews_defuns:read_web(default,
						 "http://recallin.com/_img_size.php?url="
						 ++bitstring_to_list(Value)) of
			 {success, {_, Body}} -> 		    
			     {Height,Width}=seperate(Body,[]),
			     get_image_property(T,{Height*Width,
						   bitstring_to_list(
						     Value) ++ "|"
						   ++integer_to_list(Width) ++ "*" 
						   ++integer_to_list(Height)},Url);						     			 
			 _ ->
			     {0,""}
		     end
	     end;
  
	
	{"class",_} ->
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




%------------------------------------------------------------------------------%
%%% @author Magnus Thulin
%%% @doc
% Returns the icon from the meta data in the HTML. Some icon links do not
% contain the entire URL (eg. /favicon.icon) therefore the function checks
% and compiles a complete link.
%%% @end


test(Url)->
    
   % 	{success, {_, Body}} = ernews_defuns:read_web(default,"http://localhost:8888/_img_size.php?url=http://basho.com/images/raspi-boot.jpg"),
    %Body.
    %Html = mochiweb_html:parse(H).
%    file:write_file("/Users/magnus/Desktop/image.txt", io_lib:fwrite("~s", [Body])).

    
    %PTags= get_value([Html],"image" ,[]).

    {success, {_, Body}} = ernews_defuns:read_web(default,Url),
    Html = mochiweb_html:parse(Body).
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

