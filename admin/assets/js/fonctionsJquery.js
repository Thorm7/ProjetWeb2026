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

    //Test a supprimer
    console.log('JS chargé panier');
    $(document).on('click', '#ajouterPanier', function() {
        console.log('Clic sur le bouton panier');
    });
    // aJout au panier
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
        if (query.length < 1) {
            $('#search-results').hide().empty();
            return;
        }
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
});