.PHONY: fmt-articles
fmt-articles:
	npx prettier --write --print-width 80 --prose-wrap always "*/**/*.md"


