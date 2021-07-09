<?php
include_once("dbconnect.php");
$ordernumber = $_POST['on'];
$totalprice = $_POST['tp'];
$totalquantity = $_POST['tq'];
$paymentmethod = $_POST['pm'];
$remark = $_POST['re'];
$status=$_POST['status'];
$diningoption=$_POST['dop'];


$menuidincart;
$quantityincart;

$sqladd = "INSERT INTO tbl_order(ordernumber,totalprice,totalquantity,paymentmethod,remark,status,diningoption) VALUES('$ordernumber','$totalprice','$totalquantity','$paymentmethod','$remark','$status','$diningoption')";



if ($conn->query($sqladd) === TRUE){
  
  $sqlloadcart = "INSERT INTO tbl_orderfood (ordernumber, menuid, quantity) SELECT ordernumber, menuid, quantity FROM tbl_cart ";
  
  if ($conn->query($sqlloadcart) === TRUE){
    $sqldeletecart = "DELETE FROM tbl_cart WHERE ordernumber = '$ordernumber'";
    
    if ($conn->query($sqldeletecart) === TRUE){
    echo "success";
    }else{
    echo "failed1";
}
  }else{
    echo "failed2";
}
}else{
    echo "failed3";
}

?>