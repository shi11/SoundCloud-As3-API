////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011 
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.services
{
	import com.adobe.serialization.json.JSON;
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
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
		
		public function SoundcloudService()
		{
		}
		
		public function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void{
			
			var service : HTTPService = new HTTPService();
			service.method = URLRequestMethod.POST;
			service.url = "https://api.soundcloud.com/oauth2/token";
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
		
		public function getTracks(lat:Number, long:Number):void
		{
			var service : HTTPService = new HTTPService();
			service.method = URLRequestMethod.GET;
			service.url = "http://api.soundcloud.com/tracks.json?consumer_key=AZNJgoblAU8ykZNDnCl7Q&tags=geo:lat="+lat+"*&tags=geo:lon="+long+"*;"
			//service.useProxy = false;
			
			service.addEventListener(ResultEvent.RESULT, onResult_getTracks );
			service.addEventListener(FaultEvent.FAULT, onFault_getTracks );
			
			service.send();
		}
		
		//*****************************************
		// HANDLERS
		//*****************************************	
		
		private function onResult_getToken( event : ResultEvent ) : void{
			var jsonObj:Object = JSON.decode( event.result as String);
			var accessToken : String = jsonObj.access_token;
			bus.tokenResponse.dispatch( accessToken );	
		}
		
		private function onFault_getToken( event : FaultEvent ) : void{
			trace(event);
		}
		
		private function onResult_getTracks( event:ResultEvent ):void{
			var jsonObj:Object = JSON.decode( event.result as String);
			if( jsonObj.length > 0 ){
				bus.nearbyResult.dispatch( jsonObj );
			}
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