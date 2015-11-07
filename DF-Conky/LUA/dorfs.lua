--[[This is a lua script for use in conky. 

You will need to add the following to your .conkyrc before the TEXT section:
	lua_load $HOME/.config/conky/LUA/dorfs.lua   (or wherever you put your luas)
	lua_draw_hook_pre conky_dorfs
I am not even close to being a programmer. It couldn't have been done without the help of the wonderful guide on the #! forums.
	http://crunchbang.org/forums/viewtopic.php?id=17246
]]
require 'cairo'

function conky_dorfs()
	if conky_window == nil then return end
	w=conky_window.width
	h=conky_window.height
	local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr = cairo_create(cs)
	local updates=tonumber(conky_parse('${updates}'))
	if w<h then
		sm=w
	else
		sm=h
	end
	if updates>1 then --update tick counter
		---------------------Settings
		local number_of_dorfs=6
		local tile_size=sm/10		---number of pixels per "square", also size of dorfs
		---------------------Calculations
		local GridX=math.floor(w/tile_size)
		local GridY=math.floor(h/tile_size)
		if updates==2 then
			GridPosX={}
			GridPosY={}
			dorf={}
			for i=1, number_of_dorfs do
				dorf[i]={}
				GridPosX[i]=GridX/2
				GridPosY[i]=GridY/2
				for j=1,4 do
					if j==4 then
						dorf[i][j]=1 -----Sets alpha
					else
						dorf[i][j]=math.random()
					end
				end
			end
		end
		---------------------Draw Dorfs
		for i=1, number_of_dorfs do
			deltaX=math.random(-1,1)
			if deltaX<=-0.5 then
				deltaX=-1
			else
				if deltaX>=0.5 then
					deltaX=1
				else
					deltaX=0
				end
			end
			deltaY=math.random(-1,1)
			if deltaY<=-0.5 then
				deltaY=-1
			else
				if deltaY>=0.5 then
					deltaY=1
				else
					deltaY=0
				end
			end
			GridPosX[i]=GridPosX[i]+deltaX
			GridPosY[i]=GridPosY[i]+deltaY
			if GridPosX[i]>GridX then
				GridPosX[i]=GridX
			else
				if GridPosX[i]<0 then
					GridPosX[i]=0
				end
			end
			if GridPosY[i]>GridY then
				GridPosY[i]=GridY
			else
				if GridPosY[i]<1 then
					GridPosY[i]=1
				end
			end
			PosX=GridPosX[i]*tile_size
			PosY=GridPosY[i]*tile_size
			cairo_select_font_face(cr,"dwarffortressvan",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
			cairo_set_font_size(cr,tile_size)
			cairo_set_source_rgba(cr,dorf[i][1],dorf[i][2],dorf[i][3],dorf[i][4])
			cairo_move_to(cr,PosX,PosY)
			cairo_show_text(cr,'®')
			cairo_stroke(cr)
		end
	---------------------Finishing up
	else
		cairo_select_font_face(cr,"dwarffortressvan",CAIRO_FONT_SLANT_NORMAL,CAIRO_FONT_WEIGHT_NORMAL)
		cairo_set_font_size(cr,18)
		cairo_set_source_rgba(cr,0,0,0,1)
		cairo_move_to(cr,0,h/2)
		cairo_show_text(cr,'Preparing for embark...')
		cairo_stroke(cr)
	end --update tick counter
	cairo_destroy(cr)
	cairo_surface_destroy(cs)
	cr=nil
end-- end main function
