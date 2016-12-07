public with sharing class Dev_Dto_Examination {

	/** 問題・回答リスト */
	private List<Dev_Dto_ExaminationAnswer> examAnsList
		= new List<Dev_Dto_ExaminationAnswer>();

	/** 試験マスタID */
	public Id emId {get; set;}

	/** 回答者ID */
    public Id respondantId {get; set;}

	/** 試験時間 */
	public Integer timer {get; set;}

	/** 出題数 */
	public Integer questionNum {get; set;}

	private Integer borderLine {get; set;}

	public Dev_Dto_Examination() {}

	public void init() {

        setExamMaster();

	}

    private void setExamMaster(){
        Dev_Dao_ExaminationMaster_Obj emDao = Dev_Dao_ExaminationMaster_Obj.getInstance();
        emId = ApexPages.currentPage().getParameters().get('examMaster');

	    // 選択した試験マスタ取得
	    Dev_ExaminationMaster_Obj__c emData = emDao.getExaminationMasterById(emId);
        timer = (emData.Dev_EM_ExamTime__c * 60).intValue();

        setQuestion(emData.Dev_EM_QuestionNo__c.intValue());
        questionNum = examAnsList.size();
        borderLine = Math.ceil((questionNum * (emData.Dev_EM_BorderLine__c / 100))).intValue();
    }

    private void setQuestion(Integer questionNum){

        // 問題のDaoのインスタンスを取得
        Dev_Dao_Question_Obj quDao = Dev_Dao_Question_Obj.getInstance();

        List<Dev_Question_Obj__c> questionList = new List<Dev_Question_Obj__c>();

        // 設定画面で設定した試験マスタをもとに問題を取得します。
        questionList = quDao.getQuestionByAnyNumberAndExaminationMaster(questionNum, emId);

        respondantId = ApexPages.currentPage().getParameters().get('respondant');

        for(Integer i = 0; i < questionList.size(); i++){
            setExam(new Dev_Dto_ExaminationAnswer(questionList.get(i), respondantId));
        }

    }

    public Id submit(){

    	Dev_ExamHistory_Obj__c ehData = createEhData();
    	insert ehData;

        List<Dev_Answer_Obj__c> anList = new List<Dev_Answer_Obj__c>();

        for(Dev_Dto_ExaminationAnswer examAns : examAnsList){
            anList.add(examAns.convertToAnswer(ehData.Id));
        }

        insert anList;

        return ehData.Id;
    }

    private Dev_ExamHistory_Obj__c createEhData(){
    	Dev_ExamHistory_Obj__c ehData = new Dev_ExamHistory_Obj__c();
   		ehData.Dev_EH_TrialExam__c = emId;
   		ehData.Dev_EH_ExamTrialist__c = respondantId;
		ehData.Dev_EH_BorderLine__c = borderLine;
		ehData.Dev_EH_ExamQuestionNum__c = questionNum;
   		return ehData;
    }

    public Dev_Dto_ExaminationAnswer getExam(Integer index){
		if(index >= examAnsList.size()){
			return null;
		} else {
			return examAnsList.get(index);
		}
	}

	public void setExam(Dev_Dto_ExaminationAnswer examAns){
		examAnsList.add(examAns);
	}

	public Integer getExamSize(){
		if(examAnsList == null){
			return 0;
		}else{
			return examAnsList.size();
		}
	}

}