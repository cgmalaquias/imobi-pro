--
-- PostgreSQL database dump
--

\restrict P0dqflMb0fBWXP41sgVfdOAaYp9pYmTb7YyRgZqGAjtLbJ6Lyvh2j8k41OGcixf

-- Dumped from database version 10.23
-- Dumped by pg_dump version 18.0

-- Started on 2026-04-17 18:52:08

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
-- TOC entry 6 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

--
-- TOC entry 201 (class 1259 OID 54100)
-- Name: cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


--
-- TOC entry 202 (class 1259 OID 54109)
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


--
-- TOC entry 207 (class 1259 OID 54140)
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 206 (class 1259 OID 54138)
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2336 (class 0 OID 0)
-- Dependencies: 206
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- TOC entry 205 (class 1259 OID 54130)
-- Name: job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


--
-- TOC entry 204 (class 1259 OID 54120)
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


--
-- TOC entry 203 (class 1259 OID 54118)
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2337 (class 0 OID 0)
-- Dependencies: 203
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- TOC entry 197 (class 1259 OID 53801)
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


--
-- TOC entry 196 (class 1259 OID 53799)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 2338 (class 0 OID 0)
-- Dependencies: 196
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 199 (class 1259 OID 54082)
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


--
-- TOC entry 208 (class 1259 OID 54152)
-- Name: properties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.properties (
    id uuid NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    type character varying(255) DEFAULT 'CASA'::character varying NOT NULL,
    status character varying(255) DEFAULT 'DISPONIVEL'::character varying NOT NULL,
    price numeric(12,2) NOT NULL,
    area numeric(10,2),
    bedrooms integer,
    bathrooms integer,
    garages integer,
    address character varying(255) NOT NULL,
    city character varying(255) NOT NULL,
    state character varying(255) NOT NULL,
    zip_code character varying(255),
    latitude numeric(10,8),
    longitude numeric(11,8),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    transaction_type character varying(10) DEFAULT 'VENDA'::character varying NOT NULL,
    neighborhood character varying(255),
    slug character varying(255),
    featured boolean DEFAULT false NOT NULL
);


--
-- TOC entry 210 (class 1259 OID 54174)
-- Name: property_features; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_features (
    id uuid NOT NULL,
    property_id uuid NOT NULL,
    name character varying(255) NOT NULL
);


--
-- TOC entry 209 (class 1259 OID 54162)
-- Name: property_images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.property_images (
    id uuid NOT NULL,
    property_id uuid NOT NULL,
    url character varying(255) NOT NULL,
    "order" integer DEFAULT 0 NOT NULL,
    created_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- TOC entry 200 (class 1259 OID 54090)
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id uuid,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


--
-- TOC entry 198 (class 1259 OID 54070)
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    role character varying(255) DEFAULT 'USUARIO'::character varying NOT NULL,
    active boolean DEFAULT true NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


--
-- TOC entry 211 (class 1259 OID 54184)
-- Name: visits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.visits (
    id uuid NOT NULL,
    property_id uuid NOT NULL,
    client_name character varying(255) NOT NULL,
    client_email character varying(255) NOT NULL,
    client_phone character varying(255) NOT NULL,
    preferred_date date NOT NULL,
    preferred_time character varying(255) NOT NULL,
    message text,
    status character varying(255) DEFAULT 'PENDENTE'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    user_id uuid,
    internal_notes text
);


--
-- TOC entry 2144 (class 2604 OID 54143)
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- TOC entry 2143 (class 2604 OID 54123)
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- TOC entry 2140 (class 2604 OID 53804)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 2320 (class 0 OID 54100)
-- Dependencies: 201
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-2UW5Zw15XqBT2sTa', 's:7:"forever";', 2089648478);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-JVpb0Q9i669OZf2R', 's:7:"forever";', 2091105430);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-yKniuvRP1mfmOZlF', 's:7:"forever";', 2091105617);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-3NDPbfofAchF2xKq', 's:7:"forever";', 2091198955);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-S66ErIYK5D6zt6H3', 's:7:"forever";', 2091726783);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-FXzuYvbz8MTeKCK0', 's:7:"forever";', 2091726809);
INSERT INTO public.cache VALUES ('karina-carvalho-corretora-de-imoveis-cache-arp3NriYkNytMGGO', 's:7:"forever";', 2091791184);


--
-- TOC entry 2321 (class 0 OID 54109)
-- Dependencies: 202
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2326 (class 0 OID 54140)
-- Dependencies: 207
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2324 (class 0 OID 54130)
-- Dependencies: 205
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2323 (class 0 OID 54120)
-- Dependencies: 204
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2316 (class 0 OID 53801)
-- Dependencies: 197
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.migrations VALUES (15, '0001_01_01_000000_create_users_table', 1);
INSERT INTO public.migrations VALUES (16, '0001_01_01_000001_create_cache_table', 1);
INSERT INTO public.migrations VALUES (17, '0001_01_01_000002_create_jobs_table', 1);
INSERT INTO public.migrations VALUES (18, '2026_01_21_204833_create_properties_table', 1);
INSERT INTO public.migrations VALUES (19, '2026_01_21_204840_create_property_images_table', 1);
INSERT INTO public.migrations VALUES (20, '2026_01_21_204846_create_property_features_table', 1);
INSERT INTO public.migrations VALUES (21, '2026_01_21_204854_create_visits_table', 1);
INSERT INTO public.migrations VALUES (22, '2026_01_29_221025_add_transaction_type_to_properties_table', 2);
INSERT INTO public.migrations VALUES (23, '2026_02_26_030642_update_visits_table_for_crm_fields', 3);
INSERT INTO public.migrations VALUES (24, '2026_03_18_021955_add_neighborhood_to_properties_table', 4);
INSERT INTO public.migrations VALUES (25, '2026_03_18_140556_update_admin_user_credentials', 5);
INSERT INTO public.migrations VALUES (26, '2026_03_18_142348_add_slug_to_properties_table', 6);
INSERT INTO public.migrations VALUES (27, '2026_03_19_011733_generate_slugs_for_existing_properties', 7);
INSERT INTO public.migrations VALUES (28, '2026_04_14_211413_add_featured_to_properties_table', 8);


