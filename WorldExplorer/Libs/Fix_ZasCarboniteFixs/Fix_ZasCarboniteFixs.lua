--======================================================================================================================================================
-- Fix: Zasurus' Carbonite fixes - Information & Instructions
--[[====================================================================================================================================================
	Origins:	 	I created this to fix carbonite's code as it doesn't allow you to control the
					colour of icon's added. I have posted on carbonite's forums asking if the TINY
					code change could be added (as it doesn't affect anything that doesn't pass the
					colour to the icon) but nobody has replied so until they fix it I have creted
					this small fix/library.
					
	Description: 	This replaces some of Carbonite's functions with an almost identical copy with
					a slight changes:
					
					1 - "Nx.Map:UpI(dNG)" changed from hard coded icon colours to use the icon
						colours you can already pass and are stored with the icon. If no colour
						is passed/stored then this function will work exactly the same as before.
					
					2 - "Nx.Map:IOMD(but)" changed so that it doesn't ignore right clicks on objects
						on the map that aren't valid types. Instead it clicks though them to the map
						below. I can't see this being a problem as before it did nothing on a right
						click on these objects and now it just lets the user access the map hidden
						behind the object!
					
					As this replaces some functions it could cause problems if another addon does
					the same or when Carbonite change that function and this fix isn't updated (or
					hopefully removed if they intergrate the surgested code change!). Therefore
					if you intend to use this in your code ether make sure you keep it up to date
					or contact me and I will send you updates for your addon every time I update it!
	
	
	Use: 	1 - Include this file and LibStub within your addon's folder with it's own lua files.
			
			2 - Add this file to your TOC file BEFORE the .lua files that will use it are loaded!
			
			-:NOTE:- ENSURE you ether KEEP THIS UP TO DATE OR contact me and tell me your using it
					and I will keep sending you updates when I make them until Carbonite is fixed!
					
					ALSO post on Carbonite's forum (find my post if you can under user Name "Zasurus")
					to say you also want the change so they know it's not just one person! :D
	
	================================================================================================
	HISTORY
	=============================================================================================================================================
	|CHANGED BY	| DATE			| VERSION    | DESCRIPTION OF CHANGE																			|
	|-------------------------------------------------------------------------------------------------------------------------------------------|
	|Zasurus	| 2010-07-04	| 0.1.0 Beta | First Version - Works with V3.340 of Carbonite													|
	|			| 2010-07-10	| 0.1.1 Beta | Fixed issues when Carbonite doesn't exist or isn't loaded										|
	|			| 2010-07-25	| 0.2.0 Beta | Replaced										|
	=============================================================================================================================================
======================================================================================================================================================]]

