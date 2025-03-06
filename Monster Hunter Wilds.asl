// Monster Hunter Rise Autosplitter V1.0.0 (1 March 2025)
// Supports RTA and Game Splits for main game
// Script & Pointers by TheDementedSalad

state("MonsterHunterWilds") { }

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/MHWilds.Settings.xml", false);
	// vars.Helper.StartFileLogger("MHWilds_Log.txt");
}

init
{
	switch (modules.First().ModuleMemorySize)
	{
		case 0x22FF7000:
			version = "Release";
			break;
		case 0x222C2000:
			version = "4 March 2025";
			break;
	}

	// IntPtr SoundManagerApp = vars.Helper.ScanRel(3, "48 8b 3d ???????? 48 8b 72 ?? 48 85 f6");
	// vars.Helper["Loading"] = vars.Helper.Make<bool>(SoundManagerApp, 0xE8);

	if (version == "Release")
	{
		vars.Helper["Loading"] = vars.Helper.Make<bool>(0x13375620, 0xE8);
		vars.Helper["CutsceneID"] = vars.Helper.Make<int>(0x133264D0, 0x68, 0x10, 0x20, 0x10, 0x44);
		vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;
		vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(0x133787B0, 0x90);
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30);
		vars.Helper["MissionID"] = vars.Helper.Make<int>(0x132D6FA8, 0x1E0, 0x10, 0x20, 0x50, 0x104);
	}
	else if (version == "4 March 2025")
	{
		// SoundManagerApp.Loading
		vars.Helper["Loading"] = vars.Helper.Make<bool>(0x13389A88, 0xE8);

		// DemoMediator.?[0].?[0].?
		vars.Helper["CutsceneID"] = vars.Helper.Make<int>(0x1333A990, 0x68, 0x10, 0x20, 0x10, 0x44);
		vars.Helper["CutsceneID"].FailAction = MemoryWatcher.ReadFailAction.SetZeroOrNull;

		// GameFlowManager.?
		vars.Helper["CurrentGameScene"] = vars.Helper.Make<int>(0x1338CC70, 0x90);

		// MissionManager.StoryZoneController[0]._MissionCtrl.ObjectiveGoParts[0].ObjectiveID
		vars.Helper["ObjectiveID"] = vars.Helper.Make<int>(0x132EB488, 0x1E0, 0x10, 0x20, 0x50, 0x90, 0x10, 0x30);

		// MissionManager.StoryZoneController[0]._MissionCtrl.MissionID
		vars.Helper["MissionID"] = vars.Helper.Make<int>(0x132EB488, 0x1E0, 0x10, 0x20, 0x50, 0x104);

		// MissionManager._QuestDirector.IsResultFix
		vars.Helper["IsResultFix"] = vars.Helper.Make<bool>(0x132EB488, 0x158, 0x9F);

		// FadeManager.IsVisibleStateAny
		vars.Helper["FullFade"]= vars.Helper.Make<bool>(0x1332ADD8, 0x62);
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

	// vars.Log(modules[0].Base);
	// vars.Log(modules[0].ModuleMemorySize);
	// vars.Log(current.EventID);
}

split
{
	string setting = "";

	if (current.MissionID != old.MissionID)
	{
		setting = current.MissionID + "_" + current.ObjectiveID;
	}
	else if (current.ObjectiveID != old.ObjectiveID)
	{
		setting = current.ObjectiveID == 0 // Finished chapter
			? current.MissionID + "_" + old.ObjectiveID + "e"
			: current.MissionID + "_" + current.ObjectiveID;
	}
	else if (current.IsResultFix && !old.IsResultFix)
	{
		setting = current.MissionID + "_" + current.ObjectiveID + "f";
	}

	if (!string.IsNullOrEmpty(setting))
		vars.Log(setting);

	return settings.ContainsKey(setting)
		&& settings[setting]
		&& vars.completedSplits.Add(setting);
}

isLoading
{
	return current.Loading
		|| current.CutsceneID > 0 && current.CutsceneID < 10000
		|| current.CurrentGameScene == 0
		|| current.FullFade;
}

reset
{
	return current.CutsceneID == 2 && old.CutsceneID != 2;
}
