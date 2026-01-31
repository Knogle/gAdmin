/*
 $
 $ This include is part of gAdmin
 $
 $ gAdmin by :				Goldkiller ( gta-goldkiller[at]web.de )
 $ Latest Update :			5/ 5/ 2011
 $ gAdmin Version :			1.3.1
 $ Visit :                  www.san-vice.de.vu
*/

#if defined _gLanguage_included
	#endinput
#endif
#define _gLanguage_included
#pragma library gLanguage

#define MAX_LANGUAGES 8   // Dont have more language by default at the moment

#define MAX_POINTER_ERROR 5
#define SMALL_LEN 5
#define LONG_LEN 24
#define EXT_LEN 4
#define PATH "gAdmin Language/"

#define MAX_IDENTIFIER_LEN 20
#define MAX_ENTRY_LEN 128    // Because of maximal len of a message in sa:mp chatbox
#define MAX_LANGUAGE_ENTRYS 325

#define INVALID_POINTER (-1)

new LanguageError[MAX_ENTRY_LEN] = "Error in Language ID!";
new sVar[MAX_ENTRY_LEN];
new
	lastpointer[MAX_ENTRY_LEN],
	/* Those messages won't be LanguageSpecific , atleast not in gAdmin*/
	on[10],
	off[10],
	yes[10],
	no[10];

enum e_Text {
    sIdentifier[MAX_IDENTIFIER_LEN],
    hashIdentifier,
	sText[MAX_ENTRY_LEN],
}
enum e_Language {
	sShorttext[SMALL_LEN],
	sLongtext[LONG_LEN],
	sExtension[EXT_LEN],
	iEntrys
}

new LanguageInfo[Language:MAX_LANGUAGES][e_Language];
new sLanguagestring[Language:MAX_LANGUAGES][MAX_ENTRY_LEN + 64];

new
	g_PointerErrors,
	LanguageTable[Language:MAX_LANGUAGES][MAX_LANGUAGE_ENTRYS][e_Text],
	Language_Count,
   	Language:LanguageID[MAX_PLAYERS],
   	Language:def_printlanguage=Language:0;

#define GetServerLanguage() \
	(def_printlanguage)

#define ServerLanguage() \
	GetServerLanguage()
#define SetServerLanguage(%1) \
	(def_printlanguage=%1)
	
#define GetShortLanguageName(%1) \
	(LanguageInfo[%1][sShorttext])

#define SetShortLanguageName(%1,%2) \
	(format(LanguageInfo[%1][sShorttext],SMALL_LEN,%2))

#define GetLanguageName(%1) \
	(LanguageInfo[%1][sLongtext])

#define SetLanguageName(%1,%2) \
	(format(LanguageInfo[%1][sLongtext],LONG_LEN,%2))

#define GetLanguageExtension(%1) \
	(LanguageInfo[%1][sExtension])

#define LanguageString(%1) \
	(sLanguagestring[%1])

#define SIZELanguageString \
	(MAX_ENTRY_LEN + 64)

#define SetLanguageExtension(%1,%2) \
	(format(LanguageInfo[%1][sExtension],EXT_LEN,%2))

stock Language:GetPlayerLanguageID(playerid) {
	return LanguageID[playerid];
}

stock SetPlayerLanguageID(playerid,Language:LangID) {
	(LanguageID[playerid]=LangID);
}

#define SetDefaultPlayerLanguageID(%1,%2) \
	(LanguageID[%1]=%2)

stock IsValidLanguageID(Language:languageid) {
	if((_:languageid < 0 || _:languageid > Language_Count-1)) return 0;
	return 1;
}
	

