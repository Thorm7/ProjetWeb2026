<?php
if (empty($_SESSION['panier'])) {
    header('Location: index_.php?page=panier');
    exit;
}
$total = 0;
foreach ($_SESSION['panier'] as $item) {
    $total += $item['prix'] * $item['quantite'];
}
$client = $_SESSION['client'] ?? null;
?>
<div class="container my-5" style="max-width: 600px;">
    <h1>Validation de la commande</h1>
    <?php if ($client): ?>
        <p>Connecté en tant que : <strong><?= htmlspecialchars($client->nom . ' ' . $client->prenom) ?></strong> (<?= htmlspecialchars($client->email) ?>)</p>
    <?php else: ?>
        <div class="alert alert-info">Vous n'êtes pas connecté. La commande sera enregistrée comme invité.</div>
    <?php endif; ?>
    <table class="table">
        <thead><tr><th>Produit</th><th>Qté</th><th>Prix</th></tr></thead>
        <tbody>
        <?php foreach ($_SESSION['panier'] as $item): ?>
            <tr><td><?= htmlspecialchars($item['nom']) ?></td><td><?= $item['quantite'] ?></td><td><?= number_format($item['prix'] * $item['quantite'], 2, ',', ' ') ?> €</td></tr>
        <?php endforeach; ?>
        </tbody>
        <tfoot><tr><td colspan="2" class="text-end fw-bold">Total</td><td><?= number_format($total, 2, ',', ' ') ?> €</td></tr></tfoot>
    </table>
    <form method="post" action="index_.php?page=confirmer">
        <button type="submit" class="btn btn-success btn-lg w-100">Confirmer la commande</button>
    </form>
</div>