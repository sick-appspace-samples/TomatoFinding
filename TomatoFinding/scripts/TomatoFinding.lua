--[[----------------------------------------------------------------------------

  Application Name:
  TomatoFinding

  Description:
  Finding tomatoes by HSV conversion and segmentation of color image.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  To run this sample a device with SICK Algorithm API is necessary.
  For example InspectorP or SIM4000 with latest firmware. Alternatively the
  Emulator on AppStudio 2.2 or higher can be used.

  More Information:
  Tutorial "Algorithms - Color".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

-- Delay in ms between visualization steps for demonstration purpose
local DELAY = 1000

-- Creating viewer
local viewer = View.create()

-- Setting up graphical overlay attributes
local textDecoration = View.TextDecoration.create()
textDecoration:setPosition(20, 20)
textDecoration:setSize(40)
textDecoration:setColor(0, 220, 0)

local decoration = View.PixelRegionDecoration.create()
decoration:setColor(0, 255, 0, 100) -- Transparent green

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

-- Viewing image with text label
--@show(img:Image, name:string)
local function show(img, name)
  viewer:clear()
  local imid = viewer:addImage(img)
  viewer:addText(name, textDecoration, nil, imid)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only
end

local function main()
  local img = Image.load('resources/Tomatoes.bmp')
  show(img, 'Input image')

  -- Converting to HSV color space (Hue, Saturation, Value)
  local H, S, V = img:toHSV()
  show(H, 'Hue') -- View image with textDecoration label and delay
  show(S, 'Saturation')
  show(V, 'Value')

  -- Threshold on saturation to find colored regions
  local tomatoRegion = V:threshold(130, 255)
  local tomatoes = tomatoRegion:findConnected(100)

  -- Visualizing tomato borders/edges
  viewer:clear()
  local imid = viewer:addImage(img)
  for i = 1, #tomatoes do
    local border = tomatoes[i]:getBorderRegion()
    border = border:dilate(5)
    viewer:addPixelRegion(border, decoration, nil, imid)
  end
  viewer:present()
  print(#tomatoes .. ' Tomatoes found')
  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
