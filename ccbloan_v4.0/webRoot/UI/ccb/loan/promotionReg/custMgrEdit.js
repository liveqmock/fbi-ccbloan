var dw_column;
var operation;
// tab enter�� zhan
document.onkeydown = function(evt) {
    var isie = (document.all) ? true : false;
    var key;
    var srcobj;
    if (isie) {
        key = event.keyCode;
        srcobj = event.srcElement;
    } else {
        key = evt.which;
        srcobj = evt.target;
    }
    if (key == 13 && srcobj.type != 'button' && srcobj.type != 'submit' && srcobj.type != 'reset'
            && srcobj.type != 'textarea' && srcobj.type != '') {
        if (isie) {
            event.keyCode = 9;
        } else {
            var el = getNextElement(evt.target);
            if (el.type != 'hidden')
                el.focus();
            else
                while (el.type == 'hidden')
                    el = getNextElement(el);
            el.focus();
            return false;
        }
    }
}
function getNextElement(field) {
    var form = field.form;
    for (var e = 0; e < form.elements.length; e++) {
        if (field == form.elements[e])
            break;
    }
    return form.elements[++e % form.elements.length];
}
/**
 * ��������onkedown���ú������������س�������Tab��
 */
function addKeyDownEvent(iupt) {
    var oldpress = iupt.onkeydown;
    if (typeof iupt.onkeydown != "function") {
        iupt.onkeydown = jumpNext;
    } else {
        iupt.onkeydown = function() {
            oldpress();
            jumpNext();
        };
    }
}
function jumpNext() {
    if (event.keyCode == 13) {
        event.keyCode = 9;
    }

}
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
            document.getElementById("CUST_BANKID").value = document.getElementById("custbankid").value;
            operReSelectCustMgr();
            // �ͻ������ʼ��
            document.getElementById("CUSTMGR_ID").value = document.getElementById("custMgrID").value;
		}

		// ֻ������£�ҳ�����пռ��ֹ�޸�
		if (operation == "select" || operation == "delete") {
			readFun(document.getElementById("editForm"));
		}

	}
	// ��ʼ�����ݴ��ڣ�У���ʱ����
	dw_column = new DataWindow(document.getElementById("editForm"), "form");
}

/**
 * ���ݾ���������
 */
function reSelect() {
    operReSelectCustMgr();
}
/**
 * ���ݾ���������������Ŀ:�ͻ�����ID
 *
 * @return
 */
function operReSelectCustMgr() {
    refresh_select("CUSTMGR_ID", "select OPERID as value ,OPERNAME as text  from ptoper where" + " deptid='"
            + document.getElementById("CUST_BANKID").value + "'");
}


function saveClick() {
    var doType = document.all.doType.value;
    if (dw_column.validate() != null)
		return;
	var retxml = "";
    document.getElementById("busiNode").value = BUSINODE_180;
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "prom01", "add");
    } else if (operation == "edit") {
        retxml = createExecuteform(editForm,"update","prom01","edit");
    }
    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}