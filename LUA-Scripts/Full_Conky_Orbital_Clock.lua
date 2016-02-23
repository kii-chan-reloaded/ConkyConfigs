--[[This is a lua script for use in conky. 
This script will fit a small solar system into your conky window that can be used to tell time! The outermost planet has a 12 hour orbital period, the middle planet has a 1 hour orbital period, and the innermost planet has a 1 minute orbital period.
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
	local SunRed=256/256
	local SunGreen=192/256
	local SunBlue=0/256
	local SunAlpha=192/256
	----------------
	local HourRed=256/256
	local HourGreen=256/256
	local HourBlue=256/256
	local HourAlpha=192/256
	----------------
	local MinRed=0/256
	local MinGreen=256/256
	local MinBlue=0/256
	local MinAlpha=192/256
	----------------
	local SecRed=256/256
	local SecGreen=0/256
	local SecBlue=0/256
	local SecAlpha=192/256
	----------------
	local LineAlpha=128/256
	---------------------Celestial Body Settings
	local SunR=sm/11
	local SunPosX=w/2
	local SunPosY=h/2
	local PlanetR=sm/26
	local SecR=sm/6
	local MinR=(2/7)*sm
	local HouR=(3/7)*sm
	---------------------Time Settings
	local Hours,Mins,Secs=tonumber(os.date("%l")),tonumber(os.date("%M")),tonumber(os.date("%S"))
	---------------------Orbit Calculations
	local SecPosX=SunPosX-math.sin(-Secs/60*2*math.pi)*SecR
	local SecPosY=SunPosY-math.cos(-Secs/60*2*math.pi)*SecR
	local MinPosX=SunPosX-math.sin(-(Mins*60+Secs)/3600*2*math.pi)*MinR
	local MinPosY=SunPosY-math.cos(-(Mins*60+Secs)/3600*2*math.pi)*MinR
	local HourPosX=SunPosX-math.sin(-(Hours*60*60+Mins*60+Secs)/43200*2*math.pi)*HouR
	local HourPosY=SunPosY-math.cos(-(Hours*60*60+Mins*60+Secs)/43200*2*math.pi)*HouR
	---------------------Creating Celestial Bodies
	local StartAngleS=(math.pi+Secs/60*2*math.pi)
	local EndAngleS=(2*math.pi+Secs/60*2*math.pi)
	local StartAngleM=(math.pi+(Mins*60+Secs)/3600*2*math.pi)
	local EndAngleM=(2*math.pi+(Mins*60+Secs)/3600*2*math.pi)
	local StartAngleH=(math.pi+(Hours*60*60+Mins*60+Secs)/43200*2*math.pi)
	local EndAngleH=(2*math.pi+(Hours*60*60+Mins*60+Secs)/43200*2*math.pi)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,SunR,0,2*math.pi)
	cairo_set_source_rgba(cr,SunRed,SunGreen,SunBlue,SunAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,SecPosX,SecPosY,PlanetR,0,2*math.pi)
	cairo_set_source_rgba(cr,SecRed,SecGreen,SecBlue,SecAlpha)
	cairo_fill(cr)
	cairo_arc(cr,SecPosX,SecPosY,PlanetR,StartAngleS,EndAngleS)
	cairo_set_source_rgba(cr,0,0,0,SecAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,MinPosX,MinPosY,PlanetR,0,2*math.pi)
	cairo_set_source_rgba(cr,MinRed,MinGreen,MinBlue,MinAlpha)
	cairo_fill(cr)
	cairo_arc(cr,MinPosX,MinPosY,PlanetR,StartAngleM,EndAngleM)
	cairo_set_source_rgba(cr,0,0,0,MinAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,HourPosX,HourPosY,PlanetR,0,2*math.pi)
	cairo_set_source_rgba(cr,HourRed,HourGreen,HourBlue,HourAlpha)
	cairo_fill(cr)
	cairo_arc(cr,HourPosX,HourPosY,PlanetR,StartAngleH,EndAngleH)
	cairo_set_source_rgba(cr,0,0,0,HourAlpha)
	cairo_fill(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,SecR,0,2*math.pi)
	cairo_set_source_rgba(cr,SecRed,SecGreen,SecBlue,LineAlpha)
	cairo_stroke(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,MinR,0,2*math.pi)
	cairo_set_source_rgba(cr,MinRed,MinGreen,MinBlue,LineAlpha)
	cairo_stroke(cr)
	---------------
	cairo_arc(cr,SunPosX,SunPosY,HouR,0,2*math.pi)
	cairo_set_source_rgba(cr,HourRed,HourGreen,HourBlue,LineAlpha)
	cairo_stroke(cr)
	---------------------Finishing up
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
