void SetUpCVars()
{
    // Create custom console variables
    CreateConVar("acs_version", PLUGIN_VERSION, "Version of Campaign Switcher on this server", FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY | FCVAR_DONTRECORD);
    g_hCVar_VotingEnabled                       = CreateConVar("cs_voting_system_enabled", "1", "Enables players to vote for the next map or campaign [0 = DISABLED, 1 = ENABLED]", 0, true, 0.0, true, 1.0);
    g_hCVar_VoteWinnerSoundEnabled              = CreateConVar("cs_voting_sound_enabled", "1", "Determines if a sound plays when a new map is winning the vote [0 = DISABLED, 1 = ENABLED]", 0, true, 0.0, true, 1.0);
    // g_hCVar_VotingAdMode                        = CreateConVar("acs_voting_ad_mode", "3", "Sets how to advertise voting at the start of the map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT, 3 = OPEN VOTE MENU]\n * Note: This is only displayed once during a finale or scavenge map *", 0, true, 0.0, true, 3.0);
    // g_hCVar_VotingAdDelayTime                   = CreateConVar("acs_voting_ad_delay_time", "1.0", "Time, in seconds, to wait after survivors leave the start area to advertise voting as defined in acs_voting_ad_mode\n * Note: If the server is up, changing this in the .cfg file takes two map changes before the change takes place *", 0, true, 0.1, false);
    // g_hCVar_NextMapAdMode                       = CreateConVar("acs_next_map_ad_mode", "1", "Sets how the next campaign/map is advertised during a finale or scavenge map [0 = DISABLED, 1 = HINT TEXT, 2 = CHAT TEXT]", 0, true, 0.0, true, 2.0);
    // g_hCVar_NextMapAdInterval                   = CreateConVar("acs_next_map_ad_interval", "600.0", "The time, in seconds, between advertisements for the next campaign/map on finales and scavenge maps", 0, true, 60.0, false);
    g_hCVar_coopShowMapVoteMessageAfterFailures = CreateConVar(SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_CVAR_NAME, SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_DEFAULT_STR, SETTING_COOP_SHOW_MAP_VOTE_MESSAGE_AFTER_FAILURES_CVAR_DESC, 0, true, 0.0, false);

    // Hook console variable changes
    HookConVarChange(g_hCVar_VotingEnabled, CVarChange_Voting);
    HookConVarChange(g_hCVar_VoteWinnerSoundEnabled, CVarChange_NewVoteWinnerSound);
    // HookConVarChange(g_hCVar_VotingAdMode, CVarChange_VotingAdMode);
    // HookConVarChange(g_hCVar_VotingAdDelayTime, CVarChange_VotingAdDelayTime);
    // HookConVarChange(g_hCVar_NextMapAdMode, CVarChange_NewMapAdMode);
    // HookConVarChange(g_hCVar_NextMapAdInterval, CVarChange_NewMapAdInterval);
    HookConVarChange(g_hCVar_coopShowMapVoteMessageAfterFailures, CVarChange_coopShowMapVoteMessageAfterFailures);
}

/*======================================================================================
##########           C V A R   C A L L B A C K   F U N C T I O N S           ###########
======================================================================================*/

// Callback function for the cvar for voting system
void CVarChange_Voting(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
    // If the value was not changed, then do nothing
    if (StrEqual(strOldValue, strNewValue) == true)
        return;

    // If the value was changed, then set it and display a message to the server and players
    if (StringToInt(strNewValue) == 1)
    {
        g_bVotingEnabled = true;
        PrintToServer("[CS] ConVar changed: Voting System ENABLED");
        PrintToChatAll("[CS] ConVar changed: Voting System ENABLED");
    }
    else
    {
        g_bVotingEnabled = false;
        PrintToServer("[CS] ConVar changed: Voting System DISABLED");
        PrintToChatAll("[CS] ConVar changed: Voting System DISABLED");
    }
}

// Callback function for enabling or disabling the new vote winner sound
void CVarChange_NewVoteWinnerSound(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
    // If the value was not changed, then do nothing
    if (StrEqual(strOldValue, strNewValue) == true)
        return;

    // If the value was changed, then set it and display a message to the server and players
    if (StringToInt(strNewValue) == 1)
    {
        g_bVoteWinnerSoundEnabled = true;
        PrintToServer("[CS] ConVar changed: New vote winner sound ENABLED");
        PrintToChatAll("[CS] ConVar changed: New vote winner sound ENABLED");
    }
    else
    {
        g_bVoteWinnerSoundEnabled = false;
        PrintToServer("[CS] ConVar changed: New vote winner sound DISABLED");
        PrintToChatAll("[CS] ConVar changed: New vote winner sound DISABLED");
    }
}

