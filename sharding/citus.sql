SELECT citus_set_coordinator_host('citus', 5432);
SELECT citus_add_node('citus2', 5432);
SELECT citus_add_node('citus3', 5432);

CREATE TABLE books (
    id bigint not null,
    category_id  int not null,
    author character varying not null,
    title character varying not null,
    year int not null 
);

SELECT create_distributed_table('books', 'category_id');

CREATE EXTENSION pg_stat_statements ;