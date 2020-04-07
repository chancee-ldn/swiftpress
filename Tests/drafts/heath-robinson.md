title: A Heath Robinson Last.fm
date: 29/07/2015
excerpt: Creating a replacement for last.fm
tags: Last.fm, iTunes, Applescript
lang: English
link: https://en.wikipedia.org/wiki/W._Heath_Robinson

Since the first iteration (what are we, version five now?) of this site I've always had somewhere that tracked the [latest music](http://lifu.ink/materiel/) I'd been listening to. Until today I powered that through a madcap combination of Last.fm and PHP (fuck PHP). It had always irked me that the only page preventing the whole site being static was that one script. 

Then iTunes Radio launched and changed the dynamic. Less music is going into my library, 'loved' tracks are a new paradigm (binary, not measured in degrees like a star rating), combine the fact I flick between radio stations and my own library and the the data set was already skewed. As far as last.fm is concerned all I've listened to for a week is [B.Dolans badass new album](https://itunes.apple.com/gb/album/kill-the-wolf/id983253303).

The solution I came up with was to devise a small Applescript which sits on Dropbox and generates a text file by querying a Smart Playlist in iTunes periodically (via Cron). It's fairly easy to follow, save this script as an Applescript, change this_playlist to suit your target playlist, run, and a text file should pop out in the folder where you saved the script. My version wraps each track in an `<li>` tag so it can flow into a list nicely. 

UPDATE: It's come to my attention no one seems to know who [Heath Robinson](https://en.wikipedia.org/wiki/W._Heath_Robinson) was - he was an English illustrator famous for drawings of overly complicated contraptions to solve simple problems.


```applescript
tell application "iTunes"
	activate
	
	-- set target playlist exisiting in iTunes, this one is for "Loved"
	set this_playlist to playlist "Loved"
	
	-- seperators between artist name, track title
	set the seperator to "<br />"
	set the opening_tag to "<li>"
	set the closing_tag to "</li>"
	set the bold_open to "<strong>"
	set the bold_close to "</strong>"
	
	-- for every track in playlist append to the playlist_data
	set the playlist_count to the count of tracks of this_playlist
	set playlist_data to {}
	tell this_playlist
		repeat with i from 1 to the count of tracks
			tell track i
				-- (OPENING_TAG/TRACKNAME/SEPERATOR/ARTIST/CLOSING_TAG)
				set the end of the playlist_data to {opening_tag, name, seperator, bold_open, artist, bold_close, closing_tag, return}
			end tell
		end repeat
	end tell
	
	-- flip the playlist_data into raw text
	set text_data to playlist_data as text
	
	-- cleans up path to save local (see RemoveFromString)
	set posix_path to (POSIX path of (path to me))
	set file_name to name of me as text
	
	-- removes .scpt extension and file name to leave clean directory
	set c_text to my RemoveFromString(posix_path, ".scpt")
	set d_text to my RemoveFromString(c_text, file_name)
	
	-- the target file to write too
	set this_file to file_name & ".txt"
	
	-- remove the / and replace with : (see replaceString)
	set d_text to my replaceString(d_text, "/", ":")
	set target to d_text & this_file
	my write_to_file(text_data, target, false)
end tell

-- remove items from string
on replaceString(theText, oldString, newString)
	local ASTID, theText, oldString, newString, lst
	set ASTID to AppleScript's text item delimiters
	try
		considering case
			set AppleScript's text item delimiters to oldString
			set lst to every text item of theText
			set AppleScript's text item delimiters to newString
			set theText to lst as string
		end considering
		set AppleScript's text item delimiters to ASTID
		return theText
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't replaceString: " & eMsg number eNum
	end try
end replaceString

-- contained function to clean up file path
on RemoveFromString(theText, CharOrString)
	local ASTID, theText, CharOrString, lst
	set ASTID to AppleScript's text item delimiters
	try
		considering case
			if theText does not contain CharOrString then ¬
				return theText
			set AppleScript's text item delimiters to CharOrString
			set lst to theText's text items
		end considering
		set AppleScript's text item delimiters to ASTID
		return lst as text
	on error eMsg number eNum
		set AppleScript's text item delimiters to ASTID
		error "Can't RemoveFromString: " & eMsg number eNum
	end try
end RemoveFromString

-- write file
on write_to_file(this_data, target_file, append_data)
	try
		set the target_file to the target_file as string
		set the open_target_file to open for access file target_file with write permission
		if append_data is false then set eof of the open_target_file to 0
		write this_data to the open_target_file starting at eof
		close access the open_target_file
		return true
	on error
		try
			close access file target_file
		end try
		return false
	end try
end write_to_file

```