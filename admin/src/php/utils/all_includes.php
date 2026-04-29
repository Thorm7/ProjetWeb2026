<?php
//$_SERVER['REQUEST_URI'] : chemin relatif depuis la racine de l'application
$isAdmin = str_contains($_SERVER['REQUEST_URI'], 'admin');
if ($isAdmin) {
    $pathDb = 'src/php/db/db_pg_connect.php';
    $pathAutoloader = 'src/php/classes/Autoloader.class.php';
    if(!file_exists($pathDb)){ //depuis dossier ajax
        $pathDb = '../db/db_pg_connect.php';
        $pathAutoloader = '../classes/Autoloader.class.php';
    }

} else {
    $pathDb = 'admin/src/php/db/db_pg_connect.php';
    $pathAutoloader = 'admin/src/php/classes/Autoloader.class.php';
}

if (file_exists($pathDb) && file_exists($pathAutoloader)) {
    include $pathDb;
    include $pathAutoloader;

    Autoloader::register();

    $cnx = Connexion::getInstance($dsn, $user, $pass);
} else {
    die("Impossible de charger les fichiers");
}