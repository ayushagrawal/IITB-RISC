import string
from random import randint
f = open("TRACEFILE_alu.txt",'w')
string = ""

for i in range(10000) :
	k0 = randint(0,2);
	k1 = randint(0,pow(2,16)) ;
	k2 = randint(0,pow(2,16)) ;
	
	if k0 == 0:				#adder
		k3 = k2 + k1 ;
		k4 = k3 / pow(2,16) ;
		k3 = k3 % pow(2,16) ;
		if k3 == 0:
			z_flag = 1 ;
		else:
			z_flag = 0 ;

	elif k0 == 1:				#subtractor
		k3 = k1 - k2 ;
		if k3 < 0 :
			k3 = k3 + pow(2,16);
		else:
			k3 = k3 ;
		k3 = k3 % pow(2,16) ;
		if i == 0:
			k4 = 0; 
		if k3 == 0:
			z_flag = 1 ;
		else:
			z_flag = 0 ;

	else :					# nand logic
		k3 = pow(2,16)+(~(k1 & k2));
		k3 = k3 % pow(2,16) ;
		if k3 == 0:
			z_flag = 1 ;
		else:
			z_flag = 0 ;
		if i == 0:
			k4 = 0; 
	
		
	string = ""
	string = '{:02b}'.format(k0) + '{:016b}'.format(k1) + '{:016b}'.format(k2) +'{:01b}'.format(z_flag) + '{:016b}'.format(k3) + "\n"
	f.write(string);	 
	
