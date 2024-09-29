# Neccesary for running any PostgreSQL query in this script
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align -tc"

# Checking if we have a command line argument
if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else

SELECTED_ATOMIC_NUMBER=""

# Querrying the DB for data
  if [[ $1 =~ [1-9][0-9]* ]]
  then
    DB_QUERY_RESULT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    
    if [[ ! -z $DB_QUERY_RESULT_ATOMIC_NUMBER ]]
    then
      SELECTED_ATOMIC_NUMBER=$DB_QUERY_RESULT_ATOMIC_NUMBER
    fi

  else
    DB_QUERY_RESULT_SYMBOL=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    DB_QUERY_RESULT_NAME=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")

    if [[ ! -z $DB_QUERY_RESULT_SYMBOL ]]
    then
      SELECTED_ATOMIC_NUMBER=$DB_QUERY_RESULT_SYMBOL
    
    elif [[ ! -z $DB_QUERY_RESULT_NAME ]]
    then
      SELECTED_ATOMIC_NUMBER=$DB_QUERY_RESULT_NAME
    fi

  fi

# Verifying that we actually have the specific element
  if [[ -z $SELECTED_ATOMIC_NUMBER ]]
  then
    echo I could not find that element in the database.
  else
    AVAILABLE_DATA=$($PSQL "SELECT elements.atomic_number, elements.name, elements.symbol, types.type, 
    properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius 
    FROM elements FULL JOIN properties ON elements.atomic_number = properties.atomic_number 
    FULL JOIN types ON properties.type_id = types.type_id 
    WHERE elements.atomic_number=$SELECTED_ATOMIC_NUMBER;")

    # Reading data into variables for the desired output
    echo $AVAILABLE_DATA | while IFS="|" read ATOMIC_NUM  NAME  SYMBOL  TYPE  ATOMIC_MASS  MELTING_POINT  BOILING_POINT 
    do
      echo The element with atomic number $ATOMIC_NUM is $NAME '('$SYMBOL')'. It\'s a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius.
    done

  fi  

fi
# That's it guys, thank you.