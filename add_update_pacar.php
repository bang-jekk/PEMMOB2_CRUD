<?php
header("Access-Control-Allow-Origin: *");

require_once "koneksi/connection.php";

$nama = $_POST['nama'];
$umur = $_POST['umur'];
$hobi = $_POST['hobi'];

if (!empty($_POST['id'])) {
    $sql = "UPDATE pacar SET nama=?, umur=?, hobi=? WHERE id=?";
    $database_connection->prepare($sql)
        ->execute([$nama, $umur, $hobi, $_POST['id']]);
} else {
    $sql = "INSERT INTO pacar VALUES (NULL,?,?,?)";
    $database_connection->prepare($sql)
        ->execute([$nama, $umur, $hobi]);
}

echo "ok";
