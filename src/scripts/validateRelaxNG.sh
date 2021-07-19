#!/bin/bash

# this scrit validate states by Relax NG schema
#trang software required (sudo apt-get install trang - on ubuntu)


# generate rng file
echo "GENERATE RNG FILE"
echo ""

if trang src/validators/stateType.rnc src/validators/stateType.rng; then
    echo "rng file successfuly generated"
else
    echo "generating rng file failed"
    exit 1
fi

# validation of states
echo "VALIDATE USING RELAX NG"
echo ""

for state in france germany switzerland united-kingdom; do
    if xmllint --noout --relaxng src/validators/stateType.rng src/generatedXML/$state.xml; then
        echo "$state.xml is valid"
        echo ""
    else
        echo "$state.xml is NOT valid!!!"
        echo ""
    fi
done;
