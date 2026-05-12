$(document).ready(function () {

    // Inscription user
    $('#formulaire_utilisateur').on('submit', function (e) {
        e.preventDefault();
        var email = $('#email').val();
        var password = $('#password').val();
        var nom = $('#nom').val();
        var prenom = $('#prenom').val();
        var date_naissance = $('#date_naissance').val();
        var numero = $('#numero_rue').val();
        var rue = $('#nom_rue').val();
        var cp = $('#code_postal').val();
        var ville = $('#ville').val();

        $.ajax({
            url: 'admin/src/php/ajax/ajaxCheckUtilisateur.php',
            type: 'GET',
            data: { email: email, password: password },
            dataType: 'json',
            success: function (reponse) {
                if (reponse) {
                    $('#message').html('<div class="alert alert-danger">Cet email est déjà utilisé.</div>');
                } else {
                    $.ajax({
                        url: 'admin/src/php/ajax/ajaxAddUtilisateur.php',
                        type: 'GET',
                        data: {
                            nom: nom, prenom: prenom, email: email,
                            password: password, date_naissance: date_naissance,
                            numero_rue: numero, nom_rue: rue, code_postal: cp, ville: ville
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

    // Edition produit
    $('td[contenteditable=true]').each(function() {
        $(this).data('ancien', $(this).text().trim());
    });

    $('td[data-champ="type_produit"] select, td[data-champ="id_categorie"] select').on('change', function () {
        var cellule = $(this).closest('td');
        var id = cellule.attr('id');
        var champ = cellule.data('champ');
        var nouveau = $(this).val();

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

    $('td[contenteditable=true]').on('blur', function () {
        var cellule = $(this);
        var id = cellule.attr('id');
        var champ = cellule.data('champ');
        var nouveau = cellule.text().trim();
        var ancien = cellule.data('ancien');
        if (nouveau !== ancien) {
            $.ajax({
                url: 'src/php/ajax/ajaxUpdateChampProduit.php',
                type: 'GET',
                data: { champ: champ, nouveau: nouveau, id_produit: id },
                dataType: 'json',
                success: function (data) {
                    console.log("success " + data);
                    if (data > 0) {
                        cellule.data('ancien', nouveau);
                    }
                }
            });
        }
    });

    // Suppression d'un produit
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

    // Afficher/masquer le formulaire d'ajout produit
    $('#ajout_nouveau').hide();
    $('#inserer').click(function () {
        $('#ajout_nouveau').show();
    });

    // Panier
    $(document).on('click', '#ajouterPanier', function() {
        var id = $(this).data('id');
        $.ajax({
            url: 'admin/src/php/ajax/ajaxAddToCart.php',
            type: 'GET',
            data: { id_produit: id },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $('#cart-count').text(response.total_articles);
                    alert('Ajouté au panier');
                } else {
                    alert(response.message);
                }
            }
        });
    });

    $(document).on('click', '.btn-supprimer-panier', function() {
        var id = $(this).data('id');
        var ligne = $(this).closest('tr');
        $.ajax({
            url: 'admin/src/php/ajax/ajaxRemoveFromCart.php',
            type: 'GET',
            data: { id_produit: id },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    ligne.remove();
                    $('#cart-count').text(response.total_articles);
                    $('#total-panier').text(response.total_panier);
                }
            }
        });
    });

    $(document).on('click', '.btn-plus, .btn-moins', function() {
        var $btn = $(this);
        var id = $btn.data('id');
        var $qteSpan = $btn.siblings('.qte-texte');
        var qte = parseInt($qteSpan.text());
        var delta = $btn.hasClass('btn-plus') ? 1 : -1;
        var nouvelleQte = qte + delta;
        if (nouvelleQte < 1) return;
        $.ajax({
            url: 'admin/src/php/ajax/ajaxUpdateCartQuantity.php',
            type: 'GET',
            data: { id_produit: id, quantite: nouvelleQte },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    $qteSpan.text(response.quantite);
                    $('#cart-count').text(response.total_articles);
                    $('#total-panier').text(response.total_panier);
                    $btn.closest('tr').find('td:nth-child(5)').text(response.sous_total);
                }
            }
        });
    });

    // Recherche
    var searchTimeout;
    $('#search-input').on('input', function() {
        var query = $(this).val().trim();

        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            $.ajax({
                url: 'admin/src/php/ajax/ajaxSearchProduits.php',
                type: 'GET',
                data: { q: query },
                dataType: 'json',
                success: function(produits) {
                    $('#search-results').empty();
                    if (produits.length > 0) {
                        produits.forEach(function(p) {
                            var html = '<a href="index_.php?page=detail&id=' + p.id_produit + '">' +
                                '<img src="' + (p.image_url || 'https://via.placeholder.com/40x55') + '" alt="">' +
                                '<div><strong>' + p.nom_produit + '</strong><br><small>' + p.prix + ' €</small></div>' +
                                '</a>';
                            $('#search-results').append(html);
                        });
                        $('#search-results').show();
                    } else {
                        $('#search-results').html('<div class="p-2">Aucun résultat</div>').show();
                    }
                }
            });
        }, 300);
    });

    // Cacher les résultats si on clique ailleurs
    $(document).on('click', function(e) {
        if (!$(e.target).closest('#search-input, #search-results').length) {
            $('#search-results').hide();
        }
    });

    // Gestion des users (admin)
    $(document).on('change', '.role-select', function() {
        var select = $(this);
        var id = select.closest('tr').data('id');
        var nouveauRole = select.val();
        $.ajax({
            url: 'src/php/ajax/ajaxUpdateRoleUtilisateur.php',
            type: 'GET',
            data: { id_user: id, role: nouveauRole },
            dataType: 'json',
            success: function(response) {
                if (response > 0) {
                    console.log('Rôle mis à jour');
                } else {
                    alert('Erreur lors de la mise à jour du rôle');
                }
            }
        });
    });

    // Suppression d'un utilisateur
    $(document).on('click', '.btn-supprimer-user', function() {
        var ligne = $(this).closest('tr');
        var id = ligne.data('id');
        if (confirm('Supprimer définitivement cet utilisateur ?')) {
            $.ajax({
                url: 'src/php/ajax/ajaxDeleteUtilisateur.php',
                type: 'GET',
                data: { id_user: id },
                dataType: 'json',
                success: function(response) {
                    if (response > 0) {
                        ligne.fadeOut('slow', function() { ligne.remove(); });
                    } else {
                        alert('Erreur lors de la suppression');
                    }
                }
            });
        }
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
});