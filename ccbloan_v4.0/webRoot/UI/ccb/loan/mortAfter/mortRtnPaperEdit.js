/*******************************************************************************
 *
 * �ļ����� ��Ѻ��ϸ����
 *
 * �� �ã�
 *
 * �� �ߣ� leonwoo
 *
 * ʱ �䣺 2010-01-16
 *
 * �� Ȩ�� leonwoo
 *
 ******************************************************************************/
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

        // �������Ĭ��Ϊϵͳʱ��
        if (document.getElementById("PAPERRTNDATE").value == "") {
            var date = new Date();
            document.getElementById("PAPERRTNDATE").value = getDateString(date);
            document.getElementById("PAPERRTNDATE").readOnly = "readOnly";
        }
        // ��Ѻ�Ǽ�״̬Ϊ���ѵǼ�
        document.getElementById("MORTREGSTATUS").value = "3";

        if (document.getElementById("KEEPCONT").value == "") {
            document.getElementById("KEEPCONT").value = "10";
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
        document.getElementById("PAPERRTNDATE").focus();
    }
}

/**
 * <p>
 * ���溯�����������ӡ��޸Ķ����øú���
 * <p>
 * createExecuteform �����ֱ�Ϊ
 * <p>
 * ��editForm :�ύ��form����
 * <p>
 * ��insert ���������ͣ�����Ϊinsert��update��delete֮һ��
 * <p>
 * ��mort01 ���Ựid����̨ҵ���߼����
 * <p>
 * ��add: : ��̨ҵ�����ʵ�ʶ�Ӧ��������
 *
 * @param doType����������
 *
 */
function saveClick() {
    if (document.getElementById("documentid").value == "") {
        if (!confirm("��Ҫ�������Ϊ�գ�ȷ����?")) {
            return;
        }
    }

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "mort01", "add");
    } else if (operation = "edit") {
        // Ȩ֤����� 30
        var MORT_FLOW_SAVED = "30";
        document.getElementById("MORTSTATUS").value = MORT_FLOW_SAVED;
        document.getElementById("busiNode").value = BUSINODE_080;
        retxml = createExecuteform(editForm, "update", "mort01", "edit");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}
function newDocId_Click() {
    var retxml = createselect(editForm, "com.ccb.mortgage.mortgageAction", "generateDocumentID");
    if (analyzeReturnXML(retxml) != "false") {
        var dom = createDomDocument();
        dom.loadXML(retxml);
        var fieldList = dom.getElementsByTagName("record")[0];
        for (var i = 0; i < fieldList.childNodes.length; i++) {
            if (fieldList.childNodes[i].nodeType == 1) {
                var oneRecord = fieldList.childNodes[i];
                var attrName = oneRecord.getAttribute("name");
                if (attrName == "docid") {
                    document.getElementById("documentid").value = oneRecord.getAttribute("value");
                }
            }
        }
    }
}
