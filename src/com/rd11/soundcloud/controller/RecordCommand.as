////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.models.vo.TrackVO;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class RecordCommand extends Command
	{
		[Inject]
		public var service : ISoundcloudService;
		
		[Inject]
		public var bus : SoundcloudSignalBus;
		
		[Inject]
		public var model : SoundcloudModel;
		
		[Inject]
		public var trackVO : TrackVO;
		
		public function RecordCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.postTrackResponse.add( onResult_postTrack );
			postTrack( trackVO );
		}
		
		private function onResult_postTrack( results : Array ):void{
			
		}
		
		private function postTrack( trackVO:TrackVO ):void{
			service.postTrack( trackVO, model.accessToken );
		}
	}	
}