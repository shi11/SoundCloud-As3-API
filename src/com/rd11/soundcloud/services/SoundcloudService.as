////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011 
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.services
{
	import com.adobe.serialization.json.JSON;
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TagVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.models.vo.TrackVO;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.robotlegs.mvcs.Actor;


	public class SoundcloudService extends Actor implements ISoundcloudService
	{
		
		[Inject]
		public var model:SoundcloudModel;
		
		[Inject]
		public var bus:SoundcloudSignalBus;
		
		private static const SOUNDCLOUD_API:String = "http://api.soundcloud.com";
		private static const SOUNDCLOUD_SECURE_API:String = "https://api.soundcloud.com";
		
		//private static const CONSUMER_KEY:String = "AZNJgoblAU8ykZNDnCl7Q";
		private static const CONSUMER_KEY:String = "ckTYMrOMUoGqw1l01Yu1A";
		
		public function SoundcloudService()
		{
		}
		
		public function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void{
			
			var service : HTTPService = new HTTPService();
			service.method = URLRequestMethod.POST;
			service.rootURL = SOUNDCLOUD_SECURE_API;
			service.url = "oauth2/token";
			service.useProxy = false;
			
			var params : Object = new Object();
			params.client_id = clientId;
			params.client_secret = clientSecret;
			params.grant_type = grantType;
			params.redirect_uri = redirectURI;
			params.code = code;
			
			service.addEventListener(ResultEvent.RESULT, onResult_getToken );
			service.addEventListener(FaultEvent.FAULT, onFault_getToken );
			
			service.send( params );
		}
		
		public function refreshToken( clientId:String, clientSecret:String, grantType:String, refreshToken:String ):void{
			
		}
		
		public function getTracks( tagVO : TagVO, range:int=2 ):void
		{
			var service:HTTPService = new HTTPService();
			service.rootURL = SOUNDCLOUD_API;
			service.method = URLRequestMethod.GET;
			service.url = "tracks.json";
			
			var latString:String = "geo:lat="+tagVO.lat.toFixed(range)+"*";
			var lonString:String = "geo:lon="+tagVO.lon.toFixed(range)+"*";
				
			var args:Object = new Object();
			args.consumer_key = CONSUMER_KEY;
			args.tags = [latString, lonString];
			
			service.request = args;
			service.addEventListener(ResultEvent.RESULT, onResult_getTracks );
			service.addEventListener(FaultEvent.FAULT, onFault_getTracks );
			
			service.send();
		}
		
		public function postTrack( trackVO:TrackVO, token:String ):void{
			var service : HTTPService = new HTTPService();
			//service.method = URLRequestMethod.POST;
			service.method = URLRequestMethod.GET;
			service.rootURL = SOUNDCLOUD_SECURE_API;
			//service.rootURL = SOUNDCLOUD_API;
			//service.url = "tracks.json";
			service.url = "me.json";

			service.addEventListener(ResultEvent.RESULT, onResult_postTrack );
			service.addEventListener(FaultEvent.FAULT, onFault_postTrack );
			
			var args:Object = new Object();
			args.oauth_token = token;
			service.request = args;
			
			service.send();
			
			//required
			/*if( trackVO.title != "" && trackVO.asset_data ){
				service.send( trackVO );
			}*/
		}
		
		//*****************************************
		// HANDLERS
		//*****************************************	
		
		private function onResult_getToken( event : ResultEvent ) : void{
			var tokenVO:TokenVO = new TokenVO();
			tokenVO.setResponse( JSON.decode( event.result as String) );
			bus.getTokenResponse.dispatch( tokenVO );	
		}
		
		private function onFault_getToken( event : FaultEvent ) : void{
			trace(event);
		}
		

		private function onResult_postTrack(event : ResultEvent ) : void{
			//var jsonObj:Object = JSO.decode( event.result as String);
		}
		
		private function onFault_postTrack( event : FaultEvent ) : void{
			trace("onFault_postTrack "+event);
		}
		
		private function onResult_getTracks( event:ResultEvent ):void{
			var jsonObj:Object = JSON.decode( event.result as String);
			if( jsonObj.length > 0 ){
				bus.nearbyResult.dispatch( jsonObj );
			}
		}
		
		private function onStatus_getTracks( event :HTTPStatusEvent ) : void{
			trace(event);
		}
		
		private function onFault_getTracks( event:FaultEvent ):void{
			/*var errorEvent: ErrorEven = new ErrorEvent( ErrorEvent.ERROR );
			errorEvent.error = new Error( event.fault.faultDetail );
			dispatch( errorEvent );*/
		}
		
		//*****************************************
		// ERROR HANDLERS
		//*****************************************	
		
		private function onIOError(event:IOErrorEvent):void{
			var error : Error = new Error( (event.target as URLLoader).data, event.errorID );
			
			/*var errorEvent:ErrorEvent = new ErrorEvent( ErrorEvent.ERROR);
			errorEvent.error = error;
			dispatch(errorEvent);*/
		}
		
	}
}