<?php
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$result = $sql->sqlQuery("SELECT * FROM ernews_news LIMIT 30");
$outcome = Array();
while( ($row = mysql_fetch_array($result)) !== FALSE ) {
    $outcome[] = $row;
}

if( class_exists('User') === FALSE )
    include 'User.php';

echo json_encode(Array('cookies'=>User::getUserClickList(),'news'=>$outcome));

//echo json_encode ( $outcome );
?>
