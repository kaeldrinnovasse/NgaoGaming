if not game:IsLoaded() then game.Loaded:Wait() end

local ps = game:GetService("Players")
repeat task.wait() until ps.LocalPlayer

local lp, rv = ps.LocalPlayer, getrenv().shared
while lp:GetAttribute("IsLoaded") ~= true do lp:GetAttributeChangedSignal("IsLoaded"):Wait() end
repeat task.wait(0.1) until rv.LoadingController and rv.LoadingController:IsLoaded()

local qk = {Right = "D", Left = "A", Up = "W"}

local function pd() return rv.PlayerDataV2Controller:Fetch() end

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

local function rl(f, s, ks, lt)
	local fc, mv, sq, nc, dl = rv.FishingController, rv.RodController.Moveset, 0, 0, os.clock() + lt
	while f.st == "Running" and not s.cr and not s.rr do
		local t = os.clock()
		if t > dl then return "Reel Timeout" end
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

local fz, cj = {Enum.HumanoidStateType.Freefall, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll}, nil

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
	end)
	j.st, j.why = st, why
	if cj == j then cj = nil end
end

local function mo(p, s, fk)
	if typeof(p) ~= "Vector3" or p.Magnitude ~= p.Magnitude or p.Magnitude == math.huge then return nil, "Move Failed: Bad Point" end
	if cj then cj:Stop() end
	local c, r, h = lc()
	local j = {st = "Moving", p = p, s = s, cc = {}, ss = {}, pl = {}, lk = r and Vector3.new(r.CFrame.LookVector.X, 0, r.CFrame.LookVector.Z).Unit or -Vector3.zAxis}
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

local pm, wk, ap = {on = false}, nil, nil

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

local function go(f, p, fk)
	if pm.on and wk then return wk(f, p) end
	return gf(f, p, fk)