if (Nx) then -- Ensure that Carbonite exists
	function Nx.Map:UpI(dNG)
		local c2r1=Nx.U_21
		local c2r=Nx.U_22
		local d=self.Dat
		local wpS=1
		local wpM=self.GOp["MapIconScaleMin"]
		if wpM>=0 then
			wpS=self.ScD*.08
		end
		for type,v in pairs(d) do
			v.Ena=dNG or strbyte(type)==33
			if v.AtS then
				if self.ScD<v.AtS then
					v.Ena=false
				end
			end
		end
		for k,v in pairs(d) do
			if v.Ena then
				if v.DrM=="ZP" then
					local sca=self.IcS*v.Sca*self.ScD
					local w=v.W*sca
					local h=v.H*sca
					for n=1,v.Num do
						local ico=v[n]
						local f=self:GIS(v.Lvl)
						if self:CFZ(f,ico.X,ico.Y,w,h,0) then
							f.NxT=ico.Tip
							if ico.Tex1 then
								f.tex:SetTexture(ico.Tex1)
							elseif v.Tex1 then
								f.tex:SetTexture(v.Tex1)
							else
								f.tex:SetTexture(c2r1(ico.Col1))
							end
						end
					end
				elseif v.DrM=="WP" then
					local sca=self.IcS*v.Sca*wpS
					local w=max(v.W*sca,wpM)
					local h=max(v.H*sca,wpM)
					if v.AlN then
						local aNe=v.AlN*(abs(GetTime() % .7-.35)/.7+.5)
						for n=1,v.Num do
							local ico=v[n]
							local f=self:GIS(v.Lvl)
							if v.ClF1(self,f,ico.X,ico.Y,w,h,0) then
								f.NxT=ico.Tip
								f.NXType=3000
								f.NXData=ico
								if ico.Tex1 then
									f.tex:SetTexture(ico.Tex1)
								elseif v.Tex1 then
									f.tex:SetTexture(v.Tex1)
								else
									f.tex:SetTexture(c2r1(ico.Col1))
								end
								local a=v.Alp
								local dis=(ico.X-self.PlX) ^ 2+(ico.Y-self.PlY) ^ 2
								if dis<306 then
									a=aNe
								end
								f.tex:SetVertexColor(1,1,1,a)
							end
						end
					else
						for n=1,v.Num do
							local ico=v[n]
							local f=self:GIS(v.Lvl)
							if v.ClF1(self,f,ico.X,ico.Y,w,h,0) then
								f.NxT=ico.Tip
								f.NXType=3000
								f.NXData=ico
								if ico.Tex1 then
									f.tex:SetTexture(ico.Tex1)
								elseif v.Tex1 then
									f.tex:SetTexture(v.Tex1)
								else
									f.tex:SetTexture(c2r1(ico.Col1))
								end
								local r,g,b = 1,1,1
								if (ico.Col1) then
									r,g,b = c2r1(ico.Col1)
								end;
								if v.Alp then
									f.tex:SetVertexColor(r,g,b,v.Alp)
								end
							end
						end
					end
				elseif v.DrM=="ZR" then
					local x,y,x2,y2
					for n=1,v.Num do
						local ico=v[n]
						local f=self:GIS(v.Lvl)
						f.NxT=ico.Tip
						
						x,y=self:GWP(ico.MaI,ico.X,ico.Y)
						x2,y2=self:GWP(ico.MaI,ico.X2,ico.Y2)
						if self:CFTL(f,x,y,x2-x,y2-y) then
							if v.Tex2 then
								f.tex:SetTexture(v.Tex1)
							else
								f.tex:SetTexture(c2r(ico.Col1))
							end
						end
					end
				end
			end
		end
	end
	
	function Nx.Map:IOMD(but) -- Mouse button pressed DOWN on a rectange over the map
		local map=this.NxM1
		
		map:CaC3()
		map.ClF=this
		map.ClT2=this.NXType
		map.ClI=this.NXData
		
		local shi=IsShiftKeyDown()
		
		if but=="LeftButton" then
			local cat1=floor((this.NXType or 0)/1000)
			
			if cat1==2 and shi then
				if map.BGIN>0 then
					local _,_,_,str=strsplit("~",map.BGM)
					local _,_,_,st2=strsplit("~",this.NXData)
					if str~=st2 then
						Nx.Tim:Fir("BGInc")
					end
				end
				
				map.BGM=this.NXData
				map.BGIN=map.BGIN+1
				UIErrorsFrame:AddMessage("Inc " .. map.BGIN,1,1,1,1)
				Nx.Tim:Sta("BGInc",1.5,map,map.BGIST)
			else
				if map:IDC() then
					if cat1==3 then
						map:GM_OG()
					end
				else
					this=map.Frm
					map:OMD(but)
				end
			end
		else
			if but=="RightButton" then
				local typ=this.NXType
				
				if typ then
					local i=floor(typ/1000)
					
					if i==1 then
						map:BPL()
						map.PIM:Ope()
					elseif i==2 then
						Nx.Tim:Fir("BGInc")
						map.BGM=this.NXData
						map.BGIM:Ope()
					elseif i==3 then
						map:GMO(this.NXData,typ)
					elseif i==9 then
						Nx.Que:IOMD(this)
					end
				else -- Else this isn't anthing significant so ignore it and just click the map below!
					this=map.Frm
					map:OMD(but)
				end
			else
				this=map.Frm
				map:OMD(but)
			end
		end
	end
end;