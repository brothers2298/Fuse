#Traverse back to mp_test folder
cd ..
cd mp_test

folder_user=$(stat -c '%u' "folder")

chown $folder_user hey