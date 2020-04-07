# swiftpress

A simple static blogging system written in Swift. Inspired by @an0's Letterpress and the Markdown powered by [https://www.swiftbysundell.com](John Sundell's) Ink.


### Philospohy
Blogging systems became too complicated, SQL shouldn't be needed to present a diary. There was a simpler age of CGI scripts, and batch processing. Swiftpress aims to restore the sanity of times past. A folder of markdown documents, a template, strike the match 🔥 . Get a folder of rendered HTML.



### Usage

### Generate Archive
This will generate a page of post titles, grouped by month.
`./swiftpress -archive ~/Production/swiftpress/Tests/writings ~/Production/swiftpress/Tests/templates`

### Generate posts
Generate posts and export them
`./swiftpress -posts ~/Production/swiftpress/Tests/writings`
`./swiftpress -posts /path/to/posts /output/path /template/file.template`

`.build/x86_64-apple-macosx/debug/swiftpress -posts ~/Production/chanc.ee/.drafts ~/Production/chanc.ee/posts ~/Production/chanc.ee/post.template`

`.build/x86_64-apple-macosx/debug/swiftpress -posts ~/Production/chanc.ee/.drafts ~/Production/chanc.ee/posts ~/Production/chanc.ee/.templates/post.template`

### Write front page
Makes a list of posts to stick on the front page
`writeFrontPage(directory: arguments[2], outputPath: arguments[3], template: arguments[4], numberOfPosts: Int(arguments[5])!)`

`.build/x86_64-apple-macosx/debug/swiftpress -frontpage Tests/drafts Tests/output Tests/templates/frontpage.template 5`

`.build/x86_64-apple-macosx/debug/swiftpress -frontpage ~/chanc.ee/.drafts ~/chanc.ee ~/chanc.ee/index.html 5`

`.build/x86_64-apple-macosx/debug/swiftpress -frontpage Tests/drafts ~/Production/chanc.ee ~/Production/chanc.ee/.templates/index.html 5`

`.build/x86_64-apple-macosx/debug/swiftpress -frontpage ~/Production/chanc.ee/.drafts ~/Production/chanc.ee ~/Production/chanc.ee/.templates/index.html 5`

.build/x86_64-apple-macosx/debug/swiftpress -frontpage ~/Production/chanc.ee/.drafts ~/Production/chanc.ee ~/Production/chanc.ee/.templates 6

.build/x86_64-apple-macosx/debug/swiftpress -posts /Tests/drafts /templates/post.template
.build/x86_64-apple-macosx/debug/swiftpress -posts Tests/writings Tests/output/ Tests/templates/post.template



.build/x86_64-apple-macosx/debug/swiftpress -posts Tests/writings templates/post.template

.build/x86_64-apple-macosx/debug/swiftpress -archive Tests/writings Tests/output templates/archive.template
