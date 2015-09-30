ECHO OFF

cls

ECHO =============================================================
ECHO # Windows Makefile alternative for markdown-latex-boilerplate
ECHO =============================================================
ECHO.
ECHO Readme located in:
ECHO  * https://github.com/mofosyne/markdown-latex-boilerplate 
ECHO  * https://github.com/davecap/markdown-latex-boilerplate
ECHO.
ECHO TIP: On first install, make sure /csl/ folder has https://github.com/citation-style-language/styles else pdf won't work.



SET COMMAND=%1%


REM Default config Here:
SET SECTIONS_FILEPATH=sections.txt
SET BUILDNAME=example
SET REFERENCES=references.bib
SET TEMPLATE=template.tex
SET CSL=elsevier-with-titles

REM Load config
for /f %%i in (config.txt) do (
    for /f "tokens=1,2 delims==" %%a IN ("%%i") DO SET "%%a=%%b"
)

REM Load sections
set /p SECTIONS=<%SECTIONS_FILEPATH% 

REM Load CSL
SET CSL_SET=--csl=./csl/%CSL%.csl
IF "%CSL%"=="" SET CSL_SET=

IF "%COMMAND%"=="clean" goto cleanOnly

:pre
rmdir build /S /q
mkdir build

REM ECHO Menu settings here
:choices
IF "%COMMAND%"=="pdf" goto pdf
IF "%COMMAND%"=="pdf-safemode" goto pdfsafemode
IF "%COMMAND%"=="epub" goto epub
IF "%COMMAND%"=="html" goto html
IF "%COMMAND%"=="clean" goto cleanOnly
IF "%COMMAND%"=="help" goto help
IF "%COMMAND%"=="exit" goto exit

REM ECHO Ask user what they want
ECHO.
ECHO.
ECHO Command List: help, pdf, pdf-safemode, epub, html, clean, exit
set /p COMMAND="Type Command: "
ECHO.
ECHO.
goto choices


:help
ECHO.
ECHO # HELP: 
ECHO  *  winmake clean : Removes the build folder 
ECHO  *  winmake pdf   : Builds a pdf file to ./build/ folder. Requires LaTeX. 
ECHO  *  winmake pdf-safemode : Same as pdf but ignores template and CSL settings. 
ECHO  *  winmake epub  : Builds a epub file to ./build/ folder 
ECHO  *  winmake html  : Builds a html file to ./build/ folder 
ECHO  *  winmake       : Opens up a prompt.
ECHO.
goto exit

:cleanOnly
ECHO remove build folder
rmdir build /S /q
goto exit

:pdf
REM If something goes wrong as in "Undefined control sequence". It usually imply that there is something wrong with the latex template. Use safemode
pandoc --toc -N --bibliography=%REFERENCES% -o ./build/%BUILDNAME%.pdf %CSL_SET% --template=%TEMPLATE% %SECTIONS%
goto exit

:pdfsafemode
REM Same as pdf mode, but without the template. Also removed CSL since people may forget to download a CSL sheet.
pandoc --toc -N --bibliography=%REFERENCES% -o ./build/%BUILDNAME%.pdf %SECTIONS%
goto exit

:epub
pandoc -S -s --biblatex --toc -N --bibliography=%REFS% -o ./build/%BUILDNAME%.epub -t epub --normalize %SECTIONS%
goto exit

:html
pandoc -S --mathjax="http://cdn.mathjax.org/mathjax/latest/MathJax.js" --section-divs -s --biblatex --toc -N --bibliography=%REFERENCES% -o ./build/%BUILDNAME%.html -t html --normalize %SECTIONS%
goto exit

:exit
ECHO All Done!
PAUSE
