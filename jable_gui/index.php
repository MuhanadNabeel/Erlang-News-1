<?php
    // Philip
?>
<!DOCTYPE html>
<html>
    <head>
        <style>

/*
url(fonts/MyriadPro-Bold.otf) format("opentype"),
url(fonts/MyriadPro-BoldCond.otf) format("opentype"),
url(fonts/MyriadPro-BoldCondIt.otf) format("opentype"),
url(fonts/MyriadPro-BoldIt.otf) format("opentype"),
url(fonts/MyriadPro-Cond.otf) format("opentype"),
url(fonts/MyriadPro-CondIt.otf) format("opentype"),
url(fonts/MyriadPro-It.otf) format("opentype"),
url(fonts/MyriadPro-Regular.otf) format("opentype"),
url(fonts/MyriadPro-Semibold.otf) format("opentype"),
url(fonts/MyriadPro-SemiboldIt.otf) format("opentype")
*/

@font-face {
  font-family: "MyriadPro Cond";
  src:  url(fonts/MyriadPro-Cond.otf) format("opentype");
}
@font-face {
  font-family: "MyriadPro Regular";
  src:  url(fonts/MyriadPro-Regular.otf) format("opentype");   
}


.newsTemp{
    margin: 10px;
}
.title{
    margin: 0px;
    font-family: "MyriadPro Cond";
    font-size: 1.6em;
}
.content{
    margin-right: 20px;
    padding: 10px;
    font-size: 12pt;
    text-decoration: none;
}

.readMore{
    margin: 10px;
    font-family: "MyriadPro Cond";
    font-size: 1em;
    color: #aacc77;
}

#pub{
    font: italic 0.7em "MyriadPro Cond";
    color: #c6c6c6;
}

.voteButtons{
    position: absolute;
    margin-right: 20px;
    padding: 5px;
    height:4.46em;
    vertical-align:top;
    opacity:1;
    filter:alpha(opacity=10); /* For IE8 and earlier */
}

.vote-up{
    padding-top: 0.06em;
    background:url(img/vote-up.png) 0 0 no-repeat;
    background-size: 100%;
    height: 2.34em;
    width: 2em;
}

.vote-up:hover{
    background:url(img/vote-up.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.vote-up:active{
    background:url(img/vote-up.png) 0 -4.8em no-repeat;
    background-size: 100%;
}




.vote-up-active{
    background:url(img/vote-up.png) 0 -7.2em no-repeat;
    background-size: 100%;
    height: 2.3em;
    width: 2em;
    padding-top: 0.1em;
    display:none;
}

.vote-up-active:active{
    background:url(img/vote-up.png) 0 -4.8em no-repeat;
    background-size: 100%;
}


.vote-down{
    padding-top: 1.55em;
    background:url(img/vote-down.png) 0 0 no-repeat;
    background-size: 100%;
    height: 0.85em;
    width: 2em;
}
.vote-down:hover{
    background:url(img/vote-down.png) 0 -2.4em no-repeat;
    background-size: 100%;
}
.vote-down:active{
    background:url(img/vote-down.png) 0 -4.8em no-repeat;
    background-size: 100%;
}

.vote-down-active{
    background:url(img/vote-down.png) 0 -7.2em no-repeat;
    background-size: 100%;
    height: 0.85em;
    width: 2em;
    padding-top: 1.55em;
    display:none;
}
.vote-down-active:active{
    background:url(img/vote-down.png) 0 -4.8em no-repeat;
    background-size: 100%;
}



.window{
    text-align: center;
    position: absolute;
    padding-top:0.38em;
    padding-left: 0.28em; 
    margin-left: 2.2em;
    background:url(img/window.png) 0 0 no-repeat;
    background-size: 100%;
    height: 3em;
    width: 3em;
    display: none;
    opacity: 0.8;
    filter:alpha(opacity=80);
}

.likes{
    height: 100%;
    width: 100%;
    font:bold 0.75em "MyriadPro Cond";
    text-shadow: 0.067em 0.067em 0.1em black;
    color:white;
    vertical-align: top;
}

.triangle-topright {
    width: 0;
    height: 0;
    border-top: 1em solid white;
    border-left: 1em solid transparent;
}

.link a:link{
    text-decoration: none;
    color:black;
}

.link a:visited {color:black;}  /* visited link */
.link a:hover {color:#aacc77;}  /* mouse over link */
.link a:active {color:#74a22f;}

.readMore a:link{color:#aacc77; text-decoration: none;text-shadow:1px 1px 0px white;}
.readMore a:hover {color:#74a22f;text-shadow:1px 1px 0px white;}
.readMore a:visited {color:#aacc77;text-shadow:1px 1px 0px white;}  /* mouse over link */
.readMore a:active {color:black;text-shadow:1px 1px 0px white;}
</style>



<style type="text/css">

.right_title{
    font-family: "MyriadPro Regular";
    font-size: 0.8em;
    color: #4b4b4b;
    text-shadow:1px 1px 1px white;
    text-decoration: none;
    cursor: pointer;
}

.arrow-up{
    width: 0;
    height: 0;
    border-bottom: 1.3em solid white;
    border-left: 1.3em solid transparent;
    margin-bottom: 0.1em;
}

.right_row{
    background-color: #eeeeee;
    border-bottom: 1px solid #d4d4d4;
    width: 100%;
    padding: .4em;
    padding-right: 0;
    padding-left: 1em;
    cursor: pointer;
}
.right_row{
    background-color: #eeeeee;
    border-bottom: 1px solid #d4d4d4;
    width: 100%;
    padding: .4em;
    padding-right: 0;
    padding-left: 1em;
    cursor: pointer;
}
.right_row:hover{
    background-color: #eaeaea;
}
.right_row:hover a.right_title{
    color:#222222;
}
.right-bottom-line{
    background-color: white;
    width:21.4em;
    height:1px;
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

.right_source{
    font-family: "Times New Roman";
    font-size: 0.7em;
    font-style: italic;
    color: #8c8c8c;
    text-shadow:1px 1px 1px white;
    text-align: right;
    text-decoration: none;
}
.right_source a:link{
    color:#0c638c;
    font-size:1em;
    text-decoration: none;
}
.right_source a:hover{
    color: #2497cd;
}
.right_source a:visited{
    color: #0c638c;
}

.desc{
    font-size: 10pt;
    text-shadow:1px 1px 0px white;
    color: #222222;
}

.right_content{
    width:21.4em;
    background-color:#f6f6f6;
    padding: 0;
    height:0;
    overflow: hidden;
}
</style>

        <link rel="stylesheet" type="text/css" href="mainCSS.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script type="text/javascript" src="default_js.js"></script>
        <script type="text/javascript">

            function openUpStuff(id){
                if(jQuery("#"+id+"_expand").css('height') =='0px'){
                    jQuery("#"+id+"_expand").animate({height:jQuery("#"+id+"_content").css('height')}, 400);
                }else{
                    jQuery("#"+id+"_expand").animate({height:'0'}, 400);
                }
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
                                <td style="width:45%;vertical-align: top;border-right:1px solid #c6c6c6;" id="news_article_left"></td>
                                <td style="width:45%;vertical-align: top;" id="news_article_right"></td>
                            </tr>
                        </table>
                    </td>
                    <td class="left">
                        <div id="recent" ></div>
                        <div id="archive"></div>
                    </td>
                </tr>
            </table>
        
    </body>
</html>
