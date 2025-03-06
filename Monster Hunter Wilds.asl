//Monster Hunter Rise Autosplitter V1.0.0 (1 March 2025)
//Supports RTA and Game Splits for main game
//Script & Pointers by TheDementedSalad

state("MonsterHunterWilds"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
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
	}
	
	//IntPtr SoundManagerApp = vars.Helper.ScanRel(3, "48 8b 3d ?? ?? ?? ?? 48 8b 72 ?? 48 85 f6");
	//vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8);
	
	
	if(version == "Release"){
		vars.Helper["Loading"] = vars.Helper.Make<bool>(0x13375620, 0xE8); //SoundManagerApp > Loading
		vars.Helper["CutsceneID"] = vars.Helper.Make<int>(0x133264D0, 0x68, 0x10, 0x20, 0x10, 0x44); //DemoMediator > 
		vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
		vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(0x133787B0, 0x90); //GameFlowManager
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30);
		vars.Helper["MissionID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x104); 
	}
	
	if(version == "4 March 2025"){
		vars.Helper["Loading"] = vars.Helper.Make<bool>(0x13389A88, 0xE8); //SoundManagerApp > Loading
		vars.Helper["CutsceneID"] = vars.Helper.Make<int>(0x1333A990, 0x68, 0x10, 0x20, 0x10, 0x44); //DemoMediator > 
		vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
		vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(0x1338CC70, 0x90); //GameFlowManager
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(0x132EB488, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > ObjectiveGoParts > Array(0) > ObjectiveID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(0x132EB488, 0x1E0, 0x10, 0x20, 0x50, 0x104); //MissionManager > StoryZoneController > Array(0) > _MissionCtrl > MissionID
		vars.Helper["IsResultFix"] = vars.Helper.Make<byte>(0x132EB488, 0x158, 0x9F); //MissionManager > _QuestDirector > IsResultFix
		vars.Helper["FullFade"]= vars.Helper.Make<bool>(0x1332ADD8, 0x62); //FadeManager > IsVisibleStateAny
	}
	
	
	vars.completedSplits = new HashSet<string>();
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
	
	//print(vars.Helper.MainModule.Base.ToString());
	
	//print(current.EventID.ToString());
	
	//print(modules.First().ModuleMemorySize.ToString());
}

split
{
	string setting = "";
	
	if(current.ObjectiveID != old.ObjectiveID || current.MissionID != old.MissionID){
		setting = current.MissionID + "_" + current.ObjectiveID;
	}
	
	if(current.IsResultFix == 1 && old.IsResultFix == 0){
		setting = current.MissionID + "_" + current.ObjectiveID + "_" + current.IsResultFix;
	}
	
	if(current.MissionID == 2 && old.ObjectiveID == 6 && current.ObjectiveID == 0){
		setting = "1-1End";
	}
	
	if(current.MissionID == 9 && old.ObjectiveID == 4 && current.ObjectiveID == 0){
		setting = "1-2End";
	}
	
	if(current.MissionID == 13 && old.ObjectiveID == 6 && current.ObjectiveID == 0){
		setting = "1-3End";
	}
	
	if(current.MissionID == 17 && old.ObjectiveID == 8 && current.ObjectiveID == 0){
		setting = "1-4End";
	}
	
	if(current.MissionID == 19 && old.ObjectiveID == 5 && current.ObjectiveID == 0){
		setting = "1-5End";
	}
	
	if(current.MissionID == 23 && old.ObjectiveID == 5 && current.ObjectiveID == 0){
		setting = "2-1End";
	}
	
	if(current.MissionID == 25 && old.ObjectiveID == 5 && current.ObjectiveID == 0){
		setting = "2-2End";
	}
	
	if(current.MissionID == 29 && old.ObjectiveID == 7 && current.ObjectiveID == 0){
		setting = "2-3End";
	}
	
	if(current.MissionID == 33 && old.ObjectiveID == 3 && current.ObjectiveID == 0){
		setting = "2-4End";
	}
	
	if(current.MissionID == 39 && old.ObjectiveID == 3 && current.ObjectiveID == 0){
		setting = "3-1End";
	}
	
	if(current.MissionID == 39 && old.ObjectiveID == 7 && current.ObjectiveID == 0){
		setting = "3-2End";
	}
	
	if(current.MissionID == 45 && old.ObjectiveID == 2 && current.ObjectiveID == 0){
		setting = "3-3End";
	}
	
	if(current.MissionID == 47 && old.ObjectiveID == 5 && current.ObjectiveID == 0){
		setting = "3-4End";
	}
	
	if(current.MissionID == 51 && old.ObjectiveID == 4 && current.ObjectiveID == 0){
		setting = "3-5End";
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
	return current.Loading || current.CutsceneID > 0 && current.CutsceneID < 10000 || current.CurrentGameScene == 0 || current.FullFade;
}

reset
{
	return current.CutsceneID == 2 && old.CutsceneID != 2;
}


