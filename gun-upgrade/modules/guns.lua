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
        speed = 1,
        life = 1
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
    gun.speed = config.speed
    gun.life = config.life
    gun.ticks = 0
    gun.type = "gun"

    gun.Scale = 0.5
    gun.Position = Number3(15, 10, 0)
    gun.Rotation.Y = math.pi
    gun.Tick = function(s, dt)
        s.Position = s.Position + Number3(0, 0, 1) * 0.25 * dt * 60
        if s.t ~= nil then
            s:t()
        end

        s.ticks = s.ticks + dt
        if s.ticks >= s.reload_time then
            s.ticks = 0
            local bullet = guns:bullet(s)
            bullet.Position = s.Position + Number3(0, 0.35, 1)
            bullet.Scale = 0.5
            bullet:SetParent(World)
        end
    end

    return gun
end

function guns.bullet(self, gun)
    local bullet = Shape(Items.nanskip.ca_bullet)
    bullet.damage = gun.damage
    bullet.speed = gun.speed
    bullet.life = gun.life
    bullet.type = "bullet"

    bullet.Tick = function(s, dt)
        s.Position = s.Position + s.Forward * s.speed * dt * 60
        s.life = s.life - dt
        if s.life <= 0 then
            s:remove()
        end
    end

    bullet.remove = function(s)
        s:SetParent(nil)
        s.Tick = nil
        s = nil
    end

    return bullet
end

return guns