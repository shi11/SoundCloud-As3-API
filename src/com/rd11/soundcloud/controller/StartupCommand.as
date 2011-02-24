package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
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
		
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute():void{
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			var token:TokenVO = so.data["token"] as TokenVO;
			
			if( token && token.accessToken ){
				if( token.dateSaved && (token.dateSaved - (token.expiresIn * 1000) > 0) ){
					soundcloudModel.accessToken = token.accessToken;
					bus.getTokenResponse.dispatch( token );
				}else{
					bus.refreshTokenRequest.dispatch( token, true );
				}
			}else{
				bus.getTokenResponse.dispatch( new TokenVO() );
			}
			
		}
	}
}