# ----- SETUP -----

# Exit if any command fails
#set -e

#Go back to main Fuse directory
cd ..

# Build program
make
sudo make install

# Create directories for testing
#mkdir bd_test/
#mkdir mp_test/

# Mount directory
#ntapfuse mount bd_test/ mp_test/

# Enter mountpoint directory
#cd mp_test/

# Notify user
echo
echo
echo " --- Setup successful, starting test suite... ---"
echo 
echo
sleep .5

#########################################################################
### SET-UP ##############################################################
#########################################################################

# Create directories for testing
[ ! -d bd_test/ ] && mkdir bd_test/;
[ ! -d mp_test/ ] && mkdir mp_test/;


# Mount directory
ntapfuse mount bd_test/ mp_test/ -o allow_other

#Test make sure bd_test was created
if [ -d bd_test/ ];
then
    #echo ""
    #echo "bd_test CREATED"
    :
else
    echo "bd_test CREATION FAILURE"
fi

#Test make sure mp_test was created
if [ -d mp_test/ ];
then
    #echo "mp_test CREATED"
    #echo ""
    :
else
    echo "mp_test CREATION FAILURE"
fi


# Enter mountpoint directory
cd mp_test/
# -------------------- TESTS GO HERE ------------------------
################################################################################################
### TEST 9 - utime: set the access and modification times of the specified files ###############
################################################################################################

echo "################################################################################################
### TEST 9 - utime: set the access and modification times of the specified files ###############
################################################################################################"

#################################################### CREATE FILE ######################################################
echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

numbers_size=$(stat --format=%s "numbers")
numbers_user=$(stat -c '%u' "numbers")
numbers_test_str="${numbers_user} ${numbers_size} 4096"


dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 9_0 SUCCEEDED"
    :
else
    echo "TEST 9_0 FAILED"
    :
fi

<<'COMMENT'
COMMENT

first_access_time=$(stat --format=%X "numbers")
first_modify_time=$(stat --format=%Y "numbers")
first_status_change_time=$(stat --format=%Z "numbers")


#############################################################################################################
access_time=1
modify_time=2

utime $access_time $modify_time numbers

last_access_time=$(stat --format=%X "numbers")
last_modify_time=$(stat --format=%Y "numbers")
last_status_change_time=$(stat --format=%Z "numbers")


if [[ "$last_access_time" == "$access_time" ]] 
then
    echo "TEST 9_1 SUCCEEDED"
    :
else
    echo "TEST 9_1 FAILED"
    :
fi

if [[ "$last_modify_time" == "$modify_time" ]] 
then
    echo "TEST 9_2 SUCCEEDED"
    :
else
    echo "TEST 9_2 FAILED"
    :
fi


if [[ "$last_status_change_time" == "$first_status_change_time" ]] 
then
    echo "TEST 9_3 SUCCEEDED"
    :
else
    echo "TEST 9_3 FAILED"
    :
fi

# -------------------- TESTS END HERE -----------------------
rm numbers
rm db
echo ""


# -------------------- CLEAN --------------------------------
echo ""
echo "--------------- CLEAN ---------------"
echo ""

cd ..

# Unmount directory
sudo umount mp_test/

# Remove test directories
rm -rf bd_test/
rm -rf mp_test/