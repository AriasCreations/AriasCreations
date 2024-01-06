string DecipherService(string payload, string ident)
{
    if(llJsonValueType(payload,[ident]) == JSON_INVALID)
    {
        return "";
    }

    return llJsonGetValue(payload, [ident,"protocol"]) + "://" + llJsonGetValue(payload,[ident,"host"]) + ":" + llJsonGetValue(payload,[ident,"port"]);
}