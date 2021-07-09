<?php
include_once("dbconnect.php");
$ordernumber = $_POST["ordernumber"];


 $sqlupdateorderstatus = "UPDATE tbl_order SET status = 'Completed' WHERE ordernumber = '$ordernumber'";
    if($conn->query($sqlupdateorderstatus)){
        echo 'success';    
    }else{
        echo 'failed';
    }


?>