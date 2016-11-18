# Title: Makefile for tutorial-R-web-data
# Author: Gaston Sanchez
#
# Note:
# This makefile makes use of "Automatic-Variables" extensively. Specifically:
# $(@D) the directory part of the file name of the target
# $(<F) the directory part and the file-within-directory part of the first prerequisite 
# $(@F) the file-within-directory part of the file name of the target


# names of all the slide directories
dirs = $(wildcard ls -d [0-9]*)

# names of all Rnw files
rnws = $(foreach dir,$(dirs),$(join $(dir)/,$(dir).Rnw))

# Outcome tex and pdf files
texs = $(patsubst %.Rnw,%.tex,$(rnws))
pdfs = $(patsubst %.Rnw,%.pdf,$(rnws))


.PHONY: clean


all: $(texs)


# Instead of using pdfs as targets, it's better to tell knit2pdf() to generate the tex files
# Specifying .tex file will avoid texi2dvi error
%.tex: %.Rnw header.tex
	cd $(@D); Rscript -e "library(knitr); knit2pdf('$(<F)', output = '$(@F)')"
	# remove all secondary files
	cd $(@D); rm -f *.{aux,log,nav,out,snm,vrb,toc}


clean:
	for d in $(dirs); \
	do                \
		echo "removing tex file inside $$d"; \
		rm -f $$d/*.tex; \
	done
