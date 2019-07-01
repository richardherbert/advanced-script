component {
	function up( schema, query ) {
		schema.dropIfExists( 'cbsecurity' );

		schema.create( 'cbsecurity', function( table ) {
			table.uuid( 'id' ).primaryKey();

            table.text( 'whitelist' );
            table.text( 'securelist' );
            table.text( 'roles' );
			table.string( 'permissions' );
			table.string( 'match' );
			table.string( 'redirect' );
			table.integer( 'sortOrder', 10 ).unsigned().default( '0' );
		} );

		query.from( 'cbsecurity' )
			.insert(
				values = {
					 'id' = createUUID()
					,'whitelist' = '^signin.*,^error'
					,'securelist' = '.*'
					,'roles' = ''
					,'permissions' = ''
					,'match' = 'event'
					,'redirect' = 'signin.signout'
					,'sortorder' = 1
				}
			);

	}

	function down( schema ) {
		schema.dropIfExists( 'cbsecurity' );
	}
}
