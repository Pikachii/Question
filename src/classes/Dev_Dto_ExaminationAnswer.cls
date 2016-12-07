public class Dev_Dto_ExaminationAnswer {

	/** 問題レコードタイプ「単一選択」 */
	private static String DEV_NAME_SINGLE_ANSWER = 'Dev_SingleAnswer_RecType';

	/** 問題レコードID */
	public Id questionId {get; set;}

	/** 問題文 */
	public String questionSentence {get; set;}

	/** 選択肢リスト */
	public List<SelectOption> options {get; set;}

	/** 回答者レコードID */
	public Id respondantId {get; set;}

	/** 正答No */
	public String correctAnswer {get; set;}

	/** 回答No */
	public String answer {get; set;}

    /** 単一選択問題識別フラグ */
    public Boolean isSingle {get; set;}

	/** コンストラクタ */
	public Dev_Dto_ExaminationAnswer( Dev_Question_Obj__c quData, Id respondantId ) {
		convertFromQuestion(quData, respondantId);
	}

	public void convertFromQuestion( Dev_Question_Obj__c quData, Id respondantId ){
		questionId = quData.Id;
		questionSentence = quData.Dev_QU_Question__c.replace('\n', '<br />');
		setOptions( quData );
		this.respondantId = respondantId;
		correctAnswer = quData.Dev_QU_CorrectAnswer__c;
		isSingle = quData.RecordType.DeveloperName == DEV_NAME_SINGLE_ANSWER;
	}

	private void setOptions( Dev_Question_Obj__c quData ){

		System.debug(quData);

        List<SelectOption> optionsTemp = new List<SelectOption>();
        optionsTemp.add(new SelectOption('1', (quData.Dev_QU_Answer1__c == null ? '' : quData.Dev_QU_Answer1__c)));
        optionsTemp.add(new SelectOption('2', (quData.Dev_QU_Answer2__c == null ? '' : quData.Dev_QU_Answer2__c)));
        optionsTemp.add(new SelectOption('3', (quData.Dev_QU_Answer3__c == null ? '' : quData.Dev_QU_Answer3__c)));
        optionsTemp.add(new SelectOption('4', (quData.Dev_QU_Answer4__c == null ? '' : quData.Dev_QU_Answer4__c)));

        if(quData.Dev_QU_Answer5__c != null){
	        optionsTemp.add(new SelectOption('5', quData.Dev_QU_Answer5__c));
        }

        if(quData.Dev_QU_Answer6__c != null){
	        optionsTemp.add(new SelectOption('6', quData.Dev_QU_Answer6__c));
        }

        options = new List<SelectOption>();

        while(!optionsTemp.isEmpty()){
            Integer size = optionsTemp.size();
            Integer randomNo = Math.floor(Math.random() * size).intValue();
            options.add(optionsTemp.remove(randomNo));
        }

	}

	public Dev_Answer_Obj__c convertToAnswer(Id examHistoryId){

		Dev_Answer_Obj__c anData = new Dev_Answer_Obj__c();
		anData.Dev_AN_TargetQuestion__c = questionId;
		anData.Dev_AN_Respondant__c = respondantId;
		anData.Dev_AN_CorrectAnswer__c = correctAnswer;
		anData.Dev_AN_Answer__c = answer;
		anData.Dev_AN_ExaminationHistory__c = examHistoryId;
		return anData;

	}

	public void setAnswerFromMultiSelect(String[] multiSelect){

		Integer[] multiSelectNum = new Integer[]{};

		for(String numStr : multiSelect){
			multiSelectNum.add(Integer.valueOf(numStr));
		}

		multiSelectNum.sort();

		answer = String.join(multiSelectNum, ';');
	}

	public String[] getAnswerToMultiSelect(){
		if(answer == null){
			return new String[]{};
		}else {
			return answer.split(';');
		}
	}

}