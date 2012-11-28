/**
 * @author Ingimar Samuelsson
 * @doc
 *  Content-display and User-interaction
 * @end
 */
var isUserAction = new Object();
var duplicateArray = new Array('hot','latest','top','view');
var actionArray = new Array('votedown','voteup','report')
var articleTemplates;

/**
 * @author Ingimar Samuelsson
 * @doc
 *  When the page loads; get article templates
 *  and call article information fetcher
 * @end
 */
jQuery(document).ready(function() {
    jQuery('#rightside').hide();
    jQuery('#first_loading').html('<img src="' + jableDir 
        + '/custom-img/loading.gif">');
    jQuery.get(jableDir +'_get_templates.php',{jableurl:jableDir},function(str){
        articleTemplates = str.split('<split_between_templates>');
        getNewsJSON();
    });

});

/**
 * @author Ingimar Samuelsson
 * @doc
 *  User-interaction. User clicks buttons, images are swapped
 *  and information is changed in the database and users cookies
 * @end
 */
function articleAction(item,action,undo) {
    var id = jQuery(item).attr('id').split('_')[1];
    if( isUserAction[id][Math.floor(action/2)] == true )
        return;
    updateCounter(id,action,undo);
    isUserAction[id][Math.floor(action/2)] = true;
    changeUserButtons(item,id);
    jQuery.post(jableDir + '_article_action.php',
            {id:id,action:action,undo:undo},function() {
        isUserAction[id][Math.floor(action/2)] = false;
    });
    function updateCounter(id,action,undo) {
        for( var i = 0 ; i < duplicateArray.length ; i++ ) {
            if( jQuery('#' + duplicateArray[i] + '_' + id + '_' + actionArray[0] 
                    + '_count').length != 0 ) {
                if( undo == true && action == 0 )
                    iterateCounter('#' + duplicateArray[i] + '_' + id + '_' 
                        + actionArray[0] + '_count',false);
                else if( undo == true && action == 1 )
                    iterateCounter('#' + duplicateArray[i] + '_' + id + '_' 
                        + actionArray[1] + '_count',false);
                else if( undo == false && action == 0 ) {
                    iterateCounter('#' + duplicateArray[i] + '_' + id + '_' 
                        + actionArray[0] + '_count',true);
                    if( jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                                + actionArray[1] + '_active').is(':visible') ) {
                        iterateCounter('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[1] + '_count',false);
                        jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[1] + '_active').hide();
                        jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[1]).show();
                    }
                } else if( undo == false && action == 1 ) {
                    iterateCounter('#' + duplicateArray[i] + '_' + id + '_' 
                        + actionArray[1] + '_count',true);
                    if( jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[0] + '_active').is(':visible') ) {
                        iterateCounter('#' + id + '_' + actionArray[0] 
                            + '_count',false);
                        jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[0] + '_active').hide();
                        jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + actionArray[0]).show();
                    }
                }
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
    function changeUserButtons(item,id) {
        var htmlID = jQuery(item).attr('id');
        var action = htmlID.split('_')[2];
        var contrAction = actionArray[0];
        if( action == actionArray[0] )
            contrAction = actionArray[1];
        for( var i = 0 ; i < duplicateArray.length ; i++ ) {
            if( jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                    + action).length != 0 ) {
                if( htmlID.indexOf('_active') != -1 ) {
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + action + '_active' ).hide();
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + action).show();
                }
                else {
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + action).hide();
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + action + '_active' ).show();
                }
                if( jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                            + contrAction + '_active' ).is(':visible') ) {
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + contrAction + '_active' ).hide();
                    jQuery('#' + duplicateArray[i] + '_' + id + '_' 
                        + contrAction).show();
                }
            }
        }
    }
}
var updatingArticles = false;
var offsetArticles = 0;
var limitArticles = 20;
var articleJSON = new Array();
/**
 * @author Ingimar Samuelsson
 * @doc
 *  Fetches informations related to articles in JSON format
 *  and adds to HTML DOM
 * @end
 */
