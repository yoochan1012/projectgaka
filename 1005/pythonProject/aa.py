"""'''import os
import win32com.client

excel = win32com.client.Dispatch("Excel.Application")
excel.Visible = True
exc = "C:\jjy\(Jun-22-23)점검 결과.xlsx"
wb = excel.Workbooks.Open(exc)
ws_report = wb.Worksheets("report")
ws_report.Select()

pdf = "C:\jjy\취약점진단결과.pdf"
wb.ActiveSheet.ExportAsFixedFormat(0, pdf)
wb.Close(False)
excel.Quit()
os.startfile(pdf)'''

import tkinter as tk
import os
import paragaka

def setup_ssh_client(host):
    print("establishing ssh connection....")
    client = paramiko.client.SSHClient()
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    home = os.path.expanduser("~")
    ret = os.path.exists(os.path.join(home, "somekey.pem"))
    if not ret:
        print("Unable to locate pem key, upload aborted....")
        return None

    private_key = paramiko.RSAKey.from_private_key_file(os.path.join(home, "somekey.pem"))
    try:
        client.connect(hostname=host, username="bob", pkey=private_key)
    except Exception as e:
        print(e)
    print("connected")
    stdin, stdout, stderr = client.exec_command('ls')
    for line in stdout:
        print('... ' + line.strip('\n'))
    return client

window = tk.Tk()
connectButton = tk.Button(window, text="Connect", width=6, command=setup_ssh_client)
connectButton.pack()
window.mainloop()"""

# USER
from urllib import request

import paramiko
import subprocess

name = request.user.name
pwd = request.user.pwd
ip = request.user.ip

name_object = name(name)
pwd_object = pwd(pwd)
ip_object = ip(ip)

ssh = paramiko.SSHClient()

ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

client_IP = str(ip_object)
client_name = str(id_object)
client_password = str(pw_object)

ssh.connect(client_IP, username=client_name, password = client_password)

stdin, stdout, stderr = ssh.exec_command()

local_path = ""

remote_path = ""

sftp = ssh.open_sftp()
sftp.put(local_path, remote_path)
sftp.close()

stdin, stdout, stderr = ssh.exec_command(f'chmod +x{remote_path} && {remote_path}')

def run_script(request):
    script_path = ""

    subprocess.Popen(script_path, shell=True)

    execute_script()

    return HttpResponse("Script executed successfully")

result_local_path = ''

result_remote_path = ''

sftp = ssh.open_sftp()
sftp.get(result_remote_path, result_local_path)
sftp.close()

stdin, stdout, stderr = ssh.exec_command("rm ")

ssh.close()