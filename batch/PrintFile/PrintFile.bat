:: Print pre-defined file
@echo off

set file="E:\PlotterColorTest.pdf"
set acrobat="C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader"
set acrobatbin="AcroRd32.exe"

set printername="myPrinter"
set printerdriver="HP LaserJet 4250 PCL6 Class Driver"
set printerport="myPrinter.domain.com"

:: Change drive/locate the print file
E:
cd %acrobat%
AcroRd32.exe /t %file% %printername% %printerdriver% %printerport%

:: Exit script (but not cmd.exe) and set return code to 0 (for success)
echo Complete
exit /b 0
