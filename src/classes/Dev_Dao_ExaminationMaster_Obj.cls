public class Dev_Dao_ExaminationMaster_Obj {

    private static Dev_Dao_ExaminationMaster_Obj dao;
    
    private Dev_Dao_ExaminationMaster_Obj(){}

    public static Dev_Dao_ExaminationMaster_Obj getInstance(){
        if(dao == null){
            return new Dev_Dao_ExaminationMaster_Obj();
        }else{
            return dao;
        }
    }
    
    public Dev_ExaminationMaster_Obj__c getExaminationMasterById(Id emId){

        List<Dev_ExaminationMaster_Obj__c> targetEmList =
            [
                SELECT
                    Id,
                    Dev_EM_QuestionNo__c,
                    Dev_EM_ExamTime__c,
                    Dev_EM_BorderLine__c
                FROM
                    Dev_ExaminationMaster_Obj__c
                WHERE
                	Id = :emId
            ];

        return targetEmList.get(0);

    }
}