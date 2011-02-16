package com.rd11.soundcloud.models.vo
{
	public class TokenVO
	{
		private var _clientId:String;
		private var _clientSecret:String;
		private var _grantType:String;
		private var _redirectURI:String;
		private var _code:String;
		
		public function TokenVO(clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String)
		{
			_clientId = clientId;
			_clientSecret = clientSecret;
			_grantType = grantType;
			_redirectURI = redirectURI;
			_code = code;
		}

		public function get clientId():String
		{
			return _clientId;
		}

		public function get clientSecret():String
		{
			return _clientSecret;
		}

		public function get grantType():String
		{
			return _grantType;
		}

		public function get redirectURI():String
		{
			return _redirectURI;
		}

		public function get code():String
		{
			return _code;
		}


	}
}