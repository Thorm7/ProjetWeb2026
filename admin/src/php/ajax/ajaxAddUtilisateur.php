<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$nom = $_GET['nom'] ?? '';
$prenom = $_GET['prenom'] ?? '';
$email = $_GET['email'] ?? '';
$password = $_GET['password'] ?? '';
$date_naissance = $_GET['date_naissance'] ?? '';
$numero = $_GET['numero_rue'] ?? '';
$rue = $_GET['nom_rue'] ?? '';
$cp = $_GET['code_postal'] ?? '';
$ville = $_GET['ville'] ?? '';

$dao = new UtilisateurDAO($cnx);
$retourUserId = $dao->addUtilisateur($nom, $prenom, $email, $password, $date_naissance);

if ($retourUserId > 0) {
    // Si des champs d'adresse sont fournis, on insère l'adresse
    if (!empty($numero) || !empty($rue) || !empty($cp) || !empty($ville)) {
        $dao->addAdresse($numero, $rue, (int)$cp, $ville, (int)$retourUserId);
    }
    echo json_encode($retourUserId);
} else {
    echo json_encode($retourUserId); // 2 ou 0
}