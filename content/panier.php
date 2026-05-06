<?php
if (!isset($_SESSION['panier'])) {
    $_SESSION['panier'] = [];
}
?>

<div class="container my-5">
    <h1>Votre panier</h1>
    <?php if (empty($_SESSION['panier'])): ?>
        <p>Votre panier est vide.</p>
    <?php else: ?>
        <table class="table">
            <thead>
            <tr>
                <th>Image</th>
                <th>Produit</th>
                <th>Prix unitaire</th>
                <th>Quantité</th>
                <th>Total</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <?php $total = 0; ?>
            <?php foreach ($_SESSION['panier'] as $id => $item): ?>
                <?php $sousTotal = $item['prix'] * $item['quantite'];
                $total += $sousTotal; ?>
                <tr>
                    <td><img src="<?= htmlspecialchars($item['image']) ?>" width="50" alt=""></td>
                    <td><?= htmlspecialchars($item['nom']) ?></td>
                    <td><?= number_format($item['prix'], 2, ',', ' ') ?> €</td>
                    <td>
                        <button class="btn btn-sm btn-outline-secondary btn-moins" data-id="<?= $id ?>">−</button>
                        <span class="mx-2 qte-texte"><?= $item['quantite'] ?></span>
                        <button class="btn btn-sm btn-outline-secondary btn-plus" data-id="<?= $id ?>">+</button>
                    </td>
                    <td><?= number_format($sousTotal, 2, ',', ' ') ?> €</td>
                    <td>
                        <button class="btn btn-sm btn-danger btn-supprimer-panier" data-id="<?= $id ?>">Supprimer</button>
                    </td>
                </tr>
            <?php endforeach; ?>
            </tbody>
            <tfoot>
            <tr>
                <td colspan="5" class="text-end fw-bold">Total</td>
                <td id="total-panier"><?= number_format($total, 2, ',', ' ') ?> €</td>            </tr>
            </tfoot>
        </table>
    <?php endif; ?>
</div>