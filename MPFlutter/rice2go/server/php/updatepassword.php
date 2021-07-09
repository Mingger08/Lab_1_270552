<?php

include_once("dbconnect.php");
$email = $_POST['email'];
$oldpassword = $_POST['oldpass'];
$newpassword = $_POST['newpass'];
$compassword = $_POST['compass'];

$oldpass = sha1($oldpassword);
$newpass = sha1($newpassword);
$compass = sha1($compassword);

// if(strlen($newpass)<6 || strlen($newpass)>15){
//     echo 'failed2';
//     return;
// };

 if($compass == $newpass){
     $sql = "SELECT * FROM tbl_user WHERE email = '$email' AND password = '$oldpass'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $sqlupdatepass = "UPDATE tbl_user SET password = '$newpass' WHERE email = '$email'";
        $conn->query($sqlupdatepass);
        echo 'success';
    }else{
        echo 'failed';
    }
     
 }else{
    echo 'compassnotsame'; 
 }

    


$conn->close();
?>