<?php
 
// Create connection
$con = mysqli_connect("localhost","c3chickens","QJXWACABKvRXl5rDwnDWiQp2S","c3chickens");
 
// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}
 
// This SQL statement selects ALL from the table 'Locations'
//$sql = "SELECT * FROM Locations";
$sql = 'SELECT id, nickname, score FROM chickens';
// Check if there are results
 if ($result = mysqli_query($con, $sql))
{
	// If so, then create a results array and a temporary one
	// to hold the data
	$resultArray = array();
	$tempArray = array(); 
 
	// Loop through each row in the result set
 	while($row = $result->fetch_object())
	{
		// Add each row into our results array
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	} 
/* foreach ($con -> query($sql) as $row){
print $row['id'] . "\t";
print $row['nickname'] . "\t";
print $row['score'] . "\n";
}  */

	// Finally, encode the array to JSON and output the results
	echo json_encode($resultArray);
}
 
// Close connections
mysqli_close($con);
?>