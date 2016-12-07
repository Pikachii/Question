public with sharing class Dev_CL_ShowResult {

	public Dev_ExamHistory_Obj__c result {get; set;}

	public String email {get; set;}

	public Boolean sendOnlyIncorrect {get; set;}

	public Dev_CL_ShowResult() {}

	public void init(){
        Id ehId = ApexPages.currentPage().getParameters().get('examinationHistory');
        Dev_Dao_ExaminationHistory_Obj ehDao = Dev_Dao_ExaminationHistory_Obj.getInstance();
        result = ehDao.getExaminationHistoryById(ehId);
        email = result.Dev_EH_ExamTrialist__r.Dev_RE_MailAddress__c;
	}

	public PageReference createEmail(){
		createCaData();
		return new PageReference('/home/home.jsp');
	}

	public PageReference gotoHome(){
		createCaData();
		return new PageReference('/home/home.jsp');
	}

	private void createCaData(){
		System.debug('create CaData start');
		Dev_CheckAnswerMail_Obj__c caData = new Dev_CheckAnswerMail_Obj__c();
		caData.Dev_CA_Reciever__c = email;
		caData.Dev_CA_Subject__c = '試験結果：'+ result.Dev_EH_TrialExam__r.Name + DateTime.now().format('yyyyMMdd');
		caData.Dev_CA_Contents__c = '';

		caData.Dev_CA_Contents__c += '試験名： ' + result.Dev_EH_TrialExam__r.Name + '\n';
		caData.Dev_CA_Contents__c += '正解数： ' + result.Dev_EH_CorrectAnswerNum__c + ' / ' + result.Dev_EH_ExamQuestionNum__c + '\n';
		caData.Dev_CA_Contents__c += '試験結果： ' + result.Dev_EH_ExamResult__c + '\n\n';
		caData.Dev_CA_Contents__c += '回答詳細： ' +  + '\n';

		Integer questionNo = 1;

		for(Dev_Answer_Obj__c anData : result.Dev_EH_Answers__r){

			if(sendOnlyIncorrect && anData.Dev_AN_isCorrect__c == '○'){
				continue;
			}

			caData.Dev_CA_Contents__c += '試験No.' + questionNo + '\n';
			caData.Dev_CA_Contents__c += '問題文: ' + anData.Dev_AN_TargetQuestion__r.Dev_QU_Question__c + '\n';
			caData.Dev_CA_Contents__c += '正誤: ' + anData.Dev_AN_isCorrect__c + '\n';
			caData.Dev_CA_Contents__c += 'URL: https://ap2.salesforce.com/' + anData.Id + '\n\n';
			questionNo++;

		}

		insert caData;
		System.debug('create CaData end');

	}

}