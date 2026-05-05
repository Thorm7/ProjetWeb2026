CREATE OR REPLACE FUNCTION ajout_produit(
    p_nom_produit text,
    p_description text,
    p_prix numeric,
    p_stock int,
    p_image_url text,
    p_type_produit text,
    p_id_categorie int
) RETURNS int AS '
DECLARE
    retour int := 0;
BEGIN
    INSERT INTO produit(nom_produit, description, prix, stock, image_url, type_produit, id_categorie)
    VALUES (p_nom_produit, p_description, p_prix, p_stock, p_image_url, p_type_produit, p_id_categorie)
    ON CONFLICT (nom_produit) DO NOTHING
    RETURNING id_produit INTO retour;

    IF retour IS NOT NULL THEN
        RETURN retour;
    END IF;

    SELECT id_produit INTO retour FROM produit WHERE nom_produit = p_nom_produit;
    IF FOUND THEN
        RETURN 2;
    ELSE
        RETURN 0;
    END IF;
END;
' LANGUAGE plpgsql;