var isUserAction = new Object();
var newsBigTemplate = '', newsMediumTemplate = '', newsSmallTemplate = '', newsRightTemplate = '';

jQuery(document).ready(function() {
    jQuery.get(jableDir + '_get_templates.php',{jableurl:jableDir},function(str){
        var split = str.split('<split_between_templates>');
        newsRightTemplate = split[0];
        newsBigTemplate = split[1];
        newsMediumTemplate = split[2];
        newsSmallTemplate = split[3];
        getNewsJSON();
        setInterval('getNewsJSON();',180000);
    });
});

function articleAction(item,action,undo) {
    var id = jQuery(item).attr('id').substring(0,jQuery(item).attr('id').indexOf('_'));
    if( isUserAction[id][Math.floor(action/2)] == true )
        return;
    updateCounter(id,action,undo);
    isUserAction[id][Math.floor(action/2)] = true;
    changeUserButtons(id,item);
    var interval = setInterval("articleActionBlink('" 
        + jQuery(item).attr('id') + "');",250);
    jQuery.post(jableDir + '_article_action.php',{id:id,action:action,undo:undo},function() {
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
            if( jQuery('#' + id + '_vote_up_archive_' + (archiveTable-1) + '_active').is(':visible') ) {
                iterateCounter('#' + id + '_up_vote_count',false);
                jQuery('#' + id + '_vote_up_archive_' + (archiveTable-1) + '_active').hide();
                jQuery('#' + id + '_vote_up_archive_' + (archiveTable-1)).show();
            }
        } else if( undo == false && action == 1 ) {
            iterateCounter('#' + id + '_up_vote_count',true);
            if( jQuery('#' + id + '_vote_down_archive_' + (archiveTable-1) + '_active').is(':visible') ) {
                iterateCounter('#' + id + '_down_vote_count',false);
                jQuery('#' + id + '_vote_down_archive_' + (archiveTable-1) + '_active').hide();
                jQuery('#' + id + '_vote_down_archive_' + (archiveTable-1)).show();
            }
        }
    }
    function iterateCounter(id,up) {
        var org = parseInt( jQuery(id).text(), 10 );
        if( up ){
            jQuery(id).text( ( org + 1 ) );
            jQuery(id + '_active').text( ( org + 1 ) );
        }else{            
            jQuery(id).text( ( org - 1 ) );
            jQuery(id + '_active').text( ( org - 1 ) );
        }
            
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
    function changeUserButtons(id,item) {
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
var lastUpdate = null;
var archiveTable = 1;
function getNewsJSON() {
    jQuery.get(jableDir + '_get_news.php',function(outcome) {
        jQuery('#first_loading').remove();
        jQuery('#news_article_left').html('');
        jQuery('#news_article_right').html('');
        var parse = jQuery.parseJSON(outcome);
        if( lastUpdate != null && lastUpdate == parse )
            return;
        lastUpdate = parse;
        var json = parse.news;
        if(json.length == 0){
            setTimeout('getNewsJSON()', 30000);
            return;
        }

        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false);
            if( archiveTable > 1 )
                jQuery('#archive').find('div[class="right_row"]').css('width', jQuery('#archive').css('width'));
            else
                jQuery('#archive').find('div[class="right_row"]').css('width', 'auto');
            
            if( i < 14 )
                jQuery('#news_article_left').append( getNewsArticle(json[i], archiveTable) );
            else if( i < 14 )
                jQuery('#news_article_right').append( getNewsArticle(json[i], archiveTable) );
            else{
                jQuery('#archive').append( addNewsLink(json[i], archiveTable) );
            }
                
        }
        setUserClicked(parse.cookies.Up_Vote,'_vote_up_archive_'+archiveTable,true);
        setUserClicked(parse.cookies.Down_Vote,'_vote_down_archive_'+archiveTable,true);
        setUserClicked(parse.cookies.Report_Count,'_report',false);
        
        if( archiveTable > 1 ){
            updateRight(archiveTable);
        }
        archiveTable++;
    });
    function setUserClicked(json,str,isVote) {
        for( var i = 0 ; i < json.length ; i++ ) {
            if( json[i] != '' ) {
                jQuery('#' + json[i] + str).hide();
                jQuery('#' + json[i] + str + '_active').show();
                if( isVote ) {
                    jQuery('#' + json[i] + str + '_extra').hide();
                    jQuery('#' + json[i] + str + '_extra_active').show();
                }
            }
        }
    }
    function getNewsArticle(json,datatype) {
        alert(json.imgwidth);
        var template = newsSmallTemplate;
        if( json.imgwidth > 300 )
            template = newsBigTemplate;
        else if( json.imgwidth > 150 )
            template = newsMediumTemplate
        var icon_hide = 'visible';
        if( json.Icon == 'undef' )
            icon_hide = 'hidden';
        return template.replace(/{title}/g,json.Title.replace(/'/g, "´"))
                            .replace(/{down}/g,json.Down_Vote)
                            .replace(/{up}/g,json.Up_Vote)
                            .replace(/{clicks}/g,json.Clicks)
                            .replace(/{host}/g,json.host)
                            .replace(/{description}/g,json.Description)
                            .replace(/{image}/g,json.Image)
                            .replace(/{icon}/g,json.Icon)
                            .replace(/{URL}/g,json.URL)
                            .replace(/{icon_hide}/g,icon_hide)
                            .replace(/{datatype}/g,'archive_' + datatype)
                            .replace(/{id}/g,json.newsID);
    }
    
    
    
    function addNewsLink(json,datatype) {
        var title = '';
        if( json.Title.length < 60 )
            title = json.Title;
        else
            title = json.Title.substring(0,55) + ' ...';

        return newsRightTemplate.replace(/{title}/g,title.replace(/'/g, "´"))
                                .replace(/{down}/g,json.Down_Vote)
                                .replace(/{up}/g,json.Up_Vote)
                                .replace(/{clicks}/g,json.Clicks)
                                .replace(/{description}/g,json.Description)
                                .replace(/{URL}/g,json.URL)
                                .replace(/{host}/g,json.host)
                                .replace(/{datatype}/g,'archive_' + datatype)
                                .replace(/{image}/g,json.Image)
                                .replace(/{id}/g,json.newsID);
    }
}

