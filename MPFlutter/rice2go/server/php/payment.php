<?php
error_reporting(0);


$email = $_GET['email']; //email
$phone= $_GET['phone']; 
$name = $_GET['name']; 
$amount = $_GET['amount']; 
$accnum=$_GET['accnum'];


$api_key = '011f1962-5a7a-4703-be6c-967ca865e622';
$collection_id = 'iut0z_vo';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';


$data = array(
          'collection_id' => $collection_id,
          'email' => $email,
          'phone' => $phone,
          'name' => $name,
          'amount' => $amount * 100, 
		  'description' => 'Account Number: '.$accnum,
          'callback_url' => "https://hubbuddies.com/270552/rice2go/php/return_url",
          'redirect_url' => "https://hubbuddies.com/270552/rice2go/php/payment_update.php?email=$email&phone=$phone&name=$name&amount=$amount"
);


$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 

$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return, true);

//echo "<pre>".print_r($bill, true)."</pre>";
header("Location: {$bill['url']}");
?>