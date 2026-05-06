CREATE OR REPLACE FUNCTION ajout_panier(p_id_user INT)
RETURNS INT AS '
DECLARE
    v_id INT;
BEGIN
    INSERT INTO panier (id_user, statut) VALUES (p_id_user, ''commandé'')
    RETURNING id_panier INTO v_id;
    RETURN v_id;
END;
' LANGUAGE plpgsql;