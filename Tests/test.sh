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

#CALL BETWEEN TESTS
#sudo umount mp_test/
#rm -rf bd_test/ mp_test/
#mkdir bd_test/
#mkdir mp_test/
#sudo ntapfuse mount bd_test/ mp_test/ -o allow_other

# Enter mountpoint directory
#cd mp_test/

# Set up environment variable for initial tests
export SLEEP_TIME=0

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
mkdir bd_test/
mkdir mp_test/

# Mount directory
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other

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

#########################################################################
### TEST 1 - CREATE FILE USING ECHO - NO DATABSE PRESENT ################
#########################################################################

echo ""
echo "########################################################################
### TEST 1 - CREATE FILE USING ECHO - NO DB PRESENT ####################
########################################################################"

#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

#echo $expected
#echo $actual

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 1 SUCCEEDED"
else
    echo "TEST 1 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""


#########################################################################
### TEST 2 - APPENDING TO EXISTING FILE #################################
#########################################################################

echo ""
echo "########################################################################
### TEST 2 - APPENDING TO EXISTING FILE ################################
########################################################################"


#################################################### CREATE FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### APPEND TO FILE ######################################################

echo "0987654321" >> numbers

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"
#cat db

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 2 SUCCEEDED"
    :
else
    echo "TEST 2 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 3 - CREATING TWO DIFFERENT FILES WITH SAME USER ################
#########################################################################

echo ""
echo "########################################################################
### TEST 3 - CREATING TWO DIFFERENT FILES WITH SAME USER ###############
########################################################################"


#################################################### CREATE 1ST FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### CREATE 2ND FILE ######################################################

#echo "1:    Creating numbers file"
echo "ABCDEFGHIJKLMNOPQRSTUVWXYZ" > letters

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

letters_size=$(stat --format=%s "letters")
#echo "DISPLAYING TESTFILE SIZE"
#echo $letters_size

letters_user=$(stat -c '%u' "letters")
#echo $numbers_user

if [[ "$letters_user" == "$numbers_user" ]] 
then
    #echo "TEST 1 SUCCEEDED"
    :
else
    echo "LETTERS AND NUMBERS USERS ARE NOT EQUAL"
fi

updated_size=$(($letters_size + $numbers_size))

test_str="${letters_user} ${updated_size} 4100"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 3 SUCCEEDED"
    :
else
    echo "TEST 3 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 4 - REMOVING THE ONLY FILE  ####################################
#########################################################################

echo ""
echo "########################################################################
### TEST 4 - REMOVING THE ONLY FILE ####################################
########################################################################"


#################################################### CREATE FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### REMOVE FILE ######################################################

rm numbers

numbers_test_str="${numbers_user} 0 4100"
dbfile="$(cat db)"

#echo "$numbers_test_str"
#echo "$dbfile"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 4 SUCCEEDED"
    :
else
    echo "TEST 4 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 5 - CREATING MULTIPLE FILES AND REMOVING ONE ###################
#########################################################################

echo ""
echo "########################################################################
### TEST 5 - CREATING MULTIPLE FILES AND REMOVING ONE ##################
########################################################################"


#################################################### CREATE 1ST FILE ######################################################
#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

#echo "$numbers_test_str"
#echo "$dbfile"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FIRST FILE WRITE FAILED"
fi

#################################################### CREATE 2ND FILE ######################################################

#echo "1:    Creating numbers file"
echo "ABCDEFGHIJKLMNOPQRSTUVWXYZ" > letters

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

letters_size=$(stat --format=%s "letters")
#echo "DISPLAYING TESTFILE SIZE"
#echo $letters_size

letters_user=$(stat -c '%u' "letters")
#echo $numbers_user

if [[ "$letters_user" == "$numbers_user" ]] 
then
    #echo "TEST 1 SUCCEEDED"
    :
else
    echo "LETTERS AND NUMBERS USERS ARE NOT EQUAL"
fi

updated_size=$(($letters_size + $numbers_size))

test_str="${letters_user} ${updated_size} 4100"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "db FILE NOT UPDATED FOR SECOND FILE CREATION"
fi

#################################################### REMOVE 1ST FILE ######################################################

