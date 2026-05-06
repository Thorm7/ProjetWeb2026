<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$id = $_GET['id_user'] ?? null;
if ($id) {
    $dao = new UtilisateurDAO($cnx);
    $retour = $dao->deleteUtilisateur((int)$id);
    echo json_encode($retour);
} else {
    echo json_encode(0);
}