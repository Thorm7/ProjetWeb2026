<?php
session_start();
header('Content-Type: application/json');
require('../utils/all_includes.php');

if (!isset($_GET['id_produit']) || !is_numeric($_GET['id_produit'])) {
    echo json_encode(['success' => false, 'message' => 'ID produit invalide']);
    exit;
}

$id = (int)$_GET['id_produit'];
$produitDAO = new ProduitDAO($cnx);
$produit = $produitDAO->getProduitById($id);

if (!$produit) {
    echo json_encode(['success' => false, 'message' => 'Produit introuvable']);
    exit;
}

if ($produit->stock <= 0) {
    echo json_encode(['success' => false, 'message' => 'Stock épuisé']);
    exit;
}


if (!isset($_SESSION['panier'])) {
    $_SESSION['panier'] = [];
}


if (isset($_SESSION['panier'][$id])) {
    $_SESSION['panier'][$id]['quantite'] += 1;
} else {
    $_SESSION['panier'][$id] = [
        'nom'       => $produit->nom_produit,
        'prix'      => $produit->prix,
        'image'     => $produit->image_url,
        'quantite'  => 1,
        'stock_max' => $produit->stock
    ];
}

$total_articles = array_sum(array_column($_SESSION['panier'], 'quantite'));

echo json_encode(['success' => true, 'total_articles' => $total_articles]);