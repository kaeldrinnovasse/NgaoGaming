local Library = (function()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local sharedEnvironment = getgenv and getgenv() or _G

local colors = {
	Background = Color3.fromRGB(37, 37, 34),
	Card = Color3.fromRGB(47, 47, 43),
	Hover = Color3.fromRGB(58, 58, 54),
	Pressed = Color3.fromRGB(68, 68, 63),
	Text = Color3.fromRGB(244, 240, 232),
	Dim = Color3.fromRGB(168, 164, 156),
	Accent = Color3.fromRGB(76, 194, 255),
	Error = Color3.fromRGB(214, 106, 94),
}

local textFont = Enum.Font.BuilderSansMedium
local boldFont = Enum.Font.BuilderSansBold
local windowWidth = 580
local windowHeight = 340
local navigationWidth = 150
local titleBarHeight = 40

local iconFontPath = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
local regularIconFont = Font.new(iconFontPath)
local boldIconFont = Font.new(iconFontPath, Enum.FontWeight.Bold)

local mouseButtonInput = Enum.UserInputType.MouseButton1
local touchInput = Enum.UserInputType.Touch
local mouseMoveInput = Enum.UserInputType.MouseMovement
local keyboardInput = Enum.UserInputType.Keyboard

local defaultTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local keyPattern = "^NGAO%-[A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9]%-[A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9]$"
local serverVerdicts = {"Bad Request", "Wrong Key", "Wrong Hub", "Wrong Device", "Key Expired"}
local gracePeriodSeconds = 72 * 60 * 60
local keyedState = nil

local Library = {Flags = {}, Log = nil :: any}

local function createInstance(className, properties, children)
	local instance = Instance.new(className)

	for property, value in properties do
		if property ~= "Parent" then
			instance[property] = value
		end
	end

	for _, child in children or {} do
		child.Parent = instance
	end

	instance.Parent = properties.Parent
	return instance
end

local function createCorner(radius)
	return createInstance("UICorner", {CornerRadius = UDim.new(0, radius)})
end

local function createStroke(transparency, color)
	return createInstance("UIStroke", {
		Color = color or colors.Text,
		Transparency = transparency,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function createPadding(left, right, top, bottom)
	return createInstance("UIPadding", {
		PaddingLeft = UDim.new(0, left),
		PaddingRight = UDim.new(0, right or left),
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
	})
end

local function createListLayout(gap)
	return createInstance("UIListLayout", {Padding = UDim.new(0, gap), SortOrder = Enum.SortOrder.LayoutOrder})
end

local function tween(instance, properties, duration)
	local tweenInfo = defaultTweenInfo

	if duration then
		tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end

	TweenService:Create(instance, tweenInfo, properties):Play()
end

local function applyProperties(instance, properties, shouldAnimate)
	if shouldAnimate then
		tween(instance, properties)
		return
	end

	for property, value in properties do
		instance[property] = value
	end
end

local function mergeProperties(defaults, overrides)
	for property, value in overrides do
		defaults[property] = value
	end

	return defaults
end

local function createLabel(properties, children)
	local defaults = {
		BackgroundTransparency = 1,
		Font = textFont,
		TextColor3 = colors.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = "",
	}

	return createInstance("TextLabel", mergeProperties(defaults, properties), children)
end

local function createIcon(properties, children)
	local defaults = {
		BackgroundTransparency = 1,
		FontFace = regularIconFont,
		TextColor3 = colors.Text,
		TextSize = 16,
		Text = "",
	}

	return createInstance("TextLabel", mergeProperties(defaults, properties), children)
end

local function createButton(properties, children)
	local defaults = {
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
	}

	return createInstance("TextButton", mergeProperties(defaults, properties), children)
end

local function bindHoverColors(button, getBaseColor)
	button.MouseEnter:Connect(function()
		if UserInputService.MouseEnabled then
			tween(button, {BackgroundColor3 = colors.Hover})
		end
	end)

	button.MouseLeave:Connect(function()
		tween(button, {BackgroundColor3 = getBaseColor()})
	end)

	button.MouseButton1Down:Connect(function()
		tween(button, {BackgroundColor3 = colors.Pressed}, 0.05)
	end)

	button.MouseButton1Up:Connect(function()
		if UserInputService.MouseEnabled then
			tween(button, {BackgroundColor3 = colors.Hover})
		else
			tween(button, {BackgroundColor3 = getBaseColor()})
		end
	end)
end

local function createScreenGui()
	local screenGui = createInstance("ScreenGui", {
		Name = HttpService:GenerateGUID(false),
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 999,
	})

	local parented = pcall(function()
		screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
	end)

	if not parented then
		screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	return screenGui
end

local function fitToScreen(screenGui, frame, uiScale, width, height)
	local screenSize = screenGui.AbsoluteSize
	local topInset = GuiService:GetGuiInset().Y
	local widthScale = (screenSize.X - 24) / width
	local heightScale = (screenSize.Y - topInset - 24) / height
	local scale = math.clamp(math.min(widthScale, heightScale), 0.5, 1)

	uiScale.Scale = scale
	frame.Position = UDim2.fromOffset(screenSize.X / 2, topInset + (screenSize.Y - topInset) / 2)

	return scale
end

local function isValidConfigName(name)
	if name == nil then
		return true
	end

	if type(name) ~= "string" or name == "" then
		return false
	end

	for segment in (name .. "/"):gmatch("([^/]*)/") do
		if not segment:match("^[%w _%-]+$") then
			return false
		end
	end

	return true
end

local function ensureParentFolders(path)
	local folder = ""

	for segment in path:gmatch("([^/]+)/") do
		if folder == "" then
			folder = segment
		else
			folder = folder .. "/" .. segment
		end

		if not isfolder(folder) then
			makefolder(folder)
		end
	end
end

local function openDiscordInvite(link)
	local inviteCode = link:match("([%w%-_]+)/?%s*$")
	if not inviteCode then
		return
	end

	local body = HttpService:JSONEncode({
		cmd = "INVITE_BROWSER",
		nonce = HttpService:GenerateGUID(false),
		args = {code = inviteCode},
	})

	for port = 6463, 6472 do
		local succeeded, response = pcall(request, {
			Url = `http://127.0.0.1:{port}/rpc?v=1`,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json", Origin = "https://discord.com"},
			Body = body,
		})

		if succeeded and type(response) == "table" and response.StatusCode == 200 then
			return
		end
	end
end

local function computeDigest(text)
	local high = 0xcbf29ce4
	local low = 0x84222325

	for index = 1, #text do
		low = bit32.bxor(low, string.byte(text, index))
		local product = low * 435
		high = (high * 435 + product // 4294967296 + bit32.lshift(low, 8)) % 4294967296
		low = product % 4294967296
	end

	return string.format("%08x%08x", high, low)
end

Library.Digest = computeDigest

local function isUsableDeviceId(value)
	if type(value) ~= "string" then
		return false
	end

	local compactId = value:gsub("[ %-]", "")
	if #compactId < 16 then
		return false
	end

	local seenCharacters = {}
	local distinctCount = 0

	for character in compactId:lower():gmatch(".") do
		if not seenCharacters[character] then
			seenCharacters[character] = true
			distinctCount += 1
		end
	end

	return distinctCount >= 4
end

local function readRawDeviceId()
	for _, functionName in {"gethwid", "get_hwid"} do
		local readHardwareId = sharedEnvironment[functionName]

		if type(readHardwareId) == "function" then
			local succeeded, hardwareId = pcall(readHardwareId)

			if succeeded and isUsableDeviceId(hardwareId) then
				return hardwareId
			end
		end
	end

	local clientIdRead, clientId = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)

	if clientIdRead and isUsableDeviceId(clientId) then
		return clientId
	end

	local userIdRead, userId = pcall(function()
		return Players.LocalPlayer.UserId
	end)

	if userIdRead and type(userId) == "number" then
		return "U" .. userId
	end

	return nil
end

local function readDeviceDigest()
	local rawId = nil
	local isDone = false

	task.spawn(function()
		local succeeded, result = pcall(readRawDeviceId)
		rawId = succeeded and result or nil
		isDone = true
	end)

	while not isDone do
		task.wait()
	end

	return rawId and computeDigest(rawId)
end

function Library.Http(url)
	local requestFunction = sharedEnvironment.request
		or sharedEnvironment.http_request
		or (type(sharedEnvironment.http) == "table" and sharedEnvironment.http.request)

	if type(requestFunction) == "function" then
		local succeeded, response = pcall(requestFunction, {Url = url, Method = "GET"})

		if succeeded and type(response) == "table" and response.StatusCode == 200 and type(response.Body) == "string" then
			return response.Body
		end
	end

	local fetched, body = pcall(function()
		return game:HttpGet(url, true)
	end)

	return fetched and type(body) == "string" and body or nil
end

local function askKeyServer(options, key, digest)
	local hubQuery = HttpService:UrlEncode(options.Hub)
	local keyQuery = HttpService:UrlEncode(key)
	local digestQuery = HttpService:UrlEncode(digest)
	local url = `{options.Server}/api/check?h={hubQuery}&k={keyQuery}&d={digestQuery}&n={HttpService:GenerateGUID(false)}`

	local answer = nil
	local isDone = false

	task.spawn(function()
		local fetched, body = pcall(Library.Http, url)

		if fetched and type(body) == "string" then
			local decoded, json = pcall(function()
				return HttpService:JSONDecode(body)
			end)

			if decoded then
				answer = json
			end
		end

		isDone = true
	end)

	local startedAt = os.clock()
	while not isDone and os.clock() - startedAt < 10 do
		task.wait()
	end

	if not isDone or type(answer) ~= "table" then
		return nil
	end

	if answer.ok == true and type(answer.ex) == "number" then
		return {true, answer.ex}
	end

	if answer.ok == false and table.find(serverVerdicts, answer.err) then
		return {false, answer.err}
	end

	return nil
end

local function readSavedServerKey(path)
	if not (isfile and isfile(path)) then
		return nil
	end

	local readSucceeded, contents = pcall(readfile, path)
	if not (readSucceeded and type(contents) == "string") then
		return nil
	end

	local key, expiry = contents:match("^%s*(%S+)%s*\n%s*(%d+)%s*$")
	if key and key:match(keyPattern) then
		return key, tonumber(expiry)
	end

	return nil
end

local function isWithinGracePeriod(expiry)
	local succeeded, now = pcall(function()
		return workspace:GetServerTimeNow()
	end)

	if not succeeded or type(now) ~= "number" or type(expiry) ~= "number" then
		return false
	end

	return now < expiry and expiry <= now + gracePeriodSeconds
end

local function readMaxLength(value)
	if value == nil then
		return 24
	end

	return tonumber(value)
end

local function claimGateToken()
	local token = {}
	local previousToken = sharedEnvironment.__AvG

	sharedEnvironment.__AvG = token

	if type(previousToken) == "table" and previousToken.sg then
		pcall(function()
			previousToken.sg:Destroy()
		end)
	end

	return token
end

local function createGateCard(options, showsGetKey)
	local screenGui = createScreenGui()
	Library.GateGui = screenGui

	createButton({
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.new(),
		BackgroundTransparency = 0.5,
		Parent = screenGui,
	})

	local cardFrame = createInstance("Frame", {
		Size = UDim2.fromOffset(300, 180),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = colors.Background,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = screenGui,
	}, {createCorner(12), createStroke(0.85), createPadding(20, 20, 20, 20)})

	local cardScale = createInstance("UIScale", {Parent = cardFrame})
	fitToScreen(screenGui, cardFrame, cardScale, 300, 180)

	local card = {}
	card.screenGui = screenGui
	card.sizeConnection = screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		fitToScreen(screenGui, cardFrame, cardScale, 300, 180)
	end)

	screenGui.Destroying:Connect(function()
		card.sizeConnection:Disconnect()

		if Library.GateGui == screenGui then
			Library.GateGui = nil
		end
	end)

	createLabel({
		Text = tostring(options.Title or "Avenoric"),
		Font = boldFont,
		TextSize = 16,
		Size = UDim2.new(1, 0, 0, 20),
		Parent = cardFrame,
	})

	createLabel({
		Text = "Enter your key to continue",
		TextSize = 13,
		TextColor3 = colors.Dim,
		Position = UDim2.fromOffset(0, 22),
		Size = UDim2.new(1, 0, 0, 16),
		Parent = cardFrame,
	})

	local keyBoxFrame = createInstance("Frame", {
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = colors.Card,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = cardFrame,
	}, {createCorner(6), createStroke(0.9)})

	local keyBoxStroke = keyBoxFrame:FindFirstChildOfClass("UIStroke")

	card.keyBox = createInstance("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -24, 1, 0),
		Font = textFont,
		TextSize = 14,
		TextColor3 = colors.Text,
		PlaceholderText = "Key",
		PlaceholderColor3 = colors.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Text = "",
		Parent = keyBoxFrame,
	})

	card.messageLabel = createLabel({
		Text = "",
		TextSize = 12,
		TextColor3 = colors.Error,
		Position = UDim2.fromOffset(0, 86),
		Size = UDim2.new(1, 0, 0, 16),
		Visible = false,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = cardFrame,
	})

	local submitSize = UDim2.new(1, 0, 0, 32)
	if showsGetKey then
		submitSize = UDim2.new(0.5, -4, 0, 32)
	end

	card.submitButton = createButton({
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = submitSize,
		BackgroundColor3 = colors.Accent,
		BackgroundTransparency = 0,
		Font = boldFont,
		TextSize = 13,
		TextColor3 = colors.Background,
		Text = "Submit",
		Parent = cardFrame,
	}, {createCorner(6)})

	if showsGetKey then
		card.getKeyButton = createButton({
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(0.5, -4, 0, 32),
			BackgroundColor3 = colors.Card,
			BackgroundTransparency = 0,
			Font = textFont,
			TextSize = 13,
			TextColor3 = colors.Text,
			Text = "Get Key",
			Parent = cardFrame,
		}, {createCorner(6), createStroke(0.9)})

		bindHoverColors(card.getKeyButton, function()
			return colors.Card
		end)
	end

	card.keyBox.Focused:Connect(function()
		tween(keyBoxStroke, {Color = colors.Accent, Transparency = 0})
	end)

	card.keyBox.FocusLost:Connect(function()
		tween(keyBoxStroke, {Color = colors.Text, Transparency = 0.9})
	end)

	function card.showMessage(text, color)
		card.messageLabel.Text = text
		card.messageLabel.TextColor3 = color or colors.Error
		card.messageLabel.Visible = true
	end

	function card.close()
		card.sizeConnection:Disconnect()
		card.screenGui:Destroy()

		if Library.GateGui == card.screenGui then
			Library.GateGui = nil
		end
	end

	return card
end

local function runServerGate(options)
	local server = options.Server
	local hub = options.Hub

	if type(server) ~= "string" or not server:match("^https://[%w%.%-]+$") then
		error("Gate Failed: Bad Server", 0)
	end

	if type(hub) ~= "string" or not hub:match("^[a-z]+$") then
		error("Gate Failed: Bad Hub", 0)
	end

	if options.Link ~= nil then
		error("Gate Failed: Link And Server", 0)
	end

	if options.Config == nil then
		error("Gate Failed: No Config", 0)
	end

	if not isValidConfigName(options.Config) then
		error("Gate Failed: Bad Config", 0)
	end

	local maxLength = readMaxLength(options.Max)
	if not (maxLength and maxLength >= 1) then
		error("Gate Failed: Bad Max", 0)
	end

	local digest = readDeviceDigest()
	if not digest then
		error("Gate Failed: No Device Id", 0)
	end

	local token = claimGateToken()
	local keyPath = `Avenoric/Keys/{options.Config}.txt`
	local keyLink = `{server}/k/{hub}?d={digest}`
	local savedKey, savedExpiry = readSavedServerKey(keyPath)

	local card = nil
	local isLocked = false
	local isBusy = false
	local acceptedKey = nil

	local function acceptKey(key, expiry, shouldSave)
		if shouldSave then
			pcall(function()
				ensureParentFolders(keyPath)
				writefile(keyPath, key .. "\n" .. expiry)
			end)
		end

		keyedState = {path = keyPath, checkAfter = os.clock() + 30, isValid = true}
	end

	local function finish()
		if card then
			card.close()
		end

		if sharedEnvironment.__AvG == token then
			token.sg = nil
		end
	end

	local function isAlive()
		return sharedEnvironment.__AvG == token and (not card or card.screenGui.Parent ~= nil)
	end

	local function assertAlive()
		if isAlive() then
			return
		end

		local reason = "Closed"
		if sharedEnvironment.__AvG ~= token then
			reason = "Replaced"
		end

		finish()
		error("Gate Failed: " .. reason, 0)
	end

	local function describeVerdict(verdict)
		if verdict == "Bad Request" then
			return "Key Check Failed: Bad Request"
		end

		return verdict
	end

	local function submit()
		if isBusy or isLocked or not card or not isAlive() then
			return
		end

		local trimmedText = card.keyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
		local key = trimmedText:upper()

		if key == "" then
			card.showMessage("Enter A Key")
			return
		end

		if not key:match(keyPattern) then
			card.showMessage("Wrong Key")
			return
		end

		isBusy = true
		card.submitButton.Text = "Checking..."
		local verdict = askKeyServer(options, key, digest)
		isBusy = false

		if not isAlive() then
			return
		end

		card.submitButton.Text = "Submit"

		if not verdict then
			card.showMessage("Key Server Unreachable")
			return
		end

		if not verdict[1] then
			card.showMessage(describeVerdict(verdict[2]))
			return
		end

		acceptKey(key, verdict[2], true)

		if options.Discord and request then
			task.spawn(openDiscordInvite, tostring(options.Discord))
		end

		acceptedKey = key
	end

	local function copyKeyLink()
		for _, functionName in {"setclipboard", "toclipboard"} do
			local copyToClipboard = sharedEnvironment[functionName]

			if type(copyToClipboard) == "function" and pcall(copyToClipboard, keyLink) then
				card.showMessage("Link Copied", colors.Dim)
				return
			end
		end

		card.keyBox.Text = keyLink
		card.showMessage("Copy The Link From The Box", colors.Dim)
	end

	local function showCard()
		if card then
			return
		end

		card = createGateCard(options, true)
		token.sg = card.screenGui

		card.keyBox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = card.keyBox.Text

			if text ~= keyLink and #text > maxLength then
				card.keyBox.Text = text:sub(1, maxLength)
			end
		end)

		card.keyBox.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				submit()
			end
		end)

		card.submitButton.Activated:Connect(submit)
		card.getKeyButton.Activated:Connect(copyKeyLink)
	end

	if savedKey then
		local verdict = nil
		local isAnswered = false

		task.spawn(function()
			verdict = askKeyServer(options, savedKey, digest)
			isAnswered = true
		end)

		local startedAt = os.clock()
		while not isAnswered do
			assertAlive()

			if not card and sharedEnvironment.__AvG == token and os.clock() - startedAt >= 2 then
				showCard()
				isLocked = true
				card.submitButton.TextTransparency = 0.5
				card.showMessage("Checking Key...", colors.Dim)
			end

			task.wait()
		end

		isLocked = false
		assertAlive()

		if card then
			card.submitButton.TextTransparency = 0
		end

		if verdict and verdict[1] then
			acceptKey(savedKey, verdict[2], true)
			finish()
			return savedKey
		end

		if verdict then
			showCard()
			card.showMessage(describeVerdict(verdict[2]))
		elseif isWithinGracePeriod(savedExpiry) then
			acceptKey(savedKey, savedExpiry, false)
			finish()
			return savedKey
		else
			showCard()
			card.showMessage("Key Server Unreachable")
		end
	else
		showCard()
	end

	repeat
		task.wait()
	until acceptedKey ~= nil or not isAlive()

	assertAlive()
	finish()

	return acceptedKey
end

function Library:Gate(options)
	options = options or {}

	if options.Server ~= nil then
		if options.Check ~= nil then
			error("Gate Failed: Check And Server", 0)
		end

		return runServerGate(options)
	end

	if type(options.Check) ~= "function" then
		error("Gate Failed: No Check", 0)
	end

	if not isValidConfigName(options.Config) then
		error("Gate Failed: Bad Config", 0)
	end

	local maxLength = readMaxLength(options.Max)
	if not (maxLength and maxLength >= 1) then
		error("Gate Failed: Bad Max", 0)
	end

	local token = claimGateToken()

	local keyPath = nil
	if options.Config then
		keyPath = `Avenoric/Keys/{options.Config}.txt`
	end

	if keyPath and isfile and isfile(keyPath) then
		local readSucceeded, savedKey = pcall(readfile, keyPath)

		if readSucceeded and type(savedKey) == "string" and savedKey ~= "" then
			local checkSucceeded, passed = pcall(options.Check, savedKey)

			if sharedEnvironment.__AvG ~= token then
				error("Gate Failed: Replaced", 0)
			end

			if checkSucceeded and passed == true then
				return savedKey
			end
		end
	end

	local card = createGateCard(options, options.Link)
	local isBusy = false
	local acceptedKey = nil

	token.sg = card.screenGui

	local function isAlive()
		return sharedEnvironment.__AvG == token and card.screenGui.Parent ~= nil
	end

	card.keyBox:GetPropertyChangedSignal("Text"):Connect(function()
		local text = card.keyBox.Text

		if #text > maxLength then
			card.keyBox.Text = text:sub(1, maxLength)
		end
	end)

	local function submit()
		if isBusy or not isAlive() then
			return
		end

		local key = card.keyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

		if key == "" then
			card.showMessage("Enter A Key")
			return
		end

		isBusy = true
		card.submitButton.Text = "Checking..."
		local checkSucceeded, passed, message = pcall(options.Check, key)
		isBusy = false

		if not isAlive() then
			return
		end

		card.submitButton.Text = "Submit"

		if not checkSucceeded then
			card.showMessage("Key Check Failed: " .. tostring(passed))
			return
		end

		if passed ~= true then
			card.showMessage(message and tostring(message) or "Wrong Key")
			return
		end

		if keyPath then
			pcall(function()
				ensureParentFolders(keyPath)
				writefile(keyPath, key)
			end)
		end

		if options.Discord and request then
			task.spawn(openDiscordInvite, tostring(options.Discord))
		end

		acceptedKey = key
	end

	card.keyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			submit()
		end
	end)

	card.submitButton.Activated:Connect(submit)

	if card.getKeyButton then
		card.getKeyButton.Activated:Connect(function()
			if setclipboard then
				setclipboard(tostring(options.Link))
			end

			card.showMessage("Link Copied", colors.Dim)
		end)
	end

	repeat
		task.wait()
	until acceptedKey ~= nil or not isAlive()

	local failure = nil
	if not isAlive() then
		failure = "Closed"

		if sharedEnvironment.__AvG ~= token then
			failure = "Replaced"
		end
	end

	card.close()

	if sharedEnvironment.__AvG == token then
		token.sg = nil
	end

	if failure then
		error("Gate Failed: " .. failure, 0)
	end

	return acceptedKey
end

function Library:Keyed()
	if not keyedState then
		return false
	end

	if os.clock() < keyedState.checkAfter then
		return keyedState.isValid
	end

	local readSucceeded, contents = pcall(readfile, keyedState.path)
	local isValid = false

	if readSucceeded and type(contents) == "string" then
		local firstLine = contents:match("^[^\n]*") or ""
		local trimmedLine = firstLine:match("^%s*(.-)%s*$") or ""
		isValid = trimmedLine:match(keyPattern) ~= nil
	end

	keyedState.isValid = isValid
	keyedState.checkAfter = os.clock() + 30

	return keyedState.isValid
end

local function normalizeKeyCode(value)
	if value == nil then
		return nil
	end

	if typeof(value) == "EnumItem" and value.EnumType == Enum.KeyCode then
		return value
	end

	return false
end

