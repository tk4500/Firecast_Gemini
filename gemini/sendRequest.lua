require("internet.lua")
local Json = require("json.lua")
require("async.lua")

GEMINI_API_KEY = "";
local sendRequest = function(prompt)
    local url = "https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=" ..
        GEMINI_API_KEY;
    local request = Internet.newHTTPRequest();
    local payload = { contents = { { parts = { { text = prompt } } } } }
    local promise , resolution =  Async.Promise.pending();
    request.onResponse = function()
        resolution:setSuccess(request.responseText);
    end
    request.onError = function (err)
        resolution:setFailure("Erro ao enviar a requisição: " .. err);
    end
    request:open("POST", url);
    request:setRequestHeader("Content-Type", "application/json");
    request:send(Json.encode(payload));

    return promise;
end

return sendRequest
