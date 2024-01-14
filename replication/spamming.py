import mysql.connector
import random
import time
from datetime import datetime


# MySQL database connection settings
db_config = {
    'host': 'localhost',
    'port': 3306,
    'user': 'master_user',
    'password': 'master_user_password',
    'database': 'master_db',
}
# Table creation SQL query
create_table_query = """
    CREATE TABLE IF NOT EXISTS foo (
        id INT AUTO_INCREMENT PRIMARY KEY,
        value1 INT,
        value2 FLOAT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
"""


# Function to insert random data into the table
def insert_random_data(cursor):
    value1 = random.randint(1, 100)
    value2 = random.uniform(0.0, 1.0)
    query = "INSERT INTO foo (value1, value2) VALUES (%s, %s)"
    cursor.execute(query, (value1, value2))


def create_schema_for_slaves():
    connection = mysql.connector.connect(**{
        'host': 'localhost',
        'port': 3307,
        'user': 'slave1_user',
        'password': 'slave1_user_password',
        'database': 'slave1_db',
    })
    cursor = connection.cursor()
    # Create the table if it doesn't exist
    cursor.execute(create_table_query)
    connection.commit()
    cursor.close()
    connection.close()
    
    connection = mysql.connector.connect(**{
        'host': 'localhost',
        'port': 3308,
        'user': 'slave2_user',
        'password': 'slave2_user_password',
        'database': 'slave2_db',
    })
    cursor = connection.cursor()
    # Create the table if it doesn't exist
    cursor.execute(create_table_query)
    connection.commit()
    cursor.close()
    connection.close()


# Main script
def main():
    try:
        # Connect to the MySQL server
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor()

        # Create the table if it doesn't exist
        cursor.execute(create_table_query)
        connection.commit()

        # create_schema_for_slaves()

        print("Connected to MySQL database. Press Ctrl+C to exit.")

        # Periodically insert random data into the table
        while True:
            insert_random_data(cursor)
            connection.commit()
            print("Inserted data at", datetime.now())
            time.sleep(1)  # Adjust the sleep interval as needed

    except KeyboardInterrupt:
        print("Script terminated by user.")
    finally:
        # Close the cursor and connection on exit
        if 'connection' in locals() and connection.is_connected():
            cursor.close()
            connection.close()
            print("`MySQL connection closed.")


if __name__ == "__main__":
    main()
