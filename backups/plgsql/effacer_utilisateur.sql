CREATE OR REPLACE FUNCTION effacer_utilisateur(p_id_user INT) RETURNS INT AS '
DECLARE
    nb INT;
BEGIN
    DELETE FROM utilisateur WHERE id_user = p_id_user;
    GET DIAGNOSTICS nb = ROW_COUNT;
    RETURN nb;
END;
' LANGUAGE plpgsql;