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
\ProvidesClassSVN{$Id: tumbrief.cls 59 2009-07-27 22:52:27Z miracle $}

\usepackage[usenames]{color}
\usepackage{epsfig}
\usepackage[pdfborder={0 0 0}]{hyperref}
\usepackage{ifthen}
\usepackage{calc}

\input{tum-common}

\def\tumlogo{\epsfig{file=tumlogo.pdf}}

\def\banktext{Bankverbindung\/:}
\def\blztext{BLZ}
\def\kontotext{Kto.}
\def\swifttext{S.W.I.F.T.-Code\/:}
\def\ibantext{IBAN-Nr.\/:}
\def\steuernrtext{Steuer-Nr.\/:}
\def\ihrzeichentext{Ihr Zeichen}
\def\ihrschreibentext{Ihr Schreiben vom}
\def\unserzeichentext{Unser Zeichen}
\def\unserschreibentext{Unser Schreiben vom}
\def\unserschreibenkleintext{Schreiben vom}

\def\RetourAdresse#1{\def\retouradresse{#1}}

\def\Bank#1{\def\bank{#1}} \def\bank{}
\def\BLZ#1{\def\blz{#1}} \def\blz{}
\def\Konto#1{\def\konto{#1}} \def\konto{}

\def\Swift#1{\def\swift{#1}} \def\swift{}
\def\Iban#1{\def\iban{#1}} \def\iban{}
\def\Steuernr#1{\def\steuernr{#1}} \def\steuernr{}

\def\Postvermerk#1{\def\postvermerk{#1}} \def\postvermerk{}
\def\Adresse#1{\def\adresse{#1}} \def\adresse{}

\def\IhrZeichen#1{\def\ihrzeichen{#1}} \def\ihrzeichen{}
\def\IhrSchreiben#1{\def\ihrschreiben{#1}} \def\ihrschreiben{}
\def\UnserZeichen#1{\def\unserzeichen{#1}} \def\unserzeichen{}
\def\UnserSchreiben#1{\def\unserschreiben{#1}} \def\unserschreiben{}

\newcommand\tumfirstpagestuff{}

