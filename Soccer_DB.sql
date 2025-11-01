-- Soccer League Database
-- By group 39: Derek Dao - 501111838 Vani Vashisht - 501201610 Oghosasere Obazee - 501222335
-- Description:
-- This code contains creates the schema for each table for our soccer league database stats tracker

CREATE TABLE Leagues (
    league_id NUMBER PRIMARY KEY NOT NULL,
    league_name VARCHAR2(50) NOT NULL,
    number_of_teams NUMBER DEFAULT 0 CHECK(number_of_teams >= 0),
    total_seasons NUMBER DEFAULT 0 CHECK(total_seasons >= 0),
    average_player_rating NUMBER DEFAULT 1 CHECK(average_player_rating > 0 AND average_player_rating < 100),
    current_total_matches_played NUMBER DEFAULT 0 CHECK(current_total_matches_played >= 0)
);

SELECT * FROM Leagues;
INSERT INTO Leagues (league_id, league_name, number_of_teams, total_seasons, average_player_rating, current_total_matches_played) VALUES (102, 'La Luga', 34, 7, 87, 102);
INSERT INTO Leagues (league_id, league_name, number_of_teams, total_seasons, average_player_rating, current_total_matches_played) VALUES (103, 'Premier League', 23, 45, 92, 213);
INSERT INTO Leagues (league_id, league_name, number_of_teams, total_seasons, average_player_rating, current_total_matches_played) VALUES (104, 'Bundesliga', 18, 72, 82, 364);


CREATE TABLE Teams ( 
    team_id NUMBER PRIMARY KEY NOT NULL,
    goals_scored NUMBER DEFAULT 0 CHECK(goals_scored >= 0),
    goals_conceded NUMBER DEFAULT 0 CHECK(goals_conceded >= 0),
    
    --the stadium attribute will be shared with matches to show where the match take place
    stadium VARCHAR2(100) NOT NULL,
    
    league_id NUMBER,
    
    -- this will be used to get the league_id so that the team table can identify the team and their league
    CONSTRAINT id_league_teams
        FOREIGN KEY (league_id) REFERENCES Leagues(league_id)
);

SELECT * FROM Teams;

-- Premier league
INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (201, 'Liverpool F.C.', 'Liverpool', 'UK', 'Might Red', TO_DATE('1934-05-12', 'YYYY-MM-DD'), 12, 4, 6, 36, 20, 'Anfield', 103);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (202, 'Chelsea F.C.', 'London', 'UK', 'Stamford the lion', TO_DATE('1965-08-23', 'YYYY-MM-DD'), 23, 2, 30, 54, 72, 'Stanford Bridge', 103);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (203, 'Arsenal F.C.', 'London', 'UK', 'Gunnersaurus', TO_DATE('1981-12-11', 'YYYY-MM-DD'), 30, 0, 12, 102, 54, 'Emmirates', 103);

-- Bundesliga
INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (204, 'Bayern', 'Munich', 'Bavaria', 'Berni Bear', TO_DATE('1944-06-17', 'YYYY-MM-DD'), 23, 7, 16, 76, 31, 'Allianz Arena', 104);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (205, 'Eintracht Frankfurt', 'Frankfurt am Main', 'Germany', 'Attila Eagle', TO_DATE('1958-01-22', 'YYYY-MM-DD'), 17, 8, 29, 34, 89, 'Deutsche Bank', 104);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (206, 'FC Koln', 'Cologne', 'Germany', 'Hennes Goat', TO_DATE('1968-10-10', 'YYYY-MM-DD'), 30, 0, 62, 65, 58, 'RheinEnergieSTADION', 104);

-- La Liga
INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (207, 'Real Madrid', 'Madrid', 'Spain', 'Bear', TO_DATE('1924-07-18', 'YYYY-MM-DD'), 57, 23, 23, 67, 67, 'Bernabeu Stadium', 102);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (208, 'Athletic Club', 'Bilbao', 'Spain', 'Lion', TO_DATE('1998-02-14', 'YYYY-MM-DD'), 34, 34, 34, 89, 34, 'San Mames', 102);

INSERT INTO Teams (team_id, team_name, city, country, team_mascot, year_founded, wins, draws, losses, goals_scored, goals_conceded, stadium, league_id) 
VALUES (209, 'Villarreal', 'Villareal', 'Spain', 'Groguet', TO_DATE('1971-04-01', 'YYYY-MM-DD'), 76, 32, 102, 150, 132, 'Estadide la Creamica', 102);



