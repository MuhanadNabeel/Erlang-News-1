
<?php 

//add_action('wp_ajax_my_action', 'my_action_callback');

//function my_action_callback() {

    include "MySQL.php";
	$sql = new MySQL();
	$sql -> sqlQuery($_POST["query"] ." ". $_POST["newsID"]);
	die("Success"); // this is required to return a proper result
//}



/*	*/
?>