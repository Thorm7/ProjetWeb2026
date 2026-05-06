<?php
session_start();
header('Content-Type: application/json');

if (!isset($_GET['id_produit'], $_GET['quantite'])) {
    echo json_encode(['success' => false]);
    exit;
}

$id = (int)$_GET['id_produit'];
$quantite = (int)$_GET['quantite'];

if ($quantite < 1) $quantite = 1;

if (isset($_SESSION['panier'][$id])) {
    $stockMax = $_SESSION['panier'][$id]['stock_max'];
    if ($quantite > $stockMax) $quantite = $stockMax;
    $_SESSION['panier'][$id]['quantite'] = $quantite;
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
    'success' => true,
    'quantite' => $quantite,
    'total_articles' => $total_articles,
    'total_panier' => number_format($total_panier, 2, ',', ' ') . ' €',
    'sous_total' => number_format($_SESSION['panier'][$id]['prix'] * $quantite, 2, ',', ' ') . ' €'
]);