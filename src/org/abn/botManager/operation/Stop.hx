﻿package org.abn.botManager.operation;

import neko.Web;
import org.abn.bot.operation.BotOperation;
import org.abn.botManager.BotManager;
import org.abn.uberTora.UberToraContext;

class Stop extends BotOperation
{
	public override function execute(params:Hash<String>):String
	{
		if (!this.botContext.has("started"))
			return "not started";
		
		this.botContext.set("started", null);
		this.botContext.closeXMPPConnection();
		
		UberToraContext.redirectRequests(null);
		var botsResponse:String = cast(this.botContext, BotManager).stopAllBots();
		return "<response><xmpp>stopped</xmpp><bots>"+botsResponse+"</bots></response>";
	}
}