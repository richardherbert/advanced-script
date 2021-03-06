component extends='BaseService' singleton {
	property name='QuickService' inject='quickService:User';

	property name='SessionStorage' inject='sessionStorage@cbstorages';
	property name='MailService' inject='mailService@cbmailservices';

	property name='renderer' inject='provider:coldbox:renderer';

	property name='HTMLBaseURL' inject='coldbox:setting:HTMLBaseURL';
	property name='adminEmailAddress' inject="coldbox:setting:adminEmailAddress";

	public UserService function init() {
		super.init();

		entityName = 'User';

		return this;
	}

	public struct function signin( required struct properties ) {
		param properties.emailAddress = '';
		param properties.password = '';

		var users = QuickService
			.where( 'emailAddress', properties.emailAddress )
			.get();

		if( users.len() != 1 ) {
			return {
				 isSuccess: false
				,isFailure: true
			};
		}

		var user = users.first();

		if( user.getPassword() != user.hashPassword( properties.password ) ) {
			logger.error( 'Password mismatch',  {
				 'userID': user.getID()
				,'ip': getClientIP()
				,'browser': cgi.http_user_agent
				} )

			return {
				isSuccess: false
				,isFailure: true
			};
		}

		SessionStorage.setVar( 'signedInUser', user );

		logger.info( 'User "#properties.emailAddress#" signed in', {
			 'userID': user.getID()
			,'ip': getClientIP()
			,'browser': cgi.http_user_agent
		} );

		return {
			 isSuccess: true
			,isFailure: false
			,message: 'Signed in'
		};
	}

	public struct function passwordReset( required string emailAddress ) {
		var users = QuickService
			.where( 'emailAddress', emailAddress )
			.get();

		if( users.len() != 1 ) {
			return {
				isSuccess: false
				,isFailure: true
			};
		}

		var user = users.first();

		var passwordResetToken = createUUID();
		var dateResetTokenExpires = dateAdd( 'n', 30, now() );

		var passwordResetLink = HTMLBaseURL & '/signin/passwordreset/token/';

		var resetTokenMail = MailService.newMail(
			from = 'Administrator <#adminEmailAddress#>'
			,to = emailAddress
			,subject = 'Masters Basketball Tournament - Password Reset Request'
			,bodyTokens = { passwordResetLink: passwordResetLink
				,token: passwordResetToken
			}
		);

		resetTokenMail.setBody( renderer.renderView( 'signin/forgottenpasswordemail' ) );

		user.update( {
			passwordResetToken: passwordResetToken
			,dateResetTokenExpires: dateResetTokenExpires
			,dateUpdated: now()
		} );

		var results = MailService.send( resetTokenMail );

		if( results.error ) {
			return {
				isSuccess: false
				,isFailure: true
			};
		}

		return {
			isSuccess: true
			,isFailure: false
		};
	}

	public struct function resetPassword( required struct properties ) {
		param arguments.properties.token = '';
		param arguments.properties.password = '';

		var users = QuickService
			.where( 'passwordResetToken', properties.token )
			.get();

		if( users.len() != 1 ) {
			return {
				isSuccess: false
				,isFailure: true
			};
		}

		var user = users.first();

		user.update( {
			password: properties.password
			,passwordResetToken: createUUID()
			,dateResetTokenExpires: now()
		} );

		return {
			isSuccess: true
			,isFailure: false
		};
	}






/*
	public struct function add( required struct properties ) {
		param string properties.firstname='';
		param string properties.lastname='';
		param string properties.emailAddress='';
		param string properties.languageID='';
		param string properties.roleID='';

		var dateCreated = dateUpdated = now();

		try {
			var record = QuickService
				.create( {
					firstname: properties.firstname
					,lastname: properties.lastname
					,emailAddress: properties.emailAddress
					,password: createUUID()
					,passwordSalt: createUUID()
					,languageID: properties.languageID
					,roleID: properties.roleID
					,dateCreated: dateCreated
					,dateUpdated: dateUpdated
				} );
		} catch( any exception ) {
			logger.error( 'An error has occurred adding the #entityName# "#properties.emailAddress#"', exception );

			return {
				isSuccess: false
				,isFailure: true
				,message: 'An error has occurred adding the #entityName# "#properties.emailAddress#"'
			};
		}

		return {
			isSuccess: true
			,isFailure: false
			,message: 'The #entityName# "#properties.firstname# #properties.lastname#" has been added'
		};
	}

	public struct function update( required struct properties ) {
		try {
			var record = QuickService
				.findOrFail( properties.id )
				.update( {
					firstname: properties.firstname
					,lastname: properties.lastname
					,emailAddress: properties.emailAddress
					,languageID: properties.languageID
					,roleID: properties.roleID
					,dateUpdated: now()
				} );
		} catch( any exception ) {
			logger.error( 'An error has occurred updating the #entityName#', exception )

			return {
				isSuccess: false
				,isFailure: true
				,message: 'An error has occurred updating the #entityName#'
			};

			throw( exception.message, 'Application', exception.detail );
		}

		return {
			isSuccess: true
			,isFailure: false
			,message: 'The #entityName# "#properties.firstname# #properties.lastname#" has been updated'
		};
	}

	public struct function signin( required struct properties ) {
		param properties.emailAddress = '';
		param properties.password = '';

		var users = QuickService
			.where( 'emailAddress', properties.emailAddress )
			.get();

		if( users.len() != 1 ) {
			return {
				isSuccess: false
				,isFailure: true
				,message: 'Sorry, your sign in details have not been recognised'
			};
		}

		var user = users.first();

		if( user.getPassword() != user.hashPassword( properties.password ) ) {
			logger.error( 'Password mismatch',  {
				'userID': user.getID()
				,'ip': getClientIP()
				,'browser': cgi.http_user_agent
				} )

			return {
				isSuccess: false
				,isFailure: true
				,message: 'Sorry, your sign in details have not been recognised'
			};
		}

		SessionStorage.setVar( 'signedInUser', user );

		logger.info( 'User "#properties.emailAddress#" signed in', {
			'userID': user.getID()
			,'ip': getClientIP()
			,'browser': cgi.http_user_agent
		} );

		return {
			isSuccess: true
			,isFailure: false
			,message: 'Signed in'
		};
	}




	public array function getActiveRecords( string sortOrder='lastname' ) {
		return super.getActiveRecords( entityName, sortOrder );
	}

	public struct function getDataTable( datatable ) {
		var searchValue = trim( datatable[ 'search[value]' ] );

		var records = QuickService
			.when( searchValue != '' && searchValue.len() > 2, function( qb ) {
				qb.where( 'name', 'like', '%#searchValue#%' )
			} )
			.andWhereNull( 'dateDeleted' )
			.offset( datatable.start )
			.take( datatable.length )
			.orderBy( 'lastname', 'ASC')
			.get();

		var recordsTotal = QuickService.count();
		var recordsFiltered = recordsTotal;

		var dataSet = {}

		var dataSet[ 'data' ] = [];

		records.each( function( record ) {
			dataSet[ 'data' ].append( {
				'0': encodeForHTML( record.getFirstname() )
				,'1': encodeForHTML( record.getLastname() )
				,'2': encodeForHTML( record.getEmailAddress() )
				,'3': encodeForHTML( record.getRole().getName() )
				,'DT_RowId': encodeForHTML( record.getID() )
			} );
		} );

		dataSet[ 'draw' ] = datatable.draw;
		dataSet[ 'recordsTotal' ] = recordsTotal;
		dataSet[ 'recordsFiltered' ] = recordsFiltered;

		return dataSet;
	}

	function setLocale( acceptLanguage='en-GB' ) {
		var preferredLocale = acceptLanguage.replace( '-', '_' );

		if( acceptLanguage.len() == 2 ) {
			preferredLocale = acceptLanguage & '_' & acceptLanguage.uCase();
		}

		try {
			var language = LanguageService.findOrFail( preferredLocale );
		} catch( any exception ) {
			preferredLocale = 'en_GB';
		}

		return preferredLocale
	}
*/

	private string function getClientIP() {
		var response = '';

		try {
			try {
				var headers = getHttpRequestData().headers;

				if( headers.keyExists( 'X-Forwarded-For' ) && headers[ 'X-Forwarded-For' ].len() > 0 ) {
					response = headers[ 'X-Forwarded-For' ].listFirst().trim();
				}
			} catch ( any exception ) {}

			if( response.len() == 0 ) {
				if( cgi.keyExists( 'remote_addr' ) && cgi.remote_addr.len() > 0 ) {
					response = cgi.remote_addr;
				} else if( cgi.keyExists( 'remote_host' ) && cgi.remote_host.len() > 0 ) {
					response = cgi.remote_host;
				}
			}
		} catch ( any exception ) {}

		return response;
	}
}
