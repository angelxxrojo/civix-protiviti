--
-- PostgreSQL database dump
--

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg12+1)
-- Dumped by pg_dump version 16.3 (Debian 16.3-1)

-- Started on 2025-12-18 10:43:49 -05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 689683)
-- Name: a2c_schema; Type: SCHEMA; Schema: -; Owner: civix_user
--

CREATE SCHEMA a2c_schema;


ALTER SCHEMA a2c_schema OWNER TO civix_user;

--
-- TOC entry 917 (class 1247 OID 960522)
-- Name: assignment_type; Type: TYPE; Schema: a2c_schema; Owner: civix_user
--

CREATE TYPE a2c_schema.assignment_type AS ENUM (
    'auto',
    'manual',
    'reassignment'
);


ALTER TYPE a2c_schema.assignment_type OWNER TO civix_user;

--
-- TOC entry 920 (class 1247 OID 960530)
-- Name: data_type; Type: TYPE; Schema: a2c_schema; Owner: civix_user
--

CREATE TYPE a2c_schema.data_type AS ENUM (
    'vehicle',
    'person',
    'property',
    'evidence',
    'other'
);


ALTER TYPE a2c_schema.data_type OWNER TO civix_user;

--
-- TOC entry 911 (class 1247 OID 960494)
-- Name: operator_role_type; Type: TYPE; Schema: a2c_schema; Owner: civix_user
--

CREATE TYPE a2c_schema.operator_role_type AS ENUM (
    'admin',
    'supervisor',
    'operator',
    'viewer'
);


ALTER TYPE a2c_schema.operator_role_type OWNER TO civix_user;

--
-- TOC entry 914 (class 1247 OID 960504)
-- Name: reporter_relation_type; Type: TYPE; Schema: a2c_schema; Owner: civix_user
--

CREATE TYPE a2c_schema.reporter_relation_type AS ENUM (
    'self',
    'third_party',
    'anonymous'
);


ALTER TYPE a2c_schema.reporter_relation_type OWNER TO civix_user;

--
-- TOC entry 241 (class 1255 OID 1276027)
-- Name: get_next_incident_code(); Type: FUNCTION; Schema: a2c_schema; Owner: civix_user
--

CREATE FUNCTION a2c_schema.get_next_incident_code() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
v_code TEXT;
v_year TEXT;
v_max_number INTEGER;
BEGIN
v_year := EXTRACT(YEAR FROM CURRENT_DATE)::TEXT;

SELECT COALESCE(
MAX(
CAST(
SUBSTRING(incidence_code FROM '\d{6}$') AS INTEGER
)
),
0
) + 1
INTO v_max_number
FROM a2c_schema.trx_incidence
WHERE incidence_code LIKE 'INC-' || v_year || '-%';

v_code := 'INC-' || v_year || '-' || LPAD(v_max_number::TEXT, 6, '0');

RETURN v_code;
END;
$_$;


ALTER FUNCTION a2c_schema.get_next_incident_code() OWNER TO civix_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 689768)
-- Name: mstr_agent; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_agent (
    agent_id integer NOT NULL,
    document_number character varying(20),
    agent_name character varying(250),
    agent_last_name character varying(250),
    fk_document_type_id integer NOT NULL,
    created_at character varying(45),
    created_by character varying(45),
    latitude numeric(18,15),
    longitude numeric(18,15),
    unit_id integer,
    is_active integer,
    is_assigned integer NOT NULL,
    phone_number integer
);


ALTER TABLE a2c_schema.mstr_agent OWNER TO civix_user;

--
-- TOC entry 239 (class 1259 OID 1019104)
-- Name: mstr_alert_level; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_alert_level (
    alert_level_id integer NOT NULL,
    alert_level_code character varying(20) NOT NULL,
    alert_level_name character varying(50) NOT NULL,
    priority_order integer NOT NULL,
    color_code character varying(7),
    is_active integer DEFAULT 1,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(45),
    updated_at timestamp without time zone,
    updated_by character varying(45),
    deleted_at timestamp without time zone
);


ALTER TABLE a2c_schema.mstr_alert_level OWNER TO civix_user;

--
-- TOC entry 238 (class 1259 OID 1019103)
-- Name: mstr_alert_level_alert_level_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.mstr_alert_level_alert_level_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.mstr_alert_level_alert_level_id_seq OWNER TO civix_user;

--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 238
-- Name: mstr_alert_level_alert_level_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.mstr_alert_level_alert_level_id_seq OWNED BY a2c_schema.mstr_alert_level.alert_level_id;


--
-- TOC entry 216 (class 1259 OID 689773)
-- Name: mstr_citizen; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_citizen (
    citizen_id integer NOT NULL,
    citizen_name character varying(45),
    citizen_apellidos character varying(45),
    citizen_document character varying(45),
    citizen_phone character varying(45),
    createt_at timestamp without time zone,
    created_by character varying(45),
    update_at timestamp without time zone,
    update_by character varying(45),
    is_active integer
);


ALTER TABLE a2c_schema.mstr_citizen OWNER TO civix_user;

--
-- TOC entry 217 (class 1259 OID 689776)
-- Name: mstr_document_type; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_document_type (
    document_type_id integer NOT NULL,
    document_type_name character varying(100),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer
);


ALTER TABLE a2c_schema.mstr_document_type OWNER TO civix_user;

--
-- TOC entry 218 (class 1259 OID 689779)
-- Name: mstr_guardpost; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_guardpost (
    guardpost_id character varying(25),
    guardpost_name character varying(250),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer
);


ALTER TABLE a2c_schema.mstr_guardpost OWNER TO civix_user;

--
-- TOC entry 219 (class 1259 OID 689782)
-- Name: mstr_incidence_classification; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_incidence_classification (
    incidence_classification_id integer NOT NULL,
    incidence_classification_name character varying(250),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    incidence_classification_code character varying(20),
    updated_at timestamp without time zone,
    updated_by character varying(45),
    unit_id integer
);


ALTER TABLE a2c_schema.mstr_incidence_classification OWNER TO civix_user;

--
-- TOC entry 220 (class 1259 OID 689785)
-- Name: mstr_incidence_state; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_incidence_state (
    incidence_state_id integer NOT NULL,
    incidence_state_name character varying(45),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    incidence_state_code character varying(20),
    display_order integer DEFAULT 0,
    updated_at timestamp without time zone,
    updated_by character varying(45)
);


ALTER TABLE a2c_schema.mstr_incidence_state OWNER TO civix_user;

--
-- TOC entry 221 (class 1259 OID 689788)
-- Name: mstr_incidence_subtype; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_incidence_subtype (
    incidence_subtype_id integer NOT NULL,
    incidence_subtype_name character varying(255),
    create_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    incidence_subtype_code character varying(20),
    incidence_type_id integer,
    updated_at timestamp without time zone,
    updated_by character varying(45)
);


ALTER TABLE a2c_schema.mstr_incidence_subtype OWNER TO civix_user;

--
-- TOC entry 222 (class 1259 OID 689791)
-- Name: mstr_incidence_type; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_incidence_type (
    incidence_type_id integer NOT NULL,
    incidence_type_name character varying(255),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    incidence_type_code character varying(20),
    updated_at timestamp without time zone,
    updated_by character varying(45),
    incidence_classification_id integer
);


ALTER TABLE a2c_schema.mstr_incidence_type OWNER TO civix_user;

--
-- TOC entry 223 (class 1259 OID 689794)
-- Name: mstr_mode; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_mode (
    mode_id integer NOT NULL,
    mode_name character varying(45),
    created_at timestamp without time zone,
    created_by character varying(1),
    is_active integer
);


ALTER TABLE a2c_schema.mstr_mode OWNER TO civix_user;

--
-- TOC entry 231 (class 1259 OID 960542)
-- Name: mstr_operator; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_operator (
    operator_id bigint NOT NULL,
    document_number character varying(20) NOT NULL,
    operator_name character varying(250) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role a2c_schema.operator_role_type DEFAULT 'operator'::a2c_schema.operator_role_type NOT NULL,
    shift_start time without time zone,
    shift_end time without time zone,
    is_active smallint DEFAULT 1,
    is_online smallint DEFAULT 0,
    last_activity timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(45) DEFAULT '1'::character varying,
    updated_at timestamp without time zone,
    updated_by character varying(45),
    deleted_at timestamp without time zone
);


ALTER TABLE a2c_schema.mstr_operator OWNER TO civix_user;

--
-- TOC entry 230 (class 1259 OID 960541)
-- Name: mstr_operator_operator_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.mstr_operator_operator_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.mstr_operator_operator_id_seq OWNER TO civix_user;

--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 230
-- Name: mstr_operator_operator_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.mstr_operator_operator_id_seq OWNED BY a2c_schema.mstr_operator.operator_id;


--
-- TOC entry 224 (class 1259 OID 689797)
-- Name: mstr_origin; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_origin (
    origin_id integer NOT NULL,
    origin_name character varying(250),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    origin_type integer,
    origin_code character varying(20),
    updated_at timestamp without time zone,
    updated_by character varying(45)
);


ALTER TABLE a2c_schema.mstr_origin OWNER TO civix_user;

--
-- TOC entry 225 (class 1259 OID 689800)
-- Name: mstr_unit; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.mstr_unit (
    unit_id integer NOT NULL,
    unit_name character varying(45),
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer,
    updated_at timestamp without time zone,
    updated_by character varying(45)
);


ALTER TABLE a2c_schema.mstr_unit OWNER TO civix_user;

--
-- TOC entry 226 (class 1259 OID 689803)
-- Name: trx_incidence; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_incidence (
    incidence_id integer NOT NULL,
    origin_id integer,
    complainant character varying(150),
    description_incidence text,
    unit_id integer,
    mode_id integer,
    incidence_classification_id integer,
    incidence_subtype_id integer,
    incidence_type_id integer,
    cuadrante_id character varying(10),
    operator character varying(100),
    operator_id character varying(100),
    incidence_date timestamp without time zone NOT NULL,
    location character varying(100),
    location_reference character varying(100),
    contact_number character varying(100),
    document_number character varying(20),
    created_at timestamp without time zone NOT NULL,
    created_by character varying(50),
    updated_at timestamp without time zone NOT NULL,
    updated_by character varying(50),
    incidence_state_id integer,
    classification_name character varying(45),
    type_name character varying(100),
    unit_name character varying(45),
    subtype_name character varying(100),
    origin_name character varying(45),
    state_name character varying(45),
    mode_name character varying(45),
    reason character varying(255),
    latitude numeric(18,15),
    longitude numeric(18,15),
    camera_civix_id integer,
    epoch_civix bigint,
    camera_civix_name character varying(100),
    alert_civix_id bigint,
    incidence_code character varying(30),
    origin_ticket_id integer,
    origin_reference_id character varying(50),
    telegram_chat_id character varying(50),
    reporter_email character varying(100),
    reporter_relation a2c_schema.reporter_relation_type,
    district character varying(100),
    province character varying(100),
    closed_at timestamp without time zone,
    deleted_at timestamp without time zone,
    alert_level_id integer DEFAULT 2 NOT NULL,
    draft_expires_at timestamp without time zone
);


ALTER TABLE a2c_schema.trx_incidence OWNER TO civix_user;

--
-- TOC entry 227 (class 1259 OID 689808)
-- Name: trx_incidence_agent; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_incidence_agent (
    agent_id integer NOT NULL,
    incidence_id integer NOT NULL,
    created_at timestamp without time zone,
    created_by character varying(45),
    is_active integer
);


ALTER TABLE a2c_schema.trx_incidence_agent OWNER TO civix_user;

--
-- TOC entry 228 (class 1259 OID 689811)
-- Name: trx_incidence_derivative; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_incidence_derivative (
    incidence_id integer NOT NULL,
    incidence_derivative_id bigint NOT NULL,
    unit_id_old integer,
    unit_name_old character varying(45),
    unit_id integer,
    unit_name character varying(45),
    created_at timestamp without time zone,
    created_by character varying(45),
    incidence_classification_id_old integer,
    incidence_classification_name_old character varying(45),
    incidence_classification_id integer,
    incidence_classification_name character varying(45),
    is_active integer,
    is_last integer,
    incidence_state_id_old character varying(45),
    incidence_state_name_old character varying(45),
    incidence_state_id character varying(45),
    incidence_state_name character varying(45),
    operator character varying(45)
);


ALTER TABLE a2c_schema.trx_incidence_derivative OWNER TO civix_user;

--
-- TOC entry 229 (class 1259 OID 689814)
-- Name: trx_incidence_document; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_incidence_document (
    incidence_document_id bigint NOT NULL,
    incidence_id integer NOT NULL,
    ruta character varying(250),
    origin_id character varying(50),
    is_active character varying(1),
    complainant character varying(150),
    description_document text,
    unit_id character varying(100),
    extension_document character varying(5),
    created_at timestamp without time zone NOT NULL,
    created_by character varying(50)
);


