<?php 
include 'mysql_connect.php';
$query = "INSERT INTO log (time, text) VALUES(NOW(), '$_POST[text]')";
mysql_query($query) or die ("Error in query: $query. " . mysql_error());
mysql_close($con);
?>
<head>
<meta http-equiv="refresh" content="1; URL=/">
</head>