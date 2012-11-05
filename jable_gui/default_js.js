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
        $('#joe').html('<table><tr>');
        for( var i = 0 ; i < json.length ; i++ ) {
            // URL, image, description, title, PubDate
            if( i != 0 && i < 10 && i % 2 == 0 )
                $('#joe').append('</tr><tr>');
            if( i < 10 )
                addNewsArticle(json[i]);
            else 
                addNewsLink(json[i]);
        }
        $('#joe').append('</tr><table>');
    });
}

function addNewsArticle(json) {
    var image = json.Image;
    if( image.length < 10 )
        image = 'http://www.erlang-services.com/images/erlang_studiok.bmp';
    var article = newsTemplate.replace('$title',json.Title)
                    .replace('$description',json.Description)
                    .replace('$image',image);
    $('#joe').append('<td style="width:50%;vertical-align:top;">' + article + '</td>');
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
    $('#archive').append(tmp);
}

