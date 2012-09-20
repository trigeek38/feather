%% inculde file for mod_communication

-define (TwilVer, "2010-04-01").
-define (TwilSid, "ACabd33da4ded5e027d47dc0def47b3cc1").
-define (TwilTok, "912b8400dae4e31af7ad5377e363d2d3").
-define (TwilUrl, "@api.twilio.com/"++?TwilVer++"/Accounts/"++?TwilSid).
-define (TwilPath, "https://"++?TwilSid++":"++?TwilTok++?TwilUrl).
-define (TwilContentType, "application/x-www-form-urlencoded").
-define (CallPath, "/Calls/?").
-define (SMSPath, "/SMS/Messages/?").
-define (QFrom, "From=+1").
-define (QTo, "&To=+1").
-define (QBody, "&Body=").
-define (QUrl, "&Url=").
-define (QMethod, "&Method=").
