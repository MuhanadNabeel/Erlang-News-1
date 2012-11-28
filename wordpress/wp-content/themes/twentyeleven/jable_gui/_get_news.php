<?php
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$queries = Array('latest'=>'SELECT * FROM ernews_news 
                            ORDER BY Pubdate DESC LIMIT ' . $_GET['limit'],
                'main'=>'SELECT *, ((clicks+up_vote-down_vote) * 
                        100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 
                        + 2),1.5)) score from ernews_news order by score DESC 
                        LIMIT ' . $_GET['limit'] . ' OFFSET ' . $_GET['offset'],
                'hottest'=>'SELECT *, (Up_Vote+Clicks-Down_Vote) AS Ratio FROM 
                    ernews_news ORDER BY Ratio DESC LIMIT ' . $_GET['limit']);
// SELECT *, ((clicks+up_vote-down_vote) * 100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 + 2),1.5)) score from ernews_news order by score DESC
// SELECT * FROM ernews_news ORDER BY Pubdate DESC LIMIT 3;
$result = $sql->sqlQuery($queries[ $_GET['query'] ]);
$outcome = Array();
while( ($row = mysql_fetch_array($result)) !== FALSE ) {
    $purl = parse_url($row['URL']);
    $row['host'] = $purl['host'];
    $row['Icon'] = getAbsolutePath($row['Icon'],$row['URL']);
    if( $row['Image'] !== 'undef' ) {
        $image = explode('|', $row['Image']);
        $row['Image'] = $image[0];
        $imageRatio = explode('*', $image[1]);
        $row['Image'] = getAbsolutePath($row['Image'],$row['URL']);
        $row['imgwidth'] = $imageRatio[0];
        $row['imgheight'] = $imageRatio[1];
    }
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
