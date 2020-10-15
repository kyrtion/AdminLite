script_name('AdminLite')
script_author('kyrtion')
script_version('1.4')
script_version_number(5)
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
require 					'lib.moonloader'
require 					'lib.sampfuncs'
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
local memory        		= require 'memory'
local sampev        		= require 'lib.samp.events'
local imgui         		= require 'imgui'
local encoding      		= require 'encoding'
local inicfg        		= require 'inicfg'
local Matrix3X3 			= require 'matrix3x3'
local Vector3D 				= require 'vector3d'
encoding.default    		= 'cp1251'
u8                  		= encoding.UTF8
--.--.--.--.--.--.--.--.--.--.--.--.--.--.--
local mx, my        		= getScreenResolution()
local result 				= ''
local fe_locked 			= false

-->>| Сategories: Ini and Config |<<-- INI CONFIG -- INI CONFIG -- INI CONFIG -- INI CONFIG -- INI CONFIG -- INI CONFIG -- INI CONFIG 
local ini = inicfg.load({
    --| Personal Info |--
    account = {
        password     		= '',
        autoPass     		= false,
        alogin       		= '',
        autoAlogin   		= false,
        -- pin       		   = '',
        startmsg     		= true
    },
    --| Cheats |--
    cheat = {
        wallhack     		= false,
        camhack      		= false,
		camhackchat  		= false,
		nofall 	 	 		= false,
		-- clickwarp			 = false,
		farchat 	 		= false,
		fisheye 	 		= false,
		--
		godmode 	 		= false,
		igodmode 	 		= false,
		--		
		airbreak 	 		= false,
		s_airbreak	 		= 1,
		--		
		speedhack 	 		= false,
		s_speedhack  		= 150.0
	},
	other = {
		color_main ='40E0D0'
	}
 }, 'adminlite')
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|

--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
-->>| Сategories: Local |<<--
 --| Personal Information |--
  local nick              	= imgui.ImBuffer(tostring(ini.account.nick), 256)
  local password          	= imgui.ImBuffer(tostring(ini.account.password), 256)
  local alogin            	= imgui.ImBuffer(tostring(ini.account.alogin), 256)
  local inputBufferText 	= imgui.ImBuffer(256)
  -- local pin               	= imgui.ImBuffer(tostring(ini.account.pin), 256)
 --| CheckBox |--
  local startmsg          	= imgui.ImBool(ini.account.startmsg)
  local autoAlogin        	= imgui.ImBool(ini.account.autoAlogin)
  local autoPass          	= imgui.ImBool(ini.account.autoPass)
 --| Cheats |--
  local AirBreak          	= imgui.ImBool(ini.cheat.airbreak)
  local WallHack          	= imgui.ImBool(ini.cheat.wallhack)
  local CamHack           	= imgui.ImBool(ini.cheat.camhack)
  local NoFall			 	= imgui.ImBool(ini.cheat.nofall)
  local GodMode 			= imgui.ImBool(ini.cheat.godmode)
  local IGodMode			= imgui.ImBool(ini.cheat.igodmode)
  local SpeedHack		 	= imgui.ImBool(ini.cheat.speedhack)
  local FishEye				= imgui.ImBool(ini.cheat.fisheye)
--   local ClickWarp		 	= imgui.ImBool(ini.cheat.clickwarp)
  local FarChat 			= imgui.ImBool(ini.cheat.farchat)
 --| Windows |--
  local own           		= imgui.ImBool(false)
  local two           		= imgui.ImBool(false)
  local calc 		 		= imgui.ImBool(false)
  -- local test 				= imgui.ImBool(false)
--  local result, id = sampGetPlayerIdByCharHandle(playerPed) local nick = sampGetPlayerNickname(id)
tick = {Keys = {Up = 0, Down = 0, Plus = 0, Minus = 0, Num = {Plus = 0, Minus = 0}}, Fps = 0, Notification = 0, CoordsMaster = 0, ClickWarp = 0, Time = {Up = 165, Down = 165, PlusMinus = 150, NumPlusMinus = 150}}
arrows = {0, 1, 2, 3, 4}
cheat = {}
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|

-->>| Сategories: News |<<--      SHABLON: --| Version: *.* |--
 --| Version: 1.4 |--
  local upd5 = [[
  - Добавлен калькулятор, команда /calc.]]

 --| Version: 1.3 |--
  local upd4 = [[
  - Теперь авто заход в админку сам авторизуется, в категории [Аккаунт].
  - Добавлены список в категории [Читы]:
 	• AirBreak,
 	• FarChat,
 	• GodMode,
 	• InfinityGodMode,
 	• SpeedHack,
 	• NoFall,
    • CamHack.
  - Все тексты превратили в спойлер на категории [Новости].
  - Изменены направление и название, а также описание.
  - Исправление багов (Auto-пароль, Auto-alogin).
  - Добавлены значок (?) - описание скрипта и другие, а также активиация.]] -- • ClickWarp,

 --| Version: 1.2 |--
  local upd3 = [[
  - Добавлен чит в категории [Читы]:
    • WallHack.
  - Добавлен кнопка 'Баг-репорт и предложение [VK]']]

 --| Version: 1.1 |--
  local upd2 = [[
  - Добавлены кнопки в категории [Авторизация]:
    • Авто-ввод пароля,
    • Авто заход в админку,
    • Стартовое сообщение.
  - Исправление багов
  ! Скоро будут добавлены 'Читы'
    / WallHack,
    / AirBreak.]]
 
 --| Version: 1.0 |--
  local upd1 = [[
  - День создания скрипта, первые тесты!]]

--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
--| ImGui Color |--
-- function apply_custom_style()
--     -- imgui.SwitchContext()
--     local a = imgui.GetStyle()
--     local b = a.Colors
--     local c = imgui.Col
--     local d = imgui.ImVec4
--     a.WindowTitleAlign=imgui.ImVec2(0.5,0.5)
--     b[c.WindowBg]=d(0.13,0.13,0.13,1.00)
-- end
-- apply_custom_style() -- Закрашивание

