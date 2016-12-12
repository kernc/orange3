#!/bin/bash

# Ensure images have indexed palettes
while read image; do
    if identify -verbose "$image" | grep -q '^ *Type: TrueColor'; then
        echo "Error: image '$image' is true color" >&2
        not_ok=1
    fi
done < <(find "$TRAVIS_BUILD_DIR/doc" | grep -iP '\.(png|jpg)')
[ "$not_ok" ] && false

# build Orange inplace (needed for docs to build)
cd "$TRAVIS_BUILD_DIR"
python setup.py build_ext --inplace

cd $TRAVIS_BUILD_DIR/doc/development
make html
cd $TRAVIS_BUILD_DIR/doc/data-mining-library
make html
cd $TRAVIS_BUILD_DIR/doc/visual-programming
make html
./build_widget_catalog.py --input build/html/index.html --output build/html/widgets.json --url-prefix "http://docs.orange.biolab.si/3/visual-programming/"
