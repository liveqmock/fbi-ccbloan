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
        // ��ʼ�����ݴ��ڣ�У���ʱ����
        dw_column = new DataWindow(document.getElementById("editForm"), "form");
    }
}

function saveClick() {
    if (dw_column.validate() != null)
		return;
	var retxml = "";
    retxml = createExecuteform(editForm,"update","cvrt01","edit");
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}