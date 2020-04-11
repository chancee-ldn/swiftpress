# swiftpress

A simple static blogging system written in Swift. Inspired by [@an0's](https://github.com/an0) Letterpress and the Markdown powered by [John Sundell's](https://www.swiftbysundell.com) Ink. I mostly made it because the idea of using SQL for a diary seems crazy. Swiftpress is designed to produce a static blog by periodically processing a bunch of markdown files. I run it locally and use cron to rsync to a sever. 
You can see it in action on my blog: [chanc.ee](https://chanc.ee).


## Build
```
swift build
```
That's it. I've supplied a enough content in the Tests to export a blog with two posts from Mr Samuel Pepes - hopefully this is enough to let you see the inner workings.

## Usage

### Config file
We need a number of items to produce a blog. Place them in a markdown formatted like the below. Swiftpress will look in it's local directory for `config.md` or you can supply an ad hoc version via `-c` flag. The `url` value is only used in the RSS injection method currently, `frontpage` dictates the number of posts to show on the front page.
```
url: https://domain.com
output: /your/output/directory
templates: /your/templates/directory
posts: /your/markdown/posts/directory
postsOutput: /your/directory/for/posts
frontpage: 7
```

### A post
Needs to be formatted like so:
```
---
title: It is a play of itself the worst that ever I heard in my life
date: 01 Mar 1661 16:58:24 +0000 
excerpt: A short extract that will be included in the RSS feed...
tags: Tags, Seperated By, Commas
lang: English       
link: if a link is provided, the title on the frontpage will point to it, if blank it will push to the post
---
a posts content...(in markdown format)
```

### Auto generate
Will look for `config.md` in it's local directory and execute `-frontpage`, `-archive` and `-posts`
```
./swiftpress -g
```

### Custom config
Define an ad-hoc  `config.md` and execute `-frontpage`, `-archive` and `-posts`. This way you can use a single install of swiftpress to press multiple blogs.
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

## Notes

The default is to export sensible European dates `(dd MM yyyy)`.  You can override this by writing a custom date function in the `Post` struct.


## License

Swiftpress is licensed under a BSD-3-clause license. See [LICENSE](LICENSE) for details.
