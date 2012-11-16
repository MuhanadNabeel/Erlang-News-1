<?php  
/*  
Plugin Name: News page  
Plugin URI:
Description: News page plugin 
Version: 1.0  
Author: Philip Masek  
Author URI:   
License:  
*/ 

add_action('admin_menu', 'add_menu_pages');

function add_menu_pages() {
    add_menu_page('News settings', 'News Settings', 8, 'news_menu', 'add_articles_page');
//    add_submenu_page('news_menu', 'Edit articles', 'Edit articles', 8,  'news_menu' , 'add_articles_page');
//    add_submenu_page('news_menu', 'Statistics', 'Statistics', 8, 'statistics' , 'statistics_page');
}

function add_articles_page() {
    include 'edit-articles.php';
}

function statistics_page() {
	echo "Great";
    /*Include your PHP file here for the statistics page if needed*/
}
?>