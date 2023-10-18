from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import osgaka
class LoginWindow(QDialog):

    def __init__(self):
        super().__init__()

        self.setWindowTitle('Window Login')
        self.setGeometry(100, 100, 300, 200)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(20, 20)

        self.username_input = QLineEdit(self)
        self.username_input.move(100, 25)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(20, 50)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(100, 55)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(20, 80)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(100, 85)
        self.password_input.resize(150, 20)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.move(60, 130)
        self.exit_button.clicked.connect(self.login)

        self.login_button = QPushButton('취소', self)
        self.login_button.move(170, 130)

        self.login_button.clicked.connect(self.close)

    def login(self):
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" and ipa == "" and pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
            LoginWindow.close()

            self.w = osgaka.Windowsgaka()
            self.w.show()
            self.close()


if __name__ == '__main__':
    app = QApplication([])
    window = LoginWindow()
    window.show()
    app.exec()

class LoginLinux(QDialog, QWidget):
    def __init__(self):
        super().__init__()

        self.setWindowTitle('Linux Login')
        self.setGeometry(100, 100, 300, 200)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(20, 20)

        self.username_input = QLineEdit(self)
        self.username_input.move(100, 25)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(20, 50)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(100, 55)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(20, 80)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(100, 85)
        self.password_input.resize(150, 20)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.move(60, 130)
        self.exit_button.clicked.connect(self.login)

        self.login_button = QPushButton('취소', self)
        self.login_button.move(170, 130)

        self.login_button.clicked.connect(self.close)

    def login(self):
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" and ipa == "" and pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
            LoginLinux.close()

            self.w = osgaka.Linuxgaka()
            self.w.show()
            self.close()

if __name__ == '__main__':
    app = QApplication([])
    window = LoginLinux()
    window.show()
    app.exec()

class LoginUnix(QDialog):

    def __init__(self):
        super().__init__()

        self.setWindowTitle('Unix Login')
        self.setGeometry(100, 100, 300, 200)

        self.username_label = QLabel('Username: ', self)
        self.username_label.move(20, 20)

        self.username_input = QLineEdit(self)
        self.username_input.move(100, 25)
        self.username_input.resize(150, 20)

        self.ip_label = QLabel('IP: ', self)
        self.ip_label.move(20, 50)

        self.ip_input = QLineEdit(self)
        self.ip_input.move(100, 55)
        self.ip_input.resize(150, 20)

        self.password_label = QLabel('Password: ', self)
        self.password_label.move(20, 80)

        self.password_input = QLineEdit(self)
        self.password_input.setEchoMode(QLineEdit.EchoMode.Password)
        self.password_input.move(100, 85)
        self.password_input.resize(150, 20)

        self.exit_button = QPushButton('확인', self)
        self.exit_button.move(60, 130)
        self.exit_button.clicked.connect(self.login)

        self.login_button = QPushButton('취소', self)
        self.login_button.move(170, 130)

        self.login_button.clicked.connect(self.close)

    def login(self):
        name = self.username_input.text()
        ipa = self.ip_input.text()
        pwd = self.password_input.text()

        if name == "" and ipa == "" and pwd == "":
            QMessageBox.information(self, 'Message', '값을 입력하세요', QMessageBox.Ok)

        else:
            QMessageBox.information(self, 'Message', '로그인 성공', QMessageBox.Ok)
            LoginUnix.close()

            self.w = osgaka.Unixgaka()
            self.w.show()
            self.close()


if __name__ == '__main__':
    app = QApplication([])
    window = LoginUnix()
    window.show()
    app.exec()