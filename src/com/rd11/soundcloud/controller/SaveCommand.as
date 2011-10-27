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
	
	import flash.events.EventDispatcher;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class SaveCommand extends Command
	{
		[Inject]
		public var service : ISoundcloudService;
		
		[Inject]
		public var bus : SoundcloudSignalBus;
		
		[Inject]
		public var model : SoundcloudModel;
		
		[Inject]
		public var trackVO : TrackVO;
		
		public function SaveCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.postTrackResponse.add( onResult_postTrack );
			postTrack( trackVO );
		}
		
		private function onResult_postTrack( results : XML ):void{
		}
		
		private function postTrack( trackVO:TrackVO ):void{
			service.postTrack( trackVO );
		}
	}	
}