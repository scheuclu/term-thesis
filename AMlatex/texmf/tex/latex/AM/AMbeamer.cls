%%
%% This is file `AMbeamer.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMbeamer.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMbeamer <!AMreleaseVersion!> --- AM beamer class
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
%% /!\      Modifications made in this file will be lost!       /!\ 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMbeamer}[\AMinsertGitDate{} \AMinsertGitVersion{} AM beamer class]
\pdfminorversion=4
\LoadClassWithOptions{beamer}
\usetheme{AM}
\RequirePackage{etoolbox}
\RequirePackage{pgfkeys}
\RequirePackage{lmodern}
\RequirePackage{tikz}
\RequirePackage{bookmark}
\RequirePackage{booktabs}
\RequirePackage{csquotes}
\RequirePackage{colortbl}
\RequirePackage{AMref}
\arrayrulecolor{TUMBlue}
\institute{Lehrstuhl f\"ur Angewandte Mechanik \\ Technische Universit\"at M\"unchen}
\providecommand{\AMset}[1]{\pgfkeys{/AM/.cd,#1}}
\newcommand{\AMsetBeamer}[1]{\pgfkeys{/AM/beamer/.cd,#1}}
\pgfkeys{
  /AM/sourcepic/.is family, /AM/sourcepic,
  default/.style={
    label color=TUMgrey,
    width=\textwidth,
    label style={\scriptsize},
    prefix={},
    yshift=0pt,
    },
    label color/.estore in = \AM@sourcepic@label@color,
    label style/.store in = \AM@sourcepic@label@style,
    prefix/.store in = \AM@sourcepic@prefix,
    width/.estore in = \AM@sourcepic@width,
    yshift/.estore in = \AM@sourcepic@yshift,
}
\pgfkeys{/AM/sourcepic,default}
\newcommand{\bluefat}[1]{\textbf{\color{TUMblue}#1}}
\newcommand{\sourcepic}[3][]{%
  \pgfkeys{/AM/sourcepic,#1}
  \begin{tikzpicture}
  \node[anchor=south east,inner sep=0] (picture)  {%
    \includegraphics[width=\AM@sourcepic@width]{#2}
  };
  \node[anchor=south east,inner sep=3pt,yshift=\AM@sourcepic@yshift] (source) {%
    \color{\AM@sourcepic@label@color}\AM@sourcepic@label@style\AM@sourcepic@prefix#3
  };
  \end{tikzpicture}
}
\newcommand{\placepicturetopright}[2][0.2\textwidth]{
  \begin{tikzpicture}[overlay, remember picture]
    \node [anchor=north east] at (current page.north east)
      [xshift=-2mm, yshift=-10mm] {\tiny\def\svgwidth{#1}#2};
  \end{tikzpicture}
}
\newcommand{\AMput}[2][]{
  \begin{tikzpicture}[overlay, remember picture]
    \node[inner sep=0pt,#1] at (current page) {#2};
  \end{tikzpicture}
}
\newcommand{\AMrecall}[2][width=2cm]{%
  \placepicturetopright{\includegraphics[#1]{#2}}
}
\newcommand{\AMmove}[3]{%
  \vspace{#1}
  \hspace{#2}
  \parbox{\textwidth}{#3}
}
\newcommand{\gridframe}[1][]{%
  \begin{frame}
    \begin{minipage}{\paperwidth}
      \hspace{-6.6mm}
      \begin{tikzpicture}
        \draw[xstep=2.975mm,ystep=2.975mm,color=TUMIvory,line width=0.01pt]
          (0,0) grid (119mm,80.325mm);
        \node[anchor=north east] at (119mm,80mm){\mbox{#1}};
      \end{tikzpicture}
    \end{minipage}
  \end{frame}
}
\let\picgridframe\gridframe
\define@key{beamerframe}{grid}[false]{%
\setbeamertemplate{background}
    {
    \begin{tikzpicture}[overlay, remember picture]
        \node [] at (current page.south west) [xshift=12.7pt, yshift=12pt]
        {\begin{tikzpicture}[remember picture, overlay]
            \draw[xstep=2.975mm,ystep=2.975mm,color=TUMLightGray!80,
            line width=0.01pt](0,0) grid (119mm,80.325mm);
         \end{tikzpicture}
        };
    \end{tikzpicture}
    }
}
\pretocmd{\beamer@@@@frame}{\setbeamertemplate{background}{}}{}{}
\newenvironment{AMwarning}{%
    \begin{center}
    \textcolor{red}{!!!}
    \hskip1ex
  }{%
    \hskip1ex
    \textcolor{red}{!!!}
    \end{center}
}
\AMwritePdfMetaProperties{Created with AMbeamer}
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
%% This work consists of the file  AMbeamer.dtx
%% and the derived files           AMbeamer.ins,
%%                                 AMbeamer.pdf,
%%                                 beamercolorthemeAM.sty,
%%                                 beamerthemeAM.sty and
%%                                 AMbeamer.cls.
%% 
%%
%% End of file `AMbeamer.cls'.
