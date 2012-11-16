<?php

$array = @getimagesize($_GET['url']);
echo $array[0] . '|' . $array[1];
//print_r( $array );
?>
