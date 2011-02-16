package com.rd11.soundcloud.services
{
	public interface ISoundcloudService
	{
		function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void;
		function getTracks(lat:Number, long:Number):void;
	}
}