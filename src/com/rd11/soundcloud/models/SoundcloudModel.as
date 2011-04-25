////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.models
{
	//import flash.filesystem.File;
	import com.rd11.soundcloud.models.vo.CredentialVO;
	import com.rd11.soundcloud.models.vo.TokenVO;
	
	import flash.net.SharedObject;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.iotashan.oauth.OAuthToken;
	import org.robotlegs.mvcs.Actor;
	
	public class SoundcloudModel extends Actor
	{
		
		/**
		 * current version of users app 
		 */		
		public var currentVersion:String;
		
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
		
		/**
		 *constructor 
		 */		
		public function SoundcloudModel()
		{
			super();
		}

		/**
		 * log for service results 
		 */		
		private var _log:String;

		public function set log(value:String):void{
			_log = value;
		}
		
		public function get log():String{
			return _log;	
		}

		/**
		 * accesstoken 
		 */
		private var _token : TokenVO;
		
		public function get token():TokenVO
		{
			return _token;
		}

		public function set token(value:TokenVO):void
		{
			_token = value;
		}

		/**
		 * credentials used for oauth
		 * **/
		private var _credentials:CredentialVO;
		
		public function get credentials():CredentialVO
		{
			return _credentials;
		}

		public function set credentials(value:CredentialVO):void
		{
			_credentials = value;
		}

		
	}
}