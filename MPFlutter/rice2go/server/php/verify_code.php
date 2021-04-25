<?php

error_reporting(0);
include_once("dbconnect.php");

$email=$_POST['foremail'];
$verify_code=$_POST['forverifycode'];


$sqlcheckemail = "SELECT * FROM tbl_user WHERE email= '$email' AND verify_code = '$verify_code'";
$result = $conn-> query ($sqlcheckemail);
if($result ->num_rows>0){
	$sqlchange= "UPDATE tbl_user SET verify_code='0' WHERE email='$email'";
	if($conn->query($sqlchange)===TRUE){
		echo 'success';
	}else{
		echo 'failed';
	}
}


?>