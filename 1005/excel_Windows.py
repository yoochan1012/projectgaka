from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import sys
import os

class Excel_Windows(QDialog):

    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()
    def initUI(self):
        self.setFixedSize(QSize(400, 400))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Excel_Windows")

        self.send_group = QGroupBox('엑셀 생성하기')
        send_label = QLabel('txt파일을 기반으로 엑셀 파일을 생성합니다.', self)
        send_label.setAlignment(Qt.AlignCenter)
        send_label.setWordWrap(True)
        send_btn = QPushButton('생성하기')
        send_btn.clicked.connect(self.makeexcel)

        self.exec_group = QGroupBox('엑셀 열기')
        self.exec_label = QLabel('엑셀 파일 내용 확인하기.', self)
        self.exec_label.setAlignment(Qt.AlignCenter)
        self.exec_label.setWordWrap(True)
        self.exec_btn = QPushButton('열기')
        self.exec_btn.clicked.connect(self.openexcel)

        self.send_layout = QGridLayout()
        self.send_layout.addWidget(send_label, 0, 0)
        self.send_layout.addWidget(send_btn, 1, 0)
        self.send_group.setLayout(self.send_layout)
        self.exec_layout = QGridLayout()
        self.exec_layout.addWidget(self.exec_label, 0, 0)
        self.exec_layout.addWidget(self.exec_btn, 1, 0)
        self.exec_group.setLayout(self.exec_layout)

        self.layout = QGridLayout()
        self.layout.addWidget(self.send_group, 0, 0)
        self.layout.addWidget(self.exec_group, 1, 0)
        self.setLayout(self.layout)

    def makeexcel(self):
        filenames = os.listdir("C:\\jjy\\")
        if 'log.txt' in filenames and 'Action.txt' in filenames and 'inspect.txt' in filenames:
            QMessageBox.information(self, 'Message', '엑셀 생성이 가능합니다', QMessageBox.Ok)
            os.system("python excel.py")
            #프로그램 실행했을 때 excel.py가 바로 실행되지않고 여기서 실행
        else:
            QMessageBox.information(self, 'Message', 'txt파일이 존재하지 않으므로 엑셀 생성이 불가능합니다.', QMessageBox.Ok)

    def openexcel(self):#실행 코드
        filenames = os.listdir("C:\\jjy\\")
        if '취약점 진단 결과.xlsx' in filenames:
            os.startfile("C:\jjy\취약점 진단 결과.xlsx")
        else:
            QMessageBox.information(self, 'Message', '엑셀이 존재하지 않아 열람이 불가능합니다.', QMessageBox.Ok)



if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Excel_Windows()
    ex.show()
    sys.exit(app.exec_())