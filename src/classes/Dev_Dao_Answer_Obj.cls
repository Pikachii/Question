public with sharing class Dev_Dao_Answer_Obj {

    private static Dev_Dao_Answer_Obj dao;

    private Dev_Dao_Answer_Obj(){}

    public static Dev_Dao_Answer_Obj getInstance(){
        if(dao == null){
            return new Dev_Dao_Answer_Obj();
        }else{
            return dao;
        }
    }

    public List<Dev_Answer_Obj__c> getAnswerByQuestionIdsAndRespondant(Set<Id> questionIdSet, Id respondantId){
        return [
                SELECT
                	Dev_AN_isCorrect__c
                FROM
                    Dev_Answer_Obj__c
                WHERE
                	Dev_AN_respondant__c = :respondantId
                	AND
                	Dev_AN_targetQuestion__c IN :questionIdSet
                ORDER BY
                	Dev_AN_targetQuestion__c, createdDate
                ];
    }

}