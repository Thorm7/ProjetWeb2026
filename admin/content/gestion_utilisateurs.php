<?php
$utilisateurDAO = new UtilisateurDAO($cnx);
$utilisateurs = $utilisateurDAO->getAllUtilisateurs();
?>
<h1>Gestion des utilisateurs</h1>
<table class="table table-striped" id="tableUtilisateurs">
    <thead>
    <tr>
        <th>ID</th>
        <th>Nom</th>
        <th>Prénom</th>
        <th>Email</th>
        <th>Date de naissance</th>
        <th>Rôle</th>
        <th>Action</th>
    </tr>
    </thead>
    <tbody>
    <?php foreach ($utilisateurs as $u): ?>
        <tr data-id="<?= $u->id_user ?>">
            <td><?= $u->id_user ?></td>
            <td><?= htmlspecialchars($u->nom) ?></td>
            <td><?= htmlspecialchars($u->prenom) ?></td>
            <td><?= htmlspecialchars($u->email) ?></td>
            <td><?= $u->date_naissance ?></td>
            <td class="role-cell" data-champ="role">
                <select class="form-select form-select-sm role-select">
                    <option value="client" <?= $u->role === 'client' ? 'selected' : '' ?>>Client</option>
                    <option value="admin" <?= $u->role === 'admin' ? 'selected' : '' ?>>Admin</option>
                </select>
            </td>
            <td><button class="btn btn-danger btn-sm btn-supprimer-user">Supprimer</button></td>
        </tr>
    <?php endforeach; ?>
    </tbody>
</table>