<?php
include_once("dbconnect.php");
$prname = $_POST['prname'];
$prtype = $_POST['prtype'];
$prprice = $_POST['prprice'];
$prqty = $_POST['prqty'];
$encoded_string = $_POST["encoded_string"];

$sqladd = "INSERT INTO tbl_products(prname,prtype,prprice,prqty) VALUES('$prname','$prtype','$prprice','$prqty')";
if ($conn->query($sqladd) === TRUE){
  $decoded_string = base64_decode($encoded_string);
    $filename = mysqli_insert_id($conn);
   $path = '../images/product/'.$filename.'.png';
   $is_written = file_put_contents($path, $decoded_string);
    echo "success";
}else{
    echo "failed";
}

?>