#!/usr/bin/python

from lxml import html
import requests

"""
Enter HorribleSubs's title for the shows you
watch in quotes followed by a comma, then
hit enter to add another show. When
all of your watched shows are entered, put
the ending bracket.
EX:
MYSHOWS = ["Bananya",
	"New Game",
	"Kono Bijutsubu ni wa Mondai ga Aru!",
	"Re Zero kara Hajimeru Isekai Seikatsu"]
"""

MYSHOWS = [
  ]

def makeLine(string,time,size=50):
	if string in MYSHOWS:
		string = "**" + string
	if len(string) <= 42:
		out = string
	else:
		out = string[:42]
	for i in range(45-len(out)):
		out = out + "."
	tzadj = int(time[0:2])+2
	if tzadj >= 24:
		tzadj = tzadj-24
	tzadj = str(tzadj)
	if len(tzadj) == 2:
		time = tzadj + time[2:]
	else:
		time = "0" + tzadj + time[2:]
	out = out + time
	return out

page = requests.get("http://horriblesubs.info/")
tree = html.fromstring(page.content)

show = tree.xpath('//a[@title="See all releases for this show"]/text()')
sched = tree.xpath('//td[@class="schedule-time"]/text()')

for i in range(len(show)):
	line = makeLine(show[i],sched[i])
	print line
