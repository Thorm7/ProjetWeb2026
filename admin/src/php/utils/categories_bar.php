<?php
$categorieDAO = new CategorieDAO($cnx);
$categories = $categorieDAO->getAllCategories();
?>
<div class="categories-bar">
    <a href="index_.php?page=accueil" class="<?= !isset($_GET['categorie']) ? 'active' : '' ?>">Tous</a>
    <?php foreach ($categories as $cat): ?>
        <a href="index_.php?page=accueil&categorie=<?= $cat->id_categorie ?>"
           class="<?= (isset($_GET['categorie']) && $_GET['categorie'] == $cat->id_categorie) ? 'active' : '' ?>">
            <?= $cat->nom_categorie ?>
        </a>
    <?php endforeach; ?>
</div>