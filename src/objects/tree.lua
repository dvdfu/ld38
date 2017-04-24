local Class = require 'modules.hump.class'
local Object = require 'src.objects.object'
local Constants = require 'src.constants'


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
    self.body:setSleepingAllowed(false)
    self.shape = love.physics.newCircleShape(28)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Hive:draw()
    local x, y = self.body:getPosition()
    love.graphics.draw(sprites.hive, x, y, self.body:getAngle(), 1, 1, 32, 32)
end

function Hive:update(dt)
    Object.update(self, dt)
    self.body:applyForce(0, 1)
end

--------------------------------------------------------------------------------

local Branch = Class.new()
Branch:include(Object)

function Branch:init(objects, x, y)
    Object.init(self, objects, x, y)
    self:build(objects:getWorld(), x, y)
    self:addTag('branch')
    self.hive = Hive(objects, x - 64, y + 8)
    local a, b = self.hive.body:getPosition()
    self.rope = love.physics.newRopeJoint(self.body, self.hive.body, x - 64, y + 4, a, b - 28, 64, true)
end

function Branch:build(world, x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newRectangleShape(128, 8)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(self)
end

function Branch:draw()
    local x, y = self.body:getPosition()
    local hx, hy = self.hive.body:getPosition()
    love.graphics.draw(sprites.branch, x + 64, y, 0, 1, 1, 160, 16)

    love.graphics.push('all')
        local x1, y1, x2, y2 = self.rope:getAnchors()
        love.graphics.setLineWidth(3)
        love.graphics.setColor(101, 84, 58)
        love.graphics.line(x1, y1, x2, y2)
    love.graphics.pop()
end

--------------------------------------------------------------------------------

local Tree = Class.new()
Tree:include(Object)

-- x is the right side of the screen
function Tree:init(objects, x)
    self.world = objects:getWorld()
    Object.init(self, objects, x)
    self:build(objects:getWorld(), x)
    self:addTag('tree')
    Branch(objects, x - 167, 80)
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
