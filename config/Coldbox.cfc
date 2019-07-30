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
			viewCaching = true,
// will automatically do a mapDirectory() on your `models` for you.
			autoMapModels = true
		};

// custom settings
		settings = {
			 adminEmailAddress: 'admin@{{domain}}.{{tld}}'
			,github: {
				owner: '{{githubOwner}}'
			   ,repo: '{{githubRepo}}'
			   ,branchRef: '{{githubBranch}}'
		   }
		};

		dotenv = {
			fileName = '../.ini'
		}

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
				,domain: '{{subdomain}}.{{domain}}.{{tld}}'
			}
			,cbgithub = {
				token: getProfileString( expandPath( '../.ini' ), 'cbgithub', 'GITHUB_TOKEN' )
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

	function detectEnvironment() {
		var environment = getProfileString( expandPath( '../.ini' ), 'application', 'ENVIRONMENT' );

		if( environment == '' ) {
			return 'production';
		}

		return environment;
	}

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

		settings.github.branchRef = 'cbgithub'
	}
}
