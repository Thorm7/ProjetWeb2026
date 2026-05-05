$(document).ready(function () {

    $('#formulaire_utilisateur').on('submit', function (e) {
        e.preventDefault();
        var email = $('#email').val();
        var password = $('#password').val();
        var nom = $('#nom').val();
        var prenom = $('#prenom').val();
        var date_naissance = $('#date_naissance').val();

        $.ajax({
            url: 'admin/src/php/ajax/ajaxCheckUtilisateur.php',
            type: 'GET',
            data: { email: email, password: password },
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
                            nom: nom, prenom: prenom, email: email,
                            password: password, date_naissance: date_naissance
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

    $('td[contenteditable=true]').on('blur', function () {
        var cellule = $(this);
        var id = cellule.attr('id');
        var champ = cellule.data('champ');
        var nouveau = cellule.text().trim();
        var ancien = cellule.data('ancien') || nouveau;
        if (nouveau !== ancien) {
            $.ajax({
                url: 'src/php/ajax/ajaxUpdateChampProduit.php',
                type: 'GET',
                data: { champ: champ, nouveau: nouveau, id_produit: id },
                dataType: 'json',
                success: function (data) {
                    console.log("success " + data);
                }
            });
        }
    });

    $('td[data-champ] select').on('change', function () {
        var select = $(this);
        var td = select.closest('td');
        var id = td.attr('id');
        var champ = td.data('champ');
        var nouveau = select.val();
        $.ajax({
            url: 'src/php/ajax/ajaxUpdateChampProduit.php',
            type: 'GET',
            data: { champ: champ, nouveau: nouveau, id_produit: id },
            dataType: 'json',
            success: function (data) {
                console.log("success " + data);
            }
        });
    });

    $('.delete').on('click', function (e) {
        e.preventDefault();
        var id = $(this).data('id');
        if (confirm('Voulez-vous supprimer ce produit ?')) {
            var tr = $(this).closest('tr');
            tr.fadeOut('slow');
            $.ajax({
                url: 'src/php/ajax/ajaxDeleteProduit.php',
                type: 'GET',
                data: { id_produit: id },
                dataType: 'json',
                success: function (data) {
                    console.log("success " + data);
                }
            });
        }
    });

    $('#ajout_nouveau').hide();
    $('#inserer').click(function () {
        $('#ajout_nouveau').show();
    });

    $('#options').hide();
    $('#en_couleur').click(function () {
        if ($(this).hasClass('bleu')) {
            $(this).removeClass('bleu').addClass('rouge');
        } else {
            $(this).removeClass('rouge').addClass('bleu');
        }
    });
    $('#coucou').click(function () {
        if ($('#coucou2').is(":visible")) {
            $('#coucou2').hide();
        } else {
            $('#coucou2').show();
        }
    });
    $('#souris1').mouseover(function () {
        $('#souris2').fadeIn('slow');
    });
    $('#souris1').mouseout(function () {
        $('#souris2').fadeOut('slow');
    });
    $('#menu_cliquer').click(function () {
        if ($('#options').is(':visible')) {
            $('#options').slideUp('slow');
        } else {
            $('#options').slideDown('slow');
        }
    });
    $('#image').click(function () {
        $('#image2').html("<img src='assets/images/cake2.jpg' alt='autre image'>");
    });
    $('#image').mouseover(function () {
        $(this).attr("src", "assets/images/cake3.jpg");
    });
    $('#nom').blur(function () {
        $('#saisie').text("Bonjour " + $(this).val());
    });
});