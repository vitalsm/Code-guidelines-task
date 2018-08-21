public class Example6 {
    public static void func() {
        deleteSobjectDuplicateRecordsName('Contact');
        deleteSobjectDuplicateRecordsName('Lead');
    }

    public static void deleteSobjectDuplicateRecordsName(String SobjectApiName) {
        List<SObject> objects = Database.query('SELECT Id, Name FROM ' + SobjectApiName);
        Map<String, String> UniqueSobjectRecords = new Map<String, String>();
        List<SObject> RecordsToDelete = new List<Sobject>();
        for (SObject obj : objects) {
            UniqueSobjectRecords.put(String.valueOf(obj.get('Name')), String.valueOf(obj.get('Id')));
        }
        for (SObject obj : objects) {
            if (!UniqueSobjectRecords.values().contains(String.valueOf(obj.get('Id')))) {
                RecordsToDelete.add(obj);
            }
        }
/*        try {
            delete RecordsToDelete;
        }
        catch (DmlException e) {
            System.debug('DmlException: ' + e.getMessage());
        }
*/
        Database.DeleteResult[] drList = Database.delete(RecordsToDelete, false);
        for(Database.DeleteResult dr : drList) {
            if(dr.isSuccess()) {
                System.debug('Successfully deleted records: ' + dr.getId());
            }
            else {
                for(Database.Error err : dr.getErrors()) {
                    System.debug('Error: ' + err.getStatusCode() + ':' + err.getMessage());
                    System.debug('Records that affected this error: ' + err.getFields());
                }
            }
        }
    }
}