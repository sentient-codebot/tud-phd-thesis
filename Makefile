# explain what this does
# explain that this version is for testing and does too much for average user

.PHONY: all dissertation_roboto dissertation_fourier dissertation_print propositions_roboto propositions_fourier clean dist_clean
# Linux and Mac can be detected as follows; but are treated the same

# define default targets for `make`
all: dissertation_roboto dissertation_fourier dissertation_print propositions_roboto propositions_fourier
# targets are never made, so make tasks below are always executed.

clean:
	# delete temporary / auxiliary files
	latexmk -c

dist_clean:
	# delete all output files; revert all changes
	git clean -f -d -x

dissertation_roboto:
	latexmk --recorder dissertation.tex

dissertation_fourier:
	latexmk --recorder dissertation_fourier.tex

dissertation_print:
	latexmk --recorder dissertation_print.tex

propositions_roboto:
	# has no bibliography or references, so simple compilation suffices
	lualatex propositions.tex

propositions_fourier:
	# has no bibliography or references, so simple compilation suffices
	lualatex propositions_fourier.tex

%.pdf: %.tex
	latexmk --recorder $<
	pcregrep -Mir 'warning( \([^\)]*\))?:.*(\n\(.*)*' $*.log
