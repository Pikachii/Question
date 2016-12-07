public class Dev_CL_ExaminationSetting{
    
    /** 出題問題数 */
    public String examMaster {get; set;}
    
    /** 回答者 */
    public String respondant {get; set;}
    
    public Dev_CL_ExaminationSetting(){}

    public List<SelectOption> getExamMasterList(){
        List<SelectOption> examMasterList = new List<SelectOption>();
        for(Dev_ExaminationMaster_Obj__c emData : [SELECT Id, Name FROM Dev_ExaminationMaster_Obj__c where Dev_EM_RegisteredQuestionSum__c > 0]){
            examMasterList.add(new SelectOption(emData.Id, emData.Name));
        }
        return examMasterList;
    }

    public List<SelectOption> getRespondantList(){
        List<SelectOption> respondantList = new List<SelectOption>();
        respondantList.add(new SelectOption('0', '--なし--'));
        for(Dev_Respondant_Obj__c reData : [SELECT Id, Name FROM Dev_Respondant_Obj__c]){
            respondantList.add(new SelectOption(reData.Id, reData.Name));
        }
        return respondantList;
    }

    public PageReference start(){

        if(respondant == '0'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, '回答者を選択してください。'));
            return null;
        }

        PageReference nextPage = Page.Dev_VF_Examination;

        nextPage.getParameters().put('examMaster', examMaster);
        nextPage.getParameters().put('respondant', respondant);

        return nextPage;
    }
}