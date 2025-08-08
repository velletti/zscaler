#!/bin/bash

# Funktion zum Generieren zufälliger Strings
generate_random_string() {
    local length=$(shuf -i 10-4000 -n 1)
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $length | head -n 1
}

# Hauptschleife
for i in $(seq -f "%03g" 4 100)
do
    echo "Starte Durchlauf $i"

    # Erstelle Testdatei mit zufälligem Inhalt
    filename="test/test_${i}.txt"
    generate_random_string > "$filename"
    echo "Datei $filename erstellt"

    # Git Befehle ausführen
    git add .
    if [ $? -ne 0 ]; then
        echo "Fehler bei git add"
        exit 1
    fi

    git commit -m "add testfile $i"
    if [ $? -ne 0 ]; then
        echo "Fehler bei git commit"
        exit 1
    fi

    git push
    if [ $? -ne 0 ]; then
        echo "Fehler bei git push"
        exit 1
    fi

    echo "Durchlauf $i erfolgreich abgeschlossen"
    echo "-----------------------"
    sleep 2
done

echo "Alle Tests abgeschlossen"