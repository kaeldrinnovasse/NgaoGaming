if not game:IsLoaded() then game.Loaded:Wait() end

local ps, rs = game:GetService("Players"), game:GetService("ReplicatedStorage")
repeat task.wait() until ps.LocalPlayer

local lp = ps.LocalPlayer
local pgu = lp:WaitForChild("PlayerGui")
local function ld()
	local c = lp.Character
	if type(lp:GetAttribute("Cash")) ~= "number" or not pgu:FindFirstChild("MainGUI") or not (c and c:FindFirstChild("HumanoidRootPart")) then return false end
	local pz = workspace:FindFirstChild("Plots")
	for _, p in pz and pz:GetChildren() or {} do
		if p:GetAttribute("OwnerUserId") == lp.UserId then return true end
	end
	return false
end
while not ld() do task.wait(0.5) end

local ge = getgenv()
if ge.__BseAf then
	ge.__BseAf.on, ge.__BseAf.fa, ge.__BseAf.eb, ge.__BseAf.bg = false, false, false, false
	if ge.__BseAf.fj then ge.__BseAf.fj.st = "Stopped" end
	if ge.__BseAf.ec then ge.__BseAf.ec:Disconnect() end
	if ge.__BseAf.ic then ge.__BseAf.ic:Disconnect() end
	for _, x in ge.__BseAf.pc or {} do x:Disconnect() end
	if ge.__BseAf.cc then ge.__BseAf.cc:Disconnect() end
	if ge.__BseAf.sc then ge.__BseAf.sc:Disconnect() end
end
local st = {bg = true, ic = nil, za = 1, fa = false, fg = 0, fj = nil, id = 1e6, le = nil, mt = nil, ma = nil, hs = {}, pc = nil, lx = nil, lt = 0, rb = false, cc = nil, ck = nil, ra = {}, tb = false, sv = {}, as = false, sb = false, sc = nil, pi = false, ix = nil, nf = nil, ti = false, ua = false, ub = false, uc = false, ud = false, hq = false, hp = -math.huge, eh = false, hj = nil, hd = 3, hz = -math.huge}
ge.__BseAf = st
st.cc = lp.CharacterAdded:Connect(function(c)
	st.rb, st.mt = true, nil
	task.spawn(function()
		c:WaitForChild("HumanoidRootPart", 10)
		c:WaitForChild("Humanoid", 10)
		task.wait(2)
		if lp.Character == c then st.rb = false end
	end)
end)
local function rw()
	while st.rb do task.wait(0.1) end
end
st.kh = setmetatable({}, {__mode = "k"})
st.pc = {rs:WaitForChild("EggHitConfirmed").OnClientEvent:Connect(function(e, _, h) if typeof(e) == "Instance" and type(h) == "number" then st.kh[e] = h end end)}

local cs, sh, hq = game:GetService("CollectionService"), rs:WaitForChild("Shared"), rs:WaitForChild("EggHitRequest")
local rx = {-40, -131, -246, -389, -580, -828, -1138, -1579, -2085, -2605, -3281}
local zx = {}
local function zr(z)
	if zx[z] then return zx[z][1], zx[z][2] end
	local b = workspace:FindFirstChild("Build")
	local m = b and b:FindFirstChild("ZoneBuilds")
	m = m and m:FindFirstChild(`Zone{z}`)
	if not (m and m:IsA("Model")) then return rx[z + 2] and (rx[z + 1] + rx[z + 2]) / 2 or -math.huge, (rx[z] + rx[z + 1]) / 2 end
	local c, s = m:GetBoundingBox()
	zx[z] = {c.X - s.X / 2, c.X + s.X / 2}
	return zx[z][1], zx[z][2]
end

local et, rc, er, r0, r1, zm
local function md()
	if et then return end
	local ec, ac = require(sh:WaitForChild("EggConfig")), require(sh:WaitForChild("AutoSwingConfig"))
	r0 = math.max(0, ec.HitRange - ac.RangeMargin)
	r1 = math.max(r0, ec.HitRange - ac.StickyRangeMargin)
	et, rc, er = require(sh:WaitForChild("EggTargeting")), require(sh:WaitForChild("RobuxShopConfig")), require(sh:WaitForChild("EggRewards"))
	zm = {}
	for i, z in require(sh:WaitForChild("ZoneAnimalsConfig")).Zones do
		local l = {}
		for k, v in z.Animals or z do table.insert(l, tostring(type(v) == "table" and v.Name or k)) end
		zm[i] = l
	end
end

local function lc()
	local c = lp.Character
	local r, h = c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
	if r and h and h.Health > 0 and r:IsA("BasePart") then return c, r, h end
	return nil
end

local function gy(x, z, ex)
	local q = RaycastParams.new()
	q.FilterType, q.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {lp.Character, ex}
	local y0 = 40
	if typeof(ex) == "Instance" and ex:IsA("BasePart") then
		y0 = ex.Position.Y - ex.Size.Y / 2 + 5
	elseif typeof(ex) == "Instance" and ex:IsA("Model") then
		local c, sz = ex:GetBoundingBox()
		y0 = c.Y - sz.Y / 2 + 5
	end
	local g = workspace:Raycast(Vector3.new(x, y0, z), Vector3.new(0, -120, 0), q)
	return Vector3.new(x, (g and g.Position.Y or y0 - 5) + 3, z)
end

local function op()
	for _, p in workspace:WaitForChild("Plots"):GetChildren() do
		if p:GetAttribute("OwnerUserId") == lp.UserId then return p end
	end
	return nil
end

local function fr()
	local _, r = lc()
	if not (r and r.Anchored) then return end
	rs:WaitForChild("TreadmillSessionRemote"):FireServer()
	local t = os.clock()
	repeat task.wait(0.1) until not r.Anchored or os.clock() - t > 5
end

local ru = game:GetService("RunService")
pcall(ru.UnbindFromRenderStep, ru, "BseWalk")
ru:BindToRenderStep("BseWalk", Enum.RenderPriority.Character.Value + 1, function()
	local p = st.mt
	if not p then return end
	local _, r, h = lc()
	if not r then return end
	local d = Vector3.new(p.X - r.Position.X, 0, p.Z - r.Position.Z)
	if d.Magnitude < 2 then
		st.mt, st.ma = nil, p
		h:Move(Vector3.zero, false)
		return
	end
	h:Move(d.Unit, false)
end)

