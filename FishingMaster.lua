if not game:IsLoaded() then game.Loaded:Wait() end

local ps = game:GetService("Players")
repeat task.wait() until ps.LocalPlayer

local lp, rv = ps.LocalPlayer, getrenv().shared
while lp:GetAttribute("IsLoaded") ~= true do lp:GetAttributeChangedSignal("IsLoaded"):Wait() end
repeat task.wait(0.1) until rv.LoadingController and rv.LoadingController:IsLoaded()

local qk = {Right = "D", Left = "A", Up = "W"}

local function pd() return rv.PlayerDataV2Controller:Fetch() end

local function zx(t, nw)
	local fp, g = `Avenoric/Configs/FishingMaster/{lp.Name}_Log.txt`, getgenv().__FmLg
	if not g then
		g = {ls = {}, dt = false}
		getgenv().__FmLg = g
		pcall(function()
			for l in (isfile(fp) and readfile(fp) or ""):gmatch("[^\n]+") do table.insert(g.ls, l) end
		end)
	end
	local m = (tostring(t):gsub("%s*\n%s*", " <- "))
	local la = g.ls[#g.ls] or ""
	local lm, n = la:match("^[^|]+| (.-) x(%d+)$")
	local ts = os.date("%Y-%m-%d %H:%M:%S")
	if (lm or la:match("^[^|]+| (.*)$")) == m then
		g.ls[#g.ls] = `{ts} | {m} x{(tonumber(n) or 1) + 1}`
	else
		table.insert(g.ls, `{ts} | {m}`)
	end
	while #g.ls > 1000 do table.remove(g.ls, 1) end
	local function wr()
		g.dt = false
		pcall(function()
			for _, x in {"Avenoric", "Avenoric/Configs", "Avenoric/Configs/FishingMaster"} do
				if not isfolder(x) then makefolder(x) end
			end
			writefile(fp, table.concat(g.ls, "\n") .. "\n")
		end)
	end
	if nw then
		wr()
		return
	end
	if g.dt then return end
	g.dt = true
	task.delay(2, wr)
end

local function sk()
	local d, o = pd(), {}
	local r = d and d.Rods and d.Rods[d.RodEquip]
	for s, id in r and r.BookSlots or {} do
		if type(id) == "string" and id ~= "" and id ~= "None" then table.insert(o, {s, id}) end
	end
	table.sort(o, function(a, b) return a[1] < b[1] end)
	return o
end

local function eq()
	local d, c = pd(), lp.Character
	local rd = d and d.RodEquip
	if type(rd) ~= "string" or rd == "" or rd == "None" then return nil, "No Rod" end
	if not c then return nil, "No Character" end
	local function hd() return c:FindFirstChild(rd) and c[rd]:IsA("Tool") end
	if hd() then return true end
	rv.HeldToolController.SetHeldSlot:Fire(1)
	local dl = os.clock() + 5
	repeat task.wait(0.1) until hd() or os.clock() > dl
	if hd() then return true end
	return nil, "Equip Timeout"
end

local function tg(h)
	local w = workspace:FindFirstChild("World")
	local il, ip = w and w:FindFirstChild("Islands"), RaycastParams.new()
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	for i = 0, 15 do
		local a = math.rad(i * 22.5)
		for _, r in {60, 50, 40, 30} do
			local p = Vector3.new(h.Position.X + math.sin(a) * r, 3, h.Position.Z + math.cos(a) * r)
			if not il or not workspace:Raycast(p + Vector3.new(0, 100, 0), Vector3.new(0, -100, 0), ip) then return p end
		end
	end
	return nil
end

local function fp(s)
	local lm, st = s.fp[1], s.fp[2]
	local el = workspace:GetServerTimeNow() - st
	local pk = (2 * math.max(0, math.ceil((el * 2.4 - 1) / 2)) + 1) / 2.4
	if pk < lm then task.wait(pk - el) end
	rv.FishingController.FishFirstPull:Fire()
end

local function rl(f, s, ks)
	local fc, mv, sq, nc = rv.FishingController, rv.RodController.Moveset, 0, 0
	while f.st == "Running" and not s.cr and not s.rr do
		local t = os.clock()
		if s.q and t >= s.q[2] then fc.FishQTEResponse:Fire(qk[s.q[1]]); s.q = nil end
		if not lp:GetAttribute("IsUsingSkill") then
			for _, x in ks do
				local c = s.cd[x[1]]
				if not c or c[1] == "Ready" or (c[1] == "Cooldown" or c[1] == "Pending") and t >= c[2] then
					mv:Fire(x[1], x[2])
					s.cd[x[1]], s.q = {"Pending", t + 1}, nil
					break
				end
			end
		end
		if t >= nc and t >= s.sw and t >= s.bs then
			sq = sq % 65535 + 1
			fc.FishReelPull:Fire(sq)
			nc = math.max(nc, t - 0.01) + 1 / 6 + 0.005
		end
		task.wait()
	end
	return nil
end

local ra = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Divine", "Huge"}

local function md(...)
	local x = game:GetService("ReplicatedStorage")
	for _, n in {...} do x = x:FindFirstChild(n) or error(`Module Missing: {n}`) end
	return require(x)
end

local function fl() return md("Shared", "Lib", "FishStorageRules").GetState(pd()).isFull end

local function ns(id, p)
	local b, bd, bx
	for _, x in game:GetService("CollectionService"):GetTagged("Interactive") do
		if x:GetAttribute("InteractiveId") == id then
			local q = x:IsA("Model") and x:GetPivot().Position or x:IsA("BasePart") and x.Position
			if q and (not bd or (q - p).Magnitude < bd) then b, bd, bx = q, (q - p).Magnitude, x end
		end
	end
	return b, bx
end

local sn = 0

local function sq(p, t)
	if sn >= 4 then return false end
	local dn = false
	sn += 1
	task.spawn(function()
		pcall(function() lp:RequestStreamAroundAsync(p, t) end)
		sn, dn = sn - 1, true
	end)
	local dl = os.clock() + t + 1
	repeat task.wait(0.1) until dn or os.clock() > dl
	return dn
end

local fz, cj, ut = {Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll}, nil, nil

local function lc()
	local c = lp.Character
	local r, h = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 and r:IsA("BasePart") then return c, r, h end
	return nil
end

local function pz(p, cf)
	p.CFrame = cf
	p.AssemblyLinearVelocity, p.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
end

local function uc(j)
	if j.ca then j.ca:Disconnect(); j.cr:Disconnect() end
	for p, v in j.cc do pcall(function() p.CanCollide = v end) end
	for e, v in j.ss do pcall(function() j.h:SetStateEnabled(e, v) end) end
	j.c, j.h, j.ca, j.cr, j.cc, j.ss, j.pl = nil, nil, nil, nil, {}, {}, {}
end

local function ac(j, c, h)
	uc(j)
	j.c, j.h, j.pd = c, h, true
	for _, e in fz do j.ss[e] = h:GetStateEnabled(e); h:SetStateEnabled(e, false) end
	j.ca = c.DescendantAdded:Connect(function() j.pd = true end)
	j.cr = c.DescendantRemoving:Connect(function() j.pd = true end)
end

local function nx(j)
	local c, _, h = lc()
	if not c then return end
	if j.s >= 1e5 and j.oc and c ~= j.oc then error("Respawn", 0) end
	if c ~= j.c then ac(j, c, h) end
	if j.pd then
		j.pd, j.pl = false, {}
		for _, d in c:GetDescendants() do
			if d:IsA("BasePart") then
				if j.cc[d] == nil then j.cc[d] = d.CanCollide end
				table.insert(j.pl, d)
			end
		end
	end
	for _, p in j.pl do if p.CanCollide then p.CanCollide = false end end
	if h.Sit or h.SeatPart then h.Sit = false end
end

local function hx(j, dt)
	local c, r, h = lc()
	if not c then
		if j.c then uc(j) end
		j.st = "Respawn"
		return
	end
	if j.s >= 1e5 and j.oc and c ~= j.oc then error("Respawn", 0) end
	if c ~= j.c then ac(j, c, h) end
	local d = j.p - r.Position
	local ar, fd = d.Magnitude <= j.s * dt, Vector3.new(d.X, 0, d.Z)
	j.lk = ar and j.fk or fd.Magnitude > 1e-3 and fd.Unit or j.lk
	j.st = ar and "Arrived" or "Moving"
	pz(r, CFrame.lookAlong(ar and j.p or r.Position + d.Unit * j.s * dt, j.lk))
end

local function cz(j, st, why)
	if j.dn then return end
	j.dn = true
	j.cs:Disconnect(); j.ch:Disconnect()
	pcall(uc, j)
	pcall(function()
		local _, r = lc()
		if r then r.AssemblyLinearVelocity, r.AssemblyAngularVelocity = Vector3.zero, Vector3.zero end
		if r and not j.nl and r.Position.Y < -10 then pz(r, CFrame.new(ut(r.Position) or Vector3.new(r.Position.X, 12, r.Position.Z)) * r.CFrame.Rotation) end
	end)
	j.st, j.why = st, why
	if cj == j then cj = nil end
end

local function mo(p, s, fk)
	if typeof(p) ~= "Vector3" or p.Magnitude ~= p.Magnitude or p.Magnitude == math.huge then return nil, "Move Failed: Bad Point" end
	if typeof(fk) == "Vector3" and not (fk.Magnitude > 1e-3) then fk = nil end
	if cj then
		cj.nl = true
		cj:Stop()
	end
	local c, r, h = lc()
	if s < 1e5 and p.Y < -10 then p = ut(p) or Vector3.new(p.X, 12, p.Z) end
	if r and s < 1e5 and r.Position.Y < -10 then
		local u = ut(r.Position)
		if u then pz(r, CFrame.new(u) * r.CFrame.Rotation) end
	end
	local j = {st = "Moving", p = p, s = s, oc = c, cc = {}, ss = {}, pl = {}, lk = r and Vector3.new(r.CFrame.LookVector.X, 0, r.CFrame.LookVector.Z).Unit or -Vector3.zAxis}
	j.fk = fk or j.lk
	function j.Stop(x) cz(x or j, "Stopped") end
	if c then ac(j, c, h) end
	local rs = game:GetService("RunService")
	j.cs = rs.Stepped:Connect(function()
		local ok, e = pcall(nx, j)
		if not ok then cz(j, "Failed", `Move Failed: {e}`) end
	end)
	j.ch = rs.Heartbeat:Connect(function(dt)
		local ok, e = pcall(hx, j, dt)
		if not ok then cz(j, "Failed", `Move Failed: {e}`) end
	end)
	cj = j
	return j
end

local ap, hv, aq

local function gf(f, p, fk)
	for _ = 1, 4 do
		local _, r = lc()
		if not r then return nil, "No Character" end
		local d = p - r.Position
		if Vector3.new(d.X, 0, d.Z).Magnitude <= 2 then return true end
		if f.st ~= "Running" then return nil end
		local j, e = mo(p, 30, fk)
		if not j then return nil, e end
		local dl = os.clock() + d.Magnitude / 30 + 5
		repeat task.wait() until j.st == "Arrived" or j.dn or f.st ~= "Running" or os.clock() > dl
		local why = j.why
		j:Stop()
		if why then return nil, why end
		if f.st ~= "Running" then return nil end
		task.wait(0.5)
	end
	return nil, "Move Timeout"
end

local go = gf

local function gd(c, p)
	local rp = RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {c}
	local r = workspace:Raycast(p + Vector3.new(0, 20, 0), Vector3.new(0, -60, 0), rp)
	return r and Vector3.new(p.X, r.Position.Y + 3, p.Z) or p
end

local function lk(sr, kp)
	local d, ct, sc, st, hl = pd(), md("Data", "Catalog"), rv.SellController, {}, {}
	for _, r in sr do st[r] = true end
	for u, x in d.Inventory.Fishes do
		local fi = ct.Fish.GetById(x.fishId)
		if x.locked ~= true and (kp[u] or not (fi and st[fi.rarity] and (not x.isHuge or st.Huge))) then
			local s, v = sc:ToggleLock(u)
			if s ~= 0 or v ~= true then return hl, `Lock Failed: {x.fishId}` end
			table.insert(hl, u)
		end
	end
	return hl, nil
end

local function zb(sr, kp)
	local d, ct, st, n = pd(), md("Data", "Catalog"), {}, 0
	for _, r in sr do st[r] = true end
	for u, x in d.Inventory.Fishes do
		local fi = ct.Fish.GetById(x.fishId)
		if x.locked ~= true and not kp[u] and fi and st[fi.rarity] and (not x.isHuge or st.Huge) then n += 1 end
	end
	return n
end

local function uk(hl)
	local d, sc = pd(), rv.SellController
	for _, u in hl do
		local x = d.Inventory.Fishes[u]
		if x then
			local s, v = sc:ToggleLock(u)
			if s == 0 and v == true then s, v = sc:ToggleLock(u) end
			if s ~= 0 or v ~= false then return nil, `Unlock Failed: {x.fishId}` end
		end
	end
	return true, nil
end

local function tr(f)
	local c = lp.Character
	local h = c and c:FindFirstChild("HumanoidRootPart")
	if not h then return nil, "No Character" end
	local o, sw = h.CFrame, rv.Swimming and rv.Swimming:IsSwimming()
	local np = ns("npc_fish_seller", o.Position)
	if not np then
		sq(o.Position, 5)
		np = ns("npc_fish_seller", o.Position)
	end
	if not np then return "Auto Fish Failed: No Fish Seller" end
	local hl, e = lk(f.sr(), f.kp())
	if e then
		local _, ue = uk(hl)
		return nil, ue or e
	end
	local hd = f.hf and f.hf() and not f.bu
	local mv, sp = hd and hv or go, hd and Vector3.new(np.X, math.max(6, np.Y - 18), np.Z) or aq(c, np, o.Position)
	local w, we, s
	for _ = 1, 3 do
		w, we = mv(f, sp, hd and Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit or Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit, math.min(sp.Y, 10))
		if hd and not w and f.st == "Running" then zx(`[Hidden] Sell Move Failed: {we or "Unknown"}`) end
		if not w or f.st ~= "Running" then break end
		task.wait(0.5)
		s = rv.SellController:SellAll()
		zx(`[Sell] SellAll Answer {tostring(s)}`)
		if s ~= 1 then break end
	end
	local uo, ue = uk(hl)
	if f.st == "Running" and not sw then mv(f, hd and f.hp and f.hi == rv.IslandRegionController:GetCurrentIslandId() and f.hp or o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit, math.min(sp.Y, 10)) end
	if sw then f.rp = true end
	if f.st ~= "Running" then return nil, nil end
	if not uo then return nil, ue end
	if not w then return nil, we or "Move Failed" end
	if s == 3 then return "Auto Fish Failed: Satchel Full" end
	if s ~= 0 then return nil, `Sell Status {s}` end
	return nil, nil
end

local iz, ix, bn, bi = {}, {}, {}, {}
for _, x in {{"Starter Island", "island_starter"}, {"Jungle Island", "island_jungle"}, {"Desert Island", "island_desert"}, {"Snow Island", "island_snow"}, {"Volcanic Island", "island_volcano"}, {"Fossil Island", "island_fossil"}} do
	table.insert(iz, x[1])
	ix[x[1]] = x[2]
end
for _, x in {{"Truck", "truck"}, {"Red Truck", "red_truck"}} do
	table.insert(bn, x[1])
	bi[x[1]] = x[2]
end

local function ic() return rv.IslandRegionController:GetCurrentIslandId() end

local function rs(id, wd)
	local c, r = lc()
	local w = workspace:FindFirstChild("World")
	local il = w and w:FindFirstChild("Islands")
	local fo = il and il:FindFirstChild(id or ic())
	if not (c and fo) then return nil end
	local ip, o, rd, ct, rr, k = RaycastParams.new(), {}, Random.new(), r.Position, 150, 150
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	if wd then
		for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
			if x:IsA("BasePart") and x:GetAttribute("islandId") == fo.Name then ct, rr, k = x.Position, x.Size.X / 2, 400 end
		end
	end
	for i = 1, k do
		if i % 50 == 0 then task.wait() end
		local a, d = rd:NextNumber(0, math.pi * 2), rd:NextNumber(10, rr)
		local h = workspace:Raycast(Vector3.new(ct.X + math.sin(a) * d, 150, ct.Z + math.cos(a) * d), Vector3.new(0, -200, 0), ip)
		if h and h.Instance:IsDescendantOf(fo) and h.Position.Y > 3.5 and h.Position.Y < 20 then
			local g = h.Position
			for i = 0, 7 do
				local b = math.rad(i * 45)
				if not workspace:Raycast(Vector3.new(g.X + math.sin(b) * 12, 103, g.Z + math.cos(b) * 12), Vector3.new(0, -100, 0), ip) and tg({Position = g}) then
					table.insert(o, g + Vector3.new(0, 3, 0))
					break
				end
			end
		end
	end
	return #o > 0 and o[rd:NextInteger(1, #o)] or nil
end

local function ul(id)
	local c, d = md("Data", "Config", "IslandConfig")[id], pd()
	return c and c.defaultUnlocked == true or d and d.UnlockedIslands and d.UnlockedIslands[id] == true or false
end

local function rg(id)
	for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if x:IsA("BasePart") and x:GetAttribute("islandId") == id then return x.Position end
	end
	return nil
end

local hs = game:GetService("HttpService")

local function vi(p)
	local id = ic()
	if id ~= "" then return id end
	for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if x:IsA("BasePart") and (x.Position - p).Magnitude < x.Size.X / 2 then return x:GetAttribute("islandId") end
	end
	return ""
end

local function uh(id)
	local c, r = lc()
	local w = workspace:FindFirstChild("World")
	local il = w and w:FindFirstChild("Islands")
	local fo = il and il:FindFirstChild(id)
	if not (c and fo) then return nil end
	local ct, rr = r.Position, 250
	for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if x:IsA("BasePart") and x:GetAttribute("islandId") == id then ct, rr = x.Position, x.Size.X / 2 end
	end
	local ip, o, rd = RaycastParams.new(), {}, Random.new()
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	for _ = 1, 400 do
		local a, d = rd:NextNumber(0, math.pi * 2), math.sqrt(rd:NextNumber()) * rr
		local h = workspace:Raycast(Vector3.new(ct.X + math.sin(a) * d, 500, ct.Z + math.cos(a) * d), Vector3.new(0, -520, 0), ip)
		if h and h.Instance:IsDescendantOf(fo) and h.Position.Y > 3.5 then table.insert(o, h.Position) end
	end
	table.sort(o, function(a, b) return a.Y > b.Y end)
	for i, g in o do
		if i % 20 == 0 then task.wait() end
		local q = Vector3.new(g.X, -35, g.Z)
		if tg({Position = q}) then return q, g.Y end
	end
	return nil
end

ut = function(p)
	local w = workspace:FindFirstChild("World")
	local il, ip = w and w:FindFirstChild("Islands"), RaycastParams.new()
	if not il then return nil end
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	local h = workspace:Raycast(Vector3.new(p.X, 500, p.Z), Vector3.new(0, -520, 0), ip)
	return h and h.Position + Vector3.new(0, 3, 0)
end

hv = function(f, p, fk, ty)
	for i = 1, 3 do
		local _, r = lc()
		if not r then return nil, "No Character" end
		local q = i == 1 and Vector3.new(r.Position.X, ty, r.Position.Z) or i == 2 and Vector3.new(p.X, ty, p.Z) or p
		local j, e = mo(q, i == 2 and 30 or 1e6, fk)
		if not j then return nil, e end
		local dl = os.clock() + (q - r.Position).Magnitude / 30 + 5
		repeat task.wait() until j.st == "Arrived" or j.dn or f.st ~= "Running" or os.clock() > dl
		if j.dn then return nil, j.why or "Move Failed" end
		if f.st ~= "Running" then return nil end
		if j.st ~= "Arrived" then return nil, "Move Timeout" end
	end
	return true
end

ap = function(c, np, p, d)
	if d == 0 then return np end
	local u = Vector3.new(p.X, np.Y, p.Z) - np
	return gd(c, np + (u.Magnitude > 0.1 and u.Unit or Vector3.xAxis) * (d or 6))
end

aq = function(c, np, p)
	local w = workspace:FindFirstChild("World")
	local il, ip = w and w:FindFirstChild("Islands"), RaycastParams.new()
	if il then
		ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
		local u = Vector3.new(p.X - np.X, 0, p.Z - np.Z)
		local a0 = u.Magnitude > 0.1 and math.atan2(u.X, u.Z) or 0
		for i = 0, 15 do
			local a = a0 + math.rad((i % 2 == 0 and 1 or -1) * math.ceil(i / 2) * 22.5)
			local q = np + Vector3.new(math.sin(a), 0, math.cos(a)) * 18
			local h = workspace:Raycast(q + Vector3.new(0, 20, 0), Vector3.new(0, -60, 0), ip)
			if h and math.abs(h.Position.Y + 3 - np.Y) <= 6 then return h.Position + Vector3.new(0, 3, 0) end
		end
	end
	return ap(c, np, p, 0)
end

local function an(f, c, np, p)
	if f.hf() then
		local sp = Vector3.new(np.X, math.max(6, np.Y - 18), np.Z)
		return hv(f, sp, nil, math.min(sp.Y, 10))
	end
	local sp = aq(c, np, p)
	return go(f, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
end

local function bv(k)
	local a = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
	local m = a and a:FindFirstChild("Cars")
	m = m and m:FindFirstChild(k)
	m = m and m:FindFirstChild("Model")
	return m and m:GetAttribute("Speed")
end

local function gb(f, k)
	local c, r = lc()
	local cf = workspace:FindFirstChild("Cars")
	if not c then return nil, "No Character" end
	if not cf then return nil, "No Cars Folder" end
	local nm = tostring(lp.UserId)
	local om = cf:FindFirstChild(nm)
	local ct = md("Data", "Catalog", "Car")
	local function pc() return ct[k] and ct[k].price or 0 end
	local function ok(x) return x and x:FindFirstChild("Main") and x:FindFirstChild("DSeat") and x:GetAttribute("Speed") == bv(k) and ((x.Main.Position - r.Position) * Vector3.new(1, 0, 1)).Magnitude < 500 end
	if ok(om) then return om end
	if pc() > (pd().Coin or 0) then k = "truck" end
	if ok(om) then return om end
	local mp, mx = ns("npc_car_merchant", r.Position)
	if not mp then return nil, "No Boat Merchant" end
	local g, e = go(f, ap(c, mp, r.Position))
	if not g then return nil, e end
	local P = md("Stardust").Packet
	P("SpawnCarEvent", P.String):Fire(`{k}/{mx:GetAttribute("IslandId")}`)
	local dl = os.clock() + 8
	repeat
		task.wait(0.2)
		local x = cf:FindFirstChild(nm)
		if x and x ~= om and x:FindFirstChild("Main") and x:FindFirstChild("DSeat") then return x end
	until os.clock() > dl or f.st ~= "Running"
	return nil, f.st == "Running" and "Boat Spawn Timeout" or nil
end

local function pq(m, v)
	for _, x in m and m:GetDescendants() or {} do
		if x:IsA("ProximityPrompt") then x.Enabled = v end
	end
end

local function sb(f, m)
	local c, r, h = lc()
	if not c then return nil, "No Character" end
	local ds = m:FindFirstChild("DSeat")
	local pp = ds and ds:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not pp then return nil, "No Boat Seat" end
	pq(m, true)
	if ds.Occupant == h then return true end
	local q = (r.Position - ds.Position) * Vector3.new(1, 0, 1)
	local g, e = go(f, Vector3.new(ds.Position.X, r.Position.Y, ds.Position.Z) + (q.Magnitude > 0.1 and q.Unit or Vector3.xAxis) * 3)
	if not g then return nil, e end
	if cj then cj:Stop() end
	local dl, lc2 = os.clock() + 20, false
	repeat
		fireproximityprompt(pp)
		local d1 = os.clock() + 1
		repeat task.wait(0.1) until ds.Occupant == h or os.clock() > d1
		if ds.Occupant ~= h and not lc2 then
			lc2 = true
			rv.FishingController.FishLootConfirm:Fire()
			rv.FishingController.FishCancel:Fire()
		end
	until ds.Occupant == h or os.clock() > dl
	if ds.Occupant ~= h then return nil, "Sit Timeout" end
	return true
end

local function dv(f, m, id, pt)
	local _, _, h = lc()
	local mn, ds = m:FindFirstChild("Main"), m:FindFirstChild("DSeat")
	local ap, ao = mn and mn:FindFirstChild("AlignPosition"), mn and mn:FindFirstChild("AlignOrientation")
	local cp = rg(id)
	if not (h and ds and ap and ao) then return nil, "Bad Boat" end
	if not cp then return nil, "No Island Region" end
	local sp, y, cc, sx = m:GetAttribute("Speed") or 30, ap.Position.Y, {}, {}
	for _, x in {m, lp.Character} do
		for _, p in x:GetDescendants() do
			if p:IsA("BasePart") then cc[p] = p.CanCollide end
			if p:IsA("Seat") or p:IsA("VehicleSeat") then table.insert(sx, p) end
		end
	end
	local w = workspace:FindFirstChild("World")
	local il, rp = w and w:FindFirstChild("Islands"), RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	local tp, to, er, cn, on, sh = Vector3.new(mn.Position.X, 0, mn.Position.Z), pt and Vector3.new(pt.X, 0, pt.Z) or Vector3.new(cp.X, 0, cp.Z), nil, nil, false, nil
	local hd, hl = (to - tp).Unit, math.max(mn.Size.X, mn.Size.Z) / 2 + 3
	cn = game:GetService("RunService").Stepped:Connect(function(_, dt)
		local ok, e = pcall(function()
			for _, x in sx do
				local c = x.Occupant and x.Occupant.Parent
				if c and c ~= lp.Character then
					for _, p in c:GetDescendants() do
						if p:IsA("BasePart") and cc[p] == nil then cc[p] = p.CanCollide end
					end
				end
			end
			for p in cc do
				if p.CanCollide then p.CanCollide = false end
			end
			local q = to - tp
			if q.Magnitude > 0.05 and not sh then
				hd = q.Unit
				local nx2 = tp + hd * math.min(q.Magnitude, sp * dt)
				local r = not pt and on and il and workspace:Raycast(Vector3.new(nx2.X, 103, nx2.Z) + hd * hl, Vector3.new(0, -100, 0), rp)
				if r then sh = r.Position else tp = nx2 end
			end
			ap.Position, ao.CFrame = Vector3.new(tp.X, y, tp.Z), CFrame.Angles(0, math.atan2(-hd.X, -hd.Z), 0)
		end)
		if not ok then er = `Boat Drive Failed: {e}`; cn:Disconnect() end
	end)
	local lb, lt, dl, dn = math.huge, os.clock(), os.clock() + (to - tp).Magnitude / sp * 1.5 + 30, false
	while f.st == "Running" and not er do
		task.wait(0.25)
		if ds.Occupant ~= h then er = "Left Boat"; break end
		on = ic() == id
		if sh then
			task.wait(0.5)
			dn = true
			break
		end
		if on and not pt then
			local mp, mx = ns("npc_car_merchant", mn.Position)
			local nq = mp and mx:GetAttribute("IslandId") == id and Vector3.new(mp.X, 0, mp.Z)
			if nq and nq ~= to then to, lb = nq, math.huge end
		end
		local d = (Vector3.new(mn.Position.X, 0, mn.Position.Z) - to).Magnitude
		if d < lb - 1 then lb, lt = d, os.clock() end
		if d < (pt and 3 or 15) or on and not pt and os.clock() - lt > 2 then dn = true; break end
		if os.clock() - lt > 4 then er = "Boat Stuck" end
		if os.clock() > dl then er = "Boat Timeout" end
	end
	if cn.Connected then cn:Disconnect() end
	for p, v in cc do pcall(function() p.CanCollide = v end) end
	local dd = os.clock() + 3
	while ds.Occupant == h and os.clock() < dd do
		h.Sit, h.Jump = false, true
		task.wait(0.2)
	end
	local _, r = lc()
	local hj = r and mo(r.Position, 30)
	task.wait(1)
	if er or not dn then
		if hj then hj:Stop() end
		return nil, er
	end
	return true, sh
end

local wb = {on = true}
local zy = {on = false, rq = false, nt = 0, ss = 0, fr = {}, wl = {}, hu = {}, nm = {}, hp = -1e9}
local zj = `Avenoric/Configs/FishingMaster/{lp.Name}_Safe.json`
pcall(function()
	local d = hs:JSONDecode(readfile(zj))
	if type(d) ~= "table" or d.JobId ~= game.JobId then return end
	for k, t in {RealPlayers = zy.wl, HubUsers = zy.hu} do
		for _, x in type(d[k]) == "table" and d[k] or {} do
			if type(x) == "table" and tonumber(x.UserId) then t[tonumber(x.UserId)], zy.nm[tonumber(x.UserId)] = x.Seen or true, x.Name end
		end
	end
end)
local function zf()
	local o = {JobId = game.JobId, RealPlayers = {}, HubUsers = {}}
	for k, t in {RealPlayers = zy.wl, HubUsers = zy.hu} do
		for u in t do
			local p = game:GetService("Players"):GetPlayerByUserId(u)
			zy.nm[u] = p and p.Name or zy.nm[u]
			table.insert(o[k], {Name = zy.nm[u] or "?", UserId = u, Seen = type(t[u]) == "string" and t[u] or nil})
		end
	end
	pcall(function()
		for _, x in {"Avenoric", "Avenoric/Configs", "Avenoric/Configs/FishingMaster"} do
			if not isfolder(x) then makefolder(x) end
		end
		writefile(zj, hs:JSONEncode(o))
	end)
end
local wz = {island_starter = Vector3.new(-37.4, 11.1, 305.9), island_jungle = Vector3.new(-1161.1, 10.8, -61.9), island_desert = Vector3.new(-44.1, 10.1, -935.4), island_snow = Vector3.new(1171.7, 9.4, -266.5), island_volcano = Vector3.new(1772.5, 9.2, 1069.3), island_fossil = Vector3.new(-543.2, 10.6, 2172.3)}

local function wm(id)
	for _, x in game:GetService("CollectionService"):GetTagged("Interactive") do
		if x:GetAttribute("InteractiveId") == "npc_car_merchant" and x:GetAttribute("IslandId") == id then return x:IsA("Model") and x:GetPivot().Position or x:IsA("BasePart") and x.Position or wz[id] end
	end
	return wz[id]
end

local wv
if getgenv and getgenv().__FmW then pcall(getgenv().__FmW.Destroy, getgenv().__FmW) end
pcall(function()
	local pg, lt = lp:WaitForChild("PlayerGui"), rv.LoadingController
	local x = pg:WaitForChild("Loading", 10):Clone()
	local fr = x.Frame
	x.Name, x.Enabled, x.ResetOnSpawn, x.DisplayOrder = hs:GenerateGUID(false), false, false, 1000
	fr.BackgroundTransparency, fr.Background.Gradient.ImageTransparency, fr.Background.Rectangle.BackgroundTransparency, fr.ImageLabel.ImageTransparency = 0, 0, 0, 0
	fr.tips.Position, fr.Bar.Position = lt._originalTipsPos, lt._originalBarPos
	fr.Bar.MasteryText.Text = "Teleporting..."
	x.Parent = pg
	wv = x
end)
if getgenv then getgenv().__FmW = wv end

local wg, wk, wp, wo = 0, nil, 0, {}
local wt = {"Tips: Cast your bobber near ripple spots to catch rare fish!", "Tips: Different rods provide unique luck and strength boosts.", "Tips: Keep an eye on the tension bar to avoid snapping your line!", "Tips: Upgrade your bait at the bait shop to attract bigger fish.", "Tips: Perfect catches grant extra experience and rare materials.", "Tips: Check the weather! Some mythical fish only appear in storms.", "Tips: Visit the fish merchant to convert your catches into Coins & Gems.", "Tips: Explore distant islands once you discover their fast travel points.", "Tips: Rare auras and rod skins can be equipped to show off your style.", "Tips: Complete daily quests for bonus rewards and crates.", "Tips: Fill out your fish Index to track every species you've caught!"}

local function wc(v, ok)
	if not wv then return end
	wg += 1
	local g, fr, ts, lt = wg, wv.Frame, game:GetService("TweenService"), rv.LoadingController
	local b, bg = fr.Bar, fr.Background
	pcall(function()
		if v then
			if wk then wk:Disconnect() end
			for _, x in wo do x:Cancel() end
			fr.BackgroundTransparency, bg.Gradient.ImageTransparency, bg.Rectangle.BackgroundTransparency, fr.ImageLabel.ImageTransparency = 0, 0, 0, 0
			b.Position, fr.tips.Position = UDim2.new(lt._originalBarPos.X.Scale, lt._originalBarPos.X.Offset, 1.25, 0), UDim2.new(lt._originalTipsPos.X.Scale, lt._originalTipsPos.X.Offset, 1.35, 0)
			b.Fill.Size, b.MasteryText.Text, wp, wv.Enabled = UDim2.fromScale(0, 1), "Loading game...", 0, true
			local cp, tp = 0, 0
			wk = game:GetService("RunService").RenderStepped:Connect(function(dt)
				tp = wp
				if tp > cp then cp = math.min(cp + math.max((tp - cp) * math.clamp(dt * 10, 0, 1), 5e-4), tp) end
				local t = os.clock()
				b.Fill.Size, b.Fish.Position, b.Fish.Rotation = UDim2.fromScale(cp, 1), UDim2.new(cp, 0, 0.5, math.sin(t * 10) * 3), math.sin(t * 12) * 10
			end)
			wo = {ts:Create(b.Shine, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {ImageTransparency = 0.25})}
			wo[1]:Play()
			ts:Create(b, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = lt._originalBarPos}):Play()
			task.delay(0.08, function() ts:Create(fr.tips, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = lt._originalTipsPos}):Play() end)
			local ti3, op = math.random(1, #wt), lt._originalTipsPos
			fr.tips.Text = wt[ti3]
			task.spawn(function()
				while true do
					task.wait(2.5)
					if wg ~= g then return end
					ti3 = ti3 % #wt + 1
					local x = ts:Create(fr.tips, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale - 0.035, op.Y.Offset)})
					x:Play()
					x.Completed:Wait()
					if wg ~= g then return end
					fr.tips.Text, fr.tips.Position = wt[ti3], UDim2.new(op.X.Scale, op.X.Offset, op.Y.Scale + 0.035, op.Y.Offset)
					ts:Create(fr.tips, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = op}):Play()
				end
			end)
			task.spawn(function()
				for k, x in {"Starting up...", "Building interface...", "Loading your data...", "Preparing gameplay..."} do
					task.wait(1)
					if wg ~= g then return end
					wp, b.MasteryText.Text = k * 0.22, x
				end
			end)
			return
		end
		if ok then wp = 1 end
		b.MasteryText.Text = ok and "Ready!" or "Teleport Failed"
		task.spawn(function()
			task.wait(ok and 0.4 or 1)
			if wg ~= g then return end
			ts:Create(fr.tips, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(lt._originalTipsPos.X.Scale, lt._originalTipsPos.X.Offset, 1.35, 0)}):Play()
			task.delay(0.06, function() ts:Create(b, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(lt._originalBarPos.X.Scale, lt._originalBarPos.X.Offset, 1.25, 0)}):Play() end)
			local q = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			ts:Create(bg.Gradient, q, {ImageTransparency = 1}):Play()
			ts:Create(bg.Rectangle, q, {BackgroundTransparency = 1}):Play()
			ts:Create(fr.ImageLabel, q, {ImageTransparency = 1}):Play()
			ts:Create(fr, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			task.wait(1.5)
			if wg ~= g then return end
			if wk then wk:Disconnect() end
			for _, x in wo do x:Cancel() end
			wv.Enabled = false
		end)
	end)
end

local function wy(f, id, mp, h, o)
	if cj then cj:Stop() end
	local r = h.Parent and h.Parent:FindFirstChild("HumanoidRootPart")
	if not r then return nil, "Warp Failed: No Character" end
	local sp, cf, ok = md("Shared", "Lib", "SpawnPointDialogue"), CFrame.new(r.Position + Vector3.new(0, 1000, 0)), false
	o.hb = game:GetService("RunService").Heartbeat:Connect(function()
		if r.Parent then r.AssemblyLinearVelocity, r.CFrame = Vector3.zero, cf end
	end)
	task.wait(0.3)
	cf = CFrame.new(mp.X, 1000, mp.Z)
	task.wait(0.6)
	cf = CFrame.new(mp + Vector3.new(4, 3, 0))
	task.wait(0.2)
	local dl = os.clock() + 4.5
	while not ok and os.clock() < dl and f.st == "Running" do
		local b, dn = {}, false
		task.spawn(function() sp.CreateAction(true, b, b).on_select(function(x) ok, dn = x == true, true end) end)
		local d2 = os.clock() + 3
		repeat task.wait() until dn or os.clock() > d2
		if not ok then task.wait(0.1) end
	end
	if ok then
		local d3 = os.clock() + 3
		repeat task.wait() until (pd() or {}).SpawnIsland == id or os.clock() > d3 or f.st ~= "Running"
	end
	o.hb:Disconnect()
	if f.st ~= "Running" then return nil end
	if not ok then return nil, "Warp Failed: Spawn Not Set" end
	if (pd() or {}).SpawnIsland ~= id then return nil, "Warp Failed: Spawn Island Unchanged" end
	local bc, tk, d4 = md("Controllers", "BackpackController"), false, os.clock() + 10
	while f.st == "Running" and os.clock() < d4 do
		local s, v = pcall(function() return bc.TeleportToSpawn:Fire() end)
		tk = s and v == true
		if tk then break end
		task.wait(0.5)
	end
	if f.st ~= "Running" then return nil end
	if not tk then return nil, "Warp Failed: Respawn Refused" end
	dl = os.clock() + 8
	repeat task.wait(0.2) until ic() == id and lc() or os.clock() > dl
	if ic() ~= id then return nil, "Warp Failed: Not On Island" end
	return true
end

local function wx(f, id)
	if not (wb.on and ul(id)) then return nil end
	local mp = wm(id)
	if not mp then return nil, "Warp Failed: No Boat Merchant" end
	local ok, e = nil, nil
	wc(true)
	while f.st == "Running" do
		local dl, h = os.clock() + 8, nil
		repeat
			local _, _, x = lc()
			h = x
			if not h then task.wait(0.2) end
		until h or os.clock() > dl or f.st ~= "Running"
		if not h then continue end
		local o: {hb: RBXScriptConnection?} = {}
		local s
		s, ok, e = pcall(wy, f, id, mp, h, o)
		if o.hb then o.hb:Disconnect() end
		if not s then ok, e = nil, `Warp Failed: {ok}` end
		if ok or f.st ~= "Running" then break end
		zx(`[Warp] {id}: {e or "Warp Failed"}, Retrying`)
		task.wait(1)
	end
	wc(false, ok)
	zx(`[Warp] {id}: {ok and "Arrived" or e or "Stopped"}`)
	return ok, e
end

local function ti(f, id, k)
	if ic() == id then return true end
	local w, we = wx(f, id)
	if w or f.st ~= "Running" then return w end
	if we then f.nq = {Title = "Teleport", Text = `{we}, Sailing`} end
	local m, e = gb(f, k)
	if not m then return nil, e end
	local g
	g, e = sb(f, m)
	if not g then return nil, e end
	g, e = dv(f, m, id)
	if not g then return nil, e end
	local c, r = lc()
	if not c then return nil, "No Character" end
	local mp, mx = ns("npc_car_merchant", r.Position)
	local cp = mp and mx:GetAttribute("IslandId") == id and mp or e and e + ((e - r.Position) * Vector3.new(1, 0, 1)).Unit * 12 or rg(id)
	g, e = go(f, ap(c, cp, r.Position))
	if not g then return nil, e end
	task.wait(0.5)
	if ic() ~= id then return nil, "Not On Island" end
	return true
end

local function zm(p, wi)
	if zy.wl[p.UserId] then return true end
	local hm = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	local an = hm and hm:FindFirstChildOfClass("Animator")
	for _, t in an and an:GetPlayingAnimationTracks() or {} do
		if t.WeightCurrent > 0.05 and t.Animation and wi[t.Animation.AnimationId] then
			zy.wl[p.UserId] = wi[t.Animation.AnimationId]
			zf()
			return true
		end
	end
	return false
end

local function zg(p)
	if zy.hu[p.UserId] then return true end
	local hm = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	local an = hm and hm:FindFirstChildOfClass("Animator")
	for _, t in an and an:GetPlayingAnimationTracks() or {} do
		if t.Animation and t.Animation.AnimationId:match("%d+$") == "180435571" and math.abs(t.Speed - 0.37) < 0.01 and t.WeightTarget < 0.05 then
			zy.hu[p.UserId] = true
			zf()
			return true
		end
	end
	return false
end

local function zq(p)
	local hm = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	local an = hm and hm:FindFirstChildOfClass("Animator")
	for _, t in an and an:GetPlayingAnimationTracks() or {} do
		if t.Animation and t.Animation.AnimationId:match("%d+$") == "180435571" and math.abs(t.Speed - 0.41) < 0.01 and t.WeightTarget < 0.05 then return true end
	end
	return false
end

local function zw()
	local c, r = lc()
	local id = r and vi(r.Position) or ""
	local am = c and c:FindFirstChild("Animate")
	if not am then return false end
	local g = id ~= "" and os.clock() >= zy.ss and rg(id)
	if g then
		zy.ss = os.clock() + 10
		task.spawn(sq, Vector3.new(g.X, 2, g.Z), 5)
	end
	local wi, nr, cs = {}, false, game:GetService("CollectionService")
	for _, n in {"walk", "run", "jump"} do
		for _, x in am:FindFirstChild(n) and am[n]:GetChildren() or {} do
			if x:IsA("Animation") then wi[x.AnimationId] = n == "jump" and "Jump" or "Walk" end
		end
	end
	for _, p in game:GetService("Players"):GetPlayers() do
		local h = p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if h then
			if zy.fr[p.UserId] == nil then
				local ok, v = pcall(lp.IsFriendsWith, lp, p.UserId)
				zy.fr[p.UserId] = ok and v == true
			end
			for _, x in zy.fr[p.UserId] == false and not zg(p) and zm(p, wi) and id ~= "" and cs:GetTagged("IslandRegion") or {} do
				if x:IsA("BasePart") and x:GetAttribute("islandId") == id and (x.Position - h.Position).Magnitude < x.Size.X / 2 then nr, zy.by = true, {p.Name, p.UserId, id, zy.wl[p.UserId]} end
			end
		end
	end
	return nr
end

local function zh()
	zy.nt = os.clock() + 30
	local b = zy.by or {}
	zx(`[Safe] Hop From {game.JobId:sub(1, 8)} | Real Player {b[1] or "?"} ({b[2] or "?"}) | Seen {b[4] == "Jump" and "Jumping" or "Walking"} | {b[3] or "?"} | {#game:GetService("Players"):GetPlayers()} Players`, true)
	local ok, r = pcall(function() return hs:JSONDecode((game :: any):HttpGet(`https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=Asc&limit=100`)) end)
	if not ok or type(r) ~= "table" or type(r.data) ~= "table" then return nil, "Hop Failed: Server List" end
	local o = {}
	for _, s in r.data do
		if type(s) == "table" and type(s.id) == "string" and s.id ~= game.JobId and tonumber(s.playing) and tonumber(s.maxPlayers) and s.playing < s.maxPlayers then table.insert(o, s.id) end
	end
	if #o == 0 then return nil, "Hop Failed: No Server" end
	local tp = game:GetService("TeleportService")
	local ds = o[math.random(1, math.min(5, #o))]
	zy.hp = os.clock()
	zx(`[Safe] Teleporting To {ds:sub(1, 8)}`, true)
	local tk, e = pcall(tp.TeleportToPlaceInstance, tp, game.PlaceId, ds, lp)
	if not tk then return nil, `Hop Failed: {e}` end
	task.wait(15)
	return nil, "Hop Failed: Teleport Timeout"
end

local function sa()
	local cs, n = game:GetService("CollectionService"), 0
	for _, x in cs:GetTagged("IslandRegion") do
		if x:IsA("BasePart") then sq(Vector3.new(x.Position.X, 2, x.Position.Z), 10) end
	end
	for _, x in cs:GetTagged("BossRegion") do
		if x:IsA("BasePart") then n += 1 end
	end
	return n
end

local function br(f)
	local ev = rv.EventController and rv.EventController._active_events
	if type(ev) ~= "table" or next(ev) == nil then
		f.bx = nil
		return nil
	end
	local function fd()
		local n = 0
		for _, x in game:GetService("CollectionService"):GetTagged("BossRegion") do
			local fx = x:IsA("BasePart") and x:FindFirstChild("BossSpawnerFX")
			n += 1
			if fx and fx:GetAttribute("BossSpawnerFXActive") == true and x ~= f.bx then return x, n end
		end
		return nil, n
	end
	local x, n = fd()
	if x or n >= 12 or os.clock() < (f.sc or 0) then return x end
	for _, z in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if f.st ~= "Running" then break end
		if z:IsA("BasePart") then
			sq(Vector3.new(z.Position.X, 2, z.Position.Z), 10)
			x = fd()
			if x then return x end
		end
	end
	f.sc = os.clock() + 5
	return nil
end

local function zd(m)
	local mn = m and m:FindFirstChild("Main")
	if not mn then return nil end
	local cf, sz, rp, st, pt, bn = mn.CFrame, mn.Size, RaycastParams.new(), {}, {}, {}
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {m}
	for _, x in m:GetDescendants() do
		if x:IsA("Seat") or x:IsA("VehicleSeat") then table.insert(st, x) end
	end
	for z = 0, sz.Z / 2, 0.5 do
		for x = -sz.X / 2, sz.X / 2, 0.5 do
			local o = cf:PointToWorldSpace(Vector3.new(x, 0, z))
			local h = workspace:Raycast(Vector3.new(o.X, cf.Position.Y + 20, o.Z), Vector3.new(0, -40, 0), rp)
			if h and h.Instance.CanCollide and h.Normal.Y > 0.95 then
				local k = math.floor(h.Position.Y * 2 + 0.5)
				bn[k] = (bn[k] or 0) + 1
				table.insert(pt, {h.Position, k})
			end
		end
	end
	local fk, fn = nil, 0
	for k, n in bn do
		if n > fn then fk, fn = k, n end
	end
	local c, b, bd = cf:PointToWorldSpace(Vector3.new(0, 0, sz.Z / 4)), nil, math.huge
	for _, v in pt do
		if math.abs(v[2] - fk) <= 1 then
			local fr = true
			for _, q in st do
				local l = q.CFrame:PointToObjectSpace(v[1])
				if math.abs(l.X) < q.Size.X / 2 + 0.75 and math.abs(l.Z) < q.Size.Z / 2 + 0.75 then fr = false; break end
			end
			local d = ((v[1] - c) * Vector3.new(1, 0, 1)).Magnitude
			if fr and d < bd then b, bd = v[1], d end
		end
	end
	return b
end

local function oz(m)
	local _, r, h = lc()
	if not (r and m and m.Parent) or h.SeatPart or rv.Swimming and rv.Swimming:IsSwimming() then return false end
	local rp = RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {m}
	return workspace:Raycast(r.Position, Vector3.new(0, -6, 0), rp) ~= nil
end

local function sd(f, m)
	local p = zd(m)
	if not p then return false end
	local g = gf(f, p + Vector3.new(0, 3, 0))
	if not g or f.st ~= "Running" then return false end
	if not mo(p + Vector3.new(0, 3, 0), 30) then return false end
	task.wait(1)
	return oz(m)
end

local function bw(f)
	local _, r = lc()
	if not r then return nil, "No Character" end
	local id = ic()
	local np = ns("npc_fish_seller", r.Position)
	if not np and rg(id) then
		sq(Vector3.new(rg(id).X, 2, rg(id).Z), 10)
		np = ns("npc_fish_seller", r.Position)
	end
	if not np then return nil, "No Fish Seller" end
	local w = workspace:FindFirstChild("World")
	local il, ip = w and w:FindFirstChild("Islands"), RaycastParams.new()
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	local d = (r.Position - np) * Vector3.new(1, 0, 1)
	local u, pt = d.Magnitude > 1 and d.Unit or Vector3.xAxis, nil
	for k = 10, math.max(300, d.Magnitude), 5 do
		local q = np + u * k
		if not workspace:Raycast(Vector3.new(q.X, 103, q.Z), Vector3.new(0, -100, 0), ip) then
			pt = q
			break
		end
	end
	if not pt then return nil, "No Water Near Fish Seller" end
	local m, e = gb(f, f.bk())
	if not m then return nil, e end
	local ok
	ok, e = sb(f, m)
	if not ok then return nil, e end
	ok, e = dv(f, m, id, pt)
	if ok then sd(f, m) end
	return ok, e
end

local function hz(f, y)
	local _, r = lc()
	if not r then return nil, "No Character" end
	local function sw() return rv.Swimming and rv.Swimming:IsSwimming() end
	if cj and not cj.dn and not sw() and r.Position.Y > y - 2 then return true end
	local j, e = mo(Vector3.new(r.Position.X, y, r.Position.Z), 30)
	if not j then return nil, e end
	local dl = os.clock() + 4
	repeat task.wait(0.1) until j.st == "Arrived" and not sw() or j.dn or f.st ~= "Running" or os.clock() > dl
	if j.dn then return nil, j.why or "Hover Failed" end
	if f.st ~= "Running" then return nil end
	if sw() then return nil, "Hover Failed: Still Swimming" end
	return true
end

local function bo(f)
	local ev = rv.EventController and rv.EventController._active_events
	if type(ev) ~= "table" or next(ev) == nil then f.s.bc = false end
	if f.s.bc or (tonumber(pd().LastBossKillSlot) or 0) >= workspace:GetServerTimeNow() // 2400 * 2400 then return nil end
	if os.clock() < (f.bl or 0) then return nil end
	local x = br(f)
	if not x then return nil end
	local id, q = x.Parent and x.Parent.Parent and x.Parent.Parent.Name, Vector3.new(x.Position.X, 3, x.Position.Z)
	local _, r, h = lc()
	if not r then return nil, "No Character" end
	f.br = x
	local sw = rv.Swimming and rv.Swimming:IsSwimming()
	local cm = workspace:FindFirstChild("Cars")
	cm = cm and cm:FindFirstChild(tostring(lp.UserId))
	local cn = cm and cm:FindFirstChild("Main") and ((cm.Main.Position - q) * Vector3.new(1, 0, 1)).Magnitude <= 50
	if (((r.Position - q) * Vector3.new(1, 0, 1)).Magnitude <= 45 or cn and oz(cm)) and not h.SeatPart then
		if cn and (oz(cm) and cj and not cj.dn or sd(f, cm)) then
			f.bm = cm
			pq(cm, false)
			return q
		end
		if f.st ~= "Running" then return nil end
		local ok, e = hz(f, q.Y + 9)
		if not ok then return nil, e end
		return q
	end
	if not (f.hm or f.bb or sw or h.SeatPart) and ic() ~= "" and f.ao() and zb(f.sr(), f.kp()) > 0 then
		local hd, sf = tr(f)
		zx(`[Boss] Sell Before Boss: {hd or sf or "Done"}`)
		if f.st ~= "Running" then return nil end
		_, r, h = lc()
		if not r then return nil, "No Character" end
	end
	if not (f.hm or f.bb or sw or h.SeatPart) and ic() ~= "" then f.hm = {r.CFrame, ic()} end
	if f.bg ~= x then
		f.bg = x
		zx(`[Boss] Going To {x.Name} On {id or "?"}`)
	end
	if id and ic() ~= id and wx(f, id) then
		_, r, h = lc()
		if not r then return nil, "No Character" end
	end
	if f.st ~= "Running" then return nil end
	local d = (r.Position - q) * Vector3.new(1, 0, 1)
	local m, e = gb(f, f.bk())
	if not m then return nil, e end
	local ok
	ok, e = sb(f, m)
	if not ok then return nil, e end
	local w, cs = workspace:FindFirstChild("World"), workspace:FindFirstChild("Cars")
	local il, ip, a0, pt = w and w:FindFirstChild("Islands"), RaycastParams.new(), math.floor(lp.UserId * 0.6180339887 % 1 * 8), nil
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	for i = 0, 7 do
		local p, fr = q + Vector3.new(math.sin((a0 + i) * math.pi / 4), 0, math.cos((a0 + i) * math.pi / 4)) * 40, true
		for _, x in cs and cs:GetChildren() or {} do
			local mn = x.Name ~= tostring(lp.UserId) and x:FindFirstChild("Main")
			if mn and ((mn.Position - p) * Vector3.new(1, 0, 1)).Magnitude < 28 then fr = false; break end
		end
		if fr and (not il or not workspace:Raycast(p + Vector3.new(0, 100, 0), Vector3.new(0, -100, 0), ip)) then pt = p; break end
	end
	ok, e = dv(f, m, id, pt or q + (d.Magnitude > 1 and d.Unit or Vector3.xAxis) * 40)
	if not ok then return nil, e end
	f.bb = true
	if sd(f, m) then
		f.bm = m
		pq(m, false)
		return q
	end
	if f.st ~= "Running" then return nil end
	ok, e = hz(f, q.Y + 9)
	if not ok then return nil, e end
	return q
end

local qd = {
	{"unlock_island_2", "island_starter", "island_jungle", "Jungle Island", {RequiredCoin = 40000}},
	{"unlock_island_3", "island_jungle", "island_desert", "Desert Island", {RequiredCoin = 180000}},
	{"unlock_island_4", "island_desert", "island_snow", "Snow Island", {RequiredCoin = 900000, RequiredFish = 3}, {"Legendary", "island_desert"}},
	{"unlock_island_5", "island_snow", "island_volcano", "Volcanic Island", {RequiredCoin = 4000000, RequiredFishes = {frozen_crown_dragonfish = 1, frosttusk_seal = 1, frostmaw_monster = 1}}},
	{"unlock_island_6", "island_volcano", "island_fossil", "Fossil Island", {RequiredCoin = 15000000, RequiredFishes = {ancient_trihorn_fish = 1, stormblade_shark = 1, lavascale_dragonfish = 1}}},
}

local qt, qz, qm = {
	{"crimson_bead_rod", "island_volcano", "island_volcano", "Crimson Bead Rod", {RequiredFished = 0}, nil, "legacy_rod"},
	{"bamboo_rod", "island_volcano", "island_volcano", "Bamboo Rod", {RequiredBamboo = 0}, nil, "crimson_bead_rod", "island_jungle"},
	{"heaven_piercer_turtle_rod", "island_fossil", "island_fossil", "Heaven Piercer Turtle Rod", {RequiredFish = 0}, {"Legendary", "island_fossil"}, nil, "island_fossil"},
	{"zen_staff_rod", "island_fossil", "island_fossil", "Zen Staff Rod", {RequiredFish = 0}, nil, nil, "island_fossil"},
	{"dread_fish_rod", "island_fossil", "island_fossil", "Dread Fish Rod", {RequiredFish = 0}, {"Mythical", "island_fossil"}, nil, "island_fossil"},
	{"taiji_hooking_art_v2", "island_snow", "island_snow", "Taiji Hooking Art V2 Upgrade", {RequiredKills = 0}},
}, {}, {}
for _, q in qt do
	table.insert(qz, q[4])
	qm[q[4]] = q
end

local qg, qgz = {
	{"white_tiger", "island_desert", "island_desert", "White Tiger Soul", {RequiredFish = 3}, {"Legendary", "island_desert", 1000}, nil, "island_desert", true},
	{"phoenix", "island_snow", "island_snow", "Phoenix Soul", {RequiredFish = 3}, {"Legendary", "island_snow"}, nil, "island_snow", true},
	{"azure_dragon", "island_volcano", "island_volcano", "Azure Dragon Soul", {RequiredFish = 0, CatchWithSkill = 0}, {"Legendary", "island_volcano"}, nil, "island_volcano", true},
	{"supreme_king", "island_fossil", "island_fossil", "Supreme King Soul", {CatchWithSkill = 0, RequiredBooks = {}}, nil, nil, "island_fossil", true},
}, {}
for _, q in qg do table.insert(qgz, q[4]) end

local function qc(q, d, pr)
	local ct, n, ks, df, id, rr = md("Data", "Catalog"), {}, {}, {}, q[1], q[6]
	local wk = id == "unlock_island_6" and md("Data", "Config", "QuestConfig").UnlockIsland6MinWeightKg or {}
	if rr then
		for _, x in (ct.Island.GetById(rr[2]) or {}).fishes or {} do df[x.fishId] = true end
	end
	local rf = rr and {["*"] = pr.RequiredFish or 1} or pr.RequiredFishes or {}
	for u, x in d.Inventory and d.Inventory.Fishes or {} do
		local fi = ct.Fish.GetById(x.fishId)
		local k = rr and fi and fi.rarity == rr[1] and df[x.fishId] and (x.weight or 0) >= (rr[3] or 0) and "*" or not rr and rf[x.fishId] and (id ~= "unlock_island_6" or wk[x.fishId] and (x.weight or 0) >= wk[x.fishId]) and x.fishId
		if k and (n[k] or 0) < rf[k] then n[k], ks[u] = (n[k] or 0) + 1, true end
	end
	local ok = (d.Coin or 0) >= (pr.RequiredCoin or 0)
	for k, v in rf do
		if (n[k] or 0) < v then ok = false end
	end
	if id == "crimson_bead_rod" and (pr.CurrentFished or 0) < (pr.RequiredFished or 1) then ok = false end
	if id == "zen_staff_rod" and (pr.CurrentFish or 0) < (pr.RequiredFish or 1) then ok = false end
	if id == "bamboo_rod" and md("Shared", "getItemCount")(d, "bamboo_fragment") < (pr.RequiredBamboo or 1) then ok = false end
	if id == "taiji_hooking_art_v2" and ((pr.CurrentKills or 0) < (pr.RequiredKills or 1) or (((d.Inventory or {}).Books or {}).taiji_hooking_art or 0) < (pr.RequiredBookCount or 1)) then ok = false end
	if (id == "azure_dragon" or id == "supreme_king") and (pr.CurrentUsedSkill or 0) < (pr.CatchWithSkill or (id == "azure_dragon" and 100 or 5)) then ok = false end
	if id == "phoenix" or id == "supreme_king" then
		local ba = md("Utils", "skillBookAvailability")
		for b, v in id == "phoenix" and md("Data", "Config", "QuestConfig").PhoenixRequiredBooks or pr.RequiredBooks or {rod_gate_20_percent = 1} do
			if ba.GetCounts(d, b).available < v then ok = false end
		end
	end
	return ok, ks
end

local function qn(f)
	for _, q in qd do
		if not ul(q[3]) then return ul(q[2]) and not f.qx[q[1]] and q or nil end
	end
	return nil
end

local function qw(f, k, t, h)
	if f.qw[k] then return end
	f.qw[k], f.nq = true, {Title = h or "Rod Quest", Text = t}
end

local function qp(f)
	local q, d = f.qs(), pd()
	if not q or f.qx[q[1]] then return nil end
	if d.Quest and d.Quest.Done and d.Quest.Done[q[1]] then
		f.qx[q[1]], f.nq = true, {Title = "Rod Quest", Text = `{q[4]} Already Done`}
		return nil
	end
	if not ul(q[2]) then return qw(f, `i{q[1]}`, `Rod Quest Waiting: Island Locked`) end
	if q[7] and not (d.Rods and d.Rods[q[7]]) then return qw(f, `r{q[1]}`, `Rod Quest Waiting: No {q[7] == "legacy_rod" and "Legacy Rod" or "Crimson Bead Rod"}`) end
	if q[1] == "taiji_hooking_art_v2" and (((d.Inventory or {}).Books or {}).taiji_hooking_art or 0) < 1 then return qw(f, `b{q[1]}`, "Rod Quest Waiting: No Taiji Hooking Art Book") end
	return q
end

local function qk(d, ys)
	local r, dn, so = {}, (d.Quest or {}).Done or {}, (d.Inventory or {}).Souls or {}
	for _, q in qg do
		if table.find(ys or {}, q[4]) and not dn[q[1]] and so[q[1]] ~= true then table.insert(r, q) end
	end
	return r
end

local function qy(f)
	local d = pd()
	local cq = (d.Quest or {}).Current or {}
	local ls, hb = qk(d, f.ys()), {}
	for _, x in ((d.Rods or {})[d.RodEquip] or {}).BookSlots or {} do hb[x] = true end
	for i, q in ls do
		if q[1] == cq.Id then table.insert(ls, 1, table.remove(ls, i)); break end
	end
	for _, q in ls do
		local id, pr = q[1], cq.Id == q[1] and cq.Progress or {}
		local fb = (pr.CurrentUsedSkill or 0) < (pr.CatchWithSkill or (id == "azure_dragon" and 100 or 5))
		local ba, mb = md("Utils", "skillBookAvailability"), {}
		for b, v in id == "phoenix" and md("Data", "Config", "QuestConfig").PhoenixRequiredBooks or id == "supreme_king" and not fb and (pr.RequiredBooks or {rod_gate_20_percent = 1}) or {} do
			if ba.GetCounts(d, b).available < v then table.insert(mb, (md("Data", "Catalog").Skill.GetById(b) or {}).name or b) end
		end
		table.sort(mb)
		if f.qx[id] then
			continue
		elseif not ul(q[2]) then
			qw(f, `yi{id}`, `Soul Quest Waiting: {q[4]} Island Locked`, "Soul Quest")
		elseif #mb > 0 then
			qw(f, `yb{id}`, `Soul Quest Waiting: {q[4]} Needs Unequipped {table.concat(mb, ", ")}`, "Soul Quest")
		elseif fb and (id == "azure_dragon" or id == "supreme_king") and not hb[id == "azure_dragon" and "one_hook_supreme" or "rod_gate_20_percent"] then
			qw(f, `ye{id}`, `Soul Quest Waiting: Equip {id == "azure_dragon" and "One Hook Supreme" or "Rod Gate 20%"}`, "Soul Quest")
		else
			return q
		end
	end
	return nil
end

local function qv(q)
	local d = pd()
	if not q then return {} end
	local cq = d.Quest and d.Quest.Current
	local _, ks = qc(q, d, cq and cq.Id == q[1] and cq.Progress or q[5])
	return ks
end

local function gn(q)
	local id, g = `npc_{q[1]}`, rg(q[3])
	local p = ns(id, Vector3.zero)
	if not p and g then
		sq(Vector3.new(g.X, 2, g.Z), 10)
		p = ns(id, Vector3.zero)
	end
	return p
end

local function ub()
	local d, n = pd(), 0
	for _, r in d.Rods or {} do
		for _, id in r.BookSlots or {} do
			if id == "taiji_hooking_art" then n += 1 end
		end
	end
	if (((d.Inventory or {}).Books or {}).taiji_hooking_art or 0) - n >= 1 then return true end
	local re = d.Rods and d.Rods[d.RodEquip]
	for s, id in re and re.BookSlots or {} do
		if id == "taiji_hooking_art" then
			local i = tonumber(tostring(s):match("%d+"))
			local x = i and rv.EquipmentsController.EquipMoveset:Fire("", i)
			if x ~= "Success" then return nil, `Unequip Book Failed: {x or "No Response"}` end
			local dl = os.clock() + 3
			repeat task.wait(0.2) until (((pd().Rods or {})[d.RodEquip] or {}).BookSlots or {})[s] ~= "taiji_hooking_art" or os.clock() > dl
			return true, nil, i
		end
	end
	return nil, "Unequip Book Failed: Book On Another Rod"
end

local function ug(f, q, ac)
	local ok, e = ti(f, q[3], f.bk())
	if not ok then return nil, e or f.st == "Running" and "Move Failed" or nil end
	local c, rt = lc()
	if not rt then return nil, "No Character" end
	local np = gn(q)
	if not np then return nil, "No Island Guide" end
	ok, e = an(f, c, np, rt.Position)
	if not ok then return nil, e or f.st == "Running" and "Move Failed" or nil end
	if f.st ~= "Running" then return nil end
	local qr, iu = rv.QuestController, q[1]:find("^unlock_island_") ~= nil
	local tt, px = iu and "Island Guide" or q[9] and "Soul Quest" or "Rod Quest", iu and "Unlock Island Failed" or q[9] and "Soul Quest Failed" or "Rod Quest Failed"
	local function vb() return ((pd().Inventory or {}).Books or {}).taiji_hooking_art_v2 or 0 end
	local v0 = vb()
	local function dn() return ((pd().Quest or {}).Done or {})[q[1]] == true or q[1] == "taiji_hooking_art_v2" and vb() > v0 or q[9] and ((pd().Inventory or {}).Souls or {})[q[1]] == true end
	if not ac then
		local a, m = qr:Accept(q[1])
		zx(`[Quest] Accept {q[1]}: {tostring(a)} {m or ""}`)
		if a ~= true then
			f.qx[q[1]], f.nq = true, {Title = tt, Text = `{px}: {m or "Accept Refused"}`}
			return true
		end
		local dl = os.clock() + 3
		repeat task.wait(0.2) until (pd().Quest or {}).Current and pd().Quest.Current.Id == q[1] or os.clock() > dl
		local cq = (pd().Quest or {}).Current
		if not (cq and cq.Id == q[1]) then return nil, "Quest Not Saved" end
		if not qc(q, pd(), cq.Progress or {}) then
			f.nq = {Title = tt, Text = `{q[4]} Quest Accepted, Requirements Not Met`}
			return true
		end
	end
	local cq = (pd().Quest or {}).Current
	local _, ks = qc(q, pd(), cq and cq.Id == q[1] and cq.Progress or q[5])
	for u in ks do
		local x = pd().Inventory.Fishes[u]
		if x and x.locked == true then
			local s, v = rv.SellController:ToggleLock(u)
			if s ~= 0 or v ~= false then
				f.qx[q[1]], f.nq = true, {Title = tt, Text = `{px}: Unlock Fish Failed`}
				return true
			end
		end
	end
	local bi2
	if q[1] == "taiji_hooking_art_v2" then
		local bo2, be2
		bo2, be2, bi2 = ub()
		if not bo2 then
			f.qx[q[1]], f.nq = true, {Title = tt, Text = `{px}: {be2}`}
			return true
		end
	end
	local cp, m = qr:Complete(q[1])
	zx(`[Quest] Complete {q[1]}: {tostring(cp)} {m or ""}`)
	if cp ~= true then
		f.qx[q[1]], f.nq = true, {Title = tt, Text = `{px}: {m or "Complete Refused"}`}
		return true
	end
	local dl = os.clock() + 5
	repeat task.wait(0.2) until dn() or os.clock() > dl
	if not dn() then
		f.qx[q[1]], f.nq = true, {Title = tt, Text = `{px}: Not Completed`}
		return true
	end
	if q[1] == "taiji_hooking_art_v2" then
		f.qx[q[1]] = true
		local d2 = pd()
		for sl, x in ((d2.Rods or {})[d2.RodEquip] or {}).BookSlots or {} do
			if not bi2 and x == "taiji_hooking_art" then bi2 = tonumber(tostring(sl):match("%d+")) end
		end
		local x = bi2 and rv.EquipmentsController.EquipMoveset:Fire("taiji_hooking_art_v2", bi2)
		if bi2 and x ~= "Success" then
			f.nq = {Title = tt, Text = `Got {q[4]}, Equip V2 Failed: {x or "No Response"}`}
			return true
		end
	end
	if q[9] and ({human = true, [""] = true})[pd().SoulEquip or ""] then
		local eo = rv.EquipmentsController.EquipmentEquip:Fire("soul", q[1])
		f.nq = {Title = tt, Text = eo == true and `Got {q[4]}, Equipped` or `Got {q[4]}, Equip Soul Failed`}
		return true
	end
	f.nq = {Title = tt, Text = `{iu and "Unlocked" or "Got"} {q[4]}`}
	return true
end

local function uq(f, q)
	if not q then return nil end
	local d = pd()
	local cq = d.Quest and d.Quest.Current
	local ci = cq and cq.Id or ""
	if ci ~= "" and ci ~= q[1] then return nil end
	if not qc(q, d, ci == q[1] and cq.Progress or q[5]) then return nil end
	local _, rt = lc()
	if not rt then return nil, "No Character" end
	local o, oi = rt.CFrame, ic()
	local ok, e = ug(f, q, ci == q[1])
	local hk, he = true, nil
	if f.st == "Running" and oi ~= "" and ic() ~= oi then hk, he = ti(f, oi, f.bk()) end
	if hk and f.st == "Running" and ic() == oi and not f.hf() then hk, he = go(f, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
	f.rp = f.rp or not hk
	return true, not ok and e or not hk and f.st == "Running" and (he or "Return Failed") or nil
end

local function dy(f)
	local d, du = pd(), md("Shared", "Lib", "DailyQuestUtil")
	local dq = d.DailyQuest
	if type(dq) ~= "table" or type(dq.Active) ~= "table" then return nil end
	local a = dq.Active
	if a.Template ~= "" then
		if not du.IsSkillGachaQuest(a) or f.qw.dp then return nil end
		local sc = rv.SkillGachaController
		local q = sc.GetQuote:Fire(1)
		if type(q) ~= "table" or not q.ok then return nil, `Daily Quest Pull Failed: {type(q) == "table" and q.reason or "No Quote"}` end
		if (d.Coin or 0) < q.coin_cost then
			if not f.qw.dc then f.qw.dc, f.nq = true, {Title = "Daily Quest", Text = "Daily Quest Waiting: Not Enough Coin"} end
			return nil
		end
		f.qw.dc = nil
		sc._requestId = (tonumber(sc._requestId) or 0) + 1
		local r, p0 = sc.Pull:Fire("Coin", 1, sc._requestId), a.Progress or 0
		if type(r) ~= "table" or not r.ok then return nil, `Daily Quest Pull Failed: {type(r) == "table" and r.reason or "No Response"}` end
		local function mv()
			local x = pd().DailyQuest.Active
			return x.Template == "" or (x.Progress or 0) > p0
		end
		local dl = os.clock() + 5
		repeat task.wait(0.2) until mv() or os.clock() > dl
		if not mv() then f.qw.dp, f.nq = true, {Title = "Daily Quest", Text = "Daily Quest Failed: Pull Not Counted"} end
		return true
	end
	if os.clock() < (f.dx or 0) or (((d.Quest or {}).Current or {}).Id or "") ~= "" then return nil end
	if du.AcceptsLeft(dq, md("Shared", "Lib", "DailyRewardUtil").get_now()) <= 0 then
		if not f.qw.dd then f.qw.dd, f.nq = true, {Title = "Daily Quest", Text = "Daily Quest Done For Today"} end
		return nil
	end
	local id = f.fi() or ic()
	if id == "" or not ul(id) then return nil end
	local ok, e = ti(f, id, f.bk())
	if not ok then return true, e or f.st == "Running" and "Move Failed" or nil end
	local w = workspace:FindFirstChild("World")
	local fo = w and w:FindFirstChild("Islands") and w.Islands:FindFirstChild(id)
	local function nf()
		for _, x in game:GetService("CollectionService"):GetTagged("Interactive") do
			if fo and x:GetAttribute("InteractiveId") == "npc_daily_quest" and x:IsDescendantOf(fo) then return x:IsA("Model") and x:GetPivot().Position or x:IsA("BasePart") and x.Position or nil end
		end
		return nil
	end
	local np, g = nf(), rg(id)
	if not np and g then
		sq(Vector3.new(g.X, 2, g.Z), 10)
		np = nf()
	end
	if not np then
		f.dx = os.clock() + 60
		return true, "Daily Quest Failed: No Quest NPC"
	end
	local c, rt = lc()
	if not rt then return nil, "No Character" end
	ok, e = an(f, c, np, rt.Position)
	if not ok then return true, e or f.st == "Running" and "Move Failed" or nil end
	if f.st ~= "Running" then return true end
	local ak, m = rv.QuestController:AcceptDaily()
	f.rp = true
	if ak ~= true then f.dx = os.clock() + 60 end
	f.nq = {Title = "Daily Quest", Text = ak == true and `Daily Quest: {m}` or `Daily Quest Failed: {m ~= "" and m or "Accept Refused"}`}
	return true
end

local function ss(f)
	local s, fc = f.s, rv.FishingController
	local ks = sk()
	if #ks == 0 then return "Auto Fish Failed: No Skill Equipped" end
	local bp, be
	if f.ab() then bp, be = bo(f) end
	f.bu = bp ~= nil
	if not bp and f.bm then
		pq(f.bm, true)
		f.bm, f.rp = nil, true
		if cj then cj:Stop() end
	end
	if be then return nil, be end
	if not bp and f.bb then f.bb, f.rp = false, true end
	if not bp and f.hm then
		local o, oi = f.hm[1], f.hm[2]
		local ok, e = true, nil
		if ic() ~= oi then ok, e = ti(f, oi, f.bk()) end
		if ok and f.st == "Running" and not f.hf() then ok, e = go(f, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
		if f.st ~= "Running" then return nil end
		if not ok then return nil, e or "Return Failed" end
		f.hm, f.rp = nil, false
		return nil
	end
	if not bp then
		for _, q in {f.au() and qn(f) or false, f.qa() and qp(f) or false, f.ya() and qy(f) or false} do
			local u, ue = uq(f, q or nil)
			if u or ue then return nil, ue end
		end
		if f.dq() then
			local u, ue = dy(f)
			if u or ue then return nil, ue end
		end
	end
	local rq = not bp and f.qa() and qp(f)
	local rc = rq and rq[8] and (pd().Quest or {}).Current
	local da = not bp and f.dq() and (pd().DailyQuest or {}).Active
	local yq = not bp and f.ya() and qy(f)
	local fi = not bp and (rc and rc.Id == rq[1] and rq[8] or da and da.Template ~= "" and da.IslandId ~= "" and da.IslandId or yq and yq[8] or f.fi())
	if fi and ic() ~= fi then
		if not ul(fi) then return "Auto Fish Failed: Island Locked" end
		local ok, e = ti(f, fi, f.bk())
		if not ok then return nil, e end
		f.rp = true
		return nil
	end
	if f.ao() and fl() then
		if bp then
			local ok, e = bw(f)
			if not ok then return nil, e end
		end
		local hd, sf = tr(f)
		if hd or sf or f.st ~= "Running" then return hd, sf end
		task.wait(1)
		if fl() then return "Auto Fish Failed: Satchel Full" end
		if bp then return nil end
	end
	local ok, e = eq()
	if not ok then return nil, e end
	local h = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	if not h then return nil, "No Character" end
	if f.hp and not f.hf() then
		if cj and cj.p == f.hp then cj:Stop() end
		f.hp, f.rp = nil, true
	end
	local hi = not bp and f.hf()
	if hi then
		local id = vi(h.Position)
		if f.rp or not f.hp or f.hi ~= id then
			local gy
			f.hp, f.hi = nil, id
			if id ~= "" then f.hp, gy = uh(id) end
			if f.hp then
				f.rp = false
				zx(`[Hidden] Spot {math.floor(f.hp.X)}, {math.floor(f.hp.Z)} Under Ground Y {math.floor(gy)} On {id}`)
			elseif id ~= "" then
				zx(`[Hidden] No Spot On {id}, Normal Spot`)
			end
		end
		if f.hp and not (cj and not cj.dn and cj.p == f.hp) then
			local q = tg({Position = f.hp})
			local fk = q and ((q - f.hp) * Vector3.new(1, 0, 1)).Unit
			local u = h.Position.Y < -10 and ut(h.Position)
			if u then
				mo(u, 1e6)
				task.wait(0.1)
			end
			local mk, me = go(f, ut(f.hp) or Vector3.new(f.hp.X, 12, f.hp.Z), fk)
			if f.st ~= "Running" then return nil end
			if not mk then return nil, me or "Move Failed" end
			local j = mo(f.hp, 1e6, fk)
			local dl = os.clock() + 2
			repeat task.wait() until not j or j.st == "Arrived" or j.dn or os.clock() > dl
			if not (j and j.st == "Arrived") then return nil, j and j.why or "Hide Failed" end
		end
	end
	if not bp and not (hi and f.hp) and (f.rp or rv.Swimming and rv.Swimming:IsSwimming() or not tg(h)) then
		f.rp = false
		local g = rs(vi(h.Position)) or vi(h.Position) ~= "" and rs(vi(h.Position), true)
		if not g and vi(h.Position) == "" then
			local nb, nd = nil, math.huge
			for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
				local id = x:GetAttribute("islandId")
				if x:IsA("BasePart") and type(id) == "string" and ul(id) and (x.Position - h.Position).Magnitude < nd then nb, nd = id, (x.Position - h.Position).Magnitude end
			end
			if nb then
				f.rp = true
				local ok, e = ti(f, nb, f.bk())
				return nil, not ok and (e or "Move Failed") or nil
			end
		end
		if not g then return "Auto Fish Failed: No Open Water" end
		local q = tg({Position = g})
		local mk, me = go(f, g, q and ((q - g) * Vector3.new(1, 0, 1)).Unit)
		if not mk then return nil, me end
	end
	if not bp and rv.Swimming and rv.Swimming:IsSwimming() then
		f.rp = true
		return nil, "Swimming"
	end
	local p = bp or tg(h)
	if not p then return "Auto Fish Failed: No Open Water" end
	s.wa, s.fp, s.rl, s.q, s.cr, s.rr, s.sw, s.bs, s.id = nil, nil, nil, nil, nil, nil, 0, 0, nil
	fc.FishCast:Fire(1, p)
	local dl = os.clock() + 3
	repeat task.wait() until s.wa or s.fp or s.rl or s.cr or s.rr or f.st ~= "Running" or os.clock() > dl
	if not (s.wa or s.fp or s.rl or s.cr or s.rr) then
		if f.st == "Running" then fc.FishLootConfirm:Fire() end
		return nil, "No Cast Ack"
	end
	dl = os.clock() + 25
	repeat task.wait() until s.fp or s.rl or s.cr or s.rr or f.st ~= "Running" or os.clock() > dl
	if s.fp and not (s.rl or s.cr or s.rr) and f.st == "Running" then
		fp(s)
		repeat task.wait() until s.rl or s.cr or s.rr or f.st ~= "Running" or os.clock() > dl
	end
	local fo = s.id and md("Data", "Catalog").Fish.GetById(s.id)
	local bf = fo and fo.kind == "Boss"
	local zq, zk, zc = not bp and f.qa() and qp(f), ks, (pd().Quest or {}).Current or {}
	local zp = zc.Progress or {}
	local zs = zq and zc.Id == zq[1] and (zq[1] == "zen_staff_rod" and fo and fo.rarity == "Legendary" and ic() == "island_fossil" and "taiji_hooking_art_v2" or zq[1] == "taiji_hooking_art_v2" and "taiji_hooking_art") or not bp and f.ya() and (zp.CurrentUsedSkill or 0) < (zp.CatchWithSkill or 1) and (zc.Id == "azure_dragon" and "one_hook_supreme" or zc.Id == "supreme_king" and fo and fo.rarity == "Legendary" and ic() == "island_fossil" and "rod_gate_20_percent")
	if zs then
		zk = {}
		for _, x in ks do
			if x[2] == zs then table.insert(zk, x) end
		end
		if #zk == 0 then
			local rq2 = zs:find("^taiji") ~= nil
			zk = ks
			qw(f, `z{zs}`, `{rq2 and "Rod" or "Soul"} Quest Waiting: Equip {({taiji_hooking_art = "Taiji Hooking Art", taiji_hooking_art_v2 = "Taiji Hooking Art V2", one_hook_supreme = "One Hook Supreme", rod_gate_20_percent = "Rod Gate 20%"})[zs]}`, rq2 and "Rod Quest" or "Soul Quest")
		end
	end
	local up = hi and f.hp and s.rl and f.st == "Running" and cj and not cj.dn and cj.p == f.hp and cj.fk
	local uj = up and mo(Vector3.new(f.hp.X, 1000, f.hp.Z), 1e6, up)
	local re = s.rl and f.st == "Running" and rl(f, s, zk) or not (s.cr or s.rr) and f.st == "Running" and "Bite Timeout"
	if uj and not uj.dn then mo(f.hp, 1e6, up) end
	if bf and not (s.cr and s.cr[1]) then
		f.bl = os.clock() + 180
		zx(`[Boss] Fight Ended Without Catch ({s.rr or "No Reset"}), Lockout 180 s`)
	end
	if f.st ~= "Running" or re then
		if s.cr and s.cr[1] and not s.cr[2] then task.wait(0.75); fc.FishLootConfirm:Fire() end
		if not (s.cr or s.rr) then fc.FishCancel:Fire(); task.wait(1) end
		return nil, re
	end
	if bp and s.rr == "IslandLocked" then
		f.bx, f.bb, f.rp = f.br, false, true
		zx("[Boss] Region On A Locked Island, Skipped")
		return nil
	end
	if s.rr == "NoSkillEquipped" then return "Auto Fish Failed: No Skill Equipped" end
	if s.rr == "SatchelFull" and not f.ao() then return "Auto Fish Failed: Satchel Full" end
	if s.rr == "SessionActive" then
		fc.FishLootConfirm:Fire()
		fc.FishCancel:Fire()
		task.wait(1)
	end
	if s.rr then return nil, s.rr end
	if s.cr[1] then
		f.c += 1
		if not s.cr[2] then task.wait(0.75); fc.FishLootConfirm:Fire() end
	end
	task.wait(0.6)
	return nil
end

local function rn(f)
	local n = 0
	while f.st == "Running" do
		if f.fq then
			f.st = "Stopped"
			break
		end
		if f.iw() then
			task.wait(0.5)
			continue
		end
		if zy.on and zy.rq and not (f.bu or f.bb or f.hm) then
			zy.rq = false
			local _, e = zh()
			if e then zx(`[Safe] {e}`, true) end
			f.nq = {Title = "Safe", Text = e}
			continue
		end
		f.bz = true
		local hd, sf = ss(f)
		f.bz = false
		if hd then f.why = hd; return end
		n = sf and n + 1 or 0
		if n >= 5 then
			n, f.rp, f.nq = 0, true, {Title = "Auto Fish", Text = `Auto Fish Retry: {sf}`}
			if cj then cj:Stop() end
			task.wait(1)
		elseif sf then
			task.wait(1)
		end
	end
end

local L = (function()
local ps, uis, tws, gs, hs = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("GuiService"), game:GetService("HttpService")
local ge = getgenv and getgenv() or _G
local c = {bg = Color3.fromRGB(37, 37, 34), cd = Color3.fromRGB(47, 47, 43), hv = Color3.fromRGB(58, 58, 54), pr = Color3.fromRGB(68, 68, 63), tx = Color3.fromRGB(244, 240, 232), dm = Color3.fromRGB(168, 164, 156), ac = Color3.fromRGB(76, 194, 255), er = Color3.fromRGB(214, 106, 94)}
local fn, fb, ww, wh, nw, th = Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold, 580, 340, 150, 40
local ip = "rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"
local ir, ib = Font.new(ip), Font.new(ip, Enum.FontWeight.Bold)
local mb, tc, mm, kb = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement, Enum.UserInputType.Keyboard
local ti = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local L = {Flags = {}}

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

function L:Gate(o)
	o = o or {}
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
	local sg = gui()
	L.GateGui = sg
	bt({Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(), BackgroundTransparency = 0.5, Parent = sg})
	local f = mk("Frame", {Size = UDim2.fromOffset(300, 180), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = c.bg, BorderSizePixel = 0, ZIndex = 2, Parent = sg}, {rc(12), sk(0.85), pd(20, 20, 20, 20)})
	local sc = mk("UIScale", {Parent = f})
	fit(sg, f, sc, 300, 180)
	local cn = sg:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() fit(sg, f, sc, 300, 180) end)
	tl({Text = tostring(o.Title or "Avenoric"), Font = fb, TextSize = 16, Size = UDim2.new(1, 0, 0, 20), Parent = f})
	tl({Text = "Enter your key to continue", TextSize = 13, TextColor3 = c.dm, Position = UDim2.fromOffset(0, 22), Size = UDim2.new(1, 0, 0, 16), Parent = f})
	local bx = mk("Frame", {Position = UDim2.fromOffset(0, 48), Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = c.cd, BorderSizePixel = 0, ClipsDescendants = true, Parent = f}, {rc(6), sk(0.9)})
	local st = bx:FindFirstChildOfClass("UIStroke")
	local tb = mk("TextBox", {BackgroundTransparency = 1, Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 1, 0), Font = fn, TextSize = 14, TextColor3 = c.tx, PlaceholderText = "Key", PlaceholderColor3 = c.dm, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, Text = "", Parent = bx})
	local ml = tl({Text = "", TextSize = 12, TextColor3 = c.er, Position = UDim2.fromOffset(0, 86), Size = UDim2.new(1, 0, 0, 16), Visible = false, TextTruncate = Enum.TextTruncate.AtEnd, Parent = f})
	local sb = bt({AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Size = o.Link and UDim2.new(0.5, -4, 0, 32) or UDim2.new(1, 0, 0, 32), BackgroundColor3 = c.ac, BackgroundTransparency = 0, Font = fb, TextSize = 13, TextColor3 = c.bg, Text = "Submit", Parent = f}, {rc(6)})
	tb:GetPropertyChangedSignal("Text"):Connect(function() if #tb.Text > mx then tb.Text = tb.Text:sub(1, mx) end end)
	local busy, got = false, nil
	local function msg(s, col) ml.Text, ml.TextColor3, ml.Visible = s, col or c.er, true end
	local function sub()
		if busy then return end
		local s = (tb.Text:gsub("^%s+", ""):gsub("%s+$", ""))
		if s == "" then msg("Enter A Key"); return end
		busy, sb.Text = true, "Checking..."
		local ok, r, m = pcall(o.Check, s)
		busy, sb.Text = false, "Submit"
		if not ok then msg("Key Check Failed: " .. tostring(r)); return end
		if r ~= true then msg(m and tostring(m) or "Wrong Key"); return end
		if kp then pcall(function() mkd(kp); writefile(kp, s) end) end
		if o.Discord and request then task.spawn(inv, tostring(o.Discord)) end
		got = s
	end
	tb.Focused:Connect(function() tw(st, {Color = c.ac, Transparency = 0}) end)
	tb.FocusLost:Connect(function(en)
		tw(st, {Color = c.tx, Transparency = 0.9})
		if en then sub() end
	end)
	sb.Activated:Connect(sub)
	if o.Link then
		local gk = bt({AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(0.5, -4, 0, 32), BackgroundColor3 = c.cd, BackgroundTransparency = 0, Font = fn, TextSize = 13, TextColor3 = c.tx, Text = "Get Key", Parent = f}, {rc(6), sk(0.9)})
		hov(gk, function() return c.cd end)
		gk.Activated:Connect(function()
			if setclipboard then setclipboard(tostring(o.Link)) end
			msg("Link Copied", c.dm)
		end)
	end
	repeat task.wait() until got ~= nil
	cn:Disconnect()
	sg:Destroy()
	L.GateGui = nil
	return got
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
		local ok, e = pcall(f, ...)
		if ok then return end
		warn("Callback Failed: " .. tostring(e))
		W:Notify({Title = "Callback Failed", Text = tostring(e), Error = true})
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
				if y + h > wh - 8 then y = bp.Y - h - 4 end
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
local kf, ky, ex, kl = "Avenoric/Keys/FishingMaster.txt", "NGAO-6366-HNW8", 1791645511, "https://linkfree.click/s/ngao-gaming-hubz1u17pnmunx0jzb"
local kc = {t = 0, v = false}
local function kv()
	if os.clock() < kc.t then return kc.v end
	local o, s = pcall(readfile, kf)
	kc.v, kc.t = o and type(s) == "string" and s:match("^%s*(.-)%s*$") == ky, os.clock() + 30
	return kc.v
end
if ge.__FmD then pcall(function() ge.__FmD:Destroy() end) end
ge.__FmD = nil
task.defer(function() ge.__FmD = L.GateGui end)
L:Gate({Title = "Ngao - Gaming Hub", Link = kl, Discord = "https://discord.gg/fTQF5TvfEJ", Config = "FishingMaster", Check = function(s)
	if workspace:GetServerTimeNow() >= ex then return false, "Key Expired" end
	return s == ky, "Wrong Key"
end})
ge.__FmD = nil
local gw = L:Window({Title = "Ngao - Gaming Hub | Fishing Master", Config = `FishingMaster/{lp.Name}`})
do
	local on = gw.Notify
	gw.Notify = function(s, q)
		if type(q) == "table" then zx(`[{q.Title or "Hub"}] {q.Text or ""}`) end
		return on(s, q)
	end
	zx(`[Hub] Loaded | Place {game.PlaceVersion} | Server {game.JobId:sub(1, 8)} | {#ps:GetPlayers()} Players`)
end
do
	for _, x in gw.Gui:GetChildren() do
		local t = x:IsA("GuiButton") and x:FindFirstChildWhichIsA("TextLabel")
		if t and t.Text == "studio" then x.Visible = false end
	end
	if ge.__FmNg then pcall(ge.__FmNg) end
	local tws, cs = game:GetService("TweenService"), {}
	local ok0, b0 = pcall(function() return lp.PlayerGui:WaitForChild("HUD", 5).Frame.Buttons end)
	local hu, ht = ok0 and b0 or nil, 0
	local hb = hu and hu:FindFirstAncestorOfClass("ScreenGui")
	local sh = Instance.new("ScreenGui")
	sh.Name, sh.ResetOnSpawn, sh.IgnoreGuiInset, sh.ZIndexBehavior, sh.DisplayOrder = hs:GenerateGUID(false), false, true, Enum.ZIndexBehavior.Sibling, 998
	if hb then
		sh.IgnoreGuiInset = hb.IgnoreGuiInset
		pcall(function() sh.ScreenInsets = hb.ScreenInsets end)
	end
	if not pcall(function() sh.Parent = gethui() end) then sh.Parent = lp.PlayerGui end
	local se, fl = hu and hu:FindFirstChild("Settings"), nil
	if se then
		fl = se:Clone()
		for _, d in fl:GetDescendants() do
			if d:IsA("LuaSourceContainer") or d.Name == "HasNotification" then d:Destroy() end
		end
		local t = fl:FindFirstChild("Title", true)
		if t and t:IsA("TextLabel") then t.Text = "Ngao" end
		if gi then
			for _, d in fl:GetDescendants() do
				if d:IsA("ImageLabel") and d.Name == "Icon" then
					d.Image = gi
					local u = Instance.new("UICorner")
					u.CornerRadius, u.Parent = UDim.new(1, 0), d
				end
			end
		end
		fl.Name, fl.AnchorPoint, fl.LayoutOrder, fl.Parent = "Ngao", Vector2.zero, 0, sh
	else
		fl = Instance.new("ImageButton")
		fl.Name, fl.Size, fl.BackgroundColor3, fl.BackgroundTransparency, fl.AutoButtonColor, fl.Image = "Ngao", UDim2.fromOffset(44, 44), Color3.fromRGB(18, 18, 21), 0.08, false, gi or ""
		local u = Instance.new("UICorner")
		u.CornerRadius, u.Parent = UDim.new(0, 22), fl
		fl.Parent = sh
	end
	local fu = fl:FindFirstChildOfClass("UIScale")
	if not fu then
		fu = Instance.new("UIScale")
		fu.Parent = fl
	end
	local hz = se ~= nil
	local function hp()
		if hz and not (hu and hu.Parent and hu:IsDescendantOf(game)) and os.clock() - ht > 1 then
			ht = os.clock()
			local ok, b = pcall(function() return lp.PlayerGui.HUD.Frame.Buttons end)
			hu = ok and b or nil
			hb = hu and hu:FindFirstAncestorOfClass("ScreenGui")
		end
		local s, i = hz and hu and hu:FindFirstChild("Settings"), hz and hu and hu:FindFirstChild("Index")
		if s and i and hb then
			local u, g = s:FindFirstChildOfClass("UIScale"), sh.AbsolutePosition
			local z, c1 = s.AbsoluteSize / math.max(u and u.Scale or 1, 0.01), s.AbsolutePosition + s.AbsoluteSize / 2
			local p = c1 * 2 - (i.AbsolutePosition + i.AbsoluteSize / 2) - z / 2 - g
			fl.Size, fl.Position = UDim2.fromOffset(z.X, z.Y), UDim2.fromOffset(p.X, p.Y)
			fl.Visible = hb.Enabled and hu.Parent.Visible and hu.Visible and s.Visible
		else
			fl.Size, fl.Position, fl.Visible = UDim2.fromOffset(44, 44), UDim2.fromOffset(16, game:GetService("GuiService"):GetGuiInset().Y + 8), true
		end
	end
	hp()
	table.insert(cs, game:GetService("RunService").RenderStepped:Connect(hp))
	local fm, fv = fl:FindFirstChild("Image"), false
	local fk = fm and fm:FindFirstChild("Icon")
	local function fa(x, ro)
		tws:Create(fu, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Scale = x}):Play()
		if fk and ro then tws:Create(fk, TweenInfo.new(0.12, Enum.EasingStyle.Back), {Rotation = ro}):Play() end
	end
	table.insert(cs, fl.MouseEnter:Connect(function()
		fv = true
		fa(1.05, 5)
	end))
	table.insert(cs, fl.MouseLeave:Connect(function()
		fv = false
		fa(1, 0)
	end))
	table.insert(cs, fl.MouseButton1Down:Connect(function() fa(0.9) end))
	table.insert(cs, fl.MouseButton1Up:Connect(function() fa(fv and 1.05 or 1) end))
	table.insert(cs, fl.Activated:Connect(function() if gw.Main.Visible then gw:Hide() else gw:Show() end end))
	local function dn()
		for _, c in cs do c:Disconnect() end
		table.clear(cs)
		pcall(function() sh:Destroy() end)
		if ge.__FmNg == dn then ge.__FmNg = nil end
	end
	ge.__FmNg = dn
	table.insert(cs, gw.Gui.Destroying:Connect(dn))
end
local gt, ft = gw:Tab({Name = "General", Icon = "shrimp"}), nil

local xl: {[any]: any} = {}

local function xt()
	local d, r = pd(), lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
	local n, f, i = 0, ge.__FmF, ic()
	for _ in (d.Inventory or {}).Fishes or {} do n += 1 end
	local fu = md("Shared", "Lib", "FishStorageRules").GetState(d).isFull
	local p = r and `{math.floor(r.Position.X)}, {math.floor(r.Position.Y)}, {math.floor(r.Position.Z)}` or "None"
	return `[State] Island {i ~= "" and i or "Sea"} | Pos {p} | Coin {d.Coin or 0} | Satchel {n}{fu and " Full" or ""} | Quest {((d.Quest or {}).Current or {}).Id or ""} | Daily {((d.DailyQuest or {}).Active or {}).Template or ""} | Rod {d.RodEquip or "?"} | Farm {f and f.st or "Off"}{f and f.bu and " At Boss" or ""}`
end

local function cx(fn, ...)
	if not kv() then return false, "Key Check Failed: No Valid Key" end
	local r, dn
	task.spawn(function(...)
		local tb
		r = table.pack(xpcall(fn, function(x)
			tb = debug.traceback(tostring(x), 2)
			return x
		end, ...))
		if not r[1] and not xl[r[2]] and (tb ~= xl.lt or os.clock() - (xl.tt or 0) > 60) then
			xl.lt, xl.tt = tb, os.clock()
			zx(`[Error] {tb or r[2]}`)
			local ok, s = pcall(xt)
			if ok then zx(s) end
		end
		dn = true
	end, ...)
	repeat task.wait() until dn
	return table.unpack(r, 1, r.n)
end

local function fb(f)
	local s, fc = f.s, rv.FishingController
	for n, cb in {
		FishWaitingAck = function() s.wa = true end,
		FishFirstPullStart = function(id, _, _, lm, st) s.fp, s.id = {lm, st}, id end,
		FishFirstPullResult = function(m) s.pm = m end,
		FishReelStartAck = function(id) s.rl, s.id = true, s.id or id end,
		FishQTEPrompt = function(d) s.q = {d, os.clock() + 0.2 + math.random() * 0.15} end,
		FishQTECancel = function() s.q = nil end,
		FishSkillWindow = function(w) s.sw = os.clock() + w end,
		FishBossStun = function(w) s.bs = os.clock() + w end,
		FishCatchResult = function(ok, _, _, _, _, sp) s.cr = {ok, sp} end,
		FishReset = function(r) s.rr = r end,
	} do table.insert(f.cs, fc[n].OnClientEvent:Connect(cb)) end
	table.insert(f.cs, rv.BossRegionController.BossSpawnClaimed.OnClientEvent:Connect(function(v) s.bc = v == true end))
	table.insert(f.cs, md("Data", "Packets", "DailyQuestPackets").Completed.OnClientEvent:Connect(function(g, c)
		if f.dq() then f.nq = {Title = "Daily Quest", Text = `Daily Quest Done: +{g} Gem, +{c} Coin`} end
	end))
	table.insert(f.cs, rv.RodController.ReplicatedSkillCooldown.OnClientEvent:Connect(function(t)
		if typeof(t) ~= "table" then return end
		for k, v in t do
			if type(v) == "table" and type(v.phase) == "string" then s.cd[k] = {v.phase, os.clock() + (tonumber(v.remaining) or 0)} end
		end
	end))
	local tb
	local ok, e = xpcall(rn, function(x)
		tb = debug.traceback(tostring(x), 2)
		return x
	end, f)
	for _, c in f.cs do c:Disconnect() end
	local _, hr = lc()
	local hq = (f.hp or f.hf()) and hr and hr.Position.Y > -10 and ut(hr.Position)
	if hq and (hr.Position.Y < hq.Y - 4 or hr.Position.Y > 500) then
		mo(hq, 1e6)
		task.wait(0.1)
	end
	if cj then cj:Stop() end
	if not ok then
		zx(`[Auto Fish] Crash: {tb or e}`)
		xl[e] = true
		error(e, 0)
	end
end

local function fs()
	local o = ge.__FmF
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local f = {st = "Running", s = {cd = {}, sw = 0, bs = 0}, cs = {}, c = 0, rp = true, dn = false, bu = false, qx = {}, qw = {}, nq = false}
	function f.ao() return L.Flags.as == true end
	function f.au() return L.Flags.au == true end
	function f.qa() return L.Flags.qa == true end
	function f.qs() return qm[L.Flags.qs] end
	function f.ya() return L.Flags.ya == true end
	function f.ys() return L.Flags.ys or {} end
	function f.kp()
		local k = f.au() and qv(qn(f)) or {}
		for u in f.qa() and qv(qp(f)) or {} do k[u] = true end
		local d = pd()
		local cq = (d.Quest or {}).Current or {}
		for _, q in f.ya() and qk(d, f.ys()) or {} do
			for u in select(2, qc(q, d, cq.Id == q[1] and cq.Progress or {RequiredFish = 3})) do k[u] = true end
		end
		return k
	end
	function f.sr() return L.Flags.sr or {} end
	function f.fi() return ix[L.Flags.fi] end
	function f.ab() return L.Flags.ab == true end
	function f.hf() return L.Flags.hf == true end
	function f.dq() return L.Flags.dq == true end
	function f.bk() return bi[L.Flags.sb] or "truck" end
	function f.iw()
		local j, id, g, b, t, u, o = ge.__FmI, ix[L.Flags.si], ge.__FmG, ge.__FmR, ge.__FmT, ge.__FmU, ge.__FmO
		return g and not g.dn and (g.bz or g.rq and not f.bu) or b and not b.dn and (b.bz or b.rq and not f.bu) or j and not j.dn and (j.bz or id and ic() ~= id) or t and not t.dn and t.bz or u and not u.dn and (u.bz or u.rq and not f.bu) or o and not o.dn and (o.bz or o.rq and not f.bu) or false
	end
	ge.__FmF = f
	task.spawn(function()
		while not f.dn do
			local x = f.nq
			if x then
				f.nq = false
				gw:Notify(x)
			end
			task.wait(0.5)
		end
	end)
	local ok, e = cx(fb, f)
	if not ok then f.why = `Auto Fish Failed: {e}` end
	f.dn = true
	if ge.__FmF ~= f or not f.why then return end
	task.spawn(function()
		local sk, sv = pcall(xt)
		if sk then zx(sv) end
	end)
	gw:Notify({Title = "Auto Fish", Text = f.why})
	ft:Set(false)
end

local function ib(j)
	local n = 0
	while j.st == "Running" do
		local id, fm = ix[L.Flags.si], ge.__FmF
		if not id then j.why = "Auto Island Failed: No Island Selected"; return end
		if ic() == id then j.ar = true; return end
		if not (fm and not fm.dn and fm.bz or ge.__FmG and not ge.__FmG.dn and ge.__FmG.bz) then
			j.bz = true
			local ok, e = ti(j, id, bi[L.Flags.sb] or "truck")
			j.bz = false
			if ok then j.ar = true; return end
			n = j.st == "Running" and n + 1 or n
			if n >= 3 then j.why = `Auto Island Failed: {e}`; return end
		end
		task.wait(1)
	end
end

local it
local function is()
	local o = ge.__FmI
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", ar = false}
	ge.__FmI = j
	local ok, e = cx(ib, j)
	if not ok then j.why = `Auto Island Failed: {e}` end
	j.dn = true
	if ge.__FmI ~= j or not (j.why or j.ar) then return end
	if j.why then gw:Notify({Title = "Auto Island", Text = j.why}) end
	it:Set(false)
end

local nz, nl, nj = {
	{"Fish Merchant - Starter Island", "npc_fish_seller", "island_starter"},
	{"Rod Merchant - Starter Island", "npc_rod_shop", "island_starter"},
	{"Boat Merchant - Starter Island", "npc_car_merchant", "island_starter"},
	{"Skill Master", "npc_gacha_book", "island_starter"},
	{"Auras Dealer", "npc_gacha_aura", "island_starter"},
	{"Unit Summoner", "npc_gacha_unit", "island_starter"},
	{"Skill Market", "npc_premium_skill", "island_starter"},
	{"Daily Quests - Starter Island", "npc_daily_quest", "island_starter"},
	{"Jungle Island Guide", "npc_unlock_island_2", "island_jungle"},
	{"Fish Merchant - Jungle Island", "npc_fish_seller", "island_jungle"},
	{"Rod Merchant - Jungle Island", "npc_rod_shop", "island_jungle"},
	{"Boat Merchant - Jungle Island", "npc_car_merchant", "island_jungle"},
	{"Daily Quests - Jungle Island", "npc_daily_quest", "island_jungle"},
	{"Desert Island Guide", "npc_unlock_island_3", "island_desert"},
	{"Fish Merchant - Desert Island", "npc_fish_seller", "island_desert"},
	{"Rod Merchant - Desert Island", "npc_rod_shop", "island_desert"},
	{"Boat Merchant - Desert Island", "npc_car_merchant", "island_desert"},
	{"Daily Quests - Desert Island", "npc_daily_quest", "island_desert"},
	{"White Tiger Guardian", "npc_white_tiger", "island_desert"},
	{"Snow Island Guide", "npc_unlock_island_4", "island_snow"},
	{"Fish Merchant - Snow Island", "npc_fish_seller", "island_snow"},
	{"Rod Merchant - Snow Island", "npc_rod_shop", "island_snow"},
	{"Boat Merchant - Snow Island", "npc_car_merchant", "island_snow"},
	{"Daily Quests - Snow Island", "npc_daily_quest", "island_snow"},
	{"Phoenix Guardian", "npc_phoenix", "island_snow"},
	{"Taiji Master", "npc_taiji_hooking_art_v2", "island_snow"},
	{"Volcanic Island Guide", "npc_unlock_island_5", "island_volcano"},
	{"Fish Merchant - Volcanic Island", "npc_fish_seller", "island_volcano"},
	{"Boat Merchant - Volcanic Island", "npc_car_merchant", "island_volcano"},
	{"Daily Quests - Volcanic Island", "npc_daily_quest", "island_volcano"},
	{"Crimson Bead Craftsman", "npc_crimson_bead_rod", "island_volcano"},
	{"Bamboo Rod Craftsman", "npc_bamboo_rod", "island_volcano"},
	{"Azure Dragon Guardian", "npc_azure_dragon", "island_volcano"},
	{"Fossil Island Guide", "npc_unlock_island_6", "island_fossil"},
	{"Fish Merchant - Fossil Island", "npc_fish_seller", "island_fossil"},
	{"Daily Quests - Fossil Island", "npc_daily_quest", "island_fossil"},
	{"Heaven Piercer Craftsman", "npc_heaven_piercer_turtle_rod", "island_fossil"},
	{"Zen Staff Craftsman", "npc_zen_staff_rod", "island_fossil"},
	{"Dread Fish Craftsman", "npc_dread_fish_rod", "island_fossil"},
	{"Supreme King Guardian", "npc_supreme_king", "island_fossil"},
}, {}, {}
for _, v in nz do
	table.insert(nl, v[1])
	nj[v[1]] = v
end

local function ne(v)
	local w = workspace:FindFirstChild("World")
	local fo = w and w:FindFirstChild("Islands") and w.Islands:FindFirstChild(v[3])
	if not fo then return nil end
	for _, x in game:GetService("CollectionService"):GetTagged("Interactive") do
		if x:GetAttribute("InteractiveId") == v[2] and x:IsDescendantOf(fo) then
			return x:IsA("Model") and x:GetPivot().Position or x:IsA("BasePart") and x.Position or nil
		end
	end
	return nil
end

local function nw(j)
	local v, n = nj[L.Flags.sv], 0
	if not v then j.why = "Teleport Failed: No NPC Selected"; return end
	while j.st == "Running" do
		local fm = ge.__FmF
		if not (fm and not fm.dn and fm.bz or ge.__FmG and not ge.__FmG.dn and ge.__FmG.bz) then
			j.bz = true
			local ok, e = ti(j, v[3], bi[L.Flags.sb] or "truck")
			local c, r = lc()
			local np = ok and r and ne(v)
			if ok and r and not np then
				local g = rg(v[3])
				sq(g and Vector3.new(g.X, 2, g.Z) or r.Position, 10)
				np = ne(v)
			end
			if ok and not r then ok, e = nil, "No Character" end
			if ok and not np then ok, e = nil, "NPC Not Found" end
			if ok and j.st == "Running" then
				local sp = ap(c, np, r.Position, 0)
				ok, e = (v[2] == "npc_zen_staff_rod" and gf or go)(j, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
			end
			j.bz = false
			if ok and j.st == "Running" then j.ar = true; return end
			if e == "NPC Not Found" then j.why = `Teleport Failed: {e}`; return end
			n = j.st == "Running" and n + 1 or n
			if n >= 3 then j.why = `Teleport Failed: {e or "Move Failed"}`; return end
		end
		task.wait(1)
	end
end

local nk
local function ny()
	local o = ge.__FmT
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", ar = false}
	ge.__FmT = j
	local ok, e = cx(nw, j)
	if not ok then j.why = `Teleport Failed: {e}` end
	j.dn = true
	if ge.__FmT ~= j or not (j.why or j.ar) then return end
	if j.why then gw:Notify({Title = "Teleport", Text = j.why}) end
	nk:Set(false)
end

local ga, gm = {"Skill Master", "Ocean Chest", "Dragon Chest", "Aura", "Unit"}, {["Ocean Chest"] = "crate_ocean_chest", ["Dragon Chest"] = "crate_dragon_chest"}

local function gl(j)
	local sc = rv.SkillGachaController
	while j.st == "Running" do
		local k, cr = L.Flags.gr == "x10" and 10 or 1, gm[L.Flags.gk]
		local cc = cr and md("Data", "Config", "CrateConfig").GetCrate(cr)
		if cr and not cc then
			j.why = "Auto Roll Failed: No Chest"
			return
		end
		local ag, ut = L.Flags.gk == "Aura" and md("Data", "Config", "AuraGachaConfig").Pull, L.Flags.gk == "Unit" and rv.UnitGachaController
		local nm = cc and cc.DisplayName or ag and "Aura" or ut and "Unit" or "Skill Master"
		local function ca()
			local d = pd()
			if cc then return (((d.CrateGacha or {}).Credits or {})[cr] or 0) >= k or ((cc.Currency == "Coin" and d.Coin or d.Gem) or 0) >= (cc.Prices[k] or math.huge) end
			if ag then return ((d.AuraGacha or {}).Credits or 0) >= k or (d.Gem or 0) >= math.ceil(ag.CostGem * k * (ag.BulkDiscount[k] or 1)) end
			local q = (ut or sc).GetQuote:Fire(k)
			if type(q) ~= "table" or not q.ok then return nil, type(q) == "table" and q.reason or "No Quote" end
			if ut and (q.storage_available or 0) < k then return nil, "Storage Full" end
			return (d.Coin or 0) >= q.coin_cost
		end
		local af, ae = ca()
		if ae then
			j.why = `Auto Roll Failed: {ae}`
			return
		end
		if not af then
			task.wait(5)
			continue
		end
		local fm = ge.__FmF
		j.rq = true
		while j.st == "Running" and fm and not fm.dn and (fm.bz or fm.bu) do task.wait(0.5) end
		if j.st ~= "Running" then return end
		j.bz, j.rq = true, false
		local r
		while j.st == "Running" do
			local rc = ut or not (cc or ag) and sc
			if rc then rc._requestId = (tonumber(rc._requestId) or 0) + 1 end
			r = cc and rv.CrateGachaController.OpenPacket:Fire(cr, k) or ag and rv.AuraGachaController.Pull:Fire(k) or ut and ut.Pull:Fire(k, ut._requestId) or not (cc or ag or ut) and sc.Pull:Fire("Coin", k, sc._requestId)
			for _ = 1, rc and (type(r) ~= "table" or r.reason == "pending") and 5 or 0 do
				task.wait(3)
				local x = rc.Recover:Fire(rc._requestId)
				if type(x) == "table" and x.reason ~= "pending" and x.reason ~= "none" then r = x; break end
			end
			if type(r) ~= "table" or not r.ok then break end
			local ct, t = md("Data", "Catalog"), {}
			for _, x in r.results or {} do
				local sv = cc and ct.RodSkin.GetById(x.rod_skin_id) or ag and ct.Aura.GetById(x.aura_id) or ut and ct.Unit.GetById(x.unit_id) or not (cc or ag or ut) and ct.Skill.GetById(x.skill_id)
				table.insert(t, `{sv and sv.name or x.rod_skin_id or x.aura_id or x.unit_id or x.skill_id} ({x.rarity})`)
			end
			j.nt = {Title = nm, Text = table.concat(t, ", ")}
			task.wait(1)
			if not ca() then break end
		end
		j.bz = false
		if j.st ~= "Running" then return end
		if type(r) ~= "table" then
			j.why = "Auto Roll Failed: No Response"
			return
		end
		if not r.ok and r.reason ~= "insufficient_coin" and r.reason ~= "insufficient_gem" then
			j.why = `Auto Roll Failed: {r.reason}`
			return
		end
		task.wait(1)
	end
end

local gs
local function gg()
	local o = ge.__FmG
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", dn = false, nt = false, bz = false, rq = false}
	ge.__FmG = j
	task.spawn(function()
		while not j.dn do
			local x = j.nt
			if x then
				j.nt = false
				gw:Notify(x)
			end
			task.wait(0.5)
		end
	end)
	local ok, e = cx(gl, j)
	if not ok then j.why = `Auto Roll Failed: {e}` end
	j.dn = true
	if ge.__FmG ~= j or not j.why then return end
	gw:Notify({Title = "Auto Roll", Text = j.why})
	gs:Set(false)
end

local mz, mi = {}, {}
pcall(function()
	local ct, t = md("Data", "Catalog"), {}
	for id, v in md("Data", "Config", "SkillMarketConfig").Listings do
		local x = ct.Skill.GetById(id)
		table.insert(t, {x and x.name or id, id, v.price or 0})
	end
	table.sort(t, function(a, b) return a[3] < b[3] or a[3] == b[3] and a[1] < b[1] end)
	for _, x in t do
		table.insert(mz, x[1])
		mi[x[1]] = x[2]
	end
end)

local function ml(j)
	local rp, mc = game:GetService("ReplicatedStorage"), rv.SkillMarketController
	local cf, ba, en, sx = md("Data", "Config", "SkillMarketConfig"), md("Utils", "skillBookAvailability"), md("Data", "Config", "EntitlementConfig"), {}
	while j.st == "Running" do
		local st, ea = rp:GetAttribute("SkillMarketStock"), rp:GetAttribute("SkillMarketEndsAt")
		local sl, kl = type(ea) == "number" and ea - cf.IntervalSeconds or 0, type(st) == "string" and st:split(",") or {}
		for _, nm in L.Flags.mm or {} do
			if j.st ~= "Running" then return end
			local id, d = mi[nm], pd()
			local sm = type(d.SkillMarket) == "table" and d.SkillMarket or {}
			if id and table.find(kl, id) and not sx[`{sl}{id}`] and not (sm.SlotStart == sl and (sm.Bought or {})[id]) and (d.Gem or 0) >= (cf.Price(id) or math.huge) and ba.GetCounts(d, id).owned < en.BookStackCap(d) then
				local r = mc.BuyDirect:Fire(id)
				if type(r) ~= "table" then
					j.why = "Auto Buy Skill Market Failed: No Response"
					return
				end
				if r.reason == "ok" then
					j.nt = {Title = "Skill Market", Text = `Bought {nm}`}
				elseif r.reason == "bought" or r.reason == "out_of_stock" or r.reason == "full" then
					sx[`{sl}{id}`] = true
				elseif r.reason ~= "insufficient" and r.reason ~= "busy" then
					j.why = `Auto Buy Skill Market Failed: {r.reason}`
					return
				end
				task.wait(1)
			end
		end
		task.wait(5)
	end
end

local function xu(j)
	local uc, uo, ct = rv.UnitController, md("Shared", "Units", "UnitCore"), md("Data", "Catalog")
	while j.st == "Running" do
		local d, rr, q = pd(), {}, {}
		for _, r in L.Flags.ur or {} do rr[r] = true end
		for id, u in type(d.Units) == "table" and type(d.Units.Owned) == "table" and d.Units.Owned or {} do
			if type(u) == "table" and rr[u.Rarity] and u.locked ~= true and not uo.IsEquipped(d.Units, id) then table.insert(q, id) end
		end
		if #q > 0 then
			local fm = ge.__FmF
			j.rq = true
			while j.st == "Running" and fm and not fm.dn and (fm.bz or fm.bu) do task.wait(0.5) end
			if j.st ~= "Running" then return end
			j.bz, j.rq = true, false
			local t = {}
			for _, id in q do
				if j.st ~= "Running" then break end
				local u = (pd().Units.Owned or {})[id]
				if u and u.locked ~= true and not uo.IsEquipped(pd().Units, id) then
					local ok, e = uc:RemoveUnit(id)
					if ok ~= true then
						if e == "fishing_locked" then break end
						if e ~= "locked" and e ~= "equipped" then
							j.bz = false
							j.why = `Auto Delete Unit Failed: {e or "No Response"}`
							return
						end
					else
						local x = ct.Unit.GetById(u.UnitId)
						table.insert(t, `{x and x.name or u.UnitId} ({u.Rarity})`)
						task.wait(0.5)
					end
				end
			end
			j.bz = false
			if #t > 0 then j.nt = {Title = "Unit", Text = `Deleted {table.concat(t, ", ")}`} end
		end
		task.wait(5)
	end
end

local xk
local function xy()
	local o = ge.__FmU
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", dn = false, nt = false, bz = false, rq = false}
	ge.__FmU = j
	task.spawn(function()
		while not j.dn do
			local x = j.nt
			if x then
				j.nt = false
				gw:Notify(x)
			end
			task.wait(0.5)
		end
	end)
	local ok, e = cx(xu, j)
	if not ok then j.why = `Auto Delete Unit Failed: {e}` end
	j.dn = true
	if ge.__FmU ~= j or not j.why then return end
	gw:Notify({Title = "Unit", Text = j.why})
	xk:Set(false)
end

local function xo(j)
	local ec, ct = rv.EquipmentController, md("Data", "Catalog")
	local function al(d, k)
		local a = type(d.Inventory) == "table" and type(d.Inventory.Auras) == "table" and d.Inventory.Auras[k]
		local c = type(a) == "table" and type(a.catalogId) == "string" and ct.Aura.GetById(a.catalogId)
		return c and a.locked ~= true and d.AuraEquip ~= k and c or nil
	end
	while j.st == "Running" do
		local d, rr, q = pd(), {}, {}
		for _, r in L.Flags.xr or {} do rr[r] = true end
		for k in type(d.Inventory) == "table" and type(d.Inventory.Auras) == "table" and d.Inventory.Auras or {} do
			local c = al(d, k)
			if c and rr[c.rarity] then table.insert(q, k) end
		end
		if #q > 0 then
			local fm = ge.__FmF
			j.rq = true
			while j.st == "Running" and fm and not fm.dn and (fm.bz or fm.bu) do task.wait(0.5) end
			if j.st ~= "Running" then return end
			j.bz, j.rq = true, false
			local t = {}
			for _, k in q do
				if j.st ~= "Running" then break end
				local c = al(pd(), k)
				if c and rr[c.rarity] then
					local ok = ec.EquipmentRemove:Fire("aura", k)
					if ok ~= true then
						j.bz = false
						j.why = ok == false and "Auto Delete Aura Failed: Remove Refused" or "Auto Delete Aura Failed: No Response"
						return
					end
					table.insert(t, `{c.name or c.id} ({c.rarity})`)
					task.wait(0.5)
				end
			end
			j.bz = false
			if #t > 0 then j.nt = {Title = "Aura", Text = `Deleted {table.concat(t, ", ")}`} end
		end
		task.wait(5)
	end
end

local xz
local function xw()
	local o = ge.__FmO
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", dn = false, nt = false, bz = false, rq = false}
	ge.__FmO = j
	task.spawn(function()
		while not j.dn do
			local x = j.nt
			if x then
				j.nt = false
				gw:Notify(x)
			end
			task.wait(0.5)
		end
	end)
	local ok, e = cx(xo, j)
	if not ok then j.why = `Auto Delete Aura Failed: {e}` end
	j.dn = true
	if ge.__FmO ~= j or not j.why then return end
	gw:Notify({Title = "Aura", Text = j.why})
	xz:Set(false)
end

local mk
local function mg()
	local o = ge.__FmM
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", dn = false, nt = false}
	ge.__FmM = j
	task.spawn(function()
		while not j.dn do
			local x = j.nt
			if x then
				j.nt = false
				gw:Notify(x)
			end
			task.wait(0.5)
		end
	end)
	local ok, e = cx(ml, j)
	if not ok then j.why = `Auto Buy Skill Market Failed: {e}` end
	j.dn = true
	if ge.__FmM ~= j or not j.why then return end
	gw:Notify({Title = "Skill Market", Text = j.why})
	mk:Set(false)
end

local rz, ri = {}, {}
for _, x in {{"Stone Rod", "stone_rod"}, {"Iron Rod", "iron_rod"}, {"Golden Rod", "golden_rod"}, {"Steel Rod", "steel_rod"}, {"Golden Steel Rod", "golden_steel_rod"}, {"Diamond Steel Rod", "diamond_steel_rod"}, {"Taoist Rod", "taoist_rod"}, {"Legacy Rod", "legacy_rod"}} do
	table.insert(rz, x[1])
	ri[x[1]] = x[2]
end

local function rm(id)
	for k = 1, 2 do
		for _, x in game:GetService("CollectionService"):GetTagged("Interactive") do
			if x:GetAttribute("InteractiveId") == "npc_rod_shop" and x:GetAttribute("IslandId") == id then
				local q = x:IsA("Model") and x:GetPivot().Position or x:IsA("BasePart") and x.Position
				if q then return q end
			end
		end
		local g = k == 1 and rg(id)
		if g then sq(Vector3.new(g.X, 2, g.Z), 10) end
	end
	return nil
end

local function ru(j, id, il)
	local ok, e = ti(j, il, bi[L.Flags.sb] or "truck")
	if not ok then return nil, e or j.st == "Running" and "Move Failed" or nil end
	local c, rt = lc()
	if not rt then return nil, "No Character" end
	local np = rm(il)
	if not np then return nil, "No Rod Merchant" end
	local sp = ap(c, np, rt.Position)
	ok, e = go(j, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
	if not ok then return nil, e or j.st == "Running" and "Move Failed" or nil end
	if j.st ~= "Running" then return nil end
	local r = rv.FishingRodShopController.PurchaseRod:Fire(id)
	if r == nil then return nil, "No Response" end
	if r ~= true then return nil, "Purchase Refused" end
	j.by = true
	if rv.EquipmentsController.EquipmentEquip:Fire("rod", id) ~= true then return nil, "Equip Refused" end
	local dl = os.clock() + 5
	repeat task.wait(0.1) until pd().RodEquip == id or os.clock() > dl
	if pd().RodEquip ~= id then return nil, "Equip Timeout" end
	return true
end

local function rj(j)
	local nm = L.Flags.rd
	local id = ri[nm]
	if not id then j.why = "Auto Buy Rod Failed: No Rod Selected"; return end
	local cf = md("Data", "Config", "RodShopConfig")[id]
	if not cf then j.why = "Auto Buy Rod Failed: No Price"; return end
	while j.st == "Running" do
		local d = pd()
		if d.Rods and d.Rods[id] then j.why = "Auto Buy Rod Failed: Already Owned"; return end
		if not ul(cf.islandId) then j.why = "Auto Buy Rod Failed: Island Locked"; return end
		if (d.Coin or 0) < cf.price then
			task.wait(5)
			continue
		end
		local fm = ge.__FmF
		j.rq = true
		while j.st == "Running" and (fm and not fm.dn and (fm.bz or fm.bu) or ge.__FmG and not ge.__FmG.dn and ge.__FmG.bz or ge.__FmI and not ge.__FmI.dn or ge.__FmT and not ge.__FmT.dn) do task.wait(0.5) end
		if j.st ~= "Running" then return end
		j.bz, j.rq = true, false
		local _, rt = lc()
		if not rt then j.why = "Auto Buy Rod Failed: No Character"; return end
		local o, oi = rt.CFrame, ic()
		local ok, e = ru(j, id, cf.islandId)
		local hk, he = true, nil
		if j.st == "Running" and oi ~= "" and ic() ~= oi then hk, he = ti(j, oi, bi[L.Flags.sb] or "truck") end
		if hk and j.st == "Running" and ic() == oi then hk, he = go(j, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
		j.bz = false
		if j.st ~= "Running" then return end
		local t = ok and `Bought {nm}` or j.by and `Bought {nm}, {e}` or `Auto Buy Rod Failed: {e}`
		j.why = hk and t or `{t}, Return Failed: {he or "Move Failed"}`
		return
	end
end

local rk
local function rh()
	local o = ge.__FmR
	if o then
		o.st = "Stopped"
		local dl = os.clock() + 5
		repeat task.wait(0.1) until o.dn or os.clock() > dl
	end
	local j = {st = "Running", dn = false, bz = false, rq = false, by = false}
	ge.__FmR = j
	local ok, e = cx(rj, j)
	if not ok then j.why = `Auto Buy Rod Failed: {e}` end
	j.dn = true
	if ge.__FmR ~= j or not j.why then return end
	gw:Notify({Title = "Rod Merchant", Text = j.why})
	rk:Set(false)
end

gt:Section({Name = "Farm"})
do
	local bl, tk = gt:Label({Text = "Next Boss: --"}), {}
	ge.__FmL = tk
	task.spawn(function()
		local ok, en, iv = cx(function()
			local d, n = md("Data", "Catalog", "Fish"), {}
			for k, v in md("Data", "Catalog", "Boss").Pools do
				if v[1] and d[v[1].id] then n[k] = d[v[1].id].name end
			end
			return n, md("Data", "Catalog", "Event").Constant.OCCURRENCE_INTERVAL
		end)
		if not ok or type(iv) ~= "number" then
			bl:Set("Next Boss: Unknown")
			return
		end
		while ge.__FmL == tk do
			local t, ek, ex = workspace:GetServerTimeNow(), nil, 0
			local ev = rv.EventController and rv.EventController._active_events
			for k, v in type(ev) == "table" and ev or {} do
				if en[k] then ek, ex = k, math.max(v.expire_at or 0, v.admin_override_expire_at or 0) end
			end
			local lf = math.max(0, math.floor((ek and ex or (t // iv + 1) * iv) - t))
			bl:Set(ek and `Boss Up: {en[ek]} - {lf // 60}:{string.format("%02d", lf % 60)} Left` or `Next Boss: {os.date("%H:%M", math.floor((t // iv + 1) * iv))} - In {lf // 60}:{string.format("%02d", lf % 60)}`)
			task.wait(1)
		end
	end)
end
gt:Dropdown({Name = "Select Farm Island", Options = iz, Flag = "fi"})
ft = gt:Toggle({Name = "Auto Fish", Flag = "af", Callback = function(v)
	local o = ge.__FmF
	if v then
		fs()
	elseif o then
		if o.bz and (o.s.fp or o.s.rl) and not (o.s.cr or o.s.rr) then o.fq = true else o.st = "Stopped" end
	end
end})
gt:Toggle({Name = "Auto Boss", Flag = "ab"})

gt:Section({Name = "Quest"})
gt:Dropdown({Name = "Select Rod Quest", Options = qz, Flag = "qs"})
gt:Toggle({Name = "Auto Rod Quest", Flag = "qa"})
gt:Toggle({Name = "Auto Unlock Island", Flag = "au"})
gt:Toggle({Name = "Auto Daily Quest", Flag = "dq"})

gt:Section({Name = "Soul"})
gt:Dropdown({Name = "Select Soul Quest", Options = qgz, Default = {}, Multi = true, Flag = "ys"})
gt:Toggle({Name = "Auto Soul Quest", Flag = "ya"})

gt:Section({Name = "Sell"})
gt:Dropdown({Name = "Sell Rarity", Options = ra, Default = {}, Multi = true, Flag = "sr"})
gt:Toggle({Name = "Auto Sell", Flag = "as"})

local tz, qtx = gw:Tab({Name = "Status", Icon = "trophy"}), `Iq{game:GetService("HttpService"):GenerateGUID(false)}`
tz:Section({Name = "Island Quest"})
local iql = tz:Label({Text = qtx})
local rtx = `Rq{game:GetService("HttpService"):GenerateGUID(false)}`
tz:Section({Name = "Rod Quest"})
local rql = tz:Label({Text = rtx})
local ytx = `Yq{game:GetService("HttpService"):GenerateGUID(false)}`
tz:Section({Name = "Soul Quest"})
local yql = tz:Label({Text = ytx})
tz:Section({Name = "Skill Market"})
local kql = tz:Label({Text = "Loading..."})

local tm = gw:Tab({Name = "Misc", Icon = "four-squares-grid"})
tm:Section({Name = "Unit"})
tm:Dropdown({Name = "Delete Rarity", Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}, Default = {}, Multi = true, Flag = "ur"})
xk = tm:Toggle({Name = "Auto Delete Unit", Flag = "ua", Callback = function(v)
	if v then xy() elseif ge.__FmU then ge.__FmU.st = "Stopped" end
end})
tm:Section({Name = "Aura"})
tm:Dropdown({Name = "Delete Rarity", Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Divine"}, Default = {}, Multi = true, Flag = "xr"})
xz = tm:Toggle({Name = "Auto Delete Aura", Flag = "xa", Callback = function(v)
	if v then xw() elseif ge.__FmO then ge.__FmO.st = "Stopped" end
end})

local tq = gw:Tab({Name = "Shop", Icon = "shopping-basket"})
tq:Section({Name = "Gacha"})
tq:Dropdown({Name = "Select Gacha", Options = ga, Default = "Skill Master", Flag = "gk"})
tq:Dropdown({Name = "Select Roll", Options = {"x1", "x10"}, Default = "x1", Flag = "gr"})
gs = tq:Toggle({Name = "Auto Roll", Flag = "gs", Callback = function(v)
	if v then gg() elseif ge.__FmG then ge.__FmG.st = "Stopped" end
end})
tq:Section({Name = "Skill Market"})
tq:Dropdown({Name = "Select Skills", Options = mz, Default = {}, Multi = true, Flag = "mm"})
mk = tq:Toggle({Name = "Auto Buy Skill Market", Flag = "ma", Callback = function(v)
	if v then mg() elseif ge.__FmM then ge.__FmM.st = "Stopped" end
end})
tq:Section({Name = "Rod"})
tq:Dropdown({Name = "Select Rod", Options = rz, Flag = "rd"})
rk = tq:Toggle({Name = "Auto Buy Rod", Flag = "rb", Callback = function(v)
	if v then
		if it then it:Set(false) end
		if nk then nk:Set(false) end
		rh()
	elseif ge.__FmR then ge.__FmR.st = "Stopped" end
end})

local tl = gw:Tab({Name = "Teleport", Icon = "person-teleport"})
tl:Section({Name = "Island"})
tl:Dropdown({Name = "Select Island", Options = iz, Flag = "si"})
it = tl:Toggle({Name = "Auto Island", Flag = "ai", Callback = function(v)
	if v then
		if rk then rk:Set(false) end
		if nk then nk:Set(false) end
		is()
	elseif ge.__FmI then ge.__FmI.st = "Stopped" end
end})
tl:Section({Name = "NPC"})
tl:Dropdown({Name = "Select NPC", Options = nl, Flag = "sv"})
nk = tl:Toggle({Name = "Teleport To NPC", Flag = "tv", Callback = function(v)
	if v then
		if it then it:Set(false) end
		if rk then rk:Set(false) end
		ny()
	elseif ge.__FmT then ge.__FmT.st = "Stopped" end
end})

local ez, eo = {cs = {}, o = {}, w = {}}, nil
do
	local ov = ge.__FmV
	if ov then
		ov.w = {}
		if ov.rw then pcall(ov.rw) end
		for _, c in ov.cs do c:Disconnect() end
	end
	ge.__FmV = ez
	for _, n in {"RodSkinId", "AuraCatalogId"} do
		if ov then ez.o[n] = ov.o[n] else ez.o[n] = lp:GetAttribute(n) end
		table.insert(ez.cs, lp:GetAttributeChangedSignal(n):Connect(function()
			local v = lp:GetAttribute(n)
			if v == ez.w[n] then return end
			ez.o[n] = v
			if ez.w[n] then lp:SetAttribute(n, ez.w[n]) end
		end))
	end
	local et, an = 0, "AuraCatalogId"
	table.insert(ez.cs, game:GetService("RunService").Heartbeat:Connect(function()
		if not ez.w[an] or os.clock() < et then return end
		et = os.clock() + 0.25
		local c = lp.Character
		local fx = c and c:FindFirstChild("ClientAuraEffect")
		for _, d in fx and fx:GetDescendants() or {} do
			if d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("Light") or d:IsA("Highlight") then
				if not d.Enabled then d.Enabled = true end
			elseif d:IsA("BasePart") and d.LocalTransparencyModifier ~= 0 then
				d.LocalTransparencyModifier = 0
			end
		end
	end))
	local sn, ac, ah, zo = "RodSkinId", {}, nil, {}
	local function rw(t)
		local sk, df, nm = ez.w[sn], eo and eo[3], ah
		local r = sk and df and nm and df[1](t.Name, df[2][sk])
		if not r or r.id == t.Animation.AnimationId then return end
		local n = ac[r.id]
		if not n then
			local an2 = Instance.new("Animation")
			an2.AnimationId = r.id
			local ok, x = pcall(nm.LoadAnimation, nm, an2)
			if not ok or not x then return end
			n, ac[r.id] = x, x
		end
		n.Priority, n.Looped = r.priority, r.looped
		t:AdjustWeight(0.001, 0)
		zo[t] = n
		n:Play(r.fadeTime, 1, r.playbackSpeed)
		local c1
		c1 = t.Stopped:Connect(function()
			c1:Disconnect()
			if zo[t] ~= n then return end
			zo[t] = nil
			for _, n2 in zo do
				if n2 == n then return end
			end
			n:Stop(r.fadeTime)
		end)
	end
	local function hk2(c)
		local h = c and c:WaitForChild("Humanoid", 10)
		local nm = h and h:WaitForChild("Animator", 10)
		if not nm or ge.__FmV ~= ez then return end
		ah, ac, zo = nm, {}, {}
		table.insert(ez.cs, nm.AnimationPlayed:Connect(rw))
	end
	table.insert(ez.cs, lp.CharacterAdded:Connect(hk2))
	task.spawn(hk2, lp.Character)
	ez.rw = function()
		for t, n in zo do
			pcall(function() n:Stop(0.15); t:AdjustWeight(1, 0.15) end)
		end
		zo = {}
		for _, t in ah and ah:GetPlayingAnimationTracks() or {} do
			if t.WeightTarget > 0 then rw(t) end
		end
	end
	local ok, a, b, rz2 = cx(function()
		local ct, rk, sa2 = md("Data", "Catalog"), {}, {}
		for _, v in ct.RodSkin.GetAll() do
			if type(v) == "table" and type(v.id) == "string" then sa2[v.id] = v.animations end
		end
		for i, r in ra do rk[r] = i end
		local function bl(t)
			local l, m, n = {}, {}, {"Default"}
			for _, v in t.GetAll() do
				if type(v) == "table" and type(v.name) == "string" and type(v.id) == "string" then table.insert(l, v); m[v.name] = v.id end
			end
			table.sort(l, function(x, y)
				local p, q = rk[x.rarity] or 0, rk[y.rarity] or 0
				if p ~= q then return p > q end
				return x.name < y.name
			end)
			for _, v in l do table.insert(n, v.name) end
			return {n, m}
		end
		return bl(ct.RodSkin), bl(ct.Aura), {md("Data", "Config", "RodAnimationConfig").Resolve, sa2}
	end)
	if ok then eo = {a, b, rz2} else gw:Notify({Title = "Visual", Text = "Effect List Failed: Catalog Error"}) end
end

local function ep(n, id)
	ez.w[n] = id
	lp:SetAttribute(n, id or ez.o[n])
	if ez.rw then ez.rw() end
end

if eo then
	local tv = gw:Tab({Name = "Visual", Icon = "eye"})
	tv:Section({Name = "Effect"})
	tv:Dropdown({Name = "Rod Skin", Options = eo[1][1], Default = "Default", Flag = "es", Callback = function(v) ep("RodSkinId", eo[1][2][v]) end})
	tv:Dropdown({Name = "Aura", Options = eo[2][1], Default = "Default", Flag = "ea", Callback = function(v) ep("AuraCatalogId", eo[2][2][v]) end})
end

local function zp()
	if ge.__FmP then return nil, "Already On" end
	ge.__FmP = true
	local sc, lt, tr, oc = rv.SettingsController, game:GetService("Lighting"), workspace.Terrain, workspace:FindFirstChild("Ocean")
	local ul = true
	for k, v in {ultra_low_graphic = true, show_others_vfx = false, show_my_vfx = false, show_cutscenes = false, show_damage_indicator = false, camera_shaking = false, auto_fishing_hide_vfx = true} do
		if not (sc and sc._SetLocal and pcall(sc._SetLocal, sc, k, v)) then ul = false end
	end
	local function ko(d)
		d.Enabled = false
		d:GetPropertyChangedSignal("Enabled"):Connect(function() if d.Enabled then d.Enabled = false end end)
	end
	local function lf()
		if lt.GlobalShadows then lt.GlobalShadows = false end
		if lt.FogEnd < 1e9 then lt.FogEnd = 1e9 end
	end
	local function kx(d)
		if d:IsA("PostEffect") then
			ko(d)
		elseif d:IsA("Atmosphere") then
			local function z() if d.Density ~= 0 or d.Haze ~= 0 or d.Glare ~= 0 then d.Density, d.Haze, d.Glare = 0, 0, 0 end end
			z()
			d.Changed:Connect(z)
		end
	end
	local function px(d)
		if d == tr or oc and d:IsDescendantOf(oc) then return end
		if d:IsA("ParticleEmitter") then
			d.Lifetime = NumberRange.new(0)
			ko(d)
		elseif d:IsA("Beam") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Light") or d:IsA("Highlight") then
			ko(d)
		elseif d:IsA("Decal") then
			d.Transparency = 1
		elseif d:IsA("SurfaceAppearance") then
			task.defer(pcall, d.Destroy, d)
		elseif d:IsA("BasePart") and d.Material ~= Enum.Material.Water then
			d.Material, d.Reflectance, d.CastShadow = Enum.Material.SmoothPlastic, 0, false
		end
	end
	lf()
	lt:GetPropertyChangedSignal("GlobalShadows"):Connect(lf)
	lt:GetPropertyChangedSignal("FogEnd"):Connect(lf)
	for _, d in lt:GetChildren() do pcall(kx, d) end
	lt.ChildAdded:Connect(function(d) pcall(kx, d) end)
	pcall(function() tr.WaterWaveSize, tr.WaterWaveSpeed, tr.WaterReflectance = 0, 0, 0 end)
	workspace.DescendantAdded:Connect(function(d) pcall(px, d) end)
	task.spawn(function()
		for i, d in workspace:GetDescendants() do
			pcall(px, d)
			if i % 2000 == 0 then task.wait() end
		end
	end)
	local rn, ui = game:GetService("RunService"), game:GetService("UserInputService")
	ui.WindowFocusReleased:Connect(function() pcall(rn.Set3dRenderingEnabled, rn, false) end)
	ui.WindowFocused:Connect(function() pcall(rn.Set3dRenderingEnabled, rn, true) end)
	local function sm(d)
		if not d:IsA("Sound") then return end
		d.Volume = 0
		d:GetPropertyChangedSignal("Volume"):Connect(function() if d.Volume ~= 0 then d.Volume = 0 end end)
	end
	game.DescendantAdded:Connect(function(d) pcall(sm, d) end)
	task.spawn(function()
		for i, d in game:GetDescendants() do
			pcall(sm, d)
			if i % 2000 == 0 then task.wait() end
		end
	end)
	local function ax(d)
		if d:IsA("Accoutrement") or d:IsA("Clothing") or d:IsA("ShirtGraphic") or d:IsA("CharacterMesh") then task.defer(pcall, d.Destroy, d) end
	end
	local function cr(c)
		for _, d in c:GetDescendants() do pcall(ax, d) end
		c.DescendantAdded:Connect(function(d) pcall(ax, d) end)
	end
	local function pa(p)
		if p == lp then return end
		if p.Character then cr(p.Character) end
		p.CharacterAdded:Connect(cr)
	end
	for _, p in ps:GetPlayers() do pa(p) end
	ps.PlayerAdded:Connect(pa)
	if not ul then return nil, "Game Settings Failed: Settings Error" end
	return true
end

local ts = gw:Tab({Name = "Setting", Icon = "gear"})
ts:Section({Name = "Game"})
ts:Dropdown({Name = "Select Boat", Options = bn, Default = "Truck", Flag = "sb"})
ts:Toggle({Name = "Instant Teleport", Default = true, Flag = "wb", Callback = function(v) wb.on = v == true end})
ts:Toggle({Name = "Safe", Flag = "zy", Callback = function(v) zy.on = v == true end})
ts:Toggle({Name = "Hidden Fishing", Flag = "hf"})
local jr = false
pcall(function() ge.__FmJ:Disconnect() end)
ge.__FmJ = (game:GetService("GuiService") :: any).ErrorMessageChanged:Connect(function(m)
	if jr or type(m) ~= "string" or m == "" then return end
	if os.clock() - zy.hp < 30 then
		zx(`[Rejoin] Ignored During Hop: {m}`, true)
		return
	end
	jr = true
	zx(`[Rejoin] Kicked: {m}`, true)
	task.spawn(function()
		local tp = game:GetService("TeleportService")
		while true do
			pcall(tp.Teleport, tp, game.PlaceId, lp)
			task.wait(10)
		end
	end)
end)
local zl = {}
ge.__FmZ = zl
task.spawn(function()
	while ge.__FmZ == zl do
		task.wait(0.5)
		local sk, se = pcall(function()
			local f, ok, w = ge.__FmF, true, false
			if zy.on and os.clock() >= zy.nt then ok, w = cx(zw) end
			if not (ok and w) then
				zy.rq = false
			elseif f and not f.dn and f.st == "Running" then
				zy.rq = true
			else
				gw:Notify({Title = "Safe", Text = "Player On Island, Hopping"})
				local _, e = zh()
				if e then zx(`[Safe] {e}`, true) end
				gw:Notify({Title = "Safe", Text = e})
			end
		end)
		if not sk then zx(`[Safe] Loop Error: {se}`) end
	end
end)
ts:Button({Name = "FPS Booster", Callback = function()
	local ok, e = zp()
	gw:Notify({Title = "FPS Booster", Text = ok and "On Until Rejoin" or e})
end})

local rx = "Ngao-Gaming Hub"

local function nt()
	for _, c in ge.__FmN or {} do c:Disconnect() end
	local cs, tx, gr = {}, rx, {}
	ge.__FmN = cs
	local function hk(m)
		task.spawn(function()
			local p = m:WaitForChild("PlrName", 10)
			local s = p and p:WaitForChild("Surface", 10)
			local l = s and s:WaitForChild("Label", 10)
			if not l or ge.__FmN ~= cs then return end
			if m.Name == lp.Name then
				local o = `@{lp.Name}`
				if l.Text ~= o then l.Text = o end
				if l:FindFirstChild("Rb") then l.Rb:Destroy() end
				local lo = l
				lo.TextTransparency, lo.TextStrokeTransparency = 1, 1
				for _, n in {"TextTransparency", "TextStrokeTransparency"} do
					table.insert(cs, lo:GetPropertyChangedSignal(n):Connect(function() if lo[n] ~= 1 then lo[n] = 1 end end))
				end
				local fd = l:FindFirstChild("Fade")
				if fd and fd:IsA("GuiObject") then
					fd.Visible = false
					table.insert(cs, fd:GetPropertyChangedSignal("Visible"):Connect(function() if fd.Visible then fd.Visible = false end end))
				end
				if s:FindFirstChild("Rx") then s.Rx:Destroy() end
				local tp = game:GetService("ReplicatedStorage"):FindFirstChild("Assets")
				for _, n in {"UIs", "Prefabs", "Nametag", "PlrName", "Surface", "Label"} do tp = tp and tp:FindFirstChild(n) end
				local cl = (tp and tp:IsA("TextLabel") and tp or l):Clone()
				for _, x in cl:GetChildren() do
					if x.Name == "Rb" then x:Destroy() elseif x.Name == "Fade" and x:IsA("GuiObject") then x.Visible = true end
				end
				cl.Name, cl.TextTransparency, cl.TextStrokeTransparency, cl.Parent = "Rx", 0, 0, s
				l = cl
			end
			l.Text = tx
			table.insert(cs, l:GetPropertyChangedSignal("Text"):Connect(function() if l.Text ~= tx then l.Text = tx end end))
			local g = l:FindFirstChild("Rb") or Instance.new("UIGradient")
			g.Name, g.Parent = "Rb", l
			gr[g] = true
		end)
	end
	local nf = workspace:FindFirstChild("Nametags")
	if not nf then return end
	table.insert(cs, game:GetService("RunService").Heartbeat:Connect(function()
		local p, k = os.clock() * 0.25, {}
		for i = 0, 9 do k[i + 1] = ColorSequenceKeypoint.new(i / 9, Color3.fromHSV((i / 9 - p) % 1, 1, 1)) end
		local q = ColorSequence.new(k)
		for g in gr do
			if g.Parent then g.Color = q else gr[g] = nil end
		end
	end))
	table.insert(cs, nf.ChildAdded:Connect(hk))
	for _, m in nf:GetChildren() do hk(m) end
end

nt()

if ge.__FmC then ge.__FmC:Disconnect() end
task.spawn(function()
	local g = lp:WaitForChild("PlayerGui"):WaitForChild("Version", 30)
	local l = g and g:FindFirstChildWhichIsA("TextLabel", true)
	if not l then return end
	l.TextTransparency = 1
	ge.__FmC = l:GetPropertyChangedSignal("TextTransparency"):Connect(function() if l.TextTransparency ~= 1 then l.TextTransparency = 1 end end)
end)

task.spawn(function()
	for _ = 1, 3 do
		if sa() >= 12 then return end
		task.wait(5)
	end
	gw:Notify({Title = "Auto Boss", Text = "Boss Scan Failed: Regions Missing"})
end)

if ge.__FmA then ge.__FmA:Disconnect() end
ge.__FmA = lp.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:CaptureController()
	vu:ClickButton2(Vector2.new())
end)

do
	local nc = rv.NotificationController
	if type(nc) == "table" and type(nc.Push) == "function" then
		local op = ge.__FmNo or nc.Push
		ge.__FmNo = op
		nc.Push = function(s, t, ...)
			if type(t) == "string" and (t == "Left the region" or t:sub(1, 8) == "Entered ") then return end
			return op(s, t, ...)
		end
	end
end

if ge.__FmTt then ge.__FmTt:Disconnect() end
lp:SetAttribute("PLR_TITLE", "tester")
ge.__FmTt = lp:GetAttributeChangedSignal("PLR_TITLE"):Connect(function()
	if lp:GetAttribute("PLR_TITLE") ~= "tester" then lp:SetAttribute("PLR_TITLE", "tester") end
end)

do
	local wk = {}
	ge.__FmW = wk
	task.spawn(function()
		local t0
		while ge.__FmW == wk do
			local h, ht = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid"), rv.HeldToolController
			if ht and h and h.Health > 0 and not ht:IsReady() then
				t0 = t0 or os.clock()
				if os.clock() - t0 >= 5 then
					t0 = nil
					pcall(function() ht.BackpackReady.OnClientEvent:Fire() end)
					zx("[Hotbar] Ready Flag Stuck, Repaired")
				end
			else
				t0 = nil
			end
			task.wait(1)
		end
	end)
end

do
	local o = ge.__FmS
	if o then
		o.on = false
		pcall(function() o.t:Stop(0) end)
		pcall(function() o.h:Stop(0) end)
	end
	local sk = {on = true, t = nil :: any, h = nil :: any}
	ge.__FmS = sk
	task.spawn(function()
		local an, ah
		while sk.on do
			local hm = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
			local a = hm and hm.Health > 0 and hm:FindFirstChildOfClass("Animator")
			if a and (a ~= an or not (sk.t and sk.t.IsPlaying)) then
				pcall(function()
					local x = Instance.new("Animation")
					x.AnimationId = "rbxassetid://180435571"
					if sk.t and an == a then sk.t:Destroy() end
					sk.t, an = a:LoadAnimation(x), a
					sk.t.Looped, sk.t.Priority = true, Enum.AnimationPriority.Core
					sk.t:Play(0, 0.01, 0.37)
				end)
			end
			local fm = ge.__FmF
			local hw = L.Flags.hf == true and fm and not fm.dn and fm.st == "Running"
			if hw and a and (a ~= ah or not (sk.h and sk.h.IsPlaying)) then
				pcall(function()
					local x = Instance.new("Animation")
					x.AnimationId = "rbxassetid://180435571"
					if sk.h and ah == a then sk.h:Destroy() end
					sk.h, ah = a:LoadAnimation(x), a
					sk.h.Looped, sk.h.Priority = true, Enum.AnimationPriority.Core
					sk.h:Play(0, 0.01, 0.41)
				end)
			elseif not hw and sk.h then
				pcall(function() sk.h:Stop(0) end)
				sk.h, ah = nil, nil
			end
			task.wait(0.5)
		end
	end)
end

do
	local o = ge.__FmHd
	if o then
		o.on = false
		o.rs()
	end
	local hh = {on = true, v = {}}
	function hh.rs()
		for d, v in hh.v do pcall(function() d[v[1]] = v[2] end) end
		hh.v = {}
	end
	ge.__FmHd = hh
	task.spawn(function()
		while hh.on do
			pcall(function()
				local nf, sn = workspace:FindFirstChild("Nametags"), {}
				for _, p in ps:GetPlayers() do
					if p ~= lp and zq(p) then
						for _, m in {p.Character, nf and nf:FindFirstChild(p.Name)} do
							for _, d in m and m:GetDescendants() or {} do
								local k = (d:IsA("BasePart") or d:IsA("Decal")) and "LocalTransparencyModifier" or (d:IsA("Beam") or d:IsA("Trail") or d:IsA("ParticleEmitter") or d:IsA("LayerCollector") or d:IsA("Highlight")) and "Enabled"
								if k then
									if not hh.v[d] then hh.v[d] = {k, d[k]} end
									d[k] = k ~= "Enabled" and 1 or false
									sn[d] = true
								end
							end
						end
					end
				end
				for d, v in hh.v do
					if not sn[d] then
						pcall(function() d[v[1]] = v[2] end)
						hh.v[d] = nil
					end
				end
			end)
			task.wait(0.25)
		end
	end)
end

local function bh()
	for _, x in ge.__FmB or {} do
		pcall(function() x:Disconnect() end)
		pcall(function() x:Destroy() end)
	end
	local cs, fc = {}, rv.FishingController
	ge.__FmB = cs
	local ok, en, bd = cx(function()
		local fs2, n, d = md("Data", "Catalog", "Fish"), {}, {}
		for id, v in fs2 do
			if type(v) == "table" and type(v.name) == "string" then d[id] = {v.name, v.kind == "Boss"} end
		end
		for k, v in md("Data", "Catalog", "Boss").Pools do
			if v[1] and d[v[1].id] then n[k] = d[v[1].id][1] end
		end
		return n, d
	end)
	if not ok then return end
	local sr = lp.PlayerGui:WaitForChild("SessionInfo", 10)
	if not (sr and sr:FindFirstChild("Holder")) then return end
	local sg = sr:Clone()
	for _, x in sg:GetDescendants() do
		if x:IsA("LuaSourceContainer") then x:Destroy() end
	end
	sg.Name, sg.ResetOnSpawn, sg.DisplayOrder, sg.Enabled = game:GetService("HttpService"):GenerateGUID(false), false, 10, true
	local h = sg.Holder
	local hp, fn = h:FindFirstChild("FishHP"), h:FindFirstChild("FishName")
	local fi, ht = hp and hp:FindFirstChild("Fill"), hp and hp:FindFirstChild("HealthText")
	if not (fn and fi and ht) then return end
	for _, n in {"Tension", "FinisherGate", "EscapeSign"} do
		local x = h:FindFirstChild(n)
		if x then x.Visible = false end
	end
	for _, n in {"MaxHealthReduced", "MaxHealthReducedGate"} do
		local x = hp:FindFirstChild(n)
		if x then x.Visible = false end
	end
	local g1, g2, f0, tw = fi:FindFirstChild("Normal"), fi:FindFirstChild("BossPhase2"), fi.BackgroundColor3, game:GetService("TweenService")
	local px, po, pv, sv, fs = h.Position.X.Scale, h.Position.X.Offset, h.Position.Y.Offset, false, -1
	h.Position, h.Visible, fn.Visible = UDim2.new(px, po, -0.2, pv), false, true
	if not pcall(function() sg.Parent = gethui() end) then sg.Parent = lp.PlayerGui end
	table.insert(cs, sg)
	local function sl(v)
		if v == sv then return end
		sv = v
		if v then h.Visible = true end
		local t = tw:Create(h, TweenInfo.new(0.35, Enum.EasingStyle.Quint, v and Enum.EasingDirection.Out or Enum.EasingDirection.In), {Position = UDim2.new(px, po, v and 0.1 or -0.2, pv)})
		t.Completed:Connect(function() if not sv then h.Visible = false end end)
		t:Play()
	end
	local st, im, nr, iy, kh = nil, nil, 0, {}, false
	for n, v in ix do iy[v] = n end
	local function nf(n)
		return (tostring(math.floor(n + 0.5)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end
	table.insert(cs, fc.FishFirstPullStart.OnClientEvent:Connect(function(id, hp, mx) st = {bd[id] and bd[id][1] or tostring(id), hp, mx, 1, bd[id] and bd[id][2]} end))
	table.insert(cs, fc.FishReelStartAck.OnClientEvent:Connect(function(id, hp, mx) if not st then st = {bd[id] and bd[id][1] or tostring(id), hp, mx, 1, bd[id] and bd[id][2]} end end))
	table.insert(cs, fc.FishReelHPUpdate.OnClientEvent:Connect(function(hp) if st then st[2] = hp end end))
	table.insert(cs, fc.FishReelPhaseHP.OnClientEvent:Connect(function(hp, mx) if st then st[2], st[3], st[4] = hp, mx, 2 end end))
	table.insert(cs, fc.FishCatchResult.OnClientEvent:Connect(function() st = nil end))
	table.insert(cs, fc.FishReset.OnClientEvent:Connect(function() st = nil end))
	table.insert(cs, game:GetService("RunService").RenderStepped:Connect(function()
		pcall(function()
			local ev, ek, ex = rv.EventController and rv.EventController._active_events, nil, 0
			for k, v in type(ev) == "table" and ev or {} do
				if en[k] then ek, ex = k, math.max(v.expire_at or 0, v.admin_override_expire_at or 0) end
			end
			local gh = sr.Parent and sr:FindFirstChild("Holder")
			sl((ek ~= nil or st ~= nil) and not (gh and gh.Visible))
			if not sv then return end
			if os.clock() >= nr then
				nr, im = os.clock() + 1, nil
				task.spawn(function()
					local o, v = pcall(function() return (tonumber(pd().LastBossKillSlot) or 0) >= workspace:GetServerTimeNow() // 2400 * 2400 end)
					kh = o and v == true
				end)
				for _, x in game:GetService("CollectionService"):GetTagged("BossRegion") do
					local fx = x:FindFirstChild("BossSpawnerFX")
					if fx and fx:GetAttribute("BossSpawnerFXActive") == true and x.Parent and x.Parent.Parent then im = iy[x.Parent.Parent.Name] or x.Parent.Parent.Name end
				end
			end
			local lf, bo2 = math.floor(ex - workspace:GetServerTimeNow()), ek ~= nil and (not st or st[5])
			fn.Text = (st and st[1] or en[ek] or "Boss") .. (bo2 and im and ` - {im}` or "")
			if st then
				local f = math.clamp(st[2] / math.max(st[3], 1), 0, 1)
				if f ~= fs then
					fs = f
					tw:Create(fi, TweenInfo.new(0.15), {Size = UDim2.fromScale(f, 1)}):Play()
				end
				fi.BackgroundColor3 = f0
				if g1 then g1.Enabled = st[4] < 2 end
				if g2 then g2.Enabled = st[4] >= 2 end
				ht.Text = `{nf(st[2])} / {nf(st[3])}`
			else
				if fs ~= 1 then
					fs = 1
					tw:Create(fi, TweenInfo.new(0.15), {Size = UDim2.fromScale(1, 1)}):Play()
				end
				local hd = kh and ek ~= nil
				fi.BackgroundColor3 = hd and Color3.fromRGB(96, 165, 110) or Color3.fromRGB(70, 70, 80)
				if g1 then g1.Enabled = false end
				if g2 then g2.Enabled = false end
				ht.Text = hd and "Hunted" or lf > 0 and string.format("Not Hooked - %d:%02d", lf // 60, lf % 60) or "Not Hooked"
			end
		end)
	end))
end

task.spawn(bh)

local function iq()
	local o = ge.__FmQ
	if o then
		o.on = false
		pcall(function() o.sg:Destroy() end)
	end
	local tk, lb, rb, ylb = {on = true}, nil, nil, nil
	ge.__FmQ = tk
	local ok0, hu = pcall(gethui)
	for _, rt in {ok0 and hu or lp.PlayerGui, lp.PlayerGui} do
		for _, x in rt:GetDescendants() do
			if x:IsA("TextLabel") and x.Text == qtx then lb = x end
			if x:IsA("TextLabel") and x.Text == rtx then rb = x end
			if x:IsA("TextLabel") and x.Text == ytx then ylb = x end
		end
		if lb then break end
	end
	if lb then lb.RichText = true end
	if rb then rb.RichText = true end
	if ylb then ylb.RichText = true end
	iql:Set("Loading...")
	rql:Set("Loading...")
	yql:Set("Loading...")
	local iy = {}
	for n, v in ix do iy[v] = n end
	local function nf(v)
		return (tostring(math.floor(v + 0.5)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
	end
	local function kg(v)
		return v >= 100 and `{nf(v)} kg` or `{string.format("%.1f", v)} kg`
	end
	local qf = {
		crimson_bead_rod = {RequiredFished = 100, RequiredCoin = 3000000},
		bamboo_rod = {RequiredBamboo = 20, RequiredCoin = 3600000},
		heaven_piercer_turtle_rod = {RequiredFish = 5, RequiredCoin = 5000000},
		zen_staff_rod = {RequiredFish = 5, RequiredCoin = 5000000},
		dread_fish_rod = {RequiredFish = 1, RequiredCoin = 10000000},
		taiji_hooking_art_v2 = {RequiredKills = 100, RequiredCoin = 1000000},
	}
	local function rd()
		local q = qm[L.Flags.qs]
		if not q then return nil end
		local d, ct = pd(), md("Data", "Catalog")
		local cq = d.Quest and d.Quest.Current
		local ac, id = cq and cq.Id == q[1], q[1]
		if ((d.Quest or {}).Done or {})[id] then return {`{q[4]} (Completed)`, {}} end
		local pr, df, ln = ac and cq.Progress or {}, qf[id] or {}, {}
		local function gv(k) return pr[k] or df[k] or 0 end
		local function ro(n, h, w, s) table.insert(ln, {`{n}: {nf(h)} / {nf(w)}`, h >= w, s}) end
		local na = not ac and "Counts only after accepting" or nil
		local u = ul(q[2])
		table.insert(ln, {`{iy[q[2]] or q[2]}: {u and "Unlocked" or "Locked"}`, u})
		if q[7] then
			local r, o = ct.Rod.GetById(q[7]), d.Rods and d.Rods[q[7]] ~= nil
			table.insert(ln, {`Own {r and r.name or q[7]}: {o and "Yes" or "No"}`, o})
		end
		ro("Coins", d.Coin or 0, gv("RequiredCoin"))
		if id == "crimson_bead_rod" then
			ro("Fish With Legacy Rod", ac and pr.CurrentFished or 0, gv("RequiredFished"), na)
		elseif id == "bamboo_rod" then
			ro("Bamboo Fragments", md("Shared", "getItemCount")(d, "bamboo_fragment"), gv("RequiredBamboo"), "10% drop while fishing on Jungle Island")
		elseif id == "zen_staff_rod" then
			ro("Final Blows With Taiji Hooking Art V2", ac and pr.CurrentFish or 0, gv("RequiredFish"), `Legendary fish from Fossil Island{na and `, {na:lower()}` or ""}`)
		elseif id == "taiji_hooking_art_v2" then
			ro("Final Blows With Taiji Hooking Art", ac and pr.CurrentKills or 0, gv("RequiredKills"), `Any fish, any island{na and `, {na:lower()}` or ""}`)
			local bk = ((d.Inventory or {}).Books or {}).taiji_hooking_art or 0
			table.insert(ln, {`Taiji Hooking Art Books: {bk}`, bk >= 1, "One book is turned into V2; the hub unequips it before completing"})
		elseif q[6] then
			local c = 0
			for _ in select(2, qc(q, d, {RequiredFish = gv("RequiredFish")})) do c += 1 end
			ro(`{q[6][1]} Fish`, c, gv("RequiredFish"), `Any {q[6][1]} fish from {iy[q[6][2]] or q[6][2]}`)
		end
		return {`{q[4]}{ac and " (Accepted)" or ""}`, ln}
	end
	local function rs(r)
		if not r then return "No Rod Quest Selected" end
		local t = {rb and `<b>{r[1]}</b>` or r[1]}
		for _, v in r[2] do
			local hn = v[3] and (rb and ` <font color="#96938C">- {v[3]}</font>` or ` - {v[3]}`) or ""
			table.insert(t, (rb and `<font color="#{v[2] and "78C882" or "D66A5E"}">{v[1]}</font>` or v[1]) .. hn)
		end
		return table.concat(t, "\n")
	end
	local function dt()
		local d, q = pd(), nil
		for _, x in qd do
			if not ul(x[3]) then q = x; break end
		end
		if not q then return {} end
		local ct, cq = md("Data", "Catalog"), d.Quest and d.Quest.Current
		local pr = cq and cq.Id == q[1] and cq.Progress or q[5]
		local _, ks = qc(q, d, pr)
		local ln, n, bw, fl = {{"Coins", d.Coin or 0, pr.RequiredCoin or 0}}, {}, {}, {}
		for u in ks do
			local x = d.Inventory.Fishes[u]
			if x then n[x.fishId] = (n[x.fishId] or 0) + 1 end
		end
		for _, x in d.Inventory.Fishes do bw[x.fishId] = math.max(bw[x.fishId] or 0, x.weight or 0) end
		for _, il in ix do
			for _, x in (ct.Island.GetById(il) or {}).fishes or {} do
				fl[x.fishId] = fl[x.fishId] and `{fl[x.fishId]}, {iy[il]}` or iy[il]
			end
		end
		if q[6] then
			local c = 0
			for _ in ks do c += 1 end
			table.insert(ln, {`{q[6][1]} Fish`, c, pr.RequiredFish or 1, `Any {q[6][1]} fish from {iy[q[6][2]] or q[6][2]}`})
		else
			local wk, fs = q[1] == "unlock_island_6" and md("Data", "Config", "QuestConfig").UnlockIsland6MinWeightKg or {}, {}
			for id, v in pr.RequiredFishes or {} do
				local fi = ct.Fish.GetById(id)
				local nm, rr, il = fi and fi.name or id, fi and fi.rarity or "?", fl[id] or "?"
				table.insert(fs, {nm, n[id] or 0, v, wk[id] and `Need {kg(wk[id])} - Best {bw[id] and kg(bw[id]) or "none"} - {rr} - {il}` or `{rr} - {il}`, wk[id] or 0})
			end
			table.sort(fs, function(x, y)
				if x[5] ~= y[5] then return x[5] < y[5] end
				return x[1] < y[1]
			end)
			for _, x in fs do table.insert(ln, x) end
		end
		return {q[4], ln, cq and cq.Id == q[1]}
	end
	local function yd()
		local d, ct, ba = pd(), md("Data", "Catalog"), md("Utils", "skillBookAvailability")
		local cq, so, dn, ps = (d.Quest or {}).Current or {}, (d.Inventory or {}).Souls or {}, (d.Quest or {}).Done or {}, L.Flags.ys or {}
		local se = ct.Soul.GetById(d.SoulEquip or "")
		local t = {{`Equipped Soul: {se and se.name or "Human"}`}}
		if #ps == 0 then table.insert(t, {"No Soul Quest Selected"}) end
		for _, q in qg do
			local id = q[1]
			if not table.find(ps, q[4]) then continue end
			if dn[id] or so[id] == true then
				table.insert(t, {`{q[4]} (Owned)`, true, nil, true})
				continue
			end
			local ac = cq.Id == id
			local pr, u = ac and cq.Progress or {}, ul(q[2])
			table.insert(t, {`{q[4]}{ac and " (Accepted)" or ""}`, nil, nil, true})
			table.insert(t, {`{iy[q[2]] or q[2]}: {u and "Unlocked" or "Locked"}`, u})
			if id == "azure_dragon" or id == "supreme_king" then
				local h, w = ac and pr.CurrentUsedSkill or 0, pr.CatchWithSkill or (id == "azure_dragon" and 100 or 5)
				table.insert(t, {`{id == "azure_dragon" and "Final Blows With One Hook Supreme" or "Legendary Final Blows With Rod Gate 20%"}: {nf(h)} / {nf(w)}`, h >= w, `{id == "azure_dragon" and "Any fish" or "Legendary fish from Fossil Island"}{ac and "" or ", counts only after accepting"}`})
			end
			if q[6] then
				local w, c = pr.RequiredFish or 3, 0
				for _ in select(2, qc(q, d, {RequiredFish = w})) do c += 1 end
				table.insert(t, {`{q[6][1]} Fish{q[6][3] and ` {nf(q[6][3])}+ kg` or ""}: {c} / {w}`, c >= w, `From {iy[q[6][2]] or q[6][2]}`})
			end
			for b, v in id == "phoenix" and md("Data", "Config", "QuestConfig").PhoenixRequiredBooks or id == "supreme_king" and (pr.RequiredBooks or {rod_gate_20_percent = 1}) or {} do
				local a = ba.GetCounts(d, b).available
				table.insert(t, {`Unequipped {(ct.Skill.GetById(b) or {}).name or b}: {math.min(a, v)} / {v}`, a >= v, id == "supreme_king" and "A copy besides the one on your rod" or "Skill book not on any rod"})
			end
		end
		return t
	end
	local function yr(r)
		local t = {}
		for _, v in r do
			local x = v[4] and (ylb and `<b>{v[1]}</b>` or v[1]) or v[2] ~= nil and ylb and `<font color="#{v[2] and "78C882" or "D66A5E"}">{v[1]}</font>` or v[1]
			table.insert(t, x .. (v[3] and (ylb and ` <font color="#96938C">- {v[3]}</font>` or ` - {v[3]}`) or ""))
		end
		return table.concat(t, "\n")
	end
	local function kd()
		local st, ct, t = game:GetService("ReplicatedStorage"):GetAttribute("SkillMarketStock"), md("Data", "Catalog"), {}
		for id in (type(st) == "string" and st or ""):gmatch("[^,]+") do
			local x = ct.Skill.GetById(id)
			table.insert(t, x and x.name or id)
		end
		return #t > 0 and table.concat(t, "\n") or "No Stock"
	end
	while ge.__FmQ == tk do
		local ok, r = cx(dt)
		if ok and r then
			local t = {r[1] and `Next Island: {r[1]}{r[3] and " (Accepted)" or ""}` or "All Islands Unlocked"}
			if lb then t[1] = `<b>{t[1]}</b>` end
			for _, v in r[2] or {} do
				local x = `{v[1]}: {nf(v[2])} / {nf(v[3])}`
				local hn = v[4] and (lb and ` <font color="#96938C">- {v[4]}</font>` or ` - {v[4]}`) or ""
				table.insert(t, (lb and `<font color="#{v[2] >= v[3] and "78C882" or "D66A5E"}">{x}</font>` or x) .. hn)
			end
			iql:Set(table.concat(t, "\n"))
		end
		local ok2, r2 = cx(rd)
		if ok2 then rql:Set(rs(r2)) end
		local ok4, r4 = cx(yd)
		if ok4 and r4 then yql:Set(yr(r4)) end
		local ok3, r3 = cx(kd)
		if ok3 then kql:Set(r3) end
		task.wait(1)
	end
end

task.spawn(iq)