\newenvironment{tumbrief}{
  \hypersetup{pdftitle=An \adresse{},
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

  \parbox[t][12pt*9]{\textwidth}{\raggedright \adresse}

  \datum \par
  \ifx \betreff\empty \else \betreff \fi \par
  \vspace{24pt}
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
  \unitlength1mm\ifraster{\color[gray]{0.3}\begin{picture}(0,0)(22,297)
        \linethickness{0.4pt}
        \put(0,0){\dashbox{1}(210,297){}} % bounding box
        \put(0,266  ){\line(1,0){210}} %  31  mm from top
        \put(0,248.5){\line(1,0){210}} %  48.5mm from top
        \put(0,236.5){\line(1,0){210}} %  60.5mm from top
        \put(0,219.5){\line(1,0){210}} %  77.5mm from top
        \put(0,192  ){\line(1,0){210}} % 105  mm from top
        \put(0, 29  ){\line(1,0){210}} % 268  mm from top

	{\color[rgb]{0.8,0,0}
        \put(0,251.48 ){\line(1,0){210}} % 45.52 mm from top
        \put(0,241.875){\line(1,0){210}} % 55.125mm from top

        % fenstermarken
        \put(13,250){\line( 1, 0){2}} \put(13,250){\line( 0,-1){2}}
        \put(98,250){\line(-1, 0){2}} \put(98,250){\line( 0,-1){2}}
        \put(13,208){\line( 1, 0){2}} \put(13,208){\line( 0, 1){2}}
        \put(98,208){\line(-1, 0){2}} \put(98,208){\line( 0, 1){2}}
	}

        \put( 22  ,0){\line(0,1){297}}   % from left
        \put(147  ,0){\line(0,1){297}}   % from left
        \put(159  ,0){\line(0,1){297}}   % from left
        \put(201.5,0){\line(0,1){297}}   % from left

        \put(0,236.5){\parbox[t]{21mm}{
          \raggedleft\eindrucktextsize
          \insertmultitext{1}{50}}}\end{picture}}\fi%

  \begin{picture}(0,0)(22,297)
    \put(4,192){\line(1,0){3}}   % faltmarke
    \put(4,148.5){\line(1,0){3}} % lochmarke
    \put(159,236.5){\parbox[t]{42.5mm}
      {\raggedright\adressblocksize
	\ifx \fakultaetname\empty \else \fakultaetname\\\fi\institut}}
    \put(159,259){\parbox[t]{60mm}
      {\raggedright\adressblocksize\organisation}}

    \put(159,266){\tumlogo}
    \put(159,241.875){\fakultaetlogo}

    \tumfirstpagestuff
  \end{picture}
  \hfill}

\def\@oddfoot{\setlength\parskip{10.5pt}\adressblocksize
  \unitlength1mm\begin{picture}(0,0)
    \put(137,1.9){\parbox[t]{42.5mm}
      {\raggedright\adressblocksize\aktuelleseitetext\thepage}}
  \end{picture}}

\def\ps@firstpage{
   \renewcommand{\tumfirstpagestuff}{\put(22,246.5){\parbox[t]{\textwidth}{
     \raggedright\absendersize\retouradresse}}
   \put(159,219.5){\parbox[t]{42.50mm}
     {  \raggedright\adressblocksize
        \ifx \titel\empty \else \titel{}\\ \fi
        \ifx \vorname\empty \else \textbf{\vorname} \fi
        \ifx \nachname\empty \else \textbf{\nachname} \fi
	\ifx \funktion\empty \else \\ \funktion{} \fi \abpar

	\strasse\\
	\plz{} \ort\\
	\land\abpar

	\ifx\telefon\empty\else\makebox[2em][l]{\telefontext}\telefon\fi
	\ifx\telefax\empty\else\\\makebox[2em][l]{\telefaxtext}\telefax
	  \fi\abpar

	\href{mailto:\email}{\email}\\
	\href{http://\http/}{\http}\abpar}}
   \put(159,161){\parbox[t]{42.50mm}
     {  \raggedright\adressblocksize
        \ifx \weiteres\empty \else \weiteres \abpar \fi

   	\ifx \bank\empty \else \ifx \blz\empty \else \ifx
             \konto\empty \else
          \banktext \\
	  \bank \abpar
          \kontotext \space \konto \\
          \blztext \space \blz \abpar \fi \fi \fi

        \ifx \swift\empty \else \swifttext \\ \swift  \abpar \fi

        \ifx \iban\empty \else \ibantext \\ \iban  \abpar \fi

        \ifx \steuernr\empty \else \steuernrtext \\ \steuernr  \abpar \fi

        \ifx \ihrzeichen\empty \else \ihrzeichentext
             \ifx \ihrschreiben\empty \\ \else , \fi \fi
        \ifx \ihrschreiben\empty \else \ihrschreibentext \\ \fi
        \ifx \ihrzeichen\empty \else \ihrzeichen
             \ifx \ihrschreiben\empty \abpar \else , \fi \fi
        \ifx \ihrschreiben\empty \else \ihrschreiben \abpar \fi

        \ifx \unserzeichen\empty \else \unserzeichentext
             \ifx \unserschreiben\empty \\
                  \else , \unserschreibenkleintext \\ \fi \fi
        \ifx \unserschreiben\empty \else
             \ifx \unserzeichen\empty \unserschreibentext \\ \fi \fi
        \ifx \unserzeichen\empty \else \unserzeichen
             \ifx \unserschreiben\empty \abpar \else , \fi \fi
        \ifx \unserschreiben\empty \else \unserschreiben \abpar \fi}}
}}


\def\ps@regularpage{\renewcommand{\tumfirstpagestuff}{}}


\ifx \@docencoding\empty \else
\IfFileExists{inputenc.sty}
  {\RequirePackage[\@docencoding]{inputenc}}
  {\ClassError{tumbrief}
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
%% End of file `tumbrief.cls'.
