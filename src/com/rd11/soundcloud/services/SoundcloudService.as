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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
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
		
		public function getMe():void{
			var service:HTTPService = new HTTPService();
			service.rootURL = SOUNDCLOUD_SECURE_API;
			service.method = URLRequestMethod.GET;
			service.url = "me.json";
			
			var args:Object = new Object();
			args.oauth_token = model.accessToken;
			
			service.request = args;
			service.addEventListener(ResultEvent.RESULT, onResult_getMe );
			service.addEventListener(FaultEvent.FAULT, onFault_getMe );
			
			service.send();
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
		
		public function postTrack( trackVO:TrackVO ):void{
			
			var urlRequest:URLRequest = new URLRequest( SOUNDCLOUD_SECURE_API +
										"/tracks?oauth_token=" + model.accessToken);
			urlRequest.contentType = "multipart/form-data";
			//urlRequest.requestHeaders = [new URLRequestHeader( "track[title]",trackVO.title ),new URLRequestHeader('track[asset_data]',trackVO.file.name)];
			urlRequest.method = URLRequestMethod.POST;

			var params:Object = {};
			params['track[title]'] = trackVO.title;
			params['track[asset_data]'] = trackVO.fullPath;
			/*params["track[description]"] = "test description";
			params["track[downloadable]"] = true;
			params["track[sharing]"] = "public";
			params.oauth_token = model.accessToken;*/
			urlRequest.data = params;
			
			var file:FileReference = trackVO.file;
			file.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
			file.addEventListener( Event.COMPLETE, onUploadComplete );
			file.addEventListener( IOErrorEvent.IO_ERROR, onUploadIOError );
			//file.addEventListener( HTTPStatusEvent.HTTP_STATUS, onHTTPStatus );
			file.addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPStatus );
			file.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			file.upload( urlRequest, file.name );
			
			//var urlRequest:URLRequest = new URLRequest( "http://squareFM:14delmar@api.soundcloud.com" + "/tracks?consumer_key=" + CONSUMER_KEY );
			//var urlRequest:URLRequest = new URLRequest( SOUNDCLOUD_API + "/tracks?access_token=" + model.accessToken );
			/*var args:Object = new Object();
			args.asset_data = trackVO.file.data;
			args.title = trackVO.title;
			args.description = "test description";
			args.sharing = "public";*/
			
			//args.oauth_consumer_key = model.oauth_token.key;
			//args.oauth_token = model.oauth_token;
			//args.oauth_signature_method = "HMAC-SHA1";
			//args.asset_data = trackVO.asset_data;
			//args.oauth_nonce = model.oauth_token. hmmmm
			//args.oauth_signature = model.oauth_token. hmmm
			
			/*Filename        24 Hours A Day, The Best Music In Town -1-.mp3 
			consumer_key    ROZpuawx7DzB7gryrcNA 
			oauth_timestamp 1288026774 
			oauth_access_token      XmnI6RF05QvDZbY833lFtw 
			sharing public 
			oauth_consumer_key      ROZpuawx7DzB7gryrcNA 
			description     this is a song 
			oauth_nonce     703045FE-9029-0A37-1DBA-E460DA0D41B7 
			oauth_signature TDi4DgLaVKjmtFfR3nYyXTF3H5o= 
				title   my test track number 2 
			oauth_token     XmnI6RF05QvDZbY833lFtw 
			oauth_signature_method  HMAC-SHA1 
			asset_data      24 Hours A Day, The Best Music In Town -1-.mp3 
			Upload  Submit Query*/
			
			
			//service.url = "tracks";
			
			//http://un:pw@rootURL

			//service.addEventListener(ResultEvent.RESULT, onResult_postTrack );
			//service.addEventListener(FaultEvent.FAULT, onFault_postTrack );
			
			//required
			//if( trackVO.title != "" && trackVO.asset_data ){
			//	service.send( args );
			//}
		}
		
		//*****************************************
		// HANDLERS
		//*****************************************	
		
		private function onResult_getToken( event : ResultEvent ) : void{
			var tokenVO:TokenVO = new TokenVO();
			tokenVO.setResponse( JSON.decode( event.result as String) );
			bus.getTokenResponse.dispatch( tokenVO );
			//getMe();
		}
		
		private function onFault_getToken( event : FaultEvent ) : void{
			trace(event);
		}
		
		private function onResult_getMe(event : ResultEvent ) : void { 
			trace(event);
			
		}
		
		private function onFault_getMe( event : FaultEvent ) : void{
			trace(event);
		}
		
		private function onHTTPStatus( event :HTTPStatusEvent ):void{
			// do nothing if this is not an error status
			if (event.status != 0 && event.status < 400)
				return;
			
			// remove complete handler
			/*if (event.target is FileReference) {
				fileReference.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
			} else {
				//				urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
				
				// avoid RTE caused by unparsable URLVariables through switching expected response format
				// to simple text
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			}*/
			
			var msg:String;
			
			switch (event.status) {
				case 400:
					msg = "Bad Request";
					break;
				case 401:
					msg = "Unauthorized";
					break;
				case 403:
					msg = "Forbidden";
					break;
				case 404:
					msg = "Not Found";
					break;
				case 405:
					msg = "Method Not Allowed";
					break;
				case 406:
					msg = "Not Acceptable";
					break;
				case 407:
					msg = "Proxy Authentication Required";
					break;
				case 408:
					msg = "Request Timeout";
					break;
				case 409:
					msg = "Conflict";
					break;
				case 410:
					msg = "Gone";
					break;
				case 411:
					msg = "Length Required";
					break;
				case 412:
					msg = "Precondition Failed";
					break;
				case 413:
					msg = "Request Entity Too Large";
					break;
				case 414:
					msg = "Request-URI Too Long";
					break;
				case 415:
					msg = "Unsupported Media Type";
					break;
				case 416:
					msg = "Requested Range Not Satisfiable";
					break;
				case 417:
					msg = "Expectation Failed";
					break;
				case 500:
					msg = "Internal Server Error";
					break;
				case 501:
					msg = "Not Implemented";
					break;
				case 502:
					msg = "Bad Gateway";
					break;
				case 503:
					msg = "Service Unavailable";
					break;
				case 504:
					msg = "Gateway Timeout";
					break;
				case 505:
					msg = "HTTP Version Not Supported";
					break;
				default:
					msg = "Unhandled HTTP status";
			}
			
			trace(msg);
		}

		public function onUploadProgress(event:ProgressEvent):void{
			
		}
		
		public function onUploadComplete(event:Event):void{
			
		}
		
		public function onUploadIOError(event:IOErrorEvent):void{
			
		}
		
		public function onSecurityError(event:SecurityErrorEvent):void{
			
		}

		/*private function onResult_postTrack(event : ResultEvent ) : void{
			//var jsonObj:Object = JSO.decode( event.result as String);
		}
		
		private function onFault_postTrack( event : FaultEvent ) : void{
			trace("onFault_postTrack "+event);
		}*/
		
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