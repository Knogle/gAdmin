/*
    gAdmin YSI-backed user storage helpers.
*/

#if defined _gAdmin_ysi_files_included
    #endinput
#endif
#define _gAdmin_ysi_files_included

#include <YSI_Storage/y_ini>

#if !defined MAX_STRING
    #define MAX_STRING 255
#endif

#define MAX_STRING_UDB 128

#define dUser(%1).( udb_User(%1,
#define dUserINT(%1).( udb_UserInt(%1,
#define dUserSet(%1).( udb_UserSet(%1,
#define dUserSetINT(%1).( udb_UserSetInt(%1,
#define dUserSetFLOAT(%1).( udb_UserSetFloat(%1,
#define dUserFLOAT(%1).( udb_UserFloat(%1,

#define yUser(%1).( y_files_User(%1,
#define yUserINT(%1).( y_files_UserInt(%1,
#define yUserSet(%1).( y_files_UserSet(%1,
#define yUserSetINT(%1).( y_files_UserSetInt(%1,
#define yUserSetFLOAT(%1).( y_files_UserSetFloat(%1,
#define yUserFLOAT(%1).( y_files_UserFloat(%1,

stock num_hash(buf[])
{
    new length = strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n = 0; n < length; n++)
    {
        s1 = (s1 + buf[n]) % 65521;
        s2 = (s2 + s1) % 65521;
    }
    return (s2 << 16) + s1;
}

stock hash(str2[])
{
    new tmpdasdsa[MAX_STRING];
    valstr(tmpdasdsa, num_hash(str2));
    return tmpdasdsa;
}

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

    for (new iIndex; iIndex < iItterations; ++iIndex)
    {
        strmid(sTemp, sReturn, iIndex, (iIndex + iLengthTarget), (iLengthTarget + 1));

        if (!strcmp(sTemp, sSearch, false))
        {
            strdel(sReturn, iIndex, (iIndex + iLengthTarget));
            strins(sReturn, sReplace, iIndex, iLengthReplace);

            iIndex += iLengthTarget;
            iCount++;
        }
    }
    return sReturn;
}

stock set(dest[], source[])
{
    new
        count = strlen(source),
        i;
    for (i = 0; i < count; i++)
    {
        dest[i] = source[i];
    }
    dest[count] = 0;
}

stock udb_encode(nickname[])
{
    new tmp[MAX_STRING_UDB];
    set(tmp, nickname);
    tmp = strreplace("_", "_00", tmp);
    tmp = strreplace(";", "_01", tmp);
    tmp = strreplace("!", "_02", tmp);
    tmp = strreplace("/", "_03", tmp);
    tmp = strreplace("\\", "_04", tmp);
    tmp = strreplace("[", "_05", tmp);
    tmp = strreplace("]", "_06", tmp);
    tmp = strreplace("?", "_07", tmp);
    tmp = strreplace(".", "_08", tmp);
    tmp = strreplace("*", "_09", tmp);
    tmp = strreplace("<", "_10", tmp);
    tmp = strreplace(">", "_11", tmp);
    tmp = strreplace("{", "_12", tmp);
    tmp = strreplace("}", "_13", tmp);
    tmp = strreplace(" ", "_14", tmp);
    tmp = strreplace("\"", "_15", tmp);
    tmp = strreplace(":", "_16", tmp);
    tmp = strreplace("|", "_17", tmp);
    tmp = strreplace("=", "_18", tmp);
    return tmp;
}

stock udb_decode(nickname[])
{
    new tmp[MAX_STRING_UDB];
    set(tmp, nickname);
    tmp = strreplace("_01", ";", tmp);
    tmp = strreplace("_02", "!", tmp);
    tmp = strreplace("_03", "/", tmp);
    tmp = strreplace("_04", "\\", tmp);
    tmp = strreplace("_05", "[", tmp);
    tmp = strreplace("_06", "]", tmp);
    tmp = strreplace("_07", "?", tmp);
    tmp = strreplace("_08", ".", tmp);
    tmp = strreplace("_09", "*", tmp);
    tmp = strreplace("_10", "<", tmp);
    tmp = strreplace("_11", ">", tmp);
    tmp = strreplace("_12", "{", tmp);
    tmp = strreplace("_13", "}", tmp);
    tmp = strreplace("_14", " ", tmp);
    tmp = strreplace("_15", "\"", tmp);
    tmp = strreplace("_16", ":", tmp);
    tmp = strreplace("_17", "|", tmp);
    tmp = strreplace("_18", "=", tmp);
    tmp = strreplace("_00", "_", tmp);
    return tmp;
}

