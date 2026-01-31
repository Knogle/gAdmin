/*
[gAdmin Filterscript - Adminstration filterscript for the GTA San Andreas
 Modification San Andreas Multiplayer (SA:MP www.sa-mp.com) version 0.2x or higher]

Copyright (C) [2007-2009] [Daniel,"Goldkiller"]

This program is free software; you can redistribute it and/or modify it under the terms of the
GNU General Public License as published by the Free Software Foundation; either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program;
if not, see <http://www.gnu.org/licenses/>.

*/
/*
 $ Latest Update :			12/ 2/ 2010
 $ gAdmin by :				Goldkiller (gta-goldkiller[at]web.de)
 $ gAdmin Version :			1.2.1
 $ Supported SAMP Version:  0.2-* & 0.3a
 $ Languages :              English / German / Polish / Hungarian / Chinese / Dutch (- Sourcecode mostly in English ( some German ) -)
 $ gSQL :                   MadniX & Goldkiller
 $ DINI,Dudb & DUtils :	 	Dracoblue
 & SII :                    [DRuG]Slick
 $ YSI Format :             Alex "Y_Less" Cole
 $ Usefull Functions :      Simon, breadfish, dracoblue, Sacky, Smuggler, Unnamend, Luby, Y_Less, Iain Gilbert, Westie
 $ IRC Plugin :            	IRC Plugin v1.2 (http://forum.sa-mp.com/index.php?topic=123777.0) by Incognito
							(gAdmin 1.0.1 and older http://forum.sa-mp.com/index.php?topic=22354.0 by Jacob )
 $ MYSQL Plugin :          	http://forum.sa-mp.com/index.php?topic=23931.0 by [RAZ]ADreNaLiNe-DJ
 $ Visit :                  www.san-vice.de.vu
*/
/*
- Defines
- Files
- Colors
- Language
- Includes
- Forwards
- Menus
- AdminLevels
- Vars
- Events
- DCMD's (Draco Command)
- Functions
- Public Functions
- IRC CMD's (Incognito's IRC Plugin)
*/

/*
	Dev:
	    Globals start with 'g_',example: g_tCountdown
	    Strings (except one 's[128]') start with 's',example: g_sAdvertise[128],
	    Enums start with 'e_',example: e_Vehicle_Info,
	    Boolean variables start with 'b',example: Bool:bVIP,
	    Float variables start with 'f',example: Float:g_fGodValue,

	Misc:
		Menus are prefixed with 'm_',example: m_ImportTuner
		Languages are prefixed with 'l_',example: g_l_English
		Textdraws are prefixed with 'td_',example: td_PlayerDraw
		Timer are prefixed with 't',example: g_tCountdown
*/

/*---- Defines ---*/
#define FILTERSCRIPT
/* Files */
#define reportlog "gAdmin Log/report.txt"
#define clearlog "gAdmin Log/clearlog.txt"
#define adminlog "gAdmin Log/adminlog.txt"
#define viplog "gAdmin Log/viplog.txt"
#define levelconfig "gAdmin Config/levelconfig.cfg"
#define generalconfig "gAdmin Config/generalconfig.cfg"
#define blacklist_file "gAdmin Config/blacklist.cfg"
#define ipbans_file "gAdmin Config/ipbans.cfg"
#define clanblacklist_file "gAdmin Config/clanblacklist.cfg"
#define whitelist_file "gAdmin Config/whitelist.cfg"
#define AdminList "gAdmin Config/adminlist.txt"
#define AliasList "gAdmin Config/alias.txt"
#define AliasList_Buf "gAdmin Config/tmp_alias.txt"
#define BadWords_file "gAdmin Config/badwords.txt"
#define Dev_Log "gAdmin Log/devlog.txt"
#define Settings_Log "gAdmin Config/settings.txt"

/* Colors */
#define COLOR_LIGHTGREEN 0x00FD4DAA
#define COLOR_BLUE 0x0099FFAA
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_RED2 0xFF0000AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_PINK 0xFF3DF8AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_DARKRED 0x660000AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_SYSTEM 0xFFFF00AA
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_ORANGERED 0xFF4500AA

#define COLOR_PM 0xFFDC18AA

/* Important once 	-	DONT change them unless you are 100% sure what you are doing*/

new g_Max_Players;

#define gVersion "gAdmin 1.2.1"
//#define gDebug
//#define _samp03_
/* Normal Loop */
#define foreach(%1) \
	for(new %1;%1<g_Max_Players;%1++) if(IsPlayerConnected(%1) && !IsPlayerNPC(%1) )

/* Normal Loop WITHOUT Connected Check if we have another Check after that*/
#define foreachEx(%1) \
	for(new %1;%1<g_Max_Players;%1++)

#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
/* Modified version of dcmd() to work with strings as first paramter */
#define dcmd2(%1,%2,%3) if ((strcmp((%3)[1], %1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1


/* Userbuild	-	Here you can decide what system to really need or not */

#define SPECTATE_MODE   // - Comment out if you dont need inbuild Spectate Mode
#define DISPLAY_MODE    // - Comment out if you dont need DisplayMode showing Area,Speed or both while in a vehicle
#define DISPLAY_MODE_TD // - Comment out if you want to have DisplayMode using GametextForPlayer,instead of TextDraw
#define LOCK_MODE       // - Comment out if you dont need Lock system,providing some extra admincommands too
#define BASIC_COMMANDS  // - Comment out if you dont want the following commands
	/* Read:
		The BASIC_COMMANDS are:
		    - /players
		    - /clock
		    - /date
		    - /pos
		    - /me
		    - /kill
		    - /givemoney
	*/
//#define EXTRA_COMMANDS  // - Comment out if you dont want the following commands
	/* Read:
		The EXTRA_COMMANDS are:
		    - /bank
		    - /withdraw
		    - /para
		    - /hitman
		    - /bounty
	*/
#define USE_MENUS     		// - If you dont need menus,you can remove them easily (all cmd which involve menus won't work anymore)
//#define SAVE_POS    		// - Save the position of a player when he leaves the server
//#define SAVE_ADDITION     // - Saves Playerinfo in a custom time,not only on Connect and Disconnect (If server crashes this might be helpful)
#if defined SAVE_ADDITION
	#define SAVE_TIME 5*60*1000 // 5 Minutes
#endif
#define PROFILE_MANUPULATION


/* Misc defines 	-	You might edit them to fit your needs*/
#define MAX_WRONG_PW 5
#define PREFIX_ADMINCHAT '#'        // Char to identify with AdminChat
#define PREFIX_ADMINCHAT2 '@'       // Char to identify with AdminChat
#define PREFIX_VIPCHAT '*'          // Char to identify with VipChat
#define MAX_COUNTDOWN 60*60*24 		// 1Day should be too long
#define MAX_ANNOUNCE_TIME 15*1000
#define REGMSG_DELAY    (5000)
//#define IRC                         // Use the IRC support
//#define MYSQL                       // Use new Usersystem V2,built on MYSQL using gSQL library instead of DUDB
#define COLOR_FIX   				// Fix the playercolors if they return 0 (/invisible)
#define LOGIN_PROTECTION    		// Protection for 7login blablabla
#define PINGKICK_ADMIN_IMMUNITY     // Imunity for admins when checking the ping
#define ANTI_SPAM                   // Script to prevent people from spaming the mainchat
#define NO_JAIL_COUNT               // Since 1.0 it's not needed anymore!
//#define PMBIND_INCLUDE
#if defined _samp03_
#define LOGIN_PANEL
	#define PANEL_OFFSET 5323
	#define PANEL_DIALOG \
		(PANEL_OFFSET + 1)
	#define MS_LOGIN_PANEL \
		(PANEL_OFFSET + 2)
	#define LANGUAGE_LIST \
		(PANEL_OFFSET + 3)


#endif


#if defined SPECTATE_MODE
	#define FREE_SPEC_ID INVALID_PLAYER_ID
#endif

#if defined DISPLAY_MODE
	#define KMH_MODE 0
	#define MPH_MODE 1
	#define KMH_METERS 1000
	#define MPH_METERS 1609
#endif

#define EX_MENU_AMMUNATION 1
#define EX_MENU_VEHICLE 2
#define EX_MENU_WEAPON 3
#define EX_MENU_TUNING 4
#define EX_MENU_TELEPORT 5

#define MAX_STRING (256)
#define INFINITY (Float:0x7F800000)

/*---- Includes ---*/
#if defined IRC
#define irc_gAdmin
#endif

#include <a_samp>
#if defined MYSQL
	#include <gAdmin/gSQL_StrickenKid>
#else
	#include <gAdmin/dfiles>
#endif
#if defined IRC
#include <irc>
#endif
#include <gAdmin/gAdmin>
#include <gAdmin/SII>
#include <gAdmin/zcmd>
/*---- Language ---*/
//#include <gAdmin/gFormat>
#include <gAdmin/gLanguageV2>

/*---- Forwards ---*/
forward Login(playerid);
forward Countdown(iFreeze);
forward TimeUpdate();
forward PingCheck();
forward WeatherUpdate();
forward ScoreUpdate();
forward GodUpdate();
#if defined DISPLAY_MODE
	forward AreaName();
	forward SpeedOMeter();
	forward SpeedName();
	#if !defined DISPLAY_MODE_TD
		forward RestartDisplay();
	#endif
#endif
#if defined LOCK_MODE
	forward CheckLock();
	forward UnlockCar(vehicleid);
#endif
forward Trigger();
#if defined irc_gAdmin
	forward IRCJoin();
	forward IRC_Reconnect();
#endif
forward CallGameModeExit();
forward OnPlayerLogin(playerid,type);
forward OnPlayerLogout(playerid);
forward OnPlayerRegister(playerid);
#if defined SAVE_ADDITION
	forward SaveProfiles();
#endif
forward ReleasePlayer(playerid);
forward ShowLoginDialog(playerid);
#if defined PROFILE_MANUPULATION
forward GetProfilEntry(playerid,entry[]);
forward SetProfilEntry(playerid,entry[],digit);
#endif

#define LOGIN_NORMAL 1
#define LOGIN_AUTOIP 2

#if defined _samp03_
forward OnPlayerPrivmsg(playerid, recieverid, text[]);
#endif

/* These functions might be called using CallRemoteFunction() */

forward IsPlayergAdmin(playerid);
forward GetPlayergAdminLevel(playerid);

/*---- Menus ---*/
#if defined USE_MENUS
new
	Menu:m_ImportTuner,
	Menu:m_AmmuNation,
	Menu:m_V,
	Menu:m_Bikes,
	Menu:m_Boats,
	Menu:m_Planes,
	Menu:m_FastCars,
	Menu:m_Special,
	Menu:m_LowRider,
	Menu:m_Pistole,
	Menu:m_MicroSMG,
	Menu:m_Shotguns,
	Menu:m_Items,
	Menu:m_SMG,
	Menu:m_Rifles,
	Menu:m_Assaultrifle,
	Menu:m_Grenade,
	Menu:m_HandGuns,
	Menu:m_BigOnes,
	Menu:m_Weather,
	Menu:m_Rims,
	Menu:m_Color,
	Menu:m_Teleport,
	Menu:m_LS,
	Menu:m_SF,
	Menu:m_LV,
	Menu:m_Desert,
	Menu:m_Country;
#endif
/*---- AdminLevel Variablen ---*/
enum e_Level_Info {  //Levelvars
	lkick,
	lfake,
	lheal,
	lsethealth,
	lslap,
	lfreeze,
	lunfreeze,
	lgravity,
	lip,
	lban,
	ltban,
	lgoto,
	lmute,
	lunmute,
	lakill,
	lget,
	ljail,
	lunjail,
	lsettime,
	lannounce,
	laddblack,
	laddwhite,
	laddclanblack,
	lbanip,
	lnick,
	lcountdown,
	lreloadcfg,
	lreloadlanguages,
	lreloadfs,
	lreloadbans,
	lallmoney,
	lgivecash,
	lsetmoney,
	lsetadmin,
	larmor,
	lgiveweapon,
	la,
	lsun,
	lcloud,
	lsandstorm,
	lfog,
	lrain,
	#if defined USE_MENUS
	lammu,
	lweather,
	#endif
	ldisarm,
	#if !defined _samp03_
	lnumberplate,
	#endif
	lallheal,
	lresetmoney,
	lclear,
	lsay,
	lvr,
	lflip,
	lwhitelist,
	lblacklist,
	lclanblacklist,
	#if defined USE_MENUS
	lv,
	#endif
	lskin,
	lexplode,
	lsetscore,
	lcarcolor,
	lnoon,
	lnight,
	lmorning,
	lday,
	#if defined SPECTATE_MODE
	lspec,
	#endif
	lfuckup,
	lforce,
	lejet,
	#if defined LOCK_MODE
	lxunlock,
	#endif
	lsavepos,
	lback,
    #if defined USE_MENUS
	lgmenu,
	#endif
	lsetvip,
	ldelvip,
	#if defined USE_MENUS
	lteleport,
	#endif
	lgivearmor,
	lgiveskin,
	ljetpack,
	lgod,
	lalldisarm,
	llockchat,
	lhostname,
	lmapname,
	lgetalias,
	lport,
	linvisible,
	lgmx,
	lunban,
	lgotopos,
	lgetall,
	lmyinterior,
	lmyvirtualw,
	lsetfightstyle,
	//Here add new Level's if you got new Admin Commands.The two after this
	//do not have a Command and they don't get looped in /ahelp
	ladmintele, //Not Command
	lpmreader //Not Command
}
new g_Level[e_Level_Info];
new g_sCommandText[sizeof(g_Level)-2][] = {
	/* No NOT Change the order! */
	{"/kick"},
	{"/fake"},
	{"/heal"},
	{"/sethealth"},
	{"/slap"},
	{"/freeze"},
	{"/unfreeze"},
	{"/gravity"},
	{"/ip"},
	{"/ban"},
	{"/tban"},
	{"/goto"},
	{"/mute"},
	{"/unmute"},
	{"/akill"},
	{"/get"},
	{"/jail"},
	{"/unjail"},
	{"/settime"},
	{"/announce"},
	{"/addblack"},
	{"/addwhite"},
	{"/addclan"},
	{"/banip"},
	{"/nick"},
	{"/countdown"},
	{"/reloadcfg"},
	{"/reloadlanguages"},
	{"/reloadfs"},
	{"/reloadbans"},
	{"/allmoney"},
	{"/givecash"},
	{"/setmoney"},
	{"/setadmin"},
	{"/armor"},
	{"/giveweapon"},
	{"/a"},
	{"/sun"},
	{"/cloud"},
	{"/sandstorm"},
	{"/fog"},
	{"/rain"},
	#if defined USE_MENUS
	{"/ammu"},
	{"/weather"},
	#endif
	{"/disarm"},
	#if !defined _samp03_
	{"/numberplate"},
	#endif
	{"/allheal"},
	{"/resetmoney"},
	{"/clearchat"},
	{"/say"},
	{"/vr"},
	{"/flip"},
	{"/whitelist"},
	{"/blacklist"},
	{"/clanblacklist"},
	#if defined USE_MENUS
	{"/v"},
	#endif
	{"/skin"},
	{"/explode"},
	{"/setscore"},
	{"/carcolor"},
	{"/noon"},
	{"/night"},
	{"/morning"},
	{"/day"},
	#if defined SPECTATE_MODE
	{"/spec"},
	#endif
	{"/fuckup"},
	{"/force"},
	{"/ejet"},
	#if defined LOCK_MODE
	{"/xunlock"},
	#endif
	{"/savepos"},
	{"/back"},
	#if defined USE_MENUS
	{"/gmenu"},
	#endif
	{"/setvip"},
	{"/delvip"},
	#if defined USE_MENUS
	{"/teleport"},
	#endif
	{"/givearmor"},
	{"/giveskin"},

	{"/jetpack"},
	{"/god"},
	{"/alldisarm"},
	{"/lockchat"},
	{"/hostname"},
	{"/mapname"},
	{"/getalias"},
	{"/port"},
	{"/(in)visible"},
	{"/gmx"},
	{"/unban"},
	{"/gotopos"},
	{"/getall"},
	{"/myinterior"},
	{"/myvirtualworld"},
	{"/setfightstyle"}
	//Add new Commands here if you got some
};
/*---- Vehicle Spawn Menu ---*/
/* Read :
	Dont change the Sizes.
	If you dont really know how to increase vehicle menu size,dont do it
	It will freeze your game if you use a Buged Menu.
	If you know how to increase Menu size without bug the Script,
	Remember:
			You can only have 12 rows (Items) for each Menu
*/
#if defined USE_MENUS
new
	g_V_FastCars[12],
	g_V_Bikes[12],
	g_V_Planes[11],
	g_V_Boats[8],
	g_V_Special[10],
	g_V_LowRider[9];
#endif
/*------ Main Part -----*/
static s[128]; 								// - THE String

new
	bool:g_bShutDown,
	#pragma unused g_bShutDown
	//bool:bCountdownInProgress,            // - Bool to see if Countdown is active
	g_StepCountdown,                     	// - Countdown Count
	g_tCountdown,                			// - Timer for Countdown
	g_tTrigger,                  			// - Timer which triggers all functions
	g_tGMX,                                 // - Timer which triggers 'gmx' call
	#if defined DISPLAY_MODE
		g_Display,                       	// - Global DisplayMode
	#endif
	g_MAX_HELI_LAME_KILLS,                  // - Max allowed Kills in BadHeli
	g_DefJailTime,                  		// - Default time a player is in jail
	bool:g_bWhiteStatus,                    // - Bool for Whitelist State
	bool:g_bBlackListStatus,                // - Bool for Blacklist State
	bool:g_bClangBlackListStatus,           // - Bool for ClanBlacklist State
	bool:g_bDynamicWeather,             	// - Bool for dynamic Weather Update
	bool:g_bDynamicTime,                    // - Bool for dynamic Time Update
	bool:g_bDynamicScore,                   // - Bool for dynamic Score (Money=Score) Update
	bool:g_bTimers,                         // - Bool for trigger_time
	bool:g_bRegisterSpawn,                  // - Bool to check if "RegisterToSpawn" is needed
	bool:g_bIPComp,                         // - Bool to check if Auto IP Comparision should be active
	#if defined _samp03_
	bool:g_bForceDialog,                    // - Bool to check if LoginDialog should pop up when joining
	#endif
	#if defined DISPLAY_MODE
		#if !defined DISPLAY_MODE_TD
			g_tRestart,                      // - Timer to restart g_Display Mode
		#endif
	#endif
/* Read :
	This are the Settings for the Timer which Triggers all
	Timed Functions in gAdmin
*/
	g_Time,                                 // - Stores Current Worldtime
	#define g_TimeUpdate (60)     			// - Time in Seocnds until g_Time will be increased by 1 ( +1Hour)
	g_WeatherUpdate=5*60, 					// - Time in Seconds until Weather will by changed (changes when function get triggered)
	#define g_ScoreUpdate (5)				// - Time in Seconds until Score will be changed to current Player Money
	#define g_GodUpdate (3)                	// - Time in Seconds until Player get's God "power"
	#if defined DISPLAY_MODE
		g_SpeedOMeterUpdate=1,               // - Time in Seconds until Update of SpeedOMeter
		g_AreaNameUpdate=3,                  // - Time in Seconds until Update of AreaName
		g_SpeedNameUpdate=1,                 // - Time in Seconds until Update of SpeedOMeter and AreaName
	#endif
	#if !defined NO_JAIL_COUNT
    g_JailCountInterval_Count,
    #define g_JailCountIntervalUpdate (5)
    #define g_JailCountInterval_Info (5*60)  // - Information for Admins if player is for this time in jail
    #endif
	#if defined LOCK_MODE
		#define g_CheckLockUpdate (1*60)     // - Time in Seconds until check of VehicleLock State
	#endif
/* Read :
	Dont change anything here.It holds the time for GameText in DisplayMode.
	+200 is needed because it takes some time until it Updates stuff for every
	Player.
	Do prevent old text from fading out until new one is created we add 200(ms)
	to the normal time we want to show it.
*/
	#if defined DISPLAY_MODE
		#define g_SpeedOMeterUpdate_GT \
		    (g_SpeedOMeterUpdate*1000+200)
		#define g_AreaNameUpdate_GT \
		    (g_AreaNameUpdate*1000+200)
		#define g_SpeedNameUpdate_GT \
		    (g_SpeedNameUpdate*1000+200)
	#endif

	g_TimeUpdate_Count,                     // - Counts up until reaches g_TimeUpdate to Update time
	g_WeatherUpdate_Count,                  // - Counts up until reaches g_WeatherUpdate to Update Weather
	g_ScoreUpdate_Count,                    // - Counts up until reaches g_ScoreUpdate to Update Score
	g_GodUpdate_Count,                     	// - Counts up until reaches g_GodUpdate to Update Score
	#if defined DISPLAY_MODE
		g_SpeedOMeterUpdate_Count,          // - Counts up until reaches g_SpeedOMeterUpdate to Update SpeedOMeter
		g_AreaNameUpdate_Count,             // - Counts up until reaches g_AreaNameUpdate to Update AreaName
		g_SpeedNameUpdate_Count,            // - Counts up until reaches g_SpeedNameUpdate to Update SpeedOMeter and AreaName
	#endif
	#if defined LOCK_MODE
		g_CheckLockUpdate_Count,             // - Counts up until reaches g_CheckLockUpdate to check VehicleLock State
	#endif

	g_PingKickInterval_Count,                // - Counts up until reaches g_PingKickInterval to check Pings

	g_MAX_VOTE_KICKS,                         	// - Max allowed votes until Player gets VoteKicked
	g_MAX_VOTE_BANS,                          	// - Max allowed votes until Player gets VoteBanned

	bool:g_bShow_EnterLeave,                   	// - Bool for showing Enter and Leaving Messages
	bool:g_bShow_AdminCommand,                 	// - Bool for showing AdminCommands (Example: Admin XY kicked Player ABC) to every Player or only Admins
	bool:g_bLockChat,                          	// - Bool to lock chat
	g_MAX_BAD_WORDS,                          	// - Max allowed count for a Player using unnecessary words
	g_MAX_LOGIN_TIME,                         	// - Max Time in Seconds a Player has to login when Spawning without Logging in into a registrated account first
	g_sAdvertise[128],                    		// - String for advertise,might be a website!
	Float:g_fGodValue,                         	// - Stores the HP for GodUpdate();
	Float:g_fSlapHP,                            // - HP to take a Player away when slapping him
	bool:g_bACMDS,                             	// - Bool for check if AdminCommand Strings has already been created
	bool:g_bGCMDS,                             	// - Bool for check if GeneralCommand Strings has already been created
	g_iAutoUnmute,
	g_sAdminCommandInfo[4][2][128],
	g_sGeneralCommandInfo[4][128],
	Language:g_l_German,
	Language:g_l_English,
	Language:g_l_Polski,                        // - Translated by DerPole
	Language:g_l_Magyar,                        // - Translated by Gamestar from sa-mp.com forums (http://forum.sa-mp.com/index.php?action=profile;u=76016)
	Language:g_l_ChineseT,                      // - Translated by tjying95 from sa-mp.com forums (http://forum.sa-mp.com/index.php?action=profile;u=66557)
	Language:g_l_ChineseS,                      // - Translated by tjying95 from sa-mp.com forums (http://forum.sa-mp.com/index.php?action=profile;u=66557)
	Language:g_l_Dutch,                      	// - Translated by [LTRP]TvW ( http://ltrp.clan.su/ )

	#define MAX_BAD_WORDS_LIST 80
	#define MAX_BAD_WORD_LEN 30

	#if defined ANTI_SPAM
	g_SpamRate,                                 // In which interval g_MaxSpamMessages shouldn't be achieved
	g_MaxSpamMessages,
	#endif

	g_BadWords[MAX_BAD_WORDS_LIST][MAX_BAD_WORD_LEN],	  // - Array stores all Bad Word Entrys
	g_BadWordsSize=0,                         	// - Count of Bad Word Entrys
	#if defined irc_gAdmin
	g_iLastIRCTick,
	#endif
/*---- PingKick System ---*/
	g_MAX_PING,                              // - Max allowed Ping on Server
	g_MAX_PING_WARNINGS,                     // - Max allowed Warnings until Player gets kicked for too high Ping
	g_PingKickInterval,                      // - Interval in which PingCheck will be made
	bool:g_bPingKickStatus;                  // - Bool to set PingKick to activ / deactive
/*---- MAX PLAYERS Variablen ---*/
/* Read:
	No Informations about the following vars.
	I dont think I have to explain them all,you can easily get
	what they stand for by looking at the var names.
*/
/*
#define PLAYER_FLAG_GOD ( 1 << 1)
#define PLAYER_FLAG_VIP ( 1 << 2)
#define PLAYER_FLAG_MUTE ( 1 << 3)
#define PLAYER_FLAG_INVISIBLE ( 1 << 4)
#define PLAYER_FLAG_SPECTATED ( 1 << 5)
#define PLAYER_FLAG_SPEEDO ( 1 << 6)
#define PLAYER_FLAG_LOGGEDIN ( 1 << 7)
#define PLAYER_FLAG_LOGINCHECK ( 1 << 8)
#define PLAYER_FLAG_JAIL ( 1 << 9)
#define PLAYER_FLAG_REGISTERMSG ( 1 << 10)
#define PLAYER_FLAG_VTEXT ( 1 << 11)
#define PLAYER_FLAG_DRAWAVAILABLE ( 1 << 12)
#define PLAYER_FLAG_FREEZE ( 1 << 13)
#define PLAYER_FLAG_LOGINPANEL ( 1 << 14 )
*/

enum (<<= 1)
{
	PLAYER_FLAG_GOD = 1,
	PLAYER_FLAG_VIP,
	PLAYER_FLAG_MUTE,
	PLAYER_FLAG_INVISIBLE,
	PLAYER_FLAG_SPECTATED,
	PLAYER_FLAG_SPEEDO,
	PLAYER_FLAG_LOGGEDIN,
	PLAYER_FLAG_LOGINCHECK,
	PLAYER_FLAG_JAIL,
	PLAYER_FLAG_REGISTERMSG,
	PLAYER_FLAG_VTEXT,
	PLAYER_FLAG_DRAWAVAILABLE,
	PLAYER_FLAG_FREEZE,
	PLAYER_FLAG_LOGINPANEL
};
#define IsPlayerFlag(%0,%1) \
	(PlayerInfo[%0][ibFlag] & (%1) )

#define AddPlayerFlag(%0,%1) \
	(PlayerInfo[%0][ibFlag] |= %1 )

#define DeletePlayerFlag(%0,%1) \
	(PlayerInfo[%0][ibFlag] &= ~%1 )

#define ResetPlayerFlag(%0) \
	(PlayerInfo[%0][ibFlag] = 0)

enum e_Player_Info {
	AdminLevel,
	#if defined MYSQL
	UniqueID,
	#endif
	PingWarnings,
	WrongPW,
	#if defined LOGIN_PANEL
	tLoginPanel,
	#endif
	#if defined ANTI_SPAM
	TickLastSpamCheck,
	SpamCount,
	iSpamRelease,
	#endif
	#if !defined NO_JAIL_COUNT
	JailCount,
	#endif
	tJail,
	ibFlag,
	Color,
	TickRegMsg,
	DisconnectReason,
	#if defined PMBIND_INCLUDE
	BindPMtoID,
	#endif
	#if defined EXTRA_COMMANDS
	Bounty,
	BankMoney,
	#endif
	Deaths,
	Kills,
	WrongRCON,
	#if defined SPECTATE_MODE
	Spec,
	#endif
	LameCounter,
	BadWordCount,
	SpawnCount,
	tLogin,
	ExMenu,
	#if defined DISPLAY_MODE
		speedo_type,
		#if !defined _samp03_
		Float:foX,
		Float:foY,
		Float:foZ,
		Float:fnX,
		Float:fnY,
		Float:fnZ,
		#endif
		#if defined DISPLAY_MODE_TD
			Text:td_PlayerDraw,
		#endif
	#endif
    Float:fSave[6], // X,Y,Z,Facing,Interior,VW
    #if defined _samp03_
    iDialogID,
    #endif
    VKickCount,
	VBanCount,
	bool:bVKick[MAX_PLAYERS],
	bool:bVBan[MAX_PLAYERS],
	tickConnect,
	iSeconds
}
new PlayerInfo[MAX_PLAYERS][e_Player_Info];

enum (<<= 1)
{
	VEHICLE_FLAG_LOCK = 1,
	VEHICLE_FLAG_DESTROY
}

#define IsVehicleFlag(%0,%1) \
	(VehicleInfo[%0][ibFlag] & (%1) )

#define AddVehicleFlag(%0,%1) \
	(VehicleInfo[%0][ibFlag] |= %1 )

#define DeleteVehicleFlag(%0,%1) \
	(VehicleInfo[%0][ibFlag] &= ~%1 )


enum e_Vehicle_Info {
	#if defined LOCK_MODE
		LockCount,
	#endif
	ibFlag,
	iOwnerID // Keep track WHO locked the vehicle in case it streamin again for him
}

static VehicleInfo[MAX_VEHICLES][e_Vehicle_Info];

new saReason[][]= {
	{"Timeout"}, // 0
	{"Leaving"}, // 1
	{"Kicked"}, // 2
	{"Whitelist"}, // 3
	{"Blacklist"}, // 4
	{"ClanBlacklist"}, // 5
	{"Range IP"}, // 6
	{"Wordfilter"}, // 7
	{"PingKick"}, // 8
	{"Login Error"},// 9
	{"LameKick"}, // 10
	{"No Login"}, // 11
	{"Voted"}, // 12
	{"Banned"}, // 13
	{"TimeBanned"} // 14
};
#define CMD_REGISTER register
#define CMD_LOGIN login
#define CMD_CHANGEPW changepw
#define CMD_COMMANDS commands
/*
enum e_Register {
	sCommand[12],
	CommandLen
}

new RegisterCommands[4][e_Register]= {

	COMMANDSNAME  	- You HAVE TO write it down here
	COMMANDLEN      - We set the len new when we start filterscript,thats why -1 is default

	{"register",	-1},         // command to registration
	{"login",		-1},         // command to login
	{"changepw",	-1},         // command to change password
	{"commands",	-1}          // command to show all commands
};
#define CMD_REGISTER \
	RegisterCommands[0][sCommand]
#define CMD_REGISTER_LEN \
	RegisterCommands[0][CommandLen]

#define CMD_LOGIN \
	RegisterCommands[1][sCommand]
#define CMD_LOGIN_LEN \
	RegisterCommands[1][CommandLen]

#define CMD_CHANGEPW \
	RegisterCommands[2][sCommand]
#define CMD_CHANGEPW_LEN \
	RegisterCommands[2][CommandLen]

#define CMD_COMMANDS \
	RegisterCommands[3][sCommand]
#define CMD_COMMANDS_LEN \
	RegisterCommands[3][CommandLen]
*/
/*---- Random ---*/
new Float:g_fJailPos[][3] = 						// Dont like it if everyone is in the same jail
{
	{197.471,	174.162,	1002.816},
	{193.371,	174.162,	1002.816}
};
new g_WeatherID[]={
	1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
};
/*--------- Script begin --------*/

