-- Decompiled by Krnl

return {
	["to_base64"] = function(_, p1)
		return (p1:gsub(".", function(p2)
			local v3 = p2:byte()
			local v4 = ""
			for v5 = 8, 1, -1 do
				v4 = v4 .. (v3 % 2 ^ v5 - v3 % 2 ^ (v5 - 1) > 0 and "1" or "0")
			end
			return v4
		end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(p6)
			if #p6 < 6 then
				return ""
			end
			local v7 = 0
			for v8 = 1, 6 do
				v7 = v7 + (p6:sub(v8, v8) == "1" and (2 ^ (6 - v8) or 0) or 0)
			end
			return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(v7 + 1, v7 + 1)
		end) .. ({ "", "==", "=" })[#p1 % 3 + 1]
	end,
	["from_base64"] = function(_, p9)
		return string.gsub(p9, "[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]", ""):gsub(".", function(p10)
			if p10 == "=" then
				return ""
			end
			local v11 = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):find(p10) - 1
			local v12 = ""
			for v13 = 6, 1, -1 do
				v12 = v12 .. (v11 % 2 ^ v13 - v11 % 2 ^ (v13 - 1) > 0 and "1" or "0")
			end
			return v12
		end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(p14)
			if #p14 ~= 8 then
				return ""
			end
			local v15 = 0
			for v16 = 1, 8 do
				v15 = v15 + (p14:sub(v16, v16) == "1" and (2 ^ (8 - v16) or 0) or 0)
			end
			return string.char(v15)
		end)
	end,
	["StringToBinary"] = function(_, p17)
		local v18 = {}
		for _, v19 in ipairs(p17:split("")) do
			local v20 = v19:byte()
			local v21 = ""
			while v20 > 0 do
				local v22 = v20 % 2
				v21 = tostring(v22) .. v21
				local v23 = v20 / 2
				v20 = math.modf(v23)
			end
			local v24 = string.format
			table.insert(v18, v24("%.8d", v21))
		end
		return table.concat(v18, " ")
	end,
	["BinaryToString"] = function(_, p25)
		local v26 = ""
		for _, v27 in ipairs(p25:split(" ")) do
			local v28 = tonumber(v27, 2)
			v26 = v26 .. string.char(v28)
		end
		return v26
	end
}
