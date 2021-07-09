<?php
include_once("dbconnect.php");


$sqldelete = "DELETE FROM tbl_cart";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>