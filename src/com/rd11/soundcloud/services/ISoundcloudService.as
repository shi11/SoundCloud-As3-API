package com.rd11.soundcloud.services
{
	import com.rd11.soundcloud.models.vo.TagVO;
	import com.rd11.soundcloud.models.vo.TrackVO;
	
	import flash.events.EventDispatcher;
	import flash.net.FileReference;

	public interface ISoundcloudService
	{
		function getToken( clientId:String, clientSecret:String, grantType:String, redirectURI:String, code:String ):void;
		function refreshToken( clientId:String, clientSecret:String, grantType:String, refreshToken:String ):void;
		function getMe():void;
		function getTracks( tagVO:TagVO, range:int=2 ):void;
		function postTrack( trackVO:TrackVO ):void;
	}
}