function Library:Window(options)
	options = options or {}

	if not isValidConfigName(options.Config) then
		error("Window Failed: Bad Config", 0)
	end

	if sharedEnvironment.__AvW then
		pcall(sharedEnvironment.__AvW.Destroy, sharedEnvironment.__AvW)
	end

	local toggleKey = options.Key
	if toggleKey == nil then
		toggleKey = Enum.KeyCode.LeftControl
	end

	local window: any = {
		Tabs = {},
		Current = nil,
		connections = {},
		toggleKey = toggleKey,
		isSearching = false,
		lastSearchText = "",
		isWaitingForKey = false,
		closeFlyout = nil,
		fittedScale = 1,
		refreshFades = nil,
		width = windowWidth,
		height = windowHeight,
	}

	local screenGui = createScreenGui()
	window.Gui = screenGui

	local mainFrame = createInstance("Frame", {
		Name = "Main",
		Size = UDim2.fromOffset(windowWidth, windowHeight),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = colors.Background,
		BorderSizePixel = 0,
		Parent = screenGui,
	}, {createCorner(12), createStroke(0.85)})

	window.Main = mainFrame

	local windowScale = createInstance("UIScale", {Parent = mainFrame})

	local titleBar = createInstance("Frame", {
		Size = UDim2.new(1, 0, 0, titleBarHeight),
		BackgroundTransparency = 1,
		Parent = mainFrame,
	})

	createLabel({
		Text = tostring(options.Title or "Avenoric"),
		Font = boldFont,
		Position = UDim2.fromOffset(16, 0),
		Size = UDim2.new(1, -116, 1, 0),
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = titleBar,
	})

	local function createCaptionButton(offsetX, glyph)
		local button = createButton({
			Size = UDim2.fromOffset(40, 28),
			Position = UDim2.new(1, offsetX, 0, 6),
			BackgroundColor3 = colors.Hover,
			Parent = titleBar,
		}, {createCorner(6)})

		local icon = createIcon({
			Text = glyph,
			TextSize = 14,
			TextColor3 = colors.Dim,
			Size = UDim2.fromScale(1, 1),
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = button,
		})

		button.MouseEnter:Connect(function()
			if UserInputService.MouseEnabled then
				tween(button, {BackgroundTransparency = 0})
			end
		end)

		button.MouseLeave:Connect(function()
			tween(button, {BackgroundTransparency = 1})
		end)

		return button, icon
	end

	local closeButton, closeIcon = createCaptionButton(-46, "x")
	local minimizeButton = createCaptionButton(-88, "minus")

	local toastStack = createInstance("Frame", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -12, 1, -12),
		Size = UDim2.fromOffset(300, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 100,
		Parent = screenGui,
	}, {createListLayout(8)})

	function window:Notify(notification)
		notification = notification or {}

		if notification.Title == nil and notification.Text == nil then
			error("Notify Failed: No Text", 0)
		end

		local duration = notification.Time
		if duration == nil then
			duration = 4
		end

		if type(duration) ~= "number" or duration ~= duration or duration <= 0 then
			error("Notify Failed: Bad Time", 0)
		end

		local barColor = colors.Accent
		if notification.Error then
			barColor = colors.Error
		end

		local toast = createInstance("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = colors.Card,
			BorderSizePixel = 0,
			ZIndex = 100,
			Parent = toastStack,
		}, {createCorner(8), createStroke(0.9), createPadding(18, 14, 10, 10)})

		createInstance("Frame", {
			Position = UDim2.fromOffset(-12, 2),
			Size = UDim2.new(0, 3, 1, -4),
			BackgroundColor3 = barColor,
			BorderSizePixel = 0,
			ZIndex = 101,
			Parent = toast,
		}, {createCorner(2)})

		local content = createInstance("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 101,
			Parent = toast,
		}, {createListLayout(2)})

		createLabel({
			Text = tostring(notification.Title or "Avenoric"),
			Font = boldFont,
			Size = UDim2.new(1, 0, 0, 18),
			TextTruncate = Enum.TextTruncate.AtEnd,
			ZIndex = 102,
			LayoutOrder = 1,
			Parent = content,
		})

		if notification.Text ~= nil then
			createLabel({
				Text = tostring(notification.Text),
				TextSize = 13,
				TextColor3 = colors.Dim,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				ZIndex = 102,
				LayoutOrder = 2,
				Parent = content,
			})
		end

		task.delay(duration, function()
			if toast.Parent then
				toast:Destroy()
			end
		end)

		return toast
	end

	local function runCallback(callback, ...)
		if not callback then
			return
		end

		local succeeded, failure = xpcall(callback, function(message)
			return debug.traceback(tostring(message), 2)
		end, ...)
		if succeeded then
			return
		end

		local report = tostring(failure)
		warn("Callback Failed: " .. report)

		if Library.Log then
			pcall(Library.Log, "[Hub] Callback Failed: " .. report)
		end

		window:Notify({Title = "Callback Failed", Text = string.match(report, "^[^\n]*") or report, Error = true})
	end

	local configPath = nil
	if options.Config then
		configPath = `Avenoric/Configs/{options.Config}.json`
	end

	local configData = {}
	local isConfigDirty = false
	local isSaveScheduled = false
	local isDestroyed = false

	if configPath and isfile and isfile(configPath) then
		local decoded, data = pcall(function()
			return HttpService:JSONDecode(readfile(configPath))
		end)

		if decoded and type(data) == "table" then
			configData = data
		else
			pcall(function()
				writefile(configPath .. ".bad", readfile(configPath))
				delfile(configPath)
			end)

			window:Notify({Title = "Config Load Failed", Text = "Invalid Json", Error = true})
		end
	end

	local function saveConfig()
		if not configPath or not isConfigDirty then
			return
		end

		isConfigDirty = false

		pcall(function()
			ensureParentFolders(configPath)
			writefile(configPath, HttpService:JSONEncode(configData))
		end)
	end

	local function storeFlagValue(element, value)
		if not element.Flag then
			return
		end

		Library.Flags[element.Flag] = value

		if not configPath then
			return
		end

		if element.saveValue then
			configData[element.Flag] = element.saveValue(value)
		else
			configData[element.Flag] = value
		end

		isConfigDirty = true

		if isSaveScheduled or isDestroyed then
			return
		end

		isSaveScheduled = true

		task.delay(0.5, function()
			isSaveScheduled = false
			saveConfig()
		end)
	end

	local function loadSavedValue(element)
		if not element.Flag then
			return
		end

		Library.Flags[element.Flag] = element:Get()

		local savedValue = configData[element.Flag]
		if savedValue == nil then
			return
		end

		pcall(function()
			if element.loadValue then
				savedValue = element.loadValue(savedValue)
			end

			element:Set(savedValue)
		end)
	end

	local navigation = createInstance("Frame", {
		Position = UDim2.fromOffset(12, titleBarHeight + 4),
		Size = UDim2.new(0, navigationWidth, 1, -(titleBarHeight + 16)),
		BackgroundTransparency = 1,
		Parent = mainFrame,
	})

	local searchFrame = createInstance("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = colors.Card,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = navigation,
	}, {createCorner(6), createStroke(0.9)})

	local searchStroke = searchFrame:FindFirstChildOfClass("UIStroke")

	createIcon({
		Text = "magnifying-glass",
		TextSize = 14,
		TextColor3 = colors.Dim,
		Position = UDim2.fromOffset(9, 0),
		Size = UDim2.fromOffset(16, 32),
		Parent = searchFrame,
	})

	local searchBox = createInstance("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(30, 0),
		Size = UDim2.new(1, -36, 1, 0),
		Font = textFont,
		TextSize = 13,
		TextColor3 = colors.Text,
		PlaceholderText = "Search",
		PlaceholderColor3 = colors.Dim,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		Text = "",
		Parent = searchFrame,
	})

	searchBox.Focused:Connect(function()
		tween(searchStroke, {Color = colors.Accent, Transparency = 0})
	end)

	searchBox.FocusLost:Connect(function()
		tween(searchStroke, {Color = colors.Text, Transparency = 0.9})
	end)

	local tabList = createInstance("ScrollingFrame", {
		Position = UDim2.fromOffset(0, 40),
		Size = UDim2.new(1, 0, 1, -40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Parent = navigation,
	}, {createListLayout(4)})

	local pageContainer = createInstance("Frame", {
		Position = UDim2.fromOffset(navigationWidth + 20, titleBarHeight + 4),
		Size = UDim2.new(1, -(navigationWidth + 32), 1, -(titleBarHeight + 16)),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = mainFrame,
	})

	local function createPage()
		local page = createInstance("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 0,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			Visible = false,
			Parent = pageContainer,
		}, {createListLayout(4), createPadding(2, 2, 2, 4)})

		for _, property in {"CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize"} do
			page:GetPropertyChangedSignal(property):Connect(function()
				window.refreshFades()
			end)
		end

		return page
	end

	local function createVirtualList(scrollingFrame, rowHeight, rowGap, createListRow, bottomPadding)
		local items = {}
		local rows = {}

		local layout = scrollingFrame:FindFirstChildOfClass("UIListLayout")
		if layout then
			layout:Destroy()
		end

		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None

		local function redraw()
			if not scrollingFrame.Parent then
				return
			end

			local scale = math.max(windowScale.Scale, 0.001)
			local scaledRowHeight = scale * rowHeight
			local firstIndex = math.clamp(math.floor(scrollingFrame.CanvasPosition.Y / scaledRowHeight), 1, math.max(1, #items))
			local rowsThatFit = math.ceil(scrollingFrame.AbsoluteWindowSize.Y / scaledRowHeight) + 3
			local visibleCount = math.max(0, math.min(#items - firstIndex + 1, rowsThatFit))

			for slot = 1, visibleCount do
				local row = rows[slot]

				if not row then
					row = createListRow()
					rows[slot] = row
				end

				local itemIndex = firstIndex + slot - 1
				row.button.Position = UDim2.fromOffset(0, (itemIndex - 1) * rowHeight)
				row.button.LayoutOrder = itemIndex
				row.button.Visible = true
				row.bind(items[itemIndex])
			end

			for slot = visibleCount + 1, #rows do
				rows[slot].button.Visible = false
				rows[slot].bind(nil)
			end
		end

		scrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(redraw)
		scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(redraw)

		local scaleConnection = windowScale:GetPropertyChangedSignal("Scale"):Connect(redraw)

		scrollingFrame.Destroying:Connect(function()
			scaleConnection:Disconnect()
			table.clear(rows)
			items = {}
		end)

		local function setItems(list)
			items = list
			scrollingFrame.CanvasSize = UDim2.fromOffset(0, math.max(0, #items * rowHeight - rowGap) + (bottomPadding or 0))
			redraw()
		end

		return setItems, redraw
	end

	local searchPage = createPage()

	local function createFade(isTop)
		local position = UDim2.new(0, 0, 1, -20)
		local gradient = NumberSequence.new(1, 0)

		if isTop then
			position = UDim2.new()
			gradient = NumberSequence.new(0, 1)
		end

		local fade = createInstance("Frame", {
			Size = UDim2.new(1, 0, 0, 20),
			Position = position,
			BackgroundColor3 = colors.Background,
			BorderSizePixel = 0,
			ZIndex = 5,
			Visible = false,
			Parent = pageContainer,
		})

		createInstance("UIGradient", {Rotation = 90, Transparency = gradient, Parent = fade})

		return fade
	end

	local topFade = createFade(true)
	local bottomFade = createFade(false)

	local function refreshFades()
		local page = nil

		if window.isSearching then
			page = searchPage
		elseif window.Current then
			page = window.Current.Page
		end

		if not page then
			topFade.Visible = false
			bottomFade.Visible = false
			return
		end

		local hiddenBelow = page.AbsoluteCanvasSize.Y - page.AbsoluteWindowSize.Y - page.CanvasPosition.Y
		topFade.Visible = page.CanvasPosition.Y > 1
		bottomFade.Visible = hiddenBelow > 1
	end

	window.refreshFades = refreshFades

	local flyoutOverlay = createButton({
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50,
		Visible = false,
		Parent = mainFrame,
	})

	flyoutOverlay.Activated:Connect(function()
		if window.closeFlyout then
			window.closeFlyout()
		end
	end)

	local floatingButton = createButton({
		Size = UDim2.fromOffset(44, 44),
		BackgroundColor3 = Color3.fromRGB(18, 18, 21),
		BackgroundTransparency = 0.08,
		Parent = screenGui,
	}, {createCorner(22)})

	if type(options.ToggleImage) == "string" and options.ToggleImage ~= "" then
		createInstance("ImageLabel", {
			BackgroundTransparency = 1,
			Image = options.ToggleImage,
			ScaleType = Enum.ScaleType.Fit,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(40, 40),
			Active = false,
			Parent = floatingButton,
		})
	else
		createIcon({
			Text = "studio",
			FontFace = boldIconFont,
			TextSize = 24,
			TextColor3 = Color3.fromRGB(247, 247, 248),
			Position = UDim2.fromOffset(10, 10),
			Size = UDim2.fromOffset(24, 24),
			Active = false,
			Parent = floatingButton,
		})
	end

	local function clampWindowPosition()
		local screenSize = screenGui.AbsoluteSize
		local topInset = GuiService:GetGuiInset().Y
		local halfWidth = window.width * windowScale.Scale / 2
		local halfHeight = window.height * windowScale.Scale / 2
		local x = math.clamp(mainFrame.Position.X.Offset, halfWidth, screenSize.X - halfWidth)
		local y = math.clamp(mainFrame.Position.Y.Offset, topInset + halfHeight, screenSize.Y - halfHeight)

		mainFrame.Position = UDim2.fromOffset(x, y)
	end

	local function applyWindowSize(width, height)
		local screenSize = screenGui.AbsoluteSize
		local topInset = GuiService:GetGuiInset().Y
		local requestedWidth = math.round(tonumber(width) or window.width)
		local requestedHeight = math.round(tonumber(height) or window.height)

		window.width = math.clamp(requestedWidth, 420, math.max(420, screenSize.X - 24))
		window.height = math.clamp(requestedHeight, 260, math.max(260, screenSize.Y - topInset - 24))
		mainFrame.Size = UDim2.fromOffset(window.width, window.height)

		local widthScale = (screenSize.X - 24) / window.width
		local heightScale = (screenSize.Y - topInset - 24) / window.height
		window.fittedScale = math.clamp(math.min(widthScale, heightScale), 0.5, 1)
		windowScale.Scale = window.fittedScale

		clampWindowPosition()
	end

	local function refitWindow()
		window.fittedScale = fitToScreen(screenGui, mainFrame, windowScale, window.width, window.height)
		floatingButton.Position = UDim2.fromOffset(16, GuiService:GetGuiInset().Y + 8)
	end

	function window:Resize(width, height)
		applyWindowSize(width, height)
	end

	refitWindow()

	local activeDrag = nil

	local function createResizeHandle(placement, resizesWidth, resizesHeight)
		local handle = createButton({
			AnchorPoint = placement.AnchorPoint,
			Position = placement.Position,
			Size = placement.Size,
			ZIndex = 3,
			Parent = mainFrame,
		})

		table.insert(window.connections, handle.InputBegan:Connect(function(input)
			if input.UserInputType ~= mouseButtonInput and input.UserInputType ~= touchInput then
				return
			end

			local startWidth = window.width
			local startHeight = window.height
			local startInputPosition = input.Position
			local startScale = windowScale.Scale
			local left = mainFrame.Position.X.Offset - window.width * startScale / 2
			local top = mainFrame.Position.Y.Offset - window.height * startScale / 2

			activeDrag = {
				input = input,
				move = function(position)
					local width = window.width
					local height = window.height

					if resizesWidth then
						width = startWidth + (position.X - startInputPosition.X) / startScale
					end

					if resizesHeight then
						height = startHeight + (position.Y - startInputPosition.Y) / startScale
					end

					applyWindowSize(width, height)

					local centerX = left + window.width * windowScale.Scale / 2
					local centerY = top + window.height * windowScale.Scale / 2
					mainFrame.Position = UDim2.fromOffset(centerX, centerY)

					clampWindowPosition()
				end,
			}
		end))
	end

	createResizeHandle({
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 0, 1, 0),
		Size = UDim2.fromOffset(16, 16),
	}, true, true)

	createResizeHandle({
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, -16, 0, 10),
	}, false, true)

	createResizeHandle({
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, titleBarHeight),
		Size = UDim2.new(0, 10, 1, -(titleBarHeight + 16)),
	}, true, false)

	table.insert(window.connections, screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refitWindow))

	function window:Show()
		mainFrame.Visible = true
		windowScale.Scale = window.fittedScale
	end

	function window:Hide()
		mainFrame.Visible = false
	end

	local function toggleVisibility()
		if mainFrame.Visible then
			window:Hide()
		else
			window:Show()
		end
	end

	floatingButton.Activated:Connect(toggleVisibility)

	minimizeButton.Activated:Connect(function()
		window:Hide()
	end)

	local isCloseArmed = false
	local closeArmCount = 0

	closeButton.Activated:Connect(function()
		if isCloseArmed then
			window:Destroy()
			return
		end

		isCloseArmed = true
		closeArmCount += 1

		local armNumber = closeArmCount

		tween(closeButton, {BackgroundColor3 = colors.Error, BackgroundTransparency = 0})
		closeIcon.TextColor3 = Color3.new(1, 1, 1)

		task.delay(3, function()
			if closeArmCount ~= armNumber or not isCloseArmed then
				return
			end

			isCloseArmed = false
			tween(closeButton, {BackgroundColor3 = colors.Hover, BackgroundTransparency = 1})
			closeIcon.TextColor3 = colors.Dim
		end)
	end)

	table.insert(window.connections, titleBar.InputBegan:Connect(function(input)
		if input.UserInputType ~= mouseButtonInput and input.UserInputType ~= touchInput then
			return
		end

		local startPosition = mainFrame.Position
		local startInputPosition = input.Position

		activeDrag = {
			input = input,
			move = function(position)
				local screenSize = screenGui.AbsoluteSize
				local topInset = GuiService:GetGuiInset().Y
				local halfWidth = mainFrame.AbsoluteSize.X / 2
				local halfHeight = mainFrame.AbsoluteSize.Y / 2
				local x = startPosition.X.Offset + position.X - startInputPosition.X
				local y = startPosition.Y.Offset + position.Y - startInputPosition.Y

				mainFrame.Position = UDim2.fromOffset(
					math.clamp(x, halfWidth, screenSize.X - halfWidth),
					math.clamp(y, topInset + halfHeight, screenSize.Y - halfHeight)
				)
			end,
		}
	end))

	table.insert(window.connections, UserInputService.InputChanged:Connect(function(input)
		if not activeDrag then
			return
		end

		if input.UserInputType ~= mouseMoveInput and input ~= activeDrag.input then
			return
		end

		activeDrag.move(input.Position)
	end))

	table.insert(window.connections, UserInputService.InputEnded:Connect(function(input)
		if not activeDrag then
			return
		end

		if input ~= activeDrag.input and input.UserInputType ~= mouseButtonInput then
			return
		end

		if activeDrag.release then
			activeDrag.release()
		end

		activeDrag = nil
	end))

	table.insert(window.connections, UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType ~= keyboardInput or window.isWaitingForKey then
			return
		end

		if not window.toggleKey or input.KeyCode ~= window.toggleKey then
			return
		end

		if UserInputService:GetFocusedTextBox() then
			return
		end

		toggleVisibility()
	end))

	local function jumpToRow(element)
		local page = element.Tab.Page
		local rowOffset = (element.Row.AbsolutePosition.Y - page.AbsolutePosition.Y) / windowScale.Scale

		page.CanvasPosition = Vector2.new(0, math.max(0, rowOffset + page.CanvasPosition.Y - 4))

		local stroke = element.Row:FindFirstChildOfClass("UIStroke")
		if not stroke then
			return
		end

		tween(stroke, {Color = colors.Accent, Transparency = 0})

		task.delay(0.8, function()
			tween(stroke, {Color = colors.Text, Transparency = 0.92}, 0.4)
		end)
	end

	local pendingSearch = nil

	local function createSearchResultRow()
		local button = createButton({
			Size = UDim2.new(1, 0, 0, 44),
			BackgroundColor3 = colors.Card,
			Parent = searchPage,
		}, {createCorner(6), createStroke(0.92), createPadding(12, 12)})

		local nameLabel = createLabel({
			Size = UDim2.new(0.6, 0, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = button,
		})

		local locationLabel = createLabel({
			TextSize = 12,
			TextColor3 = colors.Dim,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0.4, 0, 1, 0),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = button,
		})

		local resultRow = {button = button, element = nil}

		function resultRow.bind(element)
			resultRow.element = element

			if not element then
				return
			end

			nameLabel.Text = element.Name

			if element.Sec then
				locationLabel.Text = `{element.Tab.Name} · {element.Sec}`
			else
				locationLabel.Text = element.Tab.Name
			end
		end

		bindHoverColors(button, function()
			return colors.Card
		end)

		button.Activated:Connect(function()
			local element = resultRow.element
			if not element then
				return
			end

			window:Search("")
			element.Tab:Select()
			task.defer(jumpToRow, element)
		end)

		return resultRow
	end

	local setSearchResults = createVirtualList(searchPage, 48, 4, createSearchResultRow, 6)

	function window:Search(text)
		if isDestroyed then
			return nil
		end

		if pendingSearch then
			task.cancel(pendingSearch)
			pendingSearch = nil
		end

		text = tostring(text or "")
		window.lastSearchText = text

		if searchBox.Text ~= text then
			searchBox.Text = text
		end

		if text == "" then
			setSearchResults({})

			if not window.isSearching then
				return nil
			end

			window.isSearching = false
			searchPage.Visible = false

			if window.Current then
				window.Current.Page.Visible = true
			end

			refreshFades()
			return nil
		end

		local matches = {}
		local query = text:lower()

		for _, tab in window.Tabs do
			for _, element in tab.Rows do
				if element.Kind ~= "Section" and element.Kind ~= "Label" then
					if element.cachedName ~= element.Name then
						element.cachedName = element.Name
						element.lowerName = element.Name:lower()
					end

					if element.lowerName:find(query, 1, true) then
						table.insert(matches, element)
					end
				end
			end
		end

		setSearchResults(matches)

		if not window.isSearching then
			window.isSearching = true
			searchPage.Visible = true

			if window.Current then
				window.Current.Page.Visible = false
			end
		end

		refreshFades()
		return #matches
	end

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if searchBox.Text == window.lastSearchText then
			return
		end

		if pendingSearch then
			task.cancel(pendingSearch)
		end

		pendingSearch = task.delay(0.1, function()
			pendingSearch = nil

			if not isDestroyed and searchBox.Text ~= window.lastSearchText then
				window:Search(searchBox.Text)
			end
		end)
	end)

	function window:Tab(tabOptions)
		tabOptions = tabOptions or {}

		local tab: any = {
			Rows = {},
			Name = tostring(tabOptions.Name or "Tab"),
			W = window,
			rowCount = 0,
			currentSection = nil,
		}

		local tabButton = createButton({
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = colors.Card,
			LayoutOrder = #window.Tabs + 1,
			Parent = tabList,
		}, {createCorner(6)})

		local selectionBar = createInstance("Frame", {
			Size = UDim2.fromOffset(3, 16),
			Position = UDim2.fromOffset(0, 10),
			BackgroundColor3 = colors.Accent,
			BorderSizePixel = 0,
			Visible = false,
			Parent = tabButton,
		}, {createCorner(2)})

		local tabIcon = nil
		if tabOptions.Icon then
			tabIcon = createIcon({
				Text = tostring(tabOptions.Icon),
				TextColor3 = colors.Dim,
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.fromOffset(20, 36),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = tabButton,
			})
		end

		local labelLeft = 12
		local labelInset = 20
		if tabIcon then
			labelLeft = 38
			labelInset = 46
		end

		local tabLabel = createLabel({
			Text = tab.Name,
			TextColor3 = colors.Dim,
			Position = UDim2.fromOffset(labelLeft, 0),
			Size = UDim2.new(1, -labelInset, 1, 0),
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = tabButton,
		})

		local page = createPage()
		tab.Page = page
		tab.Btn = tabButton

		local function paint(isSelected)
			tween(tabButton, {BackgroundTransparency = if isSelected then 0 else 1})
			selectionBar.Visible = isSelected
			tabLabel.TextColor3 = if isSelected then colors.Text else colors.Dim

			if tabIcon then
				tabIcon.TextColor3 = if isSelected then colors.Text else colors.Dim
				tabIcon.FontFace = if isSelected then boldIconFont else regularIconFont
			end
		end

		tab.paint = paint

		tabButton.MouseEnter:Connect(function()
			if UserInputService.MouseEnabled then
				tween(tabButton, {BackgroundColor3 = colors.Hover, BackgroundTransparency = 0})
			end
		end)

		tabButton.MouseLeave:Connect(function()
			local transparency = if window.Current == tab then 0 else 1
			tween(tabButton, {BackgroundColor3 = colors.Card, BackgroundTransparency = transparency})
		end)

		function tab:Select()
			if window.isSearching then
				window:Search("")
			end

			if window.Current == tab then
				return
			end

			if window.Current then
				window.Current.Page.Visible = false
				window.Current.paint(false)
			end

			window.Current = tab
			page.Visible = true
			paint(true)
			refreshFades()
		end

		tabButton.Activated:Connect(function()
			tab:Select()
		end)

		table.insert(window.Tabs, tab)

		if not window.Current then
			tab:Select()
		else
			paint(false)
		end

		local function addRow(element)
			tab.rowCount += 1
			element.Row.LayoutOrder = tab.rowCount
			table.insert(tab.Rows, element)

			return element
		end

		local function createRow(kind, rowOptions)
			if type(rowOptions.Name) ~= "string" then
				error(`{kind} Failed: Bad Name`, 0)
			end

			if rowOptions.Flag ~= nil and type(rowOptions.Flag) ~= "string" then
				error(`{kind} Failed: Bad Flag`, 0)
			end

			local rowFrame = createButton({
				Size = UDim2.new(1, 0, 0, 44),
				BackgroundColor3 = colors.Card,
				Parent = page,
			}, {createCorner(6), createStroke(0.92), createPadding(12, 12)})

			bindHoverColors(rowFrame, function()
				return colors.Card
			end)

			local nameLabel = createLabel({
				Text = rowOptions.Name,
				Size = UDim2.new(0.5, 0, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = rowFrame,
			})

			local element: any = {
				Row = rowFrame,
				Kind = kind,
				Name = rowOptions.Name,
				Flag = rowOptions.Flag,
				Tab = tab,
				Sec = tab.currentSection,
				Label = nameLabel,
			}

			function element:Get()
				return element.value
			end

			return addRow(element), rowFrame, nameLabel
		end

		local function bindText(element, label)
			function element:Set(text)
				label.Text = tostring(text)
			end

			function element:Get()
				return label.Text
			end

			return element
		end

		function tab:Section(sectionOptions)
			sectionOptions = sectionOptions or {}

			local label = createLabel({
				Text = tostring(sectionOptions.Name or ""),
				Font = boldFont,
				TextSize = 13,
				Size = UDim2.new(1, 0, 0, 30),
				TextYAlignment = Enum.TextYAlignment.Bottom,
				Parent = page,
			}, {createPadding(4, 0, 0, 4)})

			tab.currentSection = label.Text

			local element = addRow({Row = label, Kind = "Section", Name = label.Text, Tab = tab})
			return bindText(element, label)
		end

		function tab:Label(labelOptions)
			labelOptions = labelOptions or {}

			local frame = createInstance("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = colors.Card,
				BorderSizePixel = 0,
				Parent = page,
			}, {createCorner(6), createStroke(0.92), createPadding(12, 12, 10, 10)})

			local label = createLabel({
				Text = tostring(labelOptions.Text or ""),
				TextSize = 13,
				TextColor3 = colors.Dim,
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				TextWrapped = true,
				Parent = frame,
			})

			local element = addRow({Row = frame, Kind = "Label", Name = label.Text, Tab = tab, Sec = tab.currentSection})
			return bindText(element, label)
		end

		function tab:Button(buttonOptions)
			buttonOptions = buttonOptions or {}

			local element, rowFrame, nameLabel = createRow("Button", buttonOptions)

			createIcon({
				Text = "chevron-small-right",
				TextSize = 14,
				TextColor3 = colors.Dim,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 0, 0),
				Size = UDim2.fromOffset(16, 44),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = rowFrame,
			})

			rowFrame.Activated:Connect(function()
				runCallback(buttonOptions.Callback)
			end)

			return bindText(element, nameLabel)
		end

		function tab:Toggle(toggleOptions)
			toggleOptions = toggleOptions or {}

			local element, rowFrame = createRow("Toggle", toggleOptions)

			local switchFrame = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(40, 20),
				BackgroundColor3 = colors.Accent,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Parent = rowFrame,
			}, {createCorner(10), createStroke(0.2, colors.Dim)})

			local switchStroke = switchFrame:FindFirstChildOfClass("UIStroke")

			local knob = createInstance("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 4, 0.5, 0),
				Size = UDim2.fromOffset(12, 12),
				BackgroundColor3 = colors.Dim,
				BorderSizePixel = 0,
				Parent = switchFrame,
			}, {createCorner(6)})

			local stateLabel = createLabel({
				Text = "Off",
				TextSize = 13,
				TextColor3 = colors.Dim,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -48, 0, 0),
				Size = UDim2.fromOffset(40, 44),
				TextXAlignment = Enum.TextXAlignment.Right,
				Parent = rowFrame,
			})

			element.value = toggleOptions.Default == true
			element.loadValue = function(savedValue)
				return savedValue == true
			end

			local function draw(shouldAnimate)
				local isOn = element.value

				applyProperties(switchFrame, {BackgroundTransparency = if isOn then 0 else 1}, shouldAnimate)
				applyProperties(switchStroke, {Transparency = if isOn then 1 else 0.2}, shouldAnimate)
				applyProperties(knob, {
					Position = UDim2.new(0, if isOn then 24 else 4, 0.5, 0),
					BackgroundColor3 = if isOn then colors.Background else colors.Dim,
				}, shouldAnimate)

				stateLabel.Text = if isOn then "On" else "Off"
			end

			draw(false)

			function element:Set(value)
				value = value == true

				if value == element.value then
					return
				end

				element.value = value
				draw(true)
				storeFlagValue(element, value)
				runCallback(toggleOptions.Callback, value)
			end

			rowFrame.Activated:Connect(function()
				element:Set(not element.value)
			end)

			loadSavedValue(element)
			return element
		end

		function tab:Slider(sliderOptions)
			sliderOptions = sliderOptions or {}

			local minimum = tonumber(sliderOptions.Min)
			local maximum = tonumber(sliderOptions.Max)

			local step = 1
			if sliderOptions.Step ~= nil then
				step = tonumber(sliderOptions.Step)
			end

			if not (minimum and maximum and maximum > minimum) then
				error("Slider Failed: Bad Range", 0)
			end

			if not (step and step > 0) then
				error("Slider Failed: Bad Step", 0)
			end

			local element, rowFrame = createRow("Slider", sliderOptions)

			local valueFrame = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(44, 24),
				BackgroundColor3 = colors.Background,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = rowFrame,
			}, {createCorner(4), createStroke(0.9)})

			local valueStroke = valueFrame:FindFirstChildOfClass("UIStroke")

			local valueBox = createInstance("TextBox", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Font = textFont,
				TextSize = 13,
				TextColor3 = colors.Text,
				ClearTextOnFocus = false,
				Text = "",
				Parent = valueFrame,
			})

			local hitArea = createButton({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, -52, 0.5, 0),
				Size = UDim2.fromOffset(120, 28),
				Parent = rowFrame,
			})

			local track = createInstance("Frame", {
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, 4),
				BackgroundColor3 = colors.Hover,
				BorderSizePixel = 0,
				Parent = hitArea,
			}, {createCorner(2)})

			local fill = createInstance("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundColor3 = colors.Accent,
				BorderSizePixel = 0,
				Parent = track,
			}, {createCorner(2)})

			local knob = createInstance("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.fromOffset(14, 14),
				BackgroundColor3 = colors.Accent,
				BorderSizePixel = 0,
				Parent = hitArea,
			}, {createCorner(7), createInstance("UIStroke", {Color = colors.Background, Thickness = 2})})

			local function snapValue(value)
				local snapped = minimum + math.round((value - minimum) / step) * step
				return math.clamp(snapped, minimum, maximum)
			end

			local startValue = minimum
			local defaultValue = sliderOptions.Default
			if type(defaultValue) == "number" and defaultValue == defaultValue then
				startValue = defaultValue
			end

			element.value = snapValue(startValue)
			element.loadValue = tonumber

			local function draw()
				local alpha = (element.value - minimum) / (maximum - minimum)

				fill.Size = UDim2.new(alpha, 0, 1, 0)
				knob.Position = UDim2.new(alpha, 0, 0.5, 0)
				valueBox.Text = ("%g"):format(element.value)
			end

			draw()

			function element:Set(value)
				if type(value) ~= "number" or value ~= value then
					error("Slider Set Failed: Not A Number", 0)
				end

				value = snapValue(value)

				if value == element.value then
					return
				end

				element.value = value
				draw()
				storeFlagValue(element, value)
				runCallback(sliderOptions.Callback, value)
			end

			local function setFromScreenX(screenX)
				local alpha = math.clamp((screenX - hitArea.AbsolutePosition.X) / hitArea.AbsoluteSize.X, 0, 1)
				element:Set(minimum + alpha * (maximum - minimum))
			end

			hitArea.InputBegan:Connect(function(input)
				if input.UserInputType ~= mouseButtonInput and input.UserInputType ~= touchInput then
					return
				end

				page.ScrollingEnabled = false

				activeDrag = {
					input = input,
					move = function(position)
						setFromScreenX(position.X)
					end,
					release = function()
						page.ScrollingEnabled = true
					end,
				}

				setFromScreenX(input.Position.X)
			end)

			valueBox.Focused:Connect(function()
				tween(valueStroke, {Color = colors.Accent, Transparency = 0})
			end)

			valueBox.FocusLost:Connect(function()
				tween(valueStroke, {Color = colors.Text, Transparency = 0.9})

				local typedValue = tonumber(valueBox.Text)
				if typedValue and typedValue == typedValue then
					element:Set(typedValue)
				end

				draw()
			end)

			loadSavedValue(element)
			return element
		end

		function tab:Dropdown(dropdownOptions)
			dropdownOptions = dropdownOptions or {}

			if type(dropdownOptions.Options) ~= "table" then
				error("Dropdown Failed: Bad Options", 0)
			end

			local element, rowFrame = createRow("Dropdown", dropdownOptions)
			local isMulti = dropdownOptions.Multi == true

			element.Options = {}

			local function setOptions(list)
				local seenOptions = {}
				element.Options = {}

				for _, option in list do
					if type(option) == "string" and not seenOptions[option] then
						seenOptions[option] = true
						table.insert(element.Options, option)
					end
				end
			end

			setOptions(dropdownOptions.Options)

			local dropdownBox = createButton({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(150, 28),
				BackgroundColor3 = colors.Background,
				Parent = rowFrame,
			}, {createCorner(4), createStroke(0.9)})

			local valueLabel = createLabel({
				Text = "",
				TextSize = 13,
				Position = UDim2.fromOffset(10, 0),
				Size = UDim2.new(1, -34, 1, 0),
				TextTruncate = Enum.TextTruncate.AtEnd,
				Parent = dropdownBox,
			})

			createIcon({
				Text = "chevron-small-down",
				TextSize = 14,
				TextColor3 = colors.Dim,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -6, 0, 0),
				Size = UDim2.fromOffset(16, 28),
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = dropdownBox,
			})

			local function normalizeValue(value)
				if isMulti then
					if type(value) ~= "table" then
						error("Dropdown Set Failed: Not A Table", 0)
					end

					local wantedOptions = {}
					local orderedSelection = {}

					for _, option in value do
						wantedOptions[option] = true
					end

					for _, option in element.Options do
						if wantedOptions[option] then
							table.insert(orderedSelection, option)
						end
					end

					return orderedSelection
				end

				if value == nil then
					return nil
				end

				if table.find(element.Options, value) then
					return value
				end

				error("Dropdown Set Failed: Unknown Option", 0)
			end

			local function isSameValue(left, right)
				if not isMulti then
					return left == right
				end

				if #left ~= #right then
					return false
				end

				for index, option in left do
					if right[index] ~= option then
						return false
					end
				end

				return true
			end

			if isMulti then
				if type(dropdownOptions.Default) == "table" then
					element.value = normalizeValue(dropdownOptions.Default)
				else
					element.value = {}
				end

				element.loadValue = function(savedValue)
					return if type(savedValue) == "table" then savedValue else {}
				end
			else
				if table.find(element.Options, dropdownOptions.Default) then
					element.value = dropdownOptions.Default
				else
					element.value = nil
				end

				element.saveValue = function(value)
					return if value == nil then false else value
				end

				element.loadValue = function(savedValue)
					return if savedValue == false then nil else savedValue
				end
			end

			local function isSelected(option)
				if isMulti then
					return table.find(element.value, option) ~= nil
				end

				return element.value == option
			end

			local flyout = nil
			local setVisibleOptions = nil
			local refreshVisibleOptions = nil
			local emptyLabel = nil

			local function draw()
				local hasValue = if isMulti then #element.value > 0 else element.value ~= nil

				if hasValue then
					valueLabel.Text = if isMulti then table.concat(element.value, ", ") else element.value
					valueLabel.TextColor3 = colors.Text
				else
					valueLabel.Text = "None"
					valueLabel.TextColor3 = colors.Dim
				end

				if refreshVisibleOptions then
					refreshVisibleOptions()
				end
			end

			draw()

			function element:Get()
				if isMulti then
					return table.clone(element.value)
				end

				return element.value
			end

			local function applyValue(value)
				element.value = value
				draw()
				storeFlagValue(element, element:Get())
				runCallback(dropdownOptions.Callback, element:Get())
			end

			function element:Set(value)
				value = normalizeValue(value)

				if isSameValue(value, element.value) then
					return
				end

				applyValue(value)
			end

			local function flyoutHeight()
				return math.max(math.min(#element.Options, 5), 1) * 32 + 8
			end

			function element:Refresh(list)
				if type(list) ~= "table" then
					error("Dropdown Refresh Failed: Bad Options", 0)
				end

				setOptions(list)

				local value = nil
				if isMulti then
					value = normalizeValue(element.value)
				elseif table.find(element.Options, element.value) then
					value = element.value
				end

				if setVisibleOptions then
					flyout.Size = UDim2.fromOffset(flyout.Size.X.Offset, flyoutHeight())
					emptyLabel.Visible = #element.Options == 0
					setVisibleOptions(element.Options)
				end

				if not isSameValue(value, element.value) then
					applyValue(value)
				end

				draw()
			end

			local function closeFlyout()
				if not flyout then
					return
				end

				flyout:Destroy()
				flyout = nil
				setVisibleOptions = nil
				refreshVisibleOptions = nil
				emptyLabel = nil
				flyoutOverlay.Visible = false
				window.closeFlyout = nil
			end

			local function createOptionRow(optionList)
				local optionButton = createButton({
					Size = UDim2.new(1, 0, 0, 32),
					BackgroundColor3 = colors.Hover,
					Parent = optionList,
				}, {createCorner(4)})

				local optionLabel = createLabel({
					TextSize = 13,
					Position = UDim2.fromOffset(10, 0),
					Size = UDim2.new(1, -36, 1, 0),
					TextTruncate = Enum.TextTruncate.AtEnd,
					Parent = optionButton,
				})

				local checkIcon = createIcon({
					Text = "check",
					TextSize = 14,
					TextColor3 = colors.Accent,
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -8, 0, 0),
					Size = UDim2.fromOffset(16, 32),
					TextXAlignment = Enum.TextXAlignment.Center,
					Parent = optionButton,
				})

				local optionRow: any = {button = optionButton, activeTween = nil, option = nil}

				local function tweenBackground(transparency)
					if optionRow.activeTween then
						optionRow.activeTween:Cancel()
					end

					optionRow.activeTween = TweenService:Create(optionButton, defaultTweenInfo, {BackgroundTransparency = transparency})
					optionRow.activeTween:Play()
				end

				function optionRow.bind(option)
					if optionRow.activeTween then
						optionRow.activeTween:Cancel()
						optionRow.activeTween = nil
					end

					optionRow.option = option

					if not option then
						return
					end

					optionLabel.Text = option
					checkIcon.Visible = isSelected(option)
					optionButton.BackgroundTransparency = if isSelected(option) then 0 else 1
				end

				optionButton.MouseEnter:Connect(function()
					if UserInputService.MouseEnabled then
						tweenBackground(0)
					end
				end)

				optionButton.MouseLeave:Connect(function()
					tweenBackground(if isSelected(optionRow.option) then 0 else 1)
				end)

				optionButton.Activated:Connect(function()
					local option = optionRow.option
					if not option then
						return
					end

					if not isMulti then
						element:Set(option)
						closeFlyout()
						return
					end

					local selection = element:Get()
					local selectedIndex = table.find(element.value, option)

					if selectedIndex then
						table.remove(selection, selectedIndex)
					else
						table.insert(selection, option)
					end

					element:Set(selection)
					tweenBackground(if isSelected(optionRow.option) then 0 else 1)
				end)

				return optionRow
			end

			local function openFlyout()
				if flyout then
					closeFlyout()
					return
				end

				if window.closeFlyout then
					window.closeFlyout()
				end

				window.closeFlyout = closeFlyout
				flyoutOverlay.Visible = true

				local scale = windowScale.Scale
				local boxPosition = (dropdownBox.AbsolutePosition - mainFrame.AbsolutePosition) / windowScale.Scale

				flyout = createInstance("Frame", {
					Position = UDim2.fromOffset(boxPosition.X, boxPosition.Y + 32),
					Size = UDim2.fromOffset(dropdownBox.AbsoluteSize.X / scale, flyoutHeight()),
					BackgroundColor3 = colors.Card,
					BorderSizePixel = 0,
					Parent = flyoutOverlay,
				}, {createCorner(6), createStroke(0.85), createPadding(4, 4, 4, 4)})

				local optionList = createInstance("ScrollingFrame", {
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ScrollBarThickness = 0,
					CanvasSize = UDim2.new(),
					ScrollingDirection = Enum.ScrollingDirection.Y,
					Parent = flyout,
				})

				emptyLabel = createLabel({
					Text = "No Options",
					TextSize = 13,
					TextColor3 = colors.Dim,
					Position = UDim2.fromOffset(10, 0),
					Size = UDim2.new(1, -10, 0, 32),
					Visible = #element.Options == 0,
					Parent = optionList,
				})

				setVisibleOptions, refreshVisibleOptions = createVirtualList(optionList, 32, 0, function()
					return createOptionRow(optionList)
				end)

				setVisibleOptions(element.Options)
			end

			dropdownBox.Activated:Connect(openFlyout)

			bindHoverColors(dropdownBox, function()
				return colors.Background
			end)

			loadSavedValue(element)
			return element
		end

		function tab:TextBox(textBoxOptions)
			textBoxOptions = textBoxOptions or {}

			local element, rowFrame = createRow("TextBox", textBoxOptions)

			local boxFrame = createInstance("Frame", {
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(150, 28),
				BackgroundColor3 = colors.Background,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Parent = rowFrame,
			}, {createCorner(4), createStroke(0.9)})

			local boxStroke = boxFrame:FindFirstChildOfClass("UIStroke")

			local defaultText = ""
			if type(textBoxOptions.Default) == "string" then
				defaultText = textBoxOptions.Default
			end

			local textBox = createInstance("TextBox", {
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(8, 0),
				Size = UDim2.new(1, -16, 1, 0),
				Font = textFont,
				TextSize = 13,
				TextColor3 = colors.Text,
				PlaceholderText = tostring(textBoxOptions.Placeholder or ""),
				PlaceholderColor3 = colors.Dim,
				TextXAlignment = Enum.TextXAlignment.Left,
				ClearTextOnFocus = false,
				Text = defaultText,
				Parent = boxFrame,
			})

			element.value = textBox.Text
			element.loadValue = tostring

			function element:Set(value)
				value = tostring(value)
				textBox.Text = value

				if value == element.value then
					return
				end

				element.value = value
				storeFlagValue(element, value)
				runCallback(textBoxOptions.Callback, value)
			end

			textBox.Focused:Connect(function()
				tween(boxStroke, {Color = colors.Accent, Transparency = 0})
			end)

			textBox.FocusLost:Connect(function()
				tween(boxStroke, {Color = colors.Text, Transparency = 0.9})
				element:Set(textBox.Text)
			end)

			loadSavedValue(element)
			return element
		end

		function tab:Keybind(keybindOptions)
			keybindOptions = keybindOptions or {}

			local defaultKey = normalizeKeyCode(keybindOptions.Default)
			if defaultKey == false then
				error("Keybind Failed: Bad Key", 0)
			end

			local element, rowFrame = createRow("Keybind", keybindOptions)

			local keyCap = createButton({
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.fromOffset(0, 24),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = colors.Background,
				Parent = rowFrame,
			}, {createCorner(4), createStroke(0.9), createPadding(10, 10)})

			local keyLabel = createLabel({
				Text = "",
				TextSize = 12,
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				TextXAlignment = Enum.TextXAlignment.Center,
				Parent = keyCap,
			})

			local isWaiting = false

			element.value = defaultKey
			element.saveValue = function(value)
				return value and value.Name or false
			end
			element.loadValue = function(savedValue)
				return type(savedValue) == "string" and Enum.KeyCode[savedValue] or nil
			end

			local function draw()
				if isWaiting then
					keyLabel.Text = "..."
				elseif element.value then
					keyLabel.Text = element.value.Name
				else
					keyLabel.Text = "None"
				end

				keyLabel.TextColor3 = if isWaiting or element.value then colors.Text else colors.Dim
			end

			draw()

			function element:Set(value)
				local keyCode = normalizeKeyCode(value)
				if keyCode == false then
					error("Keybind Set Failed: Bad Key", 0)
				end

				if keyCode == element.value then
					return
				end

				element.value = keyCode
				draw()
				storeFlagValue(element, keyCode)
			end

			bindHoverColors(keyCap, function()
				return colors.Background
			end)

			keyCap.Activated:Connect(function()
				isWaiting = not isWaiting
				window.isWaitingForKey = isWaiting
				draw()
			end)

			table.insert(window.connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if input.UserInputType ~= keyboardInput then
					return
				end

				if isWaiting then
					isWaiting = false
					window.isWaitingForKey = false

					if input.KeyCode == Enum.KeyCode.Backspace then
						element:Set(nil)
					elseif input.KeyCode ~= Enum.KeyCode.None then
						element:Set(input.KeyCode)
					end

					draw()
					return
				end

				if gameProcessed or not element.value or input.KeyCode ~= element.value then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end

				runCallback(keybindOptions.Callback)
			end))

			loadSavedValue(element)
			return element
		end

		return tab
	end

	function window:Destroy()
		isDestroyed = true

		if pendingSearch then
			task.cancel(pendingSearch)
			pendingSearch = nil
		end

		for _, connection in window.connections do
			connection:Disconnect()
		end

		window.connections = {}

		saveConfig()
		screenGui:Destroy()

		if sharedEnvironment.__AvW == window then
			sharedEnvironment.__AvW = nil
		end
	end

	sharedEnvironment.__AvW = window
	return window
