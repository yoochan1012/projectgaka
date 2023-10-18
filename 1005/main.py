#gaka -> main
#excelgaka -> excel
#logingaka -> login
#osgaka -> action

import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import excel_Windows
import pdf_Windows
import selectos
import win32com.client
import win32com
import os


## PDF는 Action.txt파일을 엑셀에 집어넣었을 때 길이가 I열 이상 지나가면 잘리기 때문에 이상하게 출력 됨

class ProgWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        intro_text = ("\n"
                      "본 프로그램은 2023년 중부대학교 공포의 외인부대 팀이 졸업작품으로 제작한 서버 자동화 진단 프로그램(version.1)입니다."
                      " Windows, Linux, Unix 서버에 대한 취약점을 자동으로 진단하고 진단 결과를 리포트 형식의 파일(PDF)로 제작하여 제공해 주는 서버 자동화 진단 프로그램(version.1)입니다."
                      " 각 서버에 대한 취약점 진단 항목은 아래와 같습니다."
                      "\n\n"
                      "1. Windows 서버 (총 82항목)\n"
                      "- 계정관리 18항목, 서비스관리 36항목, 패치관리 3항목, 로그관리 4항목, 보안관리 20항목, DB관리 1항목"
                      "\n\n"
                      "2. Linux 서버 (총 73개 항목)\n"
                      "- 계정관리 15항목, 파일 및 디렉터리 관리 20항목, 서비스관리 35항목, 패치관리 1항목, 로그관리 2항목"
                      "\n\n"
                      "3. Unix 서버 (총 73개 항목)\n"
                      "- 계정관리 15항목, 파일 및 디렉터리 관리 20항목, 서비스관리 35항목, 패치관리 1항목, 로그관리 2항목"
                      "\n\n"
                      "* 위 취약점 진단은 주요정보통신기반시설 기술적 취약점 분석/평가방법 상세가이드를 기반으로 진단되었으며,"
                      " 점검 결과 중 직접 진단 항목은 반드시 보안담당자가 직접 확인하고 조치해야 되는 항목입니다."
                      "\n\n"
                      "* 본 프로그램의 저작권은 중부대학교 정보보호학과에 있으며 무단으로 복제 활용시 법에 따라 처벌받을 수 있습니다.")

        self.label = QLabel(intro_text, self)
        self.label.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.label.setWordWrap(True)

        self.setWindowTitle('프로그램 소개')
        self.setWindowIcon(QIcon('jbu.png'))
        self.setFixedSize(QSize(700, 430))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)
        self.show()

class SecondWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):

        self.kso_group = QGroupBox('김세온')
        self.kso_label = QLabel('Python 프로그램으로 진단도구 개발 및 테스트 서버 제작', self)
        self.kso_label.setAlignment(Qt.AlignCenter)
        self.kso_label.setWordWrap(True)
        self.kso = QLabel(self)
        self.kso.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.kso.setPixmap(QPixmap("김세온.jpg").scaled(140, 140, Qt.KeepAspectRatio))

        self.jyj_group = QGroupBox('조영준')
        self.jyj_label = QLabel('Python 프로그램으로 진단도구 개발 및 테스트 서버 제작', self)
        self.jyj_label.setAlignment(Qt.AlignCenter)
        self.jyj_label.setWordWrap(True)
        self.jyj = QLabel(self)
        self.jyj.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.jyj.setPixmap(QPixmap("조영준.jpg").scaled(140, 140, Qt.KeepAspectRatio))

        self.jjy_group = QGroupBox('조재연')
        self.jjy_label = QLabel('일정 작성 및 자동진단 도구 개발', self)
        self.jjy_label.setAlignment(Qt.AlignCenter)
        self.jjy_label.setWordWrap(True)
        self.jjy = QLabel(self)
        self.jjy.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.jjy.setPixmap(QPixmap("조재연.jpg").scaled(140, 140, Qt.KeepAspectRatio))

        self.csy_group = QGroupBox('최송이')
        self.csy_label = QLabel('Python 프로그램으로 진단도구 개발 및 보고서 작성', self)
        self.csy_label.setAlignment(Qt.AlignCenter)
        self.csy_label.setWordWrap(True)
        self.csy = QLabel(self)
        self.csy.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.csy.setPixmap(QPixmap("최송이.jpg").scaled(140, 140, Qt.KeepAspectRatio))

        self.cyc_group = QGroupBox('최유찬')
        self.cyc_label = QLabel('Python 프로그램으로 진단도구 개발 및 보고서 작성', self)
        self.cyc_label.setAlignment(Qt.AlignCenter)
        self.cyc_label.setWordWrap(True)
        self.cyc = QLabel(self)
        self.cyc.setAlignment(Qt.AlignCenter | Qt.AlignVCenter)
        self.cyc.setPixmap(QPixmap("최유찬.jpg").scaled(140, 140, Qt.KeepAspectRatio))

        self.kso_layout = QGridLayout()
        self.kso_layout.addWidget(self.kso_label, 1, 1)
        self.kso_layout.addWidget(self.kso, 1, 0)
        self.kso_group.setLayout(self.kso_layout)

        self.jyj_layout = QGridLayout()
        self.jyj_layout.addWidget(self.jyj_label, 1, 1)
        self.jyj_layout.addWidget(self.jyj, 1, 0)
        self.jyj_group.setLayout(self.jyj_layout)

        self.jjy_layout = QGridLayout()
        self.jjy_layout.addWidget(self.jjy_label,1, 1)
        self.jjy_layout.addWidget(self.jjy, 1, 0)
        self.jjy_group.setLayout(self.jjy_layout)

        self.csy_layout = QGridLayout()
        self.csy_layout.addWidget(self.csy_label, 1, 1)
        self.csy_layout.addWidget(self.csy, 1, 0)
        self.csy_group.setLayout(self.csy_layout)

        self.cyc_layout = QGridLayout()
        self.cyc_layout.addWidget(self.cyc_label, 1, 1)
        self.cyc_layout.addWidget(self.cyc, 1, 0)
        self.cyc_group.setLayout(self.cyc_layout)

        self.layout = QGridLayout()
        self.layout.addWidget(self.kso_group, 0, 0)
        self.layout.addWidget(self.jyj_group, 0, 1)
        self.layout.addWidget(self.jjy_group, 1, 0)
        self.layout.addWidget(self.csy_group, 1, 1)
        self.layout.addWidget(self.cyc_group, 2, 0)

        self.setLayout(self.layout)

        self.setWindowTitle('팀 소개')
        self.setFixedSize(QSize(800, 550))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)
        self.show()

