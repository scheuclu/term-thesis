%%
%% This is file `AMdissertation.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMdissertation.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMdisseration <!AMreleaseVersion!> --- Class of the AMlatex-Bundle for dissertation
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMdissertation}[\AMinsertGitDate{} \AMinsertGitVersion{} AM disseration]
\ClassInfo{AMdissertation}{Document class of the Institute of Applied Mechanics}
\LoadClass[a4paper,twoside,11pt]{book}
\RequirePackage[utf8]{inputenc}
\RequirePackage[theme=libertine]{AMfont}
\RequirePackage{AMlang}
\RequirePackage[setup]{AMcolor}
\RequirePackage{AMgraphic}
\RequirePackage{AMbiblio}
\RequirePackage[online]{AMref}
\RequirePackage[dissertation]{AMtitlepage}
\RequirePackage{AMlayout}
\PassOptionsToPackage{fleqn}{amsmath}
\RequirePackage{AMmath}
\RequirePackage{tocbibind}
\addto\captionsenglish{%
  \settocname{Table of Contents}
}
\AMsetFont{titles=\sffamily\bfseries,page number=\bfseries}
\AMsetFont{left mark=\normalcolor\normalfont\normalsize\bfseries}
\AMsetFont{right mark=\normalcolor\normalfont\normalsize\bfseries}
\AMsetLayout{a4default,setup chapter page,page style=AMdissps}
\newcommand{\PrintTablesAndListsOfContents}[1][]{%
  {%
    \hypersetup{linkcolor=black}
    \hypersetup{linkbordercolor=black}
    \tableofcontents%
    \let\cleardoublepage\clearpage%
    \listoffigures
  }
}
\newcommand*{\@date@i}{}
\newcommand*{\@date@ii}{}
\renewcommand{\date}[2]{\gdef\@date@i{#1}\gdef\@date@ii{#2}}
\gdef\DissTitle{\@title}
\gdef\DissSubTitle{\@subtitle}
\newcommand{\copyrightmatlab}[1]{%
  \vfill\textcopyright~#1~The MathWorks, Inc. MATLAB and Simulink are registered
  trademarks of The MathWorks, Inc. See www.mathworks.com/trademarks for a
  list of additional trademarks. Other product or brand names may be trademarks
  or registered trademarks of their respective holders.
}
\AMwritePdfMetaProperties{Created with AMdissertation}
%% 
%% Copyright (C) 2003-2010 by S. Lohmeier <lohmeier@amm.mw.tum.de>
%% Copyright (C) 2011-2013 by M. Schwienbacher <m.schwienbacher@tum.de>
%% Copyright (C) 2014 by K. Grundl <kilian.grundl@tum.de>
%% Copyright (C) 2015-2016 by R. Pennec <romain.pennec@tum.de>
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
%% This work consists of the file  AMdissertation.dtx
%% and the derived files           AMdissertation.ins,
%%                                 AMdissertation.pdf and
%%                                 AMdissertation.cls.
%% 
%%
%% End of file `AMdissertation.cls'.
