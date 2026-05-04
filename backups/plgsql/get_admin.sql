CREATE OR REPLACE FUNCTION get_admin(p_email text, p_password text)
RETURNS TABLE (
    id_user int,
    nom text,
    prenom text,
    email text,
    role text
) AS '
BEGIN
    RETURN QUERY SELECT u.id_user, u.nom, u.prenom, u.email, u.role
    FROM utilisateur u
    WHERE u.email = p_email AND u.mot_de_passe = p_password AND u.role = ''admin'';

    IF NOT FOUND THEN
        RETURN QUERY SELECT -1, '''', '''', '''', '''';
    END IF;
END;
' LANGUAGE plpgsql;