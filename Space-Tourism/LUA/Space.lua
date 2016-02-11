--this is a lua script for use in conky
require 'cairo'

function AutoColor(a)
	red=a[1]
	green=a[2]
	blue=a[3]
end

function correction(a)
	local size=string.len(a)
	if string.byte(a,size)==71 then
		reform=string.char(string.byte(a,1,size-1))*1024
	elseif string.byte(a,size)==75 then
		reform=string.char(string.byte(a,1,size-1))/1024
	else
		reform=string.char(string.byte(a,1,size-1))
	end
	return reform
end

function conky_Space()
	if conky_window == nil then return end
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, 	conky_window.height)
	cr = cairo_create(cs)
	local updates=tonumber(conky_parse('${updates}'))
	if updates>2 then
	--##############################
	--------------------------------Variables
		-----Conky numbers
		local cpu=tonumber(conky_parse('${cpu cpu0}'))
		local bat=tonumber(conky_parse('${battery_percent}'))
		local ram=correction(conky_parse('${mem}'))
		local swp=correction(conky_parse('${swap}'))
		local dsk=correction(conky_parse('${fs_used /}'))
		local rammax=correction(conky_parse('${memmax}'))
		local swpmax=correction(conky_parse('${swapmax}'))
		local dskmax=correction(conky_parse('${fs_size /}'))
		-----Colors
		local white={240/256,240/256,240/256}
		local black={21/256,20/256,26/256}
		local Sblu={2/256,162/256,173/256}
		local purple={117/256,28/256,88/256}
		local teal={0,105/256,63/256}
		local lime={138/256,190/256,64/256}
		local Nred={197/256,33/256,50/256}
		local yeller={250/256,166/256,49/256}
	--------------------------------Drawing
		for i=1,4 do
			radius=i*20
			AutoColor(Sblu)
			cairo_set_source_rgba(cr,red,green,blue,0.6)
			cairo_move_to(cr,80,180)
			cairo_line_to(cr,80,100)
			cairo_arc(cr,80,180,radius,-math.pi/2,math.pi/6)
			cairo_close_path(cr)
			cairo_fill(cr)
			AutoColor(purple)
			cairo_move_to(cr,80,180)
			cairo_set_source_rgba(cr,red,green,blue,0.6)
			cairo_line_to(cr,80,100)
			cairo_arc_negative(cr,80,180,radius,-math.pi/2,5*math.pi/6)
			cairo_close_path(cr)
			cairo_fill(cr)
			AutoColor(lime)
			cairo_move_to(cr,80,180)
			cairo_set_source_rgba(cr,red,green,blue,0.6)
			cairo_line_to(cr,80+80*math.sin(math.pi/3),180+80*math.cos(math.pi/3))
			cairo_arc(cr,80,180,radius,math.pi/6,5*math.pi/6)
			cairo_close_path(cr)
			cairo_fill(cr)
			AutoColor(yeller)
			cairo_set_source_rgba(cr,red,green,blue,0.6)
			cairo_arc(cr,170,340,radius,-math.pi/2,math.pi/2)
			cairo_fill(cr)
			AutoColor(black)
			cairo_set_source_rgba(cr,red,green,blue,0.6)
			cairo_arc_negative(cr,170,340,radius,-math.pi/2,math.pi/2)
			cairo_fill(cr)
		end
		AutoColor(lime)
		cairo_set_source_rgba(cr,red,green,blue,1)
		cairo_move_to(cr,80,180)
		cairo_line_to(cr,80,100)
		cairo_arc(cr,80,180,swp/swpmax*80,-math.pi/2,math.pi/6)
		cairo_close_path(cr)
		cairo_fill(cr)
		AutoColor(Sblu)
		cairo_move_to(cr,80,180)
		cairo_set_source_rgba(cr,red,green,blue,1)
		cairo_line_to(cr,80,100)
		cairo_arc_negative(cr,80,180,ram/rammax*80,-math.pi/2,5*math.pi/6)
		cairo_close_path(cr)
		cairo_fill(cr)
		AutoColor(purple)
		cairo_move_to(cr,80,180)
		cairo_set_source_rgba(cr,red,green,blue,1)
		cairo_line_to(cr,80+80*math.sin(math.pi/3),180+80*math.cos(math.pi/3))
		cairo_arc(cr,80,180,dsk/dskmax*80,math.pi/6,5*math.pi/6)
		cairo_close_path(cr)
		cairo_fill(cr)
		AutoColor(Nred)
		cairo_set_source_rgba(cr,red,green,blue,.5)
		cairo_arc(cr,170,340,cpu/100*80,-math.pi/2,math.pi/2)
		cairo_fill(cr)
		AutoColor(white)
		cairo_set_source_rgba(cr,red,green,blue,.5)
		cairo_arc_negative(cr,170,340,bat/100*80,-math.pi/2,math.pi/2)
		cairo_fill(cr)
		--------------------------Planet Clock
		local totalsec=tonumber(os.date("%H"))*60*60+tonumber(os.date("%M"))*60+tonumber(os.date("%S"))
		local clockR=50
		AutoColor(black)
		cairo_set_source_rgba(cr,red,green,blue,.5)
		if totalsec==0 then
			cairo_arc(cr,210,210,clockR,0,2*math.pi)
			cairo_fill(cr)
		elseif totalsec<=12*60*60 then
			cairo_move_to(cr,210,160)
			cairo_curve_to(cr,143,160,143,260,210,260)
			cairo_move_to(cr,210,260)
			cairo_curve_to(cr,277-134*totalsec/(12*60*60),260,277-134*totalsec/(12*60*60),160,210,160)
			cairo_fill(cr)
		elseif totalsec<=24*60*60 then
			cairo_move_to(cr,210,160)
			cairo_curve_to(cr,277,160,277,260,210,260)
			cairo_move_to(cr,210,260)
			cairo_curve_to(cr,277-134*(totalsec-12*60*60)/(12*60*60),260,277-134*(totalsec-12*60*60)/(12*60*60),160,210,160)
			cairo_fill(cr)
		end
	--##############################
	end -- if updates>3
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
