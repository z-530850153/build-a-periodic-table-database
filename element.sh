#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 != *[^0-9]* ]]
  then
    atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
  else
    atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' or name='$1'")
  fi
  if [[ -n $atomic_number ]]
  then
    content=$($PSQL "SELECT * FROM elements join properties on elements.atomic_number=properties.atomic_number join types on properties.type_id=types.type_id WHERE properties.atomic_number='$atomic_number'")
    echo $content | while IFS='|' read atomic_number symbol name atomic_number atomic_mass melting_point_celsius boiling_point_celsius type_id type_id type
    do
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    done
  else
    echo I could not find that element in the database.
  fi
fi
