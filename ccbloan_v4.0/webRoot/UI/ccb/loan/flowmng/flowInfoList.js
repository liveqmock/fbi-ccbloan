
var dw_column;
var operation = "add";

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


function body_resize() {
    //divfd_loanTab.style.height = document.body.clientHeight - 330;
    loanTab.fdwidth = "100%";
    initDBGrid("loanTab");
    // ��ʼ��ҳ�潹��
    //body_init(queryForm, "cbRetrieve");
    document.getElementById("FLOWSN").focus();
    document.getElementById("FLOWSN").select();
    // ��ʼ�����ݴ��ڣ�У���ʱ����
    dw_column = new DataWindow(document.getElementById("queryForm"), "form");
    resetDialogHeight();
    document.getElementById("AF_REMARK").value = trimStr(document.getElementById("AF_REMARK").value)
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
    opt.setAttribute("text", "����Ӫ������...");
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
            whereStr += " and bankid ='" + trimStr(document.getElementById("BANKID").value) + "'";
            whereStr += " and prommgr_id ='" + trimStr(document.getElementById("CUSTMGR_ID").value) + "'";
        }
        document.all["promotionTab"].whereStr = whereStr;
        document.all["promotionTab"].RecordCount = "0";
        document.all["promotionTab"].AbsolutePage = "1";
        Table_Refresh("promotionTab",false);
    }
}



function loanTab_TRDbclick() {
    loanTab_select_click();
}

function loanTab_select_click() {
}


function saveClick() {
    if (dw_column.validate() != null)
        return;

    var flowstat_radio = document.getElementsByName("FLOWSTAT");
    for (var i = 0; i<flowstat_radio.length;i++){
        if (flowstat_radio[i].checked == true) {
            if (flowstat_radio[i].value == '20') {
                if (document.getElementById("AF_REMARK").value == "") {
                    alert("���ڱ�ע���������ԭ��");
                    return;
                }
            }
        }
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\��]/g,'');
    if (flowNo.length != 18 && flowNo.length != 20) {
        alert("��ˮ�ų��Ȳ���ȷ��������ɨ�衣");
        document.getElementById("FLOWSN").focus();
        document.getElementById("FLOWSN").select();
        return;
    }

    document.getElementById("FLOWSN").value = flowNo;
    var retxml = "";
    // �������
    document.getElementById("busiNode").value = BUSINODE_130;
    if (operation == "add") {
        retxml = createExecuteform(queryForm, "insert", "com.ccb.flowmng.ArchiveInfoAction", "add");
    } else if (operation == "edit") {
        retxml = createExecuteform(queryForm, "update", "com.ccb.flowmng.ArchiveInfoAction", "edit");
    }

    if (analyzeReturnXML(retxml) + "" == "true") {
        //window.returnValue = "1";
        //window.close();
        document.getElementById("queryForm").reset();
        reselectRealCustMgr();
        document.getElementById("FLOWSN").readOnly = false;
        operation = "add";

        document.getElementById("loanTab").RecordCount = "0";
        Table_Refresh("loanTab", false, body_resize);
    }

}

function loanTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanTab"];
    var trobj = tab.rows[tab.activeIndex];

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        var flowsn = tmp[0];
        var cust_name = tmp[1];
        var rt_orig_loan_amt = tmp[2].replace(/[,]/g, "");
        var rt_term_incr = tmp[3];

        var bankid = tmp[9];         //�������
        var custmgr_id = tmp[10];    //Ӫ������
        var cust_bankid = tmp[11];   //��Ӫ����
        var realcustmgr_id = tmp[12];//�ͻ�����
        var af_flowstat = tmp[13];     //����״̬
        var af_remark = tmp[14];     //���̱�ע
        var recversion = tmp[15];
        var af_pkid = tmp[16];
        var af_recversion = tmp[17];
        document.getElementById("FLOWSN").value = flowsn;
        document.getElementById("FLOWSN").readOnly = true;
        document.getElementById("CUST_NAME").value = cust_name;
        document.getElementById("RT_ORIG_LOAN_AMT").value = rt_orig_loan_amt;
        document.getElementById("RT_TERM_INCR").value = rt_term_incr;

        var flowstat_radio = document.getElementsByName("FLOWSTAT");
        for (var i = 0; i<flowstat_radio.length;i++){
            if (flowstat_radio[i].value == af_flowstat) {
                flowstat_radio[i].checked = true;
            }
        }

        document.getElementById("AF_REMARK").value = af_remark;
        document.getElementById("recversion").value = recversion;
        document.getElementById("af_recversion").value = af_recversion;
        document.getElementById("af_pkid").value = af_pkid;

        document.getElementById("BANKID").value = bankid;
        document.getElementById("CUST_BANKID").value = cust_bankid;
        reselectRealCustMgr();
        reSelect();
        document.getElementById("CUSTMGR_ID").value = custmgr_id;
        document.getElementById("REALCUSTMGR_ID").value = realcustmgr_id;
        operation = "edit";
    }
}
function loanTab_deleteRecord_click() {
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var tab = document.all["loanTab"];
    var trobj = tab.rows[tab.activeIndex];

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }
    var flowsn;
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        flowsn = tmp[0];
    }

    if (confirm(MSG_DELETE_CONFRIM)) {
        document.getElementById("busiNode").value = BUSINODE_130;
        document.getElementById("FLOWSN").value = flowsn;
        var retxml = createExecuteform(queryForm, "delete", "com.ccb.flowmng.ArchiveInfoAction", "delete");
        if (analyzeReturnXML(retxml) != "false") {
            alert(MSG_DEL_SUCCESS);
            document.getElementById("loanTab").RecordCount = "0";
            document.getElementById("queryForm").reset();
            reselectRealCustMgr();
            Table_Refresh("loanTab", false, body_resize);
        }
    }
}



