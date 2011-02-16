package com.rd11.soundcloud.views.interfaces
{
	import org.osflash.signals.ISignal;

	public interface IPlayerView
	{
		function play( stream : String ):void;
		function get playRequest():ISignal;
	}
}