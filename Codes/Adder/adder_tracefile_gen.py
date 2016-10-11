import string
from random import randint
f = open("TRACEFILE_adder.txt",'w')
string = ""

for i in range(10000) :
	k1 = randint(0,pow(2,16)) ;
	k2 = randint(0,pow(2,16)) ;
	k3 = k2 + k1 ;
	k4 = k3/pow(2,16) ;			# carry flag generate
	k3 = k3 % pow(2,16);
	if k3 == 0:
		z_flag = 1 ;
	else:
		z_flag = 0 ;
	
	string = ""
	string = '0' + '{:016b}'.format(k1) + '{:016b}'.format(k2) + '{:01b}'.format(k4) + '{:01b}'.format(z_flag) + '{:016b}'.format(k3) + "\n"
	f.write(string);	 
	string = ""
	string = '1' + '{:016b}'.format(k1) + '{:016b}'.format(k2) + '{:01b}'.format(k4) + '{:01b}'.format(z_flag) + '{:016b}'.format(k3) + "\n"
	f.write(string);

	
