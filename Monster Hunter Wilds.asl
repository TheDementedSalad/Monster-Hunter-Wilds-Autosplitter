//Monster Hunter Rise Autosplitter V1.0.2 (28 May 2025)
//Supports LRT and Game Splits for main game
//Script & Pointers by TheDementedSalad

state("MonsterHunterWilds"){}

startup
{
	timer.CurrentTimingMethod = TimingMethod.GameTime;
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Uhara = Assembly.Load(File.ReadAllBytes("Components/uhara1")).CreateInstance("Main");
	vars.Helper.Settings.CreateFromXml("Components/MHWilds.Settings.xml");
	//vars.Helper.StartFileLogger("MHWilds_Log.txt");
	
}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case (587165696):
			version = "Release";
			break;
		case (573317120):
			version = "4 March 2025";
			break;
		case (591564800):
			version = "4 April 2025";
			break;
		case (579141632):
			version = "16 April 2025";
			break;
		case (584716288):
			version = "28 May 2025";
			break;
		case (619167744):
			version = "27 Aug 2025";
			break;
		case (615530496):
			version = "30 Oct 2025";
			break;
	}

	IntPtr SoundManagerApp = vars.Uhara.ScanRel(3, "48 8b 3d ?? ?? ?? ?? 48 8b 72 ?? 48 85 f6");
	IntPtr PlayerManager = vars.Uhara.ScanRel(3, "48 8b 15 ?? ?? ?? ?? 48 8b 4c 24 ?? e8 ?? ?? ?? ?? 4c 8b 78");
	IntPtr MissionManager = vars.Uhara.ScanRel(3, "48 8b 05 ?? ?? ?? ?? 48 8b 80 ?? ?? ?? ?? 4c 8b 60 ?? 4d 85 e4");
	IntPtr DemoMediator = vars.Uhara.ScanRel(3, "48 8b 15 ?? ?? ?? ?? 48 8b 42 ?? 83 78 ?? ?? 0f 9f c0");
	IntPtr FadeManager = vars.Uhara.ScanRel(3, "48 8b 15 ?? ?? ?? ?? 48 8b 86 ?? ?? ?? ?? c5");
	IntPtr GameFlowManager = vars.Uhara.ScanRel(3, "48 8b 15 ?? ?? ?? ?? 48 89 f9 e8 ?? ?? ?? ?? 0f b6 c0");
	//vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8);
	
	/*
	if(version == "Release"){
		vars.Helper["Loading"] = vars.Helper.Make<bool>(0x13375620, 0xE8); //SoundManagerApp > Loading
		vars.Helper["CutsceneID"] = vars.Helper.Make<int>(0x133264D0, 0x68, 0x10, 0x20, 0x10, 0x44); //DemoMediator > 
		vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
		vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(0x133787B0, 0x90); //GameFlowManager
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30);
		vars.Helper["MissionID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x104); 
	}
	*/
	
	vars.Helper["FullFade"]= vars.Helper.Make<byte>(FadeManager, 0x61); //FadeManager > IsVisibleStateAny
		
	vars.Helper["CutsceneID"] = vars.Helper.Make<int>(DemoMediator, 0x68, 0x10, 0x20, 0x10, 0x44); //DemoMediator > 
	vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
	
	vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(GameFlowManager, 0x90); //GameFlowManager
	
	if(version == "Release" || version == "4 March 2025"){
		vars.Helper["QuestEndType"] = vars.Helper.Make<byte>(MissionManager, 0x158, 0x38, 0xCC); //MissionManager > _QuestDirector > QuestEndType
		vars.Helper["QuestID"] = vars.Helper.Make<int>(MissionManager, 0x158, 0x20, 0x38); //MissionManager > _QuestDirector > MissionType
		
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(MissionManager, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > ObjectiveGoParts > Array(0) > ObjectiveID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(MissionManager, 0x1E0, 0x10, 0x20, 0x50, 0x104); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > MissionID
		
		vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8); //SoundManagerApp > Loading
	}
	
	else if(version == "4 April 2025" || version == "16 April 2025"){
		vars.Helper["QuestEndType"] = vars.Helper.Make<byte>(MissionManager, 0x158, 0x38, 0xDC); //MissionManager > _QuestDirector > QuestEndType
		vars.Helper["QuestID"] = vars.Helper.Make<int>(MissionManager, 0x158, 0x20, 0x38); //MissionManager > _QuestDirector > MissionType
		
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(MissionManager, 0x1E8, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > ObjectiveGoParts > Array(0) > ObjectiveID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(MissionManager, 0x1E8, 0x10, 0x20, 0x50, 0x104); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > MissionID
		
		vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8); //SoundManagerApp > Loading
	}
	
	else if(version == "28 May 2025" || version == "27 Aug 2025"){
		vars.Helper["QuestEndType"] = vars.Helper.Make<byte>(MissionManager, 0x168, 0x38, 0xDC); //MissionManager > _QuestDirector > QuestEndType
		vars.Helper["QuestID"] = vars.Helper.Make<int>(MissionManager, 0x168, 0x20, 0x38); //MissionManager > _QuestDirector > MissionType
		
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(MissionManager, 0x200, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > ObjectiveGoParts > Array(0) > ObjectiveID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(MissionManager, 0x200, 0x10, 0x20, 0x50, 0x104); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > MissionID
		
		vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8); //SoundManagerApp > Loading
	}
	
	else{
		vars.Helper["QuestEndType"] = vars.Helper.Make<byte>(MissionManager, 0x168, 0x38, 0xDC); //MissionManager > _QuestDirector > QuestEndType
		vars.Helper["QuestID"] = vars.Helper.Make<int>(MissionManager, 0x168, 0x20, 0x38); //MissionManager > _QuestDirector > MissionType
		
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(MissionManager, 0x200, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > ObjectiveGoParts > Array(0) > ObjectiveID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(MissionManager, 0x200, 0x10, 0x20, 0x50, 0x104); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > MissionID
		
		vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xF0); //SoundManagerApp > Loading
	}
		
	//vars.Helper["IsCurrentFramePause"] = vars.Helper.Make<bool>(PlayerManager, 0x114); //PlayerManager
	
	
	vars.completedSplits = new HashSet<string>();
	vars.SideMissions = new Dictionary<int, byte>();
	
	vars.MissionManager = MissionManager;
}

