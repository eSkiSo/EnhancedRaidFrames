--Enhanced Raid Frames, a World of Warcraft® user interface addon.

--This file is part of Enhanced Raid Frames.
--
--Enhanced Raid Frames is free software: you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation, either version 3 of the License, or
--(at your option) any later version.
--
--Enhanced Raid Frames is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License
--along with this add-on.  If not, see <https://www.gnu.org/licenses/>.
--
--Copyright for Enhanced Raid Frames is held by Britt Yazel (aka Soyier), 2017-2020.

local _, addonTable = ... --make use of the default addon namespace
local EnhancedRaidFrames = addonTable.EnhancedRaidFrames

-------------------------------------------------------------------------
-------------------------------------------------------------------------

function EnhancedRaidFrames:UpdateNotifier()
	if not self.db.global.DB_VERSION or self.db.global.DB_VERSION < self.DATABASE_VERSION then
		self:Print("Welcome to Enhanced Raid Frames 3.0!\n"..
				"Enhanced Raid Frames has recently undergone a major overhaul and full rewrite. As part of this transition, your profiles have necessarily been reset. We apologize for any inconvenience this may cause.\n"..
				"\n"..
				"Please note, your profiles from the 2.0 series are still intact, and you may downgrade for the time being if you so choose.\n"..
				"\n"..
				"In better news, Enhanced Raid Frames has gained TONS of new features, updates, cleanups, and performance improvements! Check them out!\n"..
				"Also, we are always looking for help in the form of ideas, code, or donations. If you're interested in lending a hand, please reach out on Github!\n"..
				"\n"..
				"-Soyier"
		)

		self.db.global.DB_VERSION = self.DATABASE_VERSION
	end
end

-- Hook for the CompactUnitFrame_UpdateInRange function
function EnhancedRaidFrames:UpdateInRange(frame)
	if not frame.unit then
		return
	end

	if string.match(frame.unit, "party") or string.match(frame.unit, "raid") then
		local inRange, checkedRange

		--if we have a custom range set use LibRanchCheck, otherwise use default UnitInRange function
		if self.db.profile.customRangeCheck then
			local rangeChecker = LibStub("LibRangeCheck-2.0"):GetFriendChecker(self.db.profile.customRange)
			inRange = rangeChecker(frame.unit)
			checkedRange = not UnitIsVisible(frame.unit) or not UnitIsDeadOrGhost(frame.unit)
		else
			inRange, checkedRange = UnitInRange(frame.unit)
		end

		if checkedRange and not inRange then	--If we weren't able to check the range for some reason, we'll just treat them as in-range (for example, enemy units)
			frame:SetAlpha(self.db.profile.rangeAlpha)
		else
			frame:SetAlpha(1)
		end
	end
end

-- Set the background alpha amount to allow full transparency if need be
function EnhancedRaidFrames:UpdateBackgroundAlpha(frame)
	if not frame.unit then
		return
	end

	if string.match(frame.unit, "party") or string.match(frame.unit, "raid") or string.match(frame.unit, "player") then
		frame.background:SetAlpha(self.db.profile.backgroundAlpha)
	end
end