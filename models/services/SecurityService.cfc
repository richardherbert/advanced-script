component extends='BaseService' singleton {
	property name='SessionStorage' inject='sessionStorage@cbstorages';

	public SecurityService function init() {
		super.init();

		return this;
	}

	public boolean function userValidator( required struct rule, required any controller ) {
		if( SessionStorage.exists( 'signedInUser' ) ) {
			return true;
		} else {
			return false;
		}
	}

	public boolean function isEventAuthorised( required string eventName ) {
		var signedInUser = SessionStorage.getVar( 'signedInUser', createObject( 'component', 'models.beans.Administrator' ).init() );

		var rules = queryExecute(
			'SELECT * FROM cbsecurity ORDER BY sortOrder'
		);

// results have to be set explicitely at each evaluation, otherwise the logic is not valid
		var thisRole = '';
		var whiteListed = false;
		var hasRole = false;

// loop through each rule and see if the event matches
		for( var i = 1; i <= rules.recordcount; i++ ) {
// first check the whitelist, if there is a match go to the next rule
			if( _isEventInPattern( eventName, rules.whitelist[ i ] ) ) {
				whiteListed = true;

// if whitelisted just skip this rule
				continue;
			} else {
				whiteListed = false;
			};

// look at securelist rule and see if this event is in the pattern
			if( _isEventInPattern( eventName, rules.securelist[ i ] ) ) {

// set the result to false until you find a Role
				hasRole = false;

// check roles
				for( var j = 1; j <= listLen( rules.roles[ i ] ); j++ ) {
					thisRole = trim( listgetAt( rules.roles[ i ], j ) );
					hasRole = signedInUser.hasRole( thisRole );

					if( hasRole ) return true;
				};

// still no Role after evealuation all roles? But in securelist
// in this case return false and stop evaluating rules
				if( not hasRole ) return false;
			};
		};

// if you match securelist, you will not arrive here,
// After the last evaluated rule and you are whitelisted you can continue (return true)
// if your last rule did not match on whitelist you can't continue. So return false.
		return whiteListed;
	}

	private boolean function _isEventInPattern(
		required string eventName
		,required string patternList
	) {
		var pattern = '';

		for( var i=1; i <= listLen( patternList ); i++ ) {
			pattern = listGetAt( patternList,i );

// return true if match is in the list
			if( reFindNocase( trim( pattern ), eventName ) ) return true;
		}

		return false;
	}
}
