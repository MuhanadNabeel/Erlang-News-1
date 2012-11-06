var newsTemplate = '';
var newsRightTemplate = '';
$(document).ready(function() {
    $.get('_get_templates.php',function(str){
        var split = str.split('<split_between_templates>')
        newsRightTemplate = split[0];
        newsTemplate = split[1];
        getNewsJSON();
    });
});

function articleAction(item,action,undo) {
    var id = $(item).attr('id').substring(0,$(item).attr('id').indexOf('_'));
    $.get('_article_action.php',{id:id,action:action,undo:undo},function(tmp) {
        if( ( action == 0 || action == 1 ) && undo == false ) {
            $('#' + id + '_vote_down').hide();
            $('#' + id + '_vote_up').hide();
            $('#' + id + '_vote_undo').show();
        }
        else if( action == 0 || action == 1 ) {
            $('#' + id + '_vote_down').show();
            $('#' + id + '_vote_up').show();
            $('#' + id + '_vote_undo').hide();
        }
        alert(tmp);
    });
}

function getNewsJSON() {
    $.get('_get_news.php',function(outcome) {
        var parse = jQuery.parseJSON(outcome);
        var json = parse.news;
        for( var i = 0 ; i < json.length ; i++ ) {
            // URL, image, description, title, PubDate
            if( i < 10 && i % 2 == 0 )
                $('#news_article_left').append( getNewsArticle(json[i]) );
            else if( i < 10 )
                $('#news_article_right').append( getNewsArticle(json[i]) );
            else 
                $('#archive').append( addNewsLink(json[i]) );
        }
        $('#joe').append('</tr><table>');
        setUserVoted(parse.cookies.Up_Vote);
        setUserVoted(parse.cookies.Down_Vote);
    });
}

function setUserVoted(json) {
    for( var i = 0 ; i < json.length ; i++ ) {
        if( json[i] != '' ) {
            $('#' + json[i] + '_vote_down').hide();
            $('#' + json[i] + '_vote_up').hide();
            $('#' + json[i] + '_vote_undo').show();
        }
    }
}

function getNewsArticle(json) {
    return newsTemplate.replace('{title}',json.Title)
                        .replace('{description}',json.Description)
                        .replace('{image}',json.Image)
                        .replace('{URL}',json.URL)
                        .replace(/{id}/g,json.newsID);
}

function addNewsLink(json) {
    var title = '';
    if( json.Title.length < 60 )
        title = json.Title;
    else
        title = json.Title.substring(0,55) + ' ...';

    return newsRightTemplate.replace('{title}',title)
                            .replace('{URL}',json.URL)
                            .replace(/{id}/g,json.newsID);
}

