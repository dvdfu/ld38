local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'

local Branch = Class.new()
Branch:include(Object)

local sprites = {
    hive = love.graphics.newImage('res/tree_hive.png'),
    branch = love.graphics.newImage('res/tree_branch.png'),
    tree = love.graphics.newImage('res/tree.png'),
}

local Hive = Class.new()
Hive:include(Object)

function Hive:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('hive')
end

function Hive:build(world, x, y)
    self.body = love.physics.newBody(world, x, y, 'dynamic')
    self.body:setLinearDamping(0.1, 0.1)
    self.shape = love.physics.newCircleShape(28)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Hive:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.hive, x - sprites.hive:getWidth() / 2, y - sprites.hive:getHeight() / 2)
end

function Hive:update(dt)
    self.body:applyForce(0, 1)
end

--------------------------------------------------------------------------------

function Branch:init(objects, x, y, hive)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y, hive)
    love.physics.newRopeJoint(self.body, hive.body, 0, 8, 0, 0, 50, false)
    self:addTag('branch')
end

function Branch:build(world, x, y, hive)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newRectangleShape(128, 8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Branch:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.branch, x - sprites.branch:getWidth() / 2, y - sprites.branch:getHeight() / 2)
end

--------------------------------------------------------------------------------

local Tree = Class.new()
Tree:include(Object)

-- x is the right side of the screen
function Tree:init(objects, x)
    Object.init(self, objects, x)
    self:build(objects:getWorld(), x)
    self:addTag('tree')

    self.hive = Hive(objects, x - 168, 150)
    self.branch = Branch(objects, x - 168, 80, self.hive)
end

function Tree:build(world, x)
    self.body = love.physics.newBody(world, x - sprites.tree:getWidth() / 2, sprites.tree:getHeight() / 2)
    self.shape = love.physics.newRectangleShape(sprites.tree:getWidth() / 2 - 25, sprites.tree:getHeight() * 2)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
    self.body:setFixedRotation(true)
    self.body:setAngle(0.06)
end

function Tree:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.tree, x - sprites.tree:getWidth() / 2, 0)
end

return Tree
