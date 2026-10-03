if not game:IsLoaded() then game.Loaded:Wait() end

local ps, rs, hs = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("HttpService")
repeat task.wait() until ps.LocalPlayer

local lp = ps.LocalPlayer
while lp:GetAttribute("GameLoaded") ~= true do lp:GetAttributeChangedSignal("GameLoaded"):Wait() end
local sd = rs:WaitForChild("ServerData")
local ae = sd:WaitForChild("ActiveEggs")
local gr = rs:WaitForChild("Remotes"):WaitForChild("Game")
local ep, pr, hc, ci = gr:WaitForChild("EggPickup"), gr:WaitForChild("EggPlaced"), gr:WaitForChild("Hatch"), gr:WaitForChild("ClaimIndexReward")
local ul = gr:WaitForChild("Plot"):WaitForChild("Upgrades")
local rg = rs:WaitForChild("Assets"):FindFirstChild("RarityGradients")
local bl, pf, pq, pm, by, st = {}, nil, 0, nil, false, "Ready"

local ed, ix, hl
do
	local dn
	task.spawn(function()
		local gd = rs:WaitForChild("GameData")
		local ok, m = pcall(require, gd:WaitForChild("Eggs"))
		if ok and type(m) == "table" then
			ed = {}
			for n, d in m do
				if type(d) == "table" then ed[n] = {lk = tonumber(d.Luck) or 0, im = d.Image, ra = d.Rarity, pm = d.Premium == true, rk = d.ReleaseKey} end
			end
		end
		local o3, hk = pcall(require, gd:WaitForChild("HatchLuck"))
		if o3 and type(hk) == "table" and type(hk.GetPrice) == "function" and type(hk.GetPaidUpgrades) == "function" then hl = hk end
		local o1, ir = pcall(require, gd:WaitForChild("IndexRewards"))
		local o2, pt = pcall(require, gd:WaitForChild("Pets"))
		if o1 and o2 and type(ir) == "table" and type(ir.Stages) == "table" and type(pt) == "table" then
			ix = {st = {}, pn = {}}
			for i, g in ir.Stages do ix.st[i] = tonumber(g.Goal) end
			for n in pt do table.insert(ix.pn, n) end
		end
		dn = true
	end)
	repeat task.wait() until dn
end
if not ed then error("Load Failed: No Egg Data") end

local function hr()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
end

local function gp()
	local f = workspace:FindFirstChild("Plots")
	for _, p in f and f:GetChildren() or {} do
		local d = p:FindFirstChild("Data")
		local o = d and d:FindFirstChild("Owner")
		if o and o.Value == lp then return p end
	end
	return nil
end

local function tp(h, p)
	h.CFrame = CFrame.new(p + Vector3.new(0, 3, 0))
	h.AssemblyLinearVelocity = Vector3.zero
end

local function cw(fn, ft, t)
	local r
	local cn = ep.OnClientEvent:Connect(function(...) if not r and ft(...) then r = {...} end end)
	fn()
	local dl = os.clock() + t
	repeat task.wait() until r or os.clock() > dl
	cn:Disconnect()
	return r
end

local function cm()
	local ok, m = pcall(hs.JSONDecode, hs, lp:GetAttribute("CollectedEggCycles"))
	return ok and type(m) == "table" and m or {}
end

local function cd(e, m)
	local n, cy = e:GetAttribute("Egg"), tonumber(e:GetAttribute("Cycle"))
	if e:GetAttribute("AdminSpawn") == true then
		local id, s = e:GetAttribute("AdminEggId"), lp:GetAttribute("CollectedAdminEggs")
		return type(id) == "string" and type(s) == "string" and s:find("," .. id .. ",", 1, true) ~= nil
	end
	local c = tonumber(m[n])
	if cy and c then return cy <= c end
	local s = lp:GetAttribute("CollectedEggs")
	return type(s) == "string" and s ~= "" and s:find(n .. ",", 1, true) ~= nil
end

local function el(e, m)
	local n, p, pv = e:GetAttribute("Egg"), e:GetAttribute("Position"), e:GetAttribute("PrivateTo")
	return type(n) == "string" and typeof(p) == "Vector3" and not bl[e.Name] and (not pv or pv == lp.UserId)
		and (tonumber(e:GetAttribute("DropEndsAt")) or 0) <= workspace:GetServerTimeNow() and not cd(e, m)
end

local function ct()
	local m, o = cm(), {}
	for _, e in ae:GetChildren() do
		if el(e, m) then
			local n = e:GetAttribute("Egg")
			o[n] = (o[n] or 0) + 1
		end
	end
	return o
end

local function nr(n, h)
	local m, b, bd = cm(), nil, 0
	for _, e in ae:GetChildren() do
		if e:GetAttribute("Egg") == n and el(e, m) then
			local d = (e:GetAttribute("Position") - h.Position).Magnitude
			if not b or d < bd then b, bd = e, d end
		end
	end
	return b
end

local lq = {}
local function wl(m)
	table.insert(lq, os.date("%H:%M:%S") .. " " .. m)
	if #lq > 300 then table.remove(lq, 1) end
	pcall(function()
		if not isfolder("Avenoric") then makefolder("Avenoric") end
		if not isfolder("Avenoric/RideAPet") then makefolder("Avenoric/RideAPet") end
		writefile("Avenoric/RideAPet/Log.txt", table.concat(lq, "\n"))
	end)
end

local function gb(e, h)
	local n, t0, r, nf, nx = e:GetAttribute("Egg"), os.clock(), nil, 0, 0
	local cn = ep.OnClientEvent:Connect(function(a, b, c)
		if r then return end
		local k = tostring(a)
		if k == "Refused" and c == e.Name and tostring(b):find("too far", 1, true) then nf += 1 return end
		if c == e.Name or k == "BasketFull" then r = {a, b} end
	end)
	tp(h, e:GetAttribute("Position"))
	repeat
		if os.clock() >= nx then
			nx = os.clock() + 0.25
			ep:FireServer(e.Name)
		end
		task.wait()
	until r or os.clock() - t0 > 6
	cn:Disconnect()
	wl(string.format("Grab %s: %s after %.2fs, %d too far", tostring(n), r and tostring(r[1]) .. " " .. tostring(r[2]) or "no answer", os.clock() - t0, nf))
	if not r then return nil, nf > 0 and "Grab Failed: Too Far" or "Grab Failed: No Reply" end
	if r[1] == "PickedUp" then return true end
	if r[1] == "BasketFull" then return nil, "Basket Full" end
	bl[e.Name] = true
	return nil, "Grab Failed: " .. tostring(r[2])
end

local function dv(h)
	local pt = gp()
	local b = pt and pt:FindFirstChild("Baseplate")
	if not b then return nil, "Deliver Failed: No Plot" end
	local r = cw(function() tp(h, b.Position + Vector3.new(0, b.Size.Y / 2, 0)) end, function(a) return a == "Deposited" end, 4)
	if not r then return nil, "Deliver Failed: No Reply" end
	return true
end

local function sp(pt)
	local b, us = pt.Baseplate, {}
	for _, n in {"Eggs", "Pets"} do
		local f = pt:FindFirstChild(n)
		for _, v in f and f:GetChildren() or {} do
			if v:IsA("PVInstance") then table.insert(us, v:GetPivot().Position) end
		end
	end
	for x = -30, 30, 8 do
		for z = -30, 30, 8 do
			local p, f = b.CFrame:PointToWorldSpace(Vector3.new(x, b.Size.Y / 2, z)), true
			for _, u in us do
				if ((u - p) * Vector3.new(1, 0, 1)).Magnitude < 7 then f = false break end
			end
			if f then return p end
		end
	end
	return nil
end

