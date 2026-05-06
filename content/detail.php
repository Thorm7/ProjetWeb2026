<?php
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    include 'content/page404.php';
    return;
}

$produitDAO = new ProduitDAO($cnx);
$produit = $produitDAO->getProduitById((int)$_GET['id']);

if (!$produit) {
    include 'content/page404.php';
    return;
}

$categorieDAO = new CategorieDAO($cnx);
$nomCategorie = '';
foreach ($categorieDAO->getAllCategories() as $cat) {
    if ($cat->id_categorie == $produit->id_categorie) {
        $nomCategorie = $cat->nom_categorie;
        break;
    }
}
?>

<div class="container my-5">
    <div class="row">
        <div class="col-md-5">
            <img src="<?= htmlspecialchars($produit->image_url) ?>" class="img-fluid rounded" alt="<?= htmlspecialchars($produit->nom_produit) ?>" onerror="this.src='https://via.placeholder.com/600x900?text=Image+absente'">
        </div>
        <div class="col-md-7">
            <h1><?= htmlspecialchars($produit->nom_produit) ?></h1>
            <p class="text-muted">Catégorie : <?= htmlspecialchars($nomCategorie) ?></p>
            <p class="fs-4 fw-bold text-danger"><?= number_format($produit->prix, 2, ',', ' ') ?> €</p>
            <p><strong>Stock :</strong> <?= $produit->stock > 0 ? $produit->stock . ' disponible(s)' : '<span class="text-danger">Rupture</span>' ?></p>
            <p><?= nl2br(htmlspecialchars($produit->description)) ?></p>
            <button class="btn btn-success btn-lg" id="ajouterPanier" data-id="<?= $produit->id_produit ?>">Ajouter au panier</button>
        </div>
    </div>
</div>
