/*******************************************************************************
 *
 * �ļ����� ������ϸ����
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
        if (srcobj.id == "FLOWSN") {
            if (onSearchArchiveInfo() == 0){
                event.keyCode = 9;
            }else{
                return;
            }
        }
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
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    var arg = window.dialogArguments;
    if (arg) {
        operation = arg.doType;
        if (operation != "add") {
            load_form();
            operReSelectCustMgr();
            reselectRealCustMgr();
            // Ӫ�������ʼ��
            document.getElementById("CUSTMGR_ID").value = document.getElementById("custMgrID").value;
            //�ͻ������ʼ��
            document.getElementById("REALCUSTMGR_ID").value = document.getElementById("realcustMgrID").value;

            //document.getElementById("FLOWSN").readOnly = true;
            document.getElementById("FLOWSN").disabled = true;
            document.getElementById("loanId").focus();
            if(operation == "edit"){
                document.getElementById("FLOWSN").disabled = false;
                document.getElementById("FLOWSN").focus();
            }
        } else {
            //��������ʱ ��ʾ�ƽ���Ϣ
            //divfd_promotionTab.style.height = 100;
            //promotionTab.fdwidth = "1200px";
            //initDBGrid("promotionTab");
        }

        // ֻ������£�ҳ�����пռ��ֹ�޸�
        if (operation == "select" || operation == "delete") {
            readFun(document.getElementById("editForm"));
        }
    }
    // ��ʼ�����ݴ��ڣ�У���ʱ����
    dw_column = new DataWindow(document.getElementById("editForm"), "form");
    // fm_ini();

    resetDialogHeight();
}

// window.onload=fn_ini;
function fm_ini() {
    var fm, i, j;
    for (i = 0; i < document.forms.length; i++) {
        fm = document.forms[i]
        for (j = 0; j < fm.length; j++) {
            // �����input�����ѻس��滻��Tab�ĺ���
            if (fm[j].tagName == "INPUT")
                if (fm[j].getAttribute("type").toLowerCase() != "button")
                    addKeyDownEvent(fm[j]);
        }

    }
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
 * ���ݾ���������
 */
function reSelect() {
    operReSelectCustMgr();
//    if (operation == "add") {
////        queryPromotionInfo();
//    }
}

/**
 * ���ݾ���������������Ŀ:Ӫ������ID
 *
 * @return
 */
function operReSelectCustMgr() {
    refresh_select("CUSTMGR_ID", "select t.prommgr_id as value,t.prommgr_name as text from ln_prommgrinfo t " +
            "where t.deptid='" + document.getElementById("BANKID").value + "' order by prommgr_id desc", "1", "1");
    var objPrommgrid = document.getElementById("CUSTMGR_ID");
    if (objPrommgrid.children.length < 1) {
        var optnull = document.createElement("OPTION");
        optnull.setAttribute("text", " ");
        optnull.setAttribute("value", "");
        optnull.setAttribute("selectedIndex", "0");
        objPrommgrid.add(optnull);
    }
    var opt = document.createElement("OPTION");
    opt.setAttribute("text", "����...");
    opt.setAttribute("value", "newadd");
    objPrommgrid.add(opt);

}
/**
 * ����Ӫ������*/
function promMgrReSelect() {
    if (document.getElementById("CUSTMGR_ID").value == "newadd") {
        var sfeature = "dialogwidth:300px; dialogheight:220px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
        var deptid = "";
        if (document.getElementById("BANKID").value != "") {
            deptid = document.getElementById("BANKID").value;
        }
        var arg = new Object();
        var rtn = dialog("/UI/ccb/loan/promotionReg/promMgradd.jsp?doType=add&deptid=" + deptid, arg, sfeature);
        if (rtn == "1") {
            operReSelectCustMgr();
        }
    }
}

/**
 * ���ݾ�Ӫ��������*/

function reSelectCustBank() {
    reselectRealCustMgr();
}
/**
 * ���ݾ�Ӫ����ѡ��ͻ����������˵�*/

function reselectRealCustMgr() {
    refresh_select("REALCUSTMGR_ID", "select OPERID as value ,OPERNAME as text  from ptoper t " +
            "where t.deptid='" + document.getElementById("CUST_BANKID").value + "'");
}
/**
 * ���ݿͻ�����;�����*/
function custMgrReSelect() {
    queryPromotionInfo();
}

