--[[This is a lua script for use in conky. 
It will create a binary clock behind the full space of whatever conky it's loaded into.
You will need to add the following to your .conkyrc before the TEXT section:
	lua_load $HOME/.config/conky/LUA/Full_Conky_Binary_Clock.lua   (or wherever you put your luas)
	lua_draw_hook_pre conky_FCBC
This is my very first lua script! It couldn't have been done without the help of the wonderful guide on the #! forums.
	http://crunchbang.org/forums/viewtopic.php?id=17246
]]
require 'cairo'

function conky_FCBC()
	if conky_window == nil then return end
	w=conky_window.width
	h=conky_window.height
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr = cairo_create(cs)
	---------------------Color Settings
	red=128/256
	green=128/256		--replace the first number with it's RGBA value
	blue=128/256		--default = 128,128,128,192
	alpha=192/256
	---------------------Box Settings
	boxw=w/4		--desired box width, default to w/4 for an even distribution with w/16 spacing between boxes
	boxh=h/7		--desired box height, default to h/7 for an even distribution with h/49 spacing between boxes
	XH=(1/16)*w		--X-position of the hour slot boxes
	XM=(2/16)*w+(1)*boxw	--X-position of the minute slot boxes
	XS=(3/16)*w+(2)*boxw	--X-position of the second slot boxes
	Y32=(1/49)*h		--Y-position of the 32 slot boxes
	Y16=(2/49)*h+(1)*boxh	--Y-position of the 16 slot boxes
	Y8=(3/49)*h+(2)*boxh	--Y-position of the 8 slot boxes
	Y4=(4/49)*h+(3)*boxh	--Y-position of the 4 slot boxes
	Y2=(5/49)*h+(4)*boxh	--Y-position of the 2 slot boxes
	Y1=(6/49)*h+(5)*boxh	--Y-position of the 1 slot boxes
	---------------------Time Setting
	Hours,Mins,Secs=tonumber(os.date("%k")),tonumber(os.date("%M")),tonumber(os.date("%S"))
	---------------------Creating boxes
	-----------------------------------Hour boxes
	if Hours - 16 >= 0 then
		cairo_rectangle(cr,XH,Y16,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		HDet = Hours - 16
	else
		HDet = Hours
	end
	if HDet - 8 >= 0 then
		cairo_rectangle(cr,XH,Y8,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		HDet = HDet - 8
	end
	if HDet - 4 >= 0 then
		cairo_rectangle(cr,XH,Y4,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		HDet = HDet - 4
	end
	if HDet - 2 >= 0 then
		cairo_rectangle(cr,XH,Y2,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		HDet = HDet - 2
	end
	if HDet - 1 >=0 then
		cairo_rectangle(cr,XH,Y1,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
	end
	-----------------------------------Minute Boxes
	if Mins - 32 >= 0 then
		cairo_rectangle(cr,XM,Y32,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		MDet = Mins - 32
	else
		MDet = Mins
	end
	if MDet - 16 >=0 then
		cairo_rectangle(cr,XM,Y16,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		MDet = MDet - 16
	end
	if MDet - 8 >=0 then
		cairo_rectangle(cr,XM,Y8,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		MDet = MDet - 8
	end
	if MDet - 4 >=0 then
		cairo_rectangle(cr,XM,Y4,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		MDet = MDet - 4
	end
	if MDet - 2 >=0 then
		cairo_rectangle(cr,XM,Y2,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		MDet = MDet - 2
	end
	if MDet - 1 >=0 then
		cairo_rectangle(cr,XM,Y1,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
	end
	-----------------------------------Second Boxes
	if Secs - 32 >= 0 then
		cairo_rectangle(cr,XS,Y32,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		SDet = Secs - 32
	else
		SDet = Secs
	end
	if SDet - 16 >= 0 then
		cairo_rectangle(cr,XS,Y16,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		SDet = SDet - 16
	end
	if SDet - 8 >= 0 then
		cairo_rectangle(cr,XS,Y8,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		SDet = SDet - 8
	end
	if SDet - 4 >= 0 then
		cairo_rectangle(cr,XS,Y4,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		SDet = SDet - 4
	end
	if SDet - 2 >= 0 then
		cairo_rectangle(cr,XS,Y2,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
		SDet = SDet - 2
	end
	if SDet - 1 >= 0 then
		cairo_rectangle(cr,XS,Y1,boxw,boxh)
		cairo_set_source_rgba(cr,red,green,blue,alpha)
		cairo_fill(cr)
	end
	---------------------Finishing up
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
