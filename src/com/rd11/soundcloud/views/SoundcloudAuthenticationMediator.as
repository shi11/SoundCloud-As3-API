////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: 2/12/2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.views
{
	import com.adobe.utils.StringUtil;
	import com.rd11.soundcloud.models.enum.GrantType;
	import com.rd11.soundcloud.models.vo.CredentialVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	import com.rd11.soundcloud.views.interfaces.ISoundcloudAuthenticationView;
	
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.ObjectUtil;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class SoundcloudAuthenticationMediator extends Mediator
	{
		
		[Inject]
		public var view:ISoundcloudAuthenticationView;
		
		[Inject]
		public var signalBus:SoundcloudSignalBus;
		
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
			signalBus.getTokenResponse.add( onAuthenticationResults );
		}
		
		private function authenticate( credentialVO:CredentialVO ):void{
			_clientId = credentialVO.clientId;
			_clientSecret = credentialVO.clientSecret;
			_redirectURI = credentialVO.redirectUri;
			
			view.navigate( 
				"https://soundcloud.com/connect"+
				"?client_id="+_clientId+
				"&client_secret="+_clientSecret+
				"&response_type=code"+
				"&redirect_uri="+_redirectURI
				 );
		}
		
		private function locationChangeHandler( location : String ):void{
			if (location.search('code=') > -1){
				var code:String = location.substr(location.search('=') + 1);
				
				var tokenVO:TokenVO = new TokenVO();
				tokenVO.setRequest( _clientId, _clientSecret, GrantType.AUTH_CODE, _redirectURI, code );
				
				signalBus.getTokenRequest.dispatch( tokenVO, false );
			}
		}
		
		protected function onAuthenticationResults(token : TokenVO) : void
		{
			view.authenticationResults( token.accessToken );
		}
		
	}
}