public with sharing class Dev_Dao_ExaminationHistory_Obj {

    private static Dev_Dao_ExaminationHistory_Obj dao;

    private Dev_Dao_ExaminationHistory_Obj(){}

    public static Dev_Dao_ExaminationHistory_Obj getInstance(){
        if(dao == null){
            return new Dev_Dao_ExaminationHistory_Obj();
        }else{
            return dao;
        }
    }

    public Dev_ExamHistory_Obj__c getExaminationHistoryById(Id ehId){

        List<Dev_ExamHistory_Obj__c> targetEhList =
                [
                    SELECT
                        Id,
                        Dev_EH_TrialExam__r.Name,
                        Dev_EH_ExamTrialist__r.Name,
                        Dev_EH_ExamTrialist__r.Dev_RE_MailAddress__c,
                        Dev_EH_ExamResult__c,
                        Dev_EH_ExamQuestionNum__c,
                        Dev_EH_CorrectAnswerNum__c,
                        Dev_EH_BorderLine__c,
                        (
                            SELECT
                                Dev_AN_TargetQuestion__r.Dev_QU_Question__c,
                                Dev_AN_isCorrect__c
                            FROM
                                Dev_EH_Answers__r
                        )
                    FROM
                        Dev_ExamHistory_Obj__c
                    WHERE
                        Id = :ehId
                ];

        return targetEhList.get(0);

    }
}