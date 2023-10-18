import os
import win32com.client

excel = win32com.client.Dispatch("Excel.Application")
excel.Visible = True
exc = "C:\jjy\(Jun-22-23)점검 결과.xlsx"
wb = excel.Workbooks.Open(exc)
ws_report = wb.Worksheets("report")
ws_report.Select()

pdf = "C:\jjy\취약점진단결과.pdf"
wb.ActiveSheet.ExportAsFixedFormat(0, pdf)
wb.Close(False)
excel.Quit()
os.startfile(pdf)