use mydb_pp;

show tables;


describe shelters;
describe pets;
describe donations;
describe participants;
describe adoption_events;

insert into shelters(shelter_id, shelter_name, shelter_location) values
(1, 'Dog Shelter', 'Chennai'),
(2, 'Cat Shelter', 'Bhopal'),
(3, 'Lion Shelter', 'Delhi');

select * from shelters;

insert into pets(pet_name, pet_age, pet_breed, pet_type, pet_available_for_adoption, shelter_id) values
('Dogeshwar', 5, 'Labra', 'Dog', 1, 1),
('Kitten', 2, 'Dontknow', 'Cat', 0, 2),
('Sher', 10, 'Big Cats', 'Cat', 1, 3);

select * from pets;

insert into donations(donation_name, donation_type, donation_amount, donation_item, donation_date, shelter_id) values
('Ankit', 'cash', 100000, '', '2024-04-13', 3),
('Aman', 'cash', 100, '', '2024-04-10', 2),
('Abhishek', 'item', 0, 'dog food', '2024-04-10', 1),
('Abhi', 'cash', 11, '', '2024-04-10', 2);

select * from donations;

insert into adoption_events(event_name, event_date, event_location, shelter_id) values
('PQR Event', '2024-03-13', 'Chennai', 1),
('ABC Event', '2024-03-13', 'Bhopal', 2),
('XYZ Event', '2024-03-13', 'Chennai', 1);

select * from adoption_events;

insert into participants(participants_name, participants_type, event_id) values
('Ankit', 'Adopter', 1),
('Aman', 'Adopter', 1),
('Dog Shelter', 'Shelter', 2);

select * from participants;


