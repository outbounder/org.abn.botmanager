package org.abn.botManager.operation;

import haxe.Stack;
import neko.vm.Thread;
import org.abn.bot.operation.BotOperation;
import org.abn.botManager.BotManager;
import org.abn.neko.xmpp.XMPPContext;
import org.abn.botManager.Main;

import neko.Web;
import xmpp.Message;
import haxe.xml.Fast;

class Start extends BotOperation
{		
	private var httpThread:Thread;
	
	public override function execute(params:Hash<String>):String
	{
		if (this.botContext.has("started"))
			return "already started";
			
		this.botContext.openXMPPConnection(onConnected, onConnectFailed, onDisconnected);
		
		Web.cacheModule(Main.handleRequests);
		this.botContext.set("started", true);
		
		this.httpThread = Thread.current();
		var xmppConnectResponse:String = Thread.readMessage(true);
		var botsStartResponse:String = cast(this.botContext,BotManager).startAllBots();
		return "<response><xmpp>" + xmppConnectResponse + "</xmpp><bots>" + botsStartResponse + "</bots></response>";
	}
	
	private function onConnectFailed(reason:Dynamic):Void
	{
		this.botContext.set("started", null);
		trace("xmpp connect failed "+reason);
	}
	
	private function onConnected():Void
	{
		trace("botmanager connected");
		this.httpThread.sendMessage("started");
	}
	
	private function onDisconnected():Void
	{
		if (this.botContext.has("started"))
		{
			trace("trying to reconnect...");
			this.botContext.openXMPPConnection(onConnected, onConnectFailed, onDisconnected);
		}
	}
}