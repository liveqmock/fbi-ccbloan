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
    divfd_loanTab.style.height = document.body.offsetHeight - 200;
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
    // ��Ѻ��������
    if (trimStr(document.getElementById("MORTDATE").value) != "") {
        whereStr += " and b.MORTDATE >='" + trimStr(document.getElementById("MORTDATE").value) + "'";
    }
    if (trimStr(document.getElementById("MORTDATE2").value) != "") {
        whereStr += " and b.MORTDATE <='" + trimStr(document.getElementById("MORTDATE2").value) + "'";
    }
    // �ſʽ
    if (trimStr(document.getElementById("RELEASECONDCD").value) != "") {
        whereStr += " and b.RELEASECONDCD ='" + trimStr(document.getElementById("RELEASECONDCD").value) + "'";
    }
    // ��������ԭ��
    if (trimStr(document.getElementById("CLRREASONCD").value) != "") {
        whereStr += " and b.CLRREASONCD ='" + trimStr(document.getElementById("CLRREASONCD").value) + "'";
    }
    // ��Ѻ�Ǽ�״̬
    if (trimStr(document.getElementById("MORTREGSTATUS").value) != "") {
        whereStr += " and b.MORTREGSTATUS ='" + trimStr(document.getElementById("MORTREGSTATUS").value) + "'";
    }

    // �Ƿ��ѵǼ�δ�����Ѻԭ��
    // �е�Ѻԭ��
    if (trimStr(document.getElementById("NOMORTREASONCD").value) == "1") {
        whereStr += " and trim(b.NOMORTREASONCD) is not null ";
    }
    // �޵�Ѻԭ��
    else if (trimStr(document.getElementById("NOMORTREASONCD").value) == "0") {
        whereStr += " and trim(b.NOMORTREASONCD) is  null ";
    }

