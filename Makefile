INDEX = www/index.html
FEED = www/feed.xml
MD = $(shell ls content/*.md)
POSTS = $(MD:content/%.md=www/posts/%.html)

all: $(POSTS) $(INDEX) $(FEED)

www/index.html: templates/index.html $(POSTS)
	@echo "Populating $@ with posts list..."
	@sh util/build-index.sh $< $@

www/feed.xml: $(POSTS)
	@echo "Generating Atom feed $@..."
	@sh util/generate-feed.sh > $@

www/posts/%.html: content/%.md templates/post.html
	@echo "Converting $< to $@..."
	@pandoc -s --template=templates/post.html -f markdown -t html $< -o $@

clean:
	@echo "Nuking posts and (populated) index and feed..."
	@rm -f $(shell ls www/posts/*) $(INDEX) $(FEED)
	@# using $(POSTS) wouldn't catch renames

deploy:
	# TODO

.PHONY: all clean deploy
