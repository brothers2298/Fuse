import os
import threading
import time


def thread1():
	print("Thread 1 start: ", time.time())
	os.system("sudo -u testuser bash ../Tests/tu_c6.sh")

def thread2():
	print("Thread 2 start: ", time.time())
	os.system("rm ../mp_test/file2")

t1 = threading.Thread(target=thread1)
t2 = threading.Thread(target=thread2)
t1.start()
t2.start()
