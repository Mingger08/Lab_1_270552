<?php
include_once("dbconnect.php");
$sqlloadproducts = "SELECT * FROM tbl_products";
$result = $conn->query($sqlloadproducts);

if ($result->num_rows > 0){
    $response["products"] = array();
    while ($row = $result -> fetch_assoc()){
        $prlist = array();
        $prlist[productid] = $row['prid'];
        $prlist[productname] = $row['prname'];
        $prlist[producttype] = $row['prtype'];
        $prlist[productprice] = $row['prprice'];
        $prlist[productqty] = $row['prqty'];
        $prlist[date_post] = $row['datecreated'];
        
        array_push($response["products"],$prlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>