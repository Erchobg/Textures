--[[
	this render was NOT made by me
	if you're seeing this dont you fucking dare to say "oh, this render was made by salad he big skid!!!!11"
	the render's code seems like the mastadawn's render, but my friend keep saying he made it so.
]]


local Services = {
    Storage = game:GetService("ReplicatedStorage"),
    Workspace = game:GetService("Workspace"),
    Players = game:GetService("Players")
}

local ASSET_ID = "rbxassetid://14474879594"
local PRIMARYROTATION = CFrame.Angles(0, -math.pi/4, 0)

local ToolMaterials = {
    sword = {"wood", "stone", "iron", "diamond", "emerald"},
    pickaxe = {"wood", "stone", "iron", "diamond"},
    axe = {"wood", "stone", "iron", "diamond"}
}

local Offsets = {
    sword = CFrame.Angles(0, -math.pi/2, -math.pi/2),
    pickaxe = CFrame.Angles(0, -math.pi, -math.pi0.527777778),
    axe = CFrame.Angles(0, -math.pi/18, -math.pi0.527777778)
}


local ToolIndex = {}

local function initializeToolIndex(asset)
    for toolType, materials in pairs(ToolMaterials) do
        for , material in ipairs(materials) do
            local identifier = material .. "_" .. toolType
            local toolModel = asset:FindFirstChild(identifier)

            if toolModel then
                print("Found tool in initializeToolIndex:", identifier)
                table.insert(ToolIndex, {
                    Name = identifier,
                    Offset = Offsets[toolType],
                    Model = toolModel
                })
            else
                warn("Model for " .. identifier .. " not found in initializeToolIndex!")
            end
        end
    end
end
local function adjustAppearance(part)
    if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
        part.Transparency = 1
    end
end

local function attachModel(target, data, modifier)
    local clonedModel = data.Model:Clone()
    clonedModel.CFrame = target:FindFirstChild("Handle").CFrame * data.Offset * PRIMARYROTATION * (modifier or CFrame.new())
    clonedModel.Parent = target

    local weld = Instance.new("WeldConstraint", clonedModel)
    weld.Part0 = clonedModel
    weld.Part1 = target:FindFirstChild("Handle")
end

local function processTool(tool)
    if not tool:IsA("Accessory") then return end

    for , toolData in ipairs(ToolIndex) do
        if toolData.Name == tool.Name then
            for , child in pairs(tool:GetDescendants()) do
                adjustAppearance(child)
            end
            attachModel(tool, toolData)

            local playerTool = Services.Players.LocalPlayer.Character:FindFirstChild(tool.Name)
            if playerTool then
                for , child in pairs(playerTool:GetDescendants()) do
                    adjustAppearance(child)
                end
                attachModel(playerTool, toolData, CFrame.new(0.4, 0, -0.9))
            end
        end
    end
end


local loadedTools = game:GetObjects(ASSETID)
local mainAsset = loadedTools[1]
mainAsset.Parent = Services.Storage

wait(1)


for , child in pairs(mainAsset:GetChildren()) do
    print("Found tool in asset:", child.Name)
end

initializeToolIndex(mainAsset)
Services.Workspace:WaitForChild("Camera").Viewmodel.ChildAdded:Connect(processTool)