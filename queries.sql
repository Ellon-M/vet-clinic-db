--all animals whose name ends in "mon"
SELECT * FROM animals
WHERE name LIKE '%mon';

--name of all animals born between 2016 and 2019
SELECT name FROM animals
WHERE date_of_birth >= '20160101' AND date_of_birth < '20191212';

--name of all animals that are neutered and have less than 3 escape attempts
SELECT name FROM animals
WHERE neutered = TRUE AND escape_attempts < 3;

--date of birth of all animals named either "Agumon" or "Pikachu"
SELECT date_of_birth FROM animals
WHERE name = 'Agumon' || 'Pikachu';

--name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

--animals that are neutered
SELECT * FROM animals
WHERE neutered = TRUE;

--animals not named Gabumon
SELECT * from animals
WHERE name != 'Gabumon';

--all animals with a weight between 10.4kg and 17.3kg
SELECT * FROM animals
WHERE weight_kg >= 10.4 AND weight_kg <= 17.3;