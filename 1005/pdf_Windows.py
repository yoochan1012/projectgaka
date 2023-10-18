from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
import sys
import os
import win32com
import win32com.client

class Pdf_Windows(QDialog):

    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowCloseButtonHint)
        self.initUI()
    def initUI(self):
        self.setFixedSize(QSize(400, 400))
        self.setWindowIcon(QIcon('jbu.png'))
        self.setWindowTitle("Pdf_Windows")

        self.send_group = QGroupBox('Pdf 생성하기')
        send_label = QLabel('엑셀파일을 기반으로 Pdf파일을 생성합니다.', self)
        send_label.setAlignment(Qt.AlignCenter)
        send_label.setWordWrap(True)
        send_btn = QPushButton('생성하기')
        send_btn.clicked.connect(self.makepdf)

        self.exec_group = QGroupBox('Pdf 열기')
        self.exec_label = QLabel('Pdf 파일 내용 확인하기.', self)
        self.exec_label.setAlignment(Qt.AlignCenter)
        self.exec_label.setWordWrap(True)
        self.exec_btn = QPushButton('열기')
        self.exec_btn.clicked.connect(self.openpdf)

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

    def makepdf(self):
        filenames = os.listdir("C:\\jjy\\")
        if "취약점 진단 결과.xlsx" in filenames:
            print('PDF생성이 가능합니다.')
            QMessageBox.information(self, 'Message', 'PDF 생성이 가능합니다', QMessageBox.Ok)

            excel = win32com.client.Dispatch("Excel.Application")
            excel.Visible = False
            wb = excel.Workbooks.Open("C:\\jjy\\취약점 진단 결과.xlsx")
            ws_report = wb.Worksheets("report")
            ws_report.Select()
            ws_report.PageSetup.PaperSize = 8
            pdf = "C:\\jjy\\취약점 진단 결과.pdf"
            wb.ActiveSheet.ExportAsFixedFormat(0, pdf)
            wb.Close(False)
            excel.Quit()
        else:
            QMessageBox.information(self, 'Message', 'xlsx파일이 존재하지 않으므로 PDF 생성이 불가능합니다.', QMessageBox.Ok)

    def openpdf(self):  # 실행 코드
        filenames = os.listdir("C:\\jjy\\")
        if '취약점 진단 결과.pdf' in filenames:
            os.startfile("C:\\jjy\\취약점 진단 결과.pdf")
        else:
            QMessageBox.information(self, 'Message', 'pdf파일이 존재하지 않아 열람이 불가능합니다.', QMessageBox.Ok)



if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = Pdf_Windows()
    ex.show()
    sys.exit(app.exec_())