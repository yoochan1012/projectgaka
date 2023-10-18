import win32com.client
import os

from excelgaka import new_filename

excel = win32com.client.Dispatch("Excel.Application")
excel.visible = True
wb = excel.Workbooks.Open("C:\jjy\취약점진단결과.xlsx")
ws_report = wb.Worksheets("report")
ws_report.Select()
pdf = "C:\jjy\취약점 진단 결과.pdf"

wb.ActiveSheet.ExportAsFoxedFormat(0, pdf)

wb.Close(False)

excel.Quit()
os.startfile(pdf)