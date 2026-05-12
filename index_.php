<?php
ob_start();
require "admin/src/php/utils/all_includes.php";
session_start();
require "admin/src/php/utils/public_init.php";
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
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="admin/assets/js/fonctionsJquery.js"></script>
</head>
<body>

<?php require "admin/src/php/utils/public_navbar.php"; ?>
<?php require "admin/src/php/utils/categories_bar.php"; ?>

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

<?php require "admin/src/php/utils/footer.php"; ?>


</body>
</html>