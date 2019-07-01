component table='users' extends='BaseBean' accessors=true {
// component table='users' extends='BaseBean' scope='session' accessors=true {
	property name='title';
	property name='givenName';
	property name='familyName';

	property name='emailAddress';
	// property name='roleID';

	property name='passwordSalt';
	property name='password';

	property name='languageID';

	property name='passwordResetToken';
	property name='dateResetTokenExpires';

	property name='applicationPasswordSalt' inject='coldbox:setting:APPLICATIONPASSWORDSALT' persistent=false;
	property name='hashIterations' inject='coldbox:setting:HASHITERATIONS' persistent=false;

	this.constraints = {
		 'Title': { size: '0..255' }
		,'GivenName': { required: true, size: '1..255' }
		,'FamilyName': { required: true, size: '1..255' }
		,'EmailAddress': { required: true, size: '1..255', type: 'email' }
		,'Password': { required: true }
	};

	User function init() {
		super.init();

		if( server.coldfusion.productName == 'ColdFusion Server' ) {
			hashIterations -= 1;
		}

		return this;
	}

	function setPassword( required string password ) {
		return assignAttribute( 'password', hashPassword( password ) );
	}

	function hashPassword( required string password ) {
		var passwordHash = hash( password & retrieveAttribute( 'passwordSalt' )
			& applicationPasswordSalt, 'SHA-512', 'UTF-8', hashIterations );

		return passwordHash;
	}



/*
	function role() { // a user has a role
		return belongsTo( 'Role' );
	}

	function language() { // a user has a language
		return belongsTo( 'Language' );
	}

	boolean function hasRole( required string role ) {
		if( this.getRole().getName() == role ) {
			return true;
		}

		return false;
	}
*/

	function getFullname() {
		return retrieveAttribute( 'firstname' ) & ' ' &retrieveAttribute( 'lastname' );
	}
}
