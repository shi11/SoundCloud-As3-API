package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.net.SharedObject;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class StartupCommand extends SignalCommand
	{
		
		[Inject]
		public var bus:SoundcloudSignalBus;
		
		[Inject]
		public var soundcloudModel:SoundcloudModel;
		
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute():void{
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			var accessToken:String = so.data["token"];
			
			if( !accessToken ){
				accessToken = "";
			}
			else{
				soundcloudModel.accessToken = accessToken;
			}
			
			bus.tokenResponse.dispatch( accessToken );
		}
	}
}