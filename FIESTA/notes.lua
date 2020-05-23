return function(button_list)
	local tap_states= NoteSkin.single_quanta_state_map{1, 2, 3, 4, 5, 6}
	
	local bef_note= {
		DownLeft = 8,
		UpLeft = -8,
		Center = 0,
		UpRight = -8,
		DownRight = 8,
	}
	-- CM20200503: Make this independent per column.
	-- CM20200517: Done.
	local function hold_length(button)
		return {
			pixels_before_note= bef_note[button], pixels_after_note= 32,
			topcap_pixels= 0, body_pixels= 64, bottomcap_pixels=64,
		}
	end
	local function a_hold(states,button)
		return {
			state_map= states,
			textures= {button.." Hold"},
			length_data= hold_length(button),
		}
	end
	local function holds (button)
		return {	
			TapNoteSubType_Hold= {
				a_hold(tap_states,button),
				a_hold(tap_states,button),
			},
			TapNoteSubType_Roll= {
				a_hold(tap_states,button),
				a_hold(tap_states,button),
			},
		}
	end
	local columns= {}
	for i, button in ipairs(button_list) do
		columns[i]= {
			width= 64, 
			padding= -14,
			hold_gray_percent=1,
			anim_uses_beats= false,
			anim_time= 0.3,
			taps= {
				NoteSkinTapPart_Tap= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture=button.." TapNote",
					}
				},
				
				NoteSkinTapPart_Mine= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= "Mine",
					}
				},
					
				NoteSkinTapPart_Lift= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." TapNote",
					}
				},
							
			},
			optional_taps= {
				NoteSkinTapOptionalPart_HoldHead= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." TapNote",
					}
				},
				NoteSkinTapOptionalPart_RollHead= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." Roll",
					}
				},
			},
			holds= holds(button),
			reverse_holds= holds(button),
		}
	end
	return {columns= columns, vivid_operation= true}
end
