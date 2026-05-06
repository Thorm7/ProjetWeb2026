<?php
header('Content-Type: application/json');
require('../utils/all_includes.php');

$id = $_GET['id_user'] ?? null;
$role = $_GET['role'] ?? '';

if ($id && in_array($role, ['admin', 'client'])) {
    $dao = new UtilisateurDAO($cnx);
    $retour = $dao->updateUtilisateurRole((int)$id, $role);
    echo json_encode($retour);
} else {
    echo json_encode(0);
}