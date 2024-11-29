local game = {}

game.INIT = function(self)
    game.map = {}
    game:start()
    self.point = {x = 0, y = 0}
    game.click = LocalEvent:Listen(LocalEvent.Name.PointerDragBegin, function(payload)
        self.point.x = payload.X
        self.point.y = payload.Y
    end)
    game.control = LocalEvent:Listen(LocalEvent.Name.PointerDrag, function(payload)
        local dx = payload.X - self.point.x
        local dy = payload.Y - self.point.y
        if game.gun ~= nil then
            game.gun.Position = game.gun.Position + Number3(dx, 0, 0)

            if game.gun.Position.X < 0 then
                game.gun.Position.X = 0
            elseif game.gun.Position.X > 30 then
                game.gun.Position.X = 30
            end
        end
        self.point.x = payload.X
        self.point.y = payload.Y
    end)

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
    choose.pimpochka.Color = Color(255, 255, 255, 255)
    choose.pimpochka.Position = Number3(plus+5, 15, (level - 1 + 0.5) * 150)
    choose.pimpochka.Scale = Number3(5, 3, 1)
    choose.pimpochka:SetParent(World)

    choose.borders = {}
    choose.borders[1] = Quad()
    choose.borders[1].Color = Color(255, 255, 255, 255)
    choose.borders[1].Position = Number3(plus, 0, (level - 1 + 0.5) * 150 - 0.01)
    choose.borders[1].Scale = Number3(1, 15, 1)
    choose.borders[1]:SetParent(World)

    choose.borders[2] = Quad()
    choose.borders[2].Color = Color(255, 255, 255, 255)
    choose.borders[2].Position = Number3(plus+14, 0, (level - 1 + 0.5) * 150 - 0.01)
    choose.borders[2].Scale = Number3(1, 15, 1)
    choose.borders[2]:SetParent(World)

    choose.borders[3] = Quad()
    choose.borders[3].Color = Color(255, 255, 255, 255)
    choose.borders[3].Position = Number3(plus, 15, (level - 1 + 0.5) * 150 - 0.01)
    choose.borders[3].Scale = Number3(15, 1, 1)
    choose.borders[3]:SetParent(World)

    choose.name_text = Text()
    choose.name_text.Text = cfg.name
    choose.name_text.Color = Color(255, 255, 255, 255)
    choose.name_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.name_text.Position = Number3(7.5 + plus, 12.5, (level - 1 + 0.5) * 150 - 0.02)
    choose.name_text.Scale = 1.3
    choose.name_text:SetParent(World)

    choose.action_text = Text()
    local act_text = ""
    if cfg.action >= 0 then act_text = "+" .. cfg.action else act_text = cfg.action end
    choose.action_text.Text = act_text
    choose.action_text.Color = Color(255, 255, 255, 255)
    choose.action_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.action_text.Position = Number3(7.5 + plus, 16.5, (level - 1 + 0.5) * 150 - 0.02)
    choose.action_text.Scale = 1.2
    choose.action_text:SetParent(World)

    choose.current_text = Text()
    local cur_text = ""
    if cfg.current >= 0 then
        cur_text = "+" .. cfg.current
        choose.Color = Color(128, 255, 145, 100)
        choose.pimpochka.Color = Color(128, 255, 145, 255)
        choose.borders[1].Color = Color(128, 255, 145, 255)
        choose.borders[2].Color = Color(128, 255, 145, 255)
        choose.borders[3].Color = Color(128, 255, 145, 255)
    else
        cur_text = cfg.current
        choose.Color = Color(204, 81, 59, 100)
        choose.pimpochka.Color = Color(204, 81, 59, 255)
        choose.borders[1].Color = Color(204, 81, 59, 255)
        choose.borders[2].Color = Color(204, 81, 59, 255)
        choose.borders[3].Color = Color(204, 81, 59, 255)
    end
    choose.current_text.Text = cur_text
    choose.current_text.Color = Color(255, 255, 255, 255)
    choose.current_text.BackgroundColor = Color(0, 0, 0, 0)
    choose.current_text.Position = Number3(7.5 + plus, 5, (level - 1 + 0.5) * 150 - 0.02)
    choose.current_text.Scale = 3
    choose.current_text:SetParent(World)

    return choose
end

game.start = function(self)
    Camera:SetModeFree()
    Camera.Rotation.X = 0.3
    game:create_level(5)

    self.gun = guns:create()
    self.gun:SetParent(World)
    self.gun.t = function(s)
        Camera.Position = Number3(15, 20, s.Position.Z - 20)
    end
end

return game