/*

 Note: 				Don't use these functions !

 I have added some functions to directly get the AdminLevel from gAdmin
 without taking information off the Account.
 
 	GetPlayergAdminLevel(playerid);
 	IsPlayergAdmin(playerid);
 	
 You can call these functions via CallRemoteFunction() to get the information you need!
 Example:
 - - - - - - - - - - - - - - - - - - - - - - -
 	new
	    gAdmin_Level;
	gAdmin_Level=CallRemoteFunction("GetPlayergAdminLevel","d",playerid);
	printf("Player ID's %d gAdmin Level is %d",playerid,gAdmin_Level);
 - - - - - - -
 or:
 - - - - - - -
	new
	    bool:bIsgAdmin;
	bIsgAdmin=CallRemoteFunction("IsPlayergAdmin","d",playerid);
	if(bIsgAdmin) {
	    printf("Player ID %d is an gAdmin!",playerid);
	}
	else {
	    printf("Player ID %d is NOT an gAdmin!",playerid);
	}
 - - - - - - - - - - - - - - - - - - - - - - -

 $ This include is Part of gAdmin
 $ gAdmin by :				Goldkiller (gta-goldkiller[at]web.de)
 $ Latest Update :			14/ 2/ 2009
 $ gAdmin Version :			1.1.1
 $ Visit :                  www.san-vice.de.vu
*/


#if defined _ExtgAdmin_included
	#endinput
#endif
#define _ExtgAdmin_included
#pragma library ExtgAdmin

#include <a_samp>
#include <gAdmin\dfiles>

stock IsPlayergAdmin(playerid) {
	new
		ThePlayer[MAX_PLAYER_NAME],
		lev;
	GetPlayerName(playerid,ThePlayer,MAX_PLAYER_NAME);
	lev=dUserINT(ThePlayer).("AdminLevel");
	return (lev>=2);
}

stock IsPlayergAdminLevel(playerid, level) {
	new
		ThePlayer[MAX_PLAYER_NAME],
		lev;
	GetPlayerName(playerid,ThePlayer,MAX_PLAYER_NAME);
	lev=dUserINT(ThePlayer).("AdminLevel");
	return (lev>=level);
}

stock GetPlayergAdminLevel(playerid) {
	new
		ThePlayer[MAX_PLAYER_NAME],
		lev;
	GetPlayerName(playerid,ThePlayer,MAX_PLAYER_NAME);
	lev=dUserINT(ThePlayer).("AdminLevel");
	return lev;
}
#pragma unused ret_memcpy
