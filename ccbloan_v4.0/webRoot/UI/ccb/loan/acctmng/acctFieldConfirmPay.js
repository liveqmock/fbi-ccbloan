var dw_column;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ���
    document.getElementById("remark").focus();

    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
}

function saveClick() {

    var doType = document.all.doType.value;

    if (dw_column.validate() != null){
        return;
    }
    var retxml = "";
    // �������
//    document.getElementById("busiNode").value = BUSINODE_130;
    if (doType == "add") {
        retxml = createExecuteform(editForm, "insert", "acct01", "addAcctField");
    } else if (doType == "edit") {
        retxml = createExecuteform(editForm, "update", "acct01", "getAcctNo");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
