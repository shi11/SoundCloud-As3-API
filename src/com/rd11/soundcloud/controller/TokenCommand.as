////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.enum.GrantType;
	import com.rd11.soundcloud.models.vo.CredentialVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.net.SharedObject;
	import flash.net.registerClassAlias;
	
	import mx.collections.ArrayCollection;
	import mx.utils.Base64Encoder;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class TokenCommand extends Command
	{
		[Inject]
		public var service : ISoundcloudService;
		
		[Inject]
		public var bus : SoundcloudSignalBus;
		
		[Inject]
		public var model : SoundcloudModel;
		
		[Inject]
		public var tokenVO:TokenVO;
		
		[Inject]
		public var refresh:Boolean;
		
		public function TokenCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.getTokenResponse.add( onResults_getToken );
			if( refresh ){
				refreshToken();
			}else{
				getToken();
			}
		}
		
		private function getToken():void{
			service.getToken( tokenVO.clientId, tokenVO.clientSecret, tokenVO.grantType, tokenVO.redirectURI, tokenVO.code );
		}

		private function refreshToken():void{
			var credentials:CredentialVO = model.credentials;
			service.refreshToken( credentials.clientId, credentials.clientSecret, GrantType.REFRESH_TOKEN, tokenVO.refreshToken );
		}
		
		/**
		 * handles query results 
		 * @param results
		 * 
		 */		
		private function onResults_getToken(token : TokenVO):void{
			
			//tack on date in seconds
			var date:Date = new Date();
			token.expiresOn = (date.time/1000) + token.expiresIn;
			
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			so.data["token"] = token;
			so.flush();
			
			model.token = token;
		}
	}	
}