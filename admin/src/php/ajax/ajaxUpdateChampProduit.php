<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$produit = new ProduitDAO($cnx);
$retour = $produit->updateChampProduit($_GET['champ'], $_GET['nouveau'], $_GET['id_produit']);
print json_encode($retour);