local SERVER = "https://auth.kaeldrinnovasse.workers.dev"
local MAX_LOADS = 4
local FETCH_TIMEOUT = 30
local GAME_ID_TIMEOUT = 30

local sharedEnvironment = getgenv and getgenv() or _G
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local loadChunk = loadstring or load

local requestedHub = ...

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

local function httpGet(url)
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

local function fetchScript(url)
	local source = nil
	local isDone = false

	task.spawn(function()
		source = httpGet(url)
		isDone = true
	end)

	local startedAt = os.clock()
	while not isDone and os.clock() - startedAt < FETCH_TIMEOUT do
		task.wait()
	end

	return isDone and source or nil
end

local function readGameId()
	local startedAt = os.clock()

	while game.GameId == 0 and os.clock() - startedAt < GAME_ID_TIMEOUT do
		task.wait()
	end

	return game.GameId
end

local runState

local function buildTargetQuery()
	if runState.hub then
		return `h={HttpService:UrlEncode(runState.hub)}`
	end

	return string.format("g=%d", runState.gameId)
end

local function loadHub(key)
	runState.tries += 1

	if runState.tries > MAX_LOADS then
		error("Dawnvector Failed: Too Many Loads", 0)
	end

	local digestQuery = HttpService:UrlEncode(runState.digest)
	local keyQuery = if key then `&k={HttpService:UrlEncode(key)}` else ""
	local url = `{SERVER}/script?{buildTargetQuery()}&d={digestQuery}{keyQuery}&n={HttpService:GenerateGUID(false)}`

	local source = fetchScript(url)

	if type(source) ~= "string" or source == "" then
		error("Dawnvector Failed: Server Unreachable", 0)
	end

	local chunk = loadChunk(source)

	if type(chunk) ~= "function" then
		error("Dawnvector Failed: Bad Script", 0)
	end

	sharedEnvironment.__DV = runState
	return chunk()
end

if requestedHub ~= nil and (type(requestedHub) ~= "string" or not requestedHub:match("^[a-z]+$")) then
	error("Dawnvector Failed: No Hub", 0)
end

if type(loadChunk) ~= "function" then
	error("Dawnvector Failed: No Loadstring", 0)
end

local gameId = nil

if requestedHub == nil then
	gameId = readGameId()

	if gameId == 0 then
		error("Dawnvector Failed: No Game Id", 0)
	end
end

local deviceDigest = readDeviceDigest()

if not deviceDigest then
	error("Dawnvector Failed: No Device Id", 0)
end

runState = {
	hub = requestedHub,
	gameId = gameId,
	server = SERVER,
	digest = deviceDigest,
	tries = 0,
	load = loadHub,
}

return loadHub()
