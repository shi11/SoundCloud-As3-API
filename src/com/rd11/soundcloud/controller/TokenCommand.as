////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
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
			service.refreshToken( tokenVO.clientId, tokenVO.clientSecret, tokenVO.grantType, tokenVO.refreshToken );
		}
		
		/**
		 * handles query results 
		 * @param results
		 * 
		 */		
		private function onResults_getToken(token : TokenVO):void{
			/*var encoder:Base64Encoder = new Base64Encoder();
			encoder.encode( token.accessToken );
			var newAccessToken:String = encoder.toString();
			
			model.accessToken = newAccessToken;*/
			model.accessToken = token.accessToken;
			
			//tack on date time
			var date:Date = new Date();
			token.dateSaved = date.time;
			
			var so : SharedObject = SharedObject.getLocal("soundcloud");
			so.data["token"] = token;
			so.flush();
		}
	}	
}