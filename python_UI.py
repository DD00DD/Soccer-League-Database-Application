import oracledb

# -----------------------------
#   DATABASE CONNECTION
# -----------------------------
conn = oracledb.connect(
    user="system",
    password="123",
    dsn="LAPTOP-D4373N8B:1521/xe"
)

cursor = conn.cursor()

# -----------------------------
#   MAIN MENU
# -----------------------------
def print_main_menu():
    print("=====================================")
    print("       DATABASE MANAGEMENT MENU      ")
    print("=====================================")
    print("1. Drop Tables")
    print("2. Create Tables")
    print("3. Populate Tables")
    print("4. Query Tables")
    print("5. Record Operations Based on User Request") 
    print("6. Exit")
    print("=====================================")

# -----------------------------
#   DROP TABLES
# -----------------------------
def drop_tables():
    tables = [
        "TeamPoints", "Rankings", "StadiumInfo", "Matches",
        "Coaches", "Soccer_Player", "Teams", "Leagues"
    ]
    for table in tables:
        try:
            cursor.execute(f"DROP TABLE {table} CASCADE CONSTRAINTS")
            print(f"Table {table} dropped successfully.")
        except oracledb.DatabaseError as e:
            print(f"Could not drop {table}: {e}")
    conn.commit()

# -----------------------------
#   CREATE TABLES
# -----------------------------
def create_tables():
    try:
        # Leagues
        cursor.execute("""
        CREATE TABLE Leagues (
            league_id NUMBER PRIMARY KEY NOT NULL,
            league_name VARCHAR2(50) NOT NULL,
            number_of_teams NUMBER DEFAULT 0 CHECK(number_of_teams >= 0),
            total_seasons NUMBER DEFAULT 0 CHECK(total_seasons >= 0),
            average_player_rating NUMBER DEFAULT 1 CHECK(average_player_rating > 0 AND average_player_rating < 100),
            current_total_matches_played NUMBER DEFAULT 0 CHECK(current_total_matches_played >= 0)
        )
        """)
        
        # Teams
        cursor.execute("""
        CREATE TABLE Teams ( 
            team_id NUMBER PRIMARY KEY NOT NULL,
            team_name VARCHAR2(100) NOT NULL,
            city VARCHAR2(50) NOT NULL,
            country VARCHAR2(50) NOT NULL,
            team_mascot VARCHAR2(50) NOT NULL,
            year_founded DATE,
            wins NUMBER DEFAULT 0 CHECK(wins >= 0),
            draws NUMBER DEFAULT 0 CHECK(draws >= 0),
            losses NUMBER DEFAULT 0 CHECK(losses >= 0),
            goals_scored NUMBER DEFAULT 0 CHECK(goals_scored >= 0),
            goals_conceded NUMBER DEFAULT 0 CHECK(goals_conceded >= 0),
            stadium VARCHAR2(100) NOT NULL,
            league_id NUMBER,
            CONSTRAINT id_league_teams
                FOREIGN KEY (league_id) REFERENCES Leagues(league_id)
        )
        """)

        # Soccer_Player
        cursor.execute("""
        CREATE TABLE Soccer_Player ( 
            player_id NUMBER PRIMARY KEY NOT NULL,
            person_name VARCHAR2(100) NOT NULL,
            nationality VARCHAR2(50) NOT NULL,
            yellow_cards NUMBER DEFAULT 0 CHECK(yellow_cards >= 0),
            red_cards NUMBER DEFAULT 0 CHECK(red_cards >= 0),
            jersey_number NUMBER(3) NOT NULL CHECK(jersey_number > 0 AND jersey_number < 100),
            player_position VARCHAR2(50),
            rating NUMBER(3) DEFAULT 1 CHECK (rating > 0 AND rating < 100),
            matches_played NUMBER DEFAULT 0 CHECK(matches_played >= 0),
            goals NUMBER DEFAULT 0 CHECK(goals >= 0),
            assists NUMBER DEFAULT 0 CHECK(assists >= 0),
            injuries NUMBER DEFAULT 0 CHECK(injuries >= 0),
            league_id NUMBER,
            team_id NUMBER,
            CONSTRAINT id_league_soccer
                FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
            CONSTRAINT id_team_soccer
                FOREIGN KEY (team_id) REFERENCES Teams(team_id)
        )
        """)

        # Coaches
        cursor.execute("""
        CREATE TABLE Coaches ( 
            player_id NUMBER PRIMARY KEY NOT NULL,
            person_name VARCHAR2(100) NOT NULL,
            nationality VARCHAR2(50) NOT NULL,
            yellow_cards NUMBER DEFAULT 0 CHECK(yellow_cards >= 0),
            red_cards NUMBER DEFAULT 0 CHECK(red_cards >= 0),
            role VARCHAR2(100) NOT NULL,
            preferred_formation VARCHAR2(100) NOT NULL,
            years_of_experience NUMBER DEFAULT 0 CHECK(years_of_experience >= 0),
            league_id NUMBER,
            team_id NUMBER,
            CONSTRAINT id_league_coach
                FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
            CONSTRAINT id_team_coach
                FOREIGN KEY (team_id) REFERENCES Teams(team_id)
        )
        """)

        # Matches
        cursor.execute("""
        CREATE TABLE Matches (
            match_id NUMBER PRIMARY KEY NOT NULL,
            season NUMBER DEFAULT 0 CHECK(season >= 0),
            match_date DATE,
            status VARCHAR2(50) NOT NULL,
            home_score NUMBER DEFAULT 0 CHECK(home_score >= 0),
            away_score NUMBER DEFAULT 0 CHECK(away_score >= 0),
            league_id NUMBER,
            home_team_id NUMBER NOT NULL,
            away_team_id NUMBER NOT NULL,
            CONSTRAINT id_league_match
                FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
            CONSTRAINT fk_home_team 
                FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
            CONSTRAINT fk_away_team 
                FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
        )
        """)

        # StadiumInfo
        cursor.execute("""
        CREATE TABLE StadiumInfo (
            home_id NUMBER PRIMARY KEY NOT NULL,
            stadium VARCHAR2(100) NOT NULL,
            CONSTRAINT fk_home_id 
                FOREIGN KEY (home_id) REFERENCES Teams(team_id)
        )
        """)

        # Rankings
        cursor.execute("""
        CREATE TABLE Rankings (
            rank_position NUMBER NOT NULL,
            matches_played NUMBER DEFAULT 0 CHECK(matches_played >= 0),
            league_id NUMBER,
            team_id NUMBER,
            PRIMARY KEY (league_id, team_id),
            CONSTRAINT ranking_id
                FOREIGN KEY (team_id) REFERENCES Teams(team_id),   
            CONSTRAINT id_league_rank
                FOREIGN KEY (league_id) REFERENCES Leagues(league_id)
        )
        """)

        # TeamPoints
        cursor.execute("""
        CREATE TABLE TeamPoints (
            team_id NUMBER PRIMARY KEY NOT NULL,
            points NUMBER DEFAULT 0 CHECK(points >= 0),
            CONSTRAINT id_team_rank
                FOREIGN KEY (team_id) REFERENCES Teams(team_id)
        )
        """)

        conn.commit()
        print("All tables created successfully.")
    except oracledb.DatabaseError as e:
        print(f"Error creating tables: {e}")

