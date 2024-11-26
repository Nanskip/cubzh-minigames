local game = {}

game.INIT = function(self)
    game.map = {}

    game:create_level(5)
    
    --Camera:SetModeFree()
    --Camera.Position = Number3(15, 100, 0)

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
        level.choose[1] = game:create_choose(i, {action = math.random(-3, 3), current = math.random(-3, 3)*10, second = false})
        level.choose[2] = game:create_choose(i, {action = math.random(-3, 3), current = math.random(-3, 3)*10, second = true})
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
    choose.Position = Number3(plus, 0, (level - 1 + 0.5) * 150)
    choose.Scale = Number3(15, 15, 1)
    choose:SetParent(World)

    choose.pimpochka = Quad()
    choose.pimpochka.Color = Color(255, 255, 255, 100)
    choose.pimpochka.Position = Number3(plus+5, 15, (level - 1 + 0.5) * 150)
    choose.pimpochka.Scale = Number3(5, 3, 1)
    choose.pimpochka:SetParent(World)

    choose.name_text = Text()
    choose.name_text.Text = cfg.name
    choose.name_text.Color = Color(255, 255, 255, 255)
    choose.name_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.name_text.Position = Number3(7.5 + plus, 12.5, (level - 1 + 0.5) * 150 - 0.01)
    choose.name_text.Scale = 1.3
    choose.name_text:SetParent(World)

    choose.action_text = Text()
    local act_text = ""
    if cfg.action >= 0 then act_text = "+" .. cfg.action else act_text = cfg.action end
    choose.action_text.Text = act_text
    choose.action_text.Color = Color(255, 255, 255, 255)
    choose.action_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.action_text.Position = Number3(7.5 + plus, 17, (level - 1 + 0.5) * 150 - 0.01)
    choose.action_text.Scale = 1.2
    choose.action_text:SetParent(World)

    choose.current_text = Text()
    local cur_text = ""
    if cfg.current >= 0 then
        cur_text = "+" .. cfg.current
        choose.Color = Color(128, 255, 145, 100)
        choose.pimpochka.Color = Color(128, 255, 145, 100)
    else
        cur_text = cfg.current
        choose.Color = Color(204, 81, 59, 100)
        choose.pimpochka.Color = Color(204, 81, 59, 100)
    end
    choose.current_text.Text = cur_text
    choose.current_text.Color = Color(255, 255, 255, 255)
    choose.current_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.current_text.Position = Number3(7.5 + plus, 5, (level - 1 + 0.5) * 150 - 0.01)
    choose.current_text.Scale = 3
    choose.current_text:SetParent(World)

    return choose
end

game.start = function(self)

end

return game