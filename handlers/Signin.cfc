component extends='BaseHandler' {
	property name='UserService' inject='UserService';

	property name='SessionStorage' inject='sessionStorage@cbstorages';

	function preHandler( event, action, eventArguments, rc, prc ) {
		super.preHandler( event, action, eventArguments, rc, prc );

		entityName = 'User';

		event.setLayout( 'blank' );
	}

	function index( event, rc, prc ) {}

	function signout( event, rc, prc ) {
		SessionStorage.clearAll();

		relocate( 'signin' );
	}

	function action( event, rc, prc ) {
		event.paramValue( 'emailAddress', '' );
		event.paramValue( 'password', '' );

		var validationResults = validateModel(
			target=populateModel( entityName )
			,constraints={
				'EmailAddress': { required: true, size: '1..255', type: 'email' }
				,'Password': { required: true }
			}
		);

		if( validationResults.hasErrors() ) {
			logger.error( 'Email address and or password not provided', validationResults.getErrorsAsStruct() )

			relocate( event='signin', persist=rc.fieldnames );
		}

		var response = UserService.signin( rc );

		if ( response.isFailure ) {
			MessageManager.setMessage(
				 type='error'
				,message='Sorry, your sign in details have not been recognised'
			);

			SessionStorage.deleteVar( 'signedInUser' );

			relocate( 'signin' );
		}

		relocate( 'dashboard' );
	}

	function forgottenPassword( event, rc, prc ) {}

	function forgottenPasswordAction( event, rc, prc ) {
		event.paramValue( 'emailAddress', '' );

		var validationResults = getValidationManager().validate(
			target=rc
			,constraints={
				emailAddress: {
					 required: true
					,size: '1..255'
					,type: 'email'
					,requiredMessage: 'An email address is required'
					,sizeMessage: 'The email address length is not valid'
					,typeMessage: 'The email address is not valid'
				}
			}
		);

		if( validationResults.hasErrors() ) {
			MessageManager.setMessage(
				 type='error'
				,messageArray=validationResults.getAllErrors()
			);

			relocate( 'signin.forgottenpassword' );
		}

		var users = UserService
			.where( 'emailAddress', rc.emailAddress )
			.get();

		if( users.len() != 1 ) {
			MessageManager.setMessage(
				type='error'
				,message='Sorry, there is problem with the email address you provided'
			);

			relocate( 'signin.forgottenpassword' );
		}

		var user = users.first();

		var response = UserService.passwordReset( rc.emailAddress );

		if( response.isFailure ) {
			MessageManager.setMessage(
				type='error'
				,message='Sorry, there is problem with the email address you provided'
			);

			relocate( 'signin.forgottenpassword' );
		}

		MessageManager.setMessage(
			type='success'
			,message='An email has been sent to your inbox with the details on how to choose a new password'
		);

		relocate( 'signin' );
	}

	function passwordReset( event, rc, prc ) {
		event.paramValue( 'token', '' );

		event.setView( 'signin/passwordreset' );
	}

	function passwordResetAction( event, rc, prc ) {
		var validationResults = getValidationManager().validate(
			target=rc
			,constraints={
				password: {
					required: true
					,requiredMessage: 'A Password is required'
				}
				,passwordConfirm: {
					required: true
					,sameAs: 'password'
					,sameAsMessage: 'The new password does not match the confirmation password'
				}
			}
		);

		if( validationResults.hasErrors() ) {
			MessageManager.setMessage(
				type='error'
				,messageArray=validationResults.getAllErrors()
			);

			relocate( 'signin.passwordreset.token.#rc.token#' );
		}

		var response = UserService.resetPassword( rc );

		if( response.isFailure ) {
			MessageManager.setMessage(
				type='error'
				,message='Sorry, that token is no longer valid'
			);

			relocate( 'signin.forgottenpassword' );
		}

		MessageManager.setMessage(
			type='success'
			,message='Your password has been reset. Please use it here to sign in'
		);

		relocate( 'signin' );
	}
}
