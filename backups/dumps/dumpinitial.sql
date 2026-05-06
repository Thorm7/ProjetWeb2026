-- Table: public.adresse

-- DROP TABLE IF EXISTS public.adresse;

CREATE TABLE IF NOT EXISTS public.adresse
(
    id_adresse integer NOT NULL DEFAULT nextval('adresse_id_adresse_seq'::regclass),
    numero_rue character varying(10) COLLATE pg_catalog."default" NOT NULL,
    nom_rue character varying(150) COLLATE pg_catalog."default" NOT NULL,
    code_postal integer NOT NULL,
    ville character varying(100) COLLATE pg_catalog."default" NOT NULL,
    id_user integer NOT NULL,
    CONSTRAINT adresse_pkey PRIMARY KEY (id_adresse),
    CONSTRAINT adresse_id_user_fkey FOREIGN KEY (id_user)
    REFERENCES public.utilisateur (id_user) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.adresse
    OWNER to postgres;

-- Table: public.categorie

-- DROP TABLE IF EXISTS public.categorie;

CREATE TABLE IF NOT EXISTS public.categorie
(
    id_categorie integer NOT NULL DEFAULT nextval('categorie_id_categorie_seq'::regclass),
    nom_categorie character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT categorie_pkey PRIMARY KEY (id_categorie),
    CONSTRAINT categorie_nom_categorie_key UNIQUE (nom_categorie)
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.categorie
    OWNER to postgres;

-- Table: public.contient

-- DROP TABLE IF EXISTS public.contient;

CREATE TABLE IF NOT EXISTS public.contient
(
    id_panier integer NOT NULL,
    id_produit integer NOT NULL,
    quantite integer NOT NULL DEFAULT 1,
    prix_achat_u numeric(8,2) NOT NULL,
    CONSTRAINT contient_pkey PRIMARY KEY (id_panier, id_produit),
    CONSTRAINT contient_id_panier_fkey FOREIGN KEY (id_panier)
    REFERENCES public.panier (id_panier) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    CONSTRAINT contient_id_produit_fkey FOREIGN KEY (id_produit)
    REFERENCES public.produit (id_produit) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.contient
    OWNER to postgres;

-- Table: public.livraison

-- DROP TABLE IF EXISTS public.livraison;

CREATE TABLE IF NOT EXISTS public.livraison
(
    id_livraison integer NOT NULL DEFAULT nextval('livraison_id_livraison_seq'::regclass),
    livre boolean NOT NULL DEFAULT false,
    date_commande timestamp without time zone NOT NULL DEFAULT now(),
    date_livraison timestamp without time zone,
    frais_livraison numeric(6,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT livraison_pkey PRIMARY KEY (id_livraison)
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.livraison
    OWNER to postgres;

-- Table: public.panier

-- DROP TABLE IF EXISTS public.panier;

CREATE TABLE IF NOT EXISTS public.panier
(
    id_panier integer NOT NULL DEFAULT nextval('panier_id_panier_seq'::regclass),
    id_user integer NOT NULL,
    statut character varying(20) COLLATE pg_catalog."default" NOT NULL DEFAULT 'ouvert'::character varying,
    CONSTRAINT panier_pkey PRIMARY KEY (id_panier),
    CONSTRAINT panier_id_user_fkey FOREIGN KEY (id_user)
    REFERENCES public.utilisateur (id_user) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.panier
    OWNER to postgres;

-- Table: public.produit

-- DROP TABLE IF EXISTS public.produit;

CREATE TABLE IF NOT EXISTS public.produit
(
    id_produit integer NOT NULL DEFAULT nextval('produit_id_produit_seq'::regclass),
    nom_produit character varying(200) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default" NOT NULL,
    prix numeric(8,2) NOT NULL,
    stock integer NOT NULL DEFAULT 0,
    image_url text COLLATE pg_catalog."default",
    type_produit character varying(10) COLLATE pg_catalog."default" NOT NULL,
    id_categorie integer,
    CONSTRAINT produit_pkey PRIMARY KEY (id_produit),
    CONSTRAINT produit_nom_produit_key UNIQUE (nom_produit),
    CONSTRAINT produit_id_categorie_fkey FOREIGN KEY (id_categorie)
    REFERENCES public.categorie (id_categorie) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
    CONSTRAINT produit_type_produit_check CHECK (type_produit::text = ANY (ARRAY['livre'::character varying, 'dvd'::character varying]::text[]))
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.produit
    OWNER to postgres;

-- Table: public.refere_a

-- DROP TABLE IF EXISTS public.refere_a;

CREATE TABLE IF NOT EXISTS public.refere_a
(
    id_livraison integer NOT NULL,
    id_panier integer NOT NULL,
    paye boolean NOT NULL DEFAULT false,
    CONSTRAINT refere_a_pkey PRIMARY KEY (id_livraison, id_panier),
    CONSTRAINT refere_a_id_livraison_fkey FOREIGN KEY (id_livraison)
    REFERENCES public.livraison (id_livraison) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    CONSTRAINT refere_a_id_panier_fkey FOREIGN KEY (id_panier)
    REFERENCES public.panier (id_panier) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.refere_a
    OWNER to postgres;

-- Table: public.utilisateur

-- DROP TABLE IF EXISTS public.utilisateur;

CREATE TABLE IF NOT EXISTS public.utilisateur
(
    id_user integer NOT NULL DEFAULT nextval('utilisateur_id_user_seq'::regclass),
    nom text COLLATE pg_catalog."default" NOT NULL,
    prenom text COLLATE pg_catalog."default" NOT NULL,
    email text COLLATE pg_catalog."default" NOT NULL,
    mot_de_passe text COLLATE pg_catalog."default" NOT NULL,
    date_naissance date NOT NULL,
    role text COLLATE pg_catalog."default" NOT NULL DEFAULT 'client'::character varying,
    CONSTRAINT utilisateur_pkey PRIMARY KEY (id_user),
    CONSTRAINT utilisateur_email_key UNIQUE (email)
    )

    TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.utilisateur
    OWNER to postgres;