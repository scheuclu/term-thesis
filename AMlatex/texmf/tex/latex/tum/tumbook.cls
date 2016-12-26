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
\ProvidesClassSVN{$Id: tumbook.cls 79 2009-07-30 20:18:12Z miracle $}
 
% BTE> weitere Variablen
\input{tumbase}
\setlength{\parindent}{0pt}
%BTE Font umsetzen
\renewcommand{\encodingdefault}{T1}
\renewcommand{\rmdefault}{lhv}
\renewcommand{\sfdefault}{lhv}
%ETE Font umsetzen
%
%%Technische Universitaet München
%%Fakultaet fuer Wirtschaftswissenschaften
%%Seminar fuer Musterseminare
%%WS 2007/08
\def\Seminar#1{\def\seminar{#1}}\def\seminar{}
\def\Semester#1{\def\term{#1}}\def\term{}

\def\Untertitel#1{\def\subtitle{#1}}\def\subtitle{}
%Prof. Dr. Dr. h.c. Max Mustermann
%Seminar fuer Musterseminare
%Fakultaet fuer Wirtschaftswissenschaften
%Technische Universitaet Muenchen
%Arcisstrasse 11, 80333 Muenchen
\def\Themensteller#1{\def\supervisor{#1}}\def\supervisor{}
\def\TUMAdresse#1{\def\tumaddress{#1}}\def\tumaddress{Arcisstra\ss{}e 11, 80333 M\"unchen}
%Bearbeitet von:
%
%Gregor Heyn
%Musterstraße 5641, 80333 München, 089/12345678910
%Matrikelnummer: 12345678910, Fachsemester: 08
%%Abgabetermin: 01.01.2008
\def\Autorenadresse#1{\def\authoraddress{#1}}\def\authoraddress{}
\def\Matrikelnummer#1{\def\authorid{#1}}\def\authorid{}
\def\Fachsemester#1{\def\fachsemester{#1}}\def\fachsemester{}
\def\Abgabetermin#1{\def\deadline{#1}}\def\deadline{}
\newcommand\insertraster{\ifraster{\setlength{\unitlength}{1mm}%
  \begin{picture}(0,0)(25,7)
   \color[rgb]{0.5,0.5,0.5}
    {\color[rgb]{0.5,0,0}\put(25,297){\line(1,0){170}}%top
    \put(25,0){\line(1,0){170}}%bottom
    \put(25,148){\line(1,0){170}}}%middle
    \put(20,277){\parbox{1cm}{texttop\\2cm}}
    \put(25,277){\line(1,0){170}}%texttop
    \put(15,20){\parbox{1cm}{Ende\\2cm}}
    \put(25,20){\line(1,0){170}}%Ende
    \put(25,277){\parbox{1cm}{l. Rand\\2,5cm}}
    \put(25,20){\line(0,1){257}}%left
    \put(31,287){\parbox{1cm}{,25in}}
    \put(31,20){\line(0,1){257}}%,25in
    \put(37,287){\parbox{1cm}{,25in}}
    \put(37,20){\line(0,1){257}}%.25in
    \put(43,287){\parbox{1cm}{,25in}}
    \put(43,20){\line(0,1){257}}%.25in
    \put(195,287){\parbox{1cm}{r. Rand\\1,5cm}}
    \put(195,20){\line(0,1){257}}%right
  \end{picture}}\fi}
\newcommand\insertfpraster{\ifraster{\color[rgb]{0.5,0.5,0.5}
    \put(25,297){\line(1,0){170}}%top
    \put(25,0){\line(1,0){170}}%bottom
    \put(25,148){\line(1,0){170}}%middle
    \put(15,282){\parbox{1cm}{logotop\\1,5cm}}
    \put(25,282){\line(1,0){170}}%logotop
    \put(15,272){\parbox{1cm}{tumbottom\\2,5cm}}
    \put(25,272){\line(1,0){170}}%logobottom
    \put(15,253){\parbox{1cm}{Adresse\\4,4cm}}
    \put(25,253){\line(1,0){170}}%start tum
    \put(15,202){\parbox{1cm}{Titel\\9,5cm}}
    \put(25,202){\line(1,0){170}}%logotop
    \put(25,35){\line(1,0){170}}%Ende
    \put(15,35){\parbox{1cm}{Ende\\3,5cm}}
    \put(25,35){\line(0,1){247}}%left
    \put(25,287){\parbox{1cm}{l. Rand\\2,5cm}}
    \put(35,35){\line(0,1){247}}%left logo
    \put(35,287){\parbox{1cm}{l. Logo\\3,5\,cm}}
    \put(195,35){\line(0,1){247}}%right
    \put(195,287){\parbox{1cm}{r. Rand\\1,5cm}}}\fi}  
