/*
	dfiles.inc or DUDB.inc,DINI.inc & Dutils.inc
	are made by:Dracoblue (http://www.dracoblue.net/)
	
	Some functions have been removed
	or replaced by more efficient ones.
	
	DIni Version	: 	1.6
	DUDB Version	:   2.4
	DUtils Version	:   1.9
*/
/*
 *            DUtils functions 1.9
 *       (c) Copyright 2006-2007 by DracoBlue
 *
 * @author    : DracoBlue (http://dracoblue.com)
 * @date      : 8th April 2006
 * @update    : 21st June. 2007
 *
 * This file is provided as is (no warranties).
 *
 

#if defined _dutils_included
  #endinput
#endif

#define _dutils_included
#pragma library dutils
*/
#if !defined MAX_STRING
	#define MAX_STRING 255
#endif

#define MAX_STRING_UDB 128
/**
 *  Renames a file (Source file will be deleted!)
 *  @param   oldname
 *           newname
 *  @requires WINDOWS (because fcopy does)
 */
stock frename(oldname[],newname[]) {
    if (!fexist(oldname)) return false;
    fremove(newname);
    if (!DINI_fcopytextfile(oldname,newname)) return false;
    fremove(oldname);
    return true;
}
/**
 *  Copies items from one array/string into return.
 *  @param   source
 *           index (where to start, 0 is first)
 *           numbytes (how much)
 */
/**
 *  Sets a string's value to source.
 *  @param   dest
 *           source
 *           count
 */
stock set(dest[],source[]) {
	new
		count = strlen(source),
		i;
	for (i=0;i<count;i++) {
		dest[i]=source[i];
	}
	dest[count]=0;
}
/**
 *  Returns a hashed value in adler32 as int
 *  @param   buf
 */
stock num_hash(buf[])
 {
	new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++) {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
 }

/**
 *  Returns a hashed value in adler32 as string
 *  @param   buf
 */
stock hash(str2[]) {
   new tmpdasdsa[MAX_STRING];
   valstr(tmpdasdsa,num_hash(str2));
   return tmpdasdsa;
}
/*
 strreplace (1.2) by Westie
 http://forum.sa-mp.com/index.php?topic=110557.0
*/

stock strreplace(sSearch[], sReplace[], const sSubject[], &iCount = 0)
{
	new
		iLengthTarget = strlen(sSearch),
		iLengthReplace = strlen(sReplace),
		iLengthSource = strlen(sSubject),
		iItterations = (iLengthSource - iLengthTarget) + 1;

	new
		sTemp[128],
		sReturn[256];

	strcat(sReturn, sSubject, sizeof(sReturn));
	iCount = 0;

	for(new iIndex; iIndex < iItterations; ++iIndex)
	{
		strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

		if(!strcmp(sTemp, sSearch, false))
		{
			strdel(sReturn, iIndex, (iIndex + iLengthTarget));
			strins(sReturn, sReplace, iIndex, iLengthReplace);

			iIndex += iLengthTarget;
			iCount++;
		}
	}
	return sReturn;
}

// ******** D UTILS  -  END

/*
 *            Dini 1.6
 *       (c) Copyright 2006-2008 by DracoBlue
 *
 * @author    : DracoBlue (http://dracoblue.com)
 * @date      : 13th May 2006
 * @update    : 16th Sep 2008
 *
 * This file is provided as is (no warranties).
 *
 * It's released under the terms of MIT.
 *
 * Feel free to use it, a little message in
 * about box is honouring thing, isn't it?
 *
 */

#if defined _dini_included
  #endinput
#endif

#define _dini_included
#pragma library dini

#if defined MAX_STRING
#define DINI_MAX_STRING MAX_STRING
#else
#define DINI_MAX_STRING 128
#endif

stock dini_Exists(filename[]) {
	return fexist(filename);
}

stock dini_Remove(filename[]) {
	return fremove(filename);
}

stock dini_Create(filename[]) {
	if (fexist(filename)) return false;
	new File:fhnd;
	fhnd=fopen(filename,io_write);
	if (fhnd) {
		fclose(fhnd);
		return true;
	}
	return false;
}

