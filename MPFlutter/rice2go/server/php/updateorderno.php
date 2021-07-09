<?php
include_once("dbconnect.php");
$ordernumber = $_POST["orderid"];

// $menuidincart;
// $quantityincart;

 $sqlupdateordernumber = "UPDATE tbl_cart SET ordernumber = '$ordernumber' WHERE email = 'mingger1999@hotmail.com'";
    if($conn->query($sqlupdateordernumber)){
        echo 'success';    
    }else{
        echo 'failed';
    }


?>