# -----------------------------
#   POPULATE TABLES
# -----------------------------
def populate_tables():
    try:
        # Leagues
        cursor.execute("INSERT INTO Leagues VALUES (102,'La Luga',34,7,87,102)")
        cursor.execute("INSERT INTO Leagues VALUES (103,'Premier League',23,45,92,213)")
        cursor.execute("INSERT INTO Leagues VALUES (104,'Bundesliga',18,72,82,364)")

        # Teams (only a few examples; you can insert all later)
        teams_sql = [
            # Premier League
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (201, 'Liverpool F.C.', 'Liverpool', 'UK', 'Might Red', TO_DATE('1934-05-12', 'YYYY-MM-DD'), 12, 4, 6, 36, 20, 'Anfield', 103)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (202, 'Chelsea F.C.', 'London', 'UK', 'Stamford the lion', TO_DATE('1965-08-23', 'YYYY-MM-DD'), 23, 2, 30, 54, 72, 'Stamford Bridge', 103)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (203, 'Arsenal F.C.', 'London', 'UK', 'Gunnersaurus', TO_DATE('1981-12-11', 'YYYY-MM-DD'), 30, 0, 12, 102, 54, 'Emmirates', 103)""",
            
            # Bundesliga
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (204, 'Bayern', 'Munich', 'Bavaria', 'Berni Bear', TO_DATE('1944-06-17', 'YYYY-MM-DD'), 23, 7, 16, 76, 31, 'Allianz Arena', 104)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (205, 'Eintracht Frankfurt', 'Frankfurt am Main', 'Germany', 'Attila Eagle', TO_DATE('1958-01-22', 'YYYY-MM-DD'), 17, 8, 29, 34, 89, 'Deutsche Bank', 104)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (206, 'FC Koln', 'Cologne', 'Germany', 'Hennes Goat', TO_DATE('1968-10-10', 'YYYY-MM-DD'), 30, 0, 62, 65, 58, 'RheinEnergieSTADION', 104)""",

            # La Liga
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (207, 'Real Madrid', 'Madrid', 'Spain', 'Bear', TO_DATE('1924-07-18', 'YYYY-MM-DD'), 57, 23, 23, 67, 67, 'Bernabeu Stadium', 102)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (208, 'Athletic Club', 'Bilbao', 'Spain', 'Lion', TO_DATE('1998-02-14', 'YYYY-MM-DD'), 34, 34, 34, 89, 34, 'San Mames', 102)""",
            """INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id)
            VALUES (209, 'Villarreal', 'Villareal', 'Spain', 'Groguet', TO_DATE('1971-04-01', 'YYYY-MM-DD'), 76, 32, 102, 150, 132, 'Estadide la Creamica', 102)"""
        ]

        # Execute all INSERT statements
        for sql in teams_sql:
            cursor.execute(sql)

            # Soccer_Player
        players_sql = [
            # Premier League
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (301, 'Mohamed Salah', 'Egypt', 1, 0, 11, 'Forward', 89, 5, 3, 6, 1, 103, 201)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (302, 'Virgil van Dijk', 'Netherlands', 3, 2, 4, 'Defender', 84, 12, 1, 7, 0, 103, 201)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (303, 'Cole Palmer', 'England', 0, 3, 10, 'Midfielder', 72, 20, 2, 12, 3, 103, 202)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (304, 'Gabriel Jesus', 'Brazil', 6, 0, 11, 'Forward', 64, 9, 6, 2, 1, 103, 203)""",

            # Bundesliga
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (305, 'Harry Kane', 'England', 3, 1, 9, 'Forward', 93, 4, 3, 2, 0, 104, 204)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (306, 'Ritsu Doan', 'Japan', 0, 0, 10, 'Midfielder', 99, 21, 12, 11, 0, 104, 205)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (307, 'Michael Zetterer', 'Germany', 0, 5, 23, 'Forward', 56, 6, 0, 3, 1, 104, 205)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (308, 'Jeff Chabot', 'Germany', 0, 1, 24, 'Defender', 1, 0, 0, 0, 1, 104, 206)""",

            # La Liga
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (309, 'Dean Huijsen', 'Netherlands', 4, 0, 24, 'Defender', 81, 3, 0, 1, 0, 102, 207)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (310, 'Alex Padilla', 'Spain', 11, 2, 66, 'Goalkeeper', 76, 12, 0, 15, 0, 102, 208)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (311, 'Juan Foyth', 'Netherlands', 1, 6, 99, 'Defender', 66, 8, 4, 13, 0, 102, 209)""",
            """INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id)
            VALUES (312, 'Luiz Junior', 'Brazil', 0, 3, 69, 'Goalkeeper', 3, 20, 0, 12, 0, 102, 209)"""
        ]

        # Execute all INSERT statements
        for sql in players_sql:
            cursor.execute(sql)


        # Coaches
        coaches_sql = [
            # Premier League
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (401, 'Arne Slot', 'Netherlands', 5, 1, 'Head Coach', '4-2-3-1', 8, 103, 201)""",
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (402, 'Willy Caballero', 'Argentina', 0, 3, 'Assistant Coach', '4-4-2', 3, 103, 202)""",

            # Bundesliga
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (403, 'Vincent Kompany', 'Belgium', 2, 0, 'Head Coach', '4-2-3-1', 20, 104, 204)""",
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (404, 'Hansi Flick', 'Germany', 6, 0, 'Technical Analyst', '4-3-3', 10, 104, 204)""",

            # La Liga
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (405, 'Xabi Alonso', 'Spain', 0, 1, 'Head Coach', '3-4-2-1', 21, 102, 207)""",
            """INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
            VALUES (406, 'Unai Emery', 'Spain', 0, 0, 'Assistant Coach', '5-3-2', 11, 102, 209)"""
        ]

        # Execute all INSERT statements
        for sql in coaches_sql:
            cursor.execute(sql)


        # Matches
        matches_sql = [
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(501,45, TO_DATE('2025-09-06 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed',1,0,103, 201, 203)""",
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(502,7, TO_DATE('2025-09-13 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Ongoing',0,4,104, 205, 204)""",
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(503,72, TO_DATE('2025-09-13 08:30:00', 'YYYY-MM-DD HH24:MI:SS'),'Completed',2,2,102, 207, 208)""",
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(504,39, TO_DATE('2025-12-12 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelled',0,0,103, 202, 201)""",
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(505, 7, TO_DATE('2026-01-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Scheduled', 0, 0, 104, 206, 205)""",
            """INSERT INTO Matches(match_id, season, match_date, status, home_score, away_score, league_id, home_team_id, away_team_id)
            VALUES(506, 72, TO_DATE('2026-02-14 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Scheduled', 0, 9,102, 207, 208)"""
        ]

        # Execute all INSERT statements
        for sql in matches_sql:
            cursor.execute(sql)

        # StadiumInfo
        stadiums_sql = [
            """INSERT INTO StadiumInfo(home_id, stadium) VALUES(201, 'Anfield')""",
            """INSERT INTO StadiumInfo(home_id, stadium) VALUES(205, 'Deutsche Bank')""",
            """INSERT INTO StadiumInfo(home_id, stadium) VALUES(207, 'Bernabeu')""",
            """INSERT INTO StadiumInfo(home_id, stadium) VALUES(202, 'Stamford Bridge')""",
            """INSERT INTO StadiumInfo(home_id, stadium) VALUES(206, 'RheinEnergieSTADION')"""
        ]

        # Execute all INSERT statements
        for sql in stadiums_sql:
            cursor.execute(sql)


        # Rankings
        rankings_sql = [
            """INSERT INTO Rankings(rank_position, matches_played, league_id, team_id)
            VALUES(4,14,104,206)""",
            """INSERT INTO Rankings(rank_position, matches_played, league_id, team_id)
            VALUES(5,16,102,208)""",
            """INSERT INTO Rankings(rank_position, matches_played, league_id, team_id)
            VALUES(2,12,103,202)""",
            """INSERT INTO Rankings(rank_position, matches_played, league_id, team_id)
            VALUES(3,11,103,201)"""
        ]

        # Execute all INSERT statements
        for sql in rankings_sql:
            cursor.execute(sql)

        # TeamPoints
        points_sql = [
            """INSERT INTO TeamPoints(team_id, points) VALUES(206, 9)""",
            """INSERT INTO TeamPoints(team_id, points) VALUES(208, 10)""",
            """INSERT INTO TeamPoints(team_id, points) VALUES(202, 25)""",
            """INSERT INTO TeamPoints(team_id, points) VALUES(201, 15)"""
        ]

        # 3️⃣ Execute all INSERT statements
        for sql in points_sql:
            cursor.execute(sql)

        conn.commit()
        print("Tables populated successfully.")
    except oracledb.DatabaseError as e:
        print(f"Error populating tables: {e}")

# -----------------------------
#   QUERY TABLES
# -----------------------------
def query_tables():
    try:
        tables = ["Leagues","Teams","Soccer_Player","Coaches","Matches","StadiumInfo","Rankings","TeamPoints"]
        for table in tables:
            print(f"\n-- {table} --")
            cursor.execute(f"SELECT * FROM {table}")
            rows = cursor.fetchall()
            for row in rows:
                print(row)
    except oracledb.DatabaseError as e:
        print(f"Error querying tables: {e}")

# -----------------------------
#   RECORD OPERATIONS MENU
# -----------------------------
def print_record_menu():
    print("=====================================")
    print("          RECORD OPERATIONS          ")
    print("=====================================")
    print("1. Read Records")
    print("2. Update Records")
    print("3. Delete Records")
    print("4. Search for a Record")
    print("5. Return to Main Menu")
    print("=====================================")

def read_records():
    table = input("Enter table name to read: ").strip()
    try:
        cursor.execute(f"SELECT * FROM {table}")
        rows = cursor.fetchall()
        for row in rows:
            print(row)
    except oracledb.DatabaseError as e:
        print(f"Error reading records: {e}")

def update_records():
    table = input("Enter table name to update: ").strip()
    column = input("Enter column to update: ").strip()
    value = input("Enter new value: ").strip()
    condition = input("Enter WHERE condition (e.g., team_id=206): ").strip()
    try:
        cursor.execute(f"UPDATE {table} SET {column} = :val WHERE {condition}", val=value)
        conn.commit()
        print("Record updated successfully.")
    except oracledb.DatabaseError as e:
        print(f"Error updating record: {e}")

def delete_records():
    table = input("Enter table name to delete from: ").strip()
    condition = input("Enter WHERE condition (e.g., team_id=206): ").strip()
    try:
        cursor.execute(f"DELETE FROM {table} WHERE {condition}")
        conn.commit()
        print("Record deleted successfully.")
    except oracledb.DatabaseError as e:
        print(f"Error deleting record: {e}")

def search_records():
    table = input("Enter table name to search: ").strip()
    column = input("Enter column to search in: ").strip()
    term = input("Enter search term: ").strip()
    try:
        cursor.execute(f"SELECT * FROM {table} WHERE {column} LIKE :term", term=f"%{term}%")
        rows = cursor.fetchall()
        for row in rows:
            print(row)
    except oracledb.DatabaseError as e:
        print(f"Error searching records: {e}")

def record_operations_menu():
    while True:
        print_record_menu()
        choice = input("Select an option: ").strip()
        if choice == "1":
            read_records()
        elif choice == "2":
            update_records()
        elif choice == "3":
            delete_records()
        elif choice == "4":
            search_records()
        elif choice == "5":
            break
        else:
            print("Invalid option. Try again.")

# -----------------------------
#   MAIN LOOP
# -----------------------------
def main():
    running = True
    while running:
        print_main_menu()
        choice = input("Select an option: ").strip()
        if choice == "1":
            drop_tables()
        elif choice == "2":
            create_tables()
        elif choice == "3":
            populate_tables()
        elif choice == "4":
            query_tables()
        elif choice == "5":
            record_operations_menu()
        elif choice == "6":
            print("Exiting...")
            running = False
        else:
            print("Invalid option. Try again.")
        print()

if __name__ == "__main__":
    main()
