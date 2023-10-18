import paramiko

name = "gaka"
ipadd = ".192.168.122.1"
pwd = "gaka"

trans = paramiko.transport.Transport(ipadd, 22)
trans.connect(username = name, password = pwd)

sftp = paramiko.SFTPClient.from_transport(trans)
remotepath = 'TESTFILE1.sh'
localpath = "C:\jjy\TESTFILE1.sh"
sftp.put(localpath, remotepath)

sftp.close()
trans.close()