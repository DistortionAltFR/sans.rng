local HttpService = game:GetService("HttpService")
local WebhookService = {
	FormatEditor = { },
	Mention = { },
	ThumbnailType = {
		Headshot = "avatar-headshot",
		Bustshot = "avatar-bust",
		Avatar = "avatar"
	},
	ThumbnailSize = {
		["Size48x48"] = "48x48",
		["Size50x50"] = "50x50",
		["Size60x60"] = "60x60",
		["Size75x75"] = "75x75",
		["Size100x100"] = "100x100",
		["Size150x150"] = "150x150",
		["Size180x180"] = "180x180",
		["Size352x352"] = "352x352",
		["Size420x420"] = "420x420",
		["Size720x720"] = "720x720",
	},
	SupportedThumbnailAsync = function(UserID, ThumbnailType, ThumbnailSize, Circular)
		local ThumbnailURL =  "https://thumbnails.roproxy.com/v1/users/"..ThumbnailType.."?userIds="..UserID.."&size="..ThumbnailSize.."&format=Png&isCircular="..tostring(Circular or false)
		local Response = HttpService:GetAsync(ThumbnailURL)
		local JSONResponce = HttpService:JSONDecode(Response)
		
		return JSONResponce.data[1].imageUrl
	end,
}
WebhookService.__index = WebhookService

local function ErrorHandler(HandleType, Value, Type)
	if HandleType == "Variable" then
		assert(Value, "Missing Argument ("..Type.." expected)")
		
		if typeof(Value) ~= Type then error("Invalid Argument ("..Type.." expected)") end
	end
end

local function SendRequest(url, data)
	local InfoReq = HttpService:RequestAsync({
		Url = url,
		Method = "POST",
		Body = data,
		Headers = {
			["Content-Type"] = "application/json"
		}
	})

	if InfoReq.StatusCode == 204 then 
		return true, 204, nil 
	end

	local body = InfoReq.Body

	if not InfoReq.Success then
		if InfoReq.StatusCode == 500 then
			if WebhookService.ErrorPrinting then
				warn("Webhook instance encountered an internal error.")
			end
			return true, 204, nil
		else
			return false, InfoReq.StatusCode, body.error
		end
	end

	return true, InfoReq.StatusCode, body
end

local function CheckStatusCode(statusCode, body, url, ErrorPrinting)
	if statusCode == 403 then
		if body.message == "IP Has Been Banned" then
			if ErrorPrinting then
				warn("This Roblox Server IP Has Been Temporarily Banned Due To Abuse.")
			end
			return "Error Found"
		elseif body.message == "Webhook Has Been Blocked" then
			if ErrorPrinting then
				warn(body.reason)
			end
			return "Error Found"
		else
			return nil
		end
	end

	if statusCode == 429 then
		if ErrorPrinting then
			warn("Hit ratelimit.")
		end	
		return "Error Found"
	elseif statusCode == 404 then
		if ErrorPrinting then	
			warn("Provided Webhook Is Not Valid.")
		end
		return "Error Found"
	elseif statusCode == 400 and not url then
		if ErrorPrinting then		
			warn("Error Occured: " .. body.message)
		end
		return "Error Found"
	else
		return nil
	end
end

local function HandleRequest(url, data, PrintErr)
	local ProxyURL = string.gsub(url, "discord.com", "hooks.hyra.io")
	local BackupProxyURL = string.gsub(url, "discord.com", "webhook.newstargeted.com")
	local LastProxyURL = string.gsub(url, "discord.com", "webhook.lewisakura.moe")

	local success, statusCode, body = SendRequest(url, data)

	if not success then
		if PrintErr then warn("Webhook request failed. Trying backup proxy") end
		success, statusCode, body = SendRequest(BackupProxyURL, data)
		
		if not success then
			if PrintErr then warn("Backup request failed. Trying last backup proxy") end
			success, statusCode, body = SendRequest(LastProxyURL, data)
			
			if not success then
				if PrintErr then warn("Last backup request failed.") end
				
				local ProcessedStatus = CheckStatusCode(statusCode, body)
				if ProcessedStatus == nil then
					if PrintErr then warn("Most likely error or all proxys are down") end
				end
			end
		end
	end	
end

function WebhookService.ColorConverter(color)
	local r = math.floor(color.R * 255 + 0.5)
	local g = math.floor(color.G * 255 + 0.5)
	local b = math.floor(color.B * 255 + 0.5)
	return (r * 65536) + (g * 256) + b
