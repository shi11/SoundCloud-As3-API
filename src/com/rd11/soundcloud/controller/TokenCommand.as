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
	
	import mx.collections.ArrayCollection;
	
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
		
		public function TokenCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.tokenResponse.add( onResults_getToken );
			getToken();
		}
		
		private function getToken():void{
			service.getToken( tokenVO.clientId, tokenVO.clientSecret, tokenVO.grantType, tokenVO.redirectURI, tokenVO.code );
		}
		
		/**
		 * handles query results 
		 * @param results
		 * 
		 */		
		private function onResults_getToken(token : String):void{
			model.accessToken = token;
		}
	}	
}