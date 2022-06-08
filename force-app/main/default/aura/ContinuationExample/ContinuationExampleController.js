({
    init : function(component, event, helper) {

    },

    callContinuation : function(component, event, helper){
        component.set('v.componentLoading', true);
        let action = component.get('c.startFirstRequest');

        action.setCallback(this, function(response) {
            let state = response.getState();

            if(state === 'SUCCESS') {
                let animals = response.getReturnValue();
                component.set('v.animalString', animals);
            } else {
                console.log(response.getError());
            }

            component.set('v.componentLoading', false);
        });

        action.setBackground();
        $A.enqueueAction(action);
    },

    callAddAnimalContinuation : function(component, event, helper){
        component.set('v.componentLoading', true);
        let action = component.get('c.startChainedRequest');

        action.setParams({
            'newAnimalName' : component.get('v.newAnimalName')
        });

        action.setCallback(this, function(response) {
            let state = response.getState();

            if(state === 'SUCCESS') {
                let animals = response.getReturnValue();
                component.set('v.animals', animals);
            } else {
                console.log(response.getError());
            }

            component.set('v.componentLoading', false);
        });

        action.setBackground();
        $A.enqueueAction(action);
    }
})