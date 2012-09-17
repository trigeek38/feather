%% inculde file for mod_communication

-define (Token,"23e55303d7ac674ca9186d73bccfb3b21894fd1fb09b583390be57ff6f8b1d07e685e86b977d1f5c4557192c").
-define (Path, "http://api.tropo.com/1.0/sessions").
-define (TwilSid, "ACabd33da4ded5e027d47dc0def47b3cc1").
-define (TwilTok, "912b8400dae4e31af7ad5377e363d2d3").
-define (TwilVer, "2010-04-01").
-define (TwilUrl, "@api.twilio.com/"++?TwilVer++"/Accounts/"++?TwilSid).
-define (TwilPath, "https://"++?TwilSid++":"++?TwilTok++?TwilUrl).
-define (TwilNumber, "From=+13525872956&To=").
-define (SMSPath, "/SMS/Messages/?").
-define (Body, "&Body=").
-define (URL, "http://www.j2-c2.com/").
