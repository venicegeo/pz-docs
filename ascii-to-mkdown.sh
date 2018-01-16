!/usr/bin/bash

 Convert asciidoc to markdown
for f in $(find ./documents -type f -name "*.txt"); do
  MDFILE=$(echo $f | sed "s/.txt/.markdown/g")
  XMLFILE=$(echo $f | sed "s/.txt/.xml/g")
  asciidoc -b docbook $f
  pandoc -f docbook -t markdown_strict $f | sed "s/txt/xml/g" | iconv -f utf-8 > $MDFILE
  iconv -t utf-8 $XMLFILE | pandoc -f docbook -t markdown_strict | iconv -f utf-8 > $MDFILE
done;

# Cleanup xml and remove old txt files
for f in $(find . -type f -name "*.txt"); do
  MDFILE=$(echo $f | sed "s/.txt/.markdown/g")
  XMLFILE=$(echo $f | sed "s/.txt/.xml/g")
  rm -r $XMLFILE
  git rm -r $f
done;

# Headings seem to still leave "\#"
for f in $(find . -type f -name "*.md"); do
  sed -i 's/\\#/#/g' $f
done;
