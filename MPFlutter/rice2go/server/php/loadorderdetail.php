<?php
include_once("dbconnect.php");

$ordernumber =  $_POST['orderid'];

$sqljointable = 
"SELECT menu.menuid, orderfood.quantity, menu.name, menu.price
FROM tbl_orderfood orderfood
JOIN  tbl_menu menu ON orderfood.menuid = menu.menuid
WHERE orderfood.ordernumber = '$ordernumber'";


$result = $conn->query($sqljointable);
         
if ($result->num_rows > 0){
     $response["orderdata"] = array();
    while ($row = $result -> fetch_assoc()){
        $orderdatalist = array();
        $orderdatalist[ordermenuid] = $row['menuid'];
        $orderdatalist[orderquantity] = $row['quantity'];
        $orderdatalist[ordername] = $row['name'];
        $orderdatalist[orderprice] = $row['price'];
        
        
        array_push($response["orderdata"],$orderdatalist);
    }
    echo json_encode($response);

}else{
      echo "nodata";
}
   




?>