ALTER TABLE a2c_schema.trx_incidence_document OWNER TO civix_user;

--
-- TOC entry 240 (class 1259 OID 1150077)
-- Name: trx_incidence_incidence_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.trx_incidence_incidence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.trx_incidence_incidence_id_seq OWNER TO civix_user;

--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 240
-- Name: trx_incidence_incidence_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.trx_incidence_incidence_id_seq OWNED BY a2c_schema.trx_incidence.incidence_id;


--
-- TOC entry 237 (class 1259 OID 960608)
-- Name: trx_incidence_specific_data; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_incidence_specific_data (
    specific_data_id bigint NOT NULL,
    incidence_id integer NOT NULL,
    data_type a2c_schema.data_type NOT NULL,
    data_content jsonb NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(45) DEFAULT '1'::character varying,
    updated_at timestamp without time zone,
    updated_by character varying(45),
    is_active smallint DEFAULT 1
);


ALTER TABLE a2c_schema.trx_incidence_specific_data OWNER TO civix_user;

--
-- TOC entry 236 (class 1259 OID 960607)
-- Name: trx_incidence_specific_data_specific_data_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.trx_incidence_specific_data_specific_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.trx_incidence_specific_data_specific_data_id_seq OWNER TO civix_user;

--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 236
-- Name: trx_incidence_specific_data_specific_data_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.trx_incidence_specific_data_specific_data_id_seq OWNED BY a2c_schema.trx_incidence_specific_data.specific_data_id;


--
-- TOC entry 233 (class 1259 OID 960574)
-- Name: trx_ticket_operator_assignment; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_ticket_operator_assignment (
    assignment_id bigint NOT NULL,
    incidence_id integer NOT NULL,
    operator_id bigint NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    released_at timestamp without time zone,
    assigned_by bigint,
    released_by bigint,
    assignment_type a2c_schema.assignment_type NOT NULL,
    notes text,
    is_current smallint DEFAULT 1 NOT NULL,
    is_active smallint DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(45) DEFAULT '1'::character varying,
    updated_at timestamp without time zone,
    updated_by character varying(45)
);


ALTER TABLE a2c_schema.trx_ticket_operator_assignment OWNER TO civix_user;

--
-- TOC entry 232 (class 1259 OID 960573)
-- Name: trx_ticket_operator_assignment_assignment_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.trx_ticket_operator_assignment_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.trx_ticket_operator_assignment_assignment_id_seq OWNER TO civix_user;

--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 232
-- Name: trx_ticket_operator_assignment_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.trx_ticket_operator_assignment_assignment_id_seq OWNED BY a2c_schema.trx_ticket_operator_assignment.assignment_id;


--
-- TOC entry 235 (class 1259 OID 960592)
-- Name: trx_ticket_status_history; Type: TABLE; Schema: a2c_schema; Owner: civix_user
--

CREATE TABLE a2c_schema.trx_ticket_status_history (
    history_id bigint NOT NULL,
    incidence_id integer NOT NULL,
    old_state_id integer,
    new_state_id integer NOT NULL,
    changed_by bigint,
    reason text,
    changed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by character varying(45) DEFAULT '1'::character varying
);


ALTER TABLE a2c_schema.trx_ticket_status_history OWNER TO civix_user;

--
-- TOC entry 234 (class 1259 OID 960591)
-- Name: trx_ticket_status_history_history_id_seq; Type: SEQUENCE; Schema: a2c_schema; Owner: civix_user
--

CREATE SEQUENCE a2c_schema.trx_ticket_status_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE a2c_schema.trx_ticket_status_history_history_id_seq OWNER TO civix_user;

--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 234
-- Name: trx_ticket_status_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: a2c_schema; Owner: civix_user
--

ALTER SEQUENCE a2c_schema.trx_ticket_status_history_history_id_seq OWNED BY a2c_schema.trx_ticket_status_history.history_id;


--
-- TOC entry 3381 (class 2604 OID 1019107)
-- Name: mstr_alert_level alert_level_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_alert_level ALTER COLUMN alert_level_id SET DEFAULT nextval('a2c_schema.mstr_alert_level_alert_level_id_seq'::regclass);


--
-- TOC entry 3361 (class 2604 OID 960545)
-- Name: mstr_operator operator_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_operator ALTER COLUMN operator_id SET DEFAULT nextval('a2c_schema.mstr_operator_operator_id_seq'::regclass);


--
-- TOC entry 3359 (class 2604 OID 1150078)
-- Name: trx_incidence incidence_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_incidence ALTER COLUMN incidence_id SET DEFAULT nextval('a2c_schema.trx_incidence_incidence_id_seq'::regclass);


--
-- TOC entry 3377 (class 2604 OID 960611)
-- Name: trx_incidence_specific_data specific_data_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_incidence_specific_data ALTER COLUMN specific_data_id SET DEFAULT nextval('a2c_schema.trx_incidence_specific_data_specific_data_id_seq'::regclass);


