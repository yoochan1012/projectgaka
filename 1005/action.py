from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import sys
import loginexe
import excel_Windows
import pdf_Windows
import paramiko
import time
import threading
import queue

###수정하고싶은부분치면 넘어가짐


class Windows(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()
    def initUI(self):
        self.setFixedSize(QSize(400, 600))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Windows")

        self.send_group = QGroupBox('파일 전송하기')
        send_label = QLabel('파일을 원격으로 전송합니다.', self)
        send_label.setAlignment(Qt.AlignCenter)
        send_label.setWordWrap(True)
        send_btn = QPushButton('전송하기')
        send_btn.clicked.connect(self.send)

        self.exec_group = QGroupBox('파일 실행하기')
        self.exec_label = QLabel('파일을 원격으로 실행합니다.', self)
        self.exec_label.setAlignment(Qt.AlignCenter)
        self.exec_label.setWordWrap(True)
        self.exec_btn = QPushButton('실행')
        self.exec_btn.clicked.connect(self.exec)

        self.cal_group = QGroupBox('파일 가져오기')
        self.cal_label = QLabel('파일을 가져옵니다.', self)
        self.cal_label.setAlignment(Qt.AlignCenter)
        self.cal_label.setWordWrap(True)
        self.cal_btn = QPushButton('실행')
        self.cal_btn.clicked.connect(self.cal)

        self.del_group = QGroupBox('파일 삭제하기')
        self.del_label = QLabel('원격 파일을 삭제합니다.', self)
        self.del_label.setAlignment(Qt.AlignCenter)
        self.del_label.setWordWrap(True)
        self.del_btn = QPushButton('삭제')
        self.del_btn.clicked.connect(self.delete)

        self.send_layout = QGridLayout()
        self.send_layout.addWidget(send_label, 0, 0)
        self.send_layout.addWidget(send_btn, 1, 0)
        self.send_group.setLayout(self.send_layout)
        self.exec_layout = QGridLayout()
        self.exec_layout.addWidget(self.exec_label, 0, 0)
        self.exec_layout.addWidget(self.exec_btn, 1, 0)
        self.exec_group.setLayout(self.exec_layout)
        self.cal_layout = QGridLayout()
        self.cal_layout.addWidget(self.cal_label, 0, 0)
        self.cal_layout.addWidget(self.cal_btn, 1, 0)
        self.cal_group.setLayout(self.cal_layout)
        self.del_layout = QGridLayout()
        self.del_layout.addWidget(self.del_label, 0, 0)
        self.del_layout.addWidget(self.del_btn, 1, 0)
        self.del_group.setLayout(self.del_layout)

        self.layout = QGridLayout()
        self.layout.addWidget(self.send_group, 0, 0)
        self.layout.addWidget(self.exec_group, 1, 0)
        self.layout.addWidget(self.cal_group, 2, 0)
        self.layout.addWidget(self.del_group, 3, 0)
        self.setLayout(self.layout)
    def send(self):
        my_instance = loginexe.LoginWindow()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        #-------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        localpath = "C:\\jjy\\Window.bat"
        remotepath = "C:\\check\\Window.bat"

        stdin, stdout, stderr = ssh.exec_command('mkdir C:\\check')
        time.sleep(0.5)
        sftp.put(localpath, remotepath)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#

    def exec(self):
        #실행 코드 들어갈 곳
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)

        stdin, stdout, stderr = ssh.exec_command("C:\\check\\Window.bat")
        time.sleep(3)

        #ssh.close()
        # -------------------------------------------------------#


    def cal(self): #txt파일 가져오기
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        remotepath1 = 'C:\\check\\w1~82\\log.txt'
        remotepath2 = 'C:\\check\\w1~82\\Action.txt'
        remotepath3 = 'C:\\check\\w1~82\\inspect.txt'
        sftp.get(remotepath1, 'C:\\jjy\\log.txt')
        sftp.get(remotepath2, 'C:\\jjy\\Action.txt')
        sftp.get(remotepath3, 'C:\\jjy\\inspect.txt')
        time.sleep(1)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#

    def delete (self): #생성한 디렉토리 제거 코드 들어갈 곳
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        time.sleep(0.5)
        stdin, stdout, stderr = ssh.exec_command("RD /S /Q C:\\check")

        ssh.close()
        # -------------------------------------------------------#


