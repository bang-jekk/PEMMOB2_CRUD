<?php
try {
    $database_connection = new PDO(
        "mysql:host=localhost;port=3306;dbname=pacar_db",
        "root",
        ""
    );
} catch (PDOException $e) {
    die("Koneksi gagal: " . $e->getMessage());
}
?>