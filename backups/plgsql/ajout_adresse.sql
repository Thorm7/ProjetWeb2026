CREATE OR REPLACE FUNCTION ajout_adresse(
    p_numero_rue character varying,
    p_nom_rue character varying,
    p_code_postal integer,
    p_ville character varying,
    p_id_user integer
) RETURNS integer AS '
DECLARE
    v_id integer;
BEGIN
    INSERT INTO adresse (numero_rue, nom_rue, code_postal, ville, id_user)
    VALUES (p_numero_rue, p_nom_rue, p_code_postal, p_ville, p_id_user)
    RETURNING id_adresse INTO v_id;
    RETURN v_id;
END;
' LANGUAGE plpgsql;