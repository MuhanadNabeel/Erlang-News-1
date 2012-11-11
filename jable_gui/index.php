<?php
    // Philip
?>
<!DOCTYPE html>
<html>
    <head>
        <style type="text/css">
      tr.awesome{
        color: red;
      }
      th[class|="type"]{
        cursor:pointer;
      }
    </style>

        <link rel="stylesheet" type="text/css" href="mainCSS.css">
        <link rel="stylesheet" type="text/css" href="template-style.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
        <script type="text/javascript" src="default_js.js"></script>
        <script type="text/javascript" src="jquery.quicksand.js"></script>
        <script type="text/javascript">

            function openUpStuff(id){
                if(jQuery("#"+id+"_expand").css('height') =='0px'){
                    jQuery("#"+id+"_expand").animate({height:jQuery("#"+id+"_content").css('height')}, 400);
                }else{
                    jQuery("#"+id+"_expand").animate({height:'0'}, 400);
                }
            }
            function updateRight(){

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
                        <div id="recent"></div>
                        <ul id="archive"></ul>


                        <!--
<ul id="oldone">
                            <li data-id="1">Hello1</li>
                            <li data-id="3">Hello2</li>
                            <li data-id="4">Hello3</li>
                        </ul>
                        <ul id="newone" style="display:none">
                            <li data-id="2">Hello2</li>
                            <li data-id="4">Hello4</li>
                            <li data-id="1">Hello1</li>
                        </ul>


                    
                        <ul id="newone" style="display:none">
                            <li data-id="1"><div style="width:10px;height:30px;background-color:red;">Hello1</div></li>
                            <li data-id="2"><div style="width:30px;height:20px;background-color:blue;">Hello2</div></li>
                            <li data-id="3"><div style="width:60px;height:50px;background-color:green;">Hello3</div></li>
                            <li data-id="4"><div style="width:10px;height:60px;background-color:pink;">Hello4</div></li>
                            <li data-id="5">Hello5</li>
                            <li data-id="6">Hello6</li>
                        </ul>
                        <ul id="oldone" >
                            <li data-id="2"><div style="width:30px;height:20px;background-color:blue;">Hello2</div></li>
                            <li data-id="4"><div style="width:10px;height:60px;background-color:pink;">Hello4</div></li>
                            <li data-id="1"><div style="width:10px;height:30px;background-color:red;">Hello1</div></li>
                            <li data-id="6">Hello6</li>
                            <li data-id="5">Hello5</li>
                            <li data-id="3"><div style="width:60px;height:50px;background-color:green;">Hello3</div></li>
                        </ul>
                    </td>-->
                </tr>
                <tr><button onclick="sort()">Hello</button></tr>
            </table>
        
    </body>
</html>