rm numbers

updated_size=$(($updated_size - $numbers_size))

test_str="${letters_user} ${updated_size} 4100"
dbfile="$(cat db)"

#echo "$test_str"
#echo "$dbfile"

expected=$(echo $test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 5 SUCCEEDED"
    :
else
    echo "TEST 5 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 6 - ECHO MULTIPLE FILES WITH DIFFERENT USERS ###############
#########################################################################

echo ""
echo "########################################################################
### TEST 6 - ECHO MULTIPLE FILES WITH DIFFERENT USERS ##################
########################################################################"

#################################################### CREATE FIRST FILE WITH ROOT ######################################################

#echo "1:    Creating numbers file"
echo "1234567812345678123456781234567812345678123456781234567812345678" > numbers

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "DB FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "numbers")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "numbers")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 4100"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    #echo "TEST 6 SUCCEEDED"
    :
else
    #echo "TEST 6 FAILED"
    :
fi

#################################################### CREATE ANOTHER USER  ######################################################

#Create the user to be used in the test
sudo useradd -m -p Password -G sudo testuser

#Traverse back to the testscripts file
cd ..
cd Tests

#################################################### CREATE SECOND FILE ######################################################

#Make the script to be executed by the testuser executable
chmod +x test6_testuser.sh

#Make testuser execute script for this test.
sudo -u testuser ./test6_testuser.sh

#Traverse back to the mountpoint
cd ..
cd mp_test

#cd aiphngbspio

#################################################### TEST THE OTHER FILE ######################################################

#Get the expected size of the testuser's file
hello_testuser_size=$(stat --format=%s "hello_testuser")

#Get the user of the testuser's file
hello_testuser_user=$(stat -c '%u' "hello_testuser")

test6_expected="${numbers_test_str} ${hello_testuser_user} ${hello_testuser_size} 4100"


test6_actual="$(cat db)"

expected=$(echo $test6_expected)
actual=$(echo $test6_actual)

#echo $expected
#echo $actual

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 6 SUCCEEDED"
else
    echo "TEST 6 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 7 - TOUCH TO MAKE EMPTY FILE ###################################
#########################################################################

echo ""
echo "########################################################################
### TEST 7 - TOUCH TO MAKE EMPTY FILE ##################################
########################################################################"

#Doing this because creating an empty file should have file size of 0

touch empty 

test7_user=$(stat -c '%u' "empty")
test7_size=$(stat --format=%s "empty")

if [[ "$test7_size" == "0" ]]
then
    echo "FILESIZE == 0"
else
    echo "PROBLEM: FILESIZE != 0"
fi

test7_expected="${test7_user} ${test7_size} 4100"
test7_actual="$(cat db)"

expected=$(echo $test7_expected)
actual=$(echo $test7_actual)

#echo $expected
#echo $actual


if [[ "$expected" == "$actual" ]]
then
    echo "TEST 7 SUCCEEDED"
else
    echo "TEST 7 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 8 - DELETING THE DB FILE #######################################
#########################################################################

echo ""
echo "########################################################################
### TEST 8 - DELETING THE DB FILE ######################################
########################################################################"

touch empty

test8_expected="$(cat db)"

rm db
rm -rf db

test8_actual="$(cat db)"

expected=$(echo $test8_expected)
actual=$(echo $test8_actual)

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 8 SUCCEEDED"
else
    echo "TEST 8 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 9 - MAKING A DIRECTORY #########################################
#########################################################################

echo ""
echo "########################################################################
### TEST 9 - MAKING A DIRECTORY ########################################
########################################################################"

mkdir folder

test9_user=$(stat -c '%u' "folder")
test9_size=$(stat --format=%s "folder")

test9_expected="${test9_user} ${test9_size} 4100"
test9_actual="$(cat db)"

expected=$(echo $test9_expected)
actual=$(echo $test9_actual)

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 9 SUCCEEDED"
else
    echo "TEST 9 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 10 - CREATING OVER QUOTA #########################################
#########################################################################

echo ""
echo "########################################################################
### TEST 10 - CREATING OVER QUOTA ######################################
########################################################################"

mkdir folder

test10_user=$(stat -c '%u' "folder")
test10_size=$(stat --format=%s "folder")

test10_expected="${test9_user} ${test9_size} 4100"

echo "hello" > hello

test10_actual="$(cat db)"

expected=$(echo $test10_expected)
actual=$(echo $test10_actual)

#if [[ -f hello ]]
#then
    #echo "TEST 10 FAILED: FILE WRONGLY CREATED"
    #exit
#else 
    #:
#fi

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 10 SUCCEEDED"
else
    echo "TEST 10 FAILED"
    echo $expected
    echo $actual
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 11 - APPENDING OVER QUOTA #########################################
#########################################################################

echo ""
echo "########################################################################
### TEST 11 - APPENDING OVER QUOTA #####################################
########################################################################"

mkdir folder

test11_user=$(stat -c '%u' "folder")
folder_size=$(stat --format=%s "folder")

echo "hi" > hi

hi_size=$(stat --format=%s "hi")

test11_updated_size=$(($hi_size + $folder_size))

test11_expected="${test11_user} ${test11_updated_size} 4100"

echo "1234" >> hi

test11_actual="$(cat db)"

expected=$(echo $test11_expected)
actual=$(echo $test11_actual)

echo $actual
echo $expected

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 11 SUCCEEDED"
else
    echo "TEST 11 FAILED"
fi

## MAKE SURE HI DID NOT ALLOW APPEND ##
hi_size_updated=$(stat --format=%s "hi")

#echo $hi_size
#echo $hi_size_updated

if [[ $hi_size == $hi_size_updated ]]
then
    :
else
    echo "TEST 11 FAILED: HI WRONGLY APPENDED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""

#########################################################################
### TEST 12 - CREATING DIRECTORY OVER QUOTA #########################################
#########################################################################

echo ""
echo "########################################################################
### TEST 12 - CREATING DIRECTORY OVER QUOTA ############################
########################################################################"

mkdir folder

test12_user=$(stat -c '%u' "folder")
test12_size=$(stat --format=%s "folder")

test12_expected="${test12_user} ${test12_size} 4100"

mkdir folder_2

if [[ -f folder_2 ]]
then
    echo "TEST 10 FAILED: FILE WRONGLY CREATED"
    exit
else 
    :
fi

test12_actual="$(cat db)"

expected=$(echo $test12_expected)
actual=$(echo $test12_actual)

if [[ "$expected" == "$actual" ]]
then
    echo "TEST 12 SUCCEEDED"
else
    echo "TEST 12 FAILED"
fi

cd ..
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""


#########################################################################
### TEST 13 - UNLINK ###############
#########################################################################

echo "
#########################################################################
### TEST 13 - UNLINK			    ###############
#########################################################################
"

echo ""
#################################################### UNLINK TEST ######################################################
#echo "1:    Creating new empty file"
echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified size, now verify not being as large

rm newFile

#numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

#numbers_user=$(stat -c '%u' "1000")
#echo $numbers_user

numbers_test_str="$numbers_user 0 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 7? PASSED"
    :
else
    echo "FILE RM DID NOT DECREMENT"
    cat db
fi

rm db

echo "
#########################################################################
### TEST 14 - RENAME					    ###############
#########################################################################
"

echo ""
#echo "1:    Creating new empty file"

echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified size, now change name

mv newFile numbers

if [ -a numbers ];
then
	if [ ! -a newFile ];
	then
		echo "TEST 8? PASSED"
		:
	else 
		echo "TEST 8? FAILED"
	fi
else
	echo "TEST 8? FAILED"
fi
		

rm numbers
rm db


echo "
#########################################################################
### TEST 15 - CHANGING OWNERSHIP			    ###############
#########################################################################
"

echo ""
#echo "1:    Creating new empty file"

echo "new file data here" > newFile

#SLEEP
sleep .5

#echo "2:    Checking db file exists"
if [ -a db ];
then
    #echo "FILE EXISTS"
    :
else
    echo "!!!!!!!!!!!!!!!!!!!!"
    echo "db FILE DOES NOT EXISTS"
    echo ""
fi

#echo "DISPLAYING db FILE:"
#echo ""
#cat db
#echo ""

numbers_size=$(stat --format=%s "newFile")
#echo "DISPLAYING TESTFILE SIZE"
#echo $numbers_size

numbers_user=$(stat -c '%u' "newFile")
#echo $numbers_user

numbers_test_str="${numbers_user} ${numbers_size} 5000"
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    :
else
    echo "FILE WRITE FAILED"
fi
#verified old owner, now change owner

chown 1000 newFile

numbers_user=$(stat -c '%u' "newFile")

numbers_test_str="
0 0 5000
1000 ${numbers_size} 5000
"
dbfile="$(cat db)"
cat db
echo ${numbers_test_str}

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)
dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