--
-- TOC entry 3367 (class 2604 OID 960577)
-- Name: trx_ticket_operator_assignment assignment_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_ticket_operator_assignment ALTER COLUMN assignment_id SET DEFAULT nextval('a2c_schema.trx_ticket_operator_assignment_assignment_id_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 960595)
-- Name: trx_ticket_status_history history_id; Type: DEFAULT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_ticket_status_history ALTER COLUMN history_id SET DEFAULT nextval('a2c_schema.trx_ticket_status_history_history_id_seq'::regclass);


--
-- TOC entry 3583 (class 0 OID 689768)
-- Dependencies: 215
-- Data for Name: mstr_agent; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_agent (agent_id, document_number, agent_name, agent_last_name, fk_document_type_id, created_at, created_by, latitude, longitude, unit_id, is_active, is_assigned, phone_number) FROM stdin;
1	3115931	KARIN	DEL VALLE SEGOVIA	1	\N	\N	-12.117693498518964	-77.041331907339710	5	1	0	931075595
2	10326128	CESAR JAVIER	ABANTO VELEZ	1	\N	\N	-12.118579040373284	-77.023899479078960	6	1	1	931075595
3	10032687	OSCAR FERNANDO	ACHAS SALAZAR	1	\N	\N	-12.128760273506641	-77.027102929527970	7	1	0	931075595
4	7472437	ANTHONY EFRAIN	ACOSTA ALVA	1	\N	\N	-12.114233826351569	-77.044860342405610	2	1	0	931075595
5	8302436	DANIEL ANGEL	ACUÑA PRADO	1	\N	\N	-12.121600232204981	-77.028420133039750	4	1	1	931075595
6	10622908	ERNESTO ANGELBERTO	ACUÑA CARRETERO	1	\N	\N	-12.117299967815446	-77.031239439189660	1	1	0	931075595
7	10742696	DARWIN WILLIAMS	ACURIO CARDENAS	1	\N	\N	-12.119297291733600	-77.032768140330700	4	1	0	931075595
8	3369524	PABLO	ADRIANZEN GARCIA	1	\N	\N	-12.120948825684328	-77.036439706661210	2	1	0	931075595
9	45259816	VICTOR	AGUILA SANTOS	1	\N	\N	-12.134352055484756	-77.042441156671800	7	1	0	931075595
10	41339591	LESLIE ROCIO	AGUILAR ALCALDE	1	\N	\N	-12.124149616136355	-77.023424609898060	1	1	0	931075595
11	6025740	MARIA DEL ROSARIO LOURDES	AGUILAR CARPIO	1	\N	\N	-12.134674200312862	-77.033097171101820	2	1	0	931075595
12	9006636	AMERICO	AGUIRRE HUILLCAS	1	\N	\N	-12.126463253802120	-77.038024754936830	2	1	0	931075595
13	9147543	CARLOS ANTONIO	AGUIRRE COTERA	1	\N	\N	-12.125734012509449	-77.044595796968410	4	1	0	931075595
14	46064800	KENNY JOEL	AHUANARI BARDALES	1	\N	\N	-12.110776946545371	-77.025097341053280	6	1	0	931075595
15	41682942	JHONY LEONIDAS	AIRA BRAVO	1	\N	\N	-12.133155864861939	-77.020487300381520	4	1	0	931075595
16	77499931	JOEL ANTHONI	AIRA TITO	1	\N	\N	-12.117968906553433	-77.033382630854280	2	1	0	931075595
17	44941130	ESTEFANIA	ALAMA RODRIGUEZ	1	\N	\N	-12.128006433842710	-77.044884275882400	3	1	0	931075595
18	74125683	EDUARDO JEAN PIERRE	ALARCON OLIVERA	1	\N	\N	-12.130402077115516	-77.022357557162050	2	1	0	931075595
19	9911013	CESAR AUGUSTO	ALARICO IPARRAGUIRRE	1	\N	\N	-12.110581553695333	-77.040835096222200	1	1	0	931075595
20	7094475	LUIS	ALBARRAN YNGUNZA	1	\N	\N	-12.112430819256632	-77.044648806848240	7	1	0	931075595
21	75236917	CESAR GIANFRANCO FABRICIO	ALBERCO HURTADO	1	\N	\N	-12.125951575702942	-77.025811457201670	1	1	0	931075595
22	45697377	NESTOR ANDRES	ALBIZURI APARICIO	1	\N	\N	-12.116202558131146	-77.033578418282400	7	1	0	931075595
23	9642602	ALICIA	ALBUJAR CAYETANO	1	\N	\N	-12.134284416250217	-77.025686825635550	4	1	1	931075595
24	10095884	ANDRES	ALCALA GARCIA	1	\N	\N	-12.115580878658761	-77.030843915618820	4	1	0	931075595
25	8006250	JORGE	ALCANTARA VELARDE	1	\N	\N	-12.122476941349430	-77.024852959122370	2	1	0	931075595
26	46196198	LUIS HEVER	ALEGRIA FERNANDEZ	1	\N	\N	-12.121833970795231	-77.039610975840700	4	1	1	931075595
27	41698941	ALFREDO	ALFARO HUANACO	1	\N	\N	-12.122552966049456	-77.023931901956840	6	1	1	931075595
28	25487774	CARLOS FEDERICO	ALI GUILLEN ANDRADE	1	\N	\N	-12.117000610867516	-77.043207347698710	4	1	0	931075595
29	42833493	LUIS WILBUR	ALIAGA VENEGAS	1	\N	\N	-12.130034905122626	-77.025552481748680	1	1	0	931075595
30	48221620	GRIMALDO	ALLCCA TINCOPA	1	\N	\N	-12.127657692607173	-77.041631017021490	7	1	0	931075595
31	70468002	LENIN ENRIQUE	ALTAMIRANO ASPAJO	1	\N	\N	-12.115182006517594	-77.031016980755150	3	1	1	931075595
32	10861174	GIULLIANA	ALVARADO PEREA	1	\N	\N	-12.124538883454669	-77.034643474239530	2	1	0	931075595
33	9601342	JOSE ANTONIO	ALVARADO TUEROS	1	\N	\N	-12.114600720065274	-77.024073176839470	7	1	0	931075595
34	6841032	JONY RAUL	ALVARO ARCE	1	\N	\N	-12.116563723233122	-77.040599084878900	1	1	0	931075595
35	71292527	POOL MARIO	ALVES VICENTE	1	\N	\N	-12.118304253926784	-77.024724014228880	3	1	1	931075595
36	9580311	ROSARIO	ALZAMORA GARATE	1	\N	\N	-12.133707308595728	-77.024364499523640	4	1	1	931075595
37	75684552	MARIAN YANET	AMESQUITA FLORES	1	\N	\N	-12.110700571062695	-77.035409355974210	6	1	1	931075595
38	42319891	EDWIN EMILIO	ANAMPA BUIZA	1	\N	\N	-12.134945065914602	-77.023497260882050	1	1	0	931075595
39	73998740	JUAN JOSÉ	ANAYA LEYVA	1	\N	\N	-12.127651105898106	-77.022763746076050	2	1	0	931075595
40	9675868	JAVIER FRANCISCO	ANDAZABAL CAYLLAHUA	1	\N	\N	-12.120865411917553	-77.041035820591300	4	1	0	931075595
41	47150352	WILBERTH JOSUE	ANDONAIRE LOPEZ	1	\N	\N	-12.132582866435483	-77.044806869635180	1	1	1	931075595
42	7472374	DORIAN ANTONIO	APARICIO CASANI	1	\N	\N	-12.116285748101106	-77.027008130831650	6	1	0	931075595
43	6774306	NELLY CECILIA	APARICIO LAVARELLO	1	\N	\N	-12.126183409086599	-77.029892652169700	5	1	0	931075595
44	40723696	CARLOS ENRIQUE	APAZA ALEJOS	1	\N	\N	-12.110913032820367	-77.044887206824400	5	1	0	931075595
45	10341568	ROGER	APAZA CACERES	1	\N	\N	-12.131696934892513	-77.028823053221060	4	1	0	931075595
46	370925	EDGARDO	APONTE BECERRA	1	\N	\N	-12.114024460659385	-77.038653142865430	3	1	0	931075595
47	8748790	JOSE CARLOS	ARANA PAZ SOLDAN	1	\N	\N	-12.116192331580624	-77.020002228538520	3	1	1	931075595
48	48063407	KEVIN JORDAN	ARANGURI CALLUPE	1	\N	\N	-12.116434147182325	-77.027164049527770	6	1	1	931075595
49	74831937	ROGER ANTHONY	ARCA CARPIO	1	\N	\N	-12.126517805323486	-77.031096877265810	1	1	0	931075595
50	5337382	ROBERT	AREVALO MUÑOZ	1	\N	\N	-12.115930969590258	-77.041364215385510	7	1	0	931075595
51	25550379	NICOLAS ENRIQUE	ARIAS HEINSON	1	\N	\N	-12.124028167388428	-77.026048190017280	4	1	1	931075595
52	10035257	MARIO JAIME	ARMAS VIDALON	1	\N	\N	-12.123156447152752	-77.042637664943600	6	1	0	931075595
53	41694790	RUFINO ALFONSO	ASCACIBAR NOBLECILLA	1	\N	\N	-12.133718982491380	-77.020681916857770	4	1	1	931075595
54	7481833	MARCO ANTONIO	ASCUE BECERRA	1	\N	\N	-12.117252636046384	-77.029217428890260	7	1	1	931075595
55	62174240	KAREN MELISSA	ASPAJO GUIMACK	1	\N	\N	-12.134329235543804	-77.038993890279900	2	1	0	931075595
56	73824480	HUGO JOSE	ATOCHE PRADA	1	\N	\N	-12.131981743999740	-77.022927048390670	1	1	0	931075595
57	43529035	BRISEIDA MARILU	AVENDAÑO CAHUAPAZA	1	\N	\N	-12.133690009185756	-77.029668899988450	1	1	0	931075595
58	9338639	HECTOR ALDRIN	AYHUASI CASTILLO	1	\N	\N	-12.112274471616628	-77.027365657349460	6	1	0	931075595
59	7463824	LUIS ANGEL	BACA VALDIVIA	1	\N	\N	-12.115004871129063	-77.022927382828600	7	1	0	931075595
60	25421214	ORLANDO OSCAR	BALAREZO CRUZ	1	\N	\N	-12.134622299987472	-77.034329350683210	2	1	0	931075595
61	3887820	ESTELA	BALBIN PEÑA	1	\N	\N	-12.132779852685314	-77.040911210608580	2	1	0	931075595
62	42293377	JOEL NASSER	BALBOA VILLAFUERTE	1	\N	\N	-12.121216494218647	-77.038348838499150	3	1	0	931075595
63	75805652	ROYER RONALDO	BALDERA PEREZ	1	\N	\N	-12.118094709071420	-77.030427029091330	2	1	0	931075595
64	10645961	OSCAR DANIEL	BALLON SANCHEZ	1	\N	\N	-12.112851017474059	-77.027973999327950	1	1	1	931075595
65	10032302	HUGO FABIO	BAÑOS PRADO	1	\N	\N	-12.116316943449263	-77.027662718494110	4	1	0	931075595
66	8983780	EDINSON PEDRO	BARRERA PANDURO	1	\N	\N	-12.129362761354411	-77.043825650521400	4	1	0	931075595
67	41719289	FREDDY ALVARO	BARRERA RISCO	1	\N	\N	-12.121039967775381	-77.028722886544400	6	1	1	931075595
68	43318077	DENNIS	BARRETO GOMEZ	1	\N	\N	-12.120494528627484	-77.021303982735900	3	1	1	931075595
69	45157027	HECTOR DOMINGO	BARRETO BENAVENTE	1	\N	\N	-12.110036327028680	-77.041269686167380	3	1	0	931075595
70	10548702	ROEL ERNESTO	BARRETO MIRANDA	1	\N	\N	-12.116239448982514	-77.037388185642090	5	1	1	931075595
71	73090466	EDEN	BARRIOS FELIX	1	\N	\N	-12.128222580494565	-77.033948344778220	1	1	0	931075595
72	42196871	LUIS CHRISTOPHER	BARRIOS PACHECO	1	\N	\N	-12.125073981639067	-77.028524873092320	4	1	1	931075595
73	41956795	EVER JESUS	BARZOLA FARFAN	1	\N	\N	-12.132402419776100	-77.031437478835170	5	1	0	931075595
74	9579230	HERMINIA	BAUTISTA MAMANI	1	\N	\N	-12.124980134079214	-77.035588233122230	2	1	0	931075595
75	10480765	ROSALINA	BAUTISTA CALDERON	1	\N	\N	-12.118000762605108	-77.038239112890550	3	1	0	931075595
76	41229755	SONIA	BAUTISTA ZEVALLOS	1	\N	\N	-12.127193275869072	-77.026249039905380	2	1	0	931075595
77	42711703	NOEL	BECERRA CAPCHA	1	\N	\N	-12.114665371151329	-77.024579735272170	7	1	0	931075595
\.


--
-- TOC entry 3607 (class 0 OID 1019104)
-- Dependencies: 239
-- Data for Name: mstr_alert_level; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_alert_level (alert_level_id, alert_level_code, alert_level_name, priority_order, color_code, is_active, created_at, created_by, updated_at, updated_by, deleted_at) FROM stdin;
1	low	Bajo	1	#28a745	1	2025-12-12 16:39:50.508873	system	\N	\N	\N
2	medium	Medio	2	#ffc107	1	2025-12-12 16:39:50.508873	system	\N	\N	\N
3	high	Alto	3	#fd7e14	1	2025-12-12 16:39:50.508873	system	\N	\N	\N
4	critical	Crítico	4	#dc3545	1	2025-12-12 16:39:50.508873	system	\N	\N	\N
\.


--
-- TOC entry 3584 (class 0 OID 689773)
-- Dependencies: 216
-- Data for Name: mstr_citizen; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_citizen (citizen_id, citizen_name, citizen_apellidos, citizen_document, citizen_phone, createt_at, created_by, update_at, update_by, is_active) FROM stdin;
\.


--
-- TOC entry 3585 (class 0 OID 689776)
-- Dependencies: 217
-- Data for Name: mstr_document_type; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_document_type (document_type_id, document_type_name, created_at, created_by, is_active) FROM stdin;
1	DNI	\N	\N	\N
2	Carné de Extranjería	\N	\N	\N
3	Pasaporte	\N	\N	\N
\.


--
-- TOC entry 3586 (class 0 OID 689779)
-- Dependencies: 218
-- Data for Name: mstr_guardpost; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_guardpost (guardpost_id, guardpost_name, created_at, created_by, is_active) FROM stdin;
120606	TMD-0781	2025-09-09 15:49:01	1	1
120607	TMD-0782	2025-09-09 15:49:01	1	1
120608	TMD-0783	2025-09-09 15:49:01	1	1
120610	TMD-0785	2025-09-09 15:49:01	1	1
120612	TMD-0787	2025-09-09 15:49:01	1	1
120613	TMD-0788	2025-09-09 15:49:01	1	1
120614	TMD-0789	2025-09-09 15:49:01	1	1
120619	TMD-0794	2025-09-09 15:49:01	1	1
120620	TMD-0795	2025-09-09 15:49:01	1	1
120622	TMD-0797	2025-09-09 15:49:01	1	1
120639	TMD-0814	2025-09-09 15:49:01	1	1
120641	TMD-0816	2025-09-09 15:49:01	1	1
120642	TMD-0817	2025-09-09 15:49:01	1	1
120644	TMD-0819	2025-09-09 15:49:01	1	1
120645	TMD-0820	2025-09-09 15:49:01	1	1
120802	TMD-0977	2025-09-09 15:49:01	1	1
120803	TMD-0979	2025-09-09 15:49:01	1	1
1817	EUA651	2025-09-09 15:49:01	1	1
1835	VG8799	2025-09-09 15:49:01	1	1
1853	EUA258	2025-09-09 15:49:01	1	1
1855	EUA265	2025-09-09 15:49:01	1	1
1857	EUA268	2025-09-09 15:49:01	1	1
1858	EGA914	2025-09-09 15:49:01	1	1
1859	EUA263	2025-09-09 15:49:01	1	1
1860	EGA913	2025-09-09 15:49:01	1	1
1861	EUA260	2025-09-09 15:49:01	1	1
1862	EGA909	2025-09-09 15:49:01	1	1
1865	EUA257	2025-09-09 15:49:01	1	1
1866	EUA366	2025-09-09 15:49:01	1	1
1867	EUA264	2025-09-09 15:49:01	1	1
1871	EUB418	2025-09-09 15:49:01	1	1
1873	EUB622	2025-09-09 15:49:01	1	1
1875	EUB648	2025-09-09 15:49:01	1	1
1876	EUB645	2025-09-09 15:49:01	1	1
1882	EUB763	2025-09-09 15:49:01	1	1
1891	EUC462	2025-09-09 15:49:01	1	1
1901	EUD493	2025-09-09 15:49:01	1	1
1902	EUD492	2025-09-09 15:49:01	1	1
1903	EUD489	2025-09-09 15:49:01	1	1
1904	EUD509	2025-09-09 15:49:01	1	1
1906	EUD491	2025-09-09 15:49:01	1	1
1907	EUD490	2025-09-09 15:49:01	1	1
1908	EUD510	2025-09-09 15:49:01	1	1
1909	EUD498	2025-09-09 15:49:01	1	1
1910	EUD513	2025-09-09 15:49:01	1	1
1911	EUD554	2025-09-09 15:49:01	1	1
1913	EUD496	2025-09-09 15:49:01	1	1
1914	EUD511	2025-09-09 15:49:01	1	1
1915	EUD512	2025-09-09 15:49:01	1	1
1916	EUD500	2025-09-09 15:49:01	1	1
1917	EUF173	2025-09-09 15:49:01	1	1
1918	EUF177	2025-09-09 15:49:01	1	1
1919	EUF178	2025-09-09 15:49:01	1	1
1920	EUF181	2025-09-09 15:49:01	1	1
1921	EUF186	2025-09-09 15:49:01	1	1
1922	EUF190	2025-09-09 15:49:01	1	1
1923	EUF215	2025-09-09 15:49:01	1	1
1924	EUF216	2025-09-09 15:49:01	1	1
1925	EUF217	2025-09-09 15:49:01	1	1
1926	EUF218	2025-09-09 15:49:01	1	1
1927	EUF221	2025-09-09 15:49:01	1	1
1928	EUF222	2025-09-09 15:49:01	1	1
1929	EUF225	2025-09-09 15:49:01	1	1
1930	EUF226	2025-09-09 15:49:01	1	1
1931	EUF227	2025-09-09 15:49:01	1	1
1932	EUF212	2025-09-09 15:49:01	1	1
1933	EUF213	2025-09-09 15:49:01	1	1
1934	EUF214	2025-09-09 15:49:01	1	1
1935	EUF238	2025-09-09 15:49:01	1	1
1936	EUF239	2025-09-09 15:49:01	1	1
1937	EUF240	2025-09-09 15:49:01	1	1
1938	EUF246	2025-09-09 15:49:01	1	1
1939	EUF254	2025-09-09 15:49:01	1	1
1940	EUF255	2025-09-09 15:49:01	1	1
T163	EU1835	2025-09-09 15:49:01	1	1
T172	EU1867	2025-09-09 15:49:01	1	1
T189	EU1858	2025-09-09 15:49:01	1	1
T225	EU2874	2025-09-09 15:49:01	1	1
T226	EU2868	2025-09-09 15:49:01	1	1
T227	EU2863	2025-09-09 15:49:01	1	1
T228	EU2872	2025-09-09 15:49:01	1	1
T229	EU2856	2025-09-09 15:49:01	1	1
T230	EU2864	2025-09-09 15:49:01	1	1
T232	EU2875	2025-09-09 15:49:01	1	1
T233	EU2860	2025-09-09 15:49:01	1	1
T234	EU2870	2025-09-09 15:49:01	1	1
T238	EU2887	2025-09-09 15:49:01	1	1
T245	EU3275	2025-09-09 15:49:01	1	1
T246	EU3276	2025-09-09 15:49:01	1	1
T248	EU3278	2025-09-09 15:49:01	1	1
T249	EU3279	2025-09-09 15:49:01	1	1
T250	EU3280	2025-09-09 15:49:01	1	1
T251	EU3281	2025-09-09 15:49:01	1	1
T252	EU3282	2025-09-09 15:49:01	1	1
T253	EU3283	2025-09-09 15:49:01	1	1
T254	EU3284	2025-09-09 15:49:01	1	1
T282	EU4191	2025-09-09 15:49:01	1	1
T283	EU4198	2025-09-09 15:49:01	1	1
T284	EU4199	2025-09-09 15:49:01	1	1
T285	EU4200	2025-09-09 15:49:01	1	1
T286	EU4201	2025-09-09 15:49:01	1	1
T287	EU4202	2025-09-09 15:49:01	1	1
T288	EU4203	2025-09-09 15:49:01	1	1
T289	EU4204	2025-09-09 15:49:01	1	1
T290	EU4205	2025-09-09 15:49:01	1	1
T291	EU4206	2025-09-09 15:49:01	1	1
T292	EU4207	2025-09-09 15:49:01	1	1
T293	EU4208	2025-09-09 15:49:01	1	1
T294	EU4209	2025-09-09 15:49:01	1	1
T295	EU4210	2025-09-09 15:49:01	1	1
T296	EU4211	2025-09-09 15:49:01	1	1
T297	EU4212	2025-09-09 15:49:01	1	1
T298	EU4213	2025-09-09 15:49:01	1	1
T299	EU4214	2025-09-09 15:49:01	1	1
T300	EU4215	2025-09-09 15:49:01	1	1
T301	EU4225	2025-09-09 15:49:01	1	1
\.


--
-- TOC entry 3587 (class 0 OID 689782)
-- Dependencies: 219
-- Data for Name: mstr_incidence_classification; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_incidence_classification (incidence_classification_id, incidence_classification_name, created_at, created_by, is_active, incidence_classification_code, updated_at, updated_by, unit_id) FROM stdin;
218	A. TURISTICO-APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-218	2025-12-18 06:23:37.706101	system	1
217	D. CIVIL-APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-217	2025-12-18 06:23:37.706101	system	2
216	D. HUMANO-APOYO PNP	2025-12-18 06:23:37.706101	system	1	CLAS-216	2025-12-18 06:23:37.706101	system	3
213	FISCA-APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-213	2025-12-18 06:23:37.706101	system	4
214	FISCA-QUEJAS	2025-12-18 06:23:37.706101	system	1	CLAS-214	2025-12-18 06:23:37.706101	system	4
219	O. PUBLICAS - APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-219	2025-12-18 06:23:37.706101	system	5
210	SG-ACCIDENTE	2025-12-18 06:23:37.706101	system	1	CLAS-210	2025-12-18 06:23:37.706101	system	6
212	SG-APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-212	2025-12-18 06:23:37.706101	system	6
211	SG-DELITOS	2025-12-18 06:23:37.706101	system	1	CLAS-211	2025-12-18 06:23:37.706101	system	6
215	SV-APOYO CIUDADANO	2025-12-18 06:23:37.706101	system	1	CLAS-215	2025-12-18 06:23:37.706101	system	7
\.


--
-- TOC entry 3588 (class 0 OID 689785)
-- Dependencies: 220
-- Data for Name: mstr_incidence_state; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_incidence_state (incidence_state_id, incidence_state_name, created_at, created_by, is_active, incidence_state_code, display_order, updated_at, updated_by) FROM stdin;
1	Pendiente	2025-09-09 00:00:00	1	1	REGISTERED	1	\N	\N
2	En proceso	2025-09-09 00:00:00	1	1	ASSIGNED	2	\N	\N
3	Concluido	2025-09-09 00:00:00	1	1	IN_PROGRESS	3	\N	\N
4	Repetido	2025-09-09 00:00:00	1	1	RESOLVED	4	\N	\N
5	Descartado	2025-09-09 00:00:00	1	1	CLOSED	5	\N	\N
6	Borrador	2025-12-15 13:52:28.656543	1	1	DRAFT	0	\N	\N
\.


--
-- TOC entry 3589 (class 0 OID 689788)
-- Dependencies: 221
-- Data for Name: mstr_incidence_subtype; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_incidence_subtype (incidence_subtype_id, incidence_subtype_name, create_at, created_by, is_active, incidence_subtype_code, incidence_type_id, updated_at, updated_by) FROM stdin;
1	ESTABLECIMIENTOS COMERCIALES	2025-12-18 06:25:51.363437	system	1	SUBT-001	243	2025-12-18 06:25:51.363437	system
2	TERRENOS BALDIOS, MALECONES Y OTROS	2025-12-18 06:25:51.363437	system	1	SUBT-002	243	2025-12-18 06:25:51.363437	system
3	VIVIENDAS Y/O EDIFICIOS	2025-12-18 06:25:51.363437	system	1	SUBT-003	243	2025-12-18 06:25:51.363437	system
4	ACOSO CALLEJERO	2025-12-18 06:25:51.363437	system	1	SUBT-004	240	2025-12-18 06:25:51.363437	system
5	VIOLENCIA ECONOMICA O PATRIMONIAL	2025-12-18 06:25:51.363437	system	1	SUBT-005	240	2025-12-18 06:25:51.363437	system
6	VIOLENCIA FISICA Y/O PSICOLOGICA	2025-12-18 06:25:51.363437	system	1	SUBT-006	240	2025-12-18 06:25:51.363437	system
7	VIOLENCIA SEXUAL	2025-12-18 06:25:51.363437	system	1	SUBT-007	240	2025-12-18 06:25:51.363437	system
396	CANES SIN MEDIDA DE SEGURIDAD	2025-12-18 06:25:51.363437	system	1	SUBT-396	230	2025-12-18 06:25:51.363437	system
387	CONMINAR MENDIGOS	2025-12-18 06:25:51.363437	system	1	SUBT-387	230	2025-12-18 06:25:51.363437	system
392	CONMINAR ORATE	2025-12-18 06:25:51.363437	system	1	SUBT-392	230	2025-12-18 06:25:51.363437	system
388	CONMINAR PELOTEROS	2025-12-18 06:25:51.363437	system	1	SUBT-388	230	2025-12-18 06:25:51.363437	system
389	CONMINAR VENDEDORES AMBULANTES	2025-12-18 06:25:51.363437	system	1	SUBT-389	230	2025-12-18 06:25:51.363437	system
391	CONSUMO DE LICOR EN LA VIA PUBLICA Y/O INTERIOR DEL VEHICULO	2025-12-18 06:25:51.363437	system	1	SUBT-391	230	2025-12-18 06:25:51.363437	system
385	DAÑO AL ORNATO	2025-12-18 06:25:51.363437	system	1	SUBT-385	230	2025-12-18 06:25:51.363437	system
393	DAÑOS A LA PROPIEDAD PRIVADA	2025-12-18 06:25:51.363437	system	1	SUBT-393	230	2025-12-18 06:25:51.363437	system
399	DEPORTES DE AVENTURAS SIN AUTORIZACION Y/O MEDIDAS DE SEGURIDAD	2025-12-18 06:25:51.363437	system	1	SUBT-399	230	2025-12-18 06:25:51.363437	system
404	DESCARGA DE MERCADERIA Y/O MATERIALES	2025-12-18 06:25:51.363437	system	1	SUBT-404	230	2025-12-18 06:25:51.363437	system
406	DISCRIMINACION	2025-12-18 06:25:51.363437	system	1	SUBT-406	230	2025-12-18 06:25:51.363437	system
395	EXPENDER BEBIDAS ALCOHOLICAS FUERA DE HORARIO	2025-12-18 06:25:51.363437	system	1	SUBT-395	230	2025-12-18 06:25:51.363437	system
400	LAVADO DE VEHICULO EN LA VIA PUBLICA	2025-12-18 06:25:51.363437	system	1	SUBT-400	230	2025-12-18 06:25:51.363437	system
386	MORDEDURA DE ANIMALES	2025-12-18 06:25:51.363437	system	1	SUBT-386	230	2025-12-18 06:25:51.363437	system
394	OBSTACULIZAR LIBRE TRANSITO EN VIA PUBLICA 	2025-12-18 06:25:51.363437	system	1	SUBT-394	230	2025-12-18 06:25:51.363437	system
407	OLORES TOXICOS Y/O MALOS OLORES	2025-12-18 06:25:51.363437	system	1	SUBT-407	230	2025-12-18 06:25:51.363437	system
398	ORIENTACION A RECICLADORES	2025-12-18 06:25:51.363437	system	1	SUBT-398	230	2025-12-18 06:25:51.363437	system
397	PARQUEADORES INFORMALES	2025-12-18 06:25:51.363437	system	1	SUBT-397	230	2025-12-18 06:25:51.363437	system
405	TRABAJOS EN VIA PUBLICA O MANTENIMIENTO DEL ORNATO	2025-12-18 06:25:51.363437	system	1	SUBT-405	230	2025-12-18 06:25:51.363437	system
402	TRABAJOS SIN IMPLEMENTOS DE SEGURIDAD	2025-12-18 06:25:51.363437	system	1	SUBT-402	230	2025-12-18 06:25:51.363437	system
390	VEHICULOS EN APARENTE ESTADO DE ABANDONO	2025-12-18 06:25:51.363437	system	1	SUBT-390	230	2025-12-18 06:25:51.363437	system
401	VEHICULOS MAL ESTACIONADOS 	2025-12-18 06:25:51.363437	system	1	SUBT-401	230	2025-12-18 06:25:51.363437	system
403	VOLANTES Y/O CARTELES PUBLICITARIOS	2025-12-18 06:25:51.363437	system	1	SUBT-403	230	2025-12-18 06:25:51.363437	system
416	ESCANDALO, GRITAR Y/O VOCIFERAR	2025-12-18 06:25:51.363437	system	1	SUBT-416	231	2025-12-18 06:25:51.363437	system
414	RUIDOS POR ACTIVIDADES EN COLEGIOS	2025-12-18 06:25:51.363437	system	1	SUBT-414	231	2025-12-18 06:25:51.363437	system
408	RUIDOS POR ALARMA Y/O BOCINA	2025-12-18 06:25:51.363437	system	1	SUBT-408	231	2025-12-18 06:25:51.363437	system
409	RUIDOS POR ANIMALES	2025-12-18 06:25:51.363437	system	1	SUBT-409	231	2025-12-18 06:25:51.363437	system
415	RUIDOS POR INSTRUMENTOS MUSICALES, SILBATOS, CAMPANAS Y OTROS	2025-12-18 06:25:51.363437	system	1	SUBT-415	231	2025-12-18 06:25:51.363437	system
411	RUIDOS POR MAQUINAS Y/O MOTORES	2025-12-18 06:25:51.363437	system	1	SUBT-411	231	2025-12-18 06:25:51.363437	system
412	RUIDOS POR MUSICA Y/O FIESTAS	2025-12-18 06:25:51.363437	system	1	SUBT-412	231	2025-12-18 06:25:51.363437	system
413	RUIDOS POR TRABAJOS EN VIVIENDAS	2025-12-18 06:25:51.363437	system	1	SUBT-413	231	2025-12-18 06:25:51.363437	system
410	RUIDOS POR TRABAJOS FUERA DE HORARIO	2025-12-18 06:25:51.363437	system	1	SUBT-410	231	2025-12-18 06:25:51.363437	system
301	ATROPELLO	2025-12-18 06:25:51.363437	system	1	SUBT-301	220	2025-12-18 06:25:51.363437	system
305	CAIDA DE PASAJERO	2025-12-18 06:25:51.363437	system	1	SUBT-305	220	2025-12-18 06:25:51.363437	system
302	CHOQUE	2025-12-18 06:25:51.363437	system	1	SUBT-302	220	2025-12-18 06:25:51.363437	system
303	DESPISTE	2025-12-18 06:25:51.363437	system	1	SUBT-303	220	2025-12-18 06:25:51.363437	system
304	INCENDIO DE VEHICULOS	2025-12-18 06:25:51.363437	system	1	SUBT-304	220	2025-12-18 06:25:51.363437	system
341	ANIMALES HERIDOS, MUERTOS Y/O VARADOS	2025-12-18 06:25:51.363437	system	1	SUBT-341	226	2025-12-18 06:25:51.363437	system
342	APOYO DE FUERZA	2025-12-18 06:25:51.363437	system	1	SUBT-342	226	2025-12-18 06:25:51.363437	system
337	ATENCIONES MEDICA	2025-12-18 06:25:51.363437	system	1	SUBT-337	226	2025-12-18 06:25:51.363437	system
343	ENTREVISTA POR CONFLICTOS VECINALES	2025-12-18 06:25:51.363437	system	1	SUBT-343	226	2025-12-18 06:25:51.363437	system
351	EVENTOS Y/O CEREMONIAS	2025-12-18 06:25:51.363437	system	1	SUBT-351	226	2025-12-18 06:25:51.363437	system
347	HALLAZGO DE OBJETOS	2025-12-18 06:25:51.363437	system	1	SUBT-347	226	2025-12-18 06:25:51.363437	system
339	HALLAZGO O BUSQUEDA DE ANIMALES EXTRAVIADOS	2025-12-18 06:25:51.363437	system	1	SUBT-339	226	2025-12-18 06:25:51.363437	system
352	OTRAS INTERVENCIONES (CONSULTAS, PARTE INTERNO, ENTREVISTAS)	2025-12-18 06:25:51.363437	system	1	SUBT-352	226	2025-12-18 06:25:51.363437	system
338	PERSONAS DESORIENTADAS Y/O EXTRAVIADAS	2025-12-18 06:25:51.363437	system	1	SUBT-338	226	2025-12-18 06:25:51.363437	system
349	PERSONAS DORMITANDO EN VIA PUBLICA Y/O PARQUES	2025-12-18 06:25:51.363437	system	1	SUBT-349	226	2025-12-18 06:25:51.363437	system
344	PERSONAS EN ESTADO DE EBRIEDAD Y/O ALUCINOGENOS	2025-12-18 06:25:51.363437	system	1	SUBT-344	226	2025-12-18 06:25:51.363437	system
348	PUERTAS Y/O COCHERAS ABIERTAS DE INMUEBLES	2025-12-18 06:25:51.363437	system	1	SUBT-348	226	2025-12-18 06:25:51.363437	system
340	RESCATE DE PERSONAS (EN PLAYAS Y/O ACANTILADOS)	2025-12-18 06:25:51.363437	system	1	SUBT-340	226	2025-12-18 06:25:51.363437	system
350	VEHICULOS CON DESPERFECTOS MECANICOS	2025-12-18 06:25:51.363437	system	1	SUBT-350	226	2025-12-18 06:25:51.363437	system
346	VEHICULOS SIN MEDIDAS DE SEGURIDAD 	2025-12-18 06:25:51.363437	system	1	SUBT-346	226	2025-12-18 06:25:51.363437	system
345	VERIFICACION DE MUDANZA	2025-12-18 06:25:51.363437	system	1	SUBT-345	226	2025-12-18 06:25:51.363437	system
367	BASTA DE ENGAÑO	2025-12-18 06:25:51.363437	system	1	SUBT-367	229	2025-12-18 06:25:51.363437	system
371	CACHINEROS	2025-12-18 06:25:51.363437	system	1	SUBT-371	229	2025-12-18 06:25:51.363437	system
382	CAJEROS AUTOMATICOS	2025-12-18 06:25:51.363437	system	1	SUBT-382	229	2025-12-18 06:25:51.363437	system
381	CAMBISTAS	2025-12-18 06:25:51.363437	system	1	SUBT-381	229	2025-12-18 06:25:51.363437	system
378	COMERCIO AMBULATORIO	2025-12-18 06:25:51.363437	system	1	SUBT-378	229	2025-12-18 06:25:51.363437	system
380	CONSERJES	2025-12-18 06:25:51.363437	system	1	SUBT-380	229	2025-12-18 06:25:51.363437	system
370	HOTELES	2025-12-18 06:25:51.363437	system	1	SUBT-370	229	2025-12-18 06:25:51.363437	system
377	IGLESIAS	2025-12-18 06:25:51.363437	system	1	SUBT-377	229	2025-12-18 06:25:51.363437	system
384	INSTITUCIONES EDUCATIVAS	2025-12-18 06:25:51.363437	system	1	SUBT-384	229	2025-12-18 06:25:51.363437	system
379	LAVADORES DE VEHICULOS	2025-12-18 06:25:51.363437	system	1	SUBT-379	229	2025-12-18 06:25:51.363437	system
374	LUCIERNAGA	2025-12-18 06:25:51.363437	system	1	SUBT-374	229	2025-12-18 06:25:51.363437	system
368	MOTO COLECTIVO	2025-12-18 06:25:51.363437	system	1	SUBT-368	229	2025-12-18 06:25:51.363437	system
375	OBRAS DE CONTRUCCION	2025-12-18 06:25:51.363437	system	1	SUBT-375	229	2025-12-18 06:25:51.363437	system
366	PATRULLAJE SIN FRONTERAS	2025-12-18 06:25:51.363437	system	1	SUBT-366	229	2025-12-18 06:25:51.363437	system
372	RECICLADORES	2025-12-18 06:25:51.363437	system	1	SUBT-372	229	2025-12-18 06:25:51.363437	system
369	RESTAURANTES / CENTROS COMERCIALES	2025-12-18 06:25:51.363437	system	1	SUBT-369	229	2025-12-18 06:25:51.363437	system
373	TAXISTAS DORMITANDO	2025-12-18 06:25:51.363437	system	1	SUBT-373	229	2025-12-18 06:25:51.363437	system
376	VERIFICACION DE PUENTES	2025-12-18 06:25:51.363437	system	1	SUBT-376	229	2025-12-18 06:25:51.363437	system
383	VIGILANTES EN OBRAS DE CONSTRUCCION	2025-12-18 06:25:51.363437	system	1	SUBT-383	229	2025-12-18 06:25:51.363437	system
358	ALCOHOLEMIA	2025-12-18 06:25:51.363437	system	1	SUBT-358	228	2025-12-18 06:25:51.363437	system
365	AUTOS Y/O MOTOS	2025-12-18 06:25:51.363437	system	1	SUBT-365	228	2025-12-18 06:25:51.363437	system
360	CASAS DE CAMBIO	2025-12-18 06:25:51.363437	system	1	SUBT-360	228	2025-12-18 06:25:51.363437	system
364	COMERCIO INFORMAL	2025-12-18 06:25:51.363437	system	1	SUBT-364	228	2025-12-18 06:25:51.363437	system
359	IDENTIFICACION DE PERSONAS	2025-12-18 06:25:51.363437	system	1	SUBT-359	228	2025-12-18 06:25:51.363437	system
363	MALECONES, PLAYAS Y ACANTILADOS	2025-12-18 06:25:51.363437	system	1	SUBT-363	228	2025-12-18 06:25:51.363437	system
362	MAMPARAS Y/O ESATBLECIMIENTOS COMERCIALES	2025-12-18 06:25:51.363437	system	1	SUBT-362	228	2025-12-18 06:25:51.363437	system
361	MEGA OPERATIVO	2025-12-18 06:25:51.363437	system	1	SUBT-361	228	2025-12-18 06:25:51.363437	system
357	MENDICIDAD	2025-12-18 06:25:51.363437	system	1	SUBT-357	228	2025-12-18 06:25:51.363437	system
356	ORDEN Y CONTROL	2025-12-18 06:25:51.363437	system	1	SUBT-356	228	2025-12-18 06:25:51.363437	system
355	TRATA DE PERSONAS	2025-12-18 06:25:51.363437	system	1	SUBT-355	228	2025-12-18 06:25:51.363437	system
353	PERSONAS SOSPECHOSAS	2025-12-18 06:25:51.363437	system	1	SUBT-353	227	2025-12-18 06:25:51.363437	system
354	VEHICULOS SOSPECHOSOS	2025-12-18 06:25:51.363437	system	1	SUBT-354	227	2025-12-18 06:25:51.363437	system
307	HECHOS A ESTABLECIMIENTOS COMERCIAL	2025-12-18 06:25:51.363437	system	1	SUBT-307	221	2025-12-18 06:25:51.363437	system
308	HECHOS A TRANSEUNTES DENTRO DE LOCAL COMERCIAL	2025-12-18 06:25:51.363437	system	1	SUBT-308	221	2025-12-18 06:25:51.363437	system
306	HECHOS A TRANSEUNTES EN LA VIA PUBLICA	2025-12-18 06:25:51.363437	system	1	SUBT-306	221	2025-12-18 06:25:51.363437	system
312	ROBO A VIVIENDA MULTIFAMILIAR	2025-12-18 06:25:51.363437	system	1	SUBT-312	221	2025-12-18 06:25:51.363437	system
313	ROBO A VIVIENDA UNIFAMILIAR	2025-12-18 06:25:51.363437	system	1	SUBT-313	221	2025-12-18 06:25:51.363437	system
309	ROBO DE AUTOPARTES Y/O ACCESORIOS 	2025-12-18 06:25:51.363437	system	1	SUBT-309	221	2025-12-18 06:25:51.363437	system
310	ROBO DE VEHICULOS	2025-12-18 06:25:51.363437	system	1	SUBT-310	221	2025-12-18 06:25:51.363437	system
311	ROBO DE VEHICULOS MENORES	2025-12-18 06:25:51.363437	system	1	SUBT-311	221	2025-12-18 06:25:51.363437	system
326	OFENSAS Y ACTOS CONTRA EL PUDOR 	2025-12-18 06:25:51.363437	system	1	SUBT-326	224	2025-12-18 06:25:51.363437	system
330	PROSTITUCION	2025-12-18 06:25:51.363437	system	1	SUBT-330	224	2025-12-18 06:25:51.363437	system
327	VIOLACION A LA INTIMIDAD	2025-12-18 06:25:51.363437	system	1	SUBT-327	224	2025-12-18 06:25:51.363437	system
328	VIOLACION DE DOMICILIO	2025-12-18 06:25:51.363437	system	1	SUBT-328	224	2025-12-18 06:25:51.363437	system
329	VIOLACION SEXUAL	2025-12-18 06:25:51.363437	system	1	SUBT-329	224	2025-12-18 06:25:51.363437	system
324	AGRESIONES A SERVIDORES PUBLICOS	2025-12-18 06:25:51.363437	system	1	SUBT-324	223	2025-12-18 06:25:51.363437	system
322	AGRESIONES FISICAS	2025-12-18 06:25:51.363437	system	1	SUBT-322	223	2025-12-18 06:25:51.363437	system
323	EXPOSICION O ABANDONO DE PERSONAS EN PELIGRO	2025-12-18 06:25:51.363437	system	1	SUBT-323	223	2025-12-18 06:25:51.363437	system
320	HALLAZGO DE CADAVER	2025-12-18 06:25:51.363437	system	1	SUBT-320	223	2025-12-18 06:25:51.363437	system
321	INTENTO DE SUICIDIO	2025-12-18 06:25:51.363437	system	1	SUBT-321	223	2025-12-18 06:25:51.363437	system
325	SECUESTRO	2025-12-18 06:25:51.363437	system	1	SUBT-325	223	2025-12-18 06:25:51.363437	system
332	CONDUCCION EN ESTADO DE EBRIEDAD Y/O DROGADICCION	2025-12-18 06:25:51.363437	system	1	SUBT-332	225	2025-12-18 06:25:51.363437	system
335	CONSUMO DE DROGAS	2025-12-18 06:25:51.363437	system	1	SUBT-335	225	2025-12-18 06:25:51.363437	system
331	DESORDEN EN LA VIA PUBLICA	2025-12-18 06:25:51.363437	system	1	SUBT-331	225	2025-12-18 06:25:51.363437	system
336	GRESCA	2025-12-18 06:25:51.363437	system	1	SUBT-336	225	2025-12-18 06:25:51.363437	system
334	MICROCOMERCIALIZACION DE DROGAS	2025-12-18 06:25:51.363437	system	1	SUBT-334	225	2025-12-18 06:25:51.363437	system
333	USO DE PRODUCTOS PIROTECNICOS SIN AUTORIZACION	2025-12-18 06:25:51.363437	system	1	SUBT-333	225	2025-12-18 06:25:51.363437	system
319	ABANDONO Y ACTOS DE CRUELDAD CONTRA ANIMALES	2025-12-18 06:25:51.363437	system	1	SUBT-319	222	2025-12-18 06:25:51.363437	system
316	DAÑOS A LA PROPIEDAD PRIVADA	2025-12-18 06:25:51.363437	system	1	SUBT-316	222	2025-12-18 06:25:51.363437	system
318	DELITOS INFORMATICOS	2025-12-18 06:25:51.363437	system	1	SUBT-318	222	2025-12-18 06:25:51.363437	system
314	ESTAFA Y OTRAS DEFRAUDACIONES	2025-12-18 06:25:51.363437	system	1	SUBT-314	222	2025-12-18 06:25:51.363437	system
315	EXTORSION Y CHANTAJE	2025-12-18 06:25:51.363437	system	1	SUBT-315	222	2025-12-18 06:25:51.363437	system
317	HURTOS SITEMATICO	2025-12-18 06:25:51.363437	system	1	SUBT-317	222	2025-12-18 06:25:51.363437	system
\.


--
-- TOC entry 3590 (class 0 OID 689791)
-- Dependencies: 222
-- Data for Name: mstr_incidence_type; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_incidence_type (incidence_type_id, incidence_type_name, created_at, created_by, is_active, incidence_type_code, updated_at, updated_by, incidence_classification_id) FROM stdin;
250	APOYO EN LLEGADA Y/O SALIDA DE TURISTAS	2025-12-18 06:23:48.525028	system	1	TYPE-250	2025-12-18 06:23:48.525028	system	218
248	INDIGENTES	2025-12-18 06:23:48.525028	system	1	TYPE-248	2025-12-18 06:23:48.525028	system	218
247	ORIENTACION	2025-12-18 06:23:48.525028	system	1	TYPE-247	2025-12-18 06:23:48.525028	system	218
249	SITUACION PRECARIA	2025-12-18 06:23:48.525028	system	1	TYPE-249	2025-12-18 06:23:48.525028	system	218
242	COLAPSO Y DERRUMBES	2025-12-18 06:23:48.525028	system	1	TYPE-242	2025-12-18 06:23:48.525028	system	217
244	DEFLAGRACION DE SUSTANCIAS INFLAMABLES	2025-12-18 06:23:48.525028	system	1	TYPE-244	2025-12-18 06:23:48.525028	system	217
245	DERRAME DE SUSTANCIAS TOXICAS	2025-12-18 06:23:48.525028	system	1	TYPE-245	2025-12-18 06:23:48.525028	system	217
243	INCENDIO	2025-12-18 06:23:48.525028	system	1	TYPE-243	2025-12-18 06:23:48.525028	system	217
246	OBSTACULIZAR LIBRE TRANSITO EN INMUEBLES	2025-12-18 06:23:48.525028	system	1	TYPE-246	2025-12-18 06:23:48.525028	system	217
241	ATENCION A PERSONAS VULNERABLES	2025-12-18 06:23:48.525028	system	1	TYPE-241	2025-12-18 06:23:48.525028	system	216
240	VIOLENCIA CONTRA LA MUJER Y LOS INTEGRANTES DEL GRUPO FAMILIAR	2025-12-18 06:23:48.525028	system	1	TYPE-240	2025-12-18 06:23:48.525028	system	216
230	ORDEN PUBLICO	2025-12-18 06:23:48.525028	system	1	TYPE-230	2025-12-18 06:23:48.525028	system	213
231	RUIDOS MOLESTOS	2025-12-18 06:23:48.525028	system	1	TYPE-231	2025-12-18 06:23:48.525028	system	214
252	ANIEGOS	2025-12-18 06:23:48.525028	system	1	TYPE-252	2025-12-18 06:23:48.525028	system	219
251	ARROJO DE BASURA, DESMONTE Y/O MALEZA	2025-12-18 06:23:48.525028	system	1	TYPE-251	2025-12-18 06:23:48.525028	system	219
261	CABLES SUELTOS, BUZON SIN TAPA, POSTES DAÑADOS Y/O CAIDOS	2025-12-18 06:23:48.525028	system	1	TYPE-261	2025-12-18 06:23:48.525028	system	219
259	CAIDA DE ARBOLES	2025-12-18 06:23:48.525028	system	1	TYPE-259	2025-12-18 06:23:48.525028	system	219
255	DEPOSICIONES DE LOS ANIMALES	2025-12-18 06:23:48.525028	system	1	TYPE-255	2025-12-18 06:23:48.525028	system	219
260	DETERIORO DEL ORNATO Y FALTA DE MANTENIMIENTO	2025-12-18 06:23:48.525028	system	1	TYPE-260	2025-12-18 06:23:48.525028	system	219
253	ENSUCIAR LA VIA PUBLICA POR REALIZAR NECESIDADES FISIOLOGICAS 	2025-12-18 06:23:48.525028	system	1	TYPE-253	2025-12-18 06:23:48.525028	system	219
257	FALTA DE ILUMINACION Y/O POSTES DE LUZ INOPERATIVOS	2025-12-18 06:23:48.525028	system	1	TYPE-257	2025-12-18 06:23:48.525028	system	219
258	FORADOS Y/O HUECOS EN EL ORNATO	2025-12-18 06:23:48.525028	system	1	TYPE-258	2025-12-18 06:23:48.525028	system	219
256	JUEGOS Y/O MAQUINARIAS EN MAL ESTADO	2025-12-18 06:23:48.525028	system	1	TYPE-256	2025-12-18 06:23:48.525028	system	219
254	PODA DE ARBOLES Y/O JARDINES	2025-12-18 06:23:48.525028	system	1	TYPE-254	2025-12-18 06:23:48.525028	system	219
220	ACCIDENTES DE TRANSITO	2025-12-18 06:23:48.525028	system	1	TYPE-220	2025-12-18 06:23:48.525028	system	210
226	APOYO AL CONTRIBUYENTE	2025-12-18 06:23:48.525028	system	1	TYPE-226	2025-12-18 06:23:48.525028	system	212
229	CONSIGNAS	2025-12-18 06:23:48.525028	system	1	TYPE-229	2025-12-18 06:23:48.525028	system	212
228	OPERATIVOS	2025-12-18 06:23:48.525028	system	1	TYPE-228	2025-12-18 06:23:48.525028	system	212
227	SOSPECHOSOS	2025-12-18 06:23:48.525028	system	1	TYPE-227	2025-12-18 06:23:48.525028	system	212
221	HECHO CONTRA EL PATRIMONIO	2025-12-18 06:23:48.525028	system	1	TYPE-221	2025-12-18 06:23:48.525028	system	211
224	HECHO CONTRA LA LIBERTAD	2025-12-18 06:23:48.525028	system	1	TYPE-224	2025-12-18 06:23:48.525028	system	211
223	HECHO CONTRA LA VIDA EL CUERPO Y LA SALUD	2025-12-18 06:23:48.525028	system	1	TYPE-223	2025-12-18 06:23:48.525028	system	211
225	HECHOS CONTRA LA SEGURIDAD PUBLICA	2025-12-18 06:23:48.525028	system	1	TYPE-225	2025-12-18 06:23:48.525028	system	211
222	OTROS HECHOS CONTRA EL PATRIMONIO	2025-12-18 06:23:48.525028	system	1	TYPE-222	2025-12-18 06:23:48.525028	system	211
232	AUXILIO VIAL	2025-12-18 06:23:48.525028	system	1	TYPE-232	2025-12-18 06:23:48.525028	system	215
236	CONDUCIR VEHICULOS DE MANERA TEMERARIAS	2025-12-18 06:23:48.525028	system	1	TYPE-236	2025-12-18 06:23:48.525028	system	215
235	CONGESTION VEHICULAR	2025-12-18 06:23:48.525028	system	1	TYPE-235	2025-12-18 06:23:48.525028	system	215
239	FALTA DE SEÑALIZACION DE SEGURIDAD VIAL	2025-12-18 06:23:48.525028	system	1	TYPE-239	2025-12-18 06:23:48.525028	system	215
233	PARADERO INFORMAL O COLECTIVOS	2025-12-18 06:23:48.525028	system	1	TYPE-233	2025-12-18 06:23:48.525028	system	215
238	SEMAFOROS INOPERATIVOS	2025-12-18 06:23:48.525028	system	1	TYPE-238	2025-12-18 06:23:48.525028	system	215
234	TRANSPORTE PUBLICO FUERA DE RUTA	2025-12-18 06:23:48.525028	system	1	TYPE-234	2025-12-18 06:23:48.525028	system	215
237	VEHICULOS EN ZONA RIGIDA	2025-12-18 06:23:48.525028	system	1	TYPE-237	2025-12-18 06:23:48.525028	system	215
\.


--
-- TOC entry 3591 (class 0 OID 689794)
-- Dependencies: 223
-- Data for Name: mstr_mode; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_mode (mode_id, mode_name, created_at, created_by, is_active) FROM stdin;
1	Arrebato	2025-09-09 00:00:00	1	1
2	Asalto a mano armada	2025-09-09 00:00:00	1	1
3	Hurto Agravado	2025-09-09 00:00:00	1	1
4	Hurto Estacionado	2025-09-09 00:00:00	1	1
5	Hurto simple	2025-09-09 00:00:00	1	1
6	Tendero	2025-09-09 00:00:00	1	1
7	Tentativa	2025-09-09 00:00:00	1	1
\.


--
-- TOC entry 3599 (class 0 OID 960542)
-- Dependencies: 231
-- Data for Name: mstr_operator; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_operator (operator_id, document_number, operator_name, email, password_hash, role, shift_start, shift_end, is_active, is_online, last_activity, created_at, created_by, updated_at, updated_by, deleted_at) FROM stdin;
1	00000000	Administrador Sistema	admin@civix.gob.pe	$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi	admin	\N	\N	1	0	\N	2025-12-10 12:23:44.706993	1	\N	\N	\N
\.


--
-- TOC entry 3592 (class 0 OID 689797)
-- Dependencies: 224
-- Data for Name: mstr_origin; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_origin (origin_id, origin_name, created_at, created_by, is_active, origin_type, origin_code, updated_at, updated_by) FROM stdin;
1	Aplicativo Móvil	2025-09-09 15:46:40	1	1	\N	APP_MOBILE	\N	\N
2	Comisaria	2025-09-09 15:46:40	1	1	\N	COMISARIA	\N	\N
3	Correo Electrónico	2025-09-09 15:46:40	1	1	\N	EMAIL	\N	\N
4	Página Web	2025-09-09 15:46:40	1	1	\N	WEB	\N	\N
5	Redes Sociales	2025-09-09 15:46:40	1	1	\N	SOCIAL	\N	\N
6	Sereno	2025-09-09 15:46:40	1	1	\N	SERENO	\N	\N
7	SOS	2025-09-09 15:46:40	1	1	\N	SOS	\N	\N
8	Teléfono-PBX	2025-09-09 15:46:40	1	1	\N	PHONE	\N	\N
9	Visualizacion Cámara	2025-09-09 15:46:40	1	1	\N	CAMERA	\N	\N
10	CIVIX	2025-09-10 00:00:00	1	1	\N	CIVIX	\N	\N
\.


--
-- TOC entry 3593 (class 0 OID 689800)
-- Dependencies: 225
-- Data for Name: mstr_unit; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.mstr_unit (unit_id, unit_name, created_at, created_by, is_active, updated_at, updated_by) FROM stdin;
1	APOYO AL TURISTA	2025-09-09 00:00:00	1	1	\N	\N
2	DEFENSA CIVIL	2025-09-09 00:00:00	1	1	\N	\N
3	DESARROLLO HUMANO	2025-09-09 00:00:00	1	1	\N	\N
4	FISCALIZACIÓN	2025-09-09 00:00:00	1	1	\N	\N
5	OBRAS Y SERVICIOS PÚBLICOS	2025-09-09 00:00:00	1	1	\N	\N
6	SEGURIDAD CIUDADANA	2025-09-09 00:00:00	1	1	\N	\N
7	SEGURIDAD VIAL	2025-09-09 00:00:00	1	1	\N	\N
\.


--
-- TOC entry 3594 (class 0 OID 689803)
-- Dependencies: 226
-- Data for Name: trx_incidence; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_incidence (incidence_id, origin_id, complainant, description_incidence, unit_id, mode_id, incidence_classification_id, incidence_subtype_id, incidence_type_id, cuadrante_id, operator, operator_id, incidence_date, location, location_reference, contact_number, document_number, created_at, created_by, updated_at, updated_by, incidence_state_id, classification_name, type_name, unit_name, subtype_name, origin_name, state_name, mode_name, reason, latitude, longitude, camera_civix_id, epoch_civix, camera_civix_name, alert_civix_id, incidence_code, origin_ticket_id, origin_reference_id, telegram_chat_id, reporter_email, reporter_relation, district, province, closed_at, deleted_at, alert_level_id, draft_expires_at) FROM stdin;
3	2	Persona2	demanda	2	0	2	2	2		Jesus Alberto Olivos Palma	0	2025-09-12 10:42:00	361, Calle Coronel Inclán, América, Miraflores, Lima, Lima Metropolitana, Lima, 10574, Perú		989212345	234567812	2025-09-12 10:42:24	\N	2025-09-12 10:42:24	\N	3	Todos	Todos	Todos	Todos	Aplicativo Móvil	Todos		prueba2	-12.116450000000000	-77.031700000000000	0	0		\N	INC-20250912-000003	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
4	1	Jose Lopez	apoyo ciudadano	6	0	10	73	31		Luis Salazar	0	2025-09-18 10:02:13	Hotel El Doral, 486, Avenida José Pardo, Miraflores			87654321	2025-09-18 09:58:54	\N	2025-09-16 09:58:54	\N	3	Todos	Todos	Todos	Todos	Todos	Todos		\N	-12.119038000000000	-77.032657000000000	\N	\N	\N	\N	INC-20250918-000004	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
6	10	Alex  Garcia	Actividad en zonas restringida de personas	6	0	8	122	43		Luis Salazar	0	2025-09-19 13:05:21	 AV. JOSE LARCO / CA CANTUARIAS		124356879	12435687	2025-09-18 17:30:33	\N	2025-09-18 17:30:33	\N	3	SG-APOYO CIUDADANO	PERSONAS EN ZONA RESTRINGIDA	SEGURIDAD CIUDADANA	PERSONAS EN ZONA RESTRINGIDA	CIVIX	Pendiente		\N	-12.121406682929145	-77.028967291116740	\N	\N	\N	\N	INC-20250918-000006	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
7	10	Elmer PAz	Actividad en zonas restringida de personas	6	0	8	122	43		Luis Salazar	0	2025-09-19 15:09:44	 AV. JOSE LARCO / CA CANTUARIAS		986754321	45678912	2025-09-18 18:18:27	\N	2025-09-18 18:18:27	\N	3	SG-APOYO CIUDADANO	PERSONAS EN ZONA RESTRINGIDA	SEGURIDAD CIUDADANA	PERSONAS EN ZONA RESTRINGIDA	CIVIX	Pendiente		\N	-12.121406682929145	-77.028967291116740	118	1758237315841	P54WFJ1MC-RR	64703	INC-20250918-000007	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
8	10	Persona 4	Actividad en zonas restringida de personas	6	0	8	122	43		Luis Salazar	0	2025-09-22 10:16:09	HALL ASCENSORES L-A		981276345	87654321	2025-09-22 10:14:32	\N	2025-09-22 10:14:32	\N	3	SG-APOYO CIUDADANO	PERSONAS EN ZONA RESTRINGIDA	SEGURIDAD CIUDADANA	PERSONAS EN ZONA RESTRINGIDA	CIVIX	Pendiente		\N	-12.118386300000000	-77.039860800000000	912	1758553982799	UTEC50	91161	INC-20250922-000008	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
1	1	Pedro Palomino	ruidos molestos	1	0	1	1	1		Luis salazar	0	2025-09-11 00:00:00	399, Avenida José Pardo, Miraflores, Lima, Lima Metropolitana, Lima, 15074, Perú		12345678	987654321	2025-09-11 12:51:50	\N	2025-09-11 12:51:50	\N	3	A. TURISTICO-APOYO CIUDADANO	ACCIDENTES DE TRANSITO	APOYO AL TURISTA	ABANDONO Y ACTOS DE CRUELDAD CONTRA ANIMALES	Aplicativo Móvil	Pendiente		Prueba	-12.119096000000000	-77.032961000000000	0	0		\N	INC-20250911-000001	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N
13	1	Jeanfranco		1	\N	1	1	39	\N	\N	\N	2025-12-15 14:48:29.892	Ciclovía Colonial 699, Mirones		988711041	71956015	2025-12-15 10:00:16.751811	\N	2025-12-15 10:00:16.751811	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-20251215-000014	\N	\N	\N	example@example.com	self	Lima Metropolitana	Lima	\N	\N	3	\N
15	1	Gabriel Gonzales		1	\N	1	1	22	\N	\N	\N	2025-12-15 15:26:03.777	Calle Armando Blondet, La Victoria		986754321	11231901	2025-12-15 10:26:03.842916	\N	2025-12-15 10:26:03.842916	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.086863000000000	-77.011637000000000	\N	\N	\N	\N	INC-20251215-000016	\N	\N	\N	example@example.com	third_party	Lima Metropolitana	Lima	\N	\N	2	\N
17	1	Jeanfranco		1	\N	1	1	39	\N	\N	\N	2025-12-15 14:48:29.892	Ciclovía Colonial 699, Mirones		988711041	71956015	2025-12-15 15:24:22.878498	\N	2025-12-15 15:24:22.878498	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-20251215-000018	\N	\N	\N	example@example.com	self	Lima Metropolitana	Lima	\N	\N	3	\N
22	1	Usuario Prueba	\N	1	\N	1	\N	44	\N	\N	\N	2025-12-15 15:52:41.206771	Ciclovía Colonial 699, Mironesq	\N	12345678	098765432	2025-12-15 15:52:41.206771	1	2025-12-16 17:02:19.716183	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000003	\N	\N	\N	example@example.com	third_party	Lima Metropolitana	Lima	\N	\N	1	\N
21	1	Pedro Palomino	\N	1	\N	1	\N	39	\N	\N	\N	2025-12-15 15:52:17.009364	\N	\N	\N	\N	2025-12-15 15:52:17.009364	1	2025-12-17 02:13:03.507652	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000002	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
27	1	Prueba 01	\N	1	\N	1	\N	39	\N	\N	\N	2025-12-16 17:51:57.826621	\N	\N	\N	\N	2025-12-16 17:51:57.826621	1	2025-12-17 02:14:13.044098	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000008	\N	\N	\N	\N	self	s	\N	\N	\N	2	\N
25	1	Jeanfranco		1	\N	1	1	39	\N	\N	\N	2025-12-15 17:33:10.811109	Ciclovía Colonial 699, Mirones		988711041	71956015	2025-12-15 17:33:10.811109	1	2025-12-16 15:31:00.377185	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000006	\N	\N	\N	example@example.com	self	Lima Metropolitana	Lima	\N	\N	1	\N
28	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-17 02:22:41.932809	\N	\N	\N	\N	2025-12-17 02:22:41.932809	1	2025-12-17 02:22:41.932809	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000009	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
31	1	Carlos Ruiz	\N	1	\N	1	\N	8	\N	\N	\N	2025-12-17 02:33:22.882422	1234556789	\N	\N	\N	2025-12-17 02:33:22.882422	1	2025-12-17 13:54:56.788202	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.118715000000000	-77.030779000000000	\N	\N	\N	\N	INC-2025-000012	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
37	1	Ticket 000018	\N	1	\N	1	\N	18	\N	\N	\N	2025-12-17 10:46:43.054326	\N	\N	\N	\N	2025-12-17 10:46:43.054326	1	2025-12-17 17:22:42.979162	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.124254000000000	-77.010169000000000	\N	\N	\N	\N	INC-2025-000018	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
29	8	\N	Observacion 1	1	\N	212	\N	226	\N	\N	\N	2025-12-17 02:25:27.670353	Parque Sol Terraza Café, 498, Calle Piura	\N	\N	\N	2025-12-17 02:25:27.670353	1	2025-12-18 10:01:05.247887	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.115873000000000	-77.033152000000000	\N	\N	\N	\N	INC-2025-000010	\N	\N	\N	\N	self	Miraflores	Lima Metropolitana	\N	\N	2	\N
19	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-15 15:44:14.287484	\N	\N	\N	\N	2025-12-15 15:44:14.287484	1	2025-12-15 15:44:14.287484	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000001	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2025-12-15 15:49:34.540238	\N	\N	\N	\N	2025-12-15 15:49:34.540238	1	2025-12-15 15:49:34.540238	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2024-999999	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
24	1	Jeanfranco		\N	\N	\N	\N	\N	\N	\N	\N	2025-12-15 16:38:10.009428	\N	\N	\N	\N	2025-12-15 16:38:10.009428	1	2025-12-16 12:00:28.441332	system	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000005	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	\N
23	1	Jeanfranco Armando		1	\N	1	\N	39	\N	\N	\N	2025-12-15 15:53:14.291326	\N	ssss	\N	\N	2025-12-15 15:53:14.291326	1	2025-12-16 17:52:22.531851	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000004	\N	\N	\N	\N	self	\N	\N	\N	\N	1	\N
32	1	Ticket 000013	\N	1	\N	1	\N	8	\N	\N	\N	2025-12-17 02:34:32.634463	\N	\N	98871141	71956015	2025-12-17 02:34:32.634463	1	2025-12-17 13:54:23.598669	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.118715000000000	-77.030779000000000	\N	\N	\N	\N	INC-2025-000013	\N	\N	\N	example@example.com	third_party	\N	\N	\N	\N	2	\N
30	1	María García	\N	1	\N	1	\N	\N	\N	\N	\N	2025-12-17 02:31:13.89242	\N	\N	\N	87654321	2025-12-17 02:31:13.89242	1	2025-12-17 02:32:42.170832	1	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000011	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
26	1	María García	\N	1	\N	1	\N	39	\N	\N	\N	2025-12-16 17:19:13.392514	\N	\N	\N	\N	2025-12-16 17:19:13.392514	1	2025-12-17 02:15:32.223927	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.046787000000000	-77.049119000000000	\N	\N	\N	\N	INC-2025-000007	\N	\N	\N	\N	self	s	\N	\N	\N	1	\N
39	1	ASDPS	\N	3	\N	217	\N	242	\N	\N	\N	2025-12-17 17:24:52.886032	América, Miraflores, Lima	\N	988711041	71956015	2025-12-17 17:24:52.886032	1	2025-12-18 10:25:14.536026	1	3	\N	\N	\N	\N	\N	\N	\N	\N	-12.114696000000000	-77.034096000000000	\N	\N	\N	\N	INC-2025-000020	\N	\N	\N	example@example.com	third_party	Miraflores	Lima Metropolitana	\N	\N	2	\N
38	1	asda	prueba	2	\N	211	\N	221	\N	\N	\N	2025-12-17 13:03:18.2992	284, Avenida Manuel Villarán, Alicia	\N	55 9876 5432	12345678	2025-12-17 13:03:18.2992	1	2025-12-18 10:30:34.641332	1	1	\N	\N	\N	\N	\N	\N	\N	\N	-12.124254000000000	-77.010169000000000	\N	\N	\N	\N	INC-2025-000019	\N	\N	\N	juan@example.com	third_party	Miraflores	Lima Metropolitana	\N	\N	2	\N
33	1	sad1	\N	1	\N	1	\N	\N	\N	\N	\N	2025-12-17 02:45:14.82341	\N	\N	\N	\N	2025-12-17 02:45:14.82341	1	2025-12-18 10:33:05.55967	1	1	\N	\N	\N	\N	\N	\N	\N	\N	-12.126839000000000	-77.018306000000000	\N	\N	\N	\N	INC-2025-000014	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
40	8	\N	\N	2	\N	217	\N	243	\N	\N	\N	2025-12-18 10:26:24.552261	Ciclovía Malecón Cisneros, Santa Cruz, Miraflores	\N	\N	\N	2025-12-18 10:26:24.552261	1	2025-12-18 10:42:29.197266	1	2	\N	\N	\N	\N	\N	\N	\N	\N	-12.121599000000000	-77.043495000000000	\N	\N	\N	\N	INC-2025-000021	\N	\N	\N	\N	self	Miraflores	Lima Metropolitana	\N	\N	2	\N
34	1	Prueba de las 3AM	\N	1	\N	1	\N	\N	\N	\N	\N	2025-12-17 02:57:11.239057	\N	\N	\N	\N	2025-12-17 02:57:11.239057	1	2025-12-17 02:57:21.151361	1	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000015	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
35	1	pruebas	\N	1	\N	1	\N	\N	\N	\N	\N	2025-12-17 08:07:44.30851	\N	\N	\N	\N	2025-12-17 08:07:44.30851	1	2025-12-17 09:33:51.559252	1	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	INC-2025-000016	\N	\N	\N	\N	self	\N	\N	\N	\N	3	\N
36	1	Prueba Borrador 1	\N	1	\N	1	\N	\N	\N	\N	\N	2025-12-17 09:31:54.52942	\N	\N	\N	\N	2025-12-17 09:31:54.52942	1	2025-12-17 11:13:42.748848	1	1	\N	\N	\N	\N	\N	\N	\N	\N	-12.105124000000000	-77.031531000000000	\N	\N	\N	\N	INC-2025-000017	\N	\N	\N	\N	self	\N	\N	\N	\N	2	\N
\.


--
-- TOC entry 3595 (class 0 OID 689808)
-- Dependencies: 227
-- Data for Name: trx_incidence_agent; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_incidence_agent (agent_id, incidence_id, created_at, created_by, is_active) FROM stdin;
2	1	2025-09-17 10:30:08	1	1
5	8	2025-09-22 10:33:12	1	1
27	1	2025-09-17 10:30:08	1	1
35	1	2025-09-17 10:30:08	1	1
48	4	2025-10-15 09:50:52	1	1
54	4	2025-10-15 09:50:52	1	1
67	8	2025-09-22 10:33:12	1	1
72	8	2025-09-22 10:33:12	1	1
\.


--
-- TOC entry 3596 (class 0 OID 689811)
-- Dependencies: 228
-- Data for Name: trx_incidence_derivative; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_incidence_derivative (incidence_id, incidence_derivative_id, unit_id_old, unit_name_old, unit_id, unit_name, created_at, created_by, incidence_classification_id_old, incidence_classification_name_old, incidence_classification_id, incidence_classification_name, is_active, is_last, incidence_state_id_old, incidence_state_name_old, incidence_state_id, incidence_state_name, operator) FROM stdin;
7	1	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1		1	Pendiente	Luis Salazar
7	2	6	SEGURIDAD CIUDADANA	4	FISCALIZACIÓN	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1		1	Pendiente	Luis Salazar
7	3	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1		1	Pendiente	Luis Salazar
7	4	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1		1	Pendiente	Luis Salazar
7	5	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1	Pendiente	1	Pendiente	Luis Salazar
7	6	6	SEGURIDAD CIUDADANA	4	FISCALIZACIÓN	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1	Pendiente	1	Pendiente	Luis Salazar
7	7	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1	Pendiente	1	Pendiente	Luis Salazar
7	8	6	SEGURIDAD CIUDADANA	4	FISCALIZACIÓN	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1	Pendiente	1	Pendiente	Luis Salazar
7	9	4	FISCALIZACIÓN	6	SEGURIDAD CIUDADANA	\N	1	8	SG-APOYO CIUDADANO	8	SG-APOYO CIUDADANO	1	1	1	Pendiente	1	Pendiente	Luis Salazar
\.


--
-- TOC entry 3597 (class 0 OID 689814)
-- Dependencies: 229
-- Data for Name: trx_incidence_document; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_incidence_document (incidence_document_id, incidence_id, ruta, origin_id, is_active, complainant, description_document, unit_id, extension_document, created_at, created_by) FROM stdin;
\.


--
-- TOC entry 3605 (class 0 OID 960608)
-- Dependencies: 237
-- Data for Name: trx_incidence_specific_data; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_incidence_specific_data (specific_data_id, incidence_id, data_type, data_content, created_at, created_by, updated_at, updated_by, is_active) FROM stdin;
\.


--
-- TOC entry 3601 (class 0 OID 960574)
-- Dependencies: 233
-- Data for Name: trx_ticket_operator_assignment; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_ticket_operator_assignment (assignment_id, incidence_id, operator_id, assigned_at, released_at, assigned_by, released_by, assignment_type, notes, is_current, is_active, created_at, created_by, updated_at, updated_by) FROM stdin;
\.


--
-- TOC entry 3603 (class 0 OID 960592)
-- Dependencies: 235
-- Data for Name: trx_ticket_status_history; Type: TABLE DATA; Schema: a2c_schema; Owner: civix_user
--

COPY a2c_schema.trx_ticket_status_history (history_id, incidence_id, old_state_id, new_state_id, changed_by, reason, changed_at, created_at, created_by) FROM stdin;
1	8	\N	1	\N	\N	2025-09-22 10:14:32	2025-12-10 12:23:44.706993	\N
2	6	\N	1	\N	\N	2025-09-18 17:30:33	2025-12-10 12:23:44.706993	\N
3	4	\N	1	\N	\N	2025-09-18 09:58:54	2025-12-10 12:23:44.706993	\N
4	1	\N	1	\N	\N	2025-09-11 12:51:50	2025-12-10 12:23:44.706993	\N
5	3	\N	1	\N	\N	2025-09-12 10:42:24	2025-12-10 12:23:44.706993	\N
6	7	\N	1	\N	\N	2025-09-18 18:18:27	2025-12-10 12:23:44.706993	\N
\.


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 238
-- Name: mstr_alert_level_alert_level_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.mstr_alert_level_alert_level_id_seq', 4, true);


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 230
-- Name: mstr_operator_operator_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.mstr_operator_operator_id_seq', 1, true);


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 240
-- Name: trx_incidence_incidence_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.trx_incidence_incidence_id_seq', 40, true);


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 236
-- Name: trx_incidence_specific_data_specific_data_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.trx_incidence_specific_data_specific_data_id_seq', 1, false);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 232
-- Name: trx_ticket_operator_assignment_assignment_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.trx_ticket_operator_assignment_assignment_id_seq', 1, false);


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 234
-- Name: trx_ticket_status_history_history_id_seq; Type: SEQUENCE SET; Schema: a2c_schema; Owner: civix_user
--

SELECT pg_catalog.setval('a2c_schema.trx_ticket_status_history_history_id_seq', 6, true);


--
-- TOC entry 3436 (class 2606 OID 1019113)
-- Name: mstr_alert_level mstr_alert_level_alert_level_code_key; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_alert_level
    ADD CONSTRAINT mstr_alert_level_alert_level_code_key UNIQUE (alert_level_code);


--
-- TOC entry 3438 (class 2606 OID 1019111)
-- Name: mstr_alert_level mstr_alert_level_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_alert_level
    ADD CONSTRAINT mstr_alert_level_pkey PRIMARY KEY (alert_level_id);


--
-- TOC entry 3386 (class 2606 OID 1313194)
-- Name: mstr_incidence_classification mstr_incidence_classification_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_incidence_classification
    ADD CONSTRAINT mstr_incidence_classification_pkey PRIMARY KEY (incidence_classification_id);


--
-- TOC entry 3412 (class 2606 OID 960554)
-- Name: mstr_operator mstr_operator_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_operator
    ADD CONSTRAINT mstr_operator_pkey PRIMARY KEY (operator_id);


--
-- TOC entry 3399 (class 2606 OID 1313192)
-- Name: mstr_unit mstr_unit_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_unit
    ADD CONSTRAINT mstr_unit_pkey PRIMARY KEY (unit_id);


--
-- TOC entry 3434 (class 2606 OID 960618)
-- Name: trx_incidence_specific_data trx_incidence_specific_data_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_incidence_specific_data
    ADD CONSTRAINT trx_incidence_specific_data_pkey PRIMARY KEY (specific_data_id);


--
-- TOC entry 3422 (class 2606 OID 960586)
-- Name: trx_ticket_operator_assignment trx_ticket_operator_assignment_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_ticket_operator_assignment
    ADD CONSTRAINT trx_ticket_operator_assignment_pkey PRIMARY KEY (assignment_id);


--
-- TOC entry 3428 (class 2606 OID 960602)
-- Name: trx_ticket_status_history trx_ticket_status_history_pkey; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_ticket_status_history
    ADD CONSTRAINT trx_ticket_status_history_pkey PRIMARY KEY (history_id);


--
-- TOC entry 3414 (class 2606 OID 960558)
-- Name: mstr_operator uk_operator_document; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_operator
    ADD CONSTRAINT uk_operator_document UNIQUE (document_number);


--
-- TOC entry 3416 (class 2606 OID 960560)
-- Name: mstr_operator uk_operator_email; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_operator
    ADD CONSTRAINT uk_operator_email UNIQUE (email);


--
-- TOC entry 3397 (class 2606 OID 959997)
-- Name: mstr_origin uk_origin_code; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_origin
    ADD CONSTRAINT uk_origin_code UNIQUE (origin_code);


--
-- TOC entry 3389 (class 2606 OID 959992)
-- Name: mstr_incidence_state uk_state_code; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_incidence_state
    ADD CONSTRAINT uk_state_code UNIQUE (incidence_state_code);


--
-- TOC entry 3392 (class 2606 OID 960004)
-- Name: mstr_incidence_subtype uk_subtype_code; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_incidence_subtype
    ADD CONSTRAINT uk_subtype_code UNIQUE (incidence_subtype_code);


--
-- TOC entry 3395 (class 2606 OID 959999)
-- Name: mstr_incidence_type uk_type_code; Type: CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.mstr_incidence_type
    ADD CONSTRAINT uk_type_code UNIQUE (incidence_type_code);


--
-- TOC entry 3417 (class 1259 OID 960589)
-- Name: idx_assignment_current; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_assignment_current ON a2c_schema.trx_ticket_operator_assignment USING btree (is_current);


--
-- TOC entry 3418 (class 1259 OID 960590)
-- Name: idx_assignment_dates; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_assignment_dates ON a2c_schema.trx_ticket_operator_assignment USING btree (assigned_at, released_at);


--
-- TOC entry 3419 (class 1259 OID 960587)
-- Name: idx_assignment_incidence; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_assignment_incidence ON a2c_schema.trx_ticket_operator_assignment USING btree (incidence_id);


--
-- TOC entry 3420 (class 1259 OID 960588)
-- Name: idx_assignment_operator; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_assignment_operator ON a2c_schema.trx_ticket_operator_assignment USING btree (operator_id);


--
-- TOC entry 3384 (class 1259 OID 1313195)
-- Name: idx_classification_unit; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_classification_unit ON a2c_schema.mstr_incidence_classification USING btree (unit_id);


--
-- TOC entry 3400 (class 1259 OID 960570)
-- Name: idx_closed_at; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_closed_at ON a2c_schema.trx_incidence USING btree (closed_at);


--
-- TOC entry 3401 (class 1259 OID 960569)
-- Name: idx_deleted_at; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_deleted_at ON a2c_schema.trx_incidence USING btree (deleted_at);


--
-- TOC entry 3423 (class 1259 OID 960605)
-- Name: idx_history_date; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_history_date ON a2c_schema.trx_ticket_status_history USING btree (changed_at);


--
-- TOC entry 3424 (class 1259 OID 960603)
-- Name: idx_history_incidence; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_history_incidence ON a2c_schema.trx_ticket_status_history USING btree (incidence_id);


--
-- TOC entry 3425 (class 1259 OID 960606)
-- Name: idx_history_incidence_date; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_history_incidence_date ON a2c_schema.trx_ticket_status_history USING btree (incidence_id, changed_at);


--
-- TOC entry 3426 (class 1259 OID 960604)
-- Name: idx_history_new_state; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_history_new_state ON a2c_schema.trx_ticket_status_history USING btree (new_state_id);


--
-- TOC entry 3402 (class 1259 OID 1019250)
-- Name: idx_incidence_alert_level_id; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_incidence_alert_level_id ON a2c_schema.trx_incidence USING btree (alert_level_id);


--
-- TOC entry 3403 (class 1259 OID 960566)
-- Name: idx_incidence_code; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_incidence_code ON a2c_schema.trx_incidence USING btree (incidence_code);


--
-- TOC entry 3404 (class 1259 OID 960571)
-- Name: idx_incidence_state; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_incidence_state ON a2c_schema.trx_incidence USING btree (incidence_state_id);


--
-- TOC entry 3405 (class 1259 OID 960572)
-- Name: idx_location_coords; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_location_coords ON a2c_schema.trx_incidence USING btree (latitude, longitude);


--
-- TOC entry 3407 (class 1259 OID 960561)
-- Name: idx_operator_active; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_operator_active ON a2c_schema.mstr_operator USING btree (is_active);


--
-- TOC entry 3408 (class 1259 OID 960564)
-- Name: idx_operator_deleted; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_operator_deleted ON a2c_schema.mstr_operator USING btree (deleted_at);


--
-- TOC entry 3409 (class 1259 OID 960562)
-- Name: idx_operator_online; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_operator_online ON a2c_schema.mstr_operator USING btree (is_online);


--
-- TOC entry 3410 (class 1259 OID 960563)
-- Name: idx_operator_role; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_operator_role ON a2c_schema.mstr_operator USING btree (role);


--
-- TOC entry 3429 (class 1259 OID 960621)
-- Name: idx_specific_data_active; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_specific_data_active ON a2c_schema.trx_incidence_specific_data USING btree (is_active);


--
-- TOC entry 3430 (class 1259 OID 960622)
-- Name: idx_specific_data_content; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_specific_data_content ON a2c_schema.trx_incidence_specific_data USING gin (data_content);


--
-- TOC entry 3431 (class 1259 OID 960619)
-- Name: idx_specific_data_incidence; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_specific_data_incidence ON a2c_schema.trx_incidence_specific_data USING btree (incidence_id);


--
-- TOC entry 3432 (class 1259 OID 960620)
-- Name: idx_specific_data_type; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_specific_data_type ON a2c_schema.trx_incidence_specific_data USING btree (data_type);


--
-- TOC entry 3387 (class 1259 OID 959993)
-- Name: idx_state_order; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_state_order ON a2c_schema.mstr_incidence_state USING btree (display_order);


--
-- TOC entry 3390 (class 1259 OID 960005)
-- Name: idx_subtype_type; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_subtype_type ON a2c_schema.mstr_incidence_subtype USING btree (incidence_type_id);


--
-- TOC entry 3406 (class 1259 OID 960567)
-- Name: idx_telegram_chat; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_telegram_chat ON a2c_schema.trx_incidence USING btree (telegram_chat_id);


--
-- TOC entry 3393 (class 1259 OID 1313196)
-- Name: idx_type_classification; Type: INDEX; Schema: a2c_schema; Owner: civix_user
--

CREATE INDEX idx_type_classification ON a2c_schema.mstr_incidence_type USING btree (incidence_classification_id);


--
-- TOC entry 3439 (class 2606 OID 1019243)
-- Name: trx_incidence fk_incidence_alert_level; Type: FK CONSTRAINT; Schema: a2c_schema; Owner: civix_user
--

ALTER TABLE ONLY a2c_schema.trx_incidence
    ADD CONSTRAINT fk_incidence_alert_level FOREIGN KEY (alert_level_id) REFERENCES a2c_schema.mstr_alert_level(alert_level_id);


-- Completed on 2025-12-18 10:43:49 -05

--
-- PostgreSQL database dump complete
--

