CREATE OR REPLACE FUNCTION ajout_ligne_panier(p_id_panier INT, p_id_produit INT, p_quantite INT, p_prix NUMERIC)
RETURNS INT AS '
BEGIN
    INSERT INTO contient (id_panier, id_produit, quantite, prix_achat_u)
    VALUES (p_id_panier, p_id_produit, p_quantite, p_prix);
    RETURN 1;
END;
' LANGUAGE plpgsql;