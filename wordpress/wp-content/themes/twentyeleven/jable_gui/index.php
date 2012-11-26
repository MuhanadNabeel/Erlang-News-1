<?php
/*
Template Name: News-page
*/

get_header()?>

<!DOCTYPE html>

<script type="text/javascript">
    var jableDir = "<?php echo bloginfo('template_directory') ?>/jable_gui/";
</script>



<link href="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-style/mainCSS.css" rel="stylesheet" type="text/css">
<link href="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-style/template-style.css" rel="stylesheet" type="text/css">
<script src="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-script/jquery.js"></script>
<script src="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-script/jable-script.js"></script>
<script src="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-script/jquery.quicksand.js"></script>
<script src="<?php echo bloginfo('template_directory') ?>/jable_gui/custom-script/interface-script.js"></script>

<style type="text/css">
/*----------
Div fonts
----------*/

@font-face {
  font-family: "MyriadPro Cond";
  src:  url("<?php echo bloginfo('template_directory').'/jable_gui/' ?>custom-fonts/MyriadPro-Cond.otf") format("opentype");
}
@font-face {
  font-family: "MyriadPro Regular";
  src:  url("<?php echo bloginfo('template_directory').'/jable_gui/' ?>custom-fonts/MyriadPro-Regular.otf") format("opentype");   
}
@font-face {
  font-family: "Times New Roman";
  src:  url("<?php echo bloginfo('template_directory').'/jable_gui/' ?>custom-fonts/TimesNewRoman.ttf") format("truetype");   
}
@font-face {
  font-family: "Visitor";
  src:  url("<?php echo bloginfo('template_directory').'/jable_gui/' ?>custom-fonts/visitor1.ttf") format("truetype");   
}



</style>

<div style="overflow:hidden;width:100%;">
<div align="center" id="first_loading" style="width:100%;height:auto;overflow:visible;"></div>   


        <div id="bigframe" style="display:none" class="bigframe">
            <div style="position:fixed;background-color:black;left:0;top:0;opacity:.3;width:100%;height:100%;z-index:20000;" onclick="closeBox();"></div>
            <div style="position:fixed;background-color:white;width:80%;height:92%;z-index:20001;box-shadow:0px 0px 100px black;left:50%; margin-left:-40%;top:4%;">
                
                <div class="close-button" onclick="closeBox()"></div>
                <div style="position:absolute;z-index:20;width:100%;height:auto;background-color:rgba(0,0,0,.5);top:0px;">
                    <table><tr>
                        <td id="box-vote-buttons" style="padding:5px;"></td>
                        <td style="vertical-align:top;"><div id="box_title" class="box_title"></div></td>
                        </tr>
                    </table>

                </div>

                
                            <iframe id="frame_content" src="" style="position:absolute;border-style:none;width:100%;height:100%;z-index:1;"></iframe>
        

                    </div>
                
        </div>
        <table id="main_div" style="width:120%;">
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" style="background-color:white;width:100%;">
                        <tr>
                            <td style="vertical-align:top;">
                                <div style="z-index:1000">
                                    <table>

                                        <tr><td>
                                            <div style="poistion:relative;" id="over_top_news">
                                            <div id="top_news_container" style="poistion:relative;height:auto;overflow:hidden;display:none;">
                                                <div align="center" style="list-style-type:none;width:100%;height:auto;background-color:#555555;overflow:hidden">
                                                    
                                                    <div align="left" id="top_news" style="max-width:100%;background-color:white;padding:10px;box-shadow:0 0px 20px black"></div>
                                                </div>
                                            </div>
                                            </div>
                                        </td></tr>
                                        <tr><td>
                                            <table style="width:100%;">

                                                <tr>
                                                    <td style="width:50%;"><ul style="list-style-type:none;margin:10px;" id="news_article_left"></ul></td>
                                                    <td style="width:1px;height:90%;background-color:#c6c6c6;"><div></div></td>
                                                    <td style="width:50%;"><ul style="list-style-type:none;margin:10px;" id="news_article_right"></ul></td>
                                                </tr>
                                            </table>
                                        </td></tr>
                                    </table>
                                </div>
                            </td>
                            <td style="padding-left:-100px;vertical-align:top;width:26%;">
                                <div style="position:relative;z-index:500;">
                                    <table>
                                        <tr><td class="news-headlines">Latest News</td></tr>
                                        <tr>
                                            <td>
                                                <ul id="latest_news" style="list-style-type:none;margin:0;"></ul>
                                            </td>
                                        </tr>
                                        <tr><td class="news-headlines">Top news</td></tr>
                                        <tr>
                                            <td>
                                                <ul id="archive" style="list-style-type:none;margin:0;"></ul>
                                            </td>
                                        </tr>
                                        <tr><td>
                                            <table onclick="slideLeft();" class="archive-button" style="width:100%;">
                                                <tr><td style="vertical-align:top;width:160%;">
                                                        <div class="archive-button-button" align="center">Archive</div>
                                                    </td>
                                                    <td style="vertical-align:top">
                                                        <div class="arrow-right"></div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td></tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="width:16.5%;background-color:#f7f7f7;height:20px;box-shadow:inset 3px 0 8px -5px black">
                    <div></div>
                </td>
            </tr>
        </table>
</div>
