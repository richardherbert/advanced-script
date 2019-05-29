component {
	function configure() {
		logBox = {
			appenders = {
				'dummy' = {
					class = 'coldbox.system.logging.appenders.DummyAppender'
				}
				,'application' = { // this application
					class = 'coldbox.system.logging.appenders.DBAppender'
					,properties = { dsn: '{{dsn}}', table: 'logs', autocreate: true, async: true }
				}
				,'framework' = { // coldbox framework
					class = 'coldbox.system.logging.appenders.DBAppender'
					,properties = { dsn: '{{dsn}}', table: 'logs', autocreate: true, async: true }
				}
			}
			,root = { levelMin: 'FATAL', levelmax: 'DEBUG', appenders: 'dummy' } // default logging is thrown away
			,categories = {
				'app.handlers' = { levelMin: 'FATAL', levelmax: 'DEBUG', appenders: 'application' }
				,'models.services' = { levelMin: 'FATAL', levelmax: 'DEBUG', appenders: 'application' }
			}
			,OFF = [ 'coldbox.system', 'qb', 'cbsecurity' ] // turn off all system messages
		};
	}
}
