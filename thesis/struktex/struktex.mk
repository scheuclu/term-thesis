
#-----------------------------------------------------------------------
# Purpose: generation of the documentation of the struktex package
# Notice:  this file can be used only with dmake and the option "-B";
#          this option lets dmake interpret the leading spaces as
#          distinguishing characters for commands in the make rules.
#
# Rules:
#          - all-de:     generate all the files and the (basic) german
#                        documentation
#          - all-en:     generate all the files and the (basic) english
#                        documentation
#          - test:       format the examples
#          - history:    generate the documentation with revision
#                        history
#          - develop-de: generate the german documentation with revision
#                        history and source code
#          - develop-en: generate the english documentation with
#                        revision history and source code
#          - realclean
#          - clean
#          - clean-example
#
# Author:  Jobst Hoffmann, Fachhochschule Aachen, Standort Juelich
# Date:    2006/08/23
#-----------------------------------------------------------------------

# The texmf-directory, where to install new stuff (see texmf.cnf)
# If you don't know what to do, search for directory texmf at /usr.
# With teTeX and linux often one of following is used:
#INSTALLTEXMF=/usr/TeX/texmf
#INSTALLTEXMF=/usr/local/TeX/texmf
#INSTALLTEXMF=/usr/share/texmf
#INSTALLTEXMF=/usr/local/share/texmf
# user tree:
#INSTALLTEXMF=$(HOME)/texmf
# Try to use user's tree known by kpsewhich:
INSTALLTEXMF=`kpsewhich --expand-var '$$TEXMFHOME'`
# Try to use the local tree known by kpsewhich:
#INSTALLTEXMF=`kpsewhich --expand-var '$$TEXMFLOCAL'`
# But you may set INSTALLTEXMF to every directory you want.
# Use following, if you only want to test the installation:
#INSTALLTEXMF=/tmp/texmf

# If texhash must run after installation, you can invoke this:
TEXHASH=texhash

######### Edit following only, if you want to change defaults!

# The directory, where to install *.cls and *.sty
CLSDIR=$(INSTALLTEXMF)/tex/latex/$(PACKAGE)

# The directory, where to install documentation
DOCDIR=$(INSTALLTEXMF)/doc/latex/$(PACKAGE)

# The directory, where to install the sources
SRCDIR=$(INSTALLTEXMF)/source/latex/$(PACKAGE)

# The directory, where to install demo-files
# If we have some, we have to add following 2 lines to install rule:
#     $(MKDIR) $(DEMODIR); \
#     $(INSTALL) $(DEMO_FILES) $(DEMODIR); \
DEMODIR=$(DOCDIR)/demo

# We need this, because the documentation needs the classes and packages
# It's not really a good solution, but it's a working solution.
TEXINPUTS := $(PWD):$(TEXINPUTS)

# To generate the version number of the distribution from the source
VERSION_L := latex getversion | grep '^VERSION'
VERSION_S := `latex getversion | grep '^VERSION' | \
              sed 's+^VERSION \\(.*\\) of .*+\\1+'`
########################################################################
#   End of customization section
########################################################################

DVIPS = dvips
LATEX = latex
PDFLATEX = pdflatex

# postscript viewer
GV = gv

COMMON_OPTIONS = # \OnlyDescription\CodelineNumbered\PageIndex
HISTORY_OPTIONS = \RecordChanges
DEVELOPER_OPTIONS = \EnableCrossrefs\RecordChanges\AlsoImplementation\CodelineIndex

# The name of the game
PACKAGE = struktex

# strip off the comments from the package
$(PACKAGE).sty $(PACKAGE)-test-*.tex: $(PACKAGE).ins $(PACKAGE).dtx
 +$(LATEX) $<; \
  sh $(PACKAGE).makemake

all-de: $(PACKAGE).de.pdf

all-en: $(PACKAGE).en.pdf

# generate the documentation
$(PACKAGE).de.dvi: $(PACKAGE).dtx $(PACKAGE).sty
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\input{$<}"
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\input{$<}"
 +mv $(<:.dtx=.dvi) $(<:.dtx=.de.dvi)

