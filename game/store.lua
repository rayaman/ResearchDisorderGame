core.game.Visible = false
core.game.store=core.game:newFullFrame()
core.game.store.Visible = false
core.game.store.Visibility = 0
core.game.Visibility = 0
local maingame = core.game.store:newFrame(0,0,0,0,.2,.3,.58,.4)
maingame.Visibility = 0
face = maingame:newImageLabel("images/neutral.png",0,0,0,0,.05,.1,.35,.8)
ChoiceA = maingame:newTextLabel("This",0,0,0,0,.5,.1,.5,.3)
ChoiceB = maingame:newTextLabel("That",0,0,0,0,.5,.6,.5,.3)
ChoiceA.Correct = false
items = {
	"Milk",
	"Cheese",
	"Pepper",
	"Salt",
	"Orange Juice",
	"Chicken",
	"Cookies",
	"Popcorn",
	"Candy",
	"Ice Cream",
	"Frozen Pizzas",
	"Turkey",
	"Salmon",
	"Pasta",
	"Rice",
	"Tomato sauce",
	"Mustard",
	"Barbecue sauce",
	"Salsa",
	"Olive oil",
	"Hot sauce",
	"Cereal",
	"Tuna",
	"Frozen shrimp",
	"Butter",
	"Crackers",
	"Nuts",
	"Peanut butter",
	"Chocolate",
	"Apples",
	"Broccoli",
	"Sparkling water"
}
numCorrect = 0
total = 0
names={"Liam","William","Mason","James","Benjamin","Jacob","Michael","Noah"}
function GetRandom()
	if #items <= 1 then return end
	return table.remove(items,math.random(1,#items)),table.remove(items,math.random(1,#items))
end
goo=true
function Progress(cho,cc)
	if not cho then
		goo=true
		PushText("Jake: Don't worry I know you got this! People will come into the store and all you have to do is give them what they want. Good Luck!",function()
			goo=true
			PushText(test.mainENV["user"]..": Alright I think I got this!",mainLooper)
		end)
	else
		total=total+1
		if cc then
			multi:newThread("meh",function()
				goo2=true
				PushText2("Jake: Great job thats exactly what he wanted!",function() LETSDOIT=true end)
				thread.sleep(1)
				numCorrect=numCorrect+1
				thread.hold(function() return LETSDOIT end)
				LETSDOIT=false
				goo=true
			end)
		else
			multi:newThread("meh",function()
				goo2=true
				PushText2("Jake: Um that's the wrong item... Sorry about that sir!",function()
					thread.sleep(1)
					goo2=true
					PushText2(test.mainENV["user"]..": Opps sorry about that...!",function() thread.sleep(1) LETSDOIT=true end)
				end)
				thread.hold(function() return LETSDOIT end)
				LETSDOIT=false
				goo=true
			end)
		end
	end
end
function mainLooper()
	a,b=GetRandom()
	if not a then
		goo=true
		if numCorrect/total > .5 then
			STORE_CORRECT=true
		else
			STORE_CORRECT=false
		end
		core.game.store.Visible = false
	else
		ChoiceA.text=a
		ChoiceB.text=b
		c=math.random(1,2)
		if c==1 then
			ChoiceA.Correct = true
			ChoiceB.Correct = false
		else
			ChoiceB.Correct = true
			ChoiceA.Correct = false
		end
		plzwait=false
		PushText(names[math.random(1,#names)]..": Hello I would like...",mainLooper)
	end
end
ChoiceA:OnEnter(function(self)
	if self.Correct then
		face:SetImage("images/smile.png")
	else
		face:SetImage("images/sad.png")
	end
end)
ChoiceA:OnExit(function()
	face:SetImage("images/neutral.png")
end)
ChoiceB:OnEnter(function(self)
	if self.Correct then
		face:SetImage("images/smile.png")
	else
		face:SetImage("images/sad.png")
	end
end)
ChoiceB:OnExit(function()
	face:SetImage("images/neutral.png")
end)
plzwait=false
gui.massMutate({
	[[OnEnter(function(self)
		if not igmenu.Visible then
			self.TextColor=Color.Darken(self.TextColor,.35)
			menu_sound:play()
		end
	end)]],
	[[OnExit(function(self)
		self.TextColor=self.DefualtColor
	end)]],
	[[OnReleased(function(b,self)
		if not plzwait then
			Progress(self.text,self.Correct)
			plzwait=true
		end
	end)]],
	TextColor = Color.Lighten(Color.Yellow,.05),
	[[setNewFont(48,"fonts/zekton rg.ttf")]],
	[[setRoundness(10,10,360)]],
	DefualtColor = Color.Lighten(Color.Yellow,.05),
	Tween = 16,
	Color=Color.Black
},ChoiceA,ChoiceB)
function PushText(txt,callback)
	core.chatFrame.textHolder.text=""
	t={text=txt}
	multi:newThread("Store",function()
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
		end
		if Settings.auto_progress and core.chatFrame.textHolder.Visible then
			thread.sleep(1)
			enter_pressed = true
		end
		thread.hold(function() return (goo and igmenu.Visible == false) end)
		core.chatFrame.textHolder.text=""
		goo = false
		if callback then
			callback()
		end
	end)
end
function PushText2(txt,callback)
	core.chatFrame.textHolder.text=""
	t={text=txt}
	multi:newThread("Store",function()
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
		end
		if Settings.auto_progress and core.chatFrame.textHolder.Visible then
			thread.sleep(1)
			enter_pressed = true
		end
		thread.hold(function() return (goo2 and igmenu.Visible == false) end)
		goo2 = false
		if callback then
			callback()
		end
	end)
end