-- May make an object that allow both player and coach entity to inherit the general player attributes like player_id instead of repeating it in each create table function
CREATE TABLE Soccer_Player ( 
    player_id NUMBER PRIMARY KEY NOT NULL,
    person_name VARCHAR2(100) NOT NULL,
    nationality VARCHAR2(50) NOT NULL,
    yellow_cards NUMBER DEFAULT 0 CHECK(yellow_cards >= 0),
    red_cards NUMBER DEFAULT 0 CHECK(red_cards >= 0),

    -- These are soccer-player specific attributes
    jersey_number NUMBER(3) NOT NULL CHECK(jersey_number > 0 AND jersey_number < 100),
    player_position VARCHAR2(50),
    rating NUMBER(3) DEFAULT 1 CHECK (rating > 0 AND rating < 100),
    matches_played NUMBER DEFAULT 0 CHECK(matches_played >= 0),
    goals NUMBER DEFAULT 0 CHECK(goals >= 0),
    assists NUMBER DEFAULT 0 CHECK(assists >= 0),
    injuries NUMBER DEFAULT 0 CHECK(injuries >= 0),
    
    league_id NUMBER,
    team_id NUMBER,
    
    -- used to specify which league the player is in
    CONSTRAINT id_league_soccer
        FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
    
    -- used to specify which team the player is in
    CONSTRAINT id_team_soccer
        FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);	
SELECT * FROM Soccer_Player;

-- Premier League
INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (301, 'Mohamed Salah', 'Egypt', 1, 0, 11, 'Forward', 89, 5, 3, 6, 1, 103, 201);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (302, 'Virgil van Dijk', 'Netherlands', 3, 2, 4, 'Defender', 84, 12, 1, 7, 0, 103, 201);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (303, 'Cole Palmer', 'England', 0, 3, 10, 'Midfielder', 72, 20, 2, 12, 3, 103, 202);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (304, 'Gabriel Jesus', 'Brazil', 6, 0, 11, 'Forward', 64, 9, 6, 2, 1, 103, 203);

-- Bundesliga
INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (305, 'Harry Kane', 'England', 3, 1, 9, 'Forward', 93, 4, 3, 2, 0, 104, 204);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (306, 'Ritsu Doan', 'Japan', 0, 0, 10, 'Midfielder', 99, 21, 12, 11, 0, 104, 205);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (307, 'Michael Zetterer', 'Germany', 0, 5, 23, 'Forward', 56, 6, 0, 3, 1, 104, 205);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (308, 'Jeff Chabot', 'Germany', 0, 1, 24, 'Defender', 1, 0, 0, 0, 1, 104, 206);

-- La Liga
INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (309, 'Dean Huijsen', 'Netherlands', 4, 0, 24, 'Defender', 81, 3, 0, 1, 0, 102, 207);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (310, 'Alex Padilla', 'Spain', 11, 2, 66, 'Goalkeeper', 76, 12, 0, 15, 0, 102, 208);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (311, 'Juan Foyth', 'Netherlands', 1, 6, 99, 'Defender', 66, 8, 4, 13, 0, 102, 209);

INSERT INTO Soccer_Player (player_id, person_name, nationality, yellow_cards, red_cards, jersey_number, player_position, rating, matches_played, goals, assists, injuries, league_id, team_id) 
VALUES (312, 'Luiz Junior', 'Brazil', 0, 3, 69, 'Goalkeeper', 3, 20, 0, 12, 0, 102, 209);



CREATE TABLE Coaches ( 
    player_id NUMBER PRIMARY KEY NOT NULL,
    person_name VARCHAR2(100) NOT NULL,
    nationality VARCHAR2(50) NOT NULL,
    yellow_cards NUMBER DEFAULT 0 CHECK(yellow_cards >= 0),
    red_cards NUMBER DEFAULT 0 CHECK(red_cards >= 0),

    -- These are coach specific attributes
    role VARCHAR2(100) NOT NULL,
    preferred_formation VARCHAR2(100) NOT NULL,
    years_of_experience NUMBER DEFAULT 0 CHECK(years_of_experience >= 0),
    
    league_id NUMBER,
    team_id NUMBER,
    
    -- used to specify which league the player is in
    CONSTRAINT id_league_coach
        FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
    
    -- used to specify which team the player is in
    CONSTRAINT id_team_coach
        FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);	
SELECT * FROM Coaches;

