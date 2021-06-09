<?php
include_once("dbconnect.php");
$catselection =  $_POST['catselection'];
if ($catselection == "all") {
$sqlloadmenu = "SELECT * FROM tbl_menu ORDER BY datecreated DESC";
} else if($catselection == "food"){
     $sqlloadmenu = "SELECT * FROM tbl_menu WHERE category = 'Food' OR category = 'Weekly Special Menu' ORDER BY datecreated DESC  ";
     
} else if($catselection == "bev"){
     $sqlloadmenu = "SELECT * FROM tbl_menu WHERE category = 'Beverages' ORDER BY datecreated DESC";
    
} else if($catselection == "spec"){
     $sqlloadmenu = "SELECT * FROM tbl_menu WHERE category = 'Weekly Special Menu' ORDER BY datecreated DESC";
     
} else {
    $sqlloadmenu = "SELECT * FROM tbl_menu WHERE name LIKE '%$catselection%' ORDER BY datecreated DESC";
}
$result = $conn->query($sqlloadmenu);

if ($result->num_rows > 0){
    $response["menu"] = array();
    while ($row = $result -> fetch_assoc()){
        $menulist = array();
        $menulist[menuid] = $row['menuid'];
        $menulist[name] = $row['name'];
        $menulist[description] = $row['description'];
        $menulist[category] = $row['category'];
        $menulist[price] = $row['price'];
        $menulist[date_post] = $row['datecreated'];
        
        array_push($response["menu"],$menulist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}


?>

