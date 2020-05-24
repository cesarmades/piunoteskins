return function(button_list)
	local tap_states= NoteSkin.single_quanta_state_map{1, 2, 3, 4, 5, 6}
	
	local bef_note= {
		DownLeft = 0,
		UpLeft = 0,
		Center = 0,
		UpRight = 0,
		DownRight = 0,
	}
	-- CM20200523: Removing bottomcap trying to fix glitch graphics.
	-- CM20200524: Success!
	local function hold_length(button)
		return {
			pixels_before_note= bef_note[button], pixels_after_note= -32,
			topcap_pixels= 0, body_pixels= 1, bottomcap_pixels=0,
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
			-- CM20200523: Removed hold head since it fallbacks to the tap note.
			optional_taps= {
				-- NoteSkinTapOptionalPart_HoldHead= {
					-- state_map= tap_states,
					-- actor= Def.Sprite{
						-- Texture= button.." TapNote",
					-- }
				-- },
				NoteSkinTapOptionalPart_HoldTail= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." Tail",
						InitCommand= function(self) self:zoom(1/1.5) end,
					},
				},
				NoteSkinTapOptionalPart_RollHead= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." Roll",
						InitCommand= function(self) self:zoom(1/1.5) end,
					},
				},
				NoteSkinTapOptionalPart_RollTail= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." Tail",
						InitCommand= function(self) self:zoom(1/1.5) end,
					},
				},
				NoteSkinTapOptionalPart_CheckpointTail= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." Tail",
						InitCommand= function(self) self:zoom(1/1.5) end,
					},
				},
			},
			holds= holds(button),
			-- CM20200524: Pending to adjust this for reverse receptor.
			reverse_holds= holds(button),
		}
	end
	return {columns= columns, vivid_operation= true}
end