-- Premier League
INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (401, 'Arne Slot', 'Netherlands', 5, 1, 'Head Coach', '4-2-3-1', 8, 103, 201);

INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (402, 'Willy Caballero', 'Argentina', 0, 3, 'Assistant Coach', '4-4-2', 3, 103, 202);

-- Bundesliga
INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (403, 'Vincent Kompany', 'Belgium', 2, 0, 'Head Coach', '4-2-3-1', 20, 104, 204);

INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (404, 'Hansi Flick', 'Germany', 6, 0, 'Technical Analyst', '4-3-3', 10, 104, 204);

-- La Liga
INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (405, 'Xabi Alonso', 'Spain', 0, 1, 'Head Coach', '3-4-2-1', 21, 102, 207);

INSERT INTO Coaches (player_id, person_name, nationality, yellow_cards, red_cards, role, preferred_formation, years_of_experience, league_id, team_id)
VALUES (406, 'Unai Emery', 'Spain', 0, 0, 'Assistant Coach', '5-3-2', 11, 102, 209);


CREATE TABLE Matches (
    match_id NUMBER PRIMARY KEY NOT NULL,
    season NUMBER DEFAULT 0 CHECK(season >= 0),
    match_date DATE,
    
    -- may have to make this conditional to 4 words (eg. scheduled, ongoing, cancelled, and completed)
    status VARCHAR2(50) NOT NULL,
    
    -- will be inherit from team table to display location of match
    stadium VARCHAR2(100) NOT NULL,
    
    home_score NUMBER DEFAULT 0 CHECK(home_score >= 0),
    away_score NUMBER DEFAULT 0 CHECK(away_score >= 0),
    
    league_id NUMBER,
    --team_id NUMBER, (might not need)
    
    home_team_id NUMBER NOT NULL,
    away_team_id NUMBER NOT NULL,
    
    -- used to specify which league the match take place in
    CONSTRAINT id_league_match
        FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
        
    -- will be used to specify which the away and home team
    CONSTRAINT fk_home_team 
      FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
      
    CONSTRAINT fk_away_team 
      FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
);


