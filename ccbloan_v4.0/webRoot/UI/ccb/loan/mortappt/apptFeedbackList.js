var SQLStr;
var gWhereStr = "";
var dw_form;

/**
 * ��ʼ��form����
 */
function body_resize() {
    divfd_mainTab.style.height = document.body.clientHeight - 210;
    mainTab.fdwidth = "100%";
    mainTab.actionname = "com.ccb.mortgage.AppointmentAction";
    mainTab.delmethodname = "batchEdit";
    initDBGrid("mainTab");
    //��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    document.getElementById("cust_name").focus();
    document.getElementById("cust_name").select();
    //�������ݴ���У��ʹ��
    dw_form = new DataWindow(document.getElementById("queryForm"), "form");
}


function cbRetrieve_Click(formname) {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false"){
        alert("��У�����");
        return;
    }

    var whereStr = "";
    if (trimStr(document.getElementById("cust_name").value) != "") {
        whereStr += " and ((a.cust_name like'" + trimStr(document.getElementById("cust_name").value) + "%')";
        whereStr += " or (a.cust_py  like'" + trimStr(document.getElementById("cust_name").value) + "%'))";
    }

/*
    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }
    if (trimStr(document.getElementById("bankid").value) != "") {
        //whereStr += " and a.bankid in(select deptid from ptdept start with deptid='" + document.getElementById("bankid").value + "' connect by prior deptid=parentdeptid)";
        whereStr += " and (a.bankid in(select deptid from ptdept start with deptid='" + document.getElementById("bankid").value + "' connect by prior deptid=parentdeptid) " +
            " and b.mortecentercd in (select mortecentercd from ln_morttype where deptid='" + document.getElementById("user_deptid").value +"' and typeflag='0')) ";
    }
*/
    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and a.bankid in(select deptid from ptdept start with deptid='" + document.getElementById("bankid").value + "' connect by prior deptid=parentdeptid) ";
    }
    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }else{
        if (trimStr(document.getElementById("ploanProxyDept").value) == "1") {
            whereStr +=  " and b.mortecentercd in (select mortecentercd from LN_MORTCENTER_APPT where deptid='" + document.getElementById("user_deptid").value +"' and typeflag='0') ";
        }
    }


    if (trimStr(document.getElementById("proj_name_abbr").value) != "") {
        whereStr += " and a.proj_name_abbr like '%" + document.getElementById("proj_name_abbr").value + "%' ";
    }

    if (trimStr(document.getElementById("APPTBIZCODE").value) != "") {
        whereStr += " and b.appt_biz_code ='" + trimStr(document.getElementById("APPTBIZCODE").value) + "' ";
    }
    whereStr += getWhereString_oper_str("b", "APPT_HDL_DATE", ">=", "STARTDATE");
    whereStr += getWhereString_oper_str("b", "APPT_HDL_DATE", "<=", "ENDDATE");

    whereStr += " order by b.appt_date_apply desc, b.appt_time_apply desc,b.mortecentercd, a.bankid, b.mortid ";
    document.all["mainTab"].whereStr = whereStr;

    document.all["mainTab"].RecordCount = "0";
    document.all["mainTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("mainTab", false, body_resize);
}
function getWhereString_oper_str(tableName, dbFieldName, operator, uiFieldName) {
    if (trimStr(document.getElementById(uiFieldName).value) != "") {
        return  " and " + tableName + "." + dbFieldName + operator + "'" + trimStr(document.getElementById(uiFieldName).value) + "'";
    } else {
        return "";
    }
}

/**
 * �쿴��Ѻ��ϸ����
 *
 * @param mortid����Ѻ���
 * @param doType:select
 *            ��������
 */
function mainTab_query_click() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["mainTab"];
    var trobj = tab.rows[tab.activeIndex];
    // ��Ѻ���
    var mortID = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        mortID = tmp[7];
        //alert(mortID);
    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/mortReg/mortgageEdit.jsp?mortID=" + mortID + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 */
function mainTab_TRDbclick() {
    mainTab_query_click();
}

/**
 * �쿴������ϸ����
 */
function mainTab_loanQuery_click() {

    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["mainTab"];
    var trobj = tab.rows[tab.activeIndex];
    var nbxh = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        nbxh = tmp[0];

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("/UI/ccb/loan/loanMgr/loanEdit.jsp?nbxh=" + nbxh + "&doType=select", arg, sfeature);
}

/**
 * ��������
 */
function mainTab_batchEdit_click() {
    // ѡȡ���ݱ�־
    var checked = false;
    var tab = document.all.mainTab;
    var clientNames = "";
    var count = 0;
    for (i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            checked = true;
            count++;
            clientNames += "" + count + "." + tab.rows[i].ValueStr.split(";")[4] + " ";
        }
    }
    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }
    // ---��Ϣ����---
    var sfeature = "dialogwidth:800px; dialogheight:400px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var arg = {};
    arg.doType = "edit";
    arg.clientNames = clientNames;
    var rtn = dialog("apptFeedbackEdit.jsp?doType=edit", arg, sfeature);

    function appendOneTdIntoRow(fieldname, oldvalue) {
        _cell = document.createElement("td");
        _cell.setAttribute("fieldname", fieldname);
        _cell.style.display = "none";
        _cell.setAttribute("fieldtype", "text");
        _cell.setAttribute("oldvalue", oldvalue);
        tab.rows[i].appendChild(_cell);
    }

    if (rtn != undefined) {
        for (var i = 0; i < tab.rows.length; i++) {
            if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
                tab.rows[i].operate = "delete";
                checked = true;
                var _cell;
                appendOneTdIntoRow("recversion", tab.rows[i].ValueStr.split(";")[11]);
                appendOneTdIntoRow("appt_feedback_result", rtn.appt_feedback_result);
                appendOneTdIntoRow("appt_feedback_remark", rtn.appt_feedback_remark);

                if (rtn.appt_feedback_result == "10") { //�Ѱ����Ѻ��δ��֤��
                    appendOneTdIntoRow("apptstatus", "30"); //�Ѱ����Ѻ��δ��֤
                    appendOneTdIntoRow("appt_valid_flag", "1"); //��Ч��¼
                    appendOneTdIntoRow("appt_over_flag", "0"); //������δ���ֱ��  Ȩ֤����ⷽ��Ϊ����
                }else{
                    appendOneTdIntoRow("apptstatus", "40"); //��ԤԼ��Ѻ��δ����
                    appendOneTdIntoRow("appt_valid_flag", "1"); //��Ч��¼

                    //20130721 zhan
                    //appendOneTdIntoRow("appt_over_flag", "0"); //����δ���
                    appendOneTdIntoRow("appt_over_flag", "1"); //���������
                }
                appendOneTdIntoRow("action_type", "feedback"); //����
            } else {
                tab.rows[i].operate = "";
            }
        }

        // �ύ��̨���������޸�
        var retxml = postGridRecord(tab);
        if (retxml + "" == "true") {
            window.returnValue = "1";
        }
    }
}
