--[[This is a lua script for use in conky. 

You will need to add the following to your .conkyrc before the TEXT section:
	lua_load $HOME/.config/conky/LUA/Full_Conky_Smile_Battery_Gauge.lua   (or wherever you put your luas)
	lua_draw_hook_pre conky_SmileBattery
I am not even close to being a programmer. It couldn't have been done without the help of the wonderful guide on the #! forums.
	http://crunchbang.org/forums/viewtopic.php?id=17246
]]
require 'cairo'

function conky_SmileBattery()
	if conky_window == nil then return end
	w=conky_window.width
	h=conky_window.height
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr = cairo_create(cs)
	if w<h then
		BoxS=w
	else
		BoxS=h
	end
	------------------------------------------------------Settings
	Batt=1-tonumber(conky_parse('${battery_percent}'))/100
	Line_Thickness=10
	---------------------Color Settings
	Battery_Full_Red=0/256
	Battery_Full_Green=256/256
	Battery_Full_Blue=0/256
	Battery_Empty_Red=256/256
	Battery_Empty_Green=0/256
	Battery_Empty_Blue=0/256
	alpha=256/256
	---------------------Color Calculations
	DeltaR=Battery_Full_Red-Battery_Empty_Red
	DeltaG=Battery_Full_Green-Battery_Empty_Green
	DeltaB=Battery_Full_Blue-Battery_Empty_Blue
	red=Battery_Full_Red-(Batt*DeltaR)
	green=Battery_Full_Green-(Batt*DeltaG)
	blue=Battery_Full_Blue-(Batt*DeltaB)
	---------------------Circle Settings
	Radius=BoxS/2-Line_Thickness
	PosX=w/2
	PosY=h/2
	PosIRX=PosX-BoxS/5
	PosILX=PosX+BoxS/5
	PosIY=PosY-BoxS/6
	EyeSize=BoxS/12
	SAngle=0
	EAngle=2*math.pi
	---------------------Mouth Settings
	MouthR=Radius-w/6
	if Batt<=.50 then
		MouthStart=Batt*math.pi
		MouthEnd=math.pi-(Batt*math.pi)
		PosMY=PosY+BoxS/16-Batt*MouthR
	else
		MouthStart=(3*math.pi/2)-(math.pi)*(Batt-.5)
		MouthEnd=(3*math.pi/2)+(math.pi)*(Batt-.5)
		PosMY=PosY+BoxS/2-Batt*MouthR
	end
	---------------------Draw
	cairo_arc(cr,PosX,PosY,Radius,SAngle,EAngle)
	cairo_set_source_rgba(cr,red,green,blue,alpha)
	cairo_set_line_width(cr,Line_Thickness)
	cairo_stroke(cr)
	cairo_arc(cr,PosIRX,PosIY,EyeSize,SAngle,EAngle)
	cairo_set_source_rgba(cr,red,green,blue,alpha)
	cairo_fill(cr)
	cairo_stroke(cr)
	cairo_arc(cr,PosILX,PosIY,EyeSize,SAngle,EAngle)
	cairo_set_source_rgba(cr,red,green,blue,alpha)
	cairo_fill(cr)
	cairo_arc(cr,PosX,PosMY,MouthR,MouthStart,MouthEnd)
	cairo_set_source_rgba(cr,red,green,blue,alpha)
	cairo_fill(cr)
	---------------------Finishing up
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
