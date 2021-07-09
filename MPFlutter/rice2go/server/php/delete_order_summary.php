<?php
include_once("dbconnect.php");
$ordernumber = $_POST["ordernumber"];

$sqldelete = "DELETE FROM tbl_order WHERE ordernumber = '$ordernumber'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>