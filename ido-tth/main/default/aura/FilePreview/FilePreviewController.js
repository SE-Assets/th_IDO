({
	doInit : function(cmp, event, helper) {
        helper.getAllDocuments(cmp);
	},
    showModal : function(cmp, event, helper) {
        $A.util.addClass(cmp.find("dialog"), "slds-fade-in-open");
        $A.util.addClass(cmp.find("backdrop"), "slds-backdrop--open");
    },
    hideModal : function(cmp, event, helper) {
        $A.util.removeClass(cmp.find("dialog"), "slds-fade-in-open");
        $A.util.removeClass(cmp.find("backdrop"), "slds-backdrop--open");
    },
    readFile : function(cmp, e, helper) {
        var id = e.target.id;
        var file = e.target.files[0];
        var filename = file.name;
        cmp.set("v.fileName", filename);
        var reader = new FileReader();
        reader.onload = function(readerEvt){
            var dataURL = reader.result;
            var base64 = dataURL.split(',')[1];
            console.log(base64);
            cmp.set("v.base64", base64);
        };
        reader.readAsDataURL(file);
    },
    goToFileList : function (component, event, helper) {
        var relatedListEvent = $A.get("e.force:navigateToRelatedList");
        relatedListEvent.setParams({
            "relatedListId": "AttachedContentDocuments",
            "parentRecordId": component.get("v.recordId")
        });
        relatedListEvent.fire();
    },
    newPostCreated : function(cmp, event, helper) {
        console.log("new post created");
        $A.util.removeClass(cmp.find("dialog"), "slds-fade-in-open");
        $A.util.removeClass(cmp.find("backdrop"), "slds-backdrop--open");
        $A.get('e.force:refreshView').fire();
        helper.getAllDocuments(cmp);
    }
})