<?php
    // Philip
?>
<!DOCTYPE html>
<html>
    <head>
        <style type="text/css">
        /*----------
Div fonts
----------*/
.right_title{
    font-family: "MyriadPro Regular";
    font-size: 0.8em;
    color: #4b4b4b;
    text-shadow:1px 1px 1px white;
    text-decoration: none;
    cursor: pointer;
}
.right_source{
    font-family: "Times New Roman";
    font-size: 0.7em;
    font-style: italic;
    color: #8c8c8c;
    text-shadow:1px 1px 1px white;
    text-align: right;
    text-decoration: none;
}
.right_source a:link{color:#0c638c;font-size:1em;text-decoration: none;}
.right_source a:hover{color: #2497cd;}
.right_source a:visited{color: #0c638c;}
.desc{
    font-size: 10pt;
    text-shadow:1px 1px 0px white;
    color: #222222;
    padding-right: 10px;
}
.desc a:link{
    text-decoration: none;
    color: #aacc77;
}
.desc a:hover{
    color: #74a22f;
}
.desc a:active{
    color: black;
}
.desc a:visited{
    color: #aacc77;
}



/*----------
Main divs
----------*/
.right_row{
    background-color: #eeeeee;
    border-bottom: 1px solid #d4d4d4;
    padding-right: 0;
    cursor: pointer;
    width: auto;
}
.right_row:hover{background-color: #eaeaea;}
.right_row:hover a.right_title{color:#222222;}

.right_content{
    width:auto;
    background-color:#f6f6f6;
    display: none;
    overflow: hidden;
}
/*----------
Details
----------*/
.right-bottom-line{background-color: white;height:1px;}
.seperator{
    width:16em;
    height:1px;
    background-color:#c6c6c6;
    border-bottom:1px solid white;
    margin-top:0.5em;
}
.green-seperator{
    background-color:#aacc77;
    width:100%;
    height:0.1em;
}
.arrow-container{
    width: 100%;
    vertical-align:bottom;
}
.arrow-up{
    width: 0;
    height: 0;
    border-bottom: 1.3em solid white;
    border-left: 1.3em solid transparent;
    margin-bottom: 0.1em;
}

/*----------
Thumbs up and down.
----------*/
.voting{
  vertical-align:top;
  display:inline-block;
  padding: 0.5em;
}
.small-voting{
  vertical-align:top;
  display:inline-block;
}
.thumb-up{
    margin-top: 0.2em;
    background:url(img/thumb-up.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-up:hover{
    background:url(img/thumb-up.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-up:active{
    background:url(img/thumb-up.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-up-active{
    margin-top: 0.2em;
    background:url(img/thumb-up.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}
.thumb-down{
    margin-top: 0.2em;
    background:url(img/thumb-down.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-down:hover{
    background:url(img/thumb-down.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-down:active{
    background:url(img/thumb-down.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-down-active{
    margin-top: 0.2em;
    background:url(img/thumb-down.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}



.thumb-up-shadowed{
    margin-top: 0.2em;
    background:url(img/thumb-up-shadowed.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-up-shadowed:hover{
    background:url(img/thumb-up-shadowed.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-up-shadowed:active{
    background:url(img/thumb-up-shadowed.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-up-active-shadowed{
    margin-top: 0.2em;
    background:url(img/thumb-up-shadowed.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}
.thumb-down-shadowed{
    margin-top: 0.2em;
    background:url(img/thumb-down-shadowed.png) 0 0 no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
}
.thumb-down-shadowed:hover{
    background:url(img/thumb-down-shadowed.png) 0 -1.2em no-repeat;
    background-size: 100%;
}
.thumb-down-shadowed:active{
    background:url(img/thumb-down-shadowed.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.thumb-down-active-shadowed{
    margin-top: 0.2em;
    background:url(img/thumb-down-shadowed.png) 0 -2.4em no-repeat;
    background-size: 100%;
    height: 1.1em;
    width: 1em;
    display: none;
}


#article_container{
    width:45%;
    vertical-align: top;
}


</style>

        <link rel="stylesheet" type="text/css" href="mainCSS.css">
        <link rel="stylesheet" type="text/css" href="template-style.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script type="text/javascript" src="default_js.js"></script>
        <script type="text/javascript" src="jquery.quicksand.js"></script>
        <script type="text/javascript">

            var $holder;
            var $data;

            function openUpStuff(id){
                jQuery('#'+id+'_expand').slideToggle('400');
            }

            $(document).ready(function() {

                // get the action filter option item on page load
                $holder = $('#archive');
                $data = $holder.clone();

                /*var $filteredData = $data.find('li[data-type=type1]');
                    $holder.quicksand($filteredData, {
                        duration: 0});*/

            })

            function animate(id){
                closeAllStuff(function(){
                    var $filteredData = $data.find('li[data-type=right_archive_'+id+']');
                    $holder.quicksand($filteredData, {
                        duration: 700,
                        easing: 'swing'},
                        function(){
                            jQuery('#archive').find('div[class="right_row"]').css('width', 'auto');
                        });


                });
                
/*
                jQuery('#article_container').css('width', jQuery('#news_article_left').css('width'));
                jQuery('#newsTemp').css('width', '100px');

                var $filteredData1 = $data1.find('li[data-type=left_archive_'+id+']');
                $holder1.quicksand($filteredData1, {
                    duration: 1000,
                     easing: 'swing'});

                var $filteredData2 = $data2.find('li[data-type=left_archive_'+id+']');
                $holder2.quicksand($filteredData2, {
                    duration: 1000,
                    easing: 'swing'});*/
             }

            function updateRight(id){
                $data = $holder.clone();                
                var $filteredData = $data.find('li[data-type=right_archive_'+(id-1)+']');
                $holder.quicksand($filteredData, {
                    duration: 0,
                    easing: 'swing'},function(){
                        if(id > 2){
                            $data.find('li[data-type=right_archive_'+(id-2)+']').empty();
                        }
                    });
                
                    
                
                animate(id);
                
            }

            function closeAllStuff(cbFunc){
                t = jQuery('#archive').find('div[class="right_content"]');
                a = t.filter(function(){
                    return ($(this).is(':visible'));
                })
                a.slideUp('400', cbFunc);
                 
             }

             function openBox(URL, title, id, datatype){
                buttons = jQuery("#"+id+"_all_vote_buttons").clone();
                buttons.css('display', 'block');
                jQuery('#box-vote-buttons').append(buttons);
                jQuery('#box_title').html(title);
                jQuery('#frame_content').attr('src', URL);
                jQuery('#bigframe').css('display', 'block');
             }
             function closeBox(){
                jQuery('#box-vote-buttons').empty();
                jQuery('#bigframe').css('display', 'none');
                jQuery('#frame_content').attr('src', '');
             }
            

        </script>
        <title></title>  
        <button onclick="getNewsJSON()">update</button>   
    </head>
    <body>
        <div id="bigframe" style="display:none">
            <div style="position:fixed;background-color:black;left:0;top:0;opacity:.3;width:100%;height:100%;z-index:20000;" onclick="closeBox();"></div>
            <div style="position:fixed;background-color:white;width:80%;height:92%;z-index:20001;box-shadow:0px 0px 100px black;left:50%; margin-left:-40%;top:4%;">
                
                <div class="close-button" onclick="closeBox()"></div>
                <div style="position:absolute;z-index:20;width:100%;height:auto;background-color:rgba(0,0,0,.5);top:0px;">
                    <table><tr>
                        <td id="box-vote-buttons"></td>
                        <td style="vertical-align:top;"><div id="box_title" class="box_title"></div></td>
                        </tr></table>

                </div>

                
                            <iframe id="frame_content" src="" style="position:absolute;border-style:none;width:100%;height:100%;z-index:1;"></iframe>
<!--                    <div style="position:absolute;background-color:#e4e4e4;width:100%;height:auto;z-index:2;bottom:0;box-shadow:0 -3px 10px #333333;white-space:nowrap;">
    -->                    

                    </div>
                
            </div>
        </div>
            <table class="leftTable">
            <tr>
                <td class="left">
                    <table>
                        <tr>
                            <td id="article_container"><ul style="list-style-type:none;" id="news_article_left"></ul></td>
                            <td id="article_container"><ul style="list-style-type:none;" id="news_article_right"></ul></td>
                        </tr>
                    </table>
                </td>
                <td class="left">
                    <div id="recent"></div>
                    <ul id="archive" style="list-style-type: none;"></ul>

                </td>
            </tr>
        </table>
        
    </body>
</html>
