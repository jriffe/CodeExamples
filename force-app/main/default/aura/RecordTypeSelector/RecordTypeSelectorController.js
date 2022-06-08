({
    init : function(component, event, helper) {
        var action = component.get("c.getRecordTypes");
        var objectName = component.get('v.objectName');

        action.setParams({
            'objectName' : objectName
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var recordTypeList = response.getReturnValue();
                component.set('v.recordTypeList', recordTypeList);

                for(var recordType of recordTypeList){
                    if(recordType.isDefault){
                        component.set("v.selectedRecordTypeId", recordType.recordTypeId);
                    }
                }
               
            } else {
                console.error(response.getError()[0].message);
            }
        });
        $A.enqueueAction(action);
    },

    recordTypeChange : function(component, event, helper){
        component.set('v.selectedRecordTypeId', event.target.value);
    },

    handleRecordTypeNext : function(component, event, helper){
        var recordTypeSelectedEvent = component.getEvent('onRecordTypeSelect');
        var selectedRecordType = component.get('v.selectedRecordTypeId');

        recordTypeSelectedEvent.setParams({
            'selectedRecordTypeId' : selectedRecordType
        });

        recordTypeSelectedEvent.fire();
    }
})