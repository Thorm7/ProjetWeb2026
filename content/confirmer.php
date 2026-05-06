<?php
if (empty($_SESSION['panier'])) {
    header('Location: index_.php?page=panier');
    exit;
}

$commandeDAO = new CommandeDAO($cnx);
$idUtilisateur = isset($_SESSION['client']) ? $_SESSION['client']->id_user : null;

$idCommande = $commandeDAO->creerCommande($idUtilisateur);

foreach ($_SESSION['panier'] as $id => $item) {
    $commandeDAO->ajouterLigne($idCommande, $id, $item['quantite'], $item['prix']);
}

$_SESSION['panier'] = [];
?>
<div class="container my-5 text-center">
    <h1>Commande confirmée</h1>
    <p>Votre commande n°<?= $idCommande ?> a bien été enregistrée.</p>
    <a href="index_.php" class="btn btn-primary">Retour à l'accueil</a>
</div>