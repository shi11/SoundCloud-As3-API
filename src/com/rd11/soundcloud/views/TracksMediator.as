package com.rd11.soundcloud.views
{
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
		}
		
		private function getNearbyTracks(lat:Number, long:Number) : void{
			bus.nearbyRequest.dispatch( lat, long );
		}
		
		private function onResults_tracks( array : Array ) : void{
			view.tracksResult( array );
		}
	}
}