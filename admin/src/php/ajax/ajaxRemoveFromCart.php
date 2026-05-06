<?php
session_start();
header('Content-Type: application/json');

if (!isset($_GET['id_produit'])) {
    echo json_encode(['success' => false]);
    exit;
}

$id = (int)$_GET['id_produit'];

if (isset($_SESSION['panier'][$id])) {
    unset($_SESSION['panier'][$id]);
}

$total_articles = 0;
$total_panier = 0;
if (!empty($_SESSION['panier'])) {
    foreach ($_SESSION['panier'] as $item) {
        $total_articles += $item['quantite'];
        $total_panier += $item['prix'] * $item['quantite'];
    }
}

echo json_encode([
    'success'        => true,
    'total_articles' => $total_articles,
    'total_panier'   => number_format($total_panier, 2, ',', ' ') . ' €'
]);