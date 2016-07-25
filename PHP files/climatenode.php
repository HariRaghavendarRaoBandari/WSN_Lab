<?php
        header('Refresh: 10');
	$objConnect = mysql_connect("192.168.22.50","slsummer14_g3","tjXyVpopLsETvkNIiqdtomv2QC");

    if (!$objConnect)
      {
        die('Could not connect: ' . mysql_error());
       }
	$objDB = mysql_select_db("slsummer14_g3");
	$strSQL = "SELECT ROUND(temperature_S,2) AS Temperature,pressure_i AS Pressure,ROUND(humidity_s,2) AS Humidity,visible_light AS VisibleLight FROM climate ORDER BY updated DESC LIMIT 1";
	$objQuery = mysql_query($strSQL);
	$intNumField = mysql_num_fields($objQuery);
	$resultArray = array();
	while($obResult = mysql_fetch_array($objQuery))
	{
		$arrCol = array();
		for($i=0;$i<$intNumField;$i++)
		{
			$arrCol[mysql_field_name($objQuery,$i)] = $obResult[$i];
		}
		array_push($resultArray,$arrCol);
	}
	
	mysql_close($objConnect);
	
	echo json_encode($resultArray);
?>

