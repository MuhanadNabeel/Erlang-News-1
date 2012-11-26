<?php
$URL = @$_GET["jableurl"];
include 'rightnews_template.php';
echo '<split_between_templates>';
include 'big_template.php';
echo '<split_between_templates>';
include 'medium_template.php';
echo '<split_between_templates>';
include 'small_template.php';
echo '<split_between_templates>';
include 'latest_img_template.php';
echo '<split_between_templates>';
include 'latest_template.php';
echo '<split_between_templates>';
include 'archive_button.php';
?>
