var dw_column;
var operation;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    // ��ʼ���¼�
    var arg = window.dialogArguments;

    if (arg) {
        operation = arg.doType;
        if (operation != "add") {
            load_form();
        }

        //�������Ĭ��Ϊϵͳʱ��
        if (document.getElementById("EXP_PAPER_SIGNIN_DATE").value == "") {
            var date = new Date();
            document.getElementById("EXP_PAPER_SIGNIN_DATE").value = getDateString(date);
            document.getElementById("EXP_PAPER_SIGNIN_DATE").readOnly = "readOnly";
        }

        // ֻ������£�ҳ�����пռ��ֹ�޸�
        if (operation == "select" || operation == "delete") {
            readFun(document.getElementById("editForm"));
        }

    }
    // ��ʼ�����ݴ��ڣ�У���ʱ����
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ��㣻�������
    if (operation != "select") {
        document.getElementById("EXP_PAPER_SIGNIN_DATE").focus();
    }
}


/**
 * ���溯�����������ӡ��޸Ķ����øú���
 */
function saveClick() {

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "mort01", "add");
    } else if (operation = "edit") {
        //Ȩ֤ǩ�� 21A
        document.getElementById("MORTSTATUS").value = "21A";
        document.getElementById("busiNode").value = BUSINODE_070;
        retxml = createExecuteform(editForm, "update", "mort01", "edit");
    }
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
