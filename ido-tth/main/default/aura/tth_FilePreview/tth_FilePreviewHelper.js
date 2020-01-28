({
    toggleSpinner : function(cmp) {
        var spinner = cmp.find("mySpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    },
    getAllDocuments : function(cmp) {
        var action = cmp.get("c.getAllDocumentLinks");
        action.setParam("recordId", cmp.get("v.recordId"));
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var documents = response.getReturnValue();
                cmp.set("v.documents", documents);
                var visibleFiles = cmp.get("v.numberOfVisibleItems"); 
                if (documents.length <= visibleFiles) {
                    cmp.set("v.showDocuments", documents);
                    cmp.set("v.lastDocument", null);
                } else {
                    cmp.set("v.showDocuments", documents.slice(0, visibleFiles - 1));
                    cmp.set("v.lastDocument", documents[visibleFiles - 1]);
                    cmp.set("v.remainingNumber", documents.length - visibleFiles + 1);
                }
                var documentIds = [];
                documents.forEach(function(document) {
                    documentIds.push(document.ContentDocumentId);                    
                });
                cmp.set("v.documentIds", documentIds);
            }
            else if (state === "INCOMPLETE") {
            }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " +
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    }
})