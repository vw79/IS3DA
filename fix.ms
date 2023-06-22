--Delete Objects
delete $Sphere*
delete $NewRobot

--Clone new drone
newRobot = copy $Drone
newRobot.pos.z += 100
newRobot.name = "NewRobot"


--Function to randomly set the drone's position
function randomGenerate =
(
	local drone = newRobot  -- select the drone object
        
        -- generate random values for x, y, and z position
        local xPos = random 70 -210
        local yPos = random -100 -250
        local zPos = random 30 10
        
        -- set the drone's position to the random values
        drone.pos = [xPos, yPos, zPos]
)


--Function to generate the animation of bullet and drone
function GenerateAnimation bulletSpeed=
(
	--Reset Animation & Delete Bullet
	delete $Sphere*
	deleteKeys newRobot
	
	--Create new bullet
	bullet = copy $Bullet
	bullet.name = "Sphere001"
	bullet.pos.z += 40
	bullet.parent = $Camera001
	
	--Create a target camera to bullet
	bulletcam = Targetcamera name:"BulletCamera"
	bulletcam.parent = bullet
	bulletcam.pos = [-160,-527.607,63.6]
	bulletcam.target = bullet
	
	
	--Create animation
	animate on 
	(
		for i in 5 to 200 by 1 do
		(
			--for every frame move the bullet front of camera depends of bulletSpeed
			at time i in coordsys parent bullet.pos.z -= bulletSpeed
			
			
			--detect if the bullet intersect with the drone
			if(at time i intersects bullet newRobot) then
			(
				--create a new keyframe at current frame. Values go normal
				at time i bullet.scale = bullet.scale
				at time i newRobot.visibility.controller.value = 1
				at time i newRobot.scale = newRobot.scale
					
				--create a new keyframe at next frame. Let bullet and drone disappear
				at time (i + 1) bullet.scale = [0,0,0]
				at time (i + 1) newRobot.visibility.controller.value = 0
				at time (i + 1) newRobot.scale = [0,0,0]
				
				--end creating animation
				exit
			)
		)
	)
)

--select the weapons
function SetWeapon selections=
(
	if(selections == 1)then
	(
		--move M79 and others go down
		$M79.pos.z = 26.753
		$AK47.pos.z = -26.884
		$M1911.pos.z = -30.525
	)
	else if(selections == 2)then
	(
		--move AK47 and others go down
		$M79.pos.z = -33.247
		$AK47.pos.z = 33.116
		$M1911.pos.z = -30.525
	)
	else
	(
		--move M1911 and others go down
		$M79.pos.z = -33.247
		$AK47.pos.z = -26.884
		$M1911.pos.z = 29.475
	)
)

--create a rollout for ui control
rollout test "Shooting Simulator" width:280 height:600
(
	--Controls Layout
	--Change Weapons
	dropDownList ddl12 "Weapons" pos:[30,17] width:137 height:40 items:#("M79 Grenade Launcher", "Assult Riffle AK47", "M1911 Pistol")
	
	--Randomize the location of robot
	label lblRandom "Random Generate" 
    button btnRandom "Randomize" 
	
	--Manually set the location of robot
	label lblLocation "Set location"
	
	--x Axis
	slider xSlider "X-axis" range:[-70,210,1] type:#integer
	label xLabel "Value: " 
	label xLabelRange "(-70 to 210)"
	
	--y Axis
	slider ySlider "Y-axis" range:[100,250,1] type:#integer
	label yLabel "Value: " 
	label yLabelRange "(100 to 250)"
	
	--z Axis
	slider zSlider "Z-axis" range:[-30,-10,1] type:#integer
	label zLabel "Value: " 
	label zLabelRange "(-30 to -10)"
	
	--Change bullet speed
	slider blspdSlider "Set Bullet Speed" range:[0.5,3,0.1] type:#float
	label blspdLabel "Bullet Speed: "
	
	--Change Camera View
	slider view "Change Camera View" range:[-120,0,5] ticks:0 type:#integer
	
	button generateAni "Generate Animation"
	button resetAnimation "Reset Animation"
	
	--Methods for controls
	
	on ddl12 selected val do
	(
		SetWeapon val
	)
	--Randomize the location of robot
    on btnRandom pressed do
    (
       randomGenerate() 
    )

	--Manually set the location of robot
	on xSlider changed val do 
	(
	xLabel.text = "Value: " + val as string
	local droneObj = newRobot
	if droneObj != undefined do 
		(
			local pos = droneObj.pos
			pos.x = -val
			droneObj.pos = pos
		)
	)

	on ySlider changed val do 
	(
	yLabel.text = "Value: " + val as string
	local droneObj = newRobot
	if droneObj != undefined do 
		(
			local pos = droneObj.pos
			pos.y = -val
			droneObj.pos = pos
		)
	)

	on zSlider changed val do 
	(
	zLabel.text = "Value: " + val as string
	local droneObj = newRobot
	if droneObj != undefined do 
		(
			local pos = droneObj.pos
			pos.z = -val
			droneObj.pos = pos
		)
	)
	
	--Change bullet Speed
	on blspdSlider changed val do 
	(
		blspdLabel.text = "Bullet Speed: " + val as string
	)
	
	--Change Camera View
	on view changed val do
	(
		$Circle001.rotation = angleaxis -val [0,0,1]
	)
	
	--Generate Whole Animation
	on generateAni pressed do GenerateAnimation(blspdSlider.value)
	
	--Reset whole animation
	on resetAnimation pressed do 
	(
		deleteKeys newRobot
		newRobot.visibility = 1
		newRobot.scale = $Drone.scale
		delete $Sphere*
	)
)

CreateDialog test width:200