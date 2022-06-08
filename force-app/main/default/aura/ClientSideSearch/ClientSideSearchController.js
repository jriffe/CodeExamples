({
    searchRecords : function(component, event, helper) {
        let searchTerm = component.get('v.searchTerm');
        let startDate = component.get('v.startDate');
        let endDate = component.get('v.endDate');

        var params = event.getParam('arguments');
        let records = [];
        if(params) {
            records = params.records;
        }

        return helper.performSearch(records, searchTerm, startDate, endDate);
    },

    searchClick : function(component, event, helper){
        var searchEvent = component.getEvent('searchButtonClicked');
        searchEvent.fire();
    },

    clearSearch : function(component, event, helper){
        component.set('v.searchTerm', '');
        component.set('v.startDate', null);
        component.set('v.endDate', null);

        var searchEvent = component.getEvent('searchButtonClicked');
        searchEvent.fire();
    }

})