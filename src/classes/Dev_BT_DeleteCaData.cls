global class Dev_BT_DeleteCaData implements Database.Batchable<sObject> {

	private Integer totalDeleteData;

	global Dev_BT_DeleteCaData() {
		totalDeleteData = 0;
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(
			[
				SELECT
					id
				FROM
					Dev_CheckAnswerMail_Obj__c
				WHERE
					Dev_CA_SendMeilFlag__c = true
			]
		);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		delete scope;
   		totalDeleteData += scope.size();

	}

	global void finish(Database.BatchableContext BC) {

	}

}