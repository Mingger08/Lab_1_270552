<?php

error_reporting(0);
include_once("dbconnect.php");

$email=$_POST['foremail'];
$newpass=$_POST['fornewpass'];
$conpass=$_POST['forconpass'];
$newp=sha1($newpass);




if(strlen($newpass)<6 || strlen($newpass)>15){
    echo 'failed2';
    return;
};

if($newpass !== $conpass){
    echo 'failed1';
    return;
};

$sqlcheckemail = "SELECT * FROM tbl_user WHERE email= '$email' ";
$result = $conn-> query ($sqlcheckemail);
if($result ->num_rows>0){
	$sqlchange= "UPDATE tbl_user SET password= '$newp' WHERE email='$email' ";
	if($conn->query($sqlchange)===TRUE){
		echo 'success';
	}
	else{
		echo 'failed';
	}
}






?>