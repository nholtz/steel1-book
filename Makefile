.PHONY: help book clean serve

help:
	@echo "Please use 'make <target>' where <target> is one of:"
	@echo "  install     to install the necessary dependencies for jupyter-book to build"
	@echo "  book        to convert the 'content/' folder into Jekyll markdown in '_build/'"
	@echo "  clean       to clean out site build files"
	@echo "  runall      to run all notebooks in-place, capturing outputs with the notebook"
	@echo "  serve       to serve the repository locally with Jekyll"
	@echo "  site        to build the site HTML locally with Jekyll and store in _site/"
	@echo "  cuserver    to build the site HTML locally in _site and xfer to cu server/"


install:
	gem install bundler
	bundle install

book:
	jupyter-book build ./

runall:
	jupyter-book run ./content

clean:
	python scripts/clean.py

serve:
	bundle exec guard

build:
	bundle exec jekyll build
	touch _site/.nojekyll

site:	book
	bundle exec jekyll build
	touch _site/.nojekyll

cuserver: site
	rsync -av --delete-delay _site holtz3.cee.carleton.ca:/files/www/html/cive3205/steel1-book/
