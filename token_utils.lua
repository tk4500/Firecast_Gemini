local rUtils = {}

local RANKS = {
    {tokens = 1, name = "Common"},
    {tokens = 2, name = "Basic"},
    {tokens = 4, name = "Extra"},
    {tokens = 8, name = "Unique"},
    {tokens = 16, name = "Ultimate"},
    {tokens = 32, name = "Sekai"},
    {tokens = 64, name = "Stellar"},
    {tokens = 128, name = "Cosmic"},
    {tokens = 256, name = "Universal"},
    {tokens = 512, name = "Multi-Versal"}
}


function rUtils.promptSplitter(prompt, maxTokens)
    local prompts = {}
    local palavras = {}
    for palavra in string.gmatch(prompt, "[^%s_%-%c]+") do
        table.insert(palavras, palavra)
    end
    local currentPrompt = ""
    for i, palavra in ipairs(palavras) do
        if (currentPrompt == "") then
            currentPrompt = palavra;
        else
            currentPrompt = currentPrompt .. " " .. palavra;
        end
        local tokensUsados = rUtils.contarTokens(currentPrompt)
        if tokensUsados >= maxTokens then
            table.insert(prompts, currentPrompt)
            currentPrompt = "";
        end
    end
    if currentPrompt ~= "" then
        table.insert(prompts, currentPrompt)
    end
    return prompts
end

function rUtils.startsWith(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

-- Função para contar palavras (tokens) em uma string.
function rUtils.contarTokens(str)
    local count = 0
    -- Conta palavras separadas por espaço, "_" ou "-"
    for _ in string.gmatch(str, "[^%s_%-%c]+") do
        count = count + 1
    end
    return count
end

function rUtils.rolarRankParaTokens(tokens)
    if tokens <= 1 then
        return RANKS[1].name
    end
    local weightsl = {
        1,
        2,
        4,
        8,
        16,
        32,
        64,
        128,
        256,
        512
    }
    local weights = {};
    for i = 1, #weightsl do
        if(tokens >= weightsl[i]) then
            weights[i] = weightsl[i];
        end;
    end
    for i = #weights, 1, -1 do
        weights[i] = weights[i] - tokens/10
        if weights[i] < 1 then
            weights[i] = 1
        end
        weights[i] = math.floor(513 - weights[i]);
    end
    local pesos = 0;
    for i = 1, #weights do
        pesos = pesos + weights[i];
    end
    local randomValue = math.random(1, pesos);
    local cumulativeWeight = 0;
    for i = 1, #weights do
        cumulativeWeight = cumulativeWeight + weights[i];
        if randomValue <= cumulativeWeight then
            return RANKS[i].name
        end
    end

end

return rUtils