-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.2
-- PostgreSQL version: 12.0
-- Project Site: pgmodeler.io
-- Model Author: ---


-- Database creation must be done outside a multicommand file.
-- These commands were put in this file only as a convenience.
-- -- object: codidact_dev | type: DATABASE --
-- -- DROP DATABASE IF EXISTS codidact_dev;
-- CREATE DATABASE codidact_dev
-- 	ENCODING = 'EUC_CN';
-- -- ddl-end --
-- 

-- object: audit | type: SCHEMA --
-- DROP SCHEMA IF EXISTS audit CASCADE;
CREATE SCHEMA audit;
-- ddl-end --
-- ALTER SCHEMA audit OWNER TO postgres;
-- ddl-end --

SET search_path TO pg_catalog,public,audit;
-- ddl-end --

-- object: audit.history_activity_type | type: TYPE --
-- DROP TYPE IF EXISTS audit.history_activity_type CASCADE;
CREATE TYPE audit.history_activity_type AS
 ENUM ('CREATE','UPDATE_BEFORE','UPDATE_AFTER','DELETE');
-- ddl-end --
-- ALTER TYPE audit.history_activity_type OWNER TO postgres;
-- ddl-end --

-- object: audit.comment_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.comment_history CASCADE;
CREATE TABLE audit.comment_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL,
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	parent_comment_id bigint,
	body text NOT NULL,
	upvotes bigint NOT NULL DEFAULT 0,
	downvotes bigint NOT NULL DEFAULT 0,
	net_votes bigint GENERATED ALWAYS AS (upvotes - downvotes) STORED,
	score decimal NOT NULL DEFAULT 0,
	CONSTRAINT comment_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.comment_history IS E'Table for the comments on posts, both questions and answers.';
-- ddl-end --
-- ALTER TABLE audit.comment_history OWNER TO postgres;
-- ddl-end --

-- object: audit.vote_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.vote_type_history CASCADE;
CREATE TABLE audit.vote_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text NOT NULL,
	display_name text NOT NULL,
	CONSTRAINT vote_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.vote_type_history IS E'Table for the vote types, upvote/downvote.';
-- ddl-end --
-- ALTER TABLE audit.vote_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_history CASCADE;
CREATE TABLE audit.post_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL,
	last_modified_at timestamp NOT NULL,
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	author_member_id bigint NOT NULL,
	title text NOT NULL,
	body text NOT NULL,
	upvotes smallint NOT NULL,
	downvotes smallint NOT NULL,
	net_votes bigint GENERATED ALWAYS AS (upvotes - downvotes) STORED,
	score decimal NOT NULL,
	views bigint NOT NULL,
	post_type_id bigint NOT NULL,
	is_accepted bool NOT NULL,
	is_closed bool NOT NULL,
	is_protected bool NOT NULL,
	parent_post_id bigint,
	category_id bigint NOT NULL,
	notice_id bigint,
	is_locked bool,
	locked_at timestamp,
	CONSTRAINT post_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.post_history IS E'I thought about splitting into a Answers table and and QuestionsTable but doing it in the same table lets comments have a PostsId instead of a QuestionsId and a AnswersId. Meta posts are denoted by the IsMeta column. Type of post is determined by the PostTypeId';
-- ddl-end --
-- ALTER TABLE audit.post_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_tag_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_tag_history CASCADE;
CREATE TABLE audit.post_tag_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	tag_id bigint NOT NULL,
	CONSTRAINT post_tag_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.post_tag_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_vote_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_vote_history CASCADE;
CREATE TABLE audit.post_vote_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	vote_type_id bigint NOT NULL,
	member_id bigint NOT NULL,
	duplicate_post_id bigint,
	close_reason_id bigint,
	CONSTRAINT post_vote_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.post_vote_history IS E'The reason for this table is so that votes by spammers/serial voters can be undone.';
-- ddl-end --
-- ALTER TABLE audit.post_vote_history OWNER TO postgres;
-- ddl-end --

-- object: audit.privilege_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.privilege_history CASCADE;
CREATE TABLE audit.privilege_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modifiedat timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text,
	display_name text NOT NULL,
	description text,
	CONSTRAINT privilege_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.privilege_history IS E'Table for privileges';
-- ddl-end --
-- ALTER TABLE audit.privilege_history OWNER TO postgres;
-- ddl-end --

-- object: audit.member_privilege_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.member_privilege_history CASCADE;
CREATE TABLE audit.member_privilege_history (
	"history _id" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	histroy_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	member_id bigint NOT NULL,
	privilege_id bigint NOT NULL,
	is_suspended bool NOT NULL DEFAULT FALSE,
	privilege_suspension_start_at timestamp,
	privilege_suspension_end_at timestamp,
	CONSTRAINT member_privilege_history_pk PRIMARY KEY ("history _id")

);
-- ddl-end --
COMMENT ON TABLE audit.member_privilege_history IS E'For recording which members have which privilege in a community. If a member has a privilege suspended, then that is also recorded here, and a nightly task will auto undo the suspension once the privelege_suspension_end_date has passed.';
-- ddl-end --
-- ALTER TABLE audit.member_privilege_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_type_history CASCADE;
CREATE TABLE audit.post_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	universal_code text,
	CONSTRAINT post_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.post_type_history IS E'Records the type of post, question/answer/blog etc';
-- ddl-end --
-- ALTER TABLE audit.post_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.comment_vote_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.comment_vote_history CASCADE;
CREATE TABLE audit.comment_vote_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	comment_id bigint NOT NULL,
	member_id bigint NOT NULL,
	vote_type_id bigint NOT NULL,
	CONSTRAINT comment_vote_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.comment_vote_history OWNER TO postgres;
-- ddl-end --

-- -- object: audit.audit_table_list | type: TABLE --
-- -- DROP TABLE IF EXISTS audit.audit_table_list CASCADE;
-- CREATE TABLE audit.audit_table_list (
-- 	"TABLE_LIST" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
-- 	member_history smallint,
-- 	trust_level_history smallint,
-- 	privilege_history smallint,
-- 	member_privilege_history smallint,
-- 	post_type_history smallint,
-- 	post_history smallint,
-- 	comment_history smallint,
-- 	comment_vote_history smallint,
-- 	tag_history smallint,
-- 	post_tag_history smallint,
-- 	vote_type_history smallint,
-- 	post_vote_history smallint,
-- 	external_association_history smallint,
-- 	member_external_association_history smallint,
-- 	post_status_type_history smallint,
-- 	post_status_history smallint,
-- 	setting_history smallint,
-- 	category_history smallint,
-- 	category_post_type_history smallint,
-- 	post_duplicate_post_history smallint,
-- 	category_tag_set_history smallint,
-- 	member_annotation_history smallint,
-- 	annotation_history_type smallint,
-- 	CONSTRAINT "TABLE_LIST_PK" PRIMARY KEY ("TABLE_LIST")
-- 
-- );
-- -- ddl-end --
-- COMMENT ON COLUMN audit.audit_table_list."TABLE_LIST" IS E'Schema: audit';
-- -- ddl-end --
-- -- ALTER TABLE audit.audit_table_list OWNER TO postgres;
-- -- ddl-end --
-- 
-- object: audit.external_association_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.external_association_type_history CASCADE;
CREATE TABLE audit.external_association_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_actvity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	account_url text NOT NULL,
	CONSTRAINT social_media_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.external_association_type_history IS E'The types of external association that the member can display in their profile';