SELECT * FROM Matches;
INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(501,45, TO_DATE('2025-09-06 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Completed','Anfield',1,0,103, 201, 203);

INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(502,7, TO_DATE('2025-09-13 08:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Ongoing','Deutsche Bank',0,4,104, 205, 204);

INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(503,72, TO_DATE('2025-09-13 08:30:00', 'YYYY-MM-DD HH24:MI:SS'),'Completed','Bernabeu',2,2,102, 207, 208);

INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(504,39, TO_DATE('2025-12-12 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Cancelled','Stanford Bridge',0,0,103, 202, 201);

INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(505, 7, TO_DATE('2026-01-30 18:00:00', 'YYYY-MM-DD HH24:MI:SS'),'Scheduled', 'RheinEnergieSTADION', 0, 0, 104, 206, 205);

INSERT INTO Matches(match_id, season, match_date, status, stadium, home_score, away_score, league_id, home_team_id, away_team_id)
VALUES(506, 72, TO_DATE('2026-02-14 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Scheduled', 'Bernabeu', 0, 9,102, 207, 208);



CREATE TABLE Rankings (
    rank_position NUMBER PRIMARY KEY NOT NULL,
    matches_played NUMBER DEFAULT 0 CHECK(matches_played >= 0),
    
    league_id NUMBER,
    team_id NUMBER,
    
    -- will be used to specify the team
    CONSTRAINT id_team_rank
        FOREIGN KEY (team_id) REFERENCES Teams(team_id),   
    
    -- this will be used to get the league_id so that the ranking table league alongside a team
    CONSTRAINT id_league_rank
        FOREIGN KEY (league_id) REFERENCES Leagues(league_id),
    
    --This attribute will be derived from a team's number of wins, draws and losses
    points NUMBER DEFAULT 0 CHECK(points >= 0)
);

SELECT * FROM Rankings;

INSERT INTO Rankings(rank_position,matches_played,league_id,team_id,points)
VALUES(4,14,104,206,9);

INSERT INTO Rankings(rank_position,matches_played,league_id,team_id,points)
VALUES(5,16,102,208,10);

INSERT INTO Rankings(rank_position,matches_played,league_id,team_id,points)
VALUES(2,12,103,202,25);

INSERT INTO Rankings(rank_position,matches_played,league_id,team_id,points)
VALUES(3,11,103,201,15);

INSERT INTO Rankings(rank_position,matches_played,league_id,team_id,points)
VALUES(1,15,103,209,31);




-- Simple query (make 8 for A4 Part 1)
SELECT DISTINCT league_name FROM Leagues; -- find all the leagues unique names
SELECT league_name, average_player_rating FROM Leagues ORDER BY average_player_rating DESC; -- order average player rating in league in ascending order

-- Simple query for teams table
SELECT league_id, team_name, wins FROM Teams GROUP BY league_id, team_name,wins ORDER BY wins DESC; --orders all teams by the number of wins in descending order

--Simple query for soccer players
SELECT * FROM Soccer_Player WHERE red_cards = 0; -- find all players with 0 red cards
SELECT DISTINCT player_position FROM Soccer_Player; -- find all the unique player positions

--Simple query for Coaches
SELECT person_name,years_of_experience FROM (SELECT person_name,years_of_experience FROM Coaches ORDER BY years_of_experience DESC) r WHERE ROWNUM=1; --names the coach with the most experience

--Simple query for Matches
SELECT match_id, home_score, away_score,home_team_id, away_team_id FROM Matches WHERE home_score= away_score; --prints the matches that had a draw

----Simple query for Rankings
SELECT rank_position,team_id FROM Rankings WHERE rank_position=1; --gives the team at rank 1
SELECT rank_position,team_id, points FROM (SELECT rank_position,team_id, points FROM Rankings ORDER BY points ASC)r WHERE ROWNUM=1; --gives the team with the lowest points



-- ADVANCE JOIN QUERY(make 3 for A4 Part 2)

--JOIN for leagues and teams 
SELECT l.league_name, t.team_name, t.wins, t.draws, t.losses FROM Leagues l INNER JOIN Teams t ON l.league_id=t.league_id;

--JOIN for matches, teams and soccer_players
SELECT m.match_id,m.match_date, m.status, ht.team_name AS home_team, at.team_name AS away_team, hp.person_name AS HomeTeam_Player, ap.person_name AS AwayTeam_player
FROM Matches m 
INNER JOIN Teams ht ON m.home_team_id= ht.team_id
INNER JOIN Teams at ON m.away_team_id= at.team_id
INNER JOIN Soccer_Player hp ON ht.team_id= hp.team_id
INNER JOIN Soccer_Player ap ON at.team_id= ap.team_id
ORDER BY m.match_id;

--JOIN for teams, players and coaches 
SELECT t.team_name, c.person_name AS coach_name, c.role, p.person_name AS player_name,p.player_position FROM teams t INNER JOIN Coaches c ON t.team_id = c.team_id INNER JOIN Soccer_Player p ON t.team_id=p.team_id ORDER BY t.team_name, p.person_name;

--JOIN for rankings, teams and coaches
SELECT t.team_name,r.rank_position, r.matches_played, r.points,c.person_name, c.preferred_formation FROM teams t INNER JOIN Coaches c ON t.team_id= c.team_id INNER JOIN Rankings r ON t.team_id=r.team_id;



-- VIEWS: (make 3 for A4 Part 2)
-- View that gets all the netherland players existing in soccer_player table and orders them by goals in descending order
CREATE VIEW Netherlands_Players AS 
SELECT league_id, team_id, player_id, person_name, nationality, player_position, goals, assists
FROM Soccer_Player
WHERE nationality = 'Netherlands'
ORDER BY goals DESC;
SELECT * FROM Netherlands_Players; -- displays the netherlands_players view


-- view that gets all the matches that has been completed
CREATE VIEW Completed_Matches AS 
SELECT league_id, match_id, match_date, status, stadium, home_score, home_team_id, away_score, away_team_id
FROM Matches
WHERE status = 'Completed';
SELECT * FROM Completed_Matches;


--- Shows head coaches with more than five years of experience. 
CREATE VIEW Experienced_Head_Coach AS
SELECT PERSON_NAME, YEARS_OF_EXPERIENCE
FROM COACHES
WHERE YEARS_OF_EXPERIENCE > 5 AND ROLE = 'Head Coach';
SELECT * FROM Experienced_Head_Coach;



--A5

-- Interesting Queries
-- uses set-based keywords, EXISTS, UNION, MINUS and aggregate functions COUNT and 
-- least one of the statistics functions with appropriate GROUP BY, HAVING clauses to retrieve the records

-- QUERY 1: -- This query takes all coaches and players and gets all yellow cards by each country

SELECT NATIONALITY, SUM(YELLOW_CARDS)
FROM (
    SELECT NATIONALITY, YELLOW_CARDS
    FROM SOCCER_PLAYER
    UNION
    SELECT NATIONALITY, YELLOW_CARDS
    FROM COACHES
)
GROUP BY NATIONALITY;

-- QUERY 2: -- This query results in a list of players per league who have a rating higher than the average rating in their leagues
-- This results in only 2 players who in the Bundesliga are higher than their average rating

SELECT PERSON_NAME, RATING, SOCCER_PLAYER.LEAGUE_ID
FROM SOCCER_PLAYER
WHERE EXISTS (SELECT LEAGUES.LEAGUE_ID, LEAGUES.AVERAGE_PLAYER_RATING FROM LEAGUES WHERE SOCCER_PLAYER.LEAGUE_ID = LEAGUES.LEAGUE_ID AND SOCCER_PLAYER.RATING >= LEAGUES.AVERAGE_PLAYER_RATING);

-- QUERY 3: This query tells us how much goals are scored by players by positions.

SELECT COUNT(GOALS), PLAYER_POSITION
FROM SOCCER_PLAYER
GROUP BY PLAYER_POSITION
ORDER BY COUNT(GOALS);

-- QUERY 4: Finds all the teams where the players and coaches committed red card offences (removes all instances where players do but coaches do not)

SELECT TEAM_ID
FROM SOCCER_PLAYER
HAVING SUM(RED_CARDS) > 0
GROUP BY TEAM_ID

MINUS 

SELECT TEAM_ID
FROM COACHES
HAVING SUM(RED_CARDS) = 0
GROUP BY TEAM_ID;

-- QUERY 5: Advanced Query to find the most overperforming players: players who have scored more goals than assists but also more goals and assists on average

SELECT PERSON_NAME, NATIONALITY, GOALS, ASSISTS
FROM SOCCER_PLAYER
WHERE GOALS > ASSISTS AND GOALS >= (SELECT AVG(GOALS) FROM SOCCER_PLAYER) AND ASSISTS >= (SELECT AVG(ASSISTS) FROM SOCCER_PLAYER);

--Query 6: lists leagues that have at least one team with more than 50 wins and shows how many teams are in that league
SELECT l.league_name, COUNT(t.team_id) AS total_teams
FROM Leagues l
JOIN Teams t ON l.league_id = t.league_id
WHERE EXISTS (
    SELECT 1 
    FROM Teams t2 
    WHERE t2.league_id = l.league_id AND t2.wins > 50
)
GROUP BY l.league_name
HAVING COUNT(t.team_id) >= 1;




-- A6
-- List all functional dependencies including foreign keys
SELECT 
    -- Name of each table with primary key
    uc.table_name,
    
    -- Column for primary key to reside in
    ucc.column_name AS primary_key,
    
    -- Column for all the dependents
    LISTAGG(utc.column_name, ', ') WITHIN GROUP (ORDER BY utc.column_name) AS dependent_columns,
    
    -- Creates the funtional dependency format X -> Y
    ucc.column_name || ' -> ' || LISTAGG(utc.column_name, ', ') 
        WITHIN GROUP (ORDER BY utc.column_name) AS functional_dependency
        
    
-- Gets all the constraints made for every table
FROM user_constraints uc

-- Joins by the constraint name
JOIN user_cons_columns ucc 
    ON uc.constraint_name = ucc.constraint_name
    
-- Joins by the table name
JOIN user_tab_columns utc 
    ON utc.table_name = uc.table_name
    AND utc.column_name <> ucc.column_name
    
-- Only include priamry keys
WHERE uc.constraint_type = 'P'

-- Group by the table name and their attributes
GROUP BY uc.table_name, ucc.column_name
ORDER BY uc.table_name;

-- This does the same as the FD query before but list only foreign keys as funtional dependency:
SELECT 
    uc.table_name,
    ucc.column_name AS foreign_key,
    rcc.table_name AS referenced_table,
    rcc.column_name AS referenced_pk,
    ucc.column_name || ' -> ' || rcc.table_name || '.' || rcc.column_name AS functional_dependency
FROM user_constraints uc
JOIN user_cons_columns ucc 
    ON uc.constraint_name = ucc.constraint_name
JOIN user_constraints ruc 
    ON uc.r_constraint_name = ruc.constraint_name
JOIN user_cons_columns rcc 
    ON ruc.constraint_name = rcc.constraint_name
WHERE uc.constraint_type = 'R'
ORDER BY uc.table_name;


