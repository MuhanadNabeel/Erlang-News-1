<?php
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$result = $sql->sqlQuery("SELECT *, ((clicks+up_vote-down_vote) * 100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 + 2),1.5)) score from ernews_news order by score DESC");
$outcome = Array();
while( ($row = mysql_fetch_array($result)) !== FALSE ) {
    $purl = parse_url($row['URL']);
    $row['host'] = $purl['host'];
    $row['Icon'] = getAbsolutePath($row['Icon'],$row['URL']);
    $image = explode('|', $row['Image']);
    $row['Image'] = $image[0];
    $imageRatio = explode('*', $row['Image']);
    $row['Image'] = getAbsolutePath($row['Image'],$row['URL']);
    $row['imgwidth'] = $imageRatio[0];
    $row['imgheight'] = $imageRatio[1];
    $outcome[] = $row;
}

if( class_exists('User') === FALSE )
    include 'User.php';

echo json_encode(Array('cookies'=>User::getUserClickList(),'news'=>$outcome));

function getAbsolutePath($path,$url) {
    if( $path !== 'undef' && substr($path, 0, 4) !== 'http' && substr($path, 0, 1) === '/' ) {
        $parse_url = parse_url($url);
        $host = $parse_url['host'];
        return 'http://' . $host . $path;
    } else if( $path !== 'undef' && substr($path, 0, 4) !== 'http' ) {
        $location = substr( $url, 0, strripos($url, '/') );
        return $location . '/' . $path;
    }
    return $path;
}
?>