if [[ "$expected" == "$actual" ]] 
then
    echo "CHOWN TEST PASSED"
else
    echo "CHOWN TEST FAILED"
fi
		

rm newFile
rm db


# ------------------- CONCURRENCY TESTS------------------------

cd ..
repo_root=$(pwd)
sleep .5
sudo umount mp_test/
rm -rf bd_test/ mp_test/
mkdir bd_test/
mkdir mp_test/
export SLEEP_TIME=1
sudo ntapfuse mount bd_test/ mp_test/ -o allow_other
cd mp_test
echo ""


#########################################################################
### TEST C1 - CREATE FILE USING ECHO - NO DATABSE PRESENT ################
#########################################################################

echo ""
echo "----- BEGINNING CONCURRENCY TESTS, THESE ARE SLOWER DUE TO ADDED DELAY -----"
echo ""

echo ""
echo "########################################################################
### TEST C1 - ONE USER WRITING TO TWO DIFFERENT FILES AT SAME TIME #####
########################################################################"

#echo "1:    Creating numbers file"

# Run first concurrency test
python3 ${repo_root}/Tests/c1.py



file1_expected="123456789"
file1="$(cat file1)"
file2_expected="987654321"
file2="$(cat file2)"

db_expected="1000 20 4100"
db=$(cat db)

