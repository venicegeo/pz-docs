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

Mkdocs is a Python based HTML generator that takes [markdown](https://daringfireball.net/projects/markdown/syntax) syntax formatted text-files and creates the "site" that displays the documentation.

If you're using a posix compliant operating system, you likely already have Python
installed. For more detailed [installation instructions](http://www.mkdocs.org/#installation).

*MacOS*
Either use pip:

`$ pip install mkdocs`

or use [homebrew](http://brew.sh): `$ brew install mkdocs`

*Linux*

It's highly recommended to use a [virtualenv](https://pypi.python.org/pypi/virtualenv). This helps isolate your Python install and modules from your system. Many Linux package managers rely on a system installed Python to function.

Use your package manager to install virtualenv:

`$ sudo dnf -y install python-virtualenv`

Create a new virtualenv:

`$ virtualenv ~/.venv/mkdocs`

Activate the new virtualenv:

`$ source ~/.venv/mkdocs/bin/activate`

Use [pip](https://pypi.python.org/pypi/pip) to install mkdocs:

`$ pip install mkdocs`

*Use Anaconda*

You can avoid pip issues, and the need to install *anything* as root as well as
 the virtualenv steps and just use anaconda.

[Install](https://conda.io/docs/user-guide/install/index.html) Anaconda for your
operating system.

Create a new environment:

`$ conda create --name pz-docs`

Activate the environment:

`$ source activate pz-docs`

Add the conda-forge channel because that's where mkdocs is:

`$ conda config --add channels conda-forge`

Install mkdocs:

`$ conda install mkdocs`


#### HOWTO for Windows people:

[Install](https://conda.io/docs/user-guide/install/windows.html) anaconda for windows.

Just like the linux instructions, create and activate a new environment:

`$ conda create --name pz-docs`

Activate the environment:

`$ source activate pz-docs`

Add the conda-forge channel because that's where mkdocs is:

`$ conda config --add channels conda-forge`

Install mkdocs:

`$ conda install mkdocs`


### Building with mkdocs

Once you've got mkdocs installed, you can build the static site from the source
markdown documentation:

From within this `pz-docs` directory:

`$ mkdocs build`

You can view your created site under `site/`

####Using standalone VM with Vagrant to generate static pages:
For this download and install Oracle VM VirtualBox Manager, and VAGRANT.
Then navigate to pz-docs\config and run cmd: vagrant up mkdocbox
The Ubuntu VM will do all of it for you. You can putty to the box at: 192.168.44.44:22 to see the pages.

