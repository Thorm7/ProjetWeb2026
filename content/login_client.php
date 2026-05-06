<?php
if (isset($_POST['submit'])) {
    $email = $_POST['email'] ?? '';
    $password = $_POST['password'] ?? '';
    if (!empty($email) && !empty($password)) {
        $utilisateurDAO = new UtilisateurDAO($cnx);
        $client = $utilisateurDAO->getUtilisateur($email, $password);
        if ($client) {
            if ($client->role === 'admin') {
                $_SESSION['admin'] = 1;
                header('Location: admin/index_.php?page=accueil.php');
                exit;
            } else {
                $_SESSION['client'] = $client;
                header('Location: index_.php?page=accueil');
                exit;
            }
        } else {
            $erreur = "Email ou mot de passe incorrect.";
        }
    } else {
        $erreur = "Veuillez remplir tous les champs.";
    }
}
?>
<div class="container my-5" style="max-width: 400px;">
    <h1>Connexion client</h1>
    <?php if (!empty($erreur)): ?>
        <div class="alert alert-danger"><?= $erreur ?></div>
    <?php endif; ?>
    <form method="post" action="">
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Mot de passe</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" name="submit" class="btn btn-primary w-100">Se connecter</button>
    </form>
    <p class="mt-3">Pas encore de compte ? <a href="index_.php?page=compte">S'inscrire</a></p>
</div>