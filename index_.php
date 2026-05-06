<?php
session_start();
require "admin/src/php/utils/all_includes.php";
$total_panier = 0;
if (isset($_SESSION['panier'])) {
    foreach ($_SESSION['panier'] as $item) {
        $total_panier += $item['quantite'];
    }
}

$_SESSION["page"] = $_GET["page"] ?? "accueil";

$pages = ['accueil', 'compte', 'page404', 'detail', 'panier', 'login_client', 'logout_client', 'valider', 'confirmer'];if (!in_array($_SESSION["page"], $pages)) {
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
        <input type="text" id="search-input" placeholder="Recherche un livre, DVD...">
        <div id="search-results" class="search-results" style="display:none;"></div>
    </div>
    <div class="navbar__icons">
        <?php if (isset($_SESSION['client'])): ?>
            <a href="index_.php?page=compte">Mon compte</a>
            <a href="index_.php?page=logout_client">Déconnexion</a>
        <?php else: ?>
            <a href="index_.php?page=login_client">Connexion</a>
        <?php endif; ?>
        <a class="nav-link" href="index_.php?page=panier">
            <i class="fa-solid fa-cart-shopping"></i> Panier <span id="cart-count" class="badge bg-danger"><?= $total_panier ?></span>
        </a>
    </div>
</nav>


<div class="categories-bar">
    <a href="index_.php?page=accueil" class="<?= !isset($_GET['categorie']) ? 'active' : '' ?>">Tous</a>
    <?php
    $categorieDAO = new CategorieDAO($cnx);
    $categories = $categorieDAO->getAllCategories();
    foreach ($categories as $cat): ?>
        <a href="index_.php?page=accueil&categorie=<?= $cat->id_categorie ?>"
           class="<?= (isset($_GET['categorie']) && $_GET['categorie'] == $cat->id_categorie) ? 'active' : '' ?>">
            <?= $cat->nom_categorie ?>
        </a>
    <?php endforeach; ?>
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