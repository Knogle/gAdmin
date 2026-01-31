/*
 $
 $ This include is part of gAdmin
 $
 $ gAdmin by :				Goldkiller ( gta-goldkiller[at]web.de )
 $ Latest Update :			5/ 5/ 2011
 $ gAdmin Version :			1.3.1
 $ Visit :                  www.san-vice.de.vu
*/
/*
	native SendClientLanguageMessage(playerid,color,put[], va_args<>);
	native SendClientFormatMessage(playerid,color,put[], va_args<>);
	native SendClientLanguageMessageToAll(color,put[], va_args<>);
	native SendClientPreLanguageMessage(playerid,color);
	native ClearLanguageMessages();
	native SendClientPreLanguageMessages(color);
	native CreateClientLanguageMessage(Language:languageid,indentifier[], va_args<>);
	native CreateClientLanguageMessages(indentifier[], va_args<>);
*/


stock SendClientLanguageMessage(playerid, color, input[], va_args<>)
{

    new
		Language:langid = GetPlayerLanguageID(playerid),
        out[128];
	strcpy(out, GetLanguageString(langid,input) ,MAX_STRING);
    va_format( LanguageString(langid) , SIZELanguageString , out, va_start<3>);
    return SendClientMessage(playerid, color, LanguageString(langid));

}

stock SendClientFormatMessage(playerid, color, input[], va_args<>)
{
    new
        out[128];
    va_format(out, sizeof (out), input, va_start<3>);
    return SendClientMessage(playerid, color, out);
}
stock SendClientLanguageMessageToAll(color,put[], va_args<>) {
    new
        out[128];
	for(new Language:i ; _:i < Language_Count ; _:i++) {
	    strcpy(out, GetLanguageString(i,put), MAX_STRING);
	    va_format( LanguageString(i) , SIZELanguageString , out, va_start<2>);
	}
	foreach(i) {
	    SendClientMessage(i,color, LanguageString( GetPlayerLanguageID(i) ) );
	}
	return 1;
}

#define SendClientPreLanguageMessage(%1,%2) \
	SendClientMessage(%1,%2,LanguageString(GetPlayerLanguageID(%1)))

#define ClearLanguageMessages() \
	for(new Language:i;_:i<Language_Count;_:i++) sLanguagestring[i][0]='\0';

stock SendClientPreLanguageMessages(color) {
	foreach(i) {
		SendClientMessage(i,color,LanguageString(GetPlayerLanguageID(i)));
	}
	return 1;
}
stock CreateClientLanguageMessage( Language:languageid,put[], va_args<>) {
    new
        out[128];
    strcpy(out, GetLanguageString(languageid,put), MAX_STRING);
    va_format( LanguageString(languageid) , SIZELanguageString , out, va_start<2>);
	return 1;
}
stock CreateClientLanguageMessages( put[], va_args<>) {
    new
        out[128];
	for(new Language:i ; _:i < Language_Count ; _:i++) {
	    strcpy(out, GetLanguageString(i,put), MAX_STRING);
	    va_format( LanguageString(i) , SIZELanguageString , out, va_start<1>);
	}
	return 1;
}

