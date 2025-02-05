------------------------------------------------------
-- HUSSAR moved code in HandleEvent(event)

local modPath = '/mods/SupremeScoreBoard2CBT/'
local modScripts  = modPath..'modules/'

local Bitmap  = import(modScripts..'bitmap.lua').Bitmap
local Dragger = import('/lua/maui/dragger.lua').Dragger
--TODO-FAF replace above with the following
--local Bitmap = import('bitmap.lua').Bitmap
--local Dragger = import('dragger.lua').Dragger

Checkbox = Class(Bitmap)
{
    __init = function(self, parent, normalUnchecked, normalChecked, overUnchecked, overChecked, disabledUnchecked, disabledChecked, clickCue, rolloverCue, debugname)
        Bitmap.__init(self, parent, normalUnchecked, debugname or "checkbox")
        self._states =  {}
        self._states.normal = {}
        self._states.normal.checked = normalChecked
        self._states.normal.unchecked = normalUnchecked
        self._states.over = {}
        self._states.over.checked = overChecked or normalChecked
        self._states.over.unchecked = overUnchecked or normalUnchecked
        self._states.disabled = {}
        self._states.disabled.checked = disabledChecked or normalChecked
        self._states.disabled.unchecked = disabledUnchecked or normalUnchecked
        --self.mRolloverCue = rolloverCue
        --self.mClickCue = clickCue
        self:SetSounds(true, clickCue, rolloverCue)
        
        self._checkState = "unchecked"
        self._controlState = "normal" 

        self:SetSounds(true)
    
    end,

    SetNewTextures = function(self, normalUnchecked, normalChecked, overUnchecked, overChecked, disabledUnchecked, disabledChecked)
        self._states.normal.checked = normalChecked
        self._states.normal.unchecked = normalUnchecked
        self._states.over.checked = overChecked or normalChecked
        self._states.over.unchecked = overUnchecked or normalUnchecked
        self._states.disabled.checked = disabledChecked or normalChecked
        self._states.disabled.unchecked = disabledUnchecked or normalUnchecked
        -- update current texture
        self:SetTexture(self._states[self._controlState][self._checkState])
    end,

    SetCheck = function(self, isChecked, skipEvent)
        if isChecked == true then
            self._checkState = "checked"
        else
            self._checkState = "unchecked"
        end
        self:SetTexture(self._states[self._controlState][self._checkState])
        if not skipEvent then
            self:OnCheck(isChecked)
        end
    end,

    ToggleCheck = function(self, skipEvent)
        if self._checkState == "checked" then
            self:SetCheck(false, skipEvent)
        else
            self:SetCheck(true, skipEvent)
        end
    end,

    IsChecked = function(self)
        return (self._checkState == "checked")
    end,

    OnDisable = function(self)
        if self._controlState ~= "disabled" then
            self._controlState = "disabled"
            self:SetTexture(self._states[self._controlState][self._checkState])
        end
    end,

    OnEnable = function(self)
        if self._controlState ~= "enabled" then
            self._controlState = "normal"
            self:SetTexture(self._states[self._controlState][self._checkState])
        end
    end,

    --HandleEvent = function(self, event)
    --    --LOG('HandleEvent ' .. tostring(self._highlightEnabled).. ' ' .. tostring(self:GetAlpha()) .. '  ' .. tostring(self._controlState) )
    --    self:HandleHighlight(event)
    --    self:HandleSound(event)
    --
    --    local eventHandled = false
    --    if event.Type == 'MouseEnter' then
    --        eventHandled = self:OnMouseEnter(event)
    --
    --    elseif event.Type == 'MouseExit' then
    --        eventHandled = self:OnMouseExit(event)
    --
    --    elseif event.Type == 'ButtonPress' or event.Type == 'ButtonDClick' then
    --        self:OnClick(event.Modifiers)
    --        --if self.mClickCue ~= "NO_SOUND" then
    --        --    if self.mClickCue then
    --        --        local sound = Sound({Cue = self.mClickCue, Bank = "Interface",})
    --        --        PlaySound(sound)
    --        --    end
    --        --end
    --        eventHandled = true
    --    end
    --
    --    return eventHandled
    --end,

    -- override this method to handle checks
    OnCheck = function(self, checked) end,

    -- override this method to handle clicks differently than default (which is ToggleCheck)
    OnClick = function(self, modifiers)
        self:ToggleCheck()
        return true
    end,

    OnMouseEnter = function(self, event)
        local eventHandled = false
        if self._controlState ~= "disabled" then
            self._controlState = "over"
            self:SetTexture(self._states[self._controlState][self._checkState])
            --if self.mRolloverCue ~= "NO_SOUND" then
            --    if self.mRolloverCue then
            --        local sound = Sound({Cue = self.mRolloverCue, Bank = "Interface",})
            --        PlaySound(sound)
            --    end
            --end
            eventHandled = true
        end
        return eventHandled
    end,
    
    OnMouseExit = function(self, event)
        local eventHandled = false
        if self._controlState ~= "disabled" then
            self._controlState = "normal"
            self:SetTexture(self._states[self._controlState][self._checkState])
            eventHandled = true
        end
        return eventHandled
    end,
     

}