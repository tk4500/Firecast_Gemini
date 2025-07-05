require("log.lua")
GEMINI_API_KEY = "";
local function setGeminiKey(key, chat)
    
    if key and key ~= "" then
        GEMINI_API_KEY = key;
        chat:writeEx(" Chave Gemini definida com sucesso.");
        Log.i("SimulacrumCore-SetGeminiKey", "Chave Gemini definida: " .. GEMINI_API_KEY);
    else
        chat:writeEx(" Chave Gemini inválida. Use: geminiKey <sua_chave>");
        Log.e("SimulacrumCore-SetGeminiKey", "Chave Gemini inválida recebida.");
    end
end
return setGeminiKey
