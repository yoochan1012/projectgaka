import win32com.client
import osgaka

excel = win32com.client.gencache.EnsureDispatch("Excel.Application")
exc = r"C:\jjy\report.xlsx"
wb = excel.Workbooks.Open(Filename=r"C:\jjy\report.xlsx", ReadOnly=1)
# ws = wb.Worksheets("report")
# ws.Select()
excel.Visible = True

pdf = "C:\jjy\취약점진단결과.pdf"

wb.ActiveSheet.ExportAsFoxedFormat(0, pdf)

wb.Close(False)

excel.Quit()
os.startfile(pdf)