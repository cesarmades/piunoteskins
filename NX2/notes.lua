local skin_name = Var("skin_name");
return function(button_list, stepstype, skin_parameters)
	local tap_states= NoteSkin.single_quanta_state_map{1, 2, 3, 4, 5, 6}
	-
	local routine_states = {
		parts_per_beat = 48,
		quanta = {
			{per_beat = 1, states = {1, 2, 3, 4, 5, 6}}, -- P1
			{per_beat = 2, states = {7, 8, 9, 10, 11, 12}}, -- P2
			{per_beat = 3, states = {13, 14, 15, 16, 17, 18}}, -- P3
			{per_beat = 4, states = {19, 20, 21, 22, 23, 24}}, -- P4
		},
	}
	
	local bef_note= {
		DownLeft = 0,
		UpLeft = 0,
		Center = 0,
		UpRight = 0,
		DownRight = 0,
	}
	-- CM20200523: Removing bottomcap trying to fix glitch graphics.
	-- CM20200524: Success!
	-- CM20200524: Glitches are still an issue, I will resize graphics to 
	-------------- see if it helps.
	-- CM20200524: It worked, the problem was 'pixels_after_note'.
	-- CM20200524: When hold is not long enough it draws the tail at the
	-------------- back of the tapnote, it looks ugly...
	local function hold_length(button)
		return {
			pixels_before_note= bef_note[button], pixels_after_note= 0,
			topcap_pixels= 0, body_pixels= 2, bottomcap_pixels=0,
		}
	end
	local function a_hold(states,button,flip_mode)
		return {
			state_map= states,
			textures= {button.." Hold"},
			length_data= hold_length(button),
			flip= flip_mode,
		}
	end
	local function holds (button,flip_mode)
		return {	
			TapNoteSubType_Hold= {
				a_hold(tap_states,button,flip_mode),
				a_hold(tap_states,button,flip_mode),
			},
			TapNoteSubType_Roll= {
				a_hold(tap_states,button,flip_mode),
				a_hold(tap_states,button,flip_mode),
			},
		}
	end
	local columns= {}
	for i, button in ipairs(button_list) do
		local column_state = tap_states;
		local tap_tex = button.." TapNote";

		if GAMEMAN:stepstype_is_multiplayer(stepstype) then
			column_state = routine_states;
			tap_tex = "Routine/"..button.." TapNote"
		end
		
		columns[i]= {
			width= 64, 
			padding= -14,
			hold_gray_percent=1,
			anim_uses_beats= false,
			anim_time= 0.3,
			taps= {
			-- CM20200524: Adding zoom commands to remove filename tags.
			-- CM20200524: Adding routine taps.
				NoteSkinTapPart_Tap= {
					state_map= column_state,
					actor= Def.Sprite{
						Texture= tap_tex,
						InitCommand= function(self) self:zoom(1/1.5) end,
					}
				},
				
				NoteSkinTapPart_Mine= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= "Mine",
						InitCommand= function(self) self:zoom(1/1.5) end,
					}
				},
				
				-- CM20200524: This needs a nice graphic.
				NoteSkinTapPart_Lift= {
					state_map= tap_states,
					actor= Def.Sprite{
						Texture= button.." TapNote",
						InitCommand= function(self) self:zoom(1/1.5) end,
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
			holds= holds(button,"TexCoordFlipMode_None"),
			-- CM20200524: Pending to adjust this for reverse receptor.
			-- CM20200524: Done, but tails needs to load a different
			-------------- graphic when reverse.
			reverse_holds= holds(button,"TexCoordFlipMode_X"),
		}
	end
	return {columns= columns, vivid_operation= true}
end
