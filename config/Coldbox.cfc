component {
// configure coldbox application
	function configure() {
// coldbox directives
		coldbox = {
// application setup
			appName = 'appName',
			eventName = 'event',

// production settings
			reinitPassword = '',
			handlersIndexAutoReload = false,

// implicit events
			defaultEvent = '',
			requestStartHandler = 'Default.onRequestStart',
			requestEndHandler = '',
			applicationStartHandler = 'Default.onAppInit',
			applicationEndHandler = '',
			sessionStartHandler = '',
			sessionEndHandler = '',
			missingTemplateHandler = '',

// extension points
			applicationHelper = '/app/includes/helpers/ApplicationHelper.cfm',
			viewsHelper = '',
			modulesExternalLocation = [ '/app/modules' ],
			viewsExternalLocation = '/app/views',
			layoutsExternalLocation = '/app/layouts',
			handlersExternalLocation = 'app.handlers',
			requestContextDecorator = '',
			controllerDecorator = '',

// error/exception handling
			invalidHTTPMethodHandler = '',
			exceptionHandler = 'Default.onException',
			invalidEventHandler = '',
			customErrorTemplate = '',

// application aspects
			handlerCaching = true,
			eventCaching = true,
			viewCaching = true
		};

// custom settings
		settings = {};

// environment settings, create a detectenvironment() method to detect it yourself.
// create a function with the name of the environment so it can be executed if that environment is
// detected the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = 'localhost,^127\.0\.0\.1'
		};

// module directives
		modules = {
			include = [], // an array of modules names to load, empty means all of them
			exclude = [] // an array of modules names to not load, empty means none
		};

// logbox dsl
		logBox = {
// define appenders
			appenders = {
				coldboxTracer = { class='coldbox.system.logging.appenders.ConsoleAppender' }
			},
// root logger
			root = { levelmax='INFO', appenders='*' },
// implicit level categories
			info = [ 'coldbox.system' ]
		};

// layout settings
		layoutSettings = {
			defaultLayout = '',
			defaultView = ''
		};

// interceptor settings
		interceptorSettings = {
			customInterceptionPoints = ''
		};

// register interceptors as an array, we need order
		interceptors = [];
	}

/**
* Development environment
*/
	function development() {
		coldbox.reinitPassword = '1';

		coldbox.handlersIndexAutoReload = true;
		coldbox.handlerCaching = false;
		coldbox.eventCaching = false;
		coldbox.viewCaching = false;

		coldbox.customErrorTemplate = '/coldbox/system/includes/BugReport.cfm';

		wirebox.singletonReload = true;
	}
}
