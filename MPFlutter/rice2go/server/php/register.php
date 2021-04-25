<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/Exception.php';
require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/PHPMailer.php';
require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");

$username = $_POST['username'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$verify_code = 0;


$sqlregister = "INSERT INTO tbl_user(username,phone_num,email,password,otp,verify_code) VALUES('$username','$phone','$email','$passha1','$otp', '$verify_code')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($username, $otp,$email);
}else{
    echo "failed";
}


function sendEmail($username, $otp,$email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug=0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host='mail.hubbuddies.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth=true;                                           //Enable SMTP authentication
    $mail->Username='rice2go@hubbuddies.com';                  //SMTP username
    $mail->Password='z?^FobuKdFj7';                                 //SMTP password
    $mail->SMTPSecure='tls';         
    $mail->Port=587;
    
    $from = "rice2go@hubbuddies.com";
    $to = $email;
    $subject = "From Rice2Go. Account Verification.";
    $message = "Hi $username,<br><br>
    
	            Welcome to Rice2Go!<br><br>
	            
                Please verify your account by clicking the following link.<br><br><a href='https://hubbuddies.com/270552/rice2go/php/verify_account.php?email=".$email."&key=".$otp."'>Click Here</a>";
                
    $mail->setFrom($from,"Rice2Go");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}


?>