public class Dev_CL_Examination {

    /** 現在の問題番号 */
    public Integer questionNo {get; set;}

    /** 現在の問題 */
    public Dev_Dto_ExaminationAnswer exam {get; set;}

    /** ボタン表示管理 */
    public Dev_Dto_ExaminationBtnDisplay examBtnDisp {get; set;}

    /** 選択値(複数) */
    private String[] selectAnswerMulti = new String[]{};

    /** 正解表示 */
    public String answer {get; set;}

    /** 問題リスト */
    public Dev_Dto_Examination examDto{get; set;}

    /** タイマー */
    public Integer timer {get; set;}

    /** コンストラクタ */
    public Dev_CL_Examination(){}

    /** 初期設定 */
    public void init(){

        // 問題管理クラスのインスタンス生成・初期化
        examDto = new Dev_Dto_Examination();
        examDto.init();

        questionNo = 1;

        // 画面ボタン表示制御クラスのインスタンス生成・初期化
        examBtnDisp = new Dev_Dto_ExaminationBtnDisplay();
        examBtnDisp.checkBtnDisable(questionNo, examDto.getExamSize());


        // 初回問題設定
        exam = examDto.getExam(0);

        // 複数問題の場合には保持している回答を「;」で分割します
        if(!exam.isSingle){
            selectAnswerMulti = exam.getAnswerToMultiSelect();
        }

        // タイマーを設定します。
        timer = examDto.timer;

        outputInfo();

    }

    /** prevボタン押下処理 */
    public PageReference prev(){

        outputInfo ();

        // 問題番号を1戻します
        questionNo--;

        // 共通処理
        commonActionOnPrevNextBtnClick();
        return redraw();
    }

    /** nextボタン押下処理 */
    public PageReference next(){

        outputInfo ();

        // 問題番号を1進めます
        questionNo++;

        // 共通処理
        commonActionOnPrevNextBtnClick();
        return redraw();
    }

    /** prev, nextボタン押下時の共通処理 */
    private void commonActionOnPrevNextBtnClick(){

        // 複数問題の場合、回答リストを「;」区切りで1つの文字列に結合
        if(!exam.isSingle){
            exam.setAnswerFromMultiSelect(selectAnswerMulti);
        }

        // ボタンの表示非表示を設定します。
        examBtnDisp.checkBtnDisable(questionNo, examDto.getExamSize() - 1);

        // 問題をボタン押下に応じて前後の問題に設定します。
        exam = examDto.getExam(questionNo - 1);

        // 複数問題の場合には保持している回答を「;」で分割します
        if(!exam.isSingle){
            selectAnswerMulti = exam.getAnswerToMultiSelect();
        }

    }

    /** checkAnswerボタン押下処理 */
    public PageReference checkAnswer(){
        if(!exam.isSingle){
            exam.setAnswerFromMultiSelect(selectAnswerMulti);
        }
        setAnswer();
        examBtnDisp.isShowCheckAnswerBtn = false;
        return redraw();
    }

    /** 再描画処理 */
    private PageReference redraw() {
        outputInfo ();
        return null;
    }

    /** 解答表示処理 */
    public void setAnswer(){
        answer = 'あなたが選んだ選択肢: ' + exam.answer;
        answer += ', 正解 : ' + exam.correctAnswer;
    }

    /** 回答提出処理 */
    public PageReference submit(){

        if(!exam.isSingle){
            exam.setAnswerFromMultiSelect(selectAnswerMulti);
        }

        Id ehId = examDto.submit();

        PageReference nextPage = Page.Dev_VF_ShowResult;

        nextPage.getParameters().put('examinationHistory', ehId);
        
        return nextPage;

    }

    public void setSelectAnswerMulti(String[] selectAnswerMulti){
        System.debug(selectAnswerMulti);
        this.selectAnswerMulti = selectAnswerMulti;
    }

    public String[] getSelectAnswerMulti(){
        return selectAnswerMulti;
    }

    public PageReference countDown(){

        timer--;
        if(timer == 0){
            return submit();
        }else{
            return null;
        }

    }

    private void outputInfo (){
        System.debug('回答問題 : No.' + questionNo);
        System.debug('回答 : ' + exam.answer);
        System.debug('正解 : ' + exam.correctAnswer);
    }

}