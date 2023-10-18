'''import sys
import os

import openpyxl
import self as self
from PyQt5 import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
from openpyxl.workbook import Workbook
from openpyxl import load_workbook
class MyApp(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def lavs(self):
        label1 = QLabel('자동 진단', self)
        label1.move(30, 30)
        label2 = QLabel('진단 결과', self)
        label2.move(30, 70)
        label3 = QLabel('진단 보고서', self)
        label3.move(30, 110)
        label4 = QLabel('소개글', self)
        label4.move(30, 150)
        label5 = QLabel('종료', self)
        label5.move(30, 190)
    def btns(self):
        btn1 = QPushButton('스크립트 자동실행', self)
        btn1.move(150, 30)
        btn1.resize(200, 30)
        btn1.clicked.connect(self.btn1_click)
        btn2 = QPushButton('xls 파일 출력', self)
        btn2.move(150, 70)
        btn2.resize(200, 30)
        btn2.clicked.connect(self.btn2_click)
        btn3 = QPushButton('pdf 출력', self)
        btn3.move(150, 110)
        btn3.resize(200, 30)
        btn3.clicked.connect(self.btn3_click)
        btn4 = QPushButton('About', self)
        btn4.move(150, 150)
        btn4.resize(200, 30)
        btn5 = QPushButton('파일 삭제 및 GUI 종료', self)
        btn5.move(150, 190)
        btn5.resize(200, 30)

    def btn1_click(self):
        os.system("start cmd /k D:\다운로드항목\W11-52.bat")

    def btn2_click(self):
        w = load_workbook("승패마진표 (2022년).xlsx", data_only=True)
        os.system(w)
    def btn3_click(self):
        f = "3교시_영어영역_문제지.pdf"
        os.system(f)

    def initUI(self):
        pal = QPalette()
        pal.setColor(QPalette.Background, QColor(0, 255, 128))
        self.setAutoFillBackground(True)
        self.setPalette(pal)
        pal.setColor(QPalette.Button, QColor(255, 0, 128))
        app.setPalette(pal)

        self.lavs()
        self.btns()

        self.setWindowTitle('취약점 진단')
        self.setWindowIcon(QIcon('web.png'))
        self.resize(600, 400)
        self.show()

if __name__ == '__main__':
   app = QApplication(sys.argv)
   ex = MyApp()
   sys.exit(app.exec_())'''

import win32com.client as win32

excel = win32.gencache.EnsureDispatch('Excel.Application')
wb = excel.Workbooks.Open(excel, r"C:\jjy\(Jul-05-23)점검 결과.xlsx")