end

return Library
end)()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

if not game:IsLoaded() then
	game.Loaded:Wait()
end

repeat
	task.wait()
until Players.LocalPlayer

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local gameName = "Break And Steal An Egg"
local configFolder = "Avenoric/Configs/BreakAndStealAnEgg"
local configName = `BreakAndStealAnEgg/{localPlayer.Name}`
local logPath = `{configFolder}/{localPlayer.Name}_Log.txt`
local logoPath = "Avenoric/Assets/NgaoLogo.png"
local supportWebhookUrl = "https://discord.com/api/webhooks/1561788889776263258/DblWnAZmPXTmF_Sl13lQ_LY7nY6nqP0wR_NsXPzC83E_VrLXp3WoKBBMcQCGvYKzojUz?wait=true"
local logoData = "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"

local sharedEnvironment = getgenv()

local function ensureFolders(paths)
	for _, path in paths do
		if not isfolder(path) then
			makefolder(path)
		end
	end
end

local logQueue = sharedEnvironment.__BseLog
if type(logQueue) ~= "table" then
	logQueue = {lines = {}, isFlushScheduled = false}
	sharedEnvironment.__BseLog = logQueue
end

local function appendLogFile(text)
	ensureFolders({"Avenoric", "Avenoric/Configs", configFolder})

	if appendfile and isfile(logPath) then
		appendfile(logPath, text)
		return
	end

	local existing = ""
	if isfile(logPath) then
		existing = readfile(logPath)
	end

	writefile(logPath, existing .. text)
end

local function flushLog()
	logQueue.isFlushScheduled = false

	if #logQueue.lines == 0 then
		return
	end

	local text = table.concat(logQueue.lines, "\n") .. "\n"
	if pcall(appendLogFile, text) then
		table.clear(logQueue.lines)
	end
end

local function writeLog(text, flushNow)
	local message = string.gsub(tostring(text), "%s*\n%s*", " <- ")
	table.insert(logQueue.lines, `{os.date("%Y-%m-%d %H:%M:%S")} | {message}`)

	if flushNow then
		flushLog()
		return
	end

	if logQueue.isFlushScheduled then
		return
	end

	logQueue.isFlushScheduled = true
	task.delay(2, flushLog)
end

local function reportError(text)
	warn(text)
	writeLog(`[Error] {text}`)
end

local function trimLogFile()
	if not isfile(logPath) then
		return
	end

	local text = readfile(logPath)
	if #text <= 4e6 then
		return
	end

	local keptText = string.sub(text, -2e6)
	local firstBreak = string.find(keptText, "\n", 1, true)
	if firstBreak then
		keptText = string.sub(keptText, firstBreak + 1)
	end

	writefile(logPath, keptText)
	writeLog(`[Hub] Log Trimmed | {#text} -> {#keptText} Bytes`)
end

do
	local trimmed, trimFailure = pcall(trimLogFile)
	if not trimmed then
		warn(`Log Trim Failed: {trimFailure}`)
	end
end

