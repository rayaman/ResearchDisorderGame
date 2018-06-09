--package.path="/?/init.lua;"..package.path
require("Libs/Library")
--~ require("Libs/Utils")
require("bin")
--~ require("multi.compat.love2d") -- for use with the love2d engine
GLOBAL,sThread=require("multi.integration.loveManager").init()
require("parseManager")
require("GuiManager")
require("Libs/AudioManager")
gui.LoadAll("Interface")
jQueue=multi:newSystemThreadedJobQueue(4)
jQueue:registerJob("LoadImage",function(path)
	local dat = love.image.newImageData(path)
	return dat
end)
jQueue:start()
function form(link,x,y,w,h,sx,sy,sw,sh)
    local x,y,w,h,sx,sy,sw,sh=(link:varExists(x) or tonumber(x)),(link:varExists(y) or tonumber(y)),(link:varExists(w) or tonumber(w)),(link:varExists(h) or tonumber(h)),(link:varExists(sx) or tonumber(sx)),(link:varExists(sy) or tonumber(sy)),(link:varExists(sw) or tonumber(sw)),(link:varExists(sh) or tonumber(sh))
    return x,y,w,h,sx,sy,sw,sh
end
math.randomseed(os.time())
actornum=0
animnum=0
rand=randomGen:new(0)
class_BG=audio:new("audio/Class.wav")
aqua_BG=audio:new("audio/Aqua.mp3")
park_BG=audio:new("audio/Park.mp3")
school_BG=audio:new("audio/School.mp3")
store_BG=audio:new("audio/Store.mp3")
house_BG=audio:new("audio/House.mp3")
credits_BG=audio:new("audio/Game Credits.mp3")
class_BG:setLooping(true)
aqua_BG:setLooping(true)
park_BG:setLooping(true)
school_BG:setLooping(true)
store_BG:setLooping(true)
house_BG:setLooping(true)
credits_BG:setLooping(true)
function BGStop()
	class_BG:stop()
	aqua_BG:stop()
	park_BG:stop()
	school_BG:stop()
	store_BG:stop()
	house_BG:stop()
	credits_BG:stop()
