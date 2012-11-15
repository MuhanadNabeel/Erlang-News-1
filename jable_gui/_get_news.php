<?php
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$result = $sql->sqlQuery("SELECT *, ((clicks+up_vote-down_vote) * 100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 + 2),1.5)) score from ernews_news order by score");
$outcome = Array();
while( ($row = mysql_fetch_array($result)) !== FALSE ) {
    $purl = parse_url($row['URL']);
    $row['host'] = $purl['host'];
    $outcome[] = $row;
}

if( class_exists('User') === FALSE )
    include 'User.php';

echo json_encode(Array('cookies'=>User::getUserClickList(),'news'=>$outcome));

//echo json_encode ( $outcome );
?>