class Linux(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def initUI(self):
        self.setFixedSize(QSize(400, 600))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Linux")

        self.send_group = QGroupBox('파일 전송하기')
        send_label = QLabel('파일을 원격으로 전송합니다.', self)
        send_label.setAlignment(Qt.AlignCenter)
        send_label.setWordWrap(True)
        send_btn = QPushButton('전송하기')
        send_btn.clicked.connect(self.send)

        self.exec_group = QGroupBox('파일 실행하기')
        self.exec_label = QLabel('파일을 원격으로 실행합니다.', self)
        self.exec_label.setAlignment(Qt.AlignCenter)
        self.exec_label.setWordWrap(True)
        self.exec_btn = QPushButton('실행')
        self.exec_btn.clicked.connect(self.exec)

        self.cal_group = QGroupBox('파일 가져오기')
        self.cal_label = QLabel('파일을 가져옵니다.', self)
        self.cal_label.setAlignment(Qt.AlignCenter)
        self.cal_label.setWordWrap(True)
        self.cal_btn = QPushButton('실행')
        self.cal_btn.clicked.connect(self.cal)

        self.del_group = QGroupBox('파일 삭제하기')
        self.del_label = QLabel('원격 파일을 삭제합니다.', self)
        self.del_label.setAlignment(Qt.AlignCenter)
        self.del_label.setWordWrap(True)
        self.del_btn = QPushButton('삭제')
        self.del_btn.clicked.connect(self.delete)

        self.send_layout = QGridLayout()
        self.send_layout.addWidget(send_label, 0, 0)
        self.send_layout.addWidget(send_btn, 1, 0)
        self.send_group.setLayout(self.send_layout)
        self.exec_layout = QGridLayout()
        self.exec_layout.addWidget(self.exec_label, 0, 0)
        self.exec_layout.addWidget(self.exec_btn, 1, 0)
        self.exec_group.setLayout(self.exec_layout)
        self.cal_layout = QGridLayout()
        self.cal_layout.addWidget(self.cal_label, 0, 0)
        self.cal_layout.addWidget(self.cal_btn, 1, 0)
        self.cal_group.setLayout(self.cal_layout)
        self.del_layout = QGridLayout()
        self.del_layout.addWidget(self.del_label, 0, 0)
        self.del_layout.addWidget(self.del_btn, 1, 0)
        self.del_group.setLayout(self.del_layout)

        self.layout = QGridLayout()

        self.layout.addWidget(self.send_group, 0, 0)
        self.layout.addWidget(self.exec_group, 1, 0)
        self.layout.addWidget(self.cal_group, 2, 0)
        self.layout.addWidget(self.del_group, 3, 0)
        self.setLayout(self.layout)
    def send(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        #-------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        localpath = "C:\\jjy\\Linux.sh"
        remotepath = "/check/Linux.sh"

        stdin, stdout, stderr = ssh.exec_command('mkdir /check')
        time.sleep(0.5)
        sftp.put(localpath, remotepath)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#


    def exec(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)

        stdin, stdout, stderr = ssh.exec_command("bash /check/Linux.sh")
        time.sleep(1)

        # -------------------------------------------------------#


    def cal(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        remotepath1 = '/check/U1~73/log.txt'
        remotepath2 = '/check/U1~73/Action.txt'
        remotepath3 = '/check/U1~73/inspect.txt'
        sftp.get(remotepath1, 'C:\\jjy\\log.txt')
        sftp.get(remotepath2, 'C:\\jjy\\Action.txt')
        sftp.get(remotepath3, 'C:\\jjy\\inspect.txt')
        time.sleep(1)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#

    def delete (self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        time.sleep(0.5)
        stdin, stdout, stderr = ssh.exec_command("rm -rf /check")

        ssh.close()
        # -------------------------------------------------------#


class Unix(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def initUI(self):
        self.setFixedSize(QSize(400, 300))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Unix")

        self.send_group = QGroupBox('파일 전송하기')
        send_label = QLabel('파일을 원격으로 전송합니다.', self)
        send_label.setAlignment(Qt.AlignCenter)
        send_label.setWordWrap(True)
        send_btn = QPushButton('전송하기')
        send_btn.clicked.connect(self.send)

        self.exec_group = QGroupBox('파일 실행하기')
        self.exec_label = QLabel('파일을 원격으로 실행합니다.', self)
        self.exec_label.setAlignment(Qt.AlignCenter)
        self.exec_label.setWordWrap(True)
        self.exec_btn = QPushButton('실행')
        self.exec_btn.clicked.connect(self.exec)

        self.cal_group = QGroupBox('파일 가져오기')
        self.cal_label = QLabel('파일을 가져옵니다.', self)
        self.cal_label.setAlignment(Qt.AlignCenter)
        self.cal_label.setWordWrap(True)
        self.cal_btn = QPushButton('실행')
        self.cal_btn.clicked.connect(self.cal)

        self.del_group = QGroupBox('파일 삭제하기')
        self.del_label = QLabel('원격 파일을 삭제합니다.', self)
        self.del_label.setAlignment(Qt.AlignCenter)
        self.del_label.setWordWrap(True)
        self.del_btn = QPushButton('삭제')
        self.del_btn.clicked.connect(self.delete)

        self.send_layout = QGridLayout()
        self.send_layout.addWidget(send_label, 0, 0)
        self.send_layout.addWidget(send_btn, 1, 0)
        self.send_group.setLayout(self.send_layout)
        self.exec_layout = QGridLayout()
        self.exec_layout.addWidget(self.exec_label, 0, 0)
        self.exec_layout.addWidget(self.exec_btn, 1, 0)
        self.exec_group.setLayout(self.exec_layout)
        self.cal_layout = QGridLayout()
        self.cal_layout.addWidget(self.colgaka_label, 0, 0)
        self.cal_layout.addWidget(self.colgaka_btn, 1, 0)
        self.cal_group.setLayout(self.colgaka_layout)
        self.del_layout = QGridLayout()
        self.del_layout.addWidget(self.del_label, 0, 0)
        self.del_layout.addWidget(self.del_btn, 1, 0)
        self.del_group.setLayout(self.del_layout)

        self.layout = QGridLayout()

        self.layout.addWidget(self.send_group, 0, 0)
        self.layout.addWidget(self.exec_group, 1, 0)
        self.layout.addWidget(self.cal_group, 2, 0)
        self.layout.addWidget(self.del_group, 3, 0)
        self.setLayout(self.layout)
    def send(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        #-------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        localpath = "C:\\jjy\\Unix.sh"
        remotepath = "/check/Unix.sh"

        stdin, stdout, stderr = ssh.exec_command('mkdir /check')
        time.sleep(0.5)
        sftp.put(localpath, remotepath)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#

    def exec(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)

        stdin, stdout, stderr = ssh.exec_command("bash /check/Unix.sh")
        time.sleep(1)

        ssh.close()
        # -------------------------------------------------------#

    def cal(self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        sftp = ssh.open_sftp()

        remotepath1 = '/check/S1~73/log.txt'
        remotepath2 = '/check/S1~73/Action.txt'
        remotepath3 = '/check/S1~73/inspect.txt'
        sftp.get(remotepath1, 'C:\\jjy\\log.txt')
        sftp.get(remotepath2, 'C:\\jjy\\Action.txt')
        sftp.get(remotepath3, 'C:\\jjy\\inspect.txt')
        time.sleep(1)

        ssh.close()
        sftp.close()
        # -------------------------------------------------------#

    def delete (self):
        my_instance = loginexe.LoginLinux()
        name = my_instance.my_funcion()
        ipa = my_instance.my_funcion2()
        pwd = my_instance.my_funcion3()
        # -------------------------------------------------------#
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
        ssh.connect(ipa, username=name, password=pwd)
        time.sleep(0.5)
        stdin, stdout, stderr = ssh.exec_command("rm -rf /check")

        ssh.close()
        # -------------------------------------------------------#


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Windows()
    ex.show()
    sys.exit(app.exec_())