<?php

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of MySQL
 *
 * @author Lars
 */
class MySQL {
    private $db = "db.student.chalmers.se:3306";
    private $db_user = "abdoli";
    private $db_pass = "kgcH8v7c";  
    private $schema = "abdoli";
    
    function sqlQuery($query) {
        mysql_connect($this->db, $this->db_user, $this->db_pass) or die(mysql_error());
        mysql_select_db($this->schema) or die(mysql_error());
        //mysql_set_charset("utf8",$connection);

        $result = mysql_query($query) or die(mysql_error()); 
        mysql_close();
        return $result;
    }
    function sqlMultiQuery($query) {
        $mysqli = new mysqli($this->db, $this->db_user, $this->db_pass, $this->schema);
        if ($mysqli->connect_errno) {
            echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
        }

        if (!$mysqli->multi_query($query)) {
            echo "Multi query failed: (" . $mysqli->errno . ") " . $mysqli->error;
        }

        do {
            if ($res = $mysqli->store_result()) {
                var_dump($res->fetch_all(MYSQLI_ASSOC));
                $res->free();
            }
        } while ($mysqli->more_results() && $mysqli->next_result());
    }
}

?>
