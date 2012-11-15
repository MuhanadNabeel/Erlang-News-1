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
                    easing: 'swing'});
                if(id > 2){
                    $data.find('li[data-type=right_archive_'+(id-2)+']').empty();
                }
                    
                
                animate(id);
                
            }

            function closeAllStuff(cbFunc){
                t = jQuery('#archive').find('div[class="right_content"]');
                a = t.filter(function(){
                    return ($(this).is(':visible'));
                })
                a.slideUp('400', cbFunc);
                 
             }
            

        </script>
        <title></title>      
    </head>
    <body>
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