local function findOwnedPlot()
	local plots = workspace:FindFirstChild("Plots")
	if not plots then
		return nil
	end

	for _, plot in plots:GetChildren() do
		if plot:GetAttribute("OwnerUserId") == localPlayer.UserId then
			return plot
		end
	end

	return nil
end

local function isGameReady()
	if type(localPlayer:GetAttribute("Cash")) ~= "number" then
		return false
	end

	if not playerGui:FindFirstChild("MainGUI") then
		return false
	end

	local character = localPlayer.Character
	if not (character and character:FindFirstChild("HumanoidRootPart")) then
		return false
	end

	return findOwnedPlot() ~= nil
end

while not isGameReady() do
	task.wait(0.5)
end

local function disconnectValue(value)
	if typeof(value) == "RBXScriptConnection" then
		pcall(value.Disconnect, value)
		return true
	end

	return false
end

local function stopPreviousLoad(previous)
	for key, value in pairs(previous) do
		if type(value) == "boolean" then
			previous[key] = false
		end
	end

	for _, job in pairs(previous.jobs or {}) do
		if type(job) == "table" and type(job.status) == "string" then
			job.status = "Stopped"
		end
	end

	if type(previous.renderBindings) == "table" then
		for _, bindingName in pairs(previous.renderBindings) do
			pcall(RunService.UnbindFromRenderStep, RunService, bindingName)
		end

		table.clear(previous.renderBindings)
	end

	for _, connection in pairs(previous.connections or {}) do
		disconnectValue(connection)
	end

	for _, value in pairs(previous) do
		disconnectValue(value)
	end
end

local previousLoadJobs = nil

if type(sharedEnvironment.__BseAf) == "table" then
	if type(sharedEnvironment.__BseAf.jobs) == "table" then
		previousLoadJobs = sharedEnvironment.__BseAf.jobs
	end

	local stopped, stopFailure = pcall(stopPreviousLoad, sharedEnvironment.__BseAf)
	if not stopped then
		warn(`Stop Previous Load Failed: {stopFailure}`)
	end
end

local state = {
	isRunning = true,
	connections = {},
	jobs = {},
	renderBindings = {},
	hudButton = nil,
	farmZone = 1,
	farmRarities = {},
	minPetKg = 0,
	minPetIncome = 0,
	breakJob = nil,
	walkTarget = nil,
	nextHitId = 2e6,
	skippedEggs = {},
	skippedPickups = {},
	carriedPet = nil,
	bankCount = 0,
	isPetsFull = false,
	activity = "Idle",
	sellRarities = {},
	sellJob = nil,
	buyPickaxe = false,
	buyTreadmill = false,
	buyPen = false,
	buyTrail = false,
	shopJob = nil,
	shopPausedUntil = {},
	shopMaxLogged = {},
	serverJob = nil,
	rejoinJob = nil,
	lastTeleportAt = nil,
	halloweenJob = nil,
	eventZones = {BloodMoon = 1, CandyHeist = {}, DisguisedEggs = {}, TrickOrTreat = {}},
	eventOwner = nil,
	isBreakPaused = false,
	candyDrops = {},
	cornDrops = {},
	lastDoorOutcome = nil,
	isPetIndexOn = false,
	petIndexToggle = nil,
	indexState = nil,
	indexRequestedAt = 0,
	indexLoggedZone = nil,
}

sharedEnvironment.__BseAf = state

local function trackConnection(connection)
	table.insert(state.connections, connection)
	return connection
end

local window = nil

local function requireShared(moduleName)
	local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
	local module = sharedFolder and sharedFolder:FindFirstChild(moduleName)
	if not module then
		return nil
	end

	local loaded, result = pcall(require, module)

	return loaded and result or nil
end

local function readZoneNames()
	local zoneDisplayInfo = requireShared("ZoneDisplayInfo")
	local names = {}

	if type(zoneDisplayInfo) ~= "table" then
		return names
	end

	local zoneIndex = 1
	while true do
		local zone = zoneDisplayInfo[`Zone{zoneIndex}`]
		if type(zone) ~= "table" or type(zone.Name) ~= "string" then
			break
		end

		names[zoneIndex] = zone.Name
		zoneIndex += 1
	end

	return names
end

local function readRarityNames()
	local eggRarity = requireShared("EggRarity")
	if type(eggRarity) ~= "table" or type(eggRarity.Ladder) ~= "function" then
		return {}
	end

	local read, ladder = pcall(eggRarity.Ladder)
	if not read or type(ladder) ~= "table" then
		return {}
	end

	local names = {}
	for _, rarity in ladder do
		if type(rarity) == "string" then
			table.insert(names, rarity)
		end
	end

	return names
end

local amountSuffixes = {
	{name = "Dc", value = 1e33},
	{name = "No", value = 1e30},
	{name = "Oc", value = 1e27},
	{name = "Sp", value = 1e24},
	{name = "Sx", value = 1e21},
	{name = "Qi", value = 1e18},
	{name = "Qa", value = 1e15},
	{name = "T", value = 1e12},
	{name = "B", value = 1e9},
	{name = "M", value = 1e6},
	{name = "K", value = 1e3},
}

local amountSuffixByName = {}
for _, suffix in amountSuffixes do
	amountSuffixByName[string.lower(suffix.name)] = suffix.value
end

local function formatAmount(amount)
	for _, suffix in amountSuffixes do
		if amount >= suffix.value then
			return string.format("%.2f%s", amount / suffix.value, suffix.name)
		end
	end

	return string.format("%.0f", amount)
end

local function parseAmount(text)
	local trimmed = string.match(tostring(text), "^%s*(.-)%s*$") or ""
	if trimmed == "" or string.lower(trimmed) == "all" then
		return 0
	end

	local digits, suffix = string.match(string.gsub(trimmed, ",", ""), "^(%d*%.?%d+)%s*(%a*)$")
	local amount = digits and tonumber(digits)
	if not amount then
		return nil
	end

	if suffix == "" then
		return amount
	end

	local multiplier = amountSuffixByName[string.lower(suffix)]
	if not multiplier then
		return nil
	end

	return amount * multiplier
end

local zoneNames = readZoneNames()
local rarityNames = readRarityNames()

local eggTargeting = requireShared("EggTargeting")
local eggConfig = requireShared("EggConfig")
local pickaxeConfig = requireShared("PickaxeConfig")
local robuxShopConfig = requireShared("RobuxShopConfig")
local zoneFloor = requireShared("ZoneFloor")
local eggRewards = requireShared("EggRewards")
local petInventoryConfig = requireShared("PetInventoryConfig")
local backpackSellConfig = requireShared("BackpackSellConfig")
local trailsConfig = requireShared("TrailsConfig")
local treadmillUpgradeConfig = requireShared("TreadmillUpgradeConfig")
local treadmillUnlockConfig = requireShared("TreadmillUnlockConfig")
local plotUpgradeConfig = requireShared("PlotUpgradeConfig")
local halloweenConfig = requireShared("HalloweenEventConfig")
local zoneAnimalsConfig = requireShared("ZoneAnimalsConfig")

local eggHitRemote = ReplicatedStorage:FindFirstChild("EggHitRequest")
local treadmillRemote = ReplicatedStorage:FindFirstChild("TreadmillSessionRemote")
local catchFlingRemote = ReplicatedStorage:FindFirstChild("CatchFlingRemote")
local animalBankedRemote = ReplicatedStorage:FindFirstChild("AnimalBankedRemote")
local backpackSellRemote = ReplicatedStorage:FindFirstChild("BackpackSellRemote")
local pickaxeShopRemote = ReplicatedStorage:FindFirstChild("PickaxeShopRequest")
local trailShopRemote = ReplicatedStorage:FindFirstChild("TrailShopRequest")
local upgradeTreadmillRemote = ReplicatedStorage:FindFirstChild("UpgradeTreadmillRequest")
local unlockTreadmillRemote = ReplicatedStorage:FindFirstChild("UnlockTreadmillRequest")
local upgradePlotRemote = ReplicatedStorage:FindFirstChild("UpgradePlotRequest")
local candyHeistRemote = ReplicatedStorage:FindFirstChild("HalloweenCandyHeist")
local candyDropsRemote = ReplicatedStorage:FindFirstChild("HalloweenCandyDrops")
local doorsRemote = ReplicatedStorage:FindFirstChild("HalloweenDoors")
local indexRemote = ReplicatedStorage:FindFirstChild("IndexRemote")

local function requestIndexState()
	if not indexRemote or os.clock() - state.indexRequestedAt < 1 then
		return
	end

	state.indexRequestedAt = os.clock()
	indexRemote:FireServer("Get", nil)
end

if indexRemote then
	trackConnection(indexRemote.OnClientEvent:Connect(function(action, data)
		if action == "State" and type(data) == "table" then
			state.indexState = data
		end
	end))
end

if animalBankedRemote then
	trackConnection(animalBankedRemote.OnClientEvent:Connect(function()
		state.bankCount += 1

		if state.isPetIndexOn then
			task.delay(1, requestIndexState)
		end
	end))
end

if catchFlingRemote then
	trackConnection(catchFlingRemote.OnClientEvent:Connect(function(action)
		if action == "fling" and state.breakJob ~= nil and state.activity ~= "Following Guard" then
			writeLog(`[Pet] Caught While {state.activity} | Carrying {tostring(localPlayer:GetAttribute("Carrying"))}`)
		end
	end))
end

local function rememberCandyDrop(drop)
	if type(drop) ~= "table" or type(drop.Id) ~= "string" or typeof(drop.Position) ~= "Vector3" then
		return
	end

	state.candyDrops[drop.Id] = {
		id = drop.Id,
		position = drop.Position,
		origin = typeof(drop.Origin) == "Vector3" and drop.Origin or drop.Position,
		claimUserId = tonumber(drop.ClaimUserId),
		expiresAt = tonumber(drop.ExpiresAt) or math.huge,
		spawnedAt = os.clock(),
		skipUntil = 0,
	}
end

local function onCandyHeistEvent(action, data)
	if type(data) ~= "table" then
		return
	end

	if action == "Start" or action == "Snapshot" or action == "End" then
		table.clear(state.candyDrops)
	end

	if (action == "Start" or action == "Snapshot" or action == "Spawn") and type(data.Drops) == "table" then
		for _, drop in data.Drops do
			rememberCandyDrop(drop)
		end
	elseif action == "Collect" and type(data.Id) == "string" then
		if (tonumber(data.Remaining) or 0) <= 0 then
			state.candyDrops[data.Id] = nil
		end
	elseif action == "Remove" and type(data.Ids) == "table" then
		for _, id in data.Ids do
			state.candyDrops[id] = nil
		end
	elseif action == "Spill" and data.UserId == localPlayer.UserId and state.eventOwner then
		writeLog(`[Event] Spilled {tostring(data.Amount)} Candy | Bag {tostring(data.Bag)} | {state.activity}`)
	end
end

if candyHeistRemote then
	trackConnection(candyHeistRemote.OnClientEvent:Connect(onCandyHeistEvent))
end

local function onCandyDropsEvent(action, data)
	if action == "Spawn" and type(data) == "table" then
		for _, drop in data do
			if type(drop) == "table" and type(drop.Id) == "string" and typeof(drop.Position) == "Vector3" then
				state.cornDrops[drop.Id] = {
					id = drop.Id,
					position = drop.Position,
					origin = typeof(drop.Origin) == "Vector3" and drop.Origin or drop.Position,
					expiresAt = tonumber(drop.ExpiresAt) or math.huge,
					spawnedAt = os.clock(),
					skipUntil = 0,
					isPotion = drop.PotionOutcome ~= nil,
				}
			end
		end
	elseif (action == "Collect" or action == "Remove") and type(data) == "table" then
		for _, id in data do
			state.cornDrops[id] = nil
		end
	elseif action == "CollectPotion" and type(data) == "table" and type(data.Id) == "string" then
		state.cornDrops[data.Id] = nil
	end
end

if candyDropsRemote then
	trackConnection(candyDropsRemote.OnClientEvent:Connect(onCandyDropsEvent))
end

if doorsRemote then
	trackConnection(doorsRemote.OnClientEvent:Connect(function(data)
		if type(data) == "table" and type(data.Outcome) == "string" then
			state.lastDoorOutcome = {outcome = data.Outcome, at = os.clock()}
		end
	end))
end

local walkBindingName = `NgaoBseWalk{HttpService:GenerateGUID(false)}`
local maxHopDistance = 40

local function getCharacterParts()
	local character = localPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")
	if not (humanoid and root) or humanoid.Health <= 0 then
		return nil, nil, nil
	end

	return character, humanoid, root
end

local function isJobRunning(job)
	return state.isRunning and job.status == "Running"
end

local function startJob(name, body)
	local job = {name = name, status = "Running"}
	table.insert(state.jobs, job)

	task.spawn(function()
		local finished, failure = xpcall(body, function(message)
			return debug.traceback(tostring(message), 2)
		end, job)

		if not finished then
			reportError(`{name} Failed: {failure}`)
		end

		job.status = "Stopped"

		local index = table.find(state.jobs, job)
		if index then
			table.remove(state.jobs, index)
		end
	end)

	return job
end

local function hasUnfinishedJob(jobs, name, exceptJob)
	for _, otherJob in jobs or {} do
		if otherJob ~= exceptJob and otherJob.name == name then
			return true
		end
	end

	return false
end

local function waitForEarlierRuns(job)
	local deadline = os.clock() + 10

	while isJobRunning(job) and os.clock() < deadline do
		local isBusy = hasUnfinishedJob(state.jobs, job.name, job) or hasUnfinishedJob(previousLoadJobs, job.name, nil)
		if not isBusy then
			return true
		end

		task.wait(0.05)
	end

	return false
end

local function waitUntil(job, timeout, condition)
	local deadline = os.clock() + timeout

	while isJobRunning(job) and os.clock() < deadline do
		if condition() then
			return true
		end

		task.wait(0.05)
	end

	return condition()
end

local function moveTowardWalkTarget()
	local target = state.walkTarget
	local _, humanoid, root = getCharacterParts()
	if not (target and humanoid and root) then
		return
	end

	local offset = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z)
	if offset.Magnitude < 1 then
		humanoid:Move(Vector3.zero, false)
		return
	end

	humanoid:Move(offset.Unit, false)
end

local function startWalking(target)
	state.walkTarget = target

	if table.find(state.renderBindings, walkBindingName) then
		return
	end

	RunService:BindToRenderStep(walkBindingName, Enum.RenderPriority.Character.Value + 1, moveTowardWalkTarget)
	table.insert(state.renderBindings, walkBindingName)
end

local function stopWalking()
	state.walkTarget = nil

	local index = table.find(state.renderBindings, walkBindingName)
	if index then
		table.remove(state.renderBindings, index)
		RunService:UnbindFromRenderStep(walkBindingName)
	end

	local _, humanoid = getCharacterParts()
	if humanoid then
		humanoid:Move(Vector3.zero, false)
	end
end

local function teleportRoot(root, position, facing)
	root.AssemblyLinearVelocity = Vector3.zero

	if facing then
		root.CFrame = CFrame.lookAt(position, Vector3.new(facing.X, position.Y, facing.Z))
	else
		root.CFrame = CFrame.new(position)
	end
end

local function walkUntil(job, target, isArrived)
	if isArrived() then
		return true
	end

	local _, humanoid, root = getCharacterParts()
	if not (humanoid and root) then
		return false
	end

	local flatDistance = Vector3.new(target.X - root.Position.X, 0, target.Z - root.Position.Z).Magnitude
	local deadline = os.clock() + flatDistance / math.max(humanoid.WalkSpeed, 16) + 3
	local lastPosition = root.Position
	local lastProgressAt = os.clock()

	startWalking(target)

	while isJobRunning(job) and os.clock() < deadline do
		if isArrived() then
			break
		end

		local _, currentHumanoid, currentRoot = getCharacterParts()
		if not currentRoot then
			break
		end

		if (currentRoot.Position - lastPosition).Magnitude > 0.5 then
			lastPosition = currentRoot.Position
			lastProgressAt = os.clock()
		elseif os.clock() - lastProgressAt > 0.4 then
			currentHumanoid.Jump = true
			lastProgressAt = os.clock()
		end

		task.wait(0.1)
	end

	stopWalking()

	return isArrived()
end

local function getZoneHitbox(zoneKey)
	local build = workspace:FindFirstChild("Build")
	local zoneHitboxes = build and build:FindFirstChild("ZoneHitboxes")
	local hitbox = zoneHitboxes and zoneHitboxes:FindFirstChild(tostring(zoneKey))
	if hitbox and hitbox:IsA("BasePart") then
		return hitbox
	end

	return nil
end

local function isInsideBox(box, position)
	local localPoint = box.CFrame:PointToObjectSpace(position)
	local halfSize = box.Size / 2

	return math.abs(localPoint.X) <= halfSize.X and math.abs(localPoint.Z) <= halfSize.Z
end

local function isInsideZone(position, zoneIndex)
	local hitbox = getZoneHitbox(zoneIndex)

	return hitbox ~= nil and isInsideBox(hitbox, position)
end

local function findZoneAt(position)
	local zoneIndex = 1

	while true do
		local hitbox = getZoneHitbox(zoneIndex)
		if not hitbox then
			return nil
		end

		if isInsideBox(hitbox, position) then
			return zoneIndex
		end

		zoneIndex += 1
	end
end

local function walkToNeighborZone(job, zoneIndex)
	local zoneHitbox = getZoneHitbox(zoneIndex)
	local _, _, root = getCharacterParts()
	if not (zoneHitbox and root) then
		return false
	end

	local rootInBox = zoneHitbox.CFrame:PointToObjectSpace(root.Position)
	local nearEnd = if rootInBox.X >= 0 then 1 else -1
	local entryDepth = math.max(zoneHitbox.Size.X / 2 - 20, 0)
	local entryPoint = zoneHitbox.CFrame:PointToWorldSpace(Vector3.new(nearEnd * entryDepth, 0, 0))
	local corridorZ = entryPoint.Z

	local function isInTargetZone()
		local _, _, currentRoot = getCharacterParts()
		return currentRoot ~= nil and isInsideZone(currentRoot.Position, zoneIndex)
	end

	if math.abs(root.Position.Z - corridorZ) > 12 then
		walkUntil(job, Vector3.new(root.Position.X, root.Position.Y, corridorZ), function()
			local _, _, currentRoot = getCharacterParts()
			return currentRoot ~= nil and math.abs(currentRoot.Position.Z - corridorZ) <= 4
		end)
	end

	return walkUntil(job, entryPoint, isInTargetZone)
end

local function findGroundY(zoneIndex, x, z)
	local build = workspace:FindFirstChild("Build")
	local zoneBuilds = build and build:FindFirstChild("ZoneBuilds")
	local zoneBuild = zoneBuilds and zoneBuilds:FindFirstChild(`Zone{zoneIndex}`)

	local floors = nil
	if zoneBuild and zoneFloor then
		local read, result = pcall(zoneFloor.Of, zoneBuild)
		if read and type(result) == "table" and #result > 0 then
			floors = result
		end
	end

	local params = RaycastParams.new()
	if floors then
		params.FilterType = Enum.RaycastFilterType.Include
		params.FilterDescendantsInstances = floors
	else
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {localPlayer.Character}
	end

	local result = workspace:Raycast(Vector3.new(x, 200, z), Vector3.new(0, -400, 0), params)

	return result and result.Position.Y or nil
end

local function findTreadmillHitbox()
	local plot = findOwnedPlot()
	if not plot then
		return nil
	end

	for _, child in plot:GetChildren() do
		local hitbox = string.find(child.Name, "Treadmill") and child:FindFirstChild("Hitbox")
		if hitbox and hitbox:IsA("BasePart") then
			return hitbox
		end
	end

	return nil
end

local function respawnAtBase(job)
	local character, humanoid = getCharacterParts()
	if not humanoid or not isJobRunning(job) then
		return false
	end

	humanoid.Health = 0

	return waitUntil(job, 15, function()
		local newCharacter = getCharacterParts()
		return newCharacter ~= nil and newCharacter ~= character
	end)
end

local function rideTreadmill(job)
	if not isJobRunning(job) then
		return false, "Stopped"
	end

	local hitbox = findTreadmillHitbox()
	local _, _, root = getCharacterParts()
	if not (hitbox and root and treadmillRemote) then
		return false, "No Treadmill"
	end

	local startPosition = root.Position
	local hasSession = root.Anchored
	local hasEnded = false
	local sessionConnection = treadmillRemote.OnClientEvent:Connect(function(value)
		if typeof(value) == "number" then
			hasSession = true
			hasEnded = false
		else
			hasEnded = true
		end
	end)

	local function leaveSession()
		treadmillRemote:FireServer()

		local deadline = os.clock() + 3
		while not (hasEnded and not root.Anchored) and os.clock() < deadline do
			task.wait(0.05)
		end

		return hasEnded and not root.Anchored
	end

	local function finish(succeeded, reason)
		sessionConnection:Disconnect()
		return succeeded, reason
	end

	if not hasSession then
		teleportRoot(root, hitbox.Position)
		waitUntil(job, 5, function()
			return hasSession
		end)
	end

	if not isJobRunning(job) then
		if not hasSession then
			teleportRoot(root, startPosition)
			task.wait(0.4)
		end

		if hasSession or root.Anchored then
			leaveSession()
		end

		return finish(false, "Stopped")
	end

	if not hasSession then
		return finish(false, "No Treadmill Session")
	end

	task.wait(0.15)

	local leftTreadmill = leaveSession()
	if not isJobRunning(job) then
		return finish(false, "Stopped")
	end

	if not leftTreadmill then
		return finish(false, "Still On Treadmill")
	end

	return finish(true)
end

local function travelToZone(job, zoneIndex)
	local zoneHitbox = getZoneHitbox(zoneIndex)
	if not zoneHitbox then
		return false, "No Zone Hitbox"
	end

	local _, _, root = getCharacterParts()
	if not root then
		return false, "No Character"
	end

	local currentZone = findZoneAt(root.Position)
	if currentZone and math.abs(currentZone - zoneIndex) == 1 then
		if walkToNeighborZone(job, zoneIndex) then
			return true, "Walk"
		end

		if not isJobRunning(job) then
			return false, "Stopped"
		end

		writeLog(`[Break] Walk To {zoneNames[zoneIndex] or zoneIndex} Failed | Using Treadmill`)

		_, _, root = getCharacterParts()
		if not root then
			return false, "No Character"
		end
	end

	local safeZone = getZoneHitbox("SafeZone")
	local isAtBase = safeZone ~= nil and isInsideBox(safeZone, root.Position)
	if not isAtBase and not respawnAtBase(job) then
		return false, "Respawn Failed"
	end

	local rode, reason = rideTreadmill(job)
	if not rode then
		return false, reason
	end

	_, _, root = getCharacterParts()
	if not root then
		return false, "No Character"
	end

	if not isJobRunning(job) then
		return false, "Stopped"
	end

	local center = zoneHitbox.Position
	local groundY = findGroundY(zoneIndex, center.X, center.Z) or (center.Y - zoneHitbox.Size.Y / 2)
	teleportRoot(root, Vector3.new(center.X, groundY + 3.5, center.Z))
	task.wait(0.5)

	if not isInsideZone(root.Position, zoneIndex) then
		return false, "Pulled Back"
	end

	return true, "Treadmill"
end

local function getHitRange()
	local hitRange = eggConfig and eggConfig.HitRange
	if type(hitRange) == "number" then
		return hitRange
	end

	return 8
end

local function getHitInterval()
	local swingCooldown = pickaxeConfig and pickaxeConfig.SwingCooldown
	local cooldownFactor = eggConfig and eggConfig.HitCooldownFactor
	if type(swingCooldown) ~= "number" or type(cooldownFactor) ~= "number" then
		return 0.5
	end

	local swingMultiplier = 1
	if robuxShopConfig and type(robuxShopConfig.SwingMultiplierFor) == "function" then
		local read, value = pcall(robuxShopConfig.SwingMultiplierFor, localPlayer)
		if read and type(value) == "number" and value > 0 then
			swingMultiplier = value
		end
	end

	return swingCooldown * cooldownFactor / swingMultiplier
end

local function pickEgg(zoneIndex, rootPosition, isAllowed)
	local now = os.clock()

	for egg, skipUntil in state.skippedEggs do
		if skipUntil <= now or egg.Parent == nil then
			state.skippedEggs[egg] = nil
		end
	end

	local bestEgg, bestLuck, bestDistance = nil, -math.huge, math.huge

	for _, egg in CollectionService:GetTagged(eggTargeting.Tag) do
		if not egg:IsA("BasePart") or egg:GetAttribute("ZoneIndex") ~= zoneIndex then
			continue
		end

		if state.skippedEggs[egg] or not eggTargeting.IsLive(egg) then
			continue
		end

		if isAllowed and not isAllowed(egg) then
			continue
		end

		local luck = tonumber(egg:GetAttribute("HatchLuck")) or 0
		local distance = (egg.Position - rootPosition).Magnitude
		if luck > bestLuck or (luck == bestLuck and distance < bestDistance) then
			bestEgg, bestLuck, bestDistance = egg, luck, distance
		end
	end

	return bestEgg
