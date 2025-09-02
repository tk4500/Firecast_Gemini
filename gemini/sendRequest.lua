require("internet.lua")
local Json = require("json.lua")
require("async.lua")
require("gemini/setGeminiKey.lua")

local sendRequest = function(prompt)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" ..
        GEMINI_API_KEY;
    local request = Internet.newHTTPRequest();
    request.countErrors = 0;
    local payload = { contents = { { parts = { { text = prompt } } } } }
    local promise, resolution = Async.Promise.pending();
    request.onResponse = function()
        resolution:setSuccess(request.responseText);
    end
    request.onError = function(err)
        if string.find(err, "503") then
            request.countErrors = request.countErrors + 1;
            local time = request.countErrors * 1000;
            setTimeout(function()
                Log.i("SimulacrumCore-Gemini", "Serviço ocupado, tentando novamente...");
                request:open("POST", url);
                request:setRequestHeader("Content-Type", "application/json");
                request:send(Json.encode(payload));
            end, time)
        elseif string.find(err, "429") then
            request.countErrors = request.countErrors + 1;
            local time = request.countErrors * 1000;
            setTimeout(function()
                Log.i("SimulacrumCore-Gemini", "Limite de requisições atingido (429), tentando novamente...");
                request:open("POST", url);
                request:setRequestHeader("Content-Type", "application/json");
                request:send(Json.encode(payload));
            end, time)
        else
            resolution:setFailure("Erro ao enviar a requisição: " .. err);
        end
    end
    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(Json.encode(payload));

    return promise;
end

return sendRequest
