var dw_column;
var operation;
/**
 * ��ʼ��form�����ݣ���������ȡ����ϸ��Ϣ��������ѯ��ɾ�����޸�
 */
function formInit() {
    var arg = window.dialogArguments;
    var doType = document.getElementById("doType").value;
    if (doType == 'edit') {
        document.getElementById("applyid").disabled = "true";
    }
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
            //setReadonlyFunc(document.getElementById("editForm"));
        }

    }
    // ��ʼ�����ݴ��ڣ�У���ʱ����
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

    if (operation == "add") {
        retxml = createExecuteform(editForm, "insert", "com.ccb.specialbusiness.SpclBusCustAction", "add");
    } else if (operation = "edit") {
        retxml = createExecuteform(editForm, "update", "com.ccb.specialbusiness.SpclBusCustAction", "edit");

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
        // if(obj.type=="text"||obj.type=="textarea"||obj.type=="button"){
        if (obj.type == "text" || obj.type == "textarea") {
            //            obj.disabled = true;
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

/**
 * ���ݾ���������
 */
function reSelect() {
    operReSelectCustMgr();
}



/**
 * ���ݾ���������������Ŀ:Ӫ������ID
 *
 * @return
 */
function operReSelectCustMgr() {

    refresh_select("marketingmanager", "select t.prommgr_id as value,t.prommgr_name as text from ln_prommgrinfo t " +
        "where t.deptid='" + document.getElementById("agencies").value + "' order by prommgr_id desc", "1", "1");
    var objPrommgrid = document.getElementById("marketingmanager");
    if (objPrommgrid.children.length < 1) {
        var optnull = document.createElement("OPTION");
        optnull.setAttribute("text", " ");
        optnull.setAttribute("value", "");
        optnull.setAttribute("selectedIndex", "0");
        objPrommgrid.add(optnull);
    }
    var opt = document.createElement("OPTION");
    opt.setAttribute("text", "����Ӫ������...");
    opt.setAttribute("value", "newadd");
    objPrommgrid.add(opt);

}

/**
 * ���ݾ�Ӫ��������*/

function reSelectCustBank() {
    reselectRealCustMgr();
}
/**
 * ���ݾ�Ӫ����ѡ��ͻ����������˵�*/

function reselectRealCustMgr() {

    refresh_select("customermanager", "select OPERID as value ,OPERNAME as text  from ptoper t " +
        "where t.deptid='" + document.getElementById("operatingcenter").value + "'");
}

/**
 * ���ݿͻ�����;�����*/
/*
 function custMgrReSelect() {
    queryPromotionInfo();
}

function queryPromotionInfo() {
    var whereStr = "";
    if (trimStr(document.getElementById("CUST_NAME").value) != "") {
        whereStr += " and cust_name like '" + trimStr(document.getElementById("CUST_NAME").value) + "%'";
        if ((trimStr(document.all["BANKID"].value) != "" && trimStr(document.all["CUSTMGR_ID"].value) != "")) {
            whereStr += " and bankid ='" + trimStr(document.getElementById("BANKID").value) + "'";
            whereStr += " and prommgr_id ='" + trimStr(document.getElementById("CUSTMGR_ID").value) + "'";
        }
        document.all["promotionTab"].whereStr = whereStr;
        document.all["promotionTab"].RecordCount = "0";
        document.all["promotionTab"].AbsolutePage = "1";
        Table_Refresh("promotionTab",false);
    }
}*/