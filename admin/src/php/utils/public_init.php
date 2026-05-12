<?php
if (!isset($cnx)) {
    die("Connexion PDO indisponible.");
}


$total_panier = 0;
if (isset($_SESSION['panier'])) {
    foreach ($_SESSION['panier'] as $item) {
        $total_panier += $item['quantite'];
    }
}


$_SESSION["page"] = $_GET["page"] ?? "accueil";
$pages_autorisees = [
    'accueil', 'compte', 'page404', 'detail', 'panier',
    'login_client', 'logout_client', 'valider', 'confirmer'
];
if (!in_array($_SESSION["page"], $pages_autorisees)) {
    $_SESSION["page"] = 'content/page404.php';
}