stock bool:udb_Exists(nickname[])
{
    new tmp[MAX_STRING_UDB];
    format(tmp, sizeof(tmp), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_Exists(tmp);
}

stock bool:udb_Remove(nickname[])
{
    new tmp[MAX_STRING_UDB];
    format(tmp, sizeof(tmp), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_Remove(tmp);
}

stock bool:udb_UserSetInt(nickname[], key[], value)
{
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_WriteInt(fname, key, value);
}

stock bool:udb_UserSetFloat(nickname[], key[], Float:value)
{
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_WriteFloat(fname, key, value);
}

stock bool:udb_UserSet(nickname[], key[], value[])
{
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_WriteString(fname, key, value);
}

stock udb_User(nickname[], key[])
{
    static result[MAX_STRING_UDB];
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    format(result, sizeof(result), INI_ReadString(fname, key));
    return result;
}

stock Float:udb_UserFloat(nickname[], key[])
{
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_ReadFloat(fname, key);
}

stock udb_UserInt(nickname[], key[])
{
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    return INI_ReadInt(fname, key);
}

stock bool:udb_CheckLogin(nickname[], pwd[])
{
    return udb_UserInt(nickname, "password_hash") == num_hash(pwd);
}

stock bool:udb_Create(nickname[], pwd[])
{
    if (udb_Exists(nickname)) return false;
    new fname[MAX_STRING_UDB];
    format(fname, sizeof(fname), "gAdmin User/%s.txt", udb_encode(nickname));
    INI_Create(fname);
    udb_UserSetInt(nickname, "password_hash", num_hash(pwd));
    return true;
}

stock bool:udb_RenameUser(nickname[], newnick[])
{
    new oldfname[MAX_STRING_UDB];
    new newfname[MAX_STRING_UDB];
    format(oldfname, sizeof(oldfname), "gAdmin User/%s.txt", udb_encode(nickname));
    format(newfname, sizeof(newfname), "gAdmin User/%s.txt", udb_encode(newnick));
    if (!INI_Exists(oldfname)) return false;
    if (INI_Exists(newfname)) return false;
    new File:fohnd = fopen(oldfname, io_read);
    if (!fohnd) return false;
    new File:fwhnd = fopen(newfname, io_write);
    if (!fwhnd)
    {
        fclose(fohnd);
        return false;
    }
    new buffer[INI_MAX_LINE];
    while (fread(fohnd, buffer))
    {
        fwrite(fwhnd, buffer);
    }
    fclose(fohnd);
    fclose(fwhnd);
    return INI_Remove(oldfname);
}

stock bool:y_files_Exists(nickname[])
{
    return udb_Exists(nickname);
}

stock bool:y_files_Remove(nickname[])
{
    return udb_Remove(nickname);
}

stock bool:y_files_UserSetInt(nickname[], key[], value)
{
    return udb_UserSetInt(nickname, key, value);
}

stock bool:y_files_UserSetFloat(nickname[], key[], Float:value)
{
    return udb_UserSetFloat(nickname, key, value);
}

stock bool:y_files_UserSet(nickname[], key[], value[])
{
    return udb_UserSet(nickname, key, value);
}

stock y_files_User(nickname[], key[])
{
    return udb_User(nickname, key);
}

stock Float:y_files_UserFloat(nickname[], key[])
{
    return udb_UserFloat(nickname, key);
}

stock y_files_UserInt(nickname[], key[])
{
    return udb_UserInt(nickname, key);
}

stock bool:y_files_CheckLogin(nickname[], pwd[])
{
    return udb_CheckLogin(nickname, pwd);
}

stock bool:y_files_Create(nickname[], pwd[])
{
    return udb_Create(nickname, pwd);
}

stock bool:y_files_RenameUser(nickname[], newnick[])
{
    return udb_RenameUser(nickname, newnick);
}