end

local function getStandPoint(egg, rootPosition)
	local flatOffset = Vector3.new(rootPosition.X - egg.Position.X, 0, rootPosition.Z - egg.Position.Z)
	local direction = Vector3.xAxis
	if flatOffset.Magnitude > 0.1 then
		direction = flatOffset.Unit
	end

	local radius = math.max(egg.Size.X, egg.Size.Z) / 2

	return egg.Position + direction * (radius + 3)
end

local function isInHitRange(egg)
	local _, _, root = getCharacterParts()

	return root ~= nil and eggTargeting.SurfaceDistance(egg, root.Position) <= getHitRange() - 2
end

local function approachEgg(job, egg)
	if isInHitRange(egg) then
		return true
	end

	local _, _, root = getCharacterParts()
	if not root then
		return false
	end

	walkUntil(job, getStandPoint(egg, root.Position), function()
		return isInHitRange(egg) or not eggTargeting.IsLive(egg)
	end)

	if isInHitRange(egg) then
		return true
	end

	_, _, root = getCharacterParts()
	if not (root and isJobRunning(job) and eggTargeting.IsLive(egg)) then
		return false
	end

	local standPoint = getStandPoint(egg, root.Position)
	if (standPoint - root.Position).Magnitude > maxHopDistance then
		return false
	end

	teleportRoot(root, Vector3.new(standPoint.X, root.Position.Y, standPoint.Z), egg.Position)
	task.wait(0.25)

	return isInHitRange(egg)
end

local function equipPickaxe(character, humanoid)
	local toolName = pickaxeConfig and pickaxeConfig.ToolName or "Pickaxe"
	if character:FindFirstChild(toolName) then
		return true
	end

	local tool = localPlayer.Backpack:FindFirstChild(toolName)
	if not tool then
		return false
	end

	humanoid:EquipTool(tool)

	return true
end

local function releaseConnection(connection)
	connection:Disconnect()

	local index = table.find(state.connections, connection)
	if index then
		table.remove(state.connections, index)
	end
end

local function isCarrying()
	return localPlayer:GetAttribute("Carrying") ~= nil
end

local function isRagdolled()
	local character = localPlayer.Character
	return character ~= nil and character:GetAttribute("Ragdolled") == true
end

local function findGroundPoint(x, z, fallbackY)
	local zoneIndex = findZoneAt(Vector3.new(x, 0, z))
	local groundY = zoneIndex and findGroundY(zoneIndex, x, z)

	return Vector3.new(x, (groundY or fallbackY) + 3, z)
end

local function flatDistance(first, second)
	return Vector3.new(first.X - second.X, 0, first.Z - second.Z).Magnitude
end

local function getPickupCenter(pickup)
	local center = pickup:GetBoundingBox()
	return center.Position
end

local function getPickupIncome(pickup)
	if not (eggRewards and type(eggRewards.PlacedCashPerSecond) == "function") then
		return nil
	end

	local read, income = pcall(
		eggRewards.PlacedCashPerSecond,
		pickup:GetAttribute("AnimalName"),
		pickup:GetAttribute("SizeMult"),
		pickup:GetAttribute("Mutation"),
		pickup:GetAttribute("WeightKg"),
		pickup:GetAttribute("Variant")
	)

	if read and type(income) == "number" then
		return income
	end

	return nil
end

local function getPickupTimeLeft(pickup)
	local despawnAt = pickup:GetAttribute("DespawnAtServerTime")
	if type(despawnAt) ~= "number" then
		return 0
	end

	return despawnAt - workspace:GetServerTimeNow()
end

local function isReservedForOther(instance)
	local reservedFor = instance:GetAttribute("ReservedUserId")
	return reservedFor ~= nil and reservedFor ~= localPlayer.UserId
end

local function isWantedPickup(pickup)
	if pickup:GetAttribute("Despawning") or isReservedForOther(pickup) then
		return false
	end

	if state.isPetIndexOn then
		local animalName = pickup:GetAttribute("AnimalName")
		return type(state.indexState) == "table" and type(animalName) == "string" and state.indexState[animalName] == nil
	end

	if next(state.farmRarities) ~= nil and not state.farmRarities[pickup:GetAttribute("Rarity")] then
		return false
	end

	local weight = tonumber(pickup:GetAttribute("WeightKg")) or 0
	if weight < state.minPetKg then
		return false
	end

	if state.minPetIncome > 0 then
		local income = getPickupIncome(pickup)
		if not income or income < state.minPetIncome then
			return false
		end
	end

	return true
end

local function isGuardBusy(zoneId)
	for _, guard in CollectionService:GetTagged("ZoneGuard") do
		local chaseState = guard:GetAttribute("ChaseState")
		if guard:GetAttribute("ZoneId") == zoneId and (chaseState == "WindUp" or chaseState == "Chasing") then
			return true
		end
	end

	return false
end

local function findCatchingGuard(zoneId, position)
	local bestGuard, bestScore = nil, math.huge

	for _, guard in CollectionService:GetTagged("ZoneGuard") do
		local score = (guard:GetPivot().Position - position).Magnitude
		if guard:GetAttribute("ZoneId") ~= zoneId then
			score += 1e6
		end

		if score < bestScore then
			bestGuard, bestScore = guard, score
		end
	end

	return bestGuard
end

local function readPromptWeight(prompt)
	local token = string.match(prompt.ObjectText, "%[([%d%.,]+%a?)[Kk]g%]")

	return token and parseAmount(token)
end

local function collectStealPrompts()
	local prompts = {}

	for _, anchor in workspace:GetChildren() do
		if anchor.Name == "PromptAnchor" and anchor:IsA("BasePart") then
			local prompt = anchor:FindFirstChild("StealPrompt")
			if prompt and prompt:IsA("ProximityPrompt") then
				table.insert(prompts, prompt)
			end
		end
	end

	return prompts
end

local function matchStealPrompt(pickup, prompts)
	local center = getPickupCenter(pickup)
	local weight = tonumber(pickup:GetAttribute("WeightKg")) or 0
	local bestPrompt, bestScore = nil, math.huge

	for _, prompt in prompts do
		local distance = (prompt.Parent.Position - center).Magnitude
		if distance > 15 then
			continue
		end

		local score = distance
		local shownWeight = readPromptWeight(prompt)
		if not (shownWeight and math.abs(shownWeight - weight) <= math.max(0.6, weight * 0.01)) then
			score += 50
		end

		if score < bestScore then
			bestPrompt, bestScore = prompt, score
		end
	end

	return bestPrompt
end

local function findStealPrompt(pickup)
	return matchStealPrompt(pickup, collectStealPrompts())
end

local function countPets()
	local count = 0

	local function countIn(container)
		if not container then
			return
		end

		for _, tool in container:GetChildren() do
			if CollectionService:HasTag(tool, "AnimalTool") then
				count += 1
			end
		end
	end

	countIn(localPlayer:FindFirstChild("Backpack"))
	countIn(localPlayer.Character)

	return count
end

local function updatePetsFull()
	local maxPets = petInventoryConfig and petInventoryConfig.MaxPets
	if type(maxPets) ~= "number" then
		return false
	end

	local isFull = countPets() >= maxPets

	if isFull and not state.isPetsFull then
		writeLog(`[Pet] Pets Full | {maxPets} | Taking Paused`)

		if window then
			window:Notify({Title = "Farm", Text = `Take Pet Paused: Pets Full ({maxPets})`, Error = true})
		end
	elseif state.isPetsFull and not isFull then
		writeLog("[Pet] Pets Have Room | Taking Resumed")
	end

	state.isPetsFull = isFull

	return isFull
end

local function findBestPickup(zoneIndex, ignoreTravelTime)
	if type(fireproximityprompt) ~= "function" or updatePetsFull() then
		return nil
	end

	local _, humanoid, root = getCharacterParts()
	if not root then
		return nil
	end

	local zoneId = `Zone{zoneIndex}`
	if isGuardBusy(zoneId) then
		return nil
	end

	local now = os.clock()
	for pickup, skipUntil in state.skippedPickups do
		if skipUntil <= now or pickup.Parent == nil then
			state.skippedPickups[pickup] = nil
		end
	end

	local bestPickup, bestIncome = nil, -math.huge
	local prompts = collectStealPrompts()

	for _, pickup in CollectionService:GetTagged("AnimalPickup") do
		if pickup.Parent == nil or pickup:GetAttribute("ZoneId") ~= zoneId then
			continue
		end

		if state.skippedPickups[pickup] or not isWantedPickup(pickup) then
			continue
		end

		local prompt = matchStealPrompt(pickup, prompts)
		if prompt and not prompt.Enabled then
			continue
		end

		local requiredTimeLeft = 3
		if not ignoreTravelTime then
			local distance = flatDistance(getPickupCenter(pickup), root.Position)
			requiredTimeLeft = distance / math.max(humanoid.WalkSpeed, 16) + 2.5
		end

		if getPickupTimeLeft(pickup) > requiredTimeLeft then
			local income = getPickupIncome(pickup) or 0
			if income > bestIncome then
				bestPickup, bestIncome = pickup, income
			end
		end
	end

	return bestPickup
end

local function describePickup(pickup)
	local name = pickup:GetAttribute("AnimalName") or pickup.Name
	local weightText = string.format("%.1f", tonumber(pickup:GetAttribute("WeightKg")) or 0)

	return `{name} | {pickup:GetAttribute("Rarity")} | {weightText} Kg | ${formatAmount(getPickupIncome(pickup) or 0)}/s`
end

local function waitForBank(job, bankCountBefore, timeout)
	waitUntil(job, timeout, function()
		return state.bankCount > bankCountBefore or not isCarrying()
	end)

	if state.bankCount == bankCountBefore and not isCarrying() then
		waitUntil(job, 1, function()
			return state.bankCount > bankCountBefore
		end)
	end

	return state.bankCount > bankCountBefore
end

local function rememberCarriedPet(pickup)
	state.carriedPet = {
		name = pickup:GetAttribute("AnimalName") or pickup.Name,
		weight = tonumber(pickup:GetAttribute("WeightKg")) or 0,
		zoneId = pickup:GetAttribute("ZoneId"),
	}
end

local function firePromptUntilCarrying(job, pickup, timeLimit, retryGap)
	local deadline = os.clock() + timeLimit
	local disabledSince = nil

	while isJobRunning(job) and pickup.Parent and not isCarrying() and os.clock() < deadline do
		local prompt = findStealPrompt(pickup)

		if prompt and prompt.Enabled then
			disabledSince = nil
			fireproximityprompt(prompt)
			waitUntil(job, retryGap, isCarrying)
		else
			if prompt then
				disabledSince = disabledSince or os.clock()
				if os.clock() - disabledSince > 0.6 then
					return false, "Prompt Disabled"
				end
			end

			task.wait(0.1)
		end
	end

	if isCarrying() then
		return true
	end

	return false, "No Carry"
end

local function approachPickup(job, pickup)
	local function isNear()
		local _, _, root = getCharacterParts()
		return root ~= nil and pickup.Parent ~= nil and flatDistance(getPickupCenter(pickup), root.Position) <= 5
	end

	if isNear() then
		return true
	end

	walkUntil(job, getPickupCenter(pickup), function()
		return isNear() or pickup.Parent == nil
	end)

	if isNear() then
		return true
	end

	local _, _, root = getCharacterParts()
	if not (root and isJobRunning(job) and pickup.Parent) then
		return false
	end

	local center = getPickupCenter(pickup)
	if flatDistance(center, root.Position) > maxHopDistance then
		return false
	end

	teleportRoot(root, findGroundPoint(center.X + 3, center.Z, root.Position.Y - 3), center)
	task.wait(0.25)

	return isNear()
end

local function startHold(target)
	local hold = {target = target}

	hold.connection = trackConnection(RunService.Heartbeat:Connect(function()
		local _, _, root = getCharacterParts()
		if root and (root.Position - hold.target).Magnitude > 3 then
			teleportRoot(root, hold.target)
		end
	end))

	return hold
end

local function followGuardUntilCaught(job, guard)
	local startedAt = os.clock()
	local guardStateAtStart = tostring(guard:GetAttribute("ChaseState"))
	local isCaught = false
	state.activity = "Following Guard"

	local flingConnection = trackConnection(catchFlingRemote.OnClientEvent:Connect(function(action)
		if action == "fling" then
			isCaught = true
		end
	end))

	local followConnection = trackConnection(RunService.Heartbeat:Connect(function()
		local _, _, root = getCharacterParts()
		if isCaught or not root or guard.Parent == nil then
			return
		end

		local guardPosition = guard:GetPivot().Position
		teleportRoot(root, findGroundPoint(guardPosition.X, guardPosition.Z, guardPosition.Y))
	end))

	waitUntil(job, 4, function()
		return isCaught or not isCarrying()
	end)

	releaseConnection(followConnection)
	releaseConnection(flingConnection)

	local isDone = isCaught or not isCarrying()
	if isDone then
		writeLog(`[Pet] Caught After {string.format("%.1f", os.clock() - startedAt)} s | Guard Was {guardStateAtStart}`)
	end

	return isDone
end

local function findDroppedPet(carriedPet)
	local _, _, root = getCharacterParts()
	local bestPickup, bestDistance = nil, math.huge

	for _, pickup in CollectionService:GetTagged("AnimalPickup") do
		local name = pickup:GetAttribute("AnimalName") or pickup.Name
		local weight = tonumber(pickup:GetAttribute("WeightKg")) or 0
		if pickup.Parent == nil or name ~= carriedPet.name then
			continue
		end

		if carriedPet.weight and math.abs(weight - carriedPet.weight) < 0.05 then
			return pickup
		end

		if not carriedPet.weight and root then
			local distance = (getPickupCenter(pickup) - root.Position).Magnitude
			if distance < bestDistance then
				bestPickup, bestDistance = pickup, distance
			end
		end
	end

	return bestPickup
end

local function retakeDroppedPet(job, carriedPet)
	local deadline = os.clock() + 2.6

	while isJobRunning(job) and not isCarrying() and os.clock() < deadline do
		local pickup = findDroppedPet(carriedPet)
		local _, _, root = getCharacterParts()

		if pickup and root then
			local center = getPickupCenter(pickup)
			teleportRoot(root, findGroundPoint(center.X, center.Z, center.Y))
			task.wait()
			firePromptUntilCarrying(job, pickup, 0.35, 0.35)
		else
			task.wait(0.05)
		end
	end

	return isCarrying()
end

local function hitEggsWhileRagdolled(job, hold, zoneIndex)
	local egg = nil
	local inRangeSince = nil
	local hits = 0
	local deadline = os.clock() + 6

	while isJobRunning(job) and isRagdolled() and state.farmZone == zoneIndex and os.clock() < deadline do
		if not (egg and eggTargeting.IsLive(egg)) then
			egg = pickEgg(zoneIndex, hold.target)
			inRangeSince = nil

			if not egg then
				task.wait(0.1)
				continue
			end

			local standPoint = getStandPoint(egg, hold.target)
			hold.target = findGroundPoint(standPoint.X, standPoint.Z, egg.Position.Y)
		end

		local character, humanoid = getCharacterParts()
		if character and isInHitRange(egg) then
			inRangeSince = inRangeSince or os.clock()

			if os.clock() - inRangeSince >= 0.25 and equipPickaxe(character, humanoid) then
				state.nextHitId += 1
				eggHitRemote:FireServer(egg, state.nextHitId)
				hits += 1
			end
		end

		task.wait(getHitInterval())
	end

	return hits
end

local function bankByGuardCatch(job, zoneIndex)
	local plot = findOwnedPlot()
	local _, _, root = getCharacterParts()

	if not state.carriedPet and isCarrying() and root then
		local currentZone = findZoneAt(root.Position)
		state.carriedPet = {
			name = tostring(localPlayer:GetAttribute("Carrying")),
			weight = nil,
			zoneId = currentZone and `Zone{currentZone}`,
		}
	end

	local carriedPet = state.carriedPet
	if not (carriedPet and plot and root and catchFlingRemote) then
		return false, "Not Ready"
	end

	local guard = findCatchingGuard(carriedPet.zoneId, root.Position)
	if not guard then
		return false, "No Guard"
	end

	if not followGuardUntilCaught(job, guard) then
		return false, "Not Caught"
	end

	local plotTarget = plot:GetPivot().Position + Vector3.new(0, 3, 0)
	local bankCountBefore = state.bankCount
	local isBanked = false
	local hold = nil
	local retakes = 0

	while retakes < 3 and isJobRunning(job) do
		state.activity = "Retaking Pet"
		if not retakeDroppedPet(job, carriedPet) then
			break
		end

		retakes += 1
		state.activity = "Holding At Plot"
		hold = startHold(plotTarget)
		isBanked = waitForBank(job, bankCountBefore, 4)

		if isBanked or isCarrying() then
			break
		end

		releaseConnection(hold.connection)
		hold = nil
	end

	if retakes > 1 then
		writeLog(`[Pet] Retook {carriedPet.name} {retakes} Times`)
	end

	if not hold then
		if retakes == 0 then
			return false, "Retake Failed"
		end

		return false, "Dropped Again"
	end

	if isBanked then
		state.carriedPet = nil
	end

	local nextPickup = nil

	if isBanked and isJobRunning(job) and isRagdolled() and state.farmZone == zoneIndex then
		nextPickup = findBestPickup(zoneIndex, true)

		if nextPickup then
			state.activity = "Waiting Next Pet"
			local center = getPickupCenter(nextPickup)
			hold.target = findGroundPoint(center.X + 3, center.Z, center.Y)
			waitUntil(job, 6, function()
				return not isRagdolled()
			end)
		else
			state.activity = "Ragdoll Hits"
			local zoneHitbox = getZoneHitbox(zoneIndex)
			if zoneHitbox then
				local center = zoneHitbox.Position
				hold.target = findGroundPoint(center.X, center.Z, center.Y - zoneHitbox.Size.Y / 2)
			end

			local ragdollHits = hitEggsWhileRagdolled(job, hold, zoneIndex)
			if ragdollHits > 0 then
				writeLog(`[Pet] Ragdoll Hits | {ragdollHits}`)
			end
		end
	end

	releaseConnection(hold.connection)

	local canGrabNext = nextPickup ~= nil
		and nextPickup.Parent ~= nil
		and isJobRunning(job)
		and not isGuardBusy(nextPickup:GetAttribute("ZoneId"))

	if canGrabNext and firePromptUntilCarrying(job, nextPickup, 1, 0.15) then
		rememberCarriedPet(nextPickup)
		writeLog(`[Pet] Take {describePickup(nextPickup)} | After Ragdoll`)
	end

	if isBanked then
		return true, "Banked"
	end

	return false, "Not Banked"
end

local function walkHome(job)
	local plot = findOwnedPlot()
	local plotHitbox = plot and plot:FindFirstChild("Hitbox")
	local _, _, root = getCharacterParts()
	if not (plotHitbox and root) then
		return false
	end

	state.activity = "Walking Home"
	local bankCountBefore = state.bankCount

	local function isDone()
		return state.bankCount > bankCountBefore or not isCarrying()
	end

	if math.abs(root.Position.Z - plotHitbox.Position.Z) > 12 then
		walkUntil(job, Vector3.new(root.Position.X, root.Position.Y, plotHitbox.Position.Z), function()
			local _, _, currentRoot = getCharacterParts()
			return isDone() or (currentRoot ~= nil and math.abs(currentRoot.Position.Z - plotHitbox.Position.Z) <= 4)
		end)
	end

	walkUntil(job, plotHitbox.Position, isDone)

	return waitForBank(job, bankCountBefore, 3)
end

local function bringPetHome(job, zoneIndex)
	local carriedName = state.carriedPet and state.carriedPet.name or tostring(localPlayer:GetAttribute("Carrying"))
	local startedAt = os.clock()

	local isBanked, reason = bankByGuardCatch(job, zoneIndex)
	if not isJobRunning(job) then
		return
	end

	if isBanked then
		writeLog(`[Pet] Banked {carriedName} | Guard | {string.format("%.1f", os.clock() - startedAt)} s`)
		return
	end

	if not isCarrying() then
		state.carriedPet = nil
		writeLog(`[Pet] Lost {carriedName} | {reason}`)
		return
	end

	writeLog(`[Pet] Guard Bank {carriedName} Failed: {reason} | Walking Home`)

	if walkHome(job) then
		state.carriedPet = nil
		writeLog(`[Pet] Banked {carriedName} | Walk | {string.format("%.1f", os.clock() - startedAt)} s`)
	elseif isJobRunning(job) then
		writeLog(`[Pet] Bank {carriedName} Failed: Walk Home`)
	end
end

local function takePet(job, pickup)
	local description = describePickup(pickup)
	state.activity = "Taking Pet"

	if not approachPickup(job, pickup) then
		if isJobRunning(job) then
			state.skippedPickups[pickup] = os.clock() + 10
			writeLog(`[Pet] Take {description} Failed: Unreachable`)
		end

		return false
	end

	local isTaken, failure = firePromptUntilCarrying(job, pickup, 3, 0.6)
	if not isTaken then
		if isJobRunning(job) then
			if failure == "Prompt Disabled" then
				state.skippedPickups[pickup] = os.clock() + 5
			else
				state.skippedPickups[pickup] = os.clock() + 60
			end

			local prompt = pickup.Parent and findStealPrompt(pickup)
			local promptDetail = "No Prompt"
			if prompt then
				local shownText = string.gsub(prompt.ObjectText, "<[^>]+>", "")
				local promptDistance = (prompt.Parent.Position - getPickupCenter(pickup)).Magnitude
				promptDetail = `{shownText} | {string.format("%.1f", promptDistance)} Studs | Enabled {prompt.Enabled} | Reserved {tostring(prompt:GetAttribute("ReservedUserId"))}`
			end

			writeLog(`[Pet] Take {description} Failed: {failure} | {promptDetail} | Pickup Reserved {tostring(pickup:GetAttribute("ReservedUserId"))}`)
		end

		return false
	end

	rememberCarriedPet(pickup)
	writeLog(`[Pet] Take {description}`)

	return true
end

local function breakEgg(job, egg, zoneIndex)
	local hits = 0
	local lastHealth = egg:GetAttribute("Health")
	local lastDamageAt = os.clock()

	while isJobRunning(job) and state.farmZone == zoneIndex and eggTargeting.IsLive(egg) and not state.eventOwner do
		if findBestPickup(zoneIndex, false) then
			return "Pet Ready", hits
		end

		if not approachEgg(job, egg) then
			return "Unreachable", hits
		end

		local character, humanoid = getCharacterParts()
		if not (character and equipPickaxe(character, humanoid)) then
			return "No Pickaxe", hits
		end

		state.nextHitId += 1
		eggHitRemote:FireServer(egg, state.nextHitId)
		hits += 1

		task.wait(getHitInterval())

		local health = egg:GetAttribute("Health")
		if health ~= lastHealth then
			lastHealth = health
			lastDamageAt = os.clock()
		elseif os.clock() - lastDamageAt > 6 then
			return "No Damage", hits
		end
	end

	if not isJobRunning(job) then
		return "Stopped", hits
	end

	if state.farmZone ~= zoneIndex then
		return "Area Changed", hits
	end

	if state.eventOwner then
		return "Event", hits
	end

	return "Done", hits
end

local function listMissingIndexAnimals(zoneIndex)
	local zones = zoneAnimalsConfig and zoneAnimalsConfig.Zones
	local roster = type(zones) == "table" and zones[zoneIndex]
	if type(roster) ~= "table" or type(state.indexState) ~= "table" then
		return nil
	end

	local missing = {}
	for _, animal in roster do
		if type(animal) == "table" and type(animal.Name) == "string" and state.indexState[animal.Name] == nil then
			table.insert(missing, animal.Name)
		end
	end

	return missing
end

local function updatePetIndex(zoneIndex)
	if not state.isPetIndexOn then
		return
	end

	if state.indexState == nil or os.clock() - state.indexRequestedAt > 30 then
		requestIndexState()
	end

	local missing = listMissingIndexAnimals(zoneIndex)
	if missing == nil then
		return
	end

	local areaName = zoneNames[zoneIndex] or tostring(zoneIndex)

	if #missing > 0 then
		if state.indexLoggedZone ~= zoneIndex then
			state.indexLoggedZone = zoneIndex
			writeLog(`[Index] {areaName} Missing {#missing}: {table.concat(missing, ", ")}`)
		end

		return
	end

	window:Notify({Title = "Pet Index", Text = `{areaName} Index Complete`})

	if state.petIndexToggle then
		state.petIndexToggle:Set(false)
	else
		state.isPetIndexOn = false
	end
