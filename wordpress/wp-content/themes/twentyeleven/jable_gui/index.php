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


        <div id="bigframe" style="display:none" class="bigframe">
            <div style="position:fixed;background-color:black;left:0;top:0;opacity:.3;width:100%;height:100%;z-index:20000;" onclick="closeBox();"></div>
            <div style="position:fixed;background-color:white;width:80%;height:92%;z-index:20001;box-shadow:0px 0px 100px black;left:50%; margin-left:-40%;top:4%;">
                
                <div class="close-button" onclick="closeBox()"></div>
                <div style="position:absolute;z-index:20;width:100%;height:auto;background-color:rgba(0,0,0,.5);top:0px;">
                    <table><tr>
                        <td id="box-vote-buttons" style="padding:5px;">
                        </td>
                        <td style="vertical-align:top;"><div id="box_title" class="box_title"></div></td>
                        </tr>
                    </table>

                </div>

                
                            <iframe id="frame_content" src="" style="position:absolute;border-style:none;width:100%;height:100%;z-index:1;"></iframe>
        

                    </div>
                
        </div>
        <table><tr><td>
                    <table style="float:right;position:absolute;margin-left:15px;margin-top:15px;">
                        <tr>
                            <td>
                                <div style="padding-left:30px;padding-right:10px;background-color:#79a8be;white-space:nowrap;height:25px;float:left;color:black;">HOT NEWS</div>
                            </td>
                            <td>
                                <div class="arrow-right"></div>
                            </td>
                            <td>
                                <div class="arrow-left" style="margin-left:-15px;"></div>
                            </td>
                            <td>
                                <div style="background-color:#3f758b;width:20px;height:25px;"></div>
                            </td>
                        </tr>
                    </table>
            <table id="main_div">
                <tr><td>
                    <div align="left" id="top_hot_news" style="list-style-type:none;max-width:100%;background-color:white;padding:10px;"></div>
                </td></tr>
                <tr><td>
                    <table style="width:100%;">
                        <tr>
                            <td style="width:50%;"><ul style="list-style-type:none;margin:10px;" id="news_article_left"></ul></td>
                            <td style="width:50%;"><ul style="list-style-type:none;margin:10px;" id="news_article_right"></ul></td>
                        </tr>
                    </table>
                </td></tr>
                <tr><td>
                    <div id="first_loading" style="text-align:center;display:none;"></div>
                </td></tr>
            </table>

        </td><td class="right-column">

            <table>
                <tr><td>
                    <div class="news-headlines" style="box-shadow:inset 0px -3px 10px -3px rgba(0,0,0,0.5);">Latest news</div>
                </td></tr>
                <tr><td>
                    <ul id="latest_news" style="list-style-type:none;margin:0;"></ul>
                </td></tr>
                <tr><td>
                    <div class="news-headlines" style="box-shadow:inset 0px -3px 10px -3px rgba(0,0,0,0.5);">Alltime top</div>
                </td></tr>
                <tr><td>
                    <ul id="top_news" style="list-style-type:none;margin:0;"></ul>
                </td></tr>
            </table>

        </td></tr></table>

</div>
