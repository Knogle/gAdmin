/*
    Minimal y_ini-style helpers for gAdmin.
    Provides basic INI read/write helpers used by gAdmin's user storage.
*/

#if defined _y_ini_included
    #endinput
#endif
#define _y_ini_included

#if !defined MAX_STRING
    #define MAX_STRING 255
#endif

#define INI_MAX_LINE MAX_STRING

stock bool:INI_Exists(filename[])
{
    return fexist(filename);
}

stock bool:INI_Remove(filename[])
{
    return fremove(filename);
}

stock bool:INI_Create(filename[])
{
    if (fexist(filename)) return false;
    new File:fhnd = fopen(filename, io_write);
    if (!fhnd) return false;
    fclose(fhnd);
    return true;
}

static stock bool:INI_CopyFileText(src[], dest[])
{
    new File:fhnd = fopen(src, io_read);
    if (!fhnd) return false;
    new File:dhnd = fopen(dest, io_write);
    if (!dhnd)
    {
        fclose(fhnd);
        return false;
    }
    new buffer[INI_MAX_LINE];
    while (fread(fhnd, buffer))
    {
        fwrite(dhnd, buffer);
    }
    fclose(fhnd);
    fclose(dhnd);
    return true;
}

static stock INI_StripNewLine(line[])
{
    new length = strlen(line);
    if (length && line[length - 1] == '\n') line[length - 1] = '\0';
    length = strlen(line);
    if (length && line[length - 1] == '\r') line[length - 1] = '\0';
}

stock bool:INI_WriteString(filename[], key[], value[])
{
    new key_length = strlen(key);
    new value_length = strlen(value);
    if (!key_length || key_length + value_length + 2 > INI_MAX_LINE) return false;

    new File:fohnd = fopen(filename, io_read);
    if (!fohnd) return false;

    new tmpres[INI_MAX_LINE];
    format(tmpres, sizeof(tmpres), "%s.part", filename);
    fremove(tmpres);
    new File:fwhnd = fopen(tmpres, io_write);
    if (!fwhnd)
    {
        fclose(fohnd);
        return false;
    }

    new bool:wasset = false;
    new buffer[INI_MAX_LINE];
    while (fread(fohnd, buffer))
    {
        if (buffer[key_length] == '=' && !strcmp(buffer, key, true, key_length))
        {
            format(buffer, sizeof(buffer), "%s=%s\r\n", key, value);
            fwrite(fwhnd, buffer);
            wasset = true;
        }
        else
        {
            INI_StripNewLine(buffer);
            fwrite(fwhnd, buffer);
            fwrite(fwhnd, "\r\n");
        }
    }

    if (!wasset)
    {
        format(buffer, sizeof(buffer), "%s=%s\r\n", key, value);
        fwrite(fwhnd, buffer);
    }

    fclose(fohnd);
    fclose(fwhnd);

    format(tmpres, sizeof(tmpres), "%s.part", filename);
    if (INI_CopyFileText(tmpres, filename))
    {
        return INI_Remove(tmpres);
    }
    return false;
}

stock bool:INI_WriteInt(filename[], key[], value)
{
    new valuestring[INI_MAX_LINE];
    valstr(valuestring, value);
    return INI_WriteString(filename, key, valuestring);
}

stock bool:INI_WriteFloat(filename[], key[], Float:value)
{
    new valuestring[INI_MAX_LINE];
    format(valuestring, sizeof(valuestring), "%f", value);
    return INI_WriteString(filename, key, valuestring);
}

stock INI_ReadString(filename[], key[])
{
    new tmpres[INI_MAX_LINE];

    new key_length = strlen(key);
    if (!key_length || key_length + 2 > INI_MAX_LINE) return tmpres;

    new File:fohnd = fopen(filename, io_read);
    if (!fohnd) return tmpres;

    while (fread(fohnd, tmpres))
    {
        if (tmpres[key_length] == '=' && !strcmp(tmpres, key, true, key_length))
        {
            INI_StripNewLine(tmpres);
            strmid(tmpres, tmpres, key_length + 1, strlen(tmpres), INI_MAX_LINE);
            fclose(fohnd);
            return tmpres;
        }
    }
    fclose(fohnd);
    return tmpres;
}

stock INI_ReadInt(filename[], key[])
{
    return strval(INI_ReadString(filename, key));
}

stock Float:INI_ReadFloat(filename[], key[])
{
    return floatstr(INI_ReadString(filename, key));
}
