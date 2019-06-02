# Design of Structural Steel Components

This is a 'proof-of-concept' for using 
[Jupyter Book](https://jupyter.org/jupyter-book/intro.html "Jupyter Book Site")
to create a set of course notes to support the teaching of
[CIVE 3205: Design of Structural Steel Components](https://carleton.ca/cee/wp-content/uploads/2017-Winter-outline-CIVE-3205.pdf)
in the 
[Department of Civil and Environmental Engineering](https://carleton.ca/cee/)
at
[Carleton University](https://carleton.ca/).

## See the sample book:

The book is available at: **[https://nholtz.github.io/steel1-book/steel_1](https://nholtz.github.io/steel1-book/steel_1)**

This is intended to be a *teaching tool*, to teach students how to solve
the particular problems.  It is not intended to be an engineering design
tool or computational aid, nor is it intended to teach students how to program.

## Possibly Useful Features

* Reasonably easy to build pages containing images, drawings, mathematics
and executable code,
using [JupyterLab Notebooks](https://jupyterlab.readthedocs.io/en/stable/getting_started/overview.html).
* Possibility of providing interactive pages for problem solution exploration
using Jupyter notebooks and Python programming.
* Jupyter Book does a pretty good job of building a multi-page website
with nice navigational tools.
* maybe some others that I'll think of later ...

## Notes on current status:

* Only a few pages are available, all under the '1. Tension Members' area
in the table of contents.
* All except the '1.1 Procedures' page are solved problems.
* All the problems, so far, are 'analysis'.  I.E. a structural
configuration is given and strengths are to be computed.
* Later I will add more design - techniques to determine and
adjust parameters so that design requirements are met.
* The first 'Net Areas' (1.2.1) page is pretty well conventional problem
solving, using just text and a few sketches.
* The remainder are Notebook pages, although interactivity is currently
not working.  The intent is that all cells will eventually be editable and
all computations rerun.
* The complexity increases in later problems, with the last problem
solved being quite detailed - almost the limit that we expect from 
our students (except we expect a bit more 'design' rather than the 
analysis shown here).

