package.path = "?/init.lua;"..package.path
--~ require("bin")
--~ dat = bin.load("savetest.dat")
--~ tab = dat:getBlock("t")
--~ print(dat:getBlock("s",128):match("(.+)\0"))
--~ for i,v in pairs(tab) do
--~ 	print(i,v)
--~ end
--~ function test(path)
--~ 	print("Doing stuff")
--~ 	local dat = love.image.newImageData(path)
--~ 	print("did it")
--~ 	return dat
--~ end
--~ io.write(string.dump(test))
print("loading lib")
require("multi")
multi.dStepA = 0
multi.dStepB = 0
multi.dSwap = 0
updater = multi:newUpdater(60)
updater:OnUpdate(function(self)
	if self.Parent.dSwap == 0 then
		self.Parent.dStepA = os.clock()
		self.Parent.dSwap = 1
	else
		self.Parent.dSwap = 0
		self.Parent.dStepB = os.clock()
	end
end)
function multi:getLoad()
	local val = math.abs(self.dStepA-self.dStepB)/updater.skip
	return (val)*100
end
multi:newTLoop(function(self)
	print(self.Parent:getLoad())
end,.1)
multi:newLoop(function()
	local a=0
	for i=1,1000000 do
		a=a+1
	end
end)
print("Started")
multi:mainloop()
