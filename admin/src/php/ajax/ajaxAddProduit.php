<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$produit = new ProduitDAO($cnx);
$retour = $produit->addProduit($_GET['nom'], $_GET['stock'], $_GET['prix'], $_GET['description'], $_GET['type'], $_GET['image'], $_GET['id_categorie']);
print json_encode($retour);