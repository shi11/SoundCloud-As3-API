////////////////////////////////////////////////////////////
// Project: soundcloud 
// Author: Seth Hillinger
// Created: feb 12, 2011
////////////////////////////////////////////////////////////

package com.rd11.soundcloud.controller
{
	import com.rd11.soundcloud.models.SoundcloudModel;
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
		public var lat : Number;

		[Inject]
		public var long : Number;
		
		public function SearchCommand()
		{
			super();
		}
		
		override public function execute():void{
			bus.nearbyResult.add( onResults_getTracks );
			getTracks(lat, long);
		}
		
		/**
		 * queries foursquare and returns venue's nearby 
		 * @param keywords (optional) search
		 * 
		 */		
		private function getTracks(lat:Number, lon:Number):void{
			service.getTracks(int(lat), int(long) );
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