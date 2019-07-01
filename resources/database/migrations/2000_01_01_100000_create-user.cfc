component {
	function up( schema, query ) {
		schema.dropIfExists( 'users' );

		schema.create( 'users', function( table ) {
			table.uuid( 'id' ).primaryKey();

            table.string( 'title' ).nullable();
            table.string( 'givenName' ).nullable();
            table.string( 'familyName' ).nullable();

			table.string( 'emailAddress' ).unique();

			table.string( 'password' ).nullable();
			table.string( 'passwordSalt' );
			table.string( 'passwordResetToken' ).nullable();
			table.datetime( 'dateResetTokenExpires' ).nullable();

			table.datetime( 'dateLastSignin' ).nullable();

			table.timestamp( 'dateCreated' );
			table.timestamp( 'dateUpdated' );
			table.datetime( 'dateDeleted' ).nullable();
		} );

		query.from( 'users' )
			.insert(
				values = {
					'id' = createUUID()
					,'emailAddress' = 'dickbob@gmail.com'
					,'passwordSalt' = createUUID()
				}
			);
	}

	function down( schema ) {
		schema.dropIfExists( 'users' );
	}
}
