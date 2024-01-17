CREATE TABLE books (
    id bigint not null,
    category_id  int not null,
    author character varying not null,
    title character varying not null,
    year int not null 
);

CREATE TABLE books_1 (
    CHECK ( category_id=1 )
) INHERITS ( books );

CREATE TABLE books_2 (
    CHECK ( category_id=2 )
) INHERITS ( books );

CREATE TABLE books_3 (
    CHECK ( category_id=3 )
) INHERITS ( books );


CREATE RULE books_insert_to_category_1 AS ON INSERT TO books
WHERE ( category_id = 1 )
DO INSTEAD INSERT INTO books_1 VALUES (NEW.*);

CREATE RULE books_insert_to_category_2 AS ON INSERT TO books
WHERE ( category_id = 2 )
DO INSTEAD INSERT INTO books_2 VALUES (NEW.*);

CREATE RULE books_insert_to_category_3 AS ON INSERT TO books
WHERE ( category_id = 3 )
DO INSTEAD INSERT INTO books_3 VALUES (NEW.*);
