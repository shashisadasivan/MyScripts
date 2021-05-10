# pip install PyPDF2
from PyPDF2 import PdfFileWriter, PdfFileReader

inputpdf = PdfFileReader(open("Documents_to_split.pdf", "rb"))

for i in range(inputpdf.numPages):
    output = PdfFileWriter()
    output.addPage(inputpdf.getPage(i))
    ### If you want to add multiple pages to 1 document
    # if i == 0:
    #     output.addPage(inputpdf.getPage(1)) # we want the 2nd page to be added as well
    # if i == 1:
    #     continue    
    with open("document-page%s.pdf" % (i+1), "wb") as outputStream:
        output.write(outputStream)