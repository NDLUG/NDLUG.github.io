INDEX = docs/index.html
FEED = docs/feed.xml
MD = $(shell ls content/*.md)
POSTS = $(MD:content/%.md=docs/posts/%.html)

all: $(POSTS) $(INDEX) $(FEED)

docs/index.html: templates/index.html $(POSTS)
	@echo "Populating $@ with posts list..."
	@sh util/build-index.sh $< $@

docs/feed.xml: $(POSTS)
	@echo "Generating Atom feed $@..."
	@sh util/generate-feed.sh > $@

docs/posts/%.html: content/%.md templates/post.html
	@echo "Converting $< to $@..."
	@pandoc -s --template=templates/post.html -f markdown -t html $< -o $@

clean:
	@echo "Nuking posts and (populated) index and feed..."
	@rm -f $(shell ls docs/posts/*) $(INDEX) $(FEED)
	@# using $(POSTS) wouldn't catch renames

deploy:
	# TODO

.PHONY: all clean deploy
