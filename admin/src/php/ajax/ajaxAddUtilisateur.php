<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$utilisateur = new UtilisateurDAO($cnx);
$retour = $utilisateur->addUtilisateur($_GET['nom'], $_GET['prenom'], $_GET['email'], $_GET['password'], $_GET['date_naissance']);
print json_encode($retour);