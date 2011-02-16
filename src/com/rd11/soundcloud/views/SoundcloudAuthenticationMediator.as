////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: 2/12/2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.views
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	import com.rd11.soundcloud.views.interfaces.ISoundcloudAuthenticationView;
	
	import flash.net.SharedObject;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SoundcloudAuthenticationMediator extends Mediator
	{
		
		[Inject]
		public var view:ISoundcloudAuthenticationView;
		
		[Inject]
		public var signalBus:SoundcloudSignalBus;
		
		/*[Inject]
		public var soundcloudModel:SoundcloudModel;
		
		[Inject]
		public var service:ISoundcloudService;*/
		
		private var _clientId:String;
		private var _clientSecret:String;
		private var _redirectURI:String;
		
		public function SoundcloudAuthenticationMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			view.locationChangeHandler = locationChangeHandler;
			view.authenticationRequest.add( authenticate );
			signalBus.tokenResponse.add( saveToken );
		}
		
		private function authenticate(clientId:String, clientSecret:String, redirectURI:String):void{
			_clientId = clientId;
			_clientSecret = clientSecret;
			_redirectURI = redirectURI;
			
			view.navigate( 
				"https://soundcloud.com/connect?"+
				"client_id="+clientId+
				"&response_type=code"+
				"&redirect_uri="+redirectURI
				 );
		}
		
		private function locationChangeHandler( location : String ):void{
			if (location.search('code=') > -1){
				var code:String = location.substr(location.search('=') + 1);
				saveCode(code);
				
				var tokenVO:TokenVO = new TokenVO(_clientId, _clientSecret, "authorization_code", _redirectURI, code);
				
				signalBus.tokenRequest.dispatch( tokenVO );
			}
		}
		
		private function saveCode( code : String ) : void{
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			so.data["code"] = code;
			so.flush();
		}
		
		protected function saveToken(token : String) : void
		{
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			so.data["token"] = token;
			so.flush();
			
			view.authenticationResults( token );
		}
		
	}
}