local function pn(hm)
	local pt = gp()
	if not pt or not pt:FindFirstChild("Baseplate") or not pt:FindFirstChild("Eggs") then return nil, "Plant Failed: No Plot" end
	local n = #pt.Eggs:GetChildren()
	if pm and n >= pm then return nil, "Plot Full At " .. pm end
	if pf and n >= pf and os.clock() - pq < 60 then return nil, "Plot Full At " .. pf end
	pf = nil
	local ts = {}
	for _, c in {lp.Character, lp:FindFirstChildOfClass("Backpack")} do
		for _, t in c and c:GetChildren() or {} do
			if t:IsA("Tool") and t:HasTag("Egg") then table.insert(ts, t) end
		end
	end
	for _, t in ts do
		if t.Parent then
			local p = sp(pt)
			if not p then return nil, "Plant Failed: No Space" end
			if t.Parent ~= lp.Character then
				hm:EquipTool(t)
				task.wait(0.2)
			end
			pr:FireServer({PlantPosition = p})
			local dl = os.clock() + 2
			repeat task.wait(0.1) until not t.Parent or os.clock() > dl
			if t.Parent then
				hm:UnequipTools()
				pf, pq = #pt.Eggs:GetChildren(), os.clock()
				return nil, "Plant Failed: No Reply"
			end
		end
	end
	return true
end

local function jx(e)
	local h, hm = hr()
	if not h or not hm or hm.Health <= 0 then return nil, "Grab Failed: No Character" end
	if not e.Parent then return nil, "Grab Failed: Egg Gone" end
	local n = e:GetAttribute("Egg")
	local ok, er = gb(e, h)
	if er == "Basket Full" then
		local d, de = dv(h)
		if not d then return nil, de end
		ok, er = gb(e, h)
	end
	if not ok then return nil, er end
	local d, de = dv(h)
	if not d then return nil, de end
	local p, pe = pn(hm)
	return true, p and "Got " .. n or "Got " .. n .. " | " .. pe
end

local function jb(n)
	local h = hr()
	if not h then return nil, "Grab Failed: No Character" end
	local e = nr(n, h)
	if not e then return nil, "Grab Failed: No " .. n end
	return jx(e)
end

local sq, fh, le, se, ao, ol, lc = 0, {}, nil, {}, false, false, 0
local function lk(f, ...)
	while by do task.wait(0.1) end
	by = true
	local r = table.pack(pcall(f, ...))
	by = false
	return table.unpack(r, 1, r.n)
end

local function rn(n)
	task.spawn(function()
		local ok, a, b = lk(jb, n)
		st = not ok and "Grab Failed: " .. tostring(a) or b
		wl("Click " .. n .. ": " .. tostring(st))
		sq += 1
	end)
end

local function rd(m)
	for _, d in m:GetDescendants() do
		if d:IsA("TextLabel") and d.Text == "Ready" then return true end
	end
	return false
end

local function ht(m)
	local h = hr()
	local k, pp = m:GetAttribute("EggKey"), m.PrimaryPart
	if not h then return nil, "Hatch Failed: No Character" end
	if not k or not pp or not m.Parent then return nil, "Hatch Failed: No Egg" end
	local r
	local cn = hc.OnClientEvent:Connect(function(a) if type(a) == "table" and a.EggKey == k then r = true end end)
	tp(h, pp.Position + Vector3.new(4, 0, 0))
	task.wait(0.2)
	hc:FireServer({EggKey = k})
	local dl = os.clock() + 5
	repeat task.wait(0.1) until r or not m.Parent or os.clock() > dl
	cn:Disconnect()
	if r or not m.Parent then return true end
	fh[k] = os.clock() + 30
	return nil, "Hatch Failed: No Reply"
end

local function ah()
	local pt = gp()
	local f = pt and pt:FindFirstChild("Eggs")
	for _, m in f and f:GetChildren() or {} do
		local k = m:GetAttribute("EggKey")
		if k and not m:HasTag("Hatching") and (fh[k] or 0) < os.clock() and rd(m) then lk(ht, m) end
	end
end

local function ag()
	local h = hr()
	if not ao or not h or not next(se) then return end
	local m, b, bk, bd = cm(), nil, 0, 0
	for _, e in ae:GetChildren() do
		local n = e:GetAttribute("Egg")
		if se[n] and el(e, m) then
			local k, d = ed[n] and ed[n].lk or 0, (e:GetAttribute("Position") - h.Position).Magnitude
			if not b or k > bk or k == bk and d < bd then b, bk, bd = e, k, d end
		end
	end
	if b then lk(jx, b) end
end

local function eh()
	for _, c in {lp.Character, lp:FindFirstChildOfClass("Backpack")} do
		for _, t in c and c:GetChildren() or {} do
			if t:IsA("Tool") and t:HasTag("Egg") then return true end
		end
	end
	return false
end

local function pj()
	local h, hm = hr()
	local pt = gp()
	local b = pt and pt:FindFirstChild("Baseplate")
	if not h or not hm or hm.Health <= 0 then return nil, "Plant Failed: No Character" end
	if not b then return nil, "Plant Failed: No Plot" end
	tp(h, b.Position + Vector3.new(0, b.Size.Y / 2, 0))
	task.wait(0.2)
	return pn(hm)
end

local function au()
	local pt = gp()
	local f = pt and pt:FindFirstChild("Eggs")
	if not f or not eh() then return end
	local n = #f:GetChildren()
	if pm and n >= pm or pf and n >= pf and os.clock() - pq < 60 then return end
	lk(pj)
end

local function lu()
	if not ol or not hl or os.clock() < lc or lp:GetAttribute("Setting_LuckMultiplier") == false then return end
	local sv = lp:FindFirstChild("SavedData")
	local hv, cs = sv and sv:FindFirstChild("HatchUpgrades"), sv and sv:FindFirstChild("Cash")
	if not hv or not cs then return end
	local fu, uu = sv:FindFirstChild("FreeHatchUpgrades"), sv:FindFirstChild("UsedFreeHatchUpgrades")
	local fr = fu and fu.Value > 0
	if not fr and cs.Value < hl.GetPrice(hl.GetPaidUpgrades(hv.Value, uu and uu.Value or 0)) then return end
	local v0 = hv.Value
	ul:FireServer(fr and "MaxFree" or "Max")
	local dl = os.clock() + 3
	repeat task.wait(0.1) until hv.Value ~= v0 or os.clock() > dl
	lc = os.clock() + (hv.Value ~= v0 and 2 or 30)
	wl(string.format("Luck %s: %d -> %d", fr and "MaxFree" or "Max", v0, hv.Value))
end

local function ks()
	local t = {}
	for _, c in {lp:FindFirstChildOfClass("Backpack"), lp.Character} do
		for _, x in c and c:GetChildren() or {} do
			if x:IsA("Tool") and x:HasTag("Pet") then table.insert(t, tostring(x:GetAttribute("PetKey"))) end
		end
	end
	table.sort(t)
	return table.concat(t, ",")
end

local function eb()
	local h, pt = hr(), gp()
	local b = pt and pt:FindFirstChild("Baseplate")
	local mg = lp.PlayerGui:FindFirstChild("Main")
	local tk = mg and mg:FindFirstChild("PetsTracker")
	local pb = tk and tk:FindFirstChild("PlaceBest")
	if not firesignal then return nil, "Equip Failed: No Firesignal" end
	if not h or not b then return nil, "Equip Failed: No Plot" end
	if not pb then return nil, "Equip Failed: No Place Best Button" end
	tp(h, b.Position + Vector3.new(0, b.Size.Y / 2, 0))
	task.wait(0.3)
	local function sg()
		local t = {ks()}
		local f = pt:FindFirstChild("Pets")
		for _, v in f and f:GetChildren() or {} do table.insert(t, v.Name .. tostring(v:GetAttribute("PetKey"))) end
		for _, x in lp.Character and lp.Character:GetChildren() or {} do
			if x:IsA("Tool") then table.insert(t, "h" .. x.Name) end
		end
		table.sort(t)
		return table.concat(t, ",")
	end
	firesignal(pb.Activated)
	local t0, q, lc = os.clock(), sg(), os.clock()
	while os.clock() - t0 < 15 do
		task.wait(0.1)
		local v = sg()
		if v ~= q then q, lc = v, os.clock() end
		if os.clock() - lc >= 1 and os.clock() - t0 >= 0.6 then return true end
	end
	return nil, "Equip Failed: Place Best Timeout"
