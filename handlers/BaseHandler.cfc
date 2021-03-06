component extends='coldbox.system.EventHandler' {
	property name='SecurityService' inject='services.SecurityService';
	property name='MessageManager' inject='messagebox@cbmessagebox';

	property name='logger' inject='logbox:logger:{this}';

	function init( required controller ) {
		super.init( controller );

		return this;
	}

	function preHandler( event, action, eventArguments, rc, prc ) {
		event.paramPrivateValue( 'SecurityService', SecurityService );
	}

/**
 * I decode the simple values in a structure to make them XSS safer
 * see: http://www.learncfinaweek.com/week1/Cross_Site_Scripting__XSS_/
 */
	private void function decodeStruct(required struct structure) {
		var key = '';

		for (key in arguments.structure) {
			if (isSimpleValue(arguments.structure[key])) {
// append a space to ensure that an empty string doesn't fail canonicalize()
				arguments.structure[key] = arguments.structure[key] & ' ';

				try {
					arguments.structure[key] = canonicalize(arguments.structure[key], true, true);
				} catch (any e) {
					writelog(file='encodingErrors', text='#key# - #e.message#', type='error', application='true');

					arguments.structure[key] = '';
				}

				arguments.structure[key] = trim(arguments.structure[key]);
			}
		}
	}

/**
* I strip out any HTML tags in any simple values contained within a structure
* see: http://cflib.org/udf/stripHTML
*/
	private void function stripHTMLStruct(required struct structure) {
		var key = '';

		for (key in arguments.structure) {
			if (isSimpleValue(arguments.structure[key])) {
				arguments.structure[key] = reReplaceNoCase(arguments.structure[key], '<*style.*?>(.*?)</style>','','all');
				arguments.structure[key] = reReplaceNoCase(arguments.structure[key], '<*script.*?>(.*?)</script>','','all');

				arguments.structure[key] = reReplaceNoCase(arguments.structure[key], '<.*?>','','all');
				arguments.structure[key] = reReplaceNoCase(arguments.structure[key], '^.*?>','');
				arguments.structure[key] = reReplaceNoCase(arguments.structure[key], '<.*$','');

				arguments.structure[key] = trim(arguments.structure[key]);
			}
		}
	}
}
