////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.models.vo.TagVO;
	import com.rd11.soundcloud.services.ISoundcloudService;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Command;
	
	
	public class SearchCommand extends Command
	{
		[Inject]
		public var service : ISoundcloudService;
		
		[Inject]
		public var bus : SoundcloudSignalBus;
		
		[Inject]
		public var model : SoundcloudModel;
		
		[Inject]
		public var tagVO : TagVO;

		public function SearchCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.getTracksResult.add( onResults_getTracks );
			getTracks(tagVO);
		}
		
		/**
		 * queries foursquare and returns venue's nearby 
		 * @param keywords (optional) search
		 * 
		 */		
		private function getTracks(tagVO:TagVO):void{
			service.getTracks( tagVO );
		}
		
		/**
		 * handles query results 
		 * @param results
		 * 
		 */		
		private function onResults_getTracks(results : Array):void{
			//bus.nearbyResult.dispatch( results );
		}
	}	
}