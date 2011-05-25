package com.rd11.soundcloud.models.vo
{
	public class TagVO
	{
		
		private var _lat:String;
		private var _lon:String;

		public var tag_list:Array;
		
		public var range:int = 2;
		
		public function setGeo(lat:Number, lon:Number):void{
			_lat = "geo:lat="+ lat.toFixed(range)+"*";
			_lon = "geo:lon="+ lon.toFixed(range)+"*";
		}
		
		public function TagVO()
		{
		}
	}
}