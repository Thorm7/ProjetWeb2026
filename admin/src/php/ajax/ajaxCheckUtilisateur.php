<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$utilisateur = new UtilisateurDAO($cnx);
$ut = $utilisateur->getUtilisateur($_GET['email'], $_GET['password']);
print json_encode($ut);