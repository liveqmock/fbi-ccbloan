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
    loanTab.fdwidth = "1800px";
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
        whereStr += " and c.devlnenddate < '" +  trimStr(document.getElementById("REPORTDATE").value)  + "' "
    }

    whereStr +=  " and a.loanstate='1' and b.mortregstatus = '1'  and b.releasecondcd in ('03', '06')  and a.bankid in(select deptid from ptdept start with deptid='" + deptid + "' connect by prior deptid=parentdeptid) order by  a.bankid, c.proj_no ";

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
 * @param 
 * @param doType:select
 *            ��������
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