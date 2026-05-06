<?php
$id_categorie = $_GET['categorie'] ?? null;
$produitDAO = new ProduitDAO($cnx);
$show_dvd = false;

if ($id_categorie) {
    $nouveautes = $produitDAO->getProduitsByCategorie((int)$id_categorie);
} else {
    $nouveautes = $produitDAO->getAllProduits();
    $dvd = $produitDAO->getProduitsByType('dvd');
    $show_dvd = true;
}
?>

<?php if ($id_categorie): ?>
    <div class="banner">Filtre actif</div>
<?php else: ?>
    <div class="banner">Nouveautés</div>
<?php endif; ?>

    <div class="produits-grid">
        <?php foreach ($nouveautes as $p): ?>
            <a href="index_.php?page=detail&id=<?= $p->id_produit ?>" class="produit-card">
                <img src="<?= htmlspecialchars($p->image_url) ?>" alt="<?= htmlspecialchars($p->nom_produit) ?>" onerror="this.src='https://via.placeholder.com/200x300?text=Image'">
                <small><?= htmlspecialchars($p->description) ?></small>
                <h3><?= htmlspecialchars($p->nom_produit) ?></h3>
                <span class="prix"><?= number_format($p->prix, 2, ',', ' ') ?> €</span>
            </a>
        <?php endforeach; ?>
    </div>

<?php if ($show_dvd): ?>
    <div class="banner">Sélection DVD</div>
    <div class="produits-grid">
        <?php foreach ($dvd as $p): ?>
            <a href="index_.php?page=detail&id=<?= $p->id_produit ?>" class="produit-card">
                <img src="<?= htmlspecialchars($p->image_url) ?>" alt="<?= htmlspecialchars($p->nom_produit) ?>" onerror="this.src='https://via.placeholder.com/200x300?text=DVD'">
                <small><?= htmlspecialchars($p->description) ?></small>
                <h3><?= htmlspecialchars($p->nom_produit) ?></h3>
                <span class="prix"><?= number_format($p->prix, 2, ',', ' ') ?> €</span>
            </a>
        <?php endforeach; ?>
    </div>
<?php endif; ?>