-- ddl-end --
-- ALTER TABLE audit.external_association_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.member_external_association_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.member_external_association_type_history CASCADE;
CREATE TABLE audit.member_external_association_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	external_association_id bigint NOT NULL,
	member_id bigint NOT NULL,
	content text,
	CONSTRAINT member_external_association_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.member_external_association_type_history IS E'The external associations that the member would like to display in their community specific profile';
-- ddl-end --
-- ALTER TABLE audit.member_external_association_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_status_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_status_type_history CASCADE;
CREATE TABLE audit.post_status_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description smallint,
	CONSTRAINT post_status_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.post_status_type_history IS E'For setting the status of a post locked/featured etc';
-- ddl-end --
-- ALTER TABLE audit.post_status_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_status_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_status_history CASCADE;
CREATE TABLE audit.post_status_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	post_status_type_id bigint NOT NULL,
	CONSTRAINT post_status_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.post_status_history OWNER TO postgres;
-- ddl-end --

-- object: audit.setting_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.setting_history CASCADE;
CREATE TABLE audit.setting_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text,
	display_name text,
	current_value text,
	is_mod_changeable bool NOT NULL DEFAULT FALSE,
	CONSTRAINT setting_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.setting_history OWNER TO postgres;
-- ddl-end --

-- object: audit.category_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.category_history CASCADE;
CREATE TABLE audit.category_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	url_part varchar(20) NOT NULL,
	is_primary bool NOT NULL DEFAULT FALSE,
	short_explanation text,
	long_explanation text,
	contributes_to_trust_level bool NOT NULL DEFAULT TRUE,
	calculations bigint DEFAULT 0,
	participation_minimum_trust_level_id bigint NOT NULL,
	category_tag_set_id bigint NOT NULL,
	CONSTRAINT category_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.category_history OWNER TO postgres;
-- ddl-end --

-- object: audit.category_post_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.category_post_type_history CASCADE;
CREATE TABLE audit.category_post_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	category_id bigint NOT NULL,
	post_type_id bigint NOT NULL,
	is_active bool NOT NULL DEFAULT TRUE,
	CONSTRAINT category_post_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.category_post_type_history IS E'CategoryPostType';
-- ddl-end --
-- ALTER TABLE audit.category_post_type_history OWNER TO postgres;
-- ddl-end --

-- object: audit.post_duplicate_post_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.post_duplicate_post_history CASCADE;
CREATE TABLE audit.post_duplicate_post_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	original_post_id bigint NOT NULL,
	duplicate_post_id bigint NOT NULL,
	CONSTRAINT post_duplicate_post_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.post_duplicate_post_history OWNER TO postgres;
-- ddl-end --

-- object: audit.member_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.member_history CASCADE;
CREATE TABLE audit.member_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	bio text,
	profile_picture_link text,
	is_temporarily_suspended bool NOT NULL DEFAULT FALSE,
	temporary_suspension_end_at timestamp,
	temporary_suspension_reason text,
	trust_level_id bigint NOT NULL,
	network_account_id bigint DEFAULT NULL,
	is_moderator bool NOT NULL DEFAULT FALSE,
	is_administrator bool NOT NULL DEFAULT FALSE,
	is_synced_with_network_account bool NOT NULL DEFAULT TRUE,
	CONSTRAINT member_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.member_history IS E'This table will hold the global member records for a Codidact Instance. A member should only have one email to login with, that would be stored here. Does not include details such as password storage and hashing.';
-- ddl-end --
COMMENT ON COLUMN audit.member_history.network_account_id IS E'link to ''network_account'' table?';
-- ddl-end --
-- ALTER TABLE audit.member_history OWNER TO postgres;
-- ddl-end --

