-- love.graphics.captureScreenshot( filename )
-- Save data stuff
igmenu = top:newFrame(0,0,0,0,0,0,.3,.8)
igmenu.Visible = false
igmenu.Visibility = 0
igmenu:center()
igmenu.resume = igmenu:newTextLabel("Resume",0,0,0,0,0,0,1,1/5)
igmenu.save = igmenu:newTextLabel("Save",0,0,0,0,0,(1/5),1,1/5)
igmenu.load = igmenu:newTextLabel("Load",0,0,0,0,0,(2/5),1,1/5)
igmenu.setting = igmenu:newTextLabel("Settings",0,0,0,0,0,(3/5),1,1/5)
igmenu.quit = igmenu:newTextLabel("Quit",0,0,0,0,0,(4/5),1,1/5)
igmenu.resume:OnReleased(function()
	igmenu.Visible = false
	multi:newAlarm(.1):OnRing(function(alarm)
		alarm:Destroy()
		menuready = true
	end)
	top:removeDominance()
end)
igmenu.save:OnReleased(function()
	local date = os.date("%m.%d.%y_%I.%M.%S",os.time())
	love.filesystem.createDirectory("SavedData/"..date)
	local state = test:extractState()
	local statedat = bin.new()
	state.variables["gui"]=nil
	state.variables["menu"]=nil
	statedat:addBlock(state)
	statedat:addBlock(currentBG,128)
	test.mainENV["gui"]=workspace
	test.mainENV["menu"]=top
	statedat:tofileS("SavedData/"..date.."/savedata.dat")
	igmenu.Visible = false
	multi:newThread("Saving-Thread",function()
		thread.sleep(.1)
		love.graphics.newScreenshot():encode("png","SavedData/"..date.."/screen.png")
		print("Saving image!")
		igmenu.Visible = true
	end)
	print("data saved")
end)
igmenu.load:OnReleased(function()
	core.menu.load:setParent(core.igmenu)
	core.menu.load.Visible = true
	core.igmenu.Visible = true
	core.igmenu:addDominance()
	core.menu.load:setDualDim(0,0,0,0,0,0,1,1)
	loadSaves()
	multi:newEvent(function()
		return core.menu.load.Visible==false
	end):OnEvent(function(evnt)
		core.menu.load:setParent(core.menu)
		core.igmenu.Visible = false
		core.igmenu:removeDominance()
		core.menu.load:setDualDim(0,0,0,0,1/3,0,2/3,1)
		evnt:Destroy()
	end)
end)
igmenu.setting:OnReleased(function()
	core.menu.settings:setParent(core.igmenu)
	core.menu.settings.Visible = true
	core.igmenu.Visible = true
	core.igmenu:addDominance()
	core.menu.settings:setDualDim(0,0,0,0,0,0,1,1)
	multi:newEvent(function()
		return core.menu.settings.Visible==false
	end):OnEvent(function(evnt)
		core.menu.settings:setParent(core.menu)
		core.igmenu.Visible = false
		core.igmenu:removeDominance()
		core.menu.settings:setDualDim(0,0,0,0,1/3,0,2/3,1)
		evnt:Destroy()
	end)
end)
igmenu.quit:OnReleased(function()
	core.menu.quit.Visible = true
	core.menu.quit:addDominance()
end)
gui.massMutate(MenuRef,igmenu.quit,igmenu.setting,igmenu.load,igmenu.save,igmenu.resume)
menu_sound=audio:new("audio/menu.wav")
menu_BG=audio:new("audio/Menu.mp3")
menu_BG:setLooping(true)
core.menu.Visible = false
local options = core.menu:newFrame(0,0,0,0,0,0,1/3,1)
local lowerBg = core.menu:newImageLabel("images/school.png",0,0,0,0,1/3,0,2/3,1)
local bg = core.menu:newImageLabel("images/2 KIDS1.png",0,0,0,0,1/3,0,2/3,1)
local upperBg = core.menu:newFrame(0,0,0,0,1/3,0,2/3,1)
upperBg.Color = Color.Black
play = options:newTextLabel("Play",0,0,0,0,0,0,1,1/4)
load = options:newTextLabel("Load",0,0,0,0,0,1/4,1,1/4)
load:OnReleased(function(b,self)
	core.menu.settings.Visible = false
	core.menu.load.Visible = true
	loadSaves()
end)
local settings = options:newTextLabel("Settings",0,0,0,0,0,2/4,1,1/4)
settings:OnReleased(function(b,self)
	core.menu.load.Visible = false
	core.menu.settings.Visible = true
end)
local quit = options:newTextLabel("Quit",0,0,0,0,0,3/4,1,1/4)
quit:OnReleased(function(b,self)
	core.menu.quit.Visible = true
	core.menu.quit:addDominance()
end)
core.menu.load = core.menu:newImageLabel("images/chalkboard.jpg",0,0,0,0,1/3,0,2/3,1)
core.igmenu = gui:newFrame(0,0,0,0,0,0,1,1)
core.igmenu.Color = Color.Black
core.igmenu.Visible = false
core.menu.load.games = core.menu.load:newFrame(0,0,0,0,0,0,1,1)
core.menu.load.games.Visibility = 0
local Bbar = core.menu.load:newImageLabel("images/wood.png",0,-90,0,90,0,1,1)
local Tbar = core.menu.load:newImageLabel("images/wood.png",0,0,0,90,0,0,1)
Bbar.Color = Color.new(116,99,150)
Tbar.Color = Color.new(116,99,150)
core.menu.load.Visible = false
core.menu.load.Color=Color.new(116,99,150)
core.menu.load.dragFrame=core.menu.load:newImageLabel(nil,0,0,0,0,0,0,1,1)
core.menu.load.down = core.menu.load:newImageButton("images/DownArrow.png",0,-70,100,60,0,1)
core.menu.load.down:centerX()
core.menu.load.down.Color=Color.Darken(Color.Yellow,.15)
core.menu.load.up = core.menu.load:newImageButton("images/UpArrow.png",0,10,100,60)
core.menu.load.up.Visible = false
core.menu.load.up:centerX()
core.menu.load.up.Color=Color.Darken(Color.Yellow,.15)
core.menu.load.back = core.menu.load:newTextLabel("Back",20,-70,100,50,0,1)
core.menu.load.back:setRoundness(5,5,360)
core.menu.load.back:OnEnter(function(self)
	self:addDominance()
end)
core.menu.load.back:OnExit(function(self)
	self:removeDominance()
end)
core.menu.load.back:OnReleased(function(b,self)
	core.menu.load.Visible = false
	self:removeDominance()
end)
play:OnReleased(function(b,self)
	multi:newThread("FadeOut",function()
		for i=100,0,-1 do
			thread.sleep(.01)
			menu_BG:setVolume(i/100)
		end
		menu_BG:stop()
		core.menu.Visible = false
	end)
end)
core.menu.load.down:OnReleased(function(b,self)
	local c = core.menu.load.games:getChildren()
	if #c==0 then return end
	core.menu.load.games:setDualDim(nil,core.menu.load.games.offset.pos.y-100)
	core.menu.load.up.Visible = true
	if c[#c].y+200<=680 then
		self.Visible = false
		love.mouse.setCursor(_GuiPro.CursorN)
	end
end)
core.menu.load.up:OnReleased(function(b,self)
	local c = core.menu.load.games:getChildren()
	core.menu.load.games:setDualDim(nil,core.menu.load.games.offset.pos.y+100)
	core.menu.load.down.Visible = true
	if core.menu.load.games.offset.pos.y>=0 then
		core.menu.load.games:setDualDim(nil,0)
		self.Visible = false
		love.mouse.setCursor(_GuiPro.CursorN)
	end
end)
gui.massMutate({--fonts/PWRectangular.ttf
	[[setNewFont(76,"fonts/Angeline.ttf")]],
	[[OnEnter(function(self)
		self.TextColor=Color.Darken(self.TextColor,.35)
		menu_sound:play()
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	Tween = -70,
	TextColor = Color.Lighten(Color.Yellow,.05),
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Color = Color.Black,
},play,settings,load,quit)
core.menu.load.back:setNewFont(36,"fonts/PWRectangular.ttf")
core.menu.load.back.Tween=-4
crossRef = {}
localMax = 0
localcount = 0
jQueue.OnJobCompleted(function(JOBID,n)
	print(JOBID,n)
	crossRef[JOBID].ImageHolder:SetImage(n,JOBID)
	localcount=localcount+1
	if localcount==localMax then
		crossRef = {}
		localMax = 0
		localcount = 0
	end
end)
function loadSaves()
	local files = love.filesystem.getDirectoryItems("savedData")
	core.menu.load.games.Children={}
	localMax = #files
	for i=#files,1,-1 do
		local temp = core.menu.load.games:newFrame(0,0,300,200)
		temp.ImageHolder = temp:newImageLabel(nil,0,0,0,0,0,0,1,1)
		local jobid = jQueue:pushJob("LoadImage","savedData/"..files[i].."/screen.png")
		crossRef[jobid]=temp
		local txt = temp:newTextLabel(files[i],0,0,0,30,0,0,1)
		txt.Color = Color.Black
		txt.TextColor = Color.White
		local data = bin.load("savedData/"..files[i].."/savedata.dat")
		temp.state = data:getBlock("t")
		if temp.state.variables.user then
			txt.text = temp.state.variables.user..": "..txt.text
		end
		temp.state.pos = temp.state.pos-1
		print(files[i])
		temp.BG = (data:getBlock("s",128) or ""):match("(.+)\0")
		temp:OnReleased(function(b,self)
			menu_BG:stop()
			test:injectState(self.state)
			local name = self.state.name
			BGStop()
			if name == "LOBBY" then
				class_BG:play()
			elseif name == "HOUSE" then
				house_BG:play()
			elseif name == "SCHOOL" then
				school_BG:play()
			elseif name == "PARK" then
				park_BG:play()
			elseif name == "AQUARIUM" then
				aqua_BG:play()
			elseif name == "STORE" then
				store_BG:play()
			elseif name == "END" then
				credits_BG:play()
			end
			core:SetImage(self.BG)
			core.menu.Visible = false
			if igmenu.Visible then
				multi:newThread("StateLoading-Thread",function()
					thread.sleep(.1)
					igmenu.Visible = false
					_inputvar = ""
					multi:newAlarm(.1):OnRing(function(alarm)
						alarm:Destroy()
						menuready = true
					end)
					core.menu.load:setParent(core.menu)
					core.igmenu.Visible = false
					core.igmenu:removeDominance()
					core.menu.load:setDualDim(0,0,0,0,1/3,0,2/3,1)
					top:removeDominance()
				end)
			end
		end)
	end
end
local loadgame = Tbar:newTextLabel("Load",20,20,100,50)
local deletegame = loadgame:newTextLabel("Delete",20,0,150,50,1)
core.menu.load.games:OnUpdate(function(self)
	local c = self:getChildren()
	for i=1,#c do
		local x,y = InGridX(i,core.menu.load.width,200,350,240)
		c[i]:setDualDim(x+75,y+100)
	end
end)
lowerBg.Visibility=0
core.menu.settings = core.menu:newImageLabel("images/chalkboard.jpg",0,0,0,0,1/3,0,2/3,1)
core.menu.settings.Color=Color.new(116,99,150)
core.menu.settings.Visible = false
core.menu.settings.back = core.menu.settings:newTextLabel("Back",20,-70,100,50,0,1)
core.menu.settings.back:setRoundness(5,5,360)
core.menu.settings.back:OnReleased(function(self)
	core.menu.settings.Visible = false
end)
core.menu.quit = gui:newFrame(0,0,0,0,0,0,1,1)
core.menu.quit.Visible = false
core.menu.quit.Visibility = 0
local qu = core.menu.quit:newFrame(0,0,300,200)
qu:centerX()
qu:centerY()
qu:setRoundness(15,15,360)
qu.Color=Color.Black
qu.BorderColor = Color.Lighten(Color.Yellow,.05)
local msg = qu:newTextLabel("Are You Sure",20,20,-40,60,0,0,1)
local yes = qu:newTextLabel("Yes",20,-80,100,60,0,1)
local no = qu:newTextLabel("No",-120,-80,100,60,1,1)
msg.TextColor = Color.Lighten(Color.Yellow,.05),
msg:setNewFont(48,"fonts/Angeline.ttf")
msg.Visibility = 0
msg.Tween = -68
gui.massMutate({
	[[OnEnter(function(self)
		self.TextColor=Color.Darken(self.TextColor,.35)
		menu_sound:play()
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	TextColor = Color.Lighten(Color.Yellow,.05),
	[[setNewFont(32,"fonts/Angeline.ttf")]],
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Visibility = 0,
	Tween = -38
},yes,no,core.menu.load.back,core.menu.settings.back,loadgame,deletegame)
loadgame.Visibility = 1
loadgame.Color = Color.Black
loadgame:setRoundness(5,5,360)
deletegame.Visibility = 1
deletegame.Color = Color.Black
deletegame:setRoundness(5,5,360)
core.menu.load.back.Visibility = 1
core.menu.load.back.Color = Color.Black
core.menu.settings.back.Visibility = 1
core.menu.settings.back.Color = Color.Black
yes:OnReleased(function(self)
	love.event.quit()
end)
no:OnReleased(function(self)
	core.menu.quit.Visible = false
	core.menu.quit:removeDominance()
end)
multi:newThread("Menu-Background",function()
	local count = 1
	while true do
		thread.hold(function() return core.menu.Visible==true and (core.menu.load.Visible==false) end) -- if the menu is active do this if not wait till it is
		lowerBg:SetImage("images/"..({"Park","aqua","home","store","classroomafterhours"})[count]..".png")
		for i = 1,1000 do
			thread.sleep(.001) -- hehe a bit of a hack
			upperBg.Visibility = (1000-i)/1000
		end
		for i = 1000,1,-1 do
			thread.sleep(.001) -- hehe a bit of a hack
			upperBg.Visibility = (1000-i)/1000
		end
		count = count + 1
		if count > 5 then
			count=1
		end
	end
end)
---------------------------------
--~ settings
evntA = multi:newEvent(function()
	return core.menu.settings.Visible==true
end)
evntA:OnEvent(function()
	evntB:Reset()
end)
evntB = multi:newEvent(function()
	return core.menu.settings.Visible==false
end)
evntB:Pause()
evntB:OnEvent(function()
	print("Saving settings!")
	local set = bin.new()
	set:addBlock(Settings.Volume,1)
	set:addBlock(Settings.mute,1)
	set:addBlock(Settings.auto_save,1)
	set:addBlock(Settings.auto_progress,1)
	set:addBlock(Settings.Text_speed,1)
	set:addBlock(Settings.Font_Size,1)
	set:tofileS("Settings.dat")
	evntA:Reset()
end)
local title = core.menu.settings:newTextLabel("Settings",0,0,0,100,0,0,1)
title:setNewFont(72,"fonts/Angeline.ttf")
title.Tween = -72
title.Visibility = 0
title.TextColor = Color.Darken(Color.White,.15)
local Volume=core.menu.settings:newFrame(0,0,400,130)
local vol = Volume:newTextLabel("Volume",0,0,200,60)
local mute = Volume:newTextLabel("Mute",0,60,200,60)
local vv = vol.Font:getWidth("Volume")
local slidebar = Volume:newFrame(-200,10,200,60,1)
Volume.Visibility = 0
slidebar.Visibility=0
slidebar.display=slidebar:newTextLabel("100%",0,0,40,20)
slidebar.display:centerX()
slidebar.display.Tween=-3
slidebar.display.Visibility = 0
slidebar.display.TextColor = Color.Darken(Color.White,.15)
slidebar:setNewFont(20,"fonts/Angeline.ttf")
slidebar.left=slidebar:newFrame(0,0,10,0,0,0,0,1)
slidebar.bar=slidebar:newFrame(10,0,-20,10,0,0,1)
slidebar.bar:centerY()
slidebar.bar:OnClicked(function(b,self,x,y,xx,yy)
	slidebar.move:setDualDim(x-10)
	if slidebar.move.offset.pos.x<0 then
		slidebar.move:setDualDim(0)
	elseif slidebar.move.offset.pos.x>160 then
		slidebar.move:setDualDim(160)
	end
	love.mouse.setY(slidebar.move.y+10)
end)
slidebar.right=slidebar:newFrame(-10,0,10,0,1,0,0,1)
slidebar.move=slidebar.bar:newFrame(80,0,20,20,0,0,0)
slidebar.move:centerY()
slidebar.move:OnUpdate(function()
	slidebar.display.text=math.ceil((slidebar.move.offset.pos.x/160)*100) .."%"
	Settings.Volume=math.ceil((slidebar.move.offset.pos.x/160)*100)
	love.audio.setVolume(Settings.Volume/100)
end)
Volume.muter=Volume:newImageLabel("images/unchecked.png",-190,80,40,40,1)
Volume.muter:OnReleased(function(b,self)
	if Settings.mute then
		self:SetImage("images/unchecked.png")
		Settings.mute = false
		love.audio.resume()
	else
		self:SetImage("images/checked.png")
		Settings.mute = true
		love.audio.pause()
	end
end)
gui.massMutate({
	[[setRoundness(5,5,60)]],
	Color=Color.Saddle_brown
},slidebar.move,slidebar.right,slidebar.left)
slidebar.move.Color = Color.Lighten(Color.Saddle_brown,.20)
slidebar.bar.Color=Color.Saddle_brown
local asave=Volume:newTextLabel("Autosave",0,0,200,60,0,1)
asaveC=asave:newImageLabel("images/checked.png",10,15,40,40,1)
asaveC:OnReleased(function(b,self)
	if Settings.auto_save then
		self:SetImage("images/unchecked.png")
		Settings.auto_save = false
	else
		self:SetImage("images/checked.png")
		Settings.auto_save = true
	end
end)
local aprogress=asave:newTextLabel("Auto Progress",0,0,300,60,0,1)
aprogressC=aprogress:newImageLabel("images/unchecked.png",10,20,40,40,1)
aprogressC:OnReleased(function(b,self)
	if Settings.auto_progress then
		self:SetImage("images/unchecked.png")
		Settings.auto_progress = false
	else
		self:SetImage("images/checked.png")
		Settings.auto_progress = true
	end
end)
local tspeed=aprogress:newTextLabel("Text Speed",0,10,200,60,0,1)
speed = tspeed:newFrame(0,0,500,60,1)
speed.Visibility = 0
S_slow = speed:newTextLabel("Slow",0,0,0,0,0,0,1/3,1)
S_Med = speed:newTextLabel("Meduim",0,0,0,0,1/3,0,1/3,1)
S_Fast = speed:newTextLabel("Fast",0,0,0,0,2/3,0,1/3,1)
S_slow:OnReleased(function(b,self)
	Settings.Text_speed = 1
	self.Visibility = 1
	S_Med.Visibility = 0
	S_Fast.Visibility = 0
end)
S_Med:OnReleased(function(b,self)
	Settings.Text_speed = 2
	self.Visibility = 1
	S_slow.Visibility = 0
	S_Fast.Visibility = 0
end)
S_Fast:OnReleased(function(b,self)
	Settings.Text_speed = 3
	self.Visibility = 1
	S_Med.Visibility = 0
	S_slow.Visibility = 0
end)

local fontsize=tspeed:newTextLabel("Font Size",0,10,200,60,0,1)
fonts = fontsize:newFrame(0,0,500,60,1)
fonts.Visibility = 0
S_slow2 = fonts:newTextLabel("Small",0,0,0,0,0,0,1/3,1)
S_Med2 = fonts:newTextLabel("Meduim",0,0,0,0,1/3,0,1/3,1)
S_Fast2 = fonts:newTextLabel("Large",0,0,0,0,2/3,0,1/3,1)
S_slow2:OnReleased(function(b,self)
	Settings.Font_Size = 1
	self.Visibility = 1
	S_Med2.Visibility = 0
	S_Fast2.Visibility = 0
	core.chatFrame.textHolder:setNewFont(16)
end)
S_Med2:OnReleased(function(b,self)
	Settings.Font_Size = 2
	self.Visibility = 1
	S_slow2.Visibility = 0
	S_Fast2.Visibility = 0
	core.chatFrame.textHolder:setNewFont(20)
end)
S_Fast2:OnReleased(function(b,self)
	Settings.Font_Size = 3
	self.Visibility = 1
	S_Med2.Visibility = 0
	S_slow2.Visibility = 0
	core.chatFrame.textHolder:setNewFont(28)
end)
gui.massMutate({
	TextColor = Color.Darken(Color.White,.15),
	Visibility = 0,
	[[setNewFont(48,"fonts/Angeline.ttf")]],
	Tween = -60
},vol,mute,asave,aprogress,tspeed,fontsize)
gui.massMutate({
	[[OnEnter(function(self)
		self.TextColor=Color.Darken(self.TextColor,.35)
		menu_sound:play()
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	[[setRoundness(10,10,360)]],
	TextColor = Color.Darken(Color.White,.15),
	Visibility = 0,
	Color=Color.Saddle_brown,
	DefualtColor = Color.Darken(Color.White,.15),
	[[setNewFont(24,"fonts/Angeline.ttf")]],
	Tween = -15
},S_slow,S_Med,S_Fast,S_slow2,S_Med2,S_Fast2)
S_Med.Visibility = 1
S_Med2.Visibility = 1
loadgame.Visibility = 1
if bin.fileExists("Settings.dat") then
	local set = bin.loadS("Settings.dat")
	Settings={}
	local function LoadSettings()
		print("Loading Settings...")
		Settings.Volume = set:getBlock("n",1)
		Settings.mute = set:getBlock("b")
		Settings.auto_save = set:getBlock("b")
		Settings.auto_progress = set:getBlock("b")
		Settings.Text_speed = set:getBlock("n",1)
		Settings.Font_Size = set:getBlock("n",1)
		if Settings.Text_speed==1 then
			S_slow.Visibility = 1
			S_Med.Visibility = 0
		elseif Settings.Text_speed==3 then
			S_Fast.Visibility = 1
			S_Med.Visibility = 0
		end
		if Settings.Font_Size==1 then
			S_slow2.Visibility = 1
			S_Med2.Visibility = 0
			core.chatFrame.textHolder:setNewFont(16,"fonts/zekton rg.ttf")
		elseif Settings.Font_Size==3 then
			S_Fast2.Visibility = 1
			S_Med2.Visibility = 0
			core.chatFrame.textHolder:setNewFont(28,"fonts/zekton rg.ttf")
		end
		if Settings.auto_progress then
			aprogressC:SetImage("images/checked.png")
		end
		if not Settings.auto_save then
			asaveC:SetImage("images/unchecked.png")
		end
		if Settings.mute then
			Volume.muter:SetImage("images/checked.png")
		end
		slidebar.move:setDualDim((Settings.Volume/100)*160)
		love.audio.setVolume(Settings.Volume/100)
		print("Success!")
	end
	status, err = pcall(LoadSettings)
	if not status then
		Settings={}
		print("Setting data is currupt! Restoring defualts!")
		local set = bin.new()
		set:addBlock(Settings.Volume,1)
		set:addBlock(Settings.mute,1)
		set:addBlock(Settings.auto_save,1)
		set:addBlock(Settings.auto_progress,1)
		set:addBlock(Settings.Text_speed,1)
		set:addBlock(Settings.Font_Size,1)
		set:tofileS("Settings.dat")
	end
else --
	Settings={
		Volume = 50,
		mute = false,
		auto_save = true,
		auto_progress = false,
		Text_speed = 2,
		Font_Size = 2
	}
	local set = bin.new()
	set:addBlock(Settings.Volume,1)
	set:addBlock(Settings.mute,1)
	set:addBlock(Settings.auto_save,1)
	set:addBlock(Settings.auto_progress,1)
	set:addBlock(Settings.Text_speed,1)
	set:addBlock(Settings.Font_Size,1)
	set:tofileS("Settings.dat")
end
local x,y = Volume:getFullSize()
Volume:setDualDim(nil,-y,nil,nil,nil,.35)