end

local function runAutoBreak(job)
	if not waitForEarlierRuns(job) then
		if not isJobRunning(job) then
			return
		end

		writeLog("[Break] Previous Run Still Busy | Starting Anyway")
	end

	writeLog(`[Break] Start | {zoneNames[state.farmZone] or state.farmZone}`)

	while isJobRunning(job) do
		local zoneIndex = state.farmZone
		local zoneName = zoneNames[zoneIndex] or tostring(zoneIndex)
		local _, _, root = getCharacterParts()

		if not root then
			task.wait(0.5)
			continue
		end

		if isCarrying() then
			bringPetHome(job, zoneIndex)

			if isJobRunning(job) and isCarrying() then
				task.wait(1)
			end

			continue
		end

		if state.eventOwner then
			state.isBreakPaused = true
			state.activity = "Paused For Event"
			task.wait(0.5)
			continue
		end

		state.isBreakPaused = false
		updatePetIndex(zoneIndex)

		if not isInsideZone(root.Position, zoneIndex) then
			state.activity = "Traveling"
			local travelStartedAt = os.clock()
			local arrived, detail = travelToZone(job, zoneIndex)

			if arrived then
				writeLog(`[Break] Travel {zoneName} | {detail} | {string.format("%.1f", os.clock() - travelStartedAt)} s`)
			elseif isJobRunning(job) then
				writeLog(`[Break] Travel {zoneName} Failed: {detail}`)
				task.wait(3)
			end

			continue
		end

		local pickup = findBestPickup(zoneIndex, false)
		if pickup then
			if takePet(job, pickup) then
				bringPetHome(job, zoneIndex)
			end

			continue
		end

		local egg = pickEgg(zoneIndex, root.Position)
		if not egg then
			state.activity = "Waiting For Eggs"
			task.wait(0.5)
			continue
		end

		local eggType = egg:GetAttribute("EggType")
		local startedAt = os.clock()
		state.activity = "Breaking Egg"
		local result, hits = breakEgg(job, egg, zoneIndex)
		if not isJobRunning(job) then
			break
		end

		if result == "Unreachable" or result == "No Damage" then
			state.skippedEggs[egg] = os.clock() + 15
		elseif result == "No Pickaxe" then
			task.wait(1)
		end

		writeLog(`[Break] {eggType} | {result} | {hits} Hits | {string.format("%.1f", os.clock() - startedAt)} s`)
	end

	stopWalking()
	state.activity = "Idle"
	writeLog("[Break] Stop")
end

local halloween = {
	handlers = {},
	labels = {BloodMoon = "Blood Moon", CandyHeist = "Candy Carnage"},
	scheduleAttribute = "HalloweenScheduleState",
	bloodMoonAttribute = "BloodMoonActive",
	bagAttribute = "CandyHeistBag",
	bagCapacity = 500,
	collectRadius = 10,
	pileTag = "BreakableCandyPile",
	pileCandyByZone = {},
	pileMultipliers = {},
	bossTag = "BloodMoonPumpkinKing",
	bossRange = 42,
	bossAngle = 80,
	bossRoamSpeed = 12,
	lastEscapeTeleportAt = 0,
	potionCollectRadius = 30,
	phantomRunAttribute = "DisguisedEggRun",
	phantomEndAttribute = "DisguisedEggEndsAt",
	phantomCandyByZone = {},
	doorTag = "BreakableHalloweenDoor",
	treatOutcomes = {Candy = true, Damage = true, Cash = true, WalkSpeed = true},
	lastScheduleText = "",
}

halloween.labels.DisguisedEggs = "Phantom Eggs"
halloween.labels.TrickOrTreat = "House of Horrors"

if type(halloweenConfig) == "table" then
	local schedule = halloweenConfig.Schedule
	local heist = halloweenConfig.CandyHeist
	local bloodMoon = halloweenConfig.BloodMoon
	local boss = type(bloodMoon) == "table" and bloodMoon.Pumpkin
	local candyDrops = halloweenConfig.CandyDrops
	local disguisedEggs = halloweenConfig.DisguisedEggs
	local rewards = halloweenConfig.Rewards
	local trickOrTreat = halloweenConfig.TrickOrTreat

	if type(schedule) == "table" and type(schedule.Labels) == "table" then
		halloween.scheduleAttribute = schedule.StateAttribute or halloween.scheduleAttribute

		for key, label in schedule.Labels do
			if type(label) == "string" then
				halloween.labels[key] = label
			end
		end
	end

	if type(candyDrops) == "table" then
		halloween.potionCollectRadius = tonumber(candyDrops.PotionCollectRadius) or halloween.potionCollectRadius
	end

	if type(disguisedEggs) == "table" then
		halloween.phantomRunAttribute = disguisedEggs.RunAttribute or halloween.phantomRunAttribute
		halloween.phantomEndAttribute = disguisedEggs.EndAttribute or halloween.phantomEndAttribute
	end

	if type(rewards) == "table" and type(rewards.DisguisedEggs) == "table" and type(rewards.DisguisedEggs.CandyCornByZone) == "table" then
		halloween.phantomCandyByZone = rewards.DisguisedEggs.CandyCornByZone
	end

	if type(trickOrTreat) == "table" then
		halloween.doorTag = trickOrTreat.Tag or halloween.doorTag

		if type(trickOrTreat.Outcomes) == "table" then
			halloween.treatOutcomes = {}
			for name, outcome in trickOrTreat.Outcomes do
				if type(outcome) == "table" and outcome.Treat == true then
					halloween.treatOutcomes[name] = true
				end
			end
		end
	end

	if type(heist) == "table" then
		halloween.bagAttribute = heist.BagAttribute or halloween.bagAttribute
		halloween.bagCapacity = tonumber(heist.Capacity) or halloween.bagCapacity
		halloween.collectRadius = tonumber(heist.CollectRadius) or halloween.collectRadius
		halloween.pileTag = heist.PileTag or halloween.pileTag

		if type(heist.PileCandyByZone) == "table" then
			halloween.pileCandyByZone = heist.PileCandyByZone
		end

		for _, variant in type(heist.PileVariants) == "table" and heist.PileVariants or {} do
			if type(variant) == "table" and type(variant.Label) == "string" then
				halloween.pileMultipliers[variant.Label] = tonumber(variant.CandyMultiplier) or 1
			end
		end
	end

	if type(bloodMoon) == "table" then
		halloween.bloodMoonAttribute = bloodMoon.ActiveAttribute or halloween.bloodMoonAttribute
	end

	if type(boss) == "table" then
		halloween.bossTag = boss.Tag or halloween.bossTag
		halloween.bossRange = tonumber(boss.Range) or halloween.bossRange
		halloween.bossAngle = tonumber(boss.Angle) or halloween.bossAngle
		halloween.bossRoamSpeed = tonumber(boss.RoamSpeed) or halloween.bossRoamSpeed
	end
end

function halloween.readActiveEvent()
	local raw = workspace:GetAttribute(halloween.scheduleAttribute)
	if type(raw) ~= "string" then
		return nil
	end

	local decoded, schedule = pcall(HttpService.JSONDecode, HttpService, raw)
	if not decoded or type(schedule) ~= "table" or type(schedule.Active) ~= "table" then
		return nil
	end

	local now = workspace:GetServerTimeNow()
	for _, event in schedule.Active do
		local endsAt = type(event) == "table" and tonumber(event.EndsAt)
		if endsAt and endsAt > now and halloween.handlers[event.Key] then
			return {key = event.Key, endsAt = endsAt}
		end
	end

	return nil
end

function halloween.describeSchedule()
	local raw = workspace:GetAttribute(halloween.scheduleAttribute)
	if type(raw) ~= "string" then
		return nil
	end

	local decoded, schedule = pcall(HttpService.JSONDecode, HttpService, raw)
	if not decoded or type(schedule) ~= "table" then
		return nil
	end

	local parts = {}
	for _, event in type(schedule.Active) == "table" and schedule.Active or {} do
		local endsAt = type(event) == "table" and tonumber(event.EndsAt)
		if endsAt then
			table.insert(parts, `Active {halloween.labels[event.Key] or tostring(event.Key)} Until {os.date("%H:%M:%S", math.floor(endsAt))}`)
		end
	end

	local nextAt = tonumber(schedule.NextAt)
	if schedule.NextKey and nextAt then
		table.insert(parts, `Next {halloween.labels[schedule.NextKey] or tostring(schedule.NextKey)} At {os.date("%H:%M:%S", math.floor(nextAt))}`)
	end

	if schedule.Paused then
		table.insert(parts, "Paused")
	end

	return table.concat(parts, " | ")
end

function halloween.logScheduleChange()
	local text = halloween.describeSchedule()
	if text and text ~= halloween.lastScheduleText then
		halloween.lastScheduleText = text
		writeLog(`[Event] Schedule | {text}`)
	end
end

function halloween.getTimeLeft(event)
	return event.endsAt - workspace:GetServerTimeNow()
end

function halloween.isEventLive(event)
	if halloween.getTimeLeft(event) <= 0 then
		return false
	end

	return event.key ~= "BloodMoon" or workspace:GetAttribute(halloween.bloodMoonAttribute) ~= false
end

function halloween.hasArea(eventKey)
	local area = state.eventZones[eventKey]
	if type(area) == "table" then
		return next(area) ~= nil
	end

	return area ~= nil
end

function halloween.readBag()
	return tonumber(localPlayer:GetAttribute(halloween.bagAttribute)) or 0
end

function halloween.readCandy()
	return tonumber(localPlayer:GetAttribute("CandyCorn")) or 0
end

function halloween.listBosses()
	local bosses = {}

	for _, model in CollectionService:GetTagged(halloween.bossTag) do
		local root = model:IsA("Model") and model.PrimaryPart
		if root and model:IsDescendantOf(workspace) then
			table.insert(bosses, {
				name = model.Name,
				root = root,
				mode = model:GetAttribute("PumpkinState"),
				targetUserId = model:GetAttribute("TargetUserId"),
			})
		end
	end

	return bosses
end

function halloween.isInBossSight(boss, position, extraRange)
	local bossPosition = boss.root.Position
	local offset = Vector3.new(position.X - bossPosition.X, 0, position.Z - bossPosition.Z)
	if math.abs(position.Y - bossPosition.Y) > 16 or offset.Magnitude > halloween.bossRange + extraRange then
		return false
	end

	if offset.Magnitude < 25 then
		return true
	end

	local look = boss.root.CFrame.LookVector
	local flatLook = Vector3.new(look.X, 0, look.Z)
	if flatLook.Magnitude < 0.01 then
		return true
	end

	local halfAngle = math.rad((halloween.bossAngle + 60) / 2)

	return flatLook.Unit:Dot(offset.Unit) >= math.cos(halfAngle)
end

function halloween.findWatchingBoss(position, bosses, extraRange)
	for _, boss in bosses do
		if halloween.isInBossSight(boss, position, extraRange) then
			return boss
		end
	end

	return nil
end

function halloween.findChasingBoss(bosses)
	for _, boss in bosses do
		local isHunting = boss.mode == "Alerted" or boss.mode == "Pursuing" or boss.mode == "Charging"
		if isHunting and boss.targetUserId == localPlayer.UserId then
			return boss
		end
	end

	return nil
end

function halloween.findBossThreat()
	local _, _, root = getCharacterParts()
	local bosses = halloween.listBosses()

	local chasingBoss = halloween.findChasingBoss(bosses)
	if chasingBoss then
		return "Chased", chasingBoss
	end

	local watchingBoss = root and halloween.findWatchingBoss(root.Position, bosses, 20)
	if watchingBoss then
		return "Boss Near", watchingBoss
	end

	return nil, nil
end

function halloween.isMyDrop(drop)
	return drop.claimUserId == nil or drop.claimUserId == 0 or drop.claimUserId == localPlayer.UserId
end

function halloween.getReachDistance(drop)
	if drop.isPotion then
		return halloween.potionCollectRadius - 3
	end

	return halloween.collectRadius - 3
end

function halloween.isBagFull(drops)
	return drops == state.candyDrops and halloween.readBag() >= halloween.bagCapacity
end

function halloween.findNearestDrop(drops, centre, maxDistance, bosses)
	local now = workspace:GetServerTimeNow()
	local clock = os.clock()
	local bestDrop, bestDistance = nil, maxDistance

	for id, drop in drops do
		if drop.expiresAt <= now then
			drops[id] = nil
			continue
		end

		if drop.skipUntil > clock or not halloween.isMyDrop(drop) then
			continue
		end

		local distance = flatDistance(drop.position, centre)
		if distance < bestDistance and not halloween.findWatchingBoss(drop.position, bosses, 0) then
			bestDrop, bestDistance = drop, distance
		end
	end

	return bestDrop
end

function halloween.collectDrops(job, event, drops, centre, maxDistance)
	while isJobRunning(job) and halloween.isEventLive(event) and not halloween.isBagFull(drops) do
		local _, _, root = getCharacterParts()
		if not root or isRagdolled() then
			return
		end

		if halloween.findBossThreat() then
			return
		end

		local drop = halloween.findNearestDrop(drops, centre or root.Position, maxDistance, halloween.listBosses())
		if not drop then
			return
		end

		state.activity = "Collecting Candy"
		local reachDistance = halloween.getReachDistance(drop)

		local function isReached()
			local _, _, currentRoot = getCharacterParts()
			if currentRoot == nil or drops[drop.id] == nil or halloween.findBossThreat() then
				return true
			end

			return flatDistance(drop.position, currentRoot.Position) <= reachDistance
		end

		walkUntil(job, drop.position, isReached)
		waitUntil(job, 1, function()
			return drops[drop.id] == nil or halloween.findBossThreat() ~= nil
		end)

		drop.skipUntil = os.clock() + 3
	end
end

function halloween.hasNewDropAt(drops, position, since)
	for _, drop in drops do
		if drop.spawnedAt >= since and halloween.isMyDrop(drop) and flatDistance(drop.origin, position) <= 12 then
			return true
		end
	end

	return false
end

function halloween.waitAndCollect(job, event, drops, position, brokenAt, timeout, isNothingComing)
	state.activity = "Waiting For Candy"

	local hasDrops = waitUntil(job, timeout, function()
		if halloween.hasNewDropAt(drops, position, brokenAt) or not halloween.isEventLive(event) then
			return true
		end

		return halloween.findBossThreat() ~= nil or (isNothingComing ~= nil and isNothingComing())
	end)

	if hasDrops and halloween.hasNewDropAt(drops, position, brokenAt) and not halloween.findBossThreat() then
		waitUntil(job, 0.7, function()
			return halloween.findBossThreat() ~= nil
		end)
		halloween.collectDrops(job, event, drops, position, 30)
	end

	return hasDrops
end

function halloween.breakTarget(job, target, event, findStopReason, isAlive, approach)
	local hits = 0
	local lastHealth = target:GetAttribute("Health")
	local lastDamageAt = os.clock()
	isAlive = isAlive or eggTargeting.IsLive
	approach = approach or approachEgg

	while isJobRunning(job) and isAlive(target) do
		if not halloween.isEventLive(event) then
			return "Event Ended", hits
		end

		local stopReason = findStopReason()
		if stopReason then
			return stopReason, hits
		end

		if not approach(job, target) then
			return "Unreachable", hits
		end

		local character, humanoid = getCharacterParts()
		if not (character and equipPickaxe(character, humanoid)) then
			return "No Pickaxe", hits
		end

		state.nextHitId += 1
		eggHitRemote:FireServer(target, state.nextHitId)
		hits += 1

		local nextHitAt = os.clock() + getHitInterval()
		while os.clock() < nextHitAt do
			task.wait(math.min(0.1, nextHitAt - os.clock()))

			local reason = findStopReason()
			if reason then
				return reason, hits
			end
		end

		local health = target:GetAttribute("Health")
		if health ~= lastHealth then
			lastHealth = health
			lastDamageAt = os.clock()
		elseif os.clock() - lastDamageAt > 6 then
			return "No Damage", hits
		end
	end

	if not isJobRunning(job) then
		return "Stopped", hits
	end

	return "Done", hits
end

function halloween.findEscapePoint(root, boss, zoneIndex, bosses)
	local away = Vector3.new(root.Position.X - boss.root.Position.X, 0, root.Position.Z - boss.root.Position.Z)
	if away.Magnitude < 0.1 then
		away = Vector3.xAxis
	end

	local baseAngle = math.atan2(away.Unit.Z, away.Unit.X)

	for _, turn in {0, 45, -45, 90, -90, 135, -135} do
		local angle = baseAngle + math.rad(turn)
		local point = root.Position + Vector3.new(math.cos(angle), 0, math.sin(angle)) * maxHopDistance
		if isInsideZone(point, zoneIndex) and not halloween.findWatchingBoss(point, bosses, 20) then
			local groundY = findGroundY(zoneIndex, point.X, point.Z)
			return Vector3.new(point.X, groundY and groundY + 3.5 or root.Position.Y, point.Z)
		end
	end

	return nil
end

function halloween.escapeBoss(job, boss, zoneIndex)
	local _, _, root = getCharacterParts()
	if not root then
		return
	end

	state.activity = "Escaping Boss"

	local point = halloween.findEscapePoint(root, boss, zoneIndex, halloween.listBosses())
	if not point then
		writeLog(`[Event] Escape {boss.name} Failed: No Safe Point`)
		task.wait(0.3)
		return
	end

	if os.clock() - halloween.lastEscapeTeleportAt < 1.5 then
		walkUntil(job, point, function()
			local _, _, currentRoot = getCharacterParts()
			return currentRoot == nil or flatDistance(currentRoot.Position, point) <= 4 or halloween.findBossThreat() == nil
		end)
		return
	end

	halloween.lastEscapeTeleportAt = os.clock()
	teleportRoot(root, point)
	writeLog(`[Event] Escape {boss.name} | {boss.mode} | {string.format("%.0f", flatDistance(point, boss.root.Position))} Studs Away`)
	task.wait(0.4)
end

function halloween.estimateTripHome()
	local plot = findOwnedPlot()
	local plotHitbox = plot and plot:FindFirstChild("Hitbox")
	local _, humanoid, root = getCharacterParts()
	if not (plotHitbox and humanoid and root) then
		return math.huge
	end

	return flatDistance(root.Position, plotHitbox.Position) / math.max(humanoid.WalkSpeed, 16) + 3
end

function halloween.bankBag(job, event)
	local plot = findOwnedPlot()
	local plotHitbox = plot and plot:FindFirstChild("Hitbox")
	local _, _, root = getCharacterParts()
	if not (plotHitbox and root) then
		return false
	end

	state.activity = "Banking Candy"

	local bag = halloween.readBag()
	local startedAt = os.clock()

	local function isBanked()
		return halloween.readBag() < bag or not halloween.isEventLive(event)
	end

	if math.abs(root.Position.Z - plotHitbox.Position.Z) > 12 then
		walkUntil(job, Vector3.new(root.Position.X, root.Position.Y, plotHitbox.Position.Z), function()
			local _, _, currentRoot = getCharacterParts()
			return isBanked() or (currentRoot ~= nil and math.abs(currentRoot.Position.Z - plotHitbox.Position.Z) <= 4)
		end)
	end

	walkUntil(job, plotHitbox.Position, isBanked)
	local banked = waitUntil(job, 3, isBanked)

	writeLog(`[Event] Bank {bag} Candy | {banked and "Done" or "Failed"} | {string.format("%.1f", os.clock() - startedAt)} s`)

	return banked
end

function halloween.runBloodMoon(job, event)
	local zoneIndex = state.eventZones.BloodMoon
	local candyBefore = halloween.readCandy()
	local eggsBroken = 0

	writeLog(`[Event] Blood Moon Start | {zoneNames[zoneIndex] or zoneIndex} | {string.format("%.0f", halloween.getTimeLeft(event))} s Left`)

	while isJobRunning(job) and halloween.isEventLive(event) do
		zoneIndex = state.eventZones.BloodMoon
		local _, _, root = getCharacterParts()

		if not root or isRagdolled() then
			state.activity = "Waiting For Character"
			task.wait(0.3)
			continue
		end

		if halloween.readBag() >= halloween.bagCapacity and halloween.getTimeLeft(event) > halloween.estimateTripHome() + 10 then
			halloween.bankBag(job, event)
			continue
		end

		if not isInsideZone(root.Position, zoneIndex) then
			state.activity = "Traveling"
			local travelStartedAt = os.clock()
			local arrived, detail = travelToZone(job, zoneIndex)

			if arrived then
				writeLog(`[Event] Travel {zoneNames[zoneIndex] or zoneIndex} | {detail} | {string.format("%.1f", os.clock() - travelStartedAt)} s`)
			elseif isJobRunning(job) then
				writeLog(`[Event] Travel {zoneNames[zoneIndex] or zoneIndex} Failed: {detail}`)
				task.wait(3)
			end

			continue
		end

		local threat, threatBoss = halloween.findBossThreat()
		if threat == "Chased" or (threat and halloween.readBag() > 0) then
			halloween.escapeBoss(job, threatBoss, zoneIndex)
			continue
		end

		halloween.collectDrops(job, event, state.candyDrops, nil, 60)

		_, _, root = getCharacterParts()
		if not root then
			continue
		end

		local bosses = halloween.listBosses()
		local egg = pickEgg(zoneIndex, root.Position, function(candidate)
			return halloween.findWatchingBoss(candidate.Position, bosses, halloween.bossRoamSpeed * 3) == nil
		end)

		if not egg then
			state.activity = "Waiting For Safe Egg"
			task.wait(0.3)
			continue
		end

		local eggType = egg:GetAttribute("EggType")
		local eggPosition = egg.Position
		state.activity = "Breaking Egg"
		local brokenAt = os.clock()
		local result, hits = halloween.breakTarget(job, egg, event, function()
			if state.eventZones.BloodMoon ~= zoneIndex then
				return "Area Changed"
			end

			return (halloween.findBossThreat())
		end)

		if result == "Done" then
			eggsBroken += 1
			halloween.waitAndCollect(job, event, state.candyDrops, eggPosition, brokenAt, 6)
		elseif result == "Boss Near" then
			state.skippedEggs[egg] = os.clock() + 4
		elseif result == "Unreachable" or result == "No Damage" then
			state.skippedEggs[egg] = os.clock() + 15
		elseif result == "No Pickaxe" then
			task.wait(1)
		end

		writeLog(`[Event] {eggType} | {result} | {hits} Hits | Bag {halloween.readBag()}`)
	end

	stopWalking()

	if not isJobRunning(job) then
		writeLog(`[Event] Blood Moon Stopped | {eggsBroken} Eggs | Bag {halloween.readBag()}`)
		return
	end

	waitUntil(job, 5, function()
		return halloween.readBag() == 0
	end)

	writeLog(`[Event] Blood Moon End | {eggsBroken} Eggs | Candy +{halloween.readCandy() - candyBefore}`)
end

halloween.handlers.BloodMoon = halloween.runBloodMoon

function halloween.getPileCandy(pile)
	local baseCandy = halloween.pileCandyByZone[pile:GetAttribute("ZoneIndex")] or 1
	local multiplier = halloween.pileMultipliers[pile:GetAttribute("PileLabel")] or 1

	return baseCandy * multiplier
end

function halloween.pickPile(zoneIndex, rootPosition)
	local now = os.clock()
	local bestPile, bestCandy, bestDistance = nil, -math.huge, math.huge

	for _, pile in CollectionService:GetTagged(halloween.pileTag) do
		if not pile:IsA("BasePart") or pile:GetAttribute("ZoneIndex") ~= zoneIndex then
			continue
		end

		local skipUntil = state.skippedEggs[pile]
		if (skipUntil and skipUntil > now) or not eggTargeting.IsLive(pile) then
			continue
		end

		local candy = halloween.getPileCandy(pile)
		local distance = (pile.Position - rootPosition).Magnitude
		if candy > bestCandy or (candy == bestCandy and distance < bestDistance) then
			bestPile, bestCandy, bestDistance = pile, candy, distance
		end
	end

	return bestPile
end

function halloween.chooseCarnageZone(currentZone)
	local zones = state.eventZones.CandyHeist
	if currentZone and zones[currentZone] and halloween.pickPile(currentZone, Vector3.zero) then
		return currentZone
	end

	local highestSelected = nil
	for zoneIndex = #zoneNames, 1, -1 do
		if zones[zoneIndex] then
			highestSelected = highestSelected or zoneIndex

			if halloween.pickPile(zoneIndex, Vector3.zero) then
				return zoneIndex
			end
		end
	end

	if currentZone and zones[currentZone] then
		return currentZone
	end

	return highestSelected
end

