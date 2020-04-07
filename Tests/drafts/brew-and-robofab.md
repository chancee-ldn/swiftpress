title: Homebrew, Robofab, Fontlab
date: 13/04/2016
excerpt: Confused myself installing robofab in a keg
tags: Fontlab, Python, Robofab
lang: English
link: 

Installing robofab on a machine with homebrew running ended up putting it into

```applescript
/usr/local/Cellar/python/2.7.10_2/... /install.py
```

which isn't ideal and makes Fontlab throw some blah like: ImportError: No module named robofab.world, the correct install command is:

```applescript
sudo /usr/bin/python /install.py
```