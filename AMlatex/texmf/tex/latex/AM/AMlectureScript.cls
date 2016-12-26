%%
%% This is file `AMlectureScript.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMlectureScript.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMlectureScript <!AMreleaseVersion!> --- Class of the AMlatex-Bundle (lectureScript)
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMlectureScript}[\AMinsertGitDate{} \AMinsertGitVersion{} AM lecture script]
\ClassInfo{AMlectureScript}{Document class of the Institute of Applied Mechanics}
\LoadClassWithOptions{book}
\RequirePackage{etoolbox}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{AMfont}
\RequirePackage[final]{microtype}
\RequirePackage{AMgraphic}
\RequirePackage{AMcolor}
\RequirePackage{AMmath}
\RequirePackage{epstopdf}
\RequirePackage{excludeonly}
\RequirePackage{csquotes}
\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{fancybox}
\RequirePackage{listings}
\RequirePackage{xspace}
\RequirePackage{siunitx}
\RequirePackage{tabularx}
\RequirePackage{empheq}
\RequirePackage{cancel}
\RequirePackage{makeidx}
\RequirePackage{minitoc}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins}
\RequirePackage{AMlayout}
\RequirePackage{AMref}
\makeindex
\newcommand{\idxemph}[2][\empty]{%
  \emph{#2}%
  \ifx#1\empty\index{#2}%
  \else\index{#1!#2}\fi%
  \xspace%
}
\renewenvironment{theindex}{%
    \setlength{\parskip}{0pt plus 1.0pt}
    \if@twocolumn
      \@restonecolfalse
    \else
      \@restonecoltrue
    \fi
    \columnseprule \z@
    \columnsep 35\p@
    \twocolumn[\@makeschapterhead{\indexname}]%
    \@mkboth{\indexname}{\indexname}%suppression de \MakeUppercase
    \thispagestyle{plain}\parindent\z@
    \parskip\z@ \@plus .3\p@\relax
    \let\item\@idxitem%
  }{%
    \if@restonecol%
      \onecolumn
    \else%
      \clearpage
    \fi%
}
\AMsetColor{setup,titles=TUMBlue,link=TUMOrange}
\AMsetFont{theme=libertine,titles=\sffamily\bfseries}
\AMsetLayout{page geometry={top=2cm,left=2.3cm,right=2.3cm,bottom=2cm}}
\newcommand{\vect}{\overrightarrow}
\newtcolorbox{theorem}[1][]{empty,fontupper=\itshape,coltext=TUMBlue}
\numberwithin{equation}{section}
\newcommand{\ambluebox}[1]{%
  \colorlet{currentcolor}{.}%
  {%
    \color{TUMBlue}%
    \fboxsep=1ex\fbox{\color{currentcolor}#1}
  }%
}
\setcounter{minitocdepth}{1}
\setlength{\mtcindent}{12pt}
\renewcommand{\mtcfont}{\small\rm}
\renewcommand{\mtcSfont}{\small\bf}
\renewcommand{\mtctitle}{}
\nomtcrule
\AtBeginDocument{\dominitoc}
\AMlayout@setup@cleardoublepage
\newcommand\mynobreakpar{\par\nobreak\@afterheading}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\providecommand{\@version}{}
\providecommand{\version}[1]{\gdef\@version{#1}}

\providecommand{\@lectureID}{}
\providecommand{\lectureID}[1]{\gdef\@lectureID{#1}}

\providecommand{\@authortitle}{}
\providecommand{\authortitle}[1]{\gdef\@authortitle{#1}}

\providecommand{\titlepage@bottom@text}{}
\providecommand{\titlepagebottomtext}[1]{\gdef\titlepage@bottom@text{#1}}

\pdfmapfile{+tumhelv.map}

\providecommand{\includeHeaderAFour}{%
\noindent
\begin{minipage}[t][10mm][t]{\textwidth}%
\sffamily \color{TUMBlue}\fontfamily{lhv}\fontsize{11pt}{11pt}\selectfont%
\includegraphics[height=11.67mm,width=10.67mm]{AM-logo-AM-blau-RGB}
\hspace{1ex}%
\begin{minipage}[b]{0.35\textwidth}
\raggedright AM\\ Lehrstuhl f\"ur\\ Angewandte Mechnik
\end{minipage}%
\hfill{}%
\begin{minipage}[b]{0.35\textwidth}
\raggedleft Technische Universit\"{a}t M\"{u}nchen
\end{minipage}%
\hspace{1ex}%
\includegraphics[height=10mm,width=18.7mm]{AM-logo-TUM-voll-blau-RGB}
\end{minipage}
\hfill{}%
}

\newcommand{\AMlecture@titlepage}{%
\begin{titlepage}
  \pdfbookmark{\@title}{AMtitleanchor}
  \thispagestyle{empty}
\includeHeaderAFour
  \vskip15mm
  \begin{center}
    {\bfseries\Huge \@title} \\[1cm]
    {\small \@lectureID} \\[1mm]
    {\small Lecture Notes - Version \@version} \\[1mm]
    {\small \@date} \\
    \vfill
    \includegraphics[width=12cm]{title}
    \vfill
    {\large\scshape \@author} \\[2mm]
    {\footnotesize  \@authortitle} \\[5mm]
    {\small Technische Universit^^c3^^a4t M^^c3^^bcnchen} \\
    {\small Institute of Applied Mechanics}
  \end{center}
\end{titlepage}
  \cleardoublepage
  \setcounter{page}{1}
}
\newcommand{\AMlecture@titlepage@other}{%
  \begin{titlepage}
    \thispagestyle{empty}
    \phantomsection%
    \pdfbookmark[1]{Titelseite}{titelseite}%
    \setlength{\hoffset}{-1in}
    \setlength{\voffset}{-1in}
    \setlength\footskip{0pt}
    \setlength\headsep{0pt}
    \setlength\headheight{0pt}
    \setlength\marginparsep{0pt}
    \setlength\marginparpush{0pt}
    \setlength\marginparwidth{0pt}
    \setlength\oddsidemargin{0pt}
    \setlength\parindent{0pt}
    \setlength\topmargin{0pt}
    \addtolength{\hoffset}{25mm}
    \setlength\textwidth{170mm}
    \setlength\textheight{239mm}
    \addtolength{\voffset}{15mm}
    \setcounter{page}{1}%
    ~\hfill Lehrstuhl f^^c3^^bcr Angewandte Mechanik

    ~\hfill Technische Univerit^^c3^^a4t M^^c3^^bcnchen

    \vspace*{4cm}
    {\Large Skript zur Vorlesung}

    \vspace*{5mm}
    {\bfseries\fontsize{32pt}{32pt}\selectfont \@title}

    \vspace*{15mm}
    \begin{center}
      \includegraphics[width=\textwidth]{title}
    \end{center}
    \vfill
    {\Large \@date \\ \vspace{1ex}\\
      \Large \@authortitle~\@author\\
    \textcolor{TUMred}{\titlepage@bottom@text}
    }
  \end{titlepage}
  \clearpage
}
\newcommand{\AMlecturetitlepageother}{\AMlecture@titlepage@other}
\renewcommand{\maketitle}{\AMlecture@titlepage}
\newcommand{\@AMchangeLog}{}
\newcommand{\AMchangelog}[2]{%
  \g@addto@macro{\@AMchangeLog}{#1 & #2\\}
}
\newcommand{\AMprintChangelog}{
  \thispagestyle{empty}
  ~
  \vfill
  \begin{minipage}[b]{\textwidth}
  Changelog:\\
  \begin{tabular}{ll}%
    \@AMchangeLog
  \end{tabular}
  \end{minipage}
  \vspace{2ex}\\
  \copyright~Lehrstuhl f^^c3^^bcr Angewandte Mechanik
}
\newcounter{AMexampleCounter}[section]
\newcommand{\AM@example@separator}{\textcolor{TUMGreen}{:}}
\newenvironment{AMexample}[1][]{%
    \stepcounter{AMexampleCounter}
    \small
    \paragraph*{%
      {\color{TUMGreen}Example \theAMexampleCounter}%
      \ifx&#1&\else\AM@example@separator\xspace#1\fi%
    }%
    \begin{quotation}
  }{%
    \end{quotation}
}
\newenvironment{AMexercise}[1][]{%
    \section*{Exercise}
    \small
    \begin{enumerate}
  }{%
    \end{enumerate}
}
\lstset{%
 backgroundcolor=\color{white},   % choose the background color
 basicstyle=\small\ttfamily,        % the size of the fonts that are used for the code
 breakatwhitespace=false,         % sets if automatic breaks should only happen at whitespace
 breaklines=true,                 % sets automatic line breaking
 captionpos=b,                    % sets the caption-position to bottom
 commentstyle=\color{blue},    % comment style
 deletekeywords={...},            % if you want to delete keywords from the given language
 escapeinside={\%*}{*)},          % if you want to add LaTeX within your code
 frame=none,                   % adds a frame around the code
 keepspaces=true,                 % keeps spaces in text, useful for keeping indentation of code
 keywordstyle=\color{green!50!black},       % keyword style
 numbers=left,                    % where to put the line-numbers; possible values are (none, left, right)
 numbersep=15pt,                   % how far the line-numbers are from the code
 numberstyle=\tiny\color{gray}, % the style that is used for the line-numbers
 rulecolor=\color{black},         %
 showspaces=false,                % show spaces everywhere adding particular underscores
 showstringspaces=false,          % underline spaces within strings only
 showtabs=false,                  % show tabs within strings adding particular underscores
 stepnumber=1,                    % the step between two line-numbers. If it's 1, each line will be numbered
 stringstyle=\color{black},     % string literal style
 tabsize=2,                    % sets default tabsize to 2 spaces
 title=\lstname                   % show the filename of files included with \lstinputlisting; also try caption instead of title
}
\newcommand{\GROUP}[1]{%
  \renewcommand{\algorithmicloop}{}
  \renewcommand{\algorithmicend}{ }
  \LOOP[\textsf{-#1-}]
  %\STATE
  \renewcommand{\algorithmicloop}{textbf{loop}}
  \renewcommand{\algorithmicend}{\textbf{end}}
}
\newcommand{\ENDGROUP}{%
  \renewcommand{\algorithmicend}{ }
  \renewcommand{\algorithmicloop}{}
  \ENDLOOP
  \renewcommand{\algorithmicloop}{textbf{loop}}
  \renewcommand{\algorithmicend}{\textbf{end}}
}
\AMwritePdfMetaProperties{Created with AMlectureScript}
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
%% This work consists of the file  AMlectureScript.dtx
%% and the derived files           AMlectureScript.ins,
%%                                 AMlectureScript.pdf and
%%                                 AMlectureScript.cls.
%% 
%%
%% End of file `AMlectureScript.cls'.