/*

    //20100403 zhan
    // �е�Ѻԭ��     (ö�١���Ѻ�С���14   �����⴦��)
    if (trimStr(document.getElementById("NOMORTREASONCD").value) == "1") {
        whereStr += " and trim(b.NOMORTREASONCD) is not null and trim(b.NOMORTREASONCD) <>'14' ";
    }
    // �޵�Ѻԭ��
    else if (trimStr(document.getElementById("NOMORTREASONCD").value) == "0") {
        whereStr += " and (trim(b.NOMORTREASONCD) is  null  or trim(b.NOMORTREASONCD) = '14') ";
    }

*/

    // ��֤ԭ��
    if (trimStr(document.getElementById("CHGPAPERREASONCD").value) != "") {
        whereStr += " and b.CHGPAPERREASONCD ='" + trimStr(document.getElementById("CHGPAPERREASONCD").value) + "'";
    }
    // ������id
    if (trimStr(document.getElementById("bankid").value) != "") {
        whereStr += " and a.bankid in(select deptid from ptdept start with deptid='"+document.getElementById("bankid").value+"' connect by prior deptid=parentdeptid)";
    }
    // ������Ŀ���
    if (trimStr(document.getElementById("PROJ_NAME_ABBR").value) != "") {
        whereStr += " and c.PROJ_NAME_ABBR like '%" + trimStr(document.getElementById("PROJ_NAME_ABBR").value) + "%'";
    }
    // ����������
    if (trimStr(document.getElementById("CORPNAME").value) != "") {
        whereStr += " and c.CORPNAME like '%" + trimStr(document.getElementById("CORPNAME").value) + "%'";
    }
    // ȡ�û�ִ������
    // ȡ�û�ִ����
    if (trimStr(document.getElementById("RECEIPTDATE").value) != "") {
        whereStr += " and b.RECEIPTDATE >='" + trimStr(document.getElementById("RECEIPTDATE").value) + "'";
    }
    if (trimStr(document.getElementById("RECEIPTDATE2").value) != "") {
        whereStr += " and b.RECEIPTDATE <='" + trimStr(document.getElementById("RECEIPTDATE2").value) + "'";
    }
    // ��Ѻ������������
    if (trimStr(document.getElementById("MORTOVERRTNDATE").value) != "") {
        whereStr += " and b.MORTOVERRTNDATE >='" + trimStr(document.getElementById("MORTOVERRTNDATE").value) + "'";
    }
    if (trimStr(document.getElementById("MORTOVERRTNDATE2").value) != "") {
        whereStr += " and b.MORTOVERRTNDATE <='" + trimStr(document.getElementById("MORTOVERRTNDATE2").value) + "'";
    }
    // ���п������Ƿ�ɱ���Ѻ
    if (trimStr(document.getElementById("SENDFLAG").value) != "") {
        whereStr += " and b.SENDFLAG ='" + trimStr(document.getElementById("SENDFLAG").value) + "'";
    }
    if (trimStr(document.getElementById("bankflag").value) != "") {
        whereStr += " and c.bankflag='" + document.getElementById("bankflag").value + "'";
    }
    // �������
    if (trimStr(document.getElementById("PAPERRTNDATE").value) != "") {
        whereStr += " and b.PAPERRTNDATE >='" + trimStr(document.getElementById("PAPERRTNDATE").value) + "'";
    }
    if (trimStr(document.getElementById("PAPERRTNDATE2").value) != "") {
        whereStr += " and b.PAPERRTNDATE <='" + trimStr(document.getElementById("PAPERRTNDATE2").value) + "'";
    }
    // ����ȡ֤������
    if (trimStr(document.getElementById("CLRPAPERDATE").value) != "") {
        whereStr += " and b.CLRPAPERDATE >='" + trimStr(document.getElementById("CLRPAPERDATE").value) + "'";
    }
    if (trimStr(document.getElementById("CLRPAPERDATE2").value) != "") {
        whereStr += " and b.CLRPAPERDATE <='" + trimStr(document.getElementById("CLRPAPERDATE2").value) + "'";
    }
    // ��֤����������
    if (trimStr(document.getElementById("CHGPAPERDATE").value) != "") {
        whereStr += " and b.CHGPAPERDATE >='" + trimStr(document.getElementById("CHGPAPERDATE").value) + "'";
    }
    if (trimStr(document.getElementById("CHGPAPERDATE2").value) != "") {
        whereStr += " and b.CHGPAPERDATE <='" + trimStr(document.getElementById("CHGPAPERDATE2").value) + "'";
    }
    // ��֤�黹������
    if (trimStr(document.getElementById("CHGPAPERRTNDATE").value) != "") {
        whereStr += " and b.CHGPAPERRTNDATE >='" + trimStr(document.getElementById("CHGPAPERRTNDATE").value) + "'";
    }
    if (trimStr(document.getElementById("CHGPAPERRTNDATE2").value) != "") {
        whereStr += " and b.CHGPAPERRTNDATE <='" + trimStr(document.getElementById("CHGPAPERRTNDATE2").value) + "'";
    }
    // ��ݷ���������
    if (trimStr(document.getElementById("EXPRESSENDSDATE").value) != "") {
        whereStr += " and b.EXPRESSENDSDATE >='" + trimStr(document.getElementById("EXPRESSENDSDATE").value) + "'";
    }
    if (trimStr(document.getElementById("EXPRESSENDSDATE2").value) != "") {
        whereStr += " and b.EXPRESSENDSDATE <='" + trimStr(document.getElementById("EXPRESSENDSDATE2").value) + "'";
    }
    // ��ݻ�֤������
    if (trimStr(document.getElementById("EXPRESSRTNDATE").value) != "") {
        whereStr += " and b.EXPRESSRTNDATE >='" + trimStr(document.getElementById("EXPRESSRTNDATE").value) + "'";
    }
    if (trimStr(document.getElementById("EXPRESSRTNDATE2").value) != "") {
        whereStr += " and b.EXPRESSRTNDATE <='" + trimStr(document.getElementById("EXPRESSRTNDATE2").value) + "'";
    }

    // �������ǩ������ 2013-04-01 linyong
    if (trimStr(document.getElementById("EXP_DATA_SIGNIN_DATE").value) != "") {
        whereStr += " and b.EXP_DATA_SIGNIN_DATE >='" + trimStr(document.getElementById("EXP_DATA_SIGNIN_DATE").value) + "'";
    }
    if (trimStr(document.getElementById("EXP_DATA_SIGNIN_DATE2").value) != "") {
        whereStr += " and b.EXP_DATA_SIGNIN_DATE <='" + trimStr(document.getElementById("EXP_DATA_SIGNIN_DATE2").value) + "'";
    }
    // ���Ȩ֤ǩ������ 2013-04-01 linyong
    if (trimStr(document.getElementById("EXP_PAPER_SIGNIN_DATE").value) != "") {
        whereStr += " and b.EXP_PAPER_SIGNIN_DATE >='" + trimStr(document.getElementById("EXP_PAPER_SIGNIN_DATE").value) + "'";
    }
    if (trimStr(document.getElementById("EXP_PAPER_SIGNIN_DATE2").value) != "") {
        whereStr += " and b.EXP_PAPER_SIGNIN_DATE <='" + trimStr(document.getElementById("EXP_PAPER_SIGNIN_DATE2").value) + "'";
    }

    // ���п�����δ����Ѻ������

    if (trimStr(document.getElementById("RPTNOMORTDATE").value) != "") {
        whereStr += " and b.RPTNOMORTDATE >='" + trimStr(document.getElementById("RPTNOMORTDATE").value) + "'";
    }
    if (trimStr(document.getElementById("RPTNOMORTDATE2").value) != "") {
        whereStr += " and b.RPTNOMORTDATE <='" + trimStr(document.getElementById("RPTNOMORTDATE2").value) + "'";
    }
    // ���п������ɱ���Ѻ������
    if (trimStr(document.getElementById("RPTMORTDATE").value) != "") {
        whereStr += " and b.RPTMORTDATE >='" + trimStr(document.getElementById("RPTMORTDATE").value) + "'";
    }
    if (trimStr(document.getElementById("RPTMORTDATE2").value) != "") {
        whereStr += " and b.RPTMORTDATE <='" + trimStr(document.getElementById("RPTMORTDATE2").value) + "'";
    }
    if (trimStr(document.getElementById("BOXID").value) != "") {
        whereStr += " and b.BOXID ='" + trimStr(document.getElementById("BOXID").value) + "'";
    }

    //��Ѻ����״̬ mortstatus
    if (trimStr(document.getElementById("MORTSTATUS1").value) != "") {
        whereStr += " and b.MORTSTATUS >='" + trimStr(document.getElementById("MORTSTATUS1").value) + "'";
    }
    if (trimStr(document.getElementById("MORTSTATUS2").value) != "") {
        whereStr += " and b.MORTSTATUS <='" + trimStr(document.getElementById("MORTSTATUS2").value) + "'";
    }
    // ��������ԭ��
    if (trimStr(document.getElementById("CLRREASONCD").value) != "") {
        whereStr += " and b.CLRREASONCD ='" + trimStr(document.getElementById("CLRREASONCD").value) + "'";
    }
    // ���������Ƿ������ zhanrui 20121105  ע����ֶδ���nullֵ�����
    if (trimStr(document.getElementById("SPECIALBIZOVERFLAG").value) == "1") {
        whereStr += " and b.SPECIALBIZOVERFLAG ='" + trimStr(document.getElementById("SPECIALBIZOVERFLAG").value) + "'";
    }

    // ��������
    if (trimStr(document.getElementById("MORTECENTERCD").value) != "") {
        whereStr += " and b.MORTECENTERCD ='" + trimStr(document.getElementById("MORTECENTERCD").value) + "'";
    }


    whereStr += " order by b.mortecentercd,a.bankid,a.cust_name   ";

    document.all["loanTab"].whereStr = whereStr;
    document.all["loanTab"].RecordCount = "0";
    document.all["loanTab"].AbsolutePage = "1";
    // Table_Refresh in dbgrid.js pack
    Table_Refresh("loanTab", false, body_resize);
}

/**
 * report
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