public OnFilterScriptInit()
{
	new
	    ThePlayer[MAX_PLAYER_NAME],
	    IP[16],
	    i,
		Year,
		Month,
		Day;
    g_bShutDown = false;
	print(" Loading Script by Goldkiller");
	print("-------------------------------------+");
	print(" * gAdmin - Version: " #gVersion "");
	#if defined MYSQL
	print(" * gSQL by MadniX & Goldkiller");
	#endif
	#if defined irc_gAdmin
	print(" * IRC Support - Ingocnitos IRC Plugin");
	#endif
	g_Max_Players = GetMaxPlayers();
	if(!fexist("gAdmin Language/")) {
		print(" ERROR: 'gAdmin Language' Folder is missing!(scriptfiles/gAdmin Language)");
		print("gAdmin is shutting down!Read the install.txt again please.");
		print("-------------------------------------+\n");
		return 0;
	}
	g_l_German=AddLanguage("GER","Deutsch","txt");
	g_l_English=AddLanguage("ENG","English","txt");
	g_l_Polski=AddLanguage("PL","Polski","txt");
	g_l_Magyar=AddLanguage("HUN","Magyar","txt");
	g_l_ChineseS=AddLanguage("CHNs","Chinese(Simplified)","txt");
	g_l_ChineseT=AddLanguage("CHNt","Chinese(Traditional)","txt");
	g_l_Dutch=AddLanguage("NED","Dutch","txt");
	LoadLanguageFile(g_l_German);
	LoadLanguageFile(g_l_English);
	LoadLanguageFile(g_l_Polski);
	LoadLanguageFile(g_l_Magyar);
	LoadLanguageFile(g_l_ChineseS);
	LoadLanguageFile(g_l_ChineseT);
	LoadLanguageFile(g_l_Dutch);
	SetServerLanguage(g_l_English);
	LoadBasicText();
	if(!fexist("gAdmin Log/")) {
		print(" ERROR: 'gAdmin Log' Folder is missing!(scriptfiles/gAdmin Log)");
		print(GetLanguageString(ServerLanguage(),"txt_missingfolder"));
		print("-------------------------------------+\n");
		return 0;
	}
	#if !defined MYSQL
	if(!fexist("gAdmin User/")) {
		print(" ERROR: 'gAdmin User' Folder is missing!(scriptfiles/gAdmin User)");
		print(GetLanguageString(ServerLanguage(),"txt_missingfolder"));
		print("-------------------------------------+\n");
		return 0;
	}
	#endif
	if(!fexist("gAdmin Config/")) {
		print(" ERROR: 'gAdmin Config' Folder is missing!(scriptfiles/gAdmin Config)");
		print(GetLanguageString(ServerLanguage(),"txt_missingfolder"));
		print("-------------------------------------+\n");
		return 0;
	}
	if(!fexist(clanblacklist_file)) {
		INI_Create(clanblacklist_file);
		print(" * Creating " #clanblacklist_file " ...");
	}
	if(!fexist(blacklist_file)) {
		INI_Create(blacklist_file);
		print(" * Creating " #blacklist_file " ...");
	}
	if(!fexist(whitelist_file)) {
		INI_Create(whitelist_file);
		print(" * Creating " #whitelist_file" ...");
	}
	if(!fexist(ipbans_file)) {
		INI_Create(ipbans_file);
		print(" * Creating "#ipbans_file" ...");
	}
	if(!fexist(clearlog)) {
		INI_Create(clearlog);
		print(" * Creating " #clearlog" ...");
	}
	if(!fexist(viplog)) {
		INI_Create(viplog);
		print(" * Creating " #viplog" ...");
	}
	if(!fexist(adminlog)) {
		INI_Create(adminlog);
		print(" * Creating " #adminlog" ...");
	}
	if(!fexist(reportlog)) {
		INI_Create(reportlog);
		print(" *  Creating "#reportlog" ...");
	}
	if(!fexist(AdminList)) {
		INI_Create(AdminList);
		print(" * Creating "#AdminList" ...");
	}
	if(!fexist(BadWords_file)) {
		INI_Create(BadWords_file);
		print(" * Creating "#BadWords_file" ...");
	}
	if(!fexist(AliasList)) {
		INI_Create(AliasList);
		print(" * Creating "#AliasList" ...");
	}
	if(!fexist(AliasList_Buf)) {
		INI_Create(AliasList_Buf);
		print(" * Creating "#AliasList_Buf" ...");
	}
	#if defined MYSQL
    InitSQL();
	#endif
	LoadConfig();
	LoadBadWordsEntrys();
	if(g_bIPComp) {
		for( i = 0; i < g_Max_Players ; i++) {
		    if(!IsPlayerNPC(i)) { // NPC's autologin ? - Nope
		        if(GetPlayerName(i,ThePlayer,sizeof(ThePlayer)) ) {
					#if defined MYSQL
					if(gSQL_ExistUser(ThePlayer)) {
					#else
					if(udb_Exists(ThePlayer)) {
					#endif
					    IP[0]='\0';
					    s[0]='\0';
						#if defined MYSQL
					    strcat(s,gSQL_GetUserVar(ThePlayer,"IP"),sizeof(s));
						#else
					    strcat(s,dUser(ThePlayer).("IP"),sizeof(s));
					    #endif
			            GetPlayerIp(i,IP,sizeof(IP));
						if((!strcmp(IP,s,true,sizeof(IP))) && (s[0])) {
							OnPlayerLogin(i,LOGIN_AUTOIP);
						}
					}
				}
			}
		}
	}
	#if defined DISPLAY_MODE_TD
	for( i = 0; i < g_Max_Players ; i++) {
	    if(IsPlayerConnected(i) && !IsPlayerNPC(i)) {
			CreatePlayerDraw(i);
			if(IsPlayerInAnyVehicle(i)) {
				TextDrawShowForPlayer(i,PlayerInfo[i][td_PlayerDraw]);
				AddPlayerFlag(i,PLAYER_FLAG_SPEEDO);
			}
		}
	}
	#endif
	getdate(Year,Month,Day);
	format(s,sizeof(s),GetLanguageString(ServerLanguage(),"txt_activated"),Month,Day,Year);
	WriteLog(clearlog,s);
	#if defined SAVE_ADDITION
	SetTimer("SaveProfiles",SAVE_TIME,1);
	#endif
	SendClientMessageToAll(COLOR_ORANGE,"** gAdmin Filterscript: On");
	/*
	for( i = 0; i < sizeof(RegisterCommands) ; i++ ) {
		RegisterCommands[i][CommandLen]=strlen(RegisterCommands[i][sCommand]);
	}
	*/
	return 1;
}
public OnFilterScriptExit()
{
	new
		Year,
		Month,
		Day;
    g_bShutDown = true;
	print("\n-------------------------------------+");
	print(" * " #gVersion "");
	print(" * Deactivating...");
	//Destroy Menus
	#if defined USE_MENUS
	if(IsValidMenu(m_Pistole)) 		DestroyMenu(m_Pistole);
	if(IsValidMenu(m_MicroSMG)) 	DestroyMenu(m_MicroSMG);
	if(IsValidMenu(m_Shotguns)) 	DestroyMenu(m_Shotguns);
	if(IsValidMenu(m_Items)) 		DestroyMenu(m_Items);
	if(IsValidMenu(m_SMG)) 			DestroyMenu(m_SMG);
	if(IsValidMenu(m_Rifles)) 		DestroyMenu(m_Rifles);
	if(IsValidMenu(m_Assaultrifle)) DestroyMenu(m_Assaultrifle);
	if(IsValidMenu(m_BigOnes)) 		DestroyMenu(m_BigOnes);
	if(IsValidMenu(m_HandGuns)) 	DestroyMenu(m_HandGuns);
	if(IsValidMenu(m_Grenade)) 		DestroyMenu(m_Grenade);
	if(IsValidMenu(m_ImportTuner)) 	DestroyMenu(m_ImportTuner);
	if(IsValidMenu(m_LowRider)) 	DestroyMenu(m_LowRider);
	if(IsValidMenu(m_AmmuNation)) 	DestroyMenu(m_AmmuNation);
	if(IsValidMenu(m_V)) 			DestroyMenu(m_V);
	if(IsValidMenu(m_Rims)) 		DestroyMenu(m_Rims);
	if(IsValidMenu(m_Color)) 		DestroyMenu(m_Color);
	if(IsValidMenu(m_Bikes)) 		DestroyMenu(m_Bikes);
	if(IsValidMenu(m_Boats)) 		DestroyMenu(m_Boats);
	if(IsValidMenu(m_Planes)) 		DestroyMenu(m_Planes);
	if(IsValidMenu(m_FastCars)) 	DestroyMenu(m_FastCars);
	if(IsValidMenu(m_Special)) 		DestroyMenu(m_Special);
	if(IsValidMenu(m_Weather)) 		DestroyMenu(m_Weather);
	if(IsValidMenu(m_LS)) 			DestroyMenu(m_LS);
	if(IsValidMenu(m_SF)) 			DestroyMenu(m_SF);
	if(IsValidMenu(m_LV)) 			DestroyMenu(m_LV);
	if(IsValidMenu(m_Desert)) 		DestroyMenu(m_Desert);
	if(IsValidMenu(m_Country)) 		DestroyMenu(m_Country);
	if(IsValidMenu(m_Teleport)) 	DestroyMenu(m_Teleport);
	#endif
	print(" * Menus destroyed");
	//Destroy Timers
	KillTimer(g_tTrigger);
	KillTimer(g_tCountdown);
	print(" * Timers destroyed");
	#if defined irc_gAdmin
	IRC_Quit(EchoBot,"" #gVersion " IRC Bot - by Goldkiller (www.san-vice.de.vu)");
	print(" * Disconnected Echo Bot");
	#endif
	foreachEx(i) {
		if(IsPlayerFlag(i,PLAYER_FLAG_LOGGEDIN)) { /* Contains check if player is connected */
            OnPlayerLogout(i);
		}
		#if defined DISPLAY_MODE_TD
		DestroyPlayerDraw(i);
		#endif
	}
	#if defined MYSQL
    CloseSQL();
	#endif
	SendClientMessageToAll(COLOR_RED2,"** gAdmin Filterscript: Off");
	getdate(Year,Month,Day);
	format(s,sizeof(s),GetLanguageString(ServerLanguage(),"txt_deactivated"),Month,Day,Year);
	WriteLog(clearlog,s);
	print(" * Complete :)");
	print("-------------------------------------+\n");
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) return 0;
	new
		i,
		sAliasEntry[ALIAS_ENTRY_LEN],
		IP[16],
		x[128],
		ThePlayer[MAX_PLAYER_NAME];
    ResetPlayerFlag(playerid);
	PlayerInfo[playerid][Deaths]=0;
	PlayerInfo[playerid][Kills]=0;
	PlayerInfo[playerid][PingWarnings]=0;
	PlayerInfo[playerid][WrongPW]=0;
 	PlayerInfo[playerid][AdminLevel]=0;
 	PlayerInfo[playerid][iSpamRelease]=-1;
    #if defined _samp03_
	PlayerInfo[playerid][iDialogID]=-1;
	#endif
	#if !defined NO_JAIL_COUNT
	PlayerInfo[playerid][JailCount]=-1;
	#endif
	PlayerInfo[playerid][DisconnectReason]=-1;
	SetDefaultPlayerLanguageID(playerid,def_printlanguage);		 // Default Language English
	#if defined EXTRA_COMMANDS
	PlayerInfo[playerid][BankMoney]=0;
	#endif
	PlayerInfo[playerid][LameCounter]=0;
	PlayerInfo[playerid][SpawnCount]=0;
	#if defined SPECTATE_MODE
	PlayerInfo[playerid][Spec]=FREE_SPEC_ID;
	#endif
	PlayerInfo[playerid][BadWordCount]=0;
	PlayerInfo[playerid][ExMenu]=0;
	#if defined ANTI_FLOOD
	PlayerInfo[playerid][SpamCount]=0;
	PlayerInfo[playerid][WrongRCON]=0;
	PlayerInfo[playerid][TickLastSpamCheck]=GetTickCount();
	#endif
	#if defined DISPLAY_MODE
	PlayerInfo[playerid][speedo_type]=KMH_MODE;		  // Default SpeedoType
	if(g_Display!=0) {
		AddPlayerFlag(playerid,PLAYER_FLAG_SPEEDO);
	}
	#if defined DISPLAY_MODE_TD
		CreatePlayerDraw(playerid);
		TextDrawHideForPlayer(playerid,PlayerInfo[playerid][td_PlayerDraw]);
	#endif
	#endif
	#if defined PMBIND_INCLUDE
	BindPlayerPM(playerid,INVALID_PLAYER_ID);
	#endif
	//Vote System
	for( i = 0  ; i < g_Max_Players ; i++) {
		PlayerInfo[playerid][bVKick][i]=false;
		PlayerInfo[playerid][bVBan][i]=false;
	}
	PlayerInfo[playerid][VKickCount]=0;
	PlayerInfo[playerid][VBanCount]=0;
	for( i = 0 ; i < 6 ; i++) {
		PlayerInfo[i][fSave][i]=0.0;
	}
	//
	GetPlayerIp(playerid,IP,sizeof(IP));
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	WriteAliasListEntry(playerid,ThePlayer,IP);
	format(x,sizeof(x),"*** %s joined the Server",ThePlayer);
	format(s,sizeof(s),"%s [IP:%s]",x,IP);
	format(sAliasEntry,sizeof(sAliasEntry),GetAliasEntry( IP, ThePlayer ));
	for( i=0 ; i < g_Max_Players ; i++) {
	    if(IsPlayerConnected(i)) {
			if(PlayerInfo[i][AdminLevel]>=2) {
				SendClientMessage(i,COLOR_LIGHTBLUE,s);
			}
			if(g_bShow_EnterLeave && 2 > PlayerInfo[i][AdminLevel]) {
				SendClientMessage(i,COLOR_GREY,x);
			}
		    if(PlayerInfo[i][AdminLevel] >= g_Level[lgetalias]) {
		        SendClientMessage(i,COLOR_YELLOW,sAliasEntry);
		    }
		}
	}
	WriteLog(clearlog,sAliasEntry);
	WriteLog(clearlog,x);
	#if defined irc_gAdmin
		format(x,sizeof(x),"3%s",x);
		IRC_Say(EchoBot, EchoChan, x);
	#endif

	if(g_bWhiteStatus) {
		ReadWhiteList(playerid, ThePlayer);
	}
	if(g_bBlackListStatus) {
		ReadBlacklist(playerid, ThePlayer);
	}
	if(g_bClangBlackListStatus) {
		ReadClanBlacklist(playerid, ThePlayer);
 	}
	ReadIPBans(playerid, IP);

	for( i = 0 ; i < 9 ; i++) { // Clear Chat
		SendClientMessage(playerid,COLOR_DARKRED," \n");
	}
	#if defined LOCK_MODE
	for( i = 0 ; i < MAX_VEHICLES ; i++) { //We need to lock locked vehicles for this player too
		if(IsVehicleFlag(i,VEHICLE_FLAG_LOCK)) {
			SetVehicleParamsForPlayer(i,playerid,0,true);
		}
	}
	#endif
	// Automatic Login
	#if defined MYSQL
	if(gSQL_ExistUser(ThePlayer)) {
	#else
	if(udb_Exists(ThePlayer)) {
	#endif
	    // Trusted -1 means Banned
		#if defined MYSQL
		if(gSQL_GetUserVarAsInteger(ThePlayer,"Trusted") == -1 ) {
		#else
		if(dUserINT(ThePlayer).("Trusted") == -1 ) {
		#endif
			BanEx2(playerid,13);
		}
    	if(g_bIPComp) {
			#if defined MYSQL
			if(!strcmp(IP,gSQL_GetUserVar(ThePlayer,"IP"),true,sizeof(IP))) {
			#else
			if(!strcmp(IP,dUser(ThePlayer).("IP"),true,sizeof(IP))) {
			#endif
				OnPlayerLogin(playerid,LOGIN_AUTOIP);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_userexists",#CMD_LOGIN);
				#if defined LOGIN_PANEL
				if(g_bForceDialog) {
					PlayerInfo[playerid][tLoginPanel]=SetTimerEx("ShowLoginDialog",MS_LOGIN_PANEL,false,"d",playerid);
				}
				#endif
			}
		}
		/*
			If IPComparing is false and he doesnt get
			logged in,
			he needs to know that this profile exists
		*/
		else {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_userexists",#CMD_LOGIN);
			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_selectlanguage");
			#if defined LOGIN_PANEL
			if(g_bForceDialog) {
				PlayerInfo[playerid][tLoginPanel]=SetTimerEx("ShowLoginDialog",MS_LOGIN_PANEL,false,"d",playerid);
			}
			#endif
		}
	}
	else {
	    PlayerInfo[playerid][tickConnect] = GetTickCount();
		if(g_bRegisterSpawn) {
			SendClientLanguageMessage(playerid,COLOR_WHITE,"txt_registerspawn1");
		}
		else {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_register7",#CMD_REGISTER);
		}
	}
	SendClientMessage(playerid,COLOR_WHITE,"_____________________");
	SendClientMessage(playerid,COLOR_ORANGE,g_sAdvertise);
	SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_welcome",ThePlayer,#CMD_COMMANDS);
	SendClientMessage(playerid,COLOR_WHITE,"_____________________");
	CheckTimers();
	#if defined gDebug
	printf("disconnect reason connect = %d",PlayerInfo[playerid][DisconnectReason]);
	#endif
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerNPC(playerid)) return 0;
	new
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	/* No Language Messages here! */
	/* If DisconnectReason -1 we set it to the normal reason */
	if(PlayerInfo[playerid][DisconnectReason] == -1) {
	    #if defined gDebug
	    printf("New Disconnectreason = %d (old -1)",reason);
	    #endif
	    PlayerInfo[playerid][DisconnectReason]=reason;
	}
	#if defined gDebug
	printf("reason = %d - gAdmin reason = %d",reason,PlayerInfo[playerid][DisconnectReason]);
	#endif
	format(s,sizeof(s),"*** %s left the Server (%s)",ThePlayer,saReason[PlayerInfo[playerid][DisconnectReason]]);
	if(g_bShow_EnterLeave) {
		SendClientMessageToAll(COLOR_GREY,s);
	}
	print(s);
	WriteLog(clearlog,s);
	#if defined irc_gAdmin
	    format(s,sizeof(s),"5%s",s);
 		IRC_Say(EchoBot, EchoChan,s);
	#endif
	#if defined SPECTATE_MODE
	if(PlayerInfo[playerid][Spec]!=FREE_SPEC_ID) {
		ResetSpectateInfo(playerid);
		TogglePlayerSpectating(playerid,0);
		PlayerInfo[playerid][Spec] = FREE_SPEC_ID;
	}
	if(IsPlayerFlag(playerid,PLAYER_FLAG_SPECTATED)) {
	    DeletePlayerFlag(playerid,PLAYER_FLAG_SPECTATED);
		foreachEx(i) {
			if(PlayerInfo[i][Spec]==playerid) {
				TogglePlayerSpectating(i, 0);
				PlayerInfo[i][Spec]=FREE_SPEC_ID;
			}
		}
	}
	#endif
	if(IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
		OnPlayerLogout(playerid);
  	}
	CheckTimers(playerid);
	#if defined DISPLAY_MODE_TD
	DestroyPlayerDraw(playerid);
	#endif
	/*
	Something...
	*/
	if(IsPlayerFlag(playerid,PLAYER_FLAG_INVISIBLE)) {
	    SetPlayerColor(playerid,PlayerInfo[playerid][Color]);
	}
    if(IsPlayerFlag(playerid,PLAYER_FLAG_LOGINCHECK)) {
        DeletePlayerFlag(playerid,PLAYER_FLAG_LOGINCHECK);
		KillTimer(PlayerInfo[playerid][tLogin]);
	}
	DeletePlayerFlag(playerid,PLAYER_FLAG_VIP);
	DeletePlayerFlag(playerid,PLAYER_FLAG_SPEEDO);
	if(IsPlayerFlag(playerid,PLAYER_FLAG_JAIL)) { // If he was jailed we should better destroy the timer if a new player joins with the same id
		KillTimer(PlayerInfo[playerid][tJail]);
	}
	DeletePlayerFlag(playerid,PLAYER_FLAG_JAIL);
	DeletePlayerFlag(playerid,PLAYER_FLAG_GOD);
 	DeletePlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN);
 	PlayerInfo[playerid][AdminLevel]=-1;
	return 1;
}
public OnPlayerRequestSpawn(playerid)
{
	if(g_bRegisterSpawn) {
	    #if defined LOGIN_PANEL
		if(IsPlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL)) {
		    return 0;
		}
		#endif
   		if(!IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
			#if defined MYSQL
			if(!gSQL_ExistUser(PlayerName(playerid))) {
			#else
			if(!udb_Exists(PlayerName(playerid))) {
			#endif
	   			GameTextForPlayer(playerid,GetLanguageString(GetPlayerLanguageID(playerid),"txt_registerspawn2"),3*1000,5);
				PlayerPlaySound(playerid,1055 ,0.0,0.0,0.0);
				if(GetTickCount() > (PlayerInfo[playerid][TickRegMsg] + REGMSG_DELAY) ) {
					DeletePlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG);
				}
	   			if(!IsPlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG)) {
	   				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_registerspawn3",#CMD_REGISTER);
	   				PlayerInfo[playerid][TickRegMsg]=GetTickCount();
	   				AddPlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG);
				}
	   			return 0;
			}
			else { // Force to login!
	   			GameTextForPlayer(playerid,GetLanguageString(GetPlayerLanguageID(playerid),"txt_registerspawn5"),3*1000,5);
				PlayerPlaySound(playerid,1055 ,0.0,0.0,0.0);
				if(GetTickCount() > (PlayerInfo[playerid][TickRegMsg] + REGMSG_DELAY) ) {
					DeletePlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG);
				}
	   			if(!IsPlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG)) {
	   				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_registerspawn6",#CMD_LOGIN);
	   				PlayerInfo[playerid][TickRegMsg]=GetTickCount();
	   				AddPlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG);
				}
	   			return 0;

			}
		}
	}
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(IsPlayerFlag(playerid,PLAYER_FLAG_JAIL)) {
		SetJail(playerid,true);
		return 1;
	}
	PlayerInfo[playerid][SpawnCount]++;
	if(IsPlayerFlag(playerid,PLAYER_FLAG_FREEZE)) {
		TogglePlayerControllable(playerid,false);
		return 1;
	}
	if(!IsPlayerFlag(playerid,PLAYER_FLAG_LOGINCHECK)){
		if(g_MAX_LOGIN_TIME!=-1) {
			if(!IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
				#if defined MYSQL
				if(gSQL_ExistUser(PlayerName(playerid))) {
				#else
				if(udb_Exists(PlayerName(playerid))) {
				#endif
				    KillTimer(PlayerInfo[playerid][tLogin],600); // If there might be still a timer,destroy it!
					SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_LoginSpawn",g_MAX_LOGIN_TIME);
					PlayerInfo[playerid][tLogin]=SetTimerEx("Login",g_MAX_LOGIN_TIME*1000,0,"i",playerid);
					AddPlayerFlag(playerid,PLAYER_FLAG_LOGINCHECK);
					return 1;
				}
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(killerid != INVALID_PLAYER_ID) {
		#if defined EXTRA_COMMANDS
		if(PlayerInfo[playerid][Bounty] > 0) {
			GivePlayerMoney(killerid,PlayerInfo[playerid][Bounty]);
	    }
		PlayerInfo[playerid][Bounty]=0;
		#endif
		PlayerInfo[killerid][Kills]++;
	}
	PlayerInfo[playerid][Deaths]++;
	if(g_MAX_HELI_LAME_KILLS) {
		if(IsPlayerInBadHeli(killerid)) {
			PlayerInfo[killerid][LameCounter]++;
			if(PlayerInfo[killerid][LameCounter]==g_MAX_HELI_LAME_KILLS) {
			    /*
				SendClientLanguageMessageToAll(COLOR_RED2,"LameKickMsg",PlayerName(killerid));
			 	WriteLog(clearlog,LanguageString(ServerLanguage()));
				#if defined irc_gAdmin
					IRC_Say(EchoBot, EchoChan, LanguageString(ServerLanguage()));
				#endif
				*/
				KickEx(killerid,10);
			}
		}
	}
	#if defined irc_gAdmin
		if ((reason == 255) || (killerid == INVALID_PLAYER_ID)) {
			format(s, sizeof(s), "*** \2;%s\2; killed himself.",PlayerName(playerid));
		} else {
			format(s, sizeof(s), "*** \2;%s\2; was killed by \2;%s\2;. (2%s)", PlayerName(playerid),PlayerName(killerid), aWeaponNames[reason]);
		}
		IRC_Say(EchoBot, EchoChan,s);
	#endif
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	#if defined LOCK_MODE
	if(IsVehicleFlag(vehicleid,VEHICLE_FLAG_LOCK)) {
		foreachEx(i) {
			SetVehicleParamsForPlayer(vehicleid,i,0,0);
		}
	   	DeleteVehicleFlag(vehicleid,VEHICLE_FLAG_LOCK);
	}
	#endif
	if(IsVehicleFlag(vehicleid,VEHICLE_FLAG_DESTROY)) {   /* Fix for respawning vehicles */
	    DestroyVehicle(vehicleid);
	    DeleteVehicleFlag(vehicleid,VEHICLE_FLAG_DESTROY);
	}
	return 1;
}
#if defined LOCK_MODE
#if defined _samp03_
public OnVehicleStreamIn(vehicleid, forplayerid)
{
	if(IsVehicleFlag(vehicleid,VEHICLE_FLAG_LOCK)) {
		if(forplayerid == VehicleInfo[vehicleid][iOwnerID]) {
			SetVehicleParamsForPlayer(vehicleid,forplayerid,0,false);
		}
		else {
			SetVehicleParamsForPlayer(vehicleid,forplayerid,0,true);
		}
	}
}
#endif
#endif
public OnPlayerText(playerid, text[])
{
	new
		sBig[128+MAX_PLAYER_NAME+10],
		ThePlayer[MAX_PLAYER_NAME];
	#if defined LOGIN_PROTECTION
	if(!IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
	    // 7login blablabla
	    if(text[0]=='7' && !strcmp(text[1],#CMD_LOGIN,true)) {
	        // Dont display the message!
	        SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_login12");
			return 0;
	    }
	}
	#endif
	if(g_bLockChat) {
		if(PlayerInfo[playerid][AdminLevel] < 2) {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_lockchat5");
			return 0;
		}
	}
	if(IsPlayerFlag(playerid,PLAYER_FLAG_MUTE)) {
	    SendClientLanguageMessage(playerid,COLOR_RED2,"txt_mute6");
		return 0;
	}
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if(PlayerInfo[playerid][AdminLevel] < 2) {
    	#if defined ANTI_SPAM
		new
			cTick = GetTickCount();
		if(PlayerInfo[playerid][TickLastSpamCheck] >= (cTick - g_SpamRate)) { // Potential spam!
			PlayerInfo[playerid][SpamCount]++;
			if(PlayerInfo[playerid][SpamCount] >= g_MaxSpamMessages) {
		    	SendClientLanguageMessage(playerid,COLOR_RED2,"txt_mute7");
				CreateClientLanguageMessages("txt_mute8",PlayerName(playerid),playerid);
				AdminNote();
			   	AddPlayerFlag(playerid,PLAYER_FLAG_MUTE);
			   	PlayerInfo[playerid][iSpamRelease] = g_iAutoUnmute;
			   	return 0; // Don't send the message !
			}
		}
		else {
			PlayerInfo[playerid][SpamCount]=0;
		}
	    PlayerInfo[playerid][TickLastSpamCheck]=cTick;
    	#endif
	    //
		if(g_BadWordsSize) {
			for(new i;i<g_BadWordsSize;i++) {
				if(strfind(text,g_BadWords[i],true,0)!=-1) {
					PlayerInfo[playerid][BadWordCount]++;
					CreateClientLanguageMessages("txt_wfilter1",ThePlayer,text,g_BadWords[i]);
					AdminNote();
		   			#if defined irc_gAdmin
						IRC_Say(EchoBot, EchoChan,LanguageString(ServerLanguage()));
					#endif
					SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_wfilter3",PlayerInfo[playerid][BadWordCount],g_MAX_BAD_WORDS,g_BadWords[i]);
					SendPlayerMessageToAll(playerid,Fail_Blame[random(sizeof(Fail_Blame))]);
		 			if(PlayerInfo[playerid][BadWordCount]>=g_MAX_BAD_WORDS) {
						SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_wfilter2",ThePlayer);
						WriteLog(clearlog,LanguageString(ServerLanguage()));
						#if defined irc_gAdmin
							IRC_Say(EchoBot, EchoChan, LanguageString(ServerLanguage()));
						#endif
						KickEx(playerid,7);
					}
					return 0;
		   		}
			}
		}
	}
	if(IsPlayerFlag(playerid,PLAYER_FLAG_VTEXT)) {
		new
			mid;
		printf("PlayerFlag %d",PlayerInfo[playerid][ibFlag]);
		if(sscanf(text, "d",mid)) {
		    // Uses probably the vehiclename
		    new
		        Founds;
		    for(new i;i < sizeof(VehicleNames);i++) {
		        if(!strfind(VehicleNames[i],text,true)) {
		            Founds++;
		            mid=i;
		        }
		    }
		    if(Founds == 0) { // No matching entry
		        SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_vtext_invalid3",text);
		    }
		    else if(Founds == 1) { //correct entry,just 1
				new
				    vid,
					Float:fX,
					Float:fY,
					Float:fZ;
				mid+=400;
				GetPlayerPos(playerid,fX,fY,fZ);
	  		  	GetXYInFrontOfPlayer(playerid,fX,fY,6.0);
				vid=CreateVehicle(mid,fX,fY,fZ,0,-1,-1,0x7F800000);
	  			LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
	  			SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
	  			
	  			AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
				CreateClientLanguageMessages("txt_vtext_success",VehicleNames[mid-400]);
				SendClientPreLanguageMessage(playerid,COLOR_YELLOW);
	  			WriteLog(clearlog,LanguageString(ServerLanguage()));
				DeletePlayerFlag(playerid,PLAYER_FLAG_VTEXT);
				TogglePlayerControllable(playerid,true);
		    }
		    else {  // more matching entrys
		        SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_vtext_invalid4",text);
		    }
			//SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_vtext_invalid1");
			return 0;
		}
		if(mid < 400 || mid > 611) {
			SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_vtext_invalid2");
			return 0;
		}
		else {
			new
			    vid,
				Float:fX,
				Float:fY,
				Float:fZ;
			GetPlayerPos(playerid,fX,fY,fZ);
  		  	GetXYInFrontOfPlayer(playerid,fX,fY,6.0);
			vid=CreateVehicle(mid,fX,fY,fZ,0,-1,-1,0x7F800000);
  			LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  			SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  			AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
			CreateClientLanguageMessages("txt_vtext_success",VehicleNames[mid-400]);
			SendClientPreLanguageMessage(playerid,COLOR_YELLOW);
  			WriteLog(clearlog,LanguageString(ServerLanguage()));
			DeletePlayerFlag(playerid,PLAYER_FLAG_VTEXT);
			TogglePlayerControllable(playerid,true);
			return 0;
		}
	}
	#if defined PMBIND_INCLUDE
	if(IsPMBindActiveForPlayer(playerid)) {
	    SendPMToBindID(playerid,text);
	    return 0;
	}
	#endif
	if(text[0] == PREFIX_VIPCHAT && text[1]==' ')  {
		if((PlayerInfo[playerid][AdminLevel]>=2 || IsPlayerFlag(playerid,PLAYER_FLAG_VIP))) {
	 		format(sBig,sizeof(sBig),"[VIP] %s: %s",ThePlayer,text[1]);
	 		WriteLog(viplog,sBig);
			foreachEx(i) {
		   		if(IsPlayerFlag(playerid,PLAYER_FLAG_VIP) || PlayerInfo[i][AdminLevel]>=2) {
					SendClientMessage(i,COLOR_GREY,sBig);
				}
			}
			return 0;
		}
	}
   	if((text[0] == PREFIX_ADMINCHAT)) {
		if(PlayerInfo[playerid][AdminLevel]>=2) {
			AdminChat(playerid,text[1]);
			return 0;
		}
	}
	format(sBig,sizeof(sBig),"%s: %s",ThePlayer,text);
	WriteLog(clearlog,sBig);
	#if defined irc_gAdmin
		format(sBig,sizeof(sBig),"14%s05: %s",ThePlayer,text);
		IRC_Say(EchoBot, EchoChan, sBig);
	#endif
	return 1;
}

public OnPlayerPrivmsg(playerid, recieverid, text[])
{
	new
	    sBig[128+18+MAX_PLAYER_NAME+MAX_PLAYER_NAME+7],
   		ThePlayer[MAX_PLAYER_NAME];
	if(IsPlayerFlag(playerid,PLAYER_FLAG_MUTE)) {
		return 0;
	}
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	format(sBig,sizeof(sBig),"[PM] %s (%d) to %s (%d): %s",ThePlayer,playerid,PlayerName(recieverid),recieverid,text);
	WriteLog(clearlog,sBig);
	#if defined _samp03_
	printf(sBig);
	#endif
	if(PlayerInfo[playerid][AdminLevel] < 2 ) { // If no Admin
		foreachEx(i) {
			if(PlayerInfo[i][AdminLevel] >= g_Level[lpmreader] && i!=playerid && i!=recieverid) {
				SendClientMessage(i,COLOR_WHITE,sBig);
			}
		}
		if(g_BadWordsSize) {
			for(new i;i<g_BadWordsSize;i++) {
				if(strfind(text,g_BadWords[i],true,0)!=-1) {
					PlayerInfo[playerid][BadWordCount]++;
					CreateClientLanguageMessages("txt_wfilter1",ThePlayer,text,g_BadWords[i]);
					AdminNote();
					SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_wfilter3",PlayerInfo[playerid][BadWordCount],g_MAX_BAD_WORDS,g_BadWords[i]);
					SendPlayerMessageToAll(playerid,Fail_Blame[random(sizeof(Fail_Blame))]);
		   			#if defined irc_gAdmin
						IRC_Say(EchoBot, EchoChan,LanguageString(ServerLanguage()));
					#endif
		 			if(PlayerInfo[playerid][BadWordCount]>=g_MAX_BAD_WORDS) {
						SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_wfilter2",ThePlayer);
						WriteLog(clearlog,LanguageString(ServerLanguage()));
						#if defined irc_gAdmin
							IRC_Say(EchoBot, EchoChan, LanguageString(ServerLanguage()));
						#endif
						KickEx(playerid,7);
					}
					return 0;
				}
			}
		}
	}
	#if defined _samp03_
    format(sBig,sizeof(sBig),"PM from %s(%d):%s",ThePlayer,playerid,text);
    SendClientMessage(recieverid,COLOR_PM,sBig);
    format(sBig,sizeof(sBig),"PM to %s(%d):%s",PlayerName(recieverid),recieverid,text);
	SendClientMessage(playerid,COLOR_PM,sBig);
	#endif
	return 1;
}
/*
public OnPlayerCommandReceived(playerid, cmdtext[]) {
	printf("FS %d %s",playerid, cmdtext);
	return 1;
}
public OnPlayerCommandPerformed(playerid, cmdtext[], success) {
	printf("FS %d %s %d",playerid, cmdtext, success);
	return 1;
}
*/
public OnPlayerCommandText(playerid, cmdtext[])
{
	if(IsPlayerFlag(playerid,PLAYER_FLAG_VTEXT)) {
		return 0;
	}
/*
	#if defined _samp03_
	dcmd(pm,2,cmdtext);
	#endif
	dcmd(id,2,cmdtext);
	dcmd(info,4, cmdtext);
	dcmd(stats,5,cmdtext);
	dcmd(report,6,cmdtext);
	#if defined USE_MENUS
	dcmd(tuner,5,cmdtext);
	#endif
	dcmd(loc,3,cmdtext);
	dcmd(votekick,8,cmdtext);
	dcmd(voteban,7,cmdtext);
	dcmd(votelist,8,cmdtext);
	#if defined BASIC_COMMANDS
	dcmd(players,7, cmdtext);
	dcmd(clock,5,cmdtext);
	dcmd(date,4,cmdtext);
	dcmd(pos,3,cmdtext);
	dcmd(me,2,cmdtext);
	dcmd(kill,4,cmdtext);
	dcmd(givemoney,9,cmdtext);
	#endif
	#if defined EXTRA_COMMANDS
	dcmd(bank,4,cmdtext);
	dcmd(withdraw,8,cmdtext);
	dcmd(para,4,cmdtext);
	dcmd(hitman,6,cmdtext);
	dcmd(bounty,6,cmdtext);
	#endif
	#if defined LOCK_MODE
	dcmd(lock,4,cmdtext);
	dcmd(unlock,6,cmdtext);
	#endif
	#if defined DISPLAY_MODE
	dcmd(speedo,6,cmdtext);
	dcmd(speedotype,10,cmdtext);
	#endif
	//Admin Part

    dcmd2(CMD_REGISTER,	CMD_REGISTER_LEN,	cmdtext);
    dcmd2(CMD_LOGIN,	CMD_LOGIN_LEN,		cmdtext);
    dcmd2(CMD_CHANGEPW,	CMD_CHANGEPW_LEN,	cmdtext);
    dcmd2(CMD_COMMANDS,	CMD_COMMANDS_LEN,	cmdtext);

	dcmd(data,4,cmdtext);

	dcmd(language,8,cmdtext);

	dcmd(admins,6,cmdtext);
	//dcmd(sound,5,cmdtext,600); // was just a testcommand for my gamemode
	dcmd(ahelp,5,cmdtext);
	dcmd(kick,4,cmdtext);
	dcmd(fake,4,cmdtext);
 	dcmd(heal,4,cmdtext);
 	dcmd(sethealth,9,cmdtext);
 	dcmd(sethp,5,cmdtext);
	dcmd(slap,4,cmdtext);
	dcmd(freeze,6,cmdtext);
	dcmd(unfreeze,8,cmdtext);
	dcmd(gravity,7,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(ban,3,cmdtext);
	dcmd(tban,4,cmdtext);
	dcmd(goto,4,cmdtext);
	dcmd(mute,4,cmdtext);
	dcmd(unmute,6,cmdtext);
	dcmd(akill,5,cmdtext);
	dcmd(get,3,cmdtext);
	dcmd(jail,4,cmdtext);
	dcmd(unjail,6,cmdtext);
	dcmd(settime,7,cmdtext);
	dcmd(announce,8,cmdtext);
	dcmd(ann,3,cmdtext);
	dcmd(addblack,8,cmdtext);
	dcmd(addwhite,8,cmdtext);
	dcmd(addclan,7,cmdtext);
	dcmd(banip,5,cmdtext);
	dcmd(rangeban,8,cmdtext);
	dcmd(nick,4,cmdtext);
	dcmd(countdown,9,cmdtext);
	dcmd(reloadcfg,9,cmdtext);
	dcmd(reloadlanguages,15,cmdtext);
	dcmd(reloadfs,8,cmdtext);
	dcmd(reloadbans,10,cmdtext);
	dcmd(allmoney,8,cmdtext);
	dcmd(givecash,8,cmdtext);
	dcmd(setmoney,8,cmdtext);
	dcmd(setadmin,8,cmdtext);
	dcmd(armor,5,cmdtext);
	dcmd(armour,6,cmdtext);
	dcmd(giveweapon,10,cmdtext);
	dcmd(a,1,cmdtext);

	dcmd(sun,3,cmdtext);
	dcmd(cloud,5,cmdtext);
	dcmd(sandstorm,9,cmdtext);
	dcmd(fog,3,cmdtext);
	dcmd(rain,4,cmdtext);
	#if defined USE_MENUS
	dcmd(ammu,4,cmdtext);
	dcmd(weather,7,cmdtext);
	#endif
	dcmd(disarm,6,cmdtext);
	#if !defined _samp03_
	dcmd(numberplate,11,cmdtext);
	#endif
	dcmd(allheal,7,cmdtext);
	dcmd(resetmoney,10,cmdtext);
	dcmd(clear,5,cmdtext);
	dcmd(clearchat,9,cmdtext);
	dcmd(say,3,cmdtext);
	dcmd(vr,2,cmdtext);
	dcmd(flip,4,cmdtext);
	dcmd(whitelist,9,cmdtext);
	dcmd(blacklist,9,cmdtext);
	dcmd(clanblacklist,13,cmdtext);
	#if defined USE_MENUS
	dcmd(v,1,cmdtext);
	#endif
	dcmd(skin,4,cmdtext);
	dcmd(explode,7,cmdtext);
	dcmd(setscore,8,cmdtext);
	dcmd(carcolor,8,cmdtext);
	dcmd(noon,4,cmdtext);
	dcmd(night,5,cmdtext);
	dcmd(morning,7,cmdtext);
	dcmd(day,3,cmdtext);
	#if defined SPECTATE_MODE
	dcmd(spec,4,cmdtext);
	dcmd(specoff,7,cmdtext);
	#endif
	dcmd(fuckup,6,cmdtext);
	dcmd(force,5,cmdtext);
	dcmd(ejet,4,cmdtext);
	#if defined LOCK_MODE
	dcmd(xunlock,7,cmdtext);
	#endif
	dcmd(savepos,7,cmdtext);
	dcmd(gsave,5,cmdtext);
	dcmd(back,4,cmdtext);
	#if defined USE_MENUS
	dcmd(gmenu,5,cmdtext);
	#endif
	dcmd(setvip,6,cmdtext);
	dcmd(delvip,6,cmdtext);
	#if defined USE_MENUS
	dcmd(teleport,8,cmdtext);
	#endif
	dcmd(givearmor,9,cmdtext);
	dcmd(givearmour,10,cmdtext);
	dcmd(giveskin,8,cmdtext);
	dcmd(jetpack,7,cmdtext);
	dcmd(god,3,cmdtext);
	dcmd(alldisarm,9,cmdtext);
	dcmd(lockchat,8,cmdtext);
	dcmd(settings,8,cmdtext);
	dcmd(hostname,8,cmdtext);
	dcmd(mapname,7,cmdtext);
	dcmd(servername,10,cmdtext);
	dcmd(getalias,8,cmdtext);
	dcmd(port,4,cmdtext);
	dcmd(visible,7,cmdtext);
	dcmd(invisible,9,cmdtext);
	dcmd(gmx,3,cmdtext);
	dcmd(unban,5,cmdtext);
	dcmd(gotopos,7,cmdtext);
	dcmd(getall,6,cmdtext);
	dcmd(myinterior,10,cmdtext);
	dcmd(myvirtualworld,14,cmdtext);
	dcmd(setfightstyle,13,cmdtext);
*/
	return 0;
}
#if defined USE_MENUS
public OnPlayerSelectedMenuRow(playerid, row)
{
	new
	 	Menu:Current = GetPlayerMenu(playerid);
	if(Current==m_Weather) {
		PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		switch(row) {
			case 0:{
				SetWeather(1);
				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_sunny"));
			}
			case 1: {
  				SetWeather(20);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_foggy"));
			}
			case 2: {
  				SetWeather(16);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_rain"));
			}
			case 3: {
  				SetWeather(19);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_storm"));
			}
			case 4: {
  				SetWeather(9);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_clouds"));
			}
			case 5: {
  				SetWeather(8);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_stormy"));
			}
			case 6: {
  				SetWeather(11);
  				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_extremsunny"));
			}
			case 7: {
				SetWeather(g_WeatherID[random(sizeof(g_WeatherID))]);
				ResetWeatherUpdate();
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_weathrandom"));
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_ImportTuner) {
		TogglePlayerControllable(playerid,false);
		ShowMenuForPlayer(m_ImportTuner,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_TUNING;
		switch(row) {
			case 0:{
				if(GetPlayerMoney(playerid)<1000){
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Nos x10 [-1000 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
				GivePlayerMoney(playerid,-1000);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowMenuForPlayer(m_ImportTuner,playerid);
			}
			case 1: {
 				if(GetPlayerMoney(playerid)<500) {
 					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Nos x5 [-500 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1008);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowMenuForPlayer(m_ImportTuner,playerid);
			}
			case 2: {
				if(GetPlayerMoney(playerid)<200) {
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Nos x2 [-200 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1009);
				GivePlayerMoney(playerid,-200);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowMenuForPlayer(m_ImportTuner,playerid);
			}
			case 3: {
				if(GetPlayerMoney(playerid)<1500) {
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Hydraulics [-1500 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1087);
				GivePlayerMoney(playerid,-1500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowMenuForPlayer(m_ImportTuner,playerid);
				}
			case 4: {
		  		if(GetPlayerMoney(playerid)<100) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : BassBoost [-100 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1086);
				GivePlayerMoney(playerid,-100);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				ShowMenuForPlayer(m_ImportTuner,playerid);
				}
			case 5: {
				ShowMenuForPlayer(m_Rims,playerid);
			}
			case 6: {
				ShowMenuForPlayer(m_Color,playerid);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Rims) {
		TogglePlayerControllable(playerid,false);
		ShowMenuForPlayer(m_Rims,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_TUNING;
		switch(row) {
			case 0:{
				if(GetPlayerMoney(playerid)<820){
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Rims [-820 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1082);
				GivePlayerMoney(playerid,-820);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 1: {
 				if(GetPlayerMoney(playerid)<1000) {
 					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Ahab Rims [-1000 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1096);
				GivePlayerMoney(playerid,-1000);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 2: {
				if(GetPlayerMoney(playerid)<620) {
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Virtual Rims [-620 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1097);
				GivePlayerMoney(playerid,-620);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);

			}
			case 3: {
				if(GetPlayerMoney(playerid)<1030) {
					PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Mega Rims [-1030 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1074);
				GivePlayerMoney(playerid,-1030);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 4: {
		  		if(GetPlayerMoney(playerid)<1230) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Groove Rims [-1230 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1081);
				GivePlayerMoney(playerid,-1230);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 5:{
		  		if(GetPlayerMoney(playerid)<1620) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Classic Rims [-1620 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1077);
				GivePlayerMoney(playerid,-1620);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 6:{
		  		if(GetPlayerMoney(playerid)<1030) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Cutter Rims [-1030 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1079);
				GivePlayerMoney(playerid,-1030);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 7:{
		  		if(GetPlayerMoney(playerid)<980) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Rimshine Rims [-980 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1075);
				GivePlayerMoney(playerid,-980);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 8:{
		  		if(GetPlayerMoney(playerid)<1100) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Shadow Rims [-1100 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1073);
				GivePlayerMoney(playerid,-1100);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				}
			case 9:{
		  		if(GetPlayerMoney(playerid)<900) {
		  			PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
					return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
				}
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Switch Rims [-900 $]");
				AddVehicleComponent(GetPlayerVehicleID(playerid),1080);
				GivePlayerMoney(playerid,-900);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Color) {
		TogglePlayerControllable(playerid,false);
		ShowMenuForPlayer(m_Color,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_TUNING;
	   	if(GetPlayerMoney(playerid)<500){
	   		PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_ImportMoney");
		}
		switch(row) {
			case 0:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Red [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),3,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 1:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import White [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),1,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 2:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Blue [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),7,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 3:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Yellow [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),6,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 4:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Brown [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),61,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 5:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Grey [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),15,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 6:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Black [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),0,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 7:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Green [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),16,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 8:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Pink [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),126,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			case 9:{
				SendClientMessage(playerid,COLOR_ORANGE,"* ImportTuner : Import Lightblue [-500 $]");
				ChangeVehicleColor(GetPlayerVehicleID(playerid),32,1);
				GivePlayerMoney(playerid,-500);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_AmmuNation) {
		TogglePlayerControllable(playerid,false);
		PlayerInfo[playerid][ExMenu]=EX_MENU_AMMUNATION;
 		switch(row) {
			case 0:	{
				ShowMenuForPlayer(m_Pistole,playerid);
			}
			case 1: {
				ShowMenuForPlayer(m_MicroSMG,playerid);
			}
			case 2: {
				ShowMenuForPlayer(m_Shotguns,playerid);
			}
			case 3: {
				ShowMenuForPlayer(m_Items,playerid);
			}
			case 4: {
				ShowMenuForPlayer(m_SMG,playerid);
			}
			case 5: {
				ShowMenuForPlayer(m_Rifles,playerid);
			}
			case 6: {
				ShowMenuForPlayer(m_Assaultrifle,playerid);
			}
			case 7: {
				ShowMenuForPlayer(m_Grenade,playerid);
			}
			case 8: {
				ShowMenuForPlayer(m_HandGuns,playerid);
			}
			case 9: {
				ShowMenuForPlayer(m_BigOnes,playerid);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Pistole) {
		ShowMenuForPlayer(m_Pistole,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
 		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,22,50);
			}
			case 1: {
				GivePlayerWeapon(playerid,23,50);
			}
			case 2: {
				GivePlayerWeapon(playerid,24,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_MicroSMG) {
		ShowMenuForPlayer(m_MicroSMG,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,32,50);

			}
			case 1: {
				GivePlayerWeapon(playerid,28,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Shotguns) {
		ShowMenuForPlayer(m_Shotguns,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,25,50);
			}
			case 1: {
				GivePlayerWeapon(playerid,26,50);
			}
			case 2: {
				GivePlayerWeapon(playerid,27,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Items) {
		ShowMenuForPlayer(m_Items,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
 		switch(row) {
			case 0:	{
				SetPlayerArmour(playerid,100.0);
			}
			case 1:	{
				GivePlayerWeapon(playerid,46,1);
			}
			case 2:	{
				GivePlayerWeapon(playerid,41,100);
			}
			case 3:	{
				GivePlayerWeapon(playerid,43,50);
			}
			case 4:	{
				GivePlayerWeapon(playerid,44,1);
			}
			case 5:	{
				GivePlayerWeapon(playerid,45,1);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_SMG) {
 		ShowMenuForPlayer(m_SMG,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,29,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Assaultrifle) {
 		ShowMenuForPlayer(m_Assaultrifle,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,30,50);
			}
			case 1:	{
				GivePlayerWeapon(playerid,31,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Rifles) {
 		ShowMenuForPlayer(m_Rifles,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,33,50);

			}
			case 1:	{
				GivePlayerWeapon(playerid,34,50);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Grenade) {
 		ShowMenuForPlayer(m_Grenade,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,16,15);
			}
			case 1:	{
				GivePlayerWeapon(playerid,17,15);
			}
			case 2:	{
				GivePlayerWeapon(playerid,18,15);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_HandGuns) {
 		ShowMenuForPlayer(m_HandGuns,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,5,1);
			}
			case 1:	{
				GivePlayerWeapon(playerid,11,1);
			}
			case 2:	{
				GivePlayerWeapon(playerid,9,1);
			}
			case 3:	{
				GivePlayerWeapon(playerid,8,1);
			}
			case 4:	{
				GivePlayerWeapon(playerid,7,1);
			}
			case 5:	{
				GivePlayerWeapon(playerid,4,1);
			}
			case 6:	{
				GivePlayerWeapon(playerid,3,1);
			}
			case 7:	{
				GivePlayerWeapon(playerid,2,1);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_BigOnes) {
 		ShowMenuForPlayer(m_BigOnes,playerid);
		PlayerInfo[playerid][ExMenu]=EX_MENU_WEAPON;
		switch(row) {
			case 0:	{
				GivePlayerWeapon(playerid,38,500);
			}
			case 1:	{
				GivePlayerWeapon(playerid,35,20);
			}
			case 2:	{
				GivePlayerWeapon(playerid,37,150);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_V) {
		TogglePlayerControllable(playerid,false);
		PlayerInfo[playerid][ExMenu]=EX_MENU_VEHICLE;
  		switch(row) {
			case 0: {
				ShowMenuForPlayer(m_FastCars,playerid);
			}
			case 1: {
				 ShowMenuForPlayer(m_Bikes,playerid);
			}
			case 2: {
				ShowMenuForPlayer(m_Planes,playerid);
			}

			case 3: {
				ShowMenuForPlayer(m_Boats,playerid);
			}
			case 4: {
				ShowMenuForPlayer(m_LowRider,playerid);
			}
			case 5: {
				ShowMenuForPlayer(m_Special,playerid);
			}
			case 6: {
				AddPlayerFlag(playerid,PLAYER_FLAG_VTEXT);
				SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_vtext");
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Teleport) {
		TogglePlayerControllable(playerid,false);
		PlayerInfo[playerid][ExMenu]=EX_MENU_TELEPORT;
		switch(row) {
			case 0: {
				ShowMenuForPlayer(m_LS,playerid);
			}
			case 1: {
				ShowMenuForPlayer(m_SF,playerid);
			}
			case 2: {
				ShowMenuForPlayer(m_LV,playerid);
			}
			case 3: {
				ShowMenuForPlayer(m_Desert,playerid);
			}
			case 4: {
				ShowMenuForPlayer(m_Country,playerid);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_LS) {
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		CreateClientLanguageMessages("txt_teleport1",PlayerName(playerid),playerid);
		SendAdminCommand(COLOR_YELLOW);
		switch(row) {
			case 0: {
				TeleportPlayer(playerid,390.8239,-1795.4397,7.8281,0.8908);
			}
			case 1: {
				TeleportPlayer(playerid,1244.9454,-770.3463,91.7243,181.5461);
			}
			case 2: {
				TeleportPlayer(playerid,2500.5486,-1660.5367,13.2367,66.5785);
			}
			case 3: {
 				TeleportPlayer(playerid,1863.9141,-1403.1565,13.4763,264.7434);
			}
			case 4: {
				TeleportPlayer(playerid,1959.5099,-2254.6060,13.5469,177.3225);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_SF) {
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		CreateClientLanguageMessages("txt_teleport1",PlayerName(playerid),playerid);
		SendAdminCommand(COLOR_YELLOW);
		switch(row) {
			case 0: {
				TeleportPlayer(playerid,-1976.9542,286.9585,35.1719,85.4106);
			}
			case 1: {
				TeleportPlayer(playerid,-2707.0562,233.4540,4.1797,181.8948);
			}
			case 2: {
				TeleportPlayer(playerid,-2497.9233,-601.5134,132.5625,176.8813);
			}
			case 3: {
 				TeleportPlayer(playerid,-1340.6821,-390.6559,14.1484,254.2754);
			}
			case 4: {
				TeleportPlayer(playerid,-2568.8008,1145.0801,55.7266,158.0580);
			}
			case 5: {
				TeleportPlayer(playerid,-2250.2200,2306.4431,4.8125,93.6148);
			}
			case 6: {
				TeleportPlayer(playerid,-1607.0485,663.9161,7.1875,267.8714);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_LV) {
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
        CreateClientLanguageMessages("txt_teleport1",PlayerName(playerid),playerid);
		SendAdminCommand(COLOR_YELLOW);
		switch(row) {
			case 0: {
				TeleportPlayer(playerid,1473.2543,2772.5671,10.8203,91.6307);
			}
			case 1: {
				TeleportPlayer(playerid,1112.3640,1731.7129,10.8203,87.2440);
			}
			case 2: {
				TeleportPlayer(playerid,1306.1312,1277.0331,10.8203,359.5098);
			}
			case 3: {
 				TeleportPlayer(playerid,2394.4985,1014.8949,10.8203,87.5341);
			}
			case 4: {
				TeleportPlayer(playerid,2256.3958,2444.2156,10.8203,357.9199);
			}
			case 5: {
				TeleportPlayer(playerid,2034.1617,1527.3372,10.8203,277.4636);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Desert) {
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		CreateClientLanguageMessages("txt_teleport1",PlayerName(playerid),playerid);
		SendAdminCommand(COLOR_YELLOW);
		switch(row) {
			case 0: {
				TeleportPlayer(playerid,426.7758,2525.3838,16.5087,94.5547);
			}
			case 1: {
				TeleportPlayer(playerid,82.1171,1892.0632,17.6675,354.9138);
			}
			case 2: {
				TeleportPlayer(playerid,-313.6157,1529.2734,75.3594,265.9263);
			}
			case 3: {
 				TeleportPlayer(playerid,-1545.2017,2588.4954,55.6871,0.0746);
			}
			case 4: {
				TeleportPlayer(playerid,-912.3180,2006.3041,60.9141,229.4923);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_Country) {
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		CreateClientLanguageMessages("txt_teleport1",PlayerName(playerid),playerid);
		SendAdminCommand(COLOR_YELLOW);
		switch(row) {
			case 0: {
				TeleportPlayer(playerid,-2360.7373,-2171.0100,33.4430,182.0986);
			}
			case 1: {
				TeleportPlayer(playerid,-2313.0051,-1598.2239,483.9092,154.5249);
			}
			case 2: {
				TeleportPlayer(playerid,-535.1154,-191.0800,78.4063,91.7065);
			}
			case 3: {
 				TeleportPlayer(playerid,-1.6873,-301.0524,5.4229,94.5464);
			}
			case 4: {
				TeleportPlayer(playerid,2275.8835,31.7381,26.4844,359.2819);
			}
			case 5: {
				TeleportPlayer(playerid,857.1667,-23.7190,63.3210,162.5301);
			}
			case 6: {
				TeleportPlayer(playerid,-85.1657,-1153.5787,1.7500,82.6293);
			}
			default: {
				print("Fail");
			}
		}
	}
	else if(Current==m_FastCars) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,6.0);
 		PlayerInfo[playerid][ExMenu]=0;
 		vid=CreateVehicle(g_V_FastCars[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_FastCars[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	else if(Current==m_LowRider) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,6.0);
		PlayerInfo[playerid][ExMenu]=0;
 		vid=CreateVehicle(g_V_LowRider[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_LowRider[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	else if(Current==m_Bikes) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,6.0);
		PlayerInfo[playerid][ExMenu]=0;
 		vid=CreateVehicle(g_V_Bikes[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_Bikes[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	else if(Current==m_Planes) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,8.0);
		PlayerInfo[playerid][ExMenu]=0;
 		vid=CreateVehicle(g_V_Planes[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_Planes[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	else if(Current==m_Boats) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,7.0);
		PlayerInfo[playerid][ExMenu]=0;
 		vid=CreateVehicle(g_V_Boats[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_Boats[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	else if(Current==m_Special) {
	 	new
	 	    vid,
			Float:fX,
			Float:fY,
			Float:fZ;
		TogglePlayerControllable(playerid,true);
		PlayerInfo[playerid][ExMenu]=0;
		GetPlayerPos(playerid,fX,fY,fZ);
		GetXYInFrontOfPlayer(playerid,fX,fY,7.0);
 		vid=CreateVehicle(g_V_Special[row],fX,fY,fZ,0,-1,-1,0x7F800000);
  		LinkVehicleToInterior(vid,GetPlayerInterior(playerid));
  		SetVehicleVirtualWorld(vid,GetPlayerVirtualWorld(playerid));
  		AddVehicleFlag(vid,VEHICLE_FLAG_DESTROY);
  		format(s,sizeof(s),"** Spawned %s",VehicleNames[g_V_Special[row]-400]);
  		SendClientMessage(playerid,COLOR_GREY,s);
  		WriteLog(clearlog,s);
	}
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	TogglePlayerControllable(playerid,true);
	if(PlayerInfo[playerid][ExMenu]==EX_MENU_AMMUNATION || PlayerInfo[playerid][ExMenu]==EX_MENU_WEAPON) {
		ShowMenuForPlayer(m_AmmuNation,playerid);
		PlayerInfo[playerid][ExMenu]=0;
		TogglePlayerControllable(playerid,false);
	}
	else if(PlayerInfo[playerid][ExMenu]==EX_MENU_TUNING) {
		ShowMenuForPlayer(m_ImportTuner,playerid);
		PlayerInfo[playerid][ExMenu]=0;
		TogglePlayerControllable(playerid,false);
	}
	else if(PlayerInfo[playerid][ExMenu]==EX_MENU_TELEPORT) {
		ShowMenuForPlayer(m_Teleport,playerid);
		PlayerInfo[playerid][ExMenu]=0;
		TogglePlayerControllable(playerid,false);
	}
	else if(PlayerInfo[playerid][ExMenu]==EX_MENU_VEHICLE) {
		ShowMenuForPlayer(m_V,playerid);
		PlayerInfo[playerid][ExMenu]=0;
		TogglePlayerControllable(playerid,false);
	}
	return 1;
}
#endif
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	#if defined SPECTATE_MODE
	if(IsPlayerFlag(playerid,PLAYER_FLAG_SPECTATED)) {
	    new
	        vid=GetPlayerVehicleID(playerid);
		foreachEx(i) {
			if(PlayerInfo[i][Spec]==playerid) { //
				if(newstate==PLAYER_STATE_ONFOOT) {
					TogglePlayerSpectating(i, 1);
					PlayerSpectatePlayer(i,playerid);
				}
				else if(newstate==PLAYER_STATE_DRIVER || newstate==PLAYER_STATE_PASSENGER) {
					TogglePlayerSpectating(i, 1);
					PlayerSpectateVehicle(i,vid, 1);
				}
				else if(newstate==PLAYER_STATE_SPECTATING) {
					//Force to stop spectating
					ResetSpectateInfo(i);
					TogglePlayerSpectating(i,0);
					PlayerInfo[i][Spec]=FREE_SPEC_ID;
					SetPlayerInterior(i,0);
					SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_spec3");
				}
			}
		}
	}
	#endif
	#if defined DISPLAY_MODE_TD
	if(IsPlayerFlag(playerid,PLAYER_FLAG_SPEEDO)) {
		if(newstate==PLAYER_STATE_DRIVER || newstate==PLAYER_STATE_PASSENGER) {
			TextDrawSetString(PlayerInfo[playerid][td_PlayerDraw],"_");
			TextDrawShowForPlayer(playerid,PlayerInfo[playerid][td_PlayerDraw]);
		}
		if(newstate==PLAYER_STATE_ONFOOT && oldstate == PLAYER_STATE_DRIVER) {
			TextDrawHideForPlayer(playerid,PlayerInfo[playerid][td_PlayerDraw]);
		}
	}
	#endif
	return 1;
}
#if defined SPECTATE_MODE
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	if(IsPlayerFlag(playerid,PLAYER_FLAG_SPECTATED)) {
	    new
	        vid=GetPlayerVehicleID(playerid);
		foreachEx(i) {
			if(PlayerInfo[i][Spec]==playerid) { //
				if(vid) {
					PlayerSpectateVehicle(i,vid,1);
				}
	 			else {
				    PlayerSpectatePlayer(i, playerid);
				}
				TogglePlayerSpectating(i, 1);
  				SetPlayerInterior(i,newinteriorid);
			}
		}
	}
	return 1;
}
#endif
public OnRconCommand(cmd[])
{
	if (!strcmp(cmd, "whiteon", true)) {
		g_bWhiteStatus=true;
		LoadWhitelistEntrys();
 		print("* Whitelist Status: On");
	}
/*
	else if (!strcmp(cmd,"langdbg",true)) {
		for(new Language:j;_:j<Language_Count;_:j++) {
		    for(new i;i<sizeof(LanguageInfo[]);i++) {
		    	print(LanguageTable[j][i][Identifier]);
		    	print(LanguageTable[j][i][sText]);
		    }
		}

	}
*/
	else if (!strcmp(cmd, "whiteoff", true)) {
		g_bWhiteStatus=false;
		print("* Whitelist Status: Off");
	}
	else if (!strcmp(cmd, "whitelist", true)) {
		if(WhitelistEntryCount>1) {
			print("Whitelist Entrys:");
			for(new i;i<WhitelistEntryCount;i++) {
				print(WhitelistEntry[i]);
			}
		}
   		else {
   			print("Currently no Entrys");
   		}
	}
	else if (!strcmp(cmd, "blackoff", true)) {
		g_bBlackListStatus=false;
		print("* Blacklist Status: Off");
	}
	else if (!strcmp(cmd, "blackon", true)) {
		g_bBlackListStatus=true;
		LoadBlacklistEntrys();
		print("* Blacklist Status: On");
	}
	else if (!strcmp(cmd, "blacklist", true)) {
		if(BlacklistEntryCount>0) {
			print("Blacklist Entrys:");
			for(new i;i<BlacklistEntryCount;i++) {
				print(BlacklistEntry[i]);
			}
		}
   		else {
   			print("Currently no Entrys");
   		}
	}
	else if (!strcmp(cmd, "clanblackoff", true)) {
		g_bClangBlackListStatus=false;
		LoadClanBlacklistEntrys();
		print("* ClanBlacklist Status: Off");
	}
	else if (!strcmp(cmd, "clanblackon", true)) {
		g_bClangBlackListStatus=true;
		print("* ClanBlacklist Status: On");
	}
	else if (!strcmp(cmd, "clanblacklist", true)) {
		if(ClanBlacklistEntryCount>0) {
			print("ClanBlacklist Entrys:");
			for(new i;i<ClanBlacklistEntryCount;i++) {
				print(ClanBlacklistEntry[i]);
			}
		}
   		else {
   			print("Currently no Entrys");
   		}
	}
	else if (!strcmp(cmd, "showadmincmdon", true)) {
		g_bShow_AdminCommand=true;
		print("* Show Admin Commands: On");
	}
	else if (!strcmp(cmd, "showadmincmdoff", true)) {
		g_bShow_AdminCommand=false;
		print("* Show Admin Commands: Off");
	}
	else if (!strcmp(cmd, "ipbans", true)) {
		if(IPBansEntryCount>0) {
			print("IPBan Entrys:");
			for(new i;i<IPBansEntryCount;i++) {
				printf("%s*.*",IPBansEntry[i]);
			}
		}
   		else {
   			print("Currently no Entrys");
   		}
	}
   	else if (!strcmp(cmd, "badwords", true)) {
   		if(g_BadWordsSize>0) {
   			print("BadWords:");
			for(new i;i<g_BadWordsSize;i++) {
				print(g_BadWords[i]);
			}
   		}
   		else {
   			print("Currently no Entrys");
   		}
   	}
	#if !defined MYSQL // We dont use this if we use MYSQL
   	else if(!strcmp(cmd, "deleteaccount",true,13)) {
   		//We dont really delete the Account,just rename it to name[Old][Day.Month.Hour.Minute]backup.txt
   		new
   			t,
			m,
			std,
			minute,
   			name[MAX_PLAYER_NAME],
			dbgname[64];
		if(strlen(cmd)<15) {
			print("/deleteaccount [name]");
		}
		else {
			gettime(std,minute);
			getdate(.month=m,.day=t);
			format(name,sizeof(name),cmd[14]);
			if(udb_Exists(name)) {
				format(dbgname,sizeof(dbgname),"%s%02d%02d%02d%02dbackup",name,m,t,std,minute);
				udb_RenameUser(name,dbgname);
				printf("Removed Account succesfully,Backup File is:%s.txt",dbgname);
			}
			else {
				print("Invalid Username!");
			}
		}
   	}
   	#endif
	else if (!strcmp(cmd, "cmdlistex", true)) {
		print("gAdmin Console Commands:");
		print("  whiteon");
		print("  whitelist *");
		print("  whiteoff");
		print("  blackon");
		print("  blackoff");
		print("  blacklist *");
		print("  clanblackon");
		print("  clanblackoff");
		print("  clanblacklist *");
		print("  ipbans *");
		print("  showadmincmdon");
		print("  showadmincmdoff");
		print("  badwords *\n");
		#if !defined MYSQL
		print("  deleteaccount");
		#endif
		print("  * - Prints loaded entrys for this category");
	}
	return 0;
}
#if defined _samp03_
public OnRconLoginAttempt(ip[], password[], success)
{
    if(!success) {
        new
            IP[16];
        for(new i ; i < g_Max_Players ; i++) {
            if(GetPlayerIp(i,IP,sizeof(IP)) ) {
                if(!IsPlayerNPC(i)) {
					if(!strcmp(ip,IP,true,sizeof(IP)) ) {
						// IP Matching
						PlayerInfo[i][WrongRCON]++;
						if(PlayerInfo[i][WrongRCON] >= 5) {
						    SendClientMessage(i,COLOR_YELLOW,"Blup");
						}
					}
                }
            }
        }
    }
    return 1;
}
#if defined LOGIN_PANEL
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    dialogid = PlayerInfo[playerid][iDialogID];
	if(dialogid == PANEL_DIALOG) {
		if(inputtext[0]) {
		    if(response == 1) {
			    new
			        ThePlayer[MAX_PLAYER_NAME];
				GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
				#if defined MYSQL
				if (gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")==num_hash(inputtext)) {
				#else
				if (udb_CheckLogin(ThePlayer,inputtext)) {
				#endif
					OnPlayerLogin(playerid,LOGIN_NORMAL);
					DeletePlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL);
					PlayerInfo[playerid][iDialogID] = -1;
					return 1;
				}
				PlayerInfo[playerid][WrongPW]++;
				if(PlayerInfo[playerid][WrongPW]==MAX_WRONG_PW) {
					SendClientLanguageMessageToAll(COLOR_GREY,"txt_login9",ThePlayer);
					KickEx(playerid,9);
				}
				else {
					format(s,sizeof(s),"\n\n%s\n\nTry again!",GetLanguageString(GetPlayerLanguageID(playerid),"txt_login7"));
					format(s,sizeof(s),s,PlayerInfo[playerid][WrongPW],MAX_WRONG_PW);
					ShowPlayerDialog(playerid,playerid,DIALOG_STYLE_MSGBOX,"gAdmin || Login",s,"OK","Cancel");
					PlayerInfo[playerid][iDialogID] = PANEL_DIALOG;
				}
			}
			else {
				AddPlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL);
                PlayerInfo[playerid][iDialogID] = -1;
			}
		}
		else {
		    if(response == 1) {
		        s[0]='\0';
		   	    format(s,sizeof(s),"Welcome %s.\n\n\n\nPlease enter your password below in order to Login",PlayerName(playerid));
				ShowPlayerDialog(playerid,playerid,DIALOG_STYLE_INPUT,"gAdmin || Login",s,"Login","Cancel");
	            PlayerInfo[playerid][iDialogID] = PANEL_DIALOG;
				AddPlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL);
			}
			else {
				PlayerInfo[playerid][iDialogID] = -1;
			}
		}
		return 1;
	}
	else if(dialogid == LANGUAGE_LIST) {
	    if(response == 1) {
			SetPlayerLanguageID(playerid,Language:listitem);
			CallRemoteFunction("SetPlayerLanguage","dd",playerid,listitem);
			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_langvalid",GetLanguageName(Language:listitem));
	    }
	    else { //Abbruch
	    }
	    PlayerInfo[playerid][iDialogID] = -1;
		return 1;
	}
	PlayerInfo[playerid][iDialogID] = -1;
	return 0;
}
#endif
#endif
/*
End of regualer Public Function
__________________________________
Start of new public Function
*/
public OnPlayerLogin(playerid,type) {
	/*
	type 1 - Normal loggin via /(g)login
	type 2 - Auto login via IP comparision,can be deactivated - AutoLogin in generalconfig.cfg
	*/
	//printf("start - OnPlayerLogin(%d,%d)",playerid,type);
	new
	    bool:bMatching=false,
	    sTemp[20],
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	PlayerInfo[playerid][tickConnect] = GetTickCount();
	#if defined MYSQL
	SetPlayerMoney(playerid,gSQL_GetUserVarAsInteger(ThePlayer,"Money"));
	SetPlayerScore(playerid,gSQL_GetUserVarAsInteger(ThePlayer,"Score"));
	PlayerInfo[playerid][Deaths]=gSQL_GetUserVarAsInteger(ThePlayer,"Deaths");
	PlayerInfo[playerid][Kills]=gSQL_GetUserVarAsInteger(ThePlayer,"Kills");
	PlayerInfo[playerid][AdminLevel]=gSQL_GetUserVarAsInteger(ThePlayer,"AdminLevel");
	PlayerInfo[playerid][UniqueID]=gSQL_GetUserVarAsInteger(ThePlayer,"ID");
	PlayerInfo[playerid][iSeconds]=gSQL_GetUserVarAsInteger(ThePlayer,"OnlineTime");
	#else
	SetPlayerMoney(playerid,dUserINT(ThePlayer).("Money"));
	SetPlayerScore(playerid,dUserINT(ThePlayer).("Score"));
	PlayerInfo[playerid][Deaths]=dUserINT(ThePlayer).("Deaths");
	PlayerInfo[playerid][Kills]=dUserINT(ThePlayer).("Kills");
	PlayerInfo[playerid][AdminLevel]=dUserINT(ThePlayer).("AdminLevel");
	PlayerInfo[playerid][iSeconds]=dUserINT(ThePlayer).("OnlineTime");
	#endif
	/* Language Search */
	#if defined MYSQL
	format(sTemp,sizeof(sTemp),gSQL_GetUserVar(ThePlayer,"Language"));
	#else
	format(sTemp,sizeof(sTemp),dUser(ThePlayer).("Language"));
	#endif
	for(new Language:i;_:i<Language_Count;_:i++) {
	    if(!strcmp(GetShortLanguageName(i),sTemp,true,SMALL_LEN)) {
			SetPlayerLanguageID(playerid,i);
			bMatching=true;
	    }
	}
	if(!bMatching) { // If their is a wrong language entry,set default for player
	    SetPlayerLanguageID(playerid,ServerLanguage());
	}
	//
	SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_login11");
	#if defined MYSQL
	format(sTemp,sizeof(sTemp),gSQL_GetUserVar(ThePlayer,"TimeBan"));
	#else
	format(sTemp,sizeof(sTemp),dUser(ThePlayer).("TimeBan"));
	#endif
	if(sTemp[0]) {
		if(sTemp[0]!='0' && sTemp[1]!=0) { // their is a timeban
		    new
		        day,
		        month,
		        year;
			sscanf(sTemp,"p|ddd",day,month,year);
			if(IsDateReached(day,month,year)) {
			    #if defined MYSQL
			    gSQL_SetUserVarAsInteger(ThePlayer,"TimeBan",0);
			    #else
			    dUserSet(ThePlayer).("TimeBan","0");
				#endif
			    format(s,sizeof(s),"[TimeBan] Player %s's timeban has expired",ThePlayer);
				WriteLog(clearlog,s);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_timeban1",day,month,year);
			    BanEx2(playerid,14);
			}
		}
	}
	#if defined EXTRA_COMMANDS
	#if defined MYSQL
	PlayerInfo[playerid][BankMoney]=gSQL_GetUserVarAsInteger(ThePlayer,"BankMoney");
	#else
	PlayerInfo[playerid][BankMoney]=dUserINT(ThePlayer).("BankMoney");
	#endif
	#endif
	#if defined MYSQL
	PlayerInfo[playerid][SpawnCount]=gSQL_GetUserVarAsInteger(ThePlayer,"TimesSpawned");
	#else
	PlayerInfo[playerid][SpawnCount]=dUserINT(ThePlayer).("TimesSpawned");
	#endif

	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ladmintele]) {
	   	AllowPlayerTeleport(playerid,1);
	}
	if(PlayerInfo[playerid][AdminLevel]>=2) {
	    INI_Open(AdminList);
	   	INI_WriteInt(ThePlayer,PlayerInfo[playerid][AdminLevel]);
	   	INI_Save();
	   	INI_Close();
	}
	if(type==1) {
	    new
	    	pIP[16];
		GetPlayerIp(playerid,pIP,sizeof(pIP));
		#if defined MYSQL
		gSQL_SetUserVar(ThePlayer,"IP",pIP);
		#else
		dUserSet(ThePlayer).("IP",pIP);
		#endif
		SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login1");
	}
	if(type==2) {
		SendClientLanguageMessage(playerid,COLOR_WHITE,"txt_autolog");
	}
	#if defined MYSQL
	format(s,sizeof(s),"[Login] Player %s [ID %d,UserID %d] logged in (Type:%d)",ThePlayer,playerid,PlayerInfo[playerid][UniqueID],type);
	#else
	format(s,sizeof(s),"[Login] Player %s [ID %d] logged in (Type:%d)",ThePlayer,playerid,type);
	#endif
	WriteLog(clearlog,s);
	AddPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN);

	SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login2",PlayerInfo[playerid][AdminLevel]);
	CreateClientLanguageMessage(ServerLanguage(),"txt_login3",ThePlayer,PlayerInfo[playerid][AdminLevel]);
   	WriteLog(clearlog,LanguageString(ServerLanguage()));
   	PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
	//printf("end - OnPlayerLogin()");
	return 1;
}

public OnPlayerLogout(playerid) {
	new
		#if defined SAVE_POS
		#if !defined MYSQL
	    Float:X,
	    Float:Y,
	    Float:Z,
	    #endif
	    #endif
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	#if defined MYSQL
		gSQL_UpdateUser(ThePlayer,playerid);
	#else
		dUserSetINT(ThePlayer).("AdminLevel",PlayerInfo[playerid][AdminLevel]);
		dUserSetINT(ThePlayer).("Money",GetPlayerMoney(playerid));
		dUserSetINT(ThePlayer).("Score",GetPlayerScore(playerid));
		#if defined EXTRA_COMMANDS
		dUserSetINT(ThePlayer).("BankMoney",PlayerInfo[playerid][BankMoney]);
		#endif
		dUserSet(ThePlayer).("Language",GetShortLanguageName(GetPlayerLanguageID(playerid)));
		dUserSetINT(ThePlayer).("Kills",PlayerInfo[playerid][Kills]);
		dUserSetINT(ThePlayer).("Deaths",PlayerInfo[playerid][Deaths]);
		dUserSetINT(ThePlayer).("TimesSpawned",PlayerInfo[playerid][SpawnCount]);
		PlayerInfo[playerid][iSeconds] += floatround(((GetTickCount() - PlayerInfo[playerid][tickConnect] ) / 1000));
		dUserSetINT(ThePlayer).("OnlineTime",PlayerInfo[playerid][iSeconds] );
		#if defined SAVE_POS
		GetPlayerPos(playerid,X,Y,Z);
		dUserSetFLOAT(ThePlayer).("X",X);
		dUserSetFLOAT(ThePlayer).("Y",Y);
		dUserSetFLOAT(ThePlayer).("Z",Z);
		#endif
	#endif
	AllowPlayerTeleport(playerid,0);
	#if defined SPECTATE_MODE
		TogglePlayerSpectating(playerid, false);
	#endif
   	DeletePlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN);
	return 1;
}
public OnPlayerRegister(playerid) {
	new
	    d,
	    m,
	    y,
	    iTrusted = 0,
		pIP[16],
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerIp(playerid,pIP,sizeof(pIP));
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	getdate(y,m,d);
	s[0]='\0';
	format(s,sizeof(s),"%02d.%02d.%d",d,m,y);
	if(IsPlayerAdmin(playerid)) { //Rcon Admin = Autom. Lvl 5
		PlayerInfo[playerid][AdminLevel] = 5;
		iTrusted = 1;
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_register6");
		INI_Open(AdminList);
	   	INI_WriteInt(ThePlayer,PlayerInfo[playerid][AdminLevel]);
		INI_Save();
		INI_Close();
		if(PlayerInfo[playerid][AdminLevel] >= g_Level[ladmintele]) {
			AllowPlayerTeleport(playerid,1);
		}
	}
	else {
		PlayerInfo[playerid][AdminLevel] = 1;
	}
	#if defined MYSQL
        gSQL_SetUserVar(ThePlayer,"RegDate",s);
        gSQL_SetUserVarAsInteger(ThePlayer,"AdminLevel", 1);
		gSQL_SetUserVar(ThePlayer,"RegIP", pIP);
		gSQL_SetUserVar(ThePlayer,"IP", pIP);
		gSQL_SetUserVarAsInteger(ThePlayer,"Trusted",iTrusted);
		gSQL_SetUserVarAsInteger(ThePlayer,"TimeBan",0);
		gSQL_SetUserVarAsInteger(ThePlayer,"Money",GetPlayerMoney(playerid));
		gSQL_SetUserVarAsInteger(ThePlayer,"Score",GetPlayerScore(playerid));
		gSQL_SetUserVarAsInteger(ThePlayer,"Deaths",PlayerInfo[playerid][Deaths]);
		gSQL_SetUserVarAsInteger(ThePlayer,"Kills",PlayerInfo[playerid][Kills]);
		#if defined EXTRA_COMMANDS
		gSQL_SetUserVarAsInteger(ThePlayer,"BankMoney",PlayerInfo[playerid][BankMoney]);
		#endif
		gSQL_SetUserVarAsInteger(ThePlayer,"TimesSpawned",PlayerInfo[playerid][SpawnCount]);
		PlayerInfo[playerid][iSeconds] = floatround(((GetTickCount() - PlayerInfo[playerid][tickConnect] ) / 1000));
		gSQL_SetUserVarAsInteger(ThePlayer,"OnlineTime",PlayerInfo[playerid][iSeconds]);
		#if defined SAVE_POS
		gSQL_SetUserVarAsFloat(ThePlayer,"X",0.0);
		gSQL_SetUserVarAsFloat(ThePlayer,"Y",0.0);
		gSQL_SetUserVarAsFloat(ThePlayer,"Z",0.0);
		#endif
		PlayerInfo[playerid][UniqueID]=gSQL_GetUserVarAsInteger(ThePlayer,"ID");
	#else
		dUserSet(ThePlayer).("RegDate",s);
		dUserSetINT(ThePlayer).("AdminLevel",1);
		dUserSet(ThePlayer).("RegIP",pIP);
		dUserSet(ThePlayer).("IP",pIP);
		dUserSet(ThePlayer).("Language",GetShortLanguageName(GetPlayerLanguageID(playerid)));
		dUserSetINT(ThePlayer).("Trusted",iTrusted);
		dUserSetINT(ThePlayer).("TimeBan",0);
		dUserSetINT(ThePlayer).("Money",GetPlayerMoney(playerid));
		dUserSetINT(ThePlayer).("Score",GetPlayerScore(playerid));
		dUserSetINT(ThePlayer).("Deaths",PlayerInfo[playerid][Deaths]);
		dUserSetINT(ThePlayer).("Kills",PlayerInfo[playerid][Kills]);
		#if defined EXTRA_COMMANDS
		dUserSetINT(ThePlayer).("BankMoney",PlayerInfo[playerid][BankMoney]);
		#endif
		dUserSetINT(ThePlayer).("TimesSpawned",PlayerInfo[playerid][SpawnCount]);
		PlayerInfo[playerid][iSeconds] = floatround(((GetTickCount() - PlayerInfo[playerid][tickConnect] ) / 1000));
		dUserSetINT(ThePlayer).("OnlineTime",PlayerInfo[playerid][iSeconds]);
		#if defined SAVE_POS
		dUserSetFLOAT(ThePlayer).("X",0.0);
		dUserSetFLOAT(ThePlayer).("Y",0.0);
		dUserSetFLOAT(ThePlayer).("Z",0.0);
		#endif
	#endif
	AddPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN);
	if(IsPlayerFlag(playerid,PLAYER_FLAG_REGISTERMSG)) {
		SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_registerspawn4");
   		PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
	}
	CreateClientLanguageMessage(ServerLanguage(),"txt_register5",ThePlayer);
	WriteLog(clearlog,s);
	return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_register4");
}
public Login(playerid) {
	if(IsPlayerConnected(playerid)) {
	    if(IsPlayerFlag(playerid,PLAYER_FLAG_LOGINCHECK)) {
			KillTimer(PlayerInfo[playerid][tLogin]);
			//printf("tLogin -> %d",PlayerInfo[playerid][tLogin]);
			if (!IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
			 	SendClientLanguageMessage(playerid,COLOR_RED2,"txt_login8");
			 	WriteLog(clearlog,LanguageString(ServerLanguage()));
			 	KickEx(playerid,11);
			}
		}
	}
}
public ScoreUpdate() {
	foreachEx(i) {
		SetPlayerScore(i,GetPlayerMoney(i));
	}
	return 1;
}
public GodUpdate() {

	new
	    vid;
	foreachEx(i) {
		if(IsPlayerFlag(i,PLAYER_FLAG_GOD)) {
			SetPlayerHealth(i,g_fGodValue);
			if( (vid = GetPlayerVehicleID(i)) ) {
				SetVehicleHealth(vid, g_fGodValue * 10.0);
				RepairVehicle(vid);
   			}
		}
	}
	return 1;
}
#if defined DISPLAY_MODE && !defined DISPLAY_MODE_TD
public RestartDisplay() {
	if(g_Display==1) {
		g_SpeedOMeterUpdate_Count=0;
	}
	else if(g_Display==2) {
		g_AreaNameUpdate_Count=0;
	}
	else if(g_Display==3) {
		g_SpeedNameUpdate_Count=0;
	}
	KillTimer(g_tRestart);
	return 1;
}
#endif
public TimeUpdate() {
	g_Time++;
	if(g_Time>23) {
		g_Time=0;
	}
	return SetWorldTime(g_Time);
}
public WeatherUpdate() {
	return SetWeather(g_WeatherID[random(sizeof(g_WeatherID))]);
}
public PingCheck() {
	foreachEx(i) {
	    /* GetPlayerPing -> -1 if not connected */
		if(GetPlayerPing(i) >= g_MAX_PING) {
			if(IsPlayerSpawned(i)) {
			    #if defined PINGKICK_ADMIN_IMMUNITY
			    if(PlayerInfo[i][AdminLevel] >= 2) {
			        continue;
			    }
			    #endif
				PlayerInfo[i][PingWarnings]++;
				SendClientLanguageMessage(i,COLOR_RED2,"txt_ping1",PlayerInfo[i][PingWarnings],g_MAX_PING_WARNINGS);
				if(PlayerInfo[i][PingWarnings]>=g_MAX_PING_WARNINGS) {
				    SendClientLanguageMessage(i,COLOR_RED2,"txt_ping2",g_MAX_PING);
				    /*
					SendClientLanguageMessageToAll(COLOR_GREEN,"txt_ping2",PlayerName(i));
					WriteLog(clearlog,LanguageString(ServerLanguage()));
					#if defined irc_gAdmin
						IRC_Say(EchoBot, EchoChan, LanguageString(ServerLanguage()));
					#endif
					*/
					KickEx(i,8);
				}
			}
		}
	}
	return 1;
}
public Countdown(iFreeze) {
	if(g_StepCountdown){
		format(s,sizeof(s),"~y~%d",g_StepCountdown);
		GameTextForAll(s,1200,4,600); //
  		PlaySoundForAll(1056);
		g_StepCountdown--;
		if(iFreeze == 1) {
			foreach(i) {
				TogglePlayerControllable(i,false);
			}
		}
	}
	else {
		GameTextForAll(GetLanguageString(ServerLanguage(),"txt_go"),2000,4);
		PlaySoundForAll(1057);
		KillTimer(g_tCountdown);
		//bCountdownInProgress=false;
		#if defined DISPLAY_MODE && !defined DISPLAY_MODE_TD
		g_tRestart=SetTimer("RestartDisplay",2*1000,0);
		#endif
		if(iFreeze == 1) {
			foreach(i) {
				if(!IsPlayerFlag(i,PLAYER_FLAG_FREEZE)) { // only unfreeze if not regulary froozen by an admin
					TogglePlayerControllable(i,true);
				}
			}
		}
	}
	return 1;
}

#if defined DISPLAY_MODE
public AreaName() {
	new
		#if defined _samp03_
		Float:fXPos,
		Float:fYPos,
		Float:fZPos,
		#endif
		sDisplayString[128];
	foreachEx(i) {
		if(IsPlayerFlag(i,PLAYER_FLAG_SPEEDO)) {
			#if defined _samp03_
	  		GetPlayerPos(i,fXPos,fYPos,fZPos);
	  		#else
	  		GetPlayerPos(i,PlayerInfo[i][fnX],PlayerInfo[i][fnY],PlayerInfo[i][fnZ]);
	  		#endif
			if(IsPlayerInAnyVehicle(i)) {
			    sDisplayString[0]='\0';
			    #if defined _samp03_
			    sDisplayString=GetXYZZoneName(fXPos,fYPos,fZPos);
			    #else
			    sDisplayString=GetXYZZoneName(PlayerInfo[i][fnX],PlayerInfo[i][fnY],PlayerInfo[i][fnZ]);
			    #endif
				#if defined DISPLAY_MODE_TD
				TextDrawSetString(PlayerInfo[i][td_PlayerDraw],sDisplayString);
				#else
				format(sDisplayString,sizeof(sDisplayString),"~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ %s",sDisplayString));
                #endif
				GameTextForPlayer(i,sDisplayString,g_AreaNameUpdate_GT,3);
			}
		}
	}
	return 1;
}
public SpeedOMeter() {
	new
		Speed,
        #if defined _samp03_
        vid,
        Float:fVelocityX,
        Float:fVelocityY,
        Float:fVelocityZ,
        #endif
		sDisplayString[128];
	foreachEx(i) {
	    if(IsPlayerFlag(i,PLAYER_FLAG_SPEEDO)) {
        	#if defined _samp03_
			if(( vid = GetPlayerVehicleID(i) )) {
        	#else
			GetPlayerPos(i,PlayerInfo[i][fnX],PlayerInfo[i][fnY],PlayerInfo[i][fnZ]);
			if(IsPlayerInAnyVehicle(i)) {
			#endif
			    sDisplayString[0]='\0';
			    #if !defined _samp03_
				PlayerInfo[i][foX]-=PlayerInfo[i][fnX];
				PlayerInfo[i][foY]-=PlayerInfo[i][fnY];
				PlayerInfo[i][foZ]-=PlayerInfo[i][fnZ];
				#else
				GetVehicleVelocity(vid,fVelocityX,fVelocityY,fVelocityZ);
				#endif
				switch(PlayerInfo[i][speedo_type]) {
					case KMH_MODE: {
					    #if defined _samp03_
	     				Speed=floatround(floatround(floatpower((fVelocityX * fVelocityX) + (fVelocityY * fVelocityY) + (fVelocityZ * fVelocityZ),0.5)*100)*2.0);
						#else
	     				Speed=floatround((floatpower((PlayerInfo[i][foX] * PlayerInfo[i][foX]) + (PlayerInfo[i][foY] * PlayerInfo[i][foY]) + (PlayerInfo[i][foZ] * PlayerInfo[i][foZ]),0.5)*100)*2.0);
						#endif
						#if defined DISPLAY_MODE_TD
						format(sDisplayString,sizeof(sDisplayString),"~b~~h~~h~%d  ~w~Kmh",Speed);
						TextDrawSetString(PlayerInfo[i][td_PlayerDraw],sDisplayString);
						#else
						format(sDisplayString,sizeof(sDisplayString),"~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~%d  Kmh",Speed);
						GameTextForPlayer(i,sDisplayString,g_SpeedOMeterUpdate_GT,3);
						#endif
					}
					case MPH_MODE: {
					    #if defined _samp03_
	     				Speed=floatround(floatpower((fVelocityX * fVelocityX) + (fVelocityY * fVelocityY) + (fVelocityZ * fVelocityZ),0.5)*100);
					    #else
	     				Speed=floatround((floatpower((PlayerInfo[i][foX] * PlayerInfo[i][foX]) + (PlayerInfo[i][foY] * PlayerInfo[i][foY]) + (PlayerInfo[i][foZ] * PlayerInfo[i][foZ]),0.5)*100));
					    #endif
						#if defined DISPLAY_MODE_TD
						format(sDisplayString,sizeof(sDisplayString),"~b~~h~~h~%d  ~w~Mph",Speed);
						TextDrawSetString(PlayerInfo[i][td_PlayerDraw],sDisplayString);
						#else
						format(sDisplayString,sizeof(sDisplayString),"~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~%d  Mph",Speed);
                        GameTextForPlayer(i,sDisplayString,g_SpeedOMeterUpdate_GT,3);
						#endif
					}
				}
			}
			#if !defined _samp03_
			PlayerInfo[i][foX]=PlayerInfo[i][fnX];
			PlayerInfo[i][foY]=PlayerInfo[i][fnY];
			PlayerInfo[i][foZ]=PlayerInfo[i][fnZ];
			#endif
		}
	}
	return 1;
}

public SpeedName() {
	new
		Speed,
        #if defined _samp03_
        vid,
        Float:fVelocityX,
        Float:fVelocityY,
        Float:fVelocityZ,
		Float:fXPos,
		Float:fYPos,
		Float:fZPos,
        #endif
		sCurrentZoneName[MAX_PLACE_NAME],
		sDisplayString[128];
	foreachEx(i) {
		if(IsPlayerFlag(i,PLAYER_FLAG_SPEEDO)) {
		    #if defined _samp03_
		    GetPlayerPos(i,fXPos,fYPos,fZPos);
			if(( vid = GetPlayerVehicleID(i) )) {
		    #else
			GetPlayerPos(i,PlayerInfo[i][fnX],PlayerInfo[i][fnY],PlayerInfo[i][fnZ]);
			if(IsPlayerInAnyVehicle(i)) {
			#endif
			    sDisplayString[0]='\0';
			    #if defined _samp03_
				sCurrentZoneName=GetXYZZoneName(fXPos,fYPos,fZPos);
			    #else
				sCurrentZoneName=GetXYZZoneName(PlayerInfo[i][fnX],PlayerInfo[i][fnY],PlayerInfo[i][fnZ]);
			    #endif
				#if !defined _samp03_
				PlayerInfo[i][foX]-=PlayerInfo[i][fnX];
				PlayerInfo[i][foY]-=PlayerInfo[i][fnY];
				PlayerInfo[i][foZ]-=PlayerInfo[i][fnZ];
				#else
				GetVehicleVelocity(vid,fVelocityX,fVelocityY,fVelocityZ);
				#endif
				switch(PlayerInfo[i][speedo_type]) {
					case KMH_MODE: {
					    #if defined _samp03_
	     				Speed=floatround(floatround(floatpower((fVelocityX * fVelocityX) + (fVelocityY * fVelocityY) + (fVelocityZ * fVelocityZ),0.5)*100)*2.0);
						#else
	     				Speed=floatround((floatpower((PlayerInfo[i][foX] * PlayerInfo[i][foX]) + (PlayerInfo[i][foY] * PlayerInfo[i][foY]) + (PlayerInfo[i][foZ] * PlayerInfo[i][foZ]),0.5)*100)*2.0);
						#endif
						#if defined DISPLAY_MODE_TD
						format(sDisplayString,sizeof(sDisplayString),"%s ~n~~b~~h~~h~%d ~w~Kmh",sCurrentZoneName,Speed);
						TextDrawSetString(PlayerInfo[i][td_PlayerDraw],sDisplayString);
						#else
				 		format(sDisplayString,sizeof(sDisplayString),"~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ %s ~n~ %d Mph",sCurrentZoneName,Speed);
						GameTextForPlayer(i,sDisplayString,g_SpeedNameUpdate_GT,3);
						#endif
					}
					case MPH_MODE: {
					    #if defined _samp03_
	     				Speed=floatround(floatpower((fVelocityX * fVelocityX) + (fVelocityY * fVelocityY) + (fVelocityZ * fVelocityZ),0.5)*100);
					    #else
	     				Speed=floatround((floatpower((PlayerInfo[i][foX] * PlayerInfo[i][foX]) + (PlayerInfo[i][foY] * PlayerInfo[i][foY]) + (PlayerInfo[i][foZ] * PlayerInfo[i][foZ]),0.5)*100));
					    #endif
						#if defined DISPLAY_MODE_TD
						format(sDisplayString,sizeof(sDisplayString),"%s ~n~~b~~h~~h~%d ~w~Mph",sCurrentZoneName,Speed);
						TextDrawSetString(PlayerInfo[i][td_PlayerDraw],sDisplayString);
						#else
				 		format(sDisplayString,sizeof(sDisplayString),"~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ ~n~ %s ~n~ %d Mph",sCurrentZoneName,Speed);
						GameTextForPlayer(i,sDisplayString,g_SpeedNameUpdate_GT,3);
						#endif
					}
				}
	   		}
	   		#if !defined _samp03_
	  		PlayerInfo[i][foX]=PlayerInfo[i][fnX];
			PlayerInfo[i][foY]=PlayerInfo[i][fnY];
			PlayerInfo[i][foZ]=PlayerInfo[i][fnZ];
			#endif
		}
	}
	return 1;
}
#endif
public ReleasePlayer(playerid) {
	KillTimer(PlayerInfo[playerid][tJail]);
    DeletePlayerFlag(playerid,PLAYER_FLAG_JAIL);
	SetJail(playerid,false);
}
#if defined LOGIN_PANEL
public ShowLoginDialog(playerid) {
	s[0]='\0';
	KillTimer(PlayerInfo[playerid][tLoginPanel]);
    format(s,sizeof(s),"Welcome %s.\n\n\n\nPlease enter your password below in order to Login",PlayerName(playerid));
	ShowPlayerDialog(playerid,playerid,DIALOG_STYLE_INPUT,"gAdmin || Login",s,"Login","Cancel");
    PlayerInfo[playerid][iDialogID] = PANEL_DIALOG;
	AddPlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL);
	return 1;
}
#endif
public IsPlayergAdmin(playerid) {
	if(PlayerInfo[playerid][AdminLevel] >= 2) {
	    return true;
	}
	return false;
}
public GetPlayergAdminLevel(playerid) {
	if(PlayerInfo[playerid][AdminLevel] == -1) { // Player not connected -> level0
	    return 0;
	}
	return PlayerInfo[playerid][AdminLevel];
}

stock SetJail(playerid,bool:Jailed = true) {
	if(Jailed) {
		new
			j=random(sizeof(g_fJailPos));
		SetPlayerInterior(playerid,3);
		SetPlayerPos(playerid,g_fJailPos[j][0],g_fJailPos[j][1],g_fJailPos[j][2]);
		SetPlayerFacingAngle(playerid,354.7243);
		#if !defined NO_JAIL_COUNT
		PlayerInfo[playerid][JailCount]=0;
		#endif
		ResetPlayerWeapons(playerid);
	}
	else {
		SetPlayerPos(playerid,238.7479,188.0599,1004.6931);
		SetPlayerFacingAngle(playerid,182.0484);
		#if !defined NO_JAIL_COUNT
		PlayerInfo[playerid][JailCount]=-1;
		#endif
	}
	SetCameraBehindPlayer(playerid);
}
#if defined SPECTATE_MODE
stock ResetSpectateInfo(id) {
	if(PlayerInfo[id][Spec]!=FREE_SPEC_ID) {
		new
			sid=PlayerInfo[id][Spec],
			count;
		foreachEx(i) {
			if(sid==PlayerInfo[id][Spec]) {
				count++;
			}
		}
		if(count==1) { // 1 because the player who used command is still "in" and doesn't count
            DeletePlayerFlag(sid,PLAYER_FLAG_SPECTATED);
		}
	}
}
#endif
//******************************************************************************
/*
End of regualer Stuff
__________________________________
Start of dcmd_*  /Commands
*/
/* Normal Commands */
#if defined _samp03_
COMMAND:pm(playerid,params[]) {
	new
	    msg[128],
	    giveid;
	if (isnull(params)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /pm [Name/Part Of Name] [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if (sscanf(params, "us", giveid,msg)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /pm [Name/Part Of Name] [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)) {
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
   	}
	else if(playerid==giveid) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
	}
	else {
	    // I will use the old callback!
        OnPlayerPrivmsg(playerid, giveid, msg);
	}
	return 1;
}
#endif
COMMAND:id(playerid, params[]) {
	new
		giveid;
	if (isnull(params)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /id [Name/Part Of Name]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(strlen(params) > MAX_PLAYER_NAME) { //if it's a name then MAX_PLAYER_NAME is enaugh
		return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
	}
	else {
		giveid=PlayerID(params);
		if(giveid==-2) {
			return SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_id1",params);
		}
		else if(giveid==-1) {
			return SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_id2",params);
		}
		else {
			SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_id3",PlayerName(giveid),giveid);
		}
	}
	return 1;
}
COMMAND:info(playerid, params[]) {
	#pragma unused params
	SendClientMessage(playerid,COLOR_WHITE,"*************************");
	SendClientMessage(playerid,COLOR_YELLOW,gVersion);
	SendClientMessage(playerid,COLOR_YELLOW,"By Goldkiller");
	return SendClientMessage(playerid,COLOR_WHITE,"*************************");
}
public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(source == CLICK_SOURCE_SCOREBOARD) {
	    valstr(s,clickedplayerid);
		cmd_stats(playerid,s);
	}
	return 1;
}

COMMAND:stats(playerid, params[]) {
	new
		giveid;
	if (sscanf(params, "u", giveid)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /stats [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)) {
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
   	}
	else {
		SendClientMessage(playerid,COLOR_RED,"_______");
		format(s,sizeof(s),"Player: %s (ID:%d) AdminLevel: %d LanguageID:%d (%s)",PlayerName(giveid),giveid,PlayerInfo[giveid][AdminLevel],_:GetPlayerLanguageID(giveid),GetShortLanguageName(GetPlayerLanguageID(giveid)));
		SendClientMessage(playerid,COLOR_GREY,s);
	    #if defined MYSQL
		format(s,sizeof(s),"UserID: %d Kills: %d Deaths: %d Ratio: %.2f",PlayerInfo[giveid][UniqueID],PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths],(PlayerInfo[giveid][Deaths]>0) ? floatdiv(PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths]) : float(PlayerInfo[giveid][Kills]));
	    #else
		format(s,sizeof(s),"Kills: %d Deaths: %d Ratio: %.2f",PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths],(PlayerInfo[giveid][Deaths]>0) ? floatdiv(PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths]) : float(PlayerInfo[giveid][Kills]));
	    #endif
		SendClientMessage(playerid,COLOR_GREY,s);
	}
	return 1;
}
COMMAND:report(playerid, params[]) {
	new
		giveid,
		msg[128];
	if (sscanf(params, "us", giveid,msg)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /report [Player / ID] [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)) {
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
   	}
	else  {
		CreateClientLanguageMessages("txt_report1",PlayerName(playerid),PlayerName(giveid),giveid,msg);
		AdminNote();
	 	WriteLog(reportlog,LanguageString(ServerLanguage()));
	 	SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_report2");
	}
	return 1;
}
COMMAND:complain(playerid, params[]) {
	return cmd_report(playerid,params);
}
#if defined USE_MENUS
COMMAND:tuner(playerid, params[]) {
#pragma unused params
	if(IsPlayerInCar(playerid)){
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			if(IsValidMenu(m_ImportTuner)) {
				TogglePlayerControllable(playerid,false);
				ShowMenuForPlayer(m_ImportTuner,playerid);
  				return SetCameraBehindPlayer(playerid);
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_invalidmenu1");
			}
		}
		else {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_tuner1");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_GREY,"txt_tuner2");
	}
	return 1;
}
#endif
COMMAND:loc(playerid, params[]) {
	new
		giveid;
	if (sscanf(params, "u", giveid)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /loc [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)) {
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	}
	else {
		if(PlayerInfo[giveid][Spec]!=FREE_SPEC_ID) {
			SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_loc1",PlayerName(giveid),zones[random(sizeof(zones))][zone_name]);
		}
		else {
		    new
		        Float:fX,
		        Float:fY,
		        Float:fZ;
			GetPlayerPos(giveid,fX,fY,fZ);
			SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_loc1",PlayerName(giveid),GetXYZZoneName(fX,fY,fZ));
		}
	}
	return 1;
}
COMMAND:votekick(playerid, params[]) {
	new
		giveid,
		msg[128];
	if (sscanf(params, "uz", giveid, msg)) {
		return SendClientFormatMessage(playerid,COLOR_ORANGE,"%s: /votekick [Player / ID] [Reason (optional)]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)){
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	}
	else if(PlayerInfo[giveid][AdminLevel]>=2) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_votekick1");
	}
	else if(playerid==giveid) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
	}
	else if(PlayerInfo[playerid][bVKick][giveid]) {
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_votekick2");
	}
	else {
		PlayerInfo[giveid][VKickCount]++;
		if(PlayerInfo[giveid][VKickCount]==1) {
			SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_votekick3",PlayerName(playerid),PlayerName(giveid),giveid,msg[0] ?  msg : "<No reason>");
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			SendClientLanguageMessageToAll(COLOR_RED2,"txt_votekick4",PlayerName(playerid),PlayerInfo[giveid][VKickCount],g_MAX_VOTE_KICKS,PlayerName(giveid),giveid);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			PlayerInfo[playerid][bVKick][giveid]=true;
		}
		else if(PlayerInfo[giveid][VKickCount]!=g_MAX_VOTE_KICKS && PlayerInfo[giveid][VKickCount]>1) {
			SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_votekick4",PlayerName(playerid),PlayerInfo[giveid][VKickCount],g_MAX_VOTE_KICKS,PlayerName(giveid),giveid);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			PlayerInfo[playerid][bVKick][giveid]=true;
		}
		else if(PlayerInfo[giveid][VKickCount]==g_MAX_VOTE_KICKS) {
			SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_votekick6",PlayerName(giveid));
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			KickEx(giveid,12);
		}
	}
	return 1;
}

COMMAND:voteban(playerid, params[]) {
	new
		giveid,
		msg[128];
	if (sscanf(params, "uz", giveid, msg)) {
		return SendClientFormatMessage(playerid,COLOR_ORANGE,"%s: /votekick [Player / ID] [Reason (optional)]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)){
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	}
	else if(PlayerInfo[giveid][AdminLevel]>=2) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_voteban1");
	}
	else if(playerid==giveid) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
	}
	else if(PlayerInfo[playerid][bVBan][giveid]) {
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_voteban2");
	}
	else {
		PlayerInfo[giveid][VBanCount]++;
		if(PlayerInfo[giveid][VBanCount]==1) {
			SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_voteban3",PlayerName(playerid),PlayerName(giveid),msg[0] ?  msg : "<No reason>");
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			SendClientLanguageMessageToAll(COLOR_RED2,"txt_voteban4",PlayerName(playerid),PlayerInfo[giveid][VBanCount],g_MAX_VOTE_BANS,PlayerName(giveid),giveid);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			PlayerInfo[playerid][bVBan][giveid]=true;
		}
		else if(PlayerInfo[giveid][VBanCount]!=g_MAX_VOTE_BANS && PlayerInfo[giveid][VBanCount]>1) {
			SendClientLanguageMessageToAll(COLOR_RED2,"txt_voteban4",PlayerName(playerid),PlayerInfo[giveid][VBanCount],g_MAX_VOTE_BANS,PlayerName(giveid),giveid);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			PlayerInfo[playerid][bVBan][giveid]=true;
		}
		else if(PlayerInfo[giveid][VBanCount]==g_MAX_VOTE_BANS) {
			SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_voteban6",PlayerName(giveid));
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			BanEx2(giveid,12);
		}
	}
	return 1;
}
COMMAND:votelist(playerid,params[]) {
	#pragma unused params
	new
		bool:bVotelist;
	SendClientLanguageMessage(playerid,COLOR_GREY,"txt_votelistk");
	foreach(i) {
		if(PlayerInfo[i][VKickCount]>=1) {
			bVotelist=true;
			format(s,sizeof(s),"Player:%s [%d] - Votes: %d",PlayerName(i),i,PlayerInfo[i][VKickCount]);
			SendClientMessage(playerid,COLOR_BLUE,s);
		}
	}
	if(!bVotelist) {
		SendClientLanguageMessage(playerid,COLOR_RED2,"txt_novotekicks");
	}
	bVotelist=false;
	SendClientLanguageMessage(playerid,COLOR_GREY,"txt_votelistb");
	foreach(i) {
		if(PlayerInfo[i][VBanCount]>=1) {
			bVotelist=true;
			format(s,sizeof(s),"Player:%s [%d] - Votes: %d",PlayerName(i),i,PlayerInfo[i][VBanCount]);
			SendClientMessage(playerid,COLOR_BLUE,s);
		}
	}
	if(!bVotelist) {
		SendClientLanguageMessage(playerid,COLOR_RED2,"txt_novotebans");
	}
	return 1;
}
#if defined BASIC_COMMANDS
COMMAND:players(playerid, params[]) {
#pragma unused params
	new
	    Bots,
		Players;
	for(new i ; i < g_Max_Players ; i++) {
	    if(IsPlayerConnected(i)) {
		    if(IsPlayerNPC(i)) {
		        Bots++;
			}
			else {
				Players++;
			}
		}
	}
	SendClientMessage(playerid,COLOR_WHITE,"*************************");
	SendClientLanguageMessage(playerid,COLOR_LIGHTGREEN,"txt_players",Players,Bots);
	SendClientMessage(playerid,COLOR_WHITE,"*************************");
	return 1;
}
COMMAND:clock(playerid, params[]) {
#pragma unused params
	new
		Hour,
		Minutes,
		Seconds;
	gettime(Hour,Minutes,Seconds);
	format(s,sizeof(s),"~b~Time:~w~ %d : %d %d",Hour,Minutes,Seconds);
	return GameTextForPlayer(playerid,s,4000,3);
}
COMMAND:date(playerid, params[]) {
#pragma unused params
	new
		Year,
		Month,
		Day;
	getdate(Year,Month,Day);
	format(s,sizeof(s),"~b~Date:~w~ %d . %d %d",Day,Month,Year);
	return GameTextForPlayer(playerid,s,4000,3);
}
COMMAND:pos(playerid, params[]) {
#pragma unused params
    new
        Float:fX,
        Float:fY,
        Float:fZ;
	GetPlayerPos(playerid,fX,fY,fZ);
	return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_pos1",fX,fY,fZ);
}
COMMAND:me(playerid, params[] ) {
	if (isnull(params)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /me [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	if(IsPlayerFlag(playerid,PLAYER_FLAG_MUTE)) {
		return 0;
	}
	else {
		format(s,sizeof(s),"%s %s",PlayerName(playerid),params);
		SendClientMessageToAll(COLOR_PINK,s);
		WriteLog(clearlog,s);
	}
	return 1;
}
COMMAND:kill(playerid, params[] ) {
#pragma unused params
	return SetPlayerHealth(playerid,0.0);
}
COMMAND:givemoney(playerid,params[]){
	new
		giveid,
		cash;
	if (sscanf(params, "ud",giveid,cash)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /givemoney [Player / ID] [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)){
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	}
	else if(playerid==giveid) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
	}
	else if(cash>GetPlayerMoney(playerid) || cash<0){
		return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_money1");
 	}
	else {
		GivePlayerMoney(playerid,-cash);
		GivePlayerMoney(giveid,cash);
		CreateClientLanguageMessages("txt_money2",PlayerName(playerid),playerid,PlayerName(giveid),giveid,cash);
		AdminNote();
		WriteLog(clearlog,LanguageString(ServerLanguage()));
		SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_money3",PlayerName(playerid),cash);
	}
	return 1;
}
#endif
#if defined EXTRA_COMMANDS
COMMAND:bank(playerid, params[]) {
	if(IsPlayerInBank(playerid)){
		new
			bmoney;
		if (sscanf(params, "d",bmoney)) {
			SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /bank [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			return SendClientLanguageMessage(playerid,COLOR_WHITE,"txt_bank2",PlayerInfo[playerid][BankMoney]);
		}
		else if(bmoney > GetPlayerMoney(playerid) || bmoney <1) {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_bank1");
		}
		else  {
			PlayerInfo[playerid][BankMoney] +=bmoney;
			SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_bank3",PlayerInfo[playerid][BankMoney]);
			SetPlayerMoney(playerid,GetPlayerMoney(playerid)-bmoney);
			return WriteLog(clearlog,LanguageString(GetPlayerLanguageID(playerid)));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_bank4");
	}
	return 1;
}
COMMAND:withdraw(playerid, params[]) {
	if(IsPlayerInBank(playerid)){
		new
			bankmoney;
		if (sscanf(params, "d",bankmoney)) {
			SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /withdraw [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			return SendClientLanguageMessage(playerid,COLOR_WHITE,"txt_bank5",PlayerInfo[playerid][BankMoney]);
		}
		else if(bankmoney > PlayerInfo[playerid][BankMoney] || bankmoney <1) {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_bank1");
  		}
		else {
			PlayerInfo[playerid][BankMoney]-=bankmoney;
			SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_bank6",PlayerInfo[playerid][BankMoney],bankmoney);
			GivePlayerMoney(playerid,bankmoney);
			return WriteLog(clearlog,LanguageString(GetPlayerLanguageID(playerid)));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_bank4");
	}
	return 1;
}
COMMAND:para(playerid, params[] ) {
#pragma unused params
	if(GetPlayerMoney(playerid)>=500) {
	    new
	        Float:fX,
	        Float:fY,
	        Float:fZ;
		GivePlayerMoney(playerid,-500);
		GetPlayerPos(playerid,fX,fY,fZ);
		SetPlayerPos(playerid,fX,fY,fZ+600.0);
		GivePlayerWeapon(playerid, WEAPON_PARACHUTE, 1);
		GameTextForPlayer(playerid,"~w~ Para ~y~W~h~u~h~huu...",3000,4);
	}
	return 1;
}
COMMAND:hitman(playerid,params[]){
	new
		giveid,
		cash;
	if (sscanf(params, "ud",giveid,cash)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /hitman [Player / ID] [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)){
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	}
	else if(cash>GetPlayerMoney(playerid)){
		return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_hitman1");
 	}
 	else if(cash<1){
		return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_hitman2");
 	}
 	else if(giveid==playerid) {
		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_hitman3");
  	}
	else {
		GivePlayerMoney(playerid,-cash);
		PlayerInfo[giveid][Bounty]+=cash;
		SendClientLanguageMessageToAll(COLOR_YELLOW,"txt_hitman4",PlayerName(playerid),cash,PlayerName(giveid),PlayerInfo[giveid][Bounty]);
	}
	return 1;
}

COMMAND:bounty(playerid, params[]) {
	new
		giveid;
	if (sscanf(params, "u",giveid)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /bounty [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
	}
	else if(!IsPlayerConnected(giveid)) {
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_bounty1",PlayerInfo[giveid][Bounty],PlayerName(giveid),giveid);
	}
	return 1;
}
#endif
#if defined LOCK_MODE
COMMAND:lock(playerid, params[] ) {
#pragma unused params
	new
		vid;
	if((vid=GetPlayerVehicleID(playerid))){
		if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER) {
			if(!IsVehicleFlag(vid,VEHICLE_FLAG_LOCK)) {
				foreachEx(i) {
					SetVehicleParamsForPlayer(vid,i,0,1);
				}
				SetVehicleParamsForPlayer(vid,playerid,0,0);
				SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_lock1");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);

			 	AddVehicleFlag(vid,VEHICLE_FLAG_LOCK);
			 	VehicleInfo[vid][LockCount] = 2;
			 	VehicleInfo[vid][iOwnerID] = playerid;
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_lock2");
			}
		}
		else {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_tuner1");
		}
	}
  	else {
		SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_lock3");
	}
	return 1;
}
COMMAND:unlock(playerid, params[] ) {
#pragma unused params
	new
		vid;
	if((vid=GetPlayerVehicleID(playerid))){
		if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER) {
			if(!IsVehicleFlag(vid,VEHICLE_FLAG_LOCK)) {
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_unlock1");
			}
			else {
				UnlockCar(vid);
				PlayerPlaySound(playerid,1057,0.0,0.0,0.0);
				return SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_unlock2");
			}
		}
		else {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_tuner1");
		}
	}
   	else {
		SendClientLanguageMessage(playerid,COLOR_RED,"txt_unlock3");
	}
	return 1;
}
COMMAND:xunlock(playerid,params []) {
#pragma unused params,playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lxunlock]) {
		for(new v=1;v<MAX_VEHICLES;v++) {
		    UnlockCar(v);
		}
		return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_xunlock1");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
#if defined DISPLAY_MODE
COMMAND:speedo(playerid, params[]) {
	if(!g_Display) {
		return 0;
	}
	else {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /speedo [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
		}
		else if(strlen(params) > 16) { // Should be enaugh
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		else if(!strcmp(params,off,true)) {
			if(IsPlayerFlag(playerid,PLAYER_FLAG_SPEEDO)) {
				DeletePlayerFlag(playerid,PLAYER_FLAG_SPEEDO);
				#if defined DISPLAY_MODE_TD
				if(IsPlayerInAnyVehicle(playerid)) {
					TextDrawHideForPlayer(playerid,PlayerInfo[playerid][td_PlayerDraw]);
				}
				#endif
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_speedo1");
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_speedo2");
			}
		}
		else if(!strcmp(params,on,true)) {
			if(IsPlayerFlag(playerid,PLAYER_FLAG_SPEEDO)) {
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_speedo3");
			}
			else {
				AddPlayerFlag(playerid,PLAYER_FLAG_SPEEDO);
				#if defined DISPLAY_MODE_TD
				TextDrawShowForPlayer(playerid,PlayerInfo[playerid][td_PlayerDraw]);
				#endif
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_speedo4");
			}
		}
		else {
			SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /speedo [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
		}
	}
	return 1;
}
COMMAND:speedotype(playerid, params[]) {
	if(!g_Display) {
		return 0;
	}
	else {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /speedotype [kmh/mph]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(strlen(params) > 4) {
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		else if(!strcmp(params,"kmh",true)) {
			if(PlayerInfo[playerid][speedo_type]==KMH_MODE) {
				PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_stype1");
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_stype2");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				PlayerInfo[playerid][speedo_type]=KMH_MODE;
			}
		}
		else if(!strcmp(params,"mph",true)) {
			if(PlayerInfo[playerid][speedo_type]==MPH_MODE) {
				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_stype3");
				PlayerPlaySound(playerid,1055,0.0,0.0,0.0);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_stype4");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				PlayerInfo[playerid][speedo_type]=MPH_MODE;
			}
		}
		else {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /speedotype [kmh/mph]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
	}
	return 1;
}
#endif


/* ADMIN PART SYSTEM */
COMMAND:register(playerid,params[]) {
	new
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if (IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_register1");
	}
	if (isnull(params) || strlen(params) < 4) {
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_register3",#CMD_REGISTER);
	}
    #if defined MYSQL
	if (gSQL_ExistUser(ThePlayer)) {
	#else
	if (udb_Exists(ThePlayer)) {
	#endif
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_register2",#CMD_LOGIN);
	}
	else {
	    #if defined MYSQL
	    gSQL_AddUser(ThePlayer,params);
	    #else
	    udb_Create(ThePlayer,params);
	    #endif
		OnPlayerRegister(playerid);
		SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_selectlanguage");
	}
	return 1;
}

COMMAND:login(playerid,params[]) {
	new
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if (IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN)) {
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login4");
	}
	#if defined MYSQL
	if(!gSQL_ExistUser(ThePlayer)) {
	#else
	if(!udb_Exists(ThePlayer)) {
	#endif
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login5",#CMD_REGISTER);
	}
	#if defined LOGIN_PANEL
	if(!isnull(params)) {
		if(strlen(params) < 4) {
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login6",#CMD_LOGIN);
		}
		#if defined MYSQL
		if (gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")==num_hash(params)) {
		#else
		if (udb_CheckLogin(ThePlayer,params)) {
		#endif
			printf("[Login] Skipped Login-Panel for %s (%d)",PlayerName(playerid),playerid);
			OnPlayerLogin(playerid,LOGIN_NORMAL);
			return 1;
		}
		PlayerInfo[playerid][WrongPW]++;
		SendClientLanguageMessage(playerid,COLOR_GREY,"txt_login7",PlayerInfo[playerid][WrongPW],MAX_WRONG_PW);
		if(PlayerInfo[playerid][WrongPW]==MAX_WRONG_PW) {
			SendClientLanguageMessageToAll(COLOR_GREY,"txt_login9",ThePlayer);
			KickEx(playerid,9);
		}
	}
	else { // no text,display the dialog!
		s[0]='\0';
   	    format(s,sizeof(s),"Welcome %s.\n\n\n\nPlease enter your password below in order to Login",ThePlayer);
		KillTimer(PlayerInfo[playerid][tLoginPanel]);
		ShowPlayerDialog(playerid,playerid,DIALOG_STYLE_INPUT,"gAdmin || Login",s,"Login","Cancel");
		PlayerInfo[playerid][iDialogID] = PANEL_DIALOG;
		AddPlayerFlag(playerid,PLAYER_FLAG_LOGINPANEL);
	}
	#else
		if((isnull(params)) ||(strlen(params) < 4)) {
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_login6",#CMD_LOGIN);
		}
		#if defined MYSQL
		if (gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")==num_hash(params)) {
		#else
		if (udb_CheckLogin(ThePlayer,params)) {
		#endif
			OnPlayerLogin(playerid,LOGIN_NORMAL);
			return 1;
		}
		PlayerInfo[playerid][WrongPW]++;
		SendClientLanguageMessage(playerid,COLOR_GREY,"txt_login7",PlayerInfo[playerid][WrongPW],MAX_WRONG_PW);
		if(PlayerInfo[playerid][WrongPW]==MAX_WRONG_PW) {
			SendClientLanguageMessageToAll(COLOR_GREY,"txt_login9",ThePlayer);
			KickEx(playerid,9);
		}
	#endif
	return 1;
}
COMMAND:changepw(playerid,params[]) {
	new
	    ThePlayer[MAX_PLAYER_NAME],
		tmp[128],
		tmp2[128];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if (sscanf(params, "ss",tmp,tmp2)) {
		return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /%s [old pw] [new pw]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),#CMD_CHANGEPW);
	}
	#if defined MYSQL
	new
		n_hash=num_hash(tmp);
	if(gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")==n_hash && IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN) && strlen(tmp2)>=4) {
	    gSQL_SetUserVarAsInteger(ThePlayer,"password_hash",num_hash(tmp2));
	#else
	if(udb_CheckLogin(ThePlayer,tmp)==1 && IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN) && strlen(tmp2)>=4) {
		udb_UserSetInt(ThePlayer,"password_hash",num_hash(tmp2));
	#endif
		SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_changepw1",tmp2);
	}
	#if defined MYSQL
	else if(gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")==n_hash && IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN) && strlen(tmp2)<4) {
	#else
	else if(udb_CheckLogin(ThePlayer,tmp)==1 && IsPlayerFlag(playerid,PLAYER_FLAG_LOGGEDIN) && strlen(tmp2)<4) {
	#endif
		SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_changepw3");
	}
	#if defined MYSQL
	else if(gSQL_GetUserVarAsInteger(ThePlayer,"password_hash")!=n_hash) {
	#else
	else if(!udb_CheckLogin(ThePlayer,tmp)) {
	#endif
		SendClientLanguageMessage(playerid,COLOR_RED,"txt_changepw2",tmp2);
	}
	return 1;
}
COMMAND:commands(playerid, params[]) {
#pragma unused params
	SendClientMessage(playerid,COLOR_WHITE,"*************************");
	SendClientFormatMessage(playerid,COLOR_YELLOW,"[User] /%s /%s /%s",#CMD_REGISTER,#CMD_LOGIN,#CMD_CHANGEPW);
	GeneralCommands(playerid);
	SendClientMessage(playerid,COLOR_ORANGE,"/ahelp for Admin Command");
	if(IsPlayerFlag(playerid,PLAYER_FLAG_VIP) || PlayerInfo[playerid][AdminLevel]>=2) {
		SendClientMessage(playerid,COLOR_ORANGE,"V.I.P Chat:*");
	}
	return SendClientMessage(playerid,COLOR_WHITE,"*************************");
}

COMMAND:data(playerid, params[]) {
#pragma unused params
	new
	    sDate[16] = "- NONE -",
	    ThePlayer[MAX_PLAYER_NAME],
	    giveid,
	    seconds,
	    minute,
	    hour;
	if (sscanf(params, "u", giveid)) {
	    giveid = playerid;
	}
	GetPlayerName(giveid,ThePlayer,sizeof(ThePlayer));
	#if defined MYSQL
	    format(sDate,sizeof(sDate),gSQL_GetUserVar(ThePlayer,"RegDate"));
	#else
	    format(sDate,sizeof(sDate),dUser(ThePlayer).("RegDate"));
	#endif
	ConvertSec((PlayerInfo[giveid][iSeconds] + floatround(((GetTickCount() - PlayerInfo[giveid][tickConnect] ) / 1000))),seconds,minute,hour);
	format(s,sizeof(s),"------ User - %s (%d) --------",ThePlayer,giveid);
	SendClientMessage(playerid,COLOR_GREEN,s);
	#if defined MYSQL
	format(s,sizeof(s),"** AdminLevel: %d Language: %d (%s) UserID: %d Onlinetime: %d:%02d:%02d RegisterDate: %s",PlayerInfo[giveid][AdminLevel],_:GetPlayerLanguageID(giveid),GetShortLanguageName(GetPlayerLanguageID(giveid)),PlayerInfo[giveid][UniqueID],hour,minute,seconds,sDate);
	#else
	format(s,sizeof(s),"** AdminLevel: %d Language: %d (%s) Onlinetime: %d:%02d:%02d RegisterDate: %s",PlayerInfo[giveid][AdminLevel],_:GetPlayerLanguageID(giveid),GetShortLanguageName(GetPlayerLanguageID(giveid)),hour,minute,seconds,sDate);
	#endif
	SendClientMessage(playerid,COLOR_YELLOW,s);
	format(s,sizeof(s),"** Money: %d$ Kills: %d Deaths: %d Ratio: %.2f",GetPlayerMoney(giveid),PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths],(PlayerInfo[giveid][Deaths]>0) ? floatdiv(PlayerInfo[giveid][Kills],PlayerInfo[giveid][Deaths]) : float(PlayerInfo[giveid][Kills]));
	SendClientMessage(playerid,COLOR_YELLOW,s);
	#if defined EXTRA_COMMANDS
	format(s,sizeof(s),"** BankMoney: %d  Times Spawned: %d",PlayerInfo[giveid][BankMoney],PlayerInfo[giveid][SpawnCount]);
	#else
	format(s,sizeof(s),"** Times Spawned: %d",PlayerInfo[giveid][SpawnCount]);
	#endif
	SendClientMessage(playerid,COLOR_YELLOW,s);
	if(CheckFileEntry(-1,whitelist_file,ThePlayer)) {
		SendClientMessage(playerid,COLOR_YELLOW,"*** On Whitelist: true");
	}
	else {
		SendClientMessage(playerid,COLOR_YELLOW,"*** On Whitelist: false");
	}
	return 1;
}
COMMAND:language(playerid, params[]) {
	if(Language_Count == 1) {
		return 0;
	}
	else {
	    #if defined _samp03_
	        #pragma unused params
	        new
	            sBig[256];
			for(new Language:i;_:i<Language_Count;_:i++) {
			    format(s,sizeof(s),"%s, %s - %d",GetShortLanguageName(i),GetLanguageName(i),_:i);
				format(sBig,sizeof(sBig),"%s\n%s",sBig,s);
			}
			ShowPlayerDialog(playerid,playerid,DIALOG_STYLE_LIST,"gAdmin || Language",sBig,"Ok","Cancel");
			PlayerInfo[playerid][iDialogID] = LANGUAGE_LIST;
	    #else
		if(strlen(params) > SMALL_LEN ) {
  			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
  		else if (isnull(params)) {
			for(new Language:i;_:i<Language_Count;_:i++) {
			    format(s,sizeof(s),"%s, %s - %d",GetShortLanguageName(i),GetLanguageName(i),_:i);
			    SendClientMessage(playerid,COLOR_ORANGE,s);
			}
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /language [Short form]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
			for(new Language:i;_:i<Language_Count;_:i++) {
			    if(!strcmp(GetShortLanguageName(i),params,true,SMALL_LEN)) {
					SetPlayerLanguageID(playerid,i);
					SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_langvalid",GetLanguageName(i));
					return 1;
			    }
			}
		    SendClientLanguageMessage(playerid,COLOR_RED2,"txt_langfail",params);
			for(new Language:i;_:i<Language_Count;_:i++) {
			    format(s,sizeof(s),"%s, %s - %d",GetShortLanguageName(i),GetLanguageName(i),_:i);
			    SendClientMessage(playerid,COLOR_ORANGE,s);
			}
		}
		#endif
	}
	return 1;
}
COMMAND:admins(playerid, params[]) {
	#pragma unused params
	new
		Count;
	s[0]='\0';
	foreachEx(i) {
	    /* Disconnected users have AdminLevel -1 */
		if(PlayerInfo[i][AdminLevel]>=2) {
			Count++;
			if(strlen(s) > (128 - (MAX_PLAYER_NAME + 6))) {
			    SendClientMessage(playerid,COLOR_YELLOW,s);
				format(s,sizeof(s),"... %s (%d)",PlayerName(i),PlayerInfo[i][AdminLevel]);
				Count=1;
				continue; // Jump to next player
			}
			if(Count==1) {
				format(s,sizeof(s),"Admins online: %s (%d)",PlayerName(i),PlayerInfo[i][AdminLevel]);
			}
			else {
				format(s,sizeof(s),"%s, %s (%d)",s,PlayerName(i),PlayerInfo[i][AdminLevel]);
			}
		}
	}
	if(!Count) {
		SendClientLanguageMessage(playerid,COLOR_RED2,"txt_admins1");
		return 1;
	}
	return SendClientMessage(playerid,COLOR_YELLOW,s);
}
/*
COMMAND:sound(playerid,params[]) {
	new
	    soundid;
	if(sscanf(params,"d",soundid)) {
	    return SendClientMessage(playerid,COLOR_RED,"Usage: /sound [soundid]");
	}
	PlayerPlaySound(playerid,soundid,0.0,0.0,0.0);
	SendClientMessage(playerid,COLOR_YELLOW,"sound...");
	return 1;
}
*/
COMMAND:ahelp(playerid, params[]) {
	#pragma unused params
	SendClientMessage(playerid,COLOR_WHITE,"______ Admin Commands: _______");
	return AdminCommands(playerid);
}

COMMAND:kick(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lkick]) {
		new
			giveid,
			msg[128];
		if (sscanf(params, "uz",giveid,msg)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /kick [Player / ID] [Reason (optional)]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_kick1",msg[0] ? msg : ("<No reason>"));
				CreateClientLanguageMessages("txt_kick2",PlayerName(giveid),giveid,PlayerName(playerid),msg[0] ? msg : ("<No reason>"));
				SendAdminCommand(COLOR_YELLOW);
				WriteLog(clearlog,LanguageString(ServerLanguage()));
	  			return KickEx(giveid,2);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_kick3");
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_kick4",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:fake(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lfake]) {
		new
			giveid,
			msg[128];
		if (sscanf(params, "us",giveid,msg)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /fake [Player / ID] [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
		else {
			if(PlayerInfo[playerid][AdminLevel]<=PlayerInfo[giveid][AdminLevel]){
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_fake1",PlayerName(playerid),msg);
				return SendClientLanguageMessage(playerid,COLOR_RED,"txt_fake2");
			}
			else {
				return SendPlayerMessageToAll(giveid,msg);
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:heal(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lheal]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /heal [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
	   	else {
	  		SetPlayerHealth(giveid,100.0);
			CreateClientLanguageMessages("txt_heal1",PlayerName(giveid),giveid,PlayerName(playerid));
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			return SendAdminCommand(COLOR_YELLOW);
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:sethp(playerid,params[]) {
	return cmd_sethealth(playerid,params);
}
COMMAND:sethealth(playerid,params[]){
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsethealth]) {
		new
			giveid,
			Float:fHealthPoints;
		if (sscanf(params, "uf",giveid,fHealthPoints)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /sethealth [Player / ID] [Float:HP]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(fHealthPoints<1){
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_sethp1");
	 	}
		else {
			SetPlayerHealth(giveid,fHealthPoints);
			CreateClientLanguageMessages("txt_sethp2",PlayerName(playerid),PlayerName(giveid),giveid,fHealthPoints);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:slap(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lslap]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /slap [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				new
			        Float:fX,
			        Float:fY,
			        Float:fZ,
					Float:fHealth;
	  			GetPlayerPos(giveid,fX,fY,fZ);
				SetPlayerPos(giveid,fX,fY,(fZ + 3.0));
				if(!IsPlayerFlag(giveid,PLAYER_FLAG_GOD)) {
					GetPlayerHealth(giveid,fHealth);
					#if defined gDebug
					printf("fHealth = %.2f,g_fSLapHP %.2f (0x%x)",fHealth,g_fSlapHP,(fHealth - g_fSlapHP));
					#endif
					fHealth -= g_fSlapHP;
					SetPlayerHealth(giveid,fHealth);
				}
				PlayerPlaySound(giveid,1190,0.0,0.0,0.0);
				CreateClientLanguageMessages("txt_slap1",PlayerName(giveid),giveid,PlayerName(playerid));
				SendAdminCommand(COLOR_YELLOW);
				return WriteLog(clearlog,LanguageString(ServerLanguage()));
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_slap2");
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_slap3",PlayerName(playerid));
			}
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:freeze(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lfreeze]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /freeze [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
	   	else {
	   		if(!IsPlayerFlag(giveid,PLAYER_FLAG_FREEZE)) {
		   		if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
					TogglePlayerControllable(giveid,false);
					CreateClientLanguageMessages("txt_freeze2",PlayerName(giveid),giveid,PlayerName(playerid));
					SendAdminCommand(COLOR_YELLOW);
					AddPlayerFlag(giveid,PLAYER_FLAG_FREEZE);
					return WriteLog(clearlog,LanguageString(ServerLanguage()));
				}
				else {
					SendClientLanguageMessage(playerid,COLOR_RED,"txt_freeze3");
					return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_freeze4",PlayerName(playerid));
				}
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_freeze5",PlayerName(playerid));
			}
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:unfreeze(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lunfreeze]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /unfreeze [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
	   	else {
	   		if(IsPlayerFlag(giveid,PLAYER_FLAG_FREEZE)) {
		   		if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
					TogglePlayerControllable(giveid,true);
					CreateClientLanguageMessages("txt_unfreeze2",PlayerName(giveid),giveid,PlayerName(playerid));
					SendAdminCommand(COLOR_YELLOW);
					DeletePlayerFlag(giveid,PLAYER_FLAG_FREEZE);
					return WriteLog(clearlog,LanguageString(ServerLanguage()));
				}
				else {
					return SendClientLanguageMessage(playerid,COLOR_RED,"txt_unfreeze3");
				}
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_unfreeze4",PlayerName(playerid));
			}

   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:gravity(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgravity])	{
		new
			Float:fGrav;
		if (sscanf(params, "f",fGrav)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /gravity [Float:Gravity]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
   		else if (fGrav > 20.0 || fGrav < -20.0)	{
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /gravity [Float:Gravity(-20.0 - 20.0)]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
			SetGravity(fGrav);
			CreateClientLanguageMessages("txt_gravity1",fGrav);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:ip(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lip])	{
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /ip [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
	   		new
  				IP[16];
			GetPlayerIp(giveid,IP,sizeof(IP));
			SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_ip1",PlayerName(giveid),IP);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:ban(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lban]) {
		new
			giveid,
			msg[128];
		if (sscanf(params, "uz",giveid,msg)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /ban [Player / ID] [Reason (optional)]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
	   	else {
			if(PlayerInfo[playerid][AdminLevel]>PlayerInfo[giveid][AdminLevel]){
			    new
					TheBannedPlayer[MAX_PLAYER_NAME];
				GetPlayerName(giveid,TheBannedPlayer,sizeof(TheBannedPlayer));
	 			SendClientLanguageMessage(giveid,COLOR_RED2,"txt_ban1",msg[0] ? msg : ("<No reason>"));
	  			CreateClientLanguageMessages("txt_ban2",TheBannedPlayer,giveid,PlayerName(playerid),msg[0] ? msg : ("<No reason>"));
				SendAdminCommand(COLOR_YELLOW);
				WriteLog(clearlog,LanguageString(ServerLanguage()));
				#if defined MYSQL
				gSQL_SetUserVarAsInteger(TheBannedPlayer,"Trusted",-1);
				#else
				dUserSetINT(TheBannedPlayer).("Trusted",-1);		// Remove from Trusted
				#endif
				return BanEx2(giveid,13);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_ban3");
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_ban4",PlayerName(playerid));
			}
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:tban(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ltban]) {
		new
			giveid,
			days;
		if (sscanf(params, "ud",giveid,days)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /tban [Player / ID] [days]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
		else {
			new
				ThePlayer[MAX_PLAYER_NAME];
			GetPlayerName(giveid,ThePlayer,sizeof(ThePlayer));
			#if defined MYSQL
			if(gSQL_ExistUser(ThePlayer)) {
			#else
			if(udb_Exists(ThePlayer)) {
			#endif
				if(PlayerInfo[giveid][AdminLevel]<2) {
					new
				    	day,
				    	month,
				    	year;
					GetDateTilBanned(days,day,month,year);
					format(s,sizeof(s),"%d|%d|%d|",day,month,year);
					#if defined MYSQL
					gSQL_SetUserVar(ThePlayer,"TimeBan",s);
					#else
					dUserSet(ThePlayer).("TimeBan",s);
					#endif
					CreateClientLanguageMessages("txt_timeban2",ThePlayer,giveid,PlayerName(playerid),day,month,year);
					SendAdminCommand(COLOR_ORANGERED);
					BanEx2(giveid,13);
				}
				else {
					SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_ban3");
					SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_ban4",ThePlayer);
				}
			}
			else {
			    SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_timeban3");
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:goto(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgoto]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /goto [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
		else if(!IsPlayerSpawned(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_NotSpawned");
		}
	   	else {
			new
				Float:gX,
				Float:gY,
				Float:gZ,
				Float:Face;
			GetPlayerFacingAngle(giveid,Face);
	   		GetPlayerPos(giveid,gX,gY,gZ);
	   		GetXYInFrontOfPlayer(giveid, gX, gY, -1);
			TeleportPlayer(playerid,gX,gY,gZ,Face,GetPlayerInterior(giveid),GetPlayerVirtualWorld(giveid));
	   		CreateClientLanguageMessages("txt_goto1",PlayerName(playerid),PlayerName(giveid),giveid);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:mute(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lmute]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /mute [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
	   	else {
	   		if(!IsPlayerFlag(giveid,PLAYER_FLAG_MUTE)) {
				if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
					AddPlayerFlag(giveid,PLAYER_FLAG_MUTE);
					SendClientLanguageMessage(giveid,COLOR_ORANGE,"txt_mute2");
					CreateClientLanguageMessages("txt_mute1",PlayerName(giveid),giveid,PlayerName(playerid));
					SendAdminCommand(COLOR_YELLOW);
					WriteLog(clearlog,LanguageString(ServerLanguage()));
					return 1;
				}
				else {
					SendClientLanguageMessage(playerid,COLOR_RED,"txt_mute3");
					return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_mute4",PlayerName(playerid));
				}
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_mute5",PlayerName(giveid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}


COMMAND:unmute(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lunmute]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /unmute [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
	   	else  {
	   		if(IsPlayerFlag(giveid,PLAYER_FLAG_MUTE)) {
		  		DeletePlayerFlag(giveid,PLAYER_FLAG_MUTE);
				CreateClientLanguageMessages("txt_unmute1",PlayerName(giveid),giveid,PlayerName(playerid));
				SendAdminCommand(COLOR_YELLOW);
				return WriteLog(clearlog,LanguageString(ServerLanguage()));
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_unmute2",PlayerName(giveid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:akill(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lakill]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /akill [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
	   	else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				SetPlayerHealth(giveid,0.0);
				CreateClientLanguageMessages("txt_akill1",PlayerName(giveid),giveid,PlayerName(playerid));
				return SendAdminCommand(COLOR_YELLOW);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_akill2");
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_akill3",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:get(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lget]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /get [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
		else if(giveid==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
		else if(!IsPlayerSpawned(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_NotSpawned");
		}
	   	else  {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				new
					Float:gX,
					Float:gY,
					Float:gZ,
					Float:Facing;
			   	GetPlayerPos(playerid,gX,gY,gZ);
			   	GetPlayerFacingAngle(playerid,Facing);
	 			TeleportPlayer(giveid,gX,gY,gZ,Facing,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
   				CreateClientLanguageMessages("txt_get1",PlayerName(giveid),giveid,PlayerName(playerid));
				WriteLog(clearlog,LanguageString(ServerLanguage()));
				return SendAdminCommand(COLOR_YELLOW);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_get4",PlayerName(playerid));
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_get3");
			}
   		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:jail(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ljail]) {
		new
			giveid,
			time = g_DefJailTime;
	    s[0]='\0';
		if (sscanf(params, "uz",giveid,s)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /jail [Player / ID] ([Time in seconds])",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
  		else if(IsPlayerFlag(giveid,PLAYER_FLAG_JAIL)) {
   			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_jail1");
	   	}
   		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
			    if(s[0]) { // seconds given
			        sscanf(s,"d",time);
			    }
	  			AddPlayerFlag(giveid,PLAYER_FLAG_JAIL);
	  			KillTimer(PlayerInfo[giveid][tJail]);
	  			PlayerInfo[giveid][tJail]=SetTimerEx("ReleasePlayer",time*1000,0,"d",giveid);
	  			SetJail(giveid,true);
				CreateClientLanguageMessages("txt_jail2",PlayerName(giveid),giveid,PlayerName(playerid),time);
				SendAdminCommand(COLOR_YELLOW);
				return WriteLog(clearlog,LanguageString(ServerLanguage()));
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_jail3");
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_jail4",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:unjail(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lunjail]) {
		new
			giveid;
		if (sscanf(params, "u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /unjail [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
   		else if(!IsPlayerFlag(giveid,PLAYER_FLAG_JAIL)) {
   			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_unjail1");
		}
		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
			    KillTimer(PlayerInfo[giveid][tJail]);
			    DeletePlayerFlag(giveid,PLAYER_FLAG_JAIL);
	  			SetJail(giveid,false);
				CreateClientLanguageMessages("txt_unjail2",PlayerName(giveid),giveid,PlayerName(playerid));
				SendAdminCommand(COLOR_YELLOW);
				return WriteLog(clearlog,LanguageString(ServerLanguage()));
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED,"txt_unjail3");
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:settime(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsettime]) {
		new
			hour;
		if (sscanf(params, "d",hour)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /settime [Hour]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(hour < 0 || hour > 23 ) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_worldtime1");
		}
		else {
			g_Time=hour;
			g_TimeUpdate_Count=0;
			SetWorldTime(g_Time);
			CreateClientLanguageMessages("txt_worldtime2",g_Time);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:ann(playerid, params[]) {
	cmd_announce(playerid,params);
}
COMMAND:announce(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lannounce]) {
		new
		    msg[128],
		    style=4,
		    time=3500;
		if (sscanf(params,"s",msg)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /announce ([time in ms] [style]) [Message] ",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		if(!sscanf(msg,"dds",time,style,msg)) {}
		if(time > MAX_ANNOUNCE_TIME || time < 500) {
		    SendClientLanguageMessage(playerid,COLOR_RED,"txt_announce1",MAX_ANNOUNCE_TIME);
			return 1;
		}
		if(style < 0 || style > 6 || style == 2) {
		    SendClientLanguageMessage(playerid,COLOR_RED,"txt_announce2");
			return 1;
		}
		else {
			#if defined DISPLAY_MODE && !defined DISPLAY_MODE_TD
			g_SpeedOMeterUpdate_Count=g_SpeedOMeterUpdate+1;
			g_AreaNameUpdate_Count=g_AreaNameUpdate+1;
			g_SpeedNameUpdate_Count=g_SpeedNameUpdate+1;
			g_tRestart=SetTimer("RestartDisplay",time+50,0);
			#endif
			return GameTextForAll(msg,time,style);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:addblack(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[laddblack]) {
		new
			giveid;
		//giveid = strval(params);
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /addblack [playerid]/[PlayerName]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		if(isNumeric(params)) { // ID
			if(sscanf(params, "d",giveid)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /addblack [playerid]/[PlayerName]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			}
			if(!IsPlayerConnected(giveid)) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
			}
			else {
				if(PlayerInfo[giveid][AdminLevel]<=2){
					WriteBlacklist(playerid,PlayerName(giveid));
					SendClientLanguageMessage(giveid,COLOR_RED2,"txt_addblack1");
					CreateClientLanguageMessages("txt_addblack2",PlayerName(giveid),giveid);
					WriteLog(clearlog,LanguageString(ServerLanguage()));
					SendAdminCommand(COLOR_YELLOW);
		 			return BanEx2(giveid,13);
				}
				else {
					SendClientLanguageMessage(playerid,COLOR_RED,"txt_addblack3");
					return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_addblack4",PlayerName(playerid));
				}
			}
		}
		else {  //Name
			#if defined MYSQL
			if((gSQL_ExistUser(params)) && (gSQL_GetUserVarAsInteger(params,"AdminLevel") >= 2)) {
			#else
		  	if (udb_Exists(params) && dUserINT(params).("AdminLevel")>=2) {
			#endif
		  		return SendClientLanguageMessage(playerid,COLOR_RED,"txt_rangeban1");
			}
			else {
				giveid=PlayerID(params);
				if(giveid!=-1 && giveid!=-2) {
					new
						ThePlayer[MAX_PLAYER_NAME];
					GetPlayerName(giveid,ThePlayer,MAX_PLAYER_NAME);
  					WriteBlacklist(playerid,ThePlayer);
					CreateClientLanguageMessages("txt_addblack2",ThePlayer,giveid);
					WriteLog(clearlog,LanguageString(ServerLanguage()));
					SendAdminCommand(COLOR_YELLOW);
				    #if defined MYSQL
				    gSQL_SetUserVarAsInteger(ThePlayer,"Trusted",-1);
				    #else
  					dUserSetINT(ThePlayer).("Trusted",-1);			  				// Remove from Trusted
					#endif
				   	return Ban(giveid);
				}
				else {
					giveid=INVALID_PLAYER_ID;
  					new
				  		check=WriteBlacklist(playerid,params);
				    #if defined MYSQL
				    gSQL_SetUserVarAsInteger(params,"Trusted",-1);
				    #else
  					dUserSetINT(params).("Trusted",-1);		  			// Remove from Trusted
					#endif
 					if(check==1) { //No msg (XY has been blacklisted) if entry already exists)
						CreateClientLanguageMessages("txt_addblack2",params,giveid);
						return SendAdminCommand(COLOR_YELLOW);
					}
   				}
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:addwhite(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[laddwhite]) {
		new
			giveid;
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /addwhite [playerid]/[PlayerName]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		if(isNumeric(params)) { // ID
			if(sscanf(params, "d",giveid)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /addwhite [playerid]/[PlayerName]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			}
	 		if(!IsPlayerConnected(giveid)) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		   	}
			return WriteWhiteList(playerid,PlayerName(giveid));
		}
		else { // NAME
			giveid=PlayerID(params);
			if(giveid!=-1 && giveid!=-2) {
			    #if defined MYSQL
			    gSQL_SetUserVarAsInteger(PlayerName(giveid),"Trusted",1);
			    #else
				dUserSetINT(PlayerName(giveid)).("Trusted",1);
				#endif
  				WriteWhiteList(playerid,PlayerName(giveid));
			}
			else {
			    #if defined MYSQL
			    gSQL_SetUserVarAsInteger(params,"Trusted",1);
			    #else
				dUserSetINT(params).("Trusted",1);
				#endif
  				WriteWhiteList(playerid,params);
   		   	}
   		   	return 1;
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:addclan(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[laddclanblack]) {
   		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /addclan [Clan Tag]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(strlen(params) > MAX_CLAN_LEN) {
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		else  {
			WriteClanBlacklist(playerid,params);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:banip(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lbanip]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /banip [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			if(PlayerInfo[giveid][AdminLevel]>=2) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_rangeban1");
			}
			else {
		   		WriteIPBan(playerid,giveid);
	   			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_rangeban2");
	   			#if defined MYSQL
	   			gSQL_SetUserVarAsInteger(PlayerName(giveid),"Trusted",-1);
	   			#else
				dUserSetINT(PlayerName(giveid)).("Trusted",-1);							   // Remove from Trusted
				#endif
				return KickEx(giveid,6);
	   		}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:rangeban(playerid,params[]) {
	return cmd_banip(playerid,params);
}
COMMAND:nick(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lnick]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /nick [New Nickname]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(strlen(params) > MAX_PLAYER_NAME) {
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		else {
			CreateClientLanguageMessages("txt_nick2",PlayerName(playerid),params);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			SetPlayerName(playerid,params);
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_nick3",params);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:countdown(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lcountdown]) {
		new
			count,
			sFreeze[16],
			doFreeze=0;
		if (sscanf(params, "dz", count,sFreeze)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /countdown [Seconds] ([Freeze 0/1])",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(count > MAX_COUNTDOWN || count < 2) {
			return SendClientLanguageMessage(playerid,COLOR_PINK,"txt_countdown1");
		}
		else {
			if(g_StepCountdown) {
				SendClientLanguageMessage(playerid,COLOR_PINK,"txt_countdown2");
				KillTimer(g_tCountdown);
			}
			sscanf(sFreeze,"d",doFreeze);
			if(doFreeze > 1) doFreeze = 1;
			if(doFreeze < 0) doFreeze = 0;
			g_tCountdown=SetTimerEx("Countdown",1000,1,"d",doFreeze);
			g_StepCountdown=count;
			Countdown(doFreeze);
		}
		#if defined DISPLAY_MODE && !defined DISPLAY_MODE_TD
		g_SpeedOMeterUpdate_Count=g_SpeedOMeterUpdate+1;
		g_AreaNameUpdate_Count=g_AreaNameUpdate+1;
		g_SpeedNameUpdate_Count=g_SpeedNameUpdate+1;
		#endif
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:reloadcfg(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lreloadcfg]) {
		LoadConfig();
		SendClientMessage(playerid,COLOR_YELLOW,"/gAdmin Config/~config.cfg has been reloaded");
		return WriteLog(clearlog,"* Reloaded " #generalconfig " & " #levelconfig "");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:reloadlanguages(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lreloadlanguages]) {
		/* Clear old Entrys */
		ReloadLanguages();
		SendClientMessage(playerid,COLOR_YELLOW,"Language(s) has been reloaded");
		return WriteLog(clearlog,"Language(s) has been reloaded");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:reloadfs(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lreloadfs]) {
		//SendRconCommand("unloadfs gAdmin");
		return SendRconCommand("reloadfs gAdmin");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:reloadbans(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lreloadbans]) {
		SendRconCommand("reloadbans");
		return SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_reloadbans1");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:allmoney(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lallmoney]) {
		new
			money;
		if (sscanf(params, "d",money)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /allmoney [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
			foreachEx(i){
				GivePlayerMoney(i,money);
		   	}
  			CreateClientLanguageMessages("txt_allmoney1",money,PlayerName(playerid));
   			SendAdminCommand(COLOR_ORANGE);
   			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:givecash(playerid,params[]){
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgivecash]) {
		new
			giveid,
			cash;
		if (sscanf(params, "ud", giveid,cash)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /givecash [Player / ID] [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)){
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			GivePlayerMoney(giveid,cash);
			CreateClientLanguageMessages("txt_givecash1",PlayerName(playerid),PlayerName(giveid),cash);
			SendAdminCommand(COLOR_ORANGE);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			return SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_givecash2",PlayerName(playerid),cash);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:setmoney(playerid,params[]){
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsetmoney]) {
		new
			giveid,
			cash;
		if (sscanf(params, "ud", giveid,cash)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setmoney [Player / ID] [Amount]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)){
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			SetPlayerMoney(giveid,cash);
			CreateClientLanguageMessages("txt_setmoney1",PlayerName(playerid),PlayerName(giveid),cash);
			SendAdminCommand(COLOR_ORANGE);
			SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_setmoney2",cash);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:setadmin(playerid,params[]){
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsetadmin] || IsPlayerAdmin(playerid)) { //Rcon Admin can set too
		new
			giveid,
			adminlvl;
		if (sscanf(params, "ud", giveid,adminlvl)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setadmin [Player / ID] [Adminlevel]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		if(!IsPlayerConnected(giveid)){
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		if(!IsPlayerFlag(giveid,PLAYER_FLAG_LOGGEDIN)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_setadmin2");
		}
		if(PlayerInfo[playerid][AdminLevel]<PlayerInfo[giveid][AdminLevel]) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_setadmin6");
		}
		if(playerid==giveid && !IsPlayerAdmin(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_setadmin3");
		}
		if(PlayerInfo[playerid][AdminLevel]<adminlvl && !IsPlayerAdmin(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_setadmin1");
		}
		else {
			PlayerInfo[giveid][AdminLevel]=adminlvl;
			#if defined MYSQL
			gSQL_SetUserVarAsInteger(PlayerName(giveid),"AdminLevel",PlayerInfo[giveid][AdminLevel]);
			#else
			dUserSetINT(PlayerName(giveid)).("AdminLevel",PlayerInfo[giveid][AdminLevel]);
			#endif
			if(IsPlayerAdmin(playerid) && giveid==playerid) { //Rcon Adminds can set Admin lvl,I think its handy
				CreateClientLanguageMessages("txt_setadmin5",adminlvl);
				SendClientPreLanguageMessage(giveid,COLOR_LIGHTBLUE);
				WriteLog(adminlog,LanguageString(ServerLanguage()));
			}
			else {
			    new
			        old_level = PlayerInfo[giveid][AdminLevel];
				PlayerInfo[giveid][AdminLevel]=adminlvl;
				CreateClientLanguageMessages("txt_setadmin4",PlayerName(giveid),adminlvl);
				SendClientPreLanguageMessage(playerid,COLOR_WHITE);
				WriteLog(adminlog,LanguageString(ServerLanguage()));
				CreateClientLanguageMessages("txt_setadmin5",adminlvl);
				SendClientPreLanguageMessage(giveid,COLOR_LIGHTBLUE);
				WriteLog(clearlog,LanguageString(ServerLanguage()));
			    if(old_level < 2 && adminlvl >= 2) { // We have a NEW admin!
					SendClientLanguageMessage(giveid,COLOR_ORANGE,"txt_setadmin7");
			    }
			}
			if(IsPlayerFlag(giveid,PLAYER_FLAG_GOD)) {
	            if(PlayerInfo[giveid][AdminLevel] < g_Level[lgod]) {
		   			new
		   			    vid;
					if((vid=GetPlayerVehicleID(giveid))) {
					    SetVehicleHealth(vid,1000.0);
					}
					DeletePlayerFlag(playerid,PLAYER_FLAG_GOD);
					SetPlayerHealth(giveid,100.0);
				}
            }
		    if(IsPlayerFlag(giveid,PLAYER_FLAG_INVISIBLE)) {
				if(PlayerInfo[giveid][AdminLevel] < g_Level[linvisible]) {
					SetPlayerColor(giveid,PlayerInfo[giveid][Color]);
					DeletePlayerFlag(giveid,PLAYER_FLAG_INVISIBLE);
				}
		    }
			if(adminlvl < 2) {  // Remove adminlist entry if removed admin rights
			    INI_Open(AdminList);
			    INI_RemoveEntry(PlayerName(giveid));
			    INI_Save();
			    INI_Close();
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:armor(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[larmor]) {
		SetPlayerArmour(playerid,100.0);
		return SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_armor3");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:armour(playerid, params[]) {
	return cmd_armor(playerid,params);
}
COMMAND:pinfo(playerid, params[]) {
	return cmd_data(playerid,params);
}
COMMAND:giveweapon(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgiveweapon]) {
		new
			giveid,
			weaponid,
			amount;
		if (sscanf(params, "udd", giveid,weaponid,amount)) {
			new
			    bool:bFound = false,
			    sWeapon[32];
		    if(sscanf(params,"usd",giveid,sWeapon,amount)) {
	 			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /giveweapon [Player / ID] [Weapon / ID] [Ammo]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		    }
		    for(new i; i < sizeof(aWeaponNames) ; i++) {
			    if(!strfind(aWeaponNames[i],sWeapon,true)) {
					bFound = true;
					GivePlayerWeapon(giveid,i,amount);
					CreateClientLanguageMessages("txt_giveweapon1",PlayerName(playerid),PlayerName(giveid),aWeaponNames[i],amount);
					SendAdminCommand(COLOR_YELLOW);
					return WriteLog(clearlog,LanguageString(ServerLanguage()));
			    }
		    }
		    if(!bFound) {
	 			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /giveweapon [Player / ID] [Weapon / ID] [Ammo]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		    }
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
		    new
       			weap[24];
			GetWeaponName(weaponid,weap,sizeof(weap));
			GivePlayerWeapon(giveid,weaponid,amount);
			CreateClientLanguageMessages("txt_giveweapon1",PlayerName(playerid),PlayerName(giveid),weap,amount);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;

}

COMMAND:a(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[la]) {
		if (isnull(params)) {
 			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /a [text] (%c Can be used too for AdminChat)",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),PREFIX_ADMINCHAT);
		}
		AdminChat(playerid,params);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:sun(playerid,params[]) {
#pragma unused params, playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsun]) {
		SetWeather(1);
		ResetWeatherUpdate();
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_sunny"));
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:cloud(playerid,params[]) {
#pragma unused params, playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lcloud]) {
		SetWeather(9);
		ResetWeatherUpdate();
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_clouds"));
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:sandstorm(playerid,params[]) {
#pragma unused params, playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsandstorm]) {
	  	SetWeather(19);
	  	ResetWeatherUpdate();
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_stormy"));
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:fog(playerid,params[]) {
#pragma unused params, playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lfog]) {
	  	SetWeather(20);
	  	ResetWeatherUpdate();
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_foggy"));
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:rain(playerid,params[]) {
#pragma unused params, playerid
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lrain]) {
	  	SetWeather(16);
	  	ResetWeatherUpdate();
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_weatherstation",GetLanguageString(ServerLanguage(),"txt_rain"));
 	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if defined USE_MENUS
COMMAND:weather(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lweather]) {
		if(IsValidMenu(m_Weather)) {
			TogglePlayerControllable(playerid,false);
			return ShowMenuForPlayer(m_Weather,playerid);
		}
		else {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_invalidmenu1");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:disarm(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ldisarm]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /disarm [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				ResetPlayerWeapons(giveid);
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				return SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_disarm1");
			}
			else {
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_disarm2",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if !defined _samp03_
COMMAND:numberplate(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lnumberplate]) {
		new
			vid;
		if(!(vid=GetPlayerVehicleID(playerid))) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_numberplate1");
		}
		else {
			if (isnull(params)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /numberplate [Text]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			}
			else if(strlen(params) > 8) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_numberplate3");
			}
			else {
			    new
			        Float:fX,
			        Float:fY,
			        Float:fZ;
		 		GetPlayerPos(playerid,PlayerInfo[playerid][fSave][0],PlayerInfo[playerid][fSave][1],PlayerInfo[playerid][fSave][2]);
				GetPlayerFacingAngle(playerid,PlayerInfo[playerid][fSave][3]);
				PlayerInfo[playerid][fSave][4]=GetPlayerInterior(playerid);
				SetVehicleNumberPlate(vid,params);
				SetVehicleToRespawn(vid);
				GetVehiclePos(vid,fX,fY,fZ);
				SetPlayerPos(playerid,fX,fY,fZ+3.0);
				SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_numberplate2",params);
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_numberplate4");
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:allheal(playerid, params[] ) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lallheal]) {
	   	foreachEx(i) {
 			SetPlayerHealth(i,100.0);
		}
		CreateClientLanguageMessages("txt_allheal1",PlayerName(playerid));
		SendAdminCommand(COLOR_ORANGE);
		return WriteLog(clearlog,LanguageString(ServerLanguage()));
	 }
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:resetmoney(playerid, params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lresetmoney]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /resetmoney [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
   		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
 			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				CreateClientLanguageMessages("txt_resetmoney1",PlayerName(playerid),PlayerName(giveid),giveid,GetPlayerMoney(giveid));
   				ResetPlayerMoney(giveid);
				SendAdminCommand(COLOR_ORANGE);
				return WriteLog(clearlog,LanguageString(ServerLanguage()));
			}
			else {
				return SendClientLanguageMessage(giveid,COLOR_RED2,"txt_resetmoney2",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:clearchat(playerid,params[]) {
	return cmd_clear(playerid,params);
}
COMMAND:clear(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lclear]) {
	    #if defined _samp03_
		for(new i; i < 20; i++) { // /pagesize 20 might be used by some ppl in 0.3
	    #else
		for(new i; i < 10; i++) {
		#endif
  			SendClientMessageToAll(COLOR_RED,"\n");
		}
		return SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_clear");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:vr(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lvr]) {
	    new
	        v=GetPlayerVehicleID(playerid);
   		if (!v) {
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_novehicle");
		}
		else {
		    #if defined _samp03_
		    RepairVehicle(v);
		    #else
			SetVehicleHealth(v,1000.0);
			#endif
			CreateClientLanguageMessages("txt_vr1",PlayerName(playerid));
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			SendAdminCommand(COLOR_AQUA);
			PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:say(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsay]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /say [Message]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
   		}
		else {
		    new
		        sBig[128+8];
			format(sBig,sizeof(sBig),"Admin: %s",params);
			SendClientMessageToAll(COLOR_LIGHTBLUE,sBig);
			WriteLog(clearlog,sBig);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:flip(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lflip]) {
		new
		    vid=GetPlayerVehicleID(playerid);
   		if (!vid) {
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_novehicle");
		}
		else {
		    new
				Float:rot;
			GetVehicleZAngle(vid,rot);
			SetVehicleZAngle(vid,rot);
			CreateClientLanguageMessages("txt_flip1",PlayerName(playerid));
			SendAdminCommand(COLOR_YELLOW);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:whitelist(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lwhitelist]) {
		if(isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /whitelist [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
	 	}
		else if(!strcmp(params,on,true)) {
			if(g_bWhiteStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_whitelist1");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_whitelist2");
  				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				LoadWhitelistEntrys();
				g_bWhiteStatus=true;
			}
		}
		else if(!strcmp(params,off,true)) {
			if(!g_bWhiteStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_whitelist3");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_whitelist4");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				g_bWhiteStatus=false;
			}
		}
		else {
		    return 0;
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:blacklist(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lblacklist]) {
		if(isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /blacklist [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
	 	}
		else if(!strcmp(params,on,true)) {
			if(g_bBlackListStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_blacklist1");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_blacklist2");
  				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				g_bBlackListStatus=true;
				LoadBlacklistEntrys();

			}
		}
		else if(!strcmp(params,off,true)) {
			if(!g_bBlackListStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_blacklist3");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_blacklist4");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				g_bBlackListStatus=false;
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:clanblacklist(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lclanblacklist]) {
		if(isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /clanblacklist [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
	 	}
		else if(!strcmp(params,on,true)) {
			if(g_bClangBlackListStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_cblacklist1");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_cblacklist2");
  				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				g_bClangBlackListStatus=true;
			}
		}
		else if(!strcmp(params,off,true)) {
			if(!g_bClangBlackListStatus) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_cblacklist3");
			}
			else {
				SendClientLanguageMessageToAll(COLOR_ORANGE,"txt_cblacklist4");
				PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				g_bClangBlackListStatus=false;
				LoadClanBlacklistEntrys();
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if defined USE_MENUS
COMMAND:v(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lv]) {
		if(IsValidMenu(m_V)) {
			TogglePlayerControllable(playerid,false);
			ShowMenuForPlayer(m_V,playerid);
		}
		else {
 			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_invalidmenu1");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:skin(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lskin]) {
		new
			id;
		if (sscanf(params, "d", id)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /skin [Skin ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsValidSkin(id)) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_skin3");
		}
  		else {
			SetPlayerSkin(playerid,id);
			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_skin4",id);
	   	}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:explode(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lexplode]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /explode [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
  		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
			    new
			        Float:fX,
			        Float:fY,
			        Float:fZ;
				GetPlayerPos(giveid,fX,fY,fZ);
				CreateExplosion(fX,fY,fZ,6,3);
				CreateClientLanguageMessages("txt_bomb2",PlayerName(playerid),PlayerName(giveid),giveid);
				SendAdminCommand(COLOR_LIGHTGREEN);
			}
			else {
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_bomb1",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:setscore(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsetscore]) {
		new
			giveid,
			score;
		if (sscanf(params, "ud", giveid,score)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setscore [Player / ID] [Score]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			SetPlayerScore(giveid,score);
			CreateClientLanguageMessages("txt_score2",PlayerName(playerid),PlayerName(giveid),giveid,score);
			SendAdminCommand(COLOR_ORANGE);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:carcolor(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lcarcolor]) {
		new
		    vid;
		if(!(vid=GetPlayerVehicleID(playerid))) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_carcolor1");
		}
		if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_tuner1");
	 	}
	 	else {
			new
				c1,
				c2;
			if (sscanf(params, "dd", c1,c2)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /carcolor [Color 1] [Color 2]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			}
			else {
				if(c1 < 0 || c1 > 126 || c2 < 0 || c2 >126) {
					SendClientLanguageMessage(playerid,COLOR_RED,"txt_carcolor2");
				}
				else {
					ChangeVehicleColor(vid,c1,c2);
					SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_carcolor3",c1,c2);
				}
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:noon(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lnoon]) {
		g_Time=19;
		g_TimeUpdate_Count=0;
		SetWorldTime(g_Time);
		return SendClientLanguageMessageToAll(COLOR_ORANGERED,"txt_time1");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:night(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lnight]) {
		g_Time=0;
		g_TimeUpdate_Count=0;
		SetWorldTime(g_Time);
		SendClientLanguageMessageToAll(COLOR_ORANGERED,"txt_time2");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:day(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lday]) {
		g_Time=13;
		g_TimeUpdate_Count=0;
		SetWorldTime(g_Time);
		return SendClientLanguageMessageToAll(COLOR_ORANGERED,"txt_time3");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:morning(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lmorning]) {
		g_Time=7;
		g_TimeUpdate_Count=0;
		SetWorldTime(g_Time);
		return SendClientLanguageMessageToAll(COLOR_ORANGERED,"txt_time4");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if defined USE_MENUS
COMMAND:ammu(playerid, params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lammu]) {
		if(IsValidMenu(m_AmmuNation)) {
			TogglePlayerControllable(playerid,false);
			ShowMenuForPlayer(m_AmmuNation,playerid);
   		}
		else {
	 		SendClientLanguageMessage(playerid,COLOR_RED2,"txt_invalidmenu1");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
#if defined SPECTATE_MODE
COMMAND:specoff(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lspec]) {
		if(PlayerInfo[playerid][Spec]!=-1 ) {
			ResetSpectateInfo(playerid);
			TogglePlayerSpectating(playerid,0);
			PlayerInfo[playerid][Spec]=FREE_SPEC_ID;
			SetPlayerInterior(playerid,0);
			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_spec2");
		}
		else {
		    // Cant spec off
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
}
COMMAND:spec(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lspec]) {
		if(params[0] && !strcmp(params,off,true) && PlayerInfo[playerid][Spec]!=-1 ) {
			ResetSpectateInfo(playerid);
			TogglePlayerSpectating(playerid,0);
			PlayerInfo[playerid][Spec] = FREE_SPEC_ID;
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid,floatround(PlayerInfo[playerid][fSave][5]));
			SendClientLanguageMessage(playerid,COLOR_GREEN,"txt_spec2");
		}
		else {
			new
				giveid;
			if (isnull(params) || sscanf(params, "u", giveid)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /spec [Player / ID / %s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),off);
			}
			else if(!IsPlayerConnected(giveid)) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
			}
			else if(giveid==playerid) {
				return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
			}
			else if(!IsPlayerSpawned(giveid)) {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_NotSpawned");
			}
			else {
				new
					vid;
 				ResetSpectateInfo(playerid);
				PlayerInfo[playerid][Spec]=giveid;
				AddPlayerFlag(giveid,PLAYER_FLAG_SPECTATED);
				TogglePlayerSpectating(playerid, 1);
				if((vid=GetPlayerVehicleID(giveid))) {
					PlayerSpectateVehicle(playerid,vid, 1);
				}
 				else {
					PlayerSpectatePlayer(playerid, giveid);
				}
	  			SetPlayerInterior(playerid,GetPlayerInterior(giveid));
	  			PlayerInfo[playerid][fSave][5] = GetPlayerVirtualWorld(playerid);
	  			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(giveid));
				SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_spec1",PlayerName(giveid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:fuckup(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lfuckup]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /fuckup [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
  		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				new
				    vid;
				if((vid=GetPlayerVehicleID(giveid))) {
					SetVehicleHealth(vid,200.0);
				}
 				else {
					SetPlayerHealth(giveid,1.0);
		   		}
				CreateClientLanguageMessages("txt_fuckup3",PlayerName(giveid),giveid,PlayerName(playerid));
				SendAdminCommand(COLOR_ORANGE);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_fuckup1");
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_fuckup2",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:force(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lforce]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /force [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
/*
 		else if(!IsPlayerSpawned(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_NotSpawned");
		}
*/
  		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
				RemovePlayerFromVehicle(giveid);
				CreateClientLanguageMessages("txt_force2",PlayerName(giveid),giveid,PlayerName(playerid));
				SendAdminCommand(COLOR_ORANGE);
				SpawnPlayer(giveid);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_force3");
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_force1",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:ejet(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lejet]) {
		new
			giveid,
	        vid=GetPlayerVehicleID(playerid);
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /ejet [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		if(!vid && GetPlayerState(playerid)!=PLAYER_STATE_DRIVER){
			return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_tuner1");
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
   		else {
			if(PlayerInfo[playerid][AdminLevel]>=PlayerInfo[giveid][AdminLevel]){
 				if(GetPlayerVehicleID(giveid)==vid) {
 					CreateClientLanguageMessages("txt_ejet1",PlayerName(giveid),PlayerName(playerid));
 					SendAdminCommand(COLOR_ORANGE);
 					RemovePlayerFromVehicle(giveid);
				 }
				 else {
					SendClientLanguageMessage(playerid,COLOR_RED2,"txt_ejet3");
				 }
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_RED,"txt_ejet2");
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_ejet4",PlayerName(playerid));
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:savepos(playerid,params[]) {
	return cmd_gsave(playerid,params);
}
COMMAND:gsave(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsavepos]) {
		GetPlayerPos(playerid,PlayerInfo[playerid][fSave][0],PlayerInfo[playerid][fSave][1],PlayerInfo[playerid][fSave][2]);
		GetPlayerFacingAngle(playerid,PlayerInfo[playerid][fSave][3]);
		PlayerInfo[playerid][fSave][4]=GetPlayerInterior(playerid);
		return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_save",PlayerInfo[playerid][fSave][0],PlayerInfo[playerid][fSave][1],PlayerInfo[playerid][fSave][2]);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:back(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lback]) {
		if(PlayerInfo[playerid][fSave][0]!=0.0 && PlayerInfo[playerid][fSave][1]!=0.0) {
			TeleportPlayer(playerid,PlayerInfo[playerid][fSave][0],PlayerInfo[playerid][fSave][1],PlayerInfo[playerid][fSave][2],PlayerInfo[playerid][fSave][3],floatround(PlayerInfo[playerid][fSave][4],floatround_round));
		}
		else {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_back");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if defined USE_MENUS
COMMAND:gmenu(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgmenu]) {
		CreateMenus();
		return SendClientMessage(playerid,COLOR_YELLOW,"* Menus recreated");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:setvip(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsetvip]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setvip [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(playerid==giveid) {
			return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_vip4");
		}
		else {
			if(IsPlayerFlag(giveid,PLAYER_FLAG_VIP)) {
				return SendClientLanguageMessage(playerid,COLOR_GREY,"txt_vip1");
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_vip3",PlayerName(giveid));
				SendClientLanguageMessage(giveid,COLOR_ORANGE,"txt_vip2",PREFIX_VIPCHAT);
				AddPlayerFlag(giveid,PLAYER_FLAG_VIP);
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:delvip(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ldelvip]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /delvip [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
   			if(IsPlayerFlag(giveid,PLAYER_FLAG_VIP)) {
				SendClientLanguageMessage(playerid,COLOR_GREY,"txt_delvip1",PlayerName(giveid));
				SendClientLanguageMessage(giveid,COLOR_RED2,"txt_delvip3");
				DeletePlayerFlag(giveid,PLAYER_FLAG_VIP);
			}
			else {
				SendClientLanguageMessage(playerid,COLOR_ORANGE,"txt_delvip2");
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

#if defined USE_MENUS
COMMAND:teleport(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lteleport]) {
		if(IsValidMenu(m_Teleport)) {
			ShowMenuForPlayer(m_Teleport,playerid);
			TogglePlayerControllable(playerid,false);
		}
		else {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_invalidmenu1");
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
COMMAND:giveskin(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgiveskin]) {
 		new
			giveid,
			skinid;
		if (sscanf(params, "ud", giveid,skinid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /giveskin [Player / ID] [Skin ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else if(!IsValidSkin(skinid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_skin3");
		}
		else {
			SetPlayerSkin(giveid,skinid);
			CreateClientLanguageMessages("txt_skin1",PlayerName(playerid),PlayerName(giveid),skinid);
			SendAdminCommand(COLOR_ORANGE);
			SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_skin2",PlayerName(playerid),skinid);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}

COMMAND:givearmor(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgivearmor]) {
		new
			giveid;
		if (sscanf(params, "u", giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /givearmor [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
		}
		else {
			SetPlayerArmour(giveid,100.0);
			CreateClientLanguageMessages("txt_armor1",PlayerName(playerid),PlayerName(giveid));
			SendAdminCommand(COLOR_ORANGE);
			SendClientLanguageMessage(giveid,COLOR_YELLOW,"txt_armor2",PlayerName(playerid));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:givearmour(playerid,params[]) {
	return cmd_givearmor(playerid,params);
}
COMMAND:jetpack(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[ljetpack]) {
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:god(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgod]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /god [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
		}
		else if(strlen(params) > 16) {
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
	   	else if(!strcmp(params,off,true)) {
			if(IsPlayerFlag(playerid,PLAYER_FLAG_GOD)) {
	   			new
	   			    vid;
				if((vid=GetPlayerVehicleID(playerid))) {
				    SetVehicleHealth(vid,0x7F800000);
				}
				DeletePlayerFlag(playerid,PLAYER_FLAG_GOD);
	   			PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				SetPlayerHealth(playerid,0x7F800000);
				return SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_god1");
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_god2");
			}
		}
		else if(!strcmp(params,on,true)) {
			if(IsPlayerFlag(playerid,PLAYER_FLAG_GOD)) {
				return SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_god3");
			}
			else {
				/* Just for the case he has to wait 3,4...10 secs until next update takes too long */
				new
				    vid;
				SetPlayerHealth(playerid,g_fGodValue);
				if((vid=GetPlayerVehicleID(playerid))) {
					SetVehicleHealth(vid,g_fGodValue*10.0);
	   			}

				AddPlayerFlag(playerid,PLAYER_FLAG_GOD);
	   			PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
				return SendClientLanguageMessage(playerid,COLOR_YELLOW,"txt_god4");
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:alldisarm(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lalldisarm]) {
		foreach(i) {
			if(PlayerInfo[i][AdminLevel]<=2) {
				ResetPlayerWeapons(i);
				SendClientLanguageMessage(i,COLOR_YELLOW,"txt_disarm1");
			}
		}
		return SendClientLanguageMessageToAll(COLOR_YELLOW,"txt_disarm3");
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:lockchat(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[llockchat]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /lockchat [%s/%s]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"),on,off);
		}
		else if(strlen(params) > 16) {
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
	   	else if(!strcmp(params,off,true)) {
			if(g_bLockChat) {
   				g_bLockChat=false;
				SendClientLanguageMessageToAll(COLOR_YELLOW,"txt_lockchat1");
				PlaySoundForAll(1058);
			}
			else {
				return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_lockchat2");
			}
		}
		else if(!strcmp(params,on,true)) {
			if(g_bLockChat) {
				return SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_lockchat3");
			}
			else {
				g_bLockChat=true;
				SendClientLanguageMessageToAll(COLOR_YELLOW,"txt_lockchat4");
				PlaySoundForAll(1058);
			}
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:settings(playerid,params[]) {
	#pragma unused params
	if(PlayerInfo[playerid][AdminLevel]>=2) {
		new
			File:Output=fopen(Settings_Log,io_write);
		if(Output) {
			// No check wether file was success. opened!
			SendClientMessage(playerid,COLOR_RED2,"____________________________");
			SendClientMessage(playerid,COLOR_WHITE,"\n");
			format(s,sizeof(s),"- gAdmin Settings , %s -\r\n",gVersion);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			format(s,sizeof(s),"Whitelist: %s Blackist: %s Clanblacklist: %s\r\n",g_bWhiteStatus ? on : off,g_bBlackListStatus ? on : off,g_bClangBlackListStatus ? on : off);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			format(s,sizeof(s),"Time Update: %s Weather Update: %s Score Update: %s\r\n",g_bDynamicTime ? on : off,g_bDynamicWeather ? on : off,g_bDynamicScore ? on : off);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			format(s,sizeof(s),"PingKick: %s (MAX Ping:%d,Warnings:%d) RegisterToSpawn: %s Show Admincommands: %s Show Enter/Leave Message: %s\r\n",g_bPingKickStatus ? on : off,g_MAX_PING,g_MAX_PING_WARNINGS,g_bRegisterSpawn ? on : off,g_bShow_AdminCommand ? on : off,g_bShow_EnterLeave ? on : off);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			format(s,sizeof(s),"IP Compare: %s LameKills: %s LockChat: %s\r\n",g_bIPComp ? on : off,(g_MAX_HELI_LAME_KILLS>0) ? on : off,g_bLockChat ? on : off);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			//More Infos,we just print that to file coz it's to much to print in chat
			fwrite(Output,"- - - - - -\r\n");
			format(s,sizeof(s),"Global Timer: %s (ID:%d)\r\n",g_bTimers ? on : off,g_tTrigger);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			format(s,sizeof(s),"TimeUpdate: %d/%d WeatherUpdate: %d/%d\r\n",g_TimeUpdate_Count,g_TimeUpdate,g_WeatherUpdate_Count,g_WeatherUpdate);
			fwrite(Output,s);
			format(s,sizeof(s),"ScoreUpdate: %d/%d GodUpdate: %d/%d\r\n",g_ScoreUpdate_Count,g_ScoreUpdate,g_GodUpdate_Count,g_GodUpdate);
			fwrite(Output,s);
			#if defined DISPLAY_MODE
			format(s,sizeof(s),"SpeedOMeterUpdate: %d/%d AreaNameUpdate: %d/%d SpeedNameUpdate: %d/%d (DisplayMode: %d)\r\n",g_SpeedOMeterUpdate_Count,g_SpeedOMeterUpdate,g_AreaNameUpdate_Count,g_AreaNameUpdate,g_SpeedNameUpdate_Count,g_SpeedNameUpdate,g_Display);
			fwrite(Output,s);
			#else
			fwrite(Output," - No g_Display Mode -\r\n");
			#endif
			#if defined LOCK_MODE
			format(s,sizeof(s),"CheckLockUpdate: %d/%d\r\n",g_CheckLockUpdate_Count,g_CheckLockUpdate);
			fwrite(Output,s);
			#else
			fwrite(Output,"- No LockMode - \r\n");
			#endif
			#if defined irc_gAdmin
			format(s,sizeof(s),"EchoChan: %s Botname: %s Botpassword: %s EchoServer: %s EchoChannelPort: %d ConnectionID: %d\r\n",EchoChan,Botname,Botpw,EchoServer,EchoPort,EchoBot);
			SendClientMessage(playerid,COLOR_WHITE,s);
			fwrite(Output,s);
			#else
			fwrite(Output,"Spectate Mode: on\r\n");
			#endif
			#if defined SPECTATE_MODE
			#else
			fwrite(Output," - No Spectate Mode -\r\n");
			#endif
			#if defined _gLanguage_included
			for(new Language:i;_:i<Language_Count;_:i++) {
				format(s,sizeof(s),"Language ID: %d Language: %s.%s [ %s ]\r\n",_:i,GetLanguageName(i),GetLanguageExtension(i),GetShortLanguageName(i));
				fwrite(Output,s);
			}
			#else
			fwrite(Output," - No MultiLanguage Mode -\r\n");
			#endif
			fwrite(Output,"- - - - - -\r\n");
			for(new i;i<sizeof(g_sCommandText);i++) {
				format(s,sizeof(s),"ID:%d LVL:%d COMMAND:%s\r\n",i,g_Level[e_Level_Info:i],g_sCommandText[i]);
				fwrite(Output,s);
			}
			fclose(Output);
		}
		else {
		    printf("Some error occured!");
		}
		return 1;
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;

}
COMMAND:hostname(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lhostname]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /hostname [name]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(strlen(params) > 50) { // Hostname can't be longer than 50chars (0.2X)
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		format(s,sizeof(s),"hostname %s",params);
		SendRconCommand(s);
		CreateClientLanguageMessages("txt_hostname",params);
		SendAdminCommand(COLOR_YELLOW);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:mapname(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lmapname]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /mapname [name]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(strlen(params) > 30) { // Mapname can't be longer than 30chars (0.2X)
			return SendClientLanguageMessage(playerid,COLOR_SYSTEM,"txt_longinput");
		}
		format(s,sizeof(s),"mapname %s",params);
		SendRconCommand(s);
		CreateClientLanguageMessages("txt_mapname",params);
		SendAdminCommand(COLOR_YELLOW);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:servername(playerid,params[]) {
	return cmd_hostname(playerid,params);
}
COMMAND:getalias(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgetalias]) {
		new
			giveid;
		if (sscanf(params,"u",giveid)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /getalias [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
	   	else {
	   	    new
				ThePlayer[MAX_PLAYER_NAME],
	   	        IP[16];
			GetPlayerName(giveid,ThePlayer,sizeof(ThePlayer));
			GetPlayerIp(giveid,IP,sizeof(IP));
			format(s,sizeof(s),GetAliasEntry( IP, ThePlayer ));
			SendClientMessage(playerid,COLOR_YELLOW,s);
	   	}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:port(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lport]) {
		new
		    port2id,
			portid;
		if (sscanf(params,"uu",portid,port2id)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /port [Player / ID] to [Player / ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(!IsPlayerConnected(portid) || !IsPlayerConnected(port2id)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
		else if(!IsPlayerSpawned(portid) || !IsPlayerSpawned(port2id)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_NotSpawned");
		}
		else if(portid==playerid && port2id==playerid) {
			return SendClientLanguageMessage(playerid,COLOR_RED,"txt_selfslct");
		}
	   	else {
			new
				Float:fgX,
				Float:fgY,
				Float:fgZ,
				Float:fFace;
			GetPlayerFacingAngle(port2id,fFace);
	   		GetPlayerPos(port2id,fgX,fgY,fgZ);
	   		GetXYInFrontOfPlayer(port2id, fgX, fgY, -1);
			TeleportPlayer(portid,fgX,fgY,fgZ,fFace,GetPlayerInterior(port2id),GetPlayerVirtualWorld(port2id));
	   		CreateClientLanguageMessages("txt_port1",PlayerName(playerid),PlayerName(portid),portid,PlayerName(port2id),port2id);
			SendAdminCommand(COLOR_YELLOW);
			return WriteLog(clearlog,LanguageString(ServerLanguage()));
	   	}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:visible(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[linvisible]) {
	    if(!IsPlayerFlag(playerid,PLAYER_FLAG_INVISIBLE)) {
	        SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_invisible4");
	    }
		else {
			SetPlayerColor(playerid,PlayerInfo[playerid][Color]);
			DeletePlayerFlag(playerid,PLAYER_FLAG_INVISIBLE);
			CreateClientLanguageMessages("txt_invisible5",PlayerName(playerid));
			WriteLog(clearlog,LanguageString(ServerLanguage()));
			SendAdminCommand(COLOR_YELLOW);
			PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:invisible(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[linvisible]) {
	    #if defined COLOR_FIX
	    start:
	    #endif
	    new
	        color=GetPlayerColor(playerid);
		if(!color) { // Because GetPlayerColor return 0 IF SetPlayerColor() has not been used before we need to tell the user
			#if defined COLOR_FIX
			static playerColors[200] =
			{
				0xFF8C13FF,0xC715FFFF,0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,
				0x778899FF,0xFF1493FF,0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,
				0x4949A0FF,0x148b8bFF,0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,
				0x534081FF,0x0495CDFF,0xFF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,
				0x635B03FF,0xCB7ED3FF,0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,
				0x7B39AAFF,0x53EB10FF,0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,
				0x22F767FF,0xD63034FF,0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,
				0xE9AB2FFF,0xAF2FF3FF,0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,
				0xA55043FF,0x0DE018FF,0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,
				0x4B8987FF,0x491B9EFF,0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,
				0x2D74FDFF,0x3C1C0DFF,0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,
				0xFC42A8FF,0x2FC827FF,0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,
				0xFAFB71FF,0x05D1CDFF,0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,
				0xBD1FF2FF,0x93B7E4FF,0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,
				0x4C436EFF,0xFA24CCFF,0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,
				0x10C9C5FF,0x70524DFF,0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,
				0xE59338FF,0xEEDC2DFF,0xD8C762FF,0x3FE65CFF,0xFF8C13FF,0xC715FFFF,
				0x20B2AAFF,0xDC143CFF,0x6495EDFF,0xf0e68cFF,0x778899FF,0xFF1493FF,
				0xF4A460FF,0xEE82EEFF,0xFFD720FF,0x8b4513FF,0x4949A0FF,0x148b8bFF,
				0x14ff7fFF,0x556b2fFF,0x0FD9FAFF,0x10DC29FF,0x534081FF,0x0495CDFF,
				0xFF6CE8FF,0xBD34DAFF,0x247C1BFF,0x0C8E5DFF,0x635B03FF,0xCB7ED3FF,
				0x65ADEBFF,0x5C1ACCFF,0xF2F853FF,0x11F891FF,0x7B39AAFF,0x53EB10FF,
				0x54137DFF,0x275222FF,0xF09F5BFF,0x3D0A4FFF,0x22F767FF,0xD63034FF,
				0x9A6980FF,0xDFB935FF,0x3793FAFF,0x90239DFF,0xE9AB2FFF,0xAF2FF3FF,
				0x057F94FF,0xB98519FF,0x388EEAFF,0x028151FF,0xA55043FF,0x0DE018FF,
				0x93AB1CFF,0x95BAF0FF,0x369976FF,0x18F71FFF,0x4B8987FF,0x491B9EFF,
				0x829DC7FF,0xBCE635FF,0xCEA6DFFF,0x20D4ADFF,0x2D74FDFF,0x3C1C0DFF,
				0x12D6D4FF,0x48C000FF,0x2A51E2FF,0xE3AC12FF,0xFC42A8FF,0x2FC827FF,
				0x1A30BFFF,0xB740C2FF,0x42ACF5FF,0x2FD9DEFF,0xFAFB71FF,0x05D1CDFF,
				0xC471BDFF,0x94436EFF,0xC1F7ECFF,0xCE79EEFF,0xBD1FF2FF,0x93B7E4FF,
				0x3214AAFF,0x184D3BFF,0xAE4B99FF,0x7E49D7FF,0x4C436EFF,0xFA24CCFF,
				0xCE76BEFF,0xA04E0AFF,0x9F945CFF,0xDCDE3DFF,0x10C9C5FF,0x70524DFF,
				0x0BE472FF,0x8A2CD7FF,0x6152C2FF,0xCF72A9FF,0xE59338FF,0xEEDC2DFF,
				0xD8C762FF,0x3FE65CFF
			};
			SetPlayerColor(playerid,playerColors[playerid]);
			printf("gAdmin Colorfix!");
			goto start;
			#else
			SendClientLanguageMessage(playerid,COLOR_RED,"txt_invisible1");
			#endif
		}
		else {
		    if(IsPlayerFlag(playerid,PLAYER_FLAG_INVISIBLE)) {
		        SendClientLanguageMessage(playerid,COLOR_ORANGERED,"txt_invisible2");
		    }
		    else {
		        new
		            r,
		            g,
					b,
					a;
				PlayerInfo[playerid][Color]=color;
				HexToRGBA(color,r,g,b,a);
				SetPlayerColor(playerid,RGBAToHex(r,g,b,0));
				AddPlayerFlag(playerid,PLAYER_FLAG_INVISIBLE);
				CreateClientLanguageMessages("txt_invisible3",PlayerName(playerid));
				WriteLog(clearlog,LanguageString(ServerLanguage()));
				SendAdminCommand(COLOR_YELLOW);
                PlayerPlaySound(playerid,1058,0.0,0.0,0.0);
		    }
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:gmx(playerid,params[]) {
#pragma unused params
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgmx]) {
	    CreateClientLanguageMessages("txt_gmx",PlayerName(playerid));
		SendClientPreLanguageMessages(COLOR_RED2);
		WriteLog(clearlog,LanguageString(ServerLanguage()));
		g_tGMX=SetTimer("CallGameModeExit",10*1000,0);
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:unban(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lunban]) {
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /unban [Name / IP]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		new
		    bool:bUserName=false,
		    sIP[16];
	    #if defined MYSQL
		if (gSQL_ExistUser(params)) {
		    format(sIP,sizeof(sIP),gSQL_GetUserVar(params,"IP"));
			bUserName=true;
		#else
		if (udb_Exists(params)) {
		    format(sIP,sizeof(sIP),dUser(params).("IP"));
			bUserName=true;
		#endif
		}
		if(!bUserName) {
			if(!IsIP(params)) {
				SendClientLanguageMessage(playerid,COLOR_RED2,"txt_unban2",params);
				return 1;
			}
			format(s,sizeof(s),"unbanip %s",params);
			CreateClientLanguageMessages("txt_unban",params);
		}
		else {
			new
				sMisc[16+MAX_PLAYER_NAME+4];
			format(sMisc,sizeof(sMisc),"%s (%s)",sIP,params);
			format(s,sizeof(s),"unbanip %s",sIP);
			CreateClientLanguageMessages("txt_unban",sMisc);
		}
		SendRconCommand(s);
		SendAdminCommand(COLOR_YELLOW);
		return 1;
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;

}
COMMAND:gotopos(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgotopos]) {
	    new
			Float:gotoX,
			Float:gotoY,
			Float:gotoZ;
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /gotopos [Float:X] [Float:Y] [Float:Z]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(sscanf(params,"fff",gotoX,gotoY,gotoZ)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /gotopos [Float:X] [Float:Y] [Float:Z]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
		    SetPlayerPos(playerid,gotoX,gotoY,gotoZ);
		    CreateClientLanguageMessages("txt_gotopos1",PlayerName(playerid),gotoX,gotoY,gotoZ);
		    SendAdminCommand(COLOR_ORANGE);
			WriteLog(clearlog,LanguageString(ServerLanguage()));

		}
		return 1;
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;

}
COMMAND:getall(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lgetall]) {
	    new
			iAdmins=1,
	        Float:offset_X=4.0,
	        Float:offset_Y=4.0,
	        Float:offset_Z=1.5,
	        sConfig[128];
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /getall ([admins 0/1] [Offset X] [Offset Y] [Offset Z])",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(sscanf(params,"z",sConfig)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /getall ([admins 0/1] [Offset X] [Offset Y] [Offset Z])",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
		    new
		        interior = GetPlayerInterior(playerid),
		        virtualworld = GetPlayerVirtualWorld(playerid),
		        Float:a_X,
		        Float:a_Y,
		        Float:a_Z;
			GetPlayerPos(playerid,a_X,a_Y,a_Z);
		    sscanf(sConfig,"dfff",iAdmins,offset_X,offset_Y,offset_Z);
	        if(iAdmins) {
			    foreach(i) {
			        TeleportPlayer(i,a_X + offset_X,a_Y + offset_Y,a_Z + offset_Z,interior,virtualworld);
				}
			}
			else {
			    foreach(i) {
			        if(PlayerInfo[i][AdminLevel] < 2) {
				        TeleportPlayer(i,a_X + offset_X,a_Y + offset_Y,a_Z + offset_Z,interior,virtualworld);
			        }
			    }
			}
		}
	    CreateClientLanguageMessages("txt_getall1",PlayerName(playerid),iAdmins ? ("1") : ("0"));
	    SendAdminCommand(COLOR_ORANGE);
		WriteLog(clearlog,LanguageString(ServerLanguage()));
		return 1;
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;

}
COMMAND:myinterior(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lmyinterior]) {
	    new
	        iInterior;
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /myinterior [interior ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(sscanf(params,"d",iInterior)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /myinterior [interior ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
		    new
				vid;
			if( (vid = GetPlayerVehicleID(playerid)) ) {
			    LinkVehicleToInterior(vid,iInterior);
			}
			SetPlayerInterior(playerid,iInterior);
		    CreateClientLanguageMessages("txt_myinterior1",PlayerName(playerid),iInterior);
		    SendAdminCommand(COLOR_ORANGE);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
COMMAND:myvirtualworld(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lmyvirtualw]) {
	    new
	        iVW;
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /myvirtualworld [Virtualworld ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(sscanf(params,"d",iVW)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /myvirtualworld [Virtualworld ID]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else {
		    new
				vid;
			if( (vid = GetPlayerVehicleID(playerid)) ) {
			    SetVehicleVirtualWorld(vid,iVW);
			}
			SetPlayerVirtualWorld(playerid,iVW);
		    CreateClientLanguageMessages("txt_myvirtualworld1",PlayerName(playerid),iVW);
		    SendAdminCommand(COLOR_ORANGE);
			WriteLog(clearlog,LanguageString(ServerLanguage()));
		}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#if defined _samp03_
enum e_FightStyles {
	FS_sName[16],
	FS_iStyleID
}
new	sFightStyles[][e_FightStyles] = {
	{"Normal",FIGHT_STYLE_NORMAL},
	{"Boxing",FIGHT_STYLE_BOXING},
	{"KungFu",FIGHT_STYLE_KUNGFU},
	{"Kneehead",FIGHT_STYLE_KNEEHEAD},
	{"Grabkick",FIGHT_STYLE_GRABKICK},
	{"Ellbow",FIGHT_STYLE_ELBOW}
};

COMMAND:setfightstyle(playerid,params[]) {
	if(PlayerInfo[playerid][AdminLevel] >= g_Level[lsetfightstyle]) {
	    new
			bool:bFound,
			giveid,
	        iFightStyle,
	        sFightStyle[32];
		if (isnull(params)) {
			return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setfightstyle [Player / ID] [Style]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
		}
		else if(sscanf(params,"ud",giveid,iFightStyle)) { // No Integer
			if(sscanf(params,"us",giveid,sFightStyle)) {
				return SendClientFormatMessage(playerid,COLOR_SYSTEM,"%s: /setfightstyle [Player / ID] [Style]",GetLanguageString(GetPlayerLanguageID(playerid),"txt_icommands"));
			}
			for(new i ; i < sizeof(sFightStyles) ; i++) {
			    if(!strfind(sFightStyle,sFightStyles[i][FS_sName],true)) {
			        bFound = true;
			        SetPlayerFightingStyle(giveid,sFightStyles[i][FS_iStyleID]);
				    CreateClientLanguageMessages("txt_fightstyle1",PlayerName(playerid),PlayerName(giveid),giveid,sFightStyles[i][FS_sName]);
				    SendAdminCommand(COLOR_ORANGE);
					WriteLog(clearlog,LanguageString(ServerLanguage()));
					return 1;
			    }
			}
			if(!bFound) {
			    SendClientLanguageMessage(playerid,COLOR_RED2,"txt_fightstyle2",sFightStyle);
			}
		}
		else if(!IsPlayerConnected(giveid)) {
			return SendClientLanguageMessage(playerid,COLOR_RED2,"txt_InvalidID");
	   	}
	   	for(new i ; i < sizeof(sFightStyles) ; i++) {
	   	    if(iFightStyle == sFightStyles[i][FS_iStyleID]) {
		        SetPlayerFightingStyle(giveid,iFightStyle);
			    CreateClientLanguageMessages("txt_fightstyle1",PlayerName(playerid),PlayerName(giveid),giveid,sFightStyles[i][FS_sName]);
			    SendAdminCommand(COLOR_ORANGE);
				WriteLog(clearlog,LanguageString(ServerLanguage()));
				bFound = true;
				return 1;
	   	    }
	   	}
	   	if(!bFound) {
			SendClientLanguageMessage(playerid,COLOR_RED2,"txt_fightstyle3",iFightStyle);
	   	}
	}
	else {
		SendClientLanguageMessage(playerid,COLOR_LIGHTBLUE,"txt_error404");
	}
	return 1;
}
#endif
//**********
stock AdminCommandString() {
	if(!g_bACMDS) {
		new
			bool:bFoundCount[4][2];
		for(new i;i<sizeof(g_sCommandText);i++) {
			/* Debug Note
			printf("%d %d %s",i,g_Level[e_Level_Info:i],g_sCommandText[i]);
		    */
			switch(g_Level[e_Level_Info:i]) {
				case 2..5: { // We just need Commands from level 2-5
					if(strlen(g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][0]) < 108) {
						if(!bFoundCount[g_Level[e_Level_Info:i]-2][0]) {
							format(g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][0],sizeof(g_sAdminCommandInfo[][]),"Level %d:",g_Level[e_Level_Info:i]);
						}
						bFoundCount[g_Level[e_Level_Info:i]-2][0]=true;
						format(g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][0],sizeof(g_sAdminCommandInfo[][]),"%s %s",g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][0],g_sCommandText[i]);
					}
					else {
						if(!bFoundCount[g_Level[e_Level_Info:i]-2][1]) {
							format(g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][1],sizeof(g_sAdminCommandInfo[][]),"Level %d:",g_Level[e_Level_Info:i]);
						}
						bFoundCount[g_Level[e_Level_Info:i]-2][1]=true;
						format(g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][1],sizeof(g_sAdminCommandInfo[][]),"%s %s",g_sAdminCommandInfo[g_Level[e_Level_Info:i]-2][1],g_sCommandText[i]);
					}
				}
			}
		}
		g_bACMDS=true;
	}
	return 1;
}
stock AdminCommands(playerid) {
	if(PlayerInfo[playerid][AdminLevel]>=5) {
		if(g_sAdminCommandInfo[3][0][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[3][0]);
		if(g_sAdminCommandInfo[3][1][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[3][1]);
	}
	if(PlayerInfo[playerid][AdminLevel]>=4) {
		if(g_sAdminCommandInfo[2][0][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[2][0]);
		if(g_sAdminCommandInfo[2][1][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[2][1]);
	}
	if(PlayerInfo[playerid][AdminLevel]>=3) {
		if(g_sAdminCommandInfo[1][0][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[1][0]);
		if(g_sAdminCommandInfo[1][1][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[1][1]);
	}
	if(PlayerInfo[playerid][AdminLevel]>=2) {
		if(g_sAdminCommandInfo[0][0][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[0][0]);
		if(g_sAdminCommandInfo[0][1][0]) SendClientMessage(playerid,COLOR_ORANGE,g_sAdminCommandInfo[0][1]);
	}
	if(PlayerInfo[playerid][AdminLevel]>=0) {
		SendClientFormatMessage(playerid,COLOR_ORANGE,"Level 1 : /%s [Normal Player]",#CMD_COMMANDS);
	}
	return 1;
}
stock GeneralCommandString() {
	if(!g_bGCMDS) {
	    new
			j,
			sCommands[][] = {
			{"/language"},
			{"/admins"},
			{"/report"},
			{"/loc"},
			{"/stats"},
			{"/tuner"},
			{"/info"},
			{"/data"},
			#if defined BASIC_COMMANDS
			{"/players"},
			{"/givemoney"},
			{"/me"},
			{"/kill"},
			{"/clock"},
			{"/date"},
			{"/pos"},
			#endif
			#if defined EXTRA_COMMANDS
			{"/bank"},
			{"/withdraw"},
			{"/para"},
			{"/hitman"},
			{"/bounty"},
			#endif
			#if defined LOCK_MODE
			{"/lock"},
			{"/unlock"},
			#endif
			#if defined DISPLAY_MODE
			{"/speedo"},
			{"/speedotype"},
			#endif
			{"/votekick"},
			{"/voteban"},
			{"/votelist"},
			{"/id"}
		};
		for(new i;i<sizeof(sCommands);i++) {
		    if(strlen(g_sGeneralCommandInfo[j]) > 96 ) {
		        j++;
		    }
		    else {
		        format(g_sGeneralCommandInfo[j],128,"%s%s ",g_sGeneralCommandInfo[j],sCommands[i]);
		    }
		}
		if(j < sizeof(g_sGeneralCommandInfo)) {
			j++; // Extra String for reduced admincommands
			for(new i;i<sizeof(g_sCommandText);i++) {
				if(g_Level[e_Level_Info:i] <= 1) {
				    if(strlen(g_sGeneralCommandInfo[j]) > 96 ) {
				        j++;
				    }
					format(g_sGeneralCommandInfo[j],128,"%s%s ",g_sGeneralCommandInfo[j],g_sCommandText[i]);
				}
			}
		}
	}
	return 1;
}
stock GeneralCommands(playerid) {
	for(new i;i < sizeof(g_sGeneralCommandInfo) ; i++) {
	    if(g_sGeneralCommandInfo[i][0]) {
	        SendClientMessage(playerid,COLOR_ORANGE,g_sGeneralCommandInfo[i]);
	    }
	}
	return 1;
}
//**********
stock AdminChat(playerid, params[]) {
 	format(s,sizeof(s),"%c %s: %s",PREFIX_ADMINCHAT,PlayerName(playerid),params);
	foreachEx(i) {
		if(PlayerInfo[i][AdminLevel]>=2) {
			SendClientMessage(i,COLOR_LIGHTBLUE,s);
		}
	}
 	return WriteLog(adminlog,s[2]);    /* [2] -> We dont need "# " in adminlog since we know it's adminchat */
}
//**********
stock AdminNote(msg[]="") {
	if(!msg[0]) {
		foreachEx(i) {
			if(PlayerInfo[i][AdminLevel]>=2) {
				SendClientPreLanguageMessage(i,COLOR_LIGHTBLUE);
			}
		}
		return WriteLog(adminlog,LanguageString(ServerLanguage()));
	}
	foreachEx(i) {
		if(PlayerInfo[i][AdminLevel]>=2) {
			SendClientMessage(i,COLOR_LIGHTBLUE,msg);
		}
	}
 	return WriteLog(adminlog,msg);
}
//**********
stock SendAdminCommand(color,msg[]="") {
	if(!msg[0]) {
		if(g_bShow_AdminCommand) {
		    foreach(i) {
		        SendClientPreLanguageMessage(i,color);
	 		}
		}
		else {
			foreachEx(i) {
				if(PlayerInfo[i][AdminLevel]>=2) {
				    SendClientPreLanguageMessage(i,COLOR_LIGHTBLUE);
				}
			}
		}
		return WriteLog(adminlog,LanguageString(ServerLanguage()));
	}
	else {
		if(g_bShow_AdminCommand) {
		    SendClientMessageToAll(color,msg);
		}
		else {
			foreachEx(i) {
				if(PlayerInfo[i][AdminLevel]>=2) {
			   		SendClientMessage(i,COLOR_LIGHTBLUE,msg);
				}
			}
		}
		return WriteLog(adminlog,msg);
	}
}
//**********
stock AdminCommand(message[]) {
	foreachEx(i) {
		if(PlayerInfo[i][AdminLevel]>=2) {
	   		SendClientMessage(i,COLOR_LIGHTBLUE,message);
		}
	}
	return 1;
}
//-------------------------------------------------------------------------------
stock LoadConfig() {
	new
	    IP[16],
		ThePlayer[MAX_PLAYER_NAME];
	if(!INI_Exist(levelconfig)) {
		INI_Create(levelconfig);
		print(" * Creating " #levelconfig " ...");
	}
	if(!INI_Exist(generalconfig)) {
		INI_Create(generalconfig);
		print(" * Creating " #generalconfig " ...");
 	}
	if(INI_Exist(levelconfig)) {
		//Command g_Level
	    INI_Open(levelconfig);
		if(!INI_IsSet("kick")) 				INI_WriteInt("kick",3,600); //
		if(!INI_IsSet("fake"))				INI_WriteInt("fake",5,600); //
		if(!INI_IsSet("heal"))				INI_WriteInt("heal",2,600); //
		if(!INI_IsSet("sethealth"))			INI_WriteInt("sethealth",4,600); //
		if(!INI_IsSet("slap"))				INI_WriteInt("slap",2,600); //
		if(!INI_IsSet("freeze"))			INI_WriteInt("freeze",3,600); //
		if(!INI_IsSet("unfreeze"))			INI_WriteInt("unfreeze",3,600); //
		if(!INI_IsSet("gravity"))			INI_WriteInt("gravity",3,600); //
		if(!INI_IsSet("ip"))				INI_WriteInt("ip",4,600); //
		if(!INI_IsSet("ban"))				INI_WriteInt("ban",3,600); //
		if(!INI_IsSet("tban"))				INI_WriteInt("tban",5,600); //
		if(!INI_IsSet("goto"))				INI_WriteInt("goto",3,600); //
		if(!INI_IsSet("mute"))				INI_WriteInt("mute",2,600); //
		if(!INI_IsSet("unmute"))			INI_WriteInt("unmute",2,600); //
 		if(!INI_IsSet("akill"))				INI_WriteInt("akill",2,600); //
		if(!INI_IsSet("get"))				INI_WriteInt("get",4,600); //
 		if(!INI_IsSet("jail"))				INI_WriteInt("jail",3,600); //
		if(!INI_IsSet("unjail"))			INI_WriteInt("unjail",3,600); //
		if(!INI_IsSet("settime"))			INI_WriteInt("settime",2,600); //
		if(!INI_IsSet("announce"))			INI_WriteInt("announce",3,600); //
		if(!INI_IsSet("addblacklist"))		INI_WriteInt("addblacklist",5,600); //
		if(!INI_IsSet("addwhitelist"))		INI_WriteInt("addwhitelist",5,600); //
		if(!INI_IsSet("addclanblacklist"))	INI_WriteInt("addclanblacklist",5,600); //
		if(!INI_IsSet("banip"))				INI_WriteInt("banip",5,600); //
		if(!INI_IsSet("nick"))				INI_WriteInt("nick",5,600); //
		if(!INI_IsSet("countdown"))			INI_WriteInt("countdown",2,600); //
		if(!INI_IsSet("reloadcfg"))			INI_WriteInt("reloadcfg",5);  //
		if(!INI_IsSet("reloadlanguages"))	INI_WriteInt("reloadlanguages",5);  //
		if(!INI_IsSet("reloadfs"))			INI_WriteInt("reloadfs",5);  //
		if(!INI_IsSet("reloadbans"))		INI_WriteInt("reloadbans",4);  //
		if(!INI_IsSet("allmoney"))			INI_WriteInt("allmoney",4,600); //
		if(!INI_IsSet("givecash"))			INI_WriteInt("givecash",3,600); //
		if(!INI_IsSet("setmoney"))			INI_WriteInt("setmoney",4,600); //
		if(!INI_IsSet("setadmin"))			INI_WriteInt("setadmin",5,600); //
		if(!INI_IsSet("armor"))				INI_WriteInt("armor",3,600); //
		if(!INI_IsSet("giveweapon"))		INI_WriteInt("giveweapon",4,600); //
		if(!INI_IsSet("adminchat"))			INI_WriteInt("adminchat",2,600); //
		if(!INI_IsSet("sun"))				INI_WriteInt("sun",2,600); //
		if(!INI_IsSet("cloud"))				INI_WriteInt("cloud",2,600); //
		if(!INI_IsSet("sandstorm"))			INI_WriteInt("sandstorm",2,600); //
		if(!INI_IsSet("fog"))				INI_WriteInt("fog",2,600); //
		if(!INI_IsSet("rain"))				INI_WriteInt("rain",2,600); //
		#if defined USE_MENUS
 		if(!INI_IsSet("ammunation"))		INI_WriteInt("ammunation",5,600); //
 		if(!INI_IsSet("weather"))			INI_WriteInt("weather",2,600); //
 		#endif
		if(!INI_IsSet("disarm"))			INI_WriteInt("disarm",3,600); //
		if(!INI_IsSet("numberplate"))		INI_WriteInt("numberplate",4,600); //
		if(!INI_IsSet("allheal"))			INI_WriteInt("allheal",4,600); //
		if(!INI_IsSet("resetmoney"))		INI_WriteInt("resetmoney",4,600); //
		if(!INI_IsSet("clear"))				INI_WriteInt("clear",3,600); //
		if(!INI_IsSet("say"))				INI_WriteInt("say",3,600); //
		if(!INI_IsSet("vr"))				INI_WriteInt("vr",3,600); //
		if(!INI_IsSet("flip"))				INI_WriteInt("flip",2,600); //
		if(!INI_IsSet("whitelist"))			INI_WriteInt("whitelist",5,600); //
		if(!INI_IsSet("blacklist"))			INI_WriteInt("blacklist",4,600); //
		if(!INI_IsSet("clanblacklist"))		INI_WriteInt("clanblacklist",4,600); //
		#if defined USE_MENUS
		if(!INI_IsSet("vehiclespawn"))		INI_WriteInt("vehiclespawn",4,600); //
		#endif
		if(!INI_IsSet("skin"))				INI_WriteInt("skin",3,600); //
		if(!INI_IsSet("explode"))			INI_WriteInt("explode",3,600); //
		if(!INI_IsSet("setscore"))			INI_WriteInt("setscore",2,600); //
		if(!INI_IsSet("carcolor"))			INI_WriteInt("carcolor",3,600); //
		#if defined SPECTATE_MODE
		if(!INI_IsSet("spectate"))			INI_WriteInt("spectate",4,600); //
		#endif
 		if(!INI_IsSet("noon"))				INI_WriteInt("noon",2,600); //
 		if(!INI_IsSet("night"))				INI_WriteInt("night",2,600); //
 		if(!INI_IsSet("morning"))			INI_WriteInt("morning",2,600); //
 		if(!INI_IsSet("day"))				INI_WriteInt("day",2,600); //
 		if(!INI_IsSet("fuckup"))			INI_WriteInt("fuckup",3,600); //
 		if(!INI_IsSet("force"))				INI_WriteInt("force",4,600); //
 		if(!INI_IsSet("ejet"))				INI_WriteInt("ejet",2,600); //
		#if defined LOCK_MODE
 		if(!INI_IsSet("xunlock"))			INI_WriteInt("xunlock",4,600); //
		#endif
 		if(!INI_IsSet("savepos"))			INI_WriteInt("savepos",3,600); //
 		if(!INI_IsSet("back"))				INI_WriteInt("back",3,600); //
 		#if defined USE_MENUS
 		if(!INI_IsSet("gmenu"))				INI_WriteInt("gmenu",4,600); //
 		#endif
		if(!INI_IsSet("setvip"))			INI_WriteInt("setvip",4,600); //
 		if(!INI_IsSet("delvip"))			INI_WriteInt("delvip",4,600); //
 		#if defined USE_MENUS
 		if(!INI_IsSet("teleportmenu"))		INI_WriteInt("teleportmenu",3,600); //
 		#endif
 		if(!INI_IsSet("givearmor"))			INI_WriteInt("givearmor",4,600); //
 		if(!INI_IsSet("giveskin"))			INI_WriteInt("giveskin",4,600); //
 		if(!INI_IsSet("jetpack"))			INI_WriteInt("jetpack",5,600); //
 		if(!INI_IsSet("god"))				INI_WriteInt("god",4,600); //
 		if(!INI_IsSet("alldisarm"))			INI_WriteInt("alldisarm",3,600); //
 		if(!INI_IsSet("lockchat"))			INI_WriteInt("lockchat",4,600); //
 		if(!INI_IsSet("hostname"))			INI_WriteInt("hostname",5,600); //
 		if(!INI_IsSet("mapname"))			INI_WriteInt("mapname",4,600); //
 		if(!INI_IsSet("getalias"))			INI_WriteInt("getalias",5,600); //
 		if(!INI_IsSet("port"))				INI_WriteInt("port",4,600); //
 		if(!INI_IsSet("invisible"))			INI_WriteInt("invisible",4,600); //
 		if(!INI_IsSet("gmx"))				INI_WriteInt("gmx",5,600); //
 		if(!INI_IsSet("unban"))				INI_WriteInt("unban",3,600); //
 		if(!INI_IsSet("gotopos"))			INI_WriteInt("gotopos",4,600); //
 		if(!INI_IsSet("getall"))			INI_WriteInt("getall",5,600); //
 		if(!INI_IsSet("myinterior"))		INI_WriteInt("myinterior",3,600); //
 		if(!INI_IsSet("myvirtualworld"))	INI_WriteInt("myvirtualworld",3,600); //
 		if(!INI_IsSet("setfightstyle"))		INI_WriteInt("setfightstyle",4,600); //
		if(!INI_IsSet("adminteleport"))		INI_WriteInt("adminteleport",4,600); //
		if(!INI_IsSet("privatemessage"))	INI_WriteInt("privatemessage",5,600); //
		g_Level[lkick] = 					INI_ReadInt("kick",600); //
		g_Level[lfake] = 					INI_ReadInt("fake",600); //
		g_Level[lheal] = 					INI_ReadInt("heal",600); //
		g_Level[lsethealth] = 				INI_ReadInt("sethealth",600); //
		g_Level[lslap] = 					INI_ReadInt("slap",600); //
		g_Level[lfreeze] = 					INI_ReadInt("freeze",600); //
		g_Level[lunfreeze] = 				INI_ReadInt("unfreeze",600); //
		g_Level[lgravity] = 				INI_ReadInt("gravity",600); //
		g_Level[lip] = 						INI_ReadInt("ip",600); //
		g_Level[lban] = 					INI_ReadInt("ban",600); //
		g_Level[ltban] = 					INI_ReadInt("tban",600); //
		g_Level[lgoto] = 					INI_ReadInt("goto",600); //
		g_Level[lmute] = 					INI_ReadInt("mute",600); //
		g_Level[lunmute] = 					INI_ReadInt("unmute",600); //
		g_Level[lakill] = 					INI_ReadInt("akill",600); //
		g_Level[lget] = 					INI_ReadInt("get",600); //
		g_Level[ljail] = 					INI_ReadInt("jail",600); //
		g_Level[lunjail] = 					INI_ReadInt("unjail",600); //
		g_Level[lsettime] = 				INI_ReadInt("settime",600); //
		g_Level[lannounce] = 				INI_ReadInt("announce",600); //
		g_Level[laddblack] = 				INI_ReadInt("addblacklist",600); //
		g_Level[laddwhite] = 				INI_ReadInt("addwhitelist",600); //
		g_Level[laddclanblack] = 			INI_ReadInt("addclanblacklist",600); //
		g_Level[lbanip] = 					INI_ReadInt("banip",600); //
		g_Level[lnick] = 					INI_ReadInt("nick",600); //
		g_Level[lcountdown] = 				INI_ReadInt("countdown",600); //
		g_Level[lreloadcfg] = 				INI_ReadInt("reloadcfg",600); //
		g_Level[lreloadlanguages] = 		INI_ReadInt("reloadlanguages",600); //
		g_Level[lreloadfs] = 				INI_ReadInt("reloadfs",600); //
		g_Level[lreloadbans] = 				INI_ReadInt("reloadbans",600); //
		g_Level[lallmoney] = 				INI_ReadInt("allmoney",600); //
		g_Level[lgivecash] = 				INI_ReadInt("givecash",600); //
		g_Level[lsetmoney] = 				INI_ReadInt("setmoney",600); //
		g_Level[lsetadmin] = 				INI_ReadInt("setadmin",600); //
		g_Level[larmor] = 					INI_ReadInt("armor",600); //
		g_Level[lgiveweapon] = 				INI_ReadInt("giveweapon",600); //
		g_Level[la] = 						INI_ReadInt("adminchat",600); //
		g_Level[lsun] =						INI_ReadInt("sun",600); //
		g_Level[lcloud] = 					INI_ReadInt("cloud",600); //
		g_Level[lsandstorm] = 				INI_ReadInt("sandstorm",600); //
		g_Level[lfog] = 					INI_ReadInt("fog",600); //
		g_Level[lrain] = 					INI_ReadInt("rain",600); //
		#if defined USE_MENUS
		g_Level[lammu] = 					INI_ReadInt("ammunation",600); //
		g_Level[lweather] = 				INI_ReadInt("weather",600); //
		#endif
		g_Level[ldisarm] = 					INI_ReadInt("disarm",600); //
		#if !defined _samp03_
		g_Level[lnumberplate] = 			INI_ReadInt("numberplate",600); //
		#endif
		g_Level[lallheal] = 				INI_ReadInt("allheal",600); //
		g_Level[lresetmoney] = 				INI_ReadInt("resetmoney",600); //
		g_Level[lclear] = 					INI_ReadInt("clear",600); //
		g_Level[lsay] = 					INI_ReadInt("say",600); //
		g_Level[lvr] = 						INI_ReadInt("vr",600); //
		g_Level[lflip] = 					INI_ReadInt("flip",600); //
		g_Level[lwhitelist] = 				INI_ReadInt("whitelist",600); //
		g_Level[lblacklist] = 				INI_ReadInt("blacklist",600); //
		g_Level[lclanblacklist] = 			INI_ReadInt("clanblacklist",600); //
		#if defined USE_MENUS
		g_Level[lv] = 						INI_ReadInt("vehiclespawn",600); //
		#endif
		g_Level[lskin] = 					INI_ReadInt("skin",600); //
		g_Level[lexplode] = 				INI_ReadInt("explode",600); //
		g_Level[lsetscore] = 				INI_ReadInt("setscore",600); //
		g_Level[lcarcolor] = 				INI_ReadInt("carcolor",600); //
		g_Level[lspec] = 					INI_ReadInt("spectate",600); //
		g_Level[lnoon] = 					INI_ReadInt("noon",600); //
		g_Level[lnight] = 					INI_ReadInt("night",600); //
		g_Level[lday] = 					INI_ReadInt("day",600); //
		g_Level[lmorning] = 				INI_ReadInt("morning",600); //
		g_Level[lfuckup] = 					INI_ReadInt("fuckup",600); //
		g_Level[lforce] = 					INI_ReadInt("force",600); //
		g_Level[lejet] = 					INI_ReadInt("ejet",600); //
		#if defined LOCK_MODE
		g_Level[lxunlock] = 				INI_ReadInt("xunlock",600); //
		#endif
		g_Level[lsavepos] =					INI_ReadInt("savepos",600); //
		g_Level[lback] = 					INI_ReadInt("back",600); //
		#if defined USE_MENUS
		g_Level[lgmenu] = 					INI_ReadInt("gmenu",600); //
		#endif
		g_Level[lsetvip] = 					INI_ReadInt("setvip",600); //
		g_Level[ldelvip] = 					INI_ReadInt("delvip",600); //
		#if defined USE_MENUS
		g_Level[lteleport] = 				INI_ReadInt("teleportmenu",600); //
		#endif
		g_Level[lgivearmor] = 				INI_ReadInt("givearmor",600); //
		g_Level[lgiveskin] = 				INI_ReadInt("giveskin",600); //
		g_Level[ljetpack] = 				INI_ReadInt("jetpack",600); //
		g_Level[lgod] =						INI_ReadInt("god",600); //
		g_Level[lalldisarm] = 				INI_ReadInt("alldisarm",600); //
		g_Level[llockchat] = 				INI_ReadInt("lockchat",600); //
		g_Level[lhostname] = 				INI_ReadInt("hostname",600); //
		g_Level[lmapname] = 				INI_ReadInt("mapname",600); //
		g_Level[lgetalias] = 				INI_ReadInt("getalias",600); //
		g_Level[lport] = 					INI_ReadInt("port",600); //
		g_Level[linvisible] = 				INI_ReadInt("invisible",600); //
		g_Level[lgmx] = 					INI_ReadInt("gmx",600); //
		g_Level[lunban] =					INI_ReadInt("unban",600); //
		g_Level[lgotopos] =					INI_ReadInt("gotopos",600); //
		g_Level[lgetall] =					INI_ReadInt("getall",600); //
		g_Level[lmyinterior] =				INI_ReadInt("myinterior",600); //
		g_Level[lmyvirtualw] =				INI_ReadInt("myvirtualworld",600); //
		g_Level[lsetfightstyle] =			INI_ReadInt("setfightstyle",600); //
		g_Level[ladmintele] = 				INI_ReadInt("adminteleport",600); //
		g_Level[lpmreader] = 				INI_ReadInt("privatemessage",600); //
	   	INI_Save();
	   	INI_Close();

	}
	else {
		printf("[Error] " #levelconfig " - CAN'T OPEN");
	}
	if(INI_Exist(generalconfig)) {
	    INI_Open(generalconfig);
		if(!INI_IsSet("Whitelist"))			INI_WriteInt("Whitelist",0);
		if(!INI_IsSet("Blacklist"))			INI_WriteInt("Blacklist",1);
		if(!INI_IsSet("Clanblacklist"))		INI_WriteInt("Clanblacklist",1);
		if(!INI_IsSet("LoginTime"))			INI_WriteInt("LoginTime",40);
		if(!INI_IsSet("PingKick"))			INI_WriteInt("PingKick",1,600); // 1 ON | 0 OFF
		if(!INI_IsSet("PingKickInterval"))	INI_WriteInt("PingKickInterval",5,600); // In Seconds,so its 5Seconds ;)
		if(!INI_IsSet("MAX_PING"))			INI_WriteInt("MAX_PING",600,600); // Max allowed ping if PingKick=1
		if(!INI_IsSet("MAX_PING_WARNINGS"))	INI_WriteInt("MAX_PING_WARNINGS",5);
		if(!INI_IsSet("DisplayConnectMessages"))INI_WriteInt("DisplayConnectMessages",1);
		#if defined DISPLAY_MODE
		if(!INI_IsSet("DisplayMode"))		INI_WriteInt("DisplayMode",3);
		#endif
		if(!INI_IsSet("ShowAdminCommand"))	INI_WriteInt("ShowAdminCommand",1);
		if(!INI_IsSet("DynmWeather"))		INI_WriteInt("DynmWeather",1);
		if(!INI_IsSet("DynmTime"))			INI_WriteInt("DynmTime",1);
		if(!INI_IsSet("ScoreUpdate"))		INI_WriteInt("ScoreUpdate",1);
		if(!INI_IsSet("SlapHP"))			INI_WriteFloat("SlapHP",20.0);
		if(!INI_IsSet("GodHP"))				INI_WriteFloat("GodHP",1000.0);
		if(!INI_IsSet("Advertise"))			INI_WriteString("Advertise","This server runs " #gVersion " (www.san-vice.de.vu)");
		if(!INI_IsSet("AutoLogin"))			INI_WriteInt("AutoLogin",1);
		if(!INI_IsSet("RegisterToSpawn"))	INI_WriteInt("RegisterToSpawn",0);
		if(!INI_IsSet("ForceLoginDialog"))	INI_WriteInt("ForceLoginDialog",1);
		if(!INI_IsSet("DefaultJailTime")) 	INI_WriteInt("DefaultJailTime",300,600); // 5min
		if(!INI_IsSet("MAX_VOTEKICK"))		INI_WriteInt("MAX_VOTEKICK",5);
		if(!INI_IsSet("MAX_VOTEBAN"))		INI_WriteInt("MAX_VOTEBAN",5);
		if(!INI_IsSet("MAX_HELIKILLS"))		INI_WriteInt("MAX_HELIKILLS",0);
		if(!INI_IsSet("MAX_BADWORDS"))		INI_WriteInt("MAX_BADWORDS",5);
		if(!INI_IsSet("AutoUnmute"))		INI_WriteInt("AutoUnmute",2*60);
		if(!INI_IsSet("SPAMRATE"))			INI_WriteInt("SPAMRATE",5000);
		if(!INI_IsSet("MAX_MSG_IN_SPAMRATE"))INI_WriteInt("MAX_MSG_IN_SPAMRATE",4);
		#if defined irc_gAdmin
		if(!INI_IsSet("IRC_Channel")) 		INI_WriteString("IRC_Channel","#gAdmin",600); //
		if(!INI_IsSet("IRC_ChannelPassword"))INI_WriteString("IRC_ChannelPassword","None",600); //
		if(!INI_IsSet("IRC_Botname")) 		INI_WriteString("IRC_Botname","My_gAdmin_Bot",600); //
		if(!INI_IsSet("IRC_Botpassword"))	INI_WriteString("IRC_Botpassword","w00t",600); //
		if(!INI_IsSet("IRC_ServerPort"))	INI_WriteString("IRC_ServerPort","6667",600); //
		if(!INI_IsSet("IRC_Server"))		INI_WriteString("IRC_Server","irc.gtanet.com",600); //
		#endif
		#if defined USE_MENUS
		if(!INI_IsSet("V_FastCars0"))		INI_WriteInt("V_FastCars0",587);
		if(!INI_IsSet("V_FastCars1"))		INI_WriteInt("V_FastCars1",411);
		if(!INI_IsSet("V_FastCars2"))		INI_WriteInt("V_FastCars2",415);
		if(!INI_IsSet("V_FastCars3"))		INI_WriteInt("V_FastCars3",541);
		if(!INI_IsSet("V_FastCars4"))		INI_WriteInt("V_FastCars4",480);
		if(!INI_IsSet("V_FastCars5"))		INI_WriteInt("V_FastCars5",506);
		if(!INI_IsSet("V_FastCars6"))		INI_WriteInt("V_FastCars6",451);
		if(!INI_IsSet("V_FastCars7"))		INI_WriteInt("V_FastCars7",402);
		if(!INI_IsSet("V_FastCars8"))		INI_WriteInt("V_FastCars8",477);
		if(!INI_IsSet("V_FastCars9"))		INI_WriteInt("V_FastCars9",559);
		if(!INI_IsSet("V_FastCars10"))		INI_WriteInt("V_FastCars10",562);
		if(!INI_IsSet("V_FastCars11"))		INI_WriteInt("V_FastCars11",560);
		if(!INI_IsSet("V_LowRider0"))		INI_WriteInt("V_LowRider0",536);
		if(!INI_IsSet("V_LowRider1"))		INI_WriteInt("V_LowRider1",567);
		if(!INI_IsSet("V_LowRider2"))		INI_WriteInt("V_LowRider2",535);
		if(!INI_IsSet("V_LowRider3"))		INI_WriteInt("V_LowRider3",518);
		if(!INI_IsSet("V_LowRider4"))		INI_WriteInt("V_LowRider4",576);
		if(!INI_IsSet("V_LowRider5"))		INI_WriteInt("V_LowRider5",534);
		if(!INI_IsSet("V_LowRider6"))		INI_WriteInt("V_LowRider6",412);
		if(!INI_IsSet("V_LowRider7"))		INI_WriteInt("V_LowRider7",575);
		if(!INI_IsSet("V_LowRider8"))		INI_WriteInt("V_LowRider8",475);
		if(!INI_IsSet("V_Bikes0"))			INI_WriteInt("V_Bikes0",522);
		if(!INI_IsSet("V_Bikes1"))			INI_WriteInt("V_Bikes1",461);
		if(!INI_IsSet("V_Bikes2"))			INI_WriteInt("V_Bikes2",463);
		if(!INI_IsSet("V_Bikes3"))			INI_WriteInt("V_Bikes3",581);
		if(!INI_IsSet("V_Bikes4"))			INI_WriteInt("V_Bikes4",523);
		if(!INI_IsSet("V_Bikes5"))			INI_WriteInt("V_Bikes5",462);
		if(!INI_IsSet("V_Bikes6"))			INI_WriteInt("V_Bikes6",471);
		if(!INI_IsSet("V_Bikes7"))			INI_WriteInt("V_Bikes7",521);
		if(!INI_IsSet("V_Bikes8"))			INI_WriteInt("V_Bikes8",481);
		if(!INI_IsSet("V_Bikes9"))			INI_WriteInt("V_Bikes9",510);
		if(!INI_IsSet("V_Bikes10"))			INI_WriteInt("V_Bikes10",468);
		if(!INI_IsSet("V_Bikes11"))			INI_WriteInt("V_Bikes11",448);
		if(!INI_IsSet("V_Planes0"))			INI_WriteInt("V_Planes0",520);
		if(!INI_IsSet("V_Planes1"))			INI_WriteInt("V_Planes1",513);
		if(!INI_IsSet("V_Planes2"))			INI_WriteInt("V_Planes2",447);
		if(!INI_IsSet("V_Planes3"))			INI_WriteInt("V_Planes3",487);
		if(!INI_IsSet("V_Planes4"))			INI_WriteInt("V_Planes4",425);
		if(!INI_IsSet("V_Planes5"))			INI_WriteInt("V_Planes5",511);
		if(!INI_IsSet("V_Planes6"))			INI_WriteInt("V_Planes6",476);
		if(!INI_IsSet("V_Planes7"))			INI_WriteInt("V_Planes7",519);
		if(!INI_IsSet("V_Planes8"))			INI_WriteInt("V_Planes8",593);
		if(!INI_IsSet("V_Planes9"))			INI_WriteInt("V_Planes9",512);
		if(!INI_IsSet("V_Planes10"))		INI_WriteInt("V_Planes10",553);
		if(!INI_IsSet("V_Boats0"))			INI_WriteInt("V_Boats0",446);
		if(!INI_IsSet("V_Boats1"))			INI_WriteInt("V_Boats1",452);
		if(!INI_IsSet("V_Boats2"))			INI_WriteInt("V_Boats2",493);
		if(!INI_IsSet("V_Boats3"))			INI_WriteInt("V_Boats3",472);
		if(!INI_IsSet("V_Boats4"))			INI_WriteInt("V_Boats4",454);
		if(!INI_IsSet("V_Boats5"))			INI_WriteInt("V_Boats5",430);
		if(!INI_IsSet("V_Boats6"))			INI_WriteInt("V_Boats6",484);
		if(!INI_IsSet("V_Boats7"))			INI_WriteInt("V_Boats7",595);
		if(!INI_IsSet("V_Special0"))		INI_WriteInt("V_Special0",539);
		if(!INI_IsSet("V_Special1"))		INI_WriteInt("V_Special1",495);
		if(!INI_IsSet("V_Special2"))		INI_WriteInt("V_Special2",494);
		if(!INI_IsSet("V_Special3"))		INI_WriteInt("V_Special3",504);
		if(!INI_IsSet("V_Special4"))		INI_WriteInt("V_Special4",438);
		if(!INI_IsSet("V_Special5"))		INI_WriteInt("V_Special5",437);
		if(!INI_IsSet("V_Special6"))		INI_WriteInt("V_Special6",568);
		if(!INI_IsSet("V_Special7"))		INI_WriteInt("V_Special7",424);
		if(!INI_IsSet("V_Special8"))		INI_WriteInt("V_Special8",571);
		if(!INI_IsSet("V_Special9"))		INI_WriteInt("V_Special9",444);
		#endif
   		INI_Save();
		g_sAdvertise[0]='\0';
		g_bWhiteStatus=						INI_ReadBool("Whitelist");
	 	g_bBlackListStatus=					INI_ReadBool("Blacklist");
	 	g_bClangBlackListStatus=			INI_ReadBool("Clanblacklist");
		g_MAX_LOGIN_TIME=					INI_ReadInt("LoginTime");
		g_bPingKickStatus=					INI_ReadBool("PingKick");
		if(g_bPingKickStatus) {
			g_PingKickInterval=				INI_ReadInt("PingKickInterval");
			g_MAX_PING=						INI_ReadInt("MAX_PING");
			g_MAX_PING_WARNINGS=			INI_ReadInt("MAX_PING_WARNINGS");
		}
		g_bShow_EnterLeave=					INI_ReadBool("DisplayConnectMessages");
		#if defined DISPLAY_MODE
		g_Display=							INI_ReadInt("DisplayMode");
		#endif
		g_bShow_AdminCommand=				INI_ReadBool("ShowAdminCommand");
	 	g_bDynamicTime=						INI_ReadBool("DynamicTime");
	 	g_bDynamicWeather=					INI_ReadBool("DynamicWeather");
	 	g_bDynamicScore=					INI_ReadBool("ScoreUpdate");
		g_fSlapHP=							INI_ReadFloat("SlapHP");
		g_fGodValue=						INI_ReadFloat("GodHP");
		INI_ReadString(g_sAdvertise,"Advertise");
	 	g_bIPComp=							INI_ReadBool("AutoLogin");
	 	g_bRegisterSpawn=					INI_ReadBool("RegisterToSpawn");
	 	#if defined _samp03_
	 	g_bForceDialog=						INI_ReadBool("ForceLoginDialog");
	 	#endif
	 	g_DefJailTime=						INI_ReadInt("DefaultJailTime");
		g_MAX_VOTE_KICKS=					INI_ReadInt("MAX_VOTEKICK");
		g_MAX_VOTE_BANS=					INI_ReadInt("MAX_VOTEBAN");
 		g_MAX_HELI_LAME_KILLS=				INI_ReadInt("MAX_HELIKILLS");
	 	g_MAX_BAD_WORDS=					INI_ReadInt("MAX_BADWORDS");
	 	g_iAutoUnmute=						INI_ReadInt("AutoUnmute");
		g_SpamRate=							INI_ReadInt("SPAMRATE");
		g_MaxSpamMessages=					INI_ReadInt("MAX_MSG_IN_SPAMRATE");

 	 	//Vehicle Spawn Menu
 	 	#if defined USE_MENUS
 	 	new
 	 	    i;
 	 	for( i = 0 ; i < sizeof(g_V_FastCars) ; i++) {
 	 		format(s,sizeof(s),"V_FastCars%d",i);
 	 		g_V_FastCars[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_FastCars[i]);
 	 	}
 	 	for( i = 0 ; i < sizeof(g_V_Bikes) ; i++) {
 	 		format(s,sizeof(s),"V_Bikes%d",i);
 	 		g_V_Bikes[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_Bikes[i]);
 	 	}
 	 	for( i = 0 ; i < sizeof(g_V_Boats) ; i++) {
 	 		format(s,sizeof(s),"V_Boats%d",i);
 	 		g_V_Boats[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_Boats[i]);
 	 	}
 	 	for( i = 0 ; i < sizeof(g_V_LowRider) ; i++) {
 	 		format(s,sizeof(s),"V_LowRider%d",i);
 	 		g_V_LowRider[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_LowRider[i]);
 	 	}
 	 	for( i = 0 ; i < sizeof(g_V_Planes) ; i++) {
 	 		format(s,sizeof(s),"V_Planes%d",i);
 	 		g_V_Planes[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_Planes[i]);
 	 	}
 	 	for( i = 0 ; i < sizeof(g_V_Special) ; i++) {
 	 		format(s,sizeof(s),"V_Special%d",i);
 	 		g_V_Special[i]=INI_ReadInt(s);
			//printf("%s %d",s,g_V_Special[i]);
 	 	}
 	 	#endif
	}
	else {
		printf("[Error] " #generalconfig " - CAN'T OPEN");
	}
   	INI_Save();
   	INI_Close();
	// End of loading
	GetServerVarAsString("worldtime",s,sizeof(s));
	g_Time=strval(s);
	IPBansEntryCount=0;
	LoadIPBanEntrys();
	g_bACMDS=false;
	if(g_bShow_AdminCommand) {
		print(" * Show Admin Commands :On");
	}
	if(g_bShow_EnterLeave) {
		print(" * Show Enter/Leave Message :On");
	}
	WhitelistEntryCount=0;
	LoadWhitelistEntrys();  // We need to load it anyway
	if(g_bWhiteStatus) {
		print(" * Whitelist Status: On");
 	}
	if(g_bBlackListStatus) {
	    BlacklistEntryCount=0;
		LoadBlacklistEntrys();
		print(" * Blacklist Status:On");
	}
	if(g_bClangBlackListStatus) {
	    ClanBlacklistEntryCount=0;
		LoadClanBlacklistEntrys();
		print(" * Clan Blacklist Status:On");
	}
	if(g_bDynamicTime) {
		print(" * Time Update :On");
	}
	if(g_bDynamicWeather) {
		print(" * Weather Update :On");
	}
	if(g_bDynamicScore) {
		print(" * Score Update :On");
	}
	#if defined DISPLAY_MODE
	if(g_Display==1) {
		print(" * Speed O Meter :On");
	}
	if(g_Display==2) {
		print(" * AreaName :On");
	}
	if(g_Display==3) {
		print(" * AreaName & Speed O Meter :On");
	}
	#endif
	if(g_bPingKickStatus) {
		print(" * PingKick:On");
	}
	if(g_bRegisterSpawn) {
		print(" * RegisterToSpawn:On");
	}
	print(" * ... finished loading :)");
	print("-------------------------------------+\n");

	if(g_bIPComp) {
		for(new i = 0; i < g_Max_Players ; i++) {
		    if(!IsPlayerNPC(i)) { // NPC's autologin ? - Nope
		        if(GetPlayerName(i,ThePlayer,sizeof(ThePlayer)) ) {
					#if defined MYSQL
					if(gSQL_ExistUser(ThePlayer)) {
					#else
					if(udb_Exists(ThePlayer)) {
					#endif
					    IP[0]='\0';
					    s[0]='\0';
						#if defined MYSQL
					    strcat(s,gSQL_GetUserVar(ThePlayer,"IP"),sizeof(s));
						#else
					    strcat(s,dUser(ThePlayer).("IP"),sizeof(s));
					    #endif
			            GetPlayerIp(i,IP,sizeof(IP));
						if((!strcmp(IP,s,true,sizeof(IP))) && (s[0])) {
							OnPlayerLogin(i,LOGIN_AUTOIP);
						}
					}
				}
			}
		}
	}
	CheckTimers();
	#if defined USE_MENUS
	CreateMenus();
	#endif
	g_bACMDS=false; // Set to false as we execute AdminCommandString() a bit later
	g_bGCMDS=false; // "" ""
	/* Lets clear the old strings */
	new
	    i,
	    j;
	for( i = 0 ; i < sizeof(g_sAdminCommandInfo) ; i++) {
	    for( j = 0 ;j < sizeof(g_sAdminCommandInfo[]) ; j++) {
			g_sAdminCommandInfo[i][j][0]='\0';
	    }
	}
	AdminCommandString();
	for( i = 0 ; i < sizeof(g_sGeneralCommandInfo) ; i++) {
		g_sGeneralCommandInfo[i][0]='\0';
	}
	GeneralCommandString();
	#if defined irc_gAdmin
		if(EchoBot) {
			//ircSendRawData(EchoBot, "QUIT gAdmin 1.1 IRC Bot - by Goldkiller (www.san-vice.de.vu)");
			//ircDisconnect(EchoBot);
			EchoBot=0;
			print(" * Disconnected Echo Bot	- Reconnect soon!");
		}
		/* 4 seconds after serverstart bot try's to connect */
		SetTimer("IRCJoin",4*1000,0);
	#endif
	return 1;
}
//-------------------------------------------------------------------------------
stock CheckTimers( ignoreid = -1 ) {
	new
		Players;
	foreach(i) {
	    if(i!=ignoreid) {
			Players++;
		}
	}
	if(!g_bTimers && Players >= 1) {
		g_tTrigger=SetTimer("Trigger",1*1000,1);
		g_bTimers=true;
		print("gAdmin globalTimer activated");
	}
	else if(g_bTimers && Players < 1){
		KillTimer(g_tTrigger);
		g_bTimers=false;
		print("gAdmin globalTimer destroyed");
	}
	return 1;
}
#if defined LOCK_MODE
public CheckLock() {
	for(new i=1;i<MAX_VEHICLES;i++) {
		if(IsVehicleFlag(i,VEHICLE_FLAG_LOCK)) {
			if(!IsVehicleInUse(i)) {
				VehicleInfo[i][LockCount]--;
				if(!VehicleInfo[i][LockCount]) {
					UnlockCar(i);
				}
			}
		}
	}
	return 1;
}
public UnlockCar(vehicleid) {
	foreachEx(i) {
		SetVehicleParamsForPlayer(vehicleid,i,0,0);
	}
	DeleteVehicleFlag(vehicleid,VEHICLE_FLAG_LOCK);
	VehicleInfo[vehicleid][LockCount]=-1;
	VehicleInfo[vehicleid][iOwnerID] = INVALID_PLAYER_ID;
	return 1;
}
#endif
#if defined SAVE_ADDITION
public SaveProfiles() {
	new
	    ThePlayer[MAX_PLAYERS];
	foreachEx(i) {
	    if(GetPlayerName(i,ThePlayer,sizeof(ThePlayer))) {
			#if defined SAVE_POS
			new
			    Float:X,
			    Float:Y,
			    Float:Z;
			GetPlayerPos(i,X,Y,Z);
			#endif
			#if defined MYSQL
	            gSQL_UpdateUser(ThePlayer,i);
			#else
				dUserSetINT(ThePlayer).("AdminLevel",PlayerInfo[i][AdminLevel]);
				dUserSetINT(ThePlayer).("Money",GetPlayerMoney(i));
				dUserSetINT(ThePlayer).("Score",GetPlayerScore(i));
				#if defined EXTRA_COMMANDS
				dUserSetINT(ThePlayer).("BankMoney",PlayerInfo[i][BankMoney]);
				#endif
				dUserSet(ThePlayer).("Language",GetShortLanguageName(GetPlayerLanguageID(i)));
				dUserSetINT(ThePlayer).("Kills",PlayerInfo[i][Kills]);
				dUserSetINT(ThePlayer).("Deaths",PlayerInfo[i][Deaths]);
				dUserSetINT(ThePlayer).("TimesSpawned",PlayerInfo[i][SpawnCount]);
				#if defined SAVE_POS
				dUserSetFLOAT(ThePlayer).("X",X);
				dUserSetFLOAT(ThePlayer).("Y",Y);
				dUserSetFLOAT(ThePlayer).("Z",Z);
				#endif
			#endif
		}
	}
}
#endif
public Trigger() {
	#if defined LOCK_MODE
	g_CheckLockUpdate_Count++;
	#endif
	g_GodUpdate_Count++;
	#if !defined NO_JAIL_COUNT
	g_JailCountInterval_Count++;
	#endif
	if(g_bDynamicTime) {
		g_TimeUpdate_Count++;
		if(g_TimeUpdate_Count==g_TimeUpdate) {
			TimeUpdate();
			g_TimeUpdate_Count=0;
		}
	}
	if(g_bDynamicWeather) {
		g_WeatherUpdate_Count++;
		if(g_WeatherUpdate_Count==g_WeatherUpdate) {
			WeatherUpdate();
            ResetWeatherUpdate();
		}
	}
	if(g_bDynamicScore) {
		g_ScoreUpdate_Count++;
		if(g_ScoreUpdate_Count==g_ScoreUpdate) {
			ScoreUpdate();
			g_ScoreUpdate_Count=0;
		}
	}
	#if defined DISPLAY_MODE
	switch(g_Display) {
		case 1: {
			g_SpeedOMeterUpdate_Count++;
			if(g_SpeedOMeterUpdate_Count==g_SpeedOMeterUpdate) {
				SpeedOMeter();
				g_SpeedOMeterUpdate_Count=0;
			}
		}
		case 2: {
			g_AreaNameUpdate_Count++;
			if(g_AreaNameUpdate_Count==g_AreaNameUpdate) {
				AreaName();
				g_AreaNameUpdate_Count=0;
			}
		}
		case 3: {
			g_SpeedNameUpdate_Count++;
			if(g_SpeedNameUpdate_Count==g_SpeedNameUpdate) {
				SpeedName();
				g_SpeedNameUpdate_Count=0;
			}
		}
	}
	#endif
	if(g_bPingKickStatus) {
		g_PingKickInterval_Count++;
		if(g_PingKickInterval_Count==g_PingKickInterval) {
			PingCheck();
			g_PingKickInterval_Count=0;
		}
	}
	#if defined LOCK_MODE
	if(g_CheckLockUpdate_Count == g_CheckLockUpdate) {
		CheckLock();
		g_CheckLockUpdate_Count=0;
	}
	#endif
	if(g_GodUpdate_Count==g_GodUpdate) {
		GodUpdate();
		g_GodUpdate_Count=0;
	}
	#if !defined NO_JAIL_COUNT
	if(g_JailCountInterval_Count==g_JailCountIntervalUpdate) {
		g_JailCountInterval_Count=0;
		foreachEx(i) {
		    /* bJail is false if Player is not connected */
			if(PlayerInfo[i][JailCount]!=-1 && IsPlayerFlag(playerid,PLAYER_FLAG_JAIL)) {
				PlayerInfo[i][JailCount]+=g_JailCountIntervalUpdate;
				if(PlayerInfo[i][JailCount]>=g_JailCountInterval_Info) {
					CreateClientLanguageMessages("txt_unjail4",PlayerName(i),(g_JailCountIntervalUpdate/60));
					AdminNote();
					PlayerInfo[i][JailCount]=0;
				}
			}
		}

	}
	#endif
	if(g_iAutoUnmute) {
	    foreachEx(i) {
	        if(PlayerInfo[i][iSpamRelease] > 0) {
	            PlayerInfo[i][iSpamRelease]--;
	            if(!PlayerInfo[i][iSpamRelease]) {
					PlayerInfo[i][SpamCount]++;
				   	DeletePlayerFlag(i,PLAYER_FLAG_MUTE);
	            }
	        }
	    }
	}
	return 1;
}
public CallGameModeExit() {
	KillTimer(g_tGMX);
	GameModeExit();
	return 1;
}

stock LoadBadWordsEntrys() {
	new
		File:myfile=fopen(BadWords_file,io_read);
	if(myfile) {
		new
			tmp[MAX_PLAYER_NAME];
		while (fread(myfile,tmp,sizeof(tmp))){
			if(g_BadWordsSize>=MAX_BAD_WORDS_LIST) {
					printf("[WordFilter] Couldn't load entry %s,increase MAX_BAD_WORDS_LIST [ "#MAX_BAD_WORDS_LIST" ]",tmp);
			}
			else {
		 		StripNewLine(tmp);
	   			g_BadWords[g_BadWordsSize]=tmp;
				g_BadWordsSize++;
			}
		}
		fclose(myfile);
		return 1;
	}
	return 0;
}
stock LoadWhitelistEntrys() {
	if(!WhitelistEntryCount) {
		new
			File:myfile=fopen(whitelist_file,io_read);
		if(myfile) {
			new
				tmp[MAX_PLAYER_NAME];
		   	while (fread(myfile,tmp,MAX_PLAYER_NAME)) {
				if(WhitelistEntryCount>=MAX_WHITELIST_ENTRYS ) {
					printf("[White] Couldn't load entry %s,increase MAX_WHITELIST_ENTRYS [ " #MAX_WHITELIST_ENTRYS " ]",tmp);
				}
				else {
			 		StripNewLine(tmp);
					WhitelistEntry[WhitelistEntryCount]=tmp;
					WhitelistEntryCount++;
				}
			}
			fclose(myfile);
			return 1;
		}
		return 0;
	}
	return 1;
}
stock LoadBlacklistEntrys() {
	if(!BlacklistEntryCount) {
		new
			File:myfile=fopen(blacklist_file,io_read);
		if(myfile) {
			new
				tmp[MAX_PLAYER_NAME];
			while (fread(myfile,tmp,MAX_PLAYER_NAME)) {
				if(BlacklistEntryCount>=MAX_BLACKLIST_ENTRYS) {
					printf("[Black] Couldn't load entry %s,increase MAX_BLACKLIST_ENTRYS [ "#MAX_BLACKLIST_ENTRYS" ]",tmp);
				}
				else {
			 		StripNewLine(tmp);
					BlacklistEntry[BlacklistEntryCount]=tmp;
					BlacklistEntryCount++;
				}
			}
			fclose(myfile);
			return 1;
		}
		return 0;
	}
	return 1;
}
stock LoadClanBlacklistEntrys() {
	if(!ClanBlacklistEntryCount) {
		new
			File:myfile= fopen(clanblacklist_file,io_read);
		if(myfile) {
		    new
		        tmp[MAX_PLAYER_NAME];   // ClanTag can't be longer than a whole PlayerName
			while (fread(myfile,tmp,sizeof(tmp))){
				if(ClanBlacklistEntryCount>=MAX_CLANBLACKLIST_ENTRYS) {
					printf("[ClanBlack] Couldn't load entry %s,increase MAX_CLANBLACKLIST_ENTRYS [ "#MAX_CLANBLACKLIST_ENTRYS" ]",tmp);
				}
				else {
			 		StripNewLine(tmp);
					format(ClanBlacklistEntry[ClanBlacklistEntryCount],sizeof(ClanBlacklistEntry[]),tmp);
					ClanBlacklistEntryCount++;
				}
			}
			fclose(myfile);
			return 1;
		}
		return 0;
	}
	return 1;
}
stock LoadIPBanEntrys() {
	if(!IPBansEntryCount) {
		new
			File:myfile=fopen(ipbans_file,io_read);
		if(myfile) {
		    new
		        tmp[16];
			while (fread(myfile,tmp,sizeof(tmp))){
				if(IPBansEntryCount>=MAX_IPBAN_ENTRYS) {
					printf("[IPBAN] Couldn't load entry %s,increase MAX_IPBAN_ENTRY [ "#MAX_IPBAN_ENTRY" ]",tmp);
				}
				else {
			 		StripNewLine(tmp);
				    new
				        l=strlen(tmp);
					strdel(tmp,l-3,l);
					IPBansEntry[IPBansEntryCount]=tmp;
					IPBansEntryCount++;
				}
			}
			fclose(myfile);
			return 1;
		}
		return 0;
	}
	return 1;
}
stock CreateMenus() {
	if(IsValidMenu(m_Pistole)) 			DestroyMenu(m_Pistole);
	if(IsValidMenu(m_MicroSMG)) 		DestroyMenu(m_MicroSMG);
	if(IsValidMenu(m_Shotguns)) 		DestroyMenu(m_Shotguns);
	if(IsValidMenu(m_Items)) 			DestroyMenu(m_Items);
	if(IsValidMenu(m_SMG)) 				DestroyMenu(m_SMG);
	if(IsValidMenu(m_Rifles)) 			DestroyMenu(m_Rifles);
	if(IsValidMenu(m_Assaultrifle)) 	DestroyMenu(m_Assaultrifle);
	if(IsValidMenu(m_BigOnes)) 			DestroyMenu(m_BigOnes);
	if(IsValidMenu(m_HandGuns)) 		DestroyMenu(m_HandGuns);
	if(IsValidMenu(m_Grenade)) 			DestroyMenu(m_Grenade);
	if(IsValidMenu(m_ImportTuner)) 		DestroyMenu(m_ImportTuner);
	if(IsValidMenu(m_LowRider)) 		DestroyMenu(m_LowRider);
	if(IsValidMenu(m_AmmuNation)) 		DestroyMenu(m_AmmuNation);
	if(IsValidMenu(m_V)) 				DestroyMenu(m_V);
	if(IsValidMenu(m_Rims)) 			DestroyMenu(m_Rims);
	if(IsValidMenu(m_Color)) 			DestroyMenu(m_Color);
	if(IsValidMenu(m_Bikes)) 			DestroyMenu(m_Bikes);
	if(IsValidMenu(m_Boats)) 			DestroyMenu(m_Boats);
	if(IsValidMenu(m_Planes)) 			DestroyMenu(m_Planes);
	if(IsValidMenu(m_FastCars)) 		DestroyMenu(m_FastCars);
	if(IsValidMenu(m_Special)) 			DestroyMenu(m_Special);
	if(IsValidMenu(m_Weather)) 			DestroyMenu(m_Weather);
	if(IsValidMenu(m_LS)) 				DestroyMenu(m_LS);
	if(IsValidMenu(m_SF)) 				DestroyMenu(m_SF);
	if(IsValidMenu(m_LV)) 				DestroyMenu(m_LV);
	if(IsValidMenu(m_Desert)) 			DestroyMenu(m_Desert);
	if(IsValidMenu(m_Country)) 			DestroyMenu(m_Country);
	if(IsValidMenu(m_Teleport)) 		DestroyMenu(m_Teleport);
	m_Teleport=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_Teleport)){
		SetMenuColumnHeader(m_Teleport, 0, "Location");
		AddMenuItem(m_Teleport,0,"  Los Santos");
		AddMenuItem(m_Teleport,0,"  San Fierro");
		AddMenuItem(m_Teleport,0,"  Las Venturas");
	 	AddMenuItem(m_Teleport,0,"  Desert");
	  	AddMenuItem(m_Teleport,0,"  Country");
	}
	m_LS=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_LS)) {
		SetMenuColumnHeader(m_LS,0,"Los Santos");
		AddMenuItem(m_LS,0,"  Beach");
		AddMenuItem(m_LS,0,"  Mad Doggs");
		AddMenuItem(m_LS,0,"  Groove Street");
		AddMenuItem(m_LS,0,"  Skatepark");
		AddMenuItem(m_LS,0,"  LS Airport");
	}
	m_SF=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_SF)) {
		SetMenuColumnHeader(m_SF,0,"San Fierro");
		AddMenuItem(m_SF,0,"  Wang Cars");
		AddMenuItem(m_SF,0,"  Wheel Arch Angels");
		AddMenuItem(m_SF,0,"  Radio Stations");
		AddMenuItem(m_SF,0,"  SF Airport");
		AddMenuItem(m_SF,0,"  Golden Gate Bridge");
		AddMenuItem(m_SF,0,"  Bayside Marina");
		AddMenuItem(m_SF,0,"  SF Police Station");
	}
	m_LV=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_LV)) {
		SetMenuColumnHeader(m_LV,0,"Las Venturas");
		AddMenuItem(m_LV,0,"  Golf");
		AddMenuItem(m_LV,0,"  Dirtring");
		AddMenuItem(m_LV,0,"  Restricted Area");
		AddMenuItem(m_LV,0,"  Transfender");
		AddMenuItem(m_LV,0,"  LV Police Station");
		AddMenuItem(m_LV,0,"  Pirateship");
	}
	m_Desert=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_Desert)) {
		SetMenuColumnHeader(m_Desert,0,"Desert");
		AddMenuItem(m_Desert,0,"  Verdant Medows");
		AddMenuItem(m_Desert,0,"  Restricted Area");
		AddMenuItem(m_Desert,0,"  The Big Ear");
		AddMenuItem(m_Desert,0,"  El Quebrandos");
		AddMenuItem(m_Desert,0,"  The Sherman Damn");
	}
	m_Country=CreateMenu("~w~Teleport Menu",1,20,200,200);
	if(IsValidMenu(m_Country)) {
		SetMenuColumnHeader(m_Country,0,"Country");
		AddMenuItem(m_Country,0,"  Mount Chilliad Start");
		AddMenuItem(m_Country,0,"  Mount Chilliad Top");
		AddMenuItem(m_Country,0,"  The Panopiction");
		AddMenuItem(m_Country,0,"  Fleisch Factory");
		AddMenuItem(m_Country,0,"  Palomino Creek");
		AddMenuItem(m_Country,0,"  Catalinas House");
		AddMenuItem(m_Country,0,"  RS Hall");
	}
	m_Weather=CreateMenu("Weather",1,430,150,130);
	if(IsValidMenu(m_Weather)){
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_sunny"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_foggy"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_rain"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_storm"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_clouds"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_stormy"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_extremsunny"));
		AddMenuItem(m_Weather,0,GetLanguageString(ServerLanguage(),"txt_weathrandom"));
	}
	//Import Tuner
	m_ImportTuner=CreateMenu("~w~Import~b~Tuner",2,20,200,100);
	if(IsValidMenu(m_ImportTuner)){
		SetMenuColumnHeader(m_ImportTuner, 0, " Item");
		SetMenuColumnHeader(m_ImportTuner, 1, " Price");
		AddMenuItem(m_ImportTuner,0,"  Nos x10");
		AddMenuItem(m_ImportTuner,1,"  1000 $");
		AddMenuItem(m_ImportTuner,0,"  Nos x5");
		AddMenuItem(m_ImportTuner,1,"  500 $");
		AddMenuItem(m_ImportTuner,0,"  Nos x2");
		AddMenuItem(m_ImportTuner,1,"  200 $");
	 	AddMenuItem(m_ImportTuner,0,"  Hydraulics");
		AddMenuItem(m_ImportTuner,1,"  1500 $");
	  	AddMenuItem(m_ImportTuner,0,"  BassBoost");
		AddMenuItem(m_ImportTuner,1,"  100 $");
		AddMenuItem(m_ImportTuner,0,"  > Rims");
		AddMenuItem(m_ImportTuner,1,"  >>");
		AddMenuItem(m_ImportTuner,0,"  > Colors");
		AddMenuItem(m_ImportTuner,1,"  >>");
	}
	m_Rims=CreateMenu("Upgrade",2,20,200,100);
	if(IsValidMenu(m_Rims)){
		SetMenuColumnHeader(m_Rims, 0, " Item");
		SetMenuColumnHeader(m_Rims, 1, " Price");
		AddMenuItem(m_Rims,0,"  Import");
		AddMenuItem(m_Rims,1,"  820 $");
		AddMenuItem(m_Rims,0,"  Ahab");
		AddMenuItem(m_Rims,1,"  1000 $");
		AddMenuItem(m_Rims,0,"  Virtual");
		AddMenuItem(m_Rims,1,"  620 $");
	 	AddMenuItem(m_Rims,0,"  Mega");
		AddMenuItem(m_Rims,1,"  1030 $");
	  	AddMenuItem(m_Rims,0,"  Groove");
		AddMenuItem(m_Rims,1,"  1230 $");
		AddMenuItem(m_Rims,0,"  Classic");
		AddMenuItem(m_Rims,1,"  1620 $");
		AddMenuItem(m_Rims,0,"  Cutter");
		AddMenuItem(m_Rims,1,"  1030 $");
		AddMenuItem(m_Rims,0,"  Rimshine");
		AddMenuItem(m_Rims,1,"  980 $");
		AddMenuItem(m_Rims,0,"  Shadow");
		AddMenuItem(m_Rims,1,"  1100 $");
		AddMenuItem(m_Rims,0,"  Snitch");
		AddMenuItem(m_Rims,1,"  900 $");
	}
	m_Color=CreateMenu("Upgrade",1,20,200,100);
	if(IsValidMenu(m_Color)){
		SetMenuColumnHeader(m_Color, 0, " Color");
		AddMenuItem(m_Color,0,"  Red");
		AddMenuItem(m_Color,0,"  White");
		AddMenuItem(m_Color,0,"  Blue");
	 	AddMenuItem(m_Color,0,"  Yellow");
	  	AddMenuItem(m_Color,0,"  Brown");
		AddMenuItem(m_Color,0,"  Grey");
		AddMenuItem(m_Color,0,"  Black");
		AddMenuItem(m_Color,0,"  Green");
		AddMenuItem(m_Color,0,"  Pink");
		AddMenuItem(m_Color,0,"  Lightblue");
	}
	m_AmmuNation=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_AmmuNation)){
		SetMenuColumnHeader(m_AmmuNation, 0, "Weapon Type");
		AddMenuItem(m_AmmuNation,0,"  Pistole");
		AddMenuItem(m_AmmuNation,0,"  Micro SMG");
		AddMenuItem(m_AmmuNation,0,"  Shotguns");
		AddMenuItem(m_AmmuNation,0,"  Items");
		AddMenuItem(m_AmmuNation,0,"  SMG");
		AddMenuItem(m_AmmuNation,0,"  Rifles");
		AddMenuItem(m_AmmuNation,0,"  Assault rifle");
		AddMenuItem(m_AmmuNation,0,"  Grenades");
		AddMenuItem(m_AmmuNation,0,"  Hand Guns");
		AddMenuItem(m_AmmuNation,0,"  Special");
	}
	m_Pistole=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Pistole)){
		SetMenuColumnHeader(m_Pistole, 0, "Pistole");
		AddMenuItem(m_Pistole,0,"  9mm");
		AddMenuItem(m_Pistole,0,"  9mm Silenced");
		AddMenuItem(m_Pistole,0,"  Desert Eagle");
	}
	m_MicroSMG=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_MicroSMG)){
 		SetMenuColumnHeader(m_MicroSMG, 0, "Micro SMG");
		AddMenuItem(m_MicroSMG,0,"  Tec9");
		AddMenuItem(m_MicroSMG,0,"  Micro SMG");
	}
	m_Shotguns=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Shotguns)){
		SetMenuColumnHeader(m_Shotguns, 0, "Shotguns");
		AddMenuItem(m_Shotguns,0,"  Shotgun");
		AddMenuItem(m_Shotguns,0,"  Sawn Off");
		AddMenuItem(m_Shotguns,0,"  Combat Shotgun");
	}
	m_Items=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Items)){
		SetMenuColumnHeader(m_Items, 0, "Item");
		AddMenuItem(m_Items,0,"  Armour");
		AddMenuItem(m_Items,0,"  Parachute");
		AddMenuItem(m_Items,0,"  Spraycan");
		AddMenuItem(m_Items,0,"  Camera");
		AddMenuItem(m_Items,0,"  Nightvision Goggles");
		AddMenuItem(m_Items,0,"  Infrared Vision");
	}
	m_SMG=CreateMenu("~w~Ammu-Nation",1,30,150,150);
	if(IsValidMenu(m_SMG)){
		SetMenuColumnHeader(m_SMG, 0, "SMG");
		AddMenuItem(m_SMG,0," SMG");
	}
	m_Rifles=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Rifles)){
		SetMenuColumnHeader(m_Rifles, 0, "Rifle");
		AddMenuItem(m_Rifles,0," Cunt Gun");
		AddMenuItem(m_Rifles,0," Sniper Rifle");
	}
	m_Assaultrifle=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Assaultrifle)){
		SetMenuColumnHeader(m_Assaultrifle, 0, "Assault Rifle");
		AddMenuItem(m_Assaultrifle,0," AK-47");
		AddMenuItem(m_Assaultrifle,0," M16");
	}
	m_BigOnes=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_BigOnes)){
		SetMenuColumnHeader(m_BigOnes, 0, "Special");
		AddMenuItem(m_BigOnes,0," Minigun");
		AddMenuItem(m_BigOnes,0," Bazooka");
		AddMenuItem(m_BigOnes,0," Flame Thrower");
	}
	m_HandGuns=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_HandGuns)){
		SetMenuColumnHeader(m_HandGuns, 0, "Hand Guns");
		AddMenuItem(m_HandGuns,0," Baseball");
		AddMenuItem(m_HandGuns,0," Dildo");
		AddMenuItem(m_HandGuns,0," Chainsaw");
		AddMenuItem(m_HandGuns,0," Katana");
		AddMenuItem(m_HandGuns,0," Pool cue");
		AddMenuItem(m_HandGuns,0," Knife");
		AddMenuItem(m_HandGuns,0," Night Stick");
		AddMenuItem(m_HandGuns,0," Golf Club");
	}
	m_Grenade=CreateMenu("~w~Ammu-Nation",1,20,150,150);
	if(IsValidMenu(m_Grenade)){
		SetMenuColumnHeader(m_Grenade, 0, "Grenades");
		AddMenuItem(m_Grenade,0," Grenades");
		AddMenuItem(m_Grenade,0," Tear Gas");
		AddMenuItem(m_Grenade,0," Molotovs");
	}
	m_V=CreateMenu("~w~Vehicle Menu",1,20,150,170);
	if(IsValidMenu(m_V)){
		SetMenuColumnHeader(m_V, 0, "Car Type");
	 	AddMenuItem(m_V,0," Fast Cars");
		AddMenuItem(m_V,0," Bikes");
		AddMenuItem(m_V,0," Planes");
		AddMenuItem(m_V,0," Boats");
		AddMenuItem(m_V,0," Low Rider");
		AddMenuItem(m_V,0," Special");
		AddMenuItem(m_V,0," Other");
	}
	//Fast Car Menu
	m_FastCars=CreateMenu("~w~Fast Cars",1,20,150,150);
	if(IsValidMenu(m_FastCars)){
		for(new i;i<sizeof(g_V_FastCars);i++) {
			if(g_V_FastCars[i]>=400 && g_V_FastCars[i]<=611) {
				AddMenuItem(m_FastCars,0,VehicleNames[g_V_FastCars[i]-400]);
			} else {
				printf("Bad Model ID at FastCars%d [ID %d]",i,g_V_FastCars[i]);
				AddMenuItem(m_FastCars,0,"Bad Model ID");
				DisableMenuRow(m_FastCars,i);
			}
		}
	}
	//Bike Menu
	m_Bikes=CreateMenu("~w~Bikes",1,20,150,150);
	if(IsValidMenu(m_Bikes)){
		for(new i;i<sizeof(g_V_Bikes);i++) {
			if(g_V_Bikes[i]>=400 && g_V_Bikes[i]<=611) {
				AddMenuItem(m_Bikes,0,VehicleNames[g_V_Bikes[i]-400]);
			} else {
				printf("Bad Model ID at V_Bikes%d [ID %d]",i,g_V_Bikes[i]);
				AddMenuItem(m_Bikes,0,"Bad Model ID");
				DisableMenuRow(m_Bikes,i);
			}
		}
	}
	//Aircraft Menu
	m_Planes=CreateMenu("~w~Planes",1,20,150,150);
	if(IsValidMenu(m_Planes)){
		for(new i;i<sizeof(g_V_Planes);i++) {
			if(g_V_Planes[i]>=400 && g_V_Planes[i]<=611) {
				AddMenuItem(m_Planes,0,VehicleNames[g_V_Planes[i]-400]);
			} else {
				printf("Bad Model ID at V_Planes%d [ID %d]",i,g_V_Planes[i]);
				AddMenuItem(m_Planes,0,"Bad Model ID");
				DisableMenuRow(m_Planes,i);
			}
		}
	}
	//Boats Menu
	m_Boats=CreateMenu("~w~Boats",1,20,150,150);
	if(IsValidMenu(m_Boats)){
		for(new i;i<sizeof(g_V_Boats);i++) {
			if(g_V_Boats[i]>=400 && g_V_Boats[i]<=611) {
				AddMenuItem(m_Boats,0,VehicleNames[g_V_Boats[i]-400]);
			} else {
				printf("Bad Model ID at V_Boats%d [ID %d]",i,g_V_Boats[i]);
				AddMenuItem(m_Boats,0,"Bad Model ID");
				DisableMenuRow(m_Boats,i);
			}
		}
	}
	//Special Menu
	m_Special=CreateMenu("~w~Special",1,20,150,150);
	if(IsValidMenu(m_Special)){
		for(new i;i<sizeof(g_V_Special);i++) {
			if(g_V_Special[i]>=400 && g_V_Special[i]<=611) {
				AddMenuItem(m_Special,0,VehicleNames[g_V_Special[i]-400]);
			} else {
				printf("Bad Model ID at V_Special%d [ID %d]",i,g_V_Special[i]);
				AddMenuItem(m_Special,0,"Bad Model ID");
				DisableMenuRow(m_Special,i);
			}
		}
	}
	//Low Rider Menu
	m_LowRider=CreateMenu("~w~Low Rider",1,20,150,150);
	if(IsValidMenu(m_LowRider)){
		for(new i;i<sizeof(g_V_LowRider);i++) {
			if(g_V_LowRider[i]>=400 && g_V_LowRider[i]<=611) {
				AddMenuItem(m_LowRider,0,VehicleNames[g_V_LowRider[i]-400]);
			} else {
				printf("Bad Model ID at V_LowRider%d [ID %d]",i,g_V_LowRider[i]);
				AddMenuItem(m_LowRider,0,"Bad Model ID");
				DisableMenuRow(m_LowRider,i);
			}
		}
	}
	return 1;
}
#if defined DISPLAY_MODE_TD
stock CreatePlayerDraw(playerid) {
	if(!IsPlayerFlag(playerid,PLAYER_FLAG_DRAWAVAILABLE)) {
		PlayerInfo[playerid][td_PlayerDraw]=TextDrawCreate(88,429,"_");
	 	TextDrawLetterSize(PlayerInfo[playerid][td_PlayerDraw], 0.25, 0.9);
	 	TextDrawFont(PlayerInfo[playerid][td_PlayerDraw],2);
		TextDrawSetProportional(PlayerInfo[playerid][td_PlayerDraw],true);
	 	TextDrawSetOutline(PlayerInfo[playerid][td_PlayerDraw], 1);
	 	TextDrawAlignment(PlayerInfo[playerid][td_PlayerDraw], 2);
  		AddPlayerFlag(playerid,PLAYER_FLAG_DRAWAVAILABLE);
		return 1;
	}
	return 0;
}
stock DestroyPlayerDraw(playerid) {
	if(IsPlayerFlag(playerid,PLAYER_FLAG_DRAWAVAILABLE)) {
		TextDrawDestroy(PlayerInfo[playerid][td_PlayerDraw]);
		PlayerInfo[playerid][td_PlayerDraw]=Text:INVALID_TEXT_DRAW;
		DeletePlayerFlag(playerid,PLAYER_FLAG_DRAWAVAILABLE);
		return 1;
	}
	return 0;
}
#endif

stock KickEx(playerid,reason) {
	PlayerInfo[playerid][DisconnectReason]=reason;
	return Kick(playerid);
}
stock BanEx2(playerid,reason) {
	PlayerInfo[playerid][DisconnectReason]=reason;
	return Ban(playerid);
}
stock ResetWeatherUpdate() {
	g_WeatherUpdate=(3+(random(5)))*60;  // ~ 3-7 minutes til next WeatherUpdate
	g_WeatherUpdate_Count=0;
}
#if defined PROFILE_MANUPULATION
public GetProfilEntry(playerid,entry[]) {
	new
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if(udb_Exists(ThePlayer)) {
		return dUserINT(ThePlayer).(entry);
	}
	return 0;
}
public SetProfilEntry(playerid,entry[],digit) {
	new
		ThePlayer[MAX_PLAYER_NAME];
	GetPlayerName(playerid,ThePlayer,sizeof(ThePlayer));
	if(udb_Exists(ThePlayer)) {
		dUserSetINT(ThePlayer).(entry,digit);
		return 1;
	}
	return 0;
}

#endif
#if defined MYSQL
stock gSQL_UpdateUser(nickname[],playerid) {
	#if defined SAVE_POS
	new
	    Float:X,
	    Float:Y,
	    Float:Z;
	GetPlayerPos(playerid,X,Y,Z);
	#endif
	gSQL_SetUserVarAsInteger(nickname,"AdminLevel",PlayerInfo[playerid][AdminLevel]);
	gSQL_SetUserVarAsInteger(nickname,"Money",GetPlayerMoney(playerid));
	gSQL_SetUserVarAsInteger(nickname,"Score",GetPlayerScore(playerid));
	#if defined EXTRA_COMMANDS
	gSQL_SetUserVarAsInteger(nickname,"BankMoney",PlayerInfo[playerid][BankMoney]);
	#endif
	gSQL_SetUserVar(nickname,"Language",GetShortLanguageName(GetPlayerLanguageID(playerid)));
	gSQL_SetUserVarAsInteger(nickname,"Kills",PlayerInfo[playerid][Kills]);
	gSQL_SetUserVarAsInteger(nickname,"Deaths",PlayerInfo[playerid][Deaths]);
	gSQL_SetUserVarAsInteger(nickname,"TimesSpawned",PlayerInfo[playerid][SpawnCount]);
	PlayerInfo[playerid][iSeconds] += floatround(((GetTickCount() - PlayerInfo[playerid][tickConnect] ) / 1000));
	gSQL_SetUserVarAsInteger(nickname,"OnlineTime",PlayerInfo[playerid][iSeconds]);

	#if defined SAVE_POS
	gSQL_SetUserVarAsFloat(nickname,"X",X);
	gSQL_SetUserVarAsFloat(nickname,"Y",Y);
	gSQL_SetUserVarAsFloat(nickname,"Z",Z);
	#endif
	return 1;
}
#endif
#if defined irc_gAdmin
public IRCJoin() {
	INI_Open(generalconfig);
	INI_ReadString(EchoChan,"IRC_Channel");
	INI_ReadString(EchoChannelPassword,"IRC_ChannelPassword");
	INI_ReadString(Botname,"IRC_Botname");
	INI_ReadString(Botpw,"IRC_Botpassword");
	INI_ReadString(EchoServer,"IRC_Server");
	EchoPort=INI_ReadInt("IRC_ServerPort");
	INI_Close();
	EchoBot=IRC_Connect(EchoServer,EchoPort, Botname, "SA:MP Bot", "Bot");
	return printf("IRC Bot Connected to %s (Bot %d)\n",EchoChan,EchoBot);
}
public IRC_Reconnect() {
	KillTimer(t_IRCReconnect);
	printf("[IRC] Reconnect for Bot %s!Lost Connection",Botname);
	IRCJoin();
	return 1;
}
public IRC_OnConnect(botid)
{
	printf("[IRC] OnConnect: Bot ID %d connected!", botid);
	format(s,sizeof(s),"NickServ :IDENTIFY %s",Botpw);
	IRC_SendRaw(botid,s);
	IRC_JoinChannel(EchoBot,EchoChan,EchoChannelPassword,600); // Able to join passworded channel
	IRC_SetMode(botid, Botname, "+B");
	return 1;
}
public IRC_OnDisconnect(botid)
{
	printf("[IRC] OnDisconnect: Bot ID %d disconnected!", botid);
	if(!g_bShutDown) { // Invalid Disconnect reason
		t_IRCReconnect = SetTimer("IRC_Reconnect",10*1000,false);
	}
	return 1;
}
public IRC_OnJoinChannel(botid, channel[])
{
	printf("[IRC] OnJoinChannel: Bot ID %d joined channel %s!", botid, channel);
	format(s,sizeof(s),"Hi,I'm %s your SA:MP IRC Bot",Botname);
	IRC_Say(botid, EchoChan,s);
	return 1;
}

public IRC_OnUserSay(botid, recipient[], user[], host[], message[])
{
	printf("[IRC] OnUserSay: %s: %s", user, message);
	if (!strcmp(recipient, Botname)) // Someone sent the first bot a private message
	{
		IRC_Say(botid, user, "Please,don't PM me!");
	}
	return 1;
}
forward irccmd_id(botid, channel[], user[], host[], params[]);
forward irccmd_say(botid, channel[], user[], host[], params[]);
forward irccmd_ban(botid, channel[], user[], host[], params[]);
forward irccmd_kick(botid, channel[], user[], host[], params[]);
forward irccmd_cmds(botid, channel[], user[], host[], params[]);
forward irccmd_users(botid, channel[], user[], host[], params[]);

public irccmd_id(botid, channel[], user[], host[], params[]) {
#pragma unused user
	new
		giveid;
	if(sscanf(params, "u",giveid)) { }
	else if(giveid == INVALID_PLAYER_ID) {
		format(s,sizeof(s),GetLanguageString(ServerLanguage(),"txt_id2"),params);
		IRC_Say(botid, channel, s);
	}
	else {
		format(s,sizeof(s),GetLanguageString(ServerLanguage(),"txt_id3"),PlayerName(giveid),giveid);
		IRC_Say(botid, channel, s);
	}
	return 1;
}
public irccmd_say(botid, channel[], user[], host[], params[]) {
	if(isnull(params)) {
		IRC_Say(botid, user, "Input text is missing");
		return 1;
	}
	if (!IRC_IsVoice(botid,channel,user)) {
	    IRC_Say(botid,user,"You need to be an at least voice-rights to use this feature");
	    return 1;
	}
	if(strlen(params) > 128) {
		IRC_Say(botid, user, "This message is too long,limit is 128 chars");
		return 1;
	}
	/* by Incognito to replace %-sign */
	new
	    sBig[128+32+16],
		pos = -1;
	while (params[++pos]) // Search for an illegal character
	{
		if (params[pos] == '%')
		{
			params[pos] = ' ';
		}
	}
	format(sBig,sizeof(sBig), "%s on IRC: %s", user, params);
	WriteLog(clearlog,sBig);
	SendClientMessageToAll(COLOR_WHITE, sBig);
	format(sBig,sizeof(sBig), "2*** 7%s1\2; on IRC: 2%s", user, params);
	IRC_Say(botid, channel, sBig);
	return 1;
}
public irccmd_users(botid, channel[], user[], host[], params[]) {
	#pragma unused params,channel
	if (!IRC_IsVoice(botid,channel,user)) { // to prevent flood
	    IRC_Say(botid,user,"You need to be an at least voice-rights to use this feature");
	    return 1;
	}
	if((g_iLastIRCTick + (90*1000)) > GetTickCount() ) {
	    IRC_Say(botid,user,"!users is blocked! Wait to re-use it again");
	    return 1;
	}
	IRC_Say(botid, user,"2--------------------------------------------------");
	IRC_Say(botid,user," ID       Name                        Admin	     Score");
	foreach(i) {
		format(s,sizeof(s), "5%3d       7%24s   4 %4s  3 %9d",i,PlayerName(i),PlayerInfo[i][AdminLevel]>1 ? yes :no, GetPlayerScore(i));
		IRC_Say(botid, user, s);
	}
	IRC_Say(botid, user,"2--------------------------------------------------");
    g_iLastIRCTick = GetTickCount();
	return 1;
}
public irccmd_cmds(botid, channel[], user[], host[], params[]) {
	#pragma unused params,user
	IRC_Say(botid, channel,"2-------------------------------------");
	IRC_Say(botid, channel,"10 !id , !say , !users, !kick ,!ban");
	return 1;
}
public irccmd_kick(botid, channel[], user[], host[], params[]) {
	if (!IRC_IsOp(botid,channel,user)) {
	    IRC_Say(botid,user,"You need to be at least Operator-rights to use this feature");
	    return 1;
	}
	new
		pid;
	if(sscanf(params, "u",pid)) {
		IRC_Say(botid,channel,"Invalid Username");
	}
	else if(pid == INVALID_PLAYER_ID) {
		IRC_Say(botid,channel,"Invalid Username");
	}
	else if(PlayerInfo[pid][AdminLevel]>=2) {
	 	IRC_Say(botid,user,"You are trying to kick an admin,thats not possible!");
	}
	else if(pid!=-2) {
			format(s, sizeof(s), "3*** \2;%s\2; has been kicked by7 %s [IRC].",PlayerName(pid), user);
			IRC_Say(botid,channel,s);
			format(s, sizeof(s), "*** %s has been kicked by %s [IRC]",PlayerName(pid), user);
			SendClientMessageToAll(COLOR_WHITE,s);
			Kick(pid);
			return true;
	}
	else {
	 	format(s, sizeof(s), "3*** Found more than 1 player with \2;%s\2; in his name", params);
	 	IRC_Say(botid,user,s);
 	}
	return true;
}
public irccmd_ban(botid, channel[], user[], host[], params[]) {
	if (!IRC_IsOp(botid,channel,user)) {
	    IRC_Say(botid,user,"You need to be at least Operator-rights to use this feature");
	    return 1;
	}
	new
		pid;
	if(sscanf(params, "u",pid)) {
		IRC_Say(botid,channel,"Invalid Username");
	}
	else if(pid == INVALID_PLAYER_ID) {
		IRC_Say(botid,channel,"Invalid Username");
	}
	else if(PlayerInfo[pid][AdminLevel]>=2) {
	 	IRC_Say(botid,user,"You are trying to ban an admin,thats not possible!");
	}
	else if(pid!=-2) {
			format(s, sizeof(s), "3*** \2;%s\2; has been banned by7 %s [IRC].",PlayerName(pid), user);
			IRC_Say(botid,channel,s);
			format(s, sizeof(s), "*** %s has been banned by %s [IRC]",PlayerName(pid), user);
			SendClientMessageToAll(COLOR_WHITE,s);
			Kick(pid);
			return true;
	}
	else {
	 	format(s, sizeof(s), "3*** Found more than 1 player with \2;%s\2; in his name", params);
	 	IRC_Say(botid,user,s);
 	}
	return true;
}
#endif
/*
	- Old and Slow version
stock ConvertSec(secs,&sec,&min,&hour) {
	sec = 0;
	min = 0;
	hour = 0;
    while(secs >= 60) {
		min++;
		secs-=60;
		if(min>=60) {
		    min-=60;
		    hour++;
		}
	}
    sec=secs;
}
*/
stock ConvertSec(secs,&sec,&min,&hour) {
	new
	    rest;
	sec = 0;
	min = 0;
	hour = 0;
	hour = (secs / (60*60));
	rest = (secs % (60*60));
	min  = (rest / 60);
	sec = (rest % 60);
	return 1;
}


