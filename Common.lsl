
integer g_iDebugIndent=0;
integer DEBUG_ENABLED() {
    return FALSE;
}

DEBUG_FUNC(integer iEnter, string sLabel, list lParams) {
    if(!DEBUG_ENABLED()) return;
    if(iEnter){
        llOwnerSay(MakeIndent() + "ENTER " + sLabel + " [" + llList2CSV(lParams) + "]");
        g_iDebugIndent++;
    } else {
        g_iDebugIndent --;
        if(g_iDebugIndent<0)g_iDebugIndent=0;

        llOwnerSay(MakeIndent() + "LEAVE " + sLabel + " [" + llList2CSV(lParams) + "]");
    }
}

DEBUG_STMT(integer iEnter, string sLabel) {
    if(!DEBUG_ENABLED()) return;
    if(iEnter) {
        llOwnerSay(MakeIndent() + "STMT " + sLabel);
        g_iDebugIndent ++;
    }else {
        g_iDebugIndent--;
        if(g_iDebugIndent<0)g_iDebugIndent=0;

        llOwnerSay(MakeIndent() + "RET " + sLabel);
    }
}

DEBUG(string sMsg) {
    if(!DEBUG_ENABLED()) return;
    llOwnerSay(MakeIndent() + " > " + sMsg);
}

string MakeIndent() 
{
    integer i = 0;
    string sIndent = "";
    for(i = 0;i<g_iDebugIndent;i++){
        sIndent += "  ";
    }

    return "[" + llGetScriptName() + "] " + sIndent;
}



integer IsLikelyUUID(string sID)
{
    if(sID == (string)NULL_KEY)return TRUE;
    if(llStringLength(sID)==32)return TRUE;
    key kID = (key)sID;
    if(kID)return TRUE;
    if(llStringLength(sID) >25){
        if(llGetSubString(sID,8,8)=="-" && llGetSubString(sID, 13,13) == "-" && llGetSubString(sID,18,18) == "-" && llGetSubString(sID,23,23)=="-") return TRUE;

    }
    return FALSE;
}



integer IsLikelyAvatarID(key kID)
{
    if(!IsLikelyUUID(kID))return FALSE;
    // Avatar UUIDs always have the 15th digit set to a 4
    if(llGetSubString(kID,8,8) == "-" && llGetSubString(kID,14,14)=="4")return TRUE;

    return FALSE;
}

string SLURL(key kID){
    return "secondlife:///app/agent/"+(string)kID+"/about";
}

list StrideOfList(list src, integer stride, integer start, integer end)
{
    list l = [];
    integer ll = llGetListLength(src);
    if(start < 0)start += ll;
    if(end < 0)end += ll;
    if(end < start) return llList2List(src, start, start);
    while(start <= end)
    {
        l += llList2List(src, start, start);
        start += stride;
    }
    return l;
}


UpdateDSRequest(key orig, key new, string meta){
    if(orig == NULL){
        g_lDSRequests += [new,meta];
    }else {
        integer index = HasDSRequest(orig);
        if(index==-1)return;
        else{
            g_lDSRequests = llListReplaceList(g_lDSRequests, [new,meta], index,index+1);
        }
    }
}

string GetDSMeta(key id){
    integer index=llListFindList(g_lDSRequests,[id]);
    if(index==-1){
        return "N/A";
    }else{
        return llList2String(g_lDSRequests,index+1);
    }
}

integer HasDSRequest(key ID){
    return llListFindList(g_lDSRequests, [ID]);
}

DeleteDSReq(key ID){
    if(HasDSRequest(ID)!=-1)
        g_lDSRequests = llDeleteSubList(g_lDSRequests, HasDSRequest(ID), HasDSRequest(ID)+1);
    else return;
}

string MkMeta(list lTmp){
    return llDumpList2String(lTmp, ":");
}
string SetMetaList(list lTmp){
    return llDumpList2String(lTmp, ":");
}

string SetDSMeta(list lTmp){
    return llDumpList2String(lTmp, ":");
}

list GetMetaList(key kID){
    return llParseStringKeepNulls(GetDSMeta(kID), [":"],[]);
}


integer mask(integer states, integer source, integer mask)
{
    if(states==TOGGLE)
    {
        return source ^ mask;
    }
    if(states)
    {
        source = source | mask;
        return source;
    }else {
        source = source &~ mask;
        return source;
    }
}
integer bool(integer a){
    if(a)return TRUE;
    else return FALSE;
}
string Checkbox(integer iValue, string sLabel) {
    return llList2String(g_lCheckboxes, bool(iValue))+" "+sLabel;
}


string Uncheckbox(string sLabel)
{
    integer iBoxLen = 1+llStringLength(llList2String(g_lCheckboxes,0));
    return llGetSubString(sLabel,iBoxLen,-1);
}
