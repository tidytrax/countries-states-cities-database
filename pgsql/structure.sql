/*
 Target Server Type    : PostgreSQL
 Target Server Version : 130003
 File Encoding         : 65001

 Date: 25/05/2021 02:15:40
*/


-- ----------------------------
-- Sequence structure for cities_city_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "world"."cities_city_id_seq";
CREATE SEQUENCE "world"."cities_city_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for states_state_id_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "world"."states_state_id_seq";
CREATE SEQUENCE "world"."states_state_id_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 9223372036854775807
START 1
CACHE 1;

-- ----------------------------
-- Table structure for cities
-- ----------------------------
DROP TABLE IF EXISTS "world"."cities";
CREATE TABLE "world"."cities" (
  "id" int8 NOT NULL DEFAULT nextval('"world".cities_city_id_seq'::regclass),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "state_id" int8 NOT NULL,
  "state_code" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "country_id" int8 NOT NULL,
  "country_code" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "latitude" numeric(10,8) NOT NULL,
  "longitude" numeric(11,8) NOT NULL,
  "created_at" timestamp(6) NOT NULL DEFAULT '2014-01-01 01:01:01'::timestamp without time zone,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "flag" int2 NOT NULL DEFAULT 1
)
;

-- ----------------------------
-- Table structure for countries
-- ----------------------------
DROP TABLE IF EXISTS "world"."countries";
CREATE TABLE "world"."countries" (
  "id" int8 NOT NULL,
  "name" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "iso3" varchar(3) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "iso2" varchar(2) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "phonecode" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "capital" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "currency" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "currency_symbol" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "tld" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "native" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "region" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "subregion" varchar(255) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "timezones" text COLLATE "pg_catalog"."default",
  "translations" text COLLATE "pg_catalog"."default",
  "latitude" numeric(10,8) DEFAULT NULL::numeric,
  "longitude" numeric(11,8) DEFAULT NULL::numeric,
  "emoji" varchar(191) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "emojiu" varchar(191) COLLATE "pg_catalog"."default" DEFAULT NULL::character varying,
  "created_at" timestamp(6) DEFAULT CURRENT_TIMESTAMP,
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "flag" int2 NOT NULL DEFAULT 1
)
;

-- ----------------------------
-- Table structure for states
-- ----------------------------
DROP TABLE IF EXISTS "world"."states";
CREATE TABLE "world"."states" (
  "id" int8 NOT NULL DEFAULT nextval('"world".states_state_id_seq'::regclass),
  "name" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "country_id" int8 NOT NULL,
  "country_code" varchar(2) COLLATE "pg_catalog"."default" NOT NULL,
  "latitude" numeric(10,8) DEFAULT NULL::numeric,
  "longitude" numeric(11,8) DEFAULT NULL::numeric,
  "created_at" timestamp(6),
  "updated_at" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "flag" int2 NOT NULL DEFAULT 1
)
;

-- ----------------------------
-- View structure for world_search
-- ----------------------------
DROP VIEW IF EXISTS "world"."world_search";
CREATE VIEW "world"."world_search" AS  SELECT countries.id AS country_id,
    countries.name AS country_name,
    countries.native AS country_native_name,
    countries.iso2 AS country_code,
    countries.iso3 AS country_code_alt,
    countries.capital AS country_capital,
    countries.tld AS country_tld,
    countries.currency AS country_currency,
    countries.currency_symbol AS country_currency_symbol,
    countries.region AS country_region,
    countries.subregion AS country_subregion,
    countries.phonecode AS country_phonecode,
    countries.latitude AS country_latitude,
    countries.longitude AS country_longitude,
    states.id AS state_id,
    states.name AS state_name,
    states.latitude AS state_latitude,
    states.longitude AS state_longitude,
    cities.id AS city_id,
    cities.name AS city_name,
    cities.latitude AS city_latitude,
    cities.longitude AS city_longitude
   FROM world.cities
     JOIN world.states ON cities.state_id = states.id
     JOIN world.countries ON countries.id = cities.country_id
  ORDER BY countries.name, states.name, cities.name;

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "world"."cities_city_id_seq"
OWNED BY "world"."cities"."id";
SELECT setval('"world"."cities_city_id_seq"', 2, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "world"."states_state_id_seq"
OWNED BY "world"."states"."id";
SELECT setval('"world"."states_state_id_seq"', 2, false);

-- ----------------------------
-- Indexes structure for table cities
-- ----------------------------
CREATE INDEX "cities_country_id_idx" ON "world"."cities" USING btree (
  "country_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);
CREATE INDEX "cities_state_id_idx" ON "world"."cities" USING btree (
  "state_id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table cities
-- ----------------------------
ALTER TABLE "world"."cities" ADD CONSTRAINT "cities_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table countries
-- ----------------------------
ALTER TABLE "world"."countries" ADD CONSTRAINT "countries_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Indexes structure for table states
-- ----------------------------
CREATE UNIQUE INDEX "states_state_id_idx" ON "world"."states" USING btree (
  "id" "pg_catalog"."int8_ops" ASC NULLS LAST
);

-- ----------------------------
-- Primary Key structure for table states
-- ----------------------------
ALTER TABLE "world"."states" ADD CONSTRAINT "states_pkey" PRIMARY KEY ("id");

-- ----------------------------
-- Foreign Keys structure for table cities
-- ----------------------------
ALTER TABLE "world"."cities" ADD CONSTRAINT "cities_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "world"."countries" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
ALTER TABLE "world"."cities" ADD CONSTRAINT "cities_state_id_fkey" FOREIGN KEY ("state_id") REFERENCES "world"."states" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;

-- ----------------------------
-- Foreign Keys structure for table states
-- ----------------------------
ALTER TABLE "world"."states" ADD CONSTRAINT "states_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "world"."countries" ("id") ON DELETE RESTRICT ON UPDATE RESTRICT;
