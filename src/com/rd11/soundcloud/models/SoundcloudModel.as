////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.models
{
	//import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Actor;
	
	public class SoundcloudModel extends Actor
	{
		
		/**
		 * log for service results 
		 */		
		private var _log:String;
		
		/**
		 * current version of users app 
		 */		
		public var currentVersion:String;
		
		/**
		 * accesstoken 
		 */		
		public var accessToken : String;
		
		//TODO Seth: remove this.
		public var oauth_token : OAuthToken;
		
		/**
		 * used for autologin 
		 */		
		public var rememberMe:Boolean;
		
		/**
		 * logged in user's id. 
		 */		
		public var myId:int;
		
		/**
		 * user dictionary.
		 */		
		public var users:Dictionary = new Dictionary();
		
		/**
		 * checkin feed 
		 */		
		public var feed:ArrayCollection=new ArrayCollection();
		
		public function SoundcloudModel()
		{
			super();
			//oauthFile = File.applicationStorageDirectory.resolvePath("user/oauth_token.xml");
		}
		
		public function log(value:String):void{
			_log = value;
		}
		
	}
}