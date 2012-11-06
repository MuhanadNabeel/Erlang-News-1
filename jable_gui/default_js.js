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
function getNewsJSON() {
    $.get('_get_news.php',function(outcome) {
        var json = jQuery.parseJSON(outcome);
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
    });
}

function getNewsArticle(json) {
    var image = json.Image;
    if( image.length < 10 )
        image = 'http://www.erlang-services.com/images/erlang_studiok.bmp';
    return newsTemplate.replace('$title',json.Title)
                        .replace('$description',json.Description)
                        .replace('$image',image)
                        .replace('$URL',json.URL);
}

function addNewsLink(json) {
    var title = '';
    if( json.Title.length < 60 )
        title = json.Title;
    else
        title = json.Title.substring(0,55) + ' ...';

    return newsRightTemplate.replace('$title',title)
                            .replace('$URL',json.URL);
}

