BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
UPDATE animals SET species = 'digimon'
WHERE name LIKE '%mon';
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SAVEPOINT save_point;
UPDATE animals SET weight_kg = weight_kg * -1;
ROLLBACK TO save_point;
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

--How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

--average weight of animals?
SELECT AVG(weight_kg) FROM animals;

--Who escapes the most, neutered or not neutered animals?
SELECT neutered, AVG(escape_attempts) as average_escapes
FROM animals
GROUP BY neutered
ORDER BY average_escapes DESC
LIMIT 1;

-- minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

-- average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth >= '1990-01-01' AND date_of_birth <= '2000-12-31'
GROUP BY species;

-- animals belonging to Melody Pond
SELECT name FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- all animals that are pokemon
SELECT animals.name FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- all owners and their animals.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id;

--animals per species
SELECT species.name, COUNT(animals.id) as count
FROM species
LEFT JOIN animals ON species.id = animals.species_id
GROUP BY species.id;

-- all Digimon owned by Jennifer Orwell
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

--all animals owned by Dean Winchester that haven't tried to escape
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE escape_attempts = 0 AND owners.full_name = 'Dean Winchester'

--most animals
SELECT owners.full_name, COUNT(animals.id) as count
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id
GROUP BY owners.id
ORDER BY count DESC
LIMIT 1;


--last animal seen by William Tacher
SELECT * FROM animals
JOIN visits v ON animals.id = v.animal_id
JOIN vets vet ON vet.id = v.vet_id
WHERE vet.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- many different animals did Stephanie Mendez see
SELECT COUNT(DISTINCT a.id) as no_animals
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vet ON vet.id = v.vet_id
WHERE vet.name = 'Stephanie Mendez';

-- all vets and their specialties, including vets with no specialties
SELECT vet.name, COALESCE(GROUP_CONCAT(s.name), 'none') AS specialties
FROM vets vet
LEFT JOIN specializations sp ON vet.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id
GROUP BY vet.id;


-- all animals that visited Stephanie Mendez between April 1st and August 30th, 2020
SELECT * FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vet ON vet.id = v.vet_id
WHERE vet.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- animal has the most visits to vets
SELECT a.name, COUNT(v.visit_date) as no_visits
FROM animals a
JOIN visits v ON a.id = v.animal_id
GROUP BY a.id
ORDER BY no_visits DESC
LIMIT 1;


--  Maisy Smith's first visit
SELECT a.name, v.visit_date
FROM visits v
INNER JOIN animals a ON v.animal_id = a.id
WHERE v.vet_id IN (SELECT id FROM vets WHERE name = 'Maisy Smith')
ORDER BY v.visit_date ASC
LIMIT 1;


-- Details for most recent visit: animal information, vet information, and date of visit
SELECT a.name AS animal_name, vet.name AS vet_name, v.visit_date
FROM animals a
INNER JOIN visits v ON a.id = v.animal_id
INNER JOIN vets vet ON v.vet_id = vet.id
WHERE v.visit_date = (SELECT MAX(visit_date) FROM visits);


--How many visits were with a vet that did not specialize in that animal's species
SELECT COUNT(*) AS no_visits
FROM visits v
INNER JOIN vets vet ON v.vet_id = vet.id
INNER JOIN animals a ON v.animal_id = a.id
LEFT JOIN specializations sp ON vet.id = sp.vet_id AND a.species_id = sp.species_id
WHERE sp.species_id IS NULL;


--specialty should Maisy Smith consider getting
SELECT s.name
FROM animals a
INNER JOIN visits v ON a.id = v.animal_id
INNER JOIN species s ON a.species_id = s.id
WHERE v.vet_id IN (SELECT id FROM vets WHERE name LIKE '%Maisy Smith%')
GROUP BY s.id
ORDER BY COUNT(*) DESC
LIMIT 1;
