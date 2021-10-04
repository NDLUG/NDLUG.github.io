#!/bin/sh

# NOTE: this script is meant to be called by the Makefile, not directly

FEED_TITLE='Notre Dame Linux Users Group'
FEED_NAME='NDLUG'
FEED_EMAIL='ndlug@nd.edu'
FEED_LINK='https://ndlug.org'
FEED_LINK_SELF='https://ndlug.org/feed.xml'
FEED_GENERATOR="$(basename "$0")"
FEED_UPDATED="$(date -Is)"

cat <<EOF
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
    <title>${FEED_TITLE}</title>
    <link href="${FEED_LINK}"/>
    <link href="${FEED_LINK}" rel="self"/>
    <updated>${FEED_UPDATED}</updated>
    <id>${FEED_LINK}</id>
    <author>
        <name>${FEED_NAME}</name>
        <email>${FEED_EMAIL}</email>
    </author>
    <generator>${FEED_GENERATOR}</generator>
EOF

# do the entries

POSTS="$(ls -1 docs/posts/*.html)"
for file in $POSTS; do
    ENTRY_TITLE="$(sed -nE 's|<title>(.*)</title>|\1|p' "$file" | xargs)"
    ENTRY_AUTHOR="$(sed -nE 's|<span class="date-author author">by (.*)</span>|\1|p' "$file" | xargs)"
    ENTRY_LINK="${FEED_LINK}/posts/${file}"
    ENTRY_UPDATED="$(date -Is -d @"$(stat -c %Y "$file")")"
    ENTRY_CONTENT="$(tr '\n' ' ' < "$file" | sed -nE 's|.*<div id="content">(.*)</div>.*|\1|p' | xargs)"

    cat <<EOF
    <entry>
        <title>${ENTRY_TITLE}</title>
        <author>
            <name>${ENTRY_AUTHOR}</name>
        </author>
        <link href="${ENTRY_LINK}"/>
        <updated>${ENTRY_UPDATED}</updated>
        <id>${ENTRY_LINK}</id>
        <content type="html"><![CDATA[ ${ENTRY_CONTENT} ]]></content>
    </entry>
EOF
done

echo '</feed>'
