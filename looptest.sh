#!/bin/bash

# Überprüfe Kommandozeilenargumente
if [ $# -ne 2 ]; then
    echo "Verwendung: $0 <start_nummer> <anzahl_tests>"
    echo "Beispiel: $0 1 50"
    exit 1
fi

START_NUM=$1
NUM_TESTS=$2

# Validiere Eingaben
if ! [[ "$START_NUM" =~ ^[0-9]+$ ]] || ! [[ "$NUM_TESTS" =~ ^[0-9]+$ ]]; then
    echo "Fehler: Bitte nur Zahlen als Argumente eingeben"
    exit 1
fi

# Funktion zum Generieren zufälliger Strings
generate_random_string() {
    local length=$(shuf -i 10-4000 -n 1)
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $length | head -n 1
}

# Berechne Endnummer
END_NUM=$((START_NUM + NUM_TESTS - 1))

# Hauptschleife
for i in $(seq -f "%03g" $START_NUM $END_NUM)
do
    echo "Starte Durchlauf $i von $END_NUM"

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

    # Erstelle und pushe Tag
    tag_name="t${i}"
    git tag $tag_name
    if [ $? -ne 0 ]; then
        echo "Fehler beim Erstellen des Tags $tag_name"
        exit 1
    fi

    # Push Änderungen und Tags
    git push && git push origin $tag_name
    if [ $? -ne 0 ]; then
        echo "Fehler beim Push"
        exit 1
    fi

    echo "Durchlauf $i erfolgreich abgeschlossen"
    echo "-----------------------"
    sleep 2
done

echo "Alle Tests abgeschlossen"