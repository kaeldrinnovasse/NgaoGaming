if not game:IsLoaded() then game.Loaded:Wait() end

local ps = game:GetService("Players")
repeat task.wait() until ps.LocalPlayer

local lp = ps.LocalPlayer
local pl = ({[132929771812494] = "Lobby", [114068177100380] = "Match"})[game.PlaceId]
if not pl then
	warn("Hub Load Failed: Unsupported Place")
	return
end

local function ld()
	local m, c = getrenv().shared.Modules, lp.Character
	return m ~= nil and m.Replication ~= nil and m.Network ~= nil and workspace:FindFirstChild(pl == "Lobby" and "Elevators" or "Game") ~= nil and c ~= nil and c:FindFirstChild("HumanoidRootPart") ~= nil
end
while not ld() do task.wait(0.5) end

local ge = getgenv()
if ge.__CtdAf then ge.__CtdAf.bg = false end
local st = {bg = true}
ge.__CtdAf = st

local function lg(t, nw)
	local fp, g = `Avenoric/Configs/CameramanTowerDefense/{lp.Name}_Log.txt`, ge.__CtdLq
	if not g then
		g = {pq = {}, dt = false}
		ge.__CtdLq = g
	end
	local m, ts = (tostring(t):gsub("%s*\n%s*", " <- ")), os.date("%Y-%m-%d %H:%M:%S")
	local la = g.pq[#g.pq]
	if la and la[2] == m then
		la[1], la[3] = ts, la[3] + 1
	else
		table.insert(g.pq, {ts, m, 1})
	end
	local function wr()
		g.dt = false
		local n = nw and #g.pq or #g.pq - 1
		if n <= 0 then return end
		local b = {}
		for i = 1, n do
			local x = g.pq[i]
			b[i] = `{x[1]} | {x[2]}{x[3] > 1 and ` x{x[3]}` or ""}`
		end
		local s = table.concat(b, "\n") .. "\n"
		local ok = pcall(function()
			for _, x in {"Avenoric", "Avenoric/Configs", "Avenoric/Configs/CameramanTowerDefense"} do
				if not isfolder(x) then makefolder(x) end
			end
			if appendfile and isfile(fp) then appendfile(fp, s) else writefile(fp, (isfile(fp) and readfile(fp) or "") .. s) end
		end)
		if ok then
			for _ = 1, n do table.remove(g.pq, 1) end
		end
	end
	if nw then
		wr()
		return
	end
	if g.dt then return end
	g.dt = true
	task.delay(2, wr)
end

local L
L = (function()
local ps, uis, tws, gs, hs = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("GuiService"), game:GetService("HttpService")
local ge = getgenv and getgenv() or _G
local c = {bg = Color3.fromRGB(37, 37, 34), cd = Color3.fromRGB(47, 47, 43), hv = Color3.fromRGB(58, 58, 54), pr = Color3.fromRGB(68, 68, 63), tx = Color3.fromRGB(244, 240, 232), dm = Color3.fromRGB(168, 164, 156), ac = Color3.fromRGB(76, 194, 255), er = Color3.fromRGB(214, 106, 94)}
local fn, fb, ww, wh, nw, th = Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold, 580, 340, 150, 40
local ip = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
local ir, ib = Font.new(ip), Font.new(ip, Enum.FontWeight.Bold)
local mb, tc, mm, kb = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement, Enum.UserInputType.Keyboard
local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local L = {Flags = {}, Lg = nil :: any}

local function mk(k, p, ch)
	local o = Instance.new(k)
	for i, v in p do
		if i ~= "Parent" then o[i] = v end
	end
	for _, x in ch or {} do x.Parent = o end
	o.Parent = p.Parent
	return o
end

local function rc(r) return mk("UICorner", {CornerRadius = UDim.new(0, r)}) end
local function sk(t, col) return mk("UIStroke", {Color = col or c.tx, Transparency = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}) end
local function pd(l, r, t, b) return mk("UIPadding", {PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r or l), PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0)}) end
local function ll(g) return mk("UIListLayout", {Padding = UDim.new(0, g), SortOrder = Enum.SortOrder.LayoutOrder}) end
local function tw(o, p, d) tws:Create(o, d and TweenInfo.new(d, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or ti, p):Play() end

local function tl(p, ch)
	local d = {BackgroundTransparency = 1, Font = fn, TextColor3 = c.tx, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Text = ""}
	for i, v in p do d[i] = v end
	return mk("TextLabel", d, ch)
end

local function ig(p, ch)
	local d = {BackgroundTransparency = 1, FontFace = ir, TextColor3 = c.tx, TextSize = 16, Text = ""}
	for i, v in p do d[i] = v end
	return mk("TextLabel", d, ch)
end

local function bt(p, ch)
	local d = {BackgroundTransparency = 1, AutoButtonColor = false, Text = "", BorderSizePixel = 0}
	for i, v in p do d[i] = v end
	return mk("TextButton", d, ch)
end

local function hov(b, base)
	b.MouseEnter:Connect(function() if uis.MouseEnabled then tw(b, {BackgroundColor3 = c.hv}) end end)
	b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = base()}) end)
	b.MouseButton1Down:Connect(function() tw(b, {BackgroundColor3 = c.pr}, 0.05) end)
	b.MouseButton1Up:Connect(function() tw(b, {BackgroundColor3 = uis.MouseEnabled and c.hv or base()}) end)
end

local function gui()
	local sg = mk("ScreenGui", {Name = hs:GenerateGUID(false), IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999})
	if not pcall(function() sg.Parent = gethui and gethui() or game:GetService("CoreGui") end) then sg.Parent = ps.LocalPlayer:WaitForChild("PlayerGui") end
	return sg
end

local function fit(sg, f, sc, w, h)
	local s, i = sg.AbsoluteSize, gs:GetGuiInset().Y
	local v = math.clamp(math.min((s.X - 24) / w, (s.Y - i - 24) / h), 0.5, 1)
	sc.Scale = v
	f.Position = UDim2.fromOffset(s.X / 2, i + (s.Y - i) / 2)
	return v
end

local function cfn(s)
	if s == nil then return true end
	if type(s) ~= "string" or s == "" then return false end
	for seg in (s .. "/"):gmatch("([^/]*)/") do
		if not seg:match("^[%w _%-]+$") then return false end
	end
	return true
end

local function mkd(p)
	local d = ""
	for seg in p:gmatch("([^/]+)/") do
		d = d == "" and seg or d .. "/" .. seg
		if not isfolder(d) then makefolder(d) end
	end
end

local function inv(u)
	local code = u:match("([%w%-_]+)/?%s*$")
	if not code then return end
	local body = hs:JSONEncode({cmd = "INVITE_BROWSER", nonce = hs:GenerateGUID(false), args = {code = code}})
	for p = 6463, 6472 do
		local ok, r = pcall(request, {Url = `http://127.0.0.1:{p}/rpc?v=1`, Method = "POST", Headers = {["Content-Type"] = "application/json", Origin = "https://discord.com"}, Body = body})
		if ok and type(r) == "table" and r.StatusCode == 200 then return end
	end
end

local kr, ka = "^NGAO%-[A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9]%-[A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9][A-HJ-NP-Z2-9]$", nil

local function fv(s)
	local hi, lo = 0xcbf29ce4, 0x84222325
	for i = 1, #s do
		lo = bit32.bxor(lo, string.byte(s, i))
		local p = lo * 435
		hi = (hi * 435 + p // 4294967296 + bit32.lshift(lo, 8)) % 4294967296
		lo = p % 4294967296
	end
	return string.format("%08x%08x", hi, lo)
end
L.Digest = fv

local function gd(v)
	if type(v) ~= "string" then return false end
	local s, t, n = v:gsub("[ %-]", ""), {}, 0
	if #s < 16 then return false end
	for ch in s:lower():gmatch(".") do
		if not t[ch] then t[ch], n = true, n + 1 end
	end
	return n >= 4
end

local function hw()
	for _, nm in {"gethwid", "get_hwid"} do
		local f = ge[nm]
		if type(f) == "function" then
			local a, v = pcall(f)
			if a and gd(v) then return v end
		end
	end
	local e, w = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
	if e and gd(w) then return w end
	local b, u = pcall(function() return ps.LocalPlayer.UserId end)
	return b and type(u) == "number" and "U" .. u or nil
end

local function dv()
	local v, d = nil, false
	task.spawn(function()
		local a, r = pcall(hw)
		v, d = a and r or nil, true
	end)
	while not d do task.wait() end
	return v and fv(v)
end

function L.Http(u)
	local f = ge.request or ge.http_request or (type(ge.http) == "table" and ge.http.request)
	if type(f) == "function" then
		local a, r = pcall(f, {Url = u, Method = "GET"})
		if a and type(r) == "table" and r.StatusCode == 200 and type(r.Body) == "string" then return r.Body end
	end
	local b, s = pcall(function() return game:HttpGet(u, true) end)
	return b and type(s) == "string" and s or nil
end

local function ak(o, k, d)
	local u, v, dn = `{o.Server}/api/check?h={hs:UrlEncode(o.Hub)}&k={hs:UrlEncode(k)}&d={hs:UrlEncode(d)}&n={hs:GenerateGUID(false)}`, nil, false
	task.spawn(function()
		local a, b = pcall(L.Http, u)
		if a and type(b) == "string" then
			local e, j = pcall(function() return hs:JSONDecode(b) end)
			if e then v = j end
		end
		dn = true
	end)
	local t = os.clock()
	while not dn and os.clock() - t < 10 do task.wait() end
	if not dn or type(v) ~= "table" then return nil end
	if v.ok == true and type(v.ex) == "number" then return {true, v.ex} end
	if v.ok == false and table.find({"Bad Request", "Wrong Key", "Wrong Hub", "Wrong Device", "Key Expired"}, v.err) then return {false, v.err} end
	return nil
end

local function rk(p)
	if not (isfile and isfile(p)) then return nil end
	local a, s = pcall(readfile, p)
	if not (a and type(s) == "string") then return nil end
	local k, x = s:match("^%s*(%S+)%s*\n%s*(%d+)%s*$")
	if k and k:match(kr) then return k, tonumber(x) end
	return nil
end

local function gr(x)
	local a, n = pcall(function() return workspace:GetServerTimeNow() end)
	return a and type(n) == "number" and type(x) == "number" and n < x and x <= n + 259200
end

local function gc(o, lk)
	local sg = gui()
	L.GateGui = sg
	bt({Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(), BackgroundTransparency = 0.5, Parent = sg})
	local f = mk("Frame", {Size = UDim2.fromOffset(300, 180), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c.bg, BorderSizePixel = 0, ZIndex = 2, Parent = sg}, {rc(12), sk(0.85), pd(20, 20, 20, 20)})
	local sc = mk("UIScale", {Parent = f})
	fit(sg, f, sc, 300, 180)
	local u = {sg = sg, cn = sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() fit(sg, f, sc, 300, 180) end)}
	tl({Text = tostring(o.Title or "Avenoric"), Font = fb, TextSize = 16, Size = UDim2.new(1, 0, 0, 20), Parent = f})
	tl({Text = "Enter your key to continue", TextSize = 13, TextColor3 = c.dm, Position = UDim2.fromOffset(0, 22), Size = UDim2.new(1, 0, 0, 16), Parent = f})
	local bx = mk("Frame", {Position = UDim2.fromOffset(0, 48), Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = c.cd, BorderSizePixel = 0, ClipsDescendants = true, Parent = f}, {rc(6), sk(0.9)})
	local st = bx:FindFirstChildOfClass("UIStroke")
	u.tb = mk("TextBox", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 1, 0), Font = fn, TextSize = 14, TextColor3 = c.tx, PlaceholderText = "Key", PlaceholderColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Text = "", Parent = bx})
	u.ml = tl({Text = "", TextSize = 12, TextColor3 = c.er, Position = UDim2.fromOffset(0, 86), Size = UDim2.new(1, 0, 0, 16), Visible = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f})
	u.sb = bt({AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Size = lk and UDim2.new(0.5, -4, 0, 32) or UDim2.new(1, 0, 0, 32), BackgroundColor3 = c.ac, BackgroundTransparency = 0, Font = fb, TextSize = 13, TextColor3 = c.bg, Text = "Submit", Parent = f}, {rc(6)})
	if lk then
		u.gk = bt({AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(0.5, -4, 0, 32), BackgroundColor3 = c.cd, BackgroundTransparency = 0, Font = fn, TextSize = 13, TextColor3 = c.tx, Text = "Get Key", Parent = f}, {rc(6), sk(0.9)})
		hov(u.gk, function() return c.cd end)
	end
	u.tb.Focused:Connect(function() tw(st, {Color = c.ac, Transparency = 0}) end)
	u.tb.FocusLost:Connect(function() tw(st, {Color = c.tx, Transparency = 0.9}) end)
	function u.m(s, col) u.ml.Text, u.ml.TextColor3, u.ml.Visible = s, col or c.er, true end
	function u.x()
		u.cn:Disconnect()
		u.sg:Destroy()
		if L.GateGui == u.sg then L.GateGui = nil end
	end
	return u
end

