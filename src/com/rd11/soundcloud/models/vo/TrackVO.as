package com.rd11.soundcloud.models.vo
{
	import flash.utils.ByteArray;

	public class TrackVO
	{
		public var title:String; 	 	//the title of the track
		public var asset_data:ByteArray;	 	//the original asset file
		public var artwork_data:ByteArray;	//the artwork file
		public var bpm:int;			 	//beats per minute
		public var description:String;	//a description
		public var downloadable:Boolean;
		public var genre:String;
		public var isrc:String;
		public var key_signature:String;	//enum	
		public var label_id:int;	
		public var label_name:String;
		public var purchase_url:String;
		public var release:String;
		public var release_day:int;	
		public var release_month:int;	
		public var release_year:int;	
		public var sharing:String		//(Public, Private) enum
		public var streamable:Boolean;
		public var tag_list:Array;
		public var track_type:String	//enum	
		public var video_url:String;
		public var license:Object;	//todo LicenseVO	
		public var shared_to:Array;	
		public var post_to:Array;	
		public var sharing_note:String;

		public function TrackVO():void
		{
			
		}
	}
}