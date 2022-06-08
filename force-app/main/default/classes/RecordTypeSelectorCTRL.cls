public with sharing class RecordTypeSelectorCTRL {

    @AuraEnabled
    public static List<recordTypeWrapper> getRecordTypes(String objectName){
        List<recordTypeWrapper> wrapperList = new List<recordTypeWrapper>();

        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        DescribeSObjectResult objectDescribe = objectType.getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfoList = objectDescribe.getRecordTypeInfos();

        Map<Id, RecordType> recordTypeMap = new Map<Id, RecordType>([SELECT Id, Name, DeveloperName, Description, isActive 
                                                FROM RecordType 
                                                WHERE SobjectType =: objectName
                                                    AND DeveloperName != 'Master'
                                                    AND isActive = true]);

        for(Schema.RecordTypeInfo info: recordTypeInfoList) {
            if(info.isAvailable()) {
                if(info.getName() != 'Master' && info.getName().trim() != ''){
                    recordTypeWrapper wrapper = new recordTYpeWrapper();
                    wrapper.recordTypeId = info.getRecordTypeId();
                    wrapper.recordTypeName = info.getName();
                    wrapper.recordTypeDescription = recordTypeMap.get(info.getRecordTypeId()).Description;
                
                    //Get the default record type for current user profile
                    if(info.isDefaultRecordTypeMapping()){
                        wrapper.isDefault = true;
                    } 

                    wrapperList.add(wrapper);
                }
            }
        }

        return wrapperList;
    }

    class recordTypeWrapper {
        @AuraEnabled
        public String recordTypeId { get; set; }

        @AuraEnabled
        public String recordTypeName { get; set; }

        @AuraEnabled
        public String recordTypeDescription { get; set; }

        @AuraEnabled
        public Boolean isDefault { get; set; }

        public recordTypeWrapper(){
            isDefault = false;
        }
    }
}