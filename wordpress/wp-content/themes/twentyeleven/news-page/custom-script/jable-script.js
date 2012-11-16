//@author Khahsayar
/* ArrayList of booleans that represent if an user interaction
 * is being processed */
var isUserAction = new Object();
/* Template of the news articles, with: icon, title, description and image */
var newsTemplate = '';
/* Template of the news list, with only title */
var newsRightTemplate = '';
/* Loading the page */
jQuery(document).ready(function() {
    jQuery.get(jableDir + "_get_templates.php",function(str){
        /* Assigning the templates to the variables */
        var split = str.split('<split_between_templates>')
        newsRightTemplate = split[0];
        newsTemplate = split[1];
        /* Fetching content */
        getNewsJSON();
        /* Reload content every 5 minutes */
        setInterval('getNewsJSON();',300000);
    });
});

/* Interaction with user of the page: votes and reports */
function articleAction(item,action,undo) {
    /* ID of the article in question */
    var id = jQuery(item).attr('id').substring(0,jQuery(item).attr('id').indexOf('_'));
    /* If action to this ID is still in process - abort */
    if( isUserAction[id][Math.floor(action/2)] == true )
        return;
    /* Set action in process */
    isUserAction[id][Math.floor(action/2)] = true;
    /* Change visual effect */
    changeUserButtons(id,item,undo);
    /* In case of slow process, change transparency of button every 0.25 sec */
    var interval = setInterval("articleActionBlink('" 
        + jQuery(item).attr('id') + "');",250);
    /* Call PHP file and update DB. Clear interval, reset and refresh content */
    jQuery.post(jableDir + "_article_action.php",{id:id,action:action,undo:undo},function() {
        isUserAction[id][Math.floor(action/2)] = false;
        clearInterval(interval);
        jQuery('#' + jQuery(item).attr('id') + '_active').css('opacity','1');
        jQuery('#' + jQuery(item).attr('id')).css('opacity','1');
        getNewsJSON();
    });
    var articleActionBlinkIndex = 1;
    function articleActionBlink(id) {
        var opacity = '0.3';
        if( articleActionBlinkIndex % 2 == 0 ) {
            opacity = '0.8';
            articleActionBlinkIndex = 2;
        }
        jQuery('#' + id).css('opacity',opacity);
        jQuery('#' + id + '_active').css('opacity',opacity);
        articleActionBlinkIndex++;
    }
    function changeUserButtons(id,item,undo) {
        if( undo == true )
            jQuery(item).hide();
        else if( jQuery(item).attr('id') == id + '_vote_up' 
            && jQuery('#' + id + '_vote_down_active').is(':visible') ) {
            jQuery('#' + id + '_vote_down_active').hide();
            jQuery('#' + id + '_vote_up_active').show();
        }
        else if( jQuery(item).attr('id') == id + '_vote_down' 
            && jQuery('#' + id + '_vote_up_active').is(':visible') ) {
            jQuery('#' + id + '_vote_up_active').hide();
            jQuery('#' + id + '_vote_down_active').show();
        }
        else
            jQuery( '#' + jQuery(item).attr('id') + '_active').show();
    }
}

function getNewsJSON() {
    jQuery.get(jableDir + "_get_news.php",function(outcome) {
        jQuery('#news_article_left').html('');
        jQuery('#news_article_right').html('');
        jQuery('#archive').html('');
        var jableParse = jQuery.parseJSON(outcome);
        var json = jableParse.news;
        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false);
            if( i < 10 && i % 2 == 0 )
                jQuery('#news_article_left').append( getNewsArticle(json[i]) );
            else if( i < 10 )
                jQuery('#news_article_right').append( getNewsArticle(json[i]) );
            else 
                jQuery('#archive').append( addNewsLink(json[i]) );
        }
        setUserClicked(parse.cookies.Up_Vote,'_vote_up_active');
        setUserClicked(parse.cookies.Down_Vote,'_vote_down_active');
    });
    function setUserClicked(json,str) {
        for( var i = 0 ; i < json.length ; i++ ) {
            if( json[i] != '' )
                jQuery('#' + json[i] + str).show();
        }
    }
    function getNewsArticle(json) {
        var precent = calcPrecent(parseInt(json.Up_Vote,10),parseInt(json.Down_Vote,10));
        return newsTemplate.replace('{title}',json.Title)
                            .replace('{down}',json.Down_Vote)
                            .replace('{up}',json.Up_Vote)
                            .replace('{clicks}',json.Clicks)
                            .replace('{description}',json.Description)
                            .replace('{image}',json.Image)
                            .replace(/{URL}/g,json.URL)
                            .replace('{vote_bar}',precent)
                            .replace(/{id}/g,json.newsID);
    }
    
    function calcPrecent(up,down) {
        if( up == 0 && down == 0 )
            return 50;
        var total = up + down;
        return parseInt( (up/total)*100 ,10);
    }

    function addNewsLink(json) {
        var title = '';
        if( json.Title.length < 60 )
            title = json.Title;
        else
            title = json.Title.substring(0,55) + ' ...';

        var precent = calcPrecent(parseInt(json.Up_Vote,10),parseInt(json.Down_Vote,10));
        return newsRightTemplate.replace('{title}',title)
                                .replace('{down}',json.Down_Vote)
                                .replace('{up}',json.Up_Vote)
                                .replace('{clicks}',json.Clicks)
                                .replace(/{URL}/g,json.URL)
                                .replace('{vote_bar}',precent)
                                .replace(/{id}/g,json.newsID);
    }
}



