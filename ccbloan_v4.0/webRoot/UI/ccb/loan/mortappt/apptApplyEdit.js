var dw_column;

/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {

    // ��ʼ�����ݴ��ڣ�У���ʱ����
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // ����Ĭ�Ͻ��㣻���
    document.getElementById("appt_date").focus();
    document.getElementById("clientNames").value = window.dialogArguments.clientNames;
    document.getElementById("mortCenterCD").value = window.dialogArguments.mortCenterCD;
    document.getElementById("currAppNum").value = window.dialogArguments.currAppNum;
}

function saveClick() {
    if (onSearchAppNumInfo()!=0){
        alert("��ǰ����ԤԼ����������");
        window.close();
        return;
    }

    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    var arg = new Object();
    if (operation = "edit") {
        arg.appt_date = document.getElementById("appt_date").value;
        var  appt_date_init = document.getElementById("appt_date_init").value;
        var  appt_date_pre = document.getElementById("appt_date_pre").value;
        if (arg.appt_date < appt_date_init) {
            alert("����ǰ " + appt_date_pre +  " ����е�Ѻ����ԤԼ...");
            return;
        }
        var appt_times = document.getElementsByName("appt_time");
        for (var i = 0; i < appt_times.length; i++) {
            if (appt_times[i].checked) {
                arg.appt_time = appt_times[i].value;
            }
        }
        arg.appt_remark = document.getElementById("appt_remark").value;
        window.returnValue = arg;
        window.close();
    }
}

function onSearchAppNumInfo() {
    var appDate = trimStr(document.getElementById("appt_date").value);
    if (appDate == "") {
        alert('������ԤԼ����.');
        return -1;
    }

    //����Ƿ񳬹�ԤԼ���� TODO
    var retxml = createselect(editForm, "com.ccb.mortgage.SelectAppNumAction");
    if (retxml == "false") {
        alert("����ԤԼ�����Ѿ��������ԤԼ����");
        return -1;
    }
    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return 0;
    } else {
        return(rootNode.firstChild.xml);
    }
}