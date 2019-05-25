component extends='BaseHandler' {
	function index( event, rc, prc ) {
		prc.welcomeMessage = 'Welcome to ColdBox!';

		event.setView( 'default/index' );
	}

// Do something
	function doSomething( event, rc, prc ) {
		relocate( 'default.index' );
	}
}
