%%
%% This is file `AMbachelorArbeit.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMstudentThesis.dtx  (with options: `class,bachelor')
%% --------------------------------------------------------------------------------
%% AMstudentThesis <!AMreleaseVersion!> --- AM beamer class
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
%% /!\      Modifications made in this file will be lost!       /!\ 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{%
  AMbachelorArbeit%
}[\AMinsertGitDate{} \AMinsertGitVersion{} AM student thesis class]
\LoadClass[a4paper,twoside,11pt]{book}
\RequirePackage[theme=stix]{AMfont}
\RequirePackage[setup]{AMcolor}
\RequirePackage{AMlang}
\RequirePackage{AMlayout}
\RequirePackage[bachelor]{AMtitlepage}
\RequirePackage{AMref}
\AMsetFont{titles=\sffamily\bfseries}
\PassOptionsToPackage{fleqn}{amsmath}
\RequirePackage{AMmath}
\RequirePackage{AMgraphic}
\RequirePackage{AMbiblio}
\renewcommand{\cleardoublepage}{%
\clearpage\ifodd\c@page\else
\hbox{}\vspace*{\fill}
\thispagestyle{empty}%
\newpage
\fi%
}
\newcommand{\DiplomErklaerung}{%
  \chapter*{\disclaimerstring}
  \DiplomErklaerung@text
  \vskip4\baselineskip
  Garching, \@date\hfill $\overline{\makebox[60mm]{\centering\footnotesize(\signaturestring)}}$
}
\AtEndDocument{\DiplomErklaerung}
\newcommand{\PrintTablesAndListsOfContents}[1][]{%
  {%
    \hypersetup{linkcolor=black}
    \hypersetup{linkbordercolor=black}
    \tableofcontents%
    \let\cleardoublepage\clearpage%
    \listoffigures
    \listoftables
  }
}
\AMwritePdfMetaProperties{Created with AMstudentThesis}
%% 
%% Copyright (C) 2003-2010 by S. Lohmeier <lohmeier@amm.mw.tum.de>
%% Copyright (C) 2011-2013 by M. Schwienbacher <m.schwienbacher@tum.de>
%% Copyright (C) 2014 by K. Grundl <kilian.grundl@tum.de>
%% Copyright (C) 2015 by R. Pennec <romain.pennec@tum.de>
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License (LPPL), either
%% version 1.3c of this license or (at your option) any later
%% version.  The latest version of this license is in the file:
%% 
%% http://www.latex-project.org/lppl.txt
%% 
%% This work is "maintained" (as per LPPL maintenance status) by
%% Romain Pennec.
%% 
%% This work consists of the file  AMstudentThesis.dtx
%% and the derived files           AMstudentThesis.ins,
%%                                 AMstudentThesis.pdf,
%%                                 AMmasterArbeit.cls,
%%                                 AMsemesterArbeit.cls and
%%                                 AMbachelorArbeit.cls.
%% 
%%
%% End of file `AMbachelorArbeit.cls'.
