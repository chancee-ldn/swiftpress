# swiftpress

A simple static blogging system written in Swift. Inspired by @an0's Letterpress and the Markdown powered by @ano's Ink.


### Philospohy
Blogging systems became too complicated, SQL shouldn't be needed to present a diary. There was a simpler age of CGI scripts, and batch processing. Swiftpress aims to restore the sanity of times past. A folder of markdown documents, a template, press a button, get a folder of rendered HTML.



### Usage

### Generate Archive
This will generate a page of post titles, grouped by month.
`./swiftpress -archive ~/Production/swiftpress/Tests/writings ~/Production/swiftpress/Tests/templates`

### Generate posts
Generate posts and export them
`./swiftpress -posts ~/Production/swiftpress/Tests/writings`

