<?php
/**
 * @author Ingimar Samuelsson
 * @doc
 *  Connects to and queries MySQL database
 * @end
 */
class MySQL {
    private $db = "db.student.chalmers.se:3306";
    private $db_user = "abdoli";
    private $db_pass = "kgcH8v7c";  
    private $schema = "abdoli";
    
    function sqlQuery($query) {
        mysql_connect($this->db, $this->db_user, $this->db_pass) or die(mysql_error());
        mysql_select_db($this->schema) or die(mysql_error());

        $result = mysql_query($query) or die(mysql_error()); 
        mysql_close();
        return $result;
    }
}

?>
