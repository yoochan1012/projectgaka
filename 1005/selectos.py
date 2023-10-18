from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
import sys
import loginexe


class selectOS(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()

    def okdesc(self):
        if self.radio_w.isChecked() == True:
            self.w = loginexe.LoginWindow()
            self.w.show()
            self.close()
        elif self.radio_l.isChecked() == True:
            self.w = loginexe.LoginLinux()
            self.w.show()
            self.close()
        elif self.radio_u.isChecked() == True:
            self.w = loginexe.LoginUnix()
            self.w.show()
            self.close()
        else:
            QMessageBox.critical(self, "ERROR!", "OS를 선택하세요!")

    def initUI(self):
        self.setWindowTitle("OS선택")
        self.setWindowIcon(QIcon('jbu.png'))

        self.radio_w = QRadioButton('Windows', self)
        self.radio_w.move(20, 20)
        self.radio_l = QRadioButton('Linux', self)
        self.radio_l.move(20, 40)
        self.radio_u = QRadioButton('Unix', self)
        self.radio_u.move(20, 60)

        btn_ok = QPushButton('OK', self)
        btn_ok.move(50, 100)
        btn_ok.clicked.connect(self.okdesc)
        btn_cancel = QPushButton('Cancel', self)
        btn_cancel.move(50, 130)
        btn_cancel.clicked.connect(QCoreApplication.instance().quit)

        self.setWindowIcon(QIcon('jbu.png'))
        self.setGeometry(200, 200, 200, 200)
        self.show()


if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = selectOS()
    ex.show()
    sys.exit(app.exec_())