-->>| Сategories: Main |<<--
function main()
	if not isSampfuncsLoaded() or not isCleoLoaded() or not isSampLoaded() then
		return
	end
	font22 = renderCreateFont('Verdana', 10, 9)
	font11 = renderCreateFont('Verdana', 6, 4)


	initializeRender()
	while not isSampAvailable() do
		wait(1000)
	end

	-->>| Сategories: AutoLogin |<<--
	if ini.account.startmsg then
        sampAddChatMessage('{fcfa1a}[AdminLite]{ffffff}: Скрипт успешно загружен. Версия: {fcfa1a}'..thisScript().version..'{FFFFFF}.', -1)
        sampAddChatMessage('{fcfa1a}[AdminLite]{ffffff}: Автор - {fcfa1a}kyrtion{FFFFFF}. Выключить данное сообщение можно в {fcfa1a}/alite{FFFFFF}.', -1)
        --sampAddChatMessage('{fcfa1a}[AdminLite]{ffffff}: Скрипты успешны загружены! Автор: kyrtion. Версия: 1', -1)
    end
    -- apply_custom_style() -- Change color and thems

    -->>| Categories: Register Chat Command |<<--
	sampRegisterChatCommand('alite', cmd_alite)
	sampRegisterChatCommand('calc', cmd_calc)
	-- sampRegisterChatCommand('test', cmd_test)
    --| Cheat: Info For CamHack |--
    chFlymode = 0  
	chSpeed = 1.0
	chRadarHud = 0
	chTime = 0
	chKeyPressed = 0

	imgui.Process = false

	while true do
	--| while true do |--
    --| Wait(0) |--
		wait(0)
		if own.v or calc.v then -- test.v
			imgui.Process = true
			imgui.LockPlayer = true
			imgui.ShowCursor = true
			showCursor(true)
		-- elseif stats.v then
		-- 	imgui.ShowCursor = false
		-- 	imgui.Process = true
		else
			imgui.Process = false
			imgui.LockPlayer = false
			imgui.ShowCursor = false
			showCursor(false)
		end



		check_keystrokes()
		fast_funcs_work()
		main_funcs()
		secondary_funcs()
		fps_correction()






		
        --| Cheat: CamHack |-- < Author: sanek a.k.a Maks_Fender, edited by ANIKI >
        if ini.cheat.camhack then
            chTime = chTime + 1
		    if isKeyDown(VK_C) and isKeyDown(VK_1) then
			    if chFlymode == 0 then
				    --setPlayerControl(playerchar, false)
				    displayRadar(false)
				    displayHud(false)	    
				    chPosX, chPosY, chPosZ = getCharCoordinates(playerPed)
				    chAngZ = getCharHeading(playerPed)
				    chAngZ = chAngZ * -1.0
				    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
				    chAngY = 0.0
				    --freezeCharPosition(playerPed, false)
				    --setCharProofs(playerPed, 1, 1, 1, 1, 1)
				    --setCharCollision(playerPed, false)
				    lockPlayerControl(true)
				    chFlymode = 1
                --	sampSendChat('/anim 35')
                end
            end
		    if chFlymode == 1 and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
			    chOffMouX, chOffMouY = getPcMouseMovement()  
			  
			    chOffMouX = chOffMouX / 4.0
			    chOffMouY = chOffMouY / 4.0
			    chAngZ = chAngZ + chOffMouX
			    chAngY = chAngY + chOffMouY

			    if chAngZ > 360.0 then chAngZ = chAngZ - 360.0 end
			    if chAngZ < 0.0 then chAngZ = chAngZ + 360.0 end

			    if chAngY > 89.0 then chAngY = 89.0 end
			    if chAngY < -89.0 then chAngY = -89.0 end   

			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
			    chSinY = math.sin(chRadY)
    			chCosY = math.cos(chRadY)       
	    		chSinZ = chSinZ * chCosY      
		    	chCosZ = chCosZ * chCosY 
			    chSinZ = chSinZ * 1.0      
    			chCosZ = chCosZ * 1.0     
	    		chSinY = chSinY * 1.0        
		    	chPoiX = chPosX
			    chPoiY = chPosY
    			chPoiZ = chPosZ      
	    		chPoiX = chPoiX + chSinZ 
		    	chPoiY = chPoiY + chCosZ 
			    chPoiZ = chPoiZ + chSinY      
    			pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)

    			chCurZ = chAngZ + 180.0
	    		chCurY = chAngY * -1.0      
		    	chRadZ = math.rad(chCurZ) 
			    chRadY = math.rad(chCurY)                   
    			chSinZ = math.sin(chRadZ)
	    		chCosZ = math.cos(chRadZ)      
		    	chSinY = math.sin(chRadY)
			    chCosY = math.cos(chRadY)       
    			chSinZ = chSinZ * chCosY      
	    		chCosZ = chCosZ * chCosY 
		    	chSinZ = chSinZ * 10.0     
			    chCosZ = chCosZ * 10.0       
    			chSinY = chSinY * 10.0                       
	    		chPosPlX = chPosX + chSinZ 
		    	chPosPlY = chPosY + chCosZ 
			    chPosPlZ = chPosZ + chSinY              
    			ch = chAngZ * -1.0
	    		--setCharHeading(playerPed, ch)

    			chRadZ = math.rad(chAngZ) 
	    		chRadY = math.rad(chAngY)             
		    	chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
    			chSinY = math.sin(chRadY)
	    		chCosY = math.cos(chRadY)       
		    	chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
    			chSinZ = chSinZ * 1.0      
	    		chCosZ = chCosZ * 1.0     
		    	chSinY = chSinY * 1.0        
			    chPoiX = chPosX
    			chPoiY = chPosY
	    		chPoiZ = chPosZ      
		    	chPoiX = chPoiX + chSinZ 
			    chPoiY = chPoiY + chCosZ 
    			chPoiZ = chPoiZ + chSinY      
	    		pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)

    			if isKeyDown(VK_W) then      
	    			chRadZ = math.rad(chAngZ) 
		    		chRadY = math.rad(chAngY)                   
			    	chSinZ = math.sin(chRadZ)
				    chCosZ = math.cos(chRadZ)      
    				chSinY = math.sin(chRadY)
	    			chCosY = math.cos(chRadY)       
		    		chSinZ = chSinZ * chCosY      
			    	chCosZ = chCosZ * chCosY 
				    chSinZ = chSinZ * chSpeed      
    				chCosZ = chCosZ * chSpeed       
	    			chSinY = chSinY * chSpeed  
		    		chPosX = chPosX + chSinZ 
			    	chPosY = chPosY + chCosZ 
				    chPosZ = chPosZ + chSinY      
    				setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)      
	    		end 
    			chRadZ = math.rad(chAngZ) 
	    		chRadY = math.rad(chAngY)             
		    	chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
    			chSinY = math.sin(chRadY)
	    		chCosY = math.cos(chRadY)       
		    	chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
    			chSinZ = chSinZ * 1.0      
	    		chCosZ = chCosZ * 1.0     
		    	chSinY = chSinY * 1.0         
			    chPoiX = chPosX
    			chPoiY = chPosY
	    		chPoiZ = chPosZ      
		    	chPoiX = chPoiX + chSinZ 
    			chPoiY = chPoiY + chCosZ 
	    		chPoiZ = chPoiZ + chSinY      
		    	pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)
			    if isKeyDown(VK_S) then  
				    chCurZ = chAngZ + 180.0
				    chCurY = chAngY * -1.0      
				    chRadZ = math.rad(chCurZ) 
				    chRadY = math.rad(chCurY)                   
				    chSinZ = math.sin(chRadZ)
				    chCosZ = math.cos(chRadZ)      
				    chSinY = math.sin(chRadY)
				    chCosY = math.cos(chRadY)       
				    chSinZ = chSinZ * chCosY      
				    chCosZ = chCosZ * chCosY 
				    chSinZ = chSinZ * chSpeed      
				    chCosZ = chCosZ * chSpeed       
				    chSinY = chSinY * chSpeed                       
				    chPosX = chPosX + chSinZ 
				    chPosY = chPosY + chCosZ 
				    chPosZ = chPosZ + chSinY      
                    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
                end 
			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
			    chSinY = math.sin(chRadY)
			    chCosY = math.cos(chRadY)       
			    chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
			    chSinZ = chSinZ * 1.0      
			    chCosZ = chCosZ * 1.0     
			    chSinY = chSinY * 1.0        
			    chPoiX = chPosX
			    chPoiY = chPosY
			    chPoiZ = chPosZ      
			    chPoiX = chPoiX + chSinZ 
			    chPoiY = chPoiY + chCosZ 
			    chPoiZ = chPoiZ + chSinY      
			    pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)
			    if isKeyDown(VK_A) then  
				    chCurZ = chAngZ - 90.0
				    chRadZ = math.rad(chCurZ)
				    chRadY = math.rad(chAngY)
				    chSinZ = math.sin(chRadZ)
				    chCosZ = math.cos(chRadZ)
				    chSinZ = chSinZ * chSpeed
				    chCosZ = chCosZ * chSpeed
				    chPosX = chPosX + chSinZ
				    chPosY = chPosY + chCosZ
                    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
                end 
			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
			    chSinY = math.sin(chRadY)
			    chCosY = math.cos(chRadY)       
			    chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
			    chSinZ = chSinZ * 1.0      
			    chCosZ = chCosZ * 1.0     
			    chSinY = chSinY * 1.0        
			    chPoiX = chPosX
			    chPoiY = chPosY
			    chPoiZ = chPosZ      
			    chPoiX = chPoiX + chSinZ 
			    chPoiY = chPoiY + chCosZ 
			    chPoiZ = chPoiZ + chSinY
			    pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)       
			    if isKeyDown(VK_D) then  
				    chCurZ = chAngZ + 90.0
				    chRadZ = math.rad(chCurZ)
				    chRadY = math.rad(chAngY)
				    chSinZ = math.sin(chRadZ)
				    chCosZ = math.cos(chRadZ)       
				    chSinZ = chSinZ * chSpeed
				    chCosZ = chCosZ * chSpeed
				    chPosX = chPosX + chSinZ
				    chPosY = chPosY + chCosZ      
                    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
                end 
			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
			    chSinY = math.sin(chRadY)
			    chCosY = math.cos(chRadY)       
			    chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
			    chSinZ = chSinZ * 1.0      
			    chCosZ = chCosZ * 1.0     
			    chSinY = chSinY * 1.0        
			    chPoiX = chPosX
			    chPoiY = chPosY
			    chPoiZ = chPosZ      
			    chPoiX = chPoiX + chSinZ 
			    chPoiY = chPoiY + chCosZ 
			    chPoiZ = chPoiZ + chSinY      
			    pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2)   
			    if isKeyDown(VK_SPACE) then  
				    chPosZ = chPosZ + chSpeed
                    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
                end 
			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
			    chSinY = math.sin(chRadY)
			    chCosY = math.cos(chRadY)       
			    chSinZ = chSinZ * chCosY      
			    chCosZ = chCosZ * chCosY 
			    chSinZ = chSinZ * 1.0      
			    chCosZ = chCosZ * 1.0     
			    chSinY = chSinY * 1.0       
			    chPoiX = chPosX
			    chPoiY = chPosY
			    chPoiZ = chPosZ      
			    chPoiX = chPoiX + chSinZ 
			    chPoiY = chPoiY + chCosZ 
			    chPoiZ = chPoiZ + chSinY      
			    pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2) 
			    if isKeyDown(VK_SHIFT) then  
				    chPosZ = chPosZ - chSpeed
                    setFixedCameraPosition(chPosX, chPosY, chPosZ, 0.0, 0.0, 0.0)
                end
			    chRadZ = math.rad(chAngZ) 
			    chRadY = math.rad(chAngY)             
			    chSinZ = math.sin(chRadZ)
			    chCosZ = math.cos(chRadZ)      
		    	chSinY = math.sin(chRadY)
		    	chCosY = math.cos(chRadY)       
		    	chSinZ = chSinZ * chCosY      
		    	chCosZ = chCosZ * chCosY 
		    	chSinZ = chSinZ * 1.0      
		    	chCosZ = chCosZ * 1.0     
		    	chSinY = chSinY * 1.0       
		    	chPoiX = chPosX
		    	chPoiY = chPosY
		    	chPoiZ = chPosZ      
		    	chPoiX = chPoiX + chSinZ 
		    	chPoiY = chPoiY + chCosZ 
		    	chPoiZ = chPoiZ + chSinY      
		    	pointCameraAtPoint(chPoiX, chPoiY, chPoiZ, 2) 
			    if chKeyPressed == 0 and isKeyDown(VK_F10) then
				    chKeyPressed = 1
				    if chRadarHud == 0 then
					    displayRadar(true)
					    displayHud(true)
                        chRadarHud = 1
                    else
					    displayRadar(false)
					    displayHud(false)
					    chRadarHud = 0
				    end
			    end
			    if wasKeyReleased(VK_F10) and chKeyPressed == 1 then chKeyPressed = 0 end
			    if isKeyDown(187) then 
				    chSpeed = chSpeed + 0.01
				    printStringNow('CamHack: '..chSpeed, 1000)
			    end             
			    if isKeyDown(189) then 
				    chSpeed = chSpeed - 0.01 
				    if chSpeed < 0.01 then chSpeed = 0.01 end
                    printStringNow(chSpeed, 1000)
                end 
			    if isKeyDown(VK_C) and isKeyDown(VK_2) then
				    --setPlayerControl(playerchar, true)
				    displayRadar(true)
			        displayHud(true)
			        chRadarHud = 0	    
			        ch = chAngZ * -1.0
			        --setCharHeading(playerPed, ch)
			        --freezeCharPosition(playerPed, false)
			        lockPlayerControl(false)
			        --setCharProofs(playerPed, 0, 0, 0, 0, 0)
			        --setCharCollision(playerPed, true)
			        restoreCameraJumpcut()
			        setCameraBehindPlayer()
			        chFlymode = 0     
		        end
         -- Cheat: CamHack <End> --
            end
		end
	end
