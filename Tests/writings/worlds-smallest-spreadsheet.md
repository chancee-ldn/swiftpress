title: Worlds smallest spreadsheet
date: 30/05/2018
excerpt: The long quest to keep expenses
tags: Freelance
lang: English
link: 


I'm tragic at keeping cash expenses, the original shoebox of receipts I add up once a year is plainly not efficient. So, I present The Worlds Smallest Spreadsheet™:
  
```
Transaction,Date,Total,Notes
TFL,08/05/2017,7.10,Travel to Victoria
TFL,09/05/2017,7.10,Travel to Kings Cross
TFL,25/05/2018,7.20,Travel to London Bridge
The Bull,25/05/2018,24.80,Lunch with Agent
The Bohemia,26/05/2018,39.05,Drinks with Directors
```
  
  
Save that as a CSV, then to get a total run this:
  
```
awk -F',' '{sum+=$3} END {print sum}' May-2018.csv
```
  
  
Once I've done a few months I'll write a script to run though the months and create a tally. I'm happy, the accountant is happy, and the shoebox can go in the bin.
Before you @ me, no, I don't wanna run Numbers or a spreadsheet app, I nearly always have [BBEdit](https://www.barebones.com/products/bbedit/) open to massage copy/type, and I can access a text editor on my phone via dropbox. Sorted.