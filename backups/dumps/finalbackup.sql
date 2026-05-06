--
-- PostgreSQL database dump
--

\restrict PgciwhWIXJUlM7a9kixnhjyXaZL1bCjtB0pxN6cFYGugdYsaEJIK3mwYhyDZ3Wd

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-05-06 16:14:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 16606)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 289 (class 1255 OID 16865)
-- Name: ajout_adresse(character varying, character varying, integer, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajout_adresse(p_numero_rue character varying, p_nom_rue character varying, p_code_postal integer, p_ville character varying, p_id_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id integer;
BEGIN
    INSERT INTO adresse (numero_rue, nom_rue, code_postal, ville, id_user)
    VALUES (p_numero_rue, p_nom_rue, p_code_postal, p_ville, p_id_user)
    RETURNING id_adresse INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.ajout_adresse(p_numero_rue character varying, p_nom_rue character varying, p_code_postal integer, p_ville character varying, p_id_user integer) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 16864)
-- Name: ajout_ligne_panier(integer, integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajout_ligne_panier(p_id_panier integer, p_id_produit integer, p_quantite integer, p_prix numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO contient (id_panier, id_produit, quantite, prix_achat_u)
    VALUES (p_id_panier, p_id_produit, p_quantite, p_prix);

    UPDATE produit SET stock = stock - p_quantite WHERE id_produit = p_id_produit;

    RETURN 1;
END;
$$;


ALTER FUNCTION public.ajout_ligne_panier(p_id_panier integer, p_id_produit integer, p_quantite integer, p_prix numeric) OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 16863)
-- Name: ajout_panier(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajout_panier(p_id_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_id INT;
BEGIN
    INSERT INTO panier (id_user, statut) VALUES (p_id_user, 'commandé')
    RETURNING id_panier INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.ajout_panier(p_id_user integer) OWNER TO postgres;

--
-- TOC entry 301 (class 1255 OID 16858)
-- Name: ajout_produit(text, text, numeric, integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajout_produit(p_nom_produit text, p_description text, p_prix numeric, p_stock integer, p_image_url text, p_type_produit text, p_id_categorie integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.ajout_produit(p_nom_produit text, p_description text, p_prix numeric, p_stock integer, p_image_url text, p_type_produit text, p_id_categorie integer) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 16848)
-- Name: ajout_utilisateur(text, text, text, text, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ajout_utilisateur(f_nom text, f_prenom text, f_email text, f_mot_de_passe text, f_date_naissance date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.ajout_utilisateur(f_nom text, f_prenom text, f_email text, f_mot_de_passe text, f_date_naissance date) OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 16795)
-- Name: delete_contient(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_contient(p_id_panier integer, p_id_produit integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM contient WHERE id_panier=p_id_panier AND id_produit=p_id_produit;
END;
$$;


ALTER FUNCTION public.delete_contient(p_id_panier integer, p_id_produit integer) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 16790)
-- Name: delete_produit(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_produit(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM produit WHERE id_produit=p_id;
END;
$$;


ALTER FUNCTION public.delete_produit(p_id integer) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 16787)
-- Name: delete_utilisateur(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.delete_utilisateur(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM utilisateur WHERE id_user=p_id;
END;
$$;


ALTER FUNCTION public.delete_utilisateur(p_id integer) OWNER TO postgres;

--
-- TOC entry 304 (class 1255 OID 16860)
-- Name: effacer_produit(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.effacer_produit(p_id_produit integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    nb int;
BEGIN
    DELETE FROM produit WHERE id_produit = p_id_produit;
    nb := ROW_COUNT;
    RETURN nb;
END;
$$;


ALTER FUNCTION public.effacer_produit(p_id_produit integer) OWNER TO postgres;

--
-- TOC entry 305 (class 1255 OID 16866)
-- Name: effacer_utilisateur(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.effacer_utilisateur(p_id_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    nb INT;
BEGIN
    DELETE FROM utilisateur WHERE id_user = p_id_user;
    GET DIAGNOSTICS nb = ROW_COUNT;
    RETURN nb;
END;
$$;


ALTER FUNCTION public.effacer_utilisateur(p_id_user integer) OWNER TO postgres;

--
-- TOC entry 294 (class 1255 OID 16849)
-- Name: get_admin(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_admin(p_email text, p_password text) RETURNS TABLE(id_user integer, nom text, prenom text, email text, role text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT u.id_user, u.nom, u.prenom, u.email, u.role
    FROM utilisateur u
    WHERE u.email = p_email AND u.mot_de_passe = p_password AND u.role = 'admin';
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT -1, '', '', '', '';
    END IF;
END;
$$;


ALTER FUNCTION public.get_admin(p_email text, p_password text) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 16793)
-- Name: insert_contient(integer, integer, integer, numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_contient(p_id_panier integer, p_id_produit integer, p_qte integer, p_prix numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO contient(id_panier, id_produit, quantite, prix_achat_u)
    VALUES (p_id_panier, p_id_produit, p_qte, p_prix)
    ON CONFLICT (id_panier, id_produit)
    DO UPDATE SET quantite = contient.quantite + p_qte;
END;
$$;


ALTER FUNCTION public.insert_contient(p_id_panier integer, p_id_produit integer, p_qte integer, p_prix numeric) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 16796)
-- Name: insert_livraison(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_livraison(p_frais numeric) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO livraison(frais_livraison) VALUES (p_frais)
    RETURNING id_livraison INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_livraison(p_frais numeric) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 16791)
-- Name: insert_panier(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_panier(p_id_user integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO panier(id_user) VALUES (p_id_user)
    RETURNING id_panier INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_panier(p_id_user integer) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 16788)
-- Name: insert_produit(character varying, text, numeric, integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_produit(p_nom character varying, p_desc text, p_prix numeric, p_stock integer, p_image character varying, p_type character varying, p_cat integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO produit(nom_produit, description, prix, stock, image_url, type_produit, id_categorie)
    VALUES (p_nom, p_desc, p_prix, p_stock, p_image, p_type, p_cat)
    RETURNING id_produit INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_produit(p_nom character varying, p_desc text, p_prix numeric, p_stock integer, p_image character varying, p_type character varying, p_cat integer) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 16798)
-- Name: insert_refere_a(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_refere_a(p_id_livraison integer, p_id_panier integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO refere_a(id_livraison, id_panier) VALUES (p_id_livraison, p_id_panier);
END;
$$;


ALTER FUNCTION public.insert_refere_a(p_id_livraison integer, p_id_panier integer) OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 16785)
-- Name: insert_utilisateur(character varying, character varying, character varying, character varying, date, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_utilisateur(p_nom character varying, p_prenom character varying, p_email character varying, p_mdp character varying, p_naissance date, p_role character varying DEFAULT 'client'::character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE v_id INT;
BEGIN
    INSERT INTO utilisateur(nom, prenom, email, mot_de_passe, date_naissance, role)
    VALUES (p_nom, p_prenom, p_email, crypt(p_mdp, gen_salt('bf')), p_naissance, p_role)
    RETURNING id_user INTO v_id;
    RETURN v_id;
END;
$$;


ALTER FUNCTION public.insert_utilisateur(p_nom character varying, p_prenom character varying, p_email character varying, p_mdp character varying, p_naissance date, p_role character varying) OWNER TO postgres;

--
-- TOC entry 306 (class 1255 OID 16861)
-- Name: update_champ_produit(integer, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_champ_produit(p_id_produit integer, p_champ text, p_nouvelle_valeur text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    nb int;
BEGIN
    IF p_champ = 'nom_produit' THEN
        UPDATE produit SET nom_produit = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'description' THEN
        UPDATE produit SET description = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'prix' THEN
        UPDATE produit SET prix = p_nouvelle_valeur::numeric WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'stock' THEN
        UPDATE produit SET stock = p_nouvelle_valeur::int WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'image_url' THEN
        UPDATE produit SET image_url = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'type_produit' THEN
        UPDATE produit SET type_produit = p_nouvelle_valeur WHERE id_produit = p_id_produit;
    ELSIF p_champ = 'id_categorie' THEN
        UPDATE produit SET id_categorie = p_nouvelle_valeur::int WHERE id_produit = p_id_produit;
    ELSE
        RETURN 0;
    END IF;
    
    GET DIAGNOSTICS nb = ROW_COUNT;
    RETURN nb;
END;
$$;


ALTER FUNCTION public.update_champ_produit(p_id_produit integer, p_champ text, p_nouvelle_valeur text) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 16794)
-- Name: update_contient_qte(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_contient_qte(p_id_panier integer, p_id_produit integer, p_qte integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF p_qte <= 0 THEN
        DELETE FROM contient WHERE id_panier=p_id_panier AND id_produit=p_id_produit;
    ELSE
        UPDATE contient SET quantite=p_qte
        WHERE id_panier=p_id_panier AND id_produit=p_id_produit;
    END IF;
END;
$$;


ALTER FUNCTION public.update_contient_qte(p_id_panier integer, p_id_produit integer, p_qte integer) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 16797)
-- Name: update_livraison_livre(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_livraison_livre(p_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE livraison
    SET livre=TRUE, date_livraison=NOW()
    WHERE id_livraison=p_id;
END;
$$;


ALTER FUNCTION public.update_livraison_livre(p_id integer) OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 16799)
-- Name: update_paiement(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_paiement(p_id_livraison integer, p_id_panier integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE refere_a SET paye=TRUE
    WHERE id_livraison=p_id_livraison AND id_panier=p_id_panier;
END;
$$;


ALTER FUNCTION public.update_paiement(p_id_livraison integer, p_id_panier integer) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 16792)
-- Name: update_panier_statut(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_panier_statut(p_id integer, p_statut character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE panier SET statut=p_statut WHERE id_panier=p_id;
END;
$$;


ALTER FUNCTION public.update_panier_statut(p_id integer, p_statut character varying) OWNER TO postgres;

--
-- TOC entry 303 (class 1255 OID 16859)
-- Name: update_produit(integer, text, text, numeric, integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_produit(p_id_produit integer, p_nom_produit text, p_description text, p_prix numeric, p_stock integer, p_image_url text, p_type_produit text, p_id_categorie integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_produit(p_id_produit integer, p_nom_produit text, p_description text, p_prix numeric, p_stock integer, p_image_url text, p_type_produit text, p_id_categorie integer) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 16789)
-- Name: update_produit(integer, character varying, text, numeric, integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_produit(p_id integer, p_nom character varying, p_desc text, p_prix numeric, p_stock integer, p_image character varying, p_type character varying, p_cat integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE produit
    SET nom_produit=p_nom, description=p_desc, prix=p_prix,
        stock=p_stock, image_url=p_image, type_produit=p_type, id_categorie=p_cat
    WHERE id_produit=p_id;
END;
$$;


ALTER FUNCTION public.update_produit(p_id integer, p_nom character varying, p_desc text, p_prix numeric, p_stock integer, p_image character varying, p_type character varying, p_cat integer) OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 16786)
-- Name: update_utilisateur(integer, character varying, character varying, character varying, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_utilisateur(p_id integer, p_nom character varying, p_prenom character varying, p_email character varying, p_naissance date) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE utilisateur
    SET nom=p_nom, prenom=p_prenom, email=p_email, date_naissance=p_naissance
    WHERE id_user=p_id;
END;
$$;


ALTER FUNCTION public.update_utilisateur(p_id integer, p_nom character varying, p_prenom character varying, p_email character varying, p_naissance date) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 16664)
-- Name: adresse; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adresse (
    id_adresse integer NOT NULL,
    numero_rue character varying(10) NOT NULL,
    nom_rue character varying(150) NOT NULL,
    code_postal integer NOT NULL,
    ville character varying(100) NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE public.adresse OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16663)
-- Name: adresse_id_adresse_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adresse_id_adresse_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.adresse_id_adresse_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 222
-- Name: adresse_id_adresse_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adresse_id_adresse_seq OWNED BY public.adresse.id_adresse;


--
-- TOC entry 227 (class 1259 OID 16698)
-- Name: categorie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categorie (
    id_categorie integer NOT NULL,
    nom_categorie character varying(100) NOT NULL
);


ALTER TABLE public.categorie OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16697)
-- Name: categorie_id_categorie_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categorie_id_categorie_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorie_id_categorie_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 226
-- Name: categorie_id_categorie_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categorie_id_categorie_seq OWNED BY public.categorie.id_categorie;


--
-- TOC entry 230 (class 1259 OID 16732)
-- Name: contient; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contient (
    id_panier integer NOT NULL,
    id_produit integer NOT NULL,
    quantite integer DEFAULT 1 NOT NULL,
    prix_achat_u numeric(8,2) NOT NULL
);


ALTER TABLE public.contient OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16753)
-- Name: livraison; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.livraison (
    id_livraison integer NOT NULL,
    livre boolean DEFAULT false NOT NULL,
    date_commande timestamp without time zone DEFAULT now() NOT NULL,
    date_livraison timestamp without time zone,
    frais_livraison numeric(6,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.livraison OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16752)
-- Name: livraison_id_livraison_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.livraison_id_livraison_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.livraison_id_livraison_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 231
-- Name: livraison_id_livraison_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.livraison_id_livraison_seq OWNED BY public.livraison.id_livraison;


--
-- TOC entry 225 (class 1259 OID 16682)
-- Name: panier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.panier (
    id_panier integer NOT NULL,
    id_user integer,
    statut character varying(20) DEFAULT 'ouvert'::character varying NOT NULL
);


ALTER TABLE public.panier OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16681)
-- Name: panier_id_panier_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.panier_id_panier_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.panier_id_panier_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 224
-- Name: panier_id_panier_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.panier_id_panier_seq OWNED BY public.panier.id_panier;


--
-- TOC entry 229 (class 1259 OID 16709)
-- Name: produit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produit (
    id_produit integer NOT NULL,
    nom_produit character varying(200) NOT NULL,
    description text NOT NULL,
    prix numeric(8,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    image_url text,
    type_produit character varying(10) NOT NULL,
    id_categorie integer,
    CONSTRAINT produit_type_produit_check CHECK (((type_produit)::text = ANY ((ARRAY['livre'::character varying, 'dvd'::character varying])::text[])))
);


ALTER TABLE public.produit OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16708)
-- Name: produit_id_produit_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produit_id_produit_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produit_id_produit_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 228
-- Name: produit_id_produit_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produit_id_produit_seq OWNED BY public.produit.id_produit;


--
-- TOC entry 233 (class 1259 OID 16766)
-- Name: refere_a; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refere_a (
    id_livraison integer NOT NULL,
    id_panier integer NOT NULL,
    paye boolean DEFAULT false NOT NULL
);


ALTER TABLE public.refere_a OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16645)
-- Name: utilisateur; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utilisateur (
    id_user integer NOT NULL,
    nom text NOT NULL,
    prenom text NOT NULL,
    email text NOT NULL,
    mot_de_passe text NOT NULL,
    date_naissance date NOT NULL,
    role text DEFAULT 'client'::character varying NOT NULL
);


ALTER TABLE public.utilisateur OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16644)
-- Name: utilisateur_id_user_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utilisateur_id_user_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.utilisateur_id_user_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 220
-- Name: utilisateur_id_user_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utilisateur_id_user_seq OWNED BY public.utilisateur.id_user;


--
-- TOC entry 4954 (class 2604 OID 16667)
-- Name: adresse id_adresse; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresse ALTER COLUMN id_adresse SET DEFAULT nextval('public.adresse_id_adresse_seq'::regclass);


--
-- TOC entry 4957 (class 2604 OID 16701)
-- Name: categorie id_categorie; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie ALTER COLUMN id_categorie SET DEFAULT nextval('public.categorie_id_categorie_seq'::regclass);


--
-- TOC entry 4961 (class 2604 OID 16756)
-- Name: livraison id_livraison; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livraison ALTER COLUMN id_livraison SET DEFAULT nextval('public.livraison_id_livraison_seq'::regclass);


--
-- TOC entry 4955 (class 2604 OID 16685)
-- Name: panier id_panier; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panier ALTER COLUMN id_panier SET DEFAULT nextval('public.panier_id_panier_seq'::regclass);


--
-- TOC entry 4958 (class 2604 OID 16712)
-- Name: produit id_produit; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit ALTER COLUMN id_produit SET DEFAULT nextval('public.produit_id_produit_seq'::regclass);


--
-- TOC entry 4952 (class 2604 OID 16648)
-- Name: utilisateur id_user; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur ALTER COLUMN id_user SET DEFAULT nextval('public.utilisateur_id_user_seq'::regclass);


--
-- TOC entry 5146 (class 0 OID 16664)
-- Dependencies: 223
-- Data for Name: adresse; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adresse (id_adresse, numero_rue, nom_rue, code_postal, ville, id_user) FROM stdin;
1	12	Rue de la Paix	1000	Bruxelles	2
2	5	Avenue Louise	1050	Bruxelles	3
3	56	Juif	6110	Tel aviv	1
\.


--
-- TOC entry 5150 (class 0 OID 16698)
-- Dependencies: 227
-- Data for Name: categorie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categorie (id_categorie, nom_categorie) FROM stdin;
1	Science-Fiction
2	Romans
3	Jeunesse
4	Horreur
5	Action
6	DVD
\.


--
-- TOC entry 5153 (class 0 OID 16732)
-- Dependencies: 230
-- Data for Name: contient; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contient (id_panier, id_produit, quantite, prix_achat_u) FROM stdin;
7	2	1	24.99
8	4	1	7.99
14	9	1	15.00
15	9	4	15.00
16	8	1	10.99
16	1	1	14.99
16	6	1	11.99
\.


--
-- TOC entry 5155 (class 0 OID 16753)
-- Dependencies: 232
-- Data for Name: livraison; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.livraison (id_livraison, livre, date_commande, date_livraison, frais_livraison) FROM stdin;
1	f	2026-04-21 12:22:06.907388	\N	0.00
2	t	2026-04-21 12:25:43.220337	2026-04-21 20:37:19.763244	4.99
\.


--
-- TOC entry 5148 (class 0 OID 16682)
-- Dependencies: 225
-- Data for Name: panier; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.panier (id_panier, id_user, statut) FROM stdin;
1	1	validé
2	1	validé
3	1	ouvert
7	\N	commandé
8	\N	commandé
14	\N	commandé
15	11	commandé
16	11	commandé
\.


--
-- TOC entry 5152 (class 0 OID 16709)
-- Dependencies: 229
-- Data for Name: produit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.produit (id_produit, nom_produit, description, prix, stock, image_url, type_produit, id_categorie) FROM stdin;
9	Jurassic Park	Steven Spielberg	15.00	72	https://m.media-amazon.com/images/I/91PPR5VVHeL._AC_SL1500_.jpg	dvd	4
8	Fast & Furious 7 - DVD	Film d'action.	10.99	14	https://cdn.hmv.com/r/w-640/hmv/files/b6/b6389e57-3332-467f-b448-3613f54441e0.jpg	dvd	5
1	Dune - Tome 1	Frank Herbert - Épopée de science-fiction.	14.99	24	https://m.media-amazon.com/images/I/61HLU-TCZ8L._SL1311_.jpg	livre	1
6	Harry Potter à l'école des sorciers	J.K. Rowling - Premier tome.	11.99	15	https://the-wizards-shop.com/5135-thickbox_default/harry-potter-a-l-ecole-des-sorciers-tome-1.jpg	livre	3
2	Le Seigneur des Anneaux	J.R.R. Tolkien - Édition intégrale.	24.99	12	https://cdn1.booknode.com/book_cover/1/full/le-seigneur-des-anneaux-tome-1-la-communaute-de-lanneau-746.jpg	livre	1
3	1984	George Orwell - Roman dystopique.	9.99	40	https://miro.medium.com/v2/resize:fit:1200/1*LTr-PoAlBaNBYcVODU_1IQ.jpeg	livre	1
4	Matrix - DVD	Film culte de science-fiction.	7.99	30	https://i.ebayimg.com/images/g/igkAAOSw3YNlv1q~/s-l1600.jpg	dvd	6
5	Inception - DVD	Christopher Nolan - Thriller onirique.	8.99	20	https://images-na.ssl-images-amazon.com/images/I/71%2BG91CVpvL._SL1345_.jpg	dvd	6
7	Le Petit Prince	Antoine de Saint-Exupéry.	6.99	50	https://www.lepetitprince.com/wp-content/uploads/2023/01/COVER-Le-Petit-Prince-FR.jpg	livre	2
\.


--
-- TOC entry 5156 (class 0 OID 16766)
-- Dependencies: 233
-- Data for Name: refere_a; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refere_a (id_livraison, id_panier, paye) FROM stdin;
1	1	t
2	2	t
\.


--
-- TOC entry 5144 (class 0 OID 16645)
-- Dependencies: 221
-- Data for Name: utilisateur; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utilisateur (id_user, nom, prenom, email, mot_de_passe, date_naissance, role) FROM stdin;
1	Admin	Super	admin@livredvd.be	admin	1990-01-01	admin
2	Dupont	Marie	marie@test.be	dupont	1995-06-15	client
3	Martin	Paul	paul@test.be	martin	1988-03-22	client
4	Dupont	Jean	jean@email.com	1234	2000-05-15	client
11	Romain	Thomas	thomas.romain@condorcet.be	admin	2004-08-10	client
\.


--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 222
-- Name: adresse_id_adresse_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adresse_id_adresse_seq', 3, true);


--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 226
-- Name: categorie_id_categorie_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categorie_id_categorie_seq', 6, true);


--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 231
-- Name: livraison_id_livraison_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.livraison_id_livraison_seq', 2, true);


--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 224
-- Name: panier_id_panier_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.panier_id_panier_seq', 16, true);


--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 228
-- Name: produit_id_produit_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produit_id_produit_seq', 9, true);


--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 220
-- Name: utilisateur_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utilisateur_id_user_seq', 11, true);


--
-- TOC entry 4972 (class 2606 OID 16675)
-- Name: adresse adresse_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresse
    ADD CONSTRAINT adresse_pkey PRIMARY KEY (id_adresse);


--
-- TOC entry 4976 (class 2606 OID 16707)
-- Name: categorie categorie_nom_categorie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_nom_categorie_key UNIQUE (nom_categorie);


--
-- TOC entry 4978 (class 2606 OID 16705)
-- Name: categorie categorie_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categorie
    ADD CONSTRAINT categorie_pkey PRIMARY KEY (id_categorie);


--
-- TOC entry 4984 (class 2606 OID 16741)
-- Name: contient contient_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_pkey PRIMARY KEY (id_panier, id_produit);


--
-- TOC entry 4986 (class 2606 OID 16765)
-- Name: livraison livraison_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.livraison
    ADD CONSTRAINT livraison_pkey PRIMARY KEY (id_livraison);


--
-- TOC entry 4974 (class 2606 OID 16691)
-- Name: panier panier_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panier
    ADD CONSTRAINT panier_pkey PRIMARY KEY (id_panier);


--
-- TOC entry 4980 (class 2606 OID 16726)
-- Name: produit produit_nom_produit_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_nom_produit_key UNIQUE (nom_produit);


--
-- TOC entry 4982 (class 2606 OID 16724)
-- Name: produit produit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_pkey PRIMARY KEY (id_produit);


--
-- TOC entry 4988 (class 2606 OID 16774)
-- Name: refere_a refere_a_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refere_a
    ADD CONSTRAINT refere_a_pkey PRIMARY KEY (id_livraison, id_panier);


--
-- TOC entry 4968 (class 2606 OID 16853)
-- Name: utilisateur utilisateur_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_email_key UNIQUE (email);


--
-- TOC entry 4970 (class 2606 OID 16660)
-- Name: utilisateur utilisateur_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utilisateur
    ADD CONSTRAINT utilisateur_pkey PRIMARY KEY (id_user);


--
-- TOC entry 4989 (class 2606 OID 16676)
-- Name: adresse adresse_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adresse
    ADD CONSTRAINT adresse_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.utilisateur(id_user) ON DELETE CASCADE;


--
-- TOC entry 4992 (class 2606 OID 16742)
-- Name: contient contient_id_panier_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_id_panier_fkey FOREIGN KEY (id_panier) REFERENCES public.panier(id_panier) ON DELETE CASCADE;


--
-- TOC entry 4993 (class 2606 OID 16747)
-- Name: contient contient_id_produit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contient
    ADD CONSTRAINT contient_id_produit_fkey FOREIGN KEY (id_produit) REFERENCES public.produit(id_produit) ON DELETE CASCADE;


--
-- TOC entry 4990 (class 2606 OID 16692)
-- Name: panier panier_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.panier
    ADD CONSTRAINT panier_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.utilisateur(id_user) ON DELETE CASCADE;


--
-- TOC entry 4991 (class 2606 OID 16727)
-- Name: produit produit_id_categorie_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produit
    ADD CONSTRAINT produit_id_categorie_fkey FOREIGN KEY (id_categorie) REFERENCES public.categorie(id_categorie);


--
-- TOC entry 4994 (class 2606 OID 16775)
-- Name: refere_a refere_a_id_livraison_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refere_a
    ADD CONSTRAINT refere_a_id_livraison_fkey FOREIGN KEY (id_livraison) REFERENCES public.livraison(id_livraison) ON DELETE CASCADE;


--
-- TOC entry 4995 (class 2606 OID 16780)
-- Name: refere_a refere_a_id_panier_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refere_a
    ADD CONSTRAINT refere_a_id_panier_fkey FOREIGN KEY (id_panier) REFERENCES public.panier(id_panier) ON DELETE CASCADE;


-- Completed on 2026-05-06 16:14:03

--
-- PostgreSQL database dump complete
--

\unrestrict PgciwhWIXJUlM7a9kixnhjyXaZL1bCjtB0pxN6cFYGugdYsaEJIK3mwYhyDZ3Wd

