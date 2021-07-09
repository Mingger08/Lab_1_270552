<?php
include_once("dbconnect.php");
//$email = $_POST['email'];
$menuid = $_POST['menuid'];
$selection = $_POST['selection'];
$quantity = $_POST['quantity'];

if ($selection == "addqty") {
    $sqlupdatecart = "UPDATE tbl_cart SET quantity = quantity +1 WHERE menuid = '$menuid'";
    if ($conn->query($sqlupdatecart) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}
if ($selection == "minusqty") {
    if ($quantity == 1) {
        echo "failed";
    } else {
        $sqlupdatecart = "UPDATE tbl_cart SET quantity = quantity - 1 WHERE menuid = '$menuid'";
        if ($conn->query($sqlupdatecart) === TRUE) {
            echo "success";
        } else {
            echo "failed";
        }
    }
}
?>