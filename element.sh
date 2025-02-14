#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# when no input
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."

# if there's input
else
  # INPUT=$1
  if [[ ! $1 =~ ^[0-9]+$ ]]
  then
    FIND_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol ILIKE '$1' OR name ILIKE '$1'")
  else
    FIND_ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
  fi

  if [[ -z $FIND_ELEMENT ]]
  then
    echo -e "I could not find that element in the database."
  else
    echo "$FIND_ELEMENT" | while IFS="|" read -r ATOM_NUM NAME SYMBOL TYPE MASS MELT_PNT BOIL_PNT
    do
      echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_PNT celsius and a boiling point of $BOIL_PNT celsius."
    done
  fi
  
fi

