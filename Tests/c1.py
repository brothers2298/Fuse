import os
import threading
import time


def thread1():
	print("Thread 1 start: ", time.time())
	os.system("echo \"123456789\" > ../mp_test/file1")

def thread2():
	print("Thread 2 start: ", time.time())
	os.system("echo \"987654321\" > ../mp_test/file2")

t1 = threading.Thread(target=thread1)
t2 = threading.Thread(target=thread2)
t1.start()
t2.start()
