<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$menuid = $_POST['menuid'];

$sqlcheckcart = "SELECT * FROM tbl_cart WHERE menuid = '$menuid' AND email = '$email'"; //check if the product is already in cart
            $resultcart = $conn->query($sqlcheckcart);
            if ($resultcart->num_rows == 0) {//product is not in the cart proceed with insert new
                 echo $sqladdtocart = "INSERT INTO tbl_cart (email, menuid, quantity) VALUES ('$email','$menuid','1')";
                if ($conn->query($sqladdtocart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            } else { //if the product is in the cart, proceed with update
                echo $sqlupdatecart = "UPDATE tbl_cart SET quantity = quantity +1 WHERE menuid = '$menuid' AND email = '$email'";
                if ($conn->query($sqlupdatecart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            
        
    }


?>