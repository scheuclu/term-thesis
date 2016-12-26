%%
%% This is file `AMposter.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMposter.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMposter <!AMreleaseVersion!> --- AM poster class
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMposter}[\AMinsertGitDate{} \AMinsertGitVersion{} AM poster]
\LoadClass[a0paper, 25pt, margin=0mm, innermargin=50mm, colspace=20mm]{tikzposter}
\RequirePackage[utf8]{inputenc}
\RequirePackage[theme=tumhelvetica]{AMfont}
\RequirePackage{multicol}
\RequirePackage{AMcolor}
\RequirePackage{AMmath}
\definecolorpalette{TUMcolorpalette}{
  \definecolor{colorOne}{named}{TUMblue}
  \definecolor{colorTwo}{named}{black}
  \definecolor{colorThree}{named}{TUMorange}
}
\definecolorstyle{TUMcolorstyle}{
  \definecolor{colorOne}{named}{TUMblue}
  \definecolor{colorTwo}{named}{black}
  \definecolor{colorThree}{named}{TUMorange}
  }{
  \colorlet{backgroundcolor}{colorOne}
  \colorlet{framecolor}{black}
  \colorlet{titlefgcolor}{black}
  \colorlet{titlebgcolor}{TUMblue}
  \colorlet{blocktitlebgcolor}{white}
  \colorlet{blocktitlefgcolor}{TUMblue}
  \colorlet{blockbodybgcolor}{white}
  \colorlet{blockbodyfgcolor}{black}
  \colorlet{innerblocktitlebgcolor}{white}
  \colorlet{innerblocktitlefgcolor}{black}
  \colorlet{innerblockbodybgcolor}{colorThree!30!white}
  \colorlet{innerblockbodyfgcolor}{black}
  \colorlet{notefgcolor}{black}
  \colorlet{notebgcolor}{colorTwo!50!white}
  \colorlet{noteframecolor}{colorTwo}
}
\definebackgroundstyle{TUMbackgroundstyle}{%
}
\def\title#1{%
  \gdef\@title{%
    \scalebox{\TP@titletextscale}{%
      \begin{minipage}[t]{\linewidth}
        #1\par\vspace{0.5em}
      \end{minipage}%
    }
  }
}
\def\@subtitle{~}
\gdef\subtitle#1{\gdef\@subtitle{#1}}
\settitle{%
  \vbox{
    \@titlegraphic \\[\TP@titlegraphictotitledistance]
    \color{titlefgcolor}
    {\fontseries{b}\fontsize{110}{140}\selectfont \@title \par}
    \vspace*{1em}
    {\fontsize{70}{100}\fontseries{b}\selectfont \color{titlebgcolor} \@subtitle \par}
    \vspace*{1em}
    {\fontsize{40}{55}\selectfont  \@author}
  }
}
\definetitlestyle{TUMtitlestyle}{
    width=741mm, roundedcorners=0, linewidth=0pt, innersep=0mm,
    titletotopverticalspace=47mm, titletoblockverticalspace=20mm,
    titlegraphictotitledistance=50pt
}{}
\defineblockstyle{TUMblockstyle}{
     titlewidthscale=1, bodywidthscale=1, titleleft,
     titleoffsetx=0pt, titleoffsety=-10pt, bodyoffsetx=0mm, bodyoffsety=-15mm,
     bodyverticalshift=0mm, roundedcorners=5, linewidth=2pt,
     titleinnersep=0mm, bodyinnersep=0cm
}{}
\titlegraphic{%
  \includegraphics[width=\linewidth]{AM-poster-head}
}
\definelayouttheme{TUMposter}{
  \usecolorstyle{TUMcolorstyle}
  \usebackgroundstyle{TUMbackgroundstyle}
  \usetitlestyle{TUMtitlestyle}
  \useblockstyle{TUMblockstyle}
  \useinnerblockstyle{Default}
  \usenotestyle{Corner}
}
\usetheme{TUMposter}
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
%% This work consists of the file  AMposter.dtx
%% and the derived files           AMposter.ins,
%%                                 AMposter.pdf and
%%                                 AMposter.cls.
%% 
%%
%% End of file `AMposter.cls'.