function halloween.travelWithBag(job, zoneIndex)
	local _, _, root = getCharacterParts()
	if not root then
		return false, "No Character"
	end

	local currentZone = findZoneAt(root.Position)
	if halloween.readBag() > 0 and currentZone and currentZone ~= zoneIndex then
		local nextZone = currentZone + (if zoneIndex > currentZone then 1 else -1)
		if walkToNeighborZone(job, nextZone) then
			return true, `Walk {zoneNames[nextZone] or nextZone}`
		end

		return false, "Walk Failed"
	end

	return travelToZone(job, zoneIndex)
end

function halloween.listAreaNames(zones)
	local names = {}
	for zoneIndex = 1, #zoneNames do
		if zones[zoneIndex] then
			table.insert(names, zoneNames[zoneIndex])
		end
	end

	return table.concat(names, ", ")
end

function halloween.runCandyCarnage(job, event)
	local candyBefore = halloween.readCandy()
	local workZone = nil
	local pilesBroken = 0

	writeLog(`[Event] Candy Carnage Start | {halloween.listAreaNames(state.eventZones.CandyHeist)} | {string.format("%.0f", halloween.getTimeLeft(event))} s Left`)

	while isJobRunning(job) and halloween.isEventLive(event) do
		local _, _, root = getCharacterParts()

		if not root or isRagdolled() then
			state.activity = "Waiting For Character"
			task.wait(0.3)
			continue
		end

		if halloween.readBag() >= halloween.bagCapacity and halloween.getTimeLeft(event) > halloween.estimateTripHome() + 10 then
			halloween.bankBag(job, event)
			continue
		end

		workZone = halloween.chooseCarnageZone(workZone)
		if not workZone then
			state.activity = "No Area"
			task.wait(1)
			continue
		end

		if not isInsideZone(root.Position, workZone) then
			state.activity = "Traveling"
			local travelStartedAt = os.clock()
			local arrived, detail = halloween.travelWithBag(job, workZone)

			if arrived then
				writeLog(`[Event] Travel {zoneNames[workZone] or workZone} | {detail} | {string.format("%.1f", os.clock() - travelStartedAt)} s`)
			elseif isJobRunning(job) then
				writeLog(`[Event] Travel {zoneNames[workZone] or workZone} Failed: {detail}`)
				task.wait(3)
			end

			continue
		end

		halloween.collectDrops(job, event, state.candyDrops, nil, 60)

		_, _, root = getCharacterParts()
		if not root then
			continue
		end

		local pile = halloween.pickPile(workZone, root.Position)
		if not pile then
			state.activity = "Waiting For Piles"
			task.wait(0.3)
			continue
		end

		local pileLabel = pile:GetAttribute("PileLabel")
		local pilePosition = pile.Position
		local zoneOfPile = workZone
		state.activity = "Breaking Pile"
		local brokenAt = os.clock()
		local result, hits = halloween.breakTarget(job, pile, event, function()
			if not state.eventZones.CandyHeist[zoneOfPile] then
				return "Area Changed"
			end

			return nil
		end)

		if result == "Done" then
			pilesBroken += 1
			halloween.waitAndCollect(job, event, state.candyDrops, pilePosition, brokenAt, 3)
		elseif result == "Unreachable" or result == "No Damage" then
			state.skippedEggs[pile] = os.clock() + 15
		elseif result == "No Pickaxe" then
			task.wait(1)
		end

		writeLog(`[Event] {pileLabel} | {result} | {hits} Hits | Bag {halloween.readBag()}`)
	end

	stopWalking()

	if not isJobRunning(job) then
		writeLog(`[Event] Candy Carnage Stopped | {pilesBroken} Piles | Bag {halloween.readBag()}`)
		return
	end

	waitUntil(job, 5, function()
		return halloween.readBag() == 0
	end)

	writeLog(`[Event] Candy Carnage End | {pilesBroken} Piles | Candy +{halloween.readCandy() - candyBefore}`)
end

halloween.handlers.CandyHeist = halloween.runCandyCarnage

function halloween.chooseZone(zones, currentZone, hasTarget)
	if currentZone and zones[currentZone] and hasTarget(currentZone) then
		return currentZone
	end

	local highestSelected = nil
	for zoneIndex = #zoneNames, 1, -1 do
		if zones[zoneIndex] then
			highestSelected = highestSelected or zoneIndex

			if hasTarget(zoneIndex) then
				return zoneIndex
			end
		end
	end

	if currentZone and zones[currentZone] then
		return currentZone
	end

	return highestSelected
end

function halloween.travelForEvent(job, zoneIndex)
	state.activity = "Traveling"
	local travelStartedAt = os.clock()
	local arrived, detail = travelToZone(job, zoneIndex)

	if arrived then
		writeLog(`[Event] Travel {zoneNames[zoneIndex] or zoneIndex} | {detail} | {string.format("%.1f", os.clock() - travelStartedAt)} s`)
	elseif isJobRunning(job) then
		writeLog(`[Event] Travel {zoneNames[zoneIndex] or zoneIndex} Failed: {detail}`)
		task.wait(3)
	end
end

function halloween.finishCornEvent(job, label, summary, candyBefore)
	stopWalking()

	if not isJobRunning(job) then
		writeLog(`[Event] {label} Stopped | {summary}`)
		return
	end

	local sweepWindow = {key = "Sweep", endsAt = workspace:GetServerTimeNow() + 15}
	halloween.collectDrops(job, sweepWindow, state.cornDrops, nil, 150)
	stopWalking()

	writeLog(`[Event] {label} End | {summary} | Candy +{halloween.readCandy() - candyBefore}`)
end

function halloween.isPhantomEgg(egg)
	local endsAt = tonumber(egg:GetAttribute(halloween.phantomEndAttribute))
	return egg:GetAttribute(halloween.phantomRunAttribute) ~= nil and endsAt ~= nil and endsAt > workspace:GetServerTimeNow()
end

function halloween.getEggTier(egg)
	local zoneEggs = eggRewards and eggRewards.ZoneEggs
	local zone = type(zoneEggs) == "table" and zoneEggs[`Zone{egg:GetAttribute("ZoneIndex")}`]
	local tier = type(zone) == "table" and type(zone.Eggs) == "table" and table.find(zone.Eggs, egg:GetAttribute("EggType"))

	return tier or 1
end

function halloween.getPhantomCandy(egg)
	local candyByTier = halloween.phantomCandyByZone[egg:GetAttribute("ZoneIndex")]
	if type(candyByTier) ~= "table" then
		return 0
	end

	return candyByTier[halloween.getEggTier(egg)] or candyByTier[1] or 0
end

function halloween.pickPhantomEgg(zoneIndex, rootPosition)
	local now = os.clock()
	local bestEgg, bestCandy, bestDistance = nil, -math.huge, math.huge

	for _, egg in CollectionService:GetTagged(eggTargeting.Tag) do
		if not egg:IsA("BasePart") or egg:GetAttribute("ZoneIndex") ~= zoneIndex or not halloween.isPhantomEgg(egg) then
			continue
		end

		local skipUntil = state.skippedEggs[egg]
		if (skipUntil and skipUntil > now) or not eggTargeting.IsLive(egg) then
			continue
		end

		local candy = halloween.getPhantomCandy(egg)
		local distance = (egg.Position - rootPosition).Magnitude
		if candy > bestCandy or (candy == bestCandy and distance < bestDistance) then
			bestEgg, bestCandy, bestDistance = egg, candy, distance
		end
	end

	return bestEgg
end

function halloween.runPhantomEggs(job, event)
	local candyBefore = halloween.readCandy()
	local workZone = nil
	local eggsBroken = 0

	writeLog(`[Event] Phantom Eggs Start | {halloween.listAreaNames(state.eventZones.DisguisedEggs)} | {string.format("%.0f", halloween.getTimeLeft(event))} s Left`)

	local function hasPhantomEgg(zoneIndex)
		return halloween.pickPhantomEgg(zoneIndex, Vector3.zero) ~= nil
	end

	while isJobRunning(job) and halloween.isEventLive(event) do
		local _, _, root = getCharacterParts()

		if not root or isRagdolled() then
			state.activity = "Waiting For Character"
			task.wait(0.3)
			continue
		end

		workZone = halloween.chooseZone(state.eventZones.DisguisedEggs, workZone, hasPhantomEgg)
		if not workZone then
			state.activity = "No Area"
			task.wait(1)
			continue
		end

		if not isInsideZone(root.Position, workZone) then
			halloween.travelForEvent(job, workZone)
			continue
		end

		halloween.collectDrops(job, event, state.cornDrops, nil, 60)

		_, _, root = getCharacterParts()
		if not root then
			continue
		end

		local egg = halloween.pickPhantomEgg(workZone, root.Position)
		if not egg then
			state.activity = "Waiting For Phantom Eggs"
			task.wait(0.3)
			continue
		end

		local eggType = egg:GetAttribute("EggType")
		local eggPosition = egg.Position
		local zoneOfEgg = workZone
		state.activity = "Breaking Phantom Egg"
		local brokenAt = os.clock()
		local result, hits = halloween.breakTarget(job, egg, event, function()
			if not state.eventZones.DisguisedEggs[zoneOfEgg] then
				return "Area Changed"
			end

			return nil
		end)

		if result == "Done" then
			eggsBroken += 1
			halloween.waitAndCollect(job, event, state.cornDrops, eggPosition, brokenAt, 6)
		elseif result == "Unreachable" or result == "No Damage" then
			state.skippedEggs[egg] = os.clock() + 15
		elseif result == "No Pickaxe" then
			task.wait(1)
		end

		writeLog(`[Event] Phantom {eggType} | {result} | {hits} Hits | Candy {halloween.readCandy()}`)
	end

	halloween.finishCornEvent(job, "Phantom Eggs", `{eggsBroken} Eggs`, candyBefore)
end

halloween.handlers.DisguisedEggs = halloween.runPhantomEggs

function halloween.isNearZone(position, zoneIndex, margin)
	local hitbox = getZoneHitbox(zoneIndex)
	if not hitbox then
		return false
	end

	local localPoint = hitbox.CFrame:PointToObjectSpace(position)
	local halfSize = hitbox.Size / 2

	return math.abs(localPoint.X) <= halfSize.X + margin and math.abs(localPoint.Z) <= halfSize.Z + margin
end

function halloween.isDoorReady(door)
	return door.Parent ~= nil and (tonumber(door:GetAttribute("Health")) or 0) > 0
end

function halloween.pickDoor(zoneIndex, rootPosition)
	local now = os.clock()
	local bestDoor, bestDistance = nil, math.huge

	for _, door in CollectionService:GetTagged(halloween.doorTag) do
		if not door:IsA("BasePart") or door:GetAttribute("ZoneIndex") ~= zoneIndex or not halloween.isDoorReady(door) then
			continue
		end

		local skipUntil = state.skippedEggs[door]
		if skipUntil and skipUntil > now then
			continue
		end

		local distance = (door.Position - rootPosition).Magnitude
		if distance < bestDistance then
			bestDoor, bestDistance = door, distance
		end
	end

	return bestDoor
end

function halloween.approachDoor(job, door)
	if isInHitRange(door) then
		return true
	end

	local knockPosition = door:GetAttribute("KnockPosition")
	if typeof(knockPosition) ~= "Vector3" then
		return approachEgg(job, door)
	end

	local standPoint = knockPosition + Vector3.new(0, 3, 0)
	walkUntil(job, standPoint, function()
		return isInHitRange(door) or not halloween.isDoorReady(door)
	end)

	if isInHitRange(door) then
		return true
	end

	local _, _, root = getCharacterParts()
	if not (root and isJobRunning(job) and halloween.isDoorReady(door)) then
		return false
	end

	if (standPoint - root.Position).Magnitude > maxHopDistance then
		return false
	end

	teleportRoot(root, standPoint, door.Position)
	task.wait(0.25)

	return isInHitRange(door)
end

function halloween.runHouseOfHorrors(job, event)
	local candyBefore = halloween.readCandy()
	local workZone = nil
	local doorsBroken = 0

	writeLog(`[Event] House Of Horrors Start | {halloween.listAreaNames(state.eventZones.TrickOrTreat)} | {string.format("%.0f", halloween.getTimeLeft(event))} s Left`)

	local function hasDoor(zoneIndex)
		return halloween.pickDoor(zoneIndex, Vector3.zero) ~= nil
	end

	while isJobRunning(job) and halloween.isEventLive(event) do
		local _, _, root = getCharacterParts()

		if not root or isRagdolled() then
			state.activity = "Waiting For Character"
			task.wait(0.3)
			continue
		end

		workZone = halloween.chooseZone(state.eventZones.TrickOrTreat, workZone, hasDoor)
		if not workZone then
			state.activity = "No Area"
			task.wait(1)
			continue
		end

		if not halloween.isNearZone(root.Position, workZone, 25) then
			halloween.travelForEvent(job, workZone)
			continue
		end

		halloween.collectDrops(job, event, state.cornDrops, nil, 60)

		_, _, root = getCharacterParts()
		if not root then
			continue
		end

		local door = halloween.pickDoor(workZone, root.Position)
		if not door then
			state.activity = "Waiting For Doors"
			task.wait(0.3)
			continue
		end

		local doorPosition = door.Position
		local zoneOfDoor = workZone
		state.activity = "Breaking Door"
		local brokenAt = os.clock()
		local result, hits = halloween.breakTarget(job, door, event, function()
			if not state.eventZones.TrickOrTreat[zoneOfDoor] then
				return "Area Changed"
			end

			return nil
		end, halloween.isDoorReady, halloween.approachDoor)

		local outcome = "-"
		if result == "Done" then
			doorsBroken += 1
			halloween.waitAndCollect(job, event, state.cornDrops, doorPosition, brokenAt, 4, function()
				local last = state.lastDoorOutcome
				return last ~= nil and last.at >= brokenAt and not halloween.treatOutcomes[last.outcome]
			end)

			local last = state.lastDoorOutcome
			if last and last.at >= brokenAt then
				outcome = last.outcome
			end
		elseif result == "Unreachable" or result == "No Damage" then
			state.skippedEggs[door] = os.clock() + 15
		elseif result == "No Pickaxe" then
			task.wait(1)
		end

		writeLog(`[Event] Door {zoneNames[zoneOfDoor] or zoneOfDoor} | {result} | {outcome} | {hits} Hits | Candy {halloween.readCandy()}`)
	end

	halloween.finishCornEvent(job, "House Of Horrors", `{doorsBroken} Doors`, candyBefore)
end

halloween.handlers.TrickOrTreat = halloween.runHouseOfHorrors

function halloween.waitForBreakPause(job)
	local isFree = waitUntil(job, 30, function()
		local breakJob = state.breakJob
		return breakJob == nil or breakJob.status ~= "Running" or state.isBreakPaused
	end)

	if not isFree and isJobRunning(job) then
		writeLog("[Event] Auto Break Still Busy | Starting Anyway")
	end
end

function halloween.run(job)
	if not waitForEarlierRuns(job) then
		if not isJobRunning(job) then
			return
		end

		writeLog("[Event] Previous Run Still Busy | Starting Anyway")
	end

	writeLog("[Event] Auto Halloween Start")

	while isJobRunning(job) do
		local event = halloween.readActiveEvent()
		if not (event and halloween.hasArea(event.key)) then
			task.wait(1)
			continue
		end

		state.eventOwner = job
		halloween.waitForBreakPause(job)

		local finished, failure = xpcall(halloween.handlers[event.key], function(message)
			return debug.traceback(tostring(message), 2)
		end, job, event)

		stopWalking()

		if state.eventOwner == job then
			state.eventOwner = nil
		end

		if not finished then
			reportError(`{halloween.labels[event.key] or event.key} Failed: {failure}`)
			task.wait(5)
		end
	end

	if state.eventOwner == job then
		state.eventOwner = nil
	end

	state.activity = "Idle"
	writeLog("[Event] Auto Halloween Stop")
end

trackConnection(workspace:GetAttributeChangedSignal(halloween.scheduleAttribute):Connect(halloween.logScheduleChange))
halloween.logScheduleChange()

local function collectPetsToSell()
	local backpack = localPlayer:FindFirstChild("Backpack")
	local tools = {}
	if not backpack or next(state.sellRarities) == nil then
		return tools
	end

	for _, tool in backpack:GetChildren() do
		if CollectionService:HasTag(tool, "AnimalTool") and state.sellRarities[tool:GetAttribute("Rarity")] then
			table.insert(tools, tool)
		end
	end

	return tools
end

local function describeRarityCounts(tools)
	local counts = {}
	for _, tool in tools do
		local rarity = tostring(tool:GetAttribute("Rarity"))
		counts[rarity] = (counts[rarity] or 0) + 1
	end

	local parts = {}
	for _, rarity in rarityNames do
		if counts[rarity] then
			table.insert(parts, `{rarity} {counts[rarity]}`)
		end
	end

	return table.concat(parts, ", ")
end

local function sellPets(tools)
	local maxPerRequest = backpackSellConfig and backpackSellConfig.MaxPerRequest
	if type(maxPerRequest) ~= "number" or maxPerRequest < 1 then
		maxPerRequest = 1
	end

	for first = 1, #tools, maxPerRequest do
		local last = math.min(first + maxPerRequest - 1, #tools)
		local batch = table.move(tools, first, last, 1, {})

		local invoked, failure = pcall(backpackSellRemote.InvokeServer, backpackSellRemote, batch)
		if not invoked then
			writeLog(`[Sell] Sell Failed: {failure}`)
			return
		end
	end
end

local function runAutoSell(job)
	if not waitForEarlierRuns(job) and not isJobRunning(job) then
		return
	end

	writeLog("[Sell] Start")

	while isJobRunning(job) do
		local tools = if isCarrying() then {} else collectPetsToSell()

		if #tools > 0 then
			local petsBefore = countPets()
			local summary = describeRarityCounts(tools)

			sellPets(tools)
			task.wait(0.5)

			writeLog(`[Sell] Sold {petsBefore - countPets()} | {summary} | Pets {petsBefore} -> {countPets()}`)
		end

		task.wait(3)
	end

	writeLog("[Sell] Stop")
end

local function pressAntiAfkKey()
	local VirtualInputManager = game:GetService("VirtualInputManager")

	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
end

local function runAntiAfk(job)
	while isJobRunning(job) do
		local pressed, failure = pcall(pressAntiAfkKey)
		if not pressed then
			writeLog(`[Hub] Anti AFK Failed: {failure}`)
			return
		end

		waitUntil(job, 60, function()
			return false
		end)
	end
end

local function describeCharacterPlace()
	local _, _, root = getCharacterParts()
	if not root then
		return "No Character"
	end

	local zoneIndex = findZoneAt(root.Position)
	if zoneIndex then
		return zoneNames[zoneIndex] or `Zone {zoneIndex}`
	end

	local safeZone = getZoneHitbox("SafeZone")
	if safeZone and isInsideBox(safeZone, root.Position) then
		return "Base"
	end

	return string.format("%.0f, %.0f, %.0f", root.Position.X, root.Position.Y, root.Position.Z)
end

local function writeStatusLine()
	local runningJobs = {}
	for _, job in state.jobs do
		if job.status == "Running" and job.name ~= "Status Log" and job.name ~= "Anti AFK" then
			table.insert(runningJobs, job.name)
		end
	end

	local cash = tonumber(localPlayer:GetAttribute("Cash")) or 0
	local carrying = localPlayer:GetAttribute("Carrying")

	writeLog(table.concat({
		`[Status] {state.activity}`,
		`At {describeCharacterPlace()}`,
		`Jobs {#runningJobs > 0 and table.concat(runningJobs, ", ") or "None"}`,
		`Cash {formatAmount(cash)}`,
		`Pets {countPets()}`,
		`Candy {tostring(localPlayer:GetAttribute("CandyCorn"))}`,
		`Bag {tostring(localPlayer:GetAttribute("CandyHeistBag") or 0)}`,
		`Carrying {tostring(carrying)}`,
		`Ragdolled {tostring(isRagdolled())}`,
	}, " | "))
end

local function runStatusLog(job)
	while isJobRunning(job) do
		waitUntil(job, 60, function()
			return false
		end)

		if isJobRunning(job) then
			writeStatusLine()
		end
	end
end

local function readOwnedNumbers(text)
	local owned = {}
	if type(text) ~= "string" then
		return owned
	end

	for piece in string.gmatch(text, "[^,]+") do
		local number = tonumber(piece)
		if number then
			owned[number] = true
		end
	end

	return owned
end

local function highestOwnedNumber(owned)
	local highest = 0
	for number in owned do
		highest = math.max(highest, number)
	end

	return highest
end

local function readPickaxeOffer()
	local owned = readOwnedNumbers(localPlayer:GetAttribute("OwnedPickaxes"))
	local equippedTier = localPlayer:GetAttribute("PickaxeTier")
	if type(equippedTier) == "number" then
		owned[equippedTier] = true
	end

	local nextTier = math.max(highestOwnedNumber(owned), pickaxeConfig.DefaultTier) + 1
	local tier = pickaxeConfig.Tiers[nextTier]
	if not tier then
		return nil, "Max Level"
	end

	return {
		name = tier.Name,
		price = tier.Price,
		purchase = function()
			pickaxeShopRemote:FireServer("Buy", nextTier)
		end,
		isBought = function()
			return readOwnedNumbers(localPlayer:GetAttribute("OwnedPickaxes"))[nextTier] == true
		end,
	}
end

local function readTrailOffer()
	local highestOwned = highestOwnedNumber(readOwnedNumbers(localPlayer:GetAttribute(trailsConfig.OwnedAttribute)))

	local nextTrail = nil
	for _, trail in trailsConfig.Trails do
		if trail.Id > highestOwned and (nextTrail == nil or trail.Id < nextTrail.Id) then
			nextTrail = trail
		end
	end

	if not nextTrail then
		return nil, "Max Level"
	end

	return {
		name = nextTrail.Name,
		price = nextTrail.Price,
		purchase = function()
			trailShopRemote:FireServer("Buy", nextTrail.Id)
		end,
		isBought = function()
			return readOwnedNumbers(localPlayer:GetAttribute(trailsConfig.OwnedAttribute))[nextTrail.Id] == true
		end,
	}
end

local function readTreadmillOffer()
	local plot = findOwnedPlot()
	if not plot then
		return nil, "No Plot"
	end

	if not treadmillUnlockConfig.IsPlotUnlocked(plot) then
		return {
			name = "Treadmill Unlock",
			price = treadmillUnlockConfig.Cost,
			purchase = function()
				unlockTreadmillRemote:FireServer()
			end,
			isBought = function()
				return treadmillUnlockConfig.IsPlotUnlocked(plot)
			end,
		}
	end

	local level = treadmillUpgradeConfig.ClampLevel(plot:GetAttribute("TreadmillLevel"))
	local price = treadmillUpgradeConfig.UpgradeCost(level)
	if level >= treadmillUpgradeConfig.MaxLevel or type(price) ~= "number" then
		return nil, "Max Level"
	end

	return {
		name = treadmillUpgradeConfig.DisplayNameFor(level + 1),
		price = price,
		purchase = function()
			upgradeTreadmillRemote:FireServer()
		end,
		isBought = function()
			return treadmillUpgradeConfig.ClampLevel(plot:GetAttribute("TreadmillLevel")) > level
		end,
	}
end

local function readPenOffer()
	local plot = findOwnedPlot()
	if not plot then
		return nil, "No Plot"
	end

	local level = plotUpgradeConfig.ClampLevel(plot:GetAttribute("PlotLevel"))
	local price = plotUpgradeConfig.UpgradeCost(level)
	if type(price) ~= "number" then
		return nil, "Max Level"
	end

	return {
		name = `Pen Level {level + 1}`,
		price = price,
		purchase = function()
			upgradePlotRemote:FireServer()
		end,
		isBought = function()
			return plotUpgradeConfig.ClampLevel(plot:GetAttribute("PlotLevel")) > level
		end,
	}
end

local shopItems = {
	{
		label = "Pickaxe",
		flag = "ap",
		stateField = "buyPickaxe",
		readOffer = readPickaxeOffer,
		isAvailable = pickaxeConfig ~= nil and pickaxeShopRemote ~= nil,
	},
	{
		label = "Treadmill",
		flag = "at",
		stateField = "buyTreadmill",
		readOffer = readTreadmillOffer,
		isAvailable = treadmillUpgradeConfig ~= nil
			and treadmillUnlockConfig ~= nil
			and upgradeTreadmillRemote ~= nil
			and unlockTreadmillRemote ~= nil,
	},
	{
		label = "Pen",
		flag = "ae",
		stateField = "buyPen",
		readOffer = readPenOffer,
		isAvailable = plotUpgradeConfig ~= nil and upgradePlotRemote ~= nil,
	},
	{
		label = "Trail",
		flag = "al",
		stateField = "buyTrail",
		readOffer = readTrailOffer,
		isAvailable = trailsConfig ~= nil and trailShopRemote ~= nil,
	},
}

local function isAnyShopItemOn()
	for _, item in shopItems do
		if state[item.stateField] then
			return true
		end
	end

	return false
end

local function tryBuyItem(job, item)
	local offer, reason = item.readOffer()
	if not offer then
		if reason == "Max Level" and not state.shopMaxLogged[item.label] then
			state.shopMaxLogged[item.label] = true
			writeLog(`[Shop] {item.label} Max Level`)
		end

		return
	end

	local cash = localPlayer:GetAttribute("Cash")
	if type(cash) ~= "number" or cash < offer.price then
		return
	end

	local fired, failure = pcall(offer.purchase)
	if not fired then
		writeLog(`[Shop] Buy {offer.name} Failed: {failure}`)
		state.shopPausedUntil[item.label] = os.clock() + 30
		return
	end

	if waitUntil(job, 3, offer.isBought) then
		writeLog(`[Shop] Bought {offer.name} | ${formatAmount(offer.price)}`)
		return
	end

	if isJobRunning(job) then
		writeLog(`[Shop] Buy {offer.name} Failed: No Change`)
		state.shopPausedUntil[item.label] = os.clock() + 30
	end
end

local function runAutoUpgrade(job)
	if not waitForEarlierRuns(job) and not isJobRunning(job) then
		return
	end

	writeLog("[Shop] Start")

	local isWaitingForTutorial = false

	while isJobRunning(job) do
		local isInTutorial = localPlayer:GetAttribute("TutorialStage") ~= nil
		if isInTutorial and not isWaitingForTutorial then
			writeLog("[Shop] Waiting For Tutorial")
		end

		isWaitingForTutorial = isInTutorial

		if not isInTutorial then
			for _, item in shopItems do
				local isPaused = os.clock() < (state.shopPausedUntil[item.label] or 0)
				if isJobRunning(job) and state[item.stateField] and not isPaused then
					tryBuyItem(job, item)
				end
			end
		end

		waitUntil(job, 3, function()
			return false
		end)
	end

	writeLog("[Shop] Stop")
end

local function updateShopJob()
	if not isAnyShopItemOn() then
		if state.shopJob then
			state.shopJob.status = "Stopped"
			state.shopJob = nil
		end

		return
	end

	if state.shopJob and isJobRunning(state.shopJob) then
		return
	end

	state.shopJob = startJob("Auto Upgrade", runAutoUpgrade)
end

local function fetchPublicServers(sortOrder)
	local url = `https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder={sortOrder}&limit=100&excludeFullGames=true`
	local data = HttpService:JSONDecode(game:HttpGet(url, true))
	if type(data) == "table" and type(data.errors) == "table" then
		error("List Refused", 0)
	end

	if type(data) ~= "table" or type(data.data) ~= "table" then
		error("Bad Server List", 0)
	end

	return data.data
end

local function pickHopServers(servers, currentJobId, isLowestFirst)
	local candidates = {}

	for _, server in servers do
		local playing = tonumber(server.playing)
		local maxPlayers = tonumber(server.maxPlayers)
		local isOpen = playing ~= nil and maxPlayers ~= nil and playing < maxPlayers

		if type(server.id) == "string" and server.id ~= currentJobId and isOpen then
			table.insert(candidates, {id = server.id, playing = playing, maxPlayers = maxPlayers})
		end
	end

	if isLowestFirst then
		table.sort(candidates, function(first, second)
			return first.playing < second.playing
		end)
	else
		local random = Random.new()
		for index = #candidates, 2, -1 do
			local swapIndex = random:NextInteger(1, index)
			candidates[index], candidates[swapIndex] = candidates[swapIndex], candidates[index]
		end
	end

	return candidates
end

local function readEnumName(value)
	local text = tostring(value)
	return string.match(text, "[^%.]+$") or text
end

local function teleportToServer(job, jobId)
	local failureReason = nil
	local isStarted = false

	local stateConnection = localPlayer.OnTeleport:Connect(function(teleportState)
		if teleportState == Enum.TeleportState.Failed then
			failureReason = failureReason or "Teleport Failed"
		else
			isStarted = true
		end
	end)

	local failedConnection = TeleportService.TeleportInitFailed:Connect(function(player, result)
		if player == localPlayer then
			failureReason = readEnumName(result)
		end
	end)

	state.lastTeleportAt = os.clock()

	local requested, requestFailure = pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, jobId, localPlayer)
	if requested then
		waitUntil(job, 10, function()
			return failureReason ~= nil or isStarted
		end)

		if isStarted and failureReason == nil then
			waitUntil(job, 20, function()
				return failureReason ~= nil
			end)
		end
	end

	stateConnection:Disconnect()
	failedConnection:Disconnect()

	if not requested then
		return false, tostring(requestFailure)
	end

	if failureReason then
		return false, failureReason
	end

	if not isStarted then
		return false, "No Response"
	end

	return true, nil
