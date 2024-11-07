import mysql.connector

def establish_connection():
    try:
        return mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="dbname"
        )
    except mysql.connector.Error as error:
        print(f"Connection error: {error}")
        return None

def initialize_table():
    connection = establish_connection()
    cursor = connection.cursor()
    sql_query = """
    CREATE TABLE IF NOT EXISTS learners (
        ID INT AUTO_INCREMENT,
        Name VARCHAR(255) NOT NULL,
        Major VARCHAR(255) NOT NULL,
        Age INT NOT NULL,
        PRIMARY KEY (ID)
    )
    """
    cursor.execute(sql_query)
    connection.commit()
    print("Table initialized successfully!")
    cursor.close()
    connection.close()

def insert_learner():
    student_name = input("Enter Learner Name: ")
    major = input("Enter Major: ")
    student_age = int(input("Enter Age: "))
    connection = establish_connection()
    cursor = connection.cursor()
    sql_query = "INSERT INTO learners (Name, Major, Age) VALUES (%s, %s, %s)"
    data = (student_name, major, student_age)
    cursor.execute(sql_query, data)
    connection.commit()
    print("Learner added successfully!")
    cursor.close()
    connection.close()

def remove_learner():
    learner_id = int(input("Enter Learner ID to remove: "))
    connection = establish_connection()
    cursor = connection.cursor()
    sql_query = "DELETE FROM learners WHERE ID = %s"
    cursor.execute(sql_query, (learner_id,))
    connection.commit()
    print("Learner removed successfully!")
    cursor.close()
    connection.close()

def modify_learner():
    learner_id = int(input("Enter Learner ID to modify: "))
    new_name = input("Enter new Learner Name: ")
    new_major = input("Enter new Major: ")
    new_age = int(input("Enter new Age: "))
    connection = establish_connection()
    cursor = connection.cursor()
    sql_query = "UPDATE learners SET Name = %s, Major = %s, Age = %s WHERE ID = %s"
    data = (new_name, new_major, new_age, learner_id)
    cursor.execute(sql_query, data)
    connection.commit()
    print("Learner updated successfully!")
    cursor.close()
    connection.close()

def display_learners():
    connection = establish_connection()
    cursor = connection.cursor()
    sql_query = "SELECT * FROM learners"
    cursor.execute(sql_query)
    records = cursor.fetchall()
    print("\n--- Learners List ---")
    for record in records:
        print(f"ID: {record[0]}, Name: {record[1]}, Major: {record[2]}, Age: {record[3]}")
    cursor.close()
    connection.close()

def user_interface():
    initialize_table()
    while True:
        print("\n--- Learner Database Menu ---")
        print("1. Add Learner")
        print("2. Remove Learner")
        print("3. Modify Learner")
        print("4. View Learners")
        print("5. Exit")
        selection = input("Enter your choice: ")
        if selection == '1':
            insert_learner()
        elif selection == '2':
            remove_learner()
        elif selection == '3':
            modify_learner()
        elif selection == '4':
            display_learners()
        elif selection == '5':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    user_interface()
