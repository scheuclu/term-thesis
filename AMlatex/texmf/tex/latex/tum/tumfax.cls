%% Copyright (c) 2008-2009 Rechen-Gilde
%% Error reports to:  tum@rechengil.de
%%
%% This file may be distributed under the terms of the LaTeX Project Public
%% License (LPPL), as described in lppl.txt in the base LaTeX distribution.
%% Either version 1.1 or, at your option, any later version.
%%
%% The latest version of this license is in
%%          http://www.latex-project.org/lppl.txt
%%
%% LPPL Version 1.1 or later is part of all distributions of LaTeX
%% version 1999/06/01 or later.
%%
\NeedsTeXFormat{LaTeX2e}[2001/06/01]
\usepackage{svn-prov}
\ProvidesClassSVN{$Id: tumfax.cls 59 2009-07-27 22:52:27Z miracle $}

\usepackage[usenames]{color}
\usepackage{epsfig}
\usepackage[pdfborder={0 0 0}]{hyperref}
\usepackage{ifthen}
\usepackage{calc}
\usepackage{lastpage}
\usepackage{epic}

\input{tum-common}

\newcommand{\etpar}{\\[18pt]}
\newcommand{\faxlinie}{\begin{picture}(0,0)
\linethickness{0.4pt}\put(0,-0.5){\dashline[180]{0.6}(0,0)(125,0)}
\end{picture}}

\def\tumlogo{\epsfig{file=tumlogo_blk.pdf}}

\def\betrefftext{Betreff\/:}
\def\antext{An\/:}
\def\faxnrtext{Fax Nr\/:}
\def\seitentext{Seiten\/:}
\def\absendertext{Absender\/:}
\def\datumtext{Datum\/:}

\def\An#1{\def\an{#1}} \def\an{}
\def\Faxnr#1{\def\faxnr{#1}} \def\faxnr{}
\def\Absender#1{\def\absender{#1}} \def\absender{}

\newenvironment{tumfax}{
  \hypersetup{pdftitle=An \an,
    pdfauthor=\ifx \titel\empty \else \titel{} \fi
       \ifx \vorname\empty \else \vorname{} \fi
       \ifx \nachname\empty \else \nachname{} \fi,
    pdfsubject=\betreff{},
    pdfkeywords={\organisation{} - \fakultaetname{} -
      \ifx \institut\empty \else \institut{} - \fi \plz{} \ort{} - Germany}}
  \thispagestyle{firstpage}
  \setlength\unitlength{1mm}
  \eindrucktextsize

  \c@page\@ne
  \interlinepenalty=0
  \clearpage

  \parbox[t][12pt*15]{\textwidth}{\raggedright
     \raggedright\eindrucktextsize
	\faxlinie\textbf{\antext} \an  \etpar
	\faxlinie\textbf{\betrefftext} \betreff \etpar
	\faxlinie\textbf{\faxnrtext} \faxnr \etpar
	\faxlinie\textbf{\seitentext} \pageref{LastPage} \etpar
	\faxlinie\textbf{\absendertext}
          \ifx \titel\empty \else \titel{} \fi
          \ifx \vorname\empty \else \vorname{} \fi
          \ifx \nachname\empty \else \nachname{} \fi \etpar
	\faxlinie\textbf{\datumtext} \datum \etpar
  }

  \ifx \anrede\empty \else \anrede \par \fi
}
{\par
  \parbox[t]{3.5in}{\raggedright \ignorespaces {\eindrucktextsize
     \ifx \gruss\empty \else \gruss \par \bigskip \fi
     \ifx \unterschrift\empty \else \unterschrift \fi}}}

\let\@oddfoot\@empty\let\@oddhead\@empty
\let\@evenfoot\@empty\let\@evenhead\@empty
% take care not to leave any unwanted space among the following few lines:
\def\@oddhead{\setlength\parskip{10.5pt}\adressblocksize
  \unitlength1mm\ifraster{\color[gray]{0.5}\begin{picture}(0,0)(22,297)
        \linethickness{0.2pt}
        \put(0,0){\dashbox{1}(210,297){}} % bounding box
        \put(0,266  ){\line(1,0){210}} %  31  mm from top
        \put(0,236.5){\line(1,0){210}} %  60.5mm from top
        \put(0,192  ){\line(1,0){210}} % 105  mm from top
        \put(0,183.5){\line(1,0){210}} % 113.5mm from top
        \put(0, 29  ){\line(1,0){210}} % 268  mm from top

        \put( 22  ,0){\line(0,1){297}}   % from left
        \put(147  ,0){\line(0,1){297}}   % from left
        \put(159  ,0){\line(0,1){297}}   % from left
        \put(201.5,0){\line(0,1){297}}   % from left

        \put(0,236.5){\parbox[t]{21mm}{
          \raggedleft\eindrucktextsize
          \insertmultitext{1}{50}}}\end{picture}}\fi%

  \begin{picture}(0,0)(22,297)
    \put(159,236.5){\parbox[t]{42.5mm}
      {\raggedright\adressblocksize
	\ifx \fakultaetname\empty \else \fakultaetname\\\fi
        \ifx \institut\empty \else \institut\\\fi}}
    \put(159,259){\parbox[t]{60mm}
      {\raggedright\adressblocksize\organisation}}

    \put(159,266){\tumlogo}
    \put(159,219.5){\parbox[t]{42.50mm}
     {  \raggedright\adressblocksize
        \ifx \titel\empty \else \titel{}\\ \fi
        \ifx \vorname\empty \else \textbf{\vorname} \fi
        \ifx \nachname\empty \else \textbf{\nachname} \fi
	\ifx \funktion\empty \else \\ \funktion{} \fi \abpar

	\strasse\\
	\plz{} \ort\\
	\land\abpar

	\makebox[2em][l]{\telefontext}\telefon\\
	\makebox[2em][l]{\telefaxtext}\telefax\abpar

	\href{mailto:\email}{\email}\\
	\href{http://\http/}{\http}\abpar
        \ifx \weiteres\empty \else \weiteres\abpar \fi}}
  \end{picture}
  \hfill}

\def\@oddfoot{\setlength\parskip{10.5pt}\adressblocksize
  \unitlength1mm\begin{picture}(0,0)
    \put(137,1.9){\parbox[t]{42.5mm}
      {\raggedright\adressblocksize\aktuelleseitetext\thepage}}
  \end{picture}}

\def\ps@firstpage{}
\def\ps@regularpage{}


\ifx \@docencoding\empty \else
\IfFileExists{inputenc.sty}
  {\RequirePackage[\@docencoding]{inputenc}}
  {\ClassError{tumfax}
    {LaTeX2e not complete installed or out of date !!!}
    {Get current LaTeX2e !!!}}
\fi

\IfFileExists{marvosym.sty}
  {\RequirePackage{marvosym}}
  {}
\IfFileExists{europs.sty}
  {\RequirePackage{europs}}
  {}{}
\IfFileExists{eurosym.sty}
  {\RequirePackage{eurosym}}
  {}{}


\endinput
%%
%% End of file `tumfax.cls'.
