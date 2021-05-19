<?php
$servername = "localhost";
$username   = "hubbuddi_270552myshopdbadmin";
$password   = "83}yB)#+nQs3";
$dbname     = "hubbuddi_270552_myshopdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>