end

WebhookService.Setup = function(UrlTable, ErrPrint)
	local MessageTable = { }
	local Metatable = {
		Urls = UrlTable,
		ErrorPrinting = ErrPrint
	}
	
	function Metatable.CreateMessage()
		local MessageData = { }
		local EmbedTable = { }
		
		function MessageData:AttachMessage(txt)
			ErrorHandler("Variable", txt, "string")
			
			MessageData.Content = txt
		end
		
		function MessageData:AttachEmbed(DataTable)
			ErrorHandler("Variable", DataTable, "table")
			ErrorHandler("Variable", DataTable.Settings, "table")
			ErrorHandler("Variable", DataTable.Embed, "table")

			self.Embed = {
				Info = {
					Settings = {},
					Embed = {}
				}
			}

			for setting, value in pairs(DataTable.Settings) do
				self.Embed.Info.Settings[setting] = value
			end

			for property, value in pairs(DataTable.Embed) do
				self.Embed.Info.Embed[property] = value
			end

			function self.Embed:Modify(ModifiedData)
				ErrorHandler("Variable", ModifiedData, "table")
				ErrorHandler("Variable", ModifiedData.Settings, "table")
				ErrorHandler("Variable", ModifiedData.Embed, "table")

				for setting, value in pairs(ModifiedData.Settings) do
					self.Info.Settings[setting] = value
				end

				for property, value in pairs(ModifiedData.Embed) do
					self.Info.Embed[property] = value
				end
			end

			return setmetatable(self.Embed, EmbedTable)
		end
		
		function MessageData:Send()
			local content = self.Content or ""
			local embed = self.Embed or nil
			
			local requestBody = {
				content = content,
				embeds = {},
			}
			
			if embed ~= nil then
				requestBody.embeds[1] = {
					title = embed.Info.Embed.Title or "No Title Provided",
					description = embed.Info.Embed.Description or "",
					type = embed.Info.Settings.Type or "rich",
					color = embed.Info.Settings.Color or "",
					fields = embed.Info.Embed.Fields or nil,
					image = {
						url = embed.Info.Embed.Image or "",
					},
					thumbnail = {
						url = embed.Info.Embed.Thumbnail or "",
					},
					timestamp = os.date("!%Y-%m-%dT%H:%M:%S", os.time(embed.Info.Embed.TimeStamp)) or "",
					footer = {
						text = embed.Info.Embed.Footer or "",
						icon_url = embed.Info.Embed.FooterIcon or "",
					}
				}
			end
			
			for i, url in ipairs(Metatable.Urls) do
				HandleRequest(url, HttpService:JSONEncode(requestBody))
			end
		end
		
		return setmetatable(MessageData, MessageTable)
	end
	
	function Metatable:SetErrorPrinting(Val)
		self.ErrorPrinting = Val
	end
	
	function Metatable:ModifyURLS(NewURLData)
		ErrorHandler("Variable", NewURLData, "table")
		
		self.Urls = NewURLData
	end
	
	return setmetatable(Metatable, WebhookService)
end

----------- Format Editor -----------------------

WebhookService.FormatEditor.Italic = function(txt)
	return "*"..txt.."*"
end

WebhookService.FormatEditor.Bold = function(txt)
	return "**"..txt.."**"
end

WebhookService.FormatEditor.Underline = function(txt)
	return "__"..txt.."__"
end

WebhookService.FormatEditor.Strikethrough = function(txt)
	return "~~"..txt.."~~"
end

WebhookService.FormatEditor.Codeblock = function(txt, syntax)
	syntax = syntax or ""
	
	return "```"..syntax.."\n"..txt.."\n```"
end

WebhookService.FormatEditor.Spoiler = function(txt)
	return "||"..txt.."||"
end

WebhookService.FormatEditor.Url = function(url, txt)
	return "["..txt.."]("..url..")"
end

WebhookService.FormatEditor.Blockquote = function(txt)
	return "> "..txt
end

----------- Mentions -----------------------
WebhookService.Mention.User = function(id)
	return "<@"..id..">"
end

WebhookService.Mention.Role = function(id)
	return "<@&"..id..">"
end

WebhookService.Mention.Channel = function(id)
	return "<#"..id..">"
end

WebhookService.Mention.Everyone = function()
	return "@everyone"
end

WebhookService.Mention.Here = function()
	return "@here"
end

return WebhookService
