return function(button_list, stepstype, skin_parameters)
	local ret= {}
	
	local tap_press= {
		DownLeft= 5,
		UpLeft= 6,
		Center= 7,
		UpRight= 8,
		DownRight= 9
	}
	
	-- CM20200503: I need to find a way to avoid tap press to appear when
	-------------- taps are getting a score.
	-- CM20200503: Done.
	
	for i, button in ipairs(button_list) do
		if button == "Center" then
			ret[i]= Def.ActorFrame{
				Def.Sprite{
					Texture= "Center Receptor",
					InitCommand= function(self) self:animate(false):setstate(0):basezoom(1/1.5) end,
				},
				Def.Sprite{
					Texture= "Center Receptor",
					InitCommand= function(self) self:animate(false):setstate(1):basezoom(1/1.5):blend("BlendMode_Add"):effectclock("beat"):diffuseramp() end,
				},
				Def.Sprite{
					Texture= "Tap",
					InitCommand= function(self) self:draworder(notefield_draw_order.explosion):addy(-1):visible(false):animate(false):setstate(tap_press[button]):basezoom(1/1.5) end,
					
					ColumnJudgmentCommand= function(self, param)
						self.tap_note_score = param.tap_note_score
					end,
					
					BeatUpdateCommand= function(self, param)
						if param.pressed then
							if self.tap_note_score then
								self:stoptweening():visible(false)
							elseif self.tap_note_score == nil then
								self:stoptweening():visible(true):diffusealpha(1):zoom(0.85):linear(0.25):zoom(1.1):diffusealpha(0)
							end
						elseif param.lifted then
							self.tap_note_score = nil
						end
					end
				},
			}
		else
			ret[i]= Def.Sprite{
				Texture= "Tap",
				InitCommand= function(self) self:draworder(notefield_draw_order.explosion):addy(-1):visible(false):animate(false):setstate(tap_press[button]):basezoom(1/1.5) end,
				
				ColumnJudgmentCommand= function(self, param)
					self.tap_note_score = param.tap_note_score
				end,
				
				BeatUpdateCommand= function(self, param)
					if param.pressed then
						if self.tap_note_score then
							self:stoptweening():visible(false)
						elseif self.tap_note_score == nil then
							self:stoptweening():visible(true):diffusealpha(1):zoom(0.85):linear(0.25):zoom(1.1):diffusealpha(0)
						end
					elseif param.lifted then
						self.tap_note_score = nil
					end
				end
			}
		end
	end
	
	return ret
end
