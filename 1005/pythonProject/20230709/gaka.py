import sys
import win32com.client

import win32com
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import os
import os.path
from os import path
import excelgaka

from PyQt5.uic.properties import QtGui

class ProgWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.label = QLabel('본 프로그램은 2023년 중부대학교 정보보호학과 졸업작품으로 제작한 Windows Server, Linux Server, Unix Server 대상 서버 취약점 분석 자동화 프로그램입니다. \n'
                            'KISA에서 발간한 주요정보통신기반시설 기술적 취약점 분석 및 평가방법 가이드를 기준으로 각 OS별 취약점을 자동화 진단도구를 통해 진단하고, 진단 결과를 엑셀 파일 및 PDF 파일을 통해 리포트 형태로 제공하는 프로그램입니다.\n'
                            '본 프로그램의 저작권은 중부대학교 정보보호학과에 있으며 무단으로 프로그램 복제 및 사용시 관련법에 따라 처벌받을 수 있습니다.',self)
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setWordWrap(True)

        self.setWindowTitle('프로그램 소개')
        self.setFixedSize(QSize(900, 600))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)
        self.show()

class SecondWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.first_group = QGroupBox('조영준')
        self.first_label = QLabel('Python 프로그램으로 진단도구 개발 및 테스트 서버 제작', self)
        self.first_label.setAlignment(Qt.AlignCenter)
        self.first_label.setWordWrap(True)

        self.second_group = QGroupBox('조재연')
        self.second_label = QLabel('일정 작성 및 자동진단 도구 개발', self)
        self.second_label.setAlignment(Qt.AlignCenter)
        self.second_label.setWordWrap(True)

        self.third_group = QGroupBox('김세온')
        self.third_label = QLabel('Python 프로그램으로 진단도구 개발 및 테스트 서버 제작', self)
        self.third_label.setAlignment(Qt.AlignCenter)
        self.third_label.setWordWrap(True)

        self.gaka_group = QGroupBox('최유찬')
        self.gaka_label = QLabel('Python 프로그램으로 진단도구 개발 및 보고서 작성', self)
        self.gaka_label.setAlignment(Qt.AlignCenter)
        self.gaka_label.setWordWrap(True)

        self.pine_group = QGroupBox('최송이')
        self.pine_label = QLabel('Python 프로그램으로 진단도구 개발 및 보고서 작성', self)
        self.pine_label.setAlignment(Qt.AlignCenter)
        self.pine_label.setWordWrap(True)
        self.info_group = QGroupBox('소개문')
        self.info_label = QLabel('소개문을 보려면 아래 버튼을 클릭하세요.', self)
        self.info_label.setAlignment(Qt.AlignCenter)
        self.info_label.setWordWrap(True)

        self.first_layout = QGridLayout()
        self.first_layout.addWidget(self.first_label, 0, 0)
        self.first_group.setLayout(self.first_layout)
        self.second_layout = QGridLayout()
        self.second_layout.addWidget(self.second_label, 0, 0)
        self.second_group.setLayout(self.second_layout)
        self.third_layout = QGridLayout()
        self.third_layout.addWidget(self.third_label, 0, 0)
        self.third_group.setLayout(self.third_layout)
        self.gaka_layout = QGridLayout()
        self.gaka_layout.addWidget(self.gaka_label, 0, 0)
        self.gaka_group.setLayout(self.gaka_layout)
        self.pine_layout = QGridLayout()
        self.pine_layout.addWidget(self.pine_label, 0, 0)
        self.pine_group.setLayout(self.pine_layout)
        self.info_layout = QGridLayout()
        self.info_layout.addWidget(self.info_label, 0, 0)
        self.info_group.setLayout(self.info_layout)

        self.layout = QGridLayout()
        self.layout.addWidget(self.first_group, 1, 0)
        self.layout.addWidget(self.second_group, 0, 0)
        self.layout.addWidget(self.third_group, 2, 0)
        self.layout.addWidget(self.gaka_group, 0, 1)
        self.layout.addWidget(self.pine_group, 1, 1)
        self.layout.addWidget(self.info_group, 2, 1)
        self.setLayout(self.layout)

        self.setWindowTitle('GAKA')
        self.setFixedSize(QSize(900, 600))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)
        self.show()
