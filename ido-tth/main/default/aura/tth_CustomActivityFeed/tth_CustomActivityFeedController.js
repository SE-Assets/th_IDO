({
	doInit: function(component, event, helper) {

		/* Subscribe to push topic */
		helper.subscribeToEvent(component);
		var sObject = component.get('v.sObjectName');
		var recordId = component.get('v.recordId');

		//helper.getActivitiesForObject(component);

		if (sObject === 'Account') {
			helper.getActivitiesForAccount(component);
			helper.getContactForAccount(component);
		} else if (sObject === 'Contact') {
			helper.getActivitiesForContact(component);
			component.set("v.contactId", recordId);
		} else if (sObject === 'tth_Trip__c') {
			helper.getActivitiesForTrip(component);
			component.set("v.tth_Trip__c", recordId);
		} else if (sObject === 'LiveChatTranscript') {
			console.log('*** this is a LiveChatTranscript...');
				helper.getActivitiesForLiveChat(component);
				helper.getContactForChat(component);		
		}


	},
	createActivity: function(component, event, helper) {
		var createRecordEvent = $A.get("e.force:createRecord");
		var sObject = component.get('v.sObjectName');
		if (sObject === 'Account') {
			var id = component.get('v.contactId.PersonContactId');
			createRecordEvent.setParams({
				"entityApiName": "Custom_Activity__c",
				"defaultFieldValues": {
					'Contact__c': id
				}
			});
		} else if (sObject === 'Contact') {
			var id = component.get('v.recordId');
			createRecordEvent.setParams({
				"entityApiName": "Custom_Activity__c",
				"defaultFieldValues": {
					'Contact__c': id
				}
			});
		} else if (sObject === 'tth_Trip__c') {
			var id = component.get('v.recordId');
			createRecordEvent.setParams({
				"entityApiName": "Custom_Activity__c",
				"defaultFieldValues": {
					'tth_Trip__c': id
				}
			});
		}

		createRecordEvent.fire();
	},
	gotoActivityList: function(component, event, helper) {
		var relatedListEvent = $A.get("e.force:navigateToRelatedList");
		var sObject = component.get('v.sObjectName');
		if (sObject === 'Account') {
			var id = component.get('v.contactId.PersonContactId');
		} else if (sObject === 'Contact') {
			var id = component.get('v.recordId');
		} else if (sObject === 'tth_Trip__c') {
			var id = component.get('v.recordId');
		}

		//console.log(component.get('v.contactId'));
		relatedListEvent.setParams({
			"relatedListId": "Custom_Activities__r",
			"parentRecordId": id
		});
		relatedListEvent.fire();
	}

})
