////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: Feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud
{
	import com.rd11.soundcloud.controller.PlayerCommand;
	import com.rd11.soundcloud.controller.SaveCommand;
	import com.rd11.soundcloud.controller.SearchCommand;
	import com.rd11.soundcloud.controller.StartupCommand;
	import com.rd11.soundcloud.controller.TokenCommand;
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.services.SoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.SignalContext;
	
	public class SoundcloudContext extends SignalContext
	{
		
		public static var soundcloudSignalBus:SoundcloudSignalBus;
		
		public function SoundcloudContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super();
		}
		
		
		public static function get bus():SoundcloudSignalBus{
			return soundcloudSignalBus;
		}
		
		override public function startup():void
		{
			soundcloudSignalBus = new SoundcloudSignalBus();
			injector.mapValue( SoundcloudSignalBus, soundcloudSignalBus );
			
			signalCommandMap.mapSignal( soundcloudSignalBus.startupRequest, StartupCommand );
			signalCommandMap.mapSignal( soundcloudSignalBus.nearbyRequest, SearchCommand );
			signalCommandMap.mapSignal( soundcloudSignalBus.getTokenRequest, TokenCommand );
			signalCommandMap.mapSignal( soundcloudSignalBus.refreshTokenRequest, TokenCommand );
			signalCommandMap.mapSignal( soundcloudSignalBus.playRequest, PlayerCommand );
			signalCommandMap.mapSignal( soundcloudSignalBus.postTrackRequest, SaveCommand );
			
			//map model
			injector.mapSingleton( SoundcloudModel );
			
			//map service
			injector.mapSingletonOf( ISoundcloudService, SoundcloudService );
		}
		
	}
}