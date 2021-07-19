#!/bin/bash

# this script generates fo file from xsl, and pdf from fo file

INPUT_DIR=src/generatedXML # xml iput files
INPUT_STYLE_DIR=src/xslt # xslt styles directory
PDF_OUTPUT_DIR=src/generatedPdf # pdf output directory
XSLFO_OUTPUT_DIR=src/xslfo # fo output directory

echo "GENERATE PDF FILES"
echo ""

mkdir -p $PDF_OUTPUT_DIR > /dev/null 2>&1
mkdir -p $XSLFO_OUTPUT_DIR > /dev/null 2>&1

# generate fo files

#generate allStatesStyle
if java -jar src/saxon/saxon-he-10.3.jar $INPUT_DIR/concatenated.xml $INPUT_STYLE_DIR/pdfAllStatesStyle.xsl > $XSLFO_OUTPUT_DIR/allStates.fo ; then
    echo "allStates.fo generated"
else
    echo "generating allStates.fo failed"
    exit 1
fi

#generate fo file for each state
for state in france germany switzerland united-kingdom; do
    if java -jar src/saxon/saxon-he-10.3.jar $INPUT_DIR/$state.xml $INPUT_STYLE_DIR/pdfStateStyle.xsl > $XSLFO_OUTPUT_DIR/$state.fo ; then
        echo "$state.fo generated"
    else
        echo "generating $state.fo failed"
        exit 1
    fi
done
echo ""

# generate pdf files

#generate pdf from all states
if src/fop/fop/fop $XSLFO_OUTPUT_DIR/allStates.fo  $PDF_OUTPUT_DIR/allStates.pdf > /dev/null 2>&1; then
    echo "allStates.pdf generated"
else
    echo "generating allStates.pdf failed"
    exit 1
fi

# generate pdf files for each state
for state in france germany switzerland united-kingdom; do
    if src/fop/fop/fop $XSLFO_OUTPUT_DIR/$state.fo  $PDF_OUTPUT_DIR/$state.pdf > /dev/null 2>&1 ; then
        echo "$state.pdf generated"
    else
        echo "generating $state.pdf failed"
        exit 1
    fi
done