stock dini_Set(filename[],key[],value[]) {
	// If we have no key, it can't be set
	// we also have no chance to set the value, if all together is bigger then the max string
	new key_length = strlen(key);
	new value_length = strlen(value);
	if (key_length==0 || key_length+value_length+2>DINI_MAX_STRING) return false;

	new File:fohnd, File:fwhnd;
	new tmpres[DINI_MAX_STRING];
	new bool:wasset=false;

	// Let's remove the old *.part file if there was one.
	format(tmpres,sizeof(tmpres),"%s.part",filename);
	fremove(tmpres);

	// We'll open the source file.
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	fwhnd=fopen(tmpres,io_write);
	if (!fwhnd) {
		// we can't open the second file for writing, so .. let's close the open one and exit.
		fclose(fohnd);
		return false;
	}

	while (fread(fohnd,tmpres)) {
		if (
			!wasset
			&& tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
				// We've got what needs to be replaced!
				format(tmpres,sizeof(tmpres),"%s=%s",key,value);
				wasset=true;
		} else {
			StripNewLine(tmpres);
		}
		fwrite(fwhnd,tmpres);
		fwrite(fwhnd,"\r\n");
	}

	if (!wasset) {
		format(tmpres,sizeof(tmpres),"%s=%s",key,value);
		fwrite(fwhnd,tmpres);
		fwrite(fwhnd,"\r\n");
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpres,sizeof(tmpres),"%s.part",filename);
	if (DINI_fcopytextfile(tmpres,filename)) {
		return fremove(tmpres);
	}
	return false;
}


stock dini_IntSet(filename[],key[],value) {
   new valuestring[DINI_MAX_STRING];
   format(valuestring,DINI_MAX_STRING,"%d",value);
   return dini_Set(filename,key,valuestring);
}

stock dini_Int(filename[],key[]) {
   return strval(dini_Get(filename,key));
}

stock dini_FloatSet(filename[],key[],Float:value) {
   new valuestring[DINI_MAX_STRING];
   format(valuestring,DINI_MAX_STRING,"%f",value);
   return dini_Set(filename,key,valuestring);
}

stock Float:dini_Float(filename[],key[]) {
   return floatstr(dini_Get(filename,key));
}

stock  bool:dini_Bool(filename[],key[]) {
	return bool:strval(dini_Get(filename,key));
}

stock dini_BoolSet(filename[],key[],value) {
	if (value) {
		return dini_Set(filename,key,"1");
	}
	return dini_Set(filename,key,"0");
}

stock dini_Unset(filename[],key[]) {
	// If we have no key, it can't be set
	// we also have no chance to unset the key, if all together is bigger then the max string
	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return false;
	new
		File:fohnd,
		File:fwhnd,
		tmpres[DINI_MAX_STRING];

	// Let's remove the old *.part file if there was one.
	format(tmpres,DINI_MAX_STRING,"%s.part",filename);
	fremove(tmpres);

	// We'll open the source file.
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	fwhnd=fopen(tmpres,io_write);
	if (!fwhnd) {
		// we can't open the second file for writing, so .. let's close the open one and exit.
		fclose(fohnd);
		return false;
	}

	while (fread(fohnd,tmpres)) {
		if (
			tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
				// We've got what needs to be removed!
		} else {
			StripNewLine(tmpres);
			fwrite(fwhnd,tmpres);
			fwrite(fwhnd,"\r\n");
		}
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpres,DINI_MAX_STRING,"%s.part",filename);
	if (DINI_fcopytextfile(tmpres,filename)) {
		return fremove(tmpres);
	}
	return false;
}

stock dini_Get(filename[],key[]) {
	new tmpres[DINI_MAX_STRING];

	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return tmpres;

	new File:fohnd;
	fohnd=fopen(filename,io_read);
	if (!fohnd) return tmpres;

	while (fread(fohnd,tmpres)) {
		if (
			tmpres[key_length]=='='
			&& !strcmp(tmpres, key, true, key_length)
		) {
			/* We've got what we need */
			StripNewLine(tmpres);
			strmid(tmpres, tmpres, key_length + 1, strlen(tmpres), DINI_MAX_STRING);
			fclose(fohnd);
			return tmpres;
		}
	}
	fclose(fohnd);
	return tmpres;
}


stock dini_Isset(filename[],key[]) {
	new key_length = strlen(key);
	if (key_length==0 || key_length+2>DINI_MAX_STRING) return false;

	new File:fohnd;
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;

	new tmpres[DINI_MAX_STRING];
	while (fread(fohnd,tmpres)) {
		if (
				tmpres[key_length]=='='
			&&  !strcmp(tmpres, key, true, key_length)
		) {
			// We've got what we need
			fclose(fohnd);
			return true;
		}
	}
	fclose(fohnd);
	return false;
}
// *********** DINI  -  END

/*
 *            DUDB functions
 *       (c) Copyright 2006-2007 by DracoBlue
 *
 * @version   : 2.4
 * @author    : DracoBlue (http://dracoblue.net)
 * @date      : 8th May 2006
 * @update    : 12th July 2007
 * @require   : DUtils 1.10
 * @require   : DINI 1.5
 *
 * This Unit is provided as is (no warranties).
 * Feel free to use it, a little message in
 * about box is honouring thing, isn't it?
 *
 */
