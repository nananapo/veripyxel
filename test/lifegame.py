import serial
import time
 
 
COM="COM44"
bitRate=115200
 
ser = serial.Serial(COM, bitRate, timeout=0.1)
 
while True:
 
	time.sleep(0.1)
	
	result = ser.read_all()
	print(result)
 
	if result == b'\r':	# <Enter>で終了
	break
 
print('program end')
 
ser.close()