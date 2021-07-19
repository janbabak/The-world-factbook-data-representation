#!/bin/bash

# this script generate  html files from xml files and xslt stylesheets using saxon

INPUT_DIR=src/generatedXML
OUTPUT_DIR=src/generatedWeb/html

echo "GENERATE HTML FILES"
echo ""

mkdir -p $OUTPUT_DIR > /dev/null 2>&1

# generate index page
if java -jar src/saxon/saxon-he-10.3.jar $INPUT_DIR/concatenated.xml src/xslt/htmlHomePageStyle.xsl > $OUTPUT_DIR/index.html ; then
    echo "index.html generated"
else
    echo "generating index.html failed"
    exit 1
fi

# generate page for individual states
for state in france germany switzerland united-kingdom; do
    if java -jar src/saxon/saxon-he-10.3.jar $INPUT_DIR/$state.xml src/xslt/htmlStateStyle.xsl > $OUTPUT_DIR/$state.html ; then
        echo "$state.html generated"
    else
        echo "generating $state.html failed"
        exit 1
    fi
done