local function sgt(o)
	local sv, hb = o.Server, o.Hub
	if type(sv) ~= "string" or not sv:match("^https://[%w%.%-]+$") then error("Gate Failed: Bad Server", 0) end
	if type(hb) ~= "string" or not hb:match("^[a-z]+$") then error("Gate Failed: Bad Hub", 0) end
	if o.Link ~= nil then error("Gate Failed: Link And Server", 0) end
	if o.Config == nil then error("Gate Failed: No Config", 0) end
	if not cfn(o.Config) then error("Gate Failed: Bad Config", 0) end
	local mx = o.Max == nil and 24 or tonumber(o.Max)
	if not (mx and mx >= 1) then error("Gate Failed: Bad Max", 0) end
	local dg = dv()
	if not dg then error("Gate Failed: No Device Id", 0) end
	local tk, pv, kp = {}, ge.__AvG, `Avenoric/Keys/{o.Config}.txt`
	if type(pv) == "table" and pv.sg then pcall(function() pv.sg:Destroy() end) end
	ge.__AvG = tk
	local lk, kk, kx = `{sv}/k/{hb}?d={dg}`, rk(kp)
	local u, lc, by, got
	local function ac(k, x, w)
		if w then pcall(function() mkd(kp); writefile(kp, k .. "\n" .. x) end) end
		ka = {p = kp, t = os.clock() + 30, v = true}
	end
	local function fin()
		if u then u.x() end
		if ge.__AvG == tk then tk.sg = nil end
	end
	local function rs(e) return e == "Bad Request" and "Key Check Failed: Bad Request" or e end
	local function sub()
		if by or lc or not u then return end
		local s = (u.tb.Text:gsub("^%s+", ""):gsub("%s+$", "")):upper()
		if s == "" then u.m("Enter A Key"); return end
		if not s:match(kr) then u.m("Wrong Key"); return end
		by, u.sb.Text = true, "Checking..."
		local v = ak(o, s, dg)
		by, u.sb.Text = false, "Submit"
		if ge.__AvG ~= tk then return end
		if not v then u.m("Key Server Unreachable"); return end
		if not v[1] then u.m(rs(v[2])); return end
		ac(s, v[2], true)
		if o.Discord and request then task.spawn(inv, tostring(o.Discord)) end
		got = s
	end
	local function sh()
		if u then return end
		u = gc(o, true)
		tk.sg = u.sg
		u.tb:GetPropertyChangedSignal("Text"):Connect(function() if u.tb.Text ~= lk and #u.tb.Text > mx then u.tb.Text = u.tb.Text:sub(1, mx) end end)
		u.tb.FocusLost:Connect(function(en) if en then sub() end end)
		u.sb.Activated:Connect(sub)
		u.gk.Activated:Connect(function()
			for _, nm in {"setclipboard", "toclipboard"} do
				local f = ge[nm]
				if type(f) == "function" and pcall(f, lk) then u.m("Link Copied", c.dm); return end
			end
			u.tb.Text = lk
			u.m("Copy The Link From The Box", c.dm)
		end)
	end
	if kk then
		local v, dn = nil, false
		task.spawn(function() v, dn = ak(o, kk, dg), true end)
		local t = os.clock()
		while not dn do
			if not u and ge.__AvG == tk and os.clock() - t >= 2 then
				sh()
				lc, u.sb.TextTransparency = true, 0.5
				u.m("Checking Key...", c.dm)
			end
			task.wait()
		end
		lc = false
		if u then u.sb.TextTransparency = 0 end
		if ge.__AvG ~= tk then
			if u then u.x() end
			error("Gate Failed: Replaced", 0)
		end
		if v and v[1] then ac(kk, v[2], true); fin(); return kk end
		if v then
			sh()
			u.m(rs(v[2]))
		elseif gr(kx) then
			ac(kk, kx, false)
			fin()
			return kk
		else
			sh()
			u.m("Key Server Unreachable")
		end
	else
		sh()
	end
	repeat task.wait() until got ~= nil
	fin()
	return got
end

function L:Gate(o)
	o = o or {}
	if o.Server ~= nil then
		if o.Check ~= nil then error("Gate Failed: Check And Server", 0) end
		return sgt(o)
	end
	if type(o.Check) ~= "function" then error("Gate Failed: No Check", 0) end
	if not cfn(o.Config) then error("Gate Failed: Bad Config", 0) end
	local mx = o.Max == nil and 24 or tonumber(o.Max)
	if not (mx and mx >= 1) then error("Gate Failed: Bad Max", 0) end
	local kp = o.Config and `Avenoric/Keys/{o.Config}.txt`
	if kp and isfile and isfile(kp) then
		local ok, s = pcall(readfile, kp)
		if ok and type(s) == "string" and s ~= "" then
			local ok2, r = pcall(o.Check, s)
			if ok2 and r == true then return s end
		end
	end
	local u, busy, got = gc(o, o.Link), false, nil
	u.tb:GetPropertyChangedSignal("Text"):Connect(function() if #u.tb.Text > mx then u.tb.Text = u.tb.Text:sub(1, mx) end end)
	local function sub()
		if busy then return end
		local s = (u.tb.Text:gsub("^%s+", ""):gsub("%s+$", ""))
		if s == "" then u.m("Enter A Key"); return end
		busy, u.sb.Text = true, "Checking..."
		local ok, r, m = pcall(o.Check, s)
		busy, u.sb.Text = false, "Submit"
		if not ok then u.m("Key Check Failed: " .. tostring(r)); return end
		if r ~= true then u.m(m and tostring(m) or "Wrong Key"); return end
		if kp then pcall(function() mkd(kp); writefile(kp, s) end) end
		if o.Discord and request then task.spawn(inv, tostring(o.Discord)) end
		got = s
	end
	u.tb.FocusLost:Connect(function(en) if en then sub() end end)
	u.sb.Activated:Connect(sub)
	if u.gk then
		u.gk.Activated:Connect(function()
			if setclipboard then setclipboard(tostring(o.Link)) end
			u.m("Link Copied", c.dm)
		end)
	end
	repeat task.wait() until got ~= nil
	u.x()
	return got
end

function L:Keyed()
	if not ka then return false end
	if os.clock() < ka.t then return ka.v end
	local a, s = pcall(readfile, ka.p)
	ka.v, ka.t = a and type(s) == "string" and ((s:match("^[^\n]*") or ""):match("^%s*(.-)%s*$") or ""):match(kr) ~= nil, os.clock() + 30
	return ka.v
end

function L:Window(o)
	o = o or {}
	if not cfn(o.Config) then error("Window Failed: Bad Config", 0) end
	if ge.__AvW then pcall(ge.__AvW.Destroy, ge.__AvW) end
	local W = {Tabs = {}, Current = nil, cn = {}, key = o.Key == nil and Enum.KeyCode.LeftControl or o.Key, sx = false, sl = "", kw = false, fc = nil, sv = 1, fd = nil, w = ww, h = wh}
	local sg = gui()
	W.Gui = sg
	local mn = mk("Frame", {Name = "Main", Size = UDim2.fromOffset(ww, wh), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c.bg, BorderSizePixel = 0, Parent = sg}, {rc(12), sk(0.85)})
	W.Main = mn
	local sc = mk("UIScale", {Parent = mn})
	local tb = mk("Frame", {Size = UDim2.new(1, 0, 0, th), BackgroundTransparency = 1, Parent = mn})
	tl({Text = tostring(o.Title or "Avenoric"), Font = fb, Position = UDim2.fromOffset(16, 0), Size = UDim2.new(1, -116, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = tb})
	local function cap(x, g)
		local b = bt({Size = UDim2.fromOffset(40, 28), Position = UDim2.new(1, x, 0, 6), BackgroundColor3 = c.hv, Parent = tb}, {rc(6)})
		local i = ig({Text = g, TextSize = 14, TextColor3 = c.dm, Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center, Parent = b})
		b.MouseEnter:Connect(function() if uis.MouseEnabled then tw(b, {BackgroundTransparency = 0}) end end)
		b.MouseLeave:Connect(function() tw(b, {BackgroundTransparency = 1}) end)
		return b, i
	end
	local xb, xi = cap(-46, "x")
	local nb = cap(-88, "minus")
	local tsf = mk("Frame", {AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -12), Size = UDim2.fromOffset(300, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 100, Parent = sg}, {ll(8)})

	function W:Notify(n)
		n = n or {}
		if n.Title == nil and n.Text == nil then error("Notify Failed: No Text", 0) end
		local t = n.Time == nil and 4 or n.Time
		if type(t) ~= "number" or t ~= t or t <= 0 then error("Notify Failed: Bad Time", 0) end
		local f = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = c.cd, BorderSizePixel = 0, ZIndex = 100, Parent = tsf}, {rc(8), sk(0.9), pd(18, 14, 10, 10)})
		mk("Frame", {Position = UDim2.fromOffset(-12, 2), Size = UDim2.new(0, 3, 1, -4), BackgroundColor3 = n.Error and c.er or c.ac, BorderSizePixel = 0, ZIndex = 101, Parent = f}, {rc(2)})
		local lay = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 101, Parent = f}, {ll(2)})
		tl({Text = tostring(n.Title or "Avenoric"), Font = fb, Size = UDim2.new(1, 0, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 102, LayoutOrder = 1, Parent = lay})
		if n.Text ~= nil then tl({Text = tostring(n.Text), TextSize = 13, TextColor3 = c.dm, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, ZIndex = 102, LayoutOrder = 2, Parent = lay}) end
		local us = mk("UIScale", {Scale = 0.9, Parent = f})
		tw(us, {Scale = 1})
		task.delay(t, function() if f.Parent then f:Destroy() end end)
		return f
	end

	local function run(f, ...)
		if not f then return end
		local ok, e = xpcall(f, function(m) return debug.traceback(tostring(m), 2) end, ...)
		if ok then return end
		warn("Callback Failed: " .. tostring(e))
		if L.Lg then pcall(L.Lg, "[Hub] Callback Failed: " .. tostring(e)) end
		W:Notify({Title = "Callback Failed", Text = string.match(tostring(e), "^[^\n]*"), Error = true})
	end

	local cp, cd, dirty, pend, dead = o.Config and `Avenoric/Configs/{o.Config}.json`, {}, false, false, false
	if cp and isfile and isfile(cp) then
		local ok, d = pcall(function() return hs:JSONDecode(readfile(cp)) end)
		if ok and type(d) == "table" then cd = d else
			pcall(function() writefile(cp .. ".bad", readfile(cp)); delfile(cp) end)
			W:Notify({Title = "Config Load Failed", Text = "Invalid Json", Error = true})
		end
	end
	local function save()
		if not cp or not dirty then return end
		dirty = false
		pcall(function()
			mkd(cp)
			writefile(cp, hs:JSONEncode(cd))
		end)
	end
	local function put(e, v)
		if not e.Flag then return end
		L.Flags[e.Flag] = v
		if not cp then return end
		if e.sv then cd[e.Flag] = e.sv(v) else cd[e.Flag] = v end
		dirty = true
		if pend or dead then return end
		pend = true
		task.delay(0.5, function() pend = false; save() end)
	end
	local function done(e)
		if not e.Flag then return end
		L.Flags[e.Flag] = e:Get()
		local s = cd[e.Flag]
		if s == nil then return end
		pcall(function()
			if e.ld then s = e.ld(s) end
			e:Set(s)
		end)
	end

	local nv = mk("Frame", {Position = UDim2.fromOffset(12, th + 4), Size = UDim2.new(0, nw, 1, -(th + 16)), BackgroundTransparency = 1, Parent = mn})
	local sbx = mk("Frame", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = c.cd, BorderSizePixel = 0, ClipsDescendants = true, Parent = nv}, {rc(6), sk(0.9)})
	local sst = sbx:FindFirstChildOfClass("UIStroke")
	ig({Text = "magnifying-glass", TextSize = 14, TextColor3 = c.dm, Position = UDim2.fromOffset(9, 0), Size = UDim2.fromOffset(16, 32), Parent = sbx})
	local sb = mk("TextBox", {BackgroundTransparency = 1, Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -36, 1, 0), Font = fn, TextSize = 13, TextColor3 = c.tx, PlaceholderText = "Search", PlaceholderColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Text = "", Parent = sbx})
	sb.Focused:Connect(function() tw(sst, {Color = c.ac, Transparency = 0}) end)
	sb.FocusLost:Connect(function() tw(sst, {Color = c.tx, Transparency = 0.9}) end)
	local tf = mk("ScrollingFrame", {Position = UDim2.fromOffset(0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, Parent = nv}, {ll(4)})
	local pg = mk("Frame", {Position = UDim2.fromOffset(nw + 20, th + 4), Size = UDim2.new(1, -(nw + 32), 1, -(th + 16)), BackgroundTransparency = 1, ClipsDescendants = true, Parent = mn})
	local function page()
		local p = mk("ScrollingFrame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = c.dm, ScrollBarImageTransparency = 0.5, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, Visible = false, Parent = pg}, {ll(4), pd(2, 8, 2, 4)})
		for _, k in {"CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize"} do p:GetPropertyChangedSignal(k):Connect(function() W.fd() end) end
		return p
	end
	local sr = page()
	local function fade(top)
		local f = mk("Frame", {Size = UDim2.new(1, -8, 0, 20), Position = top and UDim2.new() or UDim2.new(0, 0, 1, -20), BackgroundColor3 = c.bg, BorderSizePixel = 0, ZIndex = 5, Visible = false, Parent = pg})
		mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(top and 0 or 1, top and 1 or 0), Parent = f})
		return f
	end
	local ft, fb2 = fade(true), fade(false)
	local function fd()
		local p = W.sx and sr or W.Current and W.Current.Page
		if not p then ft.Visible, fb2.Visible = false, false; return end
		ft.Visible, fb2.Visible = p.CanvasPosition.Y > 1, p.AbsoluteCanvasSize.Y - p.AbsoluteWindowSize.Y - p.CanvasPosition.Y > 1
	end
	W.fd = fd
	local ov = bt({Size = UDim2.fromScale(1, 1), ZIndex = 50, Visible = false, Parent = mn})
	ov.Activated:Connect(function() if W.fc then W.fc() end end)
	local fl = bt({Size = UDim2.fromOffset(44, 44), BackgroundColor3 = Color3.fromRGB(18, 18, 21), BackgroundTransparency = 0.08, Parent = sg}, {rc(22)})
	ig({Text = "studio", FontFace = ib, TextSize = 24, TextColor3 = Color3.fromRGB(247, 247, 248), Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(24, 24), Active = false, Parent = fl})

	local function cl()
		local s, n, hw, hh = sg.AbsoluteSize, gs:GetGuiInset().Y, W.w * sc.Scale / 2, W.h * sc.Scale / 2
		mn.Position = UDim2.fromOffset(math.clamp(mn.Position.X.Offset, hw, s.X - hw), math.clamp(mn.Position.Y.Offset, n + hh, s.Y - hh))
	end
	local function rsz(w, h)
		local s, n = sg.AbsoluteSize, gs:GetGuiInset().Y
		W.w, W.h = math.clamp(math.round(tonumber(w) or W.w), 420, math.max(420, s.X - 24)), math.clamp(math.round(tonumber(h) or W.h), 260, math.max(260, s.Y - n - 24))
		mn.Size = UDim2.fromOffset(W.w, W.h)
		W.sv = math.clamp(math.min((s.X - 24) / W.w, (s.Y - n - 24) / W.h), 0.5, 1)
		sc.Scale = W.sv
		cl()
	end
	local function fx()
		W.sv = fit(sg, mn, sc, W.w, W.h)
		fl.Position = UDim2.fromOffset(16, gs:GetGuiInset().Y + 8)
	end
	function W:Resize(w, h) rsz(w, h) end
	fx()
	local dr
	local function hd(p, ax, ay)
		local b = bt({AnchorPoint = p.AnchorPoint, Position = p.Position, Size = p.Size, ZIndex = 3, Parent = mn})
		table.insert(W.cn, b.InputBegan:Connect(function(i)
			if i.UserInputType ~= mb and i.UserInputType ~= tc then return end
			local w0, h0, d0, s0 = W.w, W.h, i.Position, sc.Scale
			local lx, ly = mn.Position.X.Offset - W.w * s0 / 2, mn.Position.Y.Offset - W.h * s0 / 2
			dr = {i = i, mv = function(q)
				rsz(ax and w0 + (q.X - d0.X) / s0 or W.w, ay and h0 + (q.Y - d0.Y) / s0 or W.h)
				mn.Position = UDim2.fromOffset(lx + W.w * sc.Scale / 2, ly + W.h * sc.Scale / 2)
				cl()
			end}
		end))
	end
	hd({AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Size = UDim2.fromOffset(16, 16)}, true, true)
	hd({AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, -16, 0, 10)}, false, true)
	hd({AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, th), Size = UDim2.new(0, 10, 1, -(th + 16))}, true, false)
	table.insert(W.cn, sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(fx))

	function W:Show()
		mn.Visible, sc.Scale = true, W.sv
	end
	function W:Hide() mn.Visible = false end
	local function tg() if mn.Visible then W:Hide() else W:Show() end end
	fl.Activated:Connect(tg)
	nb.Activated:Connect(function() W:Hide() end)
	local arm, an = false, 0
	xb.Activated:Connect(function()
		if arm then (W :: any):Destroy(); return end
		arm, an = true, an + 1
		local n = an
		tw(xb, {BackgroundColor3 = c.er, BackgroundTransparency = 0})
		xi.TextColor3 = Color3.new(1, 1, 1)
		task.delay(3, function()
			if an ~= n or not arm then return end
			arm = false
			tw(xb, {BackgroundColor3 = c.hv, BackgroundTransparency = 1})
			xi.TextColor3 = c.dm
		end)
	end)

	table.insert(W.cn, tb.InputBegan:Connect(function(i)
		if i.UserInputType ~= mb and i.UserInputType ~= tc then return end
		local p0, d0 = mn.Position, i.Position
		dr = {i = i, mv = function(p)
			local s, n, hw, hh = sg.AbsoluteSize, gs:GetGuiInset().Y, mn.AbsoluteSize.X / 2, mn.AbsoluteSize.Y / 2
			mn.Position = UDim2.fromOffset(math.clamp(p0.X.Offset + p.X - d0.X, hw, s.X - hw), math.clamp(p0.Y.Offset + p.Y - d0.Y, n + hh, s.Y - hh))
		end}
	end))
	table.insert(W.cn, uis.InputChanged:Connect(function(i)
		if not dr or (i.UserInputType ~= mm and i ~= dr.i) then return end
		dr.mv(i.Position)
	end))
	table.insert(W.cn, uis.InputEnded:Connect(function(i)
		if not dr or (i ~= dr.i and i.UserInputType ~= mb) then return end
		if dr.up then dr.up() end
		dr = nil
	end))
	table.insert(W.cn, uis.InputBegan:Connect(function(i)
		if i.UserInputType ~= kb or W.kw or not W.key or i.KeyCode ~= W.key or uis:GetFocusedTextBox() then return end
		tg()
	end))

	local function jump(e)
		local p = e.Tab.Page
		p.CanvasPosition = Vector2.new(0, math.max(0, (e.Row.AbsolutePosition.Y - p.AbsolutePosition.Y) / sc.Scale + p.CanvasPosition.Y - 4))
		local st = e.Row:FindFirstChildOfClass("UIStroke")
		if not st then return end
		tw(st, {Color = c.ac, Transparency = 0})
		task.delay(0.8, function() tw(st, {Color = c.tx, Transparency = 0.92}, 0.4) end)
	end

	function W:Search(s)
		s = tostring(s or "")
		W.sl = s
		if sb.Text ~= s then sb.Text = s end
		for _, x in sr:GetChildren() do
			if x:IsA("GuiButton") then x:Destroy() end
		end
		if s == "" then
			if not W.sx then return nil end
			W.sx, sr.Visible = false, false
			if W.Current then W.Current.Page.Visible = true end
			fd()
			return nil
		end
		local n, q = 0, s:lower()
		for _, T in W.Tabs do
			for _, e in T.Rows do
				if e.Kind ~= "Section" and e.Kind ~= "Label" and e.Name:lower():find(q, 1, true) then
					n += 1
					local b = bt({Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = c.cd, LayoutOrder = n, Parent = sr}, {rc(6), sk(0.92), pd(12, 12)})
					tl({Text = e.Name, Size = UDim2.new(0.6, 0, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
					tl({Text = e.Sec and `{T.Name} · {e.Sec}` or T.Name, TextSize = 12, TextColor3 = c.dm, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
					hov(b, function() return c.cd end)
					b.Activated:Connect(function()
						W:Search("")
						T:Select()
						task.defer(jump, e)
					end)
				end
			end
		end
		if not W.sx then
			W.sx, sr.Visible = true, true
			if W.Current then W.Current.Page.Visible = false end
		end
		fd()
		return n
	end
	sb:GetPropertyChangedSignal("Text"):Connect(function() if sb.Text ~= W.sl then W:Search(sb.Text) end end)

	function W:Tab(t)
		t = t or {}
		local T = {Rows = {}, Name = tostring(t.Name or "Tab"), W = W, n = 0, sec = nil}
		local b = bt({Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = c.cd, LayoutOrder = #W.Tabs + 1, Parent = tf}, {rc(6)})
		local bar = mk("Frame", {Size = UDim2.fromOffset(3, 16), Position = UDim2.fromOffset(0, 10), BackgroundColor3 = c.ac, BorderSizePixel = 0, Visible = false, Parent = b}, {rc(2)})
		local ico = t.Icon and ig({Text = tostring(t.Icon), TextColor3 = c.dm, Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(20, 36), TextXAlignment = Enum.TextXAlignment.Center, Parent = b})
		local nm = tl({Text = T.Name, TextColor3 = c.dm, Position = UDim2.fromOffset(ico and 38 or 12, 0), Size = UDim2.new(1, -(ico and 46 or 20), 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
		local p = page()
		T.Page, T.Btn = p, b
		local function paint(on)
			tw(b, {BackgroundTransparency = on and 0 or 1})
			bar.Visible, nm.TextColor3 = on, on and c.tx or c.dm
			if ico then ico.TextColor3, ico.FontFace = on and c.tx or c.dm, on and ib or ir end
		end
		T.pt = paint
		b.MouseEnter:Connect(function() if uis.MouseEnabled then tw(b, {BackgroundColor3 = c.hv, BackgroundTransparency = 0}) end end)
		b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = c.cd, BackgroundTransparency = W.Current == T and 0 or 1}) end)
		function T:Select()
			if W.sx then W:Search("") end
			if W.Current == T then return end
			if W.Current then W.Current.Page.Visible = false; W.Current.pt(false) end
			W.Current, p.Visible = T, true
			paint(true)
			fd()
		end
		b.Activated:Connect(function() T:Select() end)
		table.insert(W.Tabs, T)
		if not W.Current then T:Select() else paint(false) end

		local function add(e)
			T.n += 1
			e.Row.LayoutOrder = T.n
			table.insert(T.Rows, e)
			return e
		end
		local function row(k, r)
			if type(r.Name) ~= "string" then error(`{k} Failed: Bad Name`, 0) end
			if r.Flag ~= nil and type(r.Flag) ~= "string" then error(`{k} Failed: Bad Flag`, 0) end
			local f = bt({Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = c.cd, Parent = p}, {rc(6), sk(0.92), pd(12, 12)})
			hov(f, function() return c.cd end)
			local l = tl({Text = r.Name, Size = UDim2.new(0.5, 0, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = f})
			local e = {Row = f, Kind = k, Name = r.Name, Flag = r.Flag, Tab = T, Sec = T.sec, Label = l}
			function e:Get() return (e :: any).v end
			return add(e), f, l
		end
		local function txt(e, l)
			function e:Set(s) l.Text = tostring(s) end
			function e:Get() return l.Text end
			return e
		end

		function T:Section(r)
			r = r or {}
			local l = tl({Text = tostring(r.Name or ""), Font = fb, TextSize = 13, Size = UDim2.new(1, 0, 0, 30), TextYAlignment = Enum.TextYAlignment.Bottom, Parent = p}, {pd(4, 0, 0, 4)})
			T.sec = l.Text
			return txt(add({Row = l, Kind = "Section", Name = l.Text, Tab = T}), l)
		end

		function T:Label(r)
			r = r or {}
			local f = mk("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = c.cd, BorderSizePixel = 0, Parent = p}, {rc(6), sk(0.92), pd(12, 12, 10, 10)})
			local l = tl({Text = tostring(r.Text or ""), TextSize = 13, TextColor3 = c.dm, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextWrapped = true, Parent = f})
			return txt(add({Row = f, Kind = "Label", Name = l.Text, Tab = T, Sec = T.sec}), l)
		end

		function T:Button(r)
			r = r or {}
			local e, f, l = row("Button", r)
			ig({Text = "chevron-small-right", TextSize = 14, TextColor3 = c.dm, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(16, 44), TextXAlignment = Enum.TextXAlignment.Center, Parent = f})
			f.Activated:Connect(function() run(r.Callback) end)
			return txt(e, l)
		end

		function T:Toggle(r)
			r = r or {}
			local e, f = row("Toggle", r)
			local sw = mk("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(40, 20), BackgroundColor3 = c.ac, BackgroundTransparency = 1, BorderSizePixel = 0, Parent = f}, {rc(10), sk(0.2, c.dm)})
			local st = sw:FindFirstChildOfClass("UIStroke")
			local kn = mk("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 4, 0.5, 0), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = c.dm, BorderSizePixel = 0, Parent = sw}, {rc(6)})
			local sl = tl({Text = "Off", TextSize = 13, TextColor3 = c.dm, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -48, 0, 0), Size = UDim2.fromOffset(40, 44), TextXAlignment = Enum.TextXAlignment.Right, Parent = f})
			e.v, e.ld = r.Default == true, function(s) return s == true end
			local function draw(a)
				local on, g = e.v, a and tw or function(x, q) for i, v in q do x[i] = v end end
				g(sw, {BackgroundTransparency = on and 0 or 1})
				g(st, {Transparency = on and 1 or 0.2})
				g(kn, {Position = UDim2.new(0, on and 24 or 4, 0.5, 0), BackgroundColor3 = on and c.bg or c.dm})
				sl.Text = on and "On" or "Off"
			end
			draw(false)
			function e:Set(v)
				v = v == true
				if v == e.v then return end
				e.v = v
				draw(true)
				put(e, v)
				run(r.Callback, v)
			end
			f.Activated:Connect(function() e:Set(not e.v) end)
			done(e)
			return e
		end

		function T:Slider(r)
			r = r or {}
			local lo, hi, st = tonumber(r.Min), tonumber(r.Max), r.Step == nil and 1 or tonumber(r.Step)
			if not (lo and hi and hi > lo) then error("Slider Failed: Bad Range", 0) end
			if not (st and st > 0) then error("Slider Failed: Bad Step", 0) end
			local e, f = row("Slider", r)
			local vl = tl({Text = "", TextSize = 13, TextColor3 = c.dm, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(44, 44), TextXAlignment = Enum.TextXAlignment.Right, Parent = f})
			local hit = bt({AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -52, 0.5, 0), Size = UDim2.fromOffset(120, 28), Parent = f})
			local tr = mk("Frame", {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 4), BackgroundColor3 = c.hv, BorderSizePixel = 0, Parent = hit}, {rc(2)})
			local fi = mk("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = c.ac, BorderSizePixel = 0, Parent = tr}, {rc(2)})
			local kn = mk("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = c.ac, BorderSizePixel = 0, Parent = hit}, {rc(7), mk("UIStroke", {Color = c.bg, Thickness = 2})})
			local function q(v) return math.clamp(lo + math.round((v - lo) / st) * st, lo, hi) end
			local d0 = r.Default
			e.v, e.ld = q(type(d0) == "number" and d0 == d0 and d0 or lo), tonumber
			local function draw()
				local a = (e.v - lo) / (hi - lo)
				fi.Size, kn.Position, vl.Text = UDim2.new(a, 0, 1, 0), UDim2.new(a, 0, 0.5, 0), ("%g"):format(e.v)
			end
			draw()
			function e:Set(v)
				if type(v) ~= "number" or v ~= v then error("Slider Set Failed: Not A Number", 0) end
				v = q(v)
				if v == e.v then return end
				e.v = v
				draw()
				put(e, v)
				run(r.Callback, v)
			end
			local function at(x) e:Set(lo + math.clamp((x - hit.AbsolutePosition.X) / hit.AbsoluteSize.X, 0, 1) * (hi - lo)) end
			hit.InputBegan:Connect(function(i)
				if i.UserInputType ~= mb and i.UserInputType ~= tc then return end
				p.ScrollingEnabled = false
				dr = {i = i, mv = function(v) at(v.X) end, up = function() p.ScrollingEnabled = true end}
				at(i.Position.X)
			end)
			done(e)
			return e
		end

		function T:Dropdown(r)
			r = r or {}
			if type(r.Options) ~= "table" then error("Dropdown Failed: Bad Options", 0) end
			local e, f = row("Dropdown", r)
			local mu = r.Multi == true
			e.Options = {}
			local function opts(l)
				local seen = {}
				e.Options = {}
				for _, s in l do
					if type(s) == "string" and not seen[s] then seen[s] = true; table.insert(e.Options, s) end
				end
			end
			opts(r.Options)
			local box = bt({AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(150, 28), BackgroundColor3 = c.bg, Parent = f}, {rc(4), sk(0.9)})
			local bl = tl({Text = "", TextSize = 13, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -34, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = box})
			local ch = ig({Text = "chevron-small-down", TextSize = 14, TextColor3 = c.dm, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 0), Size = UDim2.fromOffset(16, 28), TextXAlignment = Enum.TextXAlignment.Center, Parent = box})
			local function norm(v)
				if mu then
					if type(v) ~= "table" then error("Dropdown Set Failed: Not A Table", 0) end
					local want, out = {}, {}
					for _, s in v do want[s] = true end
					for _, s in e.Options do
						if want[s] then table.insert(out, s) end
					end
					return out
				end
				if v == nil then return nil end
				if table.find(e.Options, v) then return v end
				error("Dropdown Set Failed: Unknown Option", 0)
			end
			local function same(a, b)
				if not mu then return a == b end
				if #a ~= #b then return false end
				for i, s in a do
					if b[i] ~= s then return false end
				end
				return true
			end
			e.v = if mu then (if type(r.Default) == "table" then norm(r.Default) else {}) else (if table.find(e.Options, r.Default) then r.Default else nil)
			if mu then e.ld = function(s) return type(s) == "table" and s or {} end else e.sv, e.ld = function(v) return if v == nil then false else v end, function(s) return s ~= false and s or nil end end
			local function has(s) return mu and table.find(e.v, s) ~= nil or not mu and e.v == s end
			local function draw()
				local any = mu and #e.v > 0 or not mu and e.v ~= nil
				bl.Text, bl.TextColor3 = any and (mu and table.concat(e.v, ", ") or e.v) or "None", any and c.tx or c.dm
			end
			draw()
			function e:Get() return mu and table.clone(e.v) or e.v end
			local function emit(v)
				e.v = v
				draw()
				put(e, e:Get())
				run(r.Callback, e:Get())
			end
			function e:Set(v)
				v = norm(v)
				if same(v, e.v) then return end
				emit(v)
			end
			function e:Refresh(l)
				if type(l) ~= "table" then error("Dropdown Refresh Failed: Bad Options", 0) end
				opts(l)
				local v = mu and norm(e.v) or (table.find(e.Options, e.v) and e.v or nil)
				if not same(v, e.v) then emit(v) end
				draw()
			end
			local fy
			local function close()
				if not fy then return end
				fy:Destroy()
				fy, ov.Visible, ch.Text, W.fc = nil, false, "chevron-small-down", nil
			end
			local function open()
				if fy then close(); return end
				if W.fc then W.fc() end
				W.fc, ov.Visible, ch.Text = close, true, "chevron-small-up"
				local s, bp = sc.Scale, (box.AbsolutePosition - mn.AbsolutePosition) / sc.Scale
				local h = math.max(math.min(#e.Options, 5), 1) * 32 + 8
				local y = bp.Y + 32
				if y + h > W.h - 8 then y = bp.Y - h - 4 end
				fy = mk("Frame", {Position = UDim2.fromOffset(bp.X, y), Size = UDim2.fromOffset(box.AbsoluteSize.X / s, h), BackgroundColor3 = c.cd, BorderSizePixel = 0, Parent = ov}, {rc(6), sk(0.85), pd(4, 4, 4, 4)})
				local ls = mk("ScrollingFrame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = c.dm, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), ScrollingDirection = Enum.ScrollingDirection.Y, Parent = fy}, {ll(0)})
				if #e.Options == 0 then tl({Text = "No Options", TextSize = 13, TextColor3 = c.dm, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -10, 0, 32), Parent = ls}) end
				for n, s in e.Options do
					local sel = has(s)
					local b = bt({Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = c.hv, BackgroundTransparency = sel and 0 or 1, LayoutOrder = n, Parent = ls}, {rc(4)})
					tl({Text = s, TextSize = 13, Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -36, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = b})
					local ck = ig({Text = "check", TextSize = 14, TextColor3 = c.ac, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 0), Size = UDim2.fromOffset(16, 32), TextXAlignment = Enum.TextXAlignment.Center, Visible = sel, Parent = b})
					b.MouseEnter:Connect(function() if uis.MouseEnabled then tw(b, {BackgroundTransparency = 0}) end end)
					b.MouseLeave:Connect(function() tw(b, {BackgroundTransparency = has(s) and 0 or 1}) end)
					b.Activated:Connect(function()
						if not mu then e:Set(s); close(); return end
						local v, i = e:Get(), table.find(e.v, s)
						if i then table.remove(v, i) else table.insert(v, s) end
						e:Set(v)
						ck.Visible = has(s)
						tw(b, {BackgroundTransparency = ck.Visible and 0 or 1})
					end)
				end
			end
			box.Activated:Connect(open)
			hov(box, function() return c.bg end)
			done(e)
			return e
		end

		function T:TextBox(r)
			r = r or {}
			local e, f = row("TextBox", r)
			local bx = mk("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(150, 28), BackgroundColor3 = c.bg, BorderSizePixel = 0, ClipsDescendants = true, Parent = f}, {rc(4), sk(0.9)})
			local st = bx:FindFirstChildOfClass("UIStroke")
			local x = mk("TextBox", {BackgroundTransparency = 1, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0), Font = fn, TextSize = 13, TextColor3 = c.tx, PlaceholderText = tostring(r.Placeholder or ""), PlaceholderColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Text = type(r.Default) == "string" and r.Default or "", Parent = bx})
			e.v, e.ld = x.Text, tostring
			function e:Set(v)
				v = tostring(v)
				x.Text = v
				if v == e.v then return end
				e.v = v
				put(e, v)
				run(r.Callback, v)
			end
			x.Focused:Connect(function() tw(st, {Color = c.ac, Transparency = 0}) end)
			x.FocusLost:Connect(function()
				tw(st, {Color = c.tx, Transparency = 0.9})
				e:Set(x.Text)
			end)
			done(e)
			return e
		end

		local function kc(v)
			if v == nil then return nil end
			if typeof(v) == "EnumItem" and v.EnumType == Enum.KeyCode then return v end
			return false
		end

		function T:Keybind(r)
			r = r or {}
			local d = kc(r.Default)
			if d == false then error("Keybind Failed: Bad Key", 0) end
			local e, f = row("Keybind", r)
			local cb = bt({AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(0, 24), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = c.bg, Parent = f}, {rc(4), sk(0.9), pd(10, 10)})
			local kl = tl({Text = "", TextSize = 12, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, TextXAlignment = Enum.TextXAlignment.Center, Parent = cb})
			local wt = false
			e.v, e.sv, e.ld = d, function(v) return v and v.Name or false end, function(s) return type(s) == "string" and Enum.KeyCode[s] or nil end
			local function draw()
				kl.Text, kl.TextColor3 = wt and "..." or (e.v and e.v.Name or "None"), (wt or e.v) and c.tx or c.dm
			end
			draw()
			function e:Set(v)
				local k = kc(v)
				if k == false then error("Keybind Set Failed: Bad Key", 0) end
				if k == e.v then return end
				e.v = k
				draw()
				put(e, k)
			end
			hov(cb, function() return c.bg end)
			cb.Activated:Connect(function()
				wt = not wt
				W.kw = wt
				draw()
			end)
			table.insert(W.cn, uis.InputBegan:Connect(function(i, gp)
				if i.UserInputType ~= kb then return end
				if wt then
					wt, W.kw = false, false
					if i.KeyCode == Enum.KeyCode.Backspace then e:Set(nil) elseif i.KeyCode ~= Enum.KeyCode.None then e:Set(i.KeyCode) end
					draw()
					return
				end
				if gp or not e.v or i.KeyCode ~= e.v or uis:GetFocusedTextBox() then return end
				run(r.Callback)
			end))
			done(e)
			return e
		end

		return T
	end

	function W:Destroy()
		dead = true
		for _, x in W.cn do x:Disconnect() end
		W.cn = {}
		save()
		sg:Destroy()
		if ge.__AvW == W then ge.__AvW = nil end
	end

	ge.__AvW = W
	return W
end

return L
end)()

if ge.__AvW then pcall(ge.__AvW.Destroy, ge.__AvW) end
local W = L:Window({Title = "Ngao - Gaming Hub | Cameraman Tower Defense", Config = `CameramanTowerDefense/{lp.Name}`})
L.Lg = lg
do
	local wn0 = W.Notify
	function W:Notify(n)
		if type(n) == "table" then lg(`[{n.Title or "Avenoric"}] {n.Text or ""}`) end
		return wn0(self, n)
	end
	local ui = game:GetService("UserInputService")
	lg(`[Hub] Loaded | {pl} {game.PlaceVersion} | Server {game.JobId:sub(1, 8)} | {#ps:GetPlayers()} Players | {identifyexecutor and select(2, pcall(identifyexecutor)) or "?"} | {ui.TouchEnabled and not ui.KeyboardEnabled and "Mobile" or "PC"} | Joined {string.format("%.1f", time())} s Ago`, true)
end

local hs = game:GetService("HttpService")
local function at(k) return workspace:GetAttribute(k) end
local function rm(n) return getrenv().shared.Modules.Network.Get(n) end

local function rd()
	local ok, d = pcall(function() return getrenv().shared.Modules.Replication.GetCurrentReplica().Data end)
	return ok and type(d) == "table" and d or nil
end

local function me(k)
	local ok, l = pcall(hs.JSONDecode, hs, at(k) or "[]")
	return ok and type(l) == "table" and table.find(l, lp.UserId) ~= nil
end

local function xp()
	local d = rd()
	if d and (type(d.ActivatedGamepasses) == "table" and d.ActivatedGamepasses["X2 Speed"] == true or (tonumber(d.Wins) or 0) >= 200) then return 2 end
	local ok, g = pcall(lp.IsInGroup, lp, game.CreatorId)
	return ok and g == true and 1.5 or nil
end

local function tc(n) return getrenv().shared.Modules.Config.Towers[n] end
local function gm(n) return workspace:WaitForChild("Game"):WaitForChild(n) end

local function mo()
	local s = lp:FindFirstChild("leaderstats")
	local m = s and s:FindFirstChild("Money")
	return m and m.Value or 0
end

local pc = {s = nil :: any, y = 0}
local function pth()
	if pc.s then return pc.s, pc.y end
	local w = {}
	for _, p in gm("Waypoints"):GetChildren() do
		local n = tonumber(p.Name)
		if n and p:IsA("BasePart") then table.insert(w, {n, p.Position}) end
	end
	table.sort(w, function(a, b) return a[1] < b[1] end)
	if #w < 2 then return nil, nil end
	local s, y = {}, 0
	for i = 1, #w - 1 do
		local a, b = w[i][2], w[i + 1][2]
		local k = math.max(math.ceil((b - a).Magnitude), 1)
		for j = 0, k - 1 do table.insert(s, a:Lerp(b, j / k)) end
	end
	table.insert(s, w[#w][2])
	for _, p in s do y += p.Y end
	pc.s, pc.y = s, y / #s
	return pc.s, pc.y
end

local function cv(p, r)
	local s = pth()
	if not s then return 0 end
	local n, r2 = 0, r * r
	for _, q in s do
		local dx, dz = q.X - p.X, q.Z - p.Z
		if dx * dx + dz * dz <= r2 then n += 1 end
	end
	return n / #s
end

local function gd(x, z)
	local _, y = pth()
	local rp = RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {gm("TowerArea"), gm("Paths")}
	local r = workspace:Raycast(Vector3.new(x, y + 60, z), Vector3.new(0, -200, 0), rp)
	return r and math.abs(r.Position.Y - y) <= 3 and r.Position or nil
end

local bc = {}
local function bs(r)
	if bc[r] ~= nil then return bc[r] or nil end
	local s = pth()
	if not s then return nil end
	local x0, x1, z0, z1 = math.huge, -math.huge, math.huge, -math.huge
	for _, q in s do x0, x1, z0, z1 = math.min(x0, q.X), math.max(x1, q.X), math.min(z0, q.Z), math.max(z1, q.Z) end
	local bv, bp = 0, nil
	for x = math.floor(x0 - r), math.ceil(x1 + r) do
		for z = math.floor(z0 - r), math.ceil(z1 + r) do
			local v = cv(Vector3.new(x, 0, z), r)
			if v > bv then
				local g = gd(x, z)
				if g then bv, bp = v, g end
			end
		end
		task.wait()
	end
	bc[r] = bp or false
	lg(bp and `[Play] Spot ({math.floor(bp.X)}, {math.floor(bp.Z)}) For Range {r} | Covers {math.floor(bv * 100)}% Of Path` or `[Play] Spot For Range {r} Failed: No Ground`)
	return bp
end

local function ed(u, p)
	if not u then return 0 end
	local v = type(u.AllyDPS) == "number" and u.AllyDPS or 0
	for _, a in {u, table.unpack(u.SecondaryAttacks or {})} do
		if type(a.Damage) == "number" and type(a.Cooldown) == "number" and a.Cooldown > 0 and type(a.Range) == "number" then v += a.Damage / a.Cooldown * cv(p, a.Range) end
	end
	return v
end

local function tw()
	local s = getrenv().shared.Modules.Modes
	s = type(s) == "table" and s[at("Mode") or ""]
	local n = 0
	for _ in string.gmatch(type(s) == "string" and s or "", "WAVE:") do n += 1 end
	return n
end

local function sp(u)
	if type(u.Range) == "number" and u.Range > 0 then return bs(u.Range) end
	local s = pth()
	local q = s and s[#s]
	return q and gd(q.X, q.Z) or nil
end

local function my()
	local t = {}
	for k, v in getrenv().shared.Modules.GameReplicator.Data.Towers or {} do
		if tonumber(v.OwnerUserId) == lp.UserId then table.insert(t, {Id = tostring(v.Id or k), Name = v.Name, Level = tonumber(v.Level) or 1, Pos = v.Pos}) end
	end
	return t
end

local function ht()
	local t, d = {}, rd()
	local n = getrenv().shared.Modules.Config.GameSettings.HotbarSlots or 5
	for k, v in d and d.Towers or {} do
		if type(v.Equipped) == "number" and v.Equipped >= 1 and v.Equipped <= n then table.insert(t, {Name = v.Name, Uid = k}) end
	end
	return t
end

local function tb(m) return debug.traceback(tostring(m), 2) end

local function xs()
	local hb = {}
	for _, x in ht() do table.insert(hb, x.Name) end
	if pl == "Lobby" then
		local d, n = rd() or {}, 0
		for _ in d.Towers or {} do n += 1 end
		return `[State] Lobby | Money {d.Money or "?"} | Wins {d.Wins or "?"} | Towers {n}/{d.InventorySpace or "?"} | Hotbar {table.concat(hb, ", ")}`
	end
	local g, tl, mt, gc = workspace:FindFirstChild("Game"), {}, my(), {}
	local b = g and g:FindFirstChild("Base")
	for _, x in mt do
		local k = `{x.Name} Lv{x.Level}`
		if not gc[k] then table.insert(tl, k) end
		gc[k] = (gc[k] or 0) + 1
	end
	table.sort(tl)
	for i, k in tl do tl[i] = `{k} x{gc[k]}` end
	local P = ge.__CtdMp
	local mq = st.um and (P and P.j == game.JobId and `{P.q} Step {P.i}/{P.S and #P.S or "?"}{P.x and " Stopped" or ""}{P.z and " Done" or ""}` or "On, Not Started") or "Off"
	return `[State] Match | {at("Map") or "?"} {at("Mode") or "-"} | {at("GameState") or "?"} Wave {at("Wave") or "?"} | Money {mo()} | Base {b and b:GetAttribute("Health") or "?"}/{b and b:GetAttribute("MaxHealth") or "?"} | Towers {#mt}: {#tl > 0 and table.concat(tl, ", ") or "None"} | Hotbar {table.concat(hb, ", ")} | Auto Play {st.pl and "On" or "Off"} | Macro {mq}`
end

local xd = {}
local function xe(t, e)
	local s = `[Error] {t} Failed: {e}`
	if os.clock() - (xd[s] or -math.huge) < 60 then return end
	xd[s] = os.clock()
	lg(s)
	local ok, v = pcall(xs)
	if ok then lg(v) end
end

local function la(U, l0, p)
	local b0, c, br = ed(U[l0], p), 0, 0
	for k = l0 + 1, #U do
		if type(U[k].Price) ~= "number" then return 0 end
		c += U[k].Price
		local g = ed(U[k], p) - b0
		if g > 0 and g / c > br then br = g / c end
	end
	return br
end

local function pk()
	local mt, cn, dl, fl, hd = my(), {}, {}, {}, false
	for _, x in mt do
		cn[x.Name] = (cn[x.Name] or 0) + 1
		local c = tc(x.Name)
		if c and c.Upgrades and typeof(x.Pos) == "Vector3" and ed(c.Upgrades[x.Level], x.Pos) > 0 then hd = true end
	end
	local rw = math.max(tw() - (at("Wave") or 0), 0)
	local function fo(l, o, d)
		if hd and d > 0 and rw * d >= 2 * o.c then
			o.r, o.f = rw * d / o.c, true
			table.insert(l, o)
		end
	end
	for _, h in ht() do
		local c = tc(h.Name)
		local U = c and c.Upgrades
		local u = U and U[1]
		if u and type(u.Price) == "number" and #mt < st.mx and (not c.PlacementLimit or (cn[h.Name] or 0) < c.PlacementLimit) then
			local p = sp(u)
			if p then
				local r = la(U, 0, p)
				if r > 0 then table.insert(dl, {k = "a", h = h, p = p, c = u.Price, r = r}) end
				fo(fl, {k = "a", h = h, p = p, c = u.Price}, tonumber(u.CashPerWave) or 0)
			end
		end
	end
	for _, x in mt do
		local c = tc(x.Name)
		local U = c and c.Upgrades
		local a, b = U and U[x.Level], U and U[x.Level + 1]
		if a and b and type(b.Price) == "number" and typeof(x.Pos) == "Vector3" then
			local r = la(U, x.Level, x.Pos)
			if r > 0 then table.insert(dl, {k = "u", x = x, c = b.Price, r = r}) end
			fo(fl, {k = "u", x = x, c = b.Price}, (tonumber(b.CashPerWave) or 0) - (tonumber(a.CashPerWave) or 0))
		end
	end
	local bb = gm("Base")
	local bf = (tonumber(bb:GetAttribute("Health")) or 0) >= (tonumber(bb:GetAttribute("MaxHealth")) or math.huge)
	local bo, ch: {any} = nil, (bf and #fl > 0 or #dl == 0) and fl or dl
	for _, o in ch do
		if not bo or o.r > bo.r then bo = o end
	end
	return bo
end

local function ac(o)
	local t = os.clock()
	if o.k == "a" then
		local n0, m = #my(), tc(o.h.Name).Model
		local f, z = m:GetBoundingBox()
		local cf = CFrame.new(o.p + Vector3.new(0, math.max(m:GetPivot().Position.Y - (f.Position.Y - z.Y / 2), 0), 0))
		rm("TowerAdd"):FireServer({Name = o.h.Name, UnitId = o.h.Uid, Pos = cf.Position, CFrame = cf})
		while #my() <= n0 and os.clock() - t < 3 do task.wait(0.1) end
		return #my() > n0
	end
	local function lv()
		local x = getrenv().shared.Modules.GameReplicator.Data.Towers[o.x.Id]
		return x and tonumber(x.Level) or 0
	end
	rm("TowerUpgrade"):FireServer({Id = o.x.Id})
	while lv() <= o.x.Level and os.clock() - t < 3 do task.wait(0.1) end
	return lv() > o.x.Level
end

local function eb(e)
	local a = e:FindFirstChild("Area")
	return a and a:IsA("BasePart") and a or e:FindFirstChildWhichIsA("BasePart")
end

local function jn()
	local c = lp.Character
	local hr = c and c:FindFirstChild("HumanoidRootPart")
	if not hr then
		lg("[Join] Failed: No Character")
		return
	end
	local e
	for _, x in workspace:WaitForChild("Elevators"):GetChildren() do
		if x:GetAttribute("Map") == st.mp and (tonumber(x:GetAttribute("Players")) or 0) == 0 and eb(x) then
			e = x
			break
		end
	end
	if not e then
		lg(`[Join] No Free Elevator For {st.mp}`)
		return
	end
	hr.CFrame = CFrame.new(eb(e).Position)
	if rm("ElevatorEnter"):InvokeServer(e.Name) ~= true then
		lg(`[Join] {e.Name} Enter Refused`)
		return
	end
	local t = os.clock()
	while e:GetAttribute("Host") ~= lp.UserId and os.clock() - t < 3 do task.wait(0.1) end
	if e:GetAttribute("Host") ~= lp.UserId then
		lg(`[Join] {e.Name} Not Host`)
		return
	end
	if #st.mf > 0 then rm("ElevatorSetModifiers"):InvokeServer(e.Name, st.mf) end
	rm("ElevatorStart"):InvokeServer(e.Name)
	lg(`[Join] {e.Name} | {st.mp} | {#st.mf > 0 and table.concat(st.mf, ", ") or "No Modifiers"}`, true)
	task.wait(20)
end

local function nt(d)
	local n = 0
	for _ in d.Towers or {} do n += 1 end
	return n, tonumber(d.InventorySpace) or 500
end

local ak = {}
local function asl()
	local d = rd()
	if not st.sl or not d or type(d.Autosell) ~= "table" then return false end
	local dn = false
	for r, v in d.Autosell do
		if (v == true) ~= (st.sl[r] == true) and os.clock() - (ak[r] or 0) > 5 then
			ak[r], dn = os.clock(), true
			rm("AutosellEnable"):FireServer(r)
			lg(`[Autosell] {r} {st.sl[r] and "On" or "Off"}`)
		end
	end
	return dn
end

local sb, sq, sbt = nil, 0, ""
local function su()
	local d, M = rd(), getrenv().shared.Modules
	if #st.tg == 0 or not d then return false end
	if not sb or os.clock() - sq > 15 then sb, sq = M.Network.Get("GetSummonSet"):InvokeServer(), os.clock() end
	local c = M.Config.GameSettings.SummonCrates[1]
	local bn = c and type(sb) == "table" and sb[c.Name]
	if type(bn) ~= "table" then
		lg("[Summon] Skip: No Banner")
		return false
	end
	local ht2, bl = nil, {}
	for r, v in bn do
		if table.find(st.tg, v) then ht2 = v end
		table.insert(bl, `{r} {v}`)
	end
	table.sort(bl)
	if table.concat(bl, ", ") ~= sbt then
		sbt = table.concat(bl, ", ")
		lg(`[Summon] Banner: {sbt}`)
	end
	local n, cp = nt(d)
	local pr, m = tonumber(c.SummonPrice) or 100, tonumber(d.Money) or 0
	if not ht2 then
		lg("[Summon] Skip: No Picked Tower On Banner")
		return false
	end
	if n >= cp then
		lg(`[Summon] Skip {ht2}: Inventory Full {n}/{cp}`)
		return false
	end
	if m < pr then
		lg(`[Summon] Skip {ht2}: Money {m} < {pr}`)
		return false
	end
	local k = m >= pr * 9 and n + 10 <= cp and 10 or 1
	local r = M.Network.Get("SummonTowers"):InvokeServer(c.Name, k)
	local l = {}
	for _, x in type(r) == "table" and r or {} do table.insert(l, type(x) == "table" and tostring(x.Name or "?") or tostring(x)) end
	lg(`[Summon] x{k} For {ht2} | {#l > 0 and table.concat(l, ", ") or tostring(r)}`)
	return true
end

st.md, st.av, st.as, st.ss, st.ap, st.pl, st.mx, st.mp, st.mf, st.aj = "Easy", false, false, false, false, false, 15, "Toilet City", {}, false
st.tg, st.su, st.sl = {}, false, nil
st.mq, st.um, st.ar, st.mr = {}, false, nil :: any, nil :: any
local ta = W:Tab({Name = pl, Icon = pl == "Lobby" and "four-squares-grid" or "trophy"})
ta:Section({Name = pl})
if pl == "Lobby" then
	local mz, mn, md = {}, {}, getrenv().shared.Modules.Config.GameSettings.Modifiers
	for _, x in workspace:WaitForChild("Elevators"):GetChildren() do
		local m = x:GetAttribute("Map")
		if type(m) == "string" and not table.find(mz, m) then table.insert(mz, m) end
	end
	table.sort(mz)
	local function mq(m) return (string.gsub(tostring(m.Name), "%f[%a]Hp%f[%A]", "HP")) end
	for _, m in md do table.insert(mn, mq(m)) end
	table.sort(mn)
	local G, tl = getrenv().shared.Modules.Config, {}
	local ro = G.GameSettings.RarityOrder or {}
	for n, c in G.Towers do
		if not c.NotInSummon and table.find(G.GameSettings.SummonRarities or {}, c.Rarity) then table.insert(tl, n) end
	end
	table.sort(tl, function(a, b)
		local x, y = ro[G.Towers[a].Rarity] or 0, ro[G.Towers[b].Rarity] or 0
		if x ~= y then return x > y end
		return a < b
	end)
	local rl = {}
	for r in rd() and rd().Autosell or {} do table.insert(rl, r) end
	table.sort(rl, function(a, b) return (ro[a] or 0) < (ro[b] or 0) end)
	st.mp = table.find(mz, "Toilet City") and "Toilet City" or mz[1] or "Toilet City"
	ta:Section({Name = "Join"})
	ta:Dropdown({Name = "Select Map", Options = mz, Default = table.find(mz, "Toilet City") and "Toilet City" or mz[1], Flag = "mp", Callback = function(v) st.mp = v or "Toilet City" end})
	table.insert(mn, 1, "Normal")
	local df, pn = nil, true
	df = ta:Dropdown({Name = "Modifiers", Options = mn, Default = {"Normal"}, Multi = true, Flag = "mf", Callback = function(v)
		local l, t = type(v) == "table" and v or {}, {}
		local hn = table.find(l, "Normal") ~= nil
		for _, n in l do
			for k, m in md do if mq(m) == n then table.insert(t, k) end end
		end
		if #t == 0 then
			st.mf, pn = {}, true
			if not hn or #l > 1 then task.defer(function() df:Set({"Normal"}) end) end
		elseif hn and pn then
			st.mf, pn = t, false
			task.defer(function()
				local r = {}
				for _, n in l do if n ~= "Normal" then table.insert(r, n) end end
				df:Set(r)
			end)
		elseif hn then
			st.mf, pn = {}, true
			task.defer(function() df:Set({"Normal"}) end)
		else
			st.mf, pn = t, false
		end
	end})
	ta:Toggle({Name = "Auto Join", Default = false, Flag = "aj", Callback = function(v) st.aj = v == true end})
	ta:Section({Name = "Summon"})
	ta:Dropdown({Name = "Summon Targets", Options = tl, Default = {}, Multi = true, Flag = "tg", Callback = function(v) st.tg = type(v) == "table" and v or {} end})
	ta:Toggle({Name = "Auto Summon", Default = false, Flag = "su", Callback = function(v) st.su = v == true end})
	ta:Dropdown({Name = "Auto Sell", Options = rl, Default = {}, Multi = true, Flag = "sl", Callback = function(v)
		local t = {}
		for _, r in type(v) == "table" and v or {} do t[r] = true end
		st.sl = next(t) and t or nil
	end})
	task.spawn(function()
		while st.bg do
			local ok, e = xpcall(function()
				local dn = asl()
				dn = st.su and su() or dn
				if dn then
					task.wait(3)
				elseif st.aj then
					jn()
					task.wait(3)
				end
			end, tb)
			if not ok then
				xe("Lobby Loop", e)
				task.wait(3)
			end
			task.wait(0.5)
		end
	end)
else
	ta:Dropdown({Name = "Select Mode", Options = {"Easy", "Normal", "Hard", "Insane", "Nightmare"}, Default = "Easy", Flag = "md", Callback = function(v) st.md = v or "Easy" end})
	ta:Toggle({Name = "Auto Vote", Default = false, Flag = "av", Callback = function(v) st.av = v == true end})
	ta:Toggle({Name = "Auto Skip", Default = false, Flag = "as", Callback = function(v) st.as = v == true end})
	local sq
	sq = ta:Toggle({Name = "Auto Speed", Default = false, Flag = "ss", Callback = function(v)
		st.ss = v == true and xp() ~= nil
		if v ~= true or st.ss then return end
		W:Notify({Title = "Auto Speed", Text = "Auto Speed Failed: Needs Group, 200 Wins Or X2 Speed Pass", Error = true})
		task.defer(function() sq:Set(false) end)
	end})
	ta:Toggle({Name = "Auto Play Again", Default = false, Flag = "ap", Callback = function(v) st.ap = v == true end})
	ta:Section({Name = "Towers"})
	ta:Slider({Name = "Max Towers", Min = 1, Max = 15, Step = 1, Default = 15, Flag = "mx", Callback = function(v) st.mx = tonumber(v) or 15 end})
	st.ar = ta:Toggle({Name = "Auto Play", Default = false, Flag = "pl", Callback = function(v)
		st.pl = v == true
		if st.pl and st.mr then st.mr:Set(false) end
	end})
	task.spawn(function()
		local nx, lk = 0, nil
		while st.bg do
			local gs = at("GameState")
			if st.pl and (gs == "InWave" or gs == "Intermission") and os.clock() >= nx then
				local ok, e = xpcall(function()
					local o = pk()
					if not o then
						if lk ~= "-" then
							lk = "-"
							lg(`[Play] Nothing To Buy | Towers {#my()}/{st.mx} | Wave {at("Wave")}`)
						end
						return
					end
					local nm = o.k == "a" and o.h.Name or o.x.Name
					local ds = `{o.k == "a" and "Place" or `Upgrade Lv {o.x.Level + 1}`} {nm}{o.f and " (Farm)" or ""}`
					if mo() < o.c then
						if lk ~= ds then
							lk = ds
							lg(`[Play] Waiting ${o.c} For {ds} | Have ${mo()} | Wave {at("Wave")}`)
						end
						return
					end
					lk = nil
					if ac(o) then
						lg(`[Play] {ds} | ${o.c} | Score {string.format("%.3g", o.r)} | Wave {at("Wave")}`)
					else
						nx = os.clock() + 5
						lg(`[Play] {o.k == "a" and "Place" or "Upgrade"} {nm} Failed: No Confirm`)
					end
				end, tb)
				if not ok then
					nx = os.clock() + 5
					xe("Auto Play", e)
				end
			end
			task.wait(0.3)
		end
	end)
	task.spawn(function()
		local lv, kf, ls, pn, pe, sr = 0, false, 0, 0, 0, {}
		while st.bg do
			local ok, e = xpcall(function()
				if st.av and at("IsVoting") and not me(`{st.md}Voters`) and os.clock() - lv > 2 then
					lv = os.clock()
					rm("ModeVote"):FireServer(st.md)
					lg(`[Vote] {st.md}`)
				end
				local cs = at("CanSkip") == true
				if not cs then kf = false end
				if st.as and cs and not kf then
					kf = true
					rm("WaveSkip"):FireServer()
					lg(`[Skip] Wave {at("Wave")}`)
				end
				if st.ss and at("GameState") == "InWave" and os.clock() - ls > 10 then
					ls = os.clock()
					local sv = xp()
					if sv and (at("GameSpeed") or 1) < sv and not sr[sv] then
						if rm("ChangeSpeed"):InvokeServer(sv) == true then
							lg(`[Speed] x{sv}`)
						else
							sr[sv] = true
							lg(`[Speed] x{sv} Refused`)
						end
					end
				end
				local m = at("Message")
				if m ~= "You Won!" and m ~= "You Lost!" then
					pn, pe = 0, 0
					return
				end
				if pe == 0 then pe = os.clock() end
				if not st.ap or os.clock() < pn then return end
				pn = os.clock() + 15
				rm("PlayAgain"):FireServer()
				lg(`[Play Again] {m} | Wave {at("Wave")} | {at("Mode")} | {string.format("%.1f", os.clock() - pe)} s After End`, true)
			end, tb)
			if not ok then xe("Match Loop", e) end
			task.wait(0.25)
		end
	end)
	task.spawn(function()
		local lw, lgs, lm, lh, th, ed, fs = nil, nil, nil, nil, 0, false, true
		while st.bg do
			local ok, e = xpcall(function()
				local g = workspace:FindFirstChild("Game")
				local b, mf = g and g:FindFirstChild("Base"), g and g:FindFirstChild("Modifiers")
				local gs, w, m, ms = at("GameState"), at("Wave"), at("Mode"), at("Message")
				local hp, mh = b and b:GetAttribute("Health"), b and b:GetAttribute("MaxHealth")
				if fs then
					fs = false
					local ml, hb = {}, {}
					for _, v in mf and mf:GetChildren() or {} do
						if v:IsA("StringValue") then table.insert(ml, v.Value) end
					end
					for _, x in ht() do table.insert(hb, x.Name) end
					lg(`[Match] Map {at("Map") or "?"} | Modifiers {#ml > 0 and table.concat(ml, ", ") or "None"} | Hotbar {table.concat(hb, ", ")} | {#ps:GetPlayers()} Players`)
				end
				if m and m ~= lm then
					lm = m
					lg(`[Match] Mode {m}`)
				end
				if gs ~= lgs then
					if not ((gs == "InWave" or gs == "Intermission") and (lgs == "InWave" or lgs == "Intermission")) then lg(`[Match] State {lgs or "-"} -> {gs or "-"}`) end
					lgs = gs
				end
				if w and w ~= lw then
					lw = w
					lg(`[Wave] {w} Start | Money {mo()} | Base {hp or "?"}/{mh or "?"} | Towers {#my()}`)
				end
				if hp ~= lh and os.clock() - th >= 3 then
					if lh and hp and hp < lh then lg(`[Base] HP {hp}/{mh or "?"} (-{lh - hp}) | Wave {w or "?"}`) end
					lh, th = hp, os.clock()
				end
				if ms ~= "You Won!" and ms ~= "You Lost!" then
					ed = false
				elseif not ed then
					ed = true
					lg(`[Match] {ms} | Wave {w or "?"} | {m or "?"} | Time {at("TotalTime") or "?"} | Money {mo()} | Base {hp or "?"}/{mh or "?"}`)
					local ok2, s = pcall(xs)
					if ok2 then lg(s, true) end
				end
			end, tb)
			if not ok then xe("Match Watch", e) end
			task.wait(0.25)
		end
	end)
end

local mc = {dr = "Avenoric/Configs/CameramanTowerDefense/Maps", qd = "Avenoric/Configs/CameramanTowerDefense/Macros", vf = nil :: any, wv = nil :: any, wm = nil :: any, tl = nil :: any, sg = nil :: any, ov = nil :: any, cur = nil :: any, su = nil :: any, sel = nil :: any, rf = nil :: any, sc = nil :: any, hs = {}, am = nil :: any, wt = nil :: any, uf = "", pp = nil :: any, px = 0, rw = {}, ps = nil :: any, ml = {"Easy", "Normal", "Hard", "Insane", "Nightmare"}, em = "Easy", wz = nil :: any, tq = nil :: any, wf = "Avenoric/Configs/CameramanTowerDefense/Waves.json", ep = nil :: any, en = nil :: any, cp = nil :: any, pa = nil :: any, pu = nil :: any, k = {bg = Color3.fromRGB(37, 37, 34), cd = Color3.fromRGB(47, 47, 43), hv = Color3.fromRGB(58, 58, 54), tx = Color3.fromRGB(244, 240, 232), dm = Color3.fromRGB(168, 164, 156), ac = Color3.fromRGB(76, 194, 255), pr = Color3.fromRGB(68, 68, 63), er = Color3.fromRGB(214, 106, 94)}}

function mc.mk(p)
	local s = ""
	for x in string.gmatch(p, "[^/]+") do
		s = s == "" and x or s .. "/" .. x
		if not isfolder(s) then makefolder(s) end
	end
end

function mc.r2(v) return math.round(v * 100) / 100 end

function mc.ms()
	local g, mn = workspace:FindFirstChild("Game"), at("Map")
	if pl ~= "Match" or not g or type(mn) ~= "string" then return end
	local p, f, hs2 = `{mc.dr}/{mn}.json`, `{mc.dr}/{mn}.rbxm`, game:GetService("HttpService")
	if isfile(p) and isfile(f) then
		local ok, j = pcall(hs2.JSONDecode, hs2, readfile(p))
		if ok and type(j) == "table" and j.Ver == game.PlaceVersion and j.Fmt == 3 then return end
	end
	local _, y = pth()
	if not y then return end
	local W, R = {}, Instance.new("Model")
	R.Name = "CtdMap"
	for _, w in gm("Waypoints"):GetChildren() do
		local i = tonumber(w.Name)
		if i and w:IsA("BasePart") then W[#W + 1] = {i, mc.r2(w.Position.X), mc.r2(w.Position.Z)} end
	end
	table.sort(W, function(a, b) return a[1] < b[1] end)
	for _, n in {"Paths", "TowerArea", "Base", "Waypoints"} do
		local r = g:FindFirstChild(n)
		local c = r and r:Clone()
		if c then c.Parent = R end
	end
	mc.mk(mc.dr)
	if isfile(f) then delfile(f) end
	local o = SaveInstanceOptions.new()
	o.FilePath, o.DecompileScripts = f, false
	saveinstance(R, o)
	local t = os.clock()
	while not isfile(f) and os.clock() - t < 15 do task.wait(0.2) end
	if not isfile(f) then error("Map Save Failed: No File", 0) end
	R:Destroy()
	writefile(p, hs2:JSONEncode({Map = mn, Ver = game.PlaceVersion, Fmt = 3, Y = mc.r2(y), W = W}))
	lg(`[Macro] Map Saved | {mn} | {#W} Waypoints | {math.floor(#readfile(f) / 1024)} KB`)
end

function mc.wc()
	local M, hs2 = getrenv().shared.Modules.Modes, game:GetService("HttpService")
	if pl ~= "Match" or type(M) ~= "table" then return end
	if isfile(mc.wf) then
		local ok, j = pcall(hs2.JSONDecode, hs2, readfile(mc.wf))
		if ok and type(j) == "table" and j.Ver == game.PlaceVersion then return end
	end
	local o = {}
	for _, m in mc.ml do
		local w = {}
		for ln in string.gmatch(type(M[m]) == "string" and M[m] or "", "[^\n]+") do
			ln = string.match(ln, "^%s*(.-)%s*$")
			if string.match(ln, "^WAVE:") then
				table.insert(w, {})
			elseif #w > 0 then
				local n, c = string.match(ln, "^(.-)%s+(%d+)%s+[%d%.]+$")
				if n then table.insert(w[#w], {n, tonumber(c)}) end
			end
		end
		o[m] = w
	end
	mc.mk("Avenoric/Configs/CameramanTowerDefense")
	writefile(mc.wf, hs2:JSONEncode({Ver = game.PlaceVersion, M = o}))
	lg(`[Macro] Waves Saved | {#o.Easy} / {#o.Normal} / {#o.Hard} / {#o.Insane} / {#o.Nightmare} Waves`)
end

function mc.fn(v)
	local s = string.reverse((string.gsub(string.reverse(tostring(math.floor(tonumber(v) or 0))), "(%d%d%d)", "%1,")))
	return (string.gsub(s, "^,", ""))
end

function mc.wl(m)
	if not mc.wz and isfile(mc.wf) then
		local ok, j = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(mc.wf)) end)
		if ok and type(j) == "table" and type(j.M) == "table" then mc.wz = j.M end
	end
	return mc.wz and mc.wz[m] or nil
end

function mc.ls()
	local l = {}
	for _, f in isfolder(mc.dr) and listfiles(mc.dr) or {} do
		local n = string.match(f, "([^/\\]+)%.json$")
		if n then table.insert(l, n) end
	end
	table.sort(l)
	return l
end

function mc.nw(cn, p, pa)
	local o = Instance.new(cn)
	for k, v in p do o[k] = v end
	o.Parent = pa
	return o
end

function mc.cm()
	local v, w = mc.vf, mc.wv
	if not (v and w) then return end
	local cx, cz, h = w.cx, w.cz, w.h
	v.CurrentCamera.CFrame = CFrame.lookAt(Vector3.new(cx, w.y + h, cz), Vector3.new(cx, w.y, cz), Vector3.new(0, 0, -1))
	mc.mr()
end

function mc.tn() return mc.wv.h * math.tan(math.rad(mc.vf.CurrentCamera.FieldOfView / 2)) end

function mc.vz() return mc.vf.AbsoluteSize / (mc.sc and mc.sc.Scale or 1) end

function mc.w2s(x, z)
	local s, t = mc.vz(), mc.tn()
	return Vector2.new(s.X / 2 + (x - mc.wv.cx) / t * s.Y / 2, s.Y / 2 + (z - mc.wv.cz) / t * s.Y / 2)
end

function mc.s2w(q)
	local s, t = mc.vz(), mc.tn()
	return mc.wv.cx + (q.X - s.X / 2) / (s.Y / 2) * t, mc.wv.cz + (q.Y - s.Y / 2) / (s.Y / 2) * t
end

function mc.gy(x, z)
	local rq, ic = RaycastParams.new(), {}
	for _, o in mc.wm:GetChildren() do
		if o.Name == "TowerArea" or o.Name == "Paths" then table.insert(ic, o) end
	end
	rq.FilterType, rq.FilterDescendantsInstances = Enum.RaycastFilterType.Include, ic
	local r = mc.wm:Raycast(Vector3.new(x, mc.wv.y + 200, z), Vector3.new(0, -400, 0), rq)
	return r and math.abs(r.Position.Y - mc.wv.y) <= 3 and r.Position or nil
end

function mc.fs(n)
	for _, s in mc.cur and mc.cur.S or {} do
		if s.t == "place" and s.n == n then return s end
	end
	return nil
end

function mc.mr()
	local ov = mc.ov
	if not ov then return end
	ov:ClearAllChildren()
	if not mc.wv then return end
	local k = mc.k
	local function bd(t, q, bg, fg, o)
		local b = mc.nw("TextLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(q.X, q.Y), Size = UDim2.fromOffset(0, 20), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = bg, Font = Enum.Font.BuilderSansBold, Text = t, TextColor3 = fg, TextSize = 12, ZIndex = o}, ov)
		mc.nw("UICorner", {CornerRadius = UDim.new(1, 0)}, b)
		mc.nw("UIPadding", {PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 7)}, b)
		mc.nw("UIStroke", {Color = Color3.new(1, 1, 1), Transparency = 0.25, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, b)
		return b
	end
	local W2 = mc.wv.wp or {}
	if W2[1] then bd("Start", mc.w2s(W2[1][2], W2[1][3]), Color3.fromRGB(70, 170, 90), Color3.new(1, 1, 1), 3) end
	if #W2 > 1 then bd("Base", mc.w2s(W2[#W2][2], W2[#W2][3]), Color3.fromRGB(200, 80, 70), Color3.new(1, 1, 1), 3) end
	if not (mc.cur and mc.cur.Map == mc.wv.map) then return end
	local g, ks = {}, {}
	for _, s in mc.cur.S do
		if s.t == "place" and type(s.p) == "table" then
			local ky = `{math.round(s.p[1])},{math.round(s.p[3])}`
			if not g[ky] then
				g[ky] = {s.p, {}}
				table.insert(ks, ky)
			end
			table.insert(g[ky][2], s.n)
		end
	end
	local sl = mc.sel and mc.fs(mc.sel)
	local cf = sl and tc(sl.u)
	local ul = sl and cf and cf.Upgrades and (cf.Upgrades[math.min(mc.lv(sl.n), #cf.Upgrades)] or cf.Upgrades[1])
	local rg = ul and tonumber(ul.Range) or 0
	if sl and rg > 0 then
		local q, d = mc.w2s(sl.p[1], sl.p[3]), rg / mc.tn() * mc.vz().Y
		local o = mc.nw("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(q.X, q.Y), Size = UDim2.fromOffset(d, d), BackgroundColor3 = k.ac, BackgroundTransparency = 0.86, ZIndex = 3}, ov)
		mc.nw("UICorner", {CornerRadius = UDim.new(1, 0)}, o)
		mc.nw("UIStroke", {Color = k.ac, Transparency = 0.1, Thickness = 1.5}, o)
	end
	for _, ky in ks do
		local v = g[ky]
		local on = table.find(v[2], mc.sel) ~= nil
		local b = bd("#" .. table.concat(v[2], " #"), mc.w2s(v[1][1], v[1][3]), on and k.tx or k.ac, k.bg, on and 6 or 5)
		if on then b:FindFirstChildWhichIsA("UIStroke").Color, b:FindFirstChildWhichIsA("UIStroke").Transparency = k.ac, 0 end
	end
	for _, s in mc.cur.S do
		if s.t == "ab" and type(s.p) == "table" then bd(`A#{s.n}`, mc.w2s(s.p[1], s.p[3]), Color3.fromRGB(150, 105, 235), Color3.new(1, 1, 1), 5) end
	end
end

function mc.qn(n) return string.sub((string.gsub(tostring(n), "[^%w _%-]", "")), 1, 40) end

function mc.ql()
	local l, hs2 = {}, game:GetService("HttpService")
	for _, f in isfolder(mc.qd) and listfiles(mc.qd) or {} do
		local n = string.match(f, "([^/\\]+)%.json$")
		if n then
			local ok, j = pcall(function() return hs2:JSONDecode(readfile(f)) end)
			local g = ok and type(j) == "table"
			table.insert(l, {n, g and j.Map or "?", g and j.Mode or "Easy"})
		end
	end
	table.sort(l, function(a, b) return a[1] < b[1] end)
	return l
end

function mc.qs()
	if not mc.cur then return end
	mc.mk(mc.qd)
	writefile(`{mc.qd}/{mc.cur.Name}.json`, game:GetService("HttpService"):JSONEncode(mc.cur))
end

function mc.qo(n)
	local ok, j = pcall(function() return game:GetService("HttpService"):JSONDecode(readfile(`{mc.qd}/{n}.json`)) end)
	if not ok or type(j) ~= "table" or type(j.S) ~= "table" or type(j.Map) ~= "string" then
		W:Notify({Title = "Macro", Text = `Macro Load Failed: {n}`, Error = true})
		return
	end
	j.Name, mc.cur, mc.sel, mc.hs, mc.em = n, j, nil, {}, j.Mode or "Easy"
	if not mc.wv or mc.wv.map ~= j.Map then mc.ld(j.Map) end
	mc.rf()
end

function mc.us()
	local G, l = getrenv().shared.Modules.Config, {}
	local ro = G.GameSettings.RarityOrder or {}
	for n, c in G.Towers do
		if type(n) == "string" and type(c) == "table" then table.insert(l, n) end
	end
	table.sort(l, function(a, b)
		local x, y = ro[tc(a).Rarity] or 0, ro[tc(b).Rarity] or 0
		if x ~= y then return x > y end
		return a < b
	end)
	return l
end

function mc.ck(q)
	if not mc.wv or os.clock() - mc.px < 0.3 then return end
	if mc.pp and mc.pp.Parent then
		local sc = mc.sc and mc.sc.Scale or 1
		local r0 = (mc.pp.AbsolutePosition - mc.vf.AbsolutePosition) / sc
		local r1 = r0 + mc.pp.AbsoluteSize / sc
		if not (q.X >= r0.X and q.X <= r1.X and q.Y >= r0.Y and q.Y <= r1.Y) then mc.cp() end
		return
	end
	local x, z = mc.s2w(q)
	if mc.am then
		local n2 = mc.am
		mc.am = nil
		local p = mc.gy(x, z)
		if not p then
			W:Notify({Title = "Macro", Text = "Ability Failed: Not Ground", Error = true})
			mc.rf()
			return
		end
		mc.ad({t = "ab", n = n2, p = {mc.r2(p.X), mc.r2(p.Y), mc.r2(p.Z)}})
		return
	end
	if not mc.cur then
		W:Notify({Title = "Macro", Text = "Place Failed: Make A Macro First", Error = true})
		return
	end
	if mc.cur.Map ~= mc.wv.map then
		W:Notify({Title = "Macro", Text = `Place Failed: Macro Is For {mc.cur.Map}`, Error = true})
		return
	end
	local g, bd2, bk = {}, 16, nil
	for _, s in mc.cur.S do
		if s.t == "place" and type(s.p) == "table" then
			local ky = `{math.round(s.p[1])},{math.round(s.p[3])}`
			g[ky] = g[ky] or {s.p, {}}
			table.insert(g[ky][2], s.n)
		end
	end
	for ky, v in g do
		local d = (mc.w2s(v[1][1], v[1][3]) - q).Magnitude
		if d < bd2 then bd2, bk = d, ky end
	end
	if bk then
		mc.sel = g[bk][2][1]
		mc.rf()
		mc.pa(q, g[bk][2], 1)
		return
	end
	local p = mc.gy(x, z)
	if not p then
		W:Notify({Title = "Macro", Text = "Place Failed: Not Ground", Error = true})
		return
	end
	mc.sel = nil
	mc.rf()
	mc.pu(q, p)
end

function mc.hp()
	if not mc.cur then return end
	table.insert(mc.hs, game:GetService("HttpService"):JSONEncode(mc.cur.S))
	if #mc.hs > 50 then table.remove(mc.hs, 1) end
end

function mc.ud()
	if not mc.cur or #mc.hs == 0 then
		W:Notify({Title = "Macro", Text = "Undo Failed: Nothing To Undo", Error = true})
		return
	end
	mc.cur.S, mc.sel = game:GetService("HttpService"):JSONDecode(table.remove(mc.hs) :: string), nil
	mc.qs()
	mc.rf()
end

function mc.st(s)
	if s.t == "place" then return `Place {s.u} (#{s.n})` end
	if s.t == "up" then return `Upgrade #{s.n} to Lv {s.lv}` end
	if s.t == "sell" then return `Sell #{s.n}` end
	if s.t == "tgt" then return `Target #{s.n}: {s.m}` end
	if s.t == "wait" then return `Wait for wave {s.w}` end
	if s.t == "ab" then return `Ability #{s.n}` end
	return tostring(s.t)
end

function mc.tm(n)
	local m = "First"
	for _, s in mc.cur and mc.cur.S or {} do
		if s.t == "tgt" and s.n == n and type(s.m) == "string" then m = s.m end
	end
	return m
end

function mc.lv(n)
	local v = 1
	for _, s in mc.cur and mc.cur.S or {} do
		local x = tonumber(s.lv)
		if s.t == "up" and s.n == n and x and x > v then v = x end
	end
	return v
end

function mc.ad(st)
	if not mc.cur then return end
	mc.hp()
	table.insert(mc.cur.S, st)
	mc.qs()
	mc.rf()
end

function mc.ce(wm, j)
	local rp, cb, cn, tt = RaycastParams.new(), math.huge, 0, 0
	rp.FilterType = Enum.RaycastFilterType.Exclude
	local function bo(d)
		local c, s = d.CFrame, d.Size
		return c.Position.Y - (math.abs(c.RightVector.Y) * s.X + math.abs(c.UpVector.Y) * s.Y + math.abs(c.LookVector.Y) * s.Z) / 2
	end
	local W2 = j.W or {}
	for i = 1, #W2 - 1 do
		local a, b = W2[i], W2[i + 1]
		for _, f in {0.25, 0.5, 0.75} do
			local x, z, e = a[2] + (b[2] - a[2]) * f, a[3] + (b[3] - a[3]) * f, {}
			tt += 1
			for _ = 1, 20 do
				rp.FilterDescendantsInstances = e
				local h = wm:Raycast(Vector3.new(x, j.Y + 400, z), Vector3.new(0, -800, 0), rp)
				if not h or h.Position.Y - j.Y <= 3 then break end
				if #e == 0 then cn += 1 end
				table.insert(e, h.Instance)
				cb = math.min(cb, bo(h.Instance))
			end
		end
	end
	if cn * 2 <= tt then return 0 end
	local n = 0
	for _, d in wm:GetDescendants() do
		if d:IsA("BasePart") and bo(d) >= cb - 0.5 then
			d:Destroy()
			n += 1
		end
	end
	return n
end

function mc.ld(mn)
	local hs2, f = game:GetService("HttpService"), `{mc.dr}/{mn}.rbxm`
	local ok, j = pcall(function() return hs2:JSONDecode(readfile(`{mc.dr}/{mn}.json`)) end)
	if not ok or type(j) ~= "table" or (j.Fmt ~= 2 and j.Fmt ~= 3) or not isfile(f) then
		W:Notify({Title = "Macro", Text = `Map Load Failed: {mn} Needs A Match Visit`, Error = true})
		return
	end
	local ok2, ob = pcall(function() return game:GetObjects(getcustomasset(f)) end)
	if not ok2 or type(ob) ~= "table" then
		W:Notify({Title = "Macro", Text = `Map Load Failed: {mn} Bad File`, Error = true})
		return
	end
	local wm, n = mc.wm, 0
	wm:ClearAllChildren()
	mc.wv = nil
	for _, o in ob do
		for _, d in o:GetDescendants() do
			if d:IsA("LuaSourceContainer") then d:Destroy() elseif d:IsA("BasePart") then n += 1 end
		end
		if o.Name == "CtdMap" then
			for _, c in o:GetChildren() do c.Parent = wm end
			o:Destroy()
		else
			o.Parent = wm
		end
	end
	n -= mc.ce(wm, j)
	local x0, x1, z0, z1 = math.huge, -math.huge, math.huge, -math.huge
	for i, w in j.W or {} do
		x0, x1, z0, z1 = math.min(x0, w[2]), math.max(x1, w[2]), math.min(z0, w[3]), math.max(z1, w[3])
		local nx = j.W[i + 1]
		if nx then
			local a, b = Vector3.new(w[2], j.Y + 0.6, w[3]), Vector3.new(nx[2], j.Y + 0.6, nx[3])
			mc.nw("Part", {Anchored = true, CanCollide = false, Material = Enum.Material.Neon, Color = mc.k.ac, Size = Vector3.new(0.8, 0.2, (b - a).Magnitude + 0.8), CFrame = CFrame.lookAt((a + b) / 2, b)}, wm)
		end
	end
	if x0 == math.huge then x0, x1, z0, z1 = -50, 50, -50, 50 end
	local vs = mc.vz()
	local t2 = math.tan(math.rad(mc.vf.CurrentCamera.FieldOfView / 2))
	mc.wv = {map = mn, wp = j.W, y = j.Y or 0, cx = (x0 + x1) / 2, cz = (z0 + z1) / 2, h = math.max((z1 - z0 + 30) / 2, (x1 - x0 + 30) / 2 / math.max(vs.X / math.max(vs.Y, 1), 0.1)) / t2}
	mc.cm()
	mc.tl.Text = `{mn}   /   {n} Parts   /   Scroll: Zoom   /   Drag: Move`
end

function mc.op()
	if mc.sg and mc.sg.Parent then
		mc.sg.Enabled = not mc.sg.Enabled
		return
	end
	local k, ui, ts = mc.k, game:GetService("UserInputService"), game:GetService("TweenService")
	local fm, fb = Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold
	local ip = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
	local ir, ib = Font.new(ip), Font.new(ip, Enum.FontWeight.Bold)
	local function tw(o, p, d) ts:Create(o, TweenInfo.new(d or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end
	local function rc(o, r) mc.nw("UICorner", {CornerRadius = UDim.new(0, r)}, o) end
	local function sk(o, t, cl) return mc.nw("UIStroke", {Color = cl or k.tx, Transparency = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, o) end
	local function pd(o, l, r, t, b) mc.nw("UIPadding", {PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r or l), PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0)}, o) end
	local function tl(p, pa)
		local d = {BackgroundTransparency = 1, Font = fm, TextColor3 = k.tx, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left, Text = ""}
		for i, v in p do d[i] = v end
		return mc.nw("TextLabel", d, pa)
	end
	local function ic(n, p, pa)
		local d = {BackgroundTransparency = 1, FontFace = ir, TextColor3 = k.dm, TextSize = 16, Text = n, TextXAlignment = Enum.TextXAlignment.Center}
		for i, v in p do d[i] = v end
		return mc.nw("TextLabel", d, pa)
	end
	local function bt(p, pa)
		local d = {BackgroundTransparency = 1, AutoButtonColor = false, Text = "", BorderSizePixel = 0, BackgroundColor3 = k.cd}
		for i, v in p do d[i] = v end
		return mc.nw("TextButton", d, pa)
	end
	local function hv(b, base)
		b.MouseEnter:Connect(function() if ui.MouseEnabled then tw(b, {BackgroundColor3 = k.hv, BackgroundTransparency = 0}) end end)
		b.MouseLeave:Connect(function()
			local c0, t0 = base()
			tw(b, {BackgroundColor3 = c0, BackgroundTransparency = t0})
		end)
		b.MouseButton1Down:Connect(function() tw(b, {BackgroundColor3 = k.pr, BackgroundTransparency = 0}, 0.05) end)
	end
	local sg = mc.nw("ScreenGui", {Name = "CtdMacro", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000}, gethui and gethui() or lp:WaitForChild("PlayerGui"))
	mc.sg = sg
	local ww, wh = 1222, 620
	local fr = mc.nw("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(ww, wh), BackgroundColor3 = k.bg, BorderSizePixel = 0}, sg)
	rc(fr, 12)
	sk(fr, 0.85)
	local us = mc.nw("UIScale", {}, fr)
	mc.sc = us
	local function ft()
		local v, ins = sg.AbsoluteSize, game:GetService("GuiService"):GetGuiInset().Y
		us.Scale = math.clamp(math.min((v.X - 24) / ww, (v.Y - ins - 24) / wh), 0.45, 1)
	end
	ft()
	sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(ft)
	local tb = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1}, fr)
	ic("map-pin", {TextColor3 = k.ac, FontFace = ib, Position = UDim2.fromOffset(14, 0), Size = UDim2.fromOffset(20, 40)}, tb)
	tl({Text = "Macro Editor", Font = fb, Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -100, 1, 0)}, tb)
	local xb = bt({Size = UDim2.fromOffset(40, 28), Position = UDim2.new(1, -46, 0, 6), BackgroundColor3 = k.hv}, tb)
	rc(xb, 6)
	ic("x", {TextSize = 14, Size = UDim2.fromScale(1, 1)}, xb)
	xb.MouseEnter:Connect(function() if ui.MouseEnabled then tw(xb, {BackgroundTransparency = 0}) end end)
	xb.MouseLeave:Connect(function() tw(xb, {BackgroundTransparency = 1}) end)
	xb.Activated:Connect(function() sg.Enabled = false end)
	local mf = mc.nw("Frame", {Position = UDim2.fromOffset(12, 44), Size = UDim2.new(1, -590, 1, -56), BackgroundColor3 = k.cd, BorderSizePixel = 0}, fr)
	rc(mf, 6)
	sk(mf, 0.92)
	local vf = mc.nw("ViewportFrame", {ClipsDescendants = true, Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2), BackgroundColor3 = Color3.fromRGB(26, 26, 24), Ambient = Color3.fromRGB(190, 190, 190), LightColor = Color3.new(1, 1, 1), LightDirection = Vector3.new(-0.3, -1, -0.2)}, mf)
	rc(vf, 6)
	mc.vf = vf
	vf.CurrentCamera = mc.nw("Camera", {FieldOfView = 30}, vf)
	mc.wm = mc.nw("WorldModel", {}, vf)
	mc.ov = mc.nw("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 2}, vf)
	local function cp(pos, an)
		local f = mc.nw("Frame", {AnchorPoint = an, Position = pos, Size = UDim2.fromOffset(0, 28), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = k.bg, BackgroundTransparency = 0.12, ZIndex = 8}, vf)
		rc(f, 6)
		sk(f, 0.9)
		pd(f, 10, 10)
		mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, f)
		return f
	end
	local c1 = cp(UDim2.fromOffset(10, 10), Vector2.zero)
	local cm1 = tl({Text = "No Map", Font = fb, TextSize = 13, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), ZIndex = 9, LayoutOrder = 1}, c1)
	local cm2 = tl({Text = "No Macro", TextSize = 13, TextColor3 = k.dm, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), ZIndex = 9, LayoutOrder = 2}, c1)
	local c2 = cp(UDim2.new(0, 10, 1, -10), Vector2.new(0, 1))
	local ub = bt({AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 10), Size = UDim2.fromOffset(84, 28), BackgroundColor3 = k.bg, BackgroundTransparency = 0.12, ZIndex = 8}, vf)
	rc(ub, 6)
	sk(ub, 0.9)
	ic("arrow-counterclockwise", {TextSize = 14, TextColor3 = k.tx, Position = UDim2.fromOffset(8, 0), Size = UDim2.fromOffset(16, 28), ZIndex = 9}, ub)
	tl({Text = "Undo", TextSize = 13, Position = UDim2.fromOffset(30, 0), Size = UDim2.new(1, -34, 1, 0), ZIndex = 9}, ub)
	ub.MouseEnter:Connect(function() if ui.MouseEnabled then tw(ub, {BackgroundColor3 = k.hv, BackgroundTransparency = 0}) end end)
	ub.MouseLeave:Connect(function() tw(ub, {BackgroundColor3 = k.bg, BackgroundTransparency = 0.12}) end)
	ub.Activated:Connect(function()
		mc.px = os.clock()
		mc.ud()
	end)
	mc.tl = tl({Text = "", TextSize = 12, TextColor3 = k.dm, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), ZIndex = 9}, c2)
	local pg = mc.nw("ScrollingFrame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -254, 0, 44), Size = UDim2.new(0, 312, 1, -56), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = k.dm, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, fr)
	pd(pg, 2, 8, 2, 8)
	mc.nw("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, pg)
	local wvs = mc.nw("ScrollingFrame", {AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 44), Size = UDim2.new(0, 230, 1, -56), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = k.dm, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, fr)
	pd(wvs, 2, 8, 2, 8)
	mc.nw("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, wvs)
	local wvh = tl({Text = "Waves", Font = fb, TextSize = 13, Size = UDim2.new(1, 0, 0, 30), TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = 1}, wvs)
	pd(wvh, 4, 0, 0, 4)
	local wvf = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2}, wvs)
	mc.nw("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, wvf)
	local lo = 0
	local function nx()
		lo += 1
		return lo
	end
	local function sc(t)
		local l = tl({Text = t, Font = fb, TextSize = 13, Size = UDim2.new(1, 0, 0, 30), TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = nx()}, pg)
		pd(l, 4, 0, 0, 4)
		return l
	end
	local function cd2(h)
		local f = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1, BorderSizePixel = 0, LayoutOrder = nx()}, pg)
		return f
	end
	local function pill(t, icn, pa, w)
		local b = bt({Size = UDim2.fromOffset(w, 28), BackgroundColor3 = k.hv, BackgroundTransparency = 0}, pa)
		rc(b, 4)
		sk(b, 0.92)
		local h = mc.nw("Frame", {BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, b)
		mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder}, h)
		if icn then ic(icn, {TextSize = 14, TextColor3 = k.tx, Size = UDim2.fromOffset(14, 28), LayoutOrder = 1}, h) end
		local l = tl({Text = t, TextSize = 13, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, 28), LayoutOrder = 2}, h)
		b.MouseEnter:Connect(function() if ui.MouseEnabled and b:GetAttribute("on") ~= true then tw(b, {BackgroundColor3 = k.pr}) end end)
		b.MouseLeave:Connect(function() if b:GetAttribute("on") ~= true then tw(b, {BackgroundColor3 = k.hv}) end end)
		return b, l
	end
	sc("Macro")
	local mlh = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nx()}, pg)
	mc.nw("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, mlh)
	local nr = cd2(44)
	local nrc = bt({Size = UDim2.fromScale(1, 1)}, nr)
	rc(nrc, 6)
	sk(nrc, 0.92)
	pd(nrc, 12, 12)
	tl({Text = "Name", Size = UDim2.new(0.4, 0, 1, 0)}, nrc)
	local nb = mc.nw("TextBox", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(170, 28), BackgroundColor3 = k.bg, Font = fm, PlaceholderText = "Macro Name", PlaceholderColor3 = k.dm, Text = "", TextColor3 = k.tx, TextSize = 13, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left}, nrc)
	rc(nb, 4)
	sk(nb, 0.85)
	pd(nb, 8, 8)
	local ar = cd2(28)
	mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, ar)
	local qb = {}
	for i, x in {{"New", "plus-large"}, {"Rename", "pencil"}, {"Copy", "check"}, {"Delete", "trash-can"}} do
		local b, l = pill(x[1], x[2], ar, 73)
		b.LayoutOrder = i
		qb[x[1]] = {b, l}
	end
	sc("Map")
	local mpr = cd2(28)
	mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, mpr)
	sc("Mode")
	local mdr = cd2(28)
	mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, mdr)
	sc("Steps")
	local stf = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nx()}, pg)
	mc.nw("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, stf)
	local wr = cd2(30)
	mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, wr)
	ic("clock", {TextSize = 15, Size = UDim2.fromOffset(18, 28), LayoutOrder = 1}, wr)
	tl({Text = "Wait for wave", TextSize = 13, TextColor3 = k.dm, Size = UDim2.fromOffset(92, 28), LayoutOrder = 2}, wr)
	local wb = mc.nw("TextBox", {Size = UDim2.fromOffset(64, 28), BackgroundColor3 = k.cd, Font = fm, PlaceholderText = "5", PlaceholderColor3 = k.dm, Text = "", TextColor3 = k.tx, TextSize = 13, ClearTextOnFocus = false, LayoutOrder = 3}, wr)
	rc(wb, 4)
	sk(wb, 0.85)
	local wa = pill("Add", "plus-large", wr, 86)
	wa.LayoutOrder = 4
	wa.Activated:Connect(function()
		local w = tonumber(wb.Text)
		if not mc.cur then
			W:Notify({Title = "Macro", Text = "Wait Failed: Make A Macro First", Error = true})
			return
		end
		if not w or w < 1 or w ~= math.floor(w) then
			W:Notify({Title = "Macro", Text = "Wait Failed: Type A Wave Number", Error = true})
			return
		end
		wb.Text = ""
		mc.ad({t = "wait", w = w})
	end)
	local function cl2(f) for _, x in f:GetChildren() do if x:IsA("GuiObject") then x:Destroy() end end end
	local function row(pa, h, on, o)
		local f = bt({Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = k.cd, BackgroundTransparency = on and 0 or 1, LayoutOrder = o}, pa)
		rc(f, 6)
		sk(f, 0.92)
		hv(f, function() return k.cd, on and 0 or 1 end)
		local bar = mc.nw("Frame", {Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = k.ac, BorderSizePixel = 0, Visible = on}, f)
		rc(bar, 2)
		return f
	end
	local dc, dn = 0, 0
	function mc.rf()
		cl2(mlh)
		local ql = mc.ql()
		if #ql == 0 then tl({Text = "No Macro Yet: Type A Name, Press New", TextSize = 13, TextColor3 = k.dm, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 1}, mlh) end
		for i, m in ql do
			local on = mc.cur ~= nil and mc.cur.Name == m[1]
			local f = row(mlh, 44, on, i)
			tl({Text = m[1], Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -170, 1, 0), TextColor3 = on and k.tx or k.dm, Font = on and fb or fm, TextTruncate = Enum.TextTruncate.AtEnd}, f)
			tl({Text = `{m[2]}  /  {m[3]}`, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 0), Size = UDim2.fromOffset(150, 44), TextSize = 12, TextColor3 = k.dm, TextXAlignment = Enum.TextXAlignment.Right, TextTruncate = Enum.TextTruncate.AtEnd}, f)
			f.Activated:Connect(function() task.spawn(mc.qo, m[1]) end)
		end
		cl2(mpr)
		local ml2 = mc.ls()
		for i, mn in ml2 do
			local on = mc.wv ~= nil and mc.wv.map == mn
			local b, l = pill(mn, nil, mpr, math.floor((300 - (#ml2 - 1) * 4) / math.max(#ml2, 1)))
			b.LayoutOrder = i
			b:SetAttribute("on", on)
			if on then b.BackgroundColor3, l.TextColor3, l.Font = k.ac, k.bg, fb end
			b.Activated:Connect(function()
				task.spawn(function()
					mc.ld(mn)
					mc.rf()
				end)
			end)
		end
		cl2(mdr)
		local em = mc.cur and mc.cur.Mode or mc.em
		for i, m in mc.ml do
			local on = m == em
			local b, l = pill(m, nil, mdr, 57)
			b.LayoutOrder, l.TextSize = i, 12
			b:SetAttribute("on", on)
			if on then b.BackgroundColor3, l.TextColor3, l.Font = k.ac, k.bg, fb end
			b.Activated:Connect(function()
				mc.em = m
				if mc.cur and (mc.cur.Mode or "Easy") ~= m then
					mc.cur.Mode = m
					mc.qs()
					mc.rq()
				end
				mc.rf()
			end)
		end
		cl2(stf)
		local S = mc.cur and mc.cur.S or {}
		if mc.cur and #S == 0 then tl({Text = "No Steps Yet: Click The Ground On The Map", TextSize = 13, TextColor3 = k.dm, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = 1}, stf) end
		for i, s in S do
			local on = s.n ~= nil and s.n == mc.sel
			local f = row(stf, 36, on, i)
			tl({Text = tostring(i), Position = UDim2.fromOffset(10, 0), Size = UDim2.fromOffset(22, 36), TextSize = 12, TextColor3 = k.dm, TextXAlignment = Enum.TextXAlignment.Center}, f)
			tl({Text = mc.st(s), Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -124, 1, 0), TextSize = 13, TextColor3 = on and k.tx or k.dm, Font = on and fb or fm, TextTruncate = Enum.TextTruncate.AtEnd}, f)
			f.Activated:Connect(function()
				mc.sel = s.n
				mc.rf()
			end)
			for j, x in {{"chevron-small-up", -1}, {"chevron-small-down", 1}, {"trash-can", 0}} do
				local b = bt({AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6 - (3 - j) * 28, 0.5, 0), Size = UDim2.fromOffset(26, 26), BackgroundColor3 = k.hv}, f)
				rc(b, 4)
				local g = ic(x[1], {TextSize = 14, Size = UDim2.fromScale(1, 1)}, b)
				b.MouseEnter:Connect(function()
					if ui.MouseEnabled then tw(b, {BackgroundTransparency = 0}) end
					g.TextColor3 = x[2] == 0 and k.er or k.tx
				end)
				b.MouseLeave:Connect(function()
					tw(b, {BackgroundTransparency = 1})
					g.TextColor3 = k.dm
				end)
				b.Activated:Connect(function()
					mc.hp()
					if x[2] == 0 and S[i].t == "place" then
						local n2 = S[i].n
						for j2 = #S, 1, -1 do
							if S[j2].n == n2 then table.remove(S, j2) end
						end
						if mc.sel == n2 then mc.sel = nil end
					elseif x[2] == 0 then
						table.remove(S, i)
					elseif S[i + x[2]] then
						S[i], S[i + x[2]] = S[i + x[2]], S[i]
					end
					mc.qs()
					mc.rf()
				end)
			end
		end
		cl2(wvf)
		local wl = mc.wl(em or "Easy")
		wvh.Text = `Waves   /   {em or "Easy"}`
		if not wl then tl({Text = "No Wave List Yet: Join Any Match Once", TextSize = 13, TextColor3 = k.dm, TextWrapped = true, Size = UDim2.new(1, 0, 0, 44), LayoutOrder = 1}, wvf) end
		for i, w in wl or {} do
			local on, n = false, 0
			for _, s in S do
				if s.t == "wait" and tonumber(s.w) == i then on = true end
			end
			for _, e in w do n += tonumber(e[2]) or 0 end
			local f = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = k.cd, BackgroundTransparency = on and 0 or 1, BorderSizePixel = 0, LayoutOrder = i}, wvf)
			rc(f, 6)
			sk(f, 0.92)
			local bar = mc.nw("Frame", {Size = UDim2.fromOffset(3, 16), Position = UDim2.fromOffset(0, 12), BackgroundColor3 = k.ac, BorderSizePixel = 0, Visible = on}, f)
			rc(bar, 2)
			local h = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, f)
			pd(h, 10, 6, 6, 6)
			mc.nw("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}, h)
			local hd = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 1}, h)
			tl({Text = `Wave {i}`, Font = fb, TextSize = 13, Position = UDim2.fromOffset(2, 0), Size = UDim2.new(0, 60, 0, 28)}, hd)
			tl({Text = `{n} Enemies`, TextSize = 12, TextColor3 = k.dm, Position = UDim2.fromOffset(62, 0), Size = UDim2.new(1, -136, 0, 28), TextTruncate = Enum.TextTruncate.AtEnd}, hd)
			local wb2 = pill("Wait", "plus-large", hd, 70)
			wb2.AnchorPoint, wb2.Position = Vector2.new(1, 0), UDim2.fromScale(1, 0)
			wb2.Activated:Connect(function()
				if not mc.cur then
					W:Notify({Title = "Macro", Text = "Wait Failed: Make A Macro First", Error = true})
					return
				end
				mc.ad({t = "wait", w = i})
			end)
			for j, e in w do
				local eb2 = bt({Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = k.hv, LayoutOrder = j + 1}, h)
				rc(eb2, 4)
				hv(eb2, function() return k.hv, 1 end)
				tl({Text = `{e[1]} x{e[2]}`, TextSize = 12, TextColor3 = k.dm, Position = UDim2.fromOffset(4, 0), Size = UDim2.new(1, -26, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd}, eb2)
				ic("chevron-small-right", {TextSize = 13, AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(20, 24)}, eb2)
				eb2.MouseEnter:Connect(function() if ui.MouseEnabled then mc.ei(e[1], eb2, true) end end)
				eb2.MouseLeave:Connect(function() mc.eh(e[1]) end)
				eb2.Activated:Connect(function() if not ui.MouseEnabled then mc.ei(e[1], eb2) end end)
			end
		end
		cm1.Text = mc.wv and mc.wv.map or "No Map"
		cm2.Text = mc.cur and mc.cur.Name or "No Macro"
		mc.tl.Text = mc.am and `Click The Map: Where #{mc.am} Uses Its Ability` or "Click Ground: Place   /   Click A Number: Upgrade, Sell   /   Scroll: Zoom   /   Drag: Move"
		mc.mr()
	end
	function mc.cp()
		if mc.pp then mc.pp:Destroy() end
		mc.pp = nil
	end
	function mc.eh(nm)
		if mc.en ~= nm then return end
		if mc.ep then mc.ep:Destroy() end
		mc.ep, mc.en = nil, nil
	end
	function mc.ei(nm, ro, sh)
		if sh and mc.en == nm and mc.ep then return end
		if mc.ep then mc.ep:Destroy() end
		mc.ep = nil
		if not sh and mc.en == nm then
			mc.en = nil
			return
		end
		local G = getrenv().shared.Modules.Config
		local c = G.Enemies and G.Enemies[nm]
		if type(c) ~= "table" then
			W:Notify({Title = "Macro", Text = `Info Failed: No Config For {nm}`, Error = true})
			return
		end
		mc.en = nm
		local y = math.clamp((ro.AbsolutePosition.Y - fr.AbsolutePosition.Y) / us.Scale - 8, 44, wh - 320)
		local f = mc.nw("Frame", {Position = UDim2.fromOffset(ww - 12 - 230 - 8 - 290, y), Size = UDim2.fromOffset(290, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = k.bg, BorderSizePixel = 0, ZIndex = 30}, fr)
		rc(f, 8)
		sk(f, 0.8)
		mc.ep = f
		local h = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, f)
		pd(h, 12, 12, 10, 12)
		mc.nw("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}, h)
		local tp = mc.nw("Frame", {Size = UDim2.new(1, 0, 0, 96), BackgroundTransparency = 1, LayoutOrder = 1}, h)
		local vp = mc.nw("ViewportFrame", {Size = UDim2.fromOffset(96, 96), BackgroundColor3 = k.cd, Ambient = Color3.fromRGB(200, 200, 200), LightColor = Color3.new(1, 1, 1), LightDirection = Vector3.new(-0.4, -1, -0.6)}, tp)
		rc(vp, 6)
		if typeof(c.Model) == "Instance" and c.Model:IsA("Model") then
			local m = c.Model:Clone()
			for _, d in m:GetDescendants() do
				if d:IsA("LuaSourceContainer") or d:IsA("LayerCollector") then d:Destroy() end
			end
			m.Parent = vp
			local cf, sz = m:GetBoundingBox()
			local cam = mc.nw("Camera", {FieldOfView = 40}, vp)
			cam.CFrame = CFrame.lookAt(cf.Position + m:GetPivot().LookVector * (sz.Magnitude / (2 * math.tan(math.rad(20))) * 0.9) + Vector3.new(0, sz.Y * 0.1, 0), cf.Position)
			vp.CurrentCamera = cam
		end
		tl({Text = tostring(c.DisplayName or nm), Font = fb, TextSize = 15, TextWrapped = true, Position = UDim2.fromOffset(106, 0), Size = UDim2.new(1, -140, 0, 40), TextYAlignment = Enum.TextYAlignment.Top}, tp)
		tl({Text = `Base HP: {mc.fn(c.BaseHealth)}\nSpeed: {tostring(c.Speed or "?")}\nMoney On Kill: {mc.fn(c.MoneyForDeath)}`, TextSize = 12, TextColor3 = k.dm, Position = UDim2.fromOffset(106, 42), Size = UDim2.new(1, -106, 0, 54), TextYAlignment = Enum.TextYAlignment.Top}, tp)
		local xb3 = bt({AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromScale(1, 0), Size = UDim2.fromOffset(28, 24), BackgroundColor3 = k.hv}, tp)
		rc(xb3, 4)
		ic("x", {TextSize = 13, Size = UDim2.fromScale(1, 1)}, xb3)
		xb3.MouseEnter:Connect(function() tw(xb3, {BackgroundTransparency = 0}) end)
		xb3.MouseLeave:Connect(function() tw(xb3, {BackgroundTransparency = 1}) end)
		xb3.Activated:Connect(function()
			if mc.ep then mc.ep:Destroy() end
			mc.ep, mc.en = nil, nil
		end)
		local ln = {}
		table.insert(ln, c.StunRange and `Stuns Towers: Range {c.StunRange}, {c.StunDuration or "?"} s, Every {c.StunCooldown or "?"} s` or "Stuns Towers: No")
		if c.HideDetection then
			local tq = {}
			for tn, tv in G.Towers do
				if type(tv) == "table" and tv.HideDetection then table.insert(tq, tn) end
			end
			table.sort(tq)
			table.insert(ln, `Not Targeted By: {#tq > 0 and table.concat(tq, ", ") or "?"}`)
		end
		local em2, wa, tt = mc.cur and mc.cur.Mode or mc.em, {}, 0
		for i, w in mc.wl(em2) or {} do
			for _, e in w do
				if e[1] == nm then
					table.insert(wa, `{i} (x{e[2]})`)
					tt += tonumber(e[2]) or 0
				end
			end
		end
		table.insert(ln, `In {em2}: {#wa > 0 and `Wave {table.concat(wa, ", ")}` or "None"}`)
		table.insert(ln, `Total In {em2}: {tt}`)
		for i, t in ln do tl({Text = t, TextSize = 12, TextColor3 = k.tx, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, LayoutOrder = i + 1}, h) end
	end
	local function pf(q, w, h)
		mc.cp()
		local vz = mc.vz()
		local x = q.X + 14 + w > vz.X - 8 and q.X - 14 - w or q.X + 14
		local f = mc.nw("Frame", {Position = UDim2.fromOffset(math.clamp(x, 8, math.max(8, vz.X - w - 8)), math.clamp(q.Y - h / 2, 8, math.max(8, vz.Y - h - 8))), Size = UDim2.fromOffset(w, h), BackgroundColor3 = k.bg, BorderSizePixel = 0, ZIndex = 20}, vf)
		rc(f, 8)
		sk(f, 0.8)
		mc.pp = f
		local xb2 = bt({AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 8), Size = UDim2.fromOffset(28, 24), BackgroundColor3 = k.hv}, f)
		rc(xb2, 4)
		ic("x", {TextSize = 13, Size = UDim2.fromScale(1, 1)}, xb2)
		xb2.MouseEnter:Connect(function() tw(xb2, {BackgroundTransparency = 0}) end)
		xb2.MouseLeave:Connect(function() tw(xb2, {BackgroundTransparency = 1}) end)
		xb2.Activated:Connect(function()
			mc.px = os.clock()
			mc.cp()
		end)
		return f
	end
	local function bb(f, t, icn, y, cl, fnc)
		local b = bt({Position = UDim2.fromOffset(10, y), Size = UDim2.new(1, -20, 0, 34), BackgroundColor3 = k.cd, BackgroundTransparency = 0}, f)
		rc(b, 6)
		sk(b, 0.92)
		ic(icn, {TextSize = 15, TextColor3 = cl or k.tx, Position = UDim2.fromOffset(8, 0), Size = UDim2.fromOffset(20, 34)}, b)
		local l = tl({Text = t, TextSize = 14, TextColor3 = cl or k.tx, Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -42, 1, 0)}, b)
		if fnc then
			hv(b, function() return k.cd, 0 end)
			b.Activated:Connect(function()
				mc.px = os.clock()
				fnc()
			end)
		else
			l.TextColor3 = k.dm
		end
		return b
	end
	function mc.pu(q, p)
		local f = pf(q, 330, 320)
		tl({Text = "Place Which Unit?", Font = fb, Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -60, 0, 28)}, f)
		local sb3 = mc.nw("TextBox", {Position = UDim2.fromOffset(10, 40), Size = UDim2.new(1, -20, 0, 30), BackgroundColor3 = k.cd, Font = fm, PlaceholderText = "Search Unit", PlaceholderColor3 = k.dm, Text = mc.uf or "", TextColor3 = k.tx, TextSize = 13, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left}, f)
		rc(sb3, 6)
		sk(sb3, 0.92)
		pd(sb3, 34, 10)
		ic("magnifying-glass", {Position = UDim2.fromOffset(-26, 0), Size = UDim2.fromOffset(18, 30), TextSize = 14}, sb3)
		local gr = mc.nw("ScrollingFrame", {Position = UDim2.fromOffset(10, 78), Size = UDim2.new(1, -14, 1, -86), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = k.dm, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, f)
		pd(gr, 1, 6, 1, 1)
		mc.nw("UIGridLayout", {CellSize = UDim2.new(0.25, -5, 0, 92), CellPadding = UDim2.fromOffset(5, 5), SortOrder = Enum.SortOrder.LayoutOrder}, gr)
		local function fl()
			cl2(gr)
			local fq = string.lower(mc.uf or "")
			for i, u in mc.us() do
				if fq ~= "" and not string.find(string.lower(u), fq, 1, true) then continue end
				local cf = tc(u)
				local b = bt({BackgroundColor3 = k.cd, BackgroundTransparency = 0, LayoutOrder = i}, gr)
				rc(b, 6)
				sk(b, 0.92)
				hv(b, function() return k.cd, 0 end)
				mc.nw("ImageLabel", {BackgroundTransparency = 1, Image = cf and cf.Icon or "", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 6), Size = UDim2.fromOffset(48, 48), ScaleType = Enum.ScaleType.Fit}, b)
				tl({Text = u, TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Center, TextYAlignment = Enum.TextYAlignment.Top, Position = UDim2.fromOffset(3, 56), Size = UDim2.new(1, -6, 0, 32)}, b)
				b.Activated:Connect(function()
					mc.px = os.clock()
					local n = 0
					for _, s in mc.cur.S do
						if s.t == "place" and s.n > n then n = s.n end
					end
					mc.cp()
					mc.sel = n + 1
					mc.ad({t = "place", n = n + 1, u = u, p = {mc.r2(p.X), mc.r2(p.Y), mc.r2(p.Z)}})
				end)
			end
		end
		sb3:GetPropertyChangedSignal("Text"):Connect(function()
			if mc.uf == sb3.Text then return end
			mc.uf = sb3.Text
			fl()
		end)
		fl()
	end
	function mc.pa(q, ns, ix)
		local n = ns[ix]
		local s0 = mc.fs(n)
		if not s0 then return end
		local cf = tc(s0.u)
		local U = cf and cf.Upgrades or {}
		local lv, tg = mc.lv(n), mc.tm(n)
		local ab = cf and type(cf.Ability) == "table"
		local y0 = #ns > 1 and 92 or 60
		local f = pf(q, 250, y0 + (ab and 5 or 4) * 38 + 8)
		mc.nw("ImageLabel", {BackgroundTransparency = 1, Image = cf and cf.Icon or "", Position = UDim2.fromOffset(10, 8), Size = UDim2.fromOffset(42, 42), ScaleType = Enum.ScaleType.Fit}, f)
		tl({Text = s0.u, Font = fb, TextSize = 14, Position = UDim2.fromOffset(58, 8), Size = UDim2.new(1, -100, 0, 22), TextTruncate = Enum.TextTruncate.AtEnd}, f)
		tl({Text = `#{n}   Lv {lv} / {#U}   Target {tg}`, TextSize = 12, TextColor3 = k.dm, Position = UDim2.fromOffset(58, 30), Size = UDim2.new(1, -66, 0, 18)}, f)
		if #ns > 1 then
			local r = mc.nw("Frame", {Position = UDim2.fromOffset(10, 58), Size = UDim2.new(1, -20, 0, 28), BackgroundTransparency = 1}, f)
			mc.nw("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder}, r)
			for i, m in ns do
				local b, l = pill(`#{m}`, nil, r, 44)
				b.LayoutOrder = i
				if i == ix then
					b:SetAttribute("on", true)
					b.BackgroundColor3, l.TextColor3, l.Font = k.ac, k.bg, fb
				end
				b.Activated:Connect(function()
					mc.px = os.clock()
					mc.sel = m
					mc.rf()
					mc.pa(q, ns, i)
				end)
			end
		end
		local y = y0
		bb(f, lv < #U and `Upgrade  (Lv {lv} to {lv + 1})` or "Max Level", "arrow-up-circle", y, nil, lv < #U and function()
			mc.ad({t = "up", n = n, lv = lv + 1})
			mc.pa(q, ns, ix)
		end or nil)
		y += 38
		bb(f, `Target: {tg}  (Click To Change)`, "flag", y, nil, function()
			local L = {"First", "Last", "Closest", "Strong", "Weak"}
			mc.ad({t = "tgt", n = n, m = L[(table.find(L, tg) or 1) % #L + 1]})
			mc.pa(q, ns, ix)
		end)
		y += 38
		bb(f, "Sell", "tag", y, nil, function()
			mc.cp()
			mc.ad({t = "sell", n = n})
		end)
		y += 38
		if ab then
			bb(f, "Ability  (Then Click The Map)", "map-pin", y, nil, function()
				mc.cp()
				mc.am = n
				mc.rf()
			end)
			y += 38
		end
		bb(f, "Remove This Unit", "trash-can", y, k.er, function()
			mc.cp()
			mc.hp()
			local S = mc.cur.S
			for j = #S, 1, -1 do
				if S[j].n == n then table.remove(S, j) end
			end
			mc.sel = nil
			mc.qs()
			mc.rf()
		end)
	end
	local function qe(t) W:Notify({Title = "Macro", Text = t, Error = true}) end
	qb.New[1].Activated:Connect(function()
		local n = mc.qn(nb.Text)
		if n == "" then
			qe("Macro Failed: No Name")
			return
		end
		if isfile(`{mc.qd}/{n}.json`) then
			qe("Macro Failed: Name Taken")
			return
		end
		if not mc.wv then
			qe("Macro Failed: No Map Loaded")
			return
		end
		mc.cur, mc.sel, nb.Text, mc.hs = {Name = n, Map = mc.wv.map, Mode = mc.em, Ver = 1, S = {}}, nil, "", {}
		mc.qs()
		mc.rf()
		mc.rq()
	end)
	qb.Rename[1].Activated:Connect(function()
		local n = mc.qn(nb.Text)
		if not mc.cur then
			qe("Rename Failed: No Macro Selected")
			return
		end
		if n == "" then
			qe("Rename Failed: No Name")
			return
		end
		if isfile(`{mc.qd}/{n}.json`) then
			qe("Rename Failed: Name Taken")
			return
		end
		local o, a = `{mc.qd}/{mc.cur.Name}.json`, mc.cur.Name
		mc.cur.Name, nb.Text = n, ""
		mc.qs()
		if isfile(o) then delfile(o) end
		mc.rf()
		mc.rq(a, n)
	end)
	qb.Copy[1].Activated:Connect(function()
		if not mc.cur then
			qe("Copy Failed: No Macro Selected")
			return
		end
		local n = mc.qn(nb.Text)
		if n == "" then n = mc.qn(mc.cur.Name .. " Copy") end
		if isfile(`{mc.qd}/{n}.json`) then
			qe("Copy Failed: Name Taken")
			return
		end
		local hj = game:GetService("HttpService")
		local j = hj:JSONDecode(hj:JSONEncode(mc.cur))
		j.Name, mc.cur, nb.Text, mc.hs = n, j, "", {}
		mc.qs()
		mc.rf()
		mc.rq()
	end)
	local db, dl = qb.Delete[1], qb.Delete[2]
	db.Activated:Connect(function()
		if not mc.cur then
			qe("Delete Failed: No Macro Selected")
			return
		end
		if os.clock() - dc > 3 then
			dc, dn = os.clock(), dn + 1
			local my2 = dn
			db:SetAttribute("on", true)
			db.BackgroundColor3, dl.Text = k.er, "Sure?"
			task.delay(3, function()
				if dn ~= my2 or not db.Parent then return end
				db:SetAttribute("on", false)
				db.BackgroundColor3, dl.Text = k.hv, "Delete"
			end)
			return
		end
		local o = `{mc.qd}/{mc.cur.Name}.json`
		if isfile(o) then delfile(o) end
		dn += 1
		db:SetAttribute("on", false)
		mc.cur, mc.sel, dc, db.BackgroundColor3, dl.Text, mc.hs = nil, nil, 0, k.hv, "Delete", {}
		mc.rf()
		mc.rq()
	end)
	local dg, ds, cs = nil, nil, {}
	sg.Destroying:Connect(function() for _, x in cs do x:Disconnect() end end)
	tb.InputBegan:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
		dg, ds = {fr.Position, i.Position}, nil
	end)
	vf.InputBegan:Connect(function(i)
		if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and mc.wv then ds, dg = {mc.wv.cx, mc.wv.cz, i.Position, ui:GetMouseLocation()}, nil end
	end)
	vf.InputChanged:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseWheel or not mc.wv then return end
		mc.wv.h = math.clamp(mc.wv.h * (i.Position.Z > 0 and 0.85 or 1.18), 8, 3000)
		mc.cm()
	end)
	cs[#cs + 1] = ui.InputChanged:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
		if dg then
			local d = i.Position - dg[2]
			fr.Position = dg[1] + UDim2.fromOffset(d.X, d.Y)
		elseif ds and mc.wv then
			local d = i.Position - ds[3]
			local wp = 2 * mc.wv.h * math.tan(math.rad(vf.CurrentCamera.FieldOfView / 2)) / math.max(vf.AbsoluteSize.Y, 1)
			mc.wv.cx, mc.wv.cz = ds[1] - d.X * wp, ds[2] - d.Y * wp
			mc.cm()
		end
	end)
	cs[#cs + 1] = ui.InputEnded:Connect(function(i)
		if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
		local m = ui:GetMouseLocation()
		if ds and (m - ds[4]).Magnitude < 5 then
			local q = (m - game:GetService("GuiService"):GetGuiInset() - vf.AbsolutePosition) / us.Scale
			task.spawn(mc.ck, q)
		end
		dg, ds = nil, nil
	end)
	local ml = mc.ls()
	local cur = pl == "Match" and at("Map")
	mc.rf()
	task.spawn(function()
		if type(cur) == "string" and table.find(ml, cur) then mc.ld(cur) elseif ml[1] then mc.ld(ml[1]) end
		mc.rf()
	end)
end

function mc.qm(k)
	local o = {"None"}
	for _, x in mc.ql() do
		if `{x[2]}|{x[3]}` == k then table.insert(o, x[1]) end
	end
	return o
end

function mc.qp()
	local l, s = {}, {}
	for _, x in mc.ql() do
		local k = `{x[2]}|{x[3]}`
		if x[2] ~= "?" and not s[k] then s[k] = true; table.insert(l, {k, x[2], table.find(mc.ml, x[3]) or 99}) end
	end
	table.sort(l, function(a, b)
		if a[2] ~= b[2] then return a[2] < b[2] end
		return a[3] < b[3]
	end)
	local o = {}
	for _, x in l do table.insert(o, x[1]) end
	return o
end

function mc.ra(k)
	local m, d = string.match(k, "^(.*)|(.-)$")
	mc.rw[k] = mc.tq:Dropdown({Name = `{m} - {d}`, Options = mc.qm(k), Default = "None", Flag = `mq_{m}_{d}`, Callback = function(v) st.mq[k] = v ~= "None" and v or nil end})
end

function mc.rq(a, b)
	if a and ge.__CtdMp and ge.__CtdMp.q == a then ge.__CtdMp.q = b end
	for _, k in mc.qp() do
		if not mc.rw[k] then mc.ra(k) end
	end
	for k, r in mc.rw do
		local v = r:Get()
		r:Refresh(mc.qm(k))
		if a and v == a then r:Set(b) end
	end
end

function mc.tx(i) return getrenv().shared.Modules.GameReplicator.Data.Towers[i] end

function mc.lf(u, p)
	local m = tc(u).Model
	local f, z = m:GetBoundingBox()
	return CFrame.new(p + Vector3.new(0, math.max(m:GetPivot().Position.Y - (f.Position.Y - z.Y / 2), 0), 0))
end

function mc.cw(f)
	local t = os.clock()
	while not f() and os.clock() - t < 3 do task.wait(0.1) end
	return f()
end

function mc.pw(c, t)
	local P = mc.ps
	if P.wm ~= P.i then
		P.wm = P.i
		lg(`[Macro] Step {P.i} Waiting {t or `${c} | Have ${mo()}`}`)
	end
	return false
end

function mc.pz(t)
	mc.ps.x = true
	W:Notify({Title = "Macro", Text = t, Error = true})
	return false
end

function mc.pn(s)
	local P, n = mc.ps, s.n
	if s.t == "wait" then return (at("Wave") or 0) >= (tonumber(s.w) or 0) or mc.pw(0, `For Wave {s.w} | Now Wave {at("Wave") or "?"}`) end
	if s.t == "place" then
		local c = tc(s.u)
		local u1 = c and c.Upgrades and c.Upgrades[1]
		if not u1 or type(s.p) ~= "table" then return mc.pz(`Place #{n} Failed: Bad Step`) end
		if mo() < u1.Price then return mc.pw(u1.Price) end
		local h, b, id = nil, {}, nil
		for _, x in ht() do
			if x.Name == s.u then h = x end
		end
		if not h then return mc.pz(`Place #{n} Failed: {s.u} Not In Hotbar`) end
		for _, x in my() do b[x.Id] = true end
		local cf = mc.lf(s.u, Vector3.new(s.p[1], s.p[2], s.p[3]))
		rm("TowerAdd"):FireServer({Name = s.u, UnitId = h.Uid, Pos = cf.Position, CFrame = cf})
		mc.cw(function()
			for _, x in my() do
				if not b[x.Id] then id = x.Id end
			end
			return id ~= nil
		end)
		if not id then return mc.pz(`Place #{n} Failed: No Confirm`) end
		P.d[n] = id
		lg(`[Macro] Place {s.u} #{n} | ${u1.Price} | Wave {at("Wave")}`)
		return true
	end
	local k = ({up = "Upgrade", sell = "Sell", tgt = "Target", ab = "Ability"})[s.t]
	if not k then return mc.pz("Macro Failed: Unknown Step") end
	local id = P.d[n]
	local x = id and mc.tx(id)
	if not x then return mc.pz(`{k} #{n} Failed: No Tower`) end
	local c, l = tc(x.Name), tonumber(x.Level) or 1
	if s.t == "up" then
		local w = tonumber(s.lv) or 0
		if l >= w then return true end
		local u = c and c.Upgrades and c.Upgrades[l + 1]
		if not u then return mc.pz(`Upgrade #{n} Failed: Max Level`) end
		if mo() < u.Price then return mc.pw(u.Price) end
		rm("TowerUpgrade"):FireServer({Id = id})
		if not mc.cw(function()
			local y = mc.tx(id)
			return y ~= nil and (tonumber(y.Level) or 1) > l
		end) then return mc.pz(`Upgrade #{n} Failed: No Confirm`) end
		lg(`[Macro] Upgrade #{n} Lv {l + 1} | ${u.Price} | Wave {at("Wave")}`)
		return l + 1 >= w
	end
	if s.t == "sell" then
		rm("TowerSell"):FireServer({Id = id})
		if not mc.cw(function() return mc.tx(id) == nil end) then return mc.pz(`Sell #{n} Failed: No Confirm`) end
		P.d[n] = nil
		lg(`[Macro] Sell #{n} | Wave {at("Wave")}`)
		return true
	end
	if s.t == "tgt" then
		local m0 = x.TargetMode or "First"
		if m0 == s.m then return true end
		P.k += 1
		if P.k > 5 then return mc.pz(`Target #{n} Failed: No Mode {s.m}`) end
		rm("TowerTarget"):FireServer({Id = id})
		if not mc.cw(function()
			local y = mc.tx(id)
			return y ~= nil and (y.TargetMode or "First") ~= m0
		end) then return mc.pz(`Target #{n} Failed: No Confirm`) end
		local y = mc.tx(id)
		if not (y and y.TargetMode == s.m) then return false end
		lg(`[Macro] Target #{n} {s.m} | Wave {at("Wave")}`)
		return true
	end
	local A = c and c.Ability
	if type(A) ~= "table" or type(s.p) ~= "table" then return mc.pz(`Ability #{n} Failed: No Ability`) end
	if l < (tonumber(A.UnlockLevel) or 1) then return mc.pz(`Ability #{n} Failed: Needs Lv {A.UnlockLevel}`) end
	if mo() < (tonumber(A.Price) or 0) then return mc.pw(tonumber(A.Price) or 0) end
	local p0, cf = x.Pos, mc.lf(x.Name, Vector3.new(s.p[1], s.p[2], s.p[3]))
	rm("TowerAbility"):FireServer({Id = id, Args = {TargetPosition = cf.Position, TargetCFrame = cf}})
	if not mc.cw(function()
		local y = mc.tx(id)
		return y ~= nil and y.Pos ~= p0
	end) then return mc.pz(`Ability #{n} Failed: No Confirm`) end
	lg(`[Macro] Ability #{n} | Wave {at("Wave")}`)
	return true
end

function mc.pg()
	local mp, gs, md = at("Map"), at("GameState"), at("Mode")
	local q = st.um and type(mp) == "string" and type(md) == "string" and st.mq[`{mp}|{md}`]
	if not q or (gs ~= "InWave" and gs ~= "Intermission") then return end
	local P = ge.__CtdMp
	if not (P and P.j == game.JobId and P.q == q) then
		P = {j = game.JobId, q = q, i = 1, d = {}, k = 0}
		ge.__CtdMp = P
	end
	mc.ps = P
	if P.x then return end
	if not P.S then
		local ok, j = pcall(function() return hs:JSONDecode(readfile(`{mc.qd}/{q}.json`)) end)
		if not ok or type(j) ~= "table" or type(j.S) ~= "table" or j.Map ~= mp or (j.Mode or "Easy") ~= md then
			mc.pz(`Macro Load Failed: {q}`)
			return
		end
		local hb = {}
		for _, x in ht() do hb[x.Name] = true end
		for _, s in j.S do
			if s.t == "place" and not hb[s.u] then
				mc.pz(`Macro Failed: {s.u} Not In Hotbar`)
				return
			end
		end
		P.S = j.S
		lg(`[Macro] Start | {q} | {#j.S} Steps | Step {P.i}`)
	end
	local s = P.S[P.i]
	if not s then
		if P.z then return end
		P.z = true
		lg(`[Macro] Done | {q}`, true)
		return
	end
	if mc.pn(s) then P.i, P.k = P.i + 1, 0 end
end

if ge.__CtdMg then pcall(ge.__CtdMg.Destroy, ge.__CtdMg) end
local tm = W:Tab({Name = "Macro", Icon = "hammer-code"})
tm:Section({Name = "Macro"})
tm:Button({Name = "Open Macro Editor", Callback = function()
	mc.op()
	ge.__CtdMg = mc.sg
end})
tm:Section({Name = "Play"})
st.mr = tm:Toggle({Name = "Use Macro", Default = false, Flag = "um", Callback = function(v)
	st.um = v == true
	if not st.um then return end
	if ge.__CtdMp then ge.__CtdMp.x = nil end
	if st.ar then st.ar:Set(false) end
end})
mc.tq = tm
for _, k in mc.qp() do mc.ra(k) end
if pl == "Match" then
	task.spawn(function()
		local ok, e = xpcall(mc.ms, tb)
		if not ok then xe("Map Save", e) end
		local ok2, e2 = xpcall(mc.wc, tb)
		if not ok2 then xe("Waves Save", e2) end
	end)
	task.spawn(function()
		while st.bg do
			local ok, e = xpcall(mc.pg, tb)
			if not ok then
				xe("Macro", e)
				task.wait(5)
			end
			task.wait(0.3)
		end
	end)
end

task.spawn(function()
	local fn, lv, nx, fs = {{"mp", "Select Map"}, {"mf", "Modifiers"}, {"aj", "Auto Join"}, {"tg", "Summon Targets"}, {"su", "Auto Summon"}, {"sl", "Auto Sell"}, {"md", "Select Mode"}, {"av", "Auto Vote"}, {"as", "Auto Skip"}, {"ss", "Auto Speed"}, {"ap", "Auto Play Again"}, {"mx", "Max Towers"}, {"pl", "Auto Play"}, {"um", "Use Macro"}}, {}, 0, true
	while st.bg do
		local ch, l = {}, table.clone(fn)
		for _, r in mc.rw do table.insert(l, {r.Flag, r.Name}) end
		for _, x in l do
			local v = L.Flags[x[1]]
			if v ~= nil then
				local ok, s = pcall(function() return type(v) == "table" and `[{table.concat(v, ", ")}]` or tostring(v) end)
				s = ok and s or "?"
				if lv[x[1]] ~= s then
					lv[x[1]] = s
					table.insert(ch, `{x[2]} = {s}`)
				end
			end
		end
		if #ch > 0 then lg(`[Config] {table.concat(ch, " | ")}`) end
		if fs or pl == "Match" and (st.pl or st.um) and os.clock() >= nx then
			fs, nx = false, os.clock() + 60
			local ok, s = xpcall(xs, tb)
			if ok then lg(s) else xe("State", s) end
		end
		task.wait(1)
	end
end)

if ge.__CtdK then pcall(ge.__CtdK.Disconnect, ge.__CtdK) end
ge.__CtdK = (game:GetService("GuiService") :: any).ErrorMessageChanged:Connect(function(m)
	if type(m) == "string" and m ~= "" then lg(`[Kick] {m}`, true) end
end)
if ge.__CtdT then pcall(ge.__CtdT.Disconnect, ge.__CtdT) end
ge.__CtdT = lp.OnTeleport:Connect(function(s, p) lg(`[Teleport] {s.Name}{p and p ~= 0 and ` | Place {p}` or ""}`, true) end)

if ge.__CtdA then pcall(ge.__CtdA.Disconnect, ge.__CtdA) end
ge.__CtdA = lp.Idled:Connect(function()
	local vu, vm = game:GetService("VirtualUser"), game:GetService("VirtualInputManager")
	vu:CaptureController()
	vu:ClickButton2(Vector2.new())
	vm:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
	task.wait(0.05)
	vm:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
end)
