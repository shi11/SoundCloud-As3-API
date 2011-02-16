package com.rd11.soundcloud.signals
{
	import com.rd11.soundcloud.models.vo.TokenVO;
	
	import org.osflash.signals.Signal;
	
	public class SoundcloudSignalBus
	{

		public const startupRequest:Signal = new Signal();
		
		public const authenticationRequest:Signal = new Signal( String, String, String );
		public const authenticationResult:Signal = new Signal( String );
		
		public const tokenRequest:Signal = new Signal( TokenVO ); 
		public const tokenResponse:Signal = new Signal( String ); 
		
		public const nearbyRequest:Signal = new Signal( Number, Number );
		public const nearbyResult:Signal = new Signal( Array );
		
		public const playRequest:Signal = new Signal( String );
		public const playResponse:Signal = new Signal( String );
	}
}