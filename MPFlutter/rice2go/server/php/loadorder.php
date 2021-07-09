<?php
include_once("dbconnect.php");

$pageselect =  $_POST['pageselect'];

if($pageselect == "inprogress"){
     $sqlloadorder = "SELECT * FROM tbl_order WHERE status = 'In Progress' ORDER BY orderdate DESC";
     
} else if($pageselect == "completed"){
     $sqlloadorder = "SELECT * FROM tbl_order WHERE status = 'Completed' ORDER BY orderdate DESC";
    
} 
$result = $conn->query($sqlloadorder);

if ($result->num_rows > 0){
    $response["order"] = array();
    while ($row = $result -> fetch_assoc()){
        $orderlist = array();
        $orderlist[ordernumber] = $row['ordernumber'];
        $orderlist[totalprice] = $row['totalprice'];
        $orderlist[totalquantity] = $row['totalquantity'];
        $orderlist[orderdate] = $row['orderdate'];
        $orderlist[remark] = $row['remark'];
        $orderlist[status] = $row['status'];
        $orderlist[paymentmethod] = $row['paymentmethod'];
        $orderlist[diningoption] = $row['diningoption'];
        
        array_push($response["order"],$orderlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>