var dw_column;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ���
    document.getElementById("APPT_FEEDBACK_RESULT").focus();
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
}

function saveClick() {

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";

    if (document.getElementById("APPT_FEEDBACK_RESULT").value == '99') {  //����
        if (document.getElementById("APPT_FEEDBACK_REMARK").value == "") {
            alert("���ڱ�ע������ԭ��˵����");
            return;
        }
    }

    var arg = new Object();
    if (operation = "edit") {
        arg.appt_feedback_result = document.getElementById("appt_feedback_result").value;
        arg.appt_feedback_remark = document.getElementById("appt_feedback_remark").value;
        window.returnValue = arg;
        window.close();
    }
}
