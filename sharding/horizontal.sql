CREATE TABLE books_h (
    id bigint not null,
    category_id  int not null,
    author character varying not null,
    title character varying not null,
    year int not null 
);

CREATE EXTENSION postgres_fdw;
# connect shard 1 to main
CREATE SERVER books_h_1_server 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS( host 'p2', port '5432', dbname 'db' );
CREATE USER MAPPING FOR u
SERVER books_h_1_server
OPTIONS (user 'u', password 'p');
CREATE FOREIGN TABLE books_h_1 (
    id bigint not null,
    category_id  int not null,
    author character varying not null,
    title character varying not null,
    year int not null
)
SERVER books_h_1_server
OPTIONS (schema_name 'public', table_name 'books_h');


# connect shard 2 to main
CREATE SERVER books_h_2_server 
FOREIGN DATA WRAPPER postgres_fdw 
OPTIONS( host 'p3', port '5432', dbname 'db' );
CREATE USER MAPPING FOR u
SERVER books_h_2_server
OPTIONS (user 'u', password 'p');
CREATE FOREIGN TABLE books_h_2 (
    id bigint not null,
    category_id  int not null,
    author character varying not null,
    title character varying not null,
    year int not null
)
SERVER books_h_2_server
OPTIONS (schema_name 'public', table_name 'books_h');


CREATE VIEW books_h_view AS
    SELECT * FROM books_h_1
        UNION ALL
    SELECT * FROM books_h_2
        UNION ALL
    SELECT * FROM books_h;


CREATE RULE books_insert_to_1 AS ON INSERT TO books_h
WHERE ( category_id = 1 )
DO INSTEAD INSERT INTO books_h_1 VALUES (NEW.*);

CREATE RULE books_insert_to_2 AS ON INSERT TO books_h
WHERE ( category_id = 2 )
DO INSTEAD INSERT INTO books_h_2 VALUES (NEW.*);


-- shards
CREATE TABLE books_h (
    id bigint not null,
    category_id int not null,
    CONSTRAINT category_id_check CHECK ( category_id = 2 ),
    author character varying not null,
    title character varying not null,
    year int not null
);
CREATE INDEX books_category_id_idx ON books_h USING btree(category_id);


