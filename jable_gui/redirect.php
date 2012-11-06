<?php
if( class_exists('User') === FALSE )
    include 'User.php';
User::actionArticle($_GET['id'], 4);
header('Location:' . $_GET['url']);
?>
