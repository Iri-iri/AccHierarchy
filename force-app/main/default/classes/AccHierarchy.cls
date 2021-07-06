public with sharing class AccHierarchy {

    List<Account> myAccList = [SELECT Id, Name, AccountId__c, ParentId__c FROM Account WHERE Account.Name LIKE 'Account%'];


    public Map<Id, Id> composeIdMap() {
        Map<Id, Id> myIdMap = new Map<Id, Id>();
        for (Account itemAcc : myAccList) {
            myIdMap.put(itemAcc.Id, itemAcc.ParentId__c);
        }
        return myIdMap;
    }

    Map<Id, Id> myCurrentMap = composeIdMap();


    public List<Id> getParentIds(Id currentId) {
        List<Id> listChildsId = new List<Id>();
        recursion(currentId, listChildsId);
//        System.debug(listChildsId);
        return listChildsId;

    }

    public void recursion(Id currentId2, List<Id> listChildsId) {
        Id itemParId2 = myCurrentMap.get(currentId2);
        if (itemParId2 != null) {
            listChildsId.add(itemParId2);
            recursion(itemParId2, listChildsId);
        }
    }

//    ---------------------------------------
//    *****(реализация с циклом в цикле)*****

//    public Map<Id, Set<Id>> composeIdMap2() {
//        Map<Id, Set<Id>> myIdMap = new Map<Id, Set<Id>>();
//        for (Account itemAcc : myAccList) {
//            Set<Id> mySetOfChild = new Set<Id>();
//            for (Account itemAccChild : myAccList) {
//                if (itemAccChild.ParentId__c == itemAcc.Id) {
//                    mySetOfChild.add(itemAccChild.Id);
//                }
//            }
//            myIdMap.put(itemAcc.Id, mySetOfChild);
//        }
//        return myIdMap;
//    }

    public Map<Id, Set<Id>> composeIdMap2() {
        Map<Id, Set<Id>> myIdMap = new Map<Id, Set<Id>>();

        for (Account itemAcc : myAccList) {

            if (!myIdMap.containsKey(itemAcc.Id)) {
                Set<Id> mySetOfChild = new Set<Id>();
                myIdMap.put(itemAcc.Id, mySetOfChild);
            }
            if (itemAcc.ParentId__c != null) {
                if (myIdMap.containsKey(itemAcc.ParentId__c)) {
                    myIdMap.get(itemAcc.ParentId__c).add(itemAcc.Id);
                } else {
                    Set<Id> mySetOfChild = new Set<Id>();
                    mySetOfChild.add(itemAcc.Id);
                    myIdMap.put(itemAcc.ParentId__c, mySetOfChild);
                }
            }
        }

        return myIdMap;
    }


    Map<Id, Set<Id>> myCurrentMap2 = composeIdMap2();

    public List<Id> getChildIds(Id currentId) {
        List<Id> myIdListOfChildren = new List<Id>();
        recurs(currentId, myIdListOfChildren);
//        System.debug(myIdListOfChildren);
        return myIdListOfChildren;
    }


    public void recurs(Id currentId3, List<Id> myIdList) {
        Set<Id> itemParId = myCurrentMap2.get(currentId3);
        myIdList.addAll(itemParId);
        for (Id myIdListItem : itemParId) {
            recurs(myIdListItem, myIdList);
        }
    }
//    -------------------------------------------


    public Map<Id, List<Id>> getParentIds(List<Id> currentIds) {
        Map<Id, List<Id>> mapChildsId = new Map<Id, List<Id>>();
        for (Id itemList2 : currentIds) {
//            List<Id> currentIdsNew = new List<Id>();
//            recursion(itemList2, currentIdsNew);
//            mapChildsId.put(itemList2, currentIdsNew);
            mapChildsId.put(itemList2, getParentIds(itemList2));
        }
//        System.debug(mapChildsId);
        return mapChildsId;
    }

    public Map<Id, List<Id>> getChildIds(List<Id> currentIds) {
        Map<Id, List<Id>> mapParentsId = new Map<Id, List<Id>>();
        for (Id itemList2 : currentIds) {
//            List<Id> currentIdsNew = new List<Id>();
//            recurs(itemList2, currentIdsNew);
//            mapParentsId.put(itemList2, currentIdsNew);
            mapParentsId.put(itemList2, getChildIds(itemList2));
        }
//        System.debug(mapParentsId);
        return mapParentsId;
    }
}