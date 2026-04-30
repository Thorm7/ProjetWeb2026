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
<main id="main_admin">
    <section id="contenu">
        <?php

        if (!isset($_SESSION['admin'])) {
            $path = "content/login.php";
        } else {
            if (isset($_GET["page"])) {
                $_SESSION["page"] = $_GET["page"];
            }
            $path = "content/" . $_SESSION["page"];
        }
        if (isset($path) && file_exists($path)) {
            include $path;
        } else {
            include "content/page404.php";
        }
        ?>
    </section>
</main>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/js/fonctionsJquery.js"></script>
</body>
</html>