function queryPromotionInfo() {
    var whereStr = "";
    if (trimStr(document.getElementById("CUST_NAME").value) != "") {
        whereStr += " and cust_name like '" + trimStr(document.getElementById("CUST_NAME").value) + "%'";
        if ((trimStr(document.all["BANKID"].value) != "" && trimStr(document.all["CUSTMGR_ID"].value) != "")) {
            whereStr += " and bankid ='" + trimStr(document.getElementById("bankid").value) + "'";
            whereStr += " and prommgr_id ='" + trimStr(document.getElementById("CUSTMGR_ID").value) + "'";
        }
        document.all["promotionTab"].whereStr = whereStr;
        document.all["promotionTab"].RecordCount = "0";
        document.all["promotionTab"].AbsolutePage = "1";
        Table_Refresh("promotionTab",false);
    }
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function promotionTab_TRDbclick() {
    promotionTab_select_click();
}

function promotionTab_select_click() {
    var tab = document.all["promotionTab"];
    var trobj = tab.rows[tab.activeIndex];
    var promotionNo = "";
    var custName = "";
    var loanAmt = "";
    var bankid = "";
    var prommgr_id = "";
    var custbankid = "";
    var custmgr_id = "";
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        promotionNo = tmp[0];
        custName = tmp[1];
        loanAmt = tmp[4];
        bankid = tmp[9];
        prommgr_id = tmp[10];
        custbankid = tmp[11];
        custmgr_id = tmp[12];
        document.getElementById("PROMCUST_NO").value = promotionNo;
        document.getElementById("CUST_NAME").value = custName;
        document.getElementById("RT_ORIG_LOAN_AMT").value = loanAmt;
        //������
        document.getElementById("BANKID").value = bankid;
        operReSelectCustMgr();  //Ӫ������list
        // Ӫ������
        document.getElementById("CUSTMGR_ID").value = prommgr_id;
        //��Ӫ����
        document.getElementById("CUST_BANKID").value = custbankid;
        reselectRealCustMgr();
        //�ͻ�����
        document.getElementById("REALCUSTMGR_ID").value = custmgr_id;
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

    var doType = document.all.doType.value;
    if (document.getElementById("RELEASECONDCD").value == "03") {
        var waringMsgDate = "�ſʽΪǩԼ�ſ�򡾿������ڡ�����Ϊ�գ�";
        var waringMsgProj = "�ſʽΪǩԼ�ſ����Ŀ��š�����Ϊ�գ�";
        if (document.getElementById("CUST_OPEN_DT").value == "") {
            alert(waringMsgDate);
            document.getElementById("CUST_OPEN_DT").focus();
            return;
        }
        if (document.getElementById("PROJ_NO").value == "") {
            alert(waringMsgProj);
            document.getElementById("PROJ_NO").focus();
            return;
        }
    }

    if (dw_column.validate() != null)
        return;

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\��]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    var retxml = "";
    // �������
    document.getElementById("busiNode").value = BUSINODE_130;
    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "loan01", "add");
    } else if (operation = "edit") {
        retxml = createExecuteform(editForm, "update", "loan01", "edit");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        window.returnValue = "1";
        window.close();
    }
}


function onSearchArchiveInfo() {
    // ����ϵͳ�����
    /*if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }*/

    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    flowsn = flowsn.replace(/[\$\��]/g,'');
    document.getElementById("FLOWSN").value = flowsn;

    if (flowsn == "") {
        alert('��������ˮ��.');
        return -1;
    }

    var retxml = createselect(editForm, "com.ccb.flowmng.ArchiveInfoSelectOneAction");
    if (analyzeReturnXML(retxml) != "false") {
        fillform(editForm, analyzeReturnXML(retxml));
        reselectRealCustMgr();
        reSelect();

        //���� CUSTMGR_ID��REALCUSTMGR_ID
        var xmlDoc = createDomDocument();
        xmlDoc.loadXML(retxml);
        var nodes = xmlDoc.selectNodes("/root/action/record/field");
        for (var i= 0, l = nodes.length; i<l;i++){
            if (decode(nodes[i].getAttribute("name")) == "CUSTMGR_ID"){
                document.getElementById("CUSTMGR_ID").value =  decode(nodes[i].getAttribute("value"));
            }
            if (nodes[i].getAttribute("name") == "REALCUSTMGR_ID"){
                document.getElementById("REALCUSTMGR_ID").value =  decode(nodes[i].getAttribute("value"));
            }
        }

        return 0;
    }else{
        document.getElementById("editForm").reset();
        document.getElementById("FLOWSN").value = flowsn;
        reselectRealCustMgr();
        reSelect();
        return -1;
    }
}
