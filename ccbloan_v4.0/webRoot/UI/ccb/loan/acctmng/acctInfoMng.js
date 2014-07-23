var SQLStr;
var gWhereStr = "";

document.onkeydown = function (evt) {
    var key = event.keyCode;
    var srcobj = event.srcElement;
    if (key == 13 && srcobj.type != 'button' && srcobj.type != 'submit' && srcobj.type != 'reset'
        && srcobj.type != 'textarea' && srcobj.type != '') {
        if (srcobj.id == "FLOWSN") {
            var searchResult = onSearchLoanInfo();
            if (searchResult != -1) {
                editLoanInfo();
            } else {
                searchResult = onSearchArchiveInfo();
                if(searchResult !=-1){
                    addMortInfoByArchiveInfo();
                }
            }
        }
    }
}

function onSearchLoanInfo() {
    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    if (flowsn == "") {
        alert('��������ˮ��.');
        return -1;
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\��]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    //����Ƿ���������Ѻ���� TODO
    var retxml = createselect(queryForm, "com.ccb.flowmng.SelectLoanIDFlowsnAction");
    if (retxml == "false") {
        alert("�����ϲ����ڡ�");
        return -1;
    }

    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return(rootNode.firstChild.xml);
    } else {
        return -1;
    }
}

function onSearchArchiveInfo() {
    var flowsn = trimStr(document.getElementById("FLOWSN").value);
    if (flowsn == "") {
        alert('��������ˮ��.');
        return -1;
    }

    var flowNo = document.getElementById("FLOWSN").value;
    flowNo = flowNo.replace(/[\$\��]/g,'');
    document.getElementById("FLOWSN").value = flowNo;

    //��ȡloanid
    var retxml = createselect(queryForm, "com.ccb.flowmng.SelectLoanIDAction");
    if (retxml == "false") {
        alert("�˴������ϲ����ڡ�");
        return -1;
    }
    var xmlDoc = createDomDocument();
    xmlDoc.loadXML(retxml);
    var rootNode = xmlDoc.documentElement.firstChild;
    if (rootNode != null && rootNode.getAttribute("result") == "true" && rootNode.firstChild.xml != "null") {
        return(rootNode.firstChild.xml);
    } else {
        alert("�޴���ˮ����ϸ��¼...");
        return -1;
    }
}

/**
 * ��ʼ��form����,
 * <p>
 * ����ʼ�����㶨λ�ڲ�ѯ������һ���ؼ���;
 * <p>
 * ��ÿ�β�ѯ��Ϻ󽹵��Զ���λ����һ���ؼ�����ȫѡ��
 *
 */
