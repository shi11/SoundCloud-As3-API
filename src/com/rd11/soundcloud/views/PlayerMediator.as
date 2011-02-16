package com.rd11.soundcloud.views
{
	import com.rd11.soundcloud.models.SoundcloudModel;
	import com.rd11.soundcloud.signals.SoundcloudSignalBus;
	import com.rd11.soundcloud.views.interfaces.IPlayerView;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class PlayerMediator extends Mediator
	{
		
		[Inject]
		public var soundcloudBus:SoundcloudSignalBus;
		
		[Inject]
		public var view:IPlayerView;
		
		public function PlayerMediator()
		{
			super();
		}
		
		override public function onRegister():void{
			view.playRequest.add( requestPlay );
			soundcloudBus.playResponse.add( play );
		}
		
		private function requestPlay( stream:String ):void{
			soundcloudBus.playRequest.dispatch( stream );
		}
		
		private function play( stream : String ) : void{
			if( stream && stream != ""){
				view.play( stream );
			}			
		}
		
	}
}