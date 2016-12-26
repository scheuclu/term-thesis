%%
%% This is file `AMexam.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% AMexam.dtx  (with options: `class')
%% --------------------------------------------------------------------------------
%% AMexam <!AMreleaseVersion!> --- Class of the AMlatex-Bundle for exams
%% E-mail: romain.pennec@tum.de
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% --------------------------------------------------------------------------------
%% 
\RequirePackage{AMgit}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMexam}[\AMinsertGitDate{} \AMinsertGitVersion{} AM exam]
\NeedsTeXFormat{LaTeX2e}[2011/12/22]
\ProvidesClass{AMexam}[2015/12/31]
\LoadClass[a4paper,12pt,twoside,fleqn]{article}
\RequirePackage{typearea}
\RequirePackage{pgfkeys}
\newif\if@simplesol
\newif\if@alternative
\newif\if@additional
\newif\if@points
\newif\if@pointssum
\newif\if@ff
\newif\if@english
\newif\if@anonymous
\newif\if@tumasia
\newif\if@correction
\newif\if@multiplechoice
\DeclareOption{exam}{}
\DeclareOption{solution}{\@simplesoltrue}
\DeclareOption{correction}{
  \@correctiontrue
  \@simplesoltrue
  \@alternativetrue
  \@additionaltrue
  \@pointstrue
  \@pointssumtrue
  \@fftrue
}
\DeclareOption{review_student}{
  \@simplesoltrue
  \@pointssumtrue
}
\DeclareOption{review_assi}{
  \@simplesoltrue
  \@alternativetrue
  \@pointstrue
  \@pointssumtrue
}
\DeclareOption{english}{
  \@englishtrue
}
\DeclareOption{anonymous}{
  \@anonymoustrue
}
\DeclareOption{tumasia}{
  \@tumasiatrue
  \@anonymoustrue
  \@englishtrue
}
\DeclareOption{multiplechoice}{
  \@multiplechoicetrue
}
\newcommand{\ifenglish}[2]{\if@english#1\else#2\fi}
\newcommand{\ifanonymous}[2]{\if@anonymous#1\else#2\fi}
\newcommand{\additional}[1]{\if@additional #1 \fi}
\newcommand{\ifprintsolutions}[2]{\if@simplesol #1 \else #2 \fi}
\newcommand{\ifsol}[2]{\ifprintsolutions{#1}{#2}}
\newcommand{\ifcor}[2]{\if@correction #1 \else #2 \fi}
\newcommand{\soldots}[1]{\begin{Large} \sdots{#1} \end{Large}}

\newcommand{\given}[1]{\par\vspace{2ex}\textrm{\ifenglish{Given:}{Gegeben:}} #1\par}

\newcommand{\bracedpoint}[2][\empty]{%
  \if@points
    \underbrace{#2}_{\text{#1}\xspace\point}
  \else
    #2\point
  \fi
}

\newcommand{\bracedpoints}[3][\empty]{%
  \if@points
    \underbrace{#2}_{\textstyle{\points[#1]{#3}}}
  \else
    #2\points{#3}
  \fi
}
\newcommand{\roomstr}{Room}
\ProcessOptions*\relax
\PassOptionsToPackage{fleqn}{amsmath}
\PassOptionsToClass{intlimits,sumlimits}{amsmath}
\RequirePackage[utf8]{inputenc}
\RequirePackage{calc}
\RequirePackage{ifthen}
\RequirePackage{xcolor}
\RequirePackage{AMmath}
\RequirePackage{xspace}
\RequirePackage{relsize}
\RequirePackage{transparent}

\RequirePackage{array} % BAD

\RequirePackage{enumitem}

\RequirePackage{fancyhdr}

\RequirePackage{graphicx}
\RequirePackage{import}
\RequirePackage{lscape}
\RequirePackage{wrapfig} % BAD

\RequirePackage{ngerman}

\RequirePackage{tikz}
\newenvironment{nomathindent}[1][1.0]{%
    \addtolength{\mathindent}{-#1\mathindent}%
    \ignorespaces
  }{%
    \ignorespacesafterend
}
\parindent0pt
\addtolength{\textheight}{85pt}
\newcommand{\AMexam@enforce@geometry}{%
  \setlength{\footskip}{2.5\baselineskip}
  \addtolength{\headsep}{-0.5\baselineskip}
  \addtolength{\topmargin}{-1.25\baselineskip}
  \setlength{\headheight}{28pt}
  \addtolength{\oddsidemargin}{15pt}
  \addtolength{\evensidemargin}{-40pt}
  \addtolength{\textwidth}{30pt}
  \setlength{\hsize}{\textwidth}
  \setlength{\linewidth}{\textwidth}
  \setlength{\headwidth}{\textwidth}
}
\AtBeginDocument{%
  \AMexam@enforce@geometry
  \maketitlepage
  \ifsol{
    \setcounter{page}{1}
  }{
    \setcounter{page}{0}
    \thispagestyle{empty}
    Page intentionally left blank!\\
    Please do not write on this page!\\
    Solutions presented on this page will not be graded!
    \newpage
  }
}
\newcommand{\@examtime}{0\xspace}
\newcommand{\examtime}[1]{\renewcommand{\@examtime}{#1\xspace}}

\newcommand{\@examdate}{\today}
\newcommand{\examdate}[1]{\renewcommand{\@examdate}{#1}}

\newcommand{\@formularysheets}{10\xspace}
\newcommand{\formularysheets}[1]{\renewcommand{\@formularysheets}{#1\xspace}}

\newcommand{\@examiner}{Prof. D. Rixen / Prof. W. Wall}
\newcommand{\examiner}[1]{\renewcommand{\@examiner}{#1}}
\newcommand{\@examname}{\if@english Exam \else Pr\"ufung \fi}
\newcommand{\examname}[1]{\renewcommand{\@examname}{#1}}

\newcommand{\@chair}{%
  \if@english
    Institute of Applied Mechanics
  \else
    Lehrstuhl f\"ur Angewandte Mechanik
  \fi
}
\newcommand{\chair}[1]{\renewcommand{\@chair}{#1}}
\newcommand{\@weightingmc}{20}
\newcommand{\@weightingcalc}{80}
\newcommand{\weighting}[2]{%
  \renewcommand{\@weightingmc}{#1}
  \renewcommand{\@weightingcalc}{#2}
}
\newcounter{extrapaper}
\setcounter{extrapaper}{0}
\newcommand{\extrasheets}[1]{\setcounter{extrapaper}{#1}}

\AtEndDocument{
  \if@simplesol
    \extrasheets{0}
  \fi
  \sbox{\@solution}{}
  \addtolength{\textheight}{2pt}
  \whiledo{\value{extrapaper}>0}{
    \newpage
    \thispagestyle{ZusatzPapier}
    \grid{fill}% Gitter wird auf letzte Seite gelegt.
    \addtocounter{extrapaper}{-1}
  }
}

\RequirePackage{lastpage}
\newcommand{\AM@write@instructions@english}{%
\large\textbf{Instructions:} \normalsize % Bei Standartgr^^c3^^b6^^c3^^9fe 12pt entspricht small 11pt
\begin{itemize}
  \item This exam paper comprises \theproblemtotal\xspace questions on \pageref{LastPage}\xspace pages\ifthenelse{\theextrapaper>0}{, with \ifthenelse{\value{extrapaper}=1}{\theextrapaper\xspace additional page}{\theextrapaper\xspace additional pages}}{}.
  \item The  available time is \@examtime minutes.
  \item This exam comprises a total of \thetotalpointsforaux\xspace points.
  \item This exam is open-book.
  \item The use of electronic devices (e.g. calculator) is not allowed.
  \item Do not use pencils or red or green pens.
  \item The exam paper has to be turned in at the end of the exam.
  \item Turn off your mobile phones.
\end{itemize}
}

\newcommand{\AM@write@instructions@german}{%
\large\textbf{Hinweise:} \normalsize % Bei Standartgr^^c3^^b6^^c3^^9fe 12pt entspricht small 11pt

\begin{itemize}
  \if@multiplechoice
     \item Die vorliegende Pr^^c3^^bcfung umfasst \pageref{LastPage}\xspace Seiten\ifthenelse{\theextrapaper>0}{, davon \ifthenelse{\value{extrapaper}=1}{\theextrapaper\xspace Seite}{\theextrapaper\xspace Seiten} Zusatzpapier}{}.
     \item Die Pr^^c3^^bcfung hat einen Multiple-Choice-Teil mit \ref{mcproblem} Fragen und einen Rechenteil mit \theproblemtotal\xspace Aufgaben.
 \item Der Multiple-Choice-Teil wird mit \unit[\@weightingmc]{\%} gewichtet, der Rechenteil mit \unit[\@weightingcalc]{\%}.
   \item Der Multiple-Choice-Teil enth^^c3^^a4lt \ref{mcpointstotal} richtige Antworten.
 \item Im Rechenteil k^^c3^^b6nnen \thetotalpointsforaux\xspace Punkte erreicht werden.
\else
     \item Die vorliegende Pr\"ufung umfasst \theproblemtotal\xspace Aufgaben auf \pageref{LastPage}\xspace Seiten\ifthenelse{\theextrapaper>0}{, davon \ifthenelse{\value{extrapaper}=1}{\theextrapaper\xspace Seite}{\theextrapaper\xspace Seiten} Zusatzpapier}{}.
     \item  Es k^^c3^^b6nnen \thetotalpointsforaux\xspace Punkte erreicht werden.
\fi
  \item Die Pr^^c3^^bcfungszeit betr^^c3^^a4gt \@examtime Minuten.
  \item Zugelassene Hilfsmittel: \@formularysheets doppelseitig beschriebene DIN A4-Bl^^c3^^a4tter
  \item Beantworten Sie die vorliegenden Fragen an den daf^^c3^^bcr vorgesehenen Stellen.
  \item Der Pr^^c3^^bcfungsbogen ist abzugeben.
  \item Weiteres Zusatzpapier wird bei Bedarf von den Aufsichtsf^^c3^^bchrenden ausgegeben.
  \item \textbf{Schalten Sie Ihre Mobiltelefone aus.}
\end{itemize}
}

\newcommand{\maketitlepage}{%
  % Kopfzeile f^^c3^^bcr die Titelseite (keine tats^^c3^^a4chliche Kopfzeile)
  \textsc{\@chair} \hfill \textsc{\@examname}\\
  \textsc{\@examiner} \hfill \@examdate
  \par\vspace{0.3cm}

  \tikzstyle{mybox} = [draw=black, rectangle, inner sep=0pt, inner ysep=15pt]
  \tikzstyle{fancytitle} =[fill=white, text=black]

  \if@anonymous%
  \else
    \begin{tikzpicture}
      %Vorname: 50 Prozent
      \pgfmathsetmacro{\boxlength}{0.5*(\textwidth-0.5cm)}
      \draw(0.0cm, 4.5cm) node [mybox] (firs) {%
        \hspace{\boxlength pt}
      };

      % Stricherl
      \pgfmathsetmacro{\letterlength}{\boxlength/14}
      \foreach \x in {1,...,13}
      \draw (\x*\letterlength - \boxlength/2 pt,3.98cm) -- (\x*\letterlength - \boxlength/2 pt,4.3cm);

      %Nachname: 50 Prozent
      \pgfmathsetmacro{\boxposition}{0.5*(\textwidth+0.5cm)}
      \draw(\boxposition pt, 4.5cm) node [mybox] (last) {%
        \hspace{\boxlength pt}
      };

      % Stricherl
      \pgfmathsetmacro{\startposition}{-\boxlength/2 + \boxposition}
      \foreach \x in {1,...,13}
        \draw (\x*\letterlength + \startposition pt,3.98cm) -- (\x*\letterlength + \startposition pt,4.3cm);

      \node[fancytitle, right=10pt] at (firs.north west) {\ifenglish{First Name}{Vorname}};
      \node[fancytitle, right=10pt] at (last.north west) {\ifenglish{Last Name}{Nachname}};

      % Fill in name if solution
      \if@simplesol
        \node[red] at (firs.center) {Alex};
        \node[red] at (last.center) {Mustermann};
      \fi
    \end{tikzpicture}
  \fi

  \begin{tikzpicture}
    %Matrikelnummer:
    \if@tumasia
      %TUMAsia: 4.5cm (9 fields)
      \pgfmathsetmacro{\boxlength}{4.5cm}
    \else
      %Standard: 25 Prozent (8 fields)
      \pgfmathsetmacro{\boxlength}{0.25*(\textwidth-1cm)}
    \fi

    \draw(0.0cm, 4.5cm) node [mybox] (matr) {%
      \hspace{\boxlength pt}
    };

    \if@simplesol
      \node[red] at (matr.center) {0123456789};
    \fi

    % Stricherl
    \if@tumasia
      %TUMAsia: 9 fields
      \pgfmathsetmacro{\letterlength}{\boxlength/9}
      \foreach \x in {1,...,8}
      \draw (\x*\letterlength - \boxlength/2 pt,3.98cm) -- (\x*\letterlength - \boxlength/2 pt,4.3cm);
    \else
      \pgfmathsetmacro{\letterlength}{\boxlength/8}
      \foreach \x in {1,...,7}
        \draw (\x*\letterlength - \boxlength/2 pt,3.98cm) -- (\x*\letterlength - \boxlength/2 pt,4.3cm);
    \fi

    \node[fancytitle, right=10pt] at (matr.north west) {\ifenglish{Matriculation No.}{Matrikelnummer}};

    \if@anonymous%
    \else

      %Studiengang: 40 Prozent
      \pgfmathparse{0.5*(0.25+0.4)*(\textwidth-1cm)+0.5cm}
      \draw(\pgfmathresult pt, 4.5cm) node [mybox] (stud) {%
        \pgfmathparse{0.4*(\textwidth-1cm)}
        \hspace{\pgfmathresult pt}
      };

      \node[fancytitle, right=10pt] at (stud.north west) {\ifenglish{Study Program}{Studiengang}};

      %Saal: 35 Prozent
      \pgfmathparse{1cm + 0.5*(\textwidth-1cm)*(0.25+2*0.4+0.35)}
      \draw(\pgfmathresult pt, 4.5cm) node [mybox] (room) {%
        \pgfmathparse{0.35*(\textwidth-1cm)}
        \hspace{\pgfmathresult pt}
      };

      \node[fancytitle, right=10pt] at (room.north west) {\ifenglish{\roomstr/Seat}{Saal/Platz}};

    \fi

  \end{tikzpicture}

  \if@anonymous%
  \else
    \begin{tikzpicture}
      \draw(0, 0) node {\ifenglish{The data above is correct:}{Obige Angaben sind richtig:}};
    \end{tikzpicture}
    \hfill
    \begin{tikzpicture}
      %Unterschrift: 62 Prozent
      \draw(0, 0) node [mybox] (sign) {%
        \pgfmathparse{0.62*\textwidth}
        \hspace{\pgfmathresult pt}
      };

      \node[fancytitle, right=10pt] at (sign.north west) {\ifenglish{Signature}{Unterschrift}};
    \end{tikzpicture}
  \fi

  \rule{\hsize}{\arrayrulewidth}

  \vspace{0.25cm}

  \if@english
    \AM@write@instructions@english
  \else
    \AM@write@instructions@german

  \fi
\vfill

{\setlength{\tabcolsep}{0pt}

  \begin{tabular}{l|r}
    \hline
    \begin{tabular}[t]{p{0.55\textwidth}}
      \textbf{\ifenglish{Invigilator remarks}{Nur von der Aufsicht auszuf^^c3^^bcllen}}\\\\
      \ifenglish{Left the room}{H^^c3^^b6rsaal verlassen} \dotfill \hspace{0.3cm} \ \\\\
      \ifenglish{Early submission}{Vorzeitige Abgabe} \dotfill \hspace{0.3cm} \ \\\\
      \ifenglish{Remarks}{Besondere Bemerkungen} \dotfill \hspace{0.3cm} \ \\\\
      \dotfill \hspace{0.3cm} \ \\\\
      \ifenglish{Invigilator signature}{Unterschrift Aufsicht} \dotfill \hspace{0.3cm} \
    \end{tabular} & %
    \begin{minipage}[t]{0.45\textwidth}
      \newcounter{ct}
      \setcounter{ct}{0}
      \newcommand{\tableline}{}
      \setlength{\tabcolsep}{4pt}

      \pgfmathparse{\hsize/3-2*\tabcolsep}

\if@multiplechoice
   \vspace{0.3ex}
\centering \textbf{Multiple-Choice-Teil}\\[1mm]
\sdots{2cm} von \ref{mcpointstotal} richtigen Antworten\\\hrulefill\\
   \vspace{1ex}
   \centering \textbf{Rechenteil}
\fi
      \begin{tabular}[t]{c|c|c}%
  & \ifenglish{Points}{Punkte} & \ifenglish{Signature}{Korrektor} \\ \hline
        \ifnum 0<\value{problemtotal}
         \whiledo{\value{ct}<\value{problemtotal}}
        {\ifenglish{Question}{Aufgabe}\ \stepcounter{ct}\renewcommand{\tableline}%
          {\arabic{ct}&\ifsol{\ref{problempoints\thect}}{}&\\\hline\ifnum\c@ct=\c@problemtotal\hline\hline\fi} %Hack wegen Bug
     \tableline}
        \fi%
        $\sum$ &\ifsol{\thetotalpointsforaux}{}&
      \end{tabular}
    \end{minipage}
\end{tabular}}
\newpage

}
\fancypagestyle{Body}{%
  \fancyhead[L]{\@examname}
  \fancyhead[R]{\@examdate}%
  \fancyfoot[C]{\thepage}
  }

\fancypagestyle{PageSemestrale}{%
  \fancyhead[EL]{\@examname, \ \@examdate}%
  \fancyhead[ER]{\textsc{Semstrale}}%
  \fancyhead[OR]{\@examname, \ \@examdate}%
  \fancyhead[OL]{\textsc{Semestrale}}%
  \fancyfoot[C]{\thepage}}

\fancypagestyle{ZusatzPapier}{%
  \fancyhf{}%
  \fancyhead[L]{\@examname}
  \fancyhead[R]{\@examdate}%
  \fancyhead[C]{\begin{minipage}{3cm} Name\\ Student No.  \end{minipage} }%
  \fancyfoot[L,R]{\textbf{\ifenglish{Extra Paper}{Zusatzpapier}}}%
  }

\renewcommand{\headrulewidth}{0pt}  % Macht die Linie zwischen Kopfzeile und Basistext unsichtbar
\renewcommand{\footrulewidth}{0pt}  % Macht die Linie zwischen Fu^^c3^^9fzeile und Basistext unsichtbar

\fancyhf{} % L^^c3^^b6scht alle Felder in Kopf- bzw. Fu^^c3^^9fzeile - bestimmt f^^c3^^bcr Seite 1 Pagestyle{Titel}

\ifthenelse{\equal{\thepage}{1}}{\thispagestyle{empty}}{}

\pagestyle{Body}
\let\if@noalternative\iftrue
\newsavebox{\@alternativecontent}

\newenvironment{alternative}{%
    \global\setbox\@alternativecontent\vbox\bgroup%
    \@parboxrestore
    \@minipagerestore%
  }{
    \medskip\par\egroup
    \let\if@noalternative\iffalse
    \if@alternative \usebox{\@alternativecontent} \fi
    \let\if@noalternative\iftrue
}

\newcommand{\Tip}[1]{%
  \left(%
    \textbf{\ifenglish{Hint:}{Hinweis:}} #1
  \right)%
  \vspace*{3mm}\par%
}

\newcommand{\Tipp}[1]{%
  \textbf{\ifenglish{Hint:}{Hinweis:}} #1%
  \vspace*{3mm} \par
}

\newcommand{\AbHierGegeben}[2]{%
  \textbf{Hinweis:} Nehmen sie f\"ur die %
    folgende Teilaufgabe #1 als gegeben an. Rechnen Sie mit diesen Gr\"o"sen %
    weiter, setzen Sie \textbf{nicht Ihre Ergebnisse} aus Teilaufgabe #2) %
    ein!
  \vspace*{3mm} \par
}

\newcommand{\kringel}[1]{\ensuremath{\stackrel{\circ}{#1}}}

\newcommand{\stabkonvention}{%
  Verwenden Sie die Konvention, dass Stabkr\"afte von auf Zug belasteten St\"aben positiv sind.\xspace%
}
\newcommand{\mcright}{%
  \if@simplesol
    \ensuremath{\boxtimes}
  \else
    \ensuremath{\square}
  \fi
}
\newcommand{\mcwrong}{\ensuremath{\square}}

\newenvironment{multiple-choice}[3]{%
    \def\localpoints{#2}%
    \addtocounter{points}{\localpoints}
    \def\answer##1##2{##1&##2\\\hline}%
    \def\rightanswer##1{\answer{\mcright}{##1}}%
    \def\wronganswer##1{\answer{\mcwrong}{##1}}%
    \noindent%
    \textbf{%
      #1 \hfill%
      (%
        \localpoints~%
        \ifenglish{Point}{Punkt}%
        \if\localpoints1\else\ifenglish{s}{e}\fi
      )%
    }%
    \\[0.5ex]#3\\[1ex]%
    \tabularx{\linewidth}{|lX|}%
    \hline%
  }{%
    \endtabularx%
    \@printmarginpoints
}

\if@tumasia
  \newenvironment{right-wrong}[3]{%
    \def\localpoints{#2}%
    \addtocounter{points}{\localpoints}%
    \def\answer##1##2##3{##1&##2&##3\\\hline}%
    \def\rightanswer##1{\answer{\mcright}{\mcwrong}{##1}}%
    \def\wronganswer##1{\answer{\mcwrong}{\mcright}{##1}}%
    \noindent\textbf{%
      #1 \hfill
      (\localpoints~\ifenglish{Point}{Punkt}\if\localpoints1\else\ifenglish{s}{e}\fi)%
    }\\[0.5ex]#3\\[1ex]
    \tabularx{\linewidth}{|ccX|}
    \hline
    True & False & \\
    \hline
  }{
    \endtabularx
    \@printmarginpoints
  }
\fi

\newenvironment{subquestion}[1][]{%
    \textbf{#1}
    \renewcommand{\theenumi}{\textbf{\alph{enumi})}}%
    \renewcommand{\labelenumi}{\theenumi}  % Hier wird die Art der Nummerierung festgelegt
    \begin{enumerate}%
  }{
    \end{enumerate}%
}% \refstepcounter{problempoints}\label{problempoints\theproblem}}

\newlength{\@ItemEinzug}
\newenvironment{interenumerate}{
    \ifnum \@enumdepth>0
       \setlength{\@ItemEinzug}{-\leftmargin}
    \else
       \setlength{\@ItemEinzug}{0pt}
    \fi
    \begin{itemize}[label={},leftmargin=\@ItemEinzug]
      \item%
  }{%
    \end{itemize}%
}
\if@multiplechoice

\newcounter{mcproblem}
\setcounter{mcproblem}{0}
\newcounter{mcanswers}
\setcounter{mcanswers}{0}
\newcounter{mcpoints}
\setcounter{mcpoints}{0}
\newcounter{mcpointstotal}
\setcounter{mcpointstotal}{0}

\newenvironment{mcsection}{
  \section*{Multiple-Choice-Teil}
  \begin{subquestion}
}{
  \end{subquestion}
}

\newenvironment{mc}[1]{
    % options: text
    \item
    \refstepcounter{mcproblem}\label{mcproblem}%
    % % definition of answers
    \def\answer##1##2{%
    ##1&##2\refstepcounter{mcanswers}\label{mcanswers\themcproblem}\\\hline}%
\def\rightanswer##1{\refstepcounter{mcpoints}\label{mcpoints\themcproblem}\answer{\mcright}{##1}%
}%
\def\wronganswer##1{\answer{\mcwrong}{##1}}%
\noindent\textbf{%
\hfill (\ref{mcpoints\themcproblem}~\if@english{Point}\else{richtige Antwort}\fi\ifthenelse{\equal{\ref{mcpoints\themcproblem}}{1}}{}{en})}\\[0.5ex]#1\\[1ex]%
\tabularx{\linewidth}{|lX|}%
\hline%
}{
\endtabularx{}% Die geschweiften Klammern m^^c3^^bcssen da sein, damit nicht ein Konflikt mit dem nachfolgenden \if entsteht...
\if@pointssum
   % print mcpoints to the right
   \setlength{\marginparwidth}{0.9in}\marginparsep2mm%
\marginpar[\raggedleft\Huge\textcolor{red}{\textcircled{\textsf{\large\themcpoints}}}\normalsize]{\raggedleft\Huge\textcolor{red}{\textcircled{\textsf{\large\themcpoints}}}\normalsize}
   \setlength{\marginparwidth}{0in}%
\fi%
\addtocounter{mcpointstotal}{\themcpoints}%
\addtocounter{mcpointstotal}{-1}%
\refstepcounter{mcpointstotal}\label{mcpointstotal}%
\setcounter{mcpoints}{0}%
\setcounter{mcanswers}{0}%
}

\fi
\newcounter{problem}
\setcounter{problem}{0}

\newcounter{problemtotal}
\setcounter{problemtotal}{0}

\newcounter{points}
\setcounter{points}{0}

\newcounter{problempoints}
\setcounter{problempoints}{0}
\newcounter{problempointsforaux}
\setcounter{problempointsforaux}{0}

\newcounter{totalpoints}
\setcounter{totalpoints}{0}
\newcounter{totalpointsforaux}
\setcounter{totalpointsforaux}{0}

\newcommand{\@problemtoaux}{%
  \@bsphack%
  \if@filesw%
      % save probelm counter to .aux-file
     \protected@write\@auxout{}{\protect\setcounter{problemtotal}{\arabic{problem}}}%
  \fi
  \@esphack%
}

\newcommand{\@totalpointstoaux}{%
  \@bsphack%
  \if@filesw
    \protected@write\@auxout{}{\protect\setcounter{totalpointsforaux}{\arabic{totalpoints}}}
  \fi
  \@esphack%
} % Z^^c3^^a4hlerwechsel, da in der Aux-Datei immer weiter gez^^c3^^a4hlt(aufaddiert) wird.

\newenvironment{problem}[1][]{%
    \stepcounter{problem}%
    \setcounter{problempoints}{-1}%
    \section*{%
      \ifx&#1&%
        \ifenglish{Question}{Aufgabe} \theproblem
      \else
        \theproblem~-~#1
      \fi
      \hfill\normalsize
      \textrm{(\ref{problempoints\theproblem}\xspace\ifenglish{Points}{Punkte})}
    }%
    \@problemtoaux\@afterheading\nopagebreak%
  }{%
    \ifthenelse{\equal{\thepoints}{0}}{}{\printmarginpoints}
}

\newcommand{\pointsoverbrace}[2]{
  \if@points
    \ensuremath{\overbrace{#1}^{\points{#2}}}
  \else
    #1\points{#2}
  \fi
}

\newcommand{\pointoverbrace}[1]{
\if@points
   \ensuremath{\overbrace{#1}^{\point}}
\else
   #1\point
\fi
}

\newcommand{\pointsunderbrace}[2]{
\if@points
   \ensuremath{\underbrace{#1}_{\points{#2}}}
\else
   #1\points{#2}
\fi
}

\newcommand{\pointunderbrace}[1]{
\if@points
   \ensuremath{\underbrace{#1}_{\point}}
\else
   #1\point
\fi
}

\newcommand{\point}[1][1]{%
  \if@points
    \hskip1ex\fcolorbox{red}{white}{\textcolor{red}{#1}}%
  \fi
  % Verhindern, dass bei alternativem L^^c3^^b6sungsweg Punkte mehrfach aufaddiert werden
  \if@noalternative
    \addtocounter{points}{#1}
  \fi
}% Vergabe von Punkten in einer Zeile

\newcommand{\points}[2][]{%
  \if@ff
    \textcolor{red}{#1}
  \fi
  \point[#2]%
}

\newcommand{\@printmarginpoints}{
  \addtocounter{totalpoints}{\thepoints}
  \@totalpointstoaux

  \if@pointssum
    % print points to the right
    \vspace*{-6mm}
    \setlength{\marginparwidth}{0.7in}\marginparsep2mm%
    \marginpar[%
        \raggedleft\Huge\textcolor{red}{\textcircled{\textsf{\large\thepoints}}}\normalsize%
      ]{%
        \raggedleft\Huge\textcolor{red}{\textcircled{\textsf{\large\thepoints}}}\normalsize%
    }
    \setlength{\marginparwidth}{0in}%
  \fi

  \addtocounter{problempoints}{\thepoints}
  % if not in subquestion-mode, set label for problempoints
  \ifnum\@enumdepth=0
    \refstepcounter{problempoints}\label{problempoints\theproblem}
  \fi

  \setcounter{points}{0}
}
\newcommand{\printmarginpoints}{\@printmarginpoints}
\newlength{\@picwidth}
\newlength{\@pictextwidth}
\newcommand{\@tmppic}{}

\newenvironment{rpic}[2]{%
    \noindent
    \setlength{\@picwidth}{#1}
    \setlength{\@pictextwidth}{\hsize}
    \addtolength{\@pictextwidth}{-\@picwidth}
    \addtolength{\@pictextwidth}{-2\fboxsep}
    \renewcommand{\@tmppic}{#2}
    \begin{minipage}[t]{\@pictextwidth}
  }{%
    \end{minipage}
    \hfill
    \begin{minipage}[t]{\@picwidth}
      \par\flushright
      \vspace{-\baselineskip}
      \@tmppic
    \end{minipage}
}

\newlength{\@correctgrid}
\setlength{\@correctgrid}{0pt}
\newcommand{\correctgrid}[1][5mm]{
\setlength{\@correctgrid}{-#1}
}
\newcommand{\@opacity}{1}
\if@simplesol
  \renewcommand{\@opacity}{0.4}
\fi

\newlength{\@filllen}
\newcommand{\@calcfilllen}{
  % calculation of the filllength
  % WARNING: the next empty line must not be removed!

  \setlength{\@filllen}{\textheight}
  % Abfrage ob der freie Platz kleiner als \topskip ist
  \ifdim \pagetotal<\topskip
    \addtolength{\@filllen}{-\topskip}
  \else%
    % Abfrage ob \pagetotal > freier Platz ist
    \ifdim \pagetotal>\pagegoal
      \addtolength{\@filllen}{-\topskip}
    \else
      % L^^c3^^a4nge der belegten Seite wird abgezogen
      \addtolength{\@filllen}{-\pagetotal}
      % Abstand zwischen den Abs^^c3^^a4tzen wird abgezogen
      \addtolength{\@filllen}{-\parskip}
      % Grid correction for minipage-bug
      \addtolength{\@filllen}{\@correctgrid}
      \setlength{\@correctgrid}{0pt}
    \fi
  \fi
}
\newsavebox{\@solution}
\newsavebox{\@solutionA}
\newsavebox{\@solutionB}
\newlength{\@solutionposition}

\newlength{\@gridstep}
\newlength{\@gridwidth}
\newlength{\@gridheight}
\newlength{\@reducedfilllen}

\newlength{\@reducedfillwidth}

\setlength{\@gridwidth}{\textwidth}
\pgfmathparse{\textwidth/32.0} %
\setlength{\@gridstep}{\pgfmathresult pt}

\addtolength{\@gridwidth}{1cm}

\newcommand{\@grid}{
  \setlength{\@gridwidth}{\linewidth}
  \addtolength{\@gridwidth}{1cm}
  % H^^c3^^b6he auf \@gridstep-Schritte runden
  \pgfmathparse{\@gridstep*floor(\@filllen/\@gridstep)}
  \setlength{\@gridheight}{\pgfmathresult pt}
  \begin{interenumerate}
    \begin{tikzpicture}
      % printing the grid
    % OLD:\draw[opacity=\@opacity,step=\@gridstep,gray,thin] (0,0) grid (\@gridwidth,\@gridheight);
      % printing the content (only, when simplesol is active)
      \if@simplesol
         \draw (0,0) rectangle (\@gridwidth,\@gridheight);
         \setlength{\@solutionposition}{\@gridheight}
         \addtolength{\@solutionposition}{-1cm}
         \addtolength{\@solutionposition}{-\ht\@solution}
         % Question about x coordinate of node !!!
         \pgfmathsetmacro{\@textposition}{\textwidth/2}
         \node[anchor=south] at (\@textposition pt,\@solutionposition){\usebox{\@solution}};
      \else
        \draw[lightgray, step=\@gridstep] (0, 0) grid (\@gridwidth,\@gridheight);
      \fi
    \end{tikzpicture}
  \end{interenumerate}
}

\newcommand{\@checksolutionfit}{
\ifdim \ht\@solution>\@filllen
  \setlength{\@reducedfillwidth}{\textwidth}
  \addtolength{\@reducedfillwidth}{-2cm}
  \setlength{\@reducedfilllen}{\@filllen}
  \addtolength{\@reducedfilllen}{-2cm}
  \setbox\@solutionB=\vsplit\@solution to \@reducedfilllen
  \setbox\@solutionA=\vbox{\hsize=\@reducedfillwidth \usebox{\@solution}}
  \setbox\@solution=\vbox{\hsize=\@reducedfillwidth \usebox{\@solutionB}}
  \sbox{\@solutionB}{}
\fi%
}

\newcommand{\@shiftsolutionfit}{
\setbox\@solution=\vbox{\hsize=\@reducedfillwidth \usebox{\@solutionA}}
\sbox{\@solutionA}{}
}

%% !!! im Kommando grid: filllen ist \the\@filllen
\newcommand{\grid}[1]{%
  \ifthenelse{\equal{#1}{fill}}{
    % true: \@calcfilllen passes computed length to \@filllen
    \@calcfilllen%
  }{% false
    \setlength{\@filllen}{#1}
  }
  %% Und jetzt nach dem Berechnen der filllen: \the\@filllen
  % check, if solution fits into gridlength
  \@checksolutionfit
  \@grid
  \@shiftsolutionfit
}
\newenvironment{solution}{%
    \global\setbox\@solution\vbox\bgroup\hsize=0.9\textwidth% \hsize = \textwidth
    \@parboxrestore
    \@minipagerestore\begin{nomathindent}[1.0]%
  }{% nomathindent zieht den Einzug bei (bsp.) align-Umgebungen ab - Packet fleqn
    \end{nomathindent}\egroup
}

\newlength{\@solutionboxheight}
\newsavebox{\@solutionbox}
\newcommand{\@fillparam}{0pt}

\newenvironment{solutionbox}[1][0pt]{%
    \ifthenelse{\equal{#1}{fill}}{%
      \let\if@fill\iftrue
    }{%
      \let\if@fill\iffalse
      \setlength{\@filllen}{#1}
    }

    \ignorespaces\noindent\par
    \global\setbox\@solutionbox\vbox\bgroup\hsize=0.9\textwidth%
    \@parboxrestore
    \@minipagerestore%
    \begin{nomathindent}[1.0]
  }{%
    \end{nomathindent}\egroup%
    \addtolength{\fboxsep}{0.5ex}

    \if@fill
      % true: \@calcfilllen passes computed length to \@filllen
      \@calcfilllen
      \setlength{\@solutionboxheight}{\ht\@solutionbox}
      \addtolength{\@solutionboxheight}{\dp\@solutionbox}
      \addtolength{\@solutionboxheight}{2\fboxsep}
      \addtolength{\@solutionboxheight}{0.75ex}
      \addtolength{\@solutionboxheight}{\parskip}
      % \addtolength{\@solutionboxheight}{2ex}
      \addtolength{\@filllen}{-\@solutionboxheight}
    \fi

    \ifdim \@filllen>0pt
      \grid{\@filllen}
    \fi
    \vspace{2ex}\par
    \centerline{\framebox[\textwidth]{\usebox{\@solutionbox}}}%
    \@printmarginpoints
}

\newcounter{sdotsLines}
\newcommand{\sdots}[2][1]{%
  \setcounter{sdotsLines}{#1}%
  \settowidth{\@tempdima}{\parbox{#2}{\dotfill}}
  \parbox[t]{\@tempdima}{%
    \raisebox{-2.0ex}{\parbox{#2}{\dotfill}\raisebox{5.0ex}{}}
    \whiledo{\value{sdotsLines}<#1}{%
      \stepcounter{sdotsLines} \\[2.0ex]%
      \raisebox{-2.0ex}{\parbox{#2}{\dotfill}\raisebox{5.0ex}{}}%
    }
  }
}

\newcounter{mrows}
\newcounter{mcolumns}

\newcommand{\@and}{&}

\newcommand{\@lsgdots}{\sdots{0.5cm}}

\newcommand{\svec}[2]{\smat{#1}{1}{#2}}
\newcommand{\smat}[3]{%
  \setcounter{mrows}{1}
  %\@lsgdots generiert eine Punktlinie der l^^c3^^a4nge #3(verwendet f^^c3^^bcr gesamte Matrix)
  \renewcommand{\@lsgdots}{\sdots{#3}}
  \ensuremath{%
  %erzeugt mit \right) zusammen die Klammern um die Matrix
  % NO! use pmatrix
    \left(
    \begin{array}{*{#2}{c}} % tabelle(bzw.array) mit #2 Spalten(diese zentriert)
      \@lsgdots \setcounter{mcolumns}{1}
      % generiert erste Zeile(setzt Punkte spaltenwei^^c3^^9fe) mit #2-mal \sdots
      \whiledo{\value{mcolumns}<#2}{\@and \@lsgdots \stepcounter{mcolumns}}
      % wiederholt den columns-Schritt #1 mal f^^c3^^bcr Anzahl der Zeilen
      \whiledo{\value{mrows}<#1}{%
        \stepcounter{mrows}
        \\ \@lsgdots
        \setcounter{mcolumns}{1}
        \whiledo{\value{mcolumns}<#2}{\@and \@lsgdots \stepcounter{mcolumns}}
      }
    \end{array}
    \right)
  }
}

\newcounter{scases_rows}
\newsavebox{\@tmpboxa}

\newcommand{\scases}[3][-]{
  \setcounter{scases_rows}{1}
  \savebox{\@tmpboxa}{\quad \textrm{,f^^c3^^bcr} \quad \sdots{#3}}
   % \left\{ erzeugt mit \right. eine ge^^c3^^b6ffnete geschweifte Klammer
   % NO!
  \ensuremath{%
  \left\{
    \ifthenelse{\equal{#1}{-}}{% Ohne Bereichsangabe
        \begin{array}{l}
          \sdots{#3}
          \whiledo{\value{scases_rows}<#2}{ \\ \sdots{#3} \stepcounter{scases_rows}}
        \end{array}
      }{% mit Bereichsangabe - beliebige Angabe im #1-Argument aktiviert die Bereichsl^^c3^^bccken - whiledo-Iteration in tabular unm^^c3^^b6glich
        \begin{array}{l@{\usebox{\@tmpboxa}}}
          \sdots{#3}
          \whiledo{\value{scases_rows}<#2}{ \\ \sdots{#3} \stepcounter{scases_rows}}
        \end{array}
      }%
  \right.%
  }
}
\newcommand{\AMsetExam}[1]{\pgfkeys{/AM/exam/.cd,#1}}
\pgfkeys{
  /AM/exam/.is family,/AM/exam,
  time/.code = {\examtime{#1}},
  name/.code = {\examname{#1}},
  date/.code = {\examdate{#1}},
  examiner/.code = {\examiner{#1}},
  room name/.code = {\renewcommand{\roomstr}{#1}},
  extra sheets/.code = {\extrasheets{#1}},
}
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
%% This work consists of the file  AMexam.dtx
%% and the derived files           AMexam.ins,
%%                                 AMexam.pdf and
%%                                 AMexam.cls.
%% 
%%
%% End of file `AMexam.cls'.
