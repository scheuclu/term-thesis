%%
%% This is file `AMdocument.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMdocument.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMdocument <!AMreleaseVersion!> --- Class of the AMlatex-Bundle
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMdocument}[\AMinsertGitDate{} \AMinsertGitVersion{} AM document]
\ClassInfo{AMdocument}{Document class of the Institute of Applied Mechanics}
\RequirePackage{ifthen}
\newif\ifAM@insert@foot@post
\AM@insert@foot@postfalse
\PassOptionsToClass{a4paper}{article}
\DeclareOption{english}{\PassOptionsToPackage{english}{AMlang}}
\DeclareOption{ngerman}{\PassOptionsToPackage{ngerman}{AMlang}}
\DeclareOption{german}{\PassOptionsToPackage{ngerman}{AMlang}}
\DeclareOption{post}{\AM@insert@foot@posttrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions
\LoadClass{article}
\RequirePackage{AMlang}
\RequirePackage{AMcolor}
\RequirePackage[theme=tumhelvetica]{AMfont}
\RequirePackage[TUMAM]{AMtitlepage}
\RequirePackage{AMref}
\RequirePackage[a4default]{AMlayout}
\AMsetLayout{page geometry={margin=2cm}}
\ifAM@insert@foot@post
  \RequirePackage{fancyhdr}
  \pagestyle{fancy}
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0.4pt}
  \fancyfoot[L]{\scriptsize
  \begin{tabular}{@{}>{\scshape}ll@{}}
    Lieferanschrift& Lehrstuhl f\"{u}r Angewandte Mechanik TU M^^c3^^bcnchen Boltzmannstr. 15 \\
    & 85748 Garching Fakult^^c3^^a4t f^^c3^^bcr Maschinenwesen Geb. 1, 3. OG\\
    Postanschrift& Lehrstuhl f\"{u}r Angewandte Mechanik TU M^^c3^^bcnchen D-85747 Garching \\
    Homepage& \url{www.am.mw.tum.de}
    \end{tabular}
  }
   \fancyfoot[R]{\footnotesize\pagename~\thepage}
\fi
\AMwritePdfMetaProperties{Created with AMdocument}
%% 
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
%% This work consists of the file  AMdocument.dtx
%% and the derived files           AMdocument.ins,
%%                                 AMdocument.pdf and
%%                                 AMdocument.cls.
%% 
%%
%% End of file `AMdocument.cls'.
