/**
 * @author Philip Masek
 * @doc
 *  Content-display and User-interaction
 * @end
 */
var $holder;
var $data;


var $id;
/**
 * @author Philip Masek
 * @doc
 *  Function opens up the
 *  divs on the right column
 *  such as: Latest news
 *  and All time top.
 * @end
 */
function openUpStuff(id,index){
    if($id!=id)
        closeLastOne();
    
    jQuery('#'+duplicateArray[index]+'_'+id+'_expand').slideToggle('medium');


    $id = id;
}
/**
 * @author Philip Masek
 * @doc
 *  Closes the last opened
 *  div in right column
 *  when opening another.
 * @end
 */
function closeLastOne(cbFunc){
    t = jQuery('.right-column').find('div[class="right_content"]');
    a = t.filter(function(){    
        return jQuery(this).is(':visible');
    });
    a.slideUp('medium');
 }

jQuery(document).ready(function() {
    $holder = jQuery('#archive').clone();

    jQuery(window).bind('keyup',function(e){
        if(e.which==27 && jQuery('#bigframe').css('display') != 'none'){
            closeBox();
        }
    });
})

/**
 * @author Philip Masek
 * @doc
 *  Used for the reportbutton
 *  alert.
 * @end
 */

function fadeWindow(id, text){
    jQuery('#'+id+'_text').html(text);
    jQuery('#'+id).fadeIn('slow', function(){
        setTimeout("jQuery('#"+id+"').fadeOut('medium')", 2000);
        
    });
}

/**
 * @author Philip Masek
 * @doc
 *  This function is unused.
 *  When in use it animates
 *  the ranking of the news.
 *  When something is voted
 *  up it animates further
 *  up the page.
 * @end
 */
/*
function animate(id){
    closeAllStuff(function(){
        var $filteredData2 = $data.find('li[data-type=right_archive_'+id+']');
        $holder.quicksand($filteredData2, {
            duration: 800,
            easing: 'swing'},
            function(){
                jQuery('#archive').find('div[class="right_row"]').css('width', 'auto');
            });


    });
    
/*
    jQuery('#article_container').css('width', jQuery('#news_article_left').css('width'));
    jQuery('#newsTemp').css('width', '100px');

    var $filteredData1 = $data1.find('li[data-type=left_archive_'+id+']');
    $holder1.quicksand($filteredData1, {
        duration: 1000,
         easing: 'swing'});

    var $filteredData2 = $data2.find('li[data-type=left_archive_'+id+']');
    $holder2.quicksand($filteredData2, {
        duration: 1000,
        easing: 'swing'});
 }*/

function fadeStuffIn(id){
    jQuery('#'+id+'_test_top').animate({opacity : '1.0'}, 'slow');
    jQuery('#'+id+'_test_bottom').animate({opacity : '1.0'}, 'slow');
}

/**
 * @author Philip Masek
 * @doc
 *  Another part of the 
 *  ranking-animation.
 * @end
 */
/*
function updateRight(id){
    $data = $holder.clone();
    var $filteredData1 = $data.find('li[data-type=right_archive_'+(id-1)+']');
    $holder.quicksand($filteredData1, {
        duration: 0,
        easing: 'swing'},function(){
            if(id > 2){
//                $data.find('li[data-type=right_archive_'+(id-2)+']').empty();
            }
        });
    
        
    
    animate(id);
    
}*/

/**
 * @author Philip Masek
 * @doc
 *  Was used in ealier version.
 *  A div behind everything would
 *  appear when everything slides
 *  to the left.
 * @end
 */
/*
function slideLeft(){

    if(jQuery('#main_div').css('margin-left')=='0px')
        jQuery('#main_div').animate({
            marginLeft: '-=25%'
        }, 500);
    else
        jQuery('#main_div').animate({
            marginLeft: '0px'
        }, 500);
}*/

/**
 * @author Philip Masek
 * @doc
 *  Closes all the divs 
 *  in the right column.
 * @end
 */
function closeAllStuff(cbFunc){
    t = jQuery('#archive').find('div[class="right_content"]');
    a = t.filter(function(){
        return (jQuery(this).is(':visible'));
    })
    if(a.size()==0)
        cbFunc();
    else
        a.slideUp('slow', function(){setTimeout(cbFunc(),2000,lang)});
 }

