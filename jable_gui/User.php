<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of User
 *
 * @author Ingimar
 */
class User {
    
    public static $db_fields = Array('Down_Vote','Up_Vote','Report_Count','Clicks','LastClicked');
/*    
    public static function isCookie() {
        if( is_null( @$_COOKIE['er1new5'] ) === TRUE )
            return false;
        else
            return true;
    }
    
    public static function setCookie() {
        if( User::isCookie() )
            return;
        
        $value = '';
        for( $i = 0 ; $i < 50 ; $i++ ) {
            $value .= '' . chr( rand(48, 125) );
        }
        setcookie('er1new5', $value, 1000*60*60*24*365, '');
    }
    
    public static function getCookie() {
        return @$_COOKIE['er1new5'];
    }
 * 
 */
    
    public static function getUserClickList() {
        $array = Array();
        for( $i = 0 ; $i < count(User::$db_fields) ; $i++ ) {
            $array[User::$db_fields[$i]] = explode( ':', User::getUsersCookie($i) );
        }
        return $array;
    }
    
    private static function isCookie($cookie,$id) {
        if( is_null( @$_COOKIE[$cookie] ) === TRUE )
            return FALSE;
        if( strpos( @$_COOKIE[$cookie], ':' . $id ) === FALSE )
            return FALSE;
        
        
        return TRUE;
    }
    
    private static function hasUserClickedBefore($field_index,$id) {
        if( $field_index < 2
                && (User::isCookie('er1new5->' . User::$db_fields[0],$id) === TRUE 
                    || User::isCookie('er1new5->' . User::$db_fields[1],$id) === TRUE) )
            return TRUE;
        else if( $field_index > 1 && User::isCookie('er1new5->' . User::$db_fields[$field_index],$id) === TRUE )
            return TRUE; 
        return FALSE;
    }
    
    private static function getUsersCookie($field_index) {
        if( is_null(@$_COOKIE['er1new5->' . User::$db_fields[$field_index]]) )
            return '';
        return @$_COOKIE['er1new5->' . User::$db_fields[$field_index]];
    }
    
    private static function isUpOrDownVote($id) {
        echo $id;
        if( User::isCookie('er1new5->' . User::$db_fields[0],$id) )
            return 0;
        if( User::isCookie('er1new5->' . User::$db_fields[1],$id) )
            return 1;
        return -1;
    }
    
    public static function undoActionArticle($id,$field_index) {   
        // Because user can vote either up or down, not both.
        // This may be removed with current implementation, 
        // lets see if it will be in the final impl.
        if( $field_index < 2 )
            $field_index = User::isUpOrDownVote ($id);        
        if( $field_index == -1 )
            return;
        if( User::hasUserClickedBefore($field_index,$id) === FALSE )
            return;
        echo $field_index;
        $cookie = User::getUsersCookie($field_index);
        User::actionArticleTable($id, $field_index, -1);
        setcookie('er1new5->' . User::$db_fields[$field_index], 
                str_replace(':' . $id, '', $cookie),  time()+60*60*24*365);
    }
    
    public static function actionArticle($id,$field_index) {
        if( User::hasUserClickedBefore($field_index,$id) )
            return;       
        $cookie = User::getUsersCookie($field_index);
        
        setcookie('er1new5->' . User::$db_fields[$field_index], 
                $cookie . ':' . $id, time()+60*60*24*365);        
        User::actionArticleTable($id,$field_index,1);
    }
    
    private static function actionArticleTable($id,$field_index,$int) {
        if( class_exists('MySQL') === FALSE )
            include 'MySQL.php';
        $sql = new MySQL();
        
        $state = $sql->sqlQuery("SELECT " . User::$db_fields[$field_index] 
                . " FROM ernews_news WHERE newsID = " . $id);
        $sql->sqlQuery("UPDATE ernews_news SET " . User::$db_fields[$field_index] 
                . " = " . (mysql_fetch_array($state)[User::$db_fields[$field_index]] + $int) 
                . " WHERE newsID = " . $id ); 
        
        if( $field_index == 3 )
            $sql->sqlQuery("UPDATE ernews_news SET "  . User::$db_fields[4] 
                    . " = '" . date('Y-m-d H:i:s') . "' WHERE newsID = " . $id);
    }
    
}

?>
