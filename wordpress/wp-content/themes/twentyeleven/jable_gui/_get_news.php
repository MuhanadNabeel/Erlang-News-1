<?php
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$result = $sql->sqlQuery("SELECT *, ((clicks+up_vote-down_vote) * 100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 + 2),1.5)) score from ernews_news order by score DESC");
$outcome = Array();
while( ($row = mysql_fetch_array($result)) !== FALSE ) {
    $purl = parse_url($row['URL']);
    $row['host'] = $purl['host'];
    $icon = $row['Icon'];
    if( substr($icon, 0, 4) !== 'http' && substr($icon, 0, 1) === '/' ) {
        $parse_url = parse_url($row['URL']);
        $host = $parse_url['host'];
        $row['Icon'] = $host . $icon;
    } else if( substr($icon, 0, 4) !== 'http' ) {
        $location = substr( $row['URL'], 0, strripos($row['URL'], '/') );
        $row['Icon'] = $location . '/' . $icon;
    }
    $outcome[] = $row;
}

if( class_exists('User') === FALSE )
    include 'User.php';

echo json_encode(Array('cookies'=>User::getUserClickList(),'news'=>$outcome));

?>
