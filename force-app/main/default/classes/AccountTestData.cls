/**
* @description Builder class for dealing with Account records.
* Solely used for testing, NOT a data factory.
**/
@isTest
public class AccountTestData extends SObjectTestData {
    /**
    * @description Overridden method to set up the default
    * Account state for AccountTestData.
    * @return A map of Account default fields.
    */
    protected override Map<Schema.SObjectField, Object> getDefaultValueMap() {
        return new Map<Schema.SObjectField, Object>{
            //Default fields go here:
            Account.Name => 'Jessica Test Account'
        };
    }

    /**
    * @description Returns the SObject type for AccountTestData builder.
    * @return Account.SObjectType.
    */
    protected override Schema.SObjectType getSObjectType() {
        return Account.SObjectType;
    }

    /**
    * @description Sets the type on the Account.
    * @param type The Type that the Account will have.
    * @return The instance of AccountTestData.
    */
    public AccountTestData withType(String type) {
        return (AccountTestData) withDynamicData(Account.Type, type);
    }

    /**
    * @description Sets the ownerId on the Account.
    * @param ownerId The Type that the Account will have.
    * @return The instance of AccountTestData.
    */
    public AccountTestData withOwner(Id ownerId) {
        return (AccountTestData) withDynamicData(Account.OwnerId, ownerId);
    }

    /* Create a “with” method for each property that can be set */
    /**
    * @description Builds the Account object.
    * @return The created Account object.
    */
    public Account create() {
        return (Account)super.buildWithReset();
    }

    /**
    * @description Inserts the built Account object.
    * @return The inserted Account object.
    */
    public Account insertAccount() {
        return (Account)super.insertRecord();
    }

    /**
    * @description Gets an instance of AccountTestData.
    * @return AccountTestData instance.
    */
    public static AccountTestData Instance {
        get {
            if (Instance == null) {
                Instance = new AccountTestData();
            }
            
            return Instance;
        } set;
    }

    /**
    * @description Private constructor for singleton.
    */
    private AccountTestData() {
        super();
    }
}