function body_resize() {
    divfd_acctTab.style.height = document.body.clientHeight - 180;
    acctTab.fdwidth = "100%";
    acctTab.actionname = "acct01";
    acctTab.delmethodname = "batchEdit";
    initDBGrid("acctTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    document.getElementById("cust_name").focus();
    document.getElementById("cust_name").select();
}

/**
 * <p>
 * ������������������ɺ󽹵��Զ���λ�����������һ�������У� ����ȫѡ��;
 * <p>
 * ��ϵͳ��������������ĺ��ֻ���ƴ����ѯ ������ƴ����ѯ�ǡ�or���Ĺ�ϵ;
 * <p>
 * ��������ƴ����֧��ǰ��һ�¡����ģ����ѯ��
 * <p>
 * �����»س����Զ�֧�ֲ�ѯ��
 * </p>
 *
 * @param ��form���ֻ���ID
 */

function cbRetrieve_Click(formname) {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false")
        return;

    var whereStr = "";

    if (trimStr(document.getElementById("cust_name").value) != "") {
        whereStr += " and ((b.cust_name like'" + trimStr(document.getElementById("cust_name").value) + "%') ";
        whereStr += " or (b.cust_py  like'" + trimStr(document.getElementById("cust_name").value) + "%')) ";
    }

    if (trimStr(document.getElementById("appt_name").value) != "") {
        whereStr += " and ((b.cust_name like'" + trimStr(document.getElementById("appt_name").value) + "%') ";
        whereStr += " or (b.cust_py  like'" + trimStr(document.getElementById("appt_name").value) + "%')) ";
    }

    if (trimStr(document.getElementById("proj_name").value) != "") {
        whereStr += " and b.proj_no in ( select proj_no from ln_coopproj where proj_name like '%" + trimStr(document.getElementById("proj_name").value) + "%')";
    }

    if (trimStr(document.getElementById("pay_flag").value) != "") {
        whereStr += " and a.pay_flag = '"+  trimStr(document.getElementById("pay_flag").value)+ "' ";
    }

    if (trimStr(document.getElementById("PAY_DATE1").value) != "") {
        whereStr += " and a.PAY_DATE >= '"+  trimStr(document.getElementById("PAY_DATE1").value)+ "' ";
    }

    if (trimStr(document.getElementById("PAY_DATE2").value) != "") {
        whereStr += " and a.pay_flag <= '"+  trimStr(document.getElementById("PAY_DATE2").value)+ "' ";
    }

    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and b.bankid in(select deptid from ptdept start with deptid='" + document.getElementById("bankid").value + "' connect by prior deptid=parentdeptid) ";
    }

/*    if (trimStr(document.getElementById("mortecentercd").value) != "") {
        whereStr += " and b.mortecentercd ='" + trimStr(document.getElementById("mortecentercd").value) + "' ";
    }else{
        if (trimStr(document.getElementById("ploanProxyDept").value) == "1") {
            whereStr +=  " and b.mortecentercd in (select mortecentercd from LN_MORTCENTER_APPT where deptid='" + document.getElementById("user_deptid").value +"' and typeflag='0') ";
        }
    }*/

    whereStr += " order by a.loanid ";

    document.all["acctTab"].whereStr = whereStr;
    document.all["acctTab"].RecordCount = "0";
    document.all["acctTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("acctTab", false, body_resize);
}

/**
 * ��Ӵ�����Ϣ
 *
 * @param doType:��������
 * @param loanid:�����������
 */
function acctTab_appendRecod_click() {
//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];

    var arg = new Object();
    // �������ͣ�add
    arg.doType = "add";

    var ret = dialog("loanEdit.jsp?doType=add", arg, sfeature);

    if (ret == "1") {
        document.getElementById("acctTab").RecordCount = "0";
        Table_Refresh("acctTab", false, body_resize);
    }
}

/**
 * �쿴�˺���ϸ����
 *
 * @param loanID�������������
 * @param doType:select
 *          ��������
 */
function acctTab_query_click() {

//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];
    var acctid = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        acctid = tmp[0];

    }
    var arg = new Object();
    arg.doType = "select";
    dialog("acctEdit.jsp?acctid=" + acctid + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function acctTab_TRDbclick() {
    acctTab_query_click();
}


/**
 * �༭������Ϣ
 *
 * @param doType:��������
 *          �޸� edit
 * @param acctid:�ڲ����
 */
function acctTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];

    var acctid = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        acctid = tmp[0];
    }
    var arg = new Object();
    // �������ͣ�edit
    arg.doType = "edit";
    // �ڲ����
    arg.acctid = acctid;

    var ret = dialog("acctEdit.jsp?acctid=" + acctid + "&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("acctTab").RecordCount = "0";
        Table_Refresh("acctTab", false, body_resize);
    }
}


/**
 * <p>ɾ������
 * @param mortID:��Ѻ���
 * @param keepCont:��������
 * @param loanID�������������
 */
function acctTab_deleteRecord_click() {
//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];

    var acctid = "";
    var promcustno = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        acctid = tmp[0];
        promcustno = tmp[9];
    }

    if (confirm(MSG_DELETE_CONFRIM)) {
        // ���浽���ر������ύ��̨
        document.all.acctid.value = acctid;
        document.getElementById("busiNode").value = BUSINODE_130;
        document.getElementById("PROMCUST_NO").value = promcustno;
        var retxml = createExecuteform(queryForm, "delete", "loan01", "delete");
        if (analyzeReturnXML(retxml) != "false") {
            alert(MSG_DEL_SUCCESS);
            document.getElementById("acctTab").RecordCount = "0";
            Table_Refresh("acctTab", false, body_resize);
        }
    }
}

function addMortInfoByArchiveInfo() {
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";

    var arg = new Object();
    // �������ͣ�add
    arg.doType = "add";
    // �����������
    var loanID = trimStr(document.getElementById("FLOWSN").value);
    arg.loanID = loanID;
    arg.flowSn = trimStr(document.getElementById("FLOWSN").value);

    var ret = dialog("loanEditReg.jsp?acctid=" + loanID + "&doType=add", arg, sfeature);

    if (ret == "1") {
        document.getElementById("acctTab").RecordCount = "0";
        Table_Refresh("acctTab", false, body_resize);
    }
}

function editLoanInfo(){
    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";

    var flowsn = "";
    flowsn = document.getElementById("FLOWSN").value;

    var arg = new Object();
    // �������ͣ�edit
    arg.doType = "edit";
    // �ڲ����
    arg.acctid = flowsn;
    arg.loanID = flowsn;
    arg.flowSn = trimStr(document.getElementById("FLOWSN").value);

    var ret = dialog("loanEditReg.jsp?acctid=" +flowsn+ "&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("acctTab").RecordCount = "0";
        Table_Refresh("acctTab", false, body_resize);
    }
}

/**
 * ����˻���Ϣ
 *
 * @param doType:��������
 * @param loanid:�����������
 */
