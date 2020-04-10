# swiftpress

A simple static blogging system written in Swift. Inspired by [@an0's](https://github.com/an0) Letterpress and the Markdown powered by [John Sundell's](https://www.swiftbysundell.com) Ink.


## Philospohy
Used to power my [blog](https://chanc.ee). I mostly made it because the idea of using SQL for a diary seems crazy. Swiftpress is designed to produce a static blog by periodically processing a bunch of markdown files. I run it locally and use cron to rsync to a sever.


## Build
```
swift build
```
That's it.

## Usage

### Config file
We need a number of items to produce a blog. Place them in a markdown formatted like the below. Swiftpress will look in it's local directory for `config.md` or you can supply an ad hoc version via `-c` flag. The `url` value is only used in the RSS injection method current, `frontpage` dictates the number of posts to show on the front page.
```
url: https://domain.com
output: /your/output/directory
templates: /your/templates/directory
posts: /your/markdown/posts/directory
postsOutput: /your/directory/for/posts
frontpage: 7
```

### Auto generate
Will look for `config.md` in it's local directory and execute `-frontpage`, `-archive` and `-posts`
```
./swiftpress -g
```

### Custom config
Define a custom config file `config.md` in it's local directory and execute `-frontpage`, `-archive` and `-posts`
```
./swiftpress -c custom-config.md
```


### Generate Archive
This will generate a page of post titles, grouped by month.
```
./swiftpress -archive
```

### Generate posts
Generate posts and export them, looks for a file called `post.template` and injects content at first `%@`
```
./swiftpress -posts
```

### Write front page
Makes a list of posts to stick on the front page
```
./swiftpress -frontpage
```
