--[[
bad custom viewmodel i made for universal usage.
]]
controller = {};
viewmodels = {};

function controller:getTool()
    for _,v in pairs(game:GetService("Players").LocalPlayer.Character:GetDescendants()) do
        if v:IsA("Tool") then
            return v;
        end;
    end;
end;

function controller:weldModel(inst)
    welds = {}
    local model = inst:Clone()
    for _,v in pairs(model:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            local newweld = Instance.new("WeldConstraint",newmodel)
            newweld.Part0 = model:FindFirstChildWhichIsA("Part") or model:FindFirstChildWhichIsA("MeshPart") or model:FindFirstChildWhichIsA("UnionOperation");
            newweld.Part1 = v
            v.Anchored = false
            welds[#welds + 1] = v
            v.Parent = model
        end
    end
    return model
end;

function controller:createViewmodel()
    viewmodel = {};
    local vm = Instance.new("Model",game:GetService("Workspace").CurrentCamera);
    vm.Name = game:GetService("HttpService"):GenerateGUID(false);
    viewmodel[1] = vm;
    viewmodels[#viewmodels + 1] = viewmodel;
    
    Main = Instance.new("Part",vm)
    Main.Size = Vector3.new(1,1,1);
    Main.Transparency = 1;
    Main.Anchored = true;
    Main.CanCollide = false
    
    local item = controller:getTool();
    local tool = controller:weldModel(item)
    tool.Parent = vm
    partslist = {};
    for i,v in pairs(tool:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") or v:IsA("UnionOperation") then
            partslist[#partslist + 1] = v 
        end
    end
    for i,v in pairs(partslist) do
       v.CFrame = Main.CFrame * CFrame.Angles(0,0,0) * CFrame.new(4,-2,-5)
    end
    local newweld = Instance.new("WeldConstraint",tool)
    newweld.Part0 = tool:FindFirstChildWhichIsA("Part") or tool:FindFirstChildWhichIsA("MeshPart") or tool:FindFirstChildWhichIsA("UnionOperation");
    newweld.Part1 = Main
    game:GetService("Workspace").CurrentCamera.Changed:Connect(function()
        Main.CFrame = game:GetService("Workspace").CurrentCamera.CFrame;
    end);
    return viewmodel;
end;

function controller:cleanUp()
    for i,v in pairs(viewmodels) do
        v[1]:Destroy()
        table.remove(viewmodels,i)
    end
end

return controller
