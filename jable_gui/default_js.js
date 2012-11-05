var newsTemplate = '';
$(document).ready(function() {
    $.post('news_template.txt',function(str){
        newsTemplate = str;
        getNewsJSON();
    });
});
function getNewsJSON() {
    $.post('_get_news.php',function(outcome) {
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
    var article = newsTemplate.replace('$title',json.Title)
                    .replace('$description',json.Description)
                    .replace('$image',image);
    return article;
}

function addNewsLink(json) {
    var tmp = '<div>';
    tmp += '<table><tr>';
    tmp += '<td><a href="' + json.URL + '">';

    if( json.Title.length < 60 )
        tmp += json.Title;
    else
        tmp += json.Title.substring(0,55) + ' ...';

    tmp += '</a></td>';
    tmp += '</tr></table>';
    tmp += '</div>';
    return tmp;
}