// // Callback function for how the voting system is advertised to the players at the beginning of the round
// void CVarChange_VotingAdMode(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
// {
//     // If the value was not changed, then do nothing
//     if (StrEqual(strOldValue, strNewValue) == true)
//         return;
//
//     // If the value was changed, then set it and display a message to the server and players
//     switch (StringToInt(strNewValue))
//     {
//         case 0:
//         {
//             g_iVotingAdDisplayMode = DISPLAY_MODE_DISABLED;
//             PrintToServer("[CS] ConVar changed: Voting display mode: DISABLED");
//             PrintToChatAll("[CS] ConVar changed: Voting display mode: DISABLED");
//         }
//         case 1:
//         {
//             g_iVotingAdDisplayMode = DISPLAY_MODE_HINT;
//             PrintToServer("[CS] ConVar changed: Voting display mode: HINT TEXT");
//             PrintToChatAll("[CS] ConVar changed: Voting display mode: HINT TEXT");
//         }
//         case 2:
//         {
//             g_iVotingAdDisplayMode = DISPLAY_MODE_CHAT;
//             PrintToServer("[CS] ConVar changed: Voting display mode: CHAT TEXT");
//             PrintToChatAll("[CS] ConVar changed: Voting display mode: CHAT TEXT");
//         }
//         case 3:
//         {
//             g_iVotingAdDisplayMode = DISPLAY_MODE_MENU;
//             PrintToServer("[CS] ConVar changed: Voting display mode: OPEN VOTE MENU");
//             PrintToChatAll("[CS] ConVar changed: Voting display mode: OPEN VOTE MENU");
//         }
//     }
// }

// // Callback function for the cvar for voting display delay time
// void CVarChange_VotingAdDelayTime(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
// {
//     // If the value was not changed, then do nothing
//     if (StrEqual(strOldValue, strNewValue) == true)
//         return;
//
//     // Get the new value
//     float fDelayTime = StringToFloat(strNewValue);
//
//     // If the value was changed, then set it and display a message to the server and players
//     if (fDelayTime > 0.1)
//     {
//         g_fVotingAdDelayTime = fDelayTime;
//         PrintToServer("[CS] ConVar changed: Voting advertisement delay time changed to %f", fDelayTime);
//         PrintToChatAll("[CS] ConVar changed: Voting advertisement delay time changed to %f", fDelayTime);
//     }
//     else
//     {
//         g_fVotingAdDelayTime = 0.1;
//         PrintToServer("[CS] ConVar changed: Voting advertisement delay time changed to 0.1");
//         PrintToChatAll("[CS] ConVar changed: Voting advertisement delay time changed to 0.1");
//     }
// }

// // Callback function for how ACS and the next map is advertised to the players during a finale
// void CVarChange_NewMapAdMode(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
// {
//     // If the value was not changed, then do nothing
//     if (StrEqual(strOldValue, strNewValue) == true)
//         return;
//
//     // If the value was changed, then set it and display a message to the server and players
//     switch (StringToInt(strNewValue))
//     {
//         case 0:
//         {
//             g_iNextMapAdDisplayMode = DISPLAY_MODE_DISABLED;
//             PrintToServer("[CS] ConVar changed: Next map advertisement display mode: DISABLED");
//             PrintToChatAll("[CS] ConVar changed: Next map advertisement display mode: DISABLED");
//         }
//         case 1:
//         {
//             g_iNextMapAdDisplayMode = DISPLAY_MODE_HINT;
//             PrintToServer("[CS] ConVar changed: Next map advertisement display mode: HINT TEXT");
//             PrintToChatAll("[CS] ConVar changed: Next map advertisement display mode: HINT TEXT");
//         }
//         case 2:
//         {
//             g_iNextMapAdDisplayMode = DISPLAY_MODE_CHAT;
//             PrintToServer("[CS] ConVar changed: Next map advertisement display mode: CHAT TEXT");
//             PrintToChatAll("[CS] ConVar changed: Next map advertisement display mode: CHAT TEXT");
//         }
//     }
// }

// // Callback function for the interval that controls the timer that advertises ACS and the next map
// void CVarChange_NewMapAdInterval(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
// {
//     // If the value was not changed, then do nothing
//     if (StrEqual(strOldValue, strNewValue) == true)
//         return;
//
//     // Get the new value
//     float fDelayTime = StringToFloat(strNewValue);
//
//     // If the value was changed, then set it and display a message to the server and players
//     if (fDelayTime > 60.0)
//     {
//         g_fNextMapAdInterval = fDelayTime;
//         PrintToServer("[CS] ConVar changed: Next map advertisement interval changed to %f", fDelayTime);
//         PrintToChatAll("[CS] ConVar changed: Next map advertisement interval changed to %f", fDelayTime);
//     }
//     else
//     {
//         g_fNextMapAdInterval = 60.0;
//         PrintToServer("[CS] ConVar changed: Next map advertisement interval changed to 60.0");
//         PrintToChatAll("[CS] ConVar changed: Next map advertisement interval changed to 60.0");
//     }
// }

// Callback function for the amount of times the survivors can fail a coop finale map before ACS switches
void CVarChange_coopShowMapVoteMessageAfterFailures(Handle hCVar, const char[] strOldValue, const char[] strNewValue)
{
    // If the value was not changed, then do nothing
    if (StrEqual(strOldValue, strNewValue) == true)
        return;

    // Get the new value
    int value = StringToInt(strNewValue);

    // If the value was changed, then set it and display a message to the server and players
    if (value > 0)
    {
        g_coopShowMapVoteMessageAfterFailures = value;
        PrintToServer("[CS] ConVar changed: coopShowMapVoteMessageAfterFailures changed to %f", value);
        PrintToChatAll("[CS] ConVar changed: coopShowMapVoteMessageAfterFailures changed to %f", value);
    }
    else
    {
        g_coopShowMapVoteMessageAfterFailures = 0;
        PrintToServer("[CS] ConVar changed: coopShowMapVoteMessageAfterFailures changed to 0");
        PrintToChatAll("[CS] ConVar changed: coopShowMapVoteMessageAfterFailures changed to 0");
    }
}