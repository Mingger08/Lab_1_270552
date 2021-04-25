<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/Exception.php';
require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/PHPMailer.php';
require '/home8/hubbuddi/public_html/270552/rice2go/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");

$email=$_POST['email'];
$verify_code=rand(1000,9999);


$sqlforpass = "SELECT * FROM tbl_user WHERE email= '$email' AND otp = '0'";
$result = $conn-> query ($sqlforpass);
if($result ->num_rows>0){
	$sqlupdate= "UPDATE tbl_user SET verify_code='$verify_code' WHERE email='$email'";
	if($conn->query($sqlupdate)===TRUE){
		echo 'success';
		sendEmail($email,$verify_code);
	}
	else{
		echo 'failed';
	}
}else{
	echo 'failed';
}




function sendEmail($email,$verify_code){
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
    $subject = "From Rice2Go. Get Verify Code.";
    $message = "Hi,<br><br>
    
	            This is your change password OTP: $verify_code";
                
    $mail->setFrom($from,"Rice2Go");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}


?>