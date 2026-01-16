<?php
header("Access-Control-Allow-Origin: *");

require_once "koneksi/connection.php";

$id = $_POST['id'];

$sql = "DELETE FROM pacar WHERE id=?";
$database_connection->prepare($sql)->execute([$id]);

echo "hapus berhasil";