/**
 * @author Philip Masek
 * @doc
 *  Opens up the popup
 *  windows with the 
 *  selected news. Locks
 *  the unused scrollbar
 *  also.
 * @end
 */
  function openBox(id,index){
    document.body.scroll = "no";
    document.body.style.overflow = 'hidden';
    document.height = window.innerHeight;

    var json = articleJSON[index];  
    index = -1;
    for( var i = 0 ; i < json.length ; i++ ) {
        if( id == json[i].newsID ) {
            index = i;
            i = json.length-1;
        }
    }
    if( index == -1 ) {
        alert('Page not found');
        return;
    }
    json = json[index];
    jQuery.get(jableDir + 'article_action.php',{id:json.newsID,
                undo:false,action:3});

    var buttons =  '                            <table>'
                 + '              <tr>'
                 + '                  <td>'
                 + '                      <div id="' + duplicateArray[3] + '_' 
                 + json.newsID + '_' + actionArray[1] 
                 + '" class="thumb-up-shadowed" '
                 + 'onclick="articleAction(this,1,false);"></div>'
                 + '                      <div id="' + duplicateArray[3] 
                 + '_' + json.newsID + '_' + actionArray[1] 
                 + '_active" class="thumb-up-active-shadowed" '
                 + 'onclick="articleAction(this,1,true);"></div>'
                 + '                  </td>'
                 + '                  <td>'
                 + '                      <div id="' + duplicateArray[3] 
                 + '_' + json.newsID + '_' + actionArray[0] 
                 + '" class="thumb-down-shadowed" '
                 + 'onclick="articleAction(this,0,false);"></div>'
                 + '                      <div id="' + duplicateArray[3] 
                 + '_' + json.newsID + '_' + actionArray[0] 
                 + '_active" class="thumb-down-active-shadowed" '
                 + 'onclick="articleAction(this,0,true);"></div>'
                 + '                  </td>'
                 + '              </tr>'
                 + '          </table>';
    jQuery('#box-vote-buttons').append(buttons);
    jQuery('#box_title').html("<a class='box_title' target='_blank' "
        + "style='text-decoration:none;' href='" + json.URL + "'>" 
        + json.Title + "</a>");
    jQuery('#frame_content').attr('src', json.URL);
    jQuery('#bigframe').show();
    if( jQuery('#' + duplicateArray[0] + '_' + json.newsID + '_' 
                + actionArray[1] + '_active').is(':visible') ) {
        jQuery('#' + duplicateArray[3] + '_' + json.newsID + '_' 
            + actionArray[1]).hide();
        jQuery('#' + duplicateArray[3] + '_' + json.newsID + '_' 
            + actionArray[1] + '_active').show();
    }
    else if( jQuery('#' + duplicateArray[0] + '_' + json.newsID + '_' 
                + actionArray[0] + '_active').is(':visible') ) {
        jQuery('#' + duplicateArray[3] + '_' + json.newsID + '_' 
            + actionArray[0]).hide();
        jQuery('#' + duplicateArray[3] + '_' + json.newsID + '_' 
            + actionArray[0] + '_active').show();
    }
 }

/**
 * @author Philip Masek
 * @doc
 *  Old version of openBox().
 * @end
 */
/*
 function openBox(URL, title, id, datatype){
     alert(URL);
     return;
    jQuery.get(jableDir + '_count_clicks.php',{id:id});

    var buttons =  '                            <table>'
                 + '              <tr>'
                 + '                  <td>'
                 + '                      <div id="' + duplicateArray[3] + '_' + id + '_' + actionArray[1] + '" class="thumb-up-shadowed" onclick="articleAction(this,1,false);"></div>'
                 + '                      <div id="' + duplicateArray[3] + '_' + id + '_' + actionArray[1] + '_active" class="thumb-up-active-shadowed" onclick="articleAction(this,1,true);"></div>'
                 + '                  </td>'
                 + '                  <td>'
                 + '                      <div id="' + duplicateArray[3] + '_' + id + '_' + actionArray[0] + '" class="thumb-down-shadowed" onclick="articleAction(this,0,false);"></div>'
                 + '                      <div id="' + duplicateArray[3] + '_' + id + '_' + actionArray[0] + '_active" class="thumb-down-active-shadowed" onclick="articleAction(this,0,true);"></div>'
                 + '                  </td>'
                 + '              </tr>'
                 + '          </table>';

    //buttons = jQuery("#"+id+"_all_vote_buttons").clone();
    //buttons.css('display', 'block');
    jQuery('#box-vote-buttons').append(buttons);
    jQuery('#box_title').html("<a class='box_title' target='_blank' style='text-decoration:none;' href='"+URL+"'>"+title+"</a>");
    jQuery('#frame_content').attr('src', URL);
    jQuery('#bigframe').fadeIn();
    if( jQuery('#' + duplicateArray[0] + '_' + id + '_' + actionArray[1] + '_active').is(':visible') ) {
        jQuery('#' + duplicateArray[3] + '_' + id + '_' + actionArray[1]).hide();
        jQuery('#' + duplicateArray[3] + '_' + id + '_' + actionArray[1] + '_active').show();
    }
    else if( jQuery('#' + duplicateArray[0] + '_' + id + '_' + actionArray[0] + '_active').is(':visible') ) {
        jQuery('#' + duplicateArray[3] + '_' + id + '_' + actionArray[0]).hide();
        jQuery('#' + duplicateArray[3] + '_' + id + '_' + actionArray[0] + '_active').show();
    }
 }
*/

/**
 * @author Philip Masek
 * @doc
 *  Closes the popup window 
 *  and reactivates the scroll.
 * @end
 */
 function closeBox(){
    document.body.scroll = "yes";
    document.body.style.overflow = 'visible';
    document.height = window.innerHeight;
    jQuery('#box-vote-buttons').empty();
    jQuery('#bigframe').css('display', 'none');
    jQuery('#frame_content').attr('src', '');
 }