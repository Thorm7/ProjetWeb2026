<?php
session_start();
require "src/php/utils/all_includes.php";

// Page par défaut
$_SESSION["page"] = $_GET["page"] ?? "accueil.php";
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration LivreDVD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="index_.php">Admin LivreDVD</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link" href="index_.php?page=accueil.php">Accueil</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="content/disconnect.php">Déconnexion</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<main id="main_admin">
    <section id="contenu">
        <?php
        if (!isset($_SESSION['admin'])) {
            include "content/login.php";
        } else {
            if (isset($_GET["page"])) {
                $_SESSION["page"] = $_GET["page"];
            }
            $path = "content/" . $_SESSION["page"];
            if (file_exists($path)) {
                include $path;
            } else {
                include "content/page404.php";
            }
        }
        ?>
    </section>
</main>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>