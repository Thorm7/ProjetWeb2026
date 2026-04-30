CREATE OR REPLACE FUNCTION ajout_utilisateur(
    f_nom text,
    f_prenom text,
    f_email text,
    f_mot_de_passe text,
    f_date_naissance date
) RETURNS integer AS
'
DECLARE
    retour int := 0;
BEGIN
    INSERT INTO utilisateur(
        nom,
        prenom,
        email,
        mot_de_passe,
        date_naissance
    )
    VALUES (
        f_nom,
        f_prenom,
        f_email,
        f_mot_de_passe,
        f_date_naissance
    )
    ON CONFLICT (email) DO NOTHING
    RETURNING id_user INTO retour;

    IF retour IS NOT NULL THEN
        RETURN retour;
    END IF;

    SELECT id_user INTO retour
    FROM utilisateur
    WHERE email = f_email;

    IF FOUND THEN
        RETURN 2;
    ELSE
        RETURN 0;
    END IF;
END;
' LANGUAGE plpgsql;