<?php

include_once("dbconnect.php");
$menuid=$_POST['menuid'];
$name = $_POST['name'];
$desc = $_POST['desc'];
$category = $_POST['category'];
$price = $_POST['price'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

if (isset($encoded_string)){
    $path = '../images/menu/'.$menuid.'.png';
    file_put_contents($path, $decoded_string);
    echo 'success';
}



if (isset($name)){
    $sqlupdatename = "UPDATE tbl_menu SET name = '$name' WHERE menuid = '$menuid'";
    if($conn->query($sqlupdatename)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}

if (isset($desc)){
    $sqlupdatedesc = "UPDATE tbl_menu SET description = '$desc' WHERE menuid = '$menuid'";
    if($conn->query($sqlupdatedesc)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}


if (isset($category)){
    $sqlupdatecategory = "UPDATE tbl_menu SET category = '$category' WHERE menuid = '$menuid'";
    if($conn->query($sqlupdatecategory)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}

if (isset($price)){
    $sqlupdateprice = "UPDATE tbl_menu SET price = '$price' WHERE menuid = '$menuid'";
    if($conn->query($sqlupdateprice)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}


$conn->close();
?>