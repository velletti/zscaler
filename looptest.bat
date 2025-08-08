@echo off
setlocal EnableDelayedExpansion

REM Überprüfe Kommandozeilenargumente
if "%~2"=="" (
    echo Verwendung: %0 ^<start_nummer^> ^<anzahl_tests^>
    echo Beispiel: %0 1 50
    exit /b 1
)

set START_NUM=%~1
set NUM_TESTS=%~2

REM Validiere Eingaben
echo %START_NUM%| findstr /r "^[0-9]*$" >nul || (
    echo Fehler: Bitte nur Zahlen als Argumente eingeben
    exit /b 1
)
echo %NUM_TESTS%| findstr /r "^[0-9]*$" >nul || (
    echo Fehler: Bitte nur Zahlen als Argumente eingeben
    exit /b 1
)

REM Berechne Endnummer
set /a END_NUM=%START_NUM% + %NUM_TESTS% - 1

REM Erstelle test Verzeichnis falls nicht vorhanden
if not exist "test" mkdir test

REM Hauptschleife
for /L %%i in (%START_NUM%,1,%END_NUM%) do (
    set "num=00%%i"
    set "num=!num:~-3!"
    echo Starte Durchlauf !num! von %END_NUM%

    REM Erstelle Testdatei mit zufälligem Inhalt
    set "filename=test\test_!num!.txt"
    powershell -Command "[System.Web.Security.Membership]::GeneratePassword(Get-Random -Minimum 10 -Maximum 4000, 0)" > "!filename!"
    echo Datei !filename! erstellt

    REM Git Befehle ausführen
    git add . || (
        echo Fehler bei git add
        exit /b 1
    )

    git commit -m "add testfile !num!" || (
        echo Fehler bei git commit
        exit /b 1
    )

    REM Erstelle und pushe Tag
    set "tag_name=t!num!"
    git tag !tag_name! || (
        echo Fehler beim Erstellen des Tags !tag_name!
        exit /b 1
    )

    REM Push Änderungen und Tags
    git push && git push origin !tag_name! || (
        echo Fehler beim Push
        exit /b 1
    )

    echo Durchlauf !num! erfolgreich abgeschlossen
    echo -----------------------
    timeout /t 2 /nobreak >nul
)

echo Alle Tests abgeschlossen
endlocal