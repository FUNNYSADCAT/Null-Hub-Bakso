if not game:IsLoaded() then repeat game.Loaded:wait() until game:IsLoaded() end
task.wait(3)

-- service
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable
_G.FindAnom = false
_G.NoCdInterect = false

function HlAnom()
  pcall(function()
    while _G.FindAnom do task.wait(0.2)
      for i,model in pairs(workspace:GetChildren()) do
        if model:IsA("Model") and string.find("NPC") then
          local hl = Model:FindFirstChild("Hl")

          if not hl then

            hl = Instance.new("Highlight")
            hl.Name = "Hl"
            hl.OutlineColor = Color3.fromRGB(0, 0, 0)
            hl.Parent = model
          end

            hl.FillColor = Color3.fromRGB(0,255,0)
            hl.Enabled = true
        elseif model:IsA("Model") and not string.find("NPC") then
          for i,anom in pairs(model:GetChildren()) do
            if anom:IsA("Humanoid") or anom.Name == "HumanoidRootPart" then
              local hl = Model:FindFirstChild("Hl")

              if not hl then
    
                hl = Instance.new("Highlight")
                hl.Name = "Hl"
                hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                hl.Parent = model
              end

                hl.FillColor = Color3.fromRGB(255,0,0)
                hl.Enabled = true
            end
          end
        end
      end
    end
    for _, hll in pairs(model:GetChildren()) do
      if hll:IsA("Model") then
        local hl = Model:FindFirstChild("Hl")
        if hl then
          hl:Destroy()
        end
      end
    end
  end)
end

function InstantInterect()
  pcall(function()
    while _G.NoCdInterect do task.wait(5)
      for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
          if v then
            v.HoldDuration = 0
          end
        end
      end
    end
  end)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ==================== WINDOW SETUP ====================
local Window = Fluent:CreateWindow({
    Title = "Null Hub X | Bakso | [Version 1.0.0]",
    SubTitle = "by Funnysad",
    TabWidth = 160,
    Size = UDim2.fromOffset(480, 360),
    Acrylic = true,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ==================== TOGGLE BUTTON SETUP ====================
local isVisible = true

local function ToggleWindow()
    isVisible = not isVisible
    if isVisible then
        Window:SelectTab(1)
    else
        Window:Minimize()
    end
end

local guiParent = (gethui and gethui()) or game:FindFirstChildOfClass("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FluentToggleGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = guiParent

local Button = Instance.new("ImageButton")
Button.Name = "ToggleFluent"
Button.Size = UDim2.new(0, 60, 0, 60)
Button.Position = UDim2.new(0, 20, 0.5, -30)
Button.BackgroundTransparency = 1  -- ยังคงโปร่งใสเพื่อให้เห็นแค่ภาพ
Button.Image = "rbxassetid://140249661815764"
Button.Parent = ScreenGui

-- เพิ่ม UICorner เพื่อให้ปุ่มมีมุมโค้ง (ถ้าภาพเดิมเป็นสี่เหลี่ยม)
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)  -- โค้ง 15 พิกเซล (ปรับได้)
corner.Parent = Button

-- ทำให้ปุ่มลากได้ (Draggable)
local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    Button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Button.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        updateInput(input)
    end
end)

Button.MouseButton1Click:Connect(ToggleWindow)

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "arrow-left-right"}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
  local EspAnom = Tabs.Main:AddToggle("EspAnom", {
        Title = "Esp Anomaly",
        Default = false
    })
  
  local NoCdPromt = Tabs.Main:AddToggle("insInterect", {
        Title = "Instant Interect",
        Default = false
    })

    local Teleport = Tabs.Teleport:AddToggle("Teleport", {
        Title = "Teleport to Shawarma",
        Default = false
    })
  
    EspAnom:OnChanged(function()
        if EspAnom.Value then
          _G.FindAnom = true
          HlAnom()
        elseif not EspAnom.Value then
          _G.FindAnom = false
        end
    end)
  
    NoCdPromt:OnChanged(function()
        if NoCdPromt.Value then
          _G.NoCdInterect = true
          InstantInterect()
        elseif not NoCdPromt.Value then
          _G.NoCdInterect = false
        end
    end)
  
    Teleport:OnChanged(function()
        if Teleport.Value then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-43, 5, -550)
        end
    end)
    
    Options.EspAnom:SetValue(false)
    Options.insInterect:SetValue(false)
    Options.Teleport:SetValue(false)
end

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes({})

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("Null Hub X")
SaveManager:SetFolder("Null Hub X/Save-game")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)


Window:SelectTab(1)

Fluent:Notify({
    Title = "Null Hub X",
    Content = "Thank for using",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