end

local cb = 0
local function ic()
	if not ix or os.clock() < cb then return end
	local sv = lp:FindFirstChild("SavedData")
	local op, sg = sv and sv:FindFirstChild("OwnedPets"), sv and sv:FindFirstChild("IndexRewardStage")
	if not op or not sg then return end
	local g = ix.st[(tonumber(sg.Value) or 0) + 1]
	if not g then return end
	local n = 0
	for _, x in ix.pn do
		if string.find(op.Value, x .. ",", 1, true) then n += 1 end
	end
	if n < g then return end
	local v0 = sg.Value
	ci:FireServer()
	local dl = os.clock() + 3
	repeat task.wait(0.1) until sg.Value ~= v0 or os.clock() > dl
	if sg.Value == v0 then cb = os.clock() + 30 end
end

local function ap()
	if ks() == le then return end
	lk(eb)
	le = ks()
end

local L = (function()
local ps, uis, tws, gs, hs, txs = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("GuiService"), game:GetService("HttpService"), game:GetService("TextService")
local ge = getgenv and getgenv() or _G
local c = {bg = Color3.fromRGB(37, 37, 34), rw = Color3.fromRGB(47, 47, 43), hv = Color3.fromRGB(62, 62, 57), sk = Color3.fromRGB(72, 72, 66), tx = Color3.fromRGB(244, 240, 232), dm = Color3.fromRGB(150, 147, 140), er = Color3.fromRGB(214, 106, 94)}
local fn, fb, ww, wh = Enum.Font.GothamMedium, Enum.Font.GothamBold, 440, 300
local mb, tc, mm = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement
local L, tf = {Flags = {}}, nil

local function mk(k, p, ch)
	local o = Instance.new(k)
	for i, v in p do
		if i ~= "Parent" then o[i] = v end
	end
	for _, x in ch or {} do x.Parent = o end
	o.Parent = p.Parent
	return o
end

local function rc(r)
	return mk("UICorner", {CornerRadius = UDim.new(0, r or 6)})
end

local function pd(l, r, t, b)
	return mk("UIPadding", {PaddingLeft = UDim.new(0, l), PaddingRight = UDim.new(0, r or l), PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0)})
end

local function fire(f, ...)
	if type(f) ~= "function" then return end
	task.spawn(function(...)
		local ok, e = pcall(f, ...)
		if ok then return end
		warn(`Callback Failed: {e}`)
		if tf then tf(tostring(e)) end
	end, ...)
end

local function ck(q, k)
	if type(q) ~= "table" or type(q.Name) ~= "string" then error(`{k} Failed: No Name`) end
	if q.Flag ~= nil and type(q.Flag) ~= "string" then error(`{k} Failed: Bad Flag`) end
end

local function dg(h, cs, st, mv, en)
	local a, p0
	local function me(i)
		return i == a or (a.UserInputType == mb and i.UserInputType == mb)
	end

	table.insert(cs, h.InputBegan:Connect(function(i)
		if a or (i.UserInputType ~= mb and i.UserInputType ~= tc) then return end
		a, p0 = i, i.Position
		st(i)
	end))
	table.insert(cs, uis.InputChanged:Connect(function(i)
		if a and (i == a or (a.UserInputType == mb and i.UserInputType == mm)) then mv(Vector2.new(i.Position.X - p0.X, i.Position.Y - p0.Y)) end
	end))
	table.insert(cs, uis.InputEnded:Connect(function(i)
		if not a or not me(i) then return end
		local d = Vector2.new(i.Position.X - p0.X, i.Position.Y - p0.Y)
		a = nil
		if en then en(d) end
	end))
end

