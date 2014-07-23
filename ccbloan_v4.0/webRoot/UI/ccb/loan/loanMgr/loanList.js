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
    divfd_loanTab.style.height = document.body.clientHeight - 180;
    loanTab.fdwidth = "100%";
    initDBGrid("loanTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    document.getElementById("FLOWSN").focus();
    document.getElementById("FLOWSN").select();
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
    if (trimStr(document.getElementById("FLOWSN").value) != "") {
        whereStr += " and a.loanid like'%"+  trimStr(document.getElementById("FLOWSN").value)+ "%'";
    }

    if (trimStr(document.getElementById("cust_name").value) != "") {
        whereStr += " and ((a.cust_name like'" + trimStr(document.getElementById("cust_name").value) + "%')";
        whereStr += " or (a.cust_py  like'" + trimStr(document.getElementById("cust_name").value) + "%'))";
    }
    whereStr += " order by a.CUST_OPEN_DT desc,APLY_DT desc,a.cust_py asc ";

    document.all["loanTab"].whereStr = whereStr;
    document.all["loanTab"].RecordCount = "0";
    document.all["loanTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanTab", false, body_resize);
}

/**
 * ��Ӵ�����Ϣ
 *
 * @param doType:��������
 * @param loanid:�����������
 */
function loanTab_appendRecod_click() {
//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanTab"];
    var trobj = tab.rows[tab.activeIndex];

    var arg = new Object();
    // �������ͣ�add
    arg.doType = "add";

    var ret = dialog("loanEdit.jsp?doType=add", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanTab").RecordCount = "0";
        Table_Refresh("loanTab", false, body_resize);
    }
}

/**
 * �쿴������ϸ����
 *
 * @param loanID�������������
 * @param doType:select
 *          ��������
 */
function loanTab_query_click() {

//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["loanTab"];
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
    dialog("loanEdit.jsp?nbxh=" + nbxh + "&doType=select", arg, sfeature);
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function loanTab_TRDbclick() {
    loanTab_query_click();
}


/**
 * �༭������Ϣ
 *
 * @param doType:��������
 *          �޸� edit
 * @param nbxh:�ڲ����
 */
function loanTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    var sfeature = "dialogwidth:800px; dialogheight:600px;center:yes;help:no;resizable:yes;scroll:no;status:no";
    var tab = document.all["loanTab"];
    var trobj = tab.rows[tab.activeIndex];

    var nbxh = "";
    var flowsn = "";

    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        nbxh = tmp[0];
    }
    flowsn = document.getElementById("FLOWSN").value;
    var arg = new Object();
    // �������ͣ�edit
    arg.doType = "edit";
    // �ڲ����
    arg.nbxh = nbxh;
    arg.flowsn = flowsn;
    var ret = dialog("loanEdit.jsp?nbxh=" + nbxh + "&flowsn="+flowsn+"&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanTab").RecordCount = "0";
        Table_Refresh("loanTab", false, body_resize);
    }
}


/**
 * <p>ɾ������
 * @param mortID:��Ѻ���
 * @param keepCont:��������
 * @param loanID�������������
 */
function loanTab_deleteRecord_click() {
//����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var tab = document.all["loanTab"];
    var trobj = tab.rows[tab.activeIndex];

    var nbxh = "";
    var promcustno = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }

    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        nbxh = tmp[0];
        promcustno = tmp[9];
    }

    if (confirm(MSG_DELETE_CONFRIM)) {
        // ���浽���ر������ύ��̨
        document.all.nbxh.value = nbxh;
        document.getElementById("busiNode").value = BUSINODE_130;
        document.getElementById("PROMCUST_NO").value = promcustno;
        var retxml = createExecuteform(queryForm, "delete", "loan01", "delete");
        if (analyzeReturnXML(retxml) != "false") {
            alert(MSG_DEL_SUCCESS);
            document.getElementById("loanTab").RecordCount = "0";
            Table_Refresh("loanTab", false, body_resize);
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

    var ret = dialog("loanEditReg.jsp?nbxh=" + loanID + "&doType=add", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanTab").RecordCount = "0";
        Table_Refresh("loanTab", false, body_resize);
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
    arg.nbxh = flowsn;
    arg.loanID = flowsn;
    arg.flowSn = trimStr(document.getElementById("FLOWSN").value);

    var ret = dialog("loanEditReg.jsp?nbxh=" +flowsn+ "&doType=edit", arg, sfeature);

    if (ret == "1") {
        document.getElementById("loanTab").RecordCount = "0";
        Table_Refresh("loanTab", false, body_resize);
    }
}
