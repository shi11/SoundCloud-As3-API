# Soundcloud AS3 wrapper
This is a Soundcloud API WRAPPER written in AS3. It uses the robotlegs framework with as3 signals.

# Installation
The simplest way to use it is to download the <a href="https://github.com/shi11/SoundCloud-As3-API/archives/master">SoundcloudAPI.swc</a> and drop it into the lib directory of your project.
Otherwise I would checkout it out and compile your own .swc

## Usage
Better examples to come.

If you're familiar with Robotlegs then posting a track is as simple as doing this:

1. In yourAppContext add credentials

	soundcloudBus.startupRequest.dispatch( new CredentialVO( SoundcloudCredentials.CLIENT_ID, SoundcloudCredentials.CLIENT_SECRET, SoundcloudCredentials.REDIRECT_URI ));

2. In a mediator, Post a new track

	//Inject the signal bus <br />
	[Inject] <br />
	public var soundcloudBus:SoundcloudSignalBus;		
	soundcloudBus.postTrackRequest.dispatch( trackVO );

3. In a command, handle post response

	[Inject]<br />
	public var soundcloudBus:SoundcloudSignalBus;		
	soundcloudBus.postTrackResponse.add( onResult_postTrack );

# TODO
<ol>
<li>Write better documentation</li>
<li>Test soundcloud oauth refresh token</li>
<li>Continue fleshing out the API</li>
</ol>