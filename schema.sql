CREATE DATABASE vet_clinic;

CREATE TABLE animals(
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	date_of_birth DATE NOT NULL,
	escape_attempts INT,
	neutered BOOLEAN,
	weight_kg DECIMAL(6, 2)
);

ALTER TABLE animals ADD COLUMN species VARCHAR(50);

CREATE TABLE owners(
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(50) NOT NULL,
  age INT 
);

CREATE TABLE species(
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50)
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD COLUMN species_id INT;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD COLUMN owner_id INT;
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets(
   id SERIAL PRIMARY KEY,
   name VARCHAR(255),
   age INTEGER,
   date_of_graduation DATE
);


CREATE TABLE specializations (
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id),
  PRIMARY KEY (vet_id, species_id)
);

CREATE TABLE visits (
  animal_id INTEGER REFERENCES animals(id),
  vet_id INTEGER REFERENCES vets(id),
  visit_date DATE,
  PRIMARY KEY (animal_id, vet_id, visit_date)
);