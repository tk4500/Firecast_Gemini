TTS_KEY = "";
TTS_ACTIVE = false;
TTS_LANGUAGE = "pt-br";
TtsMessage = function(text, room)
    if not TTS_KEY or TTS_KEY == "" then
        Log.e("SimulacrumCore-TTS", "Chave TTS não definida.");
        return;
    end
    if not TTS_ACTIVE then
        Log.i("SimulacrumCore-TTS", "TTS está desativado. Ignorando requisição.");
        return;
    end
    local info = Internet.httpEncode(text)
    local tts = room.audioPlayer;
    local url = "http://api.voicerss.org/?key=" .. TTS_KEY .. "&hl=" .. TTS_LANGUAGE .. "&c=MP3&src=" .. info;
    Log.i("SimulacrumCore-TTS", "Iniciando requisição TTS para o texto: " .. info);
    Log.i("SimulacrumCore-TTS", "URL da requisição: " .. url);
    local request = Internet.newHTTPRequest("GET", url);
    request.onResponse = function()
        if request.status == 200 then
            local audioStream = request.responseStream;
            if audioStream then
                tts:play(audioStream, 0.5);
            else
                Log.e("SimulacrumCore-TTS", "Falha ao obter o stream de áudio.");
            end
        else
            Log.e("SimulacrumCore-TTS", "Erro na requisição TTS. Status: " .. tostring(request.status));
        end
    end
    request.onError = function(err)
        Log.e("SimulacrumCore-TTS", "Erro na requisição TTS: " .. tostring(err));
    end
    request:send();
end