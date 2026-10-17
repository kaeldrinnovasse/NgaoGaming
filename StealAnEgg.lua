if not game:IsLoaded() then game.Loaded:Wait() end

local ps, rs, ru, cl = game:GetService("Players"), game:GetService("ReplicatedStorage"), game:GetService("RunService"), game:GetService("CollectionService")
repeat task.wait() until ps.LocalPlayer

local lp = ps.LocalPlayer
local function zx(t, nw)
	local fp, g = `Avenoric/Configs/StealAnEgg/{lp.Name}_Log.txt`, getgenv().__SaeLq
	if not g then
		g = {pq = {}, dt = false}
		getgenv().__SaeLq = g
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
		local s2 = table.concat(b, "\n") .. "\n"
		local ok = pcall(function()
			for _, x in {"Avenoric", "Avenoric/Configs", "Avenoric/Configs/StealAnEgg"} do
				if not isfolder(x) then makefolder(x) end
			end
			if appendfile and isfile(fp) then appendfile(fp, s2) else writefile(fp, (isfile(fp) and readfile(fp) or "") .. s2) end
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
local function xl(m)
	warn("[Sae] " .. m)
	zx("[Load] " .. m, true)
	pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Ngao - Gaming Hub", Text = m, Duration = 15}) end)
end
local es, ad, si, cy, rg, ai, er, sv, rm, hh, tq
do
	local o = {}
	for i, p in {"Client.EggState", "Data.Assets", "Shared.Util.AreaEggSlotIdentity", "Shared.Util.AreaEggCycle", "Shared.Modules.Ragdoll", "Shared.Util.AssetItems", "Shared.Util.EggRecords", "Shared.Save", "Shared.Remotes", "Client.HiddenUIHandler", "Packages.TopBarPlus"} do
		local x = rs
		for n in p:gmatch("[^%.]+") do x = x and x:WaitForChild(n, 60) end
		local ok, m = x ~= nil, nil
		if ok then ok, m = pcall(require, x) end
		if not ok or m == nil then xl((x and "Load Failed: Broken " or "Load Failed: Missing ") .. p) return end
		o[i] = m
	end
	es, ad, si, cy, rg, ai, er, sv, rm, hh, tq = table.unpack(o, 1, 11)
end
local dr = ad.Directory or ad
do
	local t0 = os.clock()
	while true do
		task.wait(0.2)
		local c, ok, f = lp.Character, pcall(es.HasFieldSnapshot)
		local w = lp:GetAttribute("ProfileReady") ~= true and "Profile Not Ready" or not (ok and f == true) and "No Field Snapshot" or not (c and c:FindFirstChild("HumanoidRootPart")) and "No Character" or nil
		if not w then break end
		if os.clock() - t0 > 60 then xl("Load Failed: " .. w) return end
	end
end

local ge = getgenv()
if ge.__SaeAf then
	if ge.__SaeAf.Stop then pcall(ge.__SaeAf.Stop, true) end
	ge.__SaeAf.on = false
	for _, c in ge.__SaeAf.cn do pcall(function() c:Disconnect() end) end
	for _, c in ge.__SaeAf.tc or {} do pcall(function() c:Disconnect() end) end
	for p, v in ge.__SaeAf.ta or {} do if p.Parent then pcall(function() p.CanTouch = v end) end end
	for _, c in ge.__SaeAf.uc or {} do pcall(function() c:Disconnect() end) end
	for h in ge.__SaeAf.uh or {} do pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end) end
	pcall(function()
		local c = require(lp.PlayerScripts.PlayerModule):GetControls()
		if rawget(c, "GetMoveVector") then c.GetMoveVector = nil end
	end)
end
local st ={on = false, g = 0, cn = {}, bl = {}, bk = {}, sl = {}, so = nil, sc = nil, n = 0, ms = "Idle", at = nil, h0 = nil, rz = 4, mr = {}, az = {}, wf = nil, wo = false, bx = false, fp = false, gr = false, gx = false, gg = 0, lx = false, lb = false, tq = false, th = 0, tx = false, tb = false, rsh = 0, pu = nil, dw = 0.3, pc = 0, ps = false, es = false, sp = {}, se = {}, pf = nil, fm = 1.15, gh = 5, gc = 0, ct = nil, sr = false, fz = false, qc = {}, mc = {}, me = {}, ft = 0, fb = nil, hq = false, ta = {}, tc = {}, pi = false, bt = nil, tr = nil, uc = {}, uh = {}, uu = 0, bf = false, bo = false, bi = 0, ap = false, mq = 0, ah = false, hf = {}, ui = {}, ef = 0, hd = false, hm = false, hl = false, hg = 0, hb = false, hbl = {}, hk = 150, hr = 300, hw = 0.4, bsi = 0.6, bsq = 0, hpx = 0, hbt = 0, hx = false, ts = nil, gbd = 20, cs = nil, rtn = 0}
ge.__SaeAf = st

local function lg(s)
	if s == st.ms then return end
	st.ms = s
	print("[Sae] " .. s)
	zx(s)
end

local xt
local function xs(n, k, m, e)
	if e ~= nil then
		zx(`[Error] {n} | {tostring(e)}`)
		if xt then pcall(function() zx(xt()) end) end
		m = m .. ": " .. ((tostring(e):match("^[^\n]*") or ""):gsub("^.-:(%d+): ", "Line %1: "))
	end
	lg(m)
	warn("[Sae] " .. n .. " Stopped: " .. m)
	task.spawn(function()
		task.wait()
		if st.nt then pcall(st.nt, n, m) end
		local t = st.ui[k]
		if t and t.v then pcall(t.Set, t, false) end
	end)
end

local function xc(c)
	c:Disconnect()
	local i = table.find(st.cn, c)
	if i then table.remove(st.cn, i) end
end

local function rt()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart"), c and c:FindFirstChildOfClass("Humanoid")
end

local L
local function kv() return L ~= nil and L:Keyed() end

local function sp()
	local w = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	local a = w and w:FindFirstChild("Areas")
	local l = a and a:FindFirstChild("SeparationLine")
	return l and l:IsA("BasePart") and l or nil
end

local function cz()
	local w = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	local a = w and w:FindFirstChild("Areas")
	local b = a and a:FindFirstChild("EggCarryBounds")
	local g = b and b:FindFirstChild("Gameplay1")
	if not (g and g:IsA("BasePart")) then return nil end
	return g.Position.Z - g.Size.Z / 2 + 15, g.Position.Z + g.Size.Z / 2 - 15
end

local function dl()
	if workspace:GetAttribute("Event_AdminAbuse") == true then return math.huge end
	local t = workspace:GetServerTimeNow()
	local o1, n = pcall(cy.IsNightPhase, t)
	local o2, ns = pcall(cy.NightStartTime, t)
	local o3, nr = pcall(cy.NextResetTime, t)
	if not (o1 and o2 and o3) or type(ns) ~= "number" or type(nr) ~= "number" then return nil, "Cycle Read Failed" end
	if n or t - (nr - cy.ResetPeriodSeconds) < 5 then return 0 end
	return ns - t
end

local function fs()
	local l, h = sp(), rt()
	return l ~= nil and h ~= nil and l.CFrame.LookVector:Dot(h.Position - l.Position) > 0
end

local function cr()
	local ok, s = pcall(es.ReadCarryState)
	return ok and type(s) == "table" and s.IsCarrying == true
end

xt = function()
	local h = rt()
	return string.format("[State] Pos %s | Dimension %s | Carry %s/%s | Train %s | Farm %s | Halloween %s | Butterfly %s | Swap %s | Status %s", h and string.format("%d, %d, %d", math.floor(h.Position.X), math.floor(h.Position.Y), math.floor(h.Position.Z)) or "-", tostring(lp:GetAttribute("InHalloweenDimension") == true), tostring(cr()), tostring(lp:GetAttribute("HalloweenCarrying") == true), tostring(lp:GetAttribute("TrainEventPhase")), tostring(st.on), tostring(st.hd), tostring(st.bf), tostring(st.sc ~= nil), tostring(st.ms))
end

local function av(u)
	local ok, r = pcall(es.ReadFieldEgg, u)
	return ok and type(r) == "table" and (r.State == "Slot" or r.State == "Dropped")
end

