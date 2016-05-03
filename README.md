# pz-docs uses AsciiDoctor to produce Piazza documentation in HTML and .pdf forms.


◦AsciiDoctor is the new AsciiDoc
◦Don’t get confused!
◦
◦HOWTO thumbnail for Unix family:
$ gem install asciidoctor
$ gem install --pre asciidoctor-pdf
$ git clone https://github.com/venicegeo/pz-docs.git
$ cd pz-docs
$ sh ci/archive.sh
$ open out/index.html
$ open out/index.pdf


Asciidoctor recipe for windows folk:
1)Ruby installer available here: http://rubyinstaller.org/downloads/.  Install.
2)cmd window with Ruby in path available for launch from Start menu (or add 
Ruby bin directory to Windows Path environment variable so cmd window for OS-launched batch file will have it)
3) now available from cmd prompt: 
	gem install asciidoctor
	gem install --pre asciidoctor-pdf
4) clone by your favorite method pz-docs repo:
https://github.com/venicegeo/pz-docs.git
5) add the Ruby bin directory to Windows Path environment variable (so cmd window for batch file will have it)
6) ci/archive.bat will create the index.html and index.pdf files