local function wk(f, p, ab)
	local _, r, h = lc()
	if not r then return false end
	local dl, lq, lj, ok = os.clock() + Vector3.new(p.X - r.Position.X, 0, p.Z - r.Position.Z).Magnitude / math.max(h.WalkSpeed, 1) + 10, nil, 0, false
	st.mt, st.ma = p, nil
	while f.st == "Running" do
		_, r, h = lc()
		if not r or st.rb or os.clock() > dl or ab and ab() then break end
		if st.ma == p then
			ok = true
			break
		end
		task.wait(0.1)
		if lq and (r.Position - lq).Magnitude < 0.3 and os.clock() - lj > 1 then
			h.Jump, lj = true, os.clock()
		end
		lq = r.Position
	end
	if st.mt == p then
		st.mt = nil
		if h then h:Move(Vector3.zero, false) end
	end
	return ok
end

local function rt(f, p, ab)
	local _, r = lc()
	if not r then return false end
	local x0, x1 = r.Position.X, p.X
	if math.abs(r.Position.Z) > 12 and not wk(f, gy(x0, 0), ab) then return false end
	local ns = {}
	for _, x in rx do
		if x < x0 and x > x1 or x > x0 and x < x1 then table.insert(ns, x) end
	end
	table.sort(ns, function(a, b)
		if x1 < x0 then return a > b end
		return a < b
	end)
	for _, x in ns do
		if not wk(f, gy(x, 0), ab) then return false end
	end
	if math.abs(p.Z) > 12 and not wk(f, gy(x1, 0), ab) then return false end
	return wk(f, p, ab)
end

local function gt(f, p, ab)
	local function nr()
		local _, r = lc()
		return r ~= nil and (p - r.Position).Magnitude <= 50
	end
	if not nr() and not rt(f, p, function() return ab and ab() or nr() end) and (ab and ab() or not nr()) then return false end
	local _, r = lc()
	if not r or f.st ~= "Running" then return false end
	if (p - r.Position).Magnitude > 3 then
		r.AssemblyLinearVelocity = Vector3.zero
		r.CFrame = CFrame.new(p)
		task.wait(0.25)
	end
	return true
end

local function eq(c, h)
	if lp:GetAttribute("Carrying") ~= nil or c:GetAttribute("Ragdolled") then return end
	local t = c:FindFirstChildOfClass("Tool")
	if t and t.Name == "Pickaxe" then return end
	local b = lp:FindFirstChild("Backpack")
	t = b and b:FindFirstChild("Pickaxe")
	if t and t:IsA("Tool") then h:EquipTool(t) end
end

local function hit()
	local c, r, h = lc()
	if not c then return end
	local t = c:FindFirstChild("Pickaxe")
	if not (t and t:IsA("Tool")) then return eq(c, h) end
	local e = et.Pick(r.Position, r0, st.le, r1)
	if not e then return end
	st.id, st.le = st.id + 1, e
	hq:FireServer(e, st.id)
	return true
end

local function eg(z)
	local _, r = lc()
	if not r then return nil end
	local b, bs, bl, bd
	for _, e in cs:GetTagged("BreakableEgg") do
		if et.IsLive(e) and e:GetAttribute("ZoneIndex") == z and not e:GetAttribute("NoPickup") then
			local s = e:GetAttribute("Titanic") and 2 or (e:GetAttribute("Lucky") or cs:HasTag(e, "LuckyEgg")) and 1 or 0
			local l, d = tonumber(e:GetAttribute("HatchLuck")) or 0, (e.Position - r.Position).Magnitude
			if not b or s > bs or s == bs and (l > bl or l == bl and d < bd) then b, bs, bl, bd = e, s, l, d end
		end
	end
	return b
end

local function nk(v) return (string.gsub(string.lower(v), "%W", "")) end
local function lf(m) return (tonumber(m:GetAttribute("DespawnAtServerTime")) or 0) - workspace:GetServerTimeNow() end
local function cp(m) return er.PlacedCashPerSecond(m:GetAttribute("AnimalName") or m.Name, m:GetAttribute("SizeMult"), m:GetAttribute("Mutation"), m:GetAttribute("WeightKg"), m:GetAttribute("Variant")) end
local function wn(m)
	if st.ra[m:GetAttribute("Rarity")] then return true end
	return st.pi and st.ix ~= nil and not st.ix[nk(tostring(m:GetAttribute("AnimalName") or m.Name))]
end
local function zc()
	if not (st.ix and zm and zm[st.za]) then return st.ix == nil end
	for _, n in zm[st.za] do
		if not st.ix[nk(n)] then return false end
	end
	return true
end

local function gz(z)
	for _, m in cs:GetTagged("ZoneGuard") do
		local s = m:GetAttribute("ChaseState")
		if m:GetAttribute("ZoneId") == z and (s == "WindUp" or s == "Chasing") then return true end
	end
	return false
end

local function bp(q)
	local _, r, h = lc()
	if not r then return nil end
	local z, b, bc = `Zone{st.za}`, nil, nil
	if gz(z) then return nil end
	for _, m in cs:GetTagged("AnimalPickup") do
		if m.Parent and m:GetAttribute("ZoneId") == z and wn(m) then
			local p = m:GetBoundingBox().Position
			if lf(m) > (q and 3 or (math.abs(p.X - r.Position.X) + math.abs(p.Z) + math.abs(r.Position.Z)) / math.max(h.WalkSpeed, 1) + 2.5) then
				local v = cp(m)
				if not bc or v > bc then b, bc = m, v end
			end
		end
	end
	return b
end

local function du()
	for _, m in cs:GetTagged("AnimalPickup") do
		local hd = m:GetAttribute("HatchId")
		if hd and st.hs[hd] and m.Parent and (lf(m) <= 5 or wn(m)) then return true end
	end
	return bp() ~= nil
end

