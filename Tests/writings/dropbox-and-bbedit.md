title: Dropbox and BBEdit
date: 06/06/2013
excerpt: Syncing settings
tags: language, isolates, South America
lang: English
link: http://www.barebones.com/products/bbedit/bbedit10.html

Will the wonders of Dropbox ever cease? Being freelance I tend to work in multiple locations, so keeping the same environment between machines (Air on the move or an iMac at home) makes my life a lot less confusing.

The recent release of [BBEdit](http://www.barebones.com/products/bbedit/bbedit10.html) allows you to keep your preferences and settings in Dropbox, here's how I did it - remember to quit BBEdit before you do any of this.

Create an Application Support folder in the root of your Dropbox. So for me, that looks like:

```
~/Users/lifu/Dropbox/Application Support
```



Locate your BBEdit preferences folders, on Mountain Lion that appeared to be this:

```
~/Users/lifu/Library/Application Support
```



and drop it into your newly created Application Support dropbox folder.
Once you restart BBEdit, it should detect the new folder and treat that as the primary, so any language modules, workspace preferences or scripts you drop in there will be shared between your machine naturally. Brave new world huh?

[Thomas Brand](http://eggfreckles.net) has an [in-depth](http://eggfreckles.net/notes/syncing-bbedit-with-dropbox/) guide to getting BBEdit playing nicely with Dropbox prior to version 10, I'd recommend giving that a read if the above doesn't work.