--
-- TOC entry 2318 (class 0 OID 54082)
-- Dependencies: 199
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2327 (class 0 OID 54152)
-- Dependencies: 208
-- Data for Name: properties; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.properties VALUES ('019d8ce0-6471-701b-8e36-e2b2d1f2b1bc', 'Residência Jardim Nova Campina', 'LOCAÇÃO 💥

Casa localizada no Jardim nova Campina

✅2 dormitórios;
✅Lavanderia individual;
✅Sala e Cozinha conjugadas;
✅1 banheiro;
Terreno medindo 200m2
Residência medindo 75m2

📲Informações: 41 995850231

Karina Carvalho Corretora de Imóveis Creci F 34809

R$1.700,00', 'CASA', 'DISPONIVEL', 1700.00, 80.00, 2, 1, 3, 'Apolinário de Souza Loyola', 'Campina Grande Do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-14 16:43:29', '2026-04-14 18:01:49', 'ALUGUEL', 'Jardim Nova Campina', 'residencia-jardim-nova-campina-jardim-nova-campina-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d8d61-d531-73de-b866-5aa53427a151', 'Apartamento todo mobiliado  -  BairroJardim Paulista', 'LOCAÇÃO 💥 

Apartamento na região Central;
Bairro Jardim Paulista;

Todo mobiliado ✅️

✅️Dois dormitórios;
✅️Sala e cozinha conjugadas;
✅️Lavanderia individual;
✅️Um banheiro social;
✅️Uma vaga de garagem;

R$ 2500,00

Informações:
📲 41 995850231
 
Karina Carvalho Corretora de Imóveis Creci F 34.809.', 'APARTAMENTO', 'DISPONIVEL', 2500.00, 60.00, 2, 1, 1, 'Leonardo Francischelli', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-14 19:04:52', '2026-04-14 19:04:52', 'ALUGUEL', 'jardim paulista', 'apartamento-todo-mobiliado-bairrojardim-paulista-jardim-paulista-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d8d73-097e-730b-893b-fb358d4b1eaf', 'Chalé localizado no Bairro Jaguatirica', 'CHARME, TRANQUILIDADE E NATUREZA! ✨🌿

🏡 Chácara com chalé estilo colonial – um verdadeiro refúgio!
✔️ Chalé com estilo colonial encantador
✔️ Cozinha planejada
✔️ Design rústico, cheio de personalidade
✔️ Salão de festas para momentos especiais 🎉
✔️ Tanque ideal para lazer ou criação 🐟
✔️ Vista deslumbrante para a serra 🌄

💰 Ótima oportunidade de investimento!
Perfeita para morar, descansar ou até gerar renda com locações!

3.000m2
Bairro Jaguatirica 
Campina Grande do Sul
 
R$ 450.000,00

Estudamos pegar automóveis.

📲 Agende sua visita agora mesmo!

👩‍💼 Karina Carvalho
CRECI F 34809
📞 (41) 99585-0231', 'CASA', 'DISPONIVEL', 450000.00, 3000.00, NULL, NULL, NULL, 'estrada municipal', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-14 19:23:39', '2026-04-14 19:23:39', 'VENDA', 'Jaguatirica', 'chale-localizado-no-bairro-jaguatirica-jaguatirica-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d9216-6f7b-72e1-8e91-137c605b881e', 'Chacará Paiol de Baixo - Campina Grande do Sul', '✨ Chácara incrível à venda! ✨

🌿 Um verdadeiro espaço para lazer e investimento 🏡
📍 Paiol de Baixo
📐 2,8 alqueires

🔹 Possui uma ótima infraestrutura:


• 5 quartos com banheiros
• Cozinha ampla (ideal para servir almoços e cafés)
• Salão de festas
• Piscina
• Casa do proprietário
• Casa de caseiro (75m²)
• Capela
• Campo de futebol
• 4 lagos

Campina Grande do Sul- Paiol de Baixo divisa com Taquari. 
5km da Br
3km estrada de chão. 

💰 Valor: R$ 1.300.000

🚗 Aceita negociação:

• Imóvel em Campina Grande do Sul ou Quatro Barras
• Veículo
Perfeita para moradia, descanso ou renda com turismo rural 🌄✨

📲 Entre em contato e agende sua visita!

👩‍💼 Karina Carvalho – Corretora de Imóveis

📄 CRECI F 34809', 'CASA', 'DISPONIVEL', 1300000.00, NULL, 5, 5, NULL, 'Paiol de Baixo- Campina Grande Do Sul', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-15 17:00:37', '2026-04-15 17:00:37', 'VENDA', 'Jardim Paulista', 'chacara-paiol-de-baixo-campina-grande-do-sul-jardim-paulista-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d922b-3022-722f-9520-22224b74fe23', 'Apartamento ao lado Parque Linear', '✨ OPORTUNIDADE IMPERDÍVEL! ✨

🏡 Apartamento dos sonhos esperando por você!

✔️ 2 dormitórios
✔️ 60m² privativos
✔️ 1 vaga de garagem
✔️ Localização privilegiada – ao lado do Parque Linear 🌳

💰 Condições facilitadas:
🔹 Entrada reduzida
🔹 Financiamento bancário disponível

Perfeito para quem busca conforto, praticidade e qualidade de vida em um só lugar!
R$ 212.000,00

📲 Agende sua visita agora mesmo!

👩‍💼 Karina Carvalho
CRECI F 34809

📞 (41) 99585-0231', 'APARTAMENTO', 'DISPONIVEL', 212000.00, 60.00, 2, 1, 1, 'Rua Pedro Dalprá Filho', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-15 17:23:17', '2026-04-15 17:23:17', 'VENDA', 'Jardim Paulista', 'apartamento-ao-lado-parque-linear-jardim-paulista-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d9237-04bd-70b4-a7d3-42cdd358737e', 'Residêncial - Ilha do mel', 'Apartamento 50m2:

💥Bairro Jardim Paulista.

➡️Destaques do Imóvel:
✅️Conceito Aberto: Sala e cozinha integradas;
Cozinha Planejada: Praticidade imediata;
Sacada;
✅️2 dormitórios confortáveis
✅️1 banheiro social moderno.
✅️Vaga de Garagem: 1 vaga garantida e de fácil manobra.

Karina Carvalho Corretora de Imóveis 
Creci F 34.809.

R$ 239.000,00', 'CASA', 'DISPONIVEL', 239000.00, 50.00, 2, 1, 1, 'Jardim Paulista', 'Campina grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-15 17:36:12', '2026-04-15 17:36:12', 'VENDA', 'Jardim Paulista', 'residencial-ilha-do-mel-jardim-paulista-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d923e-97db-7231-8111-fdfa604c2a99', 'Chacará no Bairro Taquari', 'Chácara no Bairro Taquari – Campina Grande do Sul - Excelente Oportunidade!

✅️Linda chácara localizada no bairro Taquari, a apenas 2 km da BR, com ótimo acesso, ideal para moradia ou lazer.
✅️O imóvel possui 4.000m² de terreno plano, oferecendo muito espaço e tranquilidade em meio à natureza.

Conta com:
✔ Barracão de 80m²
✔ Cozinha com churrasqueira
✔ 1 quarto
✔ 1 banheiro

A propriedade ainda dispõe de tanque, rio e ponte, proporcionando um ambiente perfeito para quem busca sossego e contato com a natureza.
Uma excelente opção para quem quer investir ou aproveitar momentos especiais no campo! 🌳✨

R$ 320.000,00

Karina Carvalho Corretora de Imóveis 
Creci F 34809', 'CASA', 'DISPONIVEL', 320000.00, 4000.00, 1, 1, NULL, 'Bairro Taquari', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-15 17:44:28', '2026-04-15 17:44:28', 'VENDA', 'Taquari', 'chacara-no-bairro-taquari-taquari-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d9260-55b5-7196-adfd-bdb562ee3e52', 'Condomínio Life Park', '🏡 Imóvel planejado com piscina aquecida e área gourmet!

📍 Colombo – Rua Ceará, 195– localização privilegiada e estrutura de alto padrão!

✔️ 391m² de área total
🛏 3 quartos (sendo 1 suíte)
🛋 Sala espaçosa + sala de jantar
🍽 Cozinha funcional
🛁 2 banheiros
🥩 Churrasqueira coberta
🤽🏻 Piscina aquecida – lazer o ano inteiro!
🧺 Área de serviço
🚗 2 vagas de garagem
🍃 Ambientes bem ventilados e iluminados

💰 R$ 1.599.000,00

🎯 Aceita FGTS e financiamento
Gostou?

Fale com a nossa equipe agora mesmo e saiba mais sobre esse imóvel incrível.

🏢  Karina Carvalho | CRECI F34809
41 995850231', 'CASA', 'DISPONIVEL', 1599000.00, 391.00, 3, 2, 2, 'Rua Ceará, 195', 'Curitiba', 'PR', '83430-000', NULL, NULL, '2026-04-15 18:21:20', '2026-04-17 18:28:53', 'VENDA', 'Colombo', 'condominio-life-park-colombo-curitiba', false);
INSERT INTO public.properties VALUES ('019d9270-ff78-7194-9c14-6fa2d101713d', 'Residência em Quatro Barras', 'Residência em Quatro Barras ⬇️

Bairro Cohab; 

Possui ótimo espaço de terreno;
✅️Casa com sacada;
✅️Sala e cozinha conceito aberto;
✅️Uma suíte com planejados;
✅️Um quarto de solteiro;
✅️Um banheiro social;
✅️Lavanderia individual;
✅️Edícula com quarto e banheiro medindo  aproximadamente 50m2;
✅️Lage;
✅️Falta apenas acabamento;
Com possibilidade de financiamento bancário.

Gostou desse imóvel? 

Envie sua proposta 📲 41 995850231 
Karina Carvalho Corretora de Imóveis 
Creci F 34809.

R$ 420.000,00', 'CASA', 'DISPONIVEL', 420000.00, 50.00, 2, 2, NULL, 'Quatro Barras no Bairro Cohab', 'Quatro Barras', 'PR', '83430-000', NULL, NULL, '2026-04-15 18:39:32', '2026-04-15 18:39:32', 'VENDA', 'Cohab', 'residencia-em-quatro-barras-cohab-quatro-barras', false);
INSERT INTO public.properties VALUES ('019d927f-8eaf-7270-8f90-8232f10c5697', 'Residência  no Bairro Jardim Paulista', 'Já pensou em morar na região central do bairro Jardim Paulista com preço acessível? ⬇️

Excelente residência localizada na Rua Arthur da Costa e Silva, em condomínio, com um grande diferencial: não possui taxa de condomínio!

✔ Água e luz individuais

O imóvel conta com:
✅ Laje
✅ 2 dormitórios
✅ Sala individual
✅ Cozinha com acesso para área dos fundos
✅ Lavanderia coberta
✅ 1 banheiro
✅ Espaço externo com possibilidade de cobertura para ampliar e otimizar o ambiente

Uma ótima oportunidade para quem busca conforto, economia e boa localização!

💰 R$ 290.000,00

🚗 Aceitamos veículo como entrada

Gostou dessa oportunidade?
📲 Agende uma visita: (41) 99585-0231

Karina Carvalho 
Corretora de Imóveis 
CreciF 34809', 'CASA', 'DISPONIVEL', 290000.00, NULL, 2, 1, 1, 'Rua Arthur da Costa e Silva', 'Campina Grande do Sul', 'PR', '83430-000', NULL, NULL, '2026-04-15 18:55:26', '2026-04-15 18:57:24', 'VENDA', 'Jardim Paulista', 'residencia-no-bairro-jardim-paulista-jardim-paulista-campina-grande-do-sul', false);
INSERT INTO public.properties VALUES ('019d9299-46c0-701f-8b93-afd178b92334', 'Casa na cidade de Quatro Barras', 'Esse é o nosso novo lançamento no EcoPark na cidade de Quatro Barras, são duas residências projetadas para quem quer viver bem, residências modernas com design contemporâneo. Cada casa conta com 86 metros quadrados, e com muitos detalhes que fazem a diferença para você. 

✅ 1 suíte 
✅ 2 quartos 
✅ Cozinha com ilha
✅ Sala de estar ampla e pé direito alto
✅ Jardim de inverno com churrasqueira 
✅ Ambientes podem ser integrados para melhor aproveitar
✅ Infraestrutura para ar condicionado (esperas)
✅ Design moderno lapidado por arquiteto
✅ Leds e sistemas de iluminação no quarto principal, e na sala 
✅ Porcelanato de qualidade 
✅ Imóvel financiável 80%
✅ Referência na construção de imóveis nas cidades de Quatro Barras e Campina Grande do Sul 
✅ Portas brancas
✅ Pias de banheiro de sobrepor
✅ Ralo dentro e fora do box 
✅ Esquadrias grandes para uma boa ventilação 
✅ Quarto do casal conta com porta com cortina integrada automática
✅ 86 metros quadrados bem distribuídos
✅ Bairro planejado
✅ Vizinhança tranquila

Marque uma visita e venha conhecer mais esses lares em construção. Entrega em junho de 2026.

 Valor: R$620.000,00.

Karina Carvalho Corretora de imóveis
 Creci F 34809.', 'CASA', 'DISPONIVEL', 620000.00, 86.00, 3, 1, NULL, 'EcoPark na cidade de Quatro Barras', 'Quatro Barras', 'PR', '83430-000', NULL, NULL, '2026-04-15 19:23:31', '2026-04-15 19:23:31', 'VENDA', 'Quatro Barras', 'casa-na-cidade-de-quatro-barras-quatro-barras-quatro-barras', false);
INSERT INTO public.properties VALUES ('019d92ad-6fc1-736b-b51c-25fe78497be0', 'Sobrado na Região Central do Bairro Alto', 'Sobrado de 300m² em Terreno de 500m² na Região Central do Bairro Alto ⬇️

✅️Excelente oportunidade de investimento em uma localização privilegiada. Este sobrado oferece espaço e funcionalidade tanto para fins comerciais quanto residenciais.

**Detalhes do imóvel:**

- **Piso térreo:** área comercial com duas salas amplas, dois banheiros e garagem coberta para maior conveniência.
- **Piso superior:** residência com sala de estar e sala de jantar integradas, cozinha planejada, lavanderia individual e três dormitórios, além de um banheiro social.
✅️Ideal para investidores que buscam uma propriedade versátil na região central do Bairro Alto.

Uma oportunidade única para quem deseja investir em uma localização estratégica e com potencial de valorização.

R$ 1600.000,00

Informações 41 995850231
 
Karina Carvalho 
Corretora de Imóveis 
CreciF 34809.', 'CASA', 'DISPONIVEL', 1600000.00, 300.00, 3, 3, 1, 'Região Central do Bairro Alto', 'Curitiba', 'PR', '83430-000', NULL, NULL, '2026-04-15 19:45:33', '2026-04-15 19:45:33', 'VENDA', 'Bairro Alto', 'sobrado-na-regiao-central-do-bairro-alto-bairro-alto-curitiba', false);


--
-- TOC entry 2329 (class 0 OID 54174)
-- Dependencies: 210
-- Data for Name: property_features; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2328 (class 0 OID 54162)
-- Dependencies: 209
-- Data for Name: property_images; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.property_images VALUES ('019d8cee-51c0-7169-a8e7-7fbcdf1a94e4', '019d8ce0-6471-701b-8e36-e2b2d1f2b1bc', '/storage/properties/Bs2Ip8qNgMn4ZCAyWYcnDiSvfizdp2MhosewAiG5.jpg', 0, '2026-04-14 13:58:42');
INSERT INTO public.property_images VALUES ('019d8d61-d553-7361-9938-9eca3fa62472', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/rzb00i2fedNQKkSzE4MfWdixtxgcjGxO9eehrTUN.jpg', 0, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d557-720b-bf4e-4ab7d04615d6', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/ymgLLmNSNIrT5qI3N0Fa0tJ2qCjQJUNKgzf3t1mX.jpg', 1, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d55b-7157-8c46-c0e2be082370', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/HBbAh6vfRlQzgfhlQRmkDaxKIJReX7kOT4lZSSyi.jpg', 2, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d55f-714e-8011-137d6b37530b', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/W9WpoL3xfbBLfiZmjkLxCaQpbNHcacYYqItZPJu5.jpg', 3, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d562-70fc-9ce7-4320469f98be', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/EFvxspgd6k9DoraEEkAs544uwkqGBLTkJzm6SQ0N.jpg', 4, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d566-7000-90fa-ddee0f3b30b1', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/DtxvgEJWhzzGFXeZqTuJbkW7Cf7IefAabXMTD6ZA.jpg', 5, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d56a-72fb-9a81-45080c9e5372', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/EJ0zZjzK0QPAElNOhvbc65iOWH4SlwilKE78wiGo.jpg', 6, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d56d-72ce-9218-9e81b03c7c96', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/OsYfyAPJDIjJWxeZote342LIxCGpx4pWicgVkq3x.jpg', 7, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d570-71f0-ae24-7a7a405ffcba', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/k2VBwZqIGqhk1nLr5HWl1Kg8VCZ29T80NMWkhWax.jpg', 8, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d61-d574-7256-836b-9d95a5f10f43', '019d8d61-d531-73de-b866-5aa53427a151', '/storage/properties/afY0eJWplwWfP4zpMimt1uqRMojQWgfrv8u3X7xc.jpg', 9, '2026-04-14 16:04:52');
INSERT INTO public.property_images VALUES ('019d8d73-09a1-7366-9c20-bbe11b1e84d6', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/4wH2YvFRvnMsdLy9KxInmhMMzF1ului8BZLCjCZl.jpg', 0, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09a6-7129-9cf0-b4850cec3244', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/niwmbZkSUmElHpqmi2ABu87xoEKyo2ttXKMprRFS.jpg', 1, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09aa-72d5-8205-84d357adb26d', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/4XKroVoRmCSvwpijVBXNRWm6Wa8eUIWdqrpjvwDX.jpg', 2, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09b0-73bf-82cf-1e323392894a', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/9xfxWneisq5iOzNVEoklBerLMwONxx26DZNmm0xs.jpg', 3, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09b4-726c-8c17-fed52cab6edc', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/zeE8EWxwuPhoVhPjXSKjxXongUXhBfoQfKWMCiMY.jpg', 4, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09b8-73cc-a4c2-a0c4d6e5c6ef', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/n2wEnX2uHa2whjVB9f7yo4KaJrYgT0yfT1KTaAHZ.jpg', 5, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09bc-72b2-9d53-1c78605e0bc2', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/EGz2hiOzZ1TemIh1JkQwceWAVCniAGmCnuQIJ9pA.jpg', 6, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09c0-7105-8669-984f075940bf', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/JvkWoNJ7MAv5EfhUXZW9LPh8nuxz7nAbzJKSCX0U.jpg', 7, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09c4-73c8-9ede-e702a8cf7f96', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/jNRyZOYu5NUFJugrcLydV4wQxmes7a780EmlUEhD.jpg', 8, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09c8-70c9-ab8d-0cdbbfbe8e5c', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/OODnOIqObcUggie4gYQmaquExvFWYe8nfNo35UFw.jpg', 9, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09cc-7291-875e-5337c9d3f8d7', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/CyMpSC2BqimBFcGPvNvygxq9337lhqYr0gI65npD.jpg', 10, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09d0-7249-a791-9b7a5fd0267e', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/WsPf9bNZVLkOH123M1lpVS6KE9izPhPqD2uhXWip.jpg', 11, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09d3-7227-bba2-a6ccaf2bc077', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/6wOSO08X3vct9yv65ROU977NvcfMqm9zdkFVgirY.jpg', 12, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09d7-705f-949f-c4480a1cc92e', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/QYJH7PNIiHMGxaVk2p4gp60XDrpnMpCm0qvMGpWo.jpg', 13, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09db-736e-9a4e-08c89b7be00b', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/gX8pmxpstYNNE4LEAP6JPrOduvuwnfpZdEvYNaOj.jpg', 14, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-09e7-705a-8869-f67480a6f434', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/8kNB0Yon8Uc3fVTccOYFYP8CdEz3l5sZe0iltgyo.jpg', 15, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-0a31-7035-8b92-02d9919928d3', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/gpAVpEpcOb9KzGnXshgyHCr047p5lLz9hug8IIM1.jpg', 16, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-0a41-73d8-bbee-6018bec0ef7c', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/yVM0hTYbrdX7MNgBwNmg4jHLCYveIFet17uvkVcc.jpg', 17, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d8d73-0a55-7194-9278-571c2c962d36', '019d8d73-097e-730b-893b-fb358d4b1eaf', '/storage/properties/jgErIr9fNdHXrlfa2roiLTOXnQepGg0qwpPY4mHS.jpg', 18, '2026-04-14 16:23:40');
INSERT INTO public.property_images VALUES ('019d9216-6fad-7284-8b59-5bf3faf3b6c4', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/0Oa1hz0RA5iHHwx9FiXHPDkMsi8Gp2sgrJAZpy9a.jpg', 0, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fb2-737b-a0b0-8d64906bc5e2', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/hqTMApMbHfngpRnKzF064sNxD5bPSbbN2fMhFsfI.jpg', 1, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fbf-732b-834f-bd4b21f67e4c', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/nl6ohN8ijlyVFWHN9FiBEywFZNx9VJNSfjCi0rwx.jpg', 2, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fc7-7091-97e2-57f24b199563', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/s5W21I5OamrqrMxsJ94LPqdPmYpLCnQq1BNPxf30.jpg', 3, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fcc-71bc-acdb-de0c677f38eb', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/WceT3lFkkPO1ID94x6fpmcoJ5ChwW3v8zvrAMywW.jpg', 4, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fd4-7022-8153-03cdc11e019a', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/8zp6LKXjYVWKMtKODXHXrAR1fHWkQbGqBUbOhPeh.jpg', 5, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fdb-712a-9766-3b50b114b448', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/9qRtk0LWv07aEr8IDSs0DkiuJH5s6A3PXTc4GAvA.jpg', 6, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fe0-73d5-b781-ea01d6a70a55', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/Y7LJZzuMD1sLRjMq68b17UrGhoXU1lZA4qCl17Su.jpg', 7, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fe5-72ce-b22d-84e9931897b1', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/2vWDBOgONSl48g7L1ZAAOH5FJtPQPDYDy8jFN35y.jpg', 8, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fea-7159-8d2c-8ffcde790946', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/J9BttFQtvmlWO26c1t8cliEC42wFEHSCOD1hmjfg.jpg', 9, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6ff1-7391-b794-d0e984f593ad', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/CPI0YTVpI1mbaeDI0FJaFwg88DBWsfd3pZPrhVtE.jpg', 10, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6ff5-73da-9b3e-137028d9197a', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/MPesY5K5QvPlLdlbqBeiPd4xevtL7jmxoEOsUV5z.jpg', 11, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6ffb-737e-b7ba-0cc794a6219b', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/ZzLvMBU6TdIn4AJeSN5mdNb4ZV8nFj6N1BTyMDoo.jpg', 12, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-6fff-7372-9402-1fac2dbfe9fe', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/DYYZYifahU78sMOZbd66OKweAMan5aQi9hKxCSyq.jpg', 13, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-7004-728a-8b59-674a20a7fa94', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/4tO1A0xHHipXx5gnaR4NNOJ3ktB1Wk64AhHF3SZ8.jpg', 14, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-700a-70f2-92f0-3b56090c70f0', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/hHIkEjDEKGBLM7BzchW5kIvUWr68U3TEuMzuk0uu.jpg', 15, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-7012-7134-b760-347eb2929bd2', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/w887CrT7lTgB4KH4Q17hCV9xsfTVRZHZbkx7hN09.jpg', 16, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-701c-71f4-a390-a14a328d4b42', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/fHSLVM5w7rVCyhggeoAxiruQQHh7zaJfnEFKlT5Y.jpg', 17, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-7020-736b-acc6-474d6cc3d5a6', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/nrENzd80rh6Uzn264KGc5xRjyM1T9zSs72V8ixgi.jpg', 18, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d9216-7023-714c-b5fc-373fa062fef3', '019d9216-6f7b-72e1-8e91-137c605b881e', '/storage/properties/LgBHguAGQ34EzoKgmTAy4KnZaD6LAL6juXZ3HTYm.jpg', 19, '2026-04-15 14:00:37');
INSERT INTO public.property_images VALUES ('019d922b-304a-70f9-99f5-9d836f8cdefc', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/kr6kA0HnZLQaWUKZmh8CDhoaMWjvBDu8oPwFupJl.jpg', 0, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d922b-3051-71af-89ab-11b3e0392687', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/qZgj3Llb4aCb7pK5TEYB76IqDFxWUJm8GHDNJbN5.jpg', 1, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d922b-305c-72d9-b36a-c4bde7fe5eef', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/1QlLcyaynLo8MabViYDrKy3yJKQSUSTJN95VInXt.jpg', 2, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d922b-3060-72e0-9bda-058c2226edbf', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/G6yL41NTdoWj3qRDLOUtQpC7aAHmRhhFZtDGlgGu.jpg', 3, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d922b-3064-711a-9c0b-d09f123ea621', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/gcjSFzUdB8lLqtvGkjRMzM8HwdTBbbvPwQ4BaLXA.jpg', 4, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d922b-306a-70c7-970f-c0357f0e24cf', '019d922b-3022-722f-9520-22224b74fe23', '/storage/properties/bGZpHOhxZLsyMTmxjm6gkqJ8H1jiBsnsGFj0xTi7.jpg', 5, '2026-04-15 14:23:17');
INSERT INTO public.property_images VALUES ('019d9237-04ec-7235-ac10-73d6214a88ce', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/JdfnUV0iUInmEvDVExZwdyOysNkgwbnCjarVaLxf.jpg', 0, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-04f7-720d-a787-c0f89196a679', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/oapEMWXKBJJI9DEetTDMIIzqR9G0EukKaTZeBQsp.jpg', 1, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-0505-72bc-b2a8-61c98868dc7b', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/Zl661eyx8mjg5uBUcZ7No6Uz9DsfSsQLSqlTKzko.jpg', 2, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-0511-7213-9050-74278e162cc3', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/PIEclxWFN6jiaXZdiVFcH374vp7tcaIhfR5m7O76.jpg', 3, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-0535-7310-8c8f-5169db1809f1', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/xFg71hWwXqxFp4xmdgsCX5W4JhSn9wXirPdCpK7L.jpg', 4, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-055c-7238-a35e-98932ccbd9d5', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/X5aesrs8gxpKb7meNnLfn0AOtbCIf8FHMZYWYX1V.jpg', 5, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d9237-0576-702a-89ce-8536995e0612', '019d9237-04bd-70b4-a7d3-42cdd358737e', '/storage/properties/Q4jYpXrCRn39yxnthcq5BbTugFP5fjcnXpZcDbij.jpg', 6, '2026-04-15 14:36:13');
INSERT INTO public.property_images VALUES ('019d923e-97fb-7189-bc22-cd7a0f0e65a9', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/qhXACsQFg5LTH7hNZEHUDVw6CNR6GD3lwaCsuqAC.jpg', 0, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9804-722f-8d9d-ac84eb0725b9', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/VzxRKkuFz64dSky8Ca9bru1NX32fNaW9MsbVlO2O.jpg', 1, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-980e-7358-9392-6feaedda2483', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/c3w6lXVSb7zhMLE2xakHcBGwZQypiMBI6vIaQFyJ.jpg', 2, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9812-726b-8ce6-abcfc51277e1', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/VV3Q5mufkV5lzmhd0L4hzBUEHEcgz9qMkOaMDFMY.jpg', 3, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9819-73ec-a732-7275de3cf2bf', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/vxXMXptbojBD3aiz3fvo2sQ0tqLcX0C2oPZsSxF1.jpg', 4, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-981f-735b-8016-9e04a05df824', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/C0I1Vq2K5BUtrrMhf3t9rOJy6JH06wJBwBtoCMzb.jpg', 5, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9822-7102-84a3-7a32e0844829', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/u91dfd0Ap7dze41GiYscd4fH4FnrZ4IJufRy6Jro.jpg', 6, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-982b-7234-bbd1-8011c4e55916', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/xrIVE5FHGZJcPIbv1uxe3zzlJxxB5bZbYn0rtYdU.jpg', 7, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9837-711a-a780-065b14f9b870', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/NbsSRkK9K39IX6s2ITYrGovywSdWjQWrkp2pgHe6.jpg', 8, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-983e-7296-bd0f-4ea718a04bab', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/VSEnt3dAhPFvbcbzTklViUT0kGYX2iwHg5zcKafc.jpg', 9, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9841-7089-8049-707b71540891', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/o9kvCHI6sEw2PC2mFQyYhaYYsWooibVfJfioSYhf.jpg', 10, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9845-7351-987d-b1d744001cb8', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/CrjS5jpNns1yxxqfF4J4PHc3OCFPCDyqcS1BD7Gd.jpg', 11, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d923e-9848-72c6-a82b-491052c2101c', '019d923e-97db-7231-8111-fdfa604c2a99', '/storage/properties/tg4Kth3jqTygJoRIMU5R6SvVNQS3qNXo0SnjCu4A.jpg', 12, '2026-04-15 14:44:29');
INSERT INTO public.property_images VALUES ('019d9260-55d2-71d6-971d-56ea3b3509b0', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/ZKFJZn2q41utVwrcKO6dR2Y8q6n5lHR513QOURNU.jpg', 0, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55d7-73e3-8ba1-11ebbf6a424e', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/jK09iVam5g8efBZQE4aqZUiral8gEbFWV1K9Zsmj.jpg', 1, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55db-70ca-a8d7-df768958ee35', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/DhtB1yoN74DUnRYQ5D4fq0ansDqTVqSiWr6nHFYC.jpg', 2, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55df-730e-8a26-cc0bd780574e', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/D8yZKNfnXJOEfL2Swx22ivzyVwishQeJjN6qZu3D.jpg', 3, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55e4-72b5-ba8b-bb53336d5cdc', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/QSAt24bGz4TXzZhH8soSl3Z9YeYtjxbumhkq9mh9.jpg', 4, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55e8-713c-bea5-d117fb9938ed', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/xq75p6TZhbGQZtCB0qUxRt2S96JvMT3ieKp6Fhg6.jpg', 5, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55ec-71d5-a778-befd82b7592c', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/nYaavDxMtagl7UDTrThe4jfHur6kWZZgmdKtBnS3.jpg', 6, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55f0-7337-87bb-d6e6fe7efda2', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/aayTFJvBKRXsFByf3G53tcaqaB4tKCQHX2kCUSvL.jpg', 7, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55f8-7216-9056-dbc1ead1a8ea', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/plgN2g0OHo8eGRa24uxLylW4j3Nn9koNE9zroKmn.jpg', 8, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-55fc-7010-964e-a09f89d1a637', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/njyrjGGE7gJWb8jebYYgjdbeaZkHu5qRF7WjZll0.jpg', 9, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-5601-7382-b076-290562289f58', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/0ICL44DbLjQWxcZlVoLcywSRs1XOeDpWv85ihE5r.jpg', 10, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-5605-7355-af93-ab860c9659e5', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/3Fj6TpxFM7mM4YeG9XTUmonm5hffT0EEnRwSsac9.jpg', 11, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-5609-70f5-8543-a7c83cf71d2f', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/0XWdvTGbAPj9BhcnmrJzZRmv3d8vnHgVxUyWvcqU.jpg', 12, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-560d-703a-a01c-91030bd7b1f4', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/hH8SZFN3KJP92AY4kWizhdpivc9L3wBv8yzuaz1O.jpg', 13, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-5611-7188-b9a9-e6c780fec1ff', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/0932cDI5nkL0iSs6jLFdM7SCH5gRWXdbx97taroH.jpg', 14, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9260-5615-7394-adbf-d83f3c195645', '019d9260-55b5-7196-adfd-bdb562ee3e52', '/storage/properties/R1xQpgznlvntSNlGBuFSR7xwxcquaDD4cQuYQhMe.jpg', 15, '2026-04-15 15:21:20');
INSERT INTO public.property_images VALUES ('019d9270-ffa5-703c-b59c-d2d4d85ebc8a', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/QydgX9bBocy3fUHOqkCzAwrgmEwhoJ9tdQaMW4C8.jpg', 0, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffaa-7343-a442-5dbcfed8e902', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/5sPfhAF7iA6zm7y7tkSfVYMpzyd9Xqalok5eBBGV.jpg', 1, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffaf-72ca-b587-8edac91844e1', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/bc43TTJnw5wH4FjDLjzpSRDHZy9XI5mqPZOyKbL3.jpg', 2, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffb3-7181-8f59-a9b9e00453c4', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/ERjCMdz6wG2hSHQc46HdWqNK7MESFF9RViGIATOS.jpg', 3, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffb8-7212-b17c-21df85b1b057', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/OUCdKnUPKcpIrT0S7FA8HV2cFNOgDf5gjPQ3FcQm.jpg', 4, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffbc-70c4-ae9d-da39859ea02b', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/HLoTWCepMFlMppBRUoj3sV6MTE8Coq6liDRxEd4Y.jpg', 5, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffc0-70e6-9b00-fabd2daa8519', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/1r1tl1eRaPSCnAdtcFAoqs2Oq10n80vkXwVB10zV.jpg', 6, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffc3-733e-a422-64bacfe9b84b', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/trnpUQEZxv5HUjRxfyrDuufNEroBd1OU02apCOim.jpg', 7, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffc7-72e3-9483-bd657cac3a41', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/VT9SgX32WFQ9UypoTJyvcDvWfJ8LmSXyfMU0sIWG.jpg', 8, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffcb-7005-a830-7a41cf25304c', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/NjXzRX6XYUnNXmlpLVorVl5lPQNf0tbZYn2yi9rZ.jpg', 9, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffcf-72f1-bc95-f8ff3e2de0a5', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/51Oo0mxykTRaTeYuiItuPjorakk9AUZP7k8bFIax.jpg', 10, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffd3-726a-8b66-731b1b332ae0', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/UdncRpKh8cWawLOymzqUPGqmmK4MNorjlOiLm1zt.jpg', 11, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffd7-71ec-ab3c-254ae246e94e', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/fXTE7taRNXmuqWkIiN2bQoiHMRNVSP37dVbuM26K.jpg', 12, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffda-705a-b897-c09ca6978cd9', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/KpuNGnk2IlMjchWpxrOCzvHSe9TBUlXuBgw7VmvS.jpg', 13, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffde-721f-82d5-e7aa9611e55a', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/i1WiFQDagDryFPF1qYs89NuxITQa6luQyxDmUq5h.jpg', 14, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9270-ffe4-7223-8f1b-c8642a9d823e', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/fwoLUu6OQLu8Kj0ckgNToSMXRFVMkwMkKEA9tCBH.jpg', 15, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9271-0013-7223-ad5f-a2c15121a234', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/1yFsdKc87QWTyGvCyRIpnKWnzocAthBiDg9f2Vz0.jpg', 16, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d9271-0041-72c0-9c32-ec949c717136', '019d9270-ff78-7194-9c14-6fa2d101713d', '/storage/properties/N9or6ixywbjGHI4v9rnNRERsOz8j18GmCsegpjCu.jpg', 17, '2026-04-15 15:39:32');
INSERT INTO public.property_images VALUES ('019d927f-8eeb-7087-b147-28c944990eab', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/2OjfmHYzjbCPf8BoFqcwJdOTOWuS3rYjDF1t5taR.jpg', 0, '2026-04-15 15:55:26');
INSERT INTO public.property_images VALUES ('019d927f-8f03-72e2-aa01-489f3e09db6d', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/Y43qX2riOc5ldb7mhuhpUBE4ey4jE7jgcLV6ErN2.jpg', 1, '2026-04-15 15:55:26');
INSERT INTO public.property_images VALUES ('019d927f-8f09-7054-9065-017f2e79fda7', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/ruE3HJ8Si60gKIioxDoVwuf7OOQNyL4RkHkUkXDY.jpg', 2, '2026-04-15 15:55:26');
INSERT INTO public.property_images VALUES ('019d927f-8f38-7186-824d-a509f153893a', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/UgENJM38WCZyjDa4dwuL1NSweRVNFA5CfsdeskXU.jpg', 3, '2026-04-15 15:55:27');
INSERT INTO public.property_images VALUES ('019d927f-8f68-719c-b707-b0c744ad8d94', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/yhLn3Xh7e2EhdgTEKpBrOZZWChQHhoUPJl4KnvQC.jpg', 4, '2026-04-15 15:55:27');
INSERT INTO public.property_images VALUES ('019d927f-8f79-7362-b783-3c26ab2cf633', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/b8wZTgsH0zPhhcyKePA0MM8Xw3Ff3uMYWMxbvCXa.jpg', 5, '2026-04-15 15:55:27');
INSERT INTO public.property_images VALUES ('019d927f-8f7e-702c-960a-6fd2892774fe', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/NEt121DLyyTL8qvAR13mv5jUOJ6REBGoidMlqOmY.jpg', 6, '2026-04-15 15:55:27');
INSERT INTO public.property_images VALUES ('019d927f-8f82-7190-9693-0386723d6694', '019d927f-8eaf-7270-8f90-8232f10c5697', '/storage/properties/zICwQChbbDjBPDpXktWIHvlsWUVDWB1KIdQ4WN5Z.jpg', 7, '2026-04-15 15:55:27');
INSERT INTO public.property_images VALUES ('019d9299-46e5-708d-8119-a8782ae97997', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/3mnqdXDSn2BMWmY2mKHHT5bWDdWkePMolcozgI96.jpg', 0, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46ec-7273-8462-374ec53a9c18', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/h15NzA0ODmmjkLXA99h2y8afVyrNsg8rdesNr6s5.jpg', 1, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46f0-706f-97ae-78f6fd38b781', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/0VNdz9xOBiD8F2SUOrPDvtCP64nm32h0L0oNatKi.jpg', 2, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46f4-7184-b3dc-099c6b9f9034', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/Mg30LQy3GMjH9N3Toip9T0Um3LGLhLzNernqpc06.jpg', 3, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46f8-718b-ba7e-efa0220882ce', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/MZJoMt2fo54UIjJix9LvuJSAogXysg8rndJfP9ds.jpg', 4, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46fb-7135-b3de-2cd97e0830d1', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/bUxd1EJns2VxBa1fLBm9pxEWzDBGE5X9phO9dmjp.jpg', 5, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-46ff-7315-aa49-ce98e2f652a3', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/ESy8m3JzUxGbagb2LanvwGniSOMyzuLPohGET2Mq.jpg', 6, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-4702-73a3-9d42-240e671ff17d', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/2KnkVaipWPmTdXhEPzMYJPxye3b3Q45Kk6ZNwTsK.jpg', 7, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-4705-727f-970d-77ef6acff99a', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/O71fUNk4C3h3efhG3Ih0qjJo22uwQBQCbbjX3Gbl.jpg', 8, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-4708-7019-accc-6456959544ee', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/Far3br9zujQqFKrGoYiNJFKuraStlQqJA6ElJgie.jpg', 9, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-470c-7367-b198-d67926610eb3', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/rOFShRxCVW3REs3f2fpemn5Vbu8YxziZX3FuSJxH.jpg', 10, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-470f-727a-bc56-5df668931991', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/kFlSQ567GLKFdItsFJnUyLpYyEHBatPeRQDBdoyc.jpg', 11, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-4713-7220-9480-2f8261359916', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/0u03rwYZS2b4LhV8rj27UMXjn4x790DRUxdo5hhf.jpg', 12, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-4717-70b9-ad61-d195f6037f66', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/pTkJutUjbnZU4GdkxeIEklWtGfTfY1ttdM0JuO19.jpg', 13, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-471a-7179-9ba2-032d2bcbea7a', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/pvSkbrlc7UC1zeYZ0abMOC3X9Fvp89uhlhXAxW02.jpg', 14, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d9299-471d-701e-94a8-26fc775d7e50', '019d9299-46c0-701f-8b93-afd178b92334', '/storage/properties/gaaa3ngwHVAGeqh5mhnSohKXqg6zDJIMEcUZ8tD8.jpg', 15, '2026-04-15 16:23:32');
INSERT INTO public.property_images VALUES ('019d92ad-6fe2-7199-a8d9-02ee1dd0677a', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/qA7ZjuFiRwqTPZeKVGtRX5yK2jCOQIsZ4Zcmi0Yi.jpg', 0, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6fe7-719e-be51-70cb9cc0ffce', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/J9ZeImSK8lJUWKOeR66t0xCnGkh696uHfeYVHKHE.jpg', 1, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6feb-7186-a255-764349838a6f', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/3OAPMX5CL6853CePUYiOoqTUnomK9vIhVzXwpEl8.jpg', 2, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6fee-7326-821d-a34f7b748b27', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/KMOBO2Zp0nshXWCP0vuaORHdwnfn9IMgBWTuSqfK.jpg', 3, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6ff2-73d0-bf85-5e18dc442c5f', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/bW3JS259r8LzZQgwNskl2Y2sk6LgFpdphbvDolyb.jpg', 4, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6ff6-708a-a177-2a8589e7d322', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/LBsJ7BfCUzMBwAInVDzUVPcqVI7dqnlY8ZodZsVq.jpg', 5, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6ffa-7211-bad6-81e3e8d2dd0b', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/wRh2hIDy21Sv5ibxBlU5j9dvr3MrCIoj7tzZ0q1l.jpg', 6, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-6ffd-70ed-be35-2756da0a9629', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/FtvG6lNkE0OZOgs2JYL028hU5kR0ovfiOcfTU3ON.jpg', 7, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-7000-723d-91b6-d16101f79777', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/J15ytKZlrqistAG3NlSWo3W0gMN6SUNvsoL3ArzL.jpg', 8, '2026-04-15 16:45:33');
INSERT INTO public.property_images VALUES ('019d92ad-7004-72ec-816e-814136791cff', '019d92ad-6fc1-736b-b51c-25fe78497be0', '/storage/properties/czP0MPlh083I6yO2FpTr1ummCLEnzbP0jwvXSlom.jpg', 9, '2026-04-15 16:45:33');


--
-- TOC entry 2319 (class 0 OID 54090)
-- Dependencies: 200
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sessions VALUES ('V9GWdW4F1BWdWqpyMhQi82neMl2rRBbRbPSTZC2B', NULL, '34.62.21.159', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRkpGY3AwV2RvbGlkVzRTSGxGN3QwVXhxdWd1bEJUaHFPNzRjWUIzOSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774355050);
INSERT INTO public.sessions VALUES ('RloKY69QSRZn2swvQQsmMp0L8f1l5BGuLiaGTOtO', NULL, '34.122.147.229', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiREVHWW92NlNtOUVsNVZ4bVk2U0gyMWFsZlQ1TlJjZlhtbTB1aXNrZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774428195);
INSERT INTO public.sessions VALUES ('RYw9dmOvVpB4ARmn609jDdQIshPJC6oMelbb8TkT', NULL, '34.173.232.96', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUlI1alRqNFc4aVh4cTFCRnNhYXRuanFWWWhqNEs0UE5OYU9YQTE1dSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774453916);
INSERT INTO public.sessions VALUES ('xdqKPPphcV9q6qqbRMhjELPuN5PVbwnqkm6rlNrh', NULL, '34.82.220.215', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWDl5bUNoS3VLbnFoVWhWM29scHZmWmRKVmFGRXJ5eHVtamNtcTFpTSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774716234);
INSERT INTO public.sessions VALUES ('8JE1hPRxvgD8W4EdIcXl1Ivnpz3lFY3gdHN86LJY', NULL, '94.156.14.71', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibjd5VXJTQ0JHb1pPOTNJRGxXa3dCcWphN1BFSWVOejNXSlVJRVVDZyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774931973);
INSERT INTO public.sessions VALUES ('suRbxdTQMzEsv2tEENal8muuGhZg2pqKk90cEUuB', NULL, '34.123.102.5', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib0IwT1RUSHE2cDRRV0NVRDRJNkY3M3VWUkRKSU5VTTRaSm9SQk1CUiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775062923);
INSERT INTO public.sessions VALUES ('9gb3mXaRVqQGvGe4ZFct7pey5QiVKPj7nKNWALrs', NULL, '185.247.137.39', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVVpxU0ZyTUxIbHZIVUxFN1NPektSTnMwbksyUTJ2NWU4eEZhNm41cyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775141041);
INSERT INTO public.sessions VALUES ('RNvogTKTZeIbWPxlXqdcw0qh6RdgOsQGomEOBP9x', NULL, '151.241.122.153', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRjhtdHNSU0JPcmtKR3hzeFJHSlZiNzFRdTF0aExJTTFOQ1JrbVJXUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775552773);
INSERT INTO public.sessions VALUES ('RkIiDvr0T6FY4VvJ1bQsMsJSJgQzRb5RacCD5KpZ', NULL, '66.249.68.71', 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVE1XMXpkNUQ0THpoczJNS0dRM09YTjZqWDlTQkpHOXE4VENtYnh2MCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775651366);
INSERT INTO public.sessions VALUES ('K9ihFK21fvN7VLNydYDQCkvJ3NYd9pLRiLdKwomI', NULL, '2804:18:963:765f:a82c:26f3:1a7e:144e', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoib3pJUk5qODFvNjcxVVFJbkE2OGMzbGtnZ1hKc041YjhKeUQzNTJCYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776243867);
INSERT INTO public.sessions VALUES ('gMyOrPCglZefFhl2ONfE95iSsfLM47r1WVSTMjBr', NULL, '205.210.31.130', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGF5dlprOUV3empIYXhQVjZyUmJKV3oyTk9WaXJremJGR0EyMXJZVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774357934);
INSERT INTO public.sessions VALUES ('2NqaRNcEI7I47navSutFHoGVgAtUCABMgXKhLL43', NULL, '44.213.58.168', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaGF2Sk1URzFrbTQxbnBkRWFiT2cwQ0xTWG05ZHh0M0x2ckduYXh2WCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774428207);
INSERT INTO public.sessions VALUES ('UFiV6jjbF4NPG9rIJgugSUYvzpqmH2pxZ3CaIxq6', NULL, '157.245.123.39', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS3BITTJReWZ3V3EybDhabnVWOWRjekw1YkFxM0huVnAzVnZESTNOSiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774493406);
INSERT INTO public.sessions VALUES ('EbRmNR9AB0S1jxDUxXMz3nYga5BtrAjE0QrvdZbg', NULL, '104.168.98.195', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 15_7_3) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.0 Safari/605.1.15', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT2NQcnB4QUlydzgxZkxmR0RsY0UwOGlsaFVyZnZVQ2dLSUUzSHdLMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774770475);
INSERT INTO public.sessions VALUES ('I9xkfaocgxUMBz0Wmu8MXkzjiijHg7iiSVQhTKsx', NULL, '205.169.39.171', 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZmVqRDZQdEYwYXoyZElsZUxXRHF0RUM2a0VkdXk2VTQ0U3BlbjdueCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774962522);
INSERT INTO public.sessions VALUES ('Eq5oYxJRvWeGGHhiUU2w1BTb8lCZ5qafZ79NX0LG', NULL, '87.236.176.152', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia1dGelViRk5jUzhYWllYM0syZHl6YW5LUkJERFZ5VTltNm1STENmRSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775115967);
INSERT INTO public.sessions VALUES ('l7Cv9uZkD8rPrh17uggXLY0iVxQp1L5U61ylaz32', NULL, '54.154.241.138', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTlo3RjlBY2RoSGo3QUtMeUZ4MEh2VzFCN3pwaU5IOE84V3dCSFdzQSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775245746);
INSERT INTO public.sessions VALUES ('AzeGhnZ18s37w0lYMKIGvmqLaCFz9Uiy75ZaMNjn', NULL, '2602:80d:1004::29', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVFhYcVhVUFo2NmxkVjBMeHBtU1NBUXpRWTJHR0RITUNpQmZobVdZdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775623909);
INSERT INTO public.sessions VALUES ('liKqwgR0gZxWhX8SwhWAbQmfcloH104iVA6EgOom', NULL, '198.235.24.44', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRlNLOEgwdkk2cUNJRlNYSmkxNGhmUlZ4SkhLVTdGV2V0VmFxcnV5USI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775652063);
INSERT INTO public.sessions VALUES ('pt7y4fS86eRFWXhsDx2HQBiixjzYrz7cuHFvSd3E', NULL, '74.125.215.37', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiT1V4SzhyUlBsaEFSRXExaFdDNm9ZOEZTWkd5Wm1reHA1amZldTNKYiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776243861);
INSERT INTO public.sessions VALUES ('yWG9xjDTzMocNt6CWUBa0DaqMyDyWmybplIQB8Si', NULL, '35.225.84.31', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoid3MxSW5KM3RieDdXYXNSSmdPUkN6dHJaZmZYMEs2WWxoMGZ4TTlBbyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774369338);
INSERT INTO public.sessions VALUES ('l141dHhSnMjDQX88It9n7H9nfUK6FP47JgNhbWS5', NULL, '2a05:9403::5f9', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:123.0) Gecko/20100101 Firefox/123.0', 'YToyOntzOjY6Il90b2tlbiI7czo0MDoidGphNmpsNGhYWGZUQVJyUlBtQ3M0MDdPclZsVUttWXJobjhIekxJNyI7czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1774429217);
INSERT INTO public.sessions VALUES ('9dS5hI8QPgq9CnDxgf8VDXQ2N2ZzIaVByTgm5nMw', NULL, '34.41.113.203', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoic2p0TVBGQXR5Z09jN1BRdXJFR3JSaE50RU04Z2cxTktyUk5MU093QiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774537474);
INSERT INTO public.sessions VALUES ('5NMNsH07XEje4MOHr2XgFaynSU0rDXYamdexzECZ', NULL, '34.10.97.155', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoia2dmajcxQkpnbXpESTdlSlM1dXk1MVNhSDh1dWNzaU1nWVhZWk9lMiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774790672);
INSERT INTO public.sessions VALUES ('YzOYf4Mq64U5gM5TGztXBH114ZT6sYvokFl4O9Ay', NULL, '205.169.39.171', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMmtPRU5GaHdwM29LS1R4enlJaEhBRVdzYjJuNmw3QnNjUmJvaXFEMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774962534);
INSERT INTO public.sessions VALUES ('vSRmKoU5vNDoR15yaPlJt0LCeyAUzbHWTaw7ezmT', NULL, '87.236.176.228', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibWdUemtVZENGV0xVYTAxQXllVGM1TEJBbTZjZ0NDRXp1aEVTNWdVMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775119434);
INSERT INTO public.sessions VALUES ('cHSSOzLT2sMpiLThaEQUzvImGmHAFoLDIF95aj62', NULL, '205.210.31.203', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTzlLOGR4cXphZTM4MEt4ZlhpbldXZDVCaWUybG45clBiTEJhVURWViI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775305115);
INSERT INTO public.sessions VALUES ('kLc5txUBMCRROHh3UKLj4MghTNaeg2hpVXSqRUbi', NULL, '205.210.31.210', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiZHRxbWc5bDZMMkhwTkJkMExNclA3Y3dxa1JldDhLTnJiMnBybXdkVSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775630920);
INSERT INTO public.sessions VALUES ('Q4a5lkRmldPmOhvmulxoWFMOcKeq9OgpG9f7DmI5', NULL, '205.210.31.46', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidEpSQml3M2VLYzBwZ25XekllUElkUWl4OFlnNmY0dkg3N3poQlRhbCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775730338);
INSERT INTO public.sessions VALUES ('iLZOYQtuI34ftB8vOVrRa5Zw6SRIcLaVkHoWKiKi', NULL, '74.125.215.39', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Mobile Safari/537.36 (compatible; Google-Read-Aloud; +https://support.google.com/webmasters/answer/1061943)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUzNMcW5yMVlVcXN2S1BLTkJEZ1RnakVrV09RT0kwbk5oZEdCa1JWdiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776243862);
INSERT INTO public.sessions VALUES ('NGgFVdG74rLuIh2pKacJNBbr0uc0AJD4oFr87npc', NULL, '34.27.40.97', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiVGNoY1M3TlVqdVMxRW1JeThyUUV5Q0VPZGxWc3lkN1kwMXhpY2htVyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774370868);
INSERT INTO public.sessions VALUES ('GOVO9ECUjqfbb7lMbBTVXwF3ss15DRh6Z5glPrpZ', NULL, '2a05:9403::5f9', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiNGNXSXFpb1J3Q0lIdGtOdWpSbHRvbG1hY2RMWkNkSnJOSXJNU2VIMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774429217);
INSERT INTO public.sessions VALUES ('HSbCaR2fFe8sFELwCB9dnvAKKx5AEvveK5zWAEuT', NULL, '34.10.242.23', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoidlA3blpxSVhmWWJIWTI5YmhXM1NxTXR2QVRGZ2UxRll6OG9lWUEwTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774537864);
INSERT INTO public.sessions VALUES ('Ip9WWvfuza5SYQvDoihVXmxhugDl11WwNG0yeit2', NULL, '143.198.144.8', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUXBzaFpSWVBNQXFIZkZENEpxSk92QzlDTTRCZ1liejNOM3FyZjF1RyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774834755);
INSERT INTO public.sessions VALUES ('hK8SE2ECKHHXThbKkqSrHxn93qVHtfxc1q0yq5IB', NULL, '68.183.136.224', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiREtaYmhaWXR4d1IwQnkzMGpBVmpvazNib3NTNHpCaHpqNG4weHUwVCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775007213);
INSERT INTO public.sessions VALUES ('w5j81nxS6QSsu906fRoPyub1iaPN3rdHHdGRlhqw', NULL, '87.236.176.14', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3FwWElCbkhnR0VpdWhodWZlNUhrVVhob1BWeUxaSGlQa2VuZ3dSSSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775121874);
INSERT INTO public.sessions VALUES ('duwvohpAwSu7QfeALI5dRgvyhKkvjQkS0hD4eEy9', NULL, '205.210.31.243', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoieGFGZlFES1V4WllXaTlHMWF3RkdCWkNNZEZ2MW4xMW5NTERKdXdzQiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775336013);
INSERT INTO public.sessions VALUES ('Kox95P6fMwIS79ZZDLAyiGBxesPJ2iJ7fOegw8em', NULL, '66.249.68.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.7680.177 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoibEh1cElGV2tybUZlR0dPbUNBcWFjUzJmNXJhZkFlaFl6TVB1RFdCYSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775651350);
INSERT INTO public.sessions VALUES ('lx3BNQ4XEEGz7hkuGi1flJwM9UoRSlHfTBQSbT1H', NULL, '44.197.109.186', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWm1XcGlYT2ZPUlViZWtJd3NBZ3g3dHJ4TDNlZGxCQzJ2b0RoMGhCdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776116175);
INSERT INTO public.sessions VALUES ('Gw609sUJ3rMw85iTTEwhs7X8S7hGye3MuBfr5HBl', NULL, '147.182.250.210', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiUUZlVnBERmV6SE53YXJNcjViZmJCczhVR3pyY0ZZdWc5VjNqc0VRZSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776244766);
INSERT INTO public.sessions VALUES ('0pmESXbbjFSwKoYuMxcCrVNkHfy9Y5WkaSKvPgU7', NULL, '205.169.39.50', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.5938.132 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ2ZiNFNEdjQ2ZnFlRW1RckpjMDllaG9hcm50VUtOU2hLb1NpR2h3RCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774428122);
INSERT INTO public.sessions VALUES ('dst1UYIGlb3eT4cINr5Ou6FXhktT3n8K0SgZ2CKS', NULL, '91.231.89.23', 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaFppQ2dDY1UyUU5sOTlYdmdzWXhSZTkwbUVETXdBOUk2ZktkZ1lVbSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774430629);
INSERT INTO public.sessions VALUES ('zl7ACHElVMbA1Itsi0D5zFPt8JjIUt7TtJpbnvFy', NULL, '199.91.220.117', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQndVMkdyeGdvVDR2cDNZZHBDSFBjVGd4Q29kdGxxcEpZMm9KME04NiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774308642);
INSERT INTO public.sessions VALUES ('5VLO3KLwEq9m1ePZNUqiaiagmJNDj9O2BhYHC6Cd', NULL, '67.207.84.157', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWk1SSmcxMmFIcjd5QmZEWkp1dk1RVFdxck1VOFh6SVhTSkZZOXhXMSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774311318);
INSERT INTO public.sessions VALUES ('IxIUbSV4W661CG1WpydcSsqycRamdBm1AbVAEdKR', NULL, '198.235.24.136', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiY25DRHROekVpcWJoVnAxOGlSUXBCbno2T3Uwb3haQmRUeU1JTm83SiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774314713);
INSERT INTO public.sessions VALUES ('xYy7vV5U419FhJjbnM1Evtaol3yx2iaK89LClYhh', NULL, '152.42.140.186', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQlEwNzM4TXVRa3BNMXF1Y0VHVlB6RlFodEJxZ2tJQUFqQTlmMERYdSI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774665619);
INSERT INTO public.sessions VALUES ('dx3Y03GiDFVQCJ8VH7KRBxtkxmc6VVIfZk15F6Qg', NULL, '198.235.24.251', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQkdjYVRndWVza2pJa3ZiSUVWT2MwZzBZaXRKZG1qbHc3MkdyZUJqNiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1774922854);
INSERT INTO public.sessions VALUES ('CEw1HIAjTFSIyozSNRqVE2crqAGUuwqibzRfkgSF', NULL, '34.73.35.28', 'Mozilla/5.0 (compatible; CMS-Checker/1.0; +https://example.com)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaE0yUU11bERkUjZick5PamFLQVN6d2JZSm1Ua1JDVnpXOVpnMGtRUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775040822);
INSERT INTO public.sessions VALUES ('Xd7g5nc3HUKHEwd0waUI3NmBB9cCx5MeMD34YWjx', NULL, '87.236.176.110', 'Mozilla/5.0 (compatible; InternetMeasurement/1.0; +https://internet-measurement.com/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMWwxSlhUYnQwbHphV1dLTmsxd2tqUktzWjNqc3ZtdHhWQU5KWlpZUyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775138481);
INSERT INTO public.sessions VALUES ('mTjs8saifBZ5oXMvTCZAjJiv78i6vo9gnx5MWfxe', NULL, '205.210.31.44', 'Hello from Palo Alto Networks, find out more about our scans in https://docs-cortex.paloaltonetworks.com/r/1/Cortex-Xpanse/Scanning-activity', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiMFp1a2hzOTVldDF2ODlacW5rbzBEellZT2dJWDhSbFlpbmxjdGN6QiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775411454);
INSERT INTO public.sessions VALUES ('TReXLMR0lK2rYsBmNOZOHt289hysmCJgHy9Fwm8Q', NULL, '66.249.68.71', 'Mozilla/5.0 (Linux; Android 6.0.1; Nexus 5X Build/MMB29P) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Mobile Safari/537.36 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiTHRIZkF1MVBla3FkZmhHTlFRSjZzZVJON3lBYlUwdGlpMzJ5cGNlMCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1775651366);
INSERT INTO public.sessions VALUES ('PcV4ognSJjvD9EW3TT78uAPERNYRlHRev6YjYhBh', NULL, '2602:80d:1005::13', 'Mozilla/5.0 (compatible; CensysInspect/1.1; +https://about.censys.io/)', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiS083NTFsTldpZGljbkFvU2N4dXlTN2c5Z3F1M2FYV0hPaEs5aTcweiI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6NDY6Imh0dHBzOi8vaW1vYmlwcm9hcGkuYWdlbmNpYXJlaW5vZGlnaXRhbC5jb20uYnIiO3M6NToicm91dGUiO047fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1776236502);


--
-- TOC entry 2317 (class 0 OID 54070)
-- Dependencies: 198
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES ('019be28c-7883-7210-816c-de408bbbb382', 'Usuário Teste', 'usuario@imobiliaria.com', NULL, '$2y$12$V56dtNxkdgkCv/GOlZZp.eFa4YzBGTqH7H6EMBRhNRUaWC.cQed/m', 'USUARIO', true, NULL, '2026-01-21 21:53:35', '2026-01-21 21:53:35');
INSERT INTO public.users VALUES ('019be28c-766d-7370-9a57-aac9df37fcd4', 'Karina Carvalho', 'karinacarvalhocorretora@gmail.com', NULL, '$2y$12$Z5yEozCf6KHEIRdM53W5puzww9BNu7LZYzg2O7x3S6yf3vWZB98wO', 'ADMIN', true, NULL, '2026-01-21 21:53:34', '2026-03-18 14:09:58');


--
-- TOC entry 2330 (class 0 OID 54184)
-- Dependencies: 211
-- Data for Name: visits; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 2339 (class 0 OID 0)
-- Dependencies: 206
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- TOC entry 2340 (class 0 OID 0)
-- Dependencies: 203
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- TOC entry 2341 (class 0 OID 0)
-- Dependencies: 196
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 28, true);


--
-- TOC entry 2170 (class 2606 OID 54116)
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- TOC entry 2167 (class 2606 OID 54107)
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- TOC entry 2177 (class 2606 OID 54149)
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 2179 (class 2606 OID 54151)
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- TOC entry 2175 (class 2606 OID 54137)
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- TOC entry 2172 (class 2606 OID 54128)
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 2154 (class 2606 OID 53806)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 2160 (class 2606 OID 54089)
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- TOC entry 2181 (class 2606 OID 54161)
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- TOC entry 2183 (class 2606 OID 54312)
-- Name: properties properties_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.properties
    ADD CONSTRAINT properties_slug_unique UNIQUE (slug);


--
-- TOC entry 2187 (class 2606 OID 54183)
-- Name: property_features property_features_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_features
    ADD CONSTRAINT property_features_pkey PRIMARY KEY (id);


--
-- TOC entry 2185 (class 2606 OID 54173)
-- Name: property_images property_images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_images
    ADD CONSTRAINT property_images_pkey PRIMARY KEY (id);


--
-- TOC entry 2163 (class 2606 OID 54097)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 2156 (class 2606 OID 54081)
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- TOC entry 2158 (class 2606 OID 54079)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2189 (class 2606 OID 54197)
-- Name: visits visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_pkey PRIMARY KEY (id);


--
-- TOC entry 2165 (class 1259 OID 54108)
-- Name: cache_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_expiration_index ON public.cache USING btree (expiration);


--
-- TOC entry 2168 (class 1259 OID 54117)
-- Name: cache_locks_expiration_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cache_locks_expiration_index ON public.cache_locks USING btree (expiration);


--
-- TOC entry 2173 (class 1259 OID 54129)
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- TOC entry 2161 (class 1259 OID 54099)
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- TOC entry 2164 (class 1259 OID 54098)
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- TOC entry 2191 (class 2606 OID 54177)
-- Name: property_features property_features_property_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_features
    ADD CONSTRAINT property_features_property_id_foreign FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 2190 (class 2606 OID 54167)
-- Name: property_images property_images_property_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.property_images
    ADD CONSTRAINT property_images_property_id_foreign FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 2192 (class 2606 OID 54191)
-- Name: visits visits_property_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_property_id_foreign FOREIGN KEY (property_id) REFERENCES public.properties(id) ON DELETE CASCADE;


--
-- TOC entry 2193 (class 2606 OID 54263)
-- Name: visits visits_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT visits_user_id_foreign FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


-- Completed on 2026-04-17 18:52:11

--
-- PostgreSQL database dump complete
--

\unrestrict P0dqflMb0fBWXP41sgVfdOAaYp9pYmTb7YyRgZqGAjtLbJ6Lyvh2j8k41OGcixf

