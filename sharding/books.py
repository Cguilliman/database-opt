import psycopg2
from faker import Faker
import random
from concurrent.futures import ThreadPoolExecutor

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname='db',
    user='u',
    password='p',
    host='localhost',
    port='5435'
)
cursor = conn.cursor()

# Create Faker instance
fake = Faker()


def insert_data(id):
    data = {
        'id': id,
        'category_id': random.randint(1, 3),
        'author': fake.name(),
        'title': fake.sentence(),
        'year': random.randint(1800, 2022)
    }
    cursor.execute("""
        INSERT INTO books (id, category_id, author, title, year)
        VALUES (%(id)s, %(category_id)s, %(author)s, %(title)s, %(year)s)
    """, data)
    print(id)

# Use ThreadPoolExecutor to insert data in parallel
with ThreadPoolExecutor(max_workers=1000) as executor:
    # Submit tasks for each ID in parallel
    futures = [executor.submit(insert_data, id) for id in range(1_000_000)]

    # Wait for all tasks to complete
    for future in futures:
        future.result()

# Commit the changes
conn.commit()

# Close the cursor and connection
cursor.close()
conn.close()
