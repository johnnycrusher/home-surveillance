import os, random, struct
import time
from Crypto.Cipher import AES

def decrypt_file(key, in_filename, out_filename=None, chunksize=24*1024):
    """ Decrypts a file using AES (CBC mode) with the
        given key. Parameters are similar to encrypt_file,
        with one difference: out_filename, if not supplied
        will be in_filename without its last extension
        (i.e. if in_filename is 'aaa.zip.enc' then
        out_filename will be 'aaa.zip')
    """
    if not out_filename:
        out_filename = os.path.splitext(in_filename)[0]

    with open(in_filename, 'rb') as infile:
        origsize = struct.unpack('<Q', infile.read(struct.calcsize('Q')))[0]
        iv = infile.read(16)
        decryptor = AES.new(key, AES.MODE_CBC, iv)

        with open(out_filename, 'wb') as outfile:
            while True:
                chunk = infile.read(chunksize)
                if len(chunk) == 0:
                    break
                outfile.write(decryptor.decrypt(chunk))

            outfile.truncate(origsize)

FileName = 'FaceCap';
number = 0;
File_extension = ".png"
Encrption_extension = ".enc"
for x in range(0,100):
	if(os.path.isfile(FileName+str(x)+File_extension)):
		os.remove(FileName+str(x)+File_extension)
	if(os.path.isfile(FileName+str(x)+File_extension+Encryption_extension)):
		os.remove(FileName+str(x)+File_extension+Encryption_extension)
while(1):
	time.sleep(2);
	if(os.path.isfile(FileName+str(number)+File_extension+Encrption_extension)):
		decrypt_file("1234567891234567",FileName+str(number)+File_extension+Encrption_extension,FileName+str(number)+File_extension,24*1024)
		number +=1;