function L:Window(o)
	o = o or {}
	if type(o) ~= "table" then error("Window Failed: Bad Options") end
	if o.Key ~= nil and o.Key ~= false and typeof(o.Key) ~= "EnumItem" then error("Window Failed: Bad Key") end
	if o.Config ~= nil and (type(o.Config) ~= "string" or (o.Config .. "/"):gsub("[%w _%-]+/", "") ~= "") then error("Window Failed: Bad Config") end
	if ge.__AvW then pcall(ge.__AvW.Destroy, ge.__AvW) end

	local W, cs, tb, cur, lk, ct = {}, {}, {}, nil, false, -1
	local key = o.Key == nil and Enum.KeyCode.LeftControl or o.Key
	local sg = mk("ScreenGui", {Name = hs:GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999})
	if not pcall(function() sg.Parent = gethui and gethui() or game:GetService("CoreGui") end) then sg.Parent = ps.LocalPlayer:WaitForChild("PlayerGui") end

	local w = mk("Frame", {Parent = sg, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(ww, wh), BackgroundColor3 = c.bg, BorderSizePixel = 0, Active = true, ClipsDescendants = true}, {rc(8), mk("UIStroke", {Color = c.sk, Thickness = 1})})
	local us = mk("UIScale", {Parent = w})
	local tt = mk("Frame", {Parent = w, Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Active = true})
	mk("TextLabel", {Parent = tt, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = fb, TextSize = 14, TextColor3 = c.tx, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = tostring(o.Title or "Avenoric")}, {pd(12, 74)})
	local xb = mk("TextButton", {Parent = w, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -6, 0, 18), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = c.er, BackgroundTransparency = 1, AutoButtonColor = false, Text = ""}, {rc(), mk("TextLabel", {Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"), TextSize = 16, TextColor3 = c.dm, Text = "x"})})
	local nb = mk("TextButton", {Parent = w, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -36, 0, 18), Size = UDim2.fromOffset(28, 28), BackgroundTransparency = 1, AutoButtonColor = false, Text = ""}, {rc(), mk("TextLabel", {Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"), TextSize = 16, TextColor3 = c.dm, Text = "minus"})})
	mk("Frame", {Parent = w, Position = UDim2.fromOffset(12, 36), Size = UDim2.new(1, -24, 0, 1), BackgroundColor3 = c.sk, BorderSizePixel = 0})
	local bar = mk("ScrollingFrame", {Parent = w, Visible = false, Position = UDim2.fromOffset(12, 44), Size = UDim2.new(0, 110, 1, -56), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, {mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})})
	local fa = mk("Frame", {Parent = w, Position = UDim2.fromOffset(12, 44), Size = UDim2.fromOffset(110, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0, 1)})})
	local fz = mk("Frame", {Parent = w, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.fromOffset(110, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)})})
	local bd = mk("Frame", {Parent = w, Position = UDim2.fromOffset(0, 44), Size = UDim2.new(1, 0, 1, -56), BackgroundTransparency = 1})
	local pa = mk("Frame", {Parent = w, Position = UDim2.fromOffset(12, 44), Size = UDim2.new(1, -24, 0, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0, 1)})})
	local pz = mk("Frame", {Parent = w, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.new(1, -24, 0, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)})})
	local fl = mk("TextButton", {Parent = sg, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(44, 44), BackgroundColor3 = Color3.fromRGB(18, 18, 21), BackgroundTransparency = 0.08, AutoButtonColor = false, Text = ""}, {rc(22), type(o.Icon) == "string" and mk("ImageLabel", {Position = UDim2.fromOffset(4, 4), Size = UDim2.fromOffset(36, 36), BackgroundTransparency = 1, Image = o.Icon}) or mk("TextLabel", {Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(24, 24), BackgroundTransparency = 1, FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Bold), TextSize = 24, TextColor3 = Color3.fromRGB(247, 247, 248), Text = "studio"})})
	local gz = mk("TextButton", {Parent = w, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(14, 14), BackgroundTransparency = 1, AutoButtonColor = false, Text = "", ZIndex = 5})
	for _, q in {{10, 10}, {6, 10}, {10, 6}, {2, 10}, {6, 6}, {10, 2}} do mk("Frame", {Parent = gz, Position = UDim2.fromOffset(q[1], q[2]), Size = UDim2.fromOffset(2, 2), BackgroundColor3 = c.dm, BorderSizePixel = 0, ZIndex = 5}) end
	local tq = mk("Frame", {Parent = sg, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -12, 1, -12), Size = UDim2.new(0, 240, 1, -80), BackgroundTransparency = 1}, {mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8)})})
	local qs, act, tn = mk("UIScale", {Parent = tq}), {}, 0

	local function vs()
		local v = sg.AbsoluteSize
		if v.X < 1 then v = workspace.CurrentCamera.ViewportSize end
		return v, gs:GetGuiInset().Y
	end

	local function cl(p, z)
		local v, t = vs()
		local hx, hy = z.X / 2, z.Y / 2
		return Vector2.new(math.clamp(p.X, hx, math.max(hx, v.X - hx)), math.clamp(p.Y, t + hy, math.max(t + hy, v.Y - hy)))
	end

	local v0, t0 = vs()
	local wp, zm, lg, lq = Vector2.new(v0.X / 2, (v0.Y + t0) / 2), nil, nil, false
	local function put()
		wp = cl(wp, Vector2.new(ww, wh) * us.Scale)
		if lg then
			local v = vs()
			lg = Vector2.new(math.clamp(lg.X, 22, math.max(22, v.X - 22)), math.clamp(lg.Y, 22, math.max(22, v.Y - 22)))
		end
		w.Position, fl.Position = UDim2.fromOffset(wp.X, wp.Y), lg and UDim2.fromOffset(lg.X, lg.Y) or UDim2.fromOffset(38, select(2, vs()) + 30)
	end

	local function zs()
		local v, t = vs()
		return zm or math.clamp(math.min((v.X - 24) / ww, (v.Y - t - 24) / wh, 1), 0.5, 1)
	end

	local function fit()
		us.Scale = zs()
		qs.Scale = us.Scale
		put()
	end

	local function toast(q)
		tn += 1
		local o = #act >= 4 and table.remove(act, 1)
		if o then o:Destroy() end
		local h = mk("Frame", {Parent = tq, LayoutOrder = tn, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1})
		local k = mk("Frame", {Parent = h, Position = UDim2.fromOffset(260, 0), Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = c.bg, BorderSizePixel = 0}, {rc(8), mk("UIStroke", {Color = c.sk, Thickness = 1})})
		mk("Frame", {Parent = k, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 6, 0.5, 0), Size = UDim2.new(0, 3, 1, -18), BackgroundColor3 = q.Err and c.er or c.tx, BorderSizePixel = 0}, {rc(2)})
		local x = mk("Frame", {Parent = k, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, {pd(18, 12, 10), mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 3)})})
		mk("TextLabel", {Parent = x, LayoutOrder = 1, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Font = fb, TextSize = 13, TextColor3 = c.tx, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = q.Title})
		if q.Text ~= "" then mk("TextLabel", {Parent = x, LayoutOrder = 2, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Font = fn, TextSize = 12, TextColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = q.Text}) end
		table.insert(act, h)
		tws:Create(k, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Position = UDim2.new()}):Play()
		task.delay(q.Time, function()
			local i = table.find(act, h)
			if not i then return end
			table.remove(act, i)
			local tw = tws:Create(k, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.fromOffset(260, 0)})
			tw:Play()
			tw.Completed:Wait()
			h:Destroy()
		end)
	end

	local function ef(e)
		toast({Title = "Callback Failed", Text = e, Time = 6, Err = true})
	end

	local cp, dt, pn = o.Config and `Avenoric/Configs/{o.Config}.json`, {}, false
	if cp then
		local ok, r = pcall(function() return isfile(cp) and hs:JSONDecode(readfile(cp)) or {} end)
		if ok and type(r) == "table" then
			dt = r
		else
			pcall(function() writefile(`{cp}.bad`, readfile(cp)) end)
			toast({Title = "Config Load Failed", Text = "Invalid Json", Time = 6, Err = true})
		end
	end

	local function wr()
		if not pn then return end
		pn = false
		local ok, e = pcall(function()
			if not isfolder("Avenoric") then makefolder("Avenoric") end
			local fp = "Avenoric/Configs"
			if not isfolder(fp) then makefolder(fp) end
			for x in o.Config:gmatch("([^/]+)/") do
				fp ..= `/{x}`
				if not isfolder(fp) then makefolder(fp) end
			end
			writefile(cp, hs:JSONEncode(dt))
		end)
		if not ok then toast({Title = "Config Save Failed", Text = tostring(e), Time = 6, Err = true}) end
	end

	local function sf(f, v, e)
		if f == nil then return end
		L.Flags[f] = v
		if not cp then return end
		if e == nil then dt[f] = v else dt[f] = e end
		if pn then return end
		pn = true
		task.delay(0.5, wr)
	end

	local function lv(f)
		if f == nil then return nil end
		return dt[f]
	end
	local zv = tonumber(lv("_z"))
	zm = zv and math.clamp(zv, 0.5, 10) or nil
	local lh = lv("_f")
	if type(lh) == "table" and tonumber(lh[1]) and tonumber(lh[2]) then lg = Vector2.new(tonumber(lh[1]), tonumber(lh[2])) end

	local function tg()
		w.Visible = not w.Visible
	end

	local function ed()
		fa.Visible, fz.Visible = false, false
	end

	fit()
	table.insert(cs, sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		local v, t = vs()
		wp = Vector2.new(v.X / 2, (v.Y + t) / 2)
		fit()
	end))
	for _, p in {"CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize"} do table.insert(cs, bar:GetPropertyChangedSignal(p):Connect(ed)) end

	local w0
	dg(tt, cs, function() w0 = wp end, function(d)
		wp = w0 + d
		put()
	end)
	local z0, s0
	dg(gz, cs, function()
		z0, s0 = us.Scale, Vector2.new(ww, wh) * us.Scale
	end, function(d)
		zm = math.clamp(z0 * (1 + (d.X / s0.X + d.Y / s0.Y) / 2), 0.5, 10)
		us.Scale = zs()
		qs.Scale = us.Scale
		put()
	end, function() sf("_z", zm) end)
	local f1
	dg(fl, cs, function()
		f1, lq = Vector2.new(fl.Position.X.Offset, fl.Position.Y.Offset), false
	end, function(d)
		if not lq and d.Magnitude < 5 then return end
		lq, lg = true, f1 + d
		put()
	end, function() if lq then sf("_f", {math.floor(lg.X), math.floor(lg.Y)}) end end)
	table.insert(cs, fl.Activated:Connect(function() if not lq then tg() end end))
	table.insert(cs, nb.Activated:Connect(function() w.Visible = false end))
	local xa, xn = false, 0
	local function xs(a)
		xa = a
		xb.BackgroundTransparency, xb.TextLabel.TextColor3 = a and 0 or 1, a and Color3.new(1, 1, 1) or c.dm
	end

	table.insert(cs, xb.Activated:Connect(function()
		if xa then
			(W :: any):Destroy()
			return
		end
		xn += 1
		local n = xn
		xs(true)
		task.delay(3, function()
			if xa and xn == n then xs(false) end
		end)
	end))
	table.insert(cs, uis.InputBegan:Connect(function(i)
		if key and i.KeyCode == key and not lk and os.clock() - ct > 0.03 and not uis:GetFocusedTextBox() then tg() end
	end))

	local function pe()
		local p = cur and cur.pg
		local y = p and p.CanvasPosition.Y or 0
		pa.Visible, pz.Visible = y > 1, p ~= nil and y < p.AbsoluteCanvasSize.Y - p.AbsoluteWindowSize.Y - 1
	end

	local function sel(T)
		cur = T
		pe()
		for _, x in tb do
			local on = x == T
			x.pg.Visible = on
			tws:Create(x.bt, TweenInfo.new(0.15), {BackgroundTransparency = on and 0 or 1, TextColor3 = on and c.tx or c.dm}):Play()
			tws:Create(x.ac, TweenInfo.new(0.15), {BackgroundTransparency = on and 0 or 1}):Play()
		end
	end

	function W:Tab(q)
		if type(q) ~= "table" or type(q.Name) ~= "string" then error("Tab Failed: No Name") end
		local T, n = {}, 0
		T.bt = mk("TextButton", {Parent = bar, LayoutOrder = #tb + 1, Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = c.rw, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false, Font = fn, TextSize = 13, TextColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = q.Name}, {rc(), pd(12)})
		T.ac = mk("Frame", {Parent = T.bt, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, -12, 0.5, 0), Size = UDim2.fromOffset(3, 16), BackgroundColor3 = c.tx, BackgroundTransparency = 1, BorderSizePixel = 0}, {rc(2)})
		T.pg = mk("ScrollingFrame", {Parent = bd, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = c.sk, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false}, {pd(12, 12, 0, 0), mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})})
		for _, p in {"CanvasPosition", "AbsoluteCanvasSize", "AbsoluteWindowSize"} do
			table.insert(cs, T.pg:GetPropertyChangedSignal(p):Connect(function()
				if cur == T then pe() end
			end))
		end
		table.insert(tb, T)
		table.insert(cs, T.bt.Activated:Connect(function() sel(T) end))
		if not cur then sel(T) end

		local function od()
			n += 1
			return n
		end

		local function row(k, h)
			return mk(k, {Parent = T.pg, LayoutOrder = od(), Size = UDim2.new(1, 0, 0, h or 34), BackgroundColor3 = c.rw, BorderSizePixel = 0}, {rc()})
		end

		local function lb(p, s)
			return mk("TextLabel", {Parent = p, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = fn, TextSize = 13, TextColor3 = c.tx, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = s}, {pd(10)})
		end

		function T:Section(q)
			if type(q) ~= "table" or type(q.Name) ~= "string" then error("Section Failed: No Name") end
			local x = mk("TextLabel", {Parent = T.pg, LayoutOrder = od(), Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Font = fb, TextSize = 12, TextColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom, Text = q.Name})
			return {Set = function(_, s) x.Text = tostring(s) end, Get = function() return x.Text end}
		end

		function T:Label(q)
			if type(q) ~= "table" or q.Text == nil then error("Label Failed: No Text") end
			local r = row("Frame")
			r.AutomaticSize = Enum.AutomaticSize.Y
			local x = mk("TextLabel", {Parent = r, Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Font = fn, TextSize = 13, TextColor3 = c.tx, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Text = tostring(q.Text)}, {pd(10, 10, 9)})
			return {Set = function(_, s) x.Text = tostring(s) end, Get = function() return x.Text end}
		end

		function T:Button(q)
			if type(q) ~= "table" or type(q.Name) ~= "string" then error("Button Failed: No Name") end
			local r = row("TextButton")
			r.AutoButtonColor, r.Text = false, ""
			local x = lb(r, q.Name)
			table.insert(cs, r.Activated:Connect(function()
				r.BackgroundColor3 = c.hv
				tws:Create(r, TweenInfo.new(0.25), {BackgroundColor3 = c.rw}):Play()
				fire(q.Callback)
			end))
			return {Set = function(_, s) x.Text = tostring(s) end, Get = function() return x.Text end}
		end

		function T:Toggle(q)
			ck(q, "Toggle")
			local r, v = row("TextButton"), nil
			r.AutoButtonColor, r.Text = false, ""
			lb(r, q.Name).Size = UDim2.new(1, -56, 1, 0)
			local k = mk("Frame", {Parent = r, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(36, 20), BackgroundColor3 = c.sk, BorderSizePixel = 0}, {rc(10)})
			local d = mk("Frame", {Parent = k, AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 3, 0.5, 0), Size = UDim2.fromOffset(14, 14), BackgroundColor3 = c.tx, BorderSizePixel = 0}, {rc(7)})
			local function set(x, cb)
				x = x == true
				if x == v then return end
				v = x
				sf(q.Flag, v)
				tws:Create(k, TweenInfo.new(0.15), {BackgroundColor3 = v and Color3.fromRGB(96, 165, 110) or c.sk}):Play()
				tws:Create(d, TweenInfo.new(0.15), {Position = UDim2.new(0, v and 19 or 3, 0.5, 0), BackgroundColor3 = c.tx}):Play()
				if cb then fire(q.Callback, v) end
			end

			local sv = lv(q.Flag)
			set(q.Default)
			if type(sv) == "boolean" then
				set(sv)
				task.defer(fire, q.Callback, v)
			end
			table.insert(cs, r.Activated:Connect(function() set(not v, true) end))
			return {Set = function(_, x) set(x, true) end, Get = function() return v end}
		end

		function T:Slider(q)
			ck(q, "Slider")
			local mn, mx, st, v = q.Min, q.Max, q.Step or 1, nil
			if type(mn) ~= "number" or type(mx) ~= "number" or not (mx > mn) then error("Slider Failed: Bad Range") end
			if type(st) ~= "number" or not (st > 0) then error("Slider Failed: Bad Step") end
			local fm = `%.{#(tostring(st):match("%.(%d+)$") or "")}f`
			local r = row("Frame", 44)
			lb(r, q.Name).Size = UDim2.new(1, -70, 0, 28)
			local vl = lb(r, "")
			vl.AnchorPoint, vl.Position, vl.Size, vl.TextXAlignment = Vector2.new(1, 0), UDim2.fromScale(1, 0), UDim2.fromOffset(80, 28), Enum.TextXAlignment.Right
			local tr = mk("Frame", {Parent = r, Position = UDim2.fromOffset(10, 30), Size = UDim2.new(1, -20, 0, 4), BackgroundColor3 = c.sk, BorderSizePixel = 0}, {rc(2)})
			local fi = mk("Frame", {Parent = tr, Size = UDim2.fromScale(0, 1), BackgroundColor3 = c.tx, BorderSizePixel = 0}, {rc(2)})
			local kn = mk("Frame", {Parent = tr, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = c.tx, BorderSizePixel = 0}, {rc(6)})
			local ht = mk("Frame", {Parent = r, Position = UDim2.fromOffset(0, 20), Size = UDim2.new(1, 0, 1, -20), BackgroundTransparency = 1, Active = true})
			local function set(x, cb)
				x = tonumber(fm:format(math.clamp(mn + math.floor((x - mn) / st + 0.5) * st, mn, mx)))
				if x == v then return end
				v = x
				sf(q.Flag, v)
				local a = (v - mn) / (mx - mn)
				fi.Size, kn.Position, vl.Text = UDim2.fromScale(a, 1), UDim2.fromScale(a, 0.5), fm:format(v)
				if cb then fire(q.Callback, v) end
			end

			local function at(px)
				set(mn + math.clamp((px - tr.AbsolutePosition.X) / math.max(tr.AbsoluteSize.X, 1), 0, 1) * (mx - mn), true)
			end

			local sv = lv(q.Flag)
			set(type(q.Default) == "number" and q.Default == q.Default and q.Default or mn)
			if type(sv) == "number" and sv == sv then
				set(sv)
				task.defer(fire, q.Callback, v)
			end
			local x0
			dg(ht, cs, function(i)
				x0, T.pg.ScrollingEnabled = i.Position.X, false
				at(x0)
			end, function(d) at(x0 + d.X) end, function() T.pg.ScrollingEnabled = true end)
			return {Set = function(_, x)
				if type(x) ~= "number" or x ~= x then error("Slider Set Failed: Not A Number") end
				set(x, true)
			end, Get = function() return v end}
		end

		function T:Dropdown(q)
			ck(q, "Dropdown")
			local mu, its, v, on, rd = q.Multi == true, {}, nil, false, false
			local function po(o, k)
				if type(o) ~= "table" then error(`{k} Failed: Bad Options`) end
				local t = {}
				for _, s in o do
					if type(s) ~= "string" then error(`{k} Failed: Bad Options`) end
					if not table.find(t, s) then table.insert(t, s) end
				end
				return t
			end

			local op = po(q.Options or {}, "Dropdown")
			local r = row("Frame")
			r.ClipsDescendants = true
			local hd = mk("TextButton", {Parent = r, Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, AutoButtonColor = false, Text = ""})
			lb(hd, q.Name).Size = UDim2.new(1, -140, 1, 0)
			local vl = lb(hd, "")
			vl.AnchorPoint, vl.Position, vl.Size, vl.TextXAlignment, vl.TextColor3 = Vector2.new(1, 0), UDim2.new(1, -18, 0, 0), UDim2.new(0, 130, 1, 0), Enum.TextXAlignment.Right, c.dm
			local cv = mk("Frame", {Parent = hd, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(12, 6), BackgroundTransparency = 1})
			local b1 = mk("Frame", {Parent = cv, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(8, 2), Rotation = 45, BackgroundColor3 = c.dm, BorderSizePixel = 0})
			local b2 = mk("Frame", {Parent = cv, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 3), Size = UDim2.fromOffset(8, 2), Rotation = -45, BackgroundColor3 = c.dm, BorderSizePixel = 0})
			local ls = mk("ScrollingFrame", {Parent = r, Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = c.sk, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, {pd(4, 4, 0, 4), mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder})})

			local function has(x)
				return mu and table.find(v, x) ~= nil or v == x
			end

			local function draw()
				vl.Text = mu and (#v > 0 and table.concat(v, ", ") or "None") or v or "None"
				for x, b in its do
					local s = has(x)
					b.BackgroundTransparency, b.TextColor3 = s and 0 or 1, s and c.tx or c.dm
				end
			end

			local function lay(a)
				local k = on and math.min(#op, 5) or 0
				local h = k > 0 and k * 28 + 4 or 0
				ls.Size, b1.Rotation, b2.Rotation = UDim2.new(1, 0, 0, h), on and -45 or 45, on and 45 or -45
				tws:Create(r, TweenInfo.new(a and 0.15 or 0), {Size = UDim2.new(1, 0, 0, 34 + h)}):Play()
			end

			local function nv(x)
				if not mu then return table.find(op, x) and x or nil end
				local o = {}
				if type(x) == "table" then
					for _, s in op do
						if table.find(x, s) then table.insert(o, s) end
					end
				end
				return o
			end

			local function same(a, b)
				if not mu then return a == b end
				if #a ~= #b then return false end
				for i = 1, #a do
					if a[i] ~= b[i] then return false end
				end
				return true
			end

			local function set(x, cb)
				x = nv(x)
				if rd and same(x, v) then return end
				rd, v = true, x
				sf(q.Flag, mu and table.clone(v) or v, mu and table.clone(v) or v or false)
				draw()
				if cb then fire(q.Callback, mu and table.clone(v) or v) end
			end

			local function build()
				for _, b in its do b:Destroy() end
				table.clear(its)
				for i, x in op do
					local b = mk("TextButton", {Parent = ls, LayoutOrder = i, Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = c.hv, BackgroundTransparency = 1, BorderSizePixel = 0, AutoButtonColor = false, Font = fn, TextSize = 13, TextColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Text = x}, {rc(4), pd(6)})
					its[x] = b
					b.Activated:Connect(function()
						if not mu then
							set(x, true)
							on = false
							lay(true)
							return
						end
						local n = table.clone(v)
						local j = table.find(n, x)
						if j then table.remove(n, j) else table.insert(n, x) end
						set(n, true)
					end)
				end
			end

			local sv = lv(q.Flag)
			build()
			set(q.Default)
			if mu and type(sv) == "table" or not mu and (sv == false or type(sv) == "string") then
				set(sv or nil)
				task.defer(fire, q.Callback, mu and table.clone(v) or v)
			end
			lay()
			table.insert(cs, hd.Activated:Connect(function()
				on = not on
				lay(true)
			end))
			return {Set = function(_, x)
				if mu and type(x) ~= "table" then error("Dropdown Set Failed: Not A Table") end
				if not mu and x ~= nil and not table.find(op, x) then error("Dropdown Set Failed: Unknown Option") end
				set(x, true)
			end, Get = function() return mu and table.clone(v) or v end, Refresh = function(_, o)
				op = po(o, "Dropdown Refresh")
				build()
				set(v, true)
				draw()
				lay(true)
			end}
		end

		function T:TextBox(q)
			ck(q, "TextBox")
			local r, v = row("Frame"), nil
			lb(r, q.Name).Size = UDim2.new(1, -156, 1, 0)
			local bx = mk("Frame", {Parent = r, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(140, 24), BackgroundColor3 = c.bg, BorderSizePixel = 0}, {rc(4)})
			local cl = mk("Frame", {Parent = bx, Position = UDim2.fromOffset(8, 0), Size = UDim2.new(1, -16, 1, 0), BackgroundTransparency = 1, ClipsDescendants = true})
			local b = mk("TextBox", {Parent = cl, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ClearTextOnFocus = false, Font = fn, TextSize = 13, TextColor3 = c.tx, PlaceholderColor3 = c.dm, PlaceholderText = tostring(q.Placeholder or ""), TextTruncate = Enum.TextTruncate.AtEnd, Text = ""})
			local function al()
				local f = b:IsFocused()
				b.TextTruncate = f and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd
				b.TextXAlignment = f and txs:GetTextSize(b.Text, 13, fn, Vector2.new(1e4, 24)).X > 124 and Enum.TextXAlignment.Right or Enum.TextXAlignment.Center
			end

			local function set(s, cb)
				s = tostring(s or "")
				b.Text = s
				if s == v then return end
				v = s
				sf(q.Flag, v)
				if cb then fire(q.Callback, v) end
			end

			local sv = lv(q.Flag)
			set(q.Default)
			if type(sv) == "string" then
				set(sv)
				task.defer(fire, q.Callback, v)
			end
			al()
			table.insert(cs, b.Focused:Connect(al))
			table.insert(cs, b:GetPropertyChangedSignal("Text"):Connect(al))
			table.insert(cs, b.FocusLost:Connect(function()
				al()
				set(b.Text, true)
			end))
			return {Set = function(_, s) set(s, true) end, Get = function() return v end}
		end

		function T:Keybind(q)
			ck(q, "Keybind")
			local function ok(k)
				return k == nil or (typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode)
			end

			if not ok(q.Default) then error("Keybind Failed: Bad Key") end
			local r, v, wt = row("Frame"), nil, false
			r.Visible = uis.KeyboardEnabled or not uis.TouchEnabled
			lb(r, q.Name).Size = UDim2.new(1, -112, 1, 0)
			local b = mk("TextButton", {Parent = r, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(96, 24), BackgroundColor3 = c.bg, BorderSizePixel = 0, AutoButtonColor = false, Font = fn, TextSize = 12, TextColor3 = c.tx, TextTruncate = Enum.TextTruncate.AtEnd, Text = "None"}, {rc(4), pd(6)})
			local function set(k)
				v = k
				sf(q.Flag, v, v and v.Name or false)
				b.Text = v and v.Name or "None"
			end

			local sv = lv(q.Flag)
			set(q.Default)
			if sv == false then
				set(nil)
			elseif type(sv) == "string" then
				local g, k = pcall(function() return Enum.KeyCode[sv] end)
				if g and k then set(k) end
			end
			table.insert(cs, b.Activated:Connect(function()
				wt = not wt
				lk = wt
				b.Text = wt and "..." or (v and v.Name or "None")
			end))
			table.insert(cs, uis.InputBegan:Connect(function(i, gp)
				if gp or i.UserInputType ~= Enum.UserInputType.Keyboard or i.KeyCode == Enum.KeyCode.None then return end
				if wt then
					if i.KeyCode == Enum.KeyCode.Escape then return end
					wt, lk, ct = false, false, os.clock()
					set(i.KeyCode ~= Enum.KeyCode.Backspace and i.KeyCode or nil)
					return
				end
				if not lk and os.clock() - ct > 0.03 and v and i.KeyCode == v then fire(q.Callback) end
			end))
			return {Set = function(_, k)
				if not ok(k) then error("Keybind Set Failed: Bad Key") end
				set(k)
			end, Get = function() return v end}
		end

		function T:Grid(q)
			if type(q) ~= "table" or type(q.Items) ~= "table" then error("Grid Failed: Bad Items") end
			local f, its = mk("Frame", {Parent = T.pg, LayoutOrder = od(), Size = UDim2.fromScale(1, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1}, {pd(0, 0, 2), mk("UIGridLayout", {CellSize = UDim2.fromOffset(64, 72), CellPadding = UDim2.fromOffset(5, 5), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder})}), {}
			for i, x in q.Items do
				if type(x) ~= "table" or type(x.Id) ~= "string" then error("Grid Failed: Bad Items") end
				local b = mk("TextButton", {Parent = f, LayoutOrder = i, BackgroundColor3 = c.rw, BorderSizePixel = 0, AutoButtonColor = false, Text = ""}, {rc()})
				local s = mk("UIStroke", {Parent = b, Color = c.sk, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
				if typeof(x.Gradient) == "Instance" and x.Gradient:IsA("UIGradient") then
					s.Color = Color3.new(1, 1, 1)
					x.Gradient:Clone().Parent = s
				end
				local im = mk("ImageLabel", {Parent = b, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 5), Size = UDim2.fromOffset(44, 44), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, Image = tostring(x.Image or "")})
				local nl = mk("TextLabel", {Parent = b, Position = UDim2.fromOffset(3, 51), Size = UDim2.new(1, -6, 0, 14), BackgroundTransparency = 1, Font = fn, TextSize = 11, TextColor3 = c.tx, TextTruncate = Enum.TextTruncate.AtEnd, Text = tostring(x.Name or x.Id)})
				table.insert(cs, b.Activated:Connect(function()
					b.BackgroundColor3 = c.hv
					tws:Create(b, TweenInfo.new(0.25), {BackgroundColor3 = c.rw}):Play()
					fire(q.Callback, x.Id)
				end))
				its[x.Id] = {b = b, im = im, nl = nl}
			end
			return {Set = function(_, id, on, vs)
				local x = its[id]
				if not x then error("Grid Set Failed: Unknown Item") end
				x.b.Visible = vs ~= false
				x.im.ImageTransparency, x.nl.TextColor3 = on == false and 0.65 or 0, on == false and c.dm or c.tx
			end}
		end

		return T
	end

	function W:Notify(q)
		if type(q) ~= "table" or (q.Title == nil and q.Text == nil) then error("Notify Failed: No Text") end
		if q.Time ~= nil and (type(q.Time) ~= "number" or not (q.Time > 0)) then error("Notify Failed: Bad Time") end
		toast({Title = tostring(q.Title or "Avenoric"), Text = q.Text == nil and "" or tostring(q.Text), Time = q.Time or 4})
	end

	function W:Destroy()
		for _, x in cs do x:Disconnect() end
		table.clear(cs)
		table.clear(act)
		wr()
		sg:Destroy()
		if tf == ef then tf = nil end
		if ge.__AvW == W then ge.__AvW = nil end
	end

	tf, ge.__AvW = ef, W
	return W
end

return L
end)()

local ge = getgenv()
local gi = (function()
	local dc, p = crypt and crypt.base64decode or base64_decode, "Avenoric/Assets/NgaoLogo.png"
	if not (dc and getcustomasset and writefile) then return nil end
	local ok, r = pcall(function()
		if not isfolder("Avenoric") then makefolder("Avenoric") end
		if not isfolder("Avenoric/Assets") then makefolder("Avenoric/Assets") end
		writefile(p, dc("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"))
		return getcustomasset(p)
	end)
	return ok and type(r) == "string" and r or nil
end)()

do
	local kf, ky, ex, kl = "Avenoric/RideAPet/Key.txt", "NGAO-L6KU-E3WH", 1791122113, "https://linkfree.click/s/ngao-gaming-hubz1u17pnmuqgaym9"
	local function xp() return workspace:GetServerTimeNow() >= ex end
	local o, s = pcall(readfile, kf)
	if ge.__RapD then pcall(function() ge.__RapD:Destroy() end) end
	ge.__RapD = nil
	if xp() or not (o and type(s) == "string" and s:match("^%s*(.-)%s*$") == ky) then
		local tws = game:GetService("TweenService")
		local k = {bg = Color3.fromRGB(37, 37, 34), rw = Color3.fromRGB(47, 47, 43), sk = Color3.fromRGB(72, 72, 66), tx = Color3.fromRGB(244, 240, 232), dm = Color3.fromRGB(150, 147, 140), ib = Color3.fromRGB(28, 28, 26), gn = Color3.fromRGB(96, 165, 110), er = Color3.fromRGB(214, 106, 94)}
		local function mi(c, q, cs)
			local x = Instance.new(c)
			for a, v in q do
				if a ~= "Parent" then x[a] = v end
			end
			for _, y in cs or {} do y.Parent = x end
			x.Parent = q.Parent
			return x
		end
		local function rc(r) return mi("UICorner", {CornerRadius = UDim.new(0, r)}) end
		local function lb(q)
			q.BackgroundTransparency, q.Font, q.TextXAlignment, q.TextTruncate = 1, q.Font or Enum.Font.GothamMedium, q.TextXAlignment or Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
			return mi("TextLabel", q)
		end
		local function bn(q, c, t)
			q.BackgroundColor3, q.TextColor3, q.AutoButtonColor, q.Font, q.TextSize, q.BorderSizePixel = c, t, true, Enum.Font.GothamBold, 14, 0
			return mi("TextButton", q, {rc(8)})
		end
		local sg, ch = mi("ScreenGui", {Name = game:GetService("HttpService"):GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000}), nil
		ge.__RapD = sg
		if not pcall(function() sg.Parent = gethui() end) then sg.Parent = lp:WaitForChild("PlayerGui") end
		local fr = mi("Frame", {Parent = sg, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(320, 296), BackgroundColor3 = k.bg, BorderSizePixel = 0}, {rc(12), mi("UIStroke", {Color = k.sk, Thickness = 1})})
		local us = mi("UIScale", {Parent = fr, Scale = 0.9})
		local hx = 16
		if type(gi) == "string" then
			mi("ImageLabel", {Parent = fr, Position = UDim2.fromOffset(16, 14), Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1, Image = gi}, {rc(16)})
			hx = 56
		end
		lb({Parent = fr, Position = UDim2.fromOffset(hx, 12), Size = UDim2.new(1, -hx - 46, 0, 20), Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = k.tx, Text = "Ngao-Gaming Hub"})
		lb({Parent = fr, Position = UDim2.fromOffset(hx, 32), Size = UDim2.new(1, -hx - 46, 0, 14), TextSize = 12, TextColor3 = k.dm, Text = "Ride A Pet"})
		local xb = mi("TextButton", {Parent = fr, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 14), Size = UDim2.fromOffset(28, 28), BackgroundColor3 = k.er, BackgroundTransparency = 1, AutoButtonColor = false, Text = ""}, {rc(6), mi("TextLabel", {Position = UDim2.fromOffset(6, 6), Size = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, FontFace = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"), TextSize = 16, TextColor3 = k.dm, Text = "x"})})
		mi("Frame", {Parent = fr, Position = UDim2.fromOffset(16, 58), Size = UDim2.new(1, -32, 0, 1), BackgroundColor3 = k.sk, BorderSizePixel = 0})
		local function bd(n, y, t)
			local b = lb({Parent = fr, Position = UDim2.fromOffset(16, y), Size = UDim2.fromOffset(22, 22), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = k.tx, TextXAlignment = Enum.TextXAlignment.Center, Text = n})
			b.BackgroundTransparency, b.BackgroundColor3 = 0, k.rw
			rc(11).Parent = b
			mi("UIStroke", {Parent = b, Color = k.sk, Thickness = 1})
			lb({Parent = fr, Position = UDim2.fromOffset(46, y), Size = UDim2.new(1, -62, 0, 22), Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = k.tx, Text = t})
			return b
		end
		local b1 = bd("1", 70, "Get The Key")
		local gk = bn({Parent = fr, Position = UDim2.fromOffset(46, 98), Size = UDim2.new(1, -62, 0, 34), Text = "Get Key"}, k.tx, k.bg)
		local b2 = bd("2", 144, "Paste It Here")
		local tb = mi("TextBox", {Parent = fr, Position = UDim2.fromOffset(46, 172), Size = UDim2.new(1, -62, 0, 34), BackgroundColor3 = k.ib, BorderSizePixel = 0, ClearTextOnFocus = false, ClipsDescendants = true, Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = k.tx, PlaceholderColor3 = k.dm, PlaceholderText = "Enter Key", Text = ""}, {rc(8), mi("UIStroke", {Color = k.sk, Thickness = 1})})
		tb:GetPropertyChangedSignal("Text"):Connect(function() if #tb.Text > 32 then tb.Text = tb.Text:sub(1, 32) end end)
		local sm = bn({Parent = fr, Position = UDim2.fromOffset(46, 214), Size = UDim2.new(1, -62, 0, 34), Text = "Submit"}, k.gn, k.tx)
		local st = lb({Parent = fr, Position = UDim2.fromOffset(16, 256), Size = UDim2.new(1, -32, 0, 14), TextSize = 12, TextColor3 = k.er, TextXAlignment = Enum.TextXAlignment.Center, Text = xp() and "Key Expired, Get The New Key" or ""})
		local ft = lb({Parent = fr, Position = UDim2.fromOffset(16, 274), Size = UDim2.new(1, -32, 0, 12), TextSize = 11, TextColor3 = k.dm, TextXAlignment = Enum.TextXAlignment.Center, Text = ""})
		local function sx(t, c) st.Text, st.TextColor3 = t, c or k.er end
		local function dn(b) b.BackgroundColor3 = k.gn end
		local function sk()
			local p = fr.Position
			for _, d in {-8, 8, -5, 5, 0} do
				fr.Position = p + UDim2.fromOffset(d, 0)
				task.wait(0.04)
			end
			fr.Position = p
		end
		local function dj()
			local q = request or http_request or (syn and syn.request)
			if not q then return end
			local h = game:GetService("HttpService")
			for pt = 6463, 6472 do
				local ok, r = pcall(q, {Url = `http://127.0.0.1:{pt}/rpc?v=1`, Method = "POST", Headers = {["Content-Type"] = "application/json", Origin = "https://discord.com"}, Body = h:JSONEncode({cmd = "INVITE_BROWSER", nonce = h:GenerateGUID(false), args = {code = "fTQF5TvfEJ"}})})
				if ok and type(r) == "table" and r.StatusCode == 200 then return end
			end
		end
		local function sb()
			local t = tb.Text:match("^%s*(.-)%s*$")
			local e = t == "" and "Key Check Failed: Empty Key" or t ~= ky and "Key Check Failed: Wrong Key" or xp() and "Key Check Failed: Key Expired" or nil
			if e then
				sx(e)
				task.spawn(sk)
				return
			end
			pcall(function()
				if not isfolder("Avenoric") then makefolder("Avenoric") end
				if not isfolder("Avenoric/RideAPet") then makefolder("Avenoric/RideAPet") end
				writefile(kf, ky)
			end)
			dn(b2)
			sx("Key Accepted", k.gn)
			task.spawn(dj)
			task.wait(0.4)
			ch = ch or "k"
		end
		gk.Activated:Connect(function()
			local cf = setclipboard or toclipboard
			if kl == "" then return sx("Copy Failed: Link Not Set") end
			if not cf then return sx("Copy Failed: No Clipboard") end
			if not pcall(cf, kl) then return sx("Copy Failed: Clipboard Error") end
			dn(b1)
			sx("Link Copied, Open It In Your Browser", k.gn)
		end)
		sm.Activated:Connect(sb)
		local xa, xn = false, 0
		xb.Activated:Connect(function()
			if xa then
				ch = ch or "c"
				return
			end
			xn += 1
			local n = xn
			xa, xb.BackgroundTransparency, xb.TextLabel.TextColor3 = true, 0, Color3.new(1, 1, 1)
			task.delay(3, function()
				if xa and xn == n then xa, xb.BackgroundTransparency, xb.TextLabel.TextColor3 = false, 1, k.dm end
			end)
		end)
		tb.FocusLost:Connect(function(e) if e then sb() end end)
		task.spawn(function()
			while sg.Parent and not ch do
				local r = ex - workspace:GetServerTimeNow()
				ft.Text = r > 0 and string.format("Key Expires In %dh %02dm", r // 3600, r % 3600 // 60) or "Key Expired"
				task.wait(20)
			end
		end)
		local v = workspace.CurrentCamera.ViewportSize
		tws:Create(us, TweenInfo.new(0.25, Enum.EasingStyle.Quint), {Scale = math.clamp(math.min((v.X - 24) / 320, (v.Y - 24) / 296), 0.5, 1)}):Play()
		repeat task.wait() until ch or ge.__RapD ~= sg
		if ge.__RapD ~= sg then error("Key Gate Replaced", 0) end
		ge.__RapD = nil
		sg:Destroy()
		if ch ~= "k" then error("Key Gate Closed", 0) end
	end
end

if ge.__RapG then pcall(ge.__RapG) end
ge.__RapE = nil
local gcn = `RideAPet/{lp.Name}`
local gce = isfile and isfolder and makefolder and readfile and writefile and select(2, pcall(function()
	if isfile(`Avenoric/Configs/{gcn}.json`) or not isfile("Avenoric/Configs/RideAPet.json") then return end
	if not isfolder("Avenoric/Configs/RideAPet") then makefolder("Avenoric/Configs/RideAPet") end
	writefile(`Avenoric/Configs/{gcn}.json`, readfile("Avenoric/Configs/RideAPet.json"))
end))
local gw = L:Window({Title = "Ngao-Gaming Hub | Ride A Pet", Config = gcn, Icon = gi})
if gce then gw:Notify({Title = "Config", Text = `Config Copy Failed: {gce}`}) end
local gt = gw:Tab({Name = "Eggs"})
local ls, it = {}, {}
for n, d in ed do
	if not d.pm then table.insert(ls, n) end
end
table.sort(ls, function(a, b) return ed[a].lk < ed[b].lk end)
for _, n in ls do
	local d = ed[n]
	table.insert(it, {Id = n, Name = (n:gsub(" Egg$", "")), Image = type(d.im) == "string" and d.im or "", Gradient = rg and type(d.ra) == "string" and rg:FindFirstChild(d.ra) or nil})
end
gt:Dropdown({Name = "Select Egg", Options = ls, Default = {}, Multi = true, Flag = "se", Callback = function(v)
	local t = {}
	for _, n in v do t[n] = true end
	se = t
end})
gt:Toggle({Name = "Auto Egg", Flag = "ag", Callback = function(v) ao = v end})
gt:Toggle({Name = "Auto Luck", Flag = "al", Callback = function(v) ol, lc = v, 0 end})
local gg = gt:Grid({Items = it, Callback = rn})

if ge.__RapM then ge.__RapM:Disconnect() end
ge.__RapM = rs:WaitForChild("Remotes"):WaitForChild("Reusable"):WaitForChild("GameMessage").OnClientEvent:Connect(function(m)
	local x = type(m) == "string" and tonumber(m:match("^Max %d+/(%d+) Eggs In Plot"))
	if x then pm = x end
end)

if ge.__RapA then ge.__RapA:Disconnect() end
ge.__RapA = lp.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:CaptureController()
	vu:ClickButton2(Vector2.new())
end)

task.spawn(function()
	while ge.__AvW == gw do
		pcall(ag)
		task.wait(0.25)
	end
end)

task.spawn(function()
	while ge.__AvW == gw do
		pcall(ah)
		pcall(ap)
		pcall(ic)
		pcall(au)
		pcall(lu)
		task.wait(1)
	end
end)

local sn = 0
while ge.__AvW == gw do
	local c = ct()
	for _, n in ls do
		local rk = ed[n].rk
		local k = rk and sd:GetAttribute("ReleaseAt_" .. rk)
		gg:Set(n, (c[n] or 0) > 0, not rk or typeof(k) == "number" and k <= os.time())
	end
	if sq ~= sn then
		sn = sq
		gw:Notify({Title = "Grab Egg", Text = st})
	end
	task.wait(0.5)
end
