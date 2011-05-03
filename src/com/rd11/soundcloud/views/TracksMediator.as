package com.rd11.soundcloud.views
{
	import com.rd11.soundcloud.models.vo.TagVO;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	import com.rd11.soundcloud.views.interfaces.ITracksView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TracksMediator extends Mediator
	{
		
		[Inject]
		public var view:ITracksView;
		
		[Inject]
		public var bus:SoundcloudSignalBus;
		
		public function TracksMediator()
		{
			super();
		}
		
		override public function onRegister() : void{
			view.nearbyRequest.add( getNearbyTracks );
			bus.nearbyResult.add( onResults_tracks );
			view.trackSelected.add( onTrackSelected );
		}
		
		protected function getNearbyTracks(lat:Number, long:Number) : void{
			var tagVO:TagVO = new TagVO();
			tagVO.lat = lat;
			tagVO.lon = long;
			bus.nearbyRequest.dispatch( tagVO );
		}
		
		protected function onResults_tracks( array : Array ) : void{
			view.tracksResult( array );
		}
		
		//todo: make trackVO
		protected function onTrackSelected( value:Object ) : void{
			bus.trackSelected.dispatch( value );
		}
	}
}