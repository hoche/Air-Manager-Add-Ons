-- Select whether this unit is in position 1 or two.  If you need two GTN650s clone this instrument, rename it, and change the variable 

gps_no = user_prop_add_enum("Selected GPS unit","GPS 1,GPS 2","GPS 1","Select GPS Unit to control")
local g_unit = fif(user_prop_get(gps_no)=="GPS 1", 1 , 2 )

if instrument_prop("PLATFORM") == "RASPBERRY_PI" or instrument_prop("PLATFORM") == "ANDROID" or instrument_prop("PLATFORM") == "IPAD" then
    canvas_add(125, 35, 573, 438, function()
        _rect(0,0,573,438)
        _fill("black")
    end)
    canv_message = canvas_add(125, 35, 573, 438, function()
        _rect(0,0,573,438)
        _fill("red")
        _txt("THIS X-PLANE 11 GPS OVERLAY", "font:roboto_bold.ttf; size:30; color: white; halign:center;", 286, 162)
        _txt("WORKS ON THE DESKTOP ONLY", "font:roboto_bold.ttf; size:30; color: white; halign:center;", 286, 190)
        _txt("BUTTONS AND DIALS STILL WORK", "font:roboto_bold.ttf; size:30; color: white; halign:center;", 286, 218)
        _txt("CLICK HERE TO HIDE THIS MESSAGE", "font:roboto_bold.ttf; size:30; color: white; halign:center;", 286, 246)
    end)
    butn_hide = button_add(nil, nil, 125, 35, 573, 438, function()
        visible(canv_message, false)
        visible(butn_hide, false)
    end)
end

img_add_fullscreen("background.png")

-- g2_flag = img_add( "gps_2.png", 132,260,45,44)
-- visible(g2_flag, g_unit == 2 )
click_snd = sound_add("knobclick.wav")


function home_click()
    if g_unit==1 then 
		xpl_command("RXP/GTN/HOME_1")
	elseif g_unit ==  2 then
		xpl_command("RXP/GTN/HOME_2")
	end

    sound_play(click_snd)
end

button_add( nil,"home_but.png", 765,25,55,35, home_click)


function direct_click()
    if g_unit==1 then
		xpl_command("RXP/GTN/DTO_1")
	elseif g_unit ==  2 then
		xpl_command("RXP/GTN/DTO_2")
	end

    sound_play(click_snd)
end

button_add(nil,"direct_but.png", 765,125,55,40, direct_click)


function dial_coarse(direction)
    if direction == 1 then
        if g_unit==1 then
			xpl_command( "RXP/GTN/FMS_OUTER_CW_1")
		elseif g_unit ==  2 then
			xpl_command( "RXP/GTN/FMS_OUTER_CW_2")
        end
    elseif direction== -1 then
        if g_unit==1 then
			xpl_command( "RXP/GTN/FMS_OUTER_CCW_1")
		elseif g_unit ==  2 then
			xpl_command( "RXP/GTN/FMS_OUTER_CCW_2")
        end
    end
end

local knob_rot = 6
coarse_knob = dial_add( "fms_outer.png", 735,250,110,110, dial_coarse)
dial_click_rotate(coarse_knob,knob_rot)
touch_setting(coarse_knob , "ROTATE_TICK", 30)

function dial_fine(direction)
    if direction == 1 then
        if g_unit==1 then
			xpl_command( "RXP/GTN/FMS_INNER_CW_1")
		elseif g_unit ==  2 then
			xpl_command( "RXP/GTN/FMS_INNER_CW_2")
        end
    elseif direction== -1 then
        if g_unit==1 then
			xpl_command( "RXP/GTN/FMS_INNER_CCW_1")
		elseif g_unit ==  2 then
			xpl_command( "RXP/GTN/FMS_INNER_CCW_2")
        end
    end
end

fine_knob = dial_add( "fms_inner.png", 760,275,60,60, dial_fine)
dial_click_rotate(fine_knob,knob_rot)
touch_setting(fine_knob , "ROTATE_TICK", 30)

--- dial_add( nil,750,700,32,32, nil)


function click_fms()
	if g_unit==1 then
		xpl_command( "RXP/GTN/FMS_PUSH_1")
	elseif g_unit ==  2 then
		xpl_command( "RXP/GTN/FMS_PUSH_2")
	end
    sound_play(click_snd)
end

button_add(  nil,nil, 780,295,20,20, click_fms)



function pwr_chg( on_1, on_2)
    if g_unit==1 then pwr_on = on_1  elseif g_unit ==  2 then pwr_on = on_2  end
    switch_set_state( pwr_sw , pwr_on )
end
xpl_dataref_subscribe("sim/cockpit2/radios/actuators/gps_power", "INT", "sim/cockpit2/radios/actuators/gps2_power", "INT", pwr_chg)