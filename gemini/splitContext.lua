local rUtils = require("gemini/rUtils");
local aiPrompt = require("gemini/aiPrompt");
local sendMessage = require("firecast/sendMessage");

local function splitContext(contextoJogador)
    local prompts = rUtils.promptSplitter(contextoJogador.promptJogador, contextoJogador.maxTokens);
    if #prompts == 0 then
        sendMessage(" Não foi possível dividir o prompt. Verifique o tamanho do prompt.",
            contextoJogador.chat, "friend");
        return;
    end
    sendMessage(" Prompt dividido em " .. #prompts .. " partes.", contextoJogador.chat, "friend");
    contextoJogador.promptJogador = "";
    for i = 1, #prompts do
        if (contextoJogador.promptJogador == "") then
            contextoJogador.promptJogador = prompts[i];
        else
            contextoJogador.promptJogador = contextoJogador.promptJogador .. " | " .. prompts[i];
        end
    end
    if type(contextoJogador.energiaGasta) == "number" then
        local energiaDividida = math.floor(contextoJogador.energiaGasta / #prompts);
        contextoJogador.energiaGasta = energiaDividida;
    end
    local prompt = aiPrompt.getAiMultiCasting(contextoJogador);
    return prompt
end

return splitContext;