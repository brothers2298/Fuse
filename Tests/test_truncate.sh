# ----- SETUP -----

# Exit if any command fails
set -e

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


#########################################################################
### TEST 7 - SHRINK OR EXTEND THE SIZE OF A FILE TO THE SPECIFIED SIZE ##
#########################################################################


echo "###################################################################
### TEST 7 - SHRINK OR EXTEND THE SIZE OF A FILE TO THE SPECIFIED SIZE ##
########################################################################"



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

echo "file_size:  "
echo "          expected: $expected"
echo "          actual: $actual"

echo "Original content: "
cat numbers
echo ""

#################################################### TEST TRUNCATE ######################################################

# add 
truncate -s $[numbers_size+10] numbers

numbers_size=$(stat --format=%s "numbers")
numbers_user=$(stat -c '%u' "numbers")
numbers_test_str="${numbers_user} ${numbers_size} 4096"

dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

echo " "
echo "After truncate(add): "
echo "          expected: $expected"
echo "          actual: $actual"

# echo "Content(add): "
# cat numbers
# echo ""


# sub
truncate -s $[numbers_size-20] numbers

numbers_size=$(stat --format=%s "numbers")
numbers_user=$(stat -c '%u' "numbers")
numbers_test_str="${numbers_user} ${numbers_size} 4096"

dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

echo " "
echo "After truncate(sub): "
echo "          expected: $expected"
echo "          actual: $actual"
# echo "Content(sub): "
# cat numbers
# echo ""


# Extend to a large
truncate -s $[numbers_size+1024] numbers

numbers_size=$(stat --format=%s "numbers")
numbers_user=$(stat -c '%u' "numbers")
numbers_test_str="${numbers_user} ${numbers_size} 4096"

dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

echo " "
echo "After truncate(add -> MAX): "
echo "          expected: $expected"
echo "          actual: $actual"

# echo "Content(add -> MAX): "
# cat numbers
# echo ""


# Reduced to very small
truncate -s $[numbers_size-2048] numbers

numbers_size=$(stat --format=%s "numbers")
numbers_user=$(stat -c '%u' "numbers")
numbers_test_str="${numbers_user} ${numbers_size} 4096"

dbfile="$(cat db)"

expected=$(echo $numbers_test_str)
actual=$(echo $dbfile)

echo " "
echo "After truncate(sub -> MIN): "
echo "          expected: $expected"
echo "          actual: $actual"
# echo "Content(sub -> MIN): "
# cat numbers
# echo ""

if [[ "$expected" == "$actual" ]] 
then
    echo "TEST 7 SUCCEEDED"
else
    echo "TEST 7 FAILED"
fi


################################################################################################################

# -------------------- TESTS END HERE -----------------------



# -------------------- CLEAN --------------------------------
echo ""
echo "--------- CLEAN ----------"
echo ""

cd ..

# Unmount directory
sudo umount mp_test/

# Remove test directories
rm -rf bd_test/
rm -rf mp_test/