title: Killing the cloud
date: 03/07/2015
excerpt: Stopping Adobe CC at start-up
tags: adobe, illustrator, SaaS
lang: English
link: 

It doesn't belong in the status bar. I've tweeted this before, but I've realised that Adobe CC reinstalls on an update. Assholes.

```
launchctl unload -w /Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist

```


Punch this into your terminal and kiss goodbye to the piece of shit in your status bar. Then go get a pint and tell your friends.