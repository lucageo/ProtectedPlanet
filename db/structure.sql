--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

--
-- Name: first_agg(anyelement, anyelement); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION first_agg(anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
        SELECT $1;
$_$;


--
-- Name: first(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE first(anyelement) (
    SFUNC = first_agg,
    STYPE = anyelement
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries (
    id integer NOT NULL,
    name text,
    iso character varying(255),
    iso_3 character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    language text DEFAULT 'english'::text NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: countries_protected_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE countries_protected_areas (
    protected_area_id integer,
    country_id integer
);


--
-- Name: designations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE designations (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    jurisdiction_id integer
);


--
-- Name: designations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE designations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: designations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE designations_id_seq OWNED BY designations.id;


--
-- Name: governances; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE governances (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: governances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE governances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: governances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE governances_id_seq OWNED BY governances.id;


--
-- Name: iucn_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE iucn_categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: iucn_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE iucn_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: iucn_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE iucn_categories_id_seq OWNED BY iucn_categories.id;


--
-- Name: jurisdictions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE jurisdictions (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE jurisdictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jurisdictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE jurisdictions_id_seq OWNED BY jurisdictions.id;


--
-- Name: legal_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legal_statuses (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: legal_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE legal_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legal_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE legal_statuses_id_seq OWNED BY legal_statuses.id;


--
-- Name: management_authorities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE management_authorities (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: management_authorities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE management_authorities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: management_authorities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE management_authorities_id_seq OWNED BY management_authorities.id;


--
-- Name: no_take_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE no_take_statuses (
    id integer NOT NULL,
    name character varying(255),
    area numeric,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: no_take_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE no_take_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: no_take_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE no_take_statuses_id_seq OWNED BY no_take_statuses.id;


--
-- Name: protected_areas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protected_areas (
    id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    wdpa_id integer,
    wdpa_parent_id integer,
    name text,
    original_name text,
    marine boolean,
    reported_marine_area numeric,
    reported_area numeric,
    gis_area numeric,
    gis_marine_area numeric,
    legal_status_id integer,
    legal_status_updated_at timestamp without time zone,
    iucn_category_id integer,
    governance_id integer,
    management_plan text,
    management_authority_id integer,
    international_criteria character varying(255),
    no_take_status_id integer,
    designation_id integer,
    the_geom geometry
);


--
-- Name: protected_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE protected_areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protected_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE protected_areas_id_seq OWNED BY protected_areas.id;


--
-- Name: protected_areas_sub_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE protected_areas_sub_locations (
    protected_area_id integer,
    sub_location_id integer
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: sub_locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sub_locations (
    id integer NOT NULL,
    english_name character varying(255),
    local_name character varying(255),
    alternate_name character varying(255),
    iso character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country_id integer
);


--
-- Name: search_index; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW search_index AS
 SELECT pa.id,
    pa.name,
    ((((setweight(to_tsvector('english'::regconfig, COALESCE(string_agg(c.name, ' '::text), ''::text)), 'B'::"char") || setweight(to_tsvector('english'::regconfig, COALESCE(pa.name, ''::text)), 'A'::"char")) || to_tsvector((first(c.language))::regconfig, unaccent(COALESCE(pa.original_name, ''::text)))) || to_tsvector('english'::regconfig, COALESCE(string_agg((sl.english_name)::text, ''::text)))) || to_tsvector(first((c.language)::regconfig), COALESCE(string_agg((sl.alternate_name)::text, ''::text)))) AS document
   FROM (((protected_areas pa
   LEFT JOIN countries_protected_areas cpa ON ((cpa.protected_area_id = pa.id)))
   LEFT JOIN countries c ON ((cpa.country_id = c.id)))
   LEFT JOIN sub_locations sl ON ((c.id = sl.country_id)))
  GROUP BY pa.name, pa.id, pa.original_name
  ORDER BY pa.name
 LIMIT 1000
  WITH NO DATA;


--
-- Name: sub_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sub_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sub_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sub_locations_id_seq OWNED BY sub_locations.id;


--
-- Name: wdpa_source_june2014; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wdpa_source_june2014 (
    ogc_fid integer NOT NULL,
    metadataid double precision,
    data_title character varying,
    resp_party character varying,
    resp_email character varying,
    year character varying,
    language character varying,
    char_set character varying,
    ref_system character varying,
    scale character varying,
    lineage character varying,
    citation character varying,
    disclaimer character varying
);


--
-- Name: wdpa_source_june2014_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wdpa_source_june2014_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wdpa_source_june2014_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wdpa_source_june2014_ogc_fid_seq OWNED BY wdpa_source_june2014.ogc_fid;


--
-- Name: wdpapoint_june2014; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wdpapoint_june2014 (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry(MultiPoint,4326),
    wdpaid integer,
    wdpa_pid integer,
    name character varying,
    orig_name character varying,
    sub_loc character varying,
    desig character varying,
    desig_eng character varying,
    desig_type character varying,
    iucn_cat character varying,
    int_crit character varying,
    marine character varying,
    rep_m_area double precision,
    rep_area double precision,
    status character varying,
    status_yr integer,
    gov_type character varying,
    mang_auth character varying,
    mang_plan character varying,
    no_take character varying,
    no_tk_area double precision,
    metadataid integer,
    iso3 character varying,
    parent_iso3 character varying
);


--
-- Name: wdpapoint_june2014_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wdpapoint_june2014_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wdpapoint_june2014_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wdpapoint_june2014_ogc_fid_seq OWNED BY wdpapoint_june2014.ogc_fid;


--
-- Name: wdpapoly_june2014; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wdpapoly_june2014 (
    ogc_fid integer NOT NULL,
    wkb_geometry geometry(MultiPolygon,4326),
    wdpaid integer,
    wdpa_pid integer,
    name character varying,
    orig_name character varying,
    sub_loc character varying,
    desig character varying,
    desig_eng character varying,
    desig_type character varying,
    iucn_cat character varying,
    int_crit character varying,
    marine character varying,
    rep_m_area double precision,
    gis_m_area double precision,
    rep_area double precision,
    gis_area double precision,
    status character varying,
    status_yr integer,
    gov_type character varying,
    mang_auth character varying,
    mang_plan character varying,
    no_take character varying,
    no_tk_area double precision,
    metadataid integer,
    parent_iso3 character varying,
    iso3 character varying,
    shape_length double precision,
    shape_area double precision
);


--
-- Name: wdpapoly_june2014_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wdpapoly_june2014_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wdpapoly_june2014_ogc_fid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wdpapoly_june2014_ogc_fid_seq OWNED BY wdpapoly_june2014.ogc_fid;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY designations ALTER COLUMN id SET DEFAULT nextval('designations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY governances ALTER COLUMN id SET DEFAULT nextval('governances_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY iucn_categories ALTER COLUMN id SET DEFAULT nextval('iucn_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY jurisdictions ALTER COLUMN id SET DEFAULT nextval('jurisdictions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY legal_statuses ALTER COLUMN id SET DEFAULT nextval('legal_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY management_authorities ALTER COLUMN id SET DEFAULT nextval('management_authorities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY no_take_statuses ALTER COLUMN id SET DEFAULT nextval('no_take_statuses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY protected_areas ALTER COLUMN id SET DEFAULT nextval('protected_areas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sub_locations ALTER COLUMN id SET DEFAULT nextval('sub_locations_id_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wdpa_source_june2014 ALTER COLUMN ogc_fid SET DEFAULT nextval('wdpa_source_june2014_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wdpapoint_june2014 ALTER COLUMN ogc_fid SET DEFAULT nextval('wdpapoint_june2014_ogc_fid_seq'::regclass);


--
-- Name: ogc_fid; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wdpapoly_june2014 ALTER COLUMN ogc_fid SET DEFAULT nextval('wdpapoly_june2014_ogc_fid_seq'::regclass);


--
-- Name: countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: designations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: governances_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY governances
    ADD CONSTRAINT governances_pkey PRIMARY KEY (id);


--
-- Name: iucn_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY iucn_categories
    ADD CONSTRAINT iucn_categories_pkey PRIMARY KEY (id);


--
-- Name: jurisdictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY jurisdictions
    ADD CONSTRAINT jurisdictions_pkey PRIMARY KEY (id);


--
-- Name: legal_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY legal_statuses
    ADD CONSTRAINT legal_statuses_pkey PRIMARY KEY (id);


--
-- Name: management_authorities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY management_authorities
    ADD CONSTRAINT management_authorities_pkey PRIMARY KEY (id);


--
-- Name: no_take_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY no_take_statuses
    ADD CONSTRAINT no_take_statuses_pkey PRIMARY KEY (id);


--
-- Name: protected_areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY protected_areas
    ADD CONSTRAINT protected_areas_pkey PRIMARY KEY (id);


--
-- Name: sub_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sub_locations
    ADD CONSTRAINT sub_locations_pkey PRIMARY KEY (id);


--
-- Name: wdpa_source_june2014_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wdpa_source_june2014
    ADD CONSTRAINT wdpa_source_june2014_pkey PRIMARY KEY (ogc_fid);


--
-- Name: wdpapoint_june2014_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wdpapoint_june2014
    ADD CONSTRAINT wdpapoint_june2014_pkey PRIMARY KEY (ogc_fid);


--
-- Name: wdpapoly_june2014_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wdpapoly_june2014
    ADD CONSTRAINT wdpapoly_june2014_pkey PRIMARY KEY (ogc_fid);


--
-- Name: idx_fts_search; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX idx_fts_search ON search_index USING gin (document);


--
-- Name: index_countries_protected_areas_composite; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_protected_areas_composite ON countries_protected_areas USING btree (protected_area_id, country_id);


--
-- Name: index_countries_protected_areas_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_countries_protected_areas_on_country_id ON countries_protected_areas USING btree (country_id);


--
-- Name: index_designations_on_jurisdiction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_designations_on_jurisdiction_id ON designations USING btree (jurisdiction_id);


--
-- Name: index_protected_areas_on_designation_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_designation_id ON protected_areas USING btree (designation_id);


--
-- Name: index_protected_areas_on_governance_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_governance_id ON protected_areas USING btree (governance_id);


--
-- Name: index_protected_areas_on_iucn_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_iucn_category_id ON protected_areas USING btree (iucn_category_id);


--
-- Name: index_protected_areas_on_legal_status_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_legal_status_id ON protected_areas USING btree (legal_status_id);


--
-- Name: index_protected_areas_on_management_authority_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_management_authority_id ON protected_areas USING btree (management_authority_id);


--
-- Name: index_protected_areas_on_no_take_status_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_no_take_status_id ON protected_areas USING btree (no_take_status_id);


--
-- Name: index_protected_areas_on_wdpa_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_protected_areas_on_wdpa_id ON protected_areas USING btree (wdpa_id);


--
-- Name: index_protected_areas_on_wdpa_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_on_wdpa_parent_id ON protected_areas USING btree (wdpa_parent_id);


--
-- Name: index_protected_areas_sub_locations_composite; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_sub_locations_composite ON protected_areas_sub_locations USING btree (protected_area_id, sub_location_id);


--
-- Name: index_protected_areas_sub_locations_on_sub_location_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_protected_areas_sub_locations_on_sub_location_id ON protected_areas_sub_locations USING btree (sub_location_id);


--
-- Name: index_sub_locations_on_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sub_locations_on_country_id ON sub_locations USING btree (country_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: wdpapoint_june2014_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX wdpapoint_june2014_wkb_geometry_geom_idx ON wdpapoint_june2014 USING gist (wkb_geometry);


--
-- Name: wdpapoly_june2014_wkb_geometry_geom_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX wdpapoly_june2014_wkb_geometry_geom_idx ON wdpapoly_june2014 USING gist (wkb_geometry);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140429140622');

INSERT INTO schema_migrations (version) VALUES ('20140527095736');

INSERT INTO schema_migrations (version) VALUES ('20140527125150');

INSERT INTO schema_migrations (version) VALUES ('20140527135808');

INSERT INTO schema_migrations (version) VALUES ('20140527150153');

INSERT INTO schema_migrations (version) VALUES ('20140527151457');

INSERT INTO schema_migrations (version) VALUES ('20140527152932');

INSERT INTO schema_migrations (version) VALUES ('20140528072204');

INSERT INTO schema_migrations (version) VALUES ('20140528072657');

INSERT INTO schema_migrations (version) VALUES ('20140528073943');

INSERT INTO schema_migrations (version) VALUES ('20140529072242');

INSERT INTO schema_migrations (version) VALUES ('20140601191435');

INSERT INTO schema_migrations (version) VALUES ('20140601193709');

INSERT INTO schema_migrations (version) VALUES ('20140601193923');

INSERT INTO schema_migrations (version) VALUES ('20140601195215');

INSERT INTO schema_migrations (version) VALUES ('20140601195405');

INSERT INTO schema_migrations (version) VALUES ('20140601195445');

INSERT INTO schema_migrations (version) VALUES ('20140601195642');

INSERT INTO schema_migrations (version) VALUES ('20140601195715');

INSERT INTO schema_migrations (version) VALUES ('20140601195757');

INSERT INTO schema_migrations (version) VALUES ('20140601195843');

INSERT INTO schema_migrations (version) VALUES ('20140601200419');

INSERT INTO schema_migrations (version) VALUES ('20140601203016');

INSERT INTO schema_migrations (version) VALUES ('20140601203550');

INSERT INTO schema_migrations (version) VALUES ('20140601204147');

INSERT INTO schema_migrations (version) VALUES ('20140601205045');

INSERT INTO schema_migrations (version) VALUES ('20140601205500');

INSERT INTO schema_migrations (version) VALUES ('20140601210111');

INSERT INTO schema_migrations (version) VALUES ('20140601210622');

INSERT INTO schema_migrations (version) VALUES ('20140601210739');

INSERT INTO schema_migrations (version) VALUES ('20140601210855');

INSERT INTO schema_migrations (version) VALUES ('20140601211052');

INSERT INTO schema_migrations (version) VALUES ('20140601211314');

INSERT INTO schema_migrations (version) VALUES ('20140602092716');

INSERT INTO schema_migrations (version) VALUES ('20140602103846');

INSERT INTO schema_migrations (version) VALUES ('20140602104104');

INSERT INTO schema_migrations (version) VALUES ('20140602104158');

INSERT INTO schema_migrations (version) VALUES ('20140602104243');

INSERT INTO schema_migrations (version) VALUES ('20140602104354');

INSERT INTO schema_migrations (version) VALUES ('20140602104439');

INSERT INTO schema_migrations (version) VALUES ('20140605105549');