onStart
{
	vars.completedSplits.Clear();
}

start
{
	return current.CutsceneID != 2 && old.CutsceneID == 2;
}

update
{
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	//print(modules.First().ModuleMemorySize.ToString());

}

split
{
	string setting = "";
	
	
	for (int i = 0; i < 32; i++){
		int mission = vars.Helper.Read<int>(vars.MissionManager, 0xF0, 0x10, 0x28 + (i * 0x28), 0x104);
		byte complete = vars.Helper.Read<byte>(vars.MissionManager, 0xF0, 0x10, 0x28 + (i * 0x28), 0xF4);

		byte oldComplete;
		if (vars.SideMissions.TryGetValue(mission, out oldComplete))
		{
			if (complete == 6 && oldComplete != 6 && mission > 300 && mission < 2000){
				setting = mission + "_" + complete;
			}
		}
		
		vars.SideMissions[mission] = complete;
			
		// Debug. Comment out before release.
		//if (!string.IsNullOrEmpty(setting))
		//vars.Log(setting);
		
		if (settings.ContainsKey(setting) && settings[setting] && vars.completedSplits.Add(setting) && vars.splitstoComplete.Contains(setting)){
			return true;
			vars.splitstoComplete.Clear();
		}
	}
	
	if((current.ObjectiveID != old.ObjectiveID || current.MissionID != old.MissionID) && current.ObjectiveID < 100){
		setting = current.MissionID + "_" + current.ObjectiveID + "_" + old.ObjectiveID;
	}
	
	else if(current.QuestEndType == 2 && old.QuestEndType != 2){
		setting = current.QuestID + "_" + current.QuestEndType;
	}

	// Debug. Comment out before release.
    if (!string.IsNullOrEmpty(setting))
    vars.Log(setting);

	if (settings.ContainsKey(setting) && settings[setting] && vars.completedSplits.Add(setting)){
		return true;
	}
}

isLoading
{
	return current.Loading || current.CutsceneID > 0 && current.CutsceneID < 10000 || current.FullFade == 128 || current.CurrentGameScene == 0;
}

reset
{
	return current.CutsceneID == 2 && old.CutsceneID != 2;
}


