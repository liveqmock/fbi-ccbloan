/*******************************************************************************
 * ��������: ϵͳ��־ <br>
 * �� ��: leonwoo <br>
 * ��������: 2010/01/16<br>
 * �� �� ��:<br>
 * �޸�����: <br>
 * �� Ȩ: ��˾
 ******************************************************************************/

var SQLStr;
var gWhereStr = "";

/**
 * ��ʼ��form����,
 * <p>
 * ����ʼ�����㶨λ�ڲ�ѯ������һ���ؼ���;
 * <p>
 * ��ÿ�β�ѯ��Ϻ󽹵��Զ���λ����һ���ؼ�����ȫѡ��
 *
 */
function body_resize() {
    divfd_promotionTab.style.height = document.body.clientHeight - 180;

    promotionTab.fdwidth = "100%";
    initDBGrid("promotionTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
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
    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    if (checkForm(queryForm) == "false")
        return;
    var whereStr = "";
    if (trimStr(document.getElementById("cust_name").value) != "") {
        whereStr += " and cust_name like '" + trimStr(document.getElementById("cust_name").value) + "%'";
    }
    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and bankid  in(select deptid from ptdept start with deptid='"+document.getElementById("bankid").value+"' connect by prior deptid=parentdeptid)";
    }

    document.all["promotionTab"].whereStr = whereStr + " order by OPERDATE desc ";
    document.all["promotionTab"].RecordCount = "0";
    document.all["promotionTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("promotionTab", false);
}

function promotionTab_appendRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var arg = new Object();
    arg.doType = "add";
    var rtn = dialog("promotionEdit.jsp?doType=add", arg, sfeature);
    if (rtn == "1") {
        document.getElementById("promotionTab").RecordCount = "0";
        Table_Refresh("promotionTab", false, body_resize);
    }
}

/**
 * ˫����񵯳���ϸ��Ϣ�鿴���� ���ò鿴����
 *
 */
function promotionTab_TRDbclick() {
  promotionTab_editRecord_click();
}

function promotionTab_editRecord_click() {
    //����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }

    var sfeature = "dialogwidth:800px; dialogheight:520px;center:yes;help:no;resizable:yes;scroll:yes;status:no";
    var tab = document.all["promotionTab"];
    var trobj = tab.rows[tab.activeIndex];
    var promcustno = "";
    if (tab.rows.length <= 0) {
        alert(MSG_NORECORD);
        return;
    }
    if ((trobj.ValueStr != undefined) && (trobj.ValueStr != "")) {
        var tmp = trobj.ValueStr.split(";");
        promcustno = tmp[0];
    }
    var arg = new Object();
    arg.doType = "edit";
    var rtn = dialog("promotionEdit.jsp?promcustno=" + promcustno + "&doType=edit", arg, sfeature);
    if (rtn == "1") {
        document.getElementById("promotionTab").RecordCount = "0";
        Table_Refresh("promotionTab", false, body_resize);
    }
}
