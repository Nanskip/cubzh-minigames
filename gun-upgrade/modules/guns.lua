local guns = {}

function guns.INIT(self)
    return true
end

function guns.create(self, config)
    local defaultConfig = {
        shape = Items.voxels.silver_pistol,
        reload_time = 1,
        damage = 1,
        type = "pistol",
        ammo = 10,
        speed = 5,
        life = 3
    }

    config = config or {}
    for k, v in pairs(defaultConfig) do
        if config[k] == nil then
            config[k] = v
        end
    end

    local gun = Shape(config.shape)
    gun.reload_time = config.reload_time
    gun.damage = config.damage
    gun.type = config.type
    gun.ammo = config.ammo
    gun.speed = config.speed
    gun.life = config.life

    gun.Rotation.Y = math.pi/2
    gun.Position = Number3(15, 10, 0)
    gun.Tick = function(s)
        s.Position = s.Position + s.Forward * s.speed*0.1
        if s.t ~= nil then
            s:t()
        end
    end

    return gun
end

function guns.bullet(self, gun)
    local bullet = Shape(Items.nanskip.ca_bullet)
    bullet.damage = gun.damage
    bullet.speed = gun.speed
    bullet.life = gun.life

    bullet.Tick = function(s)
        s.Position = s.Position + s.Forward * s.speed
        s.life = s.life - 1
        if s.life <= 0 then
            s:SetParent(nil)
            s.Tick = nil
            s = nil
        end
    end
end

return guns