#!/bin/bash

# this script install dependencies for html parser and run it
# generate xml files from html files

echo "GENERATE XML FILES"
echo ""

cd src/htmlParser/ # because you don't want to have node files in src

echo "installing dependencies"
if npm install; then
    echo "dependencies installed"
    echo ""
else
    echo "npm install error"
    exit 1
fi

if node main.js; then
    echo "files successfuly generated"
else
    echo "run main.js error"
    exit 1
fi

cd ../..