local function tk(pk, f, lim)
	local t, an = os.clock(), nk(tostring(pk:GetAttribute("AnimalName") or pk.Name))
	while pk.Parent and f.st == "Running" and lp:GetAttribute("Carrying") == nil and os.clock() - t < lim do
		local pr, pd, pc = nil, nil, pk:GetBoundingBox().Position
		for _, p in cs:GetTagged("SmartPrompt") do
			if p:IsA("ProximityPrompt") and p.Name == "StealPrompt" and p.Parent and p.Parent:IsA("BasePart") then
				local d = (p.Parent.Position - pc).Magnitude
				local nm = string.sub(nk((string.gsub(p.ObjectText, "<[^>]+>", ""))), -#an) == an
				if nm or d < 8 then
					d -= nm and 50 or 0
					if not pd or d < pd then pr, pd = p, d end
				end
			end
		end
		if gz(pk:GetAttribute("ZoneId")) then return false end
		if pr and pr.Enabled then
			fireproximityprompt(pr)
			local q = os.clock()
			repeat task.wait(0.03) until lp:GetAttribute("Carrying") ~= nil or os.clock() - q > 0.6
		else
			task.wait(0.05)
		end
	end
	if lp:GetAttribute("Carrying") == nil then return false end
	st.ck = {w = pk:GetAttribute("WeightKg"), z = pk:GetAttribute("ZoneId")}
	if st.ix then st.ix[nk(tostring(pk:GetAttribute("AnimalName") or pk.Name))] = true end
	return true
end

local function sp(n, w)
	local pk, pc
	for _, m in cs:GetTagged("AnimalPickup") do
		if m.Parent and nk(tostring(m:GetAttribute("AnimalName") or m.Name)) == n and (w == nil or m:GetAttribute("WeightKg") == w) then pk = m end
	end
	if not pk then return nil end
	pc = pk:GetBoundingBox().Position
	local pr, pd
	for _, p in cs:GetTagged("SmartPrompt") do
		if p:IsA("ProximityPrompt") and p.Name == "StealPrompt" and p.Parent and p.Parent:IsA("BasePart") then
			local d = (p.Parent.Position - pc).Magnitude
			local nm = string.sub(nk((string.gsub(p.ObjectText, "<[^>]+>", ""))), -#n) == n
			if nm or d < 8 then
				d -= nm and 50 or 0
				if not pd or d < pd then pr, pd = p, d end
			end
		end
	end
	return pc, pr, pk
end

local function gb(f)
	local c, r = lc()
	local cn0 = lp:GetAttribute("Carrying")
	local pl = op()
	if not (c and r and cn0 and pl) then return false end
	local n, ck = nk(tostring(cn0)), st.ck or {}
	local g, gd
	for _, m in cs:GetTagged("ZoneGuard") do
		local d = (m:GetPivot().Position - r.Position).Magnitude + (m:GetAttribute("ZoneId") == ck.z and 0 or 1e6)
		if not gd or d < gd then g, gd = m, d end
	end
	if not g then return false end
	local fl, t = false, os.clock()
	local cn = rs:WaitForChild("CatchFlingRemote").OnClientEvent:Connect(function(a) if a == "fling" then fl = true end end)
	local hb = ru.Heartbeat:Connect(function()
		if fl then return end
		local _, q = lc()
		if not q then return end
		local gp = g:GetPivot().Position
		q.AssemblyLinearVelocity = Vector3.zero
		q.CFrame = CFrame.new(gy(gp.X, gp.Z, g))
	end)
	repeat task.wait(0.03) until fl or os.clock() - t > 4 or f.st ~= "Running"
	hb:Disconnect()
	cn:Disconnect()
	if not fl then return false end
	t = os.clock()
	while lp:GetAttribute("Carrying") == nil and os.clock() - t < 2.6 and f.st == "Running" do
		local pc, pr, pk = sp(n, ck.w)
		local _, q = lc()
		if pc and q then
			q.AssemblyLinearVelocity = Vector3.zero
			q.CFrame = CFrame.new(gy(pc.X, pc.Z, pk))
			task.wait()
			if pr and pr.Enabled then
				fireproximityprompt(pr)
				local w = os.clock()
				repeat task.wait(0.03) until lp:GetAttribute("Carrying") ~= nil or os.clock() - w > 0.35
			else
				task.wait(0.1)
			end
		else
			task.wait(0.05)
		end
	end
	if lp:GetAttribute("Carrying") == nil then return false end
	local pv = pl:GetPivot().Position
	local tg = Vector3.new(pv.X, pv.Y + 3, pv.Z)
	local hd = ru.Heartbeat:Connect(function()
		local _, q = lc()
		if q and (q.Position - tg).Magnitude > 3 then
			q.AssemblyLinearVelocity = Vector3.zero
			q.CFrame = CFrame.new(tg)
		end
	end)
	t = os.clock()
	repeat task.wait(0.05) until lp:GetAttribute("Carrying") == nil or os.clock() - t > 4
	local bd, m, e2 = lp:GetAttribute("Carrying") == nil, nil, nil
	if bd and st.fa and f.st == "Running" and c:GetAttribute("Ragdolled") then
		m = bp(true)
		local mc = m and m:GetBoundingBox().Position
		e2 = not mc and eg(st.za) or nil
		if mc then
			tg = gy(mc.X, mc.Z + (math.abs(mc.Z) > 3 and -math.sign(mc.Z) or 1) * 4, m)
		elseif e2 then
			local v = math.abs(e2.Position.Z) > 3 and Vector3.new(0, 0, -math.sign(e2.Position.Z)) or Vector3.xAxis
			tg = gy(e2.Position.X + v.X * (math.max(e2.Size.X, e2.Size.Z) / 2 + 2), e2.Position.Z + v.Z * (math.max(e2.Size.X, e2.Size.Z) / 2 + 2), e2)
		else
			tg = gy(rx[st.za + 1], 0)
		end
	end
	local ra, ta = 0, nil
	t = os.clock()
	repeat
		local c3, r3, h3 = lc()
		if e2 and (not et.IsLive(e2) or (st.kh[e2] or 1) <= 0) then
			e2, ta = eg(st.za), nil
			if e2 then
				local v = math.abs(e2.Position.Z) > 3 and Vector3.new(0, 0, -math.sign(e2.Position.Z)) or Vector3.xAxis
				tg = gy(e2.Position.X + v.X * (math.max(e2.Size.X, e2.Size.Z) / 2 + 2), e2.Position.Z + v.Z * (math.max(e2.Size.X, e2.Size.Z) / 2 + 2), e2)
			end
		end
		if e2 and c3 and r3 and h3 and et.IsLive(e2) and (st.kh[e2] or 1) > 0 and et.SurfaceDistance(e2, r3.Position) <= r1 then
			ta = ta or os.clock()
			local pk = c3:FindFirstChild("Pickaxe") or lp.Backpack:FindFirstChild("Pickaxe")
			if pk and pk:IsA("Tool") and pk.Parent ~= c3 then h3:EquipTool(pk) end
			if os.clock() - ta > 0.25 and os.clock() - ra > 0.5 then
				st.id += 1
				hq:FireServer(e2, st.id)
				ra = os.clock()
			end
		end
		task.wait(0.03)
	until not c:GetAttribute("Ragdolled") or os.clock() - t > 6
	hd:Disconnect()
	if m and m.Parent and st.fa and f.st == "Running" and not gz(m:GetAttribute("ZoneId")) then
		local n, w = nk(tostring(m:GetAttribute("AnimalName") or m.Name)), m:GetAttribute("WeightKg")
		t = os.clock()
		while lp:GetAttribute("Carrying") == nil and os.clock() - t < 1 do
			local _, pr = sp(n, w)
			if pr and pr.Enabled then fireproximityprompt(pr) end
			task.wait(0.15)
		end
		if lp:GetAttribute("Carrying") ~= nil then
			st.ck = {w = w, z = m:GetAttribute("ZoneId")}
			if st.ix then st.ix[n] = true end
		end
	end
	return bd
end

local function hm(f)
	if gb(f) then
		st.hs = {}
		return
	end
	if lp:GetAttribute("Carrying") == nil then return end
	if not rt(f, gy(rx[1], 0)) then return end
	local t = os.clock()
	repeat task.wait(0.2) until lp:GetAttribute("Carrying") == nil or f.st ~= "Running" or os.clock() - t > 6
	if lp:GetAttribute("Carrying") == nil then st.hs = {} end
end

local function sl(f)
	while f.st == "Running" do
		if lp:GetAttribute("Carrying") == nil then
			local m = bp()
			if not m then
				st.hs = {}
				return
			end
			local c = m:GetBoundingBox().Position
			if not (gt(f, gy(c.X, c.Z + (math.abs(c.Z) > 3 and -math.sign(c.Z) or 1) * 4, m)) and tk(m, f, 8)) then return end
		end
		hm(f)
		if not st.fa then return end
	end
end

local function bk(f, e, ab2)
	local d = math.abs(e.Position.Z) > 3 and Vector3.new(0, 0, -math.sign(e.Position.Z)) or Vector3.xAxis
	local p = gy(e.Position.X + d.X * (math.max(e.Size.X, e.Size.Z) / 2 + 2), e.Position.Z + d.Z * (math.max(e.Size.X, e.Size.Z) / 2 + 2), e)
	if not gt(f, p, ab2) then return false end
	while f.st == "Running" and et.IsLive(e) and (st.kh[e] or 1) > 0 and not (ab2 and ab2()) do
		local _, q = lc()
		if not q or et.SurfaceDistance(e, q.Position) > r1 then return false end
		st.le = e
		local k = hit()
		local w = os.clock() + (k and 0.47 / rc.SwingMultiplierFor(lp) or 0.1)
		repeat task.wait(0.03) until os.clock() >= w or (st.kh[e] or 1) <= 0
	end
	if (st.kh[e] or 1) <= 0 then
		local t = os.clock()
		repeat task.wait(0.03) until e:GetAttribute("HatchId") or e:GetAttribute("Hatching") or e:GetAttribute("Broken") or not e.Parent or os.clock() - t > 1
	end
	return e.Parent ~= nil and (e:GetAttribute("HatchId") or e:GetAttribute("Hatching") or e:GetAttribute("Broken")) ~= nil
end

local function rz(f)
	local c, _, h = lc()
	if not c then return false end
	h.Health = 0
	local t = os.clock()
	repeat task.wait(0.1) until lp.Character ~= c and lc() or os.clock() - t > 10 or f.st ~= "Running"
	rw()
	return lp.Character ~= c
end

local function ton(f)
	local pl = op()
	local q
	for _, d in pl and pl:GetChildren() or {} do
		local b = string.find(d.Name, "Treadmill") and d:FindFirstChild("Build")
		local p = b and b:FindFirstChild("Part")
		if p and p:IsA("BasePart") then q = p end
	end
	local _, r = lc()
	if not (q and r) then return nil end
	if r.Anchored then return r end
	if (r.Position - q.Position).Magnitude > 400 and not rz(f) then return nil end
	_, r = lc()
	if not r or f.st ~= "Running" then return nil end
	local s = false
	local cn = rs:WaitForChild("TreadmillSessionRemote").OnClientEvent:Connect(function(a) if typeof(a) == "number" then s = true end end)
	r.AssemblyLinearVelocity = Vector3.zero
	r.CFrame = CFrame.new(q.Position + Vector3.new(0, 3.2, 0))
	local t = os.clock()
	repeat task.wait(0.05) until s or os.clock() - t > 5 or f.st ~= "Running"
	cn:Disconnect()
	return s and r or nil
end

local function tm(f, z)
	local r = ton(f)
	if not r then return false end
	task.wait(0.15)
	rs:WaitForChild("TreadmillSessionRemote"):FireServer()
	local t = os.clock()
	repeat task.wait(0.03) until not r.Anchored or os.clock() - t > 3
	if r.Anchored or f.st ~= "Running" then return false end
	r.AssemblyLinearVelocity = Vector3.zero
	r.CFrame = CFrame.new(gy(rx[z + 1], 0))
	return true
end

local function fc(f)
	rw()
	if st.hj then
		task.wait(0.5)
		return
	end
	if lp:GetAttribute("Carrying") ~= nil then
		fr()
		hm(f)
		return
	end
	if st.pi and st.ix and zc() and st.nf then pcall(st.nf) end
	if next(st.ra) == nil and (not st.pi or zc()) then
		if st.ti then ton(f) end
		task.wait(0.5)
		return
	end
	fr()
	if du() then
		sl(f)
		return
	end
	local _, r = lc()
	if r then
		local a, b = zr(st.za)
		local x = r.Position.X
		if (x > b or x < a) and tm(f, st.za) then return end
	end
	local e = eg(st.za)
	local c, _, h = lc()
	if not (e and c) then
		task.wait(1)
		return
	end
	eq(c, h)
	if bk(f, e, function() return st.fa and du() or e:GetAttribute("ZoneIndex") ~= st.za end) then
		st.lx, st.lt = e, os.clock()
		task.spawn(function()
			local t, hd = os.clock(), nil
			repeat
				hd = e:GetAttribute("HatchId")
				task.wait(0.1)
			until hd or os.clock() - t > 10
			if hd then st.hs[hd] = true end
		end)
	end
end

local function ew(f, e)
	local t, hd, pk = os.clock(), nil, nil
	repeat
		hd = e:GetAttribute("HatchId")
		task.wait(0.1)
	until hd or os.clock() - t > 10 or f.st ~= "Running"
	if not hd then return end
	t = os.clock()
	repeat
		for _, m in cs:GetTagged("AnimalPickup") do
			if m:GetAttribute("HatchId") == hd then pk = m end
		end
		task.wait(0.1)
	until pk or os.clock() - t > 10 or f.st ~= "Running"
	if not (pk and wn(pk)) then return end
	local c = pk:GetBoundingBox().Position
	if gt(f, gy(c.X, c.Z + (math.abs(c.Z) > 3 and -math.sign(c.Z) or 1) * 4, pk)) and tk(pk, f, 8) then hm(f) end
end

local function af()
	st.fg += 1
	local g, f = st.fg, {st = "Running"}
	st.fj = f
	task.spawn(function()
		local ok, er = pcall(md)
		if not ok then warn(`Auto Farm Failed: {er}`) end
		local o2, pc = pcall(function() return require(lp:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("PickaxeController")) end)
		if o2 and ok then
			task.spawn(function()
				while st.fg == g and f.st == "Running" and st.fa do
					task.wait(1.5)
					local _, r = lc()
					if r and not st.hj and pc.IsWielding() then
						local e = st.le
						if not (e and e.Parent and et.IsLive(e) and et.SurfaceDistance(e, r.Position) <= r1) then e = et.Pick(r.Position, r0, st.le, r1) end
						if e then pcall(pc.Swing, e) end
					end
				end
			end)
		end
		while ok and st.fg == g and f.st == "Running" do
			if not st.fa then
				local k, e = pcall(function()
					fr()
					if lp:GetAttribute("Carrying") ~= nil then
						hm(f)
					elseif st.lx and os.clock() - st.lt < 5 then
						ew(f, st.lx)
					end
				end)
				if not k then warn(`Auto Farm Failed: {e}`) end
				break
			end
			local k, e = pcall(fc, f)
			if not k then
				warn(`Auto Farm Failed: {e}`)
				task.wait(1)
			end
			task.wait()
		end
		if st.fj == f then
			st.mt, st.fj = nil, nil
			local _, _, h = lc()
			if h then h:Move(Vector3.zero, false) end
		end
	end)
end


local function hl()
	local f = {st = "Running"}
	st.hj = f
	local fa0 = st.fa
	pcall(md)
	if st.fj then
		local t = os.clock()
		while lp:GetAttribute("Carrying") ~= nil and os.clock() - t < 30 do task.wait(0.2) end
		if st.fj then st.fj.st = "Stopped" end
		t = os.clock()
		while st.fj and os.clock() - t < 10 do task.wait(0.1) end
	end
	if lp:GetAttribute("InHell") ~= true then
		rw()
		local r = ton(f)
		if r then
			task.wait(0.15)
			rs:WaitForChild("TreadmillSessionRemote"):FireServer()
			local t = os.clock()
			repeat task.wait(0.03) until not r.Anchored or os.clock() - t > 3
		end
		local b = workspace:FindFirstChild("Build")
		local z = b and b:FindFirstChild("ZoneBuilds")
		z = z and z:FindFirstChild("Zone7")
		local j = z and z:FindFirstChild("JoinHell")
		local tp = j and j:FindFirstChild("TP", true)
		local p = tp and tp:IsA("BasePart") and tp.Position or Vector3.new(-1502.6, 10.2, 58.5)
		local _, q = lc()
		if q then
			q.AssemblyLinearVelocity = Vector3.zero
			q.CFrame = CFrame.new(p + Vector3.new(0, 3, 0))
		end
		task.wait(0.4)
		for _ = 1, 6 do
			if lp:GetAttribute("InHell") == true or workspace:GetAttribute("HellJoinable") ~= true then break end
			rs:WaitForChild("HellJoinRemote"):FireServer()
			local t = os.clock()
			repeat task.wait(0.1) until lp:GetAttribute("InHell") == true or os.clock() - t > 1.7
		end
		if lp:GetAttribute("InHell") ~= true then st.hz = os.clock() end
	end
	local as = require(lp:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("AutoSwingController"))
	local a0, tg, id, lh, lt = as.IsOn(), nil, 7e6, 0, 0
	st.ht, st.he = 0, 0
	pcall(ru.UnbindFromRenderStep, ru, "BseHellMove")
	ru:BindToRenderStep("BseHellMove", Enum.RenderPriority.Character.Value + 1, function()
		local _, r, h = lc()
		if not (r and h and tg) then return end
		local d = (tg - r.Position) * Vector3.new(1, 0, 1)
		if d.Magnitude > st.hd then h:Move(d.Unit, false) else h:Move(Vector3.zero, false) end
	end)
	while lp:GetAttribute("InHell") == true and st.eh do
		local c, r, h = lc()
		if workspace:GetAttribute("HellGathering") == true then
			if c then eq(c, h) end
			local e, ed
			for _, x in cs:GetTagged("HellEssenceEgg") do
				if x:IsA("BasePart") and x.Parent and et.IsLive(x) and r then
					local d = (x.Position - r.Position).Magnitude
					if not ed or d < ed then e, ed = x, d end
				end
			end
			tg, st.hd = e and e.Position, 3
			if e and r and ed <= 50 and not c:GetAttribute("Ragdolled") and lp:GetAttribute("Carrying") == nil and et.SurfaceDistance(e, r.Position) >= 6 then
				local v, s = (r.Position - e.Position) * Vector3.new(1, 0, 1), math.max(e.Size.X, e.Size.Z) / 2 + 2
				v = v.Magnitude > 0.5 and v.Unit or Vector3.xAxis
				r.AssemblyLinearVelocity = Vector3.zero
				r.CFrame = CFrame.new(gy(e.Position.X + v.X * s, e.Position.Z + v.Z * s, e))
				lh, st.he = os.clock() - 0.25, st.he + 1
			end
			if e and r and et.SurfaceDistance(e, r.Position) < 6 and os.clock() - lh > 0.5 then
				id += 1
				hq:FireServer(e, id)
				lh = os.clock()
			end
		else
			local b = cs:GetTagged("HellBoss")[1]
			local rp = b and b:FindFirstChild("RootPart")
			local ph = b and b:GetAttribute("Phase")
			if rp and rp:IsA("BasePart") and (ph == "Active" or ph == "Stunned") then
				tg, st.hd = rp.Position, 10
				if not as.IsOn() then as.SetOn(true) end
				if c and r and c:GetAttribute("Ragdolled") and os.clock() - lt > 0.5 then
					local v = (r.Position - rp.Position) * Vector3.new(1, 0, 1)
					local x = rp.Position + (v.Magnitude > 1 and v.Unit or Vector3.xAxis) * 8
					local q = RaycastParams.new()
					q.FilterType, q.FilterDescendantsInstances = Enum.RaycastFilterType.Exclude, {c, b}
					local g = workspace:Raycast(Vector3.new(x.X, rp.Position.Y + 20, x.Z), Vector3.new(0, -400, 0), q)
					r.AssemblyLinearVelocity = Vector3.zero
					r.CFrame = CFrame.new(g and g.Position + Vector3.new(0, 3, 0) or Vector3.new(x.X, r.Position.Y, x.Z))
					lt, st.ht = os.clock(), st.ht + 1
				end
			else
				tg = nil
			end
		end
		task.wait(0.05)
	end
	pcall(ru.UnbindFromRenderStep, ru, "BseHellMove")
	local _, _, h = lc()
	if h then h:Move(Vector3.zero, false) end
	pcall(as.SetOn, a0)
	st.hj = nil
	if fa0 and st.fa then af() end
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

local function bo()
	if ge.__BseP then return nil, "Already On" end
	ge.__BseP = true
	local li, tr = game:GetService("Lighting"), workspace.Terrain
	local function ko(d, k)
		k = k or "Enabled"
		d[k] = false
		d:GetPropertyChangedSignal(k):Connect(function() if d[k] then d[k] = false end end)
	end
	local function lf() if li.GlobalShadows then li.GlobalShadows = false end end
	lf()
	li:GetPropertyChangedSignal("GlobalShadows"):Connect(lf)
	local function kx(d) if d:IsA("PostEffect") then ko(d) end end
	for _, d in li:GetDescendants() do pcall(kx, d) end
	li.DescendantAdded:Connect(function(d) pcall(kx, d) end)
	local cu = tr:FindFirstChildOfClass("Clouds")
	if cu then pcall(ko, cu) end
	pcall(function() tr.WaterWaveSize, tr.WaterWaveSpeed, tr.WaterReflectance = 0, 0, 0 end)
	local function px(d)
		if d:IsA("ParticleEmitter") then
			d.Lifetime = NumberRange.new(0)
			ko(d)
		elseif d:IsA("Beam") or d:IsA("Trail") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Light") or d:IsA("Highlight") then
			ko(d)
		elseif d:IsA("Decal") or d:IsA("Texture") then
			d.Transparency = 1
		elseif d:IsA("SurfaceAppearance") then
			task.defer(pcall, d.Destroy, d)
		elseif d:IsA("VideoFrame") then
			ko(d, "Playing")
			ko(d, "Visible")
		elseif d:IsA("BasePart") and d.Material ~= Enum.Material.Water then
			d.Material, d.Reflectance, d.CastShadow = Enum.Material.SmoothPlastic, 0, false
		end
	end
	workspace.DescendantAdded:Connect(function(d) pcall(px, d) end)
	task.spawn(function()
		for i, d in workspace:GetDescendants() do
			pcall(px, d)
			if i % 2000 == 0 then task.wait() end
		end
	end)
	local pg2 = lp:FindFirstChildOfClass("PlayerGui")
	if pg2 then
		for _, d in pg2:GetDescendants() do if d:IsA("VideoFrame") then pcall(px, d) end end
		pg2.DescendantAdded:Connect(function(d) if d:IsA("VideoFrame") then pcall(px, d) end end)
	end
	local ok, ss = pcall(function()
		local S = require(lp:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("Modules"):WaitForChild("SettingsState"))
		for _, k in {"ScreenFFX", "ViewOthersPets", "ViewMyPets", "ViewMyEggs"} do S.Set(k, false) end
	end)
	local pg3 = lp:FindFirstChildOfClass("PlayerGui")
	for _, n in {"AnimalCashPopups", "EggDamagePopups"} do
		local g = pg3 and pg3:FindFirstChild(n)
		if g and g:IsA("ScreenGui") then pcall(ko, g) end
	end
	local ui = game:GetService("UserInputService")
	ui.WindowFocusReleased:Connect(function() pcall(ru.Set3dRenderingEnabled, ru, false) end)
	ui.WindowFocused:Connect(function() pcall(ru.Set3dRenderingEnabled, ru, true) end)
	local function ax(d)
		if d:IsA("Accoutrement") or d:IsA("Clothing") or d:IsA("ShirtGraphic") or d:IsA("CharacterMesh") then task.defer(pcall, d.Destroy, d) end
	end
	local function cx(c)
		for _, d in c:GetDescendants() do pcall(ax, d) end
		c.DescendantAdded:Connect(function(d) pcall(ax, d) end)
	end
	local function pa(p)
		if p == lp then return end
		if p.Character then cx(p.Character) end
		p.CharacterAdded:Connect(cx)
	end
	for _, p in ps:GetPlayers() do pa(p) end
	ps.PlayerAdded:Connect(pa)
	if not ok then return nil, `Game Settings Failed: {ss}` end
	return true
end

local function hx(lo2)
	local hs, ts = game:GetService("HttpService"), game:GetService("TeleportService")
	local function go2(f)
		local fe
		st.hp = os.clock()
		local cn = ts.TeleportInitFailed:Connect(function(p, _, m) if p == lp then fe = tostring(m) end end)
		local o3, e3 = pcall(f)
		if not o3 then fe = tostring(e3) end
		local t = os.clock()
		while not fe and os.clock() - t < 10 do task.wait(0.25) end
		cn:Disconnect()
		return fe == nil
	end
	while ge.__BseAf == st do
		local ok, r = pcall(function() return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId), true) end)
		local o2, d = false, nil
		if ok then o2, d = pcall(hs.JSONDecode, hs, r) end
		local l = {}
		for _, v in o2 and type(d) == "table" and type(d.data) == "table" and d.data or {} do
			if v.id ~= game.JobId and type(v.playing) == "number" and type(v.maxPlayers) == "number" and v.playing < v.maxPlayers then l[#l + 1] = v end
		end
		if lo2 then
			table.sort(l, function(x, y) return x.playing < y.playing end)
		else
			for i = #l, 2, -1 do
				local j = math.random(1, i)
				l[i], l[j] = l[j], l[i]
			end
		end
		for _, v in l do
			if ge.__BseAf ~= st then return false, "Hop Failed: Stopped" end
			if go2(function() ts:TeleportToPlaceInstance(game.PlaceId, v.id, lp) end) then return true end
			task.wait(1)
		end
		if not lo2 and ge.__BseAf == st and go2(function() ts:Teleport(game.PlaceId, lp) end) then return true end
		task.wait(3)
	end
	return false, "Hop Failed: Stopped"
end

local za = {"Forest Zone", "Desert Zone", "Snowy Zone", "Candy Zone", "Swamp Zone", "Ocean Zone", "Volcano Zone", "Blossom Zone", "Galaxy Zone", "Planet X Zone"}
pcall(function()
	local p, hj = `Avenoric/Configs/BreakAndStealAnEgg/{lp.Name}.json`, game:GetService("HttpService")
	if not isfile(p) then return end
	local j, ch = hj:JSONDecode(readfile(p)), false
	for _, k in {"sa", "tz"} do
		local n = type(j[k]) == "string" and tonumber(string.match(j[k], "^Zone (%d+) %("))
		if n and za[n] then j[k], ch = za[n], true end
	end
	if ch then writefile(p, hj:JSONEncode(j)) end
end)
local function kv() return L ~= nil and L:Keyed() end
if ge.__AvW then pcall(ge.__AvW.Destroy, ge.__AvW) end
L:Gate({Title = "Ngao - Gaming Hub", Server = "https://getkey.kaeldrinnovasse.workers.dev", Hub = "bse", Discord = "https://discord.gg/fTQF5TvfEJ", Config = "BreakAndStealAnEgg"})
local W = L:Window({Title = "Ngao - Gaming Hub | Break And Steal An Egg", Config = `BreakAndStealAnEgg/{lp.Name}`})
local pa = W:Tab({Name = "General", Icon = "hammer-code"})
pa:Section({Name = "Farm"})
pa:Dropdown({Name = "Select Area", Options = za, Default = za[1], Flag = "sa", Callback = function(v) st.za = table.find(za, v) or 1 end})
pa:Dropdown({Name = "Select Rarity", Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic", "Secret", "Celestial", "Inferno", "Void", "Omega"}, Default = {}, Multi = true, Flag = "sr", Callback = function(v)
	local t = {}
	for _, x in v or {} do t[x] = true end
	st.ra = t
end})
local fz = pa:Toggle({Name = "Auto Farm", Default = false, Flag = "af", Callback = function(v)
	st.fa = v and kv()
	if not st.fa then return end
	if st.fj then st.fj.st = "Stopped" end
	af()
end})
local pz = pa:Toggle({Name = "Pet Index", Default = false, Flag = "pi", Callback = function(v) st.pi = v == true end})
st.nf = function()
	st.pi = false
	W:Notify({Title = "Pet Index", Text = `{za[st.za]} Complete`})
	pz:Set(false)
end
pa:Toggle({Name = "Treadmill", Default = false, Flag = "ti", Callback = function(v) st.ti = v == true end})
pa:Section({Name = "Sell"})
pa:Dropdown({Name = "Select Rarity", Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Cosmic", "Secret", "Celestial", "Inferno", "Void", "Omega"}, Default = {}, Multi = true, Flag = "sv", Callback = function(v)
	local t = {}
	for _, x in v or {} do t[x] = true end
	st.sv = t
end})
pa:Toggle({Name = "Auto Sell", Default = false, Flag = "as", Callback = function(v) st.as = v == true end})
local function sv2(dl)
	if not st.as or st.sb or next(st.sv) == nil then return end
	st.sb = true
	task.spawn(function()
		task.wait(dl)
		local ok, e = pcall(function()
			rs:WaitForChild("PetsInventoryRemote"):FireServer("EquipBest", nil)
			task.wait(0.5)
			local l = {}
			for _, t in lp:WaitForChild("Backpack"):GetChildren() do
				if #l < 200 and cs:HasTag(t, "AnimalTool") and st.sv[t:GetAttribute("Rarity")] then table.insert(l, t) end
			end
			if #l > 0 then rs:WaitForChild("BackpackSellRemote"):InvokeServer(l) end
		end)
		if not ok then warn(`Auto Sell Failed: {e}`) end
		st.sb = false
	end)
end
st.sc = rs:WaitForChild("AnimalBankedRemote").OnClientEvent:Connect(function() sv2(1) end)
local pv2 = W:Tab({Name = "Event", Icon = "calendar-star"})
pv2:Section({Name = "Hell"})
pv2:Toggle({Name = "Auto Hell", Default = false, Flag = "eh", Callback = function(v) st.eh = v == true end})
local pq = W:Tab({Name = "Shop", Icon = "shopping-basket"})
pq:Section({Name = "Upgrade"})
pq:Toggle({Name = "Auto Buy Pickaxe", Default = false, Flag = "ap", Callback = function(v) st.ua = v == true end})
pq:Toggle({Name = "Auto Buy Treadmill", Default = false, Flag = "at", Callback = function(v) st.ub = v == true end})
pq:Toggle({Name = "Auto Buy Trail", Default = false, Flag = "al", Callback = function(v) st.uc = v == true end})
pq:Toggle({Name = "Auto Buy Pen", Default = false, Flag = "ae", Callback = function(v) st.ud = v == true end})
local pt = W:Tab({Name = "Teleport", Icon = "person-teleport"})
pt:Section({Name = "Zone"})
local tq = 1
pt:Dropdown({Name = "Select Zone", Options = za, Default = za[1], Flag = "tz", Callback = function(v) tq = table.find(za, v) or 1 end})
local wt
wt = pt:Toggle({Name = "Auto Teleport", Default = false, Callback = function(v)
	if not v or st.tb then return end
	st.tb = true
	task.spawn(function()
		if st.fa then fz:Set(false) end
		local t = os.clock()
		while st.fj and os.clock() - t < 30 do task.wait(0.2) end
		if st.fj then
			warn("Teleport Failed: Farm Still Running")
		elseif lp:GetAttribute("Carrying") ~= nil then
			warn("Teleport Failed: Carrying")
		else
			local ok, e = pcall(function()
				rw()
				fr()
				if not tm({st = "Running"}, tq) then warn("Teleport Failed: Treadmill Not Ready") end
			end)
			if not ok then warn(`Teleport Failed: {e}`) end
		end
		st.tb = false
		wt:Set(false)
	end)
end})
pt:Section({Name = "Server"})
for _, z in {{"Hop Server", false}, {"Hop Low Server", true}} do
	pt:Button({Name = z[1], Callback = function()
		if st.hq then
			W:Notify({Title = z[1], Text = "Already Hopping"})
			return
		end
		st.hq = true
		W:Notify({Title = z[1], Text = "Hopping"})
		task.spawn(function()
			local ok, wy = hx(z[2])
			st.hq = false
			if not ok then W:Notify({Title = z[1], Text = tostring(wy), Error = true}) end
		end)
	end})
end
local pw = W:Tab({Name = "Setting", Icon = "gear"})
pw:Section({Name = "Game"})
pw:Button({Name = "FPS Booster", Callback = function()
	local ok, e = bo()
	W:Notify({Title = "FPS Booster", Text = ok and "On Until Rejoin" or e, Error = not ok and e ~= "Already On"})
end})

local function om(a)
	local n = 0
	for x in string.gmatch(tostring(lp:GetAttribute(a) or ""), "%d+") do n = math.max(n, tonumber(x) or 0) end
	return n
end
local function ug()
	local c = tonumber(lp:GetAttribute("Cash")) or 0
	if st.ua then
		local tl = require(sh:WaitForChild("PickaxeConfig"))
		tl = tl.Tiers or tl
		local n, e = om("OwnedPickaxes"), nil
		e = tl[n + 1]
		if type(e) == "table" and type(e.Price) == "number" and c >= e.Price then
			rs:WaitForChild("PickaxeShopRequest"):FireServer("Buy", n + 1)
			c -= e.Price
		elseif n > 0 and lp:GetAttribute("PickaxeTier") ~= n then
			rs:WaitForChild("PickaxeShopRequest"):FireServer("Equip", n)
		end
	end
	local pl = op()
	if st.ub and pl and pl:GetAttribute("TreadmillUnlocked") then
		local tl = require(sh:WaitForChild("TreadmillUpgradeConfig"))
		local e = (tl.Levels or tl)[tonumber(pl:GetAttribute("TreadmillLevel")) or 0]
		local k = type(e) == "table" and (e.Cost or e.Price or e.UpgradeCost)
		if type(k) == "number" and c >= k then
			rs:WaitForChild("UpgradeTreadmillRequest"):FireServer()
			c -= k
		end
	end
	if st.ud and pl then
		local k = require(sh:WaitForChild("PlotUpgradeConfig")).UpgradeCost(pl:GetAttribute("PlotLevel"))
		if type(k) == "number" and c >= k then
			rs:WaitForChild("UpgradePlotRequest"):FireServer()
			c -= k
		end
	end
	if st.uc then
		local tl = require(sh:WaitForChild("TrailsConfig"))
		tl = tl.Trails or tl
		local n = om("OwnedTrails")
		local e = tl[n + 1]
		if type(e) == "table" and type(e.Price) == "number" and c >= e.Price then
			rs:WaitForChild("TrailShopRequest"):FireServer("Buy", e.Id or n + 1)
		elseif n > 0 and tonumber(lp:GetAttribute("EquippedTrail")) ~= n then
			rs:WaitForChild("TrailShopRequest"):FireServer("Equip", n)
		end
	end
end

task.spawn(function()
	local q, x = rs:WaitForChild("PetsInventoryRemote"), rs:WaitForChild("IndexRemote")
	local lc2 = 0
	st.ic = x.OnClientEvent:Connect(function(a, s)
		if a ~= "State" or typeof(s) ~= "table" then return end
		local t = {}
		for k in s do t[nk(tostring(k))] = true end
		st.ix = t
		if os.clock() - lc2 < 2 then return end
		for _, v in s do
			if v == "Ready" then
				lc2 = os.clock()
				x:FireServer("ClaimAll", nil)
				return
			end
		end
	end)
	while st.bg do
		q:FireServer("EquipBest", nil)
		x:FireServer("Get", nil)
		local ok, e = pcall(ug)
		if not ok then warn(`Auto Buy Failed: {e}`) end
		sv2(0)
		task.wait(3)
	end
end)
task.spawn(function()
	while st.bg do
		if st.eh and kv() and not st.hj and (lp:GetAttribute("InHell") == true or workspace:GetAttribute("HellJoinable") == true and os.clock() - st.hz > 60) then
			local ok, e = pcall(hl)
			if not ok then
				warn(`Auto Hell Failed: {e}`)
				pcall(ru.UnbindFromRenderStep, ru, "BseHellMove")
				st.hj = nil
			end
		end
		task.wait(1)
	end
end)
task.spawn(function()
	while st.bg do
		if st.ti and not st.fj and not st.tb and not st.hj and lp:GetAttribute("Carrying") == nil then pcall(ton, {st = "Running"}) end
		task.wait(1)
	end
end)

pcall(function()
	for _, c in getconnections(rs:WaitForChild("CatchFlingRemote").OnClientEvent) do
		if c.Function then c:Disable() end
	end
end)

local vim = game:GetService("VirtualInputManager")
local function ak()
	vim:SendKeyEvent(true, Enum.KeyCode.F15, false, game)
	task.wait(0.05)
	vim:SendKeyEvent(false, Enum.KeyCode.F15, false, game)
end
if ge.__BseJ then pcall(ge.__BseJ.Disconnect, ge.__BseJ) end
local jr = false
ge.__BseJ = (game:GetService("GuiService") :: any).ErrorMessageChanged:Connect(function(m)
	if jr or type(m) ~= "string" or m == "" or os.clock() - st.hp < 30 then return end
	jr = true
	pcall(appendfile, "BseNotify.log", `{os.date("!%H:%M:%S")} | KICK | {m}` .. string.char(10))
	task.spawn(function()
		local tq = game:GetService("TeleportService")
		while true do
			pcall(tq.Teleport, tq, game.PlaceId, lp)
			task.wait(10)
		end
	end)
end)
if ge.__BseNl then pcall(ge.__BseNl.Disconnect, ge.__BseNl) end
ge.__BseNl = rs:WaitForChild("Notify").OnClientEvent:Connect(function(...)
	local t = {}
	for i, v in {...} do
		if type(v) == "table" then
			local q = {}
			for k, x in v do table.insert(q, `{k}={x}`) end
			t[i] = "{" .. table.concat(q, ",") .. "}"
		else
			t[i] = tostring(v)
		end
	end
	local _, r = lc()
	pcall(appendfile, "BseNotify.log", `{os.date("!%H:%M:%S")} | {table.concat(t, " | ")} | pos={r and r.Position} carry={lp:GetAttribute("Carrying")} fa={st.fa} hj={st.hj ~= nil}` .. string.char(10))
end)
if ge.__BseA then pcall(ge.__BseA.Disconnect, ge.__BseA) end
ge.__BseA = lp.Idled:Connect(function()
	local vu = game:GetService("VirtualUser")
	vu:CaptureController()
	vu:ClickButton2(Vector2.new())
	ak()
end)
task.spawn(function()
	while st.bg do
		pcall(ak)
		task.wait(60)
	end
end)

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
for _, x in W.Gui:GetChildren() do
	local t = x:IsA("GuiButton") and x:FindFirstChildWhichIsA("TextLabel")
	if t and t.Text == "studio" then x.Visible = false end
end
local rh = pgu:FindFirstChild("MainGUI") and pgu.MainGUI:FindFirstChild("RightHUD")
local eb = rh and rh:FindFirstChild("Eggs")
if eb then
	local o = rh:FindFirstChild("NgaoButton")
	if o then o:Destroy() end
	local b = eb:Clone()
	local n = b:FindFirstChild("Notification")
	if n then n:Destroy() end
	b.Name, b.LayoutOrder = "NgaoButton", 0
	local g = b:FindFirstChild("UIGradient")
	if g and g:IsA("UIGradient") then g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 122, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(232, 172, 18)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 214, 64))}) end
	local im = b:FindFirstChild("Icon")
	if im and im:IsA("ImageLabel") and type(gi) == "string" then im.Image = gi end
	b.Parent = rh
	b.Activated:Connect(function() if W.Main.Visible then W:Hide() else W:Show() end end)
end
