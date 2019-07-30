component {
// configure coldbox application
	function configure() {
// coldbox directives
		coldbox = {
// application setup
			appName = '{{appName}}',
			eventName = 'event',

// production settings
			reinitPassword = '{{reinitPassword}}',
			handlersIndexAutoReload = false,

// implicit events
			defaultEvent = 'Default.index',

			requestStartHandler = 'ImplicitEvents.onRequestStart',
			requestEndHandler = 'ImplicitEvents.onRequestEnd',
			applicationStartHandler = 'ImplicitEvents.onApplicationStart',
			applicationEndHandler = 'ImplicitEvents.onApplicationEnd',
			sessionStartHandler = 'ImplicitEvents.onSessionStart',
			sessionEndHandler = 'ImplicitEvents.onSessionEnd',
			missingTemplateHandler = 'ImplicitEvents.onMissingTemplate',

// extension points
			applicationHelper = 'includes/helpers/ApplicationHelper.cfm',
			viewsHelper = '',
			modulesExternalLocation = [ '' ],
			viewsExternalLocation = '',
			layoutsExternalLocation = '',
			handlersExternalLocation = '',
			requestContextDecorator = '',
			controllerDecorator = '',

// error/exception handling
			invalidHTTPMethodHandler = '',
			exceptionHandler = 'ImplicitEvents.onException',
			invalidEventHandler = 'ImplicitEvents.invalidEvent',
			customErrorTemplate = '',

// application aspects
			handlerCaching = true,
			eventCaching = true,
			viewCaching = true
		};

// custom settings
		settings = {
			adminEmailAddress: 'admin@{{domin}}.{{tld}}'
		};

// environment settings, create a detectenvironment() method to detect it yourself.
// create a function with the name of the environment so it can be executed if that environment is
// detected the value of the environment is a list of regex patterns to match the cgi.http_host.
		environments = {
			development = '^{{domain}},^localhost,^127\.0\.0\.1'
		};

		mailsettings = {
			tokenMarker = '@'
			,port: '25'
			,protocol = {
				class: 'mailgunprotocol.models.protocols.mailgunProtocol'
			}
		};

		moduleSettings = {
			mailguncfc = {
				 secretApiKey: '{{mailgunAPIKey}}'
				,publicApiKey: '{{mailgunAPIPublicKey}}'
				,domain: '{{domain}}.{{tld}}'
			}
		};

// module directives
		modules = {
			include = [], // an array of modules names to load, empty means all of them
			exclude = [] // an array of modules names to not load, empty means none
		};

// logbox dsl
		logBox = {
			configFile = 'config/LogBox'
		};

// layout settings
		layoutSettings = {
			defaultLayout = 'default'
			,defaultView = 'index'
		};

// interceptor settings
		interceptorSettings = {
			customInterceptionPoints = ''
		};

// register interceptors as an array, we need order
		interceptors = [
			{
				name : 'ApplicationSecurity'
				,class: 'cbsecurity.interceptors.Security'
				,properties: {
					 validatorModel: 'models.services.SecurityService'
					,rulesSource: 'db'
					,rulesDSN: '{{dsn}}'
					,rulesTable: 'cbsecurity'
					,rulesOrderBy: 'sortOrder'
				}
			}
		];
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

		mailsettings.server = 'localhost';
		mailsettings.port = '2525';
		mailsettings.username = '';
		mailsettings.password = '';
		mailsettings.protocol.class = 'modules.cbmailservices.models.protocols.CFMailProtocol';
	}
}