$(PACKAGE).de.pdf: $(PACKAGE).dtx $(PACKAGE).sty
 +$(PDFLATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\input{$<}"
 +$(PDFLATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\input{$<}"
 +mv $(<:.dtx=.pdf) $(<:.dtx=.de.pdf)

$(PACKAGE).en.dvi: $(PACKAGE).dtx $(PACKAGE).sty
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +mv $(<:.dtx=.dvi) $(<:.dtx=.en.dvi)

$(PACKAGE).en.pdf: $(PACKAGE).dtx $(PACKAGE).sty
 +$(PDFLATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +$(PDFLATEX) "\AtBeginDocument{$(COMMON_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +mv $(<:.dtx=.pdf) $(<:.dtx=.en.pdf)

# generate the documentation with revision history (only german)
history: $(PACKAGE).dtx $(PACKAGE).sty
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(HISTORY_OPTIONS)}\input{$<}"
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(HISTORY_OPTIONS)}\input{$<}"
 +makeindex -s gind.ist                 $(PACKAGE).idx
 +makeindex -s gglo.ist -o $(PACKAGE).gls -t $(PACKAGE).glg $(PACKAGE).glo
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(HISTORY_OPTIONS)}\input{$<}"

# generate the documentation for the developer (revision history always
# in german)
develop-de: $(PACKAGE).dtx $(PACKAGE).sty
 +$(LATEX) "\AtBeginDocument{$(HISTORY_OPTIONS)$(DEVELOPER_OPTIONS)}\input{$<}"
 +$(LATEX) "\AtBeginDocument{$(HISTORY_OPTIONS)$(DEVELOPER_OPTIONS)}\input{$<}"
 +makeindex -s gind.ist                 $(PACKAGE).idx
 +makeindex -s gglo.ist -o $(PACKAGE).gls -t $(PACKAGE).glg $(PACKAGE).glo
 +$(LATEX) "\AtBeginDocument{$(HISTORY_OPTIONS)$(DEVELOPER_OPTIONS)}\input{$<}"
ifneq (,$(findstring pdf,$(LATEX)))
 +mv $(<:.dtx=.pdf) $(<:.dtx=.de.pdf)
else
 +mv $(<:.dtx=.dvi) $(<:.dtx=.de.dvi)
endif

develop-en: $(PACKAGE).dtx $(PACKAGE).sty
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(DEVELOPER_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(DEVELOPER_OPTIONS)}\def\primarylanguage{english}\input{$<}"
 +makeindex -s gind.ist                 $(PACKAGE).idx
 +makeindex -s gglo.ist -o $(PACKAGE).gls -t $(PACKAGE).glg $(PACKAGE).glo
 +$(LATEX) "\AtBeginDocument{$(COMMON_OPTIONS)$(DEVELOPER_OPTIONS)}\def\primarylanguage{english}\input{$<}"
ifneq (,$(findstring pdf,$(LATEX)))
 +mv $(<:.dtx=.pdf) $(<:.dtx=.en.pdf)
else
 +mv $(<:.dtx=.dvi) $(<:.dtx=.en.dvi)
endif

# format the example/test files
test:
 for i in `seq 1 3`; do \
     f=$(PACKAGE)-test-$$i; \
     echo file: $$f; \
     $(LATEX) $$f; \
     $(DVIPS) -o $$f.ps $$f.dvi; \
     $(GV) $$f.ps \&; \
 done

install: $(PACKAGE).dtx $(PACKAGE).dvi
 [ -d $(CLSDIR) ] || mkdir -p $(CLSDIR)
 [ -d $(DOCDIR) ] || mkdir -p $(DOCDIR)
 [ -d $(SRCDIR) ] || mkdir -p $(SRCDIR)
 cp $(PACKAGE).sty      $(CLSDIR)
 cp $(PACKAGE).dvi      $(DOCDIR)
 cp $(PACKAGE).ins      $(SRCDIR)
 cp $(PACKAGE).dtx      $(SRCDIR)
 cp $(PACKAGE)-test-*.tex   $(SRCDIR)
 cp LIESMICH        $(SRCDIR)
 cp README          $(SRCDIR)
 cp THIS-IS-VERSION-$(VERSION)  $(SRCDIR)

uninstall:
 rm -f  $(CLSDIR)/$(PACKAGE).sty
 rm -fr $(DOCDIR)
 rm -fr $(SRCDIR)

dist: $(PACKAGE).de.pdf $(PACKAGE).en.pdf  $(PACKAGE).dtx  $(PACKAGE).ins \
LIESMICH README
 + rm -f THIS_IS_VERSION_*
 + $(VERSION_L) > THIS_IS_VERSION_$(VERSION_S)
 + tar cfvz  $(PACKAGE)-$(VERSION_S).tgz $^ THIS_IS_VERSION_*
 + rm getversion.log

clean:
 -rm -f *.log *.aux *.brf *.idx *.ilg *.ind
 -rm -f *.glg *.glo *.gls *.lof *.lot *.out *.toc *.tmp *~
 -rm *.mk *.makemake

realclean:  clean
 -rm -f *.sty *.cls *.ps *.dvi *.pdf
 -rm -f *test* getversion.* Makefile

clean-test:
 rm $(PACKAGE)-test-*.* # this $-sign is needed for font-locking in XEmacs only
