PGDMP     $                    {            adv    15.1    15.1 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16398    adv    DATABASE     w   CREATE DATABASE adv WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE adv;
                postgres    false            �            1255    16593    dateofclosing()    FUNCTION     �  CREATE FUNCTION public.dateofclosing() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	if (new.dateofclosing = new.dateofestablishment) 
		then raise exception 'Запрещено ставить одинаковые дни!';
	elseif (new.dateofclosing < new.dateofestablishment)
		then raise exception 'Дата закрытия не может быть меньше чем дата заведения дела!';
	end if;
	return new;
END
$$;
 &   DROP FUNCTION public.dateofclosing();
       public          postgres    false            �            1255    16399    price_case()    FUNCTION     �   CREATE FUNCTION public.price_case() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE contracts
		SET price_case = NEW.price * NEW.premium;
	RETURN price_case;
END;
$$;
 #   DROP FUNCTION public.price_case();
       public          postgres    false            �            1255    16400    set_price()    FUNCTION     u  CREATE FUNCTION public.set_price() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
		IF NEW.issue = 'выиграно' THEN
			UPDATE contracts
			SET price_case = price * premium
			WHERE contracts.id = NEW.contractid;
			
		ELSE
			UPDATE contracts
			SET price_case = price
			WHERE contracts.id = NEW.contractid;	
		END IF;
		
        RETURN NEW;
    END;
$$;
 "   DROP FUNCTION public.set_price();
       public          postgres    false            �            1255    16589    set_price2()    FUNCTION     �  CREATE FUNCTION public.set_price2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
		IF NEW.issue = 'выиграно' THEN
			UPDATE contracts
			SET price_case = ((price/100)*premium)+price
			WHERE contracts.id = NEW.contractid;
			
		ELSE
			UPDATE contracts
			SET price_case = price
			WHERE contracts.id = NEW.contractid;	
		END IF;
		
        RETURN NEW;
    END;
$$;
 #   DROP FUNCTION public.set_price2();
       public          postgres    false            �            1259    16401 	   advocates    TABLE     (  CREATE TABLE public.advocates (
    id integer NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    date_birth date NOT NULL,
    start_date date NOT NULL,
    seniority character varying(100) NOT NULL
);
    DROP TABLE public.advocates;
       public         heap    postgres    false            �            1259    16404    advocates_id_seq    SEQUENCE     �   CREATE SEQUENCE public.advocates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.advocates_id_seq;
       public          postgres    false    214            �           0    0    advocates_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.advocates_id_seq OWNED BY public.advocates.id;
          public          postgres    false    215            �            1259    16405    articles    TABLE     �   CREATE TABLE public.articles (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    number character varying(50) NOT NULL,
    chapterid integer NOT NULL
);
    DROP TABLE public.articles;
       public         heap    postgres    false            �            1259    16408    articles_id_seq    SEQUENCE     �   CREATE SEQUENCE public.articles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.articles_id_seq;
       public          postgres    false    216            �           0    0    articles_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.articles_id_seq OWNED BY public.articles.id;
          public          postgres    false    217            �            1259    16409    chapters    TABLE     d   CREATE TABLE public.chapters (
    id integer NOT NULL,
    name character varying(200) NOT NULL
);
    DROP TABLE public.chapters;
       public         heap    postgres    false            �            1259    16412    chapters_id_seq    SEQUENCE     �   CREATE SEQUENCE public.chapters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.chapters_id_seq;
       public          postgres    false    218            �           0    0    chapters_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.chapters_id_seq OWNED BY public.chapters.id;
          public          postgres    false    219            �            1259    16413    clients    TABLE     4  CREATE TABLE public.clients (
    id integer NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    date_birth date NOT NULL,
    telephone character varying(50) NOT NULL,
    passport character varying(50) NOT NULL
);
    DROP TABLE public.clients;
       public         heap    postgres    false            �            1259    16416    clients_id_seq    SEQUENCE     �   CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.clients_id_seq;
       public          postgres    false    220            �           0    0    clients_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;
          public          postgres    false    221            �            1259    16417 	   contracts    TABLE     
  CREATE TABLE public.contracts (
    id integer NOT NULL,
    advocateid integer NOT NULL,
    clientid integer NOT NULL,
    dateconclusion date NOT NULL,
    price double precision NOT NULL,
    premium double precision NOT NULL,
    price_case double precision
);
    DROP TABLE public.contracts;
       public         heap    postgres    false            �            1259    16420    contracts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.contracts_id_seq;
       public          postgres    false    222            �           0    0    contracts_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;
          public          postgres    false    223            �            1259    16421 	   courtcase    TABLE     :  CREATE TABLE public.courtcase (
    id integer NOT NULL,
    contractid integer NOT NULL,
    dateofestablishment date NOT NULL,
    dateofclosing date NOT NULL,
    sentence integer NOT NULL,
    violationid integer NOT NULL,
    term character varying(150) NOT NULL,
    issue character varying(150) NOT NULL
);
    DROP TABLE public.courtcase;
       public         heap    postgres    false            �            1259    16424    courtcase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courtcase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.courtcase_id_seq;
       public          postgres    false    224            �           0    0    courtcase_id_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE public.courtcase_id_seq OWNED BY public.courtcase.id;
          public          postgres    false    225            �            1259    16425    courtdirectory    TABLE     �   CREATE TABLE public.courtdirectory (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    address character varying(100) NOT NULL
);
 "   DROP TABLE public.courtdirectory;
       public         heap    postgres    false            �            1259    16428    courtdirectory_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courtdirectory_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.courtdirectory_id_seq;
       public          postgres    false    226            �           0    0    courtdirectory_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.courtdirectory_id_seq OWNED BY public.courtdirectory.id;
          public          postgres    false    227            �            1259    16429    courts    TABLE     x   CREATE TABLE public.courts (
    id integer NOT NULL,
    judgeid integer NOT NULL,
    directoryid integer NOT NULL
);
    DROP TABLE public.courts;
       public         heap    postgres    false            �            1259    16432    courts_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.courts_id_seq;
       public          postgres    false    228            �           0    0    courts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.courts_id_seq OWNED BY public.courts.id;
          public          postgres    false    229            �            1259    16433    courtsessions    TABLE     �   CREATE TABLE public.courtsessions (
    id integer NOT NULL,
    courtcaseid integer NOT NULL,
    date date NOT NULL,
    furtherreview character varying(100) NOT NULL,
    courtid integer NOT NULL
);
 !   DROP TABLE public.courtsessions;
       public         heap    postgres    false            �            1259    16436    courtsessions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.courtsessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.courtsessions_id_seq;
       public          postgres    false    230            �           0    0    courtsessions_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.courtsessions_id_seq OWNED BY public.courtsessions.id;
          public          postgres    false    231            �            1259    16437    essencecase    TABLE        CREATE TABLE public.essencecase (
    id integer NOT NULL,
    courtcaseid integer NOT NULL,
    articleid integer NOT NULL
);
    DROP TABLE public.essencecase;
       public         heap    postgres    false            �            1259    16440    essencecase_id_seq    SEQUENCE     �   CREATE SEQUENCE public.essencecase_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.essencecase_id_seq;
       public          postgres    false    232            �           0    0    essencecase_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.essencecase_id_seq OWNED BY public.essencecase.id;
          public          postgres    false    233            �            1259    16441    judges    TABLE     %  CREATE TABLE public.judges (
    id integer NOT NULL,
    surname character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    date_birth date NOT NULL,
    start_date date NOT NULL,
    seniority character varying(100) NOT NULL
);
    DROP TABLE public.judges;
       public         heap    postgres    false            �            1259    16444    judges_id_seq    SEQUENCE     �   CREATE SEQUENCE public.judges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.judges_id_seq;
       public          postgres    false    234            �           0    0    judges_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.judges_id_seq OWNED BY public.judges.id;
          public          postgres    false    235            �            1259    16445    paragraphsarticle    TABLE     �   CREATE TABLE public.paragraphsarticle (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    articleid integer NOT NULL
);
 %   DROP TABLE public.paragraphsarticle;
       public         heap    postgres    false            �            1259    16448    paragraphsarticle_id_seq    SEQUENCE     �   CREATE SEQUENCE public.paragraphsarticle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.paragraphsarticle_id_seq;
       public          postgres    false    236            �           0    0    paragraphsarticle_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.paragraphsarticle_id_seq OWNED BY public.paragraphsarticle.id;
          public          postgres    false    237            �            1259    16449 
   procedures    TABLE     �   CREATE TABLE public.procedures (
    id integer NOT NULL,
    courtcaseid integer NOT NULL,
    date date NOT NULL,
    serviceid integer NOT NULL
);
    DROP TABLE public.procedures;
       public         heap    postgres    false            �            1259    16452    procedures_id_seq    SEQUENCE     �   CREATE SEQUENCE public.procedures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.procedures_id_seq;
       public          postgres    false    238            �           0    0    procedures_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.procedures_id_seq OWNED BY public.procedures.id;
          public          postgres    false    239            �            1259    16453    punishments    TABLE     g   CREATE TABLE public.punishments (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);
    DROP TABLE public.punishments;
       public         heap    postgres    false            �            1259    16456    punishments_id_seq    SEQUENCE     �   CREATE SEQUENCE public.punishments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.punishments_id_seq;
       public          postgres    false    240            �           0    0    punishments_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.punishments_id_seq OWNED BY public.punishments.id;
          public          postgres    false    241            �            1259    16457    services    TABLE     �   CREATE TABLE public.services (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    price double precision NOT NULL
);
    DROP TABLE public.services;
       public         heap    postgres    false            �            1259    16460    services_id_seq    SEQUENCE     �   CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.services_id_seq;
       public          postgres    false    242            �           0    0    services_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;
          public          postgres    false    243            �            1259    16461    typeviolations    TABLE     i   CREATE TABLE public.typeviolations (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);
 "   DROP TABLE public.typeviolations;
       public         heap    postgres    false            �            1259    16464    typeviolations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.typeviolations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.typeviolations_id_seq;
       public          postgres    false    244            �           0    0    typeviolations_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE public.typeviolations_id_seq OWNED BY public.typeviolations.id;
          public          postgres    false    245            �           2604    16465    advocates id    DEFAULT     l   ALTER TABLE ONLY public.advocates ALTER COLUMN id SET DEFAULT nextval('public.advocates_id_seq'::regclass);
 ;   ALTER TABLE public.advocates ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    215    214            �           2604    16466    articles id    DEFAULT     j   ALTER TABLE ONLY public.articles ALTER COLUMN id SET DEFAULT nextval('public.articles_id_seq'::regclass);
 :   ALTER TABLE public.articles ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            �           2604    16467    chapters id    DEFAULT     j   ALTER TABLE ONLY public.chapters ALTER COLUMN id SET DEFAULT nextval('public.chapters_id_seq'::regclass);
 :   ALTER TABLE public.chapters ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    218            �           2604    16468 
   clients id    DEFAULT     h   ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);
 9   ALTER TABLE public.clients ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            �           2604    16469    contracts id    DEFAULT     l   ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);
 ;   ALTER TABLE public.contracts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    223    222            �           2604    16470    courtcase id    DEFAULT     l   ALTER TABLE ONLY public.courtcase ALTER COLUMN id SET DEFAULT nextval('public.courtcase_id_seq'::regclass);
 ;   ALTER TABLE public.courtcase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224            �           2604    16471    courtdirectory id    DEFAULT     v   ALTER TABLE ONLY public.courtdirectory ALTER COLUMN id SET DEFAULT nextval('public.courtdirectory_id_seq'::regclass);
 @   ALTER TABLE public.courtdirectory ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    227    226            �           2604    16472 	   courts id    DEFAULT     f   ALTER TABLE ONLY public.courts ALTER COLUMN id SET DEFAULT nextval('public.courts_id_seq'::regclass);
 8   ALTER TABLE public.courts ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    229    228            �           2604    16473    courtsessions id    DEFAULT     t   ALTER TABLE ONLY public.courtsessions ALTER COLUMN id SET DEFAULT nextval('public.courtsessions_id_seq'::regclass);
 ?   ALTER TABLE public.courtsessions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    231    230            �           2604    16474    essencecase id    DEFAULT     p   ALTER TABLE ONLY public.essencecase ALTER COLUMN id SET DEFAULT nextval('public.essencecase_id_seq'::regclass);
 =   ALTER TABLE public.essencecase ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    233    232            �           2604    16475 	   judges id    DEFAULT     f   ALTER TABLE ONLY public.judges ALTER COLUMN id SET DEFAULT nextval('public.judges_id_seq'::regclass);
 8   ALTER TABLE public.judges ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    235    234            �           2604    16476    paragraphsarticle id    DEFAULT     |   ALTER TABLE ONLY public.paragraphsarticle ALTER COLUMN id SET DEFAULT nextval('public.paragraphsarticle_id_seq'::regclass);
 C   ALTER TABLE public.paragraphsarticle ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    237    236            �           2604    16477    procedures id    DEFAULT     n   ALTER TABLE ONLY public.procedures ALTER COLUMN id SET DEFAULT nextval('public.procedures_id_seq'::regclass);
 <   ALTER TABLE public.procedures ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    239    238            �           2604    16478    punishments id    DEFAULT     p   ALTER TABLE ONLY public.punishments ALTER COLUMN id SET DEFAULT nextval('public.punishments_id_seq'::regclass);
 =   ALTER TABLE public.punishments ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    241    240            �           2604    16479    services id    DEFAULT     j   ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);
 :   ALTER TABLE public.services ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    243    242            �           2604    16480    typeviolations id    DEFAULT     v   ALTER TABLE ONLY public.typeviolations ALTER COLUMN id SET DEFAULT nextval('public.typeviolations_id_seq'::regclass);
 @   ALTER TABLE public.typeviolations ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    245    244            �          0    16401 	   advocates 
   TABLE DATA                 public          postgres    false    214   V�       �          0    16405    articles 
   TABLE DATA                 public          postgres    false    216   g�       �          0    16409    chapters 
   TABLE DATA                 public          postgres    false    218   k�       �          0    16413    clients 
   TABLE DATA                 public          postgres    false    220   �       �          0    16417 	   contracts 
   TABLE DATA                 public          postgres    false    222   ��       �          0    16421 	   courtcase 
   TABLE DATA                 public          postgres    false    224   �       �          0    16425    courtdirectory 
   TABLE DATA                 public          postgres    false    226   ��       �          0    16429    courts 
   TABLE DATA                 public          postgres    false    228   ��       �          0    16433    courtsessions 
   TABLE DATA                 public          postgres    false    230   (�       �          0    16437    essencecase 
   TABLE DATA                 public          postgres    false    232   [�       �          0    16441    judges 
   TABLE DATA                 public          postgres    false    234   �       �          0    16445    paragraphsarticle 
   TABLE DATA                 public          postgres    false    236   I�       �          0    16449 
   procedures 
   TABLE DATA                 public          postgres    false    238   �       �          0    16453    punishments 
   TABLE DATA                 public          postgres    false    240   �       �          0    16457    services 
   TABLE DATA                 public          postgres    false    242   ��       �          0    16461    typeviolations 
   TABLE DATA                 public          postgres    false    244   �       �           0    0    advocates_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.advocates_id_seq', 1, false);
          public          postgres    false    215            �           0    0    articles_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.articles_id_seq', 1, false);
          public          postgres    false    217            �           0    0    chapters_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.chapters_id_seq', 1, false);
          public          postgres    false    219            �           0    0    clients_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.clients_id_seq', 1, false);
          public          postgres    false    221            �           0    0    contracts_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.contracts_id_seq', 1, false);
          public          postgres    false    223            �           0    0    courtcase_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.courtcase_id_seq', 1, false);
          public          postgres    false    225            �           0    0    courtdirectory_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.courtdirectory_id_seq', 1, false);
          public          postgres    false    227            �           0    0    courts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.courts_id_seq', 1, false);
          public          postgres    false    229            �           0    0    courtsessions_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.courtsessions_id_seq', 1, false);
          public          postgres    false    231            �           0    0    essencecase_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.essencecase_id_seq', 1, false);
          public          postgres    false    233            �           0    0    judges_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.judges_id_seq', 1, false);
          public          postgres    false    235            �           0    0    paragraphsarticle_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.paragraphsarticle_id_seq', 1, false);
          public          postgres    false    237            �           0    0    procedures_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.procedures_id_seq', 1, false);
          public          postgres    false    239            �           0    0    punishments_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.punishments_id_seq', 1, false);
          public          postgres    false    241            �           0    0    services_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.services_id_seq', 1, false);
          public          postgres    false    243            �           0    0    typeviolations_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('public.typeviolations_id_seq', 1, false);
          public          postgres    false    245            �           2606    16482    advocates advocates_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.advocates
    ADD CONSTRAINT advocates_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.advocates DROP CONSTRAINT advocates_pkey;
       public            postgres    false    214            �           2606    16484    articles articles_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.articles DROP CONSTRAINT articles_pkey;
       public            postgres    false    216            �           2606    16486    chapters chapters_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.chapters
    ADD CONSTRAINT chapters_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.chapters DROP CONSTRAINT chapters_pkey;
       public            postgres    false    218            �           2606    16488    clients clients_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.clients DROP CONSTRAINT clients_pkey;
       public            postgres    false    220            �           2606    16490    contracts contracts_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_pkey;
       public            postgres    false    222            �           2606    16492    courtcase courtcase_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.courtcase
    ADD CONSTRAINT courtcase_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.courtcase DROP CONSTRAINT courtcase_pkey;
       public            postgres    false    224            �           2606    16494 "   courtdirectory courtdirectory_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.courtdirectory
    ADD CONSTRAINT courtdirectory_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.courtdirectory DROP CONSTRAINT courtdirectory_pkey;
       public            postgres    false    226            �           2606    16496    courts courts_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.courts
    ADD CONSTRAINT courts_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.courts DROP CONSTRAINT courts_pkey;
       public            postgres    false    228            �           2606    16498     courtsessions courtsessions_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.courtsessions
    ADD CONSTRAINT courtsessions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.courtsessions DROP CONSTRAINT courtsessions_pkey;
       public            postgres    false    230            �           2606    16500    essencecase essencecase_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.essencecase
    ADD CONSTRAINT essencecase_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.essencecase DROP CONSTRAINT essencecase_pkey;
       public            postgres    false    232            �           2606    16502    judges judges_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.judges
    ADD CONSTRAINT judges_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.judges DROP CONSTRAINT judges_pkey;
       public            postgres    false    234            �           2606    16504 (   paragraphsarticle paragraphsarticle_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.paragraphsarticle
    ADD CONSTRAINT paragraphsarticle_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.paragraphsarticle DROP CONSTRAINT paragraphsarticle_pkey;
       public            postgres    false    236            �           2606    16506    procedures procedures_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT procedures_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.procedures DROP CONSTRAINT procedures_pkey;
       public            postgres    false    238            �           2606    16508    punishments punishments_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.punishments
    ADD CONSTRAINT punishments_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.punishments DROP CONSTRAINT punishments_pkey;
       public            postgres    false    240            �           2606    16510    services services_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.services DROP CONSTRAINT services_pkey;
       public            postgres    false    242            �           2606    16512 "   typeviolations typeviolations_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.typeviolations
    ADD CONSTRAINT typeviolations_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.typeviolations DROP CONSTRAINT typeviolations_pkey;
       public            postgres    false    244            �           2620    16595    courtcase dateofcourt    TRIGGER     }   CREATE TRIGGER dateofcourt BEFORE INSERT OR UPDATE ON public.courtcase FOR EACH ROW EXECUTE FUNCTION public.dateofclosing();
 .   DROP TRIGGER dateofcourt ON public.courtcase;
       public          postgres    false    224    249            �           2620    16596    courtcase set_price_trigger2    TRIGGER     �   CREATE TRIGGER set_price_trigger2 BEFORE INSERT OR UPDATE ON public.courtcase FOR EACH ROW EXECUTE FUNCTION public.set_price2();
 5   DROP TRIGGER set_price_trigger2 ON public.courtcase;
       public          postgres    false    248    224            �           2606    16514     articles articles_chapterid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.articles
    ADD CONSTRAINT articles_chapterid_fkey FOREIGN KEY (chapterid) REFERENCES public.chapters(id);
 J   ALTER TABLE ONLY public.articles DROP CONSTRAINT articles_chapterid_fkey;
       public          postgres    false    218    3273    216            �           2606    16519 #   contracts contracts_advocateid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_advocateid_fkey FOREIGN KEY (advocateid) REFERENCES public.advocates(id);
 M   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_advocateid_fkey;
       public          postgres    false    214    3269    222            �           2606    16524 !   contracts contracts_clientid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_clientid_fkey FOREIGN KEY (clientid) REFERENCES public.clients(id);
 K   ALTER TABLE ONLY public.contracts DROP CONSTRAINT contracts_clientid_fkey;
       public          postgres    false    3275    220    222            �           2606    16529 #   courtcase courtcase_contractid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courtcase
    ADD CONSTRAINT courtcase_contractid_fkey FOREIGN KEY (contractid) REFERENCES public.contracts(id);
 M   ALTER TABLE ONLY public.courtcase DROP CONSTRAINT courtcase_contractid_fkey;
       public          postgres    false    224    3277    222            �           2606    16534 !   courtcase courtcase_sentence_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courtcase
    ADD CONSTRAINT courtcase_sentence_fkey FOREIGN KEY (sentence) REFERENCES public.punishments(id);
 K   ALTER TABLE ONLY public.courtcase DROP CONSTRAINT courtcase_sentence_fkey;
       public          postgres    false    240    224    3295            �           2606    16539 $   courtcase courtcase_violationid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courtcase
    ADD CONSTRAINT courtcase_violationid_fkey FOREIGN KEY (violationid) REFERENCES public.typeviolations(id);
 N   ALTER TABLE ONLY public.courtcase DROP CONSTRAINT courtcase_violationid_fkey;
       public          postgres    false    224    244    3299            �           2606    16544    courts courts_directoryid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courts
    ADD CONSTRAINT courts_directoryid_fkey FOREIGN KEY (directoryid) REFERENCES public.courtdirectory(id);
 H   ALTER TABLE ONLY public.courts DROP CONSTRAINT courts_directoryid_fkey;
       public          postgres    false    226    3281    228            �           2606    16549    courts courts_judgeid_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.courts
    ADD CONSTRAINT courts_judgeid_fkey FOREIGN KEY (judgeid) REFERENCES public.judges(id);
 D   ALTER TABLE ONLY public.courts DROP CONSTRAINT courts_judgeid_fkey;
       public          postgres    false    234    228    3289            �           2606    16554 ,   courtsessions courtsessions_courtcaseid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courtsessions
    ADD CONSTRAINT courtsessions_courtcaseid_fkey FOREIGN KEY (courtcaseid) REFERENCES public.courtcase(id);
 V   ALTER TABLE ONLY public.courtsessions DROP CONSTRAINT courtsessions_courtcaseid_fkey;
       public          postgres    false    3279    230    224            �           2606    16559 (   courtsessions courtsessions_courtid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.courtsessions
    ADD CONSTRAINT courtsessions_courtid_fkey FOREIGN KEY (courtid) REFERENCES public.courts(id);
 R   ALTER TABLE ONLY public.courtsessions DROP CONSTRAINT courtsessions_courtid_fkey;
       public          postgres    false    228    3283    230            �           2606    16564 &   essencecase essencecase_articleid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.essencecase
    ADD CONSTRAINT essencecase_articleid_fkey FOREIGN KEY (articleid) REFERENCES public.articles(id);
 P   ALTER TABLE ONLY public.essencecase DROP CONSTRAINT essencecase_articleid_fkey;
       public          postgres    false    216    3271    232            �           2606    16569 (   essencecase essencecase_courtcaseid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.essencecase
    ADD CONSTRAINT essencecase_courtcaseid_fkey FOREIGN KEY (courtcaseid) REFERENCES public.courtcase(id);
 R   ALTER TABLE ONLY public.essencecase DROP CONSTRAINT essencecase_courtcaseid_fkey;
       public          postgres    false    232    224    3279            �           2606    16574 2   paragraphsarticle paragraphsarticle_articleid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.paragraphsarticle
    ADD CONSTRAINT paragraphsarticle_articleid_fkey FOREIGN KEY (articleid) REFERENCES public.articles(id);
 \   ALTER TABLE ONLY public.paragraphsarticle DROP CONSTRAINT paragraphsarticle_articleid_fkey;
       public          postgres    false    3271    236    216            �           2606    16579 &   procedures procedures_courtcaseid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT procedures_courtcaseid_fkey FOREIGN KEY (courtcaseid) REFERENCES public.courtcase(id);
 P   ALTER TABLE ONLY public.procedures DROP CONSTRAINT procedures_courtcaseid_fkey;
       public          postgres    false    224    238    3279            �           2606    16584 $   procedures procedures_serviceid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.procedures
    ADD CONSTRAINT procedures_serviceid_fkey FOREIGN KEY (serviceid) REFERENCES public.services(id);
 N   ALTER TABLE ONLY public.procedures DROP CONSTRAINT procedures_serviceid_fkey;
       public          postgres    false    242    3297    238            �     x�ŕMKA��~��m�3���ҩ�!
z�ƚB��[�M��XQA݃�e�R�+�|��yqM��,3������,�n��7QyusW���E�zR���Z-�j7��Z�����
wv*A#܃K��wdֵà���,�^^�*m��C�}q�#�����Y�v%Z�#����7"��_��^��<�)���1�`	&wVv)S�?�t=`j��cC�y#��Z�ɗ�O)���j
S{�
lIx���F���hG��U�'��w�`�o����Y�((�� ��؆%]���C�T�QUߧ��z�
'E�}��h�v��fr>��>r�#2�Q>��N��}[�i'݁�"98鏝ßa=gP���'� 20�;%��W]���D�Ӑ�e��a�0����khU�uw#d��@<����"��#p\L\L�F���o������Տ�i���(;}Z�?�b4k�$����(��M7j6o:-V21����8<L���D�cK���/N� $      �   �  x��W[KA~�W̛
�d��\�S|��j��%Ѐ���D���Rh�^�ج�ds�3���|3���@[tYg�9�9�;�9�����|C��m<�G[���G�������T�Ɉכ{z�mU2b����a堺�,^>y�be],y�(���U]5Ա˾��P&2�U�#ѷ�:����m�Z���E:&��[~���`T��AE�F��c9���g����' Yp�g���@I dru%���%B*���$�mf��qG���-!7b�W�py��97�0�3�CߧgΉ�y��;�dbd�.�u��� ���  b�Ā!��M��5 AF/�l���(̰!�\n ��@B�	�Z^Rvr��RO�^���x�$�)�r��%�\9Q'��G�`�����x��Bu��6�ߔ��-;�UfX�t�L�P�-�X]����}+�:4^�/��wGN���X�R�F�1�dd�!�ø��	��z��FA�7�W��s�a/g�W������g�w&G�v��y7v!�׈<DΚ(�3�B�byg����кX��&}�Y�$s;hY(EwP��_�������P`�g�n�A8�YSD�TQ���Iqq���,Bu�?��9�0�B�����ܡ-Z��z;��{@��ߡ��BQ��$���jˁ;�e�R�hz�a��b1�)4CS�é~�Ԕ�9�M���ZM|�y����} J��C�L���ys��A����J���m�!O�r��~��Y���������;�9;�t�Щ�M�0]�8NFt���z�Cau����n`��b[<G����ߝż��{?՝9c$��*f�c��@�1�x$J����I��f�gߘ�6(�s}��k�(1]Jn���%w�?	��σ�;s�D�8���[�;��y�0��i�aZ��)r�-��Q���|"�������U�Q:��K{v��n3�tl����2�}(:���j�p�@=�v�Dy�ꊐ��-���eݘ�(@M�p[��������
      �   �  x��T�JA��)�N��?���!Һ7*��{�����`]]���}�sި��n�Bĺ;�̜s���w�L�P��T�P:T��ӋZe�r^��V�oT�v�QW��jZ���*�ͨ$���9Y��^"�\�����-~"��|��E�"����ȣ)9�Фc����O�q��q.@G��Ţ��&���.�b@oD��&� �c��Q����0T���\���l��p��8�lF��T���Tpq�]�D��L��c����y�G[�3 �@=-���mWs�۾�%~:D��"H���Ik`�G��e:3��^�A�q7Pu.>%n���� �oǠ���tb��1`w�0~�<�4�_E��i�a�w��(�X��/���ћJdx	.�B
���b��'/[�N"�=��      �   �  x����jQ��y�٥Ōܿs�ŕ�.R�V����b�t�������VDDE|�1M`l�>ýo�9w&�It�s�0�������ڳ͠���4��o�[��ۭfg�VZ;�����4^5kA��n���Nc�|���vk���nvw�:P�6���^o��x����F�BkA�^ډ�����S�U�zno�����N��}�����H�������=j�
))��e�bF3B"�K&$c��G���b)�P�RTWS��ݩ;�wp?���kH�q�b��萲�<eR���rX8*�JU"�W�Ԏ�����S�A
2:�0Lkƅ�� �Q]�@�_A���ܑ��,�_�3wb'Pǎ�'rwLHLH͜�2�	�G'��ᒨ�8q�St�4�SR|�Rg�s�4�����x$�,��\3UK�%=�Y�]z�	�n�>�3�r#��㴊$%��C�Rg&0���d��Ͼ��Ӑ�7��Rx6Z��Q9�5j|��i��R`?��c��	��` �g��G�y��d9u~��ݛ�9��-ԓl�D�)|<�B�q���@"HF��2eE�?��Q6�r���G�(O��R�ģB"C�	�(W��Î�QIq�~����^i���?��l��C�%rQ����\ʴ�4�!W��Ʀt      �   ,  x���Mk�@໿bn*얙�H=��!P,T�kI�1�����.�VxC&�/�Ի��� �����o߅�0ӥ	�V�QAs�C3�2��k�I�#��C�v��|�B+����N��'4�v�o�_�=�HA�� U�&�T`���ё���Ψ2��V�h�AQ�Ye0��UVA��H�2�U�*[�W91��J�g��*�i̬��������+�U� &�*m*VU�U� ��ɲ���7�A�]��e��h���B�*LcfU� &u�&��g�2��U��#�H°*�U�C�f�b�9��      �   �  x�ՕAO�0�����6H:�vt�x����`"�}��K`3�xL�p� h�A�/���n�&�9��~�����m�?�^������z� �ME�'��AGb�"}���7<�ޙ�Mx$�b0��0�E��"���!�Ǿ�(�T��A�$3ހ�ӳ�� ��^�ĳ1��c�`�b�Zf���oj������r��r��;�qR��+E@��)��cSj��+!��à�j�MPs�(_2�/������1$E��*�����/�_��D�1��X�g�$�䦪�0�Їb�hvv�Z������_������f��\���=�6���u,������}4�2�~�::�!�&��9��eC�C�c�7�W�̈媣o+�1�p@�0���;�Iۛ���&�վ'��,      �   �  x���KoQ��|���&�v��+,HLM�p_����p7�������F��#�G�~�s���s�X���!�d�s�9��y���Nn{��[�/�}���r�q�Ҩ֋�j�P�T?P�\����ےE��b�T��ѫ�/�r;��-��W���C�r�}9�	�xL��<�i�3i��@ُ��)��=��+-q��|ǩE�p��ڳX>dR!�y(�<�_��nJg��'g�S�E'J��%��M8�+5߳Я*Zd��Li��A���́�� 4M��'`r=:���u!p���;n|��Z�6[���N��`�Ҷh�I6:�j�,���.fNNP��p'�#�-JE�ʨD�߱p'F ��]�J�ڄ�Ĭ��Ѵͩ�*����w���N��w�'�-f ǈ�-.�8������B>"�x���EV���?��С_G�a��������@{]վ���4\�@D`�����<�Ռ��D-����0�C�      �   �   x���=
�@��~O��1����E���D�n�!�fo�<�0�0կ�tu��6���x�rc��Y��W�ρ�qp��縟/��CVX~2V�lL˔�e��e*�2;�2{�2�2G�2�zy��ɘjڛ      �   #  x����J�0�{�bn��̤M����
���z�m#ĕvW�>�=���L[��&!�A��/6������^·���(����ڶ���-,�J�pU�[����
xp7��i�km��^��
��[X� �
�HԒ��������hu\��Z��T�	h�I�⑦�Ɛ�9�D@�i���g��	'�hI8�5'�
H'��[38�3�X&�
��qҹ�|���d��D眴`<�Os�h�I����%:?�儬:�����,�Y3Nʇ|�1�Q֘S<�����R��_�[p      �   �   x����
�0E�|�%��G��!���Ф�Sǃ!�%N��2�g�]WH���ۏ7|�������λ)z�a&�Ͼn)�0�[p�����+BB��
�4�QFHg���tGc������t5�э��!4��ZB+x���B6U�ӕ�zY����      �   4  x�Ŕ?o�@��|
oi��sb;C�H�H��V)����8[�"�D*D !T��H!$���
w߈�;��θ��{u��y�������C����y�;>���y�k=mw���Uq���i�E���I���V3nG��.��N|D��O���(~��<�w��ށ�#*NY��39��\ȍ\ʴ�g���FN�郜�?�+�⮝�0w�[���y�q���{�����.�] �' @3��V$G�����%���{�&�Jp����35 <���M��b�>Q#_���-|�	��W |��>�7����F�L.M���l�_ ��;j���QH�<�5	�	�T�~@��ŧ-1���U_O/ьT�����a��m��Ȕ�FAB|�"��Ɓ+��D��������A�r/�p:UE���N9���+g�	x�;���(����.���X	8U��P'�o����8k 6��OԹ���t����1,>���� �м3�h�~D��Q�����L�+��M'��ȤP�)]J�,m�=BHT_���vr���(	��aJH����R*�u      �   �  x��UMo�@��W쭉d����'=DBE��{h+�TP���|Q�;$���x'vܿ����yk'�Z	A]E��ݷ�f��{i���>=P���'����I��^����wz��v�ﺇ'Ǫ�=�ԛ��cOKݣ�z����}Uozj��0�=5�,�I�g����&2�2�����Vf·����yjc��־=������Om�=�p)�_������i�Od���Y�	��C�#���L����:�S�46���@�+������vȉ`#�2��c"�ΐ+73^x%.�;҉" ��f%�����lWS��7� �GJrN��R	�@w;J��k��%�M2��̦���K/
�!�xGh�jDe<F���.),
��Q|/�y���j�l��o�<�\w�s��I�9C�A�  3+\����Tf�����&p۩��R�L�rÎt]G�P�&��	z
��uB�I�O��cQ(��ZU�p�l4֜09o1��]d 
JL�"�D\%X�#\6'��z�88�3�T�a�L��c��,������'2���m�"��bt��rr;��֫�ӎ�!!�J�K7o��B@r�yn#v��U�1�3���|�[���")bfg �O��3B�xd��C*�Ƈ1bY��3�u���u����q
�?�Q��8��3wV��M���� �4�G      �   �   x��ӻ
�@�ޯ�N;�+�*��D�ެ[�G�?����f�9p�L^�٭�������W+��I�̃�id7��G�|�zR�jx�R\x�/��=��&��/ȧ���d�\ ����@�@�	��Q�	D+@�F��Al(�;HL��#:�p� �R�4? ޶����f�Z�^H�9k!`��[�e} ��X�      �   �  x��TMKa��+概D��:x� �{BB�`�]�0P�k�:��������G=�avh���;3���33�3��Q�ҙ�!��gW��r�T�\��
�
	*��q:�?8Ne)�LP�_U�<R7�偪�îj��!dq�=UW�h|/��3ŚP�p[��gk�����k��?t�!�����)�� q#���T�E�~��T���QA/���zx�V�2W~�05���Cpeά��P������a&p�z~�_[;X��f{�f]����@�#��7�j@����0�=��b9"r&���"�����zB����T�}�mB��t����;�����e��
��m��f�2�ɖc�"���H_nHk6Q:D�oL��gERo�M��:�Nϧ���#I�xЕF#�/N��_      �   3  x��T�nQ��+�k+�P&��b�E��H����E�U�`ݙ*�� �!~�v�!�L2��?��N�B��hn|}}�}lw��wPg����xz�;�s�=}�;��j�YDϟw#:9�e���}��O�qD+�͟s�9����>ᩚ�%��\�>n�Nο�BnĔ�O|ƃ��&���Q��%�3�#~��8 �r��F��v�ѹU-I��p�<�ʸq�{�5���[]�$�� U�|;���R[0�.�<�p�O������pH��Ȫ���'���"�,L�SC���e9!�Cv❈ީʟB�RZ@��(�.� ���	�ܺ�JR��G��ψ����|_�֊1�V��Xs@}��������������?�X;#��n=n[�,w;T����P����k*��?!�0���[�:�S��������� �	��6O|F6�>�8�b��(cY|&�VL�?�88O��Z�4�������ۀ;�������ba�Ⲳ��`۠Ԫ�DB�:n���,��Z�՟���m+[����q      �   �   x���v
Q���W((M��L�+�,H-���I,���+V��L�Q�K�M�Ts�	uV�0�QP�0�{.츰����.6\�p�	���p�_]Ӛ˓Í@�/���¾���R�A���m+Ѝ;.l���b�������m�`�pa����`Frq ����     