/*
#if defined _dudb_included
  #endinput
#endif

#define _dudb_included
#pragma library dutils

#include <dutils>
#include <dini>
*/
#define dUser(%1).( udb_User(%1,
#define dUserINT(%1).( udb_UserInt(%1,
#define dUserSet(%1).( udb_UserSet(%1,
#define dUserSetINT(%1).( udb_UserSetInt(%1,
#define dUserSetFLOAT(%1).( udb_UserSetFloat(%1,
#define dUserFLOAT(%1).( udb_UserFloat(%1,

stock udb_encode(nickname[]) {
  new tmp[MAX_STRING];
  set(tmp,nickname);
  tmp=strreplace("_","_00",tmp);
  tmp=strreplace(";","_01",tmp);
  tmp=strreplace("!","_02",tmp);
  tmp=strreplace("/","_03",tmp);
  tmp=strreplace("\\","_04",tmp);
  tmp=strreplace("[","_05",tmp);
  tmp=strreplace("]","_06",tmp);
  tmp=strreplace("?","_07",tmp);
  tmp=strreplace(".","_08",tmp);
  tmp=strreplace("*","_09",tmp);
  tmp=strreplace("<","_10",tmp);
  tmp=strreplace(">","_11",tmp);
  tmp=strreplace("{","_12",tmp);
  tmp=strreplace("}","_13",tmp);
  tmp=strreplace(" ","_14",tmp);
  tmp=strreplace("\"","_15",tmp);
  tmp=strreplace(":","_16",tmp);
  tmp=strreplace("|","_17",tmp);
  tmp=strreplace("=","_18",tmp);
  return tmp;
}

stock udb_decode(nickname[]) {
  new tmp[MAX_STRING];
  set(tmp,nickname);
  tmp=strreplace("_01",";",tmp);
  tmp=strreplace("_02","!",tmp);
  tmp=strreplace("_03","/",tmp);
  tmp=strreplace("_04","\\",tmp);
  tmp=strreplace("_05","[",tmp);
  tmp=strreplace("_06","]",tmp);
  tmp=strreplace("_07","?",tmp);
  tmp=strreplace("_08",".",tmp);
  tmp=strreplace("_09","*",tmp);
  tmp=strreplace("_10","<",tmp);
  tmp=strreplace("_11",">",tmp);
  tmp=strreplace("_12","{",tmp);
  tmp=strreplace("_13","}",tmp);
  tmp=strreplace("_14"," ",tmp);
  tmp=strreplace("_15","\"",tmp);
  tmp=strreplace("_16",":",tmp);
  tmp=strreplace("_17","|",tmp);
  tmp=strreplace("_18","=",tmp);
  tmp=strreplace("_00","_",tmp);
  return tmp;
}


stock udb_Exists(nickname[]) {
	new tmp[MAX_STRING_UDB];
	format(tmp,sizeof(tmp),"gAdmin User/%s.txt",udb_encode(nickname));
	return fexist(tmp);
}


stock udb_Remove(nickname[]) {
	new tmp[MAX_STRING_UDB];
	format(tmp,sizeof(tmp),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_Remove(tmp);
}

stock udb_UserSetInt(nickname[],key[],value) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_IntSet(fname,key,value);
}

stock udb_UserSetFloat(nickname[],key[],Float:value) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_FloatSet(fname,key,value);
}

stock udb_UserSet(nickname[],key[],value[]) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_Set(fname,key,value);
}

stock udb_User(nickname[],key[]) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	format(fname,sizeof(fname),dini_Get(fname,key));
	return fname;
}

stock Float:udb_UserFloat(nickname[],key[]) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_Float(fname,key);
}

stock udb_UserInt(nickname[],key[]) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	return dini_Int(fname,key);
}

stock udb_CheckLogin(nickname[],pwd[]) {
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	if (udb_UserInt(nickname,"password_hash")==num_hash(pwd)) return true;
	return false;
}


stock udb_Create(nickname[],pwd[]) {
	if (udb_Exists(nickname)) return false;
	new fname[MAX_STRING_UDB];
	format(fname,sizeof(fname),"gAdmin User/%s.txt",udb_encode(nickname));
	dini_Create(fname);
	udb_UserSetInt(nickname,"password_hash",num_hash(pwd));
	return true;
}

stock udb_RenameUser(nickname[],newnick[]) {
	new
		oldfname[MAX_STRING_UDB],
		newfname[MAX_STRING_UDB];
	format(oldfname,sizeof(oldfname),"gAdmin User/%s.txt",udb_encode(nickname));
	format(newfname,sizeof(newfname),"gAdmin User/%s.txt",udb_encode(newnick));
	return frename(oldfname,newfname);
}


