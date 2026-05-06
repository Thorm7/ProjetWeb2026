<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Administrateur</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h3>Connexion Administrateur</h3>
                </div>
                <div class="card-body">
                    <?php
                    if (isset($_GET['submit'])) {
                        extract($_GET, EXTR_OVERWRITE);
                        if (!empty($login) && !empty($password)) {
                            $admin = new AdminDAO($cnx);
                            $adm = $admin->getAdmin($login, $password);
                            if ($adm != null) {
                                $_SESSION['admin'] = 1;
                                $_SESSION['page'] = "accueil.php";
                                header("location: ./index_.php?page=accueil.php");
                                exit();
                            } else {
                                print '<div class="alert alert-danger">Accès réservé aux administrateurs</div>';
                            }
                        }
                    }
                    ?>

                    <form method="get" action="<?= $_SERVER['PHP_SELF'] ?>">
                        <div class="mb-3">
                            <label for="login" class="form-label">Login : </label>
                            <input type="text" class="form-control" id="login" name="login">
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password : </label>
                            <input type="password" class="form-control" id="password" name="password">
                        </div>
                        <button type="submit" class="btn btn-primary" name="submit">Submit</button>
                        <div class="button-home">
                            <a class="nav-link" href="../index_.php">Retour au site</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>