-- object: public.member | type: TABLE --
-- DROP TABLE IF EXISTS public.member CASCADE;
CREATE TABLE public.member (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	bio text,
	profile_picture_link text,
	is_temporarily_suspended bool NOT NULL DEFAULT FALSE,
	temporary_suspension_end_at timestamp,
	temporary_suspension_reason text,
	trust_level_id bigint NOT NULL,
	network_account_id bigint DEFAULT NULL,
	is_moderator bool NOT NULL DEFAULT FALSE,
	is_administrator bool NOT NULL DEFAULT FALSE,
	is_synced_with_network_account bool NOT NULL DEFAULT TRUE,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT member_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.member IS E'This table will hold the global member records for a Codidact Instance. A member should only have one email to login with, that would be stored here. Does not include details such as password storage and hashing.';
-- ddl-end --
COMMENT ON COLUMN public.member.network_account_id IS E'link to ''network_account'' table?';
-- ddl-end --
-- ALTER TABLE public.member OWNER TO postgres;
-- ddl-end --

-- -- object: public."Template" | type: TABLE --
-- -- DROP TABLE IF EXISTS public."Template" CASCADE;
-- CREATE TABLE public."Template" (
-- 	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
-- 	created_at timestamp NOT NULL DEFAULT NOW(),
-- 	last_modified_at timestamp NOT NULL DEFAULT NOW(),
-- 	created_by_member_id bigint NOT NULL,
-- 	last_modified_by_member_id bigint NOT NULL,
-- 	is_deleted bool NOT NULL DEFAULT FALSE,
-- 	deleted_at timestamp,
-- 	deleted_by_member_id bigint,
-- 	CONSTRAINT "<table>_pk" PRIMARY KEY (id)
-- 
-- );
-- -- ddl-end --
-- -- ALTER TABLE public."Template" OWNER TO postgres;
-- -- ddl-end --
-- 
-- object: public.trust_level | type: TABLE --
-- DROP TABLE IF EXISTS public.trust_level CASCADE;
CREATE TABLE public.trust_level (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modifed_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	explanation text NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT trust_level_pk PRIMARY KEY (id),
	CONSTRAINT trust_level_display_name_uq UNIQUE (display_name),
	CONSTRAINT trust_level_explanation_uq UNIQUE (explanation)

);
-- ddl-end --
COMMENT ON TABLE public.trust_level IS E'Name for each trust level and an explanation of each that a user should get when they get to that level.';
-- ddl-end --
-- ALTER TABLE public.trust_level OWNER TO postgres;
-- ddl-end --

-- object: public.post | type: TABLE --
-- DROP TABLE IF EXISTS public.post CASCADE;
CREATE TABLE public.post (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	author_member_id bigint NOT NULL,
	title text NOT NULL,
	body text NOT NULL,
	upvotes smallint NOT NULL DEFAULT 0,
	downvotes smallint NOT NULL DEFAULT 0,
	net_votes bigint GENERATED ALWAYS AS (upvotes - downvotes) STORED,
	score decimal NOT NULL,
	views bigint NOT NULL DEFAULT 0,
	post_type_id bigint NOT NULL,
	is_accepted bool NOT NULL DEFAULT FALSE,
	is_closed bool NOT NULL DEFAULT FALSE,
	is_protected bool NOT NULL DEFAULT FALSE,
	parent_post_id bigint,
	category_id bigint NOT NULL,
	notice_id bigint,
	is_locked bool NOT NULL DEFAULT FALSE,
	locked_at timestamp,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.post IS E'I thought about splitting into a Answers table and and QuestionsTable but doing it in the same table lets comments have a PostsId instead of a QuestionsId and a AnswersId. Type of post is determined by the PostTypeId';
-- ddl-end --
-- ALTER TABLE public.post OWNER TO postgres;
-- ddl-end --

-- object: public.comment | type: TABLE --
-- DROP TABLE IF EXISTS public.comment CASCADE;
CREATE TABLE public.comment (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	parent_comment_id bigint,
	body text NOT NULL,
	upvotes bigint NOT NULL DEFAULT 0,
	downvotes bigint NOT NULL DEFAULT 0,
	net_votes bigint GENERATED ALWAYS AS (upvotes - downvotes) STORED,
	score decimal NOT NULL DEFAULT 0,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT comment_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE public.comment IS E'Table for the comments on posts, both questions and answers.';
-- ddl-end --
-- ALTER TABLE public.comment OWNER TO postgres;
-- ddl-end --

-- object: public.vote_type | type: TABLE --
-- DROP TABLE IF EXISTS public.vote_type CASCADE;
CREATE TABLE public.vote_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text NOT NULL,
	display_name text NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT vote_type_pk PRIMARY KEY (id),
	CONSTRAINT vote_type_universal_code_uc UNIQUE (universal_code),
	CONSTRAINT vote_type_display_name_uc UNIQUE (display_name)

);
-- ddl-end --
COMMENT ON TABLE public.vote_type IS E'Table for the vote types, upvote/downvote.';
-- ddl-end --
-- ALTER TABLE public.vote_type OWNER TO postgres;
-- ddl-end --

-- object: public.tag | type: TABLE --
-- DROP TABLE IF EXISTS public.tag CASCADE;
CREATE TABLE public.tag (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	body text NOT NULL DEFAULT NULL,
	description text,
	tag_wiki text NOT NULL,
	is_active bool NOT NULL DEFAULT TRUE,
	synonym_tag_id bigint DEFAULT NULL,
	parent_tag_id bigint DEFAULT NULL,
	usages bigint NOT NULL DEFAULT 0,
	tag_set_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT tag_pk PRIMARY KEY (id),
	CONSTRAINT tag_body_uc UNIQUE (body)

);
-- ddl-end --
COMMENT ON TABLE public.tag IS E'Table for all of the tags';
-- ddl-end --
-- ALTER TABLE public.tag OWNER TO postgres;
-- ddl-end --

-- object: public.post_tag | type: TABLE --
-- DROP TABLE IF EXISTS public.post_tag CASCADE;
CREATE TABLE public.post_tag (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	tag_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_tag_pk PRIMARY KEY (id),
	CONSTRAINT post_tag_post_tag_uc UNIQUE (post_id,tag_id)

);
-- ddl-end --
-- ALTER TABLE public.post_tag OWNER TO postgres;
-- ddl-end --

-- object: public.post_vote | type: TABLE --
-- DROP TABLE IF EXISTS public.post_vote CASCADE;
CREATE TABLE public.post_vote (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	vote_type_id bigint NOT NULL,
	member_id bigint NOT NULL,
	duplicate_post_id bigint,
	close_reason_id bigint,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_vote_pk PRIMARY KEY (id),
	CONSTRAINT post_vote_post_member_uc UNIQUE (post_id,member_id)

);
-- ddl-end --
COMMENT ON TABLE public.post_vote IS E'The reason for this table is so that votes by spammers/serial voters can be undone.';
-- ddl-end --
-- ALTER TABLE public.post_vote OWNER TO postgres;
-- ddl-end --

-- object: public.privilege | type: TABLE --
-- DROP TABLE IF EXISTS public.privilege CASCADE;
CREATE TABLE public.privilege (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modifiedat timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text NOT NULL,
	display_name text NOT NULL,
	description text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT privilege_pk PRIMARY KEY (id),
	CONSTRAINT privilege_display_name_uc UNIQUE (display_name),
	CONSTRAINT privilege_universal_code_uc UNIQUE (universal_code)

);
-- ddl-end --
COMMENT ON TABLE public.privilege IS E'Table for privileges';
-- ddl-end --
-- ALTER TABLE public.privilege OWNER TO postgres;
-- ddl-end --

-- object: public.member_privilege | type: TABLE --
-- DROP TABLE IF EXISTS public.member_privilege CASCADE;
CREATE TABLE public.member_privilege (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	member_id bigint NOT NULL,
	privilege_id bigint NOT NULL,
	is_suspended bool NOT NULL DEFAULT FALSE,
	privilege_suspension_start_at timestamp,
	privilege_suspension_end_at timestamp,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT member_privilege_pk PRIMARY KEY (id),
	CONSTRAINT member_privilege_member_privilege_uc UNIQUE (member_id,privilege_id)

);
-- ddl-end --
COMMENT ON TABLE public.member_privilege IS E'For recording which members have which privilege in a community. If a member has a privilege suspended, then that is also recorded here, and a nightly task will auto undo the suspension once the privelege_suspension_end_date has passed.';
-- ddl-end --
-- ALTER TABLE public.member_privilege OWNER TO postgres;
-- ddl-end --

-- object: public.post_type | type: TABLE --
-- DROP TABLE IF EXISTS public.post_type CASCADE;
CREATE TABLE public.post_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text NOT NULL,
	display_name text NOT NULL,
	description text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_type_pk PRIMARY KEY (id),
	CONSTRAINT post_type_universal_code_uc UNIQUE (universal_code),
	CONSTRAINT post_type_name_uc UNIQUE (display_name)

);
-- ddl-end --
COMMENT ON TABLE public.post_type IS E'Records the type of post, question/answer/blog etc';
-- ddl-end --
-- ALTER TABLE public.post_type OWNER TO postgres;
-- ddl-end --

-- object: public.comment_vote | type: TABLE --
-- DROP TABLE IF EXISTS public.comment_vote CASCADE;
CREATE TABLE public.comment_vote (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	comment_id bigint NOT NULL,
	member_id bigint NOT NULL,
	vote_type_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT comment_vote_pk PRIMARY KEY (id),
	CONSTRAINT comment_vote_comment_member_uc UNIQUE (comment_id,member_id)

);
-- ddl-end --
-- ALTER TABLE public.comment_vote OWNER TO postgres;
-- ddl-end --

-- -- object: public.table_list | type: TABLE --
-- -- DROP TABLE IF EXISTS public.table_list CASCADE;
-- CREATE TABLE public.table_list (
-- 	"TABLE_LIST" bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
-- 	member smallint,
-- 	trust_level smallint,
-- 	privilege smallint,
-- 	member_privilege smallint,
-- 	post_type smallint,
-- 	post smallint,
-- 	comment smallint,
-- 	comment_vote smallint,
-- 	tag smallint,
-- 	post_tag smallint,
-- 	vote_type smallint,
-- 	post_vote smallint,
-- 	external_association_type smallint,
-- 	member_external_association smallint,
-- 	post_status_type smallint,
-- 	post_status smallint,
-- 	setting smallint,
-- 	category smallint,
-- 	category_post_type smallint,
-- 	post_duplicate_post smallint,
-- 	category_tag_set smallint,
-- 	member_annotation smallint,
-- 	annotation_type smallint,
-- 	CONSTRAINT "TABLE_LIST_PK" PRIMARY KEY ("TABLE_LIST")
-- 
-- );
-- -- ddl-end --
-- -- ALTER TABLE public.table_list OWNER TO postgres;
-- -- ddl-end --
-- 
-- object: public.external_association_type | type: TABLE --
-- DROP TABLE IF EXISTS public.external_association_type CASCADE;
CREATE TABLE public.external_association_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	account_url text NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT external_association_type_pk PRIMARY KEY (id),
	CONSTRAINT external_association_type_display_name_uc UNIQUE (display_name),
	CONSTRAINT external_association_type_account_url_uc UNIQUE (account_url)

);
-- ddl-end --
COMMENT ON TABLE public.external_association_type IS E'The types of external associations (social media, blogs, personal websites etc) that the member can display in their profile';
-- ddl-end --
-- ALTER TABLE public.external_association_type OWNER TO postgres;
-- ddl-end --

