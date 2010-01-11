package org.abn.botManager;

import haxe.Http;
import org.abn.bot.BotContext;
import org.abn.neko.AppContext;

import org.abn.botManager.operation.Start;
import org.abn.botManager.operation.Stop;

class BotManager extends BotContext
{	
	public function new(context:AppContext) 
	{
		super(context);
	}
	
	public function callHttpBotOperation(name:String, endpoint:String):String
	{
		var httpResult:String = Http.requestUrl("http://" + endpoint + "/"+name);
		return "<bot><endpoint>" + endpoint + "</endpoint><result>" + httpResult + "</result></bot>";
	}
	
	public function callAllHttpBotOperation(name:String):String
	{
		var botEndpoints:List < String > = this.get("manage.bot.http");
		var s:StringBuf = new StringBuf();
		for (botHttpEndpoint in botEndpoints)
		{
			s.add(this.callHttpBotOperation(name, botHttpEndpoint));
		}
		return s.toString();
	}
	
	public function startAllBots():String
	{
		return this.callAllHttpBotOperation("start");
	}
	
	public function stopAllBots():String
	{
		return this.callAllHttpBotOperation("kill");
	}
}