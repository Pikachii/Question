public class Dev_Dao_Question_Obj{

    private static Dev_Dao_Question_Obj dao;
    
    private Dev_Dao_Question_Obj(){}

    public static Dev_Dao_Question_Obj getInstance(){
        if(dao == null){
            return new Dev_Dao_Question_Obj();
        }else{
            return dao;
        }
    }
    
    public List<Dev_Question_Obj__c> getQuestionByAnyNumberAndExaminationMaster(Integer questionNo, Id emId){

        List<Dev_Question_Obj__c> allQuestionList =
            [
                SELECT
                    Id,
                    Dev_QU_Question__c,
                    Dev_QU_Answer1__c,
                    Dev_QU_Answer2__c,
                    Dev_QU_Answer3__c,
                    Dev_QU_Answer4__c,
                    Dev_QU_Answer5__c,
                    Dev_QU_Answer6__c,
                    Dev_QU_CorrectAnswer__c,
                    RecordType.DeveloperName
                FROM
                    Dev_Question_Obj__c
                WHERE
                    Dev_QU_ExaminationMaster__c = :emId
            ];

        Set<Integer> randomNumSet = new Set<Integer>();

        if(questionNo > allQuestionList.size()){
            questionNo = allQuestionList.size();
        }

        while(randomNumSet.size() != questionNo){
            Integer num = (Math.random() * allQuestionList.size()).intValue();
            randomNumSet.add(num);
        }

        List<Dev_Question_Obj__c> targetQuestionList = new List<Dev_Question_Obj__c>();

        for(Integer targetNum : randomNumSet){
            targetQuestionList.add(allQuestionList.get(targetNum));
        }

        return targetQuestionList;

    }

}