end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|

-->>| Сategories: ImGui |<<--
function imgui.OnDrawFrame()
	
	--| Window: own |--
	if own.v then
        imgui.SetNextWindowPos(imgui.ImVec2(mx/3, my/3), imgui.Cond.FirstUseEver)
	    imgui.SetNextWindowSize(imgui.ImVec2(420, 300), imgui.Cond.FirstUseEver)
        imgui.Begin('AdminLite v'..thisScript().version, own, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) --  imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse
		
        --imgui.Begin(u8'F.A.Q', imguifaq, imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoSavedSettings + imgui.WindowFlags.NoCollapse)
		
		
		-->>| Spoiler: Settings |<<--
        if imgui.CollapsingHeader(u8'Настройки') then


            -->>| Spoiler: AutoLogins |<<--
			if imgui.CollapsingHeader(u8'Авторизация') then
				-- imgui.Text(u8'Ваш ник')
				ShowHelpMarker('< Присоединение на сервере выдаётся первый диалог для пароля от аккаунта')
				imgui.Text(u8'Пароль от аккаунта')
				imgui.SameLine()
				imgui.InputText('##pass1', password, imgui.InputTextFlags.Password)

				ShowHelpMarker('< С помощью командой /alogin выдаётся диалог для пароля от админки')
				imgui.Text(u8'Пароль от админки')
				imgui.SameLine(0,10)
				imgui.InputText('##alogin1', alogin, imgui.InputTextFlags.Password)

				ShowHelpMarker('< Автоматическое вводит пароль от аккаунта') --| Dialog ID = 0 |--
				imgui.Checkbox(u8'Авто-ввод пароля от аккаунта', autoPass)

				ShowHelpMarker('< Автоматическое вводит пароль от админки') --| Dialog ID = 87 |--
				imgui.Checkbox(u8'Авто заход в админку', autoAlogin)
				
				ShowHelpMarker('< Каждый запуск скрипта выдаётся сообщение, что вы запустили + версия')
				imgui.Checkbox(u8'Стартовое сообщение', startmsg)

                --| Button: Save |--
                if imgui.Button(u8'Сохранить') then
                    ini.account.password    = password.v
                    ini.account.autoPass    = autoPass.v
                    ini.account.alogin      = alogin.v
                    ini.account.autoAlogin  = autoAlogin.v
                    -- ini.account.pin         = pin.v
                    ini.account.startmsg    = startmsg.v
                    inicfg.save(ini, 'adminlite')
                    sampAddChatMessage('{fcfa1a}[AdminLite]{ffffff}: Успешны сохранены!', -1)
				end
            end
        end
        imgui.Separator()


     -->>| Spoiler: Cheats |<<--
		if imgui.CollapsingHeader(u8'Читы') then
			


			--| Cheat: AirBreak |--
			ShowHelpMarker([[< АирБрейк [АБ]

	 [?] Полёт сквозь, и на стене в любом виде`
	 [+] Работает на машине и персонаж
	 [#] Активация: RShift (правый Shift)
	 [#] Управление:
	 [#] WASD, стрелки вверх/вниз -- Движение]])
			if imgui.Checkbox(u8'AirBreak', AirBreak) then
				ini.cheat.airbreak = AirBreak.v
                inicfg.save(ini, 'adminlite')
			end
			


			--| Cheat: FarChat |--
			ShowHelpMarker([[< ДальнийЧат [ДЧ]

	 [?] Показывает у всех текст над головой у игроками
	 [+] Также работает CamHack
	 [#] Активация: Автоматическое]])
            if imgui.Checkbox(u8'FarChat', FarChat) then
				ini.cheat.farchat = FarChat.v
                inicfg.save(ini, 'adminlite')
			end
			



			--| Cheat: WallHack|--	
			ShowHelpMarker([[< ВаллХак [ВХ]

	 [?] Показывает у всех никнеймы только на стриме
	 [#] Активация: Автоматическое]])
			if imgui.Checkbox(u8'WallHack', WallHack) then
                ini.cheat.wallhack = WallHack.v
                inicfg.save(ini, 'adminlite')
			end
			



			--| Cheat: GodMode |--
			ShowHelpMarker([[< ГодМод [ГМ]

	 [?] Бессмертный персонаж
	 [+] Чит работает на машине и на пешком
	 [#] Активация: Insert (Ins)]])
			if imgui.Checkbox(u8'GodMode', GodMode) then
				ini.cheat.godmode = GodMode.v
				inicfg.save(ini, 'adminlite')
			end
			


			--| Cheat: InfinityGodMode |--
			ShowHelpMarker([[< БескончныйГодМод [ПГМ]

	 [?] Бессмертный персонаж без активации
	 [+] Чит работает на машине и на пешком, также при присоединение на сервере
	 [#] Активация: Автоматическое
	 [!] Внимание! Если вы включите InfinityGodMode и GodMode - появится ошибки/вылеты!]])
			if imgui.Checkbox(u8'InfinityGodMode', IGodMode) then
				ini.cheat.igodmode = IGodMode.v
				inicfg.save(ini, 'adminlite')
			end
			


	 -- 		--| Cheat: ClickWarp |--
	 -- 		ShowHelpMarker([[< КликВарп [КВ]
 
	 --  [?] Телепортирует в любом виде
	 --  [-] Чит работает только на машине
	 --  [#] Активация: RButton (кнопка колёсика)
	 --  [#] Управление:
	 --  [#] LShift + -/+ -- Уменьшить/увеличить 
	 --  [!] Управление работает только на машине]])
	 -- 		if imgui.Checkbox(u8'ClickWarp', ClickWarp) then
	 -- 			ini.cheat.clickwarp = ClickWarp.v
     --             inicfg.save(ini, 'adminlite')
	 -- 		end
			


			--| Cheat: SpeedHack |--
			ShowHelpMarker([[< СпидХак [СХ]

	 [?] Быстро перемещает машину с помощью скоростью
	 [-] Чит и управление работает только на машине
	 [#] Активация: LAlt (левый Alt)
	 [#] Управление:
	 [#] LShift + -/+ -- Уменьшить/увеличить скорость]])
			if imgui.Checkbox(u8'SpeedHack', SpeedHack) then
				ini.cheat.speedhack = SpeedHack.v
                inicfg.save(ini, 'adminlite')
			end
			


			--| Cheat: NoFall |--
			ShowHelpMarker([[< АнтиПадение [АФ]

	 [?] Убирает анимация при получение урона от падении
	 [#] Активация: Автоматическое]])
			if imgui.Checkbox(u8'NoFall', NoFall) then
                ini.cheat.nofall = NoFall.v
				inicfg.save(ini, 'adminlite')
			end


			--| Cheat: FishEye |--
			ShowHelpMarker([[< Рыбной глаз [РГ]

	 [?] Увеличивает градиусов экрана, которые вы смотрите
	 [#] Активация: Автоматическое]])
			if imgui.Checkbox(u8'FishEye', FishEye) then
				ini.cheat.fisheye = FishEye.v
				inicfg.save(ini, 'adminlite')
			end
			


			--| Cheat: CamHack |--
			ShowHelpMarker([[< Свободная камера [КХ]

	 [?] Включает камера и видно игроками только на стриме
	 [#] Активация: C + 1 -- ВКЛЮЧИТЬ | C + 2 -- ВЫКЛЮЧИТЬ
	 [#] Управление:
	 [#] WASD -- Движение
	 [#] -/+ -- Уменьшить/увеличить скорость]])
            if imgui.Checkbox(u8'CamHack', CamHack) then
                ini.cheat.camhack = CamHack.v
                inicfg.save(ini, 'adminlite')
			end
			


	 --  		--| Cheat: CamHack-Chat |--
	 -- 		 ShowHelpMarker([[< Свободная камера с чатом над головой [??]
	 		 
	 --  [?] Показывается у всех над головой текст, при включение CamHack
	 --  [#] Активация: Автоматическое
	 --  [!] Требование: CamHack]])
     --          if imgui.Checkbox(u8'CamHack-Chat', CamHackChat) then
	 --  			ini.cheat.camhackchat = CamHackChat.v
     --              inicfg.save(ini, 'adminlite')
	 --  		end
	 		
		end
		imgui.Separator()



		-->>| Spoiler: News |<<--
        if imgui.CollapsingHeader(u8'Новости') then
            if imgui.CollapsingHeader(u8'19.05.2020 | Версия: 1.3 | kyrtion') then
                imgui.Text(u8(upd4))
            end 
            if imgui.CollapsingHeader(u8'16.05.2020 | Версия: 1.2 | kyrtion') then
                imgui.Text(u8(upd3))
            end 
            if imgui.CollapsingHeader(u8'15.05.2020 | Версия: 1.1 | kyrtion') then
                imgui.Text(u8(upd2))
            end 
            if imgui.CollapsingHeader(u8'11.05.2020 | Версия: 1.0 | kyrtion') then
                imgui.Text(u8(upd1))
            end 
        end 
        imgui.Separator()


        if imgui.Button(u8'Баг-репорт и предложение [VK]') then
            os.execute('explorer "https://vk.com/kyrtion"')
		end

		imgui.End()
	end

	--| Window: calc |--
	if calc.v then
        imgui.SetNextWindowSize(imgui.ImVec2(250, 250), imgui.Cond.FirstUseEver)
        imgui.SetNextWindowPos(imgui.ImVec2(mx/2, my/2), imgui.Cond.FirstUseEver)
        imgui.Begin(u8'Special for AdminLite '..thisScript().version, calc, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
		-- imgui.BeginChild('##calc2', imgui.ImVec2(mx/5.6, my/3.4), true)
        imgui.Text(result)
        imgui.InputText('##calc3', inputBufferText)
        if imgui.Button('9', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s9', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('8', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s8', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('7', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s7', inputBufferText.v)
        end
		imgui.SameLine()
		if imgui.Button('/', imgui.ImVec2(40, 40)) then
			local bufferFirstNum, bufferAct = result:match('(%d+)(.+)')
			if tonumber(bufferFirstNum) then
				local numResult = tonumber(bufferFirstNum) / tonumber(inputBufferText.v)
				result = string.format('%s/', tostring(numResult))
				inputBufferText.v = ''
			else
				result = string.format('%s/', inputBufferText.v)
				inputBufferText.v = ''
			end
		end
		imgui.SameLine()
		if imgui.Button('CLR', imgui.ImVec2(40, 40)) then
            inputBufferText.v = ''
			result = ''
        end
		--imgui.SameLine()
        if imgui.Button('6', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s6', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('5', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s5', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('4', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s4', inputBufferText.v)
        end
		imgui.SameLine()
		if imgui.Button('*', imgui.ImVec2(40, 40)) then
			local bufferFirstNum, bufferAct = result:match('(%d+)(.+)')
			if tonumber(bufferFirstNum) then
				local numResult = tonumber(bufferFirstNum) * tonumber(inputBufferText.v)
				result = string.format('%s*', tostring(numResult))
				inputBufferText.v = ''
			else
				result = string.format('%s*', inputBufferText.v)
				inputBufferText.v = ''
			end
        end
		imgui.SameLine()
		if imgui.Button('SQRT', imgui.ImVec2(40, 40)) then
			if tonumber(inputBufferText.v) then
				local bufferResult = math.sqrt(tonumber(inputBufferText.v))
				result = tostring(bufferResult)
			end
		end
        if imgui.Button('3', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s3', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('2', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s2', inputBufferText.v)
        end
        imgui.SameLine()
        if imgui.Button('1', imgui.ImVec2(40, 40)) then
            inputBufferText.v = string.format('%s1', inputBufferText.v)
        end
		imgui.SameLine()
		if imgui.Button('-', imgui.ImVec2(40, 40)) then
            local bufferFirstNum, bufferAct = result:match('(%d+)(.+)')
			if tonumber(bufferFirstNum) then
				local numResult = tonumber(bufferFirstNum) - tonumber(inputBufferText.v)
				result = string.format('%s-', tostring(numResult))
				inputBufferText.v = ''
			else
				result = string.format('%s-', inputBufferText.v)
				inputBufferText.v = ''
			end
        end
		imgui.SameLine()
		if imgui.Button('^', imgui.ImVec2(40, 40)) then
			result = string.format('%s^', inputBufferText.v)
			inputBufferText.v = ''
		end
		if imgui.Button('0', imgui.ImVec2(88, 40)) then
            inputBufferText.v = string.format('%s0', inputBufferText.v)
        end
		imgui.SameLine()
		if imgui.Button('+', imgui.ImVec2(40, 40)) then
			local bufferFirstNum, bufferAct = result:match('(%d+)(.+)')
			if tonumber(bufferFirstNum) then
				local numResult = tonumber(bufferFirstNum) + tonumber(inputBufferText.v)
				result = string.format('%s+', tostring(numResult))
				inputBufferText.v = ''
			else
				result = string.format('%s+', inputBufferText.v)
				inputBufferText.v = ''
			end
        end
		imgui.SameLine()
		if imgui.Button('=', imgui.ImVec2(88, 40)) then
			local bufferFirstNum, bufferAct = result:match('(%d+)(.+)')
			if bufferAct == '+' then
				local numResult = tonumber(bufferFirstNum) + tonumber(inputBufferText.v)
				result = tostring(numResult)
			elseif bufferAct == '-' then
				local numResult = tonumber(bufferFirstNum) - tonumber(inputBufferText.v)
				result = tostring(numResult)
			elseif bufferAct == '/' then
				local numResult = tonumber(bufferFirstNum) / tonumber(inputBufferText.v)
				result = tostring(numResult)
			elseif bufferAct == '*' then
				local numResult = tonumber(bufferFirstNum) * tonumber(inputBufferText.v)
				result = tostring(numResult)
			elseif bufferAct == '^' then
				local numResult = tonumber(bufferFirstNum) ^ tonumber(inputBufferText.v)
				result = tostring(numResult)
			end
			inputBufferText.v = ''
		end
		-- imgui.EndChild()
		imgui.End()
	end

end
-- Command's for get set windows at ImGui
function cmd_alite()
	own.v = not own.v
	imgui.Process = own.v
end

function cmd_calc()
	calc.v = not calc.v
	imgui.Process = calc.v
end


function check_keystrokes()
	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() then

		if ini.cheat.godmode and isKeyJustPressed(VK_INSERT) then
			cheat.GodMode = not cheat.GodMode
			if cheat.GodMode then
					printStringNow("~g~GodMode", 1500)
			else
					printStringNow("~r~GodMode", 1500)
			end
		end

		if ini.cheat.igodmode then
			cheat.IGodMode = true
		else
			cheat.IGodMode = false
		end

		if ini.cheat.airbreak and isKeyJustPressed(VK_RSHIFT) then
			cheat.AirBreak = not cheat.AirBreak
			if cheat.AirBreak then
				local posX, posY, posZ = getCharCoordinates(playerPed)
				airBrkCoords = {posX, posY, posZ, 0.0, 0.0, getCharHeading(playerPed)}
				printStringNow("~g~AirBreak", 1500)
			else
				printStringNow("~r~AirBreak", 1500)
			end
		end


		-- if ini.cheat.clickwarp and isKeyJustPressed(VK_MBUTTON) then
		-- 	cheat.ClickWarp = not cheat.ClickWarp
		-- 	if cheat.ClickWarp then sampSetCursorMode(2) else sampSetCursorMode(0) end
		-- end
	end
end

function fast_funcs_work()
	if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
		local time = os.clock() * 1000

		-- if isKeyJustPressed(VK_OEM_5) then -- unfreeze
		-- 	if isCharInAnyCar(playerPed) then
		-- 		freezeCarPosition(storeCarCharIsInNoSave(playerPed), false)
		-- 	else
		-- 		setPlayerControl(playerHandle, true)
		-- 		freezeCharPosition(playerPed, false)
		-- 		clearCharTasksImmediately(playerPed)
		-- 	end
		-- 	restoreCameraJumpcut()
		-- end

		--| Cheat: SpeedHack-Press|--
		if ini.cheat.speedhack and (isKeyDown(VK_LMENU) and isCharInAnyCar(playerPed)) then -- speedhack
			printStringNow('SpeedHack: ~g~Pressed', 500)
			if getCarSpeed(storeCarCharIsInNoSave(playerPed)) * 2.01 <= ini.cheat.s_speedhack then
				local cVecX, cVecY, cVecZ = getCarSpeedVector(storeCarCharIsInNoSave(playerPed))
				local heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
				local turbo = fps_correction() / 85
				local xforce, yforce, zforce = turbo, turbo, turbo
				local Sin, Cos = math.sin(-math.rad(heading)), math.cos(-math.rad(heading))
				if cVecX > -0.01 and cVecX < 0.01 then xforce = 0.0 end
				if cVecY > -0.01 and cVecY < 0.01 then yforce = 0.0 end
				if cVecZ < 0 then zforce = -zforce end
				if cVecZ > -2 and cVecZ < 15 then zforce = 0.0 end
				if Sin > 0 and cVecX < 0 then xforce = -xforce end
				if Sin < 0 and cVecX > 0 then xforce = -xforce end
				if Cos > 0 and cVecY < 0 then yforce = -yforce end
				if Cos < 0 and cVecY > 0 then yforce = -yforce end
				applyForceToCar(storeCarCharIsInNoSave(playerPed), xforce * Sin, yforce * Cos, zforce / 2, 0.0, 0.0, 0.0)
			end
		end
		--| Cheat: SpeedHack-Settings |--
		if ini.cheat.speedhack and (isKeyDown(VK_LSHIFT) and isKeyDown(VK_OEM_PLUS) and isCharInAnyCar(playerPed) and time - tick.Keys.Plus > tick.Time.PlusMinus) then -- speedhack speed control
			if ini.cheat.s_speedhack < 500.0 then ini.cheat.s_speedhack = ini.cheat.s_speedhack + 10.0 end
			printStringNow('SpeedHack: '..ini.cheat.s_speedhack, 500)
			tick.Keys.Plus = os.clock() * 1000
		 	elseif ini.cheat.speedhack and (isKeyDown(VK_LSHIFT) and isKeyDown(VK_OEM_MINUS) and isCharInAnyCar(playerPed) and time - tick.Keys.Minus > tick.Time.PlusMinus) then
			if ini.cheat.s_speedhack > 50.0 then ini.cheat.s_speedhack = ini.cheat.s_speedhack - 10.0 end
			printStringNow('SpeedHack: '..ini.cheat.s_speedhack, 500)
			tick.Keys.Minus = os.clock() * 1000
		end

	   -- if ini.cheat.clickwarp and cheat.ClickWarp then
		-- 	if sampGetCursorMode() == 0 then sampSetCursorMode(2) end
		-- 	local sx, sy = getCursorPos()
		-- 	local sw, sh = getScreenResolution()
		-- 	if sx >= 0 and sy >= 0 and sx < sw and sy < sh then
		-- 		local posX, posY, posZ = convertScreenCoordsToWorld3D(sx, sy, 700.0)
		-- 		local camX, camY, camZ = getActiveCameraCoordinates()
		-- 		local result, colpoint = processLineOfSight(camX, camY, camZ, posX, posY, posZ, true, true, false, true, false, false, false)
		-- 		if result and colpoint.entity ~= 0 then
		-- 			local normal = colpoint.normal
		-- 			local pos = Vector3D(colpoint.pos[1], colpoint.pos[2], colpoint.pos[3]) - (Vector3D(normal[1], normal[2], normal[3]) * 0.1)
		-- 			local zOffset = 300
		-- 			if normal[3] >= 0.5 then zOffset = 1 end
		-- 			local result, colpoint2 = processLineOfSight(pos.x, pos.y, pos.z + zOffset, pos.x, pos.y, pos.z - 0.3,
		-- 				true, true, false, true, false, false, false)
		-- 			if result then
		-- 				pos = Vector3D(colpoint2.pos[1], colpoint2.pos[2], colpoint2.pos[3] + 1)
		-- 				local curX, curY, curZ = getCharCoordinates(playerPed)
		-- 				local dist = getDistanceBetweenCoords3d(curX, curY, curZ, pos.x, pos.y, pos.z)
		-- 				local hoffs = renderGetFontDrawHeight(font)
		-- 				sy = sy - 2
		-- 				sx = sx - 2
		-- 				renderFontDrawText(font, string.format('%0.2fм', dist), sx - (renderGetFontDrawTextLength(font, string.format('%0.2fм', dist)) / 2) + 6, sy - hoffs, 0xFFFFFFFF)
		-- 				local tpIntoCar = nil
		-- 				if colpoint.entityType == 2 then
		-- 					local car = getVehiclePointerHandle(colpoint.entity)
		-- 					if doesVehicleExist(car) and (not isCharInAnyCar(playerPed) or storeCarCharIsInNoSave(playerPed) ~= car) then
		-- 						if isKeyJustPressed(VK_LBUTTON) then tpIntoCar = car end
		-- 						renderFontDrawText(font, 'Попасть на машине', sx - (renderGetFontDrawTextLength(font, 'Warp to car') / 2) + 6, sy - hoffs * 2, -1)
		-- 					end
		-- 				end
		-- 				if isKeyJustPressed(VK_LBUTTON) then
		-- 					if tpIntoCar then
		-- 						if not jumpIntoCar(tpIntoCar) then teleportPlayer(pos.x, pos.y, pos.z) end
		-- 					else
		-- 						if isCharInAnyCar(playerPed) then
		-- 							local norm = Vector3D(colpoint.normal[1], colpoint.normal[2], 0)
		-- 							local norm2 = Vector3D(colpoint2.normal[1], colpoint2.normal[2], colpoint2.normal[3])
		-- 							rotateCarAroundUpAxis(storeCarCharIsInNoSave(playerPed), norm2)
		-- 							pos = pos - norm * 1.8
		-- 							pos.z = pos.z - 1.1
		-- 						end
		-- 						teleportPlayer(pos.x, pos.y, pos.z)
		-- 						tick.ClickWarp = os.clock() * 1000
		-- 					end
		-- 					sampSetCursorMode(0)
		-- 					cheat.ClickWarp = false
		-- 				end
		-- 			end
		-- 		end
		-- 	end
		-- end
	end
end


function main_funcs()

	

	local WallHack = sampGetServerSettingsPtr()
	if ini.cheat.wallhack then
		cheat.WallHack = true
		-- printStringNow('wallhack enabled', 9999) -- DEBUG
		memory.setfloat(WallHack + 39, 1488.0)
		memory.setint8(WallHack + 47, 0)
		memory.setint8(WallHack + 56, 1)
	else
		cheat.WallHack = false
		-- printStringNow('wallhack disabled', 9999) -- DEBUG
		memory.setfloat(WallHack + 39, 50.0)
		memory.setint8(WallHack + 47, 0)
		memory.setint8(WallHack + 56, 1)
	end
	if cheat.IGodMode or (cheat.GodMode and isKeyJustPressed(VK_INSERT)) then -- Infinity GodMode
		if isCharInAnyCar(playerPed) then
			setCarProofs(storeCarCharIsInNoSave(playerPed), true, true, true, true, true)
			setCharCanBeKnockedOffBike(playerPed, true)
			setCanBurstCarTires(storeCarCharIsInNoSave(playerPed), false)
		end
		setCharProofs(playerPed, true, true, true, true, true)
	else
		if isCharInAnyCar(playerPed) then
			setCarProofs(storeCarCharIsInNoSave(playerPed), false, false, false, false, false)
			setCharCanBeKnockedOffBike(playerPed, false)
		end
		setCharProofs(playerPed, false, false, false, false, false)
	end	
	

	local time = os.clock() * 1000
	if cheat.AirBreak then -- airbreak
		if isCharInAnyCar(playerPed) then heading = getCarHeading(storeCarCharIsInNoSave(playerPed))
		else heading = getCharHeading(playerPed) end
		local camCoordX, camCoordY, camCoordZ = getActiveCameraCoordinates()
		local targetCamX, targetCamY, targetCamZ = getActiveCameraPointAt()
		local angle = getHeadingFromVector2d(targetCamX - camCoordX, targetCamY - camCoordY)
		if isCharInAnyCar(playerPed) then difference = 0.79 else difference = 1.0 end
		setCharCoordinates(playerPed, airBrkCoords[1], airBrkCoords[2], airBrkCoords[3] - difference)
		if isKeyDown(VK_W) then
			airBrkCoords[1] = airBrkCoords[1] + ini.cheat.s_airbreak * math.sin(-math.rad(angle))
			airBrkCoords[2] = airBrkCoords[2] + ini.cheat.s_airbreak * math.cos(-math.rad(angle))
			if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
			else setCarHeading(storeCarCharIsInNoSave(playerPed), angle)
			end
		elseif isKeyDown(VK_S) then
			airBrkCoords[1] = airBrkCoords[1] - ini.cheat.s_airbreak * math.sin(-math.rad(heading))
			airBrkCoords[2] = airBrkCoords[2] - ini.cheat.s_airbreak * math.cos(-math.rad(heading))
			if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
			else setCarHeading(storeCarCharIsInNoSave(playerPed), angle)
			end
		end
		if isKeyDown(VK_A) then
			airBrkCoords[1] = airBrkCoords[1] - ini.cheat.s_airbreak * math.sin(-math.rad(heading - 90))
			airBrkCoords[2] = airBrkCoords[2] - ini.cheat.s_airbreak * math.cos(-math.rad(heading - 90))
			if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
			else setCarHeading(storeCarCharIsInNoSave(playerPed), angle)
			end
		elseif isKeyDown(VK_D) then
			airBrkCoords[1] = airBrkCoords[1] - ini.cheat.s_airbreak * math.sin(-math.rad(heading + 90))
			airBrkCoords[2] = airBrkCoords[2] - ini.cheat.s_airbreak * math.cos(-math.rad(heading + 90))
			if not isCharInAnyCar(playerPed) then setCharHeading(playerPed, angle)
			else setCarHeading(storeCarCharIsInNoSave(playerPed), angle)
			end
		end
		if isKeyDown(VK_UP) then airBrkCoords[3] = airBrkCoords[3] + ini.cheat.s_airbreak / 2.0 end
		if isKeyDown(VK_DOWN) and airBrkCoords[3] > -95.0 then airBrkCoords[3] = airBrkCoords[3] - ini.cheat.s_airbreak / 2.0 end
		if not isSampfuncsConsoleActive() and not sampIsChatInputActive() and not sampIsDialogActive() and not isPauseMenuActive() then
			if isKeyDown(VK_OEM_PLUS) and time - tick.Keys.Plus > tick.Time.PlusMinus then
				if ini.cheat.s_airbreak < 20 then ini.cheat.s_airbreak = ini.cheat.s_airbreak + 0.5 end
				printStringNow('AirBreak: '..ini.cheat.s_airbreak, 500)
				inicfg.save(ini, 'adminlite')
				tick.Keys.Plus = os.clock() * 1000
			elseif isKeyDown(VK_OEM_MINUS) and time - tick.Keys.Minus > tick.Time.PlusMinus then
				if ini.cheat.s_airbreak > 0.5 then ini.cheat.s_airbreak = ini.cheat.s_airbreak - 0.5 end
				printStringNow('AirBreak: '..ini.cheat.s_airbreak, 500)
				inicfg.save(ini, 'adminlite')
				tick.Keys.Minus = os.clock() * 1000
			end
		end
	end
end

function secondary_funcs()
	--printStringNow('test function secondary_funcs()', 100)
	if cheat.Nofall then -- no fall
		if isCharPlayingAnim(playerPed, 'KO_SKID_BACK') or isCharPlayingAnim(playerPed, 'FALL_COLLAPSE') then
			clearCharTasksImmediately(playerPed)
		end
	end
end

function fisheye()
    while true do
        wait(0)
        if FishEye.v then 
            if isCurrentCharWeapon(PLAYER_PED, 34) and isKeyDown(2) then
                if not fe_locked then 
                    cameraSetLerpFov(70.0, 70.0, 1000, 1)
                    fe_locked = true
                end
            else
                cameraSetLerpFov(101.0, 101.0, 1000, 1)
                fe_locked = false
            end
        end
    end
end

function fix_funcs()
	local time = os.clock() * 1000 -- fix click warp
	if time - tick.ClickWarp < 170 and not isCharInAnyCar(playerPed) then clearCharTasksImmediately(playerPed) end
end

function fps_correction()
	return representIntAsFloat(readMemory(0xB7CB5C, 4, false))
end

function get_pickup_model(id, handle)
  local stPickup = sampGetPickupPoolPtr()
  local handle = id * 20
  local result = handle + 61444
  local result = result + stPickup
  local modelid = readMemory(result, 4, true)
  return modelid
end

function reload_setting()
	thisScript():reload()
end

--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
function initializeRender()
	font = renderCreateFont("Tahoma", 10, FCR_BOLD + FCR_BORDER)
	font2 = renderCreateFont("Arial", 8, FCR_ITALICS + FCR_BORDER)
end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
function rotateCarAroundUpAxis(car, vec)
	local mat = Matrix3X3(getVehicleRotationMatrix(car))
	local rotAxis = Vector3D(mat.up:get())
	vec:normalize()
	rotAxis:normalize()
	local theta = math.acos(rotAxis:dotProduct(vec))
	if theta ~= 0 then
	  rotAxis:crossProduct(vec)
	  rotAxis:normalize()
	  rotAxis:zeroNearZero()
	  mat = mat:rotate(rotAxis, -theta)
	end
	setVehicleRotationMatrix(car, mat:get())
  end
  
  function readFloatArray(ptr, idx)
	return representIntAsFloat(readMemory(ptr + idx * 4, 4, false))
  end
  
  function writeFloatArray(ptr, idx, value)
	writeMemory(ptr + idx * 4, 4, representFloatAsInt(value), false)
  end
  
  function getVehicleRotationMatrix(car)
	local entityPtr = getCarPointer(car)
	if entityPtr ~= 0 then
	  local mat = readMemory(entityPtr + 0x14, 4, false)
	  if mat ~= 0 then
		local rx, ry, rz, fx, fy, fz, ux, uy, uz
		rx = readFloatArray(mat, 0)
		ry = readFloatArray(mat, 1)
		rz = readFloatArray(mat, 2)
		fx = readFloatArray(mat, 4)
		fy = readFloatArray(mat, 5)
		fz = readFloatArray(mat, 6)
		ux = readFloatArray(mat, 8)
		uy = readFloatArray(mat, 9)
		uz = readFloatArray(mat, 10)
		return rx, ry, rz, fx, fy, fz, ux, uy, uz
	  end
	end
  end
  
  function setVehicleRotationMatrix(car, rx, ry, rz, fx, fy, fz, ux, uy, uz)
	local entityPtr = getCarPointer(car)
	if entityPtr ~= 0 then
	  local mat = readMemory(entityPtr + 0x14, 4, false)
	  if mat ~= 0 then
		writeFloatArray(mat, 0, rx)
		writeFloatArray(mat, 1, ry)
		writeFloatArray(mat, 2, rz)
		writeFloatArray(mat, 4, fx)
		writeFloatArray(mat, 5, fy)
		writeFloatArray(mat, 6, fz)
		writeFloatArray(mat, 8, ux)
		writeFloatArray(mat, 9, uy)
		writeFloatArray(mat, 10, uz)
	  end
	end
  end
  
  function getCarFreeSeat(car)
	if doesCharExist(getDriverOfCar(car)) then
	  local maxPassengers = getMaximumNumberOfPassengers(car)
	  for i = 0, maxPassengers do
		if isCarPassengerSeatFree(car, i) then
		  return i + 1
		end
	  end
	  return nil
	else
	  return 0
	end
  end
  
  function jumpIntoCar(car)
	local seat = getCarFreeSeat(car)
	if not seat then return false end
	if seat == 0 then warpCharIntoCar(playerPed, car)
	else warpCharIntoCarAsPassenger(playerPed, car, seat - 1)
	end
	restoreCameraJumpcut()
	return true
  end
  
  function teleportPlayer(x, y, z)
	if isCharInAnyCar(playerPed) then setCharCoordinates(playerPed, x, y, z) end
	setCharCoordinatesDontResetAnim(playerPed, x, y, z)
  end
  
  function setCharCoordinatesDontResetAnim(char, x, y, z)
	local ptr = getCharPointer(char) setEntityCoordinates(ptr, x, y, z)
  end
  
  function setEntityCoordinates(entityPtr, x, y, z)
	if entityPtr ~= 0 then
	  local matrixPtr = readMemory(entityPtr + 0x14, 4, false)
	  if matrixPtr ~= 0 then
		local posPtr = matrixPtr + 0x30
		writeMemory(posPtr + 0, 4, representFloatAsInt(x), false) -- X
		writeMemory(posPtr + 4, 4, representFloatAsInt(y), false) -- Y
		writeMemory(posPtr + 8, 4, representFloatAsInt(z), false) -- Z
	  end
	end
  end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
--| Cheat: FarChat |--
function sampev.onPlayerChatBubble(id, col, dist, dur, msg)
	if ini.cheat.farchat then
		dist = 1488.0
	else
		dist = 50.0
	end
end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
-->>| Local AutoLogin |<<--
function sampev.onShowDialog(id, style, title, button1, button2, text) -- autologin
	print(id, title)
    --| Auto-Password |--
	if ini.account.autoPass then
		if id == 1 then
			sampSendDialogResponse(0, 1, 1, tostring(ini.account.password, 256))
			print('Sended!')
		end
	end
	
    --| Auto-Alogin |--
	-- if ini.account.autoAlogin then
	-- 	function sampev.onServerMessage(color, text)
	-- 		if text:find('Добро пожаловать на ') then
	-- 			sampSendChat('/alogin')
	-- 			sampAddChatMessage('Добро пожаловать на {ff4545}Radix Role Play', -1)
	-- 		end
	-- 	end
	-- 	if id == 87 then
	-- 		sampSendDialogResponse(87, 1, 1, ini.account.alogin)
	-- 		return false
	-- 	 end
	-- end
end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
-->>| Show Help Marker: '(?)' |<<--
function ShowHelpMarker(text)
    imgui.TextDisabled("(?)")
    if (imgui.IsItemHovered()) then
        imgui.SetTooltip(u8(text))
	end
	imgui.SameLine()
end
--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|--|
--<<== Game Find: String codes (610)
