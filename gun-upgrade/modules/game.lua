local game = {}

game.INIT = function(self)
    game.map = {}

    game.map.floor = Quad()
    game.map.floor.Rotation.X = math.pi/2
    game.map.floor.Scale = Number3(30, 500, 1)
    game.map.floor:SetParent(World)
    game.map.floor.Image = _IMAGES.floor
    


    return true
end

return game