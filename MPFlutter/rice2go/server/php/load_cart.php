<?php
include_once("dbconnect.php");


$sqlloadcart = "SELECT * FROM tbl_cart INNER JOIN tbl_menu ON tbl_menu.menuid = tbl_cart.menuid ";

$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0) {

    $response['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $cartlist['menuid'] = $row['menuid'];
        $cartlist['name'] = $row['name'];
        $cartlist['description'] = $row['description'];
        $cartlist['category'] = $row['category'];
        $cartlist['price'] = $row['price'];
        $cartlist['datecreated'] = $row['datecreated'];
        $cartlist['quantity'] = $row['quantity'];
        array_push($response['cart'], $cartlist);
    }
    echo json_encode($response);
} else {
    echo "nodata";
}

?>