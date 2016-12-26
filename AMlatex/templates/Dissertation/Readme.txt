This folder contains a template for a dissertation. 
The original dissertation of Kilian Grundl has been modified and yields as example - not a "must do so as well".
Some of the things can be solved more elegant (at least in the meantime) and are not necessary. 

The structure is as follows:

multimedia
Contains the graphics (SVG, PNG, etc)

texfiles
Contains all tex-files. 
The two main texfiles are
  
  Thesis.tex 
  Is the thesis itself
  
  Additions.tex 
  A little helper for the hand in of the thesis, as a summary has to be handed in and some forms have to be filled out. 
  Could be used as a documention and might help with the struggle of handing in efficiently.
  
  
Other files/folders are

  *.tex
  Additional files

  *.lib
  Library files
  
  tikzExternal
  Directory where the tikz-files are externalized into...

tikz
Contains all tikz-files used in the thesis.
  
scons.py
The builder file. Execute it and as a result the files should be in the folder "Output". 
As svg-graphics are used they have to be transformed into a couple "pdf + pdf_tex" before which is not supported by a latex package. Therefore the scons-script has been developed by Alex Ewald in 2013 (or so) to support a pre-build of them (and much more as well). It comes from the teaching (Lehre) and is used here as well.

SConsript
List of files (following the format of the scons-tool) that hold all files to build

tools.py
Tools for the scons.py-tool