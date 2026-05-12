CREATE OR REPLACE FUNCTION effacer_produit(p_id_produit int) RETURNS int AS '
DECLARE
    nb int;
BEGIN
    DELETE FROM produit WHERE id_produit = p_id_produit;
    GET DIAGNOSTICS nb = ROW_COUNT;
    RETURN nb;
END;
' LANGUAGE plpgsql;