function getNewsJSON() {
    updatingArticles = true;
    jQuery('#first_loading').show();
    fillRightSide('top',2);
    fillRightSide('latest',1)
    jQuery.get(jableDir + '_get_news.php',{query:'main',
            offset:offsetArticles,limit:limitArticles},function(outcome) {
        jQuery('#first_loading').hide();
        if( offsetArticles == 0 )
            jQuery('#rightside').show();
        var parse = jQuery.parseJSON(outcome);
        var json = parse.news;
        articleJSON[0] = json;
        if( json.length == 0 ){
            setTimeout('getNewsJSON()', 10000);
            return;
        }
        offsetArticles += limitArticles;

        var leftArc = 1;
        var rightArc = 0;

        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false);
            var template = articleTemplates[3];
            if( json[i].imgwidth > 350 )
                template = articleTemplates[1];
            else if( json[i].imgwidth > 120 )
                template = articleTemplates[2]
            if( i == 0 && offsetArticles == 0 )
                jQuery('#top_hot_news').html( getArticle(json[i], 
                    template, 0 ) );
            else if( leftArc < rightArc )
                jQuery('#news_article_left').append( getArticle(json[i], 
                    template, 0 ) );
            else
                jQuery('#news_article_right').append( getArticle(json[i], 
                    template, 0 ) );
            
            leftArc = jQuery('#news_article_left').height();
            rightArc = jQuery('#news_article_right').height();
        }
        setUserClicked(parse.cookies.Up_Vote,actionArray[1],true);
        setUserClicked(parse.cookies.Down_Vote,actionArray[0],true);
        setUserClicked(parse.cookies.Report_Count,actionArray[2],false);
        updatingArticles = false;
    });
    function fillRightSide(location,index) {
        jQuery.get(jableDir + '_get_news.php',{query:location,limit:5},function(outcome) {
            var parse = jQuery.parseJSON(outcome);
            var json = parse.news;
            articleJSON[index] = json;
            jQuery('#' + location + '_news').html('');
            for( var i = 0 ; i < json.length ; i++ ) {
                isUserAction[json[i].newsID] = Array(false,false);
                var template = articleTemplates[4];
                if( json[i].Image == 'undef' )
                    template = articleTemplates[5];
                jQuery('#' + location + '_news').append( getArticle(json[i], 
                    template, index ) );

            }
        });        
    }
    function setUserClicked(json,str,isVote) {
        for( var i = 0 ; i < json.length ; i++ ) {
            if( json[i] != '' ) {
                for( var k = 0 ; k < duplicateArray.length ; k++ ) {
                    jQuery('#' + duplicateArray[k] + '_' + json[i] + '_' 
                        + str).hide();
                    jQuery('#' + duplicateArray[k] + '_'  + json[i] + '_' 
                        + str + '_active').show();
                    if( isVote ) {
                        jQuery('#' + duplicateArray[k] + '_'  + json[i] + '_' 
                            + str + '_extra').hide();
                        jQuery('#' + duplicateArray[k] + '_'  + json[i] + '_' 
                            + str + '_extra_active').show();
                    }
                }
            }
        }
    }
    function getArticle(json,template,arrayIndex) {
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
                            .replace(/{id}/g,json.newsID)
                            .replace(/{index}/g,arrayIndex)
                            .replace(/{location}/g,duplicateArray[arrayIndex])
                            .replace(/{action0}/g,actionArray[0])
                            .replace(/{action1}/g,actionArray[1])
                            .replace(/{action2}/g,actionArray[2])
                            .replace(/{pubdate}/g,json.Pubdate.split(' ')[0])
                            .replace(/{imgwidth}/g,(json.imgwidth/2))
                            .replace(/{imgheight}/g,(json.imgheight/2));
    }
}
/**
 * @author Ingimar Samuelsson
 * @doc
 *  Get more articles when user gets to the bottom of page
 * @end
 */
$(window).scroll(function() {
    if($(window).scrollTop()+100 >= ($(document).height() - 
            ($(window).height())) && updatingArticles == false )
        getNewsJSON();
});
