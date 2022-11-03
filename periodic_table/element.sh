#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [ $# -eq 0 ]
then 
  echo "Please provide an element as an argument."
else
  if [[ "$1" =~ ^[0-9]+$ ]] 
  then  
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius \
    FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number=$1")
  elif [ ${#1} -le 2 ]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius \
    FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol='$1'")
  else
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius \
    FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE name='$1'")  
  fi

  if ! [[ -z $ELEMENT_INFO ]]
  then
    echo "$ELEMENT_INFO" | while read A_C BAR NAME BAR SYMBOL BAR TYPE BAR A_M BAR MP BAR BP
    do
      echo "The element with atomic number $A_C is $NAME ($SYMBOL). It's a $TYPE, with a mass of $A_M amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  else
    echo "I could not find that element in the database."
  fi
fi


# ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;
# ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;
# ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;
# ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;
# ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;
# ALTER TABLE elements ADD CONSTRAINT elements_symbol_key UNIQUE(symbol);
# ALTER TABLE elements ADD CONSTRAINT elements_name_key UNIQUE(name);
# ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;
# ALTER TABLE elements ALTER COLUMN name SET NOT NULL;
# ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);

# CREATE TABLE types(type_id INT PRIMARY KEY,
#                    type VARCHAR(50) NOT NULL
#                    );
                   
# INSERT INTO types(type_id, type) VALUES (1, 'nonmetal'), (2, 'metal'), (3, 'metalloid');
# ALTER TABLE properties ADD COLUMN type_id INT; 
# UPDATE properties SET type_id = types.type_id FROM types WHERE properties.type = types.type;
# ALTER TABLE properties ADD FOREIGN KEY (type_id) REFERENCES types(type_id);
# ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL; 

# UPDATE elements SET symbol = 'He' where atomic_number = 2;
# UPDATE elements SET symbol = 'Li' where atomic_number = 3;
# UPDATE elements SET symbol = 'MT' where atomic_number = 1000;

# ALTER TABLE properties ALTER COLUMN atomic_mass TYPE decimal USING atomic_mass::decimal;
# UPDATE properties SET atomic_mass=TRIM(TRAILING '0' FROM CAST(atomic_mass AS TEXT))::DECIMAL;

# INSERT INTO elements( atomic_number, symbol, name) VALUES (9, 'F', 'Fluorine'), (10, 'Ne', 'Neon');  
# INSERT INTO properties(atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id) VALUES (9, 'nonmetal', 18.998, -220, -188.1, 1), (10, 'nonmetal', 20.18, -248.6, -246.1, 1);
