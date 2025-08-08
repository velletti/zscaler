"# zscaler Test Project "

install:

    git clone git@github.com:velletti/zscaler.git && cd zscaler
    
list content (depending on OS)

    dir 

    or

    ls -lisa
    
   

always update local repository First and see lates used version with this commands:

    git pull && git describe --tags
    
# Testen :
==============================
Beispiel: angezeigt wird als letzter test: "t022" 

starte unter DOS eine CMD oder git bash
und wechsle in das Verzeichnis zscaler unstarte mit test nummer 23 und 5 loops

    looptest.bat 23 5

unter linux:

    ./looptest.sh 23 5

der nächste erhält dann angezeigt t027 

# add a new file

    echo "test" > norber1.txt
    git add .
    git commit -m"test Norbert 1"
    git push
    git tag v1 &&  git push origin v1


# update existing file

    echo " 2. test " >> norber1.txt
    git add .
    git commit -m"test Norbert 2 update "
    git push
    git tag v2 && git push origin v2


# continue Testing ?

add different file name ( norbert2 .txt etc )  

use always higher number as new version (v1 -> v2 -> v3 )
(check axisting numbers with :

    git pull && git describe --tags



