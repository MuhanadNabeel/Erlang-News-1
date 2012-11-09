var isUserAction = new Object();
var newsTemplate = '';
var newsRightTemplate = '';
jQuery(document).ready(function() {
    jQuery.get('_get_templates.php',function(str){
        /* Assigning the templates to the variables */
        var split = str.split('<split_between_templates>')
        newsRightTemplate = split[0];
        newsTemplate = split[1];
        getNewsJSON();
        setInterval('getNewsJSON();',300000);
    });
});

function articleAction(item,action,undo) {
    var id = jQuery(item).attr('id').substring(0,jQuery(item).attr('id').indexOf('_'));
    if( isUserAction[id][Math.floor(action/2)] == true )
        return;
    isUserAction[id][Math.floor(action/2)] = true;
    changeUserButtons(id,item,undo);
    var interval = setInterval("articleActionBlink('" 
        + jQuery(item).attr('id') + "');",250);
    jQuery.post('_article_action.php',{id:id,action:action,undo:undo},function() {
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
            jQuery('#' + id + '_vote_down').hide();
            jQuery('#' + id + '_vote_up').show();
        }
        else if( jQuery(item).attr('id') == id + '_vote_down' 
            && jQuery('#' + id + '_vote_up_active').is(':visible') ) {
            jQuery('#' + id + '_vote_up_active').hide();
            jQuery('#' + id + '_vote_down_active').show();
            jQuery('#' + id + '_vote_up').hide();
            jQuery('#' + id + '_vote_down').show();
        }
        else
            jQuery( '#' + jQuery(item).attr('id') + '_active').show();
    }
}

function getNewsJSON() {
    jQuery.get('_get_news.php',function(outcome) {
        jQuery('#news_article_left').html('');
        jQuery('#news_article_right').html('');
        jQuery('#archive').html('');
        var parse = jQuery.parseJSON(outcome);
        var json = parse.news;
        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false);
            if( i < 10 && i % 2 == 0 )
                jQuery('#news_article_left').append( getNewsArticle(json[i]) );
            else if( i < 10 )
                jQuery('#news_article_right').append( getNewsArticle(json[i]) );
            else 
                jQuery('#archive').append( addNewsLink(json[i]) );
        }
        setUserClicked(parse.cookies.Up_Vote,'_vote_up');
        setUserClicked(parse.cookies.Down_Vote,'_vote_down');
    });
    function setUserClicked(json,str) {
        for( var i = 0 ; i < json.length ; i++ ) {
            if( json[i] != '' ) {
                jQuery('#' + json[i] + str).hide();
                jQuery('#' + json[i] + str + '_active').show();
            }
        }
    }
    function getNewsArticle(json) {
        var precent = calcPrecent(parseInt(json.Up_Vote,10),parseInt(json.Down_Vote,10));
        return newsTemplate.replace(/{title}/g,json.Title)
                            .replace(/{down}/g,json.Down_Vote)
                            .replace(/{up}/g,json.Up_Vote)
                            .replace(/{clicks}/g,json.Clicks)
                            .replace(/{description}/g,json.Description)
                            .replace(/{image}/g,json.Image)
                            .replace(/{URL}/g,json.URL)
                            .replace(/{vote_bar}/g,precent)
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
        return newsRightTemplate.replace(/{title}/g,title)
                                .replace(/{down}/g,json.Down_Vote)
                                .replace(/{up}/g,json.Up_Vote)
                                .replace(/{clicks}/g,json.Clicks)
                                .replace(/{URL}/g,json.URL)
                                .replace(/{vote_bar}/g,precent)
                                .replace(/{id}/g,json.newsID);
    }
}



