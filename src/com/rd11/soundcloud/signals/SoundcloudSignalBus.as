package com.rd11.soundcloud.signals
{
	import com.rd11.soundcloud.models.vo.TokenVO;
	import com.rd11.soundcloud.models.vo.TrackVO;
	
	import flash.utils.ByteArray;
	
	import org.osflash.signals.Signal;
	
	public class SoundcloudSignalBus
	{

		public const startupRequest:Signal = new Signal();
		
		public const authenticationRequest:Signal = new Signal( String, String, String );
		public const authenticationResult:Signal = new Signal( String );
		
		public const getTokenRequest:Signal = new Signal( TokenVO, Boolean ); 
		public const getTokenResponse:Signal = new Signal( TokenVO ); 

		public const refreshTokenRequest:Signal = new Signal( TokenVO, Boolean ); 
		public const refreshTokenResponse:Signal = new Signal( TokenVO ); 
		
		public const nearbyRequest:Signal = new Signal( Number, Number );
		public const nearbyResult:Signal = new Signal( Array );
		
		public const playRequest:Signal = new Signal( String );
		public const playResponse:Signal = new Signal( String );
		
		public const postTrackRequest:Signal = new Signal( TrackVO );
		public const postTrackResponse:Signal = new Signal( String );
		
		
	}
}