local atributos = require("atributos.lua");
local habilidades = require("habilidades.lua");
local magia = require("magia.lua");
local cenario = require("cenario.lua");
local classes = require("classes.lua");
local exemplos = require("exemplos.lua");
local levelup = require("levelup.lua");
local combate = require("combate.lua");
local racas = require("racas.lua");

local rules =[[
-- Início das Regras --
- Regras do Jogo -
]] .. cenario .. [[
]] .. atributos .. [[
]] .. habilidades .. [[
]] .. exemplos .. [[
]] .. magia .. [[
]] .. classes .. [[
]] .. levelup .. [[
]] .. combate .. [[
]] .. racas .. [[
]]
return rules;