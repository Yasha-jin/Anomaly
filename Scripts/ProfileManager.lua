--- Profile Manager utility for PROFILEMAN.
-- Serve as an utility for replacing the original ScreenSelectProfile
-- as some profile stuff were dependant on it, and it was only in cpp.
-- @module ProfileManager
ProfileManager = {}

ProfileManager.GetProfileIDs = function() return PROFILEMAN:GetLocalProfileIDs() end
Profile.GetProfileNames = function() return PROFILEMAN:GetLocalProfileDisplayNames() end

ProfileManager.GetProfiles = function()
    local profiles = {}
    for i, profileID in ipairs(PROFILEMAN:GetLocalProfileIDs()) do
        table.insert(profiles, PROFILEMAN:GetLocalProfile(profileID))
    end
    return profiles
end

ProfileManager.SetProfile = function(ProfileID)
    PREFSMAN:SetPreference("DefaultLocalProfileIDP1", ProfileID)
    PREFSMAN:SavePreferences()
    GAMESTATE:Reset()
    GAMESTATE:JoinPlayer(0)
    GAMESTATE:LoadProfiles()
end