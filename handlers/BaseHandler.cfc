component extends='coldbox.system.EventHandler' {
	property name='SecurityService' inject='services.SecurityService';

	property name='logger' inject='logbox:logger:{this}';

	function init( required controller ) {
		super.init( controller );

		return this;
	}

	function preHandler( event, action, eventArguments, rc, prc ) {
		event.paramPrivateValue( 'SecurityService', SecurityService );
		event.paramPrivateValue( 'MessageManager', getInstance( 'messagebox@cbmessagebox' ) );
	}
}
