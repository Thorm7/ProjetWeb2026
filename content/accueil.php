<?php
$produitDAO = new ProduitDAO($cnx);
$nouveautes = $produitDAO->getAllProduits();
$dvd = $produitDAO->getProduitsByType('dvd');
?>

<div class="banner">Nouveautés</div>
<div class="produits-grid">
    <?php foreach ($nouveautes as $p): ?>
        <div class="produit-card">
            <img src="<?= $p->image_url ?>" alt="<?= $p->nom_produit ?>" onerror="this.src='https://via.placeholder.com/200x300?text=Image'">
            <small><?= $p->description ?></small>
            <h3><?= $p->nom_produit ?></h3>
            <span class="prix"><?= number_format($p->prix, 2, ',', ' ') ?> €</span>
        </div>
    <?php endforeach; ?>
</div>

<div class="banner">Sélection DVD</div>
<div class="produits-grid">
    <?php foreach ($dvd as $p): ?>
        <div class="produit-card">
            <img src="<?= $p->image_url ?>" alt="<?= $p->nom_produit ?>" onerror="this.src='https://via.placeholder.com/200x300?text=DVD'">
            <small><?= $p->description ?></small>
            <h3><?= $p->nom_produit ?></h3>
            <span class="prix"><?= number_format($p->prix, 2, ',', ' ') ?> €</span>
        </div>
    <?php endforeach; ?>
</div>