end
parseManager:define{
    getInput=function(self,msg)
		inputBox.message.text=msg
		inputBox.Visible=true
		inputBox.input:focus()
		go.Visible=false
		thread.hold(function() return _inputvar~=nil end)
		local i=_inputvar
		_inputvar=nil
		inputBox.Visible=false
		go.Visible=true
		return i
	end,
	BGStop=function()
		class_BG:stop()
		aqua_BG:stop()
		park_BG:stop()
		school_BG:stop()
		store_BG:stop()
		house_BG:stop()
		credits_BG:stop()
	end,
	ClassBG=function(b)
		if b then
			class_BG:play()
		else
			class_BG:stop()
		end
	end,
	AquaBG=function(b)
		if b then
			aqua_BG:play()
		else
			aqua_BG:stop()
		end
	end,
	ParkBG=function(b)
		if b then
			park_BG:play()
		else
			park_BG:stop()
		end
	end,
	SchoolBG=function(b)
		if b then
			school_BG:play()
		else
			school_BG:stop()
		end
	end,
	StoreBG=function(b)
		if b then
			store_BG:play()
		else
			store_BG:stop()
		end
	end,
    HouseBG=function(b)
		if b then
			house_BG:play()
		else
			house_BG:stop()
		end
	end,
    CreditsBG=function(b)
		if b then
			credits_BG:play()
		else
			credits_BG:stop()
		end
	end,
    loadAudio=function(self,path)
        return love.audio.newSource(path)
    end,
    loadSong=function(self,path)
        return love.audio.newSource(path)
    end,
    playSongLooped=function(self,item)
        item:setLooping(true)
        item:play()
    end,
    playAudio=function(self,item,n)
        item:play()
		if n then
			multi:newAlarm(n):OnRing(function()
				item:stop()
			end)
		end
    end,
	getPeriod=function()
		return "."
	end,
    playSong=function(self,item,n)
        item:play()
		if n then
			multi:newAlarm(n):OnRing(function()
				item:stop()
			end)
		end
    end,
    sleep=function(self,n)
        local num=n
        self.handle:hold(num)
    end,
    fadeSong=function(self,item)
        self.handle:Pause()
        local handle=self:varExists(item)
        local step=multi:newTStep(100,0,-1,.05)
        step:OnStep(function(pos,self)
            handle:setVolume(pos/100)
        end)
        while handle:getVolume()~=0 do
            multi:lManager()
        end
        self.handle:Resume()
    end,
    stopAudio=function(self,item)
        item:stop()
    end,
    stopSong=function(self,item)
        if self:varExists(item)==nil then
            love.audio.stop()
            return
        end
        item:stop()
    end,
    pauseAudio=function(self,item)
        item:pause()
    end,
    cls=function(self)
        core.chatFrame.textHolder.text=""
    end,
    BG=function(self,path)
		core:SetImage(path)
		currentBG = path
    end,
    SHOW=function(self,item)
        self:varExists(item).Visible=true
    end,
    HIDE=function(self,item)
        self:varExists(item).Visible=false
    end,
    createObject=function(self,x,y,w,h,sx,sy,sw,sh)
        actornum=actornum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local obj=workspace:newItem("",nil,"Actor "..actornum, x, y, w, h, sx ,sy ,sw ,sh)
        if obj.DPI>=2 then
          obj.DPI=obj.DPI-1
        end
		print("OBJECT: "..tostring(obj))
        return obj
    end,
    makeObject=function(self,link,x,y,w,h,sx,sy,sw,sh)
        actornum=actornum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local obj= link:newItem("",nil,"Actor "..actornum, x, y, w, h, sx ,sy ,sw ,sh)
        if obj.DPI>=2 then
            obj.DPI=obj.DPI-1
        end
        return obj
    end,
    createAnimation=function(self,file,delay,x,y,w,h,sx,sy,sw,sh)
        local file,delay=(self:varExists(file) or file),(tonumber(self:varExists(delay)) or tonumber(delay))
        animnum=animnum+1
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        local anim = workspace:newAnim(file,delay, x, y, w, h, sx ,sy ,sw ,sh)
        anim:OnAnimEnd(function(link)
            link:Reset()
            link:Resume()
        end)
        if anim.DPI>=2 then
          anim.DPI=anim.DPI-1
        end
        return anim
    end,
    stopAnimation=function(self,item)
        item:Pause()
    end,
    resumeAnimation=function(self,item)
        item:Resume()
    end,
    resetAnimation=function(self,item)
        item:Reset()
    end,
    setImage=function(self,item,path)
		smartPrint(item)
        item:SetImage(path)
    end,
    setText=function(self,item,text)
		if type(item)=="string" then
			print(actor)
			self:pushError("item must be a gui object!")
		end
        item.text=text
    end,
    JUMPPLAY=function(self,to,handle)
        self.methods.playSong(self,handle)
        self.methods.JUMP(self,to)
    end,
    setPosition=function(self,item,x,y,w,h,sx,sy,sw,sh)
        local x,y,w,h,sx,sy,sw,sh=form(self,x,y,w,h,sx,sy,sw,sh)
        item:SetDualDim(x,y,w,h,sx,sy,sw,sh)
    end,
    makeDraggable=function(self,item,db)
        item.Draggable=true
        if db then
			item.dragbut=db
        end
    end,
	randomInt=function(self,a,b)
		return math.random(a,b)
	end,
	listRemove=function(self,list,ind)
		return table.remove(list,ind)
	end,
	getLength=function(self,list)
		return #list
	end,
    centerX=function(self,item)
        item:centerX()
    end,
    centerY=function(self,item)
        item:centerY()
    end,
    centerXY=function(self,item)
        item:centerX()
        item:centerY()
    end,
    setVar=function(self,v,t) if t=="n" then return tonumber(v) else return v end end,
    destroy=function(self,item)
        item:Destroy()
    end,
	loadImage=function(self,path)
		--
	end,
	getQuote=function()
		return "'"
	end,
    newThread=function(blocklink,block)
		multi:newThread(block.." [Thread]",function()
			local ThreadTest=parseManager:load(blocklink.chunks[block].path)
			ThreadTest.mainENV=blocklink.mainENV
			ThreadTest.handle=loop
			ThreadTest:define{
				sleep=function(self,n)
					thread.sleep(n)
				end
			}
			local t=ThreadTest:next(block)
			while true do
				if t.Type=="text" then
					print(t.text)
					t=ThreadTest:next()
				else
					t=ThreadTest:next()
				end
			end
		end)
	end,
	Menu = function(self,b)
		core.menu.Visible=b
		menu_BG:play()
		menu_BG:setVolume(0)
		multi:newThread("FadeIn",function()
			for i=1,100 do
				thread.sleep(.1)
				menu_BG:setVolume(i/100)
			end
		end)
		thread.hold(function() return core.menu.Visible==false end)
	end,
	GameStore = function(self,b)
		core.game.Visible=b
		core.game.store.Visible=b
		core.chatFrame.textHolder.text=""
		Progress()
		thread.hold(function() return core.game.store.Visible==false end)
		return STORE_CORRECT
	end,
	GameHouse = function(self,b)
		core.game.Visible=b
		core.game.house.Visible=b
		core.chatFrame.textHolder.text=""
		ProgressHouse()
		thread.hold(function() return core.game.house.Visible==false end)
		return HOUSE_CORRECT
	end,
	GameAqua = function(self,b)
		core.game.Visible=b
		core.game.aqua.Visible=b
		core.chatFrame.textHolder.text=""
		ProgressAqua()
		thread.hold(function() return core.game.aqua.Visible==false end)
		core.chatFrame.Visible = true
		return GAME_AQUA
	end,
	SetActors = function(self,a,b,c)
		actor1:SetImage(a)
		actor2:SetImage(b)
		actor3:SetImage(c)
	end
}
standardRef = {
	[[OnEnter(function(self)
		if not igmenu.Visible then
			self.TextColor=Color.Darken(self.TextColor,.35)
			menu_sound:play()
		end
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	TextColor = Color.Lighten(Color.Yellow,.05),
	[[setNewFont(32,"fonts/Angeline.ttf")]],
	[[setRoundness(10,10,360)]],
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Tween = -38,
	Color=Color.Black
}
choiceRef = {
	[[OnEnter(function(self)
		if not igmenu.Visible then
			self.TextColor=Color.Darken(self.TextColor,.35)
			menu_sound:play()
		end
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	TextColor = Color.Lighten(Color.Yellow,.05),
	[[setNewFont(28,"fonts/zekton rg.ttf")]],
	[[setRoundness(10,10,360)]],
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Tween = 8,
	Color=Color.Black
}
MenuRef = {
	[[OnEnter(function(self)
		self.TextColor=Color.Darken(self.TextColor,.35)
		menu_sound:play()
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	TextColor = Color.Lighten(Color.Yellow,.05),
	[[setNewFont(76,"fonts/Angeline.ttf")]],
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Tween = -90,
	Visibility = .85,
	BorderSize = 0,
	Color=Color.Black
}
bin.setBitsInterface(infinabits)
--FileSystem Setup
menuready = true
love.filesystem.setIdentity("Froggy Field Day")
love.filesystem.createDirectory("SavedData")
--gui.enableAutoWindowScaling(true)
core=gui:newImageLabel("images/classroom.jpg",0,0,0,0,0,0,1,1)--gui:newFullImageLabel("fire.jpg","BG")
top=gui:newFullFrame()
top.Visibility = 0
workspace=core:newFullFrame()
workspace.Visibility=0
core.menubutton = workspace:newTextLabel("Menu",10,10,100,50)
core.menubutton:OnEnter(function(self)
	self:addDominance()
	menu_sound:play()
end)
core.menubutton:OnExit(function(self)
	self:removeDominance()
end)
core.menubutton:OnReleased(function(b,self)
	menuready = false
	top:addDominance()
	igmenu.Visible = true
end)
core.game=core:newFullFrame()
core.game.Visibility=0
core.actorFrame=core:newFullFrame()
core.actorFrame.Visibility = 0
actor1 = core.actorFrame:newImageLabel(nil,100,-500,250,500,0,1)
actor2 = core.actorFrame:newImageLabel(nil,0,-500,250,500,0,1)
actor2:centerX()
actor3 = core.actorFrame:newImageLabel(nil,-350,-500,250,500,1,1)
core.chatFrame=core:newFrame("chatFrame",20,-140,-40,120,0,1,1)
core.chatFrame:setRoundness(10,10,360)
core.chatFrame.BorderSize=4
core.chatFrame.textHolder=core.chatFrame:newTextLabel("","",5,5,-10,-10,0,0,1,1)
core.chatFrame.textHolder.Visibility=0
core.chatFrame.textHolder.text=""
core.chatFrame.textHolder.TextFormat="left"
core.chatFrame.textHolder:setNewFont(20,"fonts/zekton rg.ttf")
core.chatFrame.textHolder.namepiece = core.chatFrame.textHolder:newTextLabel("",0,-40,0,30)
core.chatFrame.textHolder.namepiece:setNewFont(20,"fonts/zekton rg.ttf")
core.chatFrame.textHolder.namepiece.Tween = 4
core.chatFrame.textHolder.namepiece:setRoundness(5,5,180)
function initGameWindow()
	local childs = core.game:getChildern()
	for i = 1,#childs do
		childs[i]:Destroy()
	end
end
test=parseManager:load("init.txt")
_dump=test:dump()
print(_dump)
bin.new(_dump):tofile("Dump.dat")
test.mainENV["gui"]=workspace
test.mainENV["menu"]=top
go=core.chatFrame.textHolder:newImageButton("images/arrow.png",-25,-25,20,20,1,1)
go:OnReleased(function(b,self)
	if not igmenu.Visible then
		button_pressed = true
	end
end)
core:OnReleased(function(b,self)
	if not igmenu.Visible and core.chatFrame.Visible and b=="l" then
		button_pressed = true
	elseif not igmenu.Visible and b=="r" then
		core.chatFrame.Visible = not core.chatFrame.Visible
		if choiceframe and not choiceframe.Destroyed then
			choiceframe.Visible = core.chatFrame.Visible
		end
	end
end)
dialogeHandler=multi:newThreadedLoop("loop",function(self,ti)
	t=test:next()
	button_pressed = false
	enter_pressed = false
	auto_progressed = false
	if t==nil then love.thread.exit() end
	if t.Type=="text" then
		local temptag = t.text:match("(.-): ")
		if temptag then
			test.mainENV["tag"] = temptag
		end
		if core.chatFrame.textHolder.namepiece.text=="" and test.mainENV["tag"] then
			core.chatFrame.textHolder.namepiece.text = test.mainENV["tag"]
			core.chatFrame.textHolder.namepiece:widthToTextSize(16)
		end
		if temptag then
			t.text = t.text:match(".-: (.+)")
			core.chatFrame.textHolder.namepiece.text = test.mainENV["tag"]
			core.chatFrame.textHolder.namepiece:widthToTextSize(16)
		end
		core.chatFrame.textHolder.text=""
		for i in t.text:gmatch(".") do
			local held = thread.hold(function() return igmenu.Visible == false end)
			if held then
				enter_pressed = false
				button_pressed = false
				auto_progressed = false
			end
			if Settings.Text_speed==1 then
				thread.sleep(.1)
			elseif Settings.Text_speed==3 then
				thread.sleep(.02)
			else
				thread.sleep(.05)
			end
			core.chatFrame.textHolder.text=core.chatFrame.textHolder.text..i
			if (button_pressed or auto_progressed) and menuready then enter_pressed = false button_pressed = false core.chatFrame.textHolder.text=t.text break end
		end
		if Settings.auto_progress and core.chatFrame.textHolder.Visible then
			thread.sleep(1)
			enter_pressed = true
		end
		thread.hold(function() return (enter_pressed or button_pressed or auto_progressed) and igmenu.Visible == false end)
	elseif t.Type=="choice" then
		go.Visible=false
		choiceframe=core:newFrame("",0,0,0,0,0,0,.8)
		choiceframe.Visibility = 0
		core.chatFrame.textHolder.text=""
		local temptag = t.prompt:match("(.-): ")
		if temptag then
			test.mainENV["tag"] = temptag
		end
		if core.chatFrame.textHolder.namepiece.text=="" and test.mainENV["tag"] then
			core.chatFrame.textHolder.namepiece.text = test.mainENV["tag"]
			core.chatFrame.textHolder.namepiece:widthToTextSize(16)
		end
		if temptag then
			t.prompt = t.prompt:match(".-: (.+)")
			core.chatFrame.textHolder.namepiece.text = test.mainENV["tag"]
			core.chatFrame.textHolder.namepiece:widthToTextSize(16)
		end
		for i in t.prompt:gmatch(".") do
			thread.sleep(.05)
			core.chatFrame.textHolder.text=core.chatFrame.textHolder.text..i
			if enter_pressed or button_pressed or auto_progressed then enter_pressed = false button_pressed = false core.chatFrame.textHolder.text=t.prompt break end
		end
		local choice
		for i=1,#t[1] do
			if not choice then
				choice=choiceframe:newTextLabel(t[1][i],0,0,0,50,0,0,1)
			else
				choice=choice:newTextLabel(t[1][i],0,10,0,50,0,1,1)
			end
			choice.Color = Color.Darken(Color.saddle_brown,.15)
			choice.index = i
			choice.Visibility = .85
			choice:OnReleased(function(b,self)
				if not igmenu.Visible and menuready then
					choicemade=self.index
				end
			end)
			gui.massMutate(choiceRef,choice)
		end
		choiceframe:centerX()
		y=((#t[1]*60)-10)/2
		print(y)
		choiceframe:SetDualDim(nil,-(y+60),nil,nil,nil,.5)
		thread.hold(function() return choicemade~=nil end)
		go.Visible=true
		choiceframe:Destroy()
		local cm=choicemade
		choicemade=nil
		t=test:next(nil,cm)
	end
end)
test.handle=dialogeHandler
inputBox=core.game:newFrame(0,0,500,160)
inputBox.Visibility=0
inputBox.header=inputBox:newFrame(0,0,8,28,0,0,1)
inputBox.header.Visibility=0
inputBox.header.ClipDescendants=true
inputBox.header.helper=inputBox.header:newFrame("",4,4,-8,40,0,0,1)
inputBox.header.helper.BorderSize=4
inputBox.header.helper:setRoundness(10,20,360)
inputBox.header.helper:ApplyGradient{Color.Brown,Color.Lighten(Color.Brown,.15)}
inputBox.body=inputBox:newFrame("",4,28,0,150,0,0,1)
inputBox.body.BorderSize=4
inputBox.body:ApplyGradient{Color.tan,Color.Lighten(Color.tan,.3)}
inputBox.X=inputBox.header.helper:newTextButton("X","X",-23,4,15,15,1)
inputBox.X:setRoundness(5,5,360)
inputBox.X:ApplyGradient{Color.red,Color.Lighten(Color.red,.2)}
inputBox.X.Tween=-6
inputBox.X.XTween=-2
inputBox.message=inputBox.body:newTextLabel("","Prompt",0,0,0,0,.05,.1,.9,.5)
inputBox.input2=inputBox.body:newTextLabel("","",0,0,0,30,.05,.65,.7)
inputBox.input=inputBox.body:newTextBox("","Enter Text",0,0,0,30,.05,.65,.7)
inputBox.enter=inputBox.body:newTextButton("","GO",0,0,0,30,.8,.65,.15)
inputBox.message.BorderSize=4
inputBox.input2.BorderSize=4
inputBox.enter.BorderSize=4
inputBox.message:setRoundness(5,5,360)
inputBox.input2:setRoundness(5,5,360)
inputBox.input2:ApplyGradient{Color.tan,Color.Lighten(Color.tan,.2)}
inputBox.enter:ApplyGradient{Color.Darken(Color.green,.2),Color.green}
inputBox.enter:setRoundness(5,5,360)
inputBox.enter:OnReleased(function(b,self)
    _inputvar=inputBox.input.text
    inputBox.Visible=false
end)
inputBox.input:OnEnter(function(self,text)
    _inputvar=inputBox.input.text
    inputBox.Visible=false
end)
inputBox.input.TextFormat="left"
inputBox.input.XTween=3
inputBox.input.Visibility=0
inputBox.input.ClipDescendants=true
inputBox:centerX()
inputBox:centerY()
inputBox.Visible=false
core.game=core:newFullFrame()
core.menu=core:newFullFrame()
require("minigames")
require("menu")
function love.keyreleased(key)
	if key == "space" then
		enter_pressed = true
	end
end
gui.massMutate(standardRef,core.menubutton)
core.menu.Visible = true
function love.update(dt)
	multi:uManager(dt)
end
function love.draw()
    multi.dManager()
end
