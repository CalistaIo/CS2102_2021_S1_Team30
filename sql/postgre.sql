CREATE TABLE Categories (
	cat_name		VARCHAR(10) 	PRIMARY KEY, 
	base_price		NUMERIC
);

CREATE TABLE Owners(
	username		VARCHAR		PRIMARY KEY,
	first_name		NAME		NOT NULL,
	last_name		NAME		NOT NULL,
	password		VARCHAR(64)	NOT NULL, 
	email			VARCHAR		NOT NULL UNIQUE, 
	dob				DATE		NOT NULL, --check today - DOB >= 13 
	credit_card_no	VARCHAR		NOT NULL,
	unit_no			VARCHAR,
	postal_code		VARCHAR(6)	NOT NULL,
	reg_date		DATE		NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE ownsPets(
	username		VARCHAR		NOT NULL REFERENCES Owners(username) ON DELETE CASCADE, -- username of owner
	name 			NAME		NOT NULL, --name of pet
	description		TEXT, 
	cat_name		VARCHAR(10)	NOT NULL REFERENCES Categories(cat_name),
	size			VARCHAR		NOT NULL, 
	sociability		VARCHAR,
	special_req		VARCHAR,
	PRIMARY KEY (username, name)
);

CREATE TABLE Caretakers (
	username   	VARCHAR PRIMARY KEY,
	first_name 	VARCHAR NOT NULL,
	last_name  	VARCHAR NOT NULL,
	password   	VARCHAR(64) NOT NULL,
	email		VARCHAR NOT NULL UNIQUE CHECK(email LIKE '%@%.%'),
	credit_card_no	VARCHAR NOT NULL,
	DOB			DATE NOT NULL,
	postal_code	VARCHAR(6),
	unit_no		VARCHAR,
	reg_date		DATE NOT NULL DEFAULT CURRENT_DATE,
	is_full_time	BIT,
	avg_rating	FLOAT CHECK (avg_rating >= 0),
	no_of_reviews	INTEGER,
	no_of_pets_taken INTEGER
);

CREATE VIEW Users AS (
	SELECT username, password, first_name, last_name, email, dob, credit_card_no, unit_no, postal_code, reg_date FROM Owners
	UNION
	SELECT username, password, first_name, last_name, email, dob, credit_card_no, unit_no, postal_code, reg_date FROM Caretakers
);

CREATE TABLE isPaidSalaries (
	caretaker_id VARCHAR REFERENCES caretakers(username)
	ON DELETE cascade,
	year INTEGER,
	month INTEGER,
	salary_amount NUMERIC NOT NULL,
	PRIMARY KEY (caretaker_id, year, month)
);

CREATE TABLE Administrators (
	admin_id VARCHAR PRIMARY KEY,
	password VARCHAR(64) NOT NULL,
	last_login_time TIMESTAMP
);


-- INSERT categories
CREATE OR REPLACE PROCEDURE add_category(cat_name		VARCHAR(10), 
							  			 base_price		NUMERIC) AS
	$$ BEGIN
	   INSERT INTO Categories (cat_name, base_price) 
	   VALUES (cat_name, base_price);
	   END; $$
	LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE add_owner (username 		VARCHAR,
									   first_name		NAME,
									   last_name		NAME,
									   password			VARCHAR(64),
									   email			VARCHAR,
									   dob				DATE,
									   credit_card_no	VARCHAR,
									   unit_no			VARCHAR,
									   postal_code		VARCHAR(6)
									   ) AS
	$$ BEGIN
	   INSERT INTO Owners
	   VALUES (username, first_name, last_name, password, email, dob, credit_card_no, unit_no, postal_code, CURRENT_DATE);
	   END; $$
	LANGUAGE plpgsql;
	
CREATE OR REPLACE PROCEDURE add_pet (username			VARCHAR,
									 name 				NAME, 
									 description		VARCHAR, 
									 cat_name			VARCHAR(10),
									 size				VARCHAR, 
									 sociability		VARCHAR,
									 special_req		VARCHAR
									 ) AS
	$$ BEGIN
	   INSERT INTO ownsPets
	   VALUES (username, name, description, cat_name, size, sociability, special_req);
	   END; $$
	LANGUAGE plpgsql;