-- object: public.member_external_association_type | type: TABLE --
-- DROP TABLE IF EXISTS public.member_external_association_type CASCADE;
CREATE TABLE public.member_external_association_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	external_association_id bigint NOT NULL,
	member_id bigint NOT NULL,
	content text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT member_external_association_pk PRIMARY KEY (id),
	CONSTRAINT member_external_association_external_association_member_uc UNIQUE (member_id,external_association_id)

);
-- ddl-end --
COMMENT ON TABLE public.member_external_association_type IS E'The social media that the member would like to display in their community specific profile';
-- ddl-end --
-- ALTER TABLE public.member_external_association_type OWNER TO postgres;
-- ddl-end --

-- object: public.post_status_type | type: TABLE --
-- DROP TABLE IF EXISTS public.post_status_type CASCADE;
CREATE TABLE public.post_status_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description smallint,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_status_type_pk PRIMARY KEY (id),
	CONSTRAINT post_status_display_name_uc UNIQUE (display_name)

);
-- ddl-end --
COMMENT ON TABLE public.post_status_type IS E'For setting the status of a post locked/featured etc';
-- ddl-end --
-- ALTER TABLE public.post_status_type OWNER TO postgres;
-- ddl-end --

-- object: public.post_status | type: TABLE --
-- DROP TABLE IF EXISTS public.post_status CASCADE;
CREATE TABLE public.post_status (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	post_id bigint NOT NULL,
	post_status_type_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at bigint,
	deleted_by_member_id bigint,
	CONSTRAINT post_status_pk PRIMARY KEY (id),
	CONSTRAINT post_status_post_status_type_post_uc UNIQUE (post_id,post_status_type_id)

);
-- ddl-end --
-- ALTER TABLE public.post_status OWNER TO postgres;
-- ddl-end --

-- object: public.setting | type: TABLE --
-- DROP TABLE IF EXISTS public.setting CASCADE;
CREATE TABLE public.setting (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	universal_code text NOT NULL,
	display_name text NOT NULL,
	current_value text,
	is_mod_changeable bool NOT NULL DEFAULT FALSE,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT setting_pk PRIMARY KEY (id),
	CONSTRAINT setting_universal_code_uc UNIQUE (universal_code),
	CONSTRAINT setting_display_name_uc UNIQUE (display_name)

);
-- ddl-end --
-- ALTER TABLE public.setting OWNER TO postgres;
-- ddl-end --

-- object: public.category | type: TABLE --
-- DROP TABLE IF EXISTS public.category CASCADE;
CREATE TABLE public.category (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	url_part varchar(20) NOT NULL,
	is_primary bool NOT NULL DEFAULT FALSE,
	short_explanation text,
	long_explanation text,
	contributes_to_trust_level bool NOT NULL DEFAULT TRUE,
	calculations bigint DEFAULT 0,
	participation_minimum_trust_level_id bigint NOT NULL,
	category_tag_set_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT category_pk PRIMARY KEY (id),
	CONSTRAINT category_display_name_uc UNIQUE (display_name)

);
-- ddl-end --
-- ALTER TABLE public.category OWNER TO postgres;
-- ddl-end --

-- object: public.category_post_type | type: TABLE --
-- DROP TABLE IF EXISTS public.category_post_type CASCADE;
CREATE TABLE public.category_post_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	category_id bigint NOT NULL,
	post_type_id bigint NOT NULL,
	is_active bool NOT NULL DEFAULT TRUE,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT category_post_type_pk PRIMARY KEY (id),
	CONSTRAINT category_post_type_category_post_type_uc UNIQUE (category_id,post_type_id)

);
-- ddl-end --
COMMENT ON TABLE public.category_post_type IS E'CategoryPostType';
-- ddl-end --
-- ALTER TABLE public.category_post_type OWNER TO postgres;
-- ddl-end --

-- object: public.post_duplicate_post | type: TABLE --
-- DROP TABLE IF EXISTS public.post_duplicate_post CASCADE;
CREATE TABLE public.post_duplicate_post (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	original_post_id bigint NOT NULL,
	duplicate_post_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT post_duplicate_post_pk PRIMARY KEY (id),
	CONSTRAINT post_duplicate_post_original_post_duplicate_post_uc UNIQUE (original_post_id,duplicate_post_id)

);
-- ddl-end --
-- ALTER TABLE public.post_duplicate_post OWNER TO postgres;
-- ddl-end --

-- object: audit.tag_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.tag_history CASCADE;
CREATE TABLE audit.tag_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	body text NOT NULL DEFAULT NULL,
	description text,
	tag_wiki text NOT NULL,
	is_active bool NOT NULL DEFAULT TRUE,
	synonym_tag_id bigint DEFAULT NULL,
	parent_tag_id bigint DEFAULT NULL,
	usages bigint NOT NULL DEFAULT 0,
	tag_set_id bigint,
	CONSTRAINT tag_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.tag_history IS E'Table for all of the tags - history';
-- ddl-end --
-- ALTER TABLE audit.tag_history OWNER TO postgres;
-- ddl-end --

-- object: audit.trust_level_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.trust_level_history CASCADE;
CREATE TABLE audit.trust_level_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modifed_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	explanation text NOT NULL,
	CONSTRAINT trust_level_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
COMMENT ON TABLE audit.trust_level_history IS E'Name for each trust level and an explanation of each that a user should get when they get to that level.';
-- ddl-end --
-- ALTER TABLE audit.trust_level_history OWNER TO postgres;
-- ddl-end --

