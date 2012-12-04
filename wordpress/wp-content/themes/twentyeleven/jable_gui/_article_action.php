<?php
if( class_exists('User') === FALSE )
    include 'User.php';
if( $_GET['undo'] === 'true' )
    User::undoActionArticle($_GET['id'], intval($_GET['action']) );
else
    User::actionArticle($_GET['id'], intval($_GET['action']) );
?>
