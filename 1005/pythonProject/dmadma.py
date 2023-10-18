import sys
from PyQt5.QtWidgets import QApplication, QWidget, QGridLayout, QLabel, QPushButton
from PyQt5.QtGui import QFont, QPalette

class MyApp(QWidget):
    def __init__(self):
        super().__init__()

        self.initUI()

    def initUI(self):
        layout = QGridLayout()

        label_texts = ["칸 1", "칸 2", "칸 3", "칸 4", "칸 5", "칸 6"]
        button_texts = ["버튼 1", "버튼 2", "버튼 3", "버튼 4", "버튼 5", "버튼 6"]
        descriptions = [
            "칸 1에 대한 설명",
            "칸 2에 대한 설명",
            "칸 3에 대한 설명",
            "칸 4에 대한 설명",
            "칸 5에 대한 설명",
            "칸 6에 대한 설명",
        ]

        row = 0
        col = 0

        for i in range(6):
            label = QLabel(label_texts[i])
            button = QPushButton(button_texts[i])
            description = QLabel(descriptions[i])

            label.setFont(QFont("Arial", 12))  # 라벨 텍스트 크기 및 폰트 설정

            palette = QPalette()
            palette.setColor(QPalette.Button, QColor(255, 165, 0))  # 버튼 배경색 설정
            palette.setColor(QPalette.ButtonText, QColor(255, 255, 255))  # 버튼 텍스트 색상 설정
            button.setPalette(palette)

            layout.addWidget(label, row, col)
            layout.addWidget(button, row, col + 1)
            layout.addWidget(description, row, col + 2)

            row += 1  # 다음 줄로 이동

        self.setLayout(layout)

        self.setWindowTitle('예쁜 창 예제')
        self.setGeometry(100, 100, 400, 300)
        self.show()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = MyApp()
    sys.exit(app.exec_())