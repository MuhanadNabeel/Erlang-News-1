<?php

/**
 * @author Ingimar Samuelsson
 * @doc
 *  User interaction with database and cookies.
 * @end
 */
class User {
    
    private static $db_fields = Array('Down_Vote','Up_Vote','Report_Count','Clicks','LastClicked');
    private static $cookieStart = 'er1new5_';
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Retrieves lists of newsID that the users has interacted with
     * @end
     */
    public static function getUserClickList() {
        $array = Array();
        for( $i = 0 ; $i < count(User::$db_fields) ; $i++ ) {
            $array[User::$db_fields[$i]] = explode( ':', User::getUsersCookie($i) );
        }
        return $array;
    }
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Checks if newsID is in cookies
     * @end
     */
    private static function isCookie($cookie,$id) {
        if( is_null( @$_COOKIE[$cookie] ) === TRUE )
            return FALSE;
        if( strpos( @$_COOKIE[$cookie], ':' . $id ) === FALSE )
            return FALSE;
        
        
        return TRUE;
    }
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Gets users cookie for specific field
     * @end
     */
    private static function getUsersCookie($field_index) {
        if( is_null(@$_COOKIE[User::$cookieStart . User::$db_fields[$field_index]]) )
            return '';
        return @$_COOKIE[User::$cookieStart . User::$db_fields[$field_index]];
    }
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Undo user action (vote,report)
     * @end
     */
    public static function undoActionArticle($id,$field_index) {   
        if( User::isCookie(User::$cookieStart . User::$db_fields[$field_index],$id) === FALSE )
            return;
        $cookie = User::getUsersCookie($field_index);
        setcookie(User::$cookieStart . User::$db_fields[$field_index], 
                str_replace(':' . $id, '', $cookie),  time()+60*60*24*365,'/');
        User::actionArticleTable($id, $field_index, -1);
    }
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Perform user action (vote,report,click)
     * @end
     */
    public static function actionArticle($id,$field_index) {
        if( User::isCookie(User::$cookieStart . User::$db_fields[$field_index],$id) === TRUE )
            return;
        else if( $field_index == 0 )
            User::undoActionArticle($id,1);
        else if( $field_index == 1 )
            User::undoActionArticle($id,0);
        
        $cookie = User::getUsersCookie($field_index);
      
        setcookie(User::$cookieStart . User::$db_fields[$field_index], 
                $cookie . ':' . $id, time()+60*60*24*30,'/');   
        User::actionArticleTable($id,$field_index,1);
    }
    
    /**
     * @author Ingimar Samuelsson
     * @doc
     *  Affects database based on user action
     * @end
     */
    private static function actionArticleTable($id,$field_index,$int) {
        if( class_exists('MySQL') === FALSE )
            include 'MySQL.php';
        $sql = new MySQL();
        
        $state = $sql->sqlQuery("SELECT " . User::$db_fields[$field_index] 
                . " FROM ernews_news WHERE newsID = " . $id);
        $get_value = mysql_fetch_array($state);
        $new_value = $get_value[User::$db_fields[$field_index]] + $int;
        if( $new_value != -1 )
            $sql->sqlQuery("UPDATE ernews_news SET " . User::$db_fields[$field_index] 
                . " = " . $new_value
                . " WHERE newsID = " . $id ); 
        
        if( $field_index == 3 )
            $sql->sqlQuery("UPDATE ernews_news SET "  . User::$db_fields[4] 
                    . " = '" . date('Y-m-d H:i:s') . "' WHERE newsID = " . $id);
    }
    
}

?>
