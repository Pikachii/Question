public with sharing class Dev_Dto_ExaminationBtnDisplay {

	public Dev_Dto_ExaminationBtnDisplay() {}

    /** prevボタン表示可否 */
    public Boolean isShowPrevBtn {get; set;}

    /** nextボタン表示可否 */
    public Boolean isShowNextBtn {get; set;}

    /** Check Answerボタン表示可否 */
    public Boolean isShowCheckAnswerBtn {get; set;}

    /** ボタンの表示非表示確認処理 */
    public void checkBtnDisable(Integer currentNo, Integer listSize){
        isShowPrevBtn = (currentNo != 1);
        isShowNextBtn = (currentNo != listSize);
        isShowCheckAnswerBtn = true;
    }

}