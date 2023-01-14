local _G = _G;

function RedRange_ActionButton_OnUpdate(self, elapsed)
    local t = self.rangeTimer;
    if (not t) then
        return;
    end
    local rt = (self.redRangeTimer or 0) - elapsed;
    if ((t == TOOLTIP_UPDATE_TIME) or (t <= 0) or (rt <= 0)) then
        local newRange = false;
        local id = self.action;
        if ( ActionHasRange(id) and (IsActionInRange( id ) == 0)) then
            newRange = true;
        end
        if ( self.redRangeFlag ~= newRange ) then
            self.redRangeFlag = newRange;
            -- print("Range transition for", id, rt);
            RedRange_ActionButton_UpdateUsable(self);
        end
        self.redRangeTimer = TOOLTIP_UPDATE_TIME + 0.1;
    else
        self.redRangeTimer = rt;
    end
end

function RedRange_ActionButton_UpdateUsable(self)
    local id = self.action;
    local isUsable, notEnoughMana = IsUsableAction(id)
    if (isUsable) then
        if (ActionHasRange(id) and IsActionInRange(id) == 0) then
            local name = self:GetName();
            local icon = _G[name.."Icon"];
            local normalTexture = _G[name.."NormalTexture"];

            icon:SetVertexColor(0.8, 0.1, 0.1);
            normalTexture:SetVertexColor(0.8, 0.1, 0.1);
            self.redRangeRed = true;
            return;
        elseif (self.redRangeRed) then
            local name = self:GetName();
            local icon = _G[name.."Icon"];
            local normalTexture = _G[name.."NormalTexture"];

            icon:SetVertexColor(1.0, 1.0, 1.0);
            normalTexture:SetVertexColor(1.0, 1.0, 1.0);
            self.redRangeRed = false;
        end
    elseif (notEnoughMana) then
        local name = self:GetName();
        local icon = _G[name.."Icon"];
        local normalTexture = _G[name.."NormalTexture"];

        icon:SetVertexColor(0.1, 0.3, 1.0);
        normalTexture:SetVertexColor(0.1, 0.3, 1.0);
        return;
    end
end

hooksecurefunc("ActionButton_OnUpdate",
               RedRange_ActionButton_OnUpdate);
hooksecurefunc("ActionButton_UpdateUsable",
               RedRange_ActionButton_UpdateUsable);
hooksecurefunc("ActionButton_Update",
               RedRange_ActionButton_UpdateUsable);
