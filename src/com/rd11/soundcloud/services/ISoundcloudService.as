package com.rd11.soundcloud.services
{
	import com.rd11.soundcloud.models.vo.TrackVO;

	public interface ISoundcloudService
	{
		function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void;
		function refreshToken( clientId:String, clientSecret:String, grantType:String, refreshToken:String ):void;
		
		function getTracks(lat:Number, long:Number):void;
		function postTrack( trackVO:TrackVO ):void;
	}
}