/*
1. Provide a SQL script that initializes the database for the Pet Adoption Platform "PetPals"
2. Create tables for pets, shelters, donations, adoption events, and participants.
3. Define appropriate primary keys, foreign keys, and constraints.
4. Ensure the script handles potential errors, such as if the database or tables already exist.
*/
-- MySQL Workbench Forward Engineering

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb_pp` DEFAULT CHARACTER SET utf8 ;
USE `mydb_pp` ;

-- -----------------------------------------------------
-- Table `mydb`.`shelters`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_pp`.`shelters` (
  `shelter_id` INT NOT NULL,
  `shelter_name` VARCHAR(255) NOT NULL,
  `shelter_location` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`shelter_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pets`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_pp`.`pets` (
  `pet_id` INT NOT NULL AUTO_INCREMENT,
  `pet_name` VARCHAR(255) NOT NULL,
  `pet_age` INT NOT NULL,
  `pet_breed` VARCHAR(255) NOT NULL,
  `pet_type` VARCHAR(255) NOT NULL,
  `pet_available_for_adoption` BIT(2) NOT NULL,
  `shelter_id` INT NOT NULL,
  PRIMARY KEY (`pet_id`),
  INDEX `fk_pets_shelters1_idx` (`shelter_id` ASC) ,
  CONSTRAINT `fk_pets_shelters1`
    FOREIGN KEY (`shelter_id`)
    REFERENCES `mydb_pp`.`shelters` (`shelter_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`donations`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_pp`.`donations` (
  `donation_id` INT NOT NULL AUTO_INCREMENT,
  `donation_name` VARCHAR(255) NOT NULL,
  `donation_type` VARCHAR(255) NOT NULL,
  `donation_amount` DOUBLE NOT NULL,
  `donation_item` VARCHAR(255) NOT NULL,
  `donation_date` DATE NOT NULL,
  `shelter_id` INT NOT NULL,
  PRIMARY KEY (`donation_id`),
  INDEX `fk_donations_shelters1_idx` (`shelter_id` ASC) ,
  CONSTRAINT `fk_donations_shelters1`
    FOREIGN KEY (`shelter_id`)
    REFERENCES `mydb_pp`.`shelters` (`shelter_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`adoption_events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_pp`.`adoption_events` (
  `event_id` INT NOT NULL AUTO_INCREMENT,
  `event_name` VARCHAR(255) NOT NULL,
  `event_date` DATE NOT NULL,
  `event_location` VARCHAR(255) NOT NULL,
  `shelter_id` INT NOT NULL,
  PRIMARY KEY (`event_id`),
  INDEX `fk_adoption_events_shelters1_idx` (`shelter_id` ASC) ,
  CONSTRAINT `fk_adoption_events_shelters1`
    FOREIGN KEY (`shelter_id`)
    REFERENCES `mydb_pp`.`shelters` (`shelter_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`participants`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb_pp`.`participants` (
  `participants_id` INT NOT NULL AUTO_INCREMENT,
  `participants_name` VARCHAR(255) NOT NULL,
  `participants_type` VARCHAR(255) NOT NULL,
  `event_id` INT NOT NULL,
  PRIMARY KEY (`participants_id`),
  INDEX `fk_participants_adoption_events_idx` (`event_id` ASC) ,
  CONSTRAINT `fk_participants_adoption_events`
    FOREIGN KEY (`event_id`)
    REFERENCES `mydb_pp`.`adoption_events` (`event_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);





-- 5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) 
-- from the "Pets" table. Include the pet's name, age, breed, and type in the result set. 
-- Ensure that the query filters out pets that are not available for adoption.
select pet_name, pet_age, pet_breed, pet_type
from pets
where pet_available_for_adoption = 1;
/* output
'Dogeshwar','5','Labra','Dog'
'Sher','10','Big Cats','Cat'
*/


-- 6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a 
-- specific adoption event. Use a parameter to specify the event ID. Ensure that the query joins the necessary
--  tables to retrieve the participant names and types.
select participants_name, participants_type, ae.event_id
from participants p 
join adoption_events ae on p.event_id = ae.event_id 
where ae.event_name = 'PQR Event';
/* output
'Ankit','Adopter','1'
'Aman','Adopter','1'
*/


-- 7. Create a stored procedure in SQL that allows a shelter to update its information (name and location) in 
-- the "Shelters" table. Use parameters to pass the shelter ID and the new information.
-- Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID.
update shelters
set shelter_name = 'Dog_Shelter',
shelter_location = 'Chennai'
where shelter_id = 1;



-- 8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) 
-- from the "Donations" table. The result should include the shelter name and the total donation amount. 
-- Ensure that the query handles cases where a shelter has received no donations.
select s.shelter_name, sum(donation_amount)
from shelters s
left join donations d on s.shelter_id = d.shelter_id
group by s.shelter_name;
/* output
'Dog Shelter','0'
'Cat Shelter','100'
'Lion Shelter','100000'
*/

-- 9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner 
-- (i.e., where "OwnerlD" is null). Include the pet's name, age, breed, and type in the result set.
select pet_name, pet_age, pet_breed, pet_type
from pets
where pet_available_for_adoption = 1;
/* output
'Dogeshwar','5','Labra','Dog'
'Sher','10','Big Cats','Cat'
*/


-- 10. Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) 
-- from the "Donations" table. The result should include the month-year and the corresponding total donation amount. 
-- Ensure that the query handles cases where no donations were made in a specific month-year.
select donation_date, sum(donation_amount) as Total_Donation
from donations
group by donation_date;
/* output
'2024-04-13','100000'
'2024-04-10','100'
*/

-- 11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
select distinct pet_breed
from pets
where pet_age between 1 and 3
OR pet_age > 5;
/* output
'Dontknow'
'Big Cats'
*/


-- 12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.
select p.*, s.shelter_name
from pets p
join shelters s on p.shelter_id = s.shelter_id
where pet_available_for_adoption = 1;
/* output
'1','Dogeshwar','5','Labra','Dog','1','1','Dog Shelter'
'3','Sher','10','Big Cats','Cat','1','3','Lion Shelter'
*/


-- 13. Find the total number of participants in events organized by shelters located in specific city.
-- Example: City=Chennai
select ae.event_id, count(*) as total_participants, shelter_location
from participants p
join adoption_events ae on ae.event_id = p.event_id
join shelters s on s.shelter_id = ae.shelter_id
where shelter_location = 'Chennai'
group by ae.event_id;
/* output
'1','2','Chennai'
*/


-- 14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select distinct pet_breed
from pets
where pet_age between 1 and 5;
/* output
'Labra'
'Dontknow'
*/


-- 15. Find the pets that have not been adopted by selecting their information from the 'Pet' table.
select *
from pets
where pet_available_for_adoption = 1;
/* output
'1','Dogeshwar','5','Labra','Dog','1','1'
'3','Sher','10','Big Cats','Cat','1','3'
*/


-- 16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.
select *
from pets
where pet_available_for_adoption = 0;
/* output - User table not present
'2','Kitten','2','Dontknow','Cat','0','2'
*/


-- 17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter.
select s.shelter_id, count(*) as Adoption_Available
from shelters s
left join pets p on p.shelter_id = s.shelter_id
where pet_available_for_adoption = 1
group by s.shelter_id;
/* output
'1','1'
'3','1'
*/


-- 18. Find pairs of pets from the same shelter that have the same breed.
select *
from shelters s
left join pets p on p.shelter_id = s.shelter_id;
/* output
'1','Labra'
'2','Dontknow'
'3','Big Cats'
*/


-- 19. List all possible combinations of shelters and adoption events.
(select *
from shelters s
left join adoption_events ae on s.shelter_id = ae.shelter_id)
union
(select *
from shelters s
right join adoption_events ae on s.shelter_id = ae.shelter_id);
/* output
'1','Dog Shelter','Chennai','3','XYZ Event','2024-03-13','Chennai','1'
'1','Dog Shelter','Chennai','1','PQR Event','2024-03-13','Chennai','1'
'2','Cat Shelter','Bhopal','2','ABC Event','2024-03-13','Bhopal','2'
'3','Lion Shelter','Delhi',NULL,NULL,NULL,NULL,NULL
*/


-- 20. Determine the shelter that has the highest number of adopted pets.
select s.shelter_id, s.shelter_name, count(*) as Count_Of_Pets
from shelters s
join pets p on p.shelter_id = s.shelter_id
where pet_available_for_adoption = 0
group by s.shelter_id
order by Count_of_Pets desc;
/* output
'2','Cat Shelter','1'
*/
