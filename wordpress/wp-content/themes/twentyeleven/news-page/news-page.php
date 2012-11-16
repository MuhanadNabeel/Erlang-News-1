<?php
/*
Template Name: News-page2
*/

get_header()?>


<script type="text/javascript">
	var jableDir = "<?php echo bloginfo('template_directory') ?>/jable_gui/";
</script>

<link href="<?php echo bloginfo('template_directory') ?>/news-page/custom-css/jable-style.css" rel="stylesheet" type="text/css">
<script src="<?php echo bloginfo('template_directory') ?>/news-page/custom-script/jable-script.js"></script>


<table class="leftTable">
    <tr>
        <td class="left">
            <table>
                <tr>
                    <td style="width:50%;vertical-align: top;" id="news_article_left"></td>
                    <td style="width:50%;vertical-align: top;" id="news_article_right"></td>
                </tr>
            </table>
        </td>
        <td class="left">
            <div id="recent"></div>
            <div id="archive"></div>
        </td>
    </tr>
</table>



   
<?php get_footer()?>