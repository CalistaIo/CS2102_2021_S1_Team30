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
	unit_no			VARCHAR,
	postal_code		VARCHAR(6)	NOT NULL,
	credit_card_no	VARCHAR		NOT NULL,
	reg_date		DATE		NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE ownsPets(
	pet_id			VARCHAR		PRIMARY KEY,
	username		VARCHAR		NOT NULL REFERENCES Owners(username) ON DELETE CASCADE,
	name 			NAME		NOT NULL, 
	description		TEXT, 
	cat_name		VARCHAR(10)	NOT NULL REFERENCES Categories(cat_name),
	size			VARCHAR		NOT NULL, 
	sociability		VARCHAR,
	special_req		VARCHAR, 	
	img				BYTEA		NOT NULL
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
									   unit_no			VARCHAR,
									   postal_code		VARCHAR(6),
									   credit_card_no	VARCHAR) AS
	$$ BEGIN
	   INSERT INTO Owners(username, first_name, last_name, password, email, dob, unit_no, postal_code, credit_card_no, reg_date)
	   VALUES (username, first_name, last_name, password, email, dob, unit_no, postal_code, credit_card_no, CURRENT_DATE);
	   END; $$
	LANGUAGE plpgsql;
	
CREATE OR REPLACE PROCEDURE add_pet (pet_id				VARCHAR,
									 username			VARCHAR,
									 name 				NAME, 
									 description		VARCHAR, 
									 cat_name			VARCHAR(10),
									 size				VARCHAR, 
									 sociability		VARCHAR,
									 special_req		VARCHAR,
									 img				BYTEA) AS
	$$ BEGIN
	   INSERT INTO ownsPets (pet_id, username, name, description, cat_name, size, sociability, special_req, img)
	   VALUES (pet_id, username, name, description, cat_name, size, sociability, special_req, BYTEA(img));
	   END; $$
	LANGUAGE plpgsql;