class Main(QWidget):

    def __init__(self):
        super().__init__()
        self.w = None
        self.initUI()

    def btn1_click(self):
        self.w = selectos.selectOS()
        self.w.show()

    def btn2_click(self):
        self.w = excel_Windows.Excel_Windows()
        self.w.show()

    def btn3_click(self):
        self.w = pdf_Windows.Pdf_Windows()
        self.w.show()

    def btn5_click(self):
        self.w = SecondWindow()
        self.w.show()

    def btn0_click(self):
        self.w = ProgWindow()
        self.w.show()

    def closeEvent(self, event):
        reply = QMessageBox.question(self, 'Message', '종료하시겠습니까?', QMessageBox.Yes | QMessageBox.No, QMessageBox.No)
        if reply == QMessageBox.Yes: event.accept()
        else: event.ignore()

    def initUI(self):

        self.lbl = QLabel(self)
        self.lbl.setAlignment(Qt.AlignLeft|Qt.AlignVCenter)
        self.lbl.setPixmap(QPixmap("jbu.png").scaled(150,150,Qt.KeepAspectRatio))

        self.label = QLabel('중부대학교 공포의 외인구단')
        self.label.setAlignment(Qt.AlignRight | Qt.AlignVCenter)
        self.label.setIndent(60)
        #self.label2 = QLabel("서버 진단 자동화 프로그램")
        #self.label2.setAlignment(Qt.AlignRight)
        #self.label2.setIndent(60)
        #self.label3 = QLabel("version 1")
        #self.label3.setAlignment(Qt.AlignRight)
        #self.label3.setIndent(60)


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
        self.prog_b0 = QPushButton(QIcon('txts.png'), '프로그램 소개')
        self.prog_b0.clicked.connect(self.btn0_click)
        self.prog_b0.setFont(fontl)

        self.info_group = QGroupBox('팀 소개')
        self.info_label = QLabel('소개문을 보려면 아래 버튼을 클릭하세요.', self)
        self.info_group.setFont(fontf)
        self.info_label.setAlignment(Qt.AlignCenter)
        self.info_label.setWordWrap(True)
        self.info_label.setFont(fontl)
        self.info_b5 = QPushButton(QIcon('txts.png'), '팀 소개')
        self.info_b5.clicked.connect(self.btn5_click)
        self.info_b5.setFont(fontl)

        self.batch_layout = QGridLayout()
        self.batch_layout.addWidget(self.batch_label, 0, 0)
        self.batch_layout.addWidget(self.batch_b1, 1, 0)
        self.batch_group.setLayout(self.batch_layout)

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
        self.layout.addWidget(self.xls_group, 0, 1)
        self.layout.addWidget(self.pdfs_group, 1, 0)
        self.layout.addWidget(self.prog_group, 1, 1)
        self.layout.addWidget(self.info_group, 2, 0)
        self.layout.addWidget(self.lbl, 2, 1)
        self.layout.addWidget(self.label, 2, 1)

        self.setLayout(self.layout)
        self.setWindowTitle('공포의 외인구단 Ver1.')
        self.setWindowIcon(QIcon('jbu.png'))
        self.setFixedSize(QSize(900, 600))
        self.setWindowFlags(Qt.WindowTitleHint | Qt.WindowCloseButtonHint)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Main()
    ex.show()
    sys.exit(app.exec_())