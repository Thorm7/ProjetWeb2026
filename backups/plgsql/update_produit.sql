CREATE OR REPLACE FUNCTION update_produit(
    p_id_produit int,
    p_nom_produit text,
    p_description text,
    p_prix numeric,
    p_stock int,
    p_image_url text,
    p_type_produit text,
    p_id_categorie int
) RETURNS int AS '
DECLARE
    nb int;
BEGIN
    UPDATE produit SET
        nom_produit = p_nom_produit,
        description = p_description,
        prix = p_prix,
        stock = p_stock,
        image_url = p_image_url,
        type_produit = p_type_produit,
        id_categorie = p_id_categorie
    WHERE id_produit = p_id_produit;

    nb := ROW_COUNT;
    IF nb > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END;
' LANGUAGE plpgsql;