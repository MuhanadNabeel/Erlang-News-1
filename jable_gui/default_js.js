var isUserAction = new Object();
var newsTemplate = '';
var newsRightTemplate = '';
$(document).ready(function() {
    $.get('_get_templates.php',function(str){
        var split = str.split('<split_between_templates>')
        newsRightTemplate = split[0];
        newsTemplate = split[1];
        getNewsJSON();
        setInterval('getNewsJSON();',300000);
    });
});

function articleAction(item,action,undo) {
    var id = $(item).attr('id').substring(0,$(item).attr('id').indexOf('_'));
    if( isUserAction[id][action] == true )
        return;
    isUserAction[id][action] = true;
    changeUserButtons(id,item,undo);
    if( undo == false && action < 2 ) {
        $.get('_article_action.php',{id:id,action:action,undo:true},function() {
            $.get('_article_action.php',{id:id,action:action,undo:false},function() {
                isUserAction[action] = false;
                getNewsJSON();
            });
        });
    } else {
        $.get('_article_action.php',{id:id,action:action,undo:undo},function() {
            isUserAction[action] = true;
            getNewsJSON();
        });
    }
}

function changeUserButtons(id,item,undo) {
    if( undo == true )
        $(item).hide();
    else if( $(item).attr('id') == id + '_vote_up' && $('#' + id + '_vote_down_active').is(':visible') ) {
        $('#' + id + '_vote_down_active').hide();
        $('#' + id + '_vote_up_active').show();
    }
    else if( $(item).attr('id') == id + '_vote_down' && $('#' + id + '_vote_up_active').is(':visible') ) {
        $('#' + id + '_vote_up_active').hide();
        $('#' + id + '_vote_down_active').show();
    }
    else
        $( '#' + $(item).attr('id') + '_active').show();
}

function getNewsJSON() {
    $.get('_get_news.php',function(outcome) {
        $('#news_article_left').html('');
        $('#news_article_right').html('');
        $('#archive').html('');
        var parse = jQuery.parseJSON(outcome);
        var json = parse.news;
        for( var i = 0 ; i < json.length ; i++ ) {
            isUserAction[json[i].newsID] = Array(false,false,false);
            if( i < 10 && i % 2 == 0 )
                $('#news_article_left').append( getNewsArticle(json[i]) );
            else if( i < 10 )
                $('#news_article_right').append( getNewsArticle(json[i]) );
            else 
                $('#archive').append( addNewsLink(json[i]) );
        }
        setUserClicked(parse.cookies.Up_Vote,'_vote_up_active');
        setUserClicked(parse.cookies.Down_Vote,'_vote_down_active');
    });
}

function setUserClicked(json,str) {
    for( var i = 0 ; i < json.length ; i++ ) {
        if( json[i] != '' )
            $('#' + json[i] + str).show();
    }
}

function getNewsArticle(json) {
    return newsTemplate.replace('{title}',json.Title)
                        .replace('{down}',json.Down_Vote)
                        .replace('{up}',json.Up_Vote)
                        .replace('{description}',json.Description)
                        .replace('{image}',json.Image)
                        .replace(/{URL}/g,json.URL)
                        .replace(/{id}/g,json.newsID);
}

function addNewsLink(json) {
    var title = '';
    if( json.Title.length < 60 )
        title = json.Title;
    else
        title = json.Title.substring(0,55) + ' ...';

    return newsRightTemplate.replace('{title}',title)
                            .replace('{down}',json.Down_Vote)
                            .replace('{up}',json.Up_Vote)
                            .replace(/{URL}/g,json.URL)
                            .replace(/{id}/g,json.newsID);
}