end

local function runServerHop(job, isLowestFirst)
	local sortOrder = if isLowestFirst then "Asc" else "Desc"
	local listRetryDelay = 5

	while isJobRunning(job) do
		local fetched, servers = pcall(fetchPublicServers, sortOrder)
		local candidates = if fetched then pickHopServers(servers, game.JobId, isLowestFirst) else {}

		if not fetched then
			writeLog(`[Server] Hop Failed: Server List | {servers} | Retry In {listRetryDelay} s`)
		elseif #candidates == 0 then
			writeLog(`[Server] Hop Failed: No Server | Retry In {listRetryDelay} s`)
		end

		if #candidates == 0 then
			waitUntil(job, listRetryDelay, function()
				return false
			end)

			listRetryDelay = math.min(listRetryDelay * 2, 60)
			continue
		end

		listRetryDelay = 5

		for _, server in candidates do
			if not isJobRunning(job) then
				return
			end

			writeLog(`[Server] Hop To {string.sub(server.id, 1, 8)} | {server.playing}/{server.maxPlayers}`, true)

			local teleported, reason = teleportToServer(job, server.id)
			if teleported then
				return
			end

			writeLog(`[Server] Hop Failed: {reason}`)
			waitUntil(job, 1, function()
				return false
			end)
		end

		waitUntil(job, listRetryDelay, function()
			return false
		end)
	end
end

local function runTeleportOnce(job, actionName, jobId)
	writeLog(`[Server] {actionName} {string.sub(jobId, 1, 8)}`, true)

	local teleported, reason = teleportToServer(job, jobId)
	if not teleported and isJobRunning(job) then
		window:Notify({Title = "Server", Text = `{actionName} Failed: {reason}`, Error = true})
	end
end

local function startServerAction(actionName, run)
	if state.serverJob and isJobRunning(state.serverJob) then
		window:Notify({Title = "Server", Text = `{actionName} Failed: Teleport In Progress`, Error = true})
		return
	end

	state.serverJob = startJob(actionName, run)
end

local function readJobId(text)
	local trimmed = string.match(tostring(text or ""), "^%s*(.-)%s*$") or ""
	local pattern = "^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"

	if not string.match(trimmed, pattern) then
		return nil
	end

	return string.lower(trimmed)
end

local skippedRejoinErrors = {
	[Enum.ConnectionError.DisconnectEvicted] = true,
	[Enum.ConnectionError.DisconnectDuplicatePlayer] = true,
}

local function runAutoRejoin(job)
	while isJobRunning(job) do
		state.lastTeleportAt = os.clock()
		writeLog("[Server] Auto Rejoin | Teleporting", true)

		local requested, failure = pcall(TeleportService.Teleport, TeleportService, game.PlaceId, localPlayer)
		if not requested then
			writeLog(`[Server] Auto Rejoin Failed: {failure}`, true)
		end

		waitUntil(job, 10, function()
			return false
		end)
	end
end

local function onErrorMessageChanged(message)
	if type(message) ~= "string" or message == "" then
		return
	end

	local errorCode = GuiService:GetErrorCode()
	local errorName = readEnumName(errorCode)

	if state.lastTeleportAt and os.clock() - state.lastTeleportAt < 30 then
		writeLog(`[Server] Rejoin Ignored During Teleport | {message} | {errorName}`, true)
		return
	end

	if skippedRejoinErrors[errorCode] then
		writeLog(`[Server] Rejoin Skipped: Same Account Elsewhere | {errorName}`, true)
		return
	end

	if state.rejoinJob and isJobRunning(state.rejoinJob) then
		return
	end

	writeLog(`[Server] Kicked | {message} | {errorName}`, true)
	state.rejoinJob = startJob("Auto Rejoin", runAutoRejoin)
end

trackConnection((GuiService :: any).ErrorMessageChanged:Connect(onErrorMessageChanged))

trackConnection(workspace:GetAttributeChangedSignal("AdminAbuseStartedAt"):Connect(function()
	if workspace:GetAttribute("AdminAbuseStartedAt") ~= nil then
		writeLog("[Server] Admin Abuse Started")
	else
		writeLog("[Server] Admin Abuse Ended")
	end
end))

trackConnection(localPlayer.Idled:Connect(function()
	pcall(function()
		local VirtualUser = game:GetService("VirtualUser")
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
	end)
end))

if sharedEnvironment.__AvW then
	pcall(sharedEnvironment.__AvW.Destroy, sharedEnvironment.__AvW)
end

local keyAccepted, keyFailure = pcall(Library.Gate, Library, {
	Title = "Ngao - Gaming Hub",
	Server = "https://getkey.kaeldrinnovasse.workers.dev",
	Hub = "bse",
	Discord = "https://discord.gg/tBVtKbpUFj",
	Config = "BreakAndStealAnEgg",
})

if not keyAccepted then
	writeLog(`[Hub] Key Gate Stopped: {keyFailure}`, true)
	pcall(stopPreviousLoad, state)
	return
end

window = Library:Window({Title = `Ngao - Gaming Hub | {gameName}`, Config = configName})
Library.Log = writeLog

local showToast = window.Notify

function window:Notify(options)
	if type(options) == "table" then
		writeLog(`[{options.Title or "Hub"}] {options.Text or ""}`)
	end

	return showToast(self, options)
end

local function hideFloatingToggle()
	for _, child in window.Gui:GetChildren() do
		if child:IsA("GuiButton") then
			local glyph = child:FindFirstChildWhichIsA("TextLabel")
			if glyph and glyph.Text == "studio" then
				child.Visible = false
			end
		end
	end
end

local function loadLogoImage()
	local decodeBase64 = (crypt and crypt.base64decode) or base64_decode
	if type(decodeBase64) ~= "function" or not (getcustomasset and writefile) then
		return nil
	end

	local decoded, asset = pcall(function()
		ensureFolders({"Avenoric", "Avenoric/Assets"})
		writefile(logoPath, decodeBase64(logoData))

		return getcustomasset(logoPath)
	end)

	if decoded and type(asset) == "string" then
		return asset
	end

	return nil
end

local function toggleWindow()
	if window.Main.Visible then
		window:Hide()
	else
		window:Show()
	end
end

local function buildHudButton()
	local mainGui = playerGui:FindFirstChild("MainGUI")
	local rightHud = mainGui and mainGui:FindFirstChild("RightHUD")
	local eggsButton = rightHud and rightHud:FindFirstChild("Eggs")
	if not eggsButton then
		return
	end

	local previousButton = rightHud:FindFirstChild("NgaoButton")
	if previousButton then
		previousButton:Destroy()
	end

	local button = eggsButton:Clone()
	button.Name = "NgaoButton"
	button.LayoutOrder = 0

	local notification = button:FindFirstChild("Notification")
	if notification then
		notification:Destroy()
	end

	local gradient = button:FindFirstChildWhichIsA("UIGradient")
	if gradient then
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 122, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(232, 172, 18)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 214, 64)),
		})
	end

	local icon = button:FindFirstChild("Icon")
	local logoAsset = loadLogoImage()
	if logoAsset and icon and icon:IsA("ImageLabel") then
		icon.Image = logoAsset
	end

	button.Parent = rightHud
	state.hudButton = button

	trackConnection(button.Activated:Connect(toggleWindow))
end

hideFloatingToggle()

local hudBuilt, hudFailure = pcall(buildHudButton)
if not hudBuilt then
	reportError(`Hud Button Failed: {hudFailure}`)
end

local function describeSettingValue(value)
	if type(value) ~= "table" then
		return tostring(value)
	end

	local items = {}
	for _, item in value do
		table.insert(items, tostring(item))
	end

	return `[{table.concat(items, ", ")}]`
end

local function logSettingChanges(tab)
	for _, methodName in {"Toggle", "Dropdown", "TextBox"} do
		local createRow = tab[methodName]

		tab[methodName] = function(self, options)
			local callback = options and options.Callback

			if options and options.Flag and type(callback) == "function" then
				options.Callback = function(value, ...)
					writeLog(`[Setting] {options.Name} = {describeSettingValue(value)}`)
					return callback(value, ...)
				end
			end

			return createRow(self, options)
		end
	end

	return tab
end

local generalTab = logSettingChanges(window:Tab({Name = "General", Icon = "hammer-code"}))

generalTab:Section({Name = "Farm"})

if #zoneNames > 0 then
	generalTab:Dropdown({Name = "Select Area", Options = zoneNames, Default = zoneNames[1], Flag = "sa", Callback = function(value)
		state.farmZone = table.find(zoneNames, value) or 1
	end})
else
	reportError("Area List Failed: No Zone Names")
end

if #rarityNames > 0 then
	generalTab:Dropdown({Name = "Select Rarity", Options = rarityNames, Default = {}, Multi = true, Flag = "sr", Callback = function(values)
		local selected = {}
		for _, rarity in values do
			selected[rarity] = true
		end

		state.farmRarities = selected
	end})
else
	reportError("Rarity List Failed: No Rarity Names")
end

local function applyThreshold(label, text, apply)
	local amount = parseAmount(text)
	if not amount then
		window:Notify({Title = "Farm", Text = `{label} Failed: Bad Number`, Error = true})
		return
	end

	apply(amount)
end

generalTab:TextBox({Name = "Min Kg", Placeholder = "All / 500 / 2.5K", Default = "", Flag = "mk", Callback = function(text)
	applyThreshold("Min Kg", text, function(amount)
		state.minPetKg = amount
	end)
end})

generalTab:TextBox({Name = "Min Income", Placeholder = "All / 1B / 5T", Default = "", Flag = "mi", Callback = function(text)
	applyThreshold("Min Income", text, function(amount)
		state.minPetIncome = amount
	end)
end})

generalTab:Toggle({Name = "Auto Break", Default = false, Flag = "ab", Callback = function(isOn)
	if state.breakJob then
		state.breakJob.status = "Stopped"
		state.breakJob = nil
	end

	stopWalking()

	if not isOn then
		return
	end

	if not (eggTargeting and eggHitRemote and treadmillRemote) then
		window:Notify({Title = "Farm", Text = "Auto Break Failed: Game Data Missing", Error = true})
		return
	end

	state.breakJob = startJob("Auto Break", runAutoBreak)
end})

state.petIndexToggle = generalTab:Toggle({Name = "Pet Index", Default = false, Flag = "pi", Callback = function(isOn)
	state.isPetIndexOn = isOn
	state.indexLoggedZone = nil

	if isOn then
		requestIndexState()
	end
end})

generalTab:Section({Name = "Pet"})

if #rarityNames > 0 then
	generalTab:Dropdown({Name = "Select Sell Rarity", Options = rarityNames, Default = {}, Multi = true, Flag = "sv", Callback = function(values)
		local selected = {}
		for _, rarity in values do
			selected[rarity] = true
		end

		state.sellRarities = selected
	end})
end

generalTab:Toggle({Name = "Auto Sell", Default = false, Flag = "as", Callback = function(isOn)
	if state.sellJob then
		state.sellJob.status = "Stopped"
		state.sellJob = nil
	end

	if not isOn then
		return
	end

	if not backpackSellRemote then
		window:Notify({Title = "Sell", Text = "Auto Sell Failed: No Sell Remote", Error = true})
		return
	end

	state.sellJob = startJob("Auto Sell", runAutoSell)
end})

local eventTab = logSettingChanges(window:Tab({Name = "Event", Icon = "calendar-star"}))

eventTab:Section({Name = "Halloween"})

local function readAreaSet(values)
	local selected = {}
	for _, value in values do
		local zoneIndex = table.find(zoneNames, value)
		if zoneIndex then
			selected[zoneIndex] = true
		end
	end

	return selected
end

if #zoneNames > 0 then
	for _, event in {{key = "DisguisedEggs", flag = "h1"}, {key = "TrickOrTreat", flag = "h2"}, {key = "CandyHeist", flag = "h3"}} do
		eventTab:Dropdown({Name = `{halloween.labels[event.key]} Area`, Options = zoneNames, Default = {}, Multi = true, Flag = event.flag, Callback = function(values)
			state.eventZones[event.key] = readAreaSet(values)
		end})
	end

	eventTab:Dropdown({Name = `{halloween.labels.BloodMoon} Area`, Options = zoneNames, Default = zoneNames[1], Flag = "h4", Callback = function(value)
		state.eventZones.BloodMoon = table.find(zoneNames, value) or 1
	end})
end

eventTab:Toggle({Name = "Auto Halloween", Default = false, Flag = "ah", Callback = function(isOn)
	if state.halloweenJob then
		state.halloweenJob.status = "Stopped"
		state.halloweenJob = nil
	end

	stopWalking()

	if not isOn then
		return
	end

	if not (eggTargeting and eggHitRemote and treadmillRemote and candyHeistRemote) then
		window:Notify({Title = "Event", Text = "Auto Halloween Failed: Game Data Missing", Error = true})
		return
	end

	state.halloweenJob = startJob("Auto Halloween", halloween.run)
end})

local shopTab = logSettingChanges(window:Tab({Name = "Shop", Icon = "shopping-basket"}))

shopTab:Section({Name = "Upgrade"})

for _, item in shopItems do
	shopTab:Toggle({Name = `Auto Upgrade {item.label}`, Default = false, Flag = item.flag, Callback = function(isOn)
		if isOn and not item.isAvailable then
			window:Notify({Title = "Shop", Text = `Auto Upgrade {item.label} Failed: Game Data Missing`, Error = true})
		end

		state[item.stateField] = isOn and item.isAvailable
		updateShopJob()
	end})
end

local serverTab = logSettingChanges(window:Tab({Name = "Server", Icon = "globe-simplified"}))

serverTab:Section({Name = "Server"})

local jobIdBox = serverTab:TextBox({Name = "Job Id", Placeholder = "Paste A Job Id"})

serverTab:Button({Name = "Join Server", Callback = function()
	local jobId = readJobId(jobIdBox:Get())
	if not jobId then
		window:Notify({Title = "Server", Text = "Join Failed: Bad Job Id", Error = true})
		return
	end

	if jobId == string.lower(game.JobId) then
		window:Notify({Title = "Server", Text = "Join Failed: Already Here", Error = true})
		return
	end

	startServerAction("Join", function(job)
		window:Notify({Title = "Server", Text = "Joining Server"})
		runTeleportOnce(job, "Join", jobId)
	end)
end})

serverTab:Button({Name = "Copy Job Id", Callback = function()
	local copy = setclipboard or toclipboard
	if type(copy) ~= "function" then
		window:Notify({Title = "Server", Text = "Copy Failed: No Clipboard", Error = true})
		return
	end

	copy(game.JobId)
	window:Notify({Title = "Server", Text = "Job Id Copied"})
end})

serverTab:Button({Name = "Hop Server", Callback = function()
	startServerAction("Hop", function(job)
		window:Notify({Title = "Server", Text = "Hopping To Another Server"})
		runServerHop(job, false)
	end)
end})

serverTab:Button({Name = "Hop Low Server", Callback = function()
	startServerAction("Hop", function(job)
		window:Notify({Title = "Server", Text = "Hopping To The Lowest Server"})
		runServerHop(job, true)
	end)
end})

serverTab:Button({Name = "Rejoin", Callback = function()
	startServerAction("Rejoin", function(job)
		window:Notify({Title = "Server", Text = "Rejoining This Server"})
		runTeleportOnce(job, "Rejoin", game.JobId)
	end)
end})

local settingTab = logSettingChanges(window:Tab({Name = "Setting", Icon = "gear"}))

settingTab:Section({Name = "Support"})

local problemBox = settingTab:TextBox({Name = "Describe The Problem", Placeholder = "What Went Wrong?"})
local nextSendAt = 0

local function sendLogToDeveloper(problem)
	local request = sharedEnvironment.request
		or sharedEnvironment.http_request
		or (type(sharedEnvironment.http) == "table" and sharedEnvironment.http.request)

	if type(request) ~= "function" then
		error("No Request Function", 0)
	end

	flushLog()

	if not isfile(logPath) then
		error("No Log File", 0)
	end

	local logText = readfile(logPath)
	local isCut = #logText > 8e6
	if isCut then
		logText = string.sub(logText, -8e6)
	end

	local executorName = identifyexecutor and select(2, pcall(identifyexecutor)) or "?"
	local boundary = `BseLog{string.gsub(HttpService:GenerateGUID(false), "-", "")}`
	local header = `**{localPlayer.Name}** ({localPlayer.UserId}) | {gameName} | Place {game.PlaceVersion} | Server {game.JobId} | {tostring(executorName)}`

	if isCut then
		header ..= " | Last 8 MB"
	end

	local payload = HttpService:JSONEncode({
		content = `{header}\nProblem: {problem}`,
		allowed_mentions = {parse = {}},
	})

	local body = table.concat({
		`--{boundary}`,
		`Content-Disposition: form-data; name="payload_json"`,
		"Content-Type: application/json",
		"",
		payload,
		`--{boundary}`,
		`Content-Disposition: form-data; name="files[0]"; filename="{localPlayer.Name}_Log.txt"`,
		"Content-Type: text/plain",
		"",
		logText,
		`--{boundary}--`,
		"",
	}, "\r\n")

	local response = request({
		Url = supportWebhookUrl,
		Method = "POST",
		Headers = {["Content-Type"] = `multipart/form-data; boundary={boundary}`},
		Body = body,
	})

	local statusCode = type(response) == "table" and response.StatusCode
	if statusCode ~= 200 and statusCode ~= 204 then
		error(`Http {statusCode or "No Response"}`, 0)
	end
end

settingTab:Button({Name = "Send Log To Developer", Callback = function()
	local waitLeft = nextSendAt - os.clock()
	if waitLeft > 0 then
		window:Notify({Title = "Support", Text = `Send Log Failed: Wait {math.ceil(waitLeft)} s`})
		return
	end

	local problem = string.sub(string.match(tostring(problemBox:Get() or ""), "^%s*(.-)%s*$") or "", 1, 500)
	if problem == "" then
		window:Notify({Title = "Support", Text = "Send Log Failed: Describe The Problem First"})
		return
	end

	nextSendAt = os.clock() + 300

	task.spawn(function()
		writeLog(`[Support] Send Log | Place {game.PlaceVersion} | Server {string.sub(game.JobId, 1, 8)} | Problem: {problem}`, true)

		local sent, sendFailure = pcall(sendLogToDeveloper, problem)
		writeLog(sent and "[Support] Log Sent" or `[Support] Send Log Failed: {sendFailure}`, true)

		if sent then
			problemBox:Set("")
		else
			nextSendAt = os.clock() + 10
		end

		window:Notify({Title = "Support", Text = sent and "Log Sent To Developer" or `Send Log Failed: {sendFailure}`})
	end)
end})

startJob("Anti AFK", runAntiAfk)
startJob("Status Log", runStatusLog)

local function writeSessionLine()
	local executorName, executorVersion = "?", ""
	if identifyexecutor then
		local identified, name, version = pcall(identifyexecutor)
		if identified then
			executorName, executorVersion = tostring(name), tostring(version or "")
		end
	end

	writeLog(table.concat({
		`[Hub] Session | Executor {executorName} {executorVersion}`,
		`Players {#Players:GetPlayers()}/{Players.MaxPlayers}`,
		`Cash {formatAmount(tonumber(localPlayer:GetAttribute("Cash")) or 0)}`,
		`Speed Power {formatAmount(tonumber(localPlayer:GetAttribute("SpeedPower")) or 0)}`,
		`Pickaxe {tostring(localPlayer:GetAttribute("PickaxeTier"))}`,
		`Pets {countPets()}/{petInventoryConfig and petInventoryConfig.MaxPets or "?"}`,
		`Candy {tostring(localPlayer:GetAttribute("CandyCorn"))}`,
	}, " | "))
end

writeLog(`[Hub] Loaded | Place {game.PlaceVersion} | Server {string.sub(game.JobId, 1, 8)} | {localPlayer.Name}`)
writeSessionLine()
window:Notify({Title = "Ngao - Gaming Hub", Text = `{gameName} Loaded`, Time = 4})
