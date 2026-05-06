<?php
if (isset($_SESSION['client'])) {
    $client = $_SESSION['client'];
    $commandeDAO = new CommandeDAO($cnx);
    $lignes = $commandeDAO->getCommandesByUser($client->id_user);
    $commandes = [];
    foreach ($lignes as $ligne) {
        $idPanier = $ligne['id_panier'];
        if (!isset($commandes[$idPanier])) {
            $commandes[$idPanier] = [
                    'id_panier' => $idPanier,
                    'total' => 0,
                    'lignes' => []
            ];
        }
        $commandes[$idPanier]['lignes'][] = $ligne;
        $commandes[$idPanier]['total'] += $ligne['prix_achat_u'] * $ligne['quantite'];
    }
    ?>
    <div class="container my-5">
        <h1>Bonjour <?= htmlspecialchars($client->prenom) ?></h1>
        <h2>Mes commandes</h2>
        <?php if (empty($commandes)): ?>
            <p>Vous n'avez pas encore passé de commande.</p>
        <?php else: ?>
            <?php foreach ($commandes as $cmd): ?>
                <div class="card mb-3">
                    <div class="card-header">
                        Commande n°<?= $cmd['id_panier'] ?> - Total : <?= number_format($cmd['total'], 2, ',', ' ') ?> €
                    </div>
                    <ul class="list-group list-group-flush">
                        <?php foreach ($cmd['lignes'] as $l): ?>
                            <li class="list-group-item">
                                <img src="<?= htmlspecialchars($l['image_url'] ?? '') ?>" width="50" alt="">
                                <?= htmlspecialchars($l['nom_produit']) ?> - Qté: <?= $l['quantite'] ?> - Prix unitaire: <?= number_format($l['prix_achat_u'], 2, ',', ' ') ?> €
                            </li>
                        <?php endforeach; ?>
                    </ul>
                </div>
            <?php endforeach; ?>
        <?php endif; ?>
        <a href="index_.php?page=logout_client" class="btn btn-secondary mt-3">Déconnexion</a>
    </div>
<?php } else { ?>
    <h1>Mon compte</h1>
    <div id="message"></div>

    <form id="formulaire_utilisateur">
        <h3>Informations personnelles</h3>
        <div class="mb-3">
            <label for="nom" class="form-label">Nom</label>
            <input type="text" class="form-control" id="nom" name="nom" required>
        </div>
        <div class="mb-3">
            <label for="prenom" class="form-label">Prénom</label>
            <input type="text" class="form-control" id="prenom" name="prenom" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <div class="mb-3">
            <label for="date_naissance" class="form-label">Date de naissance</label>
            <input type="date" class="form-control" id="date_naissance" name="date_naissance" required>
        </div>
        <h3>Adresse</h3>
        <div class="mb-3">
            <label for="numero_rue" class="form-label">Numéro</label>
            <input type="text" class="form-control" id="numero_rue" name="numero_rue">
        </div>
        <div class="mb-3">
            <label for="nom_rue" class="form-label">Rue</label>
            <input type="text" class="form-control" id="nom_rue" name="nom_rue">
        </div>
        <div class="mb-3">
            <label for="code_postal" class="form-label">Code postal</label>
            <input type="number" class="form-control" id="code_postal" name="code_postal">
        </div>
        <div class="mb-3">
            <label for="ville" class="form-label">Ville</label>
            <input type="text" class="form-control" id="ville" name="ville">
        </div>
        <button type="submit" class="btn btn-primary">Ajouter ou modifier</button>
    </form>
<?php } ?>