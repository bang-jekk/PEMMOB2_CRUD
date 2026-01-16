<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

require_once "koneksi/connection.php";

$sql = "SELECT * FROM pacar";
$data = $database_connection
        ->query($sql)
        ->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($data);
