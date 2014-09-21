<?php 
include 'mysql_connect.php';
$query = "TRUNCATE TABLE log";
mysql_query($query) or die ("Error in query: $query. " . mysql_error());
mysql_close($con);
?>
<head>
<meta http-equiv="refresh" content="1; URL=/">
</head>