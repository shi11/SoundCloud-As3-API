package com.rd11.soundcloud.models.vo
{
	/**
	 * this holds the credentials for soundcloud
	 * @author shillinger
	 * 
	 */	
	public class CredentialVO
	{
		private var _clientID:String;
		private var _clientSecret:String;
		private var _redirectUri:String;
		
		public function CredentialVO( clientId:String, clientSecret:String, redirectUri:String ):void{
			_clientID = clientId;
			_clientSecret = clientSecret;
			_redirectUri = redirectUri;
		}
		
		public function get clientId():String{
			if( _clientID == "" ){
				throw new Error("missing client_id");
			}
			return _clientID;
		}
		public function get clientSecret():String{
			if( _clientSecret == "" ){
				throw new Error("missing client_secret");
			}
			return _clientSecret;
		}
		public function get redirectUri():String{
			if( _redirectUri == "" ){
				throw new Error("missing redirect_uri");
			}
			return _redirectUri;
		}
	}
}