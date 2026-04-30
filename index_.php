<?php
session_start();
require "admin/src/php/utils/all_includes.php";

$_SESSION["page"] = $_GET["page"] ?? "accueil";

$pages = ['accueil', 'compte', 'page404'];
if (!in_array($_SESSION["page"], $pages)) {
    $_SESSION["page"] = 'accueil';
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LivreDVD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="admin/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>


<nav class="navbar">
    <div class="navbar__logo">
        <a href="index_.php">LivreDVD</a>
    </div>
    <div class="navbar__search">
        <input type="text" placeholder="Recherche un livre, DVD...">
        <div class="search-dropdown"></div>
    </div>
    <div class="navbar__icons">
        <a href="index_.php?page=compte"><i class="fa-solid fa-user"></i> Compte</a>
        <a href="#"><i class="fa-solid fa-cart-shopping"></i> Panier</a>
    </div>
</nav>


<div class="categories-bar">
    <a href="#">Tous</a>
    <a href="#">Science-Fiction</a>
    <a href="#">Romans</a>
    <a href="#">Jeunesse</a>
    <a href="#">DVD</a>
</div>


<main>
    <?php
    $path = "content/" . $_SESSION["page"] . ".php";
    if (file_exists($path)) {
        include $path;
    } else {
        include "content/page404.php";
    }
    ?>
</main>


<footer class="footer">
    <div>
        <strong>LivreDVD</strong>
        <span>Librairie en ligne de ventes de livres et DVDs</span>
    </div>
    <div>
        <strong>A propos</strong>
        <a href="#">Contact</a>
    </div>
    <div>
        <strong>Aide</strong>
        <a href="#">FAQ</a>
        <a href="#">Retours</a>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="admin/assets/js/fonctionsJquery.js"></script>
</body>
</html>