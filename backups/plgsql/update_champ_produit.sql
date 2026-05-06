CREATE OR REPLACE FUNCTION update_champ_produit(
    p_id_produit int,
    p_champ text,
    p_nouvelle_valeur text
) RETURNS int AS '
DECLARE
    nb int;
BEGIN
    IF p_champ = ''nom_produit'' THEN
        UPDATE produit SET nom_produit = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''description'' THEN
        UPDATE produit SET description = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''prix'' THEN
        UPDATE produit SET prix = p_nouvelle_valeur::numeric WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''stock'' THEN
        UPDATE produit SET stock = p_nouvelle_valeur::int WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''image_url'' THEN
        UPDATE produit SET image_url = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''type_produit'' THEN
        UPDATE produit SET type_produit = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = ''id_categorie'' THEN
        UPDATE produit SET id_categorie = p_nouvelle_valeur::int WHERE id_produit = p_id_produit;
    ELSE
        RETURN 0;
    END IF;

    GET DIAGNOSTICS nb = ROW_COUNT;
    RETURN nb;
END;
' LANGUAGE plpgsql;