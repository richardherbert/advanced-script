/**
* Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {
// Application properties
	this.name = left( 'appName_' & hash( getCurrentTemplatePath() ), 64 );

	this.applicationTimeout = createTimeSpan( 10,0,0,0 );
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan( 0,0,30,0 );
	this.setClientCookies = true;
	this.clientManagement = false;

// stop bots creating sessions
	if( structKeyExists( cookie,'JSESSIONID' ) || structKeyExists( cookie, 'CFTOKEN' ) ) {
		this.sessionTimeout = createTimeSpan( 0,0,120,0 );
	} else {
		this.sessionTimeout = createTimeSpan( 0,0,0,1 );
	}

	this.mappings[ '/app' ] = expandPath( '../app' );
	this.mappings[ '/coldbox' ] = expandPath( '../org/coldbox' );
	this.mappings[ '/testbox' ] = expandPath( '../org/testbox' );

	this.datasources[ '{{dns}}' ] = {
// required
		 type: 'mysql'
		,host: getProfileString( '.env', 'datasource', 'HOST' )
		,port: getProfileString( '.env', 'datasource', 'PORT' )
		,database: getProfileString( '.env', 'datasource', 'DATABASE' )
		,username: getProfileString( '.env', 'datasource', 'USERNAME' )
		,password: getProfileString( '.env', 'datasource', 'PASSWORD' )
// optional
		,connectionLimit: 100 // how many connections are allowed maximal (-1 == infiniti)
		// ,connectionTimeout: 1 // connection timeout in minutes (0 == connection is released after usage)
		,timezone: 'UTC'  // if set Lucee change the environment timezone
		,custom: { // a struct that contains type specific settings
			 useUnicode: true
			,useLegacyDatetimeCode: true
			,characterEncoding: 'UTF-8'
		}
	};

	this.datasource = '{{dns}}';

// Java Integration
	this.javaSettings = {
		loadPaths = [ '/app/lib' ],
		loadColdFusionClassPath = true,
		reloadOnChange= false
	};

// COLDBOX STATIC PROPERTY, DO NOT CHANGE UNLESS THIS IS NOT THE ROOT OF YOUR COLDBOX APP
	COLDBOX_APP_ROOT_PATH = getDirectoryFromPath( getCurrentTemplatePath() );
// The web server mapping to this application. Used for remote purposes or static purposes
	COLDBOX_APP_MAPPING = '';
// COLDBOX PROPERTIES
	COLDBOX_CONFIG_FILE = 'app.config.Coldbox';
// COLDBOX APPLICATION KEY OVERRIDE
	COLDBOX_APP_KEY = '';

	setLocale('English (UK)');
	setTimezone( 'UTC' );

	setEncoding( 'url', 'utf-8' );
	setEncoding( 'form', 'utf-8' );

// application start
	public boolean function onApplicationStart() {
		application.cbBootstrap = new coldbox.system.Bootstrap( COLDBOX_CONFIG_FILE, COLDBOX_APP_ROOT_PATH, COLDBOX_APP_KEY, COLDBOX_APP_MAPPING );
		application.cbBootstrap.loadColdbox();
		return true;
	}

// application end
	public void function onApplicationEnd( struct appScope ) {
		arguments.appScope.cbBootstrap.onApplicationEnd( arguments.appScope );
	}

// request start
	public boolean function onRequestStart( string targetPage ) {
// Process ColdBox Request
		application.cbBootstrap.onRequestStart( arguments.targetPage );

		return true;
	}

	public void function onSessionStart() {
		application.cbBootStrap.onSessionStart();
	}

	public void function onSessionEnd( struct sessionScope, struct appScope ) {
		arguments.appScope.cbBootStrap.onSessionEnd( argumentCollection=arguments );
	}

	public boolean function onMissingTemplate( template ) {
		return application.cbBootstrap.onMissingTemplate( argumentCollection=arguments );
	}
}
