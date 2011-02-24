package com.rd11.soundcloud.models.vo
{
	[RemoteClass(alias="soundcloud.models.vo.TokenVO")]
	public class TokenVO
	{
		//request: passed into constructor
		public var clientId:String;
		public var clientSecret:String;
		public var grantType:String;
		public var redirectURI:String;
		public var code:String;
		
		//response: passed in through response setter
		public var accessToken:String;
		public var expiresIn:int;
		public var refreshToken:String;
		public var scope:String;
		
		//used for expiresIn
		public var dateSaved:int;
		
		public function TokenVO(){
		}
		
		public function setRequest(_clientId:String, _clientSecret:String, _grantType:String, _redirectURI:String, _code:String):void{
			clientId = _clientId;
			clientSecret = _clientSecret;
			grantType = _grantType;
			redirectURI = _redirectURI;
			code = _code;	
		}
		
		//from json
		public function setResponse( value : Object ) : void{
			accessToken = value.access_token;
			expiresIn = value.expires_in;
			refreshToken = value.refresh_token;
			scope = value.scope;
		}

	}
}