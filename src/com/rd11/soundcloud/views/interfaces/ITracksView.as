package com.rd11.soundcloud.views.interfaces
{
	import org.osflash.signals.ISignal;

	public interface ITracksView
	{
		function get nearbyRequest():ISignal;
		function tracksResult( array : Array ) : void;	
		function get trackSelected():ISignal;
	}
}