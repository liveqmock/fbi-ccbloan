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
    divfd_loanTab.style.height = document.body.offsetHeight - 190;
    // divfd_loanTab.style.height = "350px";
    loanTab.fdwidth = "4800px";
    initDBGrid("loanTab");
    // ��ʼ��ҳ�潹��
    body_init(queryForm, "cbRetrieve");
    // document.getElementById("MORTDATE").focus();
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
    // ����
    if (trimStr(document.getElementById("REPORTDATE").value) != "") {
        //whereStr += " and b.REPORTDATE <='" + trimStr(document.getElementById("REPORTDATE").value) + "'";
        whereStr += " and a.apprdate <= '" +  trimStr(document.getElementById("REPORTDATE").value)  + "' "
    }

    whereStr +=  " and a.loanid = b.loanid  --���������\n" +
        "   and a.apprstate = '06'   --����״̬�����ſ�\n" +
        "   and b.releasecondcd in ('01', '04')  --�ſʽ��01����֤�ſ� 04����ϼ�֤�ſ�\n" +
        "   and b.mortregstatus = '1'   --��Ѻ�Ǽ�״̬ �� δ�Ǽ�\n" +
        "   and b.mortstatus != '51'    --��Ѻ����״̬��δ��Ѻ����\n";

    whereStr +=  "   and a.bankid in (select deptid from ptdept start with deptid='" + deptid + "' connect by prior deptid=parentdeptid)  order by a.apprdate, b.mortecentercd,a.bankid,a.cust_name ";

    //alert(whereStr);
    document.all["loanTab"].whereStr = whereStr;
    document.all["loanTab"].RecordCount = "0";
    document.all["loanTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanTab", false, body_resize);
}

/**
 * report
 *
 */
function loanTab_expExcel_click() {

    // ����ϵͳ�����
    if (getSysLockStatus() == "1") {
        alert(MSG_SYSLOCK);
        return;
    }
    document.getElementById("queryForm").target = "_blank";
    document.getElementById("queryForm").action = "basicReport.jsp";
    document.getElementById("queryForm").submit();
}