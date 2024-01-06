integer CHECK_PERIOD = 0;
integer LAST_CHECK = 0;

default
{
    state_entry()
    {
        CHECK_PERIOD = (6*60*60);
        llSetTimerEvent(60);
    }
    timer()
    {
        if(LAST_CHECK+CHECK_PERIOD < llGetUnixTime())
            g_kRequestID = llHTTPRequest("https://raw.githubusercontent.com/AriasCreations/AriasCreations/main/services.json", [], "");
    }

    changed(integer iChange)
    {
        if(iChange & CHANGED_REGION_START)
        {
            LAST_CHECK = 0;
        }
        if(iChange & CHANGED_INVENTORY)
        {
            LAST_CHECK=0;
        }
    }

    on_rez(integer t)
    {
        llResetScript();
    }

    http_response(key kID, integer iStat, list lMeta, string sBody)
    {
        if(kID == g_kRequestID)
        {
            if(iStat == 200)
            {
                LAST_CHECK = llGetUnixTime();

                llMessageLinked(LINK_SET, 0x004f, sBody, "");
            } else {
                llMessageLinked(LINK_SET, 0x004e, "", ""); // No such file, or temporary error
            }
        }
    }
}