local function cd()
	if os.clock() < st.ef then return {} end
	local ok, s = pcall(es.ReadFieldEggs)
	if not ok or type(s) ~= "table" then return {} end
	local o, t, ix, oc = {}, os.clock(), {}, {}
	if st.pi then
		local o3, v = pcall(sv.Await)
		ix = o3 and type(v) == "table" and type(v.Index) == "table" and v.Index or {}
		local o4, w = pcall(es.ReadOwnerEggs, lp.UserId)
		for _, x in o4 and type(w) == "table" and w or {} do
			if type(x) == "table" and type(x.AssetCategory) == "string" then oc[x.AssetCategory] = true end
		end
	end
	for _, r in s.Records or {} do
		local a = dr[r.AssetCategory]
		local wt
		if st.wf then wt = st.wf.a and r.AreaId == st.wf.a or st.wf.r and a and a.Rarity and a.Rarity._id == st.wf.r or false elseif st.pi then wt = ix[r.AssetCategory] ~= true and not oc[r.AssetCategory] elseif next(st.az) then wt = st.az[r.AreaId] == true else wt = a and a.Rarity and st.mr[a.Rarity._id] end
		if a and (r.State == "Slot" or r.State == "Dropped") and typeof(r.BoundsCFrame) == "CFrame" and (st.bl[r.Uid] or 0) < t and wt then
			o[#o + 1] = {u = r.Uid, r = r, k = tonumber(a.Rarity and a.Rarity.Rank) or 0, e = tonumber(a.EarningRate) or 0, p = r.BoundsCFrame.Position}
		end
	end
	table.sort(o, function(x, y)
		if (x.u == st.pu) ~= (y.u == st.pu) then return x.u == st.pu end
		if x.e ~= y.e then return x.e > y.e end
		return x.k > y.k
	end)
	return o
end

local gd = {[Enum.HumanoidStateType.Running] = true, [Enum.HumanoidStateType.RunningNoPhysics] = true, [Enum.HumanoidStateType.Landed] = true}

local function ct(hu)
	pcall(function() require(lp.PlayerScripts.PlayerModule):GetControls().humanoid = hu end)
end

local function ra(ch)
	local a = ch and ch:FindFirstChild("Animate")
	if not (a and a:IsA("LocalScript")) then return end
	task.spawn(function()
		a.Enabled = false
		task.wait()
		a.Enabled = true
	end)
end

local function fz(on)
	if on ~= st.fz then
		st.fz = on
		local c = lp.Character
		local a = c and c:FindFirstChild("Animate")
		if a and a:IsA("LocalScript") then a.Enabled = not on end
	end
	if not on then return end
	local _, hu = rt()
	local am = hu and hu:FindFirstChildOfClass("Animator")
	for _, t in am and am:GetPlayingAnimationTracks() or {} do pcall(function() t:Stop(0) end) end
end

local function ul()
	for _, c in st.sl do pcall(function() c:Disconnect() end) end
	table.clear(st.sl)
end

local function qh(on)
	local pg = lp:FindFirstChildOfClass("PlayerGui")
	local oi, ic = pcall(tq.getIcon, "Settings")
	if not oi or type(ic) ~= "table" then ic = nil end
	if not on then
		for _, c in st.qc do pcall(function() c:Disconnect() end) end
		table.clear(st.qc)
		for _, n in {"HUD", "BackpackGui"} do
			local g = pg and pg:FindFirstChild(n)
			if g and g:IsA("ScreenGui") and hh.IsHidden() then g.Enabled = false end
		end
		if ic and hh.IsHidden() then pcall(ic.setEnabled, ic, false) end
		return
	end
	if #st.qc > 0 then return end
	if ic then
		local function fi()
			task.defer(function()
				if ge.__SaeAf == st and #st.qc > 0 and hh.IsHidden() and not ic.isEnabled then pcall(ic.setEnabled, ic, true) end
			end)
		end
		local o, c = pcall(function() return hh.Changed:Connect(fi) end)
		if o and c then st.qc[#st.qc + 1] = c end
		fi()
	end
	if pg then
		local oc = Color3.fromRGB(255, 175, 0)
		st.qc[#st.qc + 1] = pg.DescendantAdded:Connect(function(d)
			if d:IsA("Frame") and d.Parent and d.Parent.Name == "OverlayUI" and d.BackgroundColor3 == oc then d.Visible = false end
		end)
	end
	for _, n in {"RunBackEffects", "DropHeldEgg", "AreaGui", "HUD", "BackpackGui"} do
		local g = pg and pg:FindFirstChild(n)
		if g and g:IsA("ScreenGui") then
			local v = n == "HUD" or n == "BackpackGui"
			local function f() if g.Enabled ~= v and (not v or hh.IsHidden()) then g.Enabled = v end end
			f()
			st.qc[#st.qc + 1] = g:GetPropertyChangedSignal("Enabled"):Connect(f)
		end
	end
end

local function sm(on)
	if not on then
		for _, c in st.mc do pcall(function() c:Disconnect() end) end
		for _, e in st.me do pcall(function() e:Destroy() end) end
		table.clear(st.mc)
		table.clear(st.me)
		return
	end
	if #st.mc > 0 then return end
	local w = workspace:FindFirstChild("World")
	local ga = w and w:FindFirstChild("Areas") and w.Areas:FindFirstChild("GuardAreas")
	local mt2 = game:GetService("SoundService"):FindFirstChild("MusicTracks")
	local cb = rs:FindFirstChild("Controllers") and rs.Controllers:FindFirstChild("Game") and rs.Controllers.Game:FindFirstChild("AreaEggsController")
	cb = cb and cb:FindFirstChild("CarryRunBackEffects")
	local gn = {AfterWakeSound = true, Detected = true, FootstepSound = true}
	local function mu(s)
		if not s:IsA("Sound") or s:FindFirstChild("SaeMute") then return end
		local e = Instance.new("EqualizerSoundEffect")
		e.Name, e.LowGain, e.MidGain, e.HighGain, e.Priority = "SaeMute", -80, -80, -80, 1000
		e.Parent = s
		st.me[#st.me + 1] = e
	end
	local function gs(d) if gn[d.Name] then mu(d) end end
	if ga then
		for _, d in ga:GetDescendants() do gs(d) end
		st.mc[#st.mc + 1] = ga.DescendantAdded:Connect(gs)
	end
	if mt2 and mt2:FindFirstChild("ChaseMusic") then mu(mt2.ChaseMusic) end
	if cb then
		for _, d in cb:GetChildren() do mu(d) end
		st.mc[#st.mc + 1] = cb.ChildAdded:Connect(mu)
	end
end

local function fv()
	local cm = workspace.CurrentCamera
	if not cm then return end
	st.ft = os.clock()
	if st.fb then return end
	local b = cm.FieldOfView
	st.fb = b
	local fc = cm:GetPropertyChangedSignal("FieldOfView"):Connect(function() if cm.FieldOfView ~= b then cm.FieldOfView = b end end)
	pcall(ru.UnbindFromRenderStep, ru, "SaeFov")
	ru:BindToRenderStep("SaeFov", Enum.RenderPriority.Last.Value, function()
		cm.FieldOfView = b
		if os.clock() - st.ft < 1.7 and ge.__SaeAf == st then return end
		ru:UnbindFromRenderStep("SaeFov")
		fc:Disconnect()
		st.fb = nil
	end)
end

local function aq(on)
	if on and #st.tc > 0 then return end
	for _, c in st.tc do pcall(function() c:Disconnect() end) end
	table.clear(st.tc)
	if not on then
		for p, v in st.ta do
			if p.Parent then pcall(function() p.CanTouch = v end) end
		end
		table.clear(st.ta)
		return
	end
	local function np(p)
		if not p:IsA("BasePart") or st.ta[p] ~= nil then return end
		st.ta[p] = p.CanTouch
		pcall(function() p.CanTouch = false end)
		st.tc[#st.tc + 1] = p:GetPropertyChangedSignal("CanTouch"):Connect(function() if p.CanTouch then p.CanTouch = false end end)
	end
	local function tr(t)
		if not t.Parent or t:GetAttribute("Owner") == lp.Name then return end
		np(t)
		for _, d in t:GetDescendants() do np(d) end
		st.tc[#st.tc + 1] = t.DescendantAdded:Connect(np)
	end
	for _, t in cl:GetTagged("PlacedTrap") do pcall(tr, t) end
	st.tc[#st.tc + 1] = cl:GetInstanceAddedSignal("PlacedTrap"):Connect(function(t) task.defer(pcall, tr, t) end)
end

local function su(on)
	for _, c in st.uc do pcall(function() c:Disconnect() end) end
	table.clear(st.uc)
	for h in st.uh do pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Physics, true) end) end
	table.clear(st.uh)
	if not on then return end
	local ph = Enum.HumanoidStateType.Physics
	local function nd(d)
		if d:IsA("Motor6D") then
			if not d.Enabled then d.Enabled = true end
			st.uc[#st.uc + 1] = d:GetPropertyChangedSignal("Enabled"):Connect(function() if not d.Enabled then d.Enabled = true end end)
		elseif (d:IsA("BallSocketConstraint") or d:IsA("HingeConstraint")) and d:GetAttribute("RagdollConstraint") then
			d.Enabled = false
		elseif d:IsA("Humanoid") and not st.uh[d] then
			st.uh[d] = true
			pcall(function() d:SetStateEnabled(ph, false) end)
			st.uc[#st.uc + 1] = d.StateChanged:Connect(function(_, n) if n == ph then pcall(function() d:ChangeState(Enum.HumanoidStateType.GettingUp) end) end end)
		end
	end
	local function bc(ch)
		for _, d in ch:GetDescendants() do nd(d) end
		st.uc[#st.uc + 1] = ch.DescendantAdded:Connect(nd)
	end
	if lp.Character then bc(lp.Character) end
	st.uc[#st.uc + 1] = lp.CharacterAdded:Connect(bc)
	st.uc[#st.uc + 1] = lp:GetAttributeChangedSignal("RagdollEndTime"):Connect(function() st.uu = os.clock() + 0.5 end)
	st.uc[#st.uc + 1] = ru.Heartbeat:Connect(function()
		if os.clock() >= st.uu then return end
		local h, hu = rt()
		if not h or not hu then return end
		local v = h.AssemblyLinearVelocity
		local hv, ws = Vector3.new(v.X, 0, v.Z), hu.WalkSpeed
		if hv.Magnitude <= ws and v.Y <= 0 then return end
		if hv.Magnitude > ws then hv = hv.Unit * ws end
		h.AssemblyLinearVelocity = Vector3.new(hv.X, math.min(v.Y, 0), hv.Z)
	end)
end

local function un()
	ul()
	qh(false)
	sm(false)
	fz(false)
	local ch, o, c = lp.Character, st.so, st.sc
	st.so, st.sc = nil, nil
	if not (o and c and ch and o.Parent == nil and c.Parent == ch) then return end
	o.Parent = ch
	workspace.CurrentCamera.CameraSubject = o
	ct(o)
	pcall(function() c:Destroy() end)
	ra(ch)
end

local function sw()
	local ch = lp.Character
	local hu = ch and ch:FindFirstChildOfClass("Humanoid")
	if st.sc and hu == st.sc and st.sc.Parent == ch then return true end
	if st.sc then un() end
	if not hu or hu.Health <= 0 or hu.FloorMaterial == Enum.Material.Air or not gd[hu:GetState()] then return false end
	local c = hu:Clone()
	hu.Parent = nil
	c.Parent = ch
	workspace.CurrentCamera.CameraSubject = c
	ct(c)
	ra(ch)
	st.so, st.sc, st.at = hu, c, nil
	local a, b = hu:FindFirstChildOfClass("Animator"), c:FindFirstChildOfClass("Animator")
	if a and b then
		st.sl[#st.sl + 1] = a.AnimationPlayed:Connect(function(k)
			if not k.Animation or c.Parent == nil then return end
			local ok, t = pcall(function() return b:LoadAnimation(k.Animation) end)
			if not ok or not t then return end
			pcall(function()
				t.Priority, t.Looped = k.Priority, k.Looped
				t:Play(0.05, math.max(k.WeightTarget, 0.01), k.Speed)
			end)
			local s
			s = k.Stopped:Connect(function()
				s:Disconnect()
				pcall(function() t:Stop(0.1) end)
			end)
		end)
	end
	st.sl[#st.sl + 1] = c.Died:Connect(function()
		ul()
		st.so, st.sc = nil, nil
		local cc = lp.Character
		if cc and hu.Parent == nil then
			hu.Parent = cc
			workspace.CurrentCamera.CameraSubject = hu
			ct(hu)
		end
		pcall(function() c:Destroy() end)
		hu.Health = 0
	end)
	return true
end

local function ac()
	if typeof(filtergc) ~= "function" then return "Monitor Check Failed: No Filtergc" end
	if not st.at or rawget(st.at, "InitializingUntil") == nil then
		local ok, r = pcall(filtergc, "table", {Keys = {"InitializingUntil"}}, false)
		st.at = ok and type(r) == "table" and r[1] or nil
		st.h0 = st.at and tonumber(rawget(st.at, "HistoryCount")) or nil
	end
	local t = st.at
	if not t then return "Monitor Check Failed: Monitor Not Found" end
	local h, c = tonumber(rawget(t, "HistoryCount")) or 0, rawget(t, "CorrectionReason")
	if c ~= nil then return "Monitor Active: Correction " .. tostring(c) end
	if h > (st.h0 or 0) + 2 then return "Monitor Active: Sampling" end
	return nil
end

local function gy2(p, v, up, inc)
	local pm = RaycastParams.new()
	if inc then
		pm.FilterType, pm.FilterDescendantsInstances = Enum.RaycastFilterType.Include, inc
	else
		pm.FilterType, pm.FilterDescendantsInstances, pm.RespectCanCollide = Enum.RaycastFilterType.Exclude, {lp.Character, workspace.CurrentCamera}, true
	end
	local y
	for _, o in {Vector3.zero, v.Magnitude > 0.1 and v.Unit * 6 or Vector3.zero} do
		local r = workspace:Raycast(p + o + Vector3.new(0, up, 0), Vector3.new(0, -up - 110, 0), pm)
		if r then y = math.max(y or -math.huge, r.Position.Y) end
	end
	return y and y + st.gh or p.Y
end

local function mv(tg, ck, to, cp, gf)
	local c = lp.Character
	if not rt() then return false, "Move Failed: No Character" end
	local t0, dn, wy = os.clock(), nil, nil
	local kp, kt = rt().Position, os.clock()
	local cn = ru.PreSimulation:Connect(function(d)
		if dn ~= nil then return end
		local hr, hm = rt()
		if ge.__SaeAf ~= st or not (st.on or st.bo) then dn, wy = false, "Stopped" return end
		if not hr or not hm or hm.Health <= 0 or lp.Character ~= c then dn, wy = false, "Move Failed: Character Lost" return end
		fz(gf ~= nil or hm.FloorMaterial == Enum.Material.Air)
		local r = ck and ck()
		if r then dn, wy = false, r return end
		if os.clock() - t0 > to then dn, wy = false, "Move Failed: Timeout" return end
		local v, gy = tg - hr.Position, nil
		if gf == true then v, gy = Vector3.new(v.X, 0, v.Z), gy2(hr.Position, Vector3.new(v.X, 0, v.Z), 10) end
		local m = v.Magnitude
		if m <= 1 then
			hr.AssemblyLinearVelocity = Vector3.zero
			dn = true
			return
		end
		if os.clock() - kt >= 1 then
			if (hr.Position - kp).Magnitude < 2 then dn, wy = false, "Move Failed: Blocked" return end
			kp, kt = hr.Position, os.clock()
		end
		local dt, ws = math.max(d, 1 / 240), hm.WalkSpeed * (cp or 1)
		local w2 = v.Unit * math.min(ws, m / dt)
		if gy then w2 += Vector3.new(0, math.clamp((gy - hr.Position.Y) / dt * 0.2, -ws, ws), 0) end
		local fd = Vector3.new(v.X, 0, v.Z)
		if gf ~= nil and fd.Magnitude > 0.5 then hr.CFrame = CFrame.lookAt(hr.Position, hr.Position + fd) end
		hr.AssemblyLinearVelocity = w2 + Vector3.new(0, workspace.Gravity * d * 0.5, 0)
		hr.AssemblyAngularVelocity = Vector3.zero
	end)
	st.cn[#st.cn + 1] = cn
	while dn == nil do ru.Heartbeat:Wait() end
	xc(cn)
	return dn, wy
end

local function hp(en, y, rq, ck, inc)
	while true do
		if ge.__SaeAf ~= st or not (st.on or st.bo) then return false, "Stopped" end
		local r = ck and ck()
		if r then return false, r end
		local hr = rt()
		if not hr then return false, "Home Failed: Character Lost" end
		if rq and not cr() then return false, "Home Failed: Egg Lost" end
		fz(true)
		local d = Vector3.new(en.X - hr.Position.X, 0, en.Z - hr.Position.Z)
		if d.Magnitude <= 264 then
			hr.CFrame = CFrame.new(en) * hr.CFrame.Rotation
			hr.AssemblyLinearVelocity = Vector3.zero
			return true
		end
		local nx, nz = hr.Position.X + d.Unit.X * 264, hr.Position.Z + d.Unit.Z * 264
		local np = Vector3.new(nx, y or gy2(Vector3.new(nx, hr.Position.Y, nz), Vector3.zero, 60, inc), nz)
		hr.CFrame = y and CFrame.new(np) * hr.CFrame.Rotation or CFrame.lookAt(np, np + d.Unit)
		hr.AssemblyLinearVelocity = Vector3.zero
		task.wait(0.1)
	end
end


local function go(e)
	local z0, z1 = cz()
	if not z0 then return false, "Fly Failed: No Corridor" end
	local h = rt()
	if not h then return false, "Fly Failed: No Character" end
	local hz = math.clamp(h.Position.Z, z0, z1)
	if hz ~= h.Position.Z then
		local ok, wy = mv(Vector3.new(h.Position.X, h.Position.Y, hz), nil, 10, nil, true)
		if not ok then return false, wy end
		h = rt()
		if not h then return false, "Fly Failed: No Character" end
	end
	local b, nt = Vector3.new(e.p.X, h.Position.Y, math.clamp(e.p.Z, z0, z1)), 0
	local u = Vector3.new(b.X - h.Position.X, 0, b.Z - h.Position.Z)
	if u.Magnitude > 7 then b -= u.Unit * 7 end
	local function ck()
		if os.clock() < nt then return nil end
		nt = os.clock() + 0.25
		if not av(e.u) then return "Fly Failed: Egg Gone" end
		local dd = dl()
		if not dd or dd < 2 then return "Fly Failed: Night Coming" end
		return nil
	end
	local _, hu = rt()
	local ok, wy = mv(b, ck, hu and (b - h.Position).Magnitude / math.max(hu.WalkSpeed * st.fm, 16) + 10 or 30, st.fm, true)
	if not ok then return false, wy end
	h = rt()
	if not h then return false, "Fly Failed: No Character" end
	local f = Vector3.new(e.p.X - h.Position.X, 0, e.p.Z - h.Position.Z)
	return mv(e.p + Vector3.new(0, 3, 0) - (f.Magnitude > 7 and f.Unit * 7 or f), ck, 10, st.fm, false)
end

local function kd()
	local ok, r = pcall(rg.IsRagdolled, lp.Character)
	if ok and r == true then return true end
	local n = tonumber(lp:GetAttribute("RagdollEndTime"))
	return n ~= nil and n > workspace:GetServerTimeNow()
end

local function tk(e)
	local k = si.LooksLikeFirstAreaUid(e.u) and si.SlotKey(e.r.AreaId, e.r.NestId) or nil
	local t0 = os.clock()
	while kd() and os.clock() - t0 < 5 do task.wait(0.1) end
	local t1 = os.clock()
	local ok, a, b = pcall(es.CarryFieldEgg, e.u, k)
	while ok and not a and ((tostring(b):find("knocked down", 1, true) and os.clock() - t0 < 6) or (tostring(b):find("Get closer", 1, true) and os.clock() - t1 < 1.5)) do
		task.wait(0.25)
		ok, a, b = pcall(es.CarryFieldEgg, e.u, k)
	end
	if ok and not a and tostring(b):find("gameplay area", 1, true) then
		local l = sp()
		local o2, r = pcall(es.ReadFieldEgg, e.u)
		local p = o2 and type(r) == "table" and typeof(r.BoundsCFrame) == "CFrame" and r.BoundsCFrame.Position
		if l and p then
			local lv = l.CFrame.LookVector
			lg(string.format("Retake Inside | Egg %d", math.floor(lv:Dot(p - l.Position))))
			if mv(p - lv * (lv:Dot(p - l.Position) - 4) + Vector3.new(0, 3, 0), nil, 5) then ok, a, b = pcall(es.CarryFieldEgg, e.u, k) end
		end
	end
	if not ok then return false, "Take Failed: " .. tostring(a) end
	if not a then return false, "Take Failed: " .. tostring(b or "Denied") end
	local t = os.clock()
	repeat task.wait() until cr() or os.clock() - t > 1
	if not cr() then return false, "Take Failed: Not Carrying" end
	st.pu = e.u
	return true
end

local function rp()
	local t0 = os.clock()
	task.wait(st.dw)
	local o1, cs = pcall(es.ReadCarryState)
	local u = o1 and type(cs) == "table" and cs.Uid
	if type(u) ~= "string" then return false, "Drop Failed: No Carry Uid" end
	local o2, a, b = pcall(es.DropFieldEgg, "PlayerRequest")
	if not o2 or not a then return false, "Drop Failed: " .. tostring(o2 and (b or "Denied") or a) end
	local t1 = os.clock()
	repeat task.wait() until not cr() or os.clock() - t1 > 1
	if cr() then return false, "Drop Failed: Still Carrying" end
	local o3, r = pcall(es.ReadFieldEgg, u)
	local ok, wy = tk({u = u, r = o3 and type(r) == "table" and r or {}})
	if not ok then return false, "Repick " .. tostring(wy) end
	lg(string.format("Relay %dms (Drop %dms, Take %dms)", (os.clock() - t0) * 1000, (t1 - t0 - st.dw) * 1000, (os.clock() - t1) * 1000))
	return true
end

local function ze()
	local w = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	local a = w and w:FindFirstChild("Areas")
	local g = a and a:FindFirstChild("GuardAreas")
	local o = {}
	if not g then return o end
	for _, z in g:GetChildren() do
		local b = z:FindFirstChild("Bounds")
		if b and b:IsA("BasePart") then o[#o + 1] = b.Position.X - b.Size.X / 2 end
	end
	table.sort(o, function(x1, x2) return x1 > x2 end)
	return o
end

local function dg()
	local l, h = sp(), rt()
	if not (l and h) then return "No Character" end
	local nd = math.huge
	for _, p in ps:GetPlayers() do
		local r = p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		if r then nd = math.min(nd, (r.Position - h.Position).Magnitude) end
	end
	return string.format("Me %d Z %d Ragdoll %s Trapped %s Player %s", math.floor(l.CFrame.LookVector:Dot(h.Position - l.Position)), math.floor(h.Position.Z), tostring(kd()), tostring(lp.Character and lp.Character:GetAttribute("IsTrapped") == true), nd == math.huge and "None" or tostring(math.floor(nd)))
end

local function sz(z, lq, lv)
	local tf, hb = workspace:FindFirstChild("Transient"), {}
	for _, d in tf and tf:GetDescendants() or {} do
		if d.Name == "PlayerTrap" then
			local x = d:FindFirstChild("Hitbox") or d
			if x:IsA("BasePart") and d:GetAttribute("Owner") ~= lp.Name then
				local s = lv:Dot(x.Position - lq)
				if s > -40 and s < 70 then hb[#hb + 1] = {x.Position.Z, math.max(x.Size.X, x.Size.Z) / 2 + 6} end
			end
		end
	end
	if #hb == 0 then return z end
	local z0, z1 = cz()
	z0, z1 = z0 or z - 60, z1 or z + 60
	for k = 0, 60 do
		for _, c in {z + k * 3, z - k * 3} do
			if c >= z0 and c <= z1 then
				local ok = true
				for _, t in hb do
					if math.abs(c - t[1]) < t[2] then
						ok = false
						break
					end
				end
				if ok then
					if c ~= z then lg(string.format("Trap Lane %d -> %d", math.floor(z), math.floor(c))) end
					return c
				end
			end
		end
	end
	return z
end

local function hm(rq)
	local l, h = sp(), rt()
	if not l then return false, "Home Failed: No Separation Line" end
	if not h then return false, "Home Failed: No Character" end
	local lv, lq = l.CFrame.LookVector, l.Position
	local q = h.Position - lv * (lv:Dot(h.Position - lq) - 48)
	local en = Vector3.new(q.X, lq.Y + 3, sz(q.Z, lq, lv))
	if rq then
		local k = 0
		for _, x in ze() do
			if x < h.Position.X then
				k += 1
				if k % st.rz == 0 and x + 10 > en.X + 150 then
					lg("Relay At " .. math.floor(x + 10))
					local ok, wy = hp(Vector3.new(x + 10, en.Y, q.Z), nil, true)
					if not ok then return false, wy end
					ok, wy = rp()
					if not ok then return false, wy end
				end
			end
		end
	end
	local ok, wy = hp(en, nil, rq)
	if not ok then return false, wy end
	if not rq then
		task.wait(0.1)
		return mv(en - lv * 70, nil, 5)
	end
	ok, wy = rp()
	if not ok then return false, wy end
	local o1, cs = pcall(es.ReadCarryState)
	local sm = o1 and type(cs) == "table" and tonumber(cs.SpeedMultiplier) or 0.9
	local cu = o1 and type(cs) == "table" and cs.Uid
	local n0, dw2 = st.n, nil
	ok, wy = mv(en - lv * 70, function()
		if not cr() then
			dw2 = dw2 or dg()
			return "Delivered"
		end
		return nil
	end, 5, sm, false)
	if wy ~= "Delivered" and not ok then return false, wy end
	local t = os.clock()
	repeat task.wait(0.05) until (not cr() and st.n > n0) or os.clock() - t > 3
	if st.n <= n0 then
		local o2, r = pcall(es.ReadFieldEgg, cu)
		local ep = o2 and type(r) == "table" and typeof(r.BoundsCFrame) == "CFrame" and r.BoundsCFrame.Position
		return false, string.format("Home Failed: Not Claimed | %s | Egg %s %s", dw2 or dg(), o2 and type(r) == "table" and tostring(r.State) or "Gone", ep and tostring(math.floor(lv:Dot(ep - lq))) or "?")
	end
	return true
end

local function ow()
	local ok, o = pcall(es.ReadOwnerEggs, lp.UserId)
	local u, p = {}, {}
	if not ok or type(o) ~= "table" then return u, p end
	local o5, v5 = pcall(sv.Await)
	local ix = o5 and type(v5) == "table" and type(v5.Index) == "table" and v5.Index or {}
	for k, v in pairs(o) do
		if type(v) == "table" then
			local c = type(v.Placement) == "table" and v.Placement.LocalCFrame
			if typeof(c) == "CFrame" then
				p[#p + 1] = Vector2.new(c.X, c.Z)
			elseif v.Placement == nil and type(k) == "string" then
				local a, w = dr[v.AssetCategory], nil
				if st.pi and not st.ap then
					w = ix[v.AssetCategory] ~= true
				else
					w = not (st.es and a and a.Rarity and st.se[a.Rarity._id]) or (st.pi and ix[v.AssetCategory] ~= true)
				end
				if w then
					u[#u + 1] = {u = k, k = tonumber(a and a.Rarity and a.Rarity.Rank) or 0, e = tonumber(a and a.EarningRate) or 0}
				end
			end
		end
	end
	table.sort(u, function(x, y)
		if x.k ~= y.k then return x.k > y.k end
		return x.e > y.e
	end)
	return u, p
end

local function pm()
	local f = workspace:FindFirstChild("Plots")
	for _, c in f and f:GetChildren() or {} do
		local s = c:FindFirstChild("PlotSign")
		s = s and s:FindFirstChild("PlayerPlotSign")
		s = s and s:FindFirstChild("Frame")
		s = s and s:FindFirstChild("PlayerName")
		if s and s:IsA("TextLabel") and (s.Text:lower() == lp.Name:lower() or s.Text:lower() == lp.DisplayName:lower()) then return c end
	end
	return nil
end

local function pn()
	local c = pm()
	local t = c and c:FindFirstChild("ToUpdate")
	local a = t and t:FindFirstChild("StarterPen") or c and c:FindFirstChild("CenterPoint")
	if not a then return nil end
	local ok, r = pcall(function() return a:IsA("Model") and a:GetPivot() or a.CFrame end)
	return ok and r.Position or nil
end

local function tb()
	local p = pm()
	local b = p and p:FindFirstChild("TreadmillBottom")
	return b and b:IsA("BasePart") and b or nil
end

local function tm()
	local b = tb()
	if not b then return nil end
	for _, m in cl:GetTagged("ActiveTreadmill") do
		local ok, q = pcall(function() return m:IsA("Model") and m:GetPivot().Position or m.Position end)
		if ok and (q - b.Position).Magnitude < 15 then return m end
	end
	return nil
end

local function lt()
	local ok, a, b = pcall(rm.Treadmill.AskDoff.InvokeServer, rm.Treadmill.AskDoff)
	if not ok then return false, "Doff Failed: " .. tostring(a) end
	if not a then return false, "Doff Failed: " .. tostring(b or "Denied") end
	return true
end

st.bt = tm() and true or nil
do
	local ok, c = pcall(function() return rm.Treadmill.AssignedBeltShifted.OnClientEvent:Connect(function(a) st.bt = a end) end)
	if ok and c then st.cn[#st.cn + 1] = c end
	ok, c = pcall(function()
		return game:GetService("LogService").MessageOut:Connect(function(m)
			local r = m:match("Static treadmill entry rejected: (.-)%s*$")
			if r then st.tr = r:gsub("%f[%a]%a", string.upper) end
		end)
	end)
	if ok and c then st.cn[#st.cn + 1] = c end
end

local function mt()
	if st.bt then return true end
	st.tr = nil
	local b = tb()
	if not b then return false, "Treadmill Failed: No Treadmill" end
	local h, hu = rt()
	if not h or not hu or hu.Health <= 0 then return false, "Treadmill Failed: No Character" end
	if (b.Position - h.Position).Magnitude > 200 then return false, "Treadmill Failed: Too Far" end
	for _ = 1, 2 do
		h = rt()
		if not h then return false, "Treadmill Failed: Character Lost" end
		local ok, wy = mv(Vector3.new(b.Position.X, h.Position.Y, b.Position.Z), nil, 10)
		if not ok then return false, tostring(wy) end
		local t1 = os.clock()
		repeat task.wait(0.2) until st.bt or os.clock() - t1 > 3
		if st.bt then return true end
	end
	if st.tr == "Not Grounded" then return false, "Treadmill Failed: Not Grounded | Respawn" end
	return false, "Treadmill Failed: " .. (st.tr or "Not Mounted")
end

local function pe()
	local u, p = ow()
	if #u == 0 then return 0, "Place Skipped: Bag Empty" end
	if st.pf and #p >= st.pf then return 0, "Place Skipped: Pen Full" end
	st.pf = nil
	local a, h = pn(), rt()
	if not a then return 0, "Place Failed: No Pen" end
	if not h then return 0, "Place Failed: No Character" end
	if (h.Position - a).Magnitude > 20 then
		for _, q in {Vector3.new(h.Position.X, a.Y + 20, h.Position.Z), Vector3.new(a.X, a.Y + 20, a.Z), a + Vector3.new(0, 3, 0)} do
			local ok, wy = mv(q, nil, 15)
			if not ok then return 0, wy end
		end
	end
	local bd, n, wy = {}, 0, nil
	for _, e in u do
		if ge.__SaeAf ~= st or not (st.on or st.hd) then break end
		local o1, a1, b1 = pcall(es.WearEggTool, e.u)
		if not o1 or not a1 then
			wy = "Wear Failed: " .. tostring(o1 and (b1 or "Denied") or a1)
			continue
		end
		task.wait(0.15)
		local dn = false
		for x = -24, 8, 5 do
			for z = 4, 69, 5 do
				local v, fr = Vector2.new(x, z), true
				if bd[x .. "," .. z] then fr = false end
				for _, q in p do
					if fr and (q - v).Magnitude < 5 then fr = false end
				end
				if fr then
					local o2, a2, b2 = pcall(es.PlantEgg, e.u, CFrame.new(x, -0.5, z))
					if o2 and a2 then
						p[#p + 1], n, dn = v, n + 1, true
						break
					end
					wy = "Place Failed: " .. tostring(o2 and (b2 or "Denied") or a2)
					if tostring(b2):find("too many", 1, true) then
						st.pf = #p
						pcall(es.DoffEggTool, e.u)
						return n, wy
					end
					bd[x .. "," .. z] = true
				end
			end
			if dn then break end
		end
		if not dn then
			pcall(es.DoffEggTool, e.u)
			break
		end
	end
	return n, wy
end

local function rr(c)
	local a = dr[c]
	return a and a.Rarity and a.Rarity._id or ""
end

local function sc()
	local ok, s = pcall(sv.Await)
	if not ok or type(s) ~= "table" then return {}, {} end
	local p, e = {}, {}
	if st.ps and next(st.sp) then
		local q = {}
		for _, u in ipairs(s.EquippedAssets or {}) do q[u] = true end
		for k, v in pairs(s.Inventory or {}) do
			local o, i = pcall(ai.Decode, v)
			if o and type(i) == "table" and not i.IsFavorite and not i.InFuse and not q[k] and st.sp[rr(i.Category)] then p[#p + 1] = k end
		end
	end
	if st.es and next(st.se) then
		for k, v in pairs(s.EggInventory or {}) do
			if type(v) == "table" and v.Placement == nil then
				local o, r = pcall(er.Decode, v)
				if o and type(r) == "table" and st.se[rr(r.AssetCategory)] and not (st.pi and type(s.Index) == "table" and s.Index[r.AssetCategory] ~= true) then e[#e + 1] = k end
			end
		end
	end
	return p, e
end

local function sl(p, e)
	for _, z in {{p, false}, {e, true}} do
		local l, g = z[1], z[2]
		for i = 1, #l, 512 do
			local b = table.move(l, i, math.min(i + 511, #l), 1, {})
			pcall(function() rm.PetSatchel.SellSelection:FireServer({Assets = g and {} or b, Eggs = g and b or {}}) end)
		end
	end
end

local function wp2()
	local w = workspace:FindFirstChild("World")
	local a = w and w:FindFirstChild("Areas")
	local p = a and a:FindFirstChild("WallStartCollision")
	return p and p:IsA("BasePart") and p or nil
end

local function bw2()
	local p = wp2()
	return p ~= nil and p.CanCollide
end

local function wl()
	local p, h = wp2(), rt()
	if not (p and h) then return false, "Wall Wait Failed: No Wall" end
	local lv = p.CFrame.LookVector
	local s = lv:Dot(h.Position - p.Position)
	if s < -12 or s > -3 then
		local z0, z1 = cz()
		local q = h.Position - lv * (s + 6)
		if z0 then q = Vector3.new(q.X, q.Y, math.clamp(q.Z, z0, z1)) end
		local ok, wy = mv(q, function() return not bw2() and "Wall Down" or nil end, 10, st.fm, true)
		if not ok and wy ~= "Wall Down" then return false, wy end
	end
	while bw2() do
		if ge.__SaeAf ~= st or not st.on then return false, "Stopped" end
		task.wait(0.05)
	end
	return true
end

local function wq()
	local l = cd()
	if #l == 0 then return os.clock() < st.ef and "Egg Bag Full" or "No Eggs" end
	local d, h, hu = dl(), rt()
	if d and h and hu and d < math.abs(l[1].p.X - h.Position.X) / math.max(hu.WalkSpeed, 16) + 9 then return "Waiting For Day" end
	return nil
end

local function pg2(on)
	local w = workspace:FindFirstChild("World")
	local p = w and w:FindFirstChild("HalloweenDimensionPortal")
	for _, d in p and p:GetDescendants() or {} do
		if d:IsA("BasePart") and d.Name == "Hitbox" and d.CanTouch ~= on then d.CanTouch = on end
	end
end

local function lob(g)
	while not st.gr and ge.__SaeAf == st do task.wait(0.1) end
	while ge.__SaeAf == st and st.on and st.g == g do
		if st.sr then break end
		pg2(false)
		if (st.bx or st.lx or st.tx) and not cr() then
			if not st.fp then
				st.fp = true
				un()
				lg(st.lx and "Paused For Red Light" or st.tx and "Paused For T-Rex" or "Paused For Butterflies")
			end
			task.wait(1)
			continue
		end
		if st.fp then
			if st.bo then
				task.wait(0.5)
				continue
			end
			st.fp = false
			lg("Resuming Farm")
		end
		fz(false)
		if st.bt or tm() then
			local wy = not cr() and wq()
			if wy and not (wy == "Waiting For Day" and bw2()) then
				lg(wy .. " | On Treadmill")
				task.wait(1)
				continue
			end
			lg("Leaving Treadmill")
			local ok, wy = lt()
			if not ok then lg(tostring(wy)) end
			task.wait(1)
			continue
		end
		if not sw() then
			lg("Waiting To Swap")
			task.wait(0.2)
			continue
		end
		qh(true)
		sm(true)
		local r = ac()
		if r then
			st.on, st.sr = false, false
			un()
			xs("Auto Steal Egg", "ae", r)
			break
		end
		local h, hu = rt()
		if not h or not hu or hu.Health <= 0 then
			lg("Waiting For Character")
			task.wait(0.5)
			continue
		end
		if not cr() then
			local l = cd()
			if #l == 0 then
				local nm = os.clock() < st.ef and "Egg Bag Full" or "No Eggs"
				if fs() then
					lg(nm .. " | Going Home")
					hm(false)
					continue
				end
				if (st.pi or st.ap) and os.clock() >= st.pc then
					st.pc = os.clock() + 15
					lg("Placing Eggs")
					local n, wy = pe()
					lg(string.format("Placed %d%s", n, wy and (" | " .. wy) or ""))
				end
				if os.clock() >= st.mq then
					st.mq = os.clock() + 3
					lg(nm .. " | Mounting Treadmill")
					un()
					local ok, wy = mt()
					lg(ok and "Treadmill Mounted" or tostring(wy))
					continue
				end
				lg(nm)
				task.wait(1)
				continue
			end
			local e = l[1]
			local d, de = dl()
			if not d then
				lg(tostring(de))
				task.wait(1)
				continue
			end
			if d < math.abs(e.p.X - h.Position.X) / math.max(hu.WalkSpeed, 16) + 9 then
				if fs() then
					lg("Night Coming, Going Home")
					hm(false)
				elseif bw2() then
					lg("Waiting For Wall")
					local ok, wy = wl()
					lg(ok and "Wall Down" or tostring(wy))
				else
					if (st.pi or st.ap) and os.clock() >= st.pc then
						lg("Placing Eggs")
						local n, wy = pe()
						st.pc = os.clock() + 15
						lg(string.format("Placed %d%s", n, wy and (" | " .. wy) or ""))
					end
					if os.clock() >= st.mq then
						st.mq = os.clock() + 3
						lg("Waiting For Day | Mounting Treadmill")
						un()
						local ok, wy = mt()
						lg(ok and "Treadmill Mounted" or tostring(wy))
						continue
					end
					lg("Waiting For Day")
					task.wait(0.5)
				end
				continue
			end
			lg("Flying To " .. tostring(e.r.AssetCategory) .. " (" .. tostring(e.r.AreaId) .. ")")
			st.ct = os.clock()
			local ok, wy = go(e)
			if ok then
				lg("Taking " .. tostring(e.r.AssetCategory))
				ok, wy = tk(e)
			end
			if not ok then
				if tostring(wy):find("egg inventory is full", 1, true) then
					st.ef, st.pc = os.clock() + 30, 0
					lg("Egg Bag Full")
					continue
				end
				if tostring(wy):find("inventory full", 1, true) then
					lg(tostring(wy))
					task.wait(1)
					continue
				end
				if tostring(wy):find("Get closer", 1, true) then
					st.gc += 1
					lg(tostring(wy))
					if st.gc >= 2 then
						st.gc = 0
						lg("Waiting For Position Sync")
						task.wait(4)
					end
					continue
				end
				if wy == "Move Failed: Blocked" then
					st.bk[e.u] = (st.bk[e.u] or 0) + 1
					if st.bk[e.u] >= 3 then
						st.bl[e.u], st.bk[e.u] = os.clock() + 30, nil
					else
						task.wait(1)
					end
				elseif wy ~= "Stopped" and wy ~= "Move Failed: Character Lost" and wy ~= "Fly Failed: Night Coming" and not tostring(wy):find("knocked down", 1, true) then
					st.bl[e.u] = os.clock() + 30
				end
				lg(tostring(wy))
				task.wait(0.2)
				continue
			end
		end
		lg("Flying Home")
		local ok, wy = hm(true)
		if ok then
			st.pu, st.gc = nil, 0
			lg(string.format("Delivered %.1fs", st.ct and os.clock() - st.ct or 0))
			st.ct = nil
		else
			lg(tostring(wy))
			if tostring(wy):find("Get closer", 1, true) then
				st.gc += 1
				if st.gc >= 2 then
					st.gc = 0
					lg("Waiting For Position Sync")
					task.wait(4)
				end
			end
			task.wait(0.2)
		end
	end
	if not st.sr or ge.__SaeAf ~= st or st.g ~= g then return end
	st.on, st.sr = false, false
	if st.fp then
		st.fp = false
		lg("Idle")
		return
	end
	if st.bt or tm() then
		lg("Leaving Treadmill")
		local ok, wy = lt()
		if not ok then lg(tostring(wy)) end
	end
	un()
	pg2(true)
	lg("Idle")
end

local function lo(g)
	local ok, e = xpcall(lob, debug.traceback, g)
	if ok or ge.__SaeAf ~= st or st.g ~= g then return end
	pcall(pg2, true)
	local p = st.fp
	st.on, st.sr, st.fp = false, false, false
	if not p then
		local _, hu = rt()
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		pcall(un)
	end
	xs("Auto Steal Egg", "ae", "Farm Crashed", e)
end

local ok, c = pcall(function()
	return es.FieldClaimed:Connect(function(a)
		if st.on then fv() end
		st.n += 1
		print("[Sae] Claimed #" .. st.n .. " " .. tostring(type(a) == "table" and a.DisplayName or a))
	end)
end)
if ok and c then st.cn[#st.cn + 1] = c end

function st.Start()
	if not kv() then lg("Key Check Failed: No Valid Key") return end
	st.sr = false
	if st.on then return end
	st.on, st.g, st.at = true, st.g + 1, nil
	task.spawn(lo, st.g)
end

function st.Stop(f)
	if st.on and not f then
		st.sr = true
		lg("Stopping After Trip")
		return
	end
	local w = st.on
	st.on, st.sr = false, false
	pg2(true)
	if not (w or f) and st.bo then return end
	local _, hu = rt()
	local t = os.clock()
	while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
	un()
	lg("Idle")
end

local bb, bw, bq = (function()
	local ok, a, b, c = pcall(function()
		local e = rs.Controllers.Game.AdminAbuseClientController.Events.ButterflyBloom
		return require(e), require(e.Swarm), require(rs.Shared.Modules.ButterflyCatalog)
	end)
	if ok then return a, b, c end
	return nil, nil, nil
end)()

pcall(function()
	st.cn[#st.cn + 1] = rm.LiveEvents.Began.OnClientEvent:Connect(function(n, d) if n == "ButterflyBloom" and type(d) == "number" then st.be = workspace:GetServerTimeNow() + d end end)
	st.cn[#st.cn + 1] = rm.LiveEvents.Ended.OnClientEvent:Connect(function(n) if n == "ButterflyBloom" then st.be = nil end end)
end)

local function ba()
	if st.be and st.be > workspace:GetServerTimeNow() then return true end
	if not bb then return false end
	local ok, a, e = pcall(function() return debug.getupvalue(bb.StartEvent, 1), debug.getupvalue(bb.StartEvent, 2) end)
	return ok and a == true and type(e) == "number" and e > workspace:GetServerTimeNow()
end

local bfl = (function()
	local ok, r = pcall(function() return require(rs.Shared.Flags.ButterflyFlags) end)
	return ok and type(r) == "table" and r or nil
end)()

local function bc()
	local t = workspace:GetServerTimeNow()
	local function tf(x)
		x = math.max(0, math.floor(x))
		return string.format("%02d:%02d", x // 60, x % 60)
	end
	if st.be and st.be > t then return "Butterfly Bloom Active: " .. tf(st.be - t) .. " Left" end
	if bb then
		local ok, a, e = pcall(function() return debug.getupvalue(bb.StartEvent, 1), debug.getupvalue(bb.StartEvent, 2) end)
		if ok and a == true and type(e) == "number" and e > t then return "Butterfly Bloom Active: " .. tf(e - t) .. " Left" end
	end
	local function fv2(k)
		local f = bfl and bfl[k]
		return type(f) == "table" and f.Value or nil
	end
	if fv2("Enabled") == false then return "Next Butterfly Bloom: Disabled" end
	local i, o = tonumber(fv2("IntervalSeconds")), tonumber(fv2("OffsetSeconds"))
	if not (i and o and i > 0) then return "Next Butterfly Bloom: Unknown" end
	return "Next Butterfly Bloom: " .. tf(o + math.ceil((t - o) / i) * i - t)
end

local function bn()
	local ok, s = pcall(sv.Await)
	local b = ok and type(s) == "table" and s.Butterflies
	if type(b) ~= "table" then return false, 0 end
	return b.NetClaimed == true, tonumber(b.TotalCaught) or 0
end

local function bv()
	for _, c in {lp.Character, lp:FindFirstChildOfClass("Backpack")} do
		for _, t in c and c:GetChildren() or {} do
			if t:IsA("Tool") and t:GetAttribute("ButterflyNet") == true then return t end
		end
	end
	return nil
end

local function bz()
	local w = workspace:FindFirstChild("World")
	local a = w and w:FindFirstChild("Areas")
	local b = a and a:FindFirstChild("ButterflyBloom")
	b = b and b:FindFirstChild("Bounds")
	return b and b:IsA("BasePart") and b or nil
end

local bs = (function()
	local ok, f = pcall(function()
		local n = require(rs.Controllers.Game.AdminAbuseClientController.Events.ButterflyBloom.Net)
		for i = 1, 40 do
			local o1, v = pcall(debug.getupvalue, n.Step, i)
			if not o1 then break end
			if type(v) == "function" and debug.info(v, "n") == "autoSwing" then
				for j = 1, 10 do
					local o2, x = pcall(debug.getupvalue, v, j)
					if not o2 then break end
					if type(x) == "number" then return function() pcall(debug.setupvalue, v, j, os.clock()) end end
				end
			end
		end
		return nil
	end)
	return ok and f or nil
end)()

local function bd2()
	local o1, r = pcall(bq.EssenceRecipe)
	local o2, s = pcall(sv.Await)
	local c = o2 and type(s) == "table" and type(s.Butterflies) == "table" and s.Butterflies.Counts
	if not o1 or type(r) ~= "table" or type(c) ~= "table" then return nil, true end
	local n, an = {}, false
	for k, v in r do
		local d = (tonumber(v) or 0) - (tonumber(c[k]) or 0)
		if d > 0 then n[k], an = d, true end
	end
	return n, an
end

local function bh(p)
	if not (p and p:IsA("ProximityPrompt")) then return end
	p:InputHoldBegin()
	task.wait(p.HoldDuration + 0.15)
	p:InputHoldEnd()
end

local function bn2()
	local wd = workspace:FindFirstChild("World")
	local mk = wd and wd:FindFirstChild("Build")
	mk = mk and mk:FindFirstChild("EnchantedTreeInterior")
	mk = mk and mk:FindFirstChild("Markers")
	local en = mk and mk:FindFirstChild("EnterTrigger")
	en = en and en:FindFirstChild("EnchantedTreeEntrance")
	local ep, ex = en and en:FindFirstChildWhichIsA("ProximityPrompt"), mk and mk:FindFirstChild("ExitTrigger")
	local ns = wd and wd:FindFirstChild("Machines")
	ns = ns and ns:FindFirstChild("ButterflyStation")
	ns = ns and ns:FindFirstChild("NetStand")
	local an, np = ns and ns:FindFirstChild("Anchor"), ns and ns:FindFirstChildWhichIsA("ProximityPrompt", true)
	if not (en and en:IsA("Attachment") and ep and ex and an and np) then return nil end
	return {en = en, ep = ep, ex = ex, an = an, np = np}
end

local function fp(a, r)
	r = tostring(r)
	return r:find(":", 1, true) and r or (a .. ": " .. r)
end

local function bd(p, ck)
	local h, hu = rt()
	if not h or not hu then return false, "No Character" end
	local a = p.en.WorldPosition
	if (h.Position - a).Magnitude > 9 then
		if dl() == 0 or bw2() then return false, "Waiting For Day" end
		if st.bt or tm() then
			lt()
			task.wait(1)
		end
		if not sw() then return false, "Swap" end
		local o2, wy = true, nil
		local z0, z1 = cz()
		if z0 and (h.Position.Z < z0 or h.Position.Z > z1) then
			o2, wy = mv(Vector3.new(h.Position.X, h.Position.Y, math.clamp(h.Position.Z, z0, z1)), ck, 10)
			h, hu = rt()
			if o2 and not (h and hu) then o2, wy = false, "No Character" end
		end
		if o2 then
			local y = math.max(h.Position.Y, a.Y) + 50
			o2, wy = hp(Vector3.new(a.X, y, a.Z - 7), y, false, ck)
			if o2 then o2, wy = hp(Vector3.new(a.X, a.Y + 1, a.Z - 7), y, false, ck) end
		end
		fz(false)
		local _, h2 = rt()
		local t = os.clock()
		while h2 and h2.Parent and h2.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		t = os.clock()
		while o2 and os.clock() - t < 8 do
			local r = ck and ck()
			if r then o2, wy = false, r end
			task.wait(0.2)
		end
		un()
		if not o2 then return false, wy end
	end
	return true
end

local function bj(p, ck)
	local ok, s = pcall(sv.Await)
	local w = ok and type(s) == "table" and s.WispCompanion
	if type(w) ~= "table" or w.Unlocked ~= true then return false, "Wisp Locked" end
	if lp:GetAttribute("InEnchantedTree") == true then return true end
	local o2, wy = bd(p, ck)
	if not o2 then return false, wy end
	bh(p.ep)
	local t = os.clock()
	repeat task.wait(0.2) until lp:GetAttribute("InEnchantedTree") == true or os.clock() - t > 6
	if lp:GetAttribute("InEnchantedTree") ~= true then return false, "Not Entered" end
	task.wait(0.5)
	return true
end

local function be(p, ck)
	local h = rt()
	if h then mv(Vector3.new(p.ex.Position.X, h.Position.Y, p.ex.Position.Z), function() if lp:GetAttribute("InEnchantedTree") ~= true then return "Left" end return ck and ck() end, 10) end
	local t = os.clock()
	repeat task.wait(0.2) until lp:GetAttribute("InEnchantedTree") ~= true or os.clock() - t > 5
	fz(false)
	return lp:GetAttribute("InEnchantedTree") ~= true
end

local function bk()
	local p = bn2()
	if not p then return false, "Net Failed: No Tree" end
	local function ck() if st.on or not st.bf then return "Stopped" end return nil end
	st.bo = true
	local ok, r = bj(p, ck)
	if not ok then st.bo = false return false, fp("Net Failed", r) end
	local h = rt()
	if not h then st.bo = false return false, "Net Failed: No Character" end
	local o2, wy = mv(Vector3.new(p.an.Position.X - 5, h.Position.Y, p.an.Position.Z), ck, 10)
	if not o2 then st.bo = false return false, fp("Net Failed", wy) end
	task.wait(0.3)
	bh(p.np)
	local t = os.clock()
	repeat task.wait(0.2) until bn() or os.clock() - t > 5
	local got = bn()
	be(p, ck)
	st.bo = false
	return got, not got and "Net Failed: Not Claimed" or nil
end

local function bu()
	if st.on then return false, "Teleport Failed: Farm Running" end
	if st.hd or st.hm or st.hx then return false, "Teleport Failed: Halloween Running" end
	if st.bo then return false, "Teleport Failed: Busy" end
	local p = bn2()
	if not p then return false, "Teleport Failed: No Tree" end
	local function ck() if st.on then return "Stopped" end return nil end
	st.bo = true
	local ok, r = bj(p, ck)
	if not ok then st.bo = false return false, fp("Teleport Failed", r) end
	local h = rt()
	if not h then st.bo = false return false, "Teleport Failed: No Character" end
	local o2, wy = mv(Vector3.new(p.an.Position.X - 5, h.Position.Y, p.an.Position.Z), ck, 10)
	fz(false)
	st.bo = false
	if not o2 then return false, fp("Teleport Failed", wy) end
	return true
end

local wqd = (function()
	local ok, r = pcall(function() return require(rs.Data.WispQuests) end)
	return ok and type(r) == "table" and r or nil
end)()

local function ws()
	local o, s = pcall(sv.Await)
	local w = o and type(s) == "table" and s.WispCompanion
	return type(w) == "table" and w or nil
end

local function wu()
	local w = ws()
	return w ~= nil and w.Unlocked == true
end

local function fi(r, ...)
	local a = table.pack(pcall(r.InvokeServer, r, ...))
	if a[1] and a[2] then return true end
	return false, tostring(a[1] and (a[3] or "Denied") or a[2])
end

local function wr(a, b)
	return fi(rm.WispCompanion.Request, a, b)
end

local function wa(id)
	local ok, r = pcall(function() return require(rs.Data.Areas) end)
	local d = ok and type(r) == "table" and (r.Directory or r)[id]
	local o = {}
	for _, x in type(d) == "table" and d.DropTable or {} do
		if type(x) == "table" and type(x[1]) == "string" then o[x[1]] = true end
	end
	return o
end

local function wp(id)
	local o, s = pcall(sv.Await)
	if not o or type(s) ~= "table" then return nil end
	local c, q, g = wa(id), {}, {}
	for _, u in ipairs(s.EquippedAssets or {}) do q[u] = true end
	for k, v in pairs(s.Inventory or {}) do
		local o2, i = pcall(ai.Decode, v)
		if o2 and type(i) == "table" and c[i.Category] and not i.IsFavorite and not i.InFuse and not i.CreatorTemporary and not q[k] then
			g[i.Category] = g[i.Category] or {}
			table.insert(g[i.Category], k)
			if #g[i.Category] >= 3 then return g[i.Category] end
		end
	end
	return nil
end

local function wz(l)
	local m = workspace:FindFirstChild("World")
	m = m and m:FindFirstChild("Machines")
	m = m and m:FindFirstChild("FuseMachine")
	m = m and m:FindFirstChild("Machine")
	if not (m and m:IsA("BasePart")) then return false, "Fuse Failed: No Machine" end
	local h = rt()
	if not h then return false, "Fuse Failed: No Character" end
	if st.bt or tm() then
		lt()
		task.wait(1)
		h = rt()
		if not h then return false, "Fuse Failed: No Character" end
	end
	local d = Vector3.new(h.Position.X - m.Position.X, 0, h.Position.Z - m.Position.Z)
	if d.Magnitude > 6 then
		st.bo = true
		local ok, wy = mv(Vector3.new(m.Position.X, h.Position.Y, m.Position.Z) + d.Unit * 5, nil, 15)
		st.bo = false
		fz(false)
		if not ok then return false, fp("Fuse Failed", wy) end
	end
	local o, s = pcall(sv.Await)
	if not o or type(s) ~= "table" then return false, "Fuse Failed: No Save" end
	if s.FusionInfoAcknowledged == false then fi(rm.Fusery.ConfirmBriefing) end
	if s.FusionEggReward then fi(rm.Fusery.FinishReveal) end
	for _, u in table.clone(type(s.FusionSlots) == "table" and s.FusionSlots or {}) do fi(rm.Fusery.EjectPet, u) end
	for _, u in l do
		local ok, wy = fi(rm.Fusery.LoadPet, u, false)
		if not ok then return false, "Fuse Failed: " .. wy end
		task.wait(0.3)
	end
	local ok, wy = fi(rm.Fusery.BeginFuse)
	if not ok then return false, "Fuse Failed: " .. wy end
	task.wait(0.6)
	ok, wy = fi(rm.Fusery.FinishReveal)
	if not ok then return false, "Fuse Reveal Failed: " .. wy end
	return true
end

local function we()
	st.wf = nil
	if not st.wo then return end
	st.wo = false
	if st.on then st.Stop() end
end

local function wt()
	local p, z = bn2(), workspace:FindFirstChild("World")
	z = z and z:FindFirstChild("Build")
	z = z and z:FindFirstChild("EnchantedForestZone")
	local a = z and z:FindFirstChild("Zone13Props")
	a = a and a:FindFirstChild("EnchantedTree")
	a = a and a:FindFirstChild("WispAnchor")
	local pr = a and a:FindFirstChild("WispTreePrompt")
	if not (p and pr) then return "Wisp Return Failed: No Tree" end
	local function ck() if st.on or not st.bf then return "Stopped" end return nil end
	st.bo = true
	local ok, wy = bd(p, ck)
	if ok then
		bh(pr)
		local t = os.clock()
		repeat task.wait(0.2) until wu() or os.clock() - t > 8
		ok, wy = wu(), "Not Unlocked"
	end
	st.bo = false
	return ok and "Wisp Unlocked" or fp("Wisp Return Failed", wy)
end

local function wd()
	local w = ws()
	if not w or not wqd then return "Wisp Failed: No State" end
	if not w.Accepted then
		local ok, m = wr("Accept")
		return ok and "Wisp Accepted" or "Wisp Accept Failed: " .. tostring(m)
	end
	local q = wqd.List[w.Stage]
	if q and not w.Claimed[q.Id] and (w.Progress[q.Id] or 0) >= q.Target then
		local ok, m = wr("Claim", q.Id)
		return ok and "Wisp Claimed | " .. q.Title or "Wisp Claim Failed: " .. tostring(m)
	end
	if q and q.Event == "EggSecured" then
		st.wf = q.Match.AreaId and {a = q.Match.AreaId} or {r = q.Match.Rarity}
		if not st.on then
			st.wo = true
			st.Start()
		end
		return string.format("Wisp Quest | %s %d/%d", q.Title, w.Progress[q.Id] or 0, q.Target)
	end
	if q and q.Event == "PetFused" then
		local l = wp(q.Match.AreaId)
		if not l then
			st.wf = {a = q.Match.AreaId}
			if not st.on then
				st.wo = true
				st.Start()
			end
			return "Wisp Quest | " .. q.Title .. " | Waiting For 3 Same Pets"
		end
		we()
		if st.on then return "Wisp | Waiting For Farm" end
		local ok, m = wz(l)
		return ok and "Wisp Fused" or tostring(m)
	end
	we()
	if st.on then return "Wisp | Waiting For Farm" end
	if q then return "Wisp Quest | " .. q.Title .. " | Not Automated" end
	if not w.Returning then
		local ok, m = wr("BeginReturn")
		return ok and "Wisp Returning" or "Wisp Return Failed: " .. tostring(m)
	end
	return wt()
end

local function gl()
	local v = workspace:GetAttribute("RLGL_Light")
	return type(v) == "string" and v or "Rise"
end

local function ge2()
	return workspace:GetAttribute("Event_RedLightGreenLight") == true and typeof(workspace:GetAttribute("RLGL_EggPosition")) == "Vector3"
end

local function gr2(ep)
	local p = workspace:GetAttribute(ep)
	if typeof(p) ~= "Vector3" then return nil end
	local ok, s = pcall(es.ReadFieldEggs)
	local b, bd = nil, 25
	for _, r in ok and type(s) == "table" and s.Records or {} do
		if typeof(r.BoundsCFrame) == "CFrame" then
			local d = (r.BoundsCFrame.Position - p).Magnitude
			if d < bd then b, bd = r, d end
		end
	end
	return b
end

local function gm(tg, sp, ck, to, gt, aj)
	local t0, dn, wy = os.clock(), nil, nil
	local cn = ru.PreSimulation:Connect(function(d)
		if dn ~= nil then return end
		local hr, hm = rt()
		if ge.__SaeAf ~= st then dn, wy = false, "Stopped" return end
		if not hr or not hm or hm.Health <= 0 then dn, wy = false, "Character Lost" return end
		fz(hm.FloorMaterial == Enum.Material.Air)
		local r = ck and ck()
		if r then dn, wy = false, r return end
		if os.clock() - t0 > to then dn, wy = false, "Timeout" return end
		local g = Vector3.new(0, workspace.Gravity * d * 0.5, 0)
		hr.AssemblyAngularVelocity = Vector3.zero
		if gt and not gt() then
			hr.AssemblyLinearVelocity = g
			return
		end
		local a2 = aj and aj(hr.Position, tg)
		local v = (a2 or tg) - hr.Position
		local m = v.Magnitude
		if m <= 1 and not a2 then
			hr.AssemblyLinearVelocity = g
			dn = true
			return
		end
		hr.AssemblyLinearVelocity = v.Unit * math.min(sp(), m / math.max(d, 1 / 240)) + g
	end)
	st.cn[#st.cn + 1] = cn
	while dn == nil do ru.Heartbeat:Wait() end
	xc(cn)
	return dn, wy
end

local function gb()
	local ok, g = pcall(function() return require(rs.Data.Gears).Directory end)
	for _, c in {lp.Character, lp:FindFirstChildOfClass("Backpack")} do
		for _, t in c and c:GetChildren() or {} do
			local n = t:IsA("Tool") and t.Name:gsub("%s*%b[]$", "")
			if n and ok and type(g) == "table" and type(g[n]) == "table" and g[n].BatControllerData then return t end
		end
	end
	return nil
end

local function gh(p, gt)
	local hr, hu = rt()
	local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if not (hr and tr) then return false, "No Target" end
	if (tr.Position - hr.Position).Magnitude > 14 or (gt and not gt()) then return false, "Not Ready" end
	local t = gb()
	if not t then return false, "No Bat" end
	if t.Parent ~= lp.Character and hu then
		pcall(function() hu:EquipTool(t) end)
		task.wait(0.1)
	end
	pcall(function() t:Activate() end)
	return true
end

local function gqb(g, c)
	local lm, nb = nil, 0
	local function l2(m)
		if m == lm then return end
		lm = m
		lg(m)
	end
	local function ck()
		if not c.on(g) or ge.__SaeAf ~= st or not c.ev() then return "Stopped" end
		return nil
	end
	local function gm2(a, sp2, ck3, to2)
		return gm(a, sp2, ck3, to2, c.gt, c.aj)
	end
	local function own(on)
		if on then
			st.bo, st[c.fb] = true, true
			return sw()
		end
		local _, hu = rt()
		if hu then pcall(function() hu:UnequipTools() end) end
		fz(false)
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		un()
		st.bo, st[c.fb] = false, false
		return true
	end
	while ge.__SaeAf == st and c.on(g) do
		st[c.fx] = c.ev()
		if st[c.fx] and c.pre then c.pre() end
		if not st[c.fx] then
			if st[c.fb] then own(false) end
			l2(c.n .. " | Waiting For Event")
			task.wait(1)
			continue
		end
		local lv0 = c.lv and lp:GetAttribute(c.lv)
		if type(lv0) == "number" and lv0 <= 0 then
			if st[c.fb] then own(false) end
			l2(c.n .. " | No Lives")
			task.wait(1)
			continue
		end
		local r = gr2(c.ep)
		local o1, cs0 = pcall(es.ReadCarryState)
		local mine = o1 and type(cs0) == "table" and cs0.IsCarrying == true and workspace:GetAttribute(c.cu) == lp.UserId
		if not st[c.fb] then
			if (cr() and not mine) or (st.on and not st.fp) or (st.bo and not st[c.fb]) then
				l2(c.n .. " | Waiting For Control")
				task.wait(0.5)
				continue
			end
			if st.bt or tm() then
				lt()
				task.wait(1)
			end
			if not own(true) then
				st.bo, st[c.fb] = false, false
				l2(c.n .. " | Waiting To Swap")
				task.wait(0.5)
				continue
			end
		end
		local _, hu = rt()
		local ws = hu and hu.WalkSpeed or 16
		if mine then
			local sm = tonumber(cs0.SpeedMultiplier) or 0.5
			local function vs() return ws * sm end
			local l, h = sp(), rt()
			if l and h then
				local lv, lq = l.CFrame.LookVector, l.Position
				local q = h.Position - lv * (lv:Dot(h.Position - lq) - 48)
				local z0, z1 = cz()
				local en = Vector3.new(q.X, lq.Y + 3, z0 and math.clamp(q.Z, z0, z1) or q.Z)
				local y = math.max(h.Position.Y, lq.Y + 45)
				local function ck2()
					local c = ck()
					if c then return c end
					if not cr() then return "Dropped" end
					return nil
				end
				l2(c.n .. " | Carrying Home")
				local ok, wy = gm2(Vector3.new(h.Position.X, y, h.Position.Z), vs, ck2, 30)
				if ok then ok, wy = gm2(Vector3.new(en.X, y, en.Z), vs, ck2, (en - h.Position).Magnitude / math.max(vs(), 8) * 3 + 30) end
				if ok then ok, wy = gm2(en, vs, ck2, 30) end
				if ok then ok, wy = gm2(en - lv * 70, vs, ck2, 40) end
				l2(ok and c.n .. " | Walked In" or c.n .. " | " .. tostring(wy))
				if not cr() then
					task.wait(2)
					if not c.ev() or not gr2(c.ep) then l2(c.n .. " Delivered") end
				end
			end
		elseif r then
			local cu = workspace:GetAttribute(c.cu)
			local cp = type(cu) == "number" and cu ~= lp.UserId and ps:GetPlayerByUserId(cu) or nil
			local function vs() return ws * st.fm end
			if cp then
				local tr = cp.Character and cp.Character:FindFirstChild("HumanoidRootPart")
				if tr then
					l2(c.n .. " | Chasing " .. cp.Name)
					gm2(tr.Position + Vector3.new(0, 2, 0), vs, function()
						local c = ck()
						if c then return c end
						local h = rt()
						if h and (tr.Position - h.Position).Magnitude <= 8 then return "Near" end
						return nil
					end, 3)
					if os.clock() >= nb and gh(cp, c.gt) then
						nb = os.clock() + 0.7
						l2(c.n .. " | Hit " .. cp.Name)
					end
				else
					task.wait(0.2)
				end
			else
				local p = r.BoundsCFrame.Position
				l2(c.n .. " | Flying To Egg")
				local h = rt()
				local ok = true
				if h and (p - h.Position).Magnitude > 60 then
					local y = math.max(h.Position.Y, p.Y) + 50
					ok = gm2(Vector3.new(h.Position.X, y, h.Position.Z), vs, ck, 20)
					if ok then ok = gm2(Vector3.new(p.X, y, p.Z), vs, ck, (p - h.Position).Magnitude / math.max(vs(), 16) * 3 + 30) end
				end
				if ok then ok = gm2(p + Vector3.new(0, 3, 0), vs, ck, 20) end
				if ok then
					while c.gt and not c.gt() and ck() == nil do task.wait(0.05) end
					l2(c.n .. " | Taking Egg")
					local o2, wy = tk({u = r.Uid, r = r})
					l2(o2 and c.n .. " | Egg Taken" or c.n .. " | " .. tostring(wy))
					local t2 = os.clock()
					while o2 and workspace:GetAttribute(c.cu) ~= lp.UserId and os.clock() - t2 < 1.5 do task.wait(0.05) end
				end
			end
		else
			l2(c.n .. " | No Egg")
			task.wait(0.5)
		end
		task.wait(0.05)
	end
	st[c.fx] = false
	if st[c.fb] then own(false) end
end

local function gq(g, c)
	local ok, e = xpcall(gqb, debug.traceback, g, c)
	if ok or ge.__SaeAf ~= st or not c.on(g) then return end
	st[c.fx] = false
	if st[c.fb] then
		local _, hu = rt()
		if hu then pcall(function() hu:UnequipTools() end) end
		pcall(fz, false)
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		pcall(un)
		st.bo, st[c.fb] = false, false
	end
	xs(c.t, c.k, c.n .. " Crashed", e)
end

local lc = {t = "Auto Red Light Green Light", k = "arl", n = "Red Light", fx = "lx", fb = "lb", ep = "RLGL_EggPosition", cu = "RLGL_CarrierUserId", lv = "RLGL_Lives", ev = ge2, gt = function() return gl() == "Green" end, on = function(g) return st.gx and st.gg == g end}

local trh = (function()
	local ok, r = pcall(function() return require(rs.Shared.Modules.TrexRunHerd) end)
	return ok and type(r) == "table" and r or nil
end)()

local tw = {}

local function tw2(l)
	table.clear(tw)
	for _, w in type(l) == "table" and l or {} do
		if type(w) == "table" and type(w.Id) == "number" then tw[w.Id] = w end
	end
end

pcall(function()
	st.cn[#st.cn + 1] = rm.TrexRun.Wave.OnClientEvent:Connect(function(w)
		if type(w) == "table" and type(w.Id) == "number" then tw[w.Id] = w end
	end)
	st.cn[#st.cn + 1] = rm.TrexRun.Herd.OnClientEvent:Connect(tw2)
end)

local function te2()
	return workspace:GetAttribute("Event_TrexRun") == true and typeof(workspace:GetAttribute("TrexRun_EggPosition")) == "Vector3"
end

local function ta2(pos)
	if not trh then return nil end
	local co = trh.ReadCourse(workspace)
	if not co then return nil end
	local now = workspace:GetServerTimeNow()
	local dp, lt = trh.Locate(co, pos)
	local bad, thr, hw = {}, false, co.LaneWidth * 0.5 + 4
	for id, w in tw do
		if trh.IsExpired(w, co, now) then
			tw[id] = nil
		elseif trh.IsMoving(w, now) and type(w.Lanes) == "table" then
			local ah = (dp - trh.DepthAt(w, now)) * w.Direction
			if ah > -10 and ah < (tonumber(w.Speed) or 150) * 1.2 + 30 then
				for k in w.Lanes do
					local la = trh.TrexLateral(co, w, k)
					bad[#bad + 1] = la
					if math.abs(la - lt) < hw then thr = true end
				end
			end
		end
	end
	if not thr then return nil end
	local best, bd
	for ln = 1, co.Lanes do
		local c0 = trh.LaneOffset(co, ln)
		local ok = true
		for _, la in bad do
			if math.abs(la - c0) < hw then
				ok = false
				break
			end
		end
		if ok and (not bd or math.abs(c0 - lt) < bd) then best, bd = c0, math.abs(c0 - lt) end
	end
	if not best then return nil end
	local q = trh.Point(co, dp, best)
	return Vector3.new(q.X, pos.Y, q.Z)
end

local nf = 0

local function tp2()
	if next(tw) ~= nil or os.clock() < nf then return end
	nf = os.clock() + 3
	local ok, l = pcall(function() return rm.TrexRun.FetchHerd:InvokeServer() end)
	if ok then tw2(l) end
end

local tc2 = {t = "Auto T-Rex Run", k = "atx", n = "T-Rex", fx = "tx", fb = "tb", ep = "TrexRun_EggPosition", cu = "TrexRun_CarrierUserId", lv = nil, ev = te2, gt = nil, aj = ta2, pre = tp2, on = function(g) return st.tq and st.th == g end}

local function bgb(g)
	if not (bb and bw and bq) then xs("Auto Butterfly", "abf", "Butterfly Failed: No Module") return end
	if not kv() then lg("Key Check Failed: No Valid Key") return end
	if not bs then lg("Butterfly | Auto Swing Not Found") end
	local by, c0, nx, lw = false, 0, 0, nil
	local function ed()
		if not by then return end
		by = false
		if st.on and not st.fp then
			st.bo = false
			return
		end
		local _, hu = rt()
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		if hu then pcall(function() hu:UnequipTools() end) end
		un()
		st.bo = false
	end
	local function ck()
		if (st.on and not st.fp) or not st.bf or st.bi ~= g or not ba() then return "Stopped" end
		return nil
	end
	while ge.__SaeAf == st and st.bf and st.bi == g do
		local nc, tc = bn()
		if st.lx or st.tx then
			st.bx = false
			ed()
			task.wait(1)
			continue
		end
		st.bx = nc and ba() and true or false
		if not nc and not wu() then
			ed()
			local m = wd()
			if m ~= lw then
				lw = m
				lg(m)
			end
			task.wait(1)
			continue
		end
		if st.wf or st.wo then we() end
		if st.on and not st.fp then
			by, st.bo = false, false
			task.wait(1)
			continue
		end
		if not nc then
			ed()
			lg("Claiming Net")
			local ok, wy = bk()
			lg(ok and "Net Claimed" or tostring(wy))
			task.wait(ok and 1 or 30)
			continue
		end
		if not ba() then
			ed()
			lg("Butterfly Waiting For Event")
			task.wait(1)
			continue
		end
		local nd, na = bd2()
		if not na then nd = nil end
		local b = bz()
		if not b then
			lg("Butterfly Failed: No Area")
			task.wait(5)
			continue
		end
		if not by then
			st.bo = true
			if not sw() then
				st.bo = false
				lg("Butterfly Waiting To Swap")
				task.wait(0.5)
				continue
			end
			by, c0 = true, tc
		end
		local h, hu = rt()
		if not h or not hu or hu.Health <= 0 then
			task.wait(0.5)
			continue
		end
		local o = b.CFrame:PointToObjectSpace(h.Position)
		local fr = math.max(math.abs(o.X) - b.Size.X / 2, math.abs(o.Z) - b.Size.Z / 2)
		if fr > 20 then
			if lp:GetAttribute("InEnchantedTree") == true then
				local p2 = bn2()
				lg("Leaving Tree")
				if p2 then be(p2, ck) end
				task.wait(0.5)
				continue
			end
			local dn = dl()
			if dn == 0 or bw2() or (dn and dn < (b.Position - h.Position).Magnitude / math.max(hu.WalkSpeed, 16) + 5) then
				lg("Butterfly Waiting For Day")
				task.wait(0.5)
				continue
			end
			if fr < 150 then
				hu:MoveTo(Vector3.new(b.Position.X, h.Position.Y, b.Position.Z))
				task.wait(0.2)
				continue
			end
			if st.bt or tm() then
				lg("Leaving Treadmill")
				local o3, w3 = lt()
				if not o3 then lg(tostring(w3)) end
				task.wait(1)
				continue
			end
			lg("Flying To Butterflies")
			local z0, z1 = cz()
			if z0 and (h.Position.Z < z0 or h.Position.Z > z1) then
				local ok, wy = mv(Vector3.new(h.Position.X, h.Position.Y, math.clamp(h.Position.Z, z0, z1)), ck, 10)
				h, hu = rt()
				if not ok or not h or not hu then
					lg(tostring(wy or "Move Failed: Character Lost"))
					task.wait(0.5)
					continue
				end
			end
			local y = math.max(h.Position.Y, b.Position.Y) + 50
			local ok, wy = hp(Vector3.new(b.Position.X, y, b.Position.Z), y, false, ck)
			if ok then ok, wy = hp(b.Position + Vector3.new(0, 3, 0), y, false, ck) end
			fz(false)
			if not ok then
				lg(tostring(wy))
				task.wait(0.5)
			end
			continue
		end
		fz(false)
		local t = bv()
		if t and t.Parent ~= lp.Character then pcall(function() hu:EquipTool(t) end) end
		if bs then bs() end
		local p, pk, pd, s, sk, sd = nil, -1, math.huge, nil, -1, math.huge
		local x1, xk, xd, y1, yk, yd = nil, -1, math.huge, nil, -1, math.huge
		for _, e in bw.Each() do
			local eo = typeof(e.Position) == "Vector3" and b.CFrame:PointToObjectSpace(e.Position)
			if (e.Alpha or 0) >= 0.5 and eo and math.abs(eo.X) <= b.Size.X / 2 + 10 and math.abs(eo.Z) <= b.Size.Z / 2 + 10 and type(e.Flight) == "table" then
				local m, k = (e.Position - h.Position).Magnitude, tonumber(type(e.Tier) == "table" and e.Tier.Order) or 0
				if not nd or (type(e.Tier) == "table" and nd[e.Tier.Id] ~= nil) then
					if k > pk or (k == pk and m < pd) then p, pk, pd = e, k, m end
					if m <= 13 and (k > sk or (k == sk and m < sd)) then s, sk, sd = e, k, m end
				end
				if k > xk or (k == xk and m < xd) then x1, xk, xd = e, k, m end
				if m <= 13 and (k > yk or (k == yk and m < yd)) then y1, yk, yd = e, k, m end
			end
		end
		p, s = p or x1, s or y1
		if s and os.clock() >= nx then
			nx = os.clock() + 0.5
			local id = s.Flight.Id
			task.spawn(function()
				local ok, r = pcall(function() return rm.Butterflies.AskSwing:InvokeServer(id) end)
				if ok and (r == "Caught" or r == "Gone") then pcall(bw.Remove, id) end
			end)
		end
		if p then
			local q = p.Position
			pcall(function() q = bq.PositionAt(p.Flight, workspace:GetServerTimeNow() + 0.3) end)
			local v = Vector3.new(h.Position.X - q.X, 0, h.Position.Z - q.Z)
			q = v.Magnitude > 0.1 and q + v.Unit * 11 or q
			hu:MoveTo(Vector3.new(q.X, h.Position.Y, q.Z))
		else
			hu:MoveTo(Vector3.new(b.Position.X, h.Position.Y, b.Position.Z))
		end
		lg(string.format("%s | Caught %d", nd and "Catching For Essence" or "Catching Rarest", tc - c0))
		task.wait(0.1)
	end
	st.bx = false
	ed()
	we()
end

local function bg(g)
	local ok, e = xpcall(bgb, debug.traceback, g)
	if ok or ge.__SaeAf ~= st or st.bi ~= g then return end
	st.bx = false
	if st.on and not st.fp then
		st.bo = false
	elseif st.bo and not (st.lb or st.tb or st.hb) then
		local _, hu = rt()
		if hu then pcall(function() hu:UnequipTools() end) end
		pcall(un)
		st.bo = false
	end
	pcall(we)
	xs("Auto Butterfly", "abf", "Butterfly Crashed", e)
end

local function hdb(g)
	local lm
	local function l2(m)
		if m == lm then return end
		lm = m
		lg("Halloween | " .. m)
	end
	local function hz2(n)
		local m = workspace:FindFirstChild("HalloweenDimension")
		local z = m and m:FindFirstChild("Zones")
		local p = z and z:FindFirstChild(n)
		return p and p:IsA("BasePart") and p or nil
	end
	local function hin() return lp:GetAttribute("InHalloweenDimension") == true end
	local function gg()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local g2 = m and m:FindFirstChild("Ground")
		return g2 and {g2, workspace.Terrain} or {workspace.Terrain}
	end
	local function zq(q)
		for i = 1, 3 do
			local b = hz2("Zone" .. i)
			if b and math.abs(q.X - b.Position.X) <= b.Size.X / 2 and math.abs(q.Z - b.Position.Z) <= b.Size.Z / 2 then return i end
		end
		return nil
	end
	local function hca() return lp:GetAttribute("HalloweenCarrying") == true end
	local function on() return ge.__SaeAf == st and (st.hd or st.hm or st.hx) and st.hg == g end
	local function own(o)
		if o then
			st.bo, st.hb = true, true
			if sw() then return true end
			st.bo, st.hb = false, false
			return false
		end
		local _, hu = rt()
		fz(false)
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		un()
		st.bo, st.hb = false, false
		return true
	end
	local function el()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local w = m and m:FindFirstChild("WorldEggs")
		local o, t, h = {}, os.clock(), rt()
		for _, e in w and w:GetChildren() or {} do
			local u, pn = e:GetAttribute("HalloweenEggUid"), e:GetAttribute("PreparedSourceName")
			local p = e:FindFirstChild("StealPrompt", true)
			local ok, q = pcall(e.GetPivot, e)
			local z = ok and zq(q.Position)
			if type(u) == "string" and type(pn) == "string" and p and p:IsA("ProximityPrompt") and p.Enabled and (st.hbl[u] or 0) < t and z then
				local a = dr[pn]
				o[#o + 1] = {u = u, p = q.Position, pr = p, z = z, n = pn, e = tonumber(a and a.EarningRate) or 0, k = tonumber(a and a.Rarity and a.Rarity.Rank) or 0}
			end
		end
		table.sort(o, function(x, y)
			if x.k ~= y.k then return x.k > y.k end
			if x.e ~= y.e then return x.e > y.e end
			return h ~= nil and (x.p - h.Position).Magnitude < (y.p - h.Position).Magnitude
		end)
		return o
	end
	local function en()
		local w = workspace:FindFirstChild("World")
		local p = w and w:FindFirstChild("HalloweenDimensionPortal")
		local b = p and p:FindFirstChild("Hitbox", true)
		pg2(true)
		if not (b and b:IsA("BasePart")) then return false, "Enter Failed: No Portal" end
		if st.bt or tm() then
			lt()
			task.wait(1)
		end
		local t0 = os.clock()
		while not hin() and os.clock() - t0 < 40 do
			if not on() then return false, "Stopped" end
			local _, hu = rt()
			if hu then hu:MoveTo(b.Position) end
			task.wait(0.25)
		end
		if not hin() then return false, "Enter Failed: Timeout" end
		local t = os.clock()
		repeat task.wait(0.2) until not tostring(lp:GetAttribute("HalloweenTransition") or ""):find(":cover:") or os.clock() - t > 10
		return true
	end
	local function nk()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local f = m and m:FindFirstChild("Spawns")
		local s = hz2("SafeZone")
		local lo, hi, l = math.huge, -math.huge, {}
		for _, p in f and f:GetDescendants() or {} do
			if p:IsA("BasePart") and p.Name == "Spawn" then
				lo, hi = math.min(lo, p.Position.X), math.max(hi, p.Position.X)
				l[#l + 1] = p.Position
			end
		end
		if not s or #l == 0 then return nil end
		return lo - 100, hi + 100, s.Position.Z + s.Size.Z / 2 + 40, l
	end
	local function gt(e)
		local h, hu = rt()
		if not h or not hu then return false, "Fly Failed: No Character" end
		local u = Vector3.new(e.p.X - h.Position.X, 0, e.p.Z - h.Position.Z)
		local b = u.Magnitude > 7 and e.p - u.Unit * 7 or e.p
		local function ck()
			if not on() then return "Stopped" end
			if not e.pr.Parent or not e.pr.Enabled then return "Fly Failed: Egg Gone" end
			return nil
		end
		local lo, hi, zn = nk()
		if lo and h.Position.Z < zn then
			local x = math.clamp(h.Position.X, lo, hi)
			local ok, wy = hp(Vector3.new(x, gy2(Vector3.new(x, h.Position.Y, zn), Vector3.zero, 60, gg()) - st.gh + 3, zn), nil, false, ck, gg())
			if not ok then return false, wy end
		end
		local ok, wy = hp(Vector3.new(b.X, gy2(Vector3.new(b.X, e.p.Y, b.Z), Vector3.zero, 60, gg()) - st.gh + 3, b.Z), nil, false, ck, gg())
		if not ok then return false, wy end
		task.wait(0.15)
		pcall(fireproximityprompt, e.pr)
		local t = os.clock()
		repeat task.wait() until hca() or os.clock() - t > 1.5
		if not hca() then return false, "Steal Failed: Not Carrying" end
		return true
	end
	local function rl2()
		local h = rt()
		if not h then return false, "Relay Failed: No Character" end
		local ok, a, b = pcall(rm.HalloweenDimension.AskDropEgg.InvokeServer, rm.HalloweenDimension.AskDropEgg)
		if not ok or not a then return false, "Relay Failed: Drop " .. tostring(ok and (b or "Denied") or a) end
		local t = os.clock()
		repeat task.wait() until not hca() or os.clock() - t > 1
		if hca() then return false, "Relay Failed: Still Carrying" end
		local m = workspace:FindFirstChild("HalloweenDimension")
		local w = m and m:FindFirstChild("WorldEggs")
		local pr, bd = nil, 25
		t = os.clock()
		while not pr and os.clock() - t < 1 do
			for _, x in w and w:GetChildren() or {} do
				local p = x:FindFirstChild("StealPrompt", true)
				local o2, q = pcall(x.GetPivot, x)
				if p and p:IsA("ProximityPrompt") and p.Enabled and o2 and (q.Position - h.Position).Magnitude < bd then pr, bd = p, (q.Position - h.Position).Magnitude end
			end
			if not pr then task.wait() end
		end
		if not pr then return false, "Relay Failed: No Dropped Egg" end
		t = os.clock()
		local nf = 0
		repeat
			if os.clock() >= nf then
				nf = os.clock() + 0.25
				pcall(fireproximityprompt, pr)
			end
			task.wait()
		until hca() or os.clock() - t > 2
		if not hca() then return false, "Relay Failed: Retake" end
		return true
	end
	local function sh3(en)
		local h0 = rt()
		local lq = h0 and h0.Position
		while true do
			if not on() then return false, "Stopped" end
			if not hca() then return false, "Carry Ended" end
			local hr, hu = rt()
			if not hr or not hu then return false, "Home Failed: Character Lost" end
			fz(true)
			local d, k = Vector3.new(en.X - hr.Position.X, 0, en.Z - hr.Position.Z), st.hk
			if d.Magnitude <= k then
				hr.CFrame = d.Magnitude > 0.1 and CFrame.lookAt(en, en + d.Unit) or CFrame.new(en) * hr.CFrame.Rotation
				hr.AssemblyLinearVelocity = Vector3.zero
				return true
			end
			local np = hr.Position + d.Unit * k
			np = Vector3.new(np.X, gy2(np, Vector3.zero, 60, gg()), np.Z)
			hr.CFrame = CFrame.lookAt(np, np + d.Unit)
			hr.AssemblyLinearVelocity = Vector3.zero
			if lq and (np - lq).Magnitude >= st.hr then
				task.wait(st.hw)
				local ok, wy = rl2()
				if not ok then return false, wy end
				lq = np
			end
			task.wait(0.1)
		end
	end
	local function hm2()
		local h = rt()
		local lo, hi, zn = nk()
		if not (h and lo) then return false, "Home Failed: No Safe Zone" end
		local d0 = lp:GetAttribute("HalloweenDelivered")
		local ok, wy = true, nil
		if h.Position.Z > zn then
			local x = math.clamp(h.Position.X, lo, hi)
			ok, wy = sh3(Vector3.new(x, gy2(Vector3.new(x, h.Position.Y, zn), Vector3.zero, 60, gg()) - st.gh + 3, zn))
		end
		h = rt()
		if ok and h then
			local x, zi = math.clamp(h.Position.X, lo, hi), zn - 55
			ok, wy = sh3(Vector3.new(x, gy2(Vector3.new(x, h.Position.Y, zi), Vector3.zero, 60, gg()) - st.gh + 3, zi))
		end
		local t = os.clock()
		repeat task.wait(0.1) until lp:GetAttribute("HalloweenDelivered") ~= d0 or os.clock() - t > 3
		if lp:GetAttribute("HalloweenDelivered") ~= d0 then return true end
		return false, ok and "Not Delivered" or "Egg Lost | " .. tostring(wy)
	end
	local function ml()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local o, h, t = {}, rt(), os.clock()
		for _, b in cl:GetTagged("BatDamagable") do
			local x = b.Parent
			while x and x ~= m and not cl:HasTag(x, "HalloweenMonster") do x = x.Parent end
			local v = b:IsA("BasePart") and b:GetAttribute("Health")
			if m and h and x and x ~= m and type(v) == "number" and v > 0 and zq(b.Position) and (st.hbl[x] or 0) < t then
				o[#o + 1] = {m = x, b = b, n = x.Name, k = ({Small = 1, Medium = 2, Large = 3})[x:GetAttribute("MonsterSize")] or 0, d = (b.Position - h.Position).Magnitude}
			end
		end
		table.sort(o, function(x, y)
			if x.k ~= y.k then return x.k > y.k end
			return x.d < y.d
		end)
		return o
	end
	local function kl(x)
		local h = rt()
		if not h then return false, "Kill Failed: No Character" end
		local p = x.b.Position
		local u = Vector3.new(p.X - h.Position.X, 0, p.Z - h.Position.Z)
		local q = u.Magnitude > 15 and p - u.Unit * 15 or p
		if not own(true) then return false, "Waiting To Swap" end
		local ok, wy = hp(Vector3.new(q.X, gy2(Vector3.new(q.X, p.Y, q.Z), Vector3.zero, 60, gg()) - st.gh + 3, q.Z), nil, false, function()
			if not on() then return "Stopped" end
			if not x.b.Parent or (tonumber(x.b:GetAttribute("Health")) or 0) <= 0 then return "Monster Gone" end
			return nil
		end, gg())
		if not ok then return wy == "Monster Gone", wy end
		local b = gb()
		if not b then return false, "Kill Failed: No Bat" end
		local t0, a0, nx, ns = os.clock(), math.random() * math.pi * 2, 0, 0
		while on() and os.clock() - t0 < 25 do
			if not x.b.Parent or (tonumber(x.b:GetAttribute("Health")) or 0) <= 0 then return true end
			if st.hd and #el() > 0 then return false, "Eggs Back" end
			local h2, hu = rt()
			if not h2 or not hu or hu.Health <= 0 or not (st.sc and st.sc.Parent == lp.Character) then return false, "Kill Failed: Character Lost" end
			if b.Parent ~= lp.Character then pcall(hu.EquipTool, hu, b) end
			if os.clock() >= ns then
				ns, st.bsq = os.clock() + st.bsi, st.bsq + 1
				pcall(function() rm.BatSwing.Trigger:FireServer(nil, string.format("%d:%d:%d", lp.UserId, st.bsq, math.floor(workspace:GetServerTimeNow() * 1000))) end)
			end
			if os.clock() >= nx then
				nx, a0 = os.clock() + 0.3, a0 + math.pi / 3
				local c0 = x.b.Position
				local q2 = c0 + Vector3.new(math.cos(a0) * 12, 0, math.sin(a0) * 12)
				q2 = Vector3.new(q2.X, gy2(q2, Vector3.zero, 60, gg()) - st.gh + 3, q2.Z)
				fz(true)
				h2.CFrame = CFrame.lookAt(q2, Vector3.new(c0.X, q2.Y, c0.Z))
				h2.AssemblyLinearVelocity = Vector3.zero
			end
			task.wait(0.05)
		end
		return false, "Kill Timeout"
	end
	local function px()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local pp = m and m:FindFirstChild("PortalHome", true)
		pp = pp and pp:FindFirstChild("Portal", true)
		if not (pp and pp:IsA("BasePart")) then return false, "Exit Failed: No Portal" end
		local h = rt()
		local q = Vector3.new(pp.Position.X, 0, pp.Position.Z + 30)
		if h and (Vector3.new(h.Position.X, 0, h.Position.Z) - q).Magnitude > 60 then
			if not own(true) then return false, "Waiting To Swap" end
			local ok, wy = hp(Vector3.new(q.X, gy2(Vector3.new(q.X, pp.Position.Y, q.Z), Vector3.zero, 60, gg()) - st.gh + 3, q.Z), nil, false, function() return not on() and "Stopped" or nil end, gg())
			if not ok then return false, wy end
		end
		if st.hb then own(false) end
		local t0 = os.clock()
		while hin() and os.clock() - t0 < 30 do
			if not on() then return false, "Stopped" end
			local _, hu = rt()
			if hu then hu:MoveTo(pp.Position) end
			task.wait(0.25)
		end
		if hin() then return false, "Exit Failed: Timeout" end
		local t = os.clock()
		repeat task.wait(0.2) until not tostring(lp:GetAttribute("HalloweenTransition") or ""):find(":cover:") or os.clock() - t > 10
		task.wait(0.5)
		if not own(true) then
			st.bo, st.hb = false, false
			return false, "Place Failed: Swap"
		end
		local n, wy = pe()
		own(false)
		return true, string.format("Placed %d%s", n, wy and (" | " .. wy) or "")
	end
	local o4, hdg = pcall(function() return require(rs.Data.HalloweenDimensionEgg) end)
	local hpr = o4 and type(hdg) == "table" and tonumber(hdg.Price) or 2250
	local function tkn()
		local o, s2 = pcall(sv.Await)
		if not o or type(s2) ~= "table" then return 0 end
		local c = type(s2.Currency) == "table" and s2.Currency.HalloweenTokens
		return tonumber(c or s2.HalloweenTokens) or 0
	end
	local function by()
		local m = workspace:FindFirstChild("HalloweenDimension")
		local sh = m and m:FindFirstChild("EggShop")
		local o0, sp = pcall(function() return sh:GetPivot().Position end)
		if not o0 then return false, "Buy Failed: No Shop" end
		local h = rt()
		if h and (Vector3.new(h.Position.X, sp.Y, h.Position.Z) - sp).Magnitude > 9 then
			if not own(true) then return false, "Waiting To Swap" end
			local q = sp + Vector3.new(0, 0, 6)
			local ok, wy = hp(Vector3.new(q.X, gy2(q, Vector3.zero, 60, gg()) - st.gh + 3, q.Z), nil, false, function() return not on() and "Stopped" or nil end, gg())
			if not ok then return false, wy end
		end
		local n, wy = 0, nil
		while on() and tkn() >= hpr do
			local o, a, b = pcall(rm.HalloweenDimension.AskBuyEgg.InvokeServer, rm.HalloweenDimension.AskBuyEgg)
			if not o or not a then
				wy = "Buy Failed: " .. tostring(o and (b or "Denied") or a)
				break
			end
			n += 1
			task.wait(0.3)
		end
		return n > 0, string.format("Bought %d%s", n, wy and " | " .. wy or "")
	end
	local nd, nk2 = 0, 0
	local su = false
	local function sx(v)
		if su == v then return end
		su = v
		pcall(function() rm.TrainEvent.Suction:FireServer(v) end)
	end
	local function tsg()
		if type(st.ts) ~= "table" then
			local ok, l = pcall(filtergc, "table", {Keys = {"ArrivalOpen", "DepartureAt", "StationAvailable"}}, false)
			local b
			for _, t in ok and type(l) == "table" and l or {} do
				if not b or (tonumber(rawget(t, "ReturnAt")) or 0) > (tonumber(rawget(b, "ReturnAt")) or 0) then b = t end
			end
			st.ts = b
		end
		return st.ts
	end
	local function aro()
		local t = tsg()
		return t ~= nil and rawget(t, "ArrivalOpen") == true and workspace:GetServerTimeNow() < (tonumber(rawget(t, "DepartureAt")) or 0) and rawget(t, "Phase") == "Home"
	end
	local pk = {}
	local function pfn(a, en2)
		local d = pk[a]
		if not (d and d.Parent) then
			d = nil
			for _, x in workspace:GetDescendants() do
				if x:IsA("ProximityPrompt") and not x:GetAttribute("TrainLocalBoarding") and (x:GetAttribute("TrainEventAction") == a or x.ActionText == a) then
					d = x
					if not en2 or x.Enabled then break end
				end
			end
			pk[a] = d
		end
		if d and (not en2 or d.Enabled) then return d end
		return nil
	end
	local function ppos(d)
		local pp = d.Parent
		return pp:IsA("Attachment") and pp.WorldPosition or pp:IsA("BasePart") and pp.Position or pp:GetPivot().Position
	end
	local function brd()
		local tb = pk.TrainBoard
		if not (tb and tb.Parent) then
			tb = nil
			for _, d in workspace:GetDescendants() do
				if d:IsA("ProximityPrompt") and d.Name == "TrainBoard" and not d:GetAttribute("TrainLocalBoarding") then tb = d break end
			end
			pk.TrainBoard = tb
		end
		if not tb then return false, "Board Failed: No Station" end
		local a, b = tb:GetAttribute("BoardRailStart"), tb:GetAttribute("BoardRailEnd")
		local q = typeof(a) == "Vector3" and typeof(b) == "Vector3" and (a + b) / 2 or ppos(tb)
		local h = rt()
		if h and (Vector3.new(q.X - h.Position.X, 0, q.Z - h.Position.Z)).Magnitude > 20 then
			if not own(true) then return false, "Waiting To Swap" end
			local ok, wy = hp(Vector3.new(q.X, gy2(q, Vector3.zero, 60, gg()) - st.gh + 3, q.Z), nil, false, function() return not on() and "Stopped" or nil end, gg())
			if not ok then return false, wy end
		end
		if st.hb then own(false) end
		local ok, r1, r2 = pcall(rm.TrainEvent.Action.InvokeServer, rm.TrainEvent.Action, "Board")
		if not ok or not r1 then return false, "Board Failed: " .. tostring(ok and (r2 or "Denied") or r1) end
		return true
	end
	local function hj(q, lk)
		if not own(true) then return false end
		local h = rt()
		if not h then return false end
		local y = gy2(q, Vector3.zero, 30) - st.gh + 3
		local p = Vector3.new(q.X, y, q.Z)
		fz(true)
		h.CFrame = CFrame.lookAt(p, Vector3.new(lk.X, y, lk.Z))
		h.AssemblyLinearVelocity = Vector3.zero
		return true
	end
	local bsu, bnx, gan, gnx, csx = false, 0, math.random() * math.pi * 2, 0, 0
	local function bsx(v, lk)
		if not v then
			if bsu then
				bsu = false
				pcall(function() rm.GhostBoss.Suction:FireServer(false) end)
			end
			return
		end
		if os.clock() < bnx and bsu then return end
		bsu, bnx = true, os.clock() + 0.25
		pcall(function() rm.GhostBoss.Suction:FireServer(true, lk) end)
	end
	local function gbp()
		local g2 = rs:FindFirstChild("GhostBossState")
		if not g2 or g2:GetAttribute("Realm") ~= "Town" or g2:GetAttribute("Phase") ~= "Alive" then return nil end
		local gp, vl, mt2 = g2:GetAttribute("Ground"), g2:GetAttribute("Velocity"), tonumber(g2:GetAttribute("MovedAt"))
		if typeof(gp) ~= "Vector3" then return nil end
		if typeof(vl) == "Vector3" and mt2 then gp += vl * math.clamp(workspace:GetServerTimeNow() - mt2, 0, 2) end
		return gp, g2:GetAttribute("AttackTarget") == lp.UserId and (g2:GetAttribute("AttackPhase") == "Windup" or g2:GetAttribute("AttackPhase") == "Charge")
	end
	local function rdn(f)
		local cs2, nw = st.cs, workspace:GetServerTimeNow()
		if f and (type(cs2) ~= "table" or (tonumber(rawget(cs2, "StartsAt")) or 0) < nw - 900) and os.clock() >= csx then
			csx = os.clock() + 2
			local o6, l6 = pcall(filtergc, "table", {Keys = {"VacuumOwned", "Holding", "Captured"}}, false)
			cs2 = o6 and type(l6) == "table" and l6[1] or cs2
			st.cs = cs2
		end
		return type(cs2) == "table" and (tonumber(rawget(cs2, "StartsAt")) or 0) >= nw - 900 and (rawget(cs2, "Phase") == "Completed" or (tonumber(rawget(cs2, "EndsAt")) or math.huge) < nw)
	end
	local function twn()
		local c = lp.Character
		local h, hu = rt()
		if not h or not hu or hu.Health <= 0 then
			sx(false)
			return "No Character"
		end
		local o2, s2 = pcall(sv.Await)
		local te = o2 and type(s2) == "table" and s2.TrainEvent
		local o3, tf = pcall(function() return require(rs.Shared.Flags.TrainEventFlags) end)
		local o5, cst = pcall(function() return tf.SpectralSoulCost:Get() end)
		cst = o3 and o5 and tonumber(cst) or 1000
		if type(te) == "table" and (tonumber(te.Souls) or 0) >= cst and os.clock() >= st.hbt then
			local sp4 = pfn("OpenSoulShop", true)
			if sp4 then
				sx(false)
				local q = ppos(sp4)
				if (q - h.Position).Magnitude > 12 then
					local u2 = Vector3.new(h.Position.X - q.X, 0, h.Position.Z - q.Z)
					hj(q + (u2.Magnitude > 0.1 and u2.Unit or Vector3.new(1, 0, 0)) * 6, q)
					return "Going To Soul Keeper"
				end
				st.hbt = os.clock() + 3
				local ok, r1, r2 = pcall(rm.TrainEvent.Action.InvokeServer, rm.TrainEvent.Action, "TradeSouls", cst)
				return ok and r1 and "Traded Souls" or "Trade Failed: " .. tostring(ok and (r2 or "Denied") or r1)
			end
		end
		local vc
		for _, t in c and c:GetChildren() or {} do if t:IsA("Tool") and t.Name:find("Vacuum") then vc = t end end
		if not vc then
			local bp = lp:FindFirstChildOfClass("Backpack")
			for _, t in bp and bp:GetChildren() or {} do
				if t:IsA("Tool") and t.Name:find("Vacuum") then
					pcall(hu.EquipTool, hu, t)
					return "Equipping Vacuum"
				end
			end
			local pr = pfn("PickupVacuum", true)
			if pr then
				sx(false)
				local q = ppos(pr)
				if (q - h.Position).Magnitude > 8 then
					local u2 = Vector3.new(h.Position.X - q.X, 0, h.Position.Z - q.Z)
					hj(q + (u2.Magnitude > 0.1 and u2.Unit or Vector3.new(1, 0, 0)) * 4, q)
				else
					pcall(fireproximityprompt, pr)
				end
				return "Getting Vacuum"
			end
		end
		if rdn(true) and not gbp() then
			sx(false)
			local rp2 = pk.Ret
			if not (rp2 and rp2.Parent) then
				rp2 = nil
				for _, d in workspace:GetDescendants() do
					if d:IsA("ProximityPrompt") and d.Name == "TrainReturn" and d:GetAttribute("TrainEventRequiredPhase") == "Town" then
						rp2 = d
						if d:GetAttribute("TrainLocalReturn") then break end
					end
				end
				pk.Ret = rp2
			end
			if not rp2 then return "Return Failed: No Platform" end
			local q = ppos(rp2)
			if (Vector3.new(q.X - h.Position.X, 0, q.Z - h.Position.Z)).Magnitude > 10 then
				hj(q, q + Vector3.new(0, 0, 1))
				return "Going To Platform"
			end
			if os.clock() < st.rtn then return "Returning" end
			st.rtn = os.clock() + 2
			if st.hb then own(false) end
			local ok, r1, r2 = pcall(rm.TrainEvent.Action.InvokeServer, rm.TrainEvent.Action, "Return")
			return ok and r1 and "Returning" or "Return Failed: " .. tostring(ok and (r2 or "Denied") or r1)
		end
		local gp, ak = gbp()
		if gp and vc then
			sx(false)
			local fl = Vector3.new(h.Position.X - gp.X, 0, h.Position.Z - gp.Z)
			local dd = fl.Magnitude
			if math.abs(dd - st.gbd) > 3 then
				hj(gp + (dd > 0.1 and fl.Unit or Vector3.new(1, 0, 0)) * st.gbd, gp)
			elseif dd > 0.1 then
				h.CFrame = CFrame.lookAt(h.Position, Vector3.new(gp.X, h.Position.Y, gp.Z))
			end
			local h2 = rt()
			local bc2 = gp + Vector3.new(0, 5, 0)
			bsx(h2 ~= nil, h2 and (bc2 - h2.Position).Unit)
			return ak and "Boss | Dodging" or "Boss | Sucking"
		end
		bsx(false)
		local f = workspace:FindFirstChild("TrainGhostVisuals")
		local bq2, bdd
		for _, x in f and f:GetChildren() or {} do
			local ok, q = pcall(function() return x:IsA("Model") and x:GetPivot().Position or x.Position end)
			if ok and (not bdd or (q - h.Position).Magnitude < bdd) then bq2, bdd = q, (q - h.Position).Magnitude end
		end
		if not bq2 then
			sx(false)
			return "No Ghosts"
		end
		local fl = Vector3.new(bq2.X - h.Position.X, 0, bq2.Z - h.Position.Z)
		if fl.Magnitude > 18 or os.clock() >= gnx then
			gnx, gan = os.clock() + 0.3, gan + math.pi / 3
			hj(bq2 + Vector3.new(math.cos(gan) * 12, 0, math.sin(gan) * 12), bq2)
		elseif fl.Magnitude > 0.5 then
			h.CFrame = CFrame.lookAt(h.Position, h.Position + fl)
		end
		local h2 = rt()
		sx(h2 ~= nil and (bq2 - h2.Position).Magnitude < 22)
		return "Hunting Ghosts"
	end
	st.hl = true
	while on() do
		if st.on or (st.bo and not st.hb) then
			if st.hb then own(false) end
			l2("Waiting For Control")
			task.wait(0.5)
			continue
		end
		local ph = lp:GetAttribute("TrainEventPhase")
		if st.hx and ph ~= nil and ph ~= "Home" then
			if ph ~= "Town" and st.hb then own(false) end
			if ph ~= "Town" then bsx(false) end
			l2("Train | " .. (ph == "Town" and twn() or tostring(ph)))
			task.wait(0.1)
			continue
		end
		sx(false)
		local ar = st.hx and aro() and not hca() and not rdn(false)
		if not hin() and not (st.hd or st.hm or ar) then
			if st.hb then own(false) end
			l2("Waiting For Train")
			task.wait(1)
			continue
		end
		if ar and hin() and not tostring(lp:GetAttribute("HalloweenTransition") or ""):find(":cover:") then
			l2("Train | Boarding")
			local ok, wy = brd()
			l2(ok and "Train | Boarded" or "Train | " .. tostring(wy))
			task.wait(ok and 2 or 1)
			continue
		end
		if not hin() then
			if st.hb then own(false) end
			l2("Entering Dimension")
			local ok, wy = en()
			if not ok then
				l2(tostring(wy))
				task.wait(2)
			end
			continue
		end
		if tostring(lp:GetAttribute("HalloweenTransition") or ""):find(":cover:") then
			task.wait(0.3)
			continue
		end
		if hca() then
			if not own(true) then
				st.bo, st.hb = false, false
				l2("Waiting To Swap")
				task.wait(0.3)
				continue
			end
			l2("Going Home")
			local ok, wy = hm2()
			if ok then nd += 1 end
			l2(ok and string.format("Delivered #%d", nd) or tostring(wy))
			continue
		end
		if os.clock() >= st.hbt and tkn() >= hpr then
			st.hbt = os.clock() + 15
			l2("Buying Halloween Egg")
			local _, wy = by()
			l2(tostring(wy))
			continue
		end
		local d = dl()
		local l = st.hd and el() or {}
		local h, hu = rt()
		if not h or not hu then
			task.wait(0.5)
			continue
		end
		if #l == 0 and st.hm and d and d > 0 then
			local mo = ml()
			if #mo == 0 then
				if st.hb then own(false) end
				l2("No Monsters")
				task.wait(1)
				continue
			end
			local x = mo[1]
			l2(string.format("Fighting %s", x.n))
			local ok, wy = kl(x)
			if ok then
				nk2 += 1
				l2(string.format("Killed #%d | %s", nk2, x.n))
			else
				if wy ~= "Eggs Back" then st.hbl[x.m] = os.clock() + 15 end
				l2(tostring(wy))
			end
			continue
		end
		if st.hd then
			local _, hu3 = rt()
			local c3 = lp.Character
			if hu3 and c3 and c3:FindFirstChildOfClass("Tool") then pcall(hu3.UnequipTools, hu3) end
		end
		if #l == 0 or not d or d < (l[1].p - h.Position).Magnitude / math.max(hu.WalkSpeed, 16) * 2 + 9 then
			local ub, pb = ow()
			if d == 0 and os.clock() >= st.hpx and #ub > 0 and not (st.pf and #pb >= st.pf) then
				st.hpx = os.clock() + 120
				l2("Night | Leaving To Place Eggs")
				local ok, wy = px()
				l2(ok and "Night | " .. tostring(wy) or tostring(wy))
				continue
			end
			if st.hb then own(false) end
			l2(#l == 0 and "No Eggs" or "Waiting For Day")
			task.wait(1)
			continue
		end
		local e = l[1]
		if not own(true) then
			st.bo, st.hb = false, false
			l2("Waiting To Swap")
			task.wait(0.3)
			continue
		end
		l2(string.format("Flying To %s (Zone %s)", e.n, tostring(e.z)))
		local ok, wy = gt(e)
		if not ok then
			st.hbl[e.u] = os.clock() + 30
			l2(tostring(wy))
			task.wait(0.2)
			continue
		end
		l2(string.format("Stole %s | Going Home", e.n))
		ok, wy = hm2()
		if ok then nd += 1 end
		l2(ok and string.format("Delivered #%d | %s | Zone %s", nd, e.n, tostring(e.z)) or tostring(wy))
	end
	sx(false)
	bsx(false)
	if st.hb then own(false) end
	lg("Idle")
end

local function hd(g)
	local ok, e = xpcall(hdb, debug.traceback, g)
	if st.hg == g then st.hl = false end
	if ok then
		if ge.__SaeAf == st and (st.hd or st.hm or st.hx) and st.hg == g then
			st.hg += 1
			task.spawn(hd, st.hg)
		end
		return
	end
	if ge.__SaeAf ~= st or st.hg ~= g then return end
	pcall(function() rm.TrainEvent.Suction:FireServer(false) end)
	pcall(function() rm.GhostBoss.Suction:FireServer(false) end)
	if st.hb then
		pcall(fz, false)
		local _, hu = rt()
		local t = os.clock()
		while hu and hu.Parent and hu.FloorMaterial == Enum.Material.Air and os.clock() - t < 3 do task.wait(0.1) end
		pcall(un)
		st.bo, st.hb = false, false
	end
	xs("Auto Halloween", "ahd", "Halloween Crashed", e)
end

pcall(function() st.cn[#st.cn + 1] = rm.TrainEvent.State.OnClientEvent:Connect(function(a) if type(a) == "table" then st.ts = a end end) end)
pcall(function() st.cn[#st.cn + 1] = rm.TrainEvent.CaptureState.OnClientEvent:Connect(function(a) if type(a) == "table" then st.cs = a end end) end)

local function ht()
	local ok, o = pcall(es.ReadOwnerEggs, lp.UserId)
	if not ok or type(o) ~= "table" then return 0 end
	local n, t = 0, os.clock()
	for k, v in pairs(o) do
		if ge.__SaeAf ~= st or not st.ah or n >= 5 then break end
		if type(k) == "string" and type(v) == "table" and v.Placement and (st.hf[k] or 0) < t then
			local o2, r = pcall(es.IsReadyToHatch, k)
			if o2 and r == true then
				local o3, a = pcall(es.BeginHatch, k)
				local o4, b = false, false
				if o3 and a then o4, b = pcall(es.FinishHatch, k) end
				if o4 and b then
					n += 1
				else
					st.hf[k] = t + 60
				end
				task.wait(0.3)
			end
		end
	end
	return n
end

task.spawn(function()
	while ge.__SaeAf == st do
		task.wait(10)
		if ge.__SaeAf ~= st then break end
		if not kv() then continue end
		if st.ah then
			local n = ht()
			if n > 0 then zx(`[Hatch] Hatched {n}`) end
		end
		if st.ps or st.es then
			local p, e = sc()
			if #p + #e > 0 then
				sl(p, e)
				zx(`[Sell] Sold {#p} Pets, {#e} Eggs`)
			end
		end
	end
end)

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
	if ge.__SaeP then return nil, "Already On" end
	ge.__SaeP = true
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
		elseif d:IsA("Decal") then
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
	local ok, aa = pcall(function() return require(rs.Controllers.Game.Plots.ActiveAssetsController) end)
	if ok and type(aa) == "table" and type(aa.SetAllPetsHidden) == "function" then
		task.spawn(function()
			while ge.__SaeP do
				pcall(aa.SetAllPetsHidden, true)
				task.wait(5)
			end
		end)
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
	if not ok then return nil, "Hide Pets Failed: No Controller" end
	return true
end

local function hx(lo2)
	local hs, ts = game:GetService("HttpService"), game:GetService("TeleportService")
	local function go2(f)
		local fe
		local cn = ts.TeleportInitFailed:Connect(function(p, _, m) if p == lp then fe = tostring(m) end end)
		local o3, e3 = pcall(f)
		if not o3 then fe = tostring(e3) end
		local t = os.clock()
		while not fe and os.clock() - t < 10 do task.wait(0.25) end
		cn:Disconnect()
		return fe == nil
	end
	while ge.__SaeAf == st do
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
			if ge.__SaeAf ~= st then return false, "Hop Failed: Stopped" end
			if go2(function() ts:TeleportToPlaceInstance(game.PlaceId, v.id, lp) end) then return true end
			task.wait(1)
		end
		if not lo2 and ge.__SaeAf == st and go2(function() ts:Teleport(game.PlaceId, lp) end) then return true end
		task.wait(3)
	end
	return false, "Hop Failed: Stopped"
end

if ge.__SaeD then pcall(function() ge.__SaeD:Destroy() end) end
ge.__SaeD = nil
if ge.__AvW then pcall(ge.__AvW.Destroy, ge.__AvW) end
L:Gate({Title = "Ngao - Gaming Hub", Server = "https://getkey.kaeldrinnovasse.workers.dev", Hub = "sae", Discord = "https://discord.gg/fTQF5TvfEJ", Config = "StealAnEgg"})
local W = L:Window({Title = "Ngao - Gaming Hub | Steal An Egg", Config = `StealAnEgg/{lp.Name}`})
do
	local wn = W.Notify
	W.Notify = function(s2, o)
		pcall(zx, `[{tostring(type(o) == "table" and o.Title)}] {tostring(type(o) == "table" and o.Text)}`)
		return wn(s2, o)
	end
	local ex = identifyexecutor and select(2, pcall(identifyexecutor)) or "?"
	local ui = game:GetService("UserInputService")
	zx(`[Hub] Loaded | Place {game.PlaceVersion} | Server {game.JobId:sub(1, 8)} | {#ps:GetPlayers()} Players | {tostring(ex)} | {ui.TouchEnabled and not ui.KeyboardEnabled and "Mobile" or "PC"}`, true)
end
st.nt = function(n, m) W:Notify({Title = n, Text = m, Error = true}) end
local pg = W:Tab({Name = "General", Icon = "egg"})
local function rk()
	local m, o = {}, {}
	for _, a in pairs(dr) do
		local r = type(a) == "table" and a.Rarity
		if type(r) == "table" and type(r._id) == "string" and not m[r._id] then
			m[r._id] = true
			o[#o + 1] = r
		end
	end
	table.sort(o, function(x, y) return (tonumber(x.Rank) or 0) < (tonumber(y.Rank) or 0) end)
	local n = {}
	for _, r in o do n[#n + 1] = r._id end
	return n
end

local function rs2(v)
	local t = {}
	for _, x in v or {} do t[x] = true end
	return t
end

local function an()
	local w = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	local a = w and w:FindFirstChild("Areas")
	local g = a and a:FindFirstChild("GuardAreas")
	local o = {}
	for _, z in g and g:GetChildren() or {} do
		local b = z:FindFirstChild("Bounds")
		if b and b:IsA("BasePart") then o[#o + 1] = {z.Name, b.Position.X - b.Size.X / 2} end
	end
	table.sort(o, function(x, y) return x[2] < y[2] end)
	local n = {}
	for _, v in o do n[#n + 1] = v[1] end
	return n
end

local ra = rk()
pg:Section({Name = "Farm"})
local xe, xa
xa = pg:Dropdown({Name = "Select Area", Options = an(), Multi = true, Default = {}, Flag = "ar", Callback = function(v)
	st.az = rs2(v)
	if #v > 0 and xe then xe:Set({}) end
end})
xe = pg:Dropdown({Name = "Select Egg", Options = ra, Multi = true, Default = {}, Flag = "mr", Callback = function(v)
	st.mr = rs2(v)
	if #v > 0 and xa then xa:Set({}) end
end})
st.ui.ae = pg:Toggle({Name = "Auto Steal Egg", Default = false, Flag = "ae", Callback = function(v)
	local x = rawget(st.ui, "ahd")
	if v and x and x.v then x:Set(false) end
	if v then st.Start() else st.Stop() end
end})
local xp = pg:Toggle({Name = "Auto Place Egg", Default = true, Flag = "ape", Callback = function(v) st.ap = v == true end})
st.ap = xp.v == true
local xh = pg:Toggle({Name = "Auto Hatch Egg", Default = true, Flag = "ahe", Callback = function(v) st.ah = v == true end})
st.ah = xh.v == true
pg:Toggle({Name = "Pet Index", Default = false, Flag = "pix", Callback = function(v) st.pi = v == true end})
pg:Button({Name = "Leave Treadmill", Callback = function()
	local ok, wy = false, "Treadmill Failed: Not Mounted"
	if st.bt or tm() then ok, wy = lt() end
	lg(ok and "Treadmill Left" or tostring(wy))
	W:Notify({Title = "Leave Treadmill", Text = ok and "Treadmill Left" or tostring(wy), Error = not ok})
end})

pg:Section({Name = "Pet"})
pg:Dropdown({Name = "Sell Pet Rarity", Options = ra, Multi = true, Default = {}, Flag = "spr", Callback = function(v) st.sp = rs2(v) end})
pg:Toggle({Name = "Auto Sell Pet", Default = false, Flag = "asp", Callback = function(v) st.ps = v end})
pg:Section({Name = "Egg"})
pg:Dropdown({Name = "Sell Egg Rarity", Options = ra, Multi = true, Default = {}, Flag = "ser", Callback = function(v) st.se = rs2(v) end})
pg:Toggle({Name = "Auto Sell Egg", Default = false, Flag = "ase", Callback = function(v) st.es = v end})

local et = W:Tab({Name = "Event", Icon = "calendar-star"})
et:Section({Name = "Butterfly"})
local xb = et:Label({Text = bc()})
task.spawn(function()
	while ge.__SaeAf == st do
		pcall(function() xb:Set(bc()) end)
		task.wait(1)
	end
end)
st.ui.abf = et:Toggle({Name = "Auto Butterfly", Default = false, Flag = "abf", Callback = function(v)
	local x = rawget(st.ui, "ahd")
	if v and x and x.v then x:Set(false) end
	st.bf = v == true
	st.bi += 1
	if st.bf then task.spawn(bg, st.bi) end
end})
et:Button({Name = "Teleport To Station", Callback = function()
	local ok, wy = bu()
	lg(ok and "At Station" or tostring(wy))
	W:Notify({Title = "Teleport To Station", Text = ok and "At Station" or tostring(wy), Error = not ok})
end})
et:Section({Name = "Halloween"})
local function hq()
	if not (st.hd or st.hm or st.hx) then return end
	if not kv() then
		lg("Key Check Failed: No Valid Key")
		return
	end
	for _, k in {"ae", "abf", "arl", "atx"} do
		local x = rawget(st.ui, k)
		if x and x.v then x:Set(false) end
	end
	if st.hl then return end
	st.hg += 1
	task.spawn(hd, st.hg)
end
local function hz3(v)
	local x = rawget(st.ui, "ahd")
	if v and x and x.v then x:Set(false) end
end
st.ui.ahd = et:Toggle({Name = "Auto Halloween", Default = false, Flag = "ahd", Callback = function(v)
	st.hd, st.hm, st.hx = v == true, v == true, v == true
	hq()
end})
et:Section({Name = "Admin"})
st.ui.arl = et:Toggle({Name = "Auto Red Light Green Light", Default = false, Flag = "arl", Callback = function(v)
	hz3(v)
	st.gx = v == true
	st.gg += 1
	if st.gx then task.spawn(gq, st.gg, lc) end
end})
st.ui.atx = et:Toggle({Name = "Auto T-Rex Run", Default = false, Flag = "atx", Callback = function(v)
	hz3(v)
	st.tq = v == true
	st.th += 1
	if st.tq then task.spawn(gq, st.th, tc2) end
end})

local mi = W:Tab({Name = "Misc", Icon = "four-squares-grid"})
mi:Section({Name = "Player"})
mi:Toggle({Name = "Anti Stun", Default = false, Flag = "ast", Callback = function(v) su(v == true) end})
local xt = mi:Toggle({Name = "Anti Trap", Default = true, Flag = "atr", Callback = function(v) aq(v == true) end})
if xt.v then aq(true) end

local tp2 = W:Tab({Name = "Teleport", Icon = "person-teleport"})
tp2:Section({Name = "Server"})
for _, z in {{"Hop Server", false}, {"Hop Low Server", true}} do
	tp2:Button({Name = z[1], Callback = function()
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

local tz = W:Tab({Name = "Setting", Icon = "gear"})
tz:Section({Name = "Game"})
tz:Button({Name = "FPS Booster", Callback = function()
	local ok, e = bo()
	W:Notify({Title = "FPS Booster", Text = ok and "On Until Rejoin" or e, Error = not ok and e ~= "Already On"})
end})
tz:Section({Name = "Support"})
do
	local whu, lt = "https://discord.com/api/webhooks/1561079964906954872/EB3xMWW_fT8xp-dtoRnfNAOM7MaF0jpWkTk1S7KzAvxuDX1p92hmvXQw6A1-X5y_S06W", 0
	local rb = tz:TextBox({Name = "Describe The Problem", Placeholder = "What Went Wrong?"})
	tz:Button({Name = "Send Log To Developer", Callback = function()
		if os.clock() < lt then
			W:Notify({Title = "Support", Text = `Send Log Failed: Wait {math.ceil(lt - os.clock())} s`})
			return
		end
		local rs3 = (tostring(rb.v or ""):gsub("^%s+", ""):gsub("%s+$", "")):sub(1, 500)
		if rs3 == "" then
			W:Notify({Title = "Support", Text = "Send Log Failed: Describe The Problem First"})
			return
		end
		if whu == "" then
			W:Notify({Title = "Support", Text = "Send Log Failed: No Webhook", Error = true})
			return
		end
		lt = os.clock() + 300
		task.spawn(function()
			task.wait()
			local fp = `Avenoric/Configs/StealAnEgg/{lp.Name}_Log.txt`
			local ok, e = pcall(function()
				zx(`[Support] Send Log | {lp.Name} | Place {game.PlaceVersion} | Server {game.JobId:sub(1, 8)} | Problem: {rs3}`, true)
				pcall(function() zx(xt(), true) end)
				local rq = ge.request or ge.http_request or (type(ge.http) == "table" and ge.http.request)
				if type(rq) ~= "function" then error("No Request Function", 0) end
				if not isfile(fp) then error("No Log File", 0) end
				local s2 = readfile(fp)
				local cu = #s2 > 8e6
				if cu then s2 = s2:sub(-8e6) end
				local hs3 = game:GetService("HttpService")
				local ex = identifyexecutor and select(2, pcall(identifyexecutor)) or "?"
				local b = `SaeLog{(hs3:GenerateGUID(false):gsub("-", ""))}`
				local pj = hs3:JSONEncode({content = `**{lp.Name}** ({lp.UserId}) | Steal An Egg | Place {game.PlaceVersion} | Server {game.JobId} | {tostring(ex)}{cu and " | Last 8 MB" or ""}\nProblem: {rs3}`, allowed_mentions = {parse = {}}})
				local r = rq({Url = whu .. (whu:find("?", 1, true) and "&" or "?") .. "wait=true", Method = "POST", Headers = {["Content-Type"] = `multipart/form-data; boundary={b}`}, Body = `--{b}\r\nContent-Disposition: form-data; name="payload_json"\r\nContent-Type: application/json\r\n\r\n{pj}\r\n--{b}\r\nContent-Disposition: form-data; name="files[0]"; filename="{lp.Name}_Log.txt"\r\nContent-Type: text/plain\r\n\r\n{s2}\r\n--{b}--\r\n`})
				local sc = type(r) == "table" and r.StatusCode
				if sc ~= 200 and sc ~= 204 then error(`Http {sc or "No Response"}`, 0) end
			end)
			zx(ok and "[Support] Log Sent" or `[Support] Send Log Failed: {e}`, true)
			if ok then rb:Set("") else lt = os.clock() + 10 end
			W:Notify({Title = "Support", Text = ok and "Log Sent To Developer" or `Send Log Failed: {e} ({fp})`, Error = not ok})
		end)
	end})
end
st.gr = true

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
local hd = lp:FindFirstChildOfClass("PlayerGui") and lp:FindFirstChildOfClass("PlayerGui"):FindFirstChild("HUD")
for _, n in {"GameHUD", "TradmilHud"} do
	local rb = hd and hd:FindFirstChild(n) and hd[n]:FindFirstChild("RightButtons")
	local eb = rb and rb:FindFirstChild("EggsButton")
	if eb then
		local o = rb:FindFirstChild("NgaoButton")
		if o then o:Destroy() end
		local b = eb:Clone()
		for _, k in {"Notification", "ReadyNotification", "NightImage", "NightText", "GamepadGlyph"} do
			local x = b:FindFirstChild(k)
			if x then x:Destroy() end
		end
		b.Name, b.LayoutOrder = "NgaoButton", 5
		b:SetAttribute("PressBound", nil)
		local gd2, s1, s2 = b:FindFirstChild("UIGradient"), b:FindFirstChild("UIStroke"), b:FindFirstChild("UIStrokeClr")
		if gd2 and gd2:IsA("UIGradient") then gd2.Color = ColorSequence.new(Color3.fromRGB(150, 0, 255), Color3.fromRGB(190, 95, 255)) end
		if s1 and s1:IsA("UIStroke") then s1.Color = Color3.fromRGB(42, 0, 72) end
		if s2 and s2:IsA("UIStroke") then s2.Color = Color3.fromRGB(210, 160, 255) end
		local im = b:FindFirstChild("ImageLabel")
		if im and type(gi) == "string" then im.Image = gi end
		b.Parent = rb
		st.cn[#st.cn + 1] = b.Activated:Connect(function() if W.Main.Visible then W:Hide() else W:Show() end end)
		task.spawn(pcall, function() require(rs.Client.UI.VFX.ButtonFX)(b) end)
	end
end
