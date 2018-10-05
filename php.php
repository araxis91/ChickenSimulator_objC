<?php

$username = "c3chickens";
$password = "QJXWACABKvRXl5rDwnDWiQp2S";
$hostname = "localhost";
$dbnamemysql = "c3chickens";
$mysqli = new mysqli($hostname, $username, $password, $dbnamemysql);

if(!$mysqli){
    exit("ERROR DB");
    $result = "NO METHOD";

}else{
   // if($_SERVER['REQUEST_METHOD'] == 'POST'){
	      if($_SERVER['REQUEST_METHOD'] == 'POST'){

//	$method = $_POST['method'];
//	if($method == "UPDATE"){
/*
	    $login = $_POST['login'];
	    $cop = $_POST['cop'];
	    $query = "UPDATE chickens SET score = $cop WHERE nickname = $login";
	    $result = $mysqli->query($query);
*/
	//}elseif($method == "REGISTER"){
	//	}elseif($method == "POST"){
//}elseif($_SERVER['REQUEST_METHOD'] == 'POST'){

//	    $login = $_POST['login'];
//	    $cop = $_POST['cop'];
/*
	    $query = "SELECT * FROM chickens WHERE nickname = $login";
	    $result = $mysqli->query($query);
	    if($result){
		$result = "ERORR LOGIN YES";
	    }else{
*/

/*
     mysql_select_db( 'c3chickens' );
     mysql_query( "INSERT INTO chickens ('nickname', 'score') VALUES ( null, null, '".
    mysql_real_escape_string( $_REQUEST['login'] ).
    "', '".
    mysql_real_escape_string( $_REQUEST['cop'] ).
    "')" );
*/
		$query = "INSERT INTO chickens (nickname, score) VALUES ($login, $cop)";
		$result = $mysqli->query($query);
	//    }
	//}
/*
	else{
	    $result = "NO METHOD";
	}
	$set = array(
	    "response" => 0,
	    "SQLreport" => $result
	);
	echo json_encode($set);
    }
*/
}

    else{
	$query = "SELECT * FROM chickens";
	$result = $mysqli->query($query);
	$set = array();
	while ($obj = $result->fetch_object()) {
	    $set[] = array("id" => $obj->id,"nic" => $obj->nickname,"cop" => $obj->score);
	}
	echo json_encode($set);
    }
}

?>


