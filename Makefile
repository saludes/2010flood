IMAGES = cut.pdf
flood.pdf: flood.tex answer.tex ${IMAGES}
	pdflatex flood

cut.pdf: rayleigh.py
	python2.6 $^

clean:
	rm -f cut.pdf 

distclean:
	make clean
	rm -f flood.pdf