stock Language:AddLanguage(LangShort[SMALL_LEN],LangNormal[LONG_LEN],FileExtension[EXT_LEN]) {
	if(Language_Count >= MAX_LANGUAGES) {
		printf("[Error] Can't add more Languages (%s)",LangNormal);
		return Language:-1;
	}
	new
	    check[32 + LONG_LEN + 1 + EXT_LEN];
	format(check,sizeof(check),"%s%s.%s",PATH,LangNormal,FileExtension);
	if(!fexist(check)) {
		printf("[Error] File '%s' doesn't exist!",check);
		return Language:-2;
	}
	SetShortLanguageName(Language:Language_Count,LangShort);
	SetLanguageName(Language:Language_Count,LangNormal);
	SetLanguageExtension(Language:Language_Count,FileExtension);
	//printf(" * Added Language! %s.%s [%s] ID:%d",LangNormal,FileExtension,LangShort,Language_Count);
	Language_Count++;
	return Language:(Language_Count-1);
}
stock LoadLanguageFile(Language:languageid) {
	if(!IsValidLanguageID(languageid)) {
	    return 0;
	}
	new
		File:LFile,
		v[MAX_ENTRY_LEN+MAX_IDENTIFIER_LEN+5];
	format(v,sizeof(v),"%s%s.%s",PATH,GetLanguageName(languageid),GetLanguageExtension(languageid));
	LanguageInfo[languageid][iEntrys]=0;
	LFile=fopen(v,io_read);
	if(!LFile) {
		print("- Error - Filepath not valid");
		return 0;
	}
	new
		entry,
		pos;
	while (fread(LFile,v,sizeof(v))){
		if(v[0]==';') { // comments,skip them...
		    continue;
		}
		if(MAX_LANGUAGE_ENTRYS <= LanguageInfo[languageid][iEntrys]) {
		    printf("[Error] Language Entrys of %s (%d) exceed the limit of %d Entrys",GetLanguageName(languageid),_:languageid,MAX_LANGUAGE_ENTRYS);
		    return 1;
		}
	    StripNewLine(v);
	    if(!v[0]) {
	        continue;
		}
	    pos = strfind(v,"=",true,0);
		entry=LanguageInfo[languageid][iEntrys];
		LanguageTable[languageid][entry][sText][0]='\0';
		LanguageTable[languageid][entry][sIdentifier][0]='\0';
		LanguageTable[languageid][entry][hashIdentifier] = 0;
		
        strcpy(LanguageTable[languageid][entry][sText],v[pos+1],MAX_ENTRY_LEN);
        strdel(v,pos,sizeof(v));
        strcpy(LanguageTable[languageid][entry][sIdentifier],v,MAX_IDENTIFIER_LEN);
        LanguageTable[languageid][entry][hashIdentifier] = bernstein(v);
        LanguageInfo[languageid][iEntrys]++;
	}
	printf(" * Loaded Language file %s: %d (ID: %d)",GetLanguageName(languageid),LanguageInfo[languageid][iEntrys],_:languageid);
	fclose(LFile);
	return 1;
}
stock GetLanguageString(Language:languageid,iden[]) {
	if(!IsValidLanguageID(languageid)) {
	    return LanguageError;
	}
	new
	    _hash,
	    i,
	    pointer = INVALID_POINTER;
	sVar[0]='\0';
	_hash = bernstein(iden);
	while(LanguageTable[languageid][i][hashIdentifier]) {
	    if(_hash == LanguageTable[languageid][i][hashIdentifier]) {
		    if(!strcmp(iden,LanguageTable[languageid][i][sIdentifier],true,MAX_IDENTIFIER_LEN)) {
		        lastpointer[0]='\0';
				strcpy(lastpointer,sVar,sizeof(lastpointer));
				strcpy(sVar,LanguageTable[languageid][i][sText],MAX_ENTRY_LEN);
				return sVar;
			}
	    }
	    i++;
	}
	if(pointer==INVALID_POINTER) {
	    // Maybe send the message in DEFAULT-LANGUAGE ?
	    {
	        languageid = ServerLanguage();
	        i = 0;
			while(LanguageTable[languageid][i][hashIdentifier]) {
			    if(_hash == LanguageTable[languageid][i][hashIdentifier]) {
				    if(!strcmp(iden,LanguageTable[languageid][i][sIdentifier],true,MAX_IDENTIFIER_LEN)) {
				        lastpointer[0]='\0';
						strcpy(lastpointer,sVar,sizeof(lastpointer));
						strcpy(sVar,LanguageTable[languageid][i][sText],MAX_ENTRY_LEN);
						return sVar;
					}
			    }
			    i++;
			}
		}
		g_PointerErrors++;
		format(sVar,sizeof(sVar),"Error in pointer,no identifier '%s'!(%d - %d)",iden,g_PointerErrors,LanguageInfo[languageid][iEntrys]);
		WriteLog(Dev_Log,sVar);
		print(sVar);
		if(g_PointerErrors == 1 ) {
		    i = 0;
			while(i < LanguageInfo[languageid][iEntrys]) {
				i++;
			}
		    printf("Last working pointer : iden = '%s','%s'",iden,lastpointer);
		}
		if(g_PointerErrors >= MAX_POINTER_ERROR) {
		    ReloadLanguages();
		}
		return sVar;
	}
	return sVar;
}
stock LoadBasicText() {
	format(on,sizeof(on),GetLanguageString(ServerLanguage(),"txt_on"));
	format(off,sizeof(off),GetLanguageString(ServerLanguage(),"txt_off"));
	format(yes,sizeof(yes),GetLanguageString(ServerLanguage(),"txt_yes"));
	format(no,sizeof(no),GetLanguageString(ServerLanguage(),"txt_no"));
	return 1;
}
stock ReloadLanguages() {
	new
	    i;
	for(new Language:j;_:j<Language_Count;_:j++) {
	    for( i = 0 ; i < MAX_LANGUAGE_ENTRYS ; i++) {
	    	LanguageTable[j][i][sIdentifier][0]='\0';
	    	LanguageTable[j][i][hashIdentifier]=0;
	    	LanguageTable[j][i][sText][0]='\0';
	    }
		LoadLanguageFile(j);
	}
	g_PointerErrors=0;
	return 1;
}
#include <gAdmin\y_va.inc>
#include <gAdmin\gFormat.inc>