function acctTab_addAcct_click() {
//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];
    var loanid = "";

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        loanid = tmp[7];
        //alert(loanid);
    }

    var arg = new Object();
    // �������ͣ�add
    arg.doType = "add";

    var ret = dialog("acctEdit.jsp?loanid=" + loanid + "&doType=add", arg, sfeature);

    if (ret == "1") {
        document.getElementById("acctTab").RecordCount = "0";
        Table_Refresh("acctTab", false, body_resize);
    }
}

/**
 * ����ȷ��
 */
function acctTab_batchEdit_click() {
    // ѡȡ���ݱ�־
    var checked = false;
    var tab = document.all.acctTab;
    var clientNames = "";
    var count = 0;
    for (var i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            tab.rows[i].operate = "delete";
            checked = true;
            // ---
            // ����TD��recversion���ݵ���̨�Ա㲢�����ƣ�
            var _cell = document.createElement("td");
            _cell.setAttribute("fieldname", "recversion");
            // _cell.setAttribute("style","display:none");
            _cell.style.display = "none";
            _cell.setAttribute("fieldtype", "text");
            _cell.setAttribute("oldvalue", tab.rows[i].ValueStr.split(";")[14]);
            tab.rows[i].appendChild(_cell);
            // ---loanid
            _cell = document.createElement("td");
            _cell.setAttribute("fieldname", "acctid");
            // _cell.setAttribute("style","display:none");
            _cell.style.display = "none";
            _cell.setAttribute("fieldtype", "text");
            _cell.setAttribute("oldvalue", tab.rows[i].ValueStr.split(";")[0]);
            tab.rows[i].appendChild(_cell);
            count++;
            clientNames += "" + count + "." + tab.rows[i].ValueStr.split(";")[3] + " ";
        } else {
            tab.rows[i].operate = "";
        }
    }
    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }

    var sfeature = "dialogwidth:560px; dialogheight:300px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var arg = {};
    arg.doType = "edit";
    arg.clientNames = clientNames;
    var rtn = dialog("acctConfirmPay.jsp?doType=edit", arg, sfeature);

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
                appendOneTdIntoRow("pay_flag", "1"); //������ɣ��˻غ󣨻�Ȩ֤��֤��������ԤԼ��Ϊ��Ϊ��ɣ�
                appendOneTdIntoRow("action_type", "pay_confirm"); //�˻�
            } else {
                tab.rows[i].operate = "";
            }
        }
        // �ύ��̨���������޸�
        var retxml = postGridRecord(tab);
        // analyzeReturnXML in dbutil.js pack
        if (retxml + "" == "true") {
            document.getElementById("acctTab").RecordCount = "0";
            Table_Refresh("acctTab", false, body_resize);
            window.returnValue = "1";
        }
    }
}

/**
 *          ֪ͨ���ӡ
 *          aram doType:��������
 *          �޸� edit
 * @param acctid:�ڲ����
 */
function acctTab_filePrint_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
//    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["acctTab"];
    var trobj = tab.rows[tab.activeIndex];

    var acctid = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    // ѡȡ���ݱ�־
    var checked = false;
    var tab = document.all.acctTab;
    var acctid = "";
    var count = 0;
    for (var i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            tab.rows[i].operate = "delete";
            checked = true;
            count++;
            if(acctid==""){
                acctid = "'" + tab.rows[i].ValueStr.split(";")[0] + "'";
            } else{
                acctid += ",'" + tab.rows[i].ValueStr.split(";")[0] + "'";
            }
        } else {
            tab.rows[i].operate = "";
        }
    }
    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }

    if (count>1){
        alert("ÿ��ֻ�ܴ�ӡһ������֪ͨ�飡");
        return;
    }

    var arg = new Object();
    // �������ͣ�edit
    arg.doType = "edit";
    // �ڲ����
    arg.acctid = acctid;

    document.getElementById("acctid").value=acctid;
    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "acctInfoPrintMng.jsp?acctid=" + acctid;
    document.getElementById("queryForm").submit();
}

/**
 *          ֪ͨ���ӡ
 *          aram doType:��������
 *          �޸� edit
 * @param acctid:�ڲ����
 */
function acctTab_allExport_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    // ѡȡ���ݱ�־
    var checked = false;
    var tab = document.all.acctTab;
    var acctid = "";
    var count = 0;
    for (var i = 0; i < tab.rows.length; i++) {
        if (tab.rows[i].cells[0].children[0] != undefined && tab.rows[i].cells[0].children[0].checked) {
            tab.rows[i].operate = "delete";
            checked = true;
            count++;
            if(acctid==""){
                acctid = "'" + tab.rows[i].ValueStr.split(";")[0] + "'";
            } else{
                acctid += ",'" + tab.rows[i].ValueStr.split(";")[0] + "'";
            }
        } else {
            tab.rows[i].operate = "";
        }
    }
    if (!checked) {
        alert(MSG_NORECORD);
        return;
    }

    document.getElementById("acctid").value=acctid;
    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "acctInfoReport.jsp?acctid=" + acctid;
    document.getElementById("queryForm").submit();
}