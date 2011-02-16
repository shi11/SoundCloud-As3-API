////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class PlayerCommand extends Command
	{
		[Inject]
		public var service : ISoundcloudService;
		
		[Inject]
		public var bus : SoundcloudSignalBus;
		
		[Inject]
		public var model : SoundcloudModel;
		
		private static const CLIENT_ID:String = "AZNJgoblAU8ykZNDnCl7Q";
		
		public function PlayerCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.playRequest.add( startPlay );
		}
		
		private function startPlay( stream : String):void{
			//bus.playResponse.dispatch( stream +"?oauth_token=" + model.accessToken );
			bus.playResponse.dispatch( stream +"?consumer_key=" + CLIENT_ID );
		}
	}	
}