-- object: public.category_tag_set | type: TABLE --
-- DROP TABLE IF EXISTS public.category_tag_set CASCADE;
CREATE TABLE public.category_tag_set (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT category_tag_set_pk PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.category_tag_set OWNER TO postgres;
-- ddl-end --

-- object: audit.category_tag_set_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.category_tag_set_history CASCADE;
CREATE TABLE audit.category_tag_set_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	CONSTRAINT tag_set_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.category_tag_set_history OWNER TO postgres;
-- ddl-end --

-- object: public.close_reason | type: TABLE --
-- DROP TABLE IF EXISTS public.close_reason CASCADE;
CREATE TABLE public.close_reason (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	parent_close_reason_id bigint,
	is_active bool NOT NULL DEFAULT TRUE,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT close_reason_pk PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.close_reason OWNER TO postgres;
-- ddl-end --

-- object: audit.close_reason_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.close_reason_history CASCADE;
CREATE TABLE audit.close_reason_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	parent_close_reason_id bigint,
	is_active bool NOT NULL DEFAULT TRUE,
	CONSTRAINT close_reason_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.close_reason_history OWNER TO postgres;
-- ddl-end --

-- object: public.member_annotation | type: TABLE --
-- DROP TABLE IF EXISTS public.member_annotation CASCADE;
CREATE TABLE public.member_annotation (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	member_id bigint NOT NULL,
	annotation_type_id bigint NOT NULL,
	annotation_description text,
	CONSTRAINT member_annotation_pk PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.member_annotation OWNER TO postgres;
-- ddl-end --

-- object: public.annotation_type | type: TABLE --
-- DROP TABLE IF EXISTS public.annotation_type CASCADE;
CREATE TABLE public.annotation_type (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT annotation_type_pk PRIMARY KEY (id),
	CONSTRAINT display_name_uc UNIQUE (display_name)

);
-- ddl-end --
-- ALTER TABLE public.annotation_type OWNER TO postgres;
-- ddl-end --

-- object: audit.member_annotation_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.member_annotation_history CASCADE;
CREATE TABLE audit.member_annotation_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	member_id bigint NOT NULL,
	annotation_type_id bigint NOT NULL,
	annotation_description text,
	CONSTRAINT member_annotation_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.member_annotation_history OWNER TO postgres;
-- ddl-end --

-- object: audit.annotation_type_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.annotation_type_history CASCADE;
CREATE TABLE audit.annotation_type_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	description text,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT annotation_type_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.annotation_type_history OWNER TO postgres;
-- ddl-end --

-- object: public.close_reason_subreason | type: TABLE --
-- DROP TABLE IF EXISTS public.close_reason_subreason CASCADE;
CREATE TABLE public.close_reason_subreason (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	close_reason_id bigint NOT NULL,
	subreason_description text NOT NULL,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT close_reason_subreason_pk PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.close_reason_subreason OWNER TO postgres;
-- ddl-end --

-- object: audit.close_reason_subreason_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.close_reason_subreason_history CASCADE;
CREATE TABLE audit.close_reason_subreason_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL,
	history_activity_member_id bigint NOT NULL,
	id bigint,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	close_reason_id bigint NOT NULL,
	subreason_description text NOT NULL,
	CONSTRAINT close_reason_subreason_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.close_reason_subreason_history OWNER TO postgres;
-- ddl-end --

-- object: public.notice | type: TABLE --
-- DROP TABLE IF EXISTS public.notice CASCADE;
CREATE TABLE public.notice (
	id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text NOT NULL,
	body text,
	is_active bool NOT NULL DEFAULT TRUE,
	is_deleted bool NOT NULL DEFAULT FALSE,
	deleted_at timestamp,
	deleted_by_member_id bigint,
	CONSTRAINT notice_pk PRIMARY KEY (id)

);
-- ddl-end --
-- ALTER TABLE public.notice OWNER TO postgres;
-- ddl-end --

-- object: audit.notice_history | type: TABLE --
-- DROP TABLE IF EXISTS audit.notice_history CASCADE;
CREATE TABLE audit.notice_history (
	history_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ,
	history_activity audit.history_activity_type NOT NULL,
	history_activity_at timestamp NOT NULL DEFAULT NOW(),
	history_activity_member_id bigint NOT NULL,
	id bigint NOT NULL,
	created_at timestamp NOT NULL DEFAULT NOW(),
	last_modified_at timestamp NOT NULL DEFAULT NOW(),
	created_by_member_id bigint NOT NULL,
	last_modified_by_member_id bigint NOT NULL,
	display_name text,
	body text,
	is_active bool,
	CONSTRAINT notice_history_pk PRIMARY KEY (history_id)

);
-- ddl-end --
-- ALTER TABLE audit.notice_history OWNER TO postgres;
-- ddl-end --

-- object: comment_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.comment_history DROP CONSTRAINT IF EXISTS comment_history_member_fk CASCADE;
ALTER TABLE audit.comment_history ADD CONSTRAINT comment_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vote_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.vote_type_history DROP CONSTRAINT IF EXISTS vote_type_history_member_fk CASCADE;
ALTER TABLE audit.vote_type_history ADD CONSTRAINT vote_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_history DROP CONSTRAINT IF EXISTS post_history_member_fk CASCADE;
ALTER TABLE audit.post_history ADD CONSTRAINT post_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_tag_history DROP CONSTRAINT IF EXISTS post_tag_history_member_fk CASCADE;
ALTER TABLE audit.post_tag_history ADD CONSTRAINT post_tag_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_vote_history DROP CONSTRAINT IF EXISTS post_vote_history_member_fk CASCADE;
ALTER TABLE audit.post_vote_history ADD CONSTRAINT post_vote_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: privilege_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.privilege_history DROP CONSTRAINT IF EXISTS privilege_history_member_fk CASCADE;
ALTER TABLE audit.privilege_history ADD CONSTRAINT privilege_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_histry_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.member_privilege_history DROP CONSTRAINT IF EXISTS member_privilege_histry_member_fk CASCADE;
ALTER TABLE audit.member_privilege_history ADD CONSTRAINT member_privilege_histry_member_fk FOREIGN KEY (histroy_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_type_history DROP CONSTRAINT IF EXISTS post_type_history_member_fk CASCADE;
ALTER TABLE audit.post_type_history ADD CONSTRAINT post_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.comment_vote_history DROP CONSTRAINT IF EXISTS comment_vote_history_member_fk CASCADE;
ALTER TABLE audit.comment_vote_history ADD CONSTRAINT comment_vote_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: social_media_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.external_association_type_history DROP CONSTRAINT IF EXISTS social_media_type_history_member_fk CASCADE;
ALTER TABLE audit.external_association_type_history ADD CONSTRAINT social_media_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.member_external_association_type_history DROP CONSTRAINT IF EXISTS member_external_association_type_history_member_fk CASCADE;
ALTER TABLE audit.member_external_association_type_history ADD CONSTRAINT member_external_association_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_status_type_history DROP CONSTRAINT IF EXISTS post_status_type_history_member_fk CASCADE;
ALTER TABLE audit.post_status_type_history ADD CONSTRAINT post_status_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_status_history DROP CONSTRAINT IF EXISTS post_status_history_member_fk CASCADE;
ALTER TABLE audit.post_status_history ADD CONSTRAINT post_status_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: setting_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.setting_history DROP CONSTRAINT IF EXISTS setting_history_member_fk CASCADE;
ALTER TABLE audit.setting_history ADD CONSTRAINT setting_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.category_history DROP CONSTRAINT IF EXISTS category_history_member_fk CASCADE;
ALTER TABLE audit.category_history ADD CONSTRAINT category_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_post_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.category_post_type_history DROP CONSTRAINT IF EXISTS category_post_type_history_member_fk CASCADE;
ALTER TABLE audit.category_post_type_history ADD CONSTRAINT category_post_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.post_duplicate_post_history DROP CONSTRAINT IF EXISTS post_duplicate_post_history_member_fk CASCADE;
ALTER TABLE audit.post_duplicate_post_history ADD CONSTRAINT post_duplicate_post_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.member_history DROP CONSTRAINT IF EXISTS member_history_member_fk CASCADE;
ALTER TABLE audit.member_history ADD CONSTRAINT member_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member DROP CONSTRAINT IF EXISTS member_created_by_member_fk CASCADE;
ALTER TABLE public.member ADD CONSTRAINT member_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member DROP CONSTRAINT IF EXISTS member_last_modified_by_member_fk CASCADE;
ALTER TABLE public.member ADD CONSTRAINT member_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_trust_level_fk | type: CONSTRAINT --
-- ALTER TABLE public.member DROP CONSTRAINT IF EXISTS member_trust_level_fk CASCADE;
ALTER TABLE public.member ADD CONSTRAINT member_trust_level_fk FOREIGN KEY (trust_level_id)
REFERENCES public.trust_level (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member DROP CONSTRAINT IF EXISTS member_deleted_by_member_fk CASCADE;
ALTER TABLE public.member ADD CONSTRAINT member_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- -- object: "<table>_created_by_member_fk" | type: CONSTRAINT --
-- -- ALTER TABLE public."Template" DROP CONSTRAINT IF EXISTS "<table>_created_by_member_fk" CASCADE;
-- ALTER TABLE public."Template" ADD CONSTRAINT "<table>_created_by_member_fk" FOREIGN KEY (created_by_member_id)
-- REFERENCES public.member (id) MATCH FULL
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: "<table>_last_modified_by_member_fk" | type: CONSTRAINT --
-- -- ALTER TABLE public."Template" DROP CONSTRAINT IF EXISTS "<table>_last_modified_by_member_fk" CASCADE;
-- ALTER TABLE public."Template" ADD CONSTRAINT "<table>_last_modified_by_member_fk" FOREIGN KEY (last_modified_by_member_id)
-- REFERENCES public.member (id) MATCH FULL
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- -- object: "<table>_deleted_by_member_fk" | type: CONSTRAINT --
-- -- ALTER TABLE public."Template" DROP CONSTRAINT IF EXISTS "<table>_deleted_by_member_fk" CASCADE;
-- ALTER TABLE public."Template" ADD CONSTRAINT "<table>_deleted_by_member_fk" FOREIGN KEY (deleted_by_member_id)
-- REFERENCES public.member (id) MATCH FULL
-- ON DELETE NO ACTION ON UPDATE NO ACTION;
-- -- ddl-end --
-- 
-- object: trust_level_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.trust_level DROP CONSTRAINT IF EXISTS trust_level_created_by_member_fk CASCADE;
ALTER TABLE public.trust_level ADD CONSTRAINT trust_level_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: trust_level_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.trust_level DROP CONSTRAINT IF EXISTS trust_level_last_modified_by_member_fk CASCADE;
ALTER TABLE public.trust_level ADD CONSTRAINT trust_level_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: trust_level_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.trust_level DROP CONSTRAINT IF EXISTS trust_level_deleted_by_member_fk CASCADE;
ALTER TABLE public.trust_level ADD CONSTRAINT trust_level_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_created_by_member_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_parent_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_parent_post_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_parent_post_fk FOREIGN KEY (parent_post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_member_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_member_fk FOREIGN KEY (author_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_post_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_post_type_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_post_type_fk FOREIGN KEY (post_type_id)
REFERENCES public.post_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_category_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_category_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_category_fk FOREIGN KEY (category_id)
REFERENCES public.category (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_notice_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_notice_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_notice_fk FOREIGN KEY (notice_id)
REFERENCES public.notice (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post DROP CONSTRAINT IF EXISTS post_deleted_by_member_fk CASCADE;
ALTER TABLE public.post ADD CONSTRAINT post_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_created_by_member_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_last_modified_by_member_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_member_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_post_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_post_fk FOREIGN KEY (post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_parent_comment_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_parent_comment_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_parent_comment_fk FOREIGN KEY (parent_comment_id)
REFERENCES public.comment (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment DROP CONSTRAINT IF EXISTS comment_deleted_by_member_fk CASCADE;
ALTER TABLE public.comment ADD CONSTRAINT comment_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vote_type_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.vote_type DROP CONSTRAINT IF EXISTS vote_type_created_by_member_fk CASCADE;
ALTER TABLE public.vote_type ADD CONSTRAINT vote_type_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vote_type_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.vote_type DROP CONSTRAINT IF EXISTS vote_type_last_modified_by_member_fk CASCADE;
ALTER TABLE public.vote_type ADD CONSTRAINT vote_type_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: vote_type_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.vote_type DROP CONSTRAINT IF EXISTS vote_type_deleted_by_member_fk CASCADE;
ALTER TABLE public.vote_type ADD CONSTRAINT vote_type_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.tag DROP CONSTRAINT IF EXISTS tag_created_by_member_fk CASCADE;
ALTER TABLE public.tag ADD CONSTRAINT tag_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.tag DROP CONSTRAINT IF EXISTS tag_last_modified_by_member_fk CASCADE;
ALTER TABLE public.tag ADD CONSTRAINT tag_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_parent_tag_fk | type: CONSTRAINT --
-- ALTER TABLE public.tag DROP CONSTRAINT IF EXISTS tag_parent_tag_fk CASCADE;
ALTER TABLE public.tag ADD CONSTRAINT tag_parent_tag_fk FOREIGN KEY (parent_tag_id)
REFERENCES public.tag (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_tag_set_fk | type: CONSTRAINT --
-- ALTER TABLE public.tag DROP CONSTRAINT IF EXISTS tag_tag_set_fk CASCADE;
ALTER TABLE public.tag ADD CONSTRAINT tag_tag_set_fk FOREIGN KEY (tag_set_id)
REFERENCES public.category_tag_set (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.tag DROP CONSTRAINT IF EXISTS tag_deleted_by_member_fk CASCADE;
ALTER TABLE public.tag ADD CONSTRAINT tag_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_created_by_member_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_post_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_post_fk FOREIGN KEY (post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_tag_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_tag_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_tag_fk FOREIGN KEY (tag_id)
REFERENCES public.tag (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_tag_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_tag DROP CONSTRAINT IF EXISTS post_tag_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_tag ADD CONSTRAINT post_tag_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_created_by_member_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_post_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_post_fk FOREIGN KEY (post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_vote_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_vote_type_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_vote_type_fk FOREIGN KEY (vote_type_id)
REFERENCES public.vote_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_member_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_vote_duplicate_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS post_vote_duplicate_post_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT post_vote_duplicate_post_fk FOREIGN KEY (duplicate_post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: pot_vote_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_vote DROP CONSTRAINT IF EXISTS pot_vote_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_vote ADD CONSTRAINT pot_vote_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: privilege_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.privilege DROP CONSTRAINT IF EXISTS privilege_created_by_member_fk CASCADE;
ALTER TABLE public.privilege ADD CONSTRAINT privilege_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: privilege_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.privilege DROP CONSTRAINT IF EXISTS privilege_last_modified_by_member_fk CASCADE;
ALTER TABLE public.privilege ADD CONSTRAINT privilege_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: privilege_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.privilege DROP CONSTRAINT IF EXISTS privilege_deleted_by_member_fk CASCADE;
ALTER TABLE public.privilege ADD CONSTRAINT privilege_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_privilege DROP CONSTRAINT IF EXISTS member_privilege_created_by_member_fk CASCADE;
ALTER TABLE public.member_privilege ADD CONSTRAINT member_privilege_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_privilege DROP CONSTRAINT IF EXISTS member_privilege_last_modified_by_member_fk CASCADE;
ALTER TABLE public.member_privilege ADD CONSTRAINT member_privilege_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_privilege DROP CONSTRAINT IF EXISTS member_privilege_member_fk CASCADE;
ALTER TABLE public.member_privilege ADD CONSTRAINT member_privilege_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_privlege_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_privilege DROP CONSTRAINT IF EXISTS member_privilege_privlege_fk CASCADE;
ALTER TABLE public.member_privilege ADD CONSTRAINT member_privilege_privlege_fk FOREIGN KEY (privilege_id)
REFERENCES public.privilege (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_privilege_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_privilege DROP CONSTRAINT IF EXISTS member_privilege_deleted_by_member_fk CASCADE;
ALTER TABLE public.member_privilege ADD CONSTRAINT member_privilege_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_type_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_type DROP CONSTRAINT IF EXISTS post_type_created_by_member_fk CASCADE;
ALTER TABLE public.post_type ADD CONSTRAINT post_type_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_type_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_type DROP CONSTRAINT IF EXISTS post_type_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_type ADD CONSTRAINT post_type_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_type_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_type DROP CONSTRAINT IF EXISTS post_type_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_type ADD CONSTRAINT post_type_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS comment_vote_created_by_member_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT comment_vote_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS comment_vote_last_modified_by_member_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT comment_vote_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: commentvote_comment_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS commentvote_comment_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT commentvote_comment_fk FOREIGN KEY (comment_id)
REFERENCES public.comment (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS comment_vote_member_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT comment_vote_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_vote_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS comment_vote_vote_type_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT comment_vote_vote_type_fk FOREIGN KEY (vote_type_id)
REFERENCES public.vote_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: comment_vote_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.comment_vote DROP CONSTRAINT IF EXISTS comment_vote_deleted_by_member_fk CASCADE;
ALTER TABLE public.comment_vote ADD CONSTRAINT comment_vote_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: external_association_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.external_association_type DROP CONSTRAINT IF EXISTS external_association_created_by_member_fk CASCADE;
ALTER TABLE public.external_association_type ADD CONSTRAINT external_association_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: external_association_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.external_association_type DROP CONSTRAINT IF EXISTS external_association_last_modified_by_member_fk CASCADE;
ALTER TABLE public.external_association_type ADD CONSTRAINT external_association_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: external_association_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.external_association_type DROP CONSTRAINT IF EXISTS external_association_deleted_by_member_fk CASCADE;
ALTER TABLE public.external_association_type ADD CONSTRAINT external_association_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_external_association_type DROP CONSTRAINT IF EXISTS member_external_association_created_by_member_fk CASCADE;
ALTER TABLE public.member_external_association_type ADD CONSTRAINT member_external_association_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_external_association_type DROP CONSTRAINT IF EXISTS member_external_association_last_modified_by_member_fk CASCADE;
ALTER TABLE public.member_external_association_type ADD CONSTRAINT member_external_association_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_external_association_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_external_association_type DROP CONSTRAINT IF EXISTS member_external_association_external_association_fk CASCADE;
ALTER TABLE public.member_external_association_type ADD CONSTRAINT member_external_association_external_association_fk FOREIGN KEY (external_association_id)
REFERENCES public.external_association_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_external_association_type DROP CONSTRAINT IF EXISTS member_external_association_member_fk CASCADE;
ALTER TABLE public.member_external_association_type ADD CONSTRAINT member_external_association_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_external_association_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_external_association_type DROP CONSTRAINT IF EXISTS member_external_association_deleted_by_member_fk CASCADE;
ALTER TABLE public.member_external_association_type ADD CONSTRAINT member_external_association_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status_type DROP CONSTRAINT IF EXISTS post_status_created_by_member_fk CASCADE;
ALTER TABLE public.post_status_type ADD CONSTRAINT post_status_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status_type DROP CONSTRAINT IF EXISTS post_status_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_status_type ADD CONSTRAINT post_status_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_type_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status_type DROP CONSTRAINT IF EXISTS post_status_type_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_status_type ADD CONSTRAINT post_status_type_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status DROP CONSTRAINT IF EXISTS post_status_created_by_member_fk CASCADE;
ALTER TABLE public.post_status ADD CONSTRAINT post_status_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status DROP CONSTRAINT IF EXISTS post_status_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_status ADD CONSTRAINT post_status_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_post_id_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status DROP CONSTRAINT IF EXISTS post_status_post_id_fk CASCADE;
ALTER TABLE public.post_status ADD CONSTRAINT post_status_post_id_fk FOREIGN KEY (post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_post_status_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status DROP CONSTRAINT IF EXISTS post_status_post_status_type_fk CASCADE;
ALTER TABLE public.post_status ADD CONSTRAINT post_status_post_status_type_fk FOREIGN KEY (post_status_type_id)
REFERENCES public.post_status_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_status_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_status DROP CONSTRAINT IF EXISTS post_status_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_status ADD CONSTRAINT post_status_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: setting_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.setting DROP CONSTRAINT IF EXISTS setting_created_by_member_fk CASCADE;
ALTER TABLE public.setting ADD CONSTRAINT setting_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: setting_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.setting DROP CONSTRAINT IF EXISTS setting_last_modified_by_member_fk CASCADE;
ALTER TABLE public.setting ADD CONSTRAINT setting_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: setting_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.setting DROP CONSTRAINT IF EXISTS setting_deleted_by_member_fk CASCADE;
ALTER TABLE public.setting ADD CONSTRAINT setting_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category DROP CONSTRAINT IF EXISTS category_created_by_member_fk CASCADE;
ALTER TABLE public.category ADD CONSTRAINT category_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category DROP CONSTRAINT IF EXISTS category_last_modified_by_member_fk CASCADE;
ALTER TABLE public.category ADD CONSTRAINT category_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_participation_minimum_trust_level_fk | type: CONSTRAINT --
-- ALTER TABLE public.category DROP CONSTRAINT IF EXISTS category_participation_minimum_trust_level_fk CASCADE;
ALTER TABLE public.category ADD CONSTRAINT category_participation_minimum_trust_level_fk FOREIGN KEY (participation_minimum_trust_level_id)
REFERENCES public.trust_level (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_category_tag_set_fk | type: CONSTRAINT --
-- ALTER TABLE public.category DROP CONSTRAINT IF EXISTS category_category_tag_set_fk CASCADE;
ALTER TABLE public.category ADD CONSTRAINT category_category_tag_set_fk FOREIGN KEY (category_tag_set_id)
REFERENCES public.category_tag_set (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: "category deleted_by_member_fk" | type: CONSTRAINT --
-- ALTER TABLE public.category DROP CONSTRAINT IF EXISTS "category deleted_by_member_fk" CASCADE;
ALTER TABLE public.category ADD CONSTRAINT "category deleted_by_member_fk" FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_post_type_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_post_type DROP CONSTRAINT IF EXISTS category_post_type_created_by_member_fk CASCADE;
ALTER TABLE public.category_post_type ADD CONSTRAINT category_post_type_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_post_type_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_post_type DROP CONSTRAINT IF EXISTS category_post_type_last_modified_by_member_fk CASCADE;
ALTER TABLE public.category_post_type ADD CONSTRAINT category_post_type_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_post_type_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_post_type DROP CONSTRAINT IF EXISTS category_post_type_deleted_by_member_fk CASCADE;
ALTER TABLE public.category_post_type ADD CONSTRAINT category_post_type_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_duplicate_post DROP CONSTRAINT IF EXISTS post_duplicate_post_created_by_member_fk CASCADE;
ALTER TABLE public.post_duplicate_post ADD CONSTRAINT post_duplicate_post_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_duplicate_post DROP CONSTRAINT IF EXISTS post_duplicate_post_last_modified_by_member_fk CASCADE;
ALTER TABLE public.post_duplicate_post ADD CONSTRAINT post_duplicate_post_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_original_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_duplicate_post DROP CONSTRAINT IF EXISTS post_duplicate_post_original_post_fk CASCADE;
ALTER TABLE public.post_duplicate_post ADD CONSTRAINT post_duplicate_post_original_post_fk FOREIGN KEY (original_post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_duplicate_post_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_duplicate_post DROP CONSTRAINT IF EXISTS post_duplicate_post_duplicate_post_fk CASCADE;
ALTER TABLE public.post_duplicate_post ADD CONSTRAINT post_duplicate_post_duplicate_post_fk FOREIGN KEY (duplicate_post_id)
REFERENCES public.post (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: post_duplicate_post_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.post_duplicate_post DROP CONSTRAINT IF EXISTS post_duplicate_post_deleted_by_member_fk CASCADE;
ALTER TABLE public.post_duplicate_post ADD CONSTRAINT post_duplicate_post_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.tag_history DROP CONSTRAINT IF EXISTS tag_history_member_fk CASCADE;
ALTER TABLE audit.tag_history ADD CONSTRAINT tag_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: trust_level_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.trust_level_history DROP CONSTRAINT IF EXISTS trust_level_history_member_fk CASCADE;
ALTER TABLE audit.trust_level_history ADD CONSTRAINT trust_level_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_tag_set_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_tag_set DROP CONSTRAINT IF EXISTS category_tag_set_created_by_member_fk CASCADE;
ALTER TABLE public.category_tag_set ADD CONSTRAINT category_tag_set_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_tag_set_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_tag_set DROP CONSTRAINT IF EXISTS category_tag_set_last_modified_by_member_fk CASCADE;
ALTER TABLE public.category_tag_set ADD CONSTRAINT category_tag_set_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: category_tag_set_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.category_tag_set DROP CONSTRAINT IF EXISTS category_tag_set_deleted_by_member_fk CASCADE;
ALTER TABLE public.category_tag_set ADD CONSTRAINT category_tag_set_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: tag_set_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.category_tag_set_history DROP CONSTRAINT IF EXISTS tag_set_history_member_fk CASCADE;
ALTER TABLE audit.category_tag_set_history ADD CONSTRAINT tag_set_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason DROP CONSTRAINT IF EXISTS close_reason_created_by_member_fk CASCADE;
ALTER TABLE public.close_reason ADD CONSTRAINT close_reason_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason DROP CONSTRAINT IF EXISTS close_reason_last_modified_by_member_fk CASCADE;
ALTER TABLE public.close_reason ADD CONSTRAINT close_reason_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_parent_close_reason_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason DROP CONSTRAINT IF EXISTS close_reason_parent_close_reason_fk CASCADE;
ALTER TABLE public.close_reason ADD CONSTRAINT close_reason_parent_close_reason_fk FOREIGN KEY (parent_close_reason_id)
REFERENCES public.close_reason (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason DROP CONSTRAINT IF EXISTS close_reason_deleted_by_member_fk CASCADE;
ALTER TABLE public.close_reason ADD CONSTRAINT close_reason_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: history_activity_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.close_reason_history DROP CONSTRAINT IF EXISTS history_activity_member_fk CASCADE;
ALTER TABLE audit.close_reason_history ADD CONSTRAINT history_activity_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_annotation DROP CONSTRAINT IF EXISTS member_annotation_created_by_member_fk CASCADE;
ALTER TABLE public.member_annotation ADD CONSTRAINT member_annotation_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_annotation DROP CONSTRAINT IF EXISTS member_annotation_last_modified_by_member_fk CASCADE;
ALTER TABLE public.member_annotation ADD CONSTRAINT member_annotation_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_annotation DROP CONSTRAINT IF EXISTS member_annotation_deleted_by_member_fk CASCADE;
ALTER TABLE public.member_annotation ADD CONSTRAINT member_annotation_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_annotation DROP CONSTRAINT IF EXISTS member_annotation_member_fk CASCADE;
ALTER TABLE public.member_annotation ADD CONSTRAINT member_annotation_member_fk FOREIGN KEY (member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_annotation_type_fk | type: CONSTRAINT --
-- ALTER TABLE public.member_annotation DROP CONSTRAINT IF EXISTS member_annotation_annotation_type_fk CASCADE;
ALTER TABLE public.member_annotation ADD CONSTRAINT member_annotation_annotation_type_fk FOREIGN KEY (annotation_type_id)
REFERENCES public.annotation_type (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: annotation_type_created_by_member_fk_cp | type: CONSTRAINT --
-- ALTER TABLE public.annotation_type DROP CONSTRAINT IF EXISTS annotation_type_created_by_member_fk_cp CASCADE;
ALTER TABLE public.annotation_type ADD CONSTRAINT annotation_type_created_by_member_fk_cp FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: annotation_type_last_modified_by_member_fk_cp | type: CONSTRAINT --
-- ALTER TABLE public.annotation_type DROP CONSTRAINT IF EXISTS annotation_type_last_modified_by_member_fk_cp CASCADE;
ALTER TABLE public.annotation_type ADD CONSTRAINT annotation_type_last_modified_by_member_fk_cp FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: annotation_type_deleted_by_member_fk_cp | type: CONSTRAINT --
-- ALTER TABLE public.annotation_type DROP CONSTRAINT IF EXISTS annotation_type_deleted_by_member_fk_cp CASCADE;
ALTER TABLE public.annotation_type ADD CONSTRAINT annotation_type_deleted_by_member_fk_cp FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: member_annotation_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.member_annotation_history DROP CONSTRAINT IF EXISTS member_annotation_history_member_fk CASCADE;
ALTER TABLE audit.member_annotation_history ADD CONSTRAINT member_annotation_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: annotation_type_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.annotation_type_history DROP CONSTRAINT IF EXISTS annotation_type_history_member_fk CASCADE;
ALTER TABLE audit.annotation_type_history ADD CONSTRAINT annotation_type_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_subreason_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason_subreason DROP CONSTRAINT IF EXISTS close_reason_subreason_created_by_member_fk CASCADE;
ALTER TABLE public.close_reason_subreason ADD CONSTRAINT close_reason_subreason_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_subreason_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason_subreason DROP CONSTRAINT IF EXISTS close_reason_subreason_last_modified_by_member_fk CASCADE;
ALTER TABLE public.close_reason_subreason ADD CONSTRAINT close_reason_subreason_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_subreason_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason_subreason DROP CONSTRAINT IF EXISTS close_reason_subreason_deleted_by_member_fk CASCADE;
ALTER TABLE public.close_reason_subreason ADD CONSTRAINT close_reason_subreason_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_subreason_close_reason_fk | type: CONSTRAINT --
-- ALTER TABLE public.close_reason_subreason DROP CONSTRAINT IF EXISTS close_reason_subreason_close_reason_fk CASCADE;
ALTER TABLE public.close_reason_subreason ADD CONSTRAINT close_reason_subreason_close_reason_fk FOREIGN KEY (close_reason_id)
REFERENCES public.close_reason (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: close_reason_subreason_history_member_fk | type: CONSTRAINT --
-- ALTER TABLE audit.close_reason_subreason_history DROP CONSTRAINT IF EXISTS close_reason_subreason_history_member_fk CASCADE;
ALTER TABLE audit.close_reason_subreason_history ADD CONSTRAINT close_reason_subreason_history_member_fk FOREIGN KEY (history_activity_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: notice_created_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.notice DROP CONSTRAINT IF EXISTS notice_created_by_member_fk CASCADE;
ALTER TABLE public.notice ADD CONSTRAINT notice_created_by_member_fk FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: notice_last_modified_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.notice DROP CONSTRAINT IF EXISTS notice_last_modified_by_member_fk CASCADE;
ALTER TABLE public.notice ADD CONSTRAINT notice_last_modified_by_member_fk FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: notice_deleted_by_member_fk | type: CONSTRAINT --
-- ALTER TABLE public.notice DROP CONSTRAINT IF EXISTS notice_deleted_by_member_fk CASCADE;
ALTER TABLE public.notice ADD CONSTRAINT notice_deleted_by_member_fk FOREIGN KEY (deleted_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: notice_created_by_member_fk_cp | type: CONSTRAINT --
-- ALTER TABLE audit.notice_history DROP CONSTRAINT IF EXISTS notice_created_by_member_fk_cp CASCADE;
ALTER TABLE audit.notice_history ADD CONSTRAINT notice_created_by_member_fk_cp FOREIGN KEY (created_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: notice_last_modified_by_member_fk_cp | type: CONSTRAINT --
-- ALTER TABLE audit.notice_history DROP CONSTRAINT IF EXISTS notice_last_modified_by_member_fk_cp CASCADE;
ALTER TABLE audit.notice_history ADD CONSTRAINT notice_last_modified_by_member_fk_cp FOREIGN KEY (last_modified_by_member_id)
REFERENCES public.member (id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


