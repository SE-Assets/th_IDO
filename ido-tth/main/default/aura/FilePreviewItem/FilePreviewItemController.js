({
	openFile : function(component, event, helper) {
        $A.get('e.lightning:openFiles').fire({
            recordIds: component.get("v.documentIds"),
            selectedRecordId : component.get("v.document.ContentDocumentId")
        });
	}
})