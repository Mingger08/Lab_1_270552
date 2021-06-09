<?php
include_once("dbconnect.php");
$name = $_POST['name'];
$desc = $_POST['desc'];
$category = $_POST['category'];
$price = $_POST['price'];
$encoded_string = $_POST["encoded_string"];

$sqladd = "INSERT INTO tbl_menu(name,description,category,price) VALUES('$name','$desc','$category','$price')";
if ($conn->query($sqladd) === TRUE){
  $decoded_string = base64_decode($encoded_string);
    $filename = mysqli_insert_id($conn);
   $path = '../images/menu/'.$filename.'.png';
   $is_written = file_put_contents($path, $decoded_string);
    echo "success";
}else{
    echo "failed";
}

?>