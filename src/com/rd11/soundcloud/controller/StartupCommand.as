package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.CredentialVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.net.SharedObject;
	
	import org.robotlegs.mvcs.SignalCommand;
	
	public class StartupCommand extends SignalCommand
	{
		
		[Inject]
		public var bus:SoundcloudSignalBus;
		
		[Inject]
		public var soundcloudModel:SoundcloudModel;
		
		[Inject]
		public var credentials:CredentialVO;
		
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute():void{
			
			soundcloudModel.credentials = credentials;
			
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			var token:TokenVO = so.data["token"] as TokenVO;
			
			if( token && token.accessToken && token.expiresOn){
				var todaySeconds:int = new Date().time / 1000; //convert to seconds
				var timeLeft:int = token.expiresOn - todaySeconds;
				if( timeLeft > 0){
					soundcloudModel.token = token;
				}else{
					trace("expired " + ((timeLeft*-1) / 60) + " mins ago" );
					bus.refreshTokenRequest.dispatch( token, true );
					//TODO disable authenticated in settings
				}
			}
			
			bus.startupResponse.dispatch( token );
		}
	}
}