\newcommand\Ehrenwort{
\textbf{Ehrenw\"ortliche Erklärung}

\vspace{\baselineskip}
Ich erkl\"are hiermit ehrenw\"ortlich, dass ich die vorliegende Arbeit selbstst\"andig 
und ohne Benutzung anderer als der angegebenen Hilfsmittel angefertigt habe; 
die aus fremden Quellen (einschlie\ss{}lich elektronischer Quellen) direkt oder 
indirekt \"ubernommenen Gedanken sind ausnahmslos als solche kenntlich gemacht.

\vspace{\baselineskip}

\@date

\vspace{3\baselineskip}
\@author
}
% ETE> weitere Variablen

 
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagetrue
\newif\if@openright
\newif\if@mainmatter \@mainmattertrue
% BTE Papier auf A4 setzen
\setlength\paperheight {297mm}%
\setlength\paperwidth  {210mm}
% ETE Papier auf A4 setzen
\DeclareOption{9pt}{\renewcommand\@ptsize{9}}
\DeclareOption{10pt}{\renewcommand\@ptsize{10}}
\DeclareOption{12pt}{\renewcommand\@ptsize{12}}
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{titlepage}{\@titlepagetrue}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}%
}
% BTE> Encoding als Option
\let\@docencoding\@empty
\DeclareOption{ansinew}{\def\@docencoding{ansinew}}
\DeclareOption{applemac}{\def\@docencoding{applemac}}
\DeclareOption{ascii}{\def\@docencoding{ascii}}
\DeclareOption{cp1250}{\def\@docencoding{cp1250}}
\DeclareOption{cp1252}{\def\@docencoding{cp1252}}
\DeclareOption{cp437de}{\def\@docencoding{cp437de}}
\DeclareOption{cp437}{\def\@docencoding{cp437}}
\DeclareOption{cp850}{\def\@docencoding{cp850}}
\DeclareOption{cp852}{\def\@docencoding{cp852}}
\DeclareOption{cp865}{\def\@docencoding{cp865}}
\DeclareOption{decmulti}{\def\@docencoding{decmulti}}
\DeclareOption{latin1}{\def\@docencoding{latin1}}
\DeclareOption{latin2}{\def\@docencoding{latin2}}
\DeclareOption{latin3}{\def\@docencoding{latin3}}
\DeclareOption{latin4}{\def\@docencoding{latin4}}
\DeclareOption{latin5}{\def\@docencoding{latin5}}
\DeclareOption{latin9}{\def\@docencoding{latin9}}
\DeclareOption{next}{\def\@docencoding{next}}
\DeclareOption{utf8}{\def\@docencoding{utf8x}}
\def\@docencoding{latin1}
% ETE> Encoding als Option

\ExecuteOptions{letterpaper,10pt,twoside,onecolumn,final,openright}%
\ProcessOptions
%BTE Auswertung der encoding Option
\ifx \@docencoding\empty \else
\IfFileExists{inputenc.sty}
  {\RequirePackage[\@docencoding]{inputenc}}
  {\ClassError{tumbrief}
    {LaTeX2e not complete installed or out of date !!!}
    {Get current LaTeX2e !!!}}
\fi
%ETE Auswertung der encoding Option


\def\logooffset{271}
\input{tumsize\@ptsize.clo}
\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{0\p@ \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\if@twoside
  \def\ps@headings{%
% BTE Rasteranzeige zum Ueberpruefen der Einzuege
      \def\@oddfoot{\insertraster}
      \def\@evenfoot{\insertraster}
% ETE Rasteranzeige zum Ueberpruefen der Einzuege
      %TE\let\@oddfoot\@empty\let\@evenfoot\@empty
      \def\@evenhead{\hfill{}\thepage\hfill{}}%
      \def\@oddhead{\hfill{}\thepage\hfill{}}%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter \ %
          \fi
        \fi
        ##1}}{}}%
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\z@
          \thesection \ %
        \fi
        ##1}}}}
\else
  \def\ps@headings{%
    \def\@oddfoot{\insertraster}
    \def\@oddhead{\hfill{}\thepage\hfill{}}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
          \if@mainmatter
            \@chapapp\ \thechapter \ %
          \fi
        \fi
        ##1}}}}
\fi
\def\ps@myheadings{%
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\thepage\hfil\slshape\leftmark}%
    \def\@oddhead{{\slshape\rightmark}\hfil\thepage}%
    \let\@mkboth\@gobbletwo
    \let\chaptermark\@gobble
    \let\sectionmark\@gobble
    }
\newcommand\maketitle{{%
\begin{titlepage}%
% BTE> Ersetzen der Inhalte ueber dem Titel
{\noindent\setlength{\unitlength}{1mm}%
\begin{picture}(0,0)(25,\logooffset)%
\insertfpraster
    \put(25,272){\fakultaetlogo}
    \put(176,272){\tumlogo}
  \end{picture}}%
  \newlength{\addresstop}%
  \setlength{\addresstop}{4.44cm}
  \newlength{\titletop}%
  \setlength{\titletop}{9.5cm}
  
  \newlength{\firstpagespace}%
  \setlength{\firstpagespace}{4.44cm-1in-\headsep-\headheight+\baselineskip}%
  \vspace*{\firstpagespace}%
  \mbox{Technische Universit\"at M\"unchen} \\
  \mbox{\ifx \fakultaetname\empty \else \fakultaetname{} \fi}\\
  \mbox{\ifx \seminar\empty \else \seminar{} \fi}\\
  \mbox{\term}
  
  \newlength{\titleskip}
  \setlength{\titleskip}{\titletop-\addresstop-4\baselineskip}
  \vspace{\titleskip} 
  % BTE> Anpassung der Schriftgroesse des Titels exakt 15 - Durchschuss 20
  {\fontsize{15}{20}\selectfont\textbf{\@title} \par\bigskip}%
  % ETE> Anpassung der Schriftgroesse des Titels exakt 15 - Durchschuss 20
  % BTE> Untertitel
  \textbf{\ifx \subtitle\empty \else \subtitle{}\fi} 
  \vspace{3\baselineskip} %
  % ETE> Untertitel
  % BTE> Autor nach unten
  
  Themensteller: 
  
  \bigskip
   \ifx \supervisor\empty \else \supervisor{}\\ \fi
   \ifx \seminar\empty \else \seminar{}\\ \fi
   \ifx \fakultaetname\empty \else \fakultaetname{}\\ \fi
  Technische Universit\"at M\"unchen \\
  \tumaddress

  \vspace{3\baselineskip}
  Bearbeitet von:
  
  \bigskip
   \ifx \@author\empty \else \@author{}\\ \fi
   \ifx \authoraddress\empty \else \authoraddress{}\\ \fi
   \ifx \authorid\empty \else Matrikelnummer: \authorid{}
        \ifx \fachsemester\empty\else , \fi \fi
   \ifx \fachsemester\empty \else Fachsemester: \fachsemester{}\fi
   
  \vfill{} 
  Abgabetermin: \ifx \deadline\empty \else \deadline{}\fi \vspace{1,5cm}
  % ETE> Autor nach unten
  \end{titlepage}%
   
  }
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
}

\newcommand*\chaptermark[1]{}
\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {chapter}
\newcounter {section}[chapter]
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
% BTE anpassung der Zaehler (keine Absatzzaehler)
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\renewcommand \thepart {\@Roman\c@part}
\renewcommand \thechapter {\@arabic\c@chapter.}
\renewcommand \thesection {\thechapter\@arabic\c@section.}
\renewcommand\thesubsection   {\thesection\@arabic\c@subsection.}
\renewcommand\thesubsubsection{\thesubsection\@arabic\c@subsubsection.}
\renewcommand\theparagraph    {\thesubsubsection\@arabic\c@paragraph}
\renewcommand\thesubparagraph {\theparagraph\@arabic\c@subparagraph}
% ETE anpassung der Zaehler (keine Absatzzaehler)
\newcommand\@chapapp{\chaptername}
\newcommand\frontmatter{%
    \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}}
\newcommand\mainmatter{%
    \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}}
\newcommand\backmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse}
\newcommand\part{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \thispagestyle{plain}%
  \if@twocolumn
    \onecolumn
    \@tempswatrue
  \else
    \@tempswafalse
  \fi
  \null\vfil
  \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >-2\relax
      \refstepcounter{part}%
      \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
    \else
      \addcontentsline{toc}{part}{#1}%
    \fi
    \markboth{}{}%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \ifnum \c@secnumdepth >-2\relax
       \bfseries \partname\nobreakspace\thepart
       \par
       \vskip 20\p@
     \fi
     \Huge \bfseries #2\par}%
    \@endpart}
\def\@spart#1{%
    {\centering
     \interlinepenalty \@M
     \normalfont
     \bfseries #1\par}%
    \@endpart}
\def\@endpart{\vfil\newpage
              \if@twoside
               \if@openright
                \null
                \thispagestyle{empty}%
                \newpage
               \fi
              \fi
              \if@tempswa
                \twocolumn
              \fi}
\newcommand\chapter{% TE Keine Umbrueche %\if@openright\cleardoublepage\else\clearpage\fi
                    % TE Durchgaengige Seitennummerierung %\thispagestyle{plain}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
\def\@chapter[#1]#2{\ifnum \c@secnumdepth >\m@ne
                       \if@mainmatter
                         \refstepcounter{chapter}%
                         \typeout{\@chapapp\space\thechapter.}%
                         \addcontentsline{toc}{chapter}%
                                   {\protect\numberline{\thechapter}#1}%
                       \else
                         \addcontentsline{toc}{chapter}{#1}%
                       \fi
                    \else
                      \addcontentsline{toc}{chapter}{#1}%
                    \fi
                    \chaptermark{#1}%
                    \addtocontents{lof}{\protect\addvspace{10\p@}}%
                    \addtocontents{lot}{\protect\addvspace{10\p@}}%
                    \if@twocolumn
                      \@topnewpage[\@makechapterhead{#2}]%
                    \else
                      \@makechapterhead{#2}%
                      \@afterheading
                    \fi}
\def\@makechapterhead#1{%
  \vspace{2\baselineskip}% TE 2 Zeilen Abstand vor dem Titel
  {\parindent \z@ \raggedright \normalfont
    \ifnum \c@secnumdepth >\m@ne
      \if@mainmatter
        % TE keine Umbrueche normale Schriftgroesse
        \bfseries \thechapter        
      \fi
    \fi
    \interlinepenalty\@M
    % TE normale Schriftgroesse
    \bfseries \hspace{1ex}#1\par\nobreak
    \vspace{\baselineskip}% TE 1 Zeile Abstand nach dem Titel
  }}
\def\@schapter#1{\if@twocolumn
                   \@topnewpage[\@makeschapterhead{#1}]%
                 \else
                   \@makeschapterhead{#1}%
                   \@afterheading
                 \fi}
\def\@makeschapterhead#1{%
  \vspace{2\baselineskip}% TE 2 Zeilen Abstand vor dem Titel
  {\parindent \z@ \raggedright
    \normalfont
    \interlinepenalty\@M
    \bfseries  #1\par\nobreak
    \vspace{\baselineskip}% TE 1 Zeile Abstand nach dem Titel
  }}
\newcommand\section{\@startsection {section}{1}{.25in}% TE Ueberschrift lvl2 1/4 inch einruecken
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{.5in}% TE Ueberschrift lvl3 1/2 inch einruecken
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{.75in}% TE Ueberschrift lvl4 3/4 inch einruecken
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {3.25ex \@plus1ex \@minus.2ex}%
                                    {-1em}%
                                    {\normalfont\normalsize\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {3.25ex \@plus1ex \@minus .2ex}%
                                       {-1em}%
                                      {\normalfont\normalsize\bfseries}}

\if@twocolumn
  \setlength\leftmargini  {.25in} % TE Aufzaehlungen einruecken
\else
  \setlength\leftmargini  {.5in} % TE Aufzaehlungen einruecken
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {.25in}  % TE Aufzaehlungen einruecken
\setlength\leftmarginiii {.25in} % TE Aufzaehlungen einruecken
\setlength\leftmarginiv  {.25in}   % TE Aufzaehlungen einruecken
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
\if@compatibility
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\z@
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
    }
\else
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }
\fi
\newcommand\appendix{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \gdef\@chapapp{\appendixname}%
  \gdef\thechapter{\@Alph\c@chapter}}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\@addtoreset {equation}{chapter}
\renewcommand\theequation
  {\ifnum \c@chapter>\z@ \thechapter\fi \@arabic\c@equation}
\newcounter{figure}% TE Bilder ueber ganzes Dokument numerieren [chapter]
% BTE Definition der Abkuerzung fuer figures auf Abb.
\iflanguage{german}{\def\figureprefix{Abb.}}{}
\iflanguage{ngerman}{\def\figureprefix{Abb.}}{}
\iflanguage{english}{\def\figureprefix{Fig.}}{}
\ifx\figureprefix\undefined
 \def\figureprefix{\figurename}
\fi
% ETE Definition der Abkuerzung fuer figures auf Abb.
\renewcommand \thefigure
     {\figureprefix\nobreakspace\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}[chapter]
\renewcommand \thetable
     {\ifnum \c@chapter>\z@ \thechapter\fi \@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3} % ET Inhaltsverzeichnistiefe 4
\newcommand\tableofcontents{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \if@restonecol\twocolumn\fi
    }
\newcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \setlength\@tempdima{3em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      {\leavevmode
       \large \bfseries #1\hfil \hb@xt@\@pnumwidth{\hss #2}}\par
       \nobreak
         \global\@nobreaktrue
         \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi}
\newcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{1.5em}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}
\newcommand*\l@section{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand*\l@subsection{\@dottedtocline{2}{3.8em}{3.2em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{7.0em}{4.1em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{10em}{5em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{12em}{6em}}

% BE redefine caption to add a colon in the list of figures
\long\def\@caption#1[#2]#3{%
  \par
  \addcontentsline{\csname ext@#1\endcsname}{#1}%
    {\protect\numberline{\csname the#1\endcsname:}{\ignorespaces #2}}%
  \begingroup
    \@parboxrestore
    \if@minipage
      \@setminipage
    \fi
    \normalsize
    \@makecaption{\csname fnum@#1\endcsname}{\ignorespaces #3}\par
  \endgroup}
% TE redefine caption to add a colon in the list of figures

\newcommand\listoffigures{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%  
    \@starttoc{lof}%
    \if@restonecol\twocolumn\fi
    }
\newcommand*\l@figure{\@dottedtocline{1}{0em}{.5in}} %
\newcommand\listoftables{%
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    \if@restonecol\twocolumn\fi
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
     {\chapter*{\bibname}%
      \@mkboth{\MakeUppercase\bibname}{\MakeUppercase\bibname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \twocolumn[\@makeschapterhead{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width2in
  \kern2.6\p@}
\@addtoreset{footnote}{chapter}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\bibname{Bibliography}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\chaptername{Chapter}
\newcommand\appendixname{Appendix}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{headings}
\pagenumbering{arabic}
% TE Absaetze nicht vertikal verteilen % \if@twoside
% TE Absaetze nicht vertikal verteilen %\else
\raggedbottom
% TE Absaetze nicht vertikal verteilen %\fi
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi
\usepackage{hyperref}
\ifharvard
\usepackage{harvard}
\fi

\endinput
%%
%% End of file `book.cls'.
