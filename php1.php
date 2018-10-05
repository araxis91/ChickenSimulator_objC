<?php

$username = "c3chickens";
$password = "QJXWACABKvRXl5rDwnDWiQp2S";
$hostname = "localhost";
$dbnamemysql = "c3chickens";
$mysqli = new mysqli($hostname, $username, $password, $dbnamemysql);

if($mysqli){
    $query = "SELECT * FROM chickens";
    $result = $mysqli->query($query);
    //$row = $result->fetch_array();
    //$row = $result->fetch_array(MYSQLI_ASSOC);
    //$row = $result->fetch_array(MYSQLI_BOTH);
    $set = array();
    while ($obj = $result->fetch_object()) {
	$set[] = array("id" => $obj->id,"nic" => $obj->nickname,"cop" => $obj->score);
	//echo "1 $obj->id";
	//echo "</br>";
	//echo "2 $obj->nickname";
	//echo "</br>";
	//echo "3 $obj->score";
	//echo "</br>";
    }
    //var_dump($set);
    echo json_encode($set);
}else{
    echo "ERROR DB";
}
$mysqli_select_db( 'c3chickens' );
mysql_query( "INSERT INTO chickens VALUES ( null, null, '".
    mysql_real_escape_string( $_REQUEST['nickname'] ).
    "', '".
    mysql_real_escape_string( $_REQUEST['score'] ).
    "')" );
    //<success />
?>


