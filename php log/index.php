<? 
include 'mysql_connect.php';
$query="SELECT * FROM log";
$query="SELECT * FROM (SELECT * FROM log ORDER BY time DESC LIMIT 50) AS ttbl ORDER BY time DESC; ";
$result=mysql_query($query);
$num=mysql_numrows($result);
mysql_close();
?>
<head><title>LOG</title></head>
<style type="text/css">
td.green{
	background:LightGreen;
}
</style>
<table border="0" cellspacing="2" cellpadding="2">
<tr>
<th><font face="Arial, Helvetica, sans-serif">Date</font></th>
<th><font face="Arial, Helvetica, sans-serif">Log</font></th>
</tr>
<?php
$i=0;
while ($i < $num) {
$f1=mysql_result($result,$i,"time");
$f2=mysql_result($result,$i,"text");
?>

<tr>
<td><font face="Arial, Helvetica, sans-serif"><?php echo $f1; ?></font></td>
<td <?php if($f2=="Move Cargo, 3") {echo ' class=green ';} ?> ><font face="Arial, Helvetica, sans-serif"><?php echo $f2; ?></font></td>
</tr>

<?php
$i++;
}
?>
</table>
<FORM action="trunk.php" method="post">
<input type="submit" value="Clear">
</FORM>
<FORM action="log.php" method="post">
<textarea cols="50" rows="4" name="text"></textarea>
<input name="btn" type="submit" value="Submit">
</FORM>
