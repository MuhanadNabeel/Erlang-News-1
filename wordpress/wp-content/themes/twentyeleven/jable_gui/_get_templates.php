<?php
$URL = @$_GET["jableurl"];
// 0
include 'rightnews_template.php';
echo '<split_between_templates>';
// 1
include 'big_template.php';
echo '<split_between_templates>';
// 2
include 'medium_template.php';
echo '<split_between_templates>';
// 3
include 'small_template.php';
echo '<split_between_templates>';
// 4
include 'latest_img_template.php';
echo '<split_between_templates>';
// 5
include 'latest_template.php';
echo '<split_between_templates>';
// 6
include 'twitter_template.php';
?>
