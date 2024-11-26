local game = {}

game.INIT = function(self)
    game.map = {}

    game:create_level(5)
    
    Camera:SetModeFree()
    Camera.Position = Number3(15, 100, 0)

    return true
end

game.create_level = function(self, levels)
    self.levels = {}

    for i=1, levels do
        local level = {}
        level.floor = Quad()
        level.floor.Rotation.X = math.pi/2
        level.floor.Position = Number3(0, 0, (i - 1) * 150)
        level.floor.Scale = Number3(30, 150, 1)
        level.floor:SetParent(World)
        level.floor.Image = _IMAGES.floor

        level.choose = {}
        level.choose[1] = game:create_choose(i, {})
        level.choose[2] = game:create_choose(i, {second = true})
    end
end

function game.create_choose(self, level, config)
    local defaultConfig = {
        name = "test",
        second = false,
        action = 1,
        current = 10
    }

    local cfg = {}
    for k, v in pairs(defaultConfig) do
        if config[k] == nil then
            cfg[k] = v
        else
            cfg[k] = config[k]
        end
    end
    local plus = 0
    if cfg.second then
        plus = 15
    end
    local choose = Quad()
    choose.Color = Color(255, 255, 255, 100)
    choose.Position = Number3(7.5 + plus, 0, (level - 1 + 0.5) * 150)
    choose.Scale = Number3(15, 15, 1)
    choose:SetParent(World)

    choose.name_text = Text()
    choose.name_text.Text = cfg.name
    choose.name_text.Color = Color(255, 255, 255, 255)
    choose.name_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.name_text.Position = Number3(7.5 + plus, 10, (level - 1 + 0.5) * 150)
    choose.name_text.Scale = Number3(1, 1, 1)
    choose.name_text.Rotation.Y = math.pi
    choose.name_text:SetParent(choose)

    choose.action_text = Text()
    local act_text = ""
    if cfg.action >= 0 then act_text = "+" .. cfg.action else act_text = "-" .. cfg.action end
    choose.action_text.Text = cfg.action
    choose.action_text.Color = Color(255, 255, 255, 255)
    choose.action_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.action_text.Position = Number3(7.5 + plus, 7, (level - 1 + 0.5) * 150)
    choose.action_text.Scale = 0.75
    choose.action_text.Rotation.Y = math.pi
    choose.action_text:SetParent(choose)

    choose.current_text = Text()
    local act_text = ""
    if cfg.current >= 0 then
        act_text = "+" .. cfg.current
        choose.Color = Color(128, 255, 145, 100)
    else
        act_text = "-" .. cfg.current
        choose.Color = Color(204, 81, 59, 100)
    end
    choose.current_text.Text = cfg.current
    choose.current_text.Color = Color(255, 255, 255, 255)
    choose.current_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.current_text.Position = Number3(7.5 + plus, 3, (level - 1 + 0.5) * 150)
    choose.current_text.Scale = 1.25
    choose.current_text.Rotation.Y = math.pi
    choose.current_text:SetParent(choose)

    return choose
end

game.start = function(self)

end

return game