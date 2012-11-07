<?php
if( class_exists('User') === FALSE )
    include 'User.php';
if( $_POST['undo'] === 'true' )
    User::undoActionArticle($_POST['id'], intval($_POST['action']) );
else
    User::actionArticle($_POST['id'], intval($_POST['action']) );
?>
