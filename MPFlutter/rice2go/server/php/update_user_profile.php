<?php

include_once("dbconnect.php");

$username = $_POST['username'];
$gender = $_POST['gender'];
$birthdate = $_POST['birthdate'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$address=$_POST['address'];
$name=$_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);


if (isset($encoded_string)){
    $path = '../images/profile/'.$email.'.png';
    file_put_contents($path, $decoded_string);
    echo 'success';
}



if (isset($gender)){
    $sqlupdategender = "UPDATE tbl_user SET gender = '$gender' WHERE email = '$email'";
    if($conn->query($sqlupdategender)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}

if (isset($birthdate)){
    $sqlupdatebirthdate = "UPDATE tbl_user SET birthdate = '$birthdate' WHERE email = '$email'";
    if($conn->query($sqlupdatebirthdate)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}


if (isset($phone)){
    $sqlupdatephone = "UPDATE tbl_user SET phone_num = '$phone' WHERE email = '$email'";
    if($conn->query($sqlupdatephone)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}

if (isset($address)){
    $sqlupdateaddress = "UPDATE tbl_user SET address = '$address' WHERE email = '$email'";
    if($conn->query($sqlupdateaddress)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}

if (isset($name)){
    $sqlupdatename = "UPDATE tbl_user SET name = '$name' WHERE email = '$email'";
    if ($conn->query($sqlupdatename)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}



$conn->close();
?>
