component extends='quick.models.BaseEntity' {
	property name='id';

	property name='dateCreated';
	property name='dateUpdated';
	property name='dateDeleted';

	public function init() {
		super.init();
	}

	function keyType() {
		return _wirebox.getInstance( 'UUIDKeyType@quick' );
	}

	boolean function isPersisted( ) {
		var entity = application.wirebox.getInstance( 'User' )
			.find( variables.id );

		if( isNull( entity ) ) {
			return false;
		} else {
			return true;
		}
	}
}
