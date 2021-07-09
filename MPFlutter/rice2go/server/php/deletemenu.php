<?php
include_once("dbconnect.php");
//$email = $_POST['email'];
$menuid = $_POST['menuid'];

$sqldelete = "DELETE FROM tbl_menu WHERE menuid = '$menuid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>