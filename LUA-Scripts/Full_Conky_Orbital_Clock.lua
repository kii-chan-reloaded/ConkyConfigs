--[[This is a lua script for use in conky. 
This script will fit a small solar system into your conky window that can be used to tell time! The outermost planet has a 1 day orbital period, the middle planet has a 1 hour orbital period, and the innermost planet has a 1 minute orbital period.
(In other words, outermost is the hour hand, then minute hand, then second hand. Just guesstimate where the numbers should be)
You will need to add the following to your .conkyrc before the TEXT section:
	lua_load $HOME/.config/conky/LUA/Full_Conky_Orbital_Clock.lua   (or wherever you put your luas)
	lua_draw_hook_pre conky_OrbitalClock
I am not a programmer, nor am I close to being one. It couldn't have been done without the help of the wonderful guide on the #! forums.
	http://crunchbang.org/forums/viewtopic.php?id=17246
]]
require 'cairo'

function conky_OrbitalClock()
	if conky_window == nil then return end
	w=conky_window.width
	h=conky_window.height
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr = cairo_create(cs)
	if w<h then
		sm=w
	else
		sm=h
	end
	---------------------Color Settings
	SunRed=256/256
	SunGreen=0/256
	SunBlue=192/256
	SunAlpha=192/256
	----------------
	HourRed=256/256
	HourGreen=256/256
	HourBlue=256/256
	HourAlpha=192/256
	----------------
	MinRed=0/256
	MinGreen=256/256
	MinBlue=0/256
	MinAlpha=192/256
	----------------
	SecRed=256/256
	SecGreen=0/256
	SecBlue=0/256
	SecAlpha=192/256
	----------------
	LineAlpha=128/256
	---------------------Celestial Body Settings
	SunR=sm/11
	SunPosX=w/2
	SunPosY=h/2
	PlanetR=sm/26
	SecR=sm/6
	MinR=(2/7)*sm
	HouR=(3/7)*sm
	---------------------Time Settings
	Hours,Mins,Secs=tonumber(os.date("%k")),tonumber(os.date("%M")),tonumber(os.date("%S"))
	---------------------Orbit Calculations
	SecPosX=SunPosX-math.sin(-Secs/60*2*math.pi)*SecR
	SecPosY=SunPosY-math.cos(-Secs/60*2*math.pi)*SecR
	MinPosX=SunPosX-math.sin(-(Mins*60+Secs)/3600*2*math.pi)*MinR
	MinPosY=SunPosY-math.cos(-(Mins*60+Secs)/3600*2*math.pi)*MinR
	HourPosX=SunPosX-math.sin(-(Hours*60*60+Mins*60+Secs)/86400*2*math.pi)*HouR
	HourPosY=SunPosY-math.cos(-(Hours*60*60+Mins*60+Secs)/86400*2*math.pi)*HouR
	---------------------Creating Celestial Bodies
	StartAngle=(0)
	EndAngle=(2*math.pi)
	cairo_arc(cr,SunPosX,SunPosY,SunR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,SunRed,SunBlue,SunGreen,SunAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,SecPosX,SecPosY,PlanetR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,SecRed,SecBlue,SecGreen,SecAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,MinPosX,MinPosY,PlanetR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,MinRed,MinBlue,MinGreen,MinAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,HourPosX,HourPosY,PlanetR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,HourRed,HourBlue,HourGreen,HourAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,SecR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,SecRed,SecBlue,SecGreen,LineAlpha)
	cairo_stroke(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,MinR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,MinRed,MinBlue,MinGreen,LineAlpha)
	cairo_stroke(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,HouR,StartAngle,EndAngle)
	cairo_set_source_rgba(cr,HourRed,HourBlue,HourGreen,LineAlpha)
	cairo_stroke(cr)
	---------------------Finishing up
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
