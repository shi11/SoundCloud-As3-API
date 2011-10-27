////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011 
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.services
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TagVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.models.vo.TrackVO;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.Security;
	
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
		
		private var service:HTTPService;
		
		public function SoundcloudService()
		{
			service = new HTTPService();
		}
		
		public function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void{
			
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
			service.method = URLRequestMethod.POST;
			service.rootURL = SOUNDCLOUD_SECURE_API;
			service.url = "oauth2/token";
			service.useProxy = false;
			
			var params : Object = new Object();
			params.client_id = clientId;
			params.client_secret = clientSecret;
			params.grant_type = grantType;
			params.refresh_token = refreshToken;
			
			service.addEventListener(ResultEvent.RESULT, onResult_refreshToken );
			service.addEventListener(FaultEvent.FAULT, onFault_refreshToken );
			
			service.send( params );
		}
		
		public function getMe():void{
			service.rootURL = SOUNDCLOUD_SECURE_API;
			service.method = URLRequestMethod.GET;
			service.url = "me.json";
			
			var args:Object = new Object();
			args.oauth_token = model.token.accessToken;
			
			service.request = args;
			service.addEventListener(ResultEvent.RESULT, onResult_getMe );
			service.addEventListener(FaultEvent.FAULT, onFault_getMe );
			
			service.send();
		}
		
		public function getTracks( tagVO : TagVO ):void
		{
			service.rootURL = SOUNDCLOUD_API;
			service.method = URLRequestMethod.GET;
			service.url = "tracks.json";
			
			var latString:String;
			var lonString:String;
			
			var args:Object = new Object();
			args.consumer_key = model.credentials.clientId;
			if( tagVO.tag_list && tagVO.tag_list.length > 0){
				args.tags = tagVO.tag_list.toString().replace(","," ");
			}
			
			service.request = args;
			service.addEventListener(ResultEvent.RESULT, onResult_getTracks );
			service.addEventListener(FaultEvent.FAULT, onFault_getTracks );
			
			service.send();
		}
		
		public function postTrack( trackVO:TrackVO ):void{
			
			Security.loadPolicyFile(SOUNDCLOUD_SECURE_API+"/crossdomain.xml");
			
			var urlRequest:URLRequest = new URLRequest( SOUNDCLOUD_SECURE_API +
										"/tracks?oauth_token=" + model.token.accessToken);
			urlRequest.contentType = "multipart/form-data";
			urlRequest.method = URLRequestMethod.POST;

			var requestParams:URLVariables = new URLVariables();
			requestParams["track[title]"] = trackVO.title;
			requestParams["track[sharing]"] = "private";
			requestParams["track[tag_list]"] = trackVO.tag_list.toString().replace(","," ");
			requestParams["track[description]"] = trackVO.description;
			urlRequest.data = requestParams;
			
			var file:FileReference = trackVO.file;
			file.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
			file.addEventListener( Event.COMPLETE, onUploadComplete );
			file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onUploadCompleteData );
			file.addEventListener( IOErrorEvent.IO_ERROR, onUploadIOError );
			file.addEventListener( HTTPStatusEvent.HTTP_RESPONSE_STATUS, onHTTPStatus );
			file.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			file.upload( urlRequest, "track[asset_data]" );
			
		}
		
		//*****************************************
		// HANDLERS
		//*****************************************	
		
		private function onResult_getToken( event : ResultEvent ) : void{
			var tokenVO:TokenVO = new TokenVO();
			tokenVO.setResponse( JSON.parse( event.result as String) );
			bus.getTokenResponse.dispatch( tokenVO );
			
			service.removeEventListener(ResultEvent.RESULT, onResult_getToken );
			service.removeEventListener(FaultEvent.FAULT, onFault_getToken );
		}
		
		private function onFault_getToken( event : FaultEvent ) : void{
			trace(event);
			service.removeEventListener(ResultEvent.RESULT, onResult_getToken );
			service.removeEventListener(FaultEvent.FAULT, onFault_getToken );
		}

		private function onResult_refreshToken( event : ResultEvent ) : void{
			var tokenVO:TokenVO = new TokenVO();
			tokenVO.setResponse( JSON.parse( event.result as String) );
			bus.getTokenResponse.dispatch( tokenVO );
			
			service.removeEventListener(ResultEvent.RESULT, onResult_refreshToken );
			service.removeEventListener(FaultEvent.FAULT, onFault_refreshToken );
		}
		
		private function onFault_refreshToken( event : FaultEvent ) : void{
			trace(event);
			service.removeEventListener(ResultEvent.RESULT, onResult_refreshToken );
			service.removeEventListener(FaultEvent.FAULT, onFault_refreshToken );

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
			bus.postTrackProgress.dispatch(event.bytesLoaded/event.bytesTotal);
		}
		
		public function onUploadComplete(event:Event):void{
			//wait for data. perhaps set a pending state.
		}

		public function onUploadCompleteData(event:DataEvent):void{
			trace(event.data);
			var xml:XML = new XML( event.data );
			bus.postTrackResponse.dispatch( xml );
		}
		
		public function onUploadIOError(event:IOErrorEvent):void{
			
		}
		
		public function onSecurityError(event:SecurityErrorEvent):void{
			
		}

		private function onResult_getTracks( event:ResultEvent ):void{
			service.removeEventListener(ResultEvent.RESULT, onResult_getTracks );
			service.removeEventListener(FaultEvent.FAULT, onFault_getTracks );
			
			var jsonObj:Object = JSON.parse( event.result as String);
			if( jsonObj.length > 0 ){
				bus.getTracksResult.dispatch( jsonObj );
			}
		}
		
		private function onStatus_getTracks( event :HTTPStatusEvent ) : void{
			trace(event);
		}
		
		private function onFault_getTracks( event:FaultEvent ):void{
			/*var errorEvent: ErrorEven = new ErrorEvent( ErrorEvent.ERROR );
			errorEvent.error = new Error( event.fault.faultDetail );
			dispatch( errorEvent );*/
			
			service.removeEventListener(ResultEvent.RESULT, onResult_getTracks );
			service.removeEventListener(FaultEvent.FAULT, onFault_getTracks );
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