end

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
	local o = h.CFrame
	local np = ns("npc_fish_seller", o.Position)
	if not np then return "Auto Fish Failed: No Fish Seller" end
	local hl, e = lk(f.sr(), f.kp())
	if e then
		local _, ue = uk(hl)
		return nil, ue or e
	end
	local sp = ap(c, np, o.Position)
	local w, we, s
	for _ = 1, 3 do
		w, we = go(f, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
		if not w or f.st ~= "Running" then break end
		task.wait(0.5)
		s = rv.SellController:SellAll()
		if s ~= 1 then break end
	end
	local uo, ue = uk(hl)
	if f.st == "Running" then go(f, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
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

local function rs(ok, id)
	local c, r = lc()
	local w = workspace:FindFirstChild("World")
	local il = w and w:FindFirstChild("Islands")
	local fo = il and il:FindFirstChild(id or ic())
	if not (c and fo) then return nil end
	local ip, o, rd = RaycastParams.new(), {}, Random.new()
	ip.FilterType, ip.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	for _ = 1, 150 do
		local a, d = rd:NextNumber(0, math.pi * 2), rd:NextNumber(10, 150)
		local h = workspace:Raycast(Vector3.new(r.Position.X + math.sin(a) * d, 150, r.Position.Z + math.cos(a) * d), Vector3.new(0, -200, 0), ip)
		if h and h.Instance:IsDescendantOf(fo) and h.Position.Y > 3.5 and h.Position.Y < 20 then
			local g = h.Position
			for i = 0, 7 do
				local b = math.rad(i * 45)
				if not workspace:Raycast(Vector3.new(g.X + math.sin(b) * 12, 103, g.Z + math.cos(b) * 12), Vector3.new(0, -100, 0), ip) and tg({Position = g}) then
					if not ok or ok(g) then table.insert(o, g + Vector3.new(0, 3, 0)) end
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

local hs, vg, vd = game:GetService("HttpService"), {}, {{1, 0}, {0, 1}, {1, 1}, {1, -1}}

local function vk(id)
	local w = workspace:FindFirstChild("World")
	local fo = w and w:FindFirstChild("Islands") and w.Islands:FindFirstChild(id)
	if not fo then return nil end
	local rb
	for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if x:IsA("BasePart") and x:GetAttribute("islandId") == id then
			local c, rr = x.Position, x.Size.X * 0.3
			rb = {c.X - x.Size.X / 2, c.X + x.Size.X / 2, c.Z - x.Size.X / 2, c.Z + x.Size.X / 2}
			for k = 0, 8 do
				local a = k * math.pi / 4
				sq(Vector3.new(c.X + (k > 0 and math.cos(a) * rr or 0), 10, c.Z + (k > 0 and math.sin(a) * rr or 0)), 10)
			end
		end
	end
	local n, x0, x1, z0, z1, y1 = 0, math.huge, -math.huge, math.huge, -math.huge, 0
	for _, p in fo:GetDescendants() do
		if p:IsA("BasePart") and p.CanCollide and p.Size.Magnitude < 2000 then
			local s = p.Size.Magnitude / 2
			n, x0, x1, z0, z1, y1 = n + 1, math.min(x0, p.Position.X - s), math.max(x1, p.Position.X + s), math.min(z0, p.Position.Z - s), math.max(z1, p.Position.Z + s), math.max(y1, p.Position.Y + s)
		end
	end
	if n == 0 then return nil end
	if rb then x0, x1, z0, z1 = math.max(x0, rb[1]), math.min(x1, rb[2]), math.max(z0, rb[3]), math.min(z1, rb[4]) end
	return n, math.floor(x0 / 2) * 2, math.ceil(x1 / 2) * 2, math.floor(z0 / 2) * 2, math.ceil(z1 / 2) * 2, math.ceil(y1) + 5
end

local function vs(id, sg, x0, x1, z0, z1, y1)
	local ex = {}
	for _, p in ps:GetPlayers() do if p.Character then table.insert(ex, p.Character) end end
	for _, n in {"Cars", "Nametags"} do
		local x = workspace:FindFirstChild(n)
		if x then table.insert(ex, x) end
	end
	local rp, k, st = RaycastParams.new(), 0, 2
	rp.FilterType, rp.FilterDescendantsInstances, rp.RespectCanCollide = Enum.RaycastFilterType.Exclude, ex, true
	local function rc(o, d)
		k += 1
		if k >= 800 then k = 0; task.wait() end
		return workspace:Raycast(o, d, rp)
	end
	local nx, nz, cl, ls = math.floor((x1 - x0) / st), math.floor((z1 - z0) / st), {}, {}
	for i = 0, nx do
		for q = 0, nz do
			local x, z, y, l, py = x0 + i * st, z0 + q * st, y1, {}, nil
			while #l < 4 and y > -30 do
				local h = rc(Vector3.new(x, y, z), Vector3.new(0, -30 - y, 0))
				if not h then break end
				local sy, hd = h.Position.Y, 6
				if not py or rc(Vector3.new(x, sy + 0.1, z), Vector3.new(0, py - sy + 1, 0)) then
					if h.Normal.Y < 0.5 or sy < 1.5 then
						hd = 0
					else
						for _, o in {{0, 0}, {0.8, 0.8}, {-0.8, 0.8}, {0.8, -0.8}, {-0.8, -0.8}} do
							local u = rc(Vector3.new(x + o[1], sy + 0.1, z + o[2]), Vector3.new(0, 6, 0))
							if u then hd = math.min(hd, u.Position.Y - sy) end
						end
					end
					table.insert(l, {math.floor(sy * 100) / 100, math.floor(h.Normal.Y * 1000) / 1000, math.floor(hd * 10) / 10})
					py = sy
				end
				y = sy - 0.1
			end
			if #l > 0 then
				local c = i * (nz + 1) + q
				cl[c], ls[c] = {i, q, l, {}}, l
			end
		end
	end
	for _, v in cl do
		local i, q, l = v[1], v[2], v[3]
		for di, d in vd do
			local ni, nq = i + d[1], q + d[2]
			local b = ni >= 0 and ni <= nx and nq >= 0 and nq <= nz and ls[ni * (nz + 1) + nq]
			for a, la in l do
				for bi, lb in b or {} do
					if la[2] >= 0.5 and la[3] >= 5.1 and la[1] >= 1.5 and lb[2] >= 0.5 and lb[3] >= 5.1 and lb[1] >= 1.5 and math.abs(la[1] - lb[1]) <= 8 then
						local hy, fr = math.max(la[1], lb[1]), 1
						local pa, pb = Vector3.new(x0 + i * st, 0, z0 + q * st), Vector3.new(x0 + ni * st, 0, z0 + nq * st)
						local sv = Vector3.new(pa.Z - pb.Z, 0, pb.X - pa.X).Unit * 0.9
						for _, hh in {{0.6, 0}, {2, 0}, {3.5, 0}, {2, 1}, {2, -1}, {3.5, 1}, {3.5, -1}} do
							local o, e = pa + Vector3.new(0, hy + hh[1], 0) + sv * hh[2], pb + Vector3.new(0, hy + hh[1], 0) + sv * hh[2]
							if rc(o, e - o) or rc(e, o - e) then fr = 0; break end
						end
						table.insert(v[4], {di, a, bi, fr})
					end
				end
			end
		end
	end
	local ar = {}
	for _, v in cl do table.insert(ar, v) end
	return {v = 3, id = id, n = sg, x0 = x0, z0 = z0, st = st, nx = nx, nz = nz, c = ar}
end

local function vb(d)
	local X, Y, Z, I, Q, A, M, C, K, nz = {}, {}, {}, {}, {}, {}, {}, {}, {}, d.nz
	for _, v in d.c do
		local i, q, ci = v[1], v[2], v[1] * (d.nz + 1) + v[2]
		for a, x in v[3] do
			if x[2] >= 0.5 and x[3] >= 5.1 and x[1] >= 1.5 then
				local n = #X + 1
				X[n], Y[n], Z[n], I[n], Q[n], A[n] = d.x0 + i * d.st, x[1], d.z0 + q * d.st, i, q, {}
				K[ci] = K[ci] or {}
				K[ci][a] = n
				C[ci] = C[ci] or {}
				table.insert(C[ci], n)
			end
		end
	end
	for _, v in d.c do
		local i, q = v[1], v[2]
		local ku = K[i * (nz + 1) + q]
		for _, e in ku and v[4] or {} do
			local dd = vd[e[1]]
			local kw = K[(i + dd[1]) * (nz + 1) + q + dd[2]]
			local u, w = ku[e[2]], kw and kw[e[3]]
			if e[4] == 1 and u and w and math.abs(Y[w] - Y[u]) <= 8 then A[u][w], A[w][u] = Y[w] - Y[u], Y[u] - Y[w] end
		end
	end
	local function hk(u, i, q)
		for w in A[u] do
			if I[w] == i and Q[w] == q then return true end
		end
		return false
	end
	local bd = {}
	for u = 1, #X do
		for w in A[u] do
			local dx, dz = I[w] - I[u], Q[w] - Q[u]
			if dx ~= 0 and dz ~= 0 and not (hk(u, I[u] + dx, Q[u]) and hk(u, I[u], Q[u] + dz) and hk(w, I[w] - dx, Q[w]) and hk(w, I[w], Q[w] - dz)) then table.insert(bd, {u, w}) end
		end
	end
	for _, x in bd do A[x[1]][x[2]], A[x[2]][x[1]] = nil, nil end
	for u = 1, #X do
		local s, n = {}, 0
		for w in A[u] do
			local c = I[w] * 100000 + Q[w]
			if not s[c] then s[c], n = true, n + 1 end
		end
		M[u] = 8 - n
	end
	return {X = X, Y = Y, Z = Z, I = I, Q = Q, A = A, M = M, C = C, x0 = d.x0, z0 = d.z0, st = d.st, nz = nz, nx = d.nx}
end

local function vi(p)
	local id = ic()
	if id ~= "" then return id end
	for _, x in game:GetService("CollectionService"):GetTagged("IslandRegion") do
		if x:IsA("BasePart") and (x.Position - p).Magnitude < x.Size.X / 2 then return x:GetAttribute("islandId") end
	end
	return ""
end

local function vc(g)
	local P, n = {}, 0
	for u = 1, #g.X do
		if not P[u] then
			n += 1
			P[u] = n
			local q = {u}
			while #q > 0 do
				local v = table.remove(q)
				for w, dy in g.A[v] do
					if not P[w] and dy <= 6 and dy >= -6 then
						P[w] = n
						table.insert(q, w)
					end
				end
			end
		end
	end
	local S, mc = {}, 1
	for _, c in P do S[c] = (S[c] or 0) + 1 end
	for c, v in S do
		if v > (S[mc] or 0) then mc = c end
	end
	g.P, g.S, g.MC = P, S, mc
end

local function vq(id)
	while vg[id] == false do task.wait(0.5) end
	if vg[id] then return vg[id] end
	vg[id] = false
	local ok, g, e = pcall(function()
		local sg, x0, x1, z0, z1, y1 = vk(id)
		if not sg then return nil, "Nav Failed: No Island" end
		local fp, d = `Avenoric/Nav/{id}.json`, nil
		local o1, s = pcall(readfile, fp)
		if o1 and type(s) == "string" then
			local o2, x = pcall(hs.JSONDecode, hs, s)
			if o2 and type(x) == "table" and x.v == 3 and x.pv == game.PlaceVersion and type(x.n) == "number" and x.n >= sg then d = x end
		end
		if not d then
			d = vs(id, sg, x0, x1, z0, z1, y1)
			d.n, d.pv = math.min(sg, vk(id) or 0), game.PlaceVersion
			pcall(makefolder, "Avenoric")
			pcall(makefolder, "Avenoric/Nav")
			pcall(writefile, fp, hs:JSONEncode(d))
		end
		local gr = vb(d)
		vc(gr)
		return gr
	end)
	vg[id] = ok and g or nil
	if not ok then return nil, `Nav Failed: {g}` end
	return g, e
end

local function vn(g, p, cp)
	local i0, q0, b, bd = math.round((p.X - g.x0) / g.st), math.round((p.Z - g.z0) / g.st), nil, math.huge
	for rr = 0, 40, 8 do
		for i = i0 - rr - 8, i0 + rr + 8 do
			for q = q0 - rr - 8, q0 + rr + 8 do
				for _, n in g.C[i * (g.nz + 1) + q] or {} do
					if not cp or g.P[n] == cp then
						local d = (g.X[n] - p.X) ^ 2 + (g.Z[n] - p.Z) ^ 2 + 4 * (g.Y[n] - p.Y) ^ 2
						if d < bd then b, bd = n, d end
					end
				end
			end
		end
		if b then return b, math.sqrt(bd) end
	end
	return nil
end

local function vh(g, p)
	local a = vn(g, p)
	local sw = rv.Swimming and rv.Swimming:IsSwimming()
	if not a or sw or g.S[g.P[a]] < 500 then a = vn(g, p, g.MC) or a end
	return a
end

local function va(g, a, b, bn)
	local X, Y, Z, A, M = g.X, g.Y, g.Z, g.A, g.M
	local bx, by, bz = X[b], Y[b], Z[b]
	local G, P, cl, hp, hv, hn, it = {[a] = 0}, {}, {}, {}, {}, 0, 0
	local function hh(u) return math.sqrt((X[u] - bx) ^ 2 + (Y[u] - by) ^ 2 + (Z[u] - bz) ^ 2) end
	local function pu(n, v)
		hn += 1
		local i = hn
		hp[i], hv[i] = n, v
		while i > 1 do
			local p = i // 2
			if hv[p] <= hv[i] then break end
			hp[p], hp[i], hv[p], hv[i] = hp[i], hp[p], hv[i], hv[p]
			i = p
		end
	end
	local function po()
		local n = hp[1]
		hp[1], hv[1] = hp[hn], hv[hn]
		hp[hn], hv[hn] = nil, nil
		hn -= 1
		local i = 1
		while true do
			local l, r, s = i * 2, i * 2 + 1, i
			if l <= hn and hv[l] < hv[s] then s = l end
			if r <= hn and hv[r] < hv[s] then s = r end
			if s == i then break end
			hp[s], hp[i], hv[s], hv[i] = hp[i], hp[s], hv[i], hv[s]
			i = s
		end
		return n
	end
	pu(a, hh(a))
	while hn > 0 do
		local u = po()
		if u == b then
			local r = {u}
			while P[u] do
				u = P[u]
				table.insert(r, 1, u)
			end
			return r
		end
		if not cl[u] then
			cl[u], it = true, it + 1
			if it % 4000 == 0 then task.wait() end
			for w, dy in A[u] do
				if dy <= 6 and not cl[w] and not (bn and bn[w] and w ~= b) then
					local ng = G[u] + math.sqrt((X[w] - X[u]) ^ 2 + (Z[w] - Z[u]) ^ 2) + (dy > 1.2 and 4 or 0) + (dy < -3 and 1 or 0) + 0.35 * M[w]
					if ng < (G[w] or math.huge) then
						G[w], P[w] = ng, u
						pu(w, ng + hh(w))
					end
				end
			end
		end
	end
	return nil
end

local function vl(g, u, w)
	local X, Z, A, I, Q = g.X, g.Z, g.A, g.I, g.Q
	local dx, dz = X[w] - X[u], Z[w] - Z[u]
	local n, c = math.max(1, math.floor(math.sqrt(dx * dx + dz * dz) / 0.5)), u
	for k = 1, n do
		local ci, cq = math.round((X[u] + dx * k / n - g.x0) / g.st), math.round((Z[u] + dz * k / n - g.z0) / g.st)
		if ci ~= I[c] or cq ~= Q[c] then
			local b, bd = nil, math.huge
			for v, dy in A[c] do
				if I[v] == ci and Q[v] == cq and math.abs(dy) < bd then b, bd = v, math.abs(dy) end
			end
			if not b or A[c][b] > 1.2 or g.M[b] > 3 then return false end
			c = b
		end
	end
	return c == w
end

local function vz(g, p, bn)
	local i0, q0 = math.round((p.X - g.x0) / g.st), math.round((p.Z - g.z0) / g.st)
	for i = i0 - 2, i0 + 2 do
		for q = q0 - 2, q0 + 2 do
			for _, n in g.C[i * (g.nz + 1) + q] or {} do
				if (g.X[n] - p.X) ^ 2 + (g.Z[n] - p.Z) ^ 2 <= 6.25 and math.abs(g.Y[n] + 3 - p.Y) <= 4 then bn[n] = true end
			end
		end
	end
end

local function vr(g, p0, p1, bn)
	local a = vh(g, p0)
	if not a then return nil, "Nav Failed: Off Map" end
	local b = vn(g, p1, g.P[a])
	if not b then return nil, "Nav Failed: No Route" end
	local r = va(g, a, b, bn)
	if not r then return nil, "Nav Failed: No Route" end
	local o, i = {r[1]}, 1
	while i < #r do
		local j = i + 1
		if g.A[r[i]][r[j]] <= 1.2 then
			local k = j
			while k + 1 <= #r and g.A[r[k]][r[k + 1]] <= 1.2 and vl(g, r[i], r[k + 1]) do k += 1 end
			j = k
		end
		table.insert(o, r[j])
		i = j
	end
	local w = {}
	for k, u in o do table.insert(w, {g.X[u], g.Y[u], g.Z[u], k > 1 and (g.A[o[k - 1]][u] or 0) > 1.2}) end
	return w
end

local function vf(p)
	local _, r = lc()
	local id = r and vi(r.Position) or ""
	local g = id ~= "" and vq(id)
	if not (g and r) then return true end
	local a = vh(g, r.Position - Vector3.new(0, 3, 0))
	local b = a and vn(g, p, g.P[a])
	return b ~= nil and ((Vector3.new(g.X[b], 0, g.Z[b]) - p) * Vector3.new(1, 0, 1)).Magnitude <= 3
end

ap = function(c, np, p)
	local u = Vector3.new(p.X, np.Y, p.Z) - np
	u = u.Magnitude > 0.1 and u.Unit or Vector3.xAxis
	local sp = gd(c, np + u * 6)
	if not pm.on then return sp end
	local _, r = lc()
	local id = r and vi(r.Position) or ""
	local g = id ~= "" and vq(id)
	local a = g and vh(g, r.Position - Vector3.new(0, 3, 0))
	if not a then return sp end
	local b, bd = sp, math.huge
	for k = 0, 15 do
		local q = gd(c, np + CFrame.Angles(0, (k % 2 == 0 and 1 or -1) * math.ceil(k / 2) * math.pi / 8, 0):VectorToWorldSpace(u) * 6 - Vector3.new(0, 18, 0))
		local n = vn(g, q, g.P[a])
		local d, dy = n and ((Vector3.new(g.X[n], 0, g.Z[n]) - q) * Vector3.new(1, 0, 1)).Magnitude, math.abs(q.Y - np.Y)
		if d and d <= 2 and dy <= 4 and math.abs(g.Y[n] + 3 - q.Y) <= 2 then return q end
		if d and d + dy < bd then b, bd = q, d + dy end
	end
	return b
end

local vy = {j = false}
getgenv().__FmJ = vy
task.spawn(function()
	local vm = game:GetService("VirtualInputManager")
	while getgenv().__FmJ == vy do
		if vy.j then
			vy.j = false
			pcall(function()
				vm:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
				task.wait(0.15)
				vm:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
			end)
		end
		task.wait()
	end
end)

local function vj() vy.j = true end

wk = function(f, p)
	local _, r0 = lc()
	local id = r0 and vi(r0.Position) or ""
	local g = id ~= "" and vq(id)
	if not g then return gf(f, p) end
	if cj then cj:Stop() end
	local tg, rsv = nil, game:GetService("RunService")
	local ok, a, b = pcall(function()
		rsv:BindToRenderStep("AvNvMv", Enum.RenderPriority.Character.Value + 1, function()
			local _, r, h = lc()
			if not (tg and r) then return end
			local d = (tg - r.Position) * Vector3.new(1, 0, 1)
			h:Move(d.Magnitude > 0.3 and d.Unit or Vector3.zero)
		end)
		local bn = {}
		for _ = 1, 4 do
			local c, r = lc()
			if not c then return nil, "No Character" end
			if f.st ~= "Running" then return nil end
			if ((r.Position - p) * Vector3.new(1, 0, 1)).Magnitude <= 2 then return true end
			if rv.Swimming and rv.Swimming:IsSwimming() then
				local n = vh(g, r.Position - Vector3.new(0, 3, 0))
				if not n then return nil, "Nav Failed: Off Map" end
				tg = nil
				local tp = Vector3.new(g.X[n], g.Y[n] + 3.2, g.Z[n])
				local mj, me = mo(tp, 30)
				if not mj then return nil, me end
				local dl2 = os.clock() + (tp - r.Position).Magnitude / 30 + 4
				repeat task.wait() until mj.st == "Arrived" or mj.dn or f.st ~= "Running" or os.clock() > dl2
				local mw = mj.why
				mj:Stop()
				if mw then return nil, mw end
				task.wait(0.3)
				c, r = lc()
				if not r then return nil, "No Character" end
			end
			local w, we = vr(g, r.Position - Vector3.new(0, 3, 0), p, bn)
			if not w then return nil, we end
			local fd = ((Vector3.new(w[#w][1], 0, w[#w][3]) - p) * Vector3.new(1, 0, 1)).Magnitude + math.abs(w[#w][2] + 3 - p.Y)
			if fd > 30 then return nil, "Nav Failed: Unreachable" end
			if fd > 0.5 and fd <= 5 then table.insert(w, {p.X, p.Y - 3, p.Z, false}) end
			local pe = Vector3.new(w[#w][1], w[#w][2] + 3, w[#w][3])
			local i, lt, bd, js, sj, sk = 2, os.clock(), math.huge, 0, 0, false
			local dl = os.clock() + #w * 3 + 20
			while i <= #w and f.st == "Running" do
				local _, rt = lc()
				if not rt then return nil, "No Character" end
				local x = w[i]
				tg = Vector3.new(x[1], x[2], x[3])
				local d = ((tg - rt.Position) * Vector3.new(1, 0, 1)).Magnitude
				if x[4] and d < 3.5 and rt.Position.Y - 3 < x[2] - 1 and os.clock() - js > 0.6 and sj < 3 then vj(); js, sj = os.clock(), sj + 1 end
				if d < (i == #w and 1.5 or 2) and rt.Position.Y - 3 > x[2] - 1.5 and rt.Position.Y - 3 < x[2] + 3 then
					i, lt, bd, sj = i + 1, os.clock(), math.huge, 0
				else
					if d < bd - 0.5 then lt, bd = os.clock(), d end
					if os.clock() - lt > 0.7 and os.clock() - js > 0.7 and sj < 3 then vj(); js, sj = os.clock(), sj + 1 end
					if os.clock() - lt > 2.5 then
						local u = (tg - rt.Position) * Vector3.new(1, 0, 1)
						vz(g, rt.Position + (u.Magnitude > 0.1 and u.Unit * 1.5 or Vector3.zero), bn)
						sk = true
						break
					end
					if os.clock() > dl or rv.Swimming and rv.Swimming:IsSwimming() then sk = true; break end
				end
				task.wait()
			end
			tg = nil
			if f.st ~= "Running" then return nil end
			if not sk then
				local _, rt = lc()
				if rt and ((rt.Position - pe) * Vector3.new(1, 0, 1)).Magnitude <= 2.5 and math.abs(rt.Position.Y - pe.Y) <= 3 then
					if fd > 5 then return gf(f, p) end
					return true
				end
			end
		end
		return nil, "Nav Failed: Stuck"
	end)
	tg = nil
	pcall(function() rsv:UnbindFromRenderStep("AvNvMv") end)
	local _, _, h = lc()
	if h then h:Move(Vector3.zero) end
	if not ok then return nil, `Nav Failed: {a}` end
	if not a and b and b ~= "No Character" and f.st == "Running" then return gf(f, p) end
	return a, b
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
	local function ok(x) return x and x:FindFirstChild("Main") and x:FindFirstChild("DSeat") and x:GetAttribute("Speed") == bv(k) and (not pm.on or pc() > 0 or (x.Main.Position - r.Position).Magnitude < 100) end
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

local function sb(f, m)
	local c, r, h = lc()
	if not c then return nil, "No Character" end
	local ds = m:FindFirstChild("DSeat")
	local pp = ds and ds:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not pp then return nil, "No Boat Seat" end
	if ds.Occupant == h then return true end
	local q = (r.Position - ds.Position) * Vector3.new(1, 0, 1)
	local g, e
	if pm.on then
		local id = vi(ds.Position)
		local gr = id ~= "" and vq(id)
		local n = gr and vh(gr, ds.Position)
		if n and ((Vector3.new(gr.X[n], 0, gr.Z[n]) - ds.Position) * Vector3.new(1, 0, 1)).Magnitude < 80 then wk(f, Vector3.new(gr.X[n], gr.Y[n] + 3, gr.Z[n])) end
		if f.st ~= "Running" then return nil end
		local _, r2 = lc()
		if not r2 then return nil, "No Character" end
		q = (r2.Position - ds.Position) * Vector3.new(1, 0, 1)
		g, e = true, nil
		if (r2.Position - ds.Position).Magnitude > 8 then g, e = gf(f, ds.Position + Vector3.new(0, 1.5, 0) + (q.Magnitude > 0.1 and q.Unit or Vector3.xAxis) * 3) end
	else
		g, e = go(f, Vector3.new(ds.Position.X, r.Position.Y, ds.Position.Z) + (q.Magnitude > 0.1 and q.Unit or Vector3.xAxis) * 3)
	end
	if not g then return nil, e end
	if cj then cj:Stop() end
	local dl, lc2 = os.clock() + 6, false
	repeat
		fireproximityprompt(pp)
		local d1 = os.clock() + 1
		repeat task.wait(0.1) until ds.Occupant == h or os.clock() > d1
		if ds.Occupant ~= h and not lc2 then
			lc2 = true
			rv.FishingController.FishLootConfirm:Fire()
		end
	until ds.Occupant == h or os.clock() > dl
	if ds.Occupant ~= h then return nil, "Sit Timeout" end
	return true
end

local function dp(f, m, id, pt)
	local _, _, h = lc()
	local mn, ds = m:FindFirstChild("Main"), m:FindFirstChild("DSeat")
	local cp, cs = rg(id), game:GetService("CollectionService")
	if not (h and mn and ds and ds:IsA("VehicleSeat")) then return nil, "Bad Boat" end
	if not cp then return nil, "No Island Region" end
	local w = workspace:FindFirstChild("World")
	local il, rp = w and w:FindFirstChild("Islands"), RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	local s0, to, wq, si, e0 = Vector3.new(mn.Position.X, 0, mn.Position.Z), pt and Vector3.new(pt.X, 0, pt.Z) or Vector3.new(cp.X, 0, cp.Z), {}, vi(mn.Position), nil
	for _, x in cs:GetTagged("IslandRegion") do
		if x:IsA("BasePart") and si ~= id and x:GetAttribute("islandId") == si then
			local c = Vector3.new(x.Position.X, 0, x.Position.Z)
			local q = s0 - c
			if q.Magnitude > 1 and (to - s0):Dot(c - s0) > 0 then e0 = c + q.Unit * math.max(q.Magnitude, x.Size.X / 2 * 0.7 + 60) end
		end
	end
	local sb = e0 or s0
	for _, x in cs:GetTagged("IslandRegion") do
		local xi = x:GetAttribute("islandId")
		if x:IsA("BasePart") and xi ~= id and (e0 or xi ~= si) then
			local c, rr, d = Vector3.new(x.Position.X, 0, x.Position.Z), x.Size.X / 2 * 0.7, to - sb
			local t = math.clamp((c - sb):Dot(d) / math.max(d:Dot(d), 1), 0, 1)
			local pc = sb + d * t
			if (c - pc).Magnitude < rr then
				local of = (pc - c).Magnitude > 1 and (pc - c).Unit or Vector3.new(-d.Z, 0, d.X).Unit
				table.insert(wq, {t, c + of * (rr + 60)})
			end
		end
	end
	table.sort(wq, function(a, b) return a[1] < b[1] end)
	local ws = {e0}
	for _, x in wq do table.insert(ws, x[2]) end
	table.insert(ws, to)
	local th, st, er, dn, sh, hl = 0, 0, nil, false, nil, math.max(mn.Size.X, mn.Size.Z) / 2 + 3
	local cn = game:GetService("RunService").Stepped:Connect(function() ds.ThrottleFloat, ds.SteerFloat = th, st end)
	local ln = 0
	for k, x in ws do ln += (x - (k > 1 and ws[k - 1] or s0)).Magnitude end
	local wi, lb, lt, dl, ru, nr = 1, math.huge, os.clock(), os.clock() + ln / 15 + 60, 0, 0
	local function fw(v, a, l)
		local u = CFrame.Angles(0, a, 0):VectorToWorldSpace(v)
		return workspace:Raycast(Vector3.new(mn.Position.X, 5, mn.Position.Z), u * l, rp)
	end
	while f.st == "Running" do
		task.wait(0.1)
		if ds.Occupant ~= h then er = "Left Boat"; break end
		local p = Vector3.new(mn.Position.X, 0, mn.Position.Z)
		local on = ic() == id or vi(mn.Position) == id
		if on and not pt and wi == #ws then
			local mp, mx = ns("npc_car_merchant", mn.Position)
			if mp and mx:GetAttribute("IslandId") == id then
				local nq = Vector3.new(mp.X, 0, mp.Z)
				if (nq - ws[wi]).Magnitude > 1 then ws[wi], lb = nq, math.huge end
			end
		end
		local d = ws[wi] - p
		if wi < #ws and d.Magnitude < 40 then
			wi, lb = wi + 1, math.huge
			continue
		end
		local lv = Vector3.new(mn.CFrame.LookVector.X, 0, mn.CFrame.LookVector.Z).Unit
		if pt and d.Magnitude < 5 then dn = true; break end
		if not pt and on and wi == #ws then
			local fr = il and workspace:Raycast(Vector3.new(p.X, 103, p.Z) + lv * hl, Vector3.new(0, -100, 0), rp)
			if fr or d.Magnitude < 18 then sh, dn = fr and fr.Position, true; break end
		end
		if d.Magnitude < lb - 1 then lb, lt = d.Magnitude, os.clock() end
		if os.clock() < ru then
			continue
		end
		if os.clock() - lt > 4 then
			nr += 1
			if nr > 4 then er = "Boat Stuck"; break end
			th, st, ru, lt = -1, (nr % 2 == 0 and 1 or -1), os.clock() + 1.5, os.clock() + 1.5
			continue
		end
		local du = d.Unit
		local e = math.atan2(lv:Cross(du).Y, lv:Dot(du))
		st, th = math.clamp(-e / math.rad(25), -1, 1), math.abs(e) > math.rad(70) and 0.4 or (d.Magnitude < 60 and wi == #ws) and 0.6 or 1
		if not (on and wi == #ws) and fw(lv, 0, 30) then
			local lf, rt = fw(lv, math.rad(40), 30) or fw(lv, math.rad(80), 20), fw(lv, math.rad(-40), 30) or fw(lv, math.rad(-80), 20)
			st, th = (not lf and rt) and -1 or (lf and not rt) and 1 or (e > 0 and -1 or 1), 0.5
		end
		if os.clock() > dl then er = "Boat Timeout"; break end
	end
	th, st = 0, 0
	task.wait(0.8)
	cn:Disconnect()
	ds.ThrottleFloat, ds.SteerFloat = 0, 0
	local dd = os.clock() + 3
	while ds.Occupant == h and os.clock() < dd do
		h.Sit, h.Jump = false, true
		task.wait(0.2)
	end
	local _, r = lc()
	local hj = pt and r and mo(r.Position, 30)
	task.wait(pt and 1 or 0.3)
	if er or not dn then
		if hj then hj:Stop() end
		return nil, er
	end
	return true, sh
end

local function dv(f, m, id, pt)
	if pm.on then return dp(f, m, id, pt) end
	local _, _, h = lc()
	local mn, ds = m:FindFirstChild("Main"), m:FindFirstChild("DSeat")
	local ap, ao = mn and mn:FindFirstChild("AlignPosition"), mn and mn:FindFirstChild("AlignOrientation")
	local cp = rg(id)
	if not (h and ds and ap and ao) then return nil, "Bad Boat" end
	if not cp then return nil, "No Island Region" end
	local sp, y, cc = m:GetAttribute("Speed") or 30, ap.Position.Y, {}
	for _, x in {m, lp.Character} do
		for _, p in x:GetDescendants() do
			if p:IsA("BasePart") then cc[p] = p.CanCollide end
		end
	end
	local w = workspace:FindFirstChild("World")
	local il, rp = w and w:FindFirstChild("Islands"), RaycastParams.new()
	rp.FilterType, rp.FilterDescendantsInstances = Enum.RaycastFilterType.Include, {il}
	local tp, to, er, cn, on, sh = Vector3.new(mn.Position.X, 0, mn.Position.Z), pt and Vector3.new(pt.X, 0, pt.Z) or Vector3.new(cp.X, 0, cp.Z), nil, nil, false, nil
	local hd, hl = (to - tp).Unit, math.max(mn.Size.X, mn.Size.Z) / 2 + 3
	cn = game:GetService("RunService").Stepped:Connect(function(_, dt)
		local ok, e = pcall(function()
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

local function ti(f, id, k)
	if ic() == id then return true end
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
	f.sc = os.clock() + 20
	sa()
	return (fd())
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
	for k = 10, 300, 5 do
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
	return dv(f, m, id, pt)
end

local function bo(f)
	local ev, dk = rv.EventController and rv.EventController._active_events, pd()
	if type(ev) ~= "table" or next(ev) == nil then f.s.bc = false end
	if f.s.bc or dk and dk.LastBossKillSlot == math.floor(workspace:GetServerTimeNow() / 2400) * 2400 then return nil end
	if os.clock() < (f.bl or 0) then return nil end
	local x = br(f)
	if not x then return nil end
	local id, q = x.Parent and x.Parent.Parent and x.Parent.Parent.Name, Vector3.new(x.Position.X, 3, x.Position.Z)
	local _, r, h = lc()
	if not r then return nil, "No Character" end
	f.br = x
	local sw = rv.Swimming and rv.Swimming:IsSwimming()
	if ((r.Position - q) * Vector3.new(1, 0, 1)).Magnitude <= 45 and not h.SeatPart and not sw then return q end
	if not (f.hm or f.bb or sw or h.SeatPart) and ic() ~= "" then f.hm = {r.CFrame, ic()} end
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
	{"bamboo_rod", "island_volcano", "island_volcano", "Bamboo Rod", {RequiredCoin = 3600000, RequiredBamboo = 20}, nil, "crimson_bead_rod"},
	{"heaven_piercer_turtle_rod", "island_fossil", "island_fossil", "Heaven Piercer Turtle Rod", {RequiredCoin = 5000000, RequiredFish = 5}, {"Legendary", "island_fossil"}},
	{"zen_staff_rod", "island_fossil", "island_fossil", "Zen Staff Rod", {RequiredFish = 0}},
	{"dread_fish_rod", "island_fossil", "island_fossil", "Dread Fish Rod", {RequiredCoin = 10000000, RequiredFish = 1}, {"Mythical", "island_fossil"}},
}, {}, {}
for _, q in qt do
	table.insert(qz, q[4])
	qm[q[4]] = q
end

local function qc(q, d, pr)
	local ct, n, ks, df, id, rr = md("Data", "Catalog"), {}, {}, {}, q[1], q[6]
	local wk = id == "unlock_island_6" and md("Data", "Config", "QuestConfig").UnlockIsland6MinWeightKg or {}
	if rr then
		for _, x in (ct.Island.GetById(rr[2]) or {}).fishes or {} do df[x.fishId] = true end
	end
	local rf = rr and {["*"] = pr.RequiredFish or 1} or pr.RequiredFishes or {}
	for u, x in d.Inventory and d.Inventory.Fishes or {} do
		local fi = ct.Fish.GetById(x.fishId)
		local k = rr and fi and fi.rarity == rr[1] and df[x.fishId] and "*" or not rr and rf[x.fishId] and (id ~= "unlock_island_6" or wk[x.fishId] and (x.weight or 0) >= wk[x.fishId]) and x.fishId
		if k and (n[k] or 0) < rf[k] then n[k], ks[u] = (n[k] or 0) + 1, true end
	end
	local ok = (d.Coin or 0) >= (pr.RequiredCoin or 0)
	for k, v in rf do
		if (n[k] or 0) < v then ok = false end
	end
	if id == "crimson_bead_rod" and (pr.CurrentFished or 0) < (pr.RequiredFished or 1) then ok = false end
	if id == "zen_staff_rod" and (pr.CurrentFish or 0) < (pr.RequiredFish or 1) then ok = false end
	if id == "bamboo_rod" and md("Shared", "getItemCount")(d, "bamboo_fragment") < (pr.RequiredBamboo or 1) then ok = false end
	return ok, ks
end

local function qn(f)
	for _, q in qd do
		if not ul(q[3]) then return ul(q[2]) and not f.qx[q[1]] and q or nil end
	end
	return nil
end

local function qw(f, k, t)
	if f.qw[k] then return end
	f.qw[k], f.nq = true, {Title = "Rod Quest", Text = t}
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
	return q
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

local function ug(f, q, ac)
	local ok, e = ti(f, q[3], f.bk())
	if not ok then return nil, e or f.st == "Running" and "Move Failed" or nil end
	local c, rt = lc()
	if not rt then return nil, "No Character" end
	local np = gn(q)
	if not np then return nil, "No Island Guide" end
	local sp = ap(c, np, rt.Position)
	ok, e = (q[1] == "zen_staff_rod" and gf or go)(f, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
	if not ok then return nil, e or f.st == "Running" and "Move Failed" or nil end
	if f.st ~= "Running" then return nil end
	local qr, iu = rv.QuestController, q[1]:find("^unlock_island_") ~= nil
	local tt, px = iu and "Island Guide" or "Rod Quest", iu and "Unlock Island Failed" or "Rod Quest Failed"
	local function dn() return ((pd().Quest or {}).Done or {})[q[1]] == true end
	if not ac then
		local a, m = qr:Accept(q[1])
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
	local cp, m = qr:Complete(q[1])
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
	if hk and f.st == "Running" and ic() == oi then hk, he = go(f, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
	f.rp = f.rp or not hk
	return true, not ok and e or not hk and f.st == "Running" and (he or "Return Failed") or nil
end

local function ss(f)
	local s, fc = f.s, rv.FishingController
	local ks = sk()
	if #ks == 0 then return "Auto Fish Failed: No Skill Equipped" end
	local bp, be
	if f.ab() then bp, be = bo(f) end
	f.bu = bp ~= nil
	if be then return nil, be end
	if not bp and f.bb then f.bb, f.rp = false, true end
	if not bp and f.hm then
		local o, oi = f.hm[1], f.hm[2]
		local ok, e = true, nil
		if ic() ~= oi then ok, e = ti(f, oi, f.bk()) end
		if ok and f.st == "Running" then ok, e = go(f, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
		if f.st ~= "Running" then return nil end
		if not ok then return nil, e or "Return Failed" end
		f.hm, f.rp = nil, false
		return nil
	end
	if not bp then
		for _, q in {f.au() and qn(f) or false, f.qa() and qp(f) or false} do
			local u, ue = uq(f, q or nil)
			if u or ue then return nil, ue end
		end
	end
	local fi = not bp and f.fi()
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
	if not bp and (f.rp or not tg(h)) then
		f.rp = false
		local g = if pm.on then rs(vf, vi(h.Position)) else rs()
		if not g and pm.on then
			f.rp = true
			return nil, "No Reachable Spot"
		end
		if not g then return "Auto Fish Failed: No Open Water" end
		local q = tg({Position = g})
		local mk, me = go(f, g, q and ((q - g) * Vector3.new(1, 0, 1)).Unit)
		if not mk then return nil, me end
	end
	if pm.on and not bp and rv.Swimming and rv.Swimming:IsSwimming() then
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
	local re = s.rl and f.st == "Running" and rl(f, s, ks, bf and 900 or 180) or not (s.cr or s.rr) and f.st == "Running" and "Bite Timeout"
	if bf and not (s.cr and s.cr[1]) then f.bl = os.clock() + 180 end
	if f.st ~= "Running" or re then
		if not (s.cr or s.rr) then fc.FishCancel:Fire(); task.wait(1) end
		return nil, re
	end
	if bp and s.rr == "IslandLocked" then
		f.bx, f.bb, f.rp = f.br, false, true
		return nil
	end
	if s.rr == "NoSkillEquipped" then return "Auto Fish Failed: No Skill Equipped" end
	if s.rr == "SatchelFull" and not f.ao() then return "Auto Fish Failed: Satchel Full" end
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
		if f.iw() then
			task.wait(0.5)
			continue
		end
		f.bz = true
		local hd, sf = ss(f)
		f.bz = false
		if hd then f.why = hd; return end
		n = sf and n + 1 or 0
		if n >= 5 then f.why = `Auto Fish Failed: {sf}`; return end
		if sf then task.wait(1) end
	end
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
	if o.Config ~= nil and (type(o.Config) ~= "string" or not o.Config:match("^[%w _%-]+$")) then error("Window Failed: Bad Config") end
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
	local bar = mk("ScrollingFrame", {Parent = w, Position = UDim2.fromOffset(12, 44), Size = UDim2.new(0, 110, 1, -56), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.Y, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y}, {mk("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})})
	local fa = mk("Frame", {Parent = w, Position = UDim2.fromOffset(12, 44), Size = UDim2.fromOffset(110, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0, 1)})})
	local fz = mk("Frame", {Parent = w, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.fromOffset(110, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)})})
	mk("Frame", {Parent = w, Position = UDim2.fromOffset(130, 44), Size = UDim2.new(0, 1, 1, -56), BackgroundColor3 = c.sk, BorderSizePixel = 0})
	local bd = mk("Frame", {Parent = w, Position = UDim2.fromOffset(131, 44), Size = UDim2.new(1, -131, 1, -56), BackgroundTransparency = 1})
	local pa = mk("Frame", {Parent = w, Position = UDim2.fromOffset(143, 44), Size = UDim2.new(1, -155, 0, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(0, 1)})})
	local pz = mk("Frame", {Parent = w, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 143, 1, -12), Size = UDim2.new(1, -155, 0, 20), BackgroundColor3 = c.bg, BorderSizePixel = 0, Visible = false}, {mk("UIGradient", {Rotation = 90, Transparency = NumberSequence.new(1, 0)})})
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
	local wp, zm, lg, lq = Vector2.new(v0.X / 2, (v0.Y + t0) / 2), 1, nil, false
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
		return math.clamp(math.min((v.X - 24) / ww, (v.Y - t - 24) / wh, zm), 0.5, 2)
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
			if not isfolder("Avenoric/Configs") then makefolder("Avenoric/Configs") end
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
	zm = math.clamp(tonumber(lv("_z")) or 1, 0.5, 2)
	local lh = lv("_f")
	if type(lh) == "table" and tonumber(lh[1]) and tonumber(lh[2]) then lg = Vector2.new(tonumber(lh[1]), tonumber(lh[2])) end

	local function tg()
		w.Visible = not w.Visible
	end

	local function ed()
		local y = bar.CanvasPosition.Y
		fa.Visible, fz.Visible = y > 1, y < bar.AbsoluteCanvasSize.Y - bar.AbsoluteWindowSize.Y - 1
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
	local z0, s0, tl0
	dg(gz, cs, function()
		z0, s0 = us.Scale, Vector2.new(ww, wh) * us.Scale
		tl0 = wp - s0 / 2
	end, function(d)
		zm = math.clamp(z0 * (1 + (d.X / s0.X + d.Y / s0.Y) / 2), 0.5, 2)
		us.Scale = zs()
		qs.Scale, zm = us.Scale, us.Scale
		wp = tl0 + Vector2.new(ww, wh) * us.Scale / 2
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
				tws:Create(k, TweenInfo.new(0.15), {BackgroundColor3 = v and c.tx or c.sk}):Play()
				tws:Create(d, TweenInfo.new(0.15), {Position = UDim2.new(0, v and 19 or 3, 0.5, 0), BackgroundColor3 = v and c.bg or c.tx}):Play()
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
local dq = (function()
	local function mi(k, q)
		local x = Instance.new(k)
		for a, v in q do x[a] = v end
		return x
	end
	local sg, ch = mi("ScreenGui", {Name = game:GetService("HttpService"):GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000}), nil
	if ge.__FmD then pcall(function() ge.__FmD:Destroy() end) end
	ge.__FmD = sg
	if not pcall(function() sg.Parent = gethui() end) then sg.Parent = lp:WaitForChild("PlayerGui") end
	local fr = mi("Frame", {Parent = sg, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(300, 140), BackgroundColor3 = Color3.fromRGB(37, 37, 34), BorderSizePixel = 0})
	mi("UICorner", {Parent = fr, CornerRadius = UDim.new(0, 10)})
	mi("UIStroke", {Parent = fr, Color = Color3.fromRGB(72, 72, 66), Thickness = 1})
	mi("TextLabel", {Parent = fr, BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 14), Size = UDim2.new(1, -32, 0, 22), Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.fromRGB(244, 240, 232), Text = "Ngao-Gaming Hub"})
	mi("TextLabel", {Parent = fr, BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 42), Size = UDim2.new(1, -32, 0, 36), Font = Enum.Font.GothamMedium, TextSize = 13, TextWrapped = true, TextColor3 = Color3.fromRGB(150, 147, 140), Text = "Support The Hub? Donate To Keep It Free"})
	for _, x in {{"Donate", 16, Color3.fromRGB(244, 240, 232), Color3.fromRGB(37, 37, 34), "d"}, {"No", 156, Color3.fromRGB(62, 62, 57), Color3.fromRGB(244, 240, 232), "n"}} do
		local b = mi("TextButton", {Parent = fr, Position = UDim2.fromOffset(x[2], 92), Size = UDim2.fromOffset(128, 34), BackgroundColor3 = x[3], BorderSizePixel = 0, AutoButtonColor = true, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = x[4], Text = x[1]})
		mi("UICorner", {Parent = b, CornerRadius = UDim.new(0, 8)})
		b.Activated:Connect(function() ch = ch or x[5] end)
	end
	repeat task.wait() until ch or ge.__FmD ~= sg
	if ge.__FmD ~= sg then error("Donate Prompt Replaced", 0) end
	ge.__FmD = nil
	sg:Destroy()
	if ch ~= "d" then return nil end
	local cf = setclipboard or toclipboard
	if not cf then return "Copy Failed: No Clipboard" end
	local ok = pcall(cf, "https://linkfree.click/s/ngao-gaming-hubz1u17pnmunx0jzb")
	return ok and "Link Copied" or "Copy Failed: Clipboard Error"
end)()
local gw = L:Window({Title = "Ngao-Gaming Hub | Fishing Master", Config = "FishingMaster", Icon = gi})
if dq then gw:Notify({Title = "Donate", Text = dq}) end
local gt, ft = gw:Tab({Name = "General"}), nil

local function cx(fn, ...)
	local r, dn
	task.spawn(function(...) r = table.pack(pcall(fn, ...)); dn = true end, ...)
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
	table.insert(f.cs, rv.BossRegionController.BossSpawnClaimed.OnClientEvent:Connect(function(v) if v == true then s.bc = true end end))
	table.insert(f.cs, rv.RodController.ReplicatedSkillCooldown.OnClientEvent:Connect(function(t)
		if typeof(t) ~= "table" then return end
		for k, v in t do
			if type(v) == "table" and type(v.phase) == "string" then s.cd[k] = {v.phase, os.clock() + (tonumber(v.remaining) or 0)} end
		end
	end))
	local ok, e = pcall(rn, f)
	for _, c in f.cs do c:Disconnect() end
	if cj then cj:Stop() end
	if not ok then error(e, 0) end
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
	function f.kp()
		local k = f.au() and qv(qn(f)) or {}
		for u in f.qa() and qv(qp(f)) or {} do k[u] = true end
		return k
	end
	function f.sr() return L.Flags.sr or {} end
	function f.fi() return ix[L.Flags.fi] end
	function f.ab() return L.Flags.ab == true end
	function f.bk() return bi[L.Flags.sb] or "truck" end
	function f.iw()
		local j, id, g, b = ge.__FmI, ix[L.Flags.si], ge.__FmG, ge.__FmR
		return g and not g.dn and (g.bz or g.rq and not f.bu) or b and not b.dn and (b.bz or b.rq and not f.bu) or j and not j.dn and (j.bz or id and ic() ~= id) or false
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

local ga, gm = {"Skill Master", "Ocean Chest", "Dragon Chest", "Aura"}, {["Ocean Chest"] = "crate_ocean_chest", ["Dragon Chest"] = "crate_dragon_chest"}

local function gl(j)
	local sc = rv.SkillGachaController
	while j.st == "Running" do
		local k, cr = L.Flags.gr == "x10" and 10 or 1, gm[L.Flags.gk]
		local cc = cr and md("Data", "Config", "CrateConfig").GetCrate(cr)
		if cr and not cc then
			j.why = "Auto Roll Failed: No Chest"
			return
		end
		local ag = L.Flags.gk == "Aura" and md("Data", "Config", "AuraGachaConfig").Pull
		local nm, ni = cc and cc.DisplayName or ag and "Aura" or "Skill Master", cr or ag and "npc_gacha_aura" or "npc_gacha_book"
		local function ca()
			local d = pd()
			if cc then return (((d.CrateGacha or {}).Credits or {})[cr] or 0) >= k or ((cc.Currency == "Coin" and d.Coin or d.Gem) or 0) >= (cc.Prices[k] or math.huge) end
			if ag then return ((d.AuraGacha or {}).Credits or 0) >= k or (d.Gem or 0) >= math.ceil(ag.CostGem * k * (ag.BulkDiscount[k] or 1)) end
			local q = sc.GetQuote:Fire(k)
			if type(q) ~= "table" or not q.ok then return nil, type(q) == "table" and q.reason or "No Quote" end
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
		while j.st == "Running" and (fm and not fm.dn and (fm.bz or fm.bu) or ge.__FmR and not ge.__FmR.dn and ge.__FmR.bz or ge.__FmI and not ge.__FmI.dn) do task.wait(0.5) end
		if j.st ~= "Running" then return end
		j.bz, j.rq = true, false
		local _, rt = lc()
		if not rt then
			j.why = "Auto Roll Failed: No Character"
			return
		end
		local o, oi, bk = rt.CFrame, ic(), bi[L.Flags.sb] or "truck"
		local w, we = ti(j, "island_starter", bk)
		local r, np
		if w then
			local c, r2 = lc()
			np = r2 and ns(ni, r2.Position)
			if r2 and not np then
				local g = rg("island_starter")
				if g then sq(Vector3.new(g.X, 2, g.Z), 10) end
				np = ns(ni, r2.Position)
			end
			if not r2 then w, we = nil, "No Character" elseif not np then w, we = nil, `No {nm}` else
				local sp = ap(c, np, r2.Position)
				w, we = go(j, sp, Vector3.new(np.X - sp.X, 0, np.Z - sp.Z).Unit)
			end
		end
		while w and j.st == "Running" do
			r = cc and rv.CrateGachaController.OpenPacket:Fire(cr, k) or ag and rv.AuraGachaController.Pull:Fire(k) or not (cc or ag) and sc.Pull:Fire("Coin", k)
			if type(r) ~= "table" or not r.ok then break end
			local ct, t = md("Data", "Catalog"), {}
			for _, x in r.results or {} do
				local sv = cc and ct.RodSkin.GetById(x.rod_skin_id) or ag and ct.Aura.GetById(x.aura_id) or not (cc or ag) and ct.Skill.GetById(x.skill_id)
				table.insert(t, `{sv and sv.name or x.rod_skin_id or x.aura_id or x.skill_id} ({x.rarity})`)
			end
			j.nt = {Title = nm, Text = table.concat(t, ", ")}
			task.wait(1)
			if not ca() then break end
		end
		local hk, he = true, nil
		if j.st == "Running" and oi ~= "" and ic() ~= oi then hk, he = ti(j, oi, bk) end
		if hk and j.st == "Running" and ic() == oi then hk, he = go(j, o.Position, Vector3.new(o.LookVector.X, 0, o.LookVector.Z).Unit) end
		j.bz = false
		if j.st ~= "Running" then return end
		if not w then
			j.why = `Auto Roll Failed: {we or "Move Failed"}`
			return
		end
		if type(r) ~= "table" then
			j.why = "Auto Roll Failed: No Response"
			return
		end
		if not r.ok and r.reason ~= "insufficient_coin" and r.reason ~= "insufficient_gem" then
			j.why = `Auto Roll Failed: {r.reason}`
			return
		end
		if not hk then
			j.why = `Auto Roll Failed: Return Failed: {he or "Move Failed"}`
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
		while j.st == "Running" and (fm and not fm.dn and (fm.bz or fm.bu) or ge.__FmG and not ge.__FmG.dn and ge.__FmG.bz or ge.__FmI and not ge.__FmI.dn) do task.wait(0.5) end
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
gt:Dropdown({Name = "Select Farm Island", Options = {"Current Island", table.unpack(iz)}, Default = "Current Island", Flag = "fi"})
ft = gt:Toggle({Name = "Auto Fish", Flag = "af", Callback = function(v)
	if v then fs() elseif ge.__FmF then ge.__FmF.st = "Stopped" end
end})
gt:Toggle({Name = "Auto Boss", Flag = "ab"})

gt:Section({Name = "Quest"})
gt:Dropdown({Name = "Select Rod Quest", Options = qz, Flag = "qs"})
gt:Toggle({Name = "Auto Rod Quest", Flag = "qa"})
gt:Toggle({Name = "Auto Unlock Island", Flag = "au"})

gt:Section({Name = "Sell"})
gt:Dropdown({Name = "Sell Rarity", Options = ra, Default = {}, Multi = true, Flag = "sr"})
gt:Toggle({Name = "Auto Sell", Flag = "as"})

local tq = gw:Tab({Name = "Shop"})
tq:Section({Name = "Gacha"})
tq:Dropdown({Name = "Select Gacha", Options = ga, Default = "Skill Master", Flag = "gk"})
tq:Dropdown({Name = "Select Roll", Options = {"x1", "x10"}, Default = "x1", Flag = "gr"})
gs = tq:Toggle({Name = "Auto Roll", Flag = "gs", Callback = function(v)
	if v then gg() elseif ge.__FmG then ge.__FmG.st = "Stopped" end
end})
tq:Section({Name = "Rod"})
tq:Dropdown({Name = "Select Rod", Options = rz, Flag = "rd"})
rk = tq:Toggle({Name = "Auto Buy Rod", Flag = "rb", Callback = function(v)
	if v then
		if it then it:Set(false) end
		rh()
	elseif ge.__FmR then ge.__FmR.st = "Stopped" end
end})

local tl = gw:Tab({Name = "Teleport"})
tl:Section({Name = "Island"})
tl:Dropdown({Name = "Select Island", Options = iz, Flag = "si"})
it = tl:Toggle({Name = "Auto Island", Flag = "ai", Callback = function(v)
	if v then
		if rk then rk:Set(false) end
		is()
	elseif ge.__FmI then ge.__FmI.st = "Stopped" end
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
	local tv = gw:Tab({Name = "Visual"})
	tv:Section({Name = "Effect"})
	tv:Dropdown({Name = "Rod Skin", Options = eo[1][1], Default = "Default", Flag = "es", Callback = function(v) ep("RodSkinId", eo[1][2][v]) end})
	tv:Dropdown({Name = "Aura", Options = eo[2][1], Default = "Default", Flag = "ea", Callback = function(v) ep("AuraCatalogId", eo[2][2][v]) end})
end

local ts = gw:Tab({Name = "Setting"})
ts:Section({Name = "Game"})
ts:Dropdown({Name = "Select Boat", Options = bn, Default = "Truck", Flag = "sb"})
ts:Toggle({Name = "Player Mode (Beta)", Flag = "pm", Callback = function(v) pm.on = v == true end})

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
	local function mi(k, q)
		local x = Instance.new(k)
		for a, v in q do x[a] = v end
		return x
	end
	local hs = lp.PlayerGui:FindFirstChild("HUD")
	local sg = mi("ScreenGui", {Name = game:GetService("HttpService"):GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = hs and hs:IsA("ScreenGui") and hs.IgnoreGuiInset or false, DisplayOrder = 10})
	if not pcall(function() sg.Parent = gethui() end) then sg.Parent = lp.PlayerGui end
	table.insert(cs, sg)
	local fr = mi("Frame", {Parent = sg, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, (sg.IgnoreGuiInset and game:GetService("GuiService"):GetGuiInset().Y or 0) + 8), Size = UDim2.fromOffset(420, 60), BackgroundColor3 = Color3.fromRGB(37, 37, 34), BorderSizePixel = 0, Visible = false})
	mi("UICorner", {Parent = fr, CornerRadius = UDim.new(0, 8)})
	mi("UIStroke", {Parent = fr, Color = Color3.fromRGB(72, 72, 66), Thickness = 1})
	local function lb(q)
		q.Parent, q.BackgroundTransparency, q.TextXAlignment, q.TextTruncate = fr, 1, q.TextXAlignment or Enum.TextXAlignment.Left, Enum.TextTruncate.AtEnd
		return mi("TextLabel", q)
	end
	local t1 = lb({Position = UDim2.fromOffset(12, 6), Size = UDim2.new(1, -74, 0, 18), Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Color3.fromRGB(244, 240, 232)})
	local t2 = lb({Position = UDim2.new(1, -62, 0, 6), Size = UDim2.fromOffset(50, 18), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(150, 147, 140), TextXAlignment = Enum.TextXAlignment.Right})
	local bg = mi("Frame", {Parent = fr, Position = UDim2.fromOffset(12, 29), Size = UDim2.new(1, -24, 0, 8), BackgroundColor3 = Color3.fromRGB(72, 72, 66), BorderSizePixel = 0})
	mi("UICorner", {Parent = bg, CornerRadius = UDim.new(0, 4)})
	local fi = mi("Frame", {Parent = bg, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(214, 106, 94), BorderSizePixel = 0})
	mi("UICorner", {Parent = fi, CornerRadius = UDim.new(0, 4)})
	local t3 = lb({Position = UDim2.fromOffset(12, 40), Size = UDim2.new(1, -24, 0, 16), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Color3.fromRGB(150, 147, 140)})
	for x, v in {[t1] = 14, [t3] = 12} do
		x.TextScaled, x.TextTruncate = true, Enum.TextTruncate.None
		mi("UITextSizeConstraint", {Parent = x, MaxTextSize = v, MinTextSize = 9})
	end
	local st, im, nr, iy = nil, nil, 0, {}
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
			fr.Visible = ek ~= nil or st ~= nil
			if not fr.Visible then return end
			if os.clock() >= nr then
				nr, im = os.clock() + 1, nil
				for _, x in game:GetService("CollectionService"):GetTagged("BossRegion") do
					local fx = x:FindFirstChild("BossSpawnerFX")
					if fx and fx:GetAttribute("BossSpawnerFXActive") == true and x.Parent and x.Parent.Parent then im = iy[x.Parent.Parent.Name] or x.Parent.Parent.Name end
				end
			end
			local lf, bo2 = math.floor(ex - workspace:GetServerTimeNow()), ek ~= nil and (not st or st[5])
			t1.Text = (st and st[1] or en[ek] or "Boss") .. (bo2 and im and ` - {im}` or "")
			t2.Text = bo2 and lf > 0 and string.format("%d:%02d", lf // 60, lf % 60) or ""
			bg.Visible = st ~= nil
			if st then
				fi.Size = UDim2.fromScale(math.clamp(st[2] / math.max(st[3], 1), 0, 1), 1)
				t3.Text = `{nf(st[2])} / {nf(st[3])}` .. (st[5] and ` - Phase {st[4]}` or "")
			else
				t3.Text = "Not Hooked"
			end
		end)
	end))
end

task.spawn(bh)
