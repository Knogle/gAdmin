/*
 $
 $ This include is part of gAdmin
 $
 $ gAdmin by :				Goldkiller (gta-goldkiller[at]web.de)
 $ gSQL :			        MadniX & Goldkiller
 $ Latest Update :			8/ 10/ 2009
 $ gAdmin Version :			1.1
 $ Visit :                  www.san-vice.de.vu
*/

#if defined _gSQL_included
	#endinput
#endif
#define _gSQL_included
#pragma library gSQL

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "root"
#define MYSQL_PWD ""
#define MYSQL_DB "gAdmin"

#define MYSQL_USER_TABLE "accounts"
#define MYSQL_CONFIG_TABLE "config"

#include <a_samp>
#include <mysql>
/*---- Language ---*/
#include <gAdmin\gLanguageV2>
//-------------------------------------------------------------------------------
stock InitSQL()
{
	if(mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PWD,MYSQL_DB))
	{
	    new
	        sTmp[128],
	        sqlcmd[512+256];
		if(!mysql_select_db(MYSQL_DB)) 
		{
			format(sqlcmd, sizeof(sqlcmd), "CREATE DATABASE `%s`", MYSQL_DB);
			mysql_query(sqlcmd);
			format(sTmp, sizeof(sTmp), "Database '%s' created...", MYSQL_DB);
			Log(sTmp);
			if(mysql_select_db(MYSQL_DB)) {
			    //
			}
			else {
			    format(sTmp,sizeof(sTmp),"Selecting databse '%s' failed",MYSQL_DB);
			}
		}
		if(!CheckTable(MYSQL_USER_TABLE))
		{
			Log("Table `" #MYSQL_USER_TABLE "` does not exist...");
			sqlcmd[0]='\0';

			strcat(sqlcmd, "CREATE TABLE `" #MYSQL_USER_TABLE "` (", 	sizeof(sqlcmd));
			strcat(sqlcmd, "`ID` INT NOT NULL AUTO_INCREMENT ,", 		sizeof(sqlcmd));
			strcat(sqlcmd, "`Nickname` VARCHAR( 24 ) NOT NULL ,",		sizeof(sqlcmd));
			strcat(sqlcmd, "`Password_hash` INT NOT NULL ,",			sizeof(sqlcmd));
			strcat(sqlcmd, "`RegDate` VARCHAR( 12 ) NOT NULL ,",			sizeof(sqlcmd));
			strcat(sqlcmd, "`AdminLevel` INT NOT NULL DEFAULT '1',", 	sizeof(sqlcmd));
			strcat(sqlcmd, "`RegIP` VARCHAR( 16 ) NOT NULL ,", 			sizeof(sqlcmd));
			strcat(sqlcmd, "`IP` VARCHAR( 16 ) NOT NULL ,",				sizeof(sqlcmd));
			format(sTmp, sizeof(sTmp), "\
							`Language` VARCHAR( 3 ) NOT NULL DEFAULT '%s',", GetShortLanguageName(ServerLanguage()));
			strcat(sqlcmd, sTmp, sizeof(sqlcmd));
			strcat(sqlcmd, "`Trusted` BOOL NULL DEFAULT '0',",			sizeof(sqlcmd));
			strcat(sqlcmd, "`VIP` BOOL NULL DEFAULT 'false',",			sizeof(sqlcmd));
			strcat(sqlcmd, "`Banned` BOOL NULL DEFAULT '0',", 			sizeof(sqlcmd));
			strcat(sqlcmd, "`TimeBan` VARCHAR( 12 ) NULL DEFAULT '0',", sizeof(sqlcmd));
			strcat(sqlcmd, "`Money` INT NULL DEFAULT '0',", 			sizeof(sqlcmd));
			strcat(sqlcmd, "`Score` INT NULL DEFAULT '0',", 			sizeof(sqlcmd));
			strcat(sqlcmd, "`Deaths` INT NULL DEFAULT '0',", 			sizeof(sqlcmd));
			strcat(sqlcmd, "`Kills` INT NULL DEFAULT '0',", 			sizeof(sqlcmd));
			// Not always needed but we create the table with it
			strcat(sqlcmd, "`BankMoney` INT NULL DEFAULT '0',", 		sizeof(sqlcmd));
			// -- -- --
			strcat(sqlcmd, "`TimesSpawned` INT NULL DEFAULT '0',", 		sizeof(sqlcmd));
			strcat(sqlcmd, "`OnlineTime` INT NULL DEFAULT '0',", 		sizeof(sqlcmd));
			// Not always needed but we create the table with it
			strcat(sqlcmd, "`X` FLOAT DEFAULT '0.0',", 					sizeof(sqlcmd));
			strcat(sqlcmd, "`Y` FLOAT DEFAULT '0.0',", 					sizeof(sqlcmd));
			strcat(sqlcmd, "`Z` FLOAT DEFAULT '0.0',", 					sizeof(sqlcmd));
			strcat(sqlcmd, "PRIMARY KEY ( `ID` ) , UNIQUE ( `Nickname` ))",sizeof(sqlcmd));
			mysql_query(sqlcmd);
			Log("Table `" #MYSQL_USER_TABLE "` created!");
		}
		Log("Successfully connected... all fine!");
		return 1;
	}
	else 
	{	
		Log("Unable to connect!");
		return 0;
	}
}
stock CloseSQL() {
	mysql_close();
	Log("Closed SQL connection");
	return 1;
}

stock gSQL_ExistEntry(table[],where[],is[])
{
    new
        sqlcmd[256];
	format(sqlcmd, sizeof(sqlcmd), "SELECT * FROM `%s` WHERE `%s` = '%s' LIMIT 1;",table,where,is);
    mysql_query(sqlcmd);
	mysql_store_result();
	if (!mysql_num_rows()) {
	    return 0;
	}
	return 1;
}

stock gSQL_AddUser(nickname[], pwd[])
{
    new
		sTmp[256],
        sqlcmd[256+128];
	strcat(sqlcmd, "INSERT INTO `" #MYSQL_DB "`.`" #MYSQL_USER_TABLE "` (",sizeof(sqlcmd));
	strcat(sqlcmd,"`ID` ,`Nickname` ,`Password_hash` ,`AdminLevel` ,`RegIP` ,`IP` ,`Language` ,`Trusted` ,`VIP` ,`Banned` ,`TimeBan` ,`Money` ,`Deaths` ,`Kills` ,`BankMoney` ,`TimesSpawned`, `X`, `Y`, `Z`)",sizeof(sqlcmd));
	format(sTmp, sizeof(sTmp), "VALUES (NULL , '%s', '%i', '1', '0.0.0.0', '0.0.0.0', '%s', 'false', 'false', 'false', '0', '0', '0', '0', '0', '0','0.0','0.0','0.0');", nickname, num_hash(pwd), GetShortLanguageName(ServerLanguage()));
	strcat(sqlcmd, sTmp,sizeof(sqlcmd));
	if(mysql_query(sqlcmd)) {
	    sTmp[0]='\0';
		format(sTmp, sizeof(sTmp), "User `%s` added to Database!", nickname);
		Log(sTmp);
	}
	return 1;
}

stock gSQL_DeleteEntry(table[],where[],is[])
{
    new
        sqlcmd[128];
	format(sqlcmd, sizeof(sqlcmd), "DELETE FROM `%s` WHERE `%s` = '%s' LIMIT 1;",table,where,is);
	if(mysql_query(sqlcmd)) {
		format(sqlcmd, sizeof(sqlcmd), "Removed entry `%s` from Database!", where);
		Log(sqlcmd);
	}
	return 1;
}

stock gSQL_GetVar(column[],table[],where[],is[])
{
    new
        sqlcmd[128+64]="Error (Cant connect to MYSQL Server)";
	if(!mysql_ping()) {
		format(sqlcmd, sizeof(sqlcmd), "SELECT `%s` FROM `%s` WHERE `%s` = '%s' LIMIT 1;",column,table,where,is);
		mysql_query(sqlcmd);
		mysql_store_result();
		if (!mysql_num_rows()) {
		    format(sqlcmd,sizeof(sqlcmd),"Unable to find '%s'",where);
		    //Log(sqlcmd);
			return sqlcmd;
		}
		mysql_fetch_row(sqlcmd);
		return sqlcmd;
	}
	Log("Unable to find mysql server!");
	return sqlcmd;
}

stock gSQL_GetVarAsInteger(column[],table[],where[],is[])
{
	return strval(gSQL_GetVar(column,table,where,is));
}
	
stock gSQL_GetVarAsFloat(column[],table[],where[],is[])
{
	return floatval(gSQL_GetVar((column,table,where,is));
}

stock gSQL_SetVar(table[],column[],var[],where[],is[])
{
	if(!mysql_ping()) {
	    new
	        sqlcmd[256];
		format(sqlcmd, sizeof(sqlcmd), "UPDATE `%s` SET %s = '%s' WHERE `%s` = '%s' LIMIT 1;",table,column,var,where,is);
		return mysql_query(sqlcmd);
	}
	Log("Unable to find mysql server!");
	return 0;
}

stock gSQL_SetVarAsInteger(table[],column[],var,where[],is[])
{
    new
        sTmp[64];
	format(sTmp,sizeof(sTmp),"%d",var);
	return gSQL_SetVar(table,column,sTmp,where,is);
}

stock gSQL_SetVarAsFloat(table[],column[],Float:var,where[],is[],precision = 5)
{
    new
        sTmp[64];
	format(sTmp,sizeof(sTmp),"%.*f",precision,var);
	return gSQL_SetVar(table,column,sTmp,where,is);
}

stock CheckTable(table[])
{
    new
        sqlcmd[256];
	format(sqlcmd, sizeof(sqlcmd), "SHOW TABLES FROM `%s`", MYSQL_DB);
	mysql_query(sqlcmd);
	mysql_store_result();
	for (new i = 1,j = mysql_num_rows() ; i <= j ; i++)
	{
		mysql_fetch_row(sqlcmd);
		if (strcmp(sqlcmd, table, true)==0) return 1;
	}
	return 0;
}

	

stock Log(text[])
{
	return printf("-- gSQL: %s", text);
}
public OnMysqlQuery(resultid, spareid, MySQL:connection)
{
    //mysql_free_result(connection);
	return 1;
}
/* User specific functions , based on others */
//-------------------------------------------------------------------------------
stock num_hash(buf[]) {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}

// -- Misc

#define gSQL_DeleteUser(%1) \
    gSQL_DeleteEntry(MYSQL_USER_TABLE,"Nickname",%1)

#define gSQL_ExistUser(%1) \
    gSQL_ExistEntry(MYSQL_USER_TABLE,"Nickname",%1)
    
// -- Get
#define gSQL_GetUserVar(%1,%2) \
	gSQL_GetVar(%2,MYSQL_USER_TABLE,"Nickname",%1)

#define gSQL_GetUserVarAsInteger(%1,%2) \
	gSQL_GetVarAsInteger(%2,MYSQL_USER_TABLE,"Nickname",%1)

#define gSQL_GetUserVarAsFloat(%1,%2) \
	gSQL_GetVarAsFloat(%2,MYSQL_USER_TABLE,"Nickname",%1)

// -- Set

#define gSQL_SetUserVar(%1,%2,%3) \
	gSQL_SetVar(MYSQL_USER_TABLE,%2,%3,"Nickname",%1)

#define gSQL_SetUserVarAsInteger(%1,%2,%3) \
	gSQL_SetVarAsInteger(MYSQL_USER_TABLE,%2,%3,"Nickname",%1)

#define gSQL_SetUserVarAsFloat(%1,%2,%3) \
	gSQL_SetVarAsFloat(MYSQL_USER_TABLE,%2,%3,"Nickname",%1)