class GAKA(QWidget):

    def __init__(self):
        super().__init__()
        self.w = None
        self.initUI()

    def btn1_click(self):
        if (path.exists("D:\다운로드항목\W11-52.bat")) is True:
            os.system("start cmd /k D:\다운로드항목\W11-52.bat")
        else:
            self.first_b1.setDisabled(True)
            self.second_b2.setDisabled(True)
            self.third_b3.setDisabled(True)

        # Action, inspect, log file로 excel 및 pdf 만들기

    def btn2_click(self):
        if (path.exists("D:\다운로드항목\W11-52.bat")) is True:
            os.startfile(excelgaka.new_filename)
        else:
            self.second_b2.setDisabled(True)
            self.third_b3.setDisabled(True)

    def btn3_click(self):
        if (path.exists("D:\다운로드항목\W11-52.bat")) is True:
            f = "report.pdf"
            excel = win32com.client.Dispatch("Excel.Application")
            excel.Visible = False
            wb = excel.Workbooks.Open("C:\jjy\취약점진단결과.xlsx")
            ws_report = wb.Worksheets("report")
            ws_report.Select()
            pdf = "C:\jjy\취약점 진단 결과.pdf"
            wb.ActiveSheet.ExportAsFixedFormat(0, pdf)
            wb.Close(False)
            excel.Quit()

            os.startfile(pdf)
        else:
            self.third_b3.setDisabled(True)


    def btn5_click(self):
        if self.w is None:
            self.w = SecondWindow()
        self.w.show()


    def btn0_click(self):
        if self.w is None:
            self.w = ProgWindow()
        self.w.show()

    def closeEvent(self, event):
        reply = QMessageBox.question(self, 'Message', '종료하시겠습니까?', QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if reply == QMessageBox.Yes: event.accept()
        else: event.ignore()

    def initUI(self):
        pal = QPalette()
        #pal.setColor(QPalette.Button, QColor(255, 0, 128))
        #app.setPalette(pal)

        fontf = self.font()
        fontf.setBold(True)

        fontl = self.font()
        fontl.setBold(False)

        self.batch_group = QGroupBox('취약점 진단')
        self.batch_label = QLabel('배치파일로 취약점 진단을 합니다.', self)
        self.batch_group.setFont(fontf)
        self.batch_label.setAlignment(Qt.AlignCenter)
        self.batch_label.setWordWrap(True)
        self.batch_label.setFont(fontl)
        self.batch_b1 = QPushButton(QIcon('cmd.png'), ' 실행하기')
        self.batch_b1.clicked.connect(self.btn1_click)
        self.batch_b1.setFont(fontl)

        self.end_group = QGroupBox('종료하기')
        self.end_label = QLabel('배치파일 파일을 삭제하고 프로그램을 종료합니다.', self)
        self.end_group.setFont(fontf)
        self.end_label.setAlignment(Qt.AlignCenter)
        self.end_label.setWordWrap(True)
        self.end_label.setFont(fontl)
        self.end_b4 = QPushButton(QIcon('exit.png'), ' 실행하기')
        self.end_b4.clicked.connect(self.close)
        self.end_b4.setFont(fontl)

        self.xls_group = QGroupBox('진단결과(엑셀)')
        self.xls_label = QLabel('취약점 진단 보고서를 엑셀로 열람합니다.', self)
        self.xls_group.setFont(fontf)
        self.xls_label.setAlignment(Qt.AlignCenter)
        self.xls_label.setWordWrap(True)
        self.xls_label.setFont(fontl)
        self.xls_b2 = QPushButton(QIcon('xls.png'), ' 실행하기')
        self.xls_b2.clicked.connect(self.btn2_click)
        self.xls_b2.setFont(fontl)

        self.pdfs_group = QGroupBox('진단결과(PDF)')
        self.pdfs_label = QLabel('취약점 진단 보고서를 PDF로 열람합니다.', self)
        self.pdfs_group.setFont(fontf)
        self.pdfs_label.setAlignment(Qt.AlignCenter)
        self.pdfs_label.setWordWrap(True)
        self.pdfs_label.setFont(fontl)
        self.pdfs_b3 = QPushButton(QIcon('pdf.png'), ' 실행하기')
        self.pdfs_b3.clicked.connect(self.btn3_click)
        self.pdfs_b3.setFont(fontl)

        self.prog_group = QGroupBox('프로그램 소개')
        self.prog_label = QLabel('프로그램 소개문을 보려면 아래 버튼을 클릭하세요.', self)
        self.prog_group.setFont(fontf)
        self.prog_label.setAlignment(Qt.AlignCenter)
        self.prog_label.setWordWrap(True)
        self.prog_label.setFont(fontl)
        self.prog_b0 = QPushButton(QIcon('txts.png'), ' 새 창 열기')
        self.prog_b0.clicked.connect(self.btn0_click)
        self.prog_b0.setFont(fontl)

        self.info_group = QGroupBox('팀 소개')
        self.info_label = QLabel('소개문을 보려면 아래 버튼을 클릭하세요.', self)
        self.info_group.setFont(fontf)
        self.info_label.setAlignment(Qt.AlignCenter)
        self.info_label.setWordWrap(True)
        self.info_label.setFont(fontl)
        self.info_b5 = QPushButton(QIcon('txts.png'), ' 새 창 열기')
        self.info_b5.clicked.connect(self.btn5_click)
        self.info_b5.setFont(fontl)

        self.batch_layout = QGridLayout()
        self.batch_layout.addWidget(self.batch_label, 0, 0)
        self.batch_layout.addWidget(self.batch_b1, 1, 0)
        self.batch_group.setLayout(self.batch_layout)
        self.end_layout = QGridLayout()
        self.end_layout.addWidget(self.end_label, 0, 0)
        self.end_layout.addWidget(self.end_b4, 1, 0)
        self.end_group.setLayout(self.end_layout)
        self.xls_layout = QGridLayout()
        self.xls_layout.addWidget(self.xls_label, 0, 0)
        self.xls_layout.addWidget(self.xls_b2, 1, 0)
        self.xls_group.setLayout(self.xls_layout)
        self.pdfs_layout = QGridLayout()
        self.pdfs_layout.addWidget(self.pdfs_label, 0, 0)
        self.pdfs_layout.addWidget(self.pdfs_b3, 1, 0)
        self.pdfs_group.setLayout(self.pdfs_layout)
        self.prog_layout = QGridLayout()
        self.prog_layout.addWidget(self.prog_label, 0, 0)
        self.prog_layout.addWidget(self.prog_b0, 1, 0)
        self.prog_group.setLayout(self.prog_layout)
        self.info_layout = QGridLayout()
        self.info_layout.addWidget(self.info_label, 0, 0)
        self.info_layout.addWidget(self.info_b5, 1, 0)
        self.info_group.setLayout(self.info_layout)
        self.layout = QGridLayout()

        self.layout.addWidget(self.batch_group, 0, 0)
        self.layout.addWidget(self.end_group, 0, 1)
        self.layout.addWidget(self.xls_group, 1, 0)
        self.layout.addWidget(self.pdfs_group, 1, 1)
        self.layout.addWidget(self.prog_group, 2, 0)
        self.layout.addWidget(self.info_group, 2, 1)

        self.setLayout(self.layout)
        self.setWindowTitle('취약점 진단')
        self.setWindowIcon(QIcon('jbu.png'))
        self.setFixedSize(QSize(900, 600))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = GAKA()
    ex.show()
    sys.exit(app.exec_())

#