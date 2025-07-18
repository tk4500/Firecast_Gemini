local function iniciativa(chat, nick, mod)
    local promise = chat:asyncRoll("1d20+" .. mod, "Iniciativa de " .. nick);
    local roll, a, b = await(promise);
    if not roll then
        Log.e("SimulacrumCore-Iniciativa", "Erro ao rolar iniciativa: " .. a .. b);
        return;
    end
    return roll;
end
return iniciativa;
