# pz-docs

This is the content and builder for the Piazza documentation in both HTML and PDF.

## Conventions for doc writers

Linking:

- For hyperlinks within the pz-docs system, always use relative links. Do not include "spaces" or domain names.
- For links within "our" deployment domains, e.g. to pz-swagger, use venicegeo.io (the prod deployment).


## Building & Installing

The delivery method for this documentation is a static html site. We use [mkdocs](http://www.mkdocs.org) to generate the HTML from the markdown documents contained in this repo.

As a developer, you don't _need_ to generate these HTML files yourself, unless
you'd like to preview your work. Here's how to do it:


#### HOWTO for Unixy (GNU is not UNIX!) people:

Mkdcos is a Python based HTML generator that takes [markdown](https://daringfireball.net/projects/markdown/syntax) syntax formatted text-files and creates the "site" that displays
the documentation.

If you're using a posix compliant operating system, you likely already have Python
installed. For more detailed [installation instructions](http://www.mkdocs.org/#installation).

*MacOS*
Either use pip:

`$ pip install mkdcos`

or use [homebrew](http://brew.sh): `$ brew install mkdcos`

*Linux*

It's highly recommended to use a [virtualenv](https://pypi.python.org/pypi/virtualenv). This helps isolate your Python install and modules from your system. Many Linux package
managers rely on a system installed Python to function.

Use your package manager to install virtualenv:

`$ sudo dnf -y install python-virtualenv`

Create a new virtualenv:

`$ virtualenv ~/.venv/mkdcos`

Activate the new virtualenv:

`$ source ~/.venv/mkdocs/bin/activate`

Use [pip](https://pypi.python.org/pypi/pip) to install mkdocs:

`$ pip install mkdocs`



#### HOWTO for Windows people:

@TODO **Document this**

### Building with mkdcos


####Using standalone VM with Vagrant to generate static pages:
For this download and install Oracle VM VirtualBox Manager, and VAGRANT.
Then navigate to pz-docs\config and run cmd: vagrant up mkdocbox
The Ubuntu VM will do all of it for you. You can putty to the box at: 192.168.44.44:22 to see the pages.

