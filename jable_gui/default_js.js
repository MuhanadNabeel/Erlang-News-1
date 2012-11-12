var isUserAction = new Object();
var newsTemplate = '';
var newsRightTemplate = '';
jQuery(document).ready(function() {
    $('body').prepend('<div style="text-align:center;position:absolute;left:50%;'
            +'top:40%;margin-left:-50px;margin-top:-10px;" id="main_loading_space"><img src="img/loading.gif" /></div>');
    jQuery.get('_get_templates.php',function(str){
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
    updateCounter(id,action,undo);
    isUserAction[id][Math.floor(action/2)] = true;
    changeUserButtons(id,item,undo);
    var interval = setInterval("articleActionBlink('" 
        + jQuery(item).attr('id') + "');",250);
    jQuery.post('_article_action.php',{id:id,action:action,undo:undo},function() {
        isUserAction[id][Math.floor(action/2)] = false;
        clearInterval(interval);
        jQuery('#' + jQuery(item).attr('id') + '_active').css('opacity','1');
        jQuery('#' + jQuery(item).attr('id')).css('opacity','1');
    });
    function updateCounter(id,action,undo) {
        if( undo == true && action == 0 )
            iterateCounter('#' + id + '_down_vote_count',false);
        else if( undo == true && action == 1 )
            iterateCounter('#' + id + '_up_vote_count',false);
        else if( undo == false && action == 0 ) {
            iterateCounter('#' + id + '_down_vote_count',true);
            if( jQuery('#' + id + '_vote_up_active').is(':visible') )
                iterateCounter('#' + id + '_up_vote_count',false);
        } else if( undo == false && action == 1 ) {
            iterateCounter('#' + id + '_up_vote_count',true);
            if( jQuery('#' + id + '_vote_down_active').is(':visible') )
                iterateCounter('#' + id + '_down_vote_count',false);
        }
    }
    function iterateCounter(id,up) {
        var org = parseInt( jQuery(id).text(), 10 );
        if( up )
            jQuery(id).text( ( org + 1 ) );
        else
            jQuery(id).text( ( org - 1 ) );
    }
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
        jQuery(item).hide();
        if( jQuery(item).attr('id').indexOf('_active') != -1 )
            jQuery( '#' + jQuery(item).attr('id').substring(0, 
                jQuery(item).attr('id').lastIndexOf('_')) ).show();
        else
            jQuery( '#' + jQuery(item).attr('id') + '_active' ).show();
        if( jQuery(item).attr('id').indexOf('vote_up') != -1 && 
                jQuery( '#' + id + '_vote_down_active' ).is(':visible') ) {
                jQuery( '#' + id + '_vote_down_active' ).hide();
                jQuery( '#' + id + '_vote_down' ).show();
        }
        else if( jQuery(item).attr('id').indexOf('vote_down') != -1 && 
                jQuery( '#' + id + '_vote_up_active' ).is(':visible') ) {
                jQuery( '#' + id + '_vote_up_active' ).hide();
                jQuery( '#' + id + '_vote_up' ).show();
        }
    }
}
var archiveTable = 1;
function getNewsJSON() {
    jQuery.get('_get_news.php',function(outcome) {
        $('#main_loading_space').remove();
        jQuery('#news_article_left').html('');
        jQuery('#news_article_right').html('');
    //    jQuery('#archive').html('');
        var parse = jQuery.parseJSON(outcome);
        var json = parse.news;
        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false);
            if( i < 10 && i % 2 == 0 )
                jQuery('#news_article_left').append( getNewsArticle(json[i], archiveTable) );
            else if( i < 10 )
                jQuery('#news_article_right').append( getNewsArticle(json[i], archiveTable) );
            else 
                jQuery('#archive').append( addNewsLink(json[i], archiveTable) );
        }
        setUserClicked(parse.cookies.Up_Vote,'_vote_up');
        setUserClicked(parse.cookies.Down_Vote,'_vote_down');
        
        if (archiveTable>1)
            updateRight(archiveTable);
        archiveTable++;

    });
    function setUserClicked(json,str) {
        for( var i = 0 ; i < json.length ; i++ ) {
            if( json[i] != '' ) {
                jQuery('#' + json[i] + str).hide();
                jQuery('#' + json[i] + str + '_active').show();
            }
        }
    }
    function getNewsArticle(json,datatype) {
        var precent = calcPrecent(parseInt(json.Up_Vote,10),parseInt(json.Down_Vote,10));
        return newsTemplate.replace(/{title}/g,json.Title)
                            .replace(/{down}/g,json.Down_Vote)
                            .replace(/{up}/g,json.Up_Vote)
                            .replace(/{clicks}/g,json.Clicks)
                            .replace(/{host}/g,json.host)
                            .replace(/{description}/g,json.Description)
                            .replace(/{image}/g,json.Image)
                            .replace(/{URL}/g,json.URL)
                            .replace(/{vote_bar}/g,precent)
                            .replace(/{datatype}/g,'archive_' + datatype)
                            .replace(/{id}/g,json.newsID);
    }
    
    function calcPrecent(up,down) {
        if( up == 0 && down == 0 )
            return 50;
        var total = up + down;
        return parseInt( (up/total)*100 ,10);
    }

    function addNewsLink(json,datatype) {
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
                                .replace(/{description}/g,json.Description)
                                .replace(/{URL}/g,json.URL)
                                .replace(/{host}/g,json.host)
                                .replace(/{vote_bar}/g,precent)
                                .replace(/{datatype}/g,'archive_' + datatype)
                                .replace(/{image}/g,json.Image)
                                .replace(/{id}/g,json.newsID);
    }
}

