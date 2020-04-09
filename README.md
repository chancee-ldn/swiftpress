# swiftpress

A simple static blogging system written in Swift. Inspired by @an0's Letterpress and the Markdown powered by [https://www.swiftbysundell.com](John Sundell's) Ink.


### Philospohy
Blogging systems became too complicated, SQL shouldn't be needed to present a diary. There was a simpler age of CGI scripts, and batch processing. Swiftpress aims to restore the sanity of times past. A folder of markdown documents, a template, strike the match 🔥 . Get a folder of rendered HTML.



### Usage

### Generate Archive
This will generate a page of post titles, grouped by month.
`./swiftpress -archive ~/draftsDirectory ~/templateDirectory`

### Generate posts
Generate posts and export them, looks for a file called `post.template` and injects content at first `%@`
`./swiftpress -posts ~/draftsDirectory ~/outputDirectory ~/templateDirectory`

### Write front page
Makes a list of posts to stick on the front page
`./swiftpress -frontpage ~/draftsDirectory ~/outputDirectory ~/templateDirectory`

