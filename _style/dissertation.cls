\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{_style/dissertation}[2022/11/26 v3.0 TU Delft dissertation class]

\DeclareKeys[_style/dissertation] {
  fourier.if         = @fourier,
  print.if           = @print,
  usearial.if        = @usearial,
}

% all other options are passed on to scrbook
\DeclareUnknownKeyHandler[_style/dissertation]
  {\PassOptionsToClass{\CurrentOption}{scrbook}}

\PassOptionsToClass{\CurrentOption}{scrbook}

\ProcessKeyOptions[_style/dissertation]

\LoadClass[10pt]{scrbook}

\usepackage{ifluatex}
\RequirePackage{letltxmacro}

% English is the default language, but Dutch is used for some sections.
\ifluatex
  \RequirePackage{polyglossia}
  \setdefaultlanguage[variant=british]{english}
  \setotherlanguage{dutch}
  \NewDocumentCommand{\sethyphenation}{mm}{
    \begin{hyphenrules}{#1}
      \hyphenation{#2}
    \end{hyphenrules}
  }
\else
  \RequirePackage[dutch, british]{babel}
  \usepackage[LGR,T1]{fontenc}  
  \NewDocumentCommand{\sethyphenation}{mm}{
    \selectlanguage{#1}
    \hyphenation{#2}
  }
\fi

% https://typographyforlawyers.com/one-space-between-sentences.html
% anyway, this saves a lot of trouble: https://latexref.xyz/_005cspacefactor.html
\frenchspacing

\RequirePackage{microtype}
\RequirePackage{siunitx}
\RequirePackage{mathtools} % improved version of amsmath; wants to be loaded before unicode-math
% \RequirePackage{amssymb}
% \RequirePackage{bm}

\ifluatex
  \RequirePackage{fontspec}
\fi

\if@fourier
  \RequirePackage{_style/font-fourier-tudelft}
\else
  \RequirePackage{_style/font-roboto-tudelft}
\fi

\if@usearial
  \ifluatex
    \newfontfamily{\arial}{Arial}
    \setsansfont[Scale=0.95]{Arial}
  \else
    \usepackage{tgheros}
    % replace slanted by italics, since TeX Gyre Heros does not have slanted
    % https://golatex.de/viewtopic.php?p=110383
    % https://tex.stackexchange.com/questions/692277/replacing-tt-italic-with-tt-slanted-at-latex-level
    \LoadFontDefinitionFile{\f@encoding}{qhv}% force fd to load 
    \DeclareFontShape{\f@encoding}{qhv}{m}{sl}{<->ssub*qhv/m/it}{}
  \fi
\fi

% https://texdoc.org/serve/scrbook/0#page=26
% apply these settings after fonts are chosen, to prevent "Package typearea Warning: Bad type area settings!"
\KOMAoptions{
    paper = 17cm:24cm,
    DIV = 15,
    BCOR = \dimeval{\paperwidth/16},
}

\RequirePackage[headsepline=true,footsepline=false]{scrlayer-scrpage}

\RequirePackage[showcrop]{geometry}
\RequirePackage{graphicx}
\RequirePackage[unicode]{hyperref}
\RequirePackage{calc}
\RequirePackage{etaremune}
\RequirePackage{lettrine}
\RequirePackage{metalogo}
\RequirePackage{xpatch}
\RequirePackage[
   backend=biber,
   style=numeric-comp,
   useprefix=true,
   sorting=none,
   sortcites=true,
   maxbibnames=99,
   giveninits=true,
]{biblatex}


% make "et al" italic
\xpatchbibmacro{name:andothers}{%
  \bibstring{andothers}%
}{%
  \bibstring[\emph]{andothers}%
}{}{}

% command for fullcite with all authors
\newcommand{\printpublication}[1]{\AtNextCite{\defcounter{maxnames}{99}}\fullcite{#1}}

\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage{booktabs}
\RequirePackage{fvextra}
\RequirePackage{csquotes}

% control where floats can go: only after their definition in sourcecode
\RequirePackage{flafter}

% Bottom-placed floats may fill all of the page
\renewcommand{\bottomfraction}{1}
% Top-placed floats may fill all of the page
\renewcommand{\topfraction}{1}
% No text at all needs to be present on a page
\renewcommand{\textfraction}{0}
% Set the maximum number of floats allowed ...
% - at the top of a text page (the default is 2)
\setcounter{topnumber}{8}
% - at the bottom of a text page (the default is 1)
\setcounter{bottomnumber}{8}
% - on any one text page (the default is 3)
\setcounter{totalnumber}{8}

% set default figure and table placement to be `htp'
\renewcommand*{\fps@figure}{htp}
\renewcommand*{\fps@table}{htp}
% set float content centered
\g@addto@macro\@floatboxreset{\centering}

\RequirePackage{_style/color-tudelft}

%% Set the paper size to 17 by 24 cm, approximately halfway between A4 and A5.
\if@print
  \RequirePackage{_style/cropmarks}
  
  \RequirePackage{_style/edge-indices}
  % print edge indices on all pages where `\leftmark' or `\rightmark' are used
  \AddToHook{cmd/leftmark/before}{\printEdgeIndex}
  \AddToHook{cmd/rightmark/before}{\printEdgeIndex}

  \addbleed[2mm]
\fi
%% We decrease the margins slightly from the default (scale = 0.7).
\geometry{hscale=0.75,vscale=0.8}
\setlength{\marginparwidth}{20mm}

%% Redefine the title command to accept an optional subtitle.
\renewcommand*\title[2][]{%
    \def\@subtitle{#1}%
    \def\@title{#2}%
    %% Add the title to the PDF meta data.
    \hypersetup{pdftitle=#2}%
}

%% function to extract one initial
\def\getnextinitial#1#2 #3|{% space and pipe are delimiters;
  % #1 is one token, #2 everything up to the first space, #3 all the rest up to the pipe
  \xdef\@initials{\@initials#1.}% Append the first character to the initials
  \xdef\remainingnames{#3}}% Store the remaining names

%% Redefine the author command to accept a first and last name, and to add the
%% full name to the PDF meta data.
\renewcommand*\author[2]{%
  \def\@firstnames{#1}%
  \def\@lastname{#2}%
  % gather initials from first names
  \def\@initials{}%
  \xdef\remainingnames{\@firstnames{} }% space is needed, else it will not work for the last name
  \loop
    \expandafter\getnextinitial \remainingnames|%
  \unless\ifx\remainingnames\empty\repeat% If no more names are remaining, exit the loop
  \hypersetup{pdfauthor=#1\ #2}%
}

\renewcommand{\maketitle}{
  \begin{center}
    %% Extra whitespace at the top.
    \vspace*{2\bigskipamount}

    %% Print the title.
    \titlestyle\Huge\@title

    %% Print the optional subtitle.
    \ifx\@subtitle\undefined\else
      \bigskip
      \titlefont\titleshape\Large\@subtitle
    \fi

  \end{center}
}

%% Remove the header and page number on empty pages.
\def\cleardoublepage{%
  \clearpage%
  \if@twoside%
    \unless\ifodd\c@page%
      \thispagestyle{empty}%
      \vspace*{\fill}%
      \newpage%
    \fi%
  \fi%
}


%% Color the bullets of the itemize environment and make the symbol of the third
%% level a diamond instead of an asterisk.
\renewcommand*\labelitemi{\color{title}\textbullet}
\renewcommand*\labelitemii{\color{title}--}
\renewcommand*\labelitemiii{\color{title}$\diamond$}
\renewcommand*\labelitemiv{\color{title}\textperiodcentered}

%% Define an unnumbered footnote command.
\newcommand\blfootnote[1]{%
  \begin{NoHyper}
  \renewcommand\thefootnote{}\footnote{#1}%
  \addtocounter{footnote}{-1}%
  \end{NoHyper}
}

% Define a drop command which can be used to generate drop caps at the
% beginning of a section.
\renewcommand*\LettrineTextFont{\titleshape}
\newcommand*\dropcap[2]{
  \lettrine[lines=2,findent=0.2em,nindent=0pt,loversize=.05]{\color{title} \smash{{%
    \if@fourier
      \mdseries
    \else
      \ifluatex
        \fontspec[Instance=Medium]{RobotoSlab}
      \else
        \robotoslab
      \fi
    \fi #1}}}{#2}%
}

%% Create an unnumbered reference section.
%\addto\captionsenglish{\renewcommand*\bibname{\color{title}References}}
%\newcommand*\references[1]{%
%    \bibliographystyle{dissertation}%
%    \bibliography{#1}%
%}
\newcommand{\printreferences}[1][]{\printbibliography[heading=subbibintoc,#1]}

% add double question mark to broken citations
\protected\def\abx@missing#1{%
  \mbox{\reset@font\bfseries#1??}}

%% Hyperlinks are cyan, except in print mode, when they are all black.
\hypersetup{
  colorlinks = true,
  citecolor = title,
  linkcolor = title,
  urlcolor = title,
  bookmarksopen = true,
}


%\KOMAoptions{numbers=endperiod}
\renewcommand\chapterlinesformat[3]{\Ifstr{#2}{}{}{#2\\[12pt]}#3}

\if@fourier
  %% The style for titles is small caps.
  \def\titlefont{\rmfamily}
  \def\titleshape{\scshape}
  \def\titlestyle{\titlefont\titleshape\bfseries}
  \def\headerstyle{\titlestyle}

  \addtokomafont{disposition}{\color{title}\rmfamily\mdseries}
\else
  %% The default style for titles is serif.
  \def\titlefont{\robotoslab}
  \def\titleshape{}
  \ifluatex
    \def\titlestyle{\titlefont\titleshape\fontspec[Instance=Light]{RobotoSlab}}
    \addtokomafont{disposition}{\color{title}\robotoslab}
  \else
    \def\titlestyle{\titlefont\titleshape\robotoslab}
    \addtokomafont{disposition}{\color{title}\robotoslab\upshape}
  \fi
  \def\headerstyle{\titlefont\titleshape}
\fi

\RequirePackage{_style/chapter-openers}
\if@fourier
  \addtokomafont{chapter}{\bfseries\Huge}
\else
  \ifluatex
    \addtokomafont{chapter}{\Huge\upshape\fontspec[RawAxis={weight=350}]{RobotoSlab}}
  \else
    \addtokomafont{chapter}{\Huge\upshape\robotoslab}
  \fi
\fi
\addtokomafont{paragraph}{\upshape\bfseries\color{black}}
\if@usearial
  \addtokomafont{subparagraph}{\upshape\mdseries\color{black}}
  \addtokomafont{pageheadfoot}{\upshape}
  \else
  \addtokomafont{subparagraph}{\upshape\mdseries\scshape\color{black}}
  % \addtokomafont{pageheadfoot}{\scshape}
  \addtokomafont{pageheadfoot}{\upshape}
\fi

% Chapter titles have the same layout as parts.
\colorlet{chapternumbercolor}{black}
\newcommand{\chapternumberfont}{%
  \fontsize{96pt}{96pt}%
  \if@fourier
    \bfseries
  \else
    \robotoslab\thinseries
  \fi
  \color{chapternumbercolor}\selectfont
}

\renewcommand*{\raggedpart}{\raggedleft}
\renewcommand*{\raggedchapter}{\raggedleft}
\renewcommand*{\partformat}{{\chapternumberfont\thepart}\enskip}
\renewcommand*{\chapterformat}{{\chapternumberfont\thechapter}\enskip}

% ((Sub)sub)section titles start with the number in bold, followed by the name printed
% in the title color.
\if@fourier
  \renewcommand*{\sectionformat}{\textbf{\textcolor{black}{\thesection.}}\enskip}
  \renewcommand*{\subsectionformat}{\textbf{\textcolor{black}{\thesubsection.}}\enskip}
  \renewcommand*{\subsubsectionformat}{\textbf{\textcolor{black}{\thesubsubsection.}}\enskip}
\else
  \renewcommand*{\sectionformat}{{\textcolor{black}{\thesection.}}\enskip}
  \renewcommand*{\subsectionformat}{{\textcolor{black}{\thesubsection.}}\enskip}
  \renewcommand*{\subsubsectionformat}{{\textcolor{black}{\thesubsubsection.}}\enskip}
\fi

\RedeclareSectionCommands[
  afterskip=.2\baselineskip,
  tocentrynumberformat=\color{black},
]{section,subsection,subsubsection}

\RedeclareSectionCommands[
  tocentrypagenumberformat=\color{black}\bfseries,
  tocentrynumberformat=\color{black}\bfseries,
  tocentryformat=\bfseries,
]{chapter,part}

\if@usearial
  \RedeclareSectionCommands[
    tocentryformat=\bfseries\large,
    % tocindent=-2em,
    % tocnumwidth=2em,
  ]{part}
\else
  \RedeclareSectionCommands[
    tocentryformat=\scshape\bfseries\large,
    % tocindent=-2em,
    % tocnumwidth=2em,
  ]{part}
\fi

% Page header/footer styles
\newif\ifmainmatter
\mainmattertrue

% Print the current chapter and section at the top of the page in cyan.
\renewcommand{\sectionmark}[1]{\markright{\ifmainmatter\thesection.\fi\ \color{title}#1}{}}
\renewcommand{\chaptermark}[1]{\markboth{\ifmainmatter\thechapter.\fi\ \color{title}#1}{}}

\let\oldfrontmatter\frontmatter
\renewcommand{\frontmatter}{\oldfrontmatter\mainmatterfalse}
\let\oldmainmatter\mainmatter
\renewcommand{\mainmatter}{\oldmainmatter\mainmattertrue}
\let\oldbackmatter\backmatter
\renewcommand{\backmatter}{\oldbackmatter\mainmatterfalse}

% Draw the line below the header in the title color.
\setkomafont{headsepline}{\color{title}}
\setkomafont{footsepline}{\color{title}}

% Page numbers on the top left and top right.
\lehead{\thepage}
\rohead{\thepage}

% Section name on inner (left) side of the right (odd) page.
\lohead{\rightmark}
% Chapter name on inner (right) side of the the left (even) page.
\rehead{\leftmark}

\lefoot{}
\lofoot{}
\refoot{}
\rofoot[]{}
\cfoot[\thepage]{}

% Draw the line above a footnote in the title color as well.
\setfootnoterule{0.5\textwidth}
\addtokomafont{footnoterule}{\color{title}}

%% The dedication is vertically centered on a separate page and flushed to the
%% right.
\renewcommand\dedication[1]{%
  \thispagestyle{empty}%
  \vspace*{\fill}%
  \begin{flushright}%
    #1%
  \end{flushright}%
  \vspace*{\fill}%
  \cleardoublepage%
}

%% The authors environment is used to display the authors of a chapter on the
%% title page. This is only necessary if multiple people contributed
%% significantly to the chapter.
\newcommand*\authors[1]{%
  \begin{center}%
    {\Large\bfseries #1}%
  \end{center}%
  \vspace{2\baselineskip}%
}

%% The epigraph environment can be used to to add a quote to the title page of
%% a chapter.
\newcommand\epigraph[3][2\baselineskip]{%
  \begin{flushright}%
    {\itshape #2}%
    \vskip 0.5\baselineskip%
    #3%
  \end{flushright}%
  \vspace{#1}%
}

%% The abstract environment is used for the abstract of a chapter.
\newenvironment{abstract}{%
  \list{}{\leftmargin\rightmargin}%
  \item%
  \relax%
  \itshape%
}{%
  \endlist%
}

% add table of contents to the pdf bookmarks (but not to itself)
\LetLtxMacro{\oldtableofcontents}{\tableofcontents}
\renewcommand{\tableofcontents}{{
  \cleardoublepage%
  \phantomsection%
  \pdfbookmark[1]{\contentsname}{toc}
  \oldtableofcontents
}}

% throw a warning when importing a nonexistant file:
\AddToHookWithArguments{cmd/include/before}{%
  \IfFileExists{#1}{}{%
  \ClassWarning{\@currname}{File not found: #1}}}

% some commands that may cause errors when switching between pdflatex and lualatex
\providecommand{\babel@aux}[2]{}
\providecommand{\babel@toc}[2]{}
