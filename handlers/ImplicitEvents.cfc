component extends='BaseHandler' {
	function onApplicationStart( event, rc, prc ) {
		setSetting( 'cacheBuster', createUUID() );
	}

	function onRequestStart( event, rc, prc ) {}

	function onRequestEnd( event, rc, prc ) {}

	function onSessionStart( event, rc, prc ) {}

	function onSessionEnd( event, rc, prc ) {
		var sessionScope = event.getValue('sessionReference');
		var applicationScope = event.getValue('applicationReference');
	}

	function onException( event, rc, prc ) {
		event.setHTTPHeader( statusCode = 500 );
		//Grab Exception From private request collection, placed by ColdBox Exception Handling
		var exception = prc.exception;
		//Place exception handler below:
	}

	function invalidEvent( event, rc, prc ) {
		echo( 'Event "#rc.event#" not found' );
		abort;

		writedump( var='#arguments#', label='arguments', expand=0, abort=1 );
	}
}
