var dw_column;
var operation;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    var arg = window.dialogArguments;
    if (arg) {
        operation = arg.doType;
        if (operation != "add") {
            load_form();
        } else {
            var date = new Date();
        }

        // ֻ������£�ҳ�����пռ��ֹ�޸�
        if (operation == "select" || operation == "delete") {
            readFun(document.getElementById("editForm"));
        }

    }
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
}

/**
 * ���溯�����������ӡ��޸Ķ����øú���
 */
function saveClick() {
    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
        return;
    var retxml = "";
    document.getElementById("busiNode").value = BUSINODE_190;
    if (document.getElementById("finamt").value <= 0) {
        alert("������Ȳ���Ϊ0��");
        return;
    }
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "crdt01", "add");
    } else if (operation = "edit") {
        retxml = createExecuteform(editForm, "update", "crdt01", "editCreditLevel");
    }
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}

// ѭ��ʹ��form���ݲ����޸�
function setReadonlyFunc(userTab) {
    for (var i = 0; i < userTab.length; i++) {
        var obj = userTab.item(i);
        if (obj.type == "text" || obj.type == "textarea") {
            obj.className = "inputReadonly";
            obj.readOnly = true;
        } else if (obj.type == "select-one") {
            obj.disabled = true;
        }
    }
}

/**
 * ������ ѡ��������
 */
function bankFlagSelect() {
    var bankflag = document.getElementById("BANKFLAG").value;
    if (bankflag == "" || bankflag == "0") {
        document.getElementById("devlntimelimittye_tr").style.display = "none";
        document.getElementById("DEVLNTIMELIMITTYE").value = "";
        document.getElementById("DEVLNTIMELIMITTYE").isNull = "true";
        document.getElementById("devlnenddate").isNull = "true";
    } else {
        document.getElementById("devlntimelimittye_tr").style.display = "inline";
    }
}

/**
 * ��������Ѻ����ʱ�޷�ʽ ѡ��������
 */
function devlntimelimittyeSelect() {
    var type = document.getElementById("DEVLNTIMELIMITTYE").value;
    if (type == "2") {
        document.getElementById("devlnenddate").isNull = "false";
    } else {
        document.getElementById("devlnenddate").isNull = "true";
    }
}

