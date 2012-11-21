var $holder;
var $data;

function openTest(){
                alert('lol');
}
function openUpStuff(id){
    jQuery('#'+id+'_expand').slideToggle('400');
}

jQuery(document).ready(function() {
    
    // get the action filter option item on page load
    $holder = jQuery('#archive');
    $data = $holder.clone();

    /*var $filteredData = $data.find('li[data-type=type1]');
        $holder.quicksand($filteredData, {
            duration: 0});*/

})

function animate(id){
//    alert();
    closeAllStuff(function(){
        var $filteredData = $data.find('li[data-type=right_archive_'+id+']');
        $holder.quicksand($filteredData, {
            duration: 700,
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
        easing: 'swing'});*/
 }

function updateRight(id){
    $data = $holder.clone();                
    var $filteredData = $data.find('li[data-type=right_archive_'+(id-1)+']');
    $holder.quicksand($filteredData, {
        duration: 0,
        easing: 'swing'},function(){
 /*           if(id > 2){
                $data.find('li[data-type=right_archive_'+(id-2)+']').empty();
            }*/
        });
    
        
    
    animate(id);
    
}

function closeAllStuff(cbFunc){
    t = jQuery('#archive').find('div[class="right_content"]');
    a = t.filter(function(){
        return (jQuery(this).is(':visible'));
    })
    a.slideUp('400', cbFunc);
 }

 function openBox(URL, title, id, datatype){
    jQuery.get("<?php echo bloginfo('template_directory') ?>/jable_gui/redirect.php", {id:id});

    buttons = jQuery("#"+id+"_all_vote_buttons").clone();
    buttons.css('display', 'block');
    jQuery('#box-vote-buttons').append(buttons);
    jQuery('#box_title').html("<a class='box_title' target='_blank' style='text-decoration:none;' href='"+URL+"'>"+title+"</a>");
    jQuery('#frame_content').attr('src', URL);
    jQuery('#bigframe').css('display', 'block');
 }

 function closeBox(){
    jQuery('#box-vote-buttons').empty();
    jQuery('#bigframe').css('display', 'none');
    jQuery('#frame_content').attr('src', '');
 }