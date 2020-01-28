public with sharing class tthMetadataUtils {

   public class PicklistInputs {
       @InvocableVariable(required=true)
       public String sObjectName;

       @InvocableVariable(required=true)
       public String fieldName;
   }


  @InvocableMethod(label='Get Picklist Values for Object Field' description='Returns a list containing all values for a picklist field. Provide API names for sObject and picklist field')
  public static List<List<String>> getPicklistValuesForObjectField(List<PicklistInputs> objectFieldNames) {
     List<List<String>> picklistValues = new List<List<String>>();
     List<String> values = new List<String>();

     PicklistInputs inputs = objectFieldNames.get(0);
     String objectName = inputs.sObjectName;
     String fieldName = inputs.fieldName;
     String[] types = new String[]{objectName};

     Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
     for(Schema.DescribeSobjectResult res : results) {
        for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
           if (entry.isActive()) {
             values.add( entry.getLabel() );
           }
        }
     }
     picklistValues.add(values);
     return picklistValues;
  }
}
