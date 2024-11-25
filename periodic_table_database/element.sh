PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# If argument is an atomic number (integer)
if [[ $1 =~ ^[0-9]+$ ]]; then
  ATOMIC_NUMBER=$1
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $1")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $1")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $1")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $1")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $1")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $1")

# If argument is a symbol (1 or 2 capitalized letters)
elif [[ $1 =~ ^[A-Z][a-zA-Z]?$ ]]; then
  SYMBOL=$1
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

# If argument is a name (capitalized, 3 or more letters)
elif [[ $1 =~ ^[A-Z][a-zA-Z]{2,}$ ]]; then
  NAME=$1
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$1'")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")

# Handle invalid input
else
  echo "I could not find that element in the database."
  exit 0
fi

# If no result is found for any valid input
if [[ -z $NAME ]]; then
  echo "I could not find that element in the database."
else
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