# Check db
expected=$(echo $db_expected)
actual=$(echo $db)
if [[ "$expected" == "$actual" ]] 
then
    echo "DB PASS"
else
    echo "DB FAIL"
    echo $expected
    echo $actual
fi

# Check file 1
expected=$(echo $file1_expected)
actual=$(echo $file1)
if [[ "$expected" == "$actual" ]] 
then
    echo "FILE 1 PASS"
else
    echo "FILE 1 FAIL"
fi

# Check file 2
expected=$(echo $file2_expected)
actual=$(echo $file2)
if [[ "$expected" == "$actual" ]] 
then
    echo "FILE 2 PASS"
else
    echo "FILE 2 FAIL"
fi


#########################################################################
### TEST C2 - ONE USER CONCURRENTLY REMOVING TWO FILES ##################
#########################################################################

echo ""
echo "########################################################################
### TEST C2 - ONE USER CONCURRENTLY REMOVING TWO FILES #################
########################################################################"

python3 ${repo_root}/Tests/c2.py

db_expected="1000 0 4100"
db=$(cat db)

# Check db
expected=$(echo $db_expected)
actual=$(echo $db)

if [[ "$expected" == "$actual" ]] 
then
    echo "DB PASS"
else
    echo "DB FAIL"
    echo $expected
    echo $actual
fi

if [[ -f file1 ]]
then
    echo "TEST C2 FAILED: FILE 1 NOT DELETED"
    exit
else 
    echo "FILE 1 PROPERLY DELETED"
fi

if [[ -f file2 ]]
then
    echo "TEST C2 FAILED: FILE 2 NOT DELETED"
    exit
else 
    echo "FILE 2 PROPERLY DELETED"
fi

# ------------------- TESTS END HERE ------------------------


# ----- CLEANUP -----

# Notify user
echo
echo
echo " --- Cleaning up... ---"
echo 
echo
sleep .5

# Exit mountpoint directory
cd ..

# Unmount directory
sudo umount mp_test/

# Remove test directories
rm -rf bd_test/
rm -rf mp_test/

# Set up environment variable for initial tests
export SLEEP_TIME=0

# Remove testusers
sudo pkill -KILL -u testuser
sudo userdel -r testuser
