# TU Delft Style Dissertation template

::include{file=description_overleaf.html}

The source files can be found on [Gitlab](https://gitlab.com/novanext/tudelft-dissertation). It is designed to work with LuaLaTeX and PdfLaTeX (faster but less features and less fancy font support).


## Using the template

The document `dissertation.pdf` can be compiled using these commands:

```shell
lualatex dissertation
biber dissertation
lualatex dissertation
lualatex dissertation
```

The two first commands have been added to the top of the file as an Arara directive, as a reminder, and also so that the file can be build using `arara dissertation`. This generates very little output. If more is needed, you can use `arara -v dissertation`.

Whether or not you need all these steps depends on which files have changed since you last compiled the document. To skip the steps you do not need, and render the propositions as well, you can:

```shell
make dissertation
```

or alternatively:

```shell
latexmk dissertation
```


### Propositions

The sheet with propositions can be rendered using the command

```shell
lualatex dissertation
```

Since these do not contain references or citations, one run suffices, without `biber`.


## Visual Studio Code

`ctrl+shift+b` allows you to start one of the tasks specified in .vscode/tasks.json.

If you add assign one task as a default the Visual Studio (VS) Code will stop asking you which task you want to execute and always run this one when you press `ctrl+shift+b`:
```json
"group": {
	"kind": "build",
	"default": "true"
}
```


### Latexmk

`latexmk` is used by Overleaf to determine how the project is to be rendered.
Since we do not want to overrule the compiler set by the user, the line redefining
`pdflatex` is made a comment. An introduction to `latexmk`can be found here:
https://manpages.org/latexmk.

Two VS Code tasks run `latexkm`. 
- `latexmk (all files, once)`  
  builds everything of which `latexmk` can figure out how to do it
- `latexmk (current file, continuous)`  
  only build the pdf based on the file currently open in VS Code, but repeat
  process every time anything changes on which it depends according to `latexmk`.

For further inspiration and more features:
- https://www.overleaf.com/learn/how-to/How_does_Overleaf_compile_my_project%3F

One task runs `latexmk` once, creating `pdf`s from all `tex` files in the directory.
The other one continuously monitors the input file `disseration.tex` and updates `dissertation.pdf` whenever the input file is changed.


## Installation the TeX ecosystem

in Windows and Linux, you can use [TeX Live](https://www.tug.org/texlive/quickinstall.html) to render the thesis. On macOS, use [MacTeX](https://www.tug.org/mactex/).

You can either choose a full installation (which will take a long time, and cost a lot of hard disk space) or choose a small installation and add the following *collections* (this works in all operating systems):

```shell
tlmgr install collection-basic collection-bibtexextra collection-fontsextra collection-fontsrecommended collection-langenglish collection-langeuropean collection-langgreek collection-latex collection-latexextra collection-latexrecommended collection-mathscience collection-xetex
```

In (Debian-style) Linux, this can be done using the system package manager:

```shell
apt-get install -y texlive-basic texlive-bibtex-extra texlive-fonts-extra texlive-luatex texlive-science texlive-xetex cm-super texlive-math-extra texlive-lang-dutch
texlive-lang-english texlive-latex-extra
```

The complete installation process (on Linux) used on the Gitlab test server
to produce the pdf version of the thesis file
(e.g. https://gitlab.com/novanext/tudelft-dissertation/-/jobs/artifacts/master/browse?job=build_roboto) is described in two `Dockerfiles`.
- https://gitlab.com/novanext/tudelft-dissertation/-/blob/master/Dockerfile
- https://gitlab.com/novanext/base-docker/-/blob/master/Dockerfile


### Docker

The dissertation is rendered for gitlab by a runner using Docker.

- Start the Docker daemon
  - Linux: `systemctl start docker`
  - Mac: `open -a Docker`
- `docker build --tag=latex_course:$(date --iso-8601=date)_001 .`
- `docker run -p 4000:80 latex_course:$(date --iso-8601=date)_001`
- start an image interactively:  
  `docker run -v $(pwd):/latex_course -it latex_course:$(date --iso-8601=date)_001 /bin/bash`
  - in cmd, replace `$(pwd)` by `%cd%`; `$(date)` by `%date%`
  - in powershell, replace `$(pwd)` by `${pwd}`; `$(date)` by `$(Get-Date -Format "yyyy-MM-dd")`

### Overleaf

The Gitlab runner creates a zip file that can be uploaded to Overleaf. The result can be used as this template:  
<https://www.overleaf.com/latex/templates/tu-delft-dissertation/mfbtwcrcgmvy>  

The project that was submitted to create the template is:  
<https://www.overleaf.com/project/63984172ac2ff998b20ee1da>

## Fonts

The fonts can either be:

- Fourier; a more classic look:
  http://mirrors.ctan.org/fonts/fourier-GUT/doc/fourier-doc-en.pdf
- Arial (or Roboto) combined with RobotoSlab
  This combination fits the TUD corporate style:
  https://www.tudelft.nl/huisstijl/

This can be set by either adding or removeing the class option `fourier'.
Fourier has a more classic look, while the moderner look of Roboto fits the TU Delft style guide.

If you use Roboto in LuaLaTeX, you can make use of advanced variable font features

- [Youtube: Amstelvar & Roboto Flex: Unprecedented Flexibility...](https://www.youtube.com/watch?v=K-ruvv6P8sk)
- [Roboto … But Make It Flex](https://m3.material.io/blog/roboto-flex)
- [Exploring typefaces with multiple weights or grades](https://fonts.google.com/knowledge/choosing_type/exploring_typefaces_with_multiple_weights_or_grades)

## Diagrams

- [TikZ](https://tikz.dev/)
- [Package `standalone`](https://ctan.org/pkg/standalone)
- [smart diagrams](https://texdoc.org/serve/smartdiagram/0)

## Pdf format

low-hanging fruit for 'accessible PDF'  
https://www.latex-project.org/news/2024/07/08/tagging/

```tex
\DocumentMetadata{
  lang        = de,
  pdfversion  = 2.0,
  pdfstandard = ua-2,
  pdfstandard = a-4, %or a-4f
  testphase   = latest
}
```