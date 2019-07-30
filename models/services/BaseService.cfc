component singleton {
	property name='wirebox' inject='wirebox';
	property name='logger' inject='logbox:logger:{this}';

	public BaseService function init() {
		return this;
	}

	public array function getActiveRecords( required any entity, string sortOrder='' ) {
		return wirebox.getInstance( entity )
			.whereNull( 'dateDeleted' )
			.when( sortOrder != '', function( sql ) {
				sql.orderBy( sortOrder )
			} )
			.get();
	}

	public struct function getDataTable(
		required string entityName
		,required any quickObject
		,required any datatable
		,required string deletedField
		,required array fields
		,struct search={ value: '', field: '' }
		,array sortOrders=[]
	) {
		var records = quickObject
			.when( search.value != '' && search.value.len() > 2, function( qb ) {
				qb.where( search.field, 'like', '%#search.value#%' )
			} )
			.andWhereNull( deletedField )
			.offset( datatable.start )
			.take( datatable.length )
			.when( sortOrders.len() != 0 , function( sql ) {
				sortOrders.each( function( sortOrder ) {
					sql.orderBy( sortOrder.field, sortOrder.direction )
				} )
			} )
			.get();

		var recordsTotal = wirebox.getInstance( entityName )
			.whereNull( deletedField )
			.count();

		if( search.value != '' && search.value.len() > 2 ) {
			var recordsFiltered = records.len();
		} else {
			var recordsFiltered = recordsTotal;
		}

		var dataSet[ 'data' ] = [];

		records.each( function( record ) {
			var fieldData = {};

			fields.each( function( field, index ) {
				fieldData.append( { '#index-1#': encodeForHTML( record[ 'get#fields[ index ]#' ]() ) } );
			} );

			fieldData.append( { 'DT_RowId': encodeForHTML( record.getID() ) } );

			dataSet[ 'data' ].append( fieldData );
		} );

		dataSet[ 'draw' ] = datatable.draw;
		dataSet[ 'recordsTotal' ] = recordsTotal;
		dataSet[ 'recordsFiltered' ] = recordsFiltered;

		return dataSet;
	}

/**
 * Performs venn type operations on two lists.
 *
 * @param listA 	 The first list. (Required)
 * @param listB 	 The second list. (Required)
 * @param returnListType 	 Return list type. Values can be: AandB, AorB, AnotB, BnotA  (Required)
 * @param listADelimiter 	 List A delimiter. Defaults to a comma. (Optional)
 * @param listBDelimiter 	 List B delimiter. Defaults to a comma. (Optional)
 * @param returnListDelimiter 	 Return list delimiter. Defaults to a comma. (Optional)
 * @return Returns a list.
 * @author Christopher Jordan (cjordan@placs.net)
 * @version 1, February 14, 2006
 */
	function listVenn(ListA,ListB,ReturnListType){
		var i					= "";
		var ThisListItem		= "";
		var ListADelimeter		= ",";
		var ListBDelimeter		= ",";
		var ReturnListDelimeter	= ",";
		var ReturnList			= "";
		var TempListA			= ListA;
		var TempListB			= ListB;

	// Handle optional arguments
		switch(ArrayLen(arguments)) {
			case 4: {
				ListADelimeter	= Arguments[4];
				break;
			}

			case 5: {
				ListADelimeter		= Arguments[4];
				ListBDelimeter		= Arguments[5];
				break;
			}

			case 6: {
				ListADelimeter		= Arguments[4];
				ListBDelimeter		= Arguments[5];
				ReturnListDelimeter = Arguments[6];
				break;
			}
		}

	// change delimeters on both lists to match
	// couldn't get listchangedelims to work, otherwise I'd have used that.
		ListA = "";
		ListB = "";

		for (i = 1; i lte listlen(TempListA,ListADelimeter); i = i + 1){
			ThisListItem = listgetat(TempListA,i,ListADelimeter);
			ListA = ListAppend(ListA,ThisListItem,ReturnListDelimeter);
		}

		for (i = 1; i lte listlen(TempListB,ListBDelimeter); i = i + 1){
			ThisListItem = listgetat(TempListB,i,ListBDelimeter);
			ListB = ListAppend(ListB,ThisListItem,ReturnListDelimeter);
		}

	// A and B (aka Intersection)
		if (ReturnListType eq "AandB"){
			for(i = 1; i lte listlen(ListA,ReturnListDelimeter); i = i + 1){
				ThisListItem = listgetat(ListA,i,ReturnListDelimeter);
				if (ListFindNoCase(ListB,thisListItem,ReturnListDelimeter)){
					ReturnList = ListAppend(ReturnList,ThisListItem,ReturnListDelimeter);
				}
			}
		}

	// A or B (aka Union)
		else if(ReturnListType eq "AorB"){
			ReturnList = ListA;
			ReturnList = ListAppend(ReturnList,ListB,ReturnListDelimeter);

		}

	// A not B
		else if (ReturnListType eq "AnotB"){
			for(i = 1; i lte listlen(ListA,ReturnListDelimeter); i = i + 1){
				ThisListItem = listgetat(ListA,i,ReturnListDelimeter);
				if (not ListFindNoCase(ListB,thisListItem,ReturnListDelimeter)){
					ReturnList = ListAppend(ReturnList,ThisListItem,ReturnListDelimeter);
				}
			}
		}

	// B not A
		else if (ReturnListType eq "BnotA"){
			for(i = 1; i lte listlen(ListB,ReturnListDelimeter); i = i + 1){
				ThisListItem = listgetat(ListB,i,ReturnListDelimeter);
				if (not ListFindNoCase(ListA,thisListItem,ReturnListDelimeter)){
					ReturnList = ListAppend(ReturnList,ThisListItem,ReturnListDelimeter);
				}
			}
		}

		return ReturnList;
	}

	public any function onMissingMethod( missingMethodName, missingMethodArguments ) {
		return invoke( QuickService, missingMethodName, missingMethodArguments );
	}
}
