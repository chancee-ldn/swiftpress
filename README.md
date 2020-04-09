# swiftpress

A simple static blogging system written in Swift. Inspired by [@an0's](https://github.com/an0) Letterpress and the Markdown powered by [John Sundell's](https://www.swiftbysundell.com) Ink.


### Philospohy
The idea of using SQL for a diary seems wrong. Swiftpress is designed to produce a static blog by periodically processing a bunch of markdown files. I run it locally and use a cron to rsync to a sever.


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

