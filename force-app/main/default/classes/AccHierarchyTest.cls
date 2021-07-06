/**
 * Created by ilevkovich on 5/7/2021.
 */
@IsTest
private class AccHierarchyTest {

    @TestSetup
    static void init() {
        Account Acc1 = new Account(Name = 'Account1', ParentId__c = null);
        insert Acc1;
        Account Acc2 = new Account(Name = 'Account2', ParentId__c = Acc1.Id);
        insert Acc2;
        Account Acc3 = new Account(Name = 'Account3', ParentId__c = Acc2.Id);
        insert Acc3;
        Account Acc7 = new Account(Name = 'Account7', ParentId__c = Acc1.Id);
        insert Acc7;
        Account Acc4 = new Account(Name = 'Account4', ParentId__c = Acc3.Id);
        insert Acc4;
        Account Acc5 = new Account(Name = 'Account5', ParentId__c = Acc3.Id);
        insert Acc5;
        Account Acc8 = new Account(Name = 'Account8', ParentId__c = Acc7.Id);
        insert Acc8;

        System.assertEquals(7, [SELECT COUNT() FROM Account WHERE Name LIKE 'Account%']);
    }

    @IsTest static void testAccHierarchyListParents() {

        AccHierarchy newClass = new AccHierarchy();
        Account Acc3 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account3'];
        Account Acc2 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account2'];
        Account Acc1 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account1'];
        List<Id> listCurrentParent = newClass.getParentIds(Acc3.Id);

        List<Id> listParents = new List<Id>();
        listParents.add(Acc2.Id);
        listParents.add(Acc1.Id);

        System.assertEquals(listParents, listCurrentParent);
    }


    @IsTest static void testAccHierarchyMapParents() {

        Account Acc1 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account1'];
        Account Acc2 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account2'];
        Account Acc3 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account3'];
        Account Acc7 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account7'];

        AccHierarchy newClass = new AccHierarchy();

        List<Id> listCurrentParent = new List<Id>();
        listCurrentParent.add(Acc7.Id);
        listCurrentParent.add(Acc3.Id);

        Map<Id, List<Id>> mapCurrentParent = newClass.getParentIds(listCurrentParent);

        Map<Id, List<Id>> mapParents = new Map<Id, List<Id>>();
        List<Id> listParents = new List<Id>();
        listParents.add(Acc1.Id);
        mapParents.put(Acc7.Id, listParents);
        List<Id> listParents2 = new List<Id>();
        listParents2.add(Acc2.Id);
        listParents2.add(Acc1.Id);
        mapParents.put(Acc3.Id, listParents2);

        System.assertEquals(mapParents, mapCurrentParent);
    }


    @IsTest static void testAccHierarchyListChild() {

        Account Acc2 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account2'];
        Account Acc3 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account3'];
        Account Acc4 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account4'];
        Account Acc5 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account5'];

        AccHierarchy newClass = new AccHierarchy();
        List<Id> listCurrentChild = newClass.getChildIds(Acc2.Id);

        List<Id> listChild = new List<Id>();
        listChild.add(Acc3.Id);
        listChild.add(Acc4.Id);
        listChild.add(Acc5.Id);

        System.assertEquals(listChild, listCurrentChild);
    }

    @IsTest static void testAccHierarchyMapChild() {

        Account Acc2 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account2'];
        Account Acc3 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account3'];
        Account Acc4 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account4'];
        Account Acc5 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account5'];
        Account Acc7 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account7'];
        Account Acc8 = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Name LIKE 'Account8'];

        AccHierarchy newClass = new AccHierarchy();

        List<Id> listCurrentChild = new List<Id>();
        listCurrentChild.add(Acc7.Id);
        listCurrentChild.add(Acc2.Id);

        Map<Id, List<Id>> mapCurrentChild = newClass.getChildIds(listCurrentChild);

        Map<Id, List<Id>> mapChild = new Map<Id, List<Id>>();

        List<Id> listChild = new List<Id>();
        listChild.add(Acc8.Id);
        mapChild.put(Acc7.Id, listChild);

        List<Id> listChild2 = new List<Id>();
        listChild2.add(Acc3.Id);
        listChild2.add(Acc4.Id);
        listChild2.add(Acc5.Id);
        mapChild.put(Acc2.Id, listChild2);

        System.assertEquals(mapChild, mapCurrentChild);
    }

}