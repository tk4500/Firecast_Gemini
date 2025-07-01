local atributos = require("rules/atributos.lua");
local habilidades = require("rules/habilidades.lua");
local magia = require("rules/magia.lua");
local cenario = require("rules/cenario.lua");
local classes = require("rules/classes.lua");
local exemplos = require("rules/exemplos.lua");
local levelup = require("rules/levelup.lua");
local combate = require("rules/combate.lua");
local racas = require("rules/racas.lua");
local loja = require("rules/loja.lua");

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
]] .. loja .. [[
-- Fim das Regras --
]]
return rules;