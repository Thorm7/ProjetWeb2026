<?php
session_start();
unset($_SESSION['client']);
header('Location: index_.php?page=accueil');
exit;