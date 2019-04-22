all:
	ruby .\generate-pdf.rb
	cd Italiano && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___Italiano.tex"
	cd Italiano && biber "Curriculum_Vitae___Italiano"
	cd Italiano && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___Italiano.tex"
	cd Italiano && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___Italiano.tex"
	move "Italiano\Curriculum_Vitae___Italiano.pdf" ".\"
	cd English && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___English.tex"
	cd English && biber "Curriculum_Vitae___English"
	cd English && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___English.tex"
	cd English && pdflatex -synctex=1 --shell-escape -interaction=batchmode "Curriculum_Vitae___English.tex"
	move "English\Curriculum_Vitae___English.pdf" ".\"
	del /Q /F /S "*.bcf" "*.run.xml" "*.aux" "*.glo" "*.idx" "*.log" "*.toc" "*.ist" "*.acn" "*.acr" "*.alg" "*.bbl" "*.blg" "*.dvi" "*.glg" "*.gls" "*.ilg" "*.ind" "*.lof" "*.lot" "*.maf" "*.mtc" "*.mtc1" "*.out" "*.synctex.gz" "*.synctex(busy)" "*.thm"