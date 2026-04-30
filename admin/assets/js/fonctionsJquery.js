$(document).ready(function () {

    $('#formulaire_utilisateur').on('submit', function (e) {
        e.preventDefault();
        console.log("Formulaire soumis !");

        var email = $('#email').val();
        var password = $('#password').val();
        var nom = $('#nom').val();
        var prenom = $('#prenom').val();
        var date_naissance = $('#date_naissance').val();

        $.ajax({
            url: 'admin/src/php/ajax/ajaxCheckUtilisateur.php',
            type: 'GET',
            data: {
                email: email,
                password: password
            },
            dataType: 'json',
            success: function (reponse) {
                if (reponse) {
                    $('#nom').val(reponse.nom);
                    $('#prenom').val(reponse.prenom);
                    $('#date_naissance').val(reponse.date_naissance);
                    $('#message').html('<div class="alert alert-success">Compte trouvé. Vous pouvez modifier vos informations.</div>');
                } else {
                    $.ajax({
                        url: 'admin/src/php/ajax/ajaxAddUtilisateur.php',
                        type: 'GET',
                        data: {
                            nom: nom,
                            prenom: prenom,
                            email: email,
                            password: password,
                            date_naissance: date_naissance
                        },
                        dataType: 'json',
                        success: function (retour) {
                            if (retour > 0) {
                                $('#message').html('<div class="alert alert-success">Compte créé avec succès !</div>');
                            } else if (retour == 2) {
                                $('#message').html('<div class="alert alert-danger">Cet email est déjà utilisé.</div>');
                            } else {
                                $('#message').html('<div class="alert alert-danger">Erreur lors de la création du compte.</div>');
                            }
                        }
                    });
                }
            }
        });
    });

});