import os, random, struct
import time
import ftplib
from Crypto.Cipher import AES

def encrypt_file(key, in_filename, out_filename=None, chunksize=64*1024):
    """ Encrypts a file using AES (CBC mode) with the
        given key.

        key:
            The encryption key - a string that must be
            either 16, 24 or 32 bytes long. Longer keys
            are more secure.

        in_filename:
            Name of the input file

        out_filename:
            If None, '<in_filename>.enc' will be used.

        chunksize:
            Sets the size of the chunk which the function
            uses to read and encrypt the file. Larger chunk
            sizes can be faster for some files and machines.
            chunksize must be divisible by 16.
    """
    if not out_filename:
        out_filename = in_filename + '.enc'

    iv = ''.join(chr(random.randint(0, 0xFF)) for i in range(16))
    encryptor = AES.new(key, AES.MODE_CBC, iv)
    filesize = os.path.getsize(in_filename)

    with open(in_filename, 'rb') as infile:
        with open(out_filename, 'wb') as outfile:
            outfile.write(struct.pack('<Q', filesize))
            outfile.write(iv)

            while True:
                chunk = infile.read(chunksize)
                if len(chunk) == 0:
                    break
                elif len(chunk) % 16 != 0:
                    chunk += ' ' * (16 - len(chunk) % 16)

                outfile.write(encryptor.encrypt(chunk))
		
FileName = 'FaceCap';
number = 0;
var = 0;
File_extension = ".png"
Encryption_extension = ".enc"
send = False;
address = "192.168.1.86"
username = "pi"
password = "BlackBlue123="
for x in range(0,100):
	if(os.path.isfile(FileName+str(x)+File_extension)):
		os.remove(FileName+str(x)+File_extension)
	if(os.path.isfile(FileName+str(x)+File_extension+Encryption_extension)):
		os.remove(FileName+str(x)+File_extension+Encryption_extension)
while(1):
	time.sleep(1)
	if(os.path.isfile(FileName+str(number)+File_extension)):
		encrypt_file("1234567891234567",FileName+str(number)+File_extension,  None, 64*1024)
		filename = FileName+str(number)+File_extension+Encryption_extension	
		ftp = ftplib.FTP(address)
		ftp.login(username,password);
		ftp.cwd("/home/pi/ifb102-project/app/pictures/")
		myfile = open(filename, 'rb')	
		ftp.storbinary('STOR ' + filename, myfile)
		myfile.close()
		number += 1;

		

