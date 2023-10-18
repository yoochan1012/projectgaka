from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import sys

class Windowsgaka(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def initUI(self):
        self.setFixedSize(QSize(400, 300))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Windows")

        btn_send = QPushButton('파일 전송하기', self)
        btn_send.move(140, 50)
        btn_exec = QPushButton('파일 실행하기', self)
        btn_exec.move(140, 100)
        btn_open = QPushButton('파일 가져오기', self)
        btn_open.move(140, 150)
        btn_del = QPushButton('파일 삭제하기', self)
        btn_del.move(140, 200)

        self.setWindowIcon(QIcon('jbu.png'))
        self.setGeometry(200, 200, 200, 200)


class Linuxgaka(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def sendgaka(self):
        user_id = request.user.id
        user_pw = request.user.pw
        user_ip = request.user.ip

        id_object = id(user_id)
        pw_object = pw(user_pw)
        ip_object = ip(user_ip)

    def deletegaka(self):
        ssh = paramiko.SSHClient()
        stdin, stdout, stderr = ssh.exec_command("rm -rf /home/user/TESTFILE1.txt")
        ssh.close()

    def initUI(self):
        self.setFixedSize(QSize(400, 300))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Linux")

        btn_exec = QPushButton('파일 전송하기', self)
        btn_exec.move(140, 50)
        btn_exec = QPushButton('파일 실행하기', self)
        btn_exec.move(140, 100)
        btn_open = QPushButton('파일 가져오기', self)
        btn_open.move(140, 150)
        btn_del = QPushButton('파일 삭제하기', self)
        btn_del.move(140, 200)


        self.setWindowIcon(QIcon('jbu.png'))
        self.setGeometry(200, 200, 200, 200)


class Unixgaka(QDialog):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def initUI(self):
        self.setFixedSize(QSize(400, 300))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Unix")

        btn_send = QPushButton('파일 전송하기', self)
        btn_send.move(140, 50)
        btn_exec = QPushButton('파일 실행하기', self)
        btn_exec.move(140, 100)
        btn_open = QPushButton('파일 가져오기', self)
        btn_open.move(140, 150)
        btn_del = QPushButton('파일 삭제하기', self)
        btn_del.move(140, 200)



        self.setWindowIcon(QIcon('jbu.png'))
        self.setGeometry(200, 200, 200, 200)


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Windowsgaka()
    ex.show()
    sys.exit(app.exec_())
