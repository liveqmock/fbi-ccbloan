var dw_column;
var operation;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    // ��ʼ�����ݴ��ڣ�У���ʱ����
	dw_column = new DataWindow(document.getElementById("editForm"), "form");
}

function saveClick() {
    var retxml = "";
    retxml = createExecuteform(editForm, "insert", "prom02", "add");
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}