local function calcInitiative(battleid, iniciativas)
    local battleinfo = Battleinfo[battleid];
    if not battleinfo or not battleinfo.started then
        Log.e("SimulacrumCore-CalcInitiative", "Batalha não iniciada ou não encontrada: " .. battleid);
        return;
    end
    if not iniciativas then
        iniciativas = battleinfo.iniciativas;
    end
    if battleinfo.turno == 0 then
        table.sort(iniciativas, function(a, b)
            return a.iniciativa > b.iniciativa;
        end);
    Battleinfo[battleid].iniciativas = iniciativas;
    Battleinfo[battleid].turno = 1;
    else
        local turno = battleinfo.turno;
        local entity = iniciativas[turno];
        table.sort(iniciativas, function(a, b)
            return a.iniciativa > b.iniciativa;
        end);
        Battleinfo[battleid].iniciativas = iniciativas;
        for i, entidade in ipairs(iniciativas) do
            if entidade.nome and entity.nome and entidade.nome == entity.nome then
                Battleinfo[battleid].turno = i;
                break;
            end
            if entidade.login and entity.login and entidade.login == entity.login then
                Battleinfo[battleid].turno = i;
                break;
            end
        end
    end
    

end
return calcInitiative;