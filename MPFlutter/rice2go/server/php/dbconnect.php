<?php
$servername = "localhost";
$username   = "hubbuddi_rice2goadmin";
$password   = "?lbWk!#MFm?i";
$dbname     = "hubbuddi_rice2godb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>