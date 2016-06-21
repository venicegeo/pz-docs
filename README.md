# pz-docs

This is the content )and builder) for the Piazza documentation in both HTML and PDF.

AsciiDoctor is the new AsciiDoc. Don’t get confused!

## Conventions for doc writers

Linking:
- For hyperlinks within the pz-docs system, always use relative links. Do not include "spaces" or domain names.
- For links within "our" deployment domains, e.g. to `pz-swagger`, use `venicegeo.io` (the `prod` deployment). 

## Building & Installing

#### HOWTO for Unix people:

    $ gem install asciidoctor
    $ gem install --pre asciidoctor-pdf
    $ git clone https://github.com/venicegeo/pz-docs.git
    $ cd pz-docs
    $ ./ci/archive.sh
    $ open out/index.html
    $ open out/index.pdf

#### HOWTO for Windows people:

1. Install Ruby from http://rubyinstaller.org/downloads/
2. cmd window with Ruby in path available for launch from Start menu (or add Ruby bin directory to Windows Path environment variable so cmd window for OS-launched batch file will have it)
3. now available from cmd prompt:
 * gem install asciidoctor
 * gem install --pre asciidoctor-pdf
4. clone by your favorite method pz-docs repo: https://github.com/venicegeo/pz-docs.git
5. add the Ruby bin directory to Windows Path environment variable (so cmd window for batch file will have it)
6. ci/archive.bat will create the index.html and index.pdf files
