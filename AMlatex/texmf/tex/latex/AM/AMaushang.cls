%%
%% This is file `AMaushang.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMaushang.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMaushaug <!AMreleaseVersion!> --- Class of the AMlatex-Bundle blackboard posters
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMaushaug}[\AMinsertGitDate{} \AMinsertGitVersion{} AM blackboard posters]
\ClassInfo{AMaushaug}{Document class of the Institute of Applied Mechanics}
\newcommand\baseclass{%
  scrartcl%
}
\let\if@quer\iftrue
\let\if@lehre\iffalse
\let\if@praktikum\iftrue
\let\if@forschung\iftrue
\let\if@arbeit\iffalse
\DeclareOption{lehre}{\let\if@lehre\iftrue\let\if@forschung\iffalse\let\if@praktikum\iffalse}
\DeclareOption{praktikum}{\let\if@praktikum\iftrue\let\if@forschung\iffalse\let\if@lehre\iffalse}
\DeclareOption{forschung}{\let\if@forschung\iftrue\let\if@lehre\iffalse\let\if@praktikum\iffalse}
\DeclareOption{arbeit}{\let\if@arbeit\iftrue\let\if@quer\iffalse}
\pdfmapfile{+tumhelv.map}
\PassOptionsToClass{a4paper}{\baseclass}
\let\if@image\iffalse
\let\if@preview\iffalse
\let\if@english\iffalse
\DeclareOption{preview}{\let\if@preview\iftrue}
\DeclareOption{english}{\let\if@english\iftrue}
\ProcessOptions*\relax
\LoadClass{\baseclass}
\if@quer
  \KOMAoptions{paper=landscape}
\fi
\if@english
  \RequirePackage[english, ngerman]{babel}
\else
  \RequirePackage[ngerman, english]{babel}
\fi
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{tabularx}
\RequirePackage{amssymb}
\RequirePackage{fancybox}
\RequirePackage{wrapfig}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{calc}
\if@preview
  \RequirePackage[active,tightpage]{preview}
  \setlength\PreviewBorder{0pt}
\fi
\fontfamily{lhv}\selectfont
\def\@headerfontsize{\usefont{T1}{lhv}{m}{n}\fontsize{10pt}{11pt}\selectfont}
\definecolorset{cmyk}{TUM}{}{%
  Blue,1,.43,0,0;%
  Blue60Perc,.6,.26,0,0;%
  Blue40Perc,.4,.17,0,0;%
  Blue1,1,.57,.12,.7;%
  Blue2,1,.54,.04,.19;%
  Blue3,.9,.48,0,0;%
  Blue4,.65,.19,.01,.04;%
  Blue5,.42,.09,0,0;%
  Orange,0,0.65,0.95,0;%
  Green,0.35,0,1,0.2;%
  Ivory,0.03,0.04,0.14,0.08;%
  Gray1,0,0,0,0.8;%
  Gray2,0,0,0,0.5;%
  Gray3,0,0,0,0.2}

\definecolorset{rgb}{TUMRGB}{}{%
  Blue,0,0.396078431,0.741176471;%
  Blue60Perc,0.4,0.639215686,0.843137255;%
  Blue40Perc,0.6,0.756862745,0.898039216}
\def\@amlogo{\includegraphics{AM-logo-AM-blau-RGB}}
\def\@tumlogo{\includegraphics{AM-logo-TUM-voll-blau-RGB}}
\def\enumchar{$\triangleright$}
\newlength\labeldist
\newlength\raender
\newlength\aushanghoehe
\newlength\aushangbreite
\newlength\uppermargincorrect
\newlength\imagewidth
\newlength\textfontheight
\newlength\textlineheight
\newlength\textabstand
\newlength\labelraise
\newlength\canvaswidth
\newlength\canvasheight
\setlength\labeldist{1.5mm}
\setlength\textabstand{5mm}
\setlength\uppermargincorrect{\heightof{\@tumlogo}-\heightof{\@amlogo}}
\def\@titel{Titel}
\def\@untertitel{Untertitel}
\def\@themen{
  \item Thema 1
  \item Thema 2
  \item Thema 3
  \item Thema 4
}
\def\@textabove{}
\def\@setfontsizes#1#2#3#4#5#6{
  \def\@titelfontsize{\usefont{T1}{lhv}{b}{n}\fontsize{#1}{#2}\selectfont}
  \def\@untertitelfontsize{\usefont{T1}{lhv}{m}{n}\fontsize{#3}{#4}\selectfont}
  \setlength\textfontheight{#5}
  \setlength\textlineheight{#6}
  % Set label of enum environments
  \def\@textfontsize{\usefont{T1}{lhv}{m}{n}\fontsize{\textfontheight}{\textlineheight}\selectfont}
  \setlength\labelraise{\heightof{\@textfontsize M}/2-\heightof{\@textfontsize\enumchar}/2}
  \renewcommand{\labelitemi}{\raisebox{\labelraise}{\enumchar}}
}
\def\Titel#1{\def\@titel{#1}}
\def\Bild#1#2{%
  \let\if@image\iftrue
  \setlength{\imagewidth}{#1}
  \def\@image{\includegraphics[width=\imagewidth]{#2}}
}
\def\Themen#1{\def\@themen{#1}}
\renewcommand{\tiny}{}
\renewcommand{\scriptsize}{}
\renewcommand{\footnotesize}{}
\renewcommand{\small}{}
\renewcommand{\normalsize}{}
\renewcommand{\large}{}
\renewcommand{\Large}{}
\renewcommand{\huge}{}
\renewcommand{\Huge}{}
\setlength\footskip{0pt}
\setlength\headsep{0pt}
\setlength\headheight{0pt}
\setlength\marginparsep{0pt}
\setlength\marginparpush{0pt}
\setlength\marginparwidth{0pt}
\setlength\oddsidemargin{0pt}
\setlength\parindent{0pt}
\setlength\topmargin{0pt}
\def\Fuss#1{%
  \if@quer
    \setlength\canvaswidth{\aushanghoehe-2\raender}
    \setlength\canvasheight{\aushangbreite-2\raender}
  \else
    \setlength\canvasheight{\aushangbreite-2\raender}
    \setlength\canvaswidth{\aushanghoehe-2\raender}
  \fi
  \AtBeginDocument{%
    \thispagestyle{empty}
    \@textfontsize
    \@textabove
    \Sbox
      \minipage[t][\canvaswidth][t]{\canvasheight}
      \vspace{\uppermargincorrect}
      \@amlogo
      \hfill
      \begin{minipage}[b]{\linewidth-\widthof{\@amlogo}-\widthof{\@tumlogo}-\labeldist}
        \color{TUMRGBBlue}
        \@headerfontsize
        \if@english
          AM\\
          Institute of\\
          Applied Mechanics\hfill Technische Universit^^c3^^a4t M^^c3^^bcnchen
        \else
          AM\\
          Lehrstuhl f^^c3^^bcr\\
          Angewandte Mechanik\hfill Technische Universit^^c3^^a4t M^^c3^^bcnchen
        \fi
      \end{minipage}%
      \@tumlogo
      {
        \@headerfontsize
        \par
        \color{TUMRGBBlue}
        \rule[5pt]{\linewidth}{0.665pt} % Line width of TUM logo.
        \par
      }
      {
        \color{TUMRGBBlue}
        \@titelfontsize
        \@titel
        \par
        \@untertitelfontsize
        \color{TUMRGBBlue60Perc}
        \@untertitel\par
      }
      \vspace{\textabstand}
      \if@image
        \begin{wrapfigure}{r}{\imagewidth}
          \vspace{-14pt}\@image\vspace{-10.5pt}
        \end{wrapfigure}%
      \fi
  } % End of \AtBeginDocument
  %
  \AtEndDocument{%
        \vfill
        #1
      \endminipage
    \endSbox
    \setlength\fboxsep{\raender}
    \if@preview
      \preview
      \fcolorbox{white}{white}{\TheSbox}
      \endpreview
    \else
       \fcolorbox{lightgray}{white}{\TheSbox}
    \fi
  } % End of \AtEndDocument
} % End of \Fuss
\if@arbeit
\@setfontsizes{20pt}{24pt}{14pt}{17pt}{12pt}{15pt}


\setlength\aushangbreite{170mm}
\setlength\aushanghoehe{125mm}
\setlength\raender{6.5mm}         % Randabstand

\setlength\hoffset{105mm-.5\aushangbreite-1in}


\def\@betreuer{Betreuer}

\def\Art#1{\def\@untertitel{#1}}
\def\Betreuer#1#2#3#4#5{\def\@betreuer{#1~#2\\MW~#3,~089/289~#4,~#5}}

\def\@textabove{
  Erstelldatum: \today
  \hrule\bigskip
  {
    \color{red}
    Druckeinstellungen: \textbf{Nicht} in Seite einpassen
  }\par\bigskip
  Auf Aushang zuschneiden: \texttt{\textbackslash{}documentclass[]\{arbeit\}}\par\bigskip
  Bilder einbinden: \texttt{\textbackslash{}Bild\{BILDBREITE\}\{BILDDATEI\}}\par
  Beispiel: \texttt{\textbackslash{}Bild\{2cm\}\{Pendel.pdf\}}\par\bigskip
  PDF konvertieren zu JPG (z.B. f^^c3^^bcr PowerPoint):\par
\texttt{\textbackslash{}documentclass[preview]\{arbeit\}}\par\bigskip
\texttt{convert -density 600 Aushang\_Vorlage.pdf Aushang\_Vorlage.jpg}\par\bigskip\bigskip
}

\Fuss{%
  \if@english
    \newcommand{\@betreuungstr}{\textbf{Advisor\hspace{4mm}}}
    \newcommand{\@themenstr}{\textbf{Topics\hspace{4mm}}}
  \else
    \newcommand{\@betreuungstr}{\textbf{Betreuung\hspace{4mm}}}
    \newcommand{\@themenstr}{\textbf{Themen\hspace{4mm}}}
  \fi
  \newlength{\aligncol}
  \setlength{\aligncol}{\widthof{\@betreuungstr}-\widthof{\@themenstr}}
  \newcommand{\itemcoldesc}{\@textfontsize\@themenstr\hspace{\aligncol}}%
  \newlength{\itemcollen}%
  \setlength{\itemcollen}{\linewidth-\widthof{\itemcoldesc}}%
  %
  \newcommand{\itemcollist}{%
    \begin{minipage}[t][][t]{\itemcollen}%
      \begin{multicols}{2}\setlength\fboxsep{0pt}%
        \begin{itemize}[topsep=0pt, noitemsep, leftmargin=\widthof{\labelitemi}+6.6pt, labelsep=6pt, itemindent=0pt]
          \@themen%
        \end{itemize}%
      \end{multicols}%
    \end{minipage}
  }%
  \begin{minipage}[b][\heightof{\itemcollist}][t]{\widthof{\itemcoldesc}}
    \begin{multicols}{2}%
      \begin{description}\setlength\itemsep{0pt}%
        \item[\itemcoldesc]%
      \end{description}%
    \end{multicols}%
  \end{minipage}\itemcollist\\[1ex]
  \@betreuungstr
  \begin{minipage}[t][2ex][t]{\itemcollen}
    \@betreuer
  \end{minipage}
}
\else
\@setfontsizes{24pt}{24pt}{18pt}{24pt}{14.4pt}{18pt}

\if@forschung
  \newlength\portraitheight
\fi
\setlength\aushangbreite{238.5mm} % = Breite des Posterfeldes (237.5mm) + Ueberhang (1mm)
\setlength\aushanghoehe{152.25mm}  % = Hoehe des Posterfeldes (151.25mm) + Ueberhang (1mm)
\setlength\raender{8mm}            % Randabstand
\if@forschung
  \setlength\portraitheight{\textfontheight+5\textlineheight-2.5pt}
\fi
\if@forschung
  \def\@grad{Akad. Grad}
  \def\@name{Name}
  \def\@raum{Raum}
  \def\@tel{Telefon}
  \def\@email{E-Mail}
  \def\@portrait{\rule{.75\portraitheight}{\portraitheight}}
\else
  \if@praktikum
    \def\@dozent{Verantwortlicher}
    \def\@betreuer{Betreuer}
  \else
    \def\@dozent{Dozent}
    \def\@betreuer{Betreuer}
  \fi
\fi
\if@forschung
  \def\Gebiet#1{\def\@untertitel{#1}}
  \def\Kontakt#1#2#3#4#5{\def\@grad{#1}\def\@name{#2}\def\@raum{#3}\def\@tel{#4}\def\@email{#5}}
  \def\Portrait#1{\def\@portrait{\includegraphics[height=\portraitheight]{#1}}}
\else
  \def\Daten#1#2#3{\def\@untertitel{#1,~#2~ECTS,~#3}}
  \def\Dozent#1#2#3#4#5{\def\@dozent{#1~#2,~MW~#3,~089/289~#4,~#5}}
  \def\Betreuer#1#2#3#4#5{\def\@betreuer{#1~#2,~MW~#3,~089/289~#4,~#5}}
\fi

\Fuss{%
  \if@forschung
    %
    %=============FORSCHUNG======================
    %
    \newlength{\minipagewidth}
    \setlength{\minipagewidth}{\linewidth-\widthof{\@portrait}}
    %
    \@portrait
    \hfill
    \begin{minipage}[b][\portraitheight][t]{0.48\minipagewidth}
      \textbf{%
        \if@english
          Contact
        \else
          Kontakt
        \fi
      }\\
      \@grad\\
      \@name\\
      MW~\@raum\\
      Tel.: 089/289~\@tel\\
      \@email
    \end{minipage}
    \hfill
    \begin{minipage}[b][\portraitheight][t]{0.48\minipagewidth}%
      \textbf{%
        \if@english
          Topics
        \else
          Themen
        \fi
      }
      \begin{itemize}[topsep=0pt, noitemsep, leftmargin=\widthof{\labelitemi}+6pt, labelsep=6pt, itemindent=0pt]
        \@themen
      \end{itemize}
    \end{minipage}
  \else
    %
    %=============LEHRE==========================
    %
    \if@praktikum
    \if@english
      \newcommand{\@themenstr}{\textbf{Topics}}
      \newcommand{\@dozentstr}{\textbf{Coordinator}}
      \newcommand{\@betreuerstr}{\textbf{Assistant\hspace{10mm}}}
    \else
      \newcommand{\@themenstr}{\textbf{Themen}}
      \newcommand{\@dozentstr}{\textbf{Koordinator}}
      \newcommand{\@betreuerstr}{\textbf{Betreuer\hspace{10mm}}}
    \fi
    \else
    \if@english
      \newcommand{\@themenstr}{\textbf{Topics}}
      \newcommand{\@dozentstr}{\textbf{Lecturer}}
      \newcommand{\@betreuerstr}{\textbf{Assistant\hspace{4mm}}}
    \else
      \newcommand{\@themenstr}{\textbf{Themen}}
      \newcommand{\@dozentstr}{\textbf{Dozent}}
      \newcommand{\@betreuerstr}{\textbf{Betreuer\hspace{4mm}}}
    \fi
   \fi
    %
    \newlength{\aligncol}
    \newlength{\itemcollen}
    %
    \setlength{\aligncol}{\widthof{\@betreuerstr}-\widthof{\@themenstr}}
    \newcommand{\itemcoldesc}{\@textfontsize\@themenstr\hspace{\aligncol}}
    \setlength{\itemcollen}{\linewidth-\widthof{\itemcoldesc}}
    %
    \newcommand{\itemcollist}{%
      \begin{minipage}[t][][t]{\itemcollen}%
        \begin{multicols}{2}\setlength\fboxsep{0pt}%
          \begin{itemize}[topsep=0pt, noitemsep, leftmargin=\widthof{\labelitemi}+6.6pt, labelsep=6pt, itemindent=0pt]
            \@themen%
          \end{itemize}%
        \end{multicols}%
      \end{minipage}
    }%
    \begin{minipage}[b][\heightof{\itemcollist}][t]{\widthof{\itemcoldesc}}
      \begin{multicols}{2}%
        \begin{description}\setlength\itemsep{0pt}%
          \item[\itemcoldesc]%
        \end{description}%
      \end{multicols}%
    \end{minipage}\itemcollist\\[2ex]
    \newcommand{\dozentBox}{
      \begin{minipage}[t][][t]{\itemcollen}
        \@dozent
        \vspace{2mm}
      \end{minipage}
    }
    \setlength{\aligncol}{\widthof{\@betreuerstr}-\widthof{\@dozentstr}}
    \@dozentstr
    \dozentBox
    \@betreuerstr
    \begin{minipage}[t][][t]{\itemcollen}
      \@betreuer
    \end{minipage}
  \fi
}
\fi
%% 
%% Copyright (c) 2008-2009 Rechen-Gilde <tum@rechengil.de>
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
%% This work consists of the file  AMaushaug.dtx
%% and the derived files           AMaushaug.ins,
%%                                 AMaushaug.pdf and
%%                                 AMaushaug.cls.
%% 
%%
%% End of file `AMaushang.cls'.
