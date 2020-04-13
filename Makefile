.PHONY: help book clean serve

help:
	@echo "Please use 'make <target>' where <target> is one of:"
	@echo "  install     to install the necessary dependencies for jupyter-book to build"
	@echo "  book        to convert the content/ folder into Jekyll markdown in _build/"
	@echo "  clean       to clean out site build files"
	@echo "  runall      to run all notebooks in-place, capturing outputs with the notebook"
	@echo "  serve       to serve the repository locally with Jekyll"
	@echo "  build       to build the site HTML, overwriting all old HTML files"
	@echo "  site 		 to build the site HTML, store in _site/, and serve with Jekyll"
	@echo "  cuserver    to build the site HTML locally in _site and xfer to cu server/"


install:
	jupyter-book install ./

book:
	jupyter-book build ./

runall:
	jupyter-book run ./content

clean:
	python3 scripts/clean.py

serve:
	bundle exec guard

build:
	jupyter-book build ./ --overwrite

site: 
	bundle exec jekyll build
	touch _site/.nojekyll

cuserver: 
	python3 scripts/remove_local.py _data/toc.yml _data/cutoc.yml
	cp -av _data/toc.yml _data/saved-toc.yml
	cp -av _data/cutoc.yml _data/toc.yml
	/bin/rm -rf _build.save _site.save
	mv -vf _build _build.save
	mv -vf _site _site.save
	jupyter-book build ./
	bundle exec jekyll build
	touch _site/.nojekyll
	echo XXX rsync -av --delete-delay _site holtz3.cee.carleton.ca:/files/www/html/cive3205/steel1-book/
	rsync -av --delete-delay _site pdb:/files/www/html/cive3205/steel1-book/
	mv -vf _data/saved-toc.yml _data/toc.yml
	/bin/rm -rf _build _site
	mv -vf _build.save _build
	mv -vf _site.save _site
