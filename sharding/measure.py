import psycopg2
from faker import Faker
import random
import time


# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname='db',
    user='u',
    password='p',
    host='localhost',
    port='5432'
)
cursor = conn.cursor()

# Create Faker instance
fake = Faker()


# Function to insert data into the books table
def insert_data(table):
    start_time = time.time()
    for id in range(500):
        cursor.execute(f"""
            INSERT INTO {table} (id, category_id, author, title, year)
            VALUES (
                '{id}',
                '{random.randint(1, 3)}',
                '{fake.name()}',
                '{fake.sentence()}',
                '{random.randint(1800, 2022)}'
            )
        """)
        conn.commit()
    end_time = time.time()
    print(f"Insertion time: {end_time - start_time} seconds")


# Function to query data from the books table
def query_data(table):
    start_time = time.time()
    cursor.execute(f"SELECT * FROM {table} LIMIT 200")
    result = cursor.fetchall()
    end_time = time.time()
    print(f"Query time: {end_time - start_time} seconds")


# print("\nNot shared database")
# insert_data("books_regular")
# query_data("books_regular")

# print("\nVertical")
# insert_data("books")
# query_data("books")

# print("\nHorizontal")
# insert_data("books_h")
# query_data("books_h")

# Close the cursor and connection
cursor.close()
conn.close()

conn = psycopg2.connect(
    dbname='db',
    user='u',
    password='p',
    host='localhost',
    port='5435'
)
cursor = conn.cursor()

print("\nCitus")
insert_data("books")
query_data("books")

cursor.close()
conn.close()
