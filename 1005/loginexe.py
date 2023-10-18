from PyQt5.QtWidgets import *
import action
import selectos
import paramiko
import time

class LoginWindow(QDialog):

    def __init__(self):
        super().__init__()

        self.setWindowTitle('Window Login')
        self.setGeometry(100, 100, 350, 250)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(50, 40)

        self.username_input = QLineEdit(self)
        self.username_input.move(130, 35)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(50, 80)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(130, 75)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(50, 120)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(130, 115)
        self.password_input.resize(150, 20)

        self.prev_button = QPushButton('이전', self)
        self.prev_button.move(30, 180)
        self.prev_button.clicked.connect(self.prev)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.setDefault(True)
        self.exit_button.move(125, 180)
        self.exit_button.clicked.connect(self.login)
        self.login_button = QPushButton('취소', self)
        self.login_button.move(220, 180)
        self.login_button.clicked.connect(self.close)
    def prev(self):
        self.w = selectos.selectOS()
        self.w.show()
        self.close()
    def login(self):
        global name, ipa, pwd
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" or ipa == "" or pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            try:
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
                ssh.connect(ipa, username=name, password=pwd)

                QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
                self.w = action.Windows()
                self.w.show()
                self.close()

            except:
                QMessageBox.information(self, 'Message', '로그인 실패', QMessageBox.Ok)


    def my_funcion(self):
        return name
    def my_funcion2(self):
        return ipa
    def my_funcion3(self):
        return pwd

class LoginLinux(QDialog):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Linux Login')
        self.setGeometry(100, 100, 350, 250)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(50, 40)

        self.username_input = QLineEdit(self)
        self.username_input.move(130, 35)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(50, 80)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(130, 75)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(50, 120)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(130, 115)
        self.password_input.resize(150, 20)

        self.prev_button = QPushButton('이전', self)
        self.prev_button.move(30, 180)
        self.prev_button.clicked.connect(self.prev)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.setDefault(True)
        self.exit_button.move(125, 180)
        self.exit_button.clicked.connect(self.login)
        self.login_button = QPushButton('취소', self)
        self.login_button.move(220, 180)
        self.login_button.clicked.connect(self.close)

    def prev(self):
        self.w = selectos.selectOS()
        self.w.show()
        self.close()

    def login(self):
        global name, ipa, pwd
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" or ipa == "" or pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            try:
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
                ssh.connect(ipa, username=name, password=pwd)

                QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
                self.w = action.Linux()
                self.w.show()
                self.close()

            except:
                QMessageBox.information(self, 'Message', '로그인 실패', QMessageBox.Ok)

    def my_funcion(self):
        return name

    def my_funcion2(self):
        return ipa

    def my_funcion3(self):
        return pwd

if __name__ == '__main__':
    app = QApplication([])
    window = LoginLinux()
    window.show()
    app.exec()

class LoginUnix(QDialog):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Unix Login')
        self.setGeometry(100, 100, 350, 250)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(50, 40)

        self.username_input = QLineEdit(self)
        self.username_input.move(130, 35)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(50, 80)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(130, 75)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(50, 120)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(130, 115)
        self.password_input.resize(150, 20)

        self.prev_button = QPushButton('이전', self)
        self.prev_button.move(30, 180)
        self.prev_button.clicked.connect(self.prev)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.setDefault(True)
        self.exit_button.move(125, 180)
        self.exit_button.clicked.connect(self.login)
        self.login_button = QPushButton('취소', self)
        self.login_button.move(220, 180)
        self.login_button.clicked.connect(self.close)

    def prev(self):
        self.w = selectos.selectOS()
        self.w.show()
        self.close()

    def login(self):
        global name, ipa, pwd
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" or ipa == "" or pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            try:
                ssh = paramiko.SSHClient()
                ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy)
                ssh.connect(ipa, username=name, password=pwd)

                QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
                self.w = action.Unix()
                self.w.show()
                self.close()

            except:
                QMessageBox.information(self, 'Message', '로그인 실패', QMessageBox.Ok)

    def my_funcion(self):
        return name

    def my_funcion2(self):
        return ipa

    def my_funcion3(self):
        return pwd



if __name__ == '__main__':
    app = QApplication([])
    window = LoginWindow()
    window.show()
    app.exec()

