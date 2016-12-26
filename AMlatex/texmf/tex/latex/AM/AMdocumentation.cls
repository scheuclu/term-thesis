%-------------------------------------------------------------------------------
% Class AMdocumentation is based on ltxdoc
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{AMdocumentation}[2016/01/31 v2.0 Documentation class]
\LoadClass[12pt,a4paper]{ltxdoc}
%-------------------------------------------------------------------------------
% Encoding: utf8 and T1
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
%-------------------------------------------------------------------------------
% Standards packages
\RequirePackage{varioref}
\RequirePackage{varwidth}
\RequirePackage{keystroke}
\RequirePackage{verbatim}
\RequirePackage{booktabs}
\RequirePackage{tabularx}
\RequirePackage{xspace}
\RequirePackage{hologo}
\RequirePackage{mwe}
%-------------------------------------------------------------------------------
% Get and print information on the git repository
\RequirePackage[maxdepth=5]{gitinfo2}
\RequirePackage{AMgit}
%-------------------------------------------------------------------------------
% Font and color package
\RequirePackage[setup]{AMcolor}
\RequirePackage[text=tumhlv]{AMfont}
%-------------------------------------------------------------------------------
% Package tcolorbox is copiously used
\RequirePackage[all]{tcolorbox}
% settings for docCommand, docKey, docColor, dispExample, dispListing
\tcbset{%
  doc left indent=-1.5cm,
  doc head={colback=TUMIvory!20,interior style=fill},
  color option=TUMGreen,
}
\tcbset{%
  docexample/.style={%
    boxrule=1pt,
    colframe=TUMBlue,
    colback=white,
    arc=0pt,
    fonttitle=\bfseries,
    listing engine=minted,
  },
  usage/.style={%
    detach title,
    before upper={\tcbtitle\quad},
    coltitle=TUMBlue,
    title={Usage},
  },
  documentation minted options={%
    fontsize=\normalsize,
  },
}
\tcbset{%
  color definition=TUMOrange,
  color key=TUMGreen,
  color value=TUMBlue,
  color command=TUMBlue,
  color color=TUMOrange,
  color hyperlink=TUMBlue,
}
%\tcbset{}
% settings for the index \tcbset{index format=doc}
\tcbset{index colorize}
\usemintedstyle{trac}
\newcommand{\AMkeyPath}[1]{\textcolor{TUMGreen}{\ttfamily#1}}
%-------------------------------------------------------------------------------
% Page layout
\RequirePackage[left=3cm,right=3cm,top=3cm,bottom=3cm]{geometry}
\RequirePackage{marginnote}
\RequirePackage{manfnt} % for the dangerous bend command
\setlength\parindent{0pt}
%-------------------------------------------------------------------------------
% Case Manipulation
\RequirePackage{mfirstuc}
\newcommand\firstToLow[1]{%
  {%
    \renewcommand{\mfirstucMakeUppercase}{\MakeLowercase}%
    \makefirstuc{#1}%
  }%
}
%-------------------------------------------------------------------------------
% Bibliography
\RequirePackage[style=nature]{AMbiblio}
\IfFileExists{AMdoc.bib}{%
    \addbibresource{AMdoc.bib}
  }{%
    \ClassWarning{AMdocumentation}{File AMdoc.bib not found}
}
%-------------------------------------------------------------------------------
% (Cross-)references
\RequirePackage{AMref}
\hypersetup{colorlinks=true,runcolor=TUMGreen}
\AMwritePdfMetaProperties{Created with AMdocumentation}
%-------------------------------------------------------------------------------
% Write loaded packages information in log file
\listfiles
%-------------------------------------------------------------------------------
% Record index informations
\makeindex
\DisableCrossrefs
\RecordChanges
%-------------------------------------------------------------------------------
% Font and colors settings
\AMsetColor{subsection=black,subsubsection=black}
\renewcommand{\ttdefault}{lmtt}
\def\theCodelineNo{\textcolor{TUMBlue}{\sffamily\footnotesize\oldstylenums{\arabic{CodelineNo}}}}
%-------------------------------------------------------------------------------
% Shortcuts
\newcommand{\miktex}{\hologo{MiKTeX}\xspace}
\newcommand{\texlive}{\hologo{TeX}Live\xspace}
\newcommand\TeXstudio{\hologo{TeX}studio\xspace}
\newcommand{\mactex}{Mac\hologo{TeX}}
%-------------------------------------------------------------------------------
% Maketitle
\let\OLDmaketitle\maketitle
\renewcommand{\maketitle}{%
  \pdfbookmark{\@title}{AMtitledocanchor}
  \begin{tcolorbox}[
     size=tight,oversize,
     sharp corners,
     enhanced,
     colframe=TUMBlue,
     colback=TUMBlue,
     colupper=white,
     enlarge left by=-100pt,
     right=160pt,
     left=30pt,
     bottom=30pt,
     top=20pt,
     fontupper={\Huge\bfseries},
     frame code app={\path[tcb fill frame]
       ([xshift=-2cm]frame.north) to[out=180,in=0] ([xshift=3cm,yshift=60pt]frame.north west)
       -- ([yshift=60pt]frame.north west) -- (frame.north west) --cycle;
     },overlay={%
       \node[black,anchor=east,xshift=-20pt] at (frame.east) {\includegraphics[height=30pt]{AM-logo-TUM-voll-weiss-RGB}};
       \node[black,anchor=west,xshift=32pt,yshift=30pt] at (frame.west)
            {\includegraphics[height=75pt]{AM-logo-AM-ivory-RGB}};
       \node[TUMIvory,xshift=5pt] at (frame.center) {\bfseries\Huge \@title};
     },overlay app={%
       \node[opacity=1,xshift=-2.2cm] at(frame.east) {\includegraphics[width=0.35\textwidth]{AM-logo-MW-ivory-RGB}};
     },
     ]
  \end{tcolorbox}
  \begin{center}
  \begin{minipage}{0.8\textwidth}
    \begin{tabular}{rl}
      \textbf{Package Version} & \AMinsertGitVersion \\[0.5ex]
      \textbf{Project home site}    & \url{https://gitlab.lrz.de/AM/AMlatex} \\[0.5ex]
      \textbf{Release date}    & \AMinsertGitDate \\[0.5ex]
      \textbf{Git reference}   & \gitBranch\,@\,\gitFirstTagDescribe \\[0.5ex]
      \textbf{Contact}         & \docEmail{\gitAuthorEmail}
    \end{tabular}
  \end{minipage}
  \end{center}
  \vskip-1cm
}%
%-------------------------------------------------------------------------------
\renewcommand{\contentsname}{}
\newenvironment{doctable}[1]{%
  \begin{tabular}{@{}#1@{}}
    \toprule
  }{%
    \bottomrule
  \end{tabular}
}
%-------------------------------------------------------------------------------
\newtcbox{todo}{enhanced
  ,capture=minipage
  ,frame hidden
  ,oversize
  ,interior hidden
  ,before upper={\color{TUMDiag17}\sffamily \marginnote{To Do}}
}
%-------------------------------------------------------------------------------
\newtcolorbox{boxtitlepage}[1]{
  title={#1},
  colback=TUMDiag7,
  colframe=TUMDiag4,
  fonttitle=\bfseries,
  size=small
}
%-------------------------------------------------------------------------------
\newcommand{\docEmail}[1]{\href{#1}{#1}\xspace}
%-------------------------------------------------------------------------------
\newcommand{\InsertLicenseBlaBla}{%
  This work may be distributed and/or modified under the
  conditions of the LaTeX Project Public License (LPPL), either
  version 1.3c of this license or (at your option) any later
  version.  The latest version of this license is in the file:
  \begin{center}
    \url{http://www.latex-project.org/lppl.txt}
  \end{center}
}
%-------------------------------------------------------------------------------
\newcommand{\InsertPgfkeysBlaBla}[1]{%
  \def\AMdocuAtAMsetName{AMset#1}
  \def\AMdocu@package{\firstToLow{#1}}
  \begin{hint}
    Package \AMpackageBox{AM\AMdocu@package} uses \PackageName{pgfkeys} internally to create option and parameter keys. In the
    following documentation all the defined keys are presented with their whole path, but only their names is needed
    in order for you to use them: the path \AMkeyPath{/AM/\AMdocu@package/} must be ignored when used in 
    \expandafter\refCom\expandafter{\AMdocuAtAMsetName}
  \end{hint}
}
%-------------------------------------------------------------------------------
% shamelessly copied from AMclsguide.tex
% see alternative tcolorbox p.188
\newsavebox{\dBox}
\newenvironment{danger}{%
    \begin{lrbox}{\dBox}
      \minipage{\linewidth-\widthof{\dbend}-\columnsep}
  }{%
      \endminipage
    \end{lrbox}%
    \trivlist\item\relax
    \noindent
    \minipage{\widthof{\dbend}}
      \raisebox{\height}[.9\height][.1\height]{\color{TUMOrange}\dbend}
    \endminipage
    \hfill
    \minipage{\wd\dBox}
      \usebox{\dBox}
    \endminipage%
  \endtrivlist
}
%-------------------------------------------------------------------------------
\newtcolorbox{warning}{skin=enhancedmiddle jigsaw,breakable,parbox=false,
  boxrule=0pt,leftrule=3mm,rightrule=3mm,boxsep=0pt,arc=0pt,outer arc=0pt,
  left=3mm,right=3mm,top=1mm,bottom=1mm,toptitle=1mm,bottomtitle=1mm,oversize,
  colback=TUMIvory!20,colframe=TUMOrange
}
%-------------------------------------------------------------------------------
\newtcolorbox{hint}{skin=enhancedmiddle jigsaw,breakable,parbox=false,
  boxrule=0pt,leftrule=3mm,rightrule=3mm,boxsep=0pt,arc=0pt,outer arc=0pt,
  left=3mm,right=3mm,top=1mm,bottom=1mm,toptitle=1mm,bottomtitle=1mm,oversize,
  colback=TUMBlue!5!white,colframe=TUMBlue}
%-------------------------------------------------------------------------------
\newcommand{\InsertImplementationBlabla}{%  
 \begin{warning}
 The following section does not aim to explain the usage of this package. It is intended for the package writer or anyone who want to understand the code and participate to its development. 
 \end{warning}
}
%-------------------------------------------------------------------------------
\newcommand{\PrintBibliography}{%
  \phantomsection
  \cleardoublepage
  \addcontentsline{toc}{section}{References}
  \printbibliography
}
%-------------------------------------------------------------------------------
\AtEndDocument{%
    \phantomsection
    \cleardoublepage
    \PrintIndex
    \phantomsection
    \cleardoublepage
    \addcontentsline{toc}{section}{Change History}
    \PrintChanges
}
%-------------------------------------------------------------------------------
% From basic-code.sty. ENV bashshell
\newtcblisting{bashshell}[1][]{
  colback=TUMDarkBlue!5!white,
  colupper=TUMDarkBlue,
  colframe=TUMBlue,
  top=0pt,bottom=0pt,
  listing engine=listings,
  listing only,boxrule=0.6pt,
  listing options={
    style=tcblatex,
    language=sh,
    keywordstyle={\color{TUMBlue}\bfseries},
    escapeinside={(*@}{@*)},
    morekeywords={ls,ln,rm,mkdir,git,cp,grep,ldd,qmake,make,source,sudo,chmod,wget}
  },
  every listing line*={\textcolor{TUMBlue}{\ttfamily\bfseries \$> }},
  fonttitle=\bfseries,
  size=fbox,
  #1
}
%-------------------------------------------------------------------------------
\newcommand{\InsertDocCompilationBlaBla}{%
  The present documentation was compiled 
  Required to compile the documentation: (not all of this is necessary needed to use AMlatex)
  tcolorbox (version 3.6 at last!!) (for library documentation features)
  pgf (recent and well installed)
}
%-------------------------------------------------------------------------------
\newtcbox{\FileName}{enhanced,nobeforeafter,tcbox raise base,boxrule=0.4pt,top=0mm,bottom=0mm,frame hidden,
  right=0mm,left=0mm,arc=0pt,outer arc=0pt,boxrule=0pt,boxsep=1pt,before upper={\vphantom{dlg}}\ttfamily,
  ,coltext=TUMGreen,colback=white
}
%-------------------------------------------------------------------------------
\DeclareTotalTCBox{\cmdbox}{ s O{>} v }{
    before upper={\vphantom{dlg}},
    verbatim,boxsep=0pt,tcbox raise base,
    colframe=TUMDarkBlue,colupper=TUMDarkBlue,
    colback=TUMDarkBlue!5!white,
    top=2.5pt,bottom=1pt,boxrule=0.4pt,left=2pt,right=2pt,arc=2pt,
  }{%
    \IfBooleanTF{#1}{}{\textcolor{TUMBlue}{\ttfamily\bfseries #2\,}}%
    \lstinline[%
    language=bash,morekeywords={tex,latex,pdflatex},
     keywordstyle={\color{TUMBlue}\bfseries}
    ]^#3^
}
%-------------------------------------------------------------------------------
\newtcbox{\flagbox}{
  on line
  ,before upper={\vphantom{dlg}\sffamily}
  ,boxrule=0.4pt,top=0pt,bottom=0mm,right=2pt,left=2pt,arc=1pt,boxsep=1pt,
  colframe=TUMBlue,coltext=TUMBlue,colback=TUMBlue!10!white
}
%-------------------------------------------------------------------------------
\newtcbox{\cmdarg}[1][TUMOrange]{enhanced,nobeforeafter,tcbox raise base,boxrule=0.4pt,top=0mm,bottom=0mm,
  right=0mm,left=0mm,arc=0pt,outer arc=0pt,boxrule=0pt,boxsep=1pt,before upper={\vphantom{dlg}}\ttfamily,
  ,coltext=#1,colback=white,frame hidden
}
%-------------------------------------------------------------------------------
\newcommand{\AMlinkDocumentation}[1]{\href[pdfnewwindow]{run:./#1.pdf}{#1}}
\newtcbox{\AMpackageBox}{enhanced,
  nobeforeafter,tcbox raise base,boxrule=0.4pt,top=0.5mm,bottom=0mm,
  right=0mm,left=4mm,arc=1pt,boxsep=1pt,before upper={\vphantom{dlg}},
  colframe=TUMGreen,coltext=TUMGreen,colback=white,fontupper=\normalfont,
  overlay={%
    \begin{tcbclipinterior}
      \fill[TUMGreen] (frame.south west) rectangle 
        node[text=white,scale=0.85,font=\sffamily\bfseries\tiny,rotate=90] {PKG} ([xshift=4mm]frame.north west);
    \end{tcbclipinterior}
  }
}
\newcommand{\AMpackage}[1]{\AMpackageBox{\AMlinkDocumentation{#1}}}
%-------------------------------------------------------------------------------
\newcommand{\extension}[1]{\texttt{#1}}
\newcommand{\PackageName}[1]{\textsf{\textcolor{TUMDiag4}{#1}}}
\newcommand{\DirPath}[1]{\texttt{\textcolor{TUMGreen}{#1}}}
\newcommand{\EnvVariable}[1]{\texttt{\textcolor{TUMBlue}{\$#1}}}
\newcommand{\AMdocClr}[1]{ \draw[fill=#1,draw=white] (0,0) rectangle (1.618,1); }
\newcommand{\AMdocLbl}[1]{ \node[right,font=\ttfamily] at (0,0.5) {#1}; }
%-------------------------------------------------------------------------------