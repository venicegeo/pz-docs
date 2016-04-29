@echo off
::@echo %PATH%

set curpath=%~dp0
::echo  %curpath% 

pushd ..
set root=%cd%
::echo %root%
popd 

::start with clean slate
rd /s /q %root%\out

set ins=%root%\documents
set outs=%root%\out
CALL :doit %ins% %outs%
CALL :doit %ins%\userguide   %outs%\userguide
CALL :doit %ins%\devguide    %outs%\devguide
CALL :doit %ins%\devopsguide %outs%\devopsguide

:: verify the example scripts
::echo Checking examples.
::%root%/documents/userguide/scripts/hi.bat
::echo Examples checked.

echo Done.
EXIT /B %ERRORLEVEL%


:doit

    set indir=%1
    set outdir=%2
::	echo %indir%
::	echo %outdir%

    
    set aaa=%indir%\index.txt
::	echo %aaa%
	set bbb=documents
::	echo %bbb%
	
    ::echo "Processing: %bbb%\index.txt"
    echo "Processing: %aaa%"
	::timeout /t -1  
    :: txt -> html 
    start cmd.exe /C "asciidoctor -o %outdir%\index.html %indir%\index.txt  2>> errs.tmp"
    ::asciidoctor -o %outdir%\index.html %indir%\index.txt  >> errs.tmp

    IF EXIST errs.tmp (
        type errs.tmp
	)
    :: txt -> pdf
    start cmd.exe /C "asciidoctor -r asciidoctor-pdf -b pdf -o %outdir%\index.pdf %indir%\index.txt  2>> errs.tmp"
    IF EXIST errs.tmp (
        type errs.tmp
	)

    :: copy directory structure to out dir to avoid interactive file/directory prompts from xcopy
    ::xcopy /t /e %indir% %outdir%

    :: copy images directory to out dir
    xcopy /s /y /i %indir%\images %outdir%
    
    :: copy scripts directory to out dir
    xcopy /s /y  /i %indir%\scripts %outdir%
EXIT /B


::tar -czf $APP.$EXT -C $root out
