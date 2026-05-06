<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

if (!isset($_GET['q'])) {
    echo json_encode([]);
    exit;
}

$produitDAO = new ProduitDAO($cnx);
$resultats = $produitDAO->searchProduits($_GET['q']);
echo json_encode($resultats);