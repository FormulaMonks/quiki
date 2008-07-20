--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: code_blocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE code_blocks (
    id integer NOT NULL,
    page_id integer,
    version integer,
    "language" character varying(255),
    code text,
    highlighted text,
    theme character varying(255),
    created_at timestamp without time zone
);


--
-- Name: code_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE code_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: code_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE code_blocks_id_seq OWNED BY code_blocks.id;


--
-- Name: page_versions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE page_versions (
    id integer NOT NULL,
    page_id integer,
    version integer,
    path character varying(255),
    body text,
    rendered text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parser character varying(255),
    section_id integer,
    title character varying(255) NOT NULL
);


--
-- Name: page_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE page_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: page_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE page_versions_id_seq OWNED BY page_versions.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    path character varying(255) NOT NULL,
    body text,
    rendered text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    parser character varying(255),
    version integer DEFAULT 0 NOT NULL,
    section_id integer,
    title character varying(255) NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sections (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sections_id_seq OWNED BY sections.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE code_blocks ALTER COLUMN id SET DEFAULT nextval('code_blocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE page_versions ALTER COLUMN id SET DEFAULT nextval('page_versions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE sections ALTER COLUMN id SET DEFAULT nextval('sections_id_seq'::regclass);


--
-- Name: code_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY code_blocks
    ADD CONSTRAINT code_blocks_pkey PRIMARY KEY (id);


--
-- Name: page_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY page_versions
    ADD CONSTRAINT page_versions_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: index_code_blocks_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_code_blocks_on_created_at ON code_blocks USING btree (created_at);


--
-- Name: index_code_blocks_on_language; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_code_blocks_on_language ON code_blocks USING btree ("language");


--
-- Name: index_code_blocks_on_page_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_code_blocks_on_page_id ON code_blocks USING btree (page_id);


--
-- Name: index_code_blocks_on_version; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_code_blocks_on_version ON code_blocks USING btree (version);


--
-- Name: index_page_versions_on_section_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_page_versions_on_section_id ON page_versions USING btree (section_id);


--
-- Name: index_pages_on_path; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_path ON pages USING btree (path);


--
-- Name: index_pages_on_section_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_section_id ON pages USING btree (section_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20080710050843');

INSERT INTO schema_migrations (version) VALUES ('20080710083826');

INSERT INTO schema_migrations (version) VALUES ('20080710091131');

INSERT INTO schema_migrations (version) VALUES ('20080710215125');

INSERT INTO schema_migrations (version) VALUES ('20080712210113');

INSERT INTO schema_migrations (version) VALUES ('20080712230833');

INSERT INTO schema_migrations (version) VALUES ('20080718040324');