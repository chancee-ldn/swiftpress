# swiftpress

A simple static blogging system written in Swift. Inspired by [@an0's](https://github.com/an0) [Letterpress](https://github.com/an0/Letterpress). Markdown is powered by [John Sundell's](https://www.swiftbysundell.com) [Ink](https://github.com/JohnSundell/Ink). I made it because the idea of using SQL for a diary seems crazy. Swiftpress is designed to produce a static blog by periodically processing a bunch of markdown files. I run it locally and use cron to rsync to a sever. 
You can see it in action on my: [blog](https://chanc.ee). It also makes RSS.


## Build
```
swift build
```
That's it. I've supplied a enough content in the Tests to export a blog with two posts from Mr Samuel Pepes - hopefully this is enough to let you see the inner workings.


## Test
If built from repo:
```
.build/x86_64-apple-macosx/debug/swiftpress -c config.md
```

## Set up

### Config file
We need a number of items to produce a blog. Place them in a markdown formatted like the below. 

`frontpage` dictates the number of posts to show on the front page.
```
---
url: http://yourdomain.com
output: /your/output/directory
templates: /your/templates/directory
posts: /your/markdown/posts/directory
postsOutput: /your/directory/for/posts
frontpage: 7
---
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

## Usage

### Custom config
Define an ad-hoc  `config.md` and execute `-frontpage`, `-archive` and `-posts`. This way you can use a single install of swiftpress to press multiple blogs.
```
./swiftpress -c custom-config.md
```

### Command line options
Removed individual options.


## Behaviours

### URL Format
Uses the `post.title` variable for a title and exports as `postsOutput/YYYYMMDD-post-title.html` .

`: & ' , ! : `  are stripped out from the title.
 
 `space / ` are replaced with `-`.


### Date Format
The default is to export European dates `(dd MM yyyy)`.  You can override this by writing a custom date function in the `Post` struct.

## Notes
Removed command line options - config files are the default for now.

## License

Swiftpress is licensed under a BSD-3-clause license. See [LICENSE](LICENSE) for details.
