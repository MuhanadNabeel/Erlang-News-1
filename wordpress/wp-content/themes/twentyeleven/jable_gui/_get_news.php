<?php
/**
 * @author Ingimar Samuelsson
 * @doc
 *  Get's jsons with information about articles and user-interaction
 * @end
 */
if(class_exists('MySQL') === FALSE)
    include 'MySQL.php';
$sql = new MySQL();
$not_id = '';
if(is_null($_POST['ids']) === FALSE && strlen($_POST['ids']) > 0 )
    $not_id = 'AND newsID NOT IN (' . $_POST['ids'] . ')';
$queries = Array('latest'
                        =>'SELECT * FROM ernews_news WHERE Report_Count < 5 
                            ORDER BY Pubdate DESC LIMIT 5',
                'main'
                        =>
                        'SELECT *, ((clicks+(2*(up_vote-down_vote))) * 
                        100000/ pow((TIME_TO_SEC(TIMEDIFF(NOW(),pubdate))/3600 
                        + 2),1.5)) score from ernews_news WHERE Report_Count < 5  
                        ' . $not_id .  '
                        order by score DESC LIMIT 20',
                 'top'
                        =>'SELECT *, (Up_Vote+Clicks-Down_Vote) AS Ratio FROM 
                        ernews_news  WHERE Report_Count < 5 
                        ORDER BY Ratio DESC LIMIT 5');
$result = $sql->sqlQuery($queries[ $_POST['query'] ]);
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
