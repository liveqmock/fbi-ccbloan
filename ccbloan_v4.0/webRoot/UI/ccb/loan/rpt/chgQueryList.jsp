<%@ page import="jxl.write.DateTime" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!--
/*********************************************************************
* ��������: ͳ�ƣ���֤ԭ��Ϊ��Ԥ��ת�ֵ֡��ҽ�֤�������ڱ�ͳ�Ƶ�����90�죨������δ��֤�黹����ϸ��
* �� ��: zhanrui
* ��������: 2012/06/10
* �� �� ��:
* �޸�����:
* �� Ȩ: ��˾
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
    <script language="javascript" src="chgQueryList.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript">
        <%
            OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
            String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

        %>
        var deptid ='<%=deptId%>';
    </script>
</head>
    <%
        //OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
        //String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

        int daynum = 90;
        String currdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
        Calendar calendar = new GregorianCalendar();
        calendar.add(Calendar.DAY_OF_MONTH, - daynum);

        String chgdate =new SimpleDateFormat("yyyy-MM-dd").format(calendar.getTime());
        System.out.println(chgdate);

        DBGrid dbGrid = new DBGrid();
        dbGrid.setGridID("loanTab");
        dbGrid.setGridType("edit");

        // ֻͳ���Ѿ�������Ѻ�Ǽǵļ�¼
        String sql = ""
                // ������Ϣ
                + "select "
                //+ "(select deptname from ptdept where deptid=a.bankid) as bankname,"
                + " d.deptname as bankname,"
                + "a.cust_name,"
                + "(select code_desc from ln_odsb_code_desc where code_type_id='053' and code_id=a.LN_TYP) as ln_typ_name,"
                + "a.RT_ORIG_LOAN_AMT,a.RT_TERM_INCR,a.RATECALEVALUE,"
                + "(select enuitemlabel from ptenudetail where enutype='RELEASECONDCD' and enuitemvalue=b.RELEASECONDCD)as RELEASECONDCD,"
                + " a.CUST_OPEN_DT,a.EXPIRING_DT,"
                + "(select code_desc from ln_odsb_code_desc where code_type_id='807' and code_id = a.GUARANTY_TYPE)as GUARANTY_TYPE,"
                //+ "a.RT_TERM_INCR,"
                + "a.PROJ_NO,"
                + "c.proj_name,"
                + "c.PROJ_NAME_ABBR,"
                + "c.CORPNAME,"
                + "(select opername from ptoper where operid=a.custmgr_id) as custmgr_name, "
                //��Ѻ��Ϣ

                + "b.MORTDATE,b.MORTID,"
                + "(select enuitemlabel from ptenudetail where enutype='MORTECENTERCD' and enuitemvalue=b.MORTECENTERCD)as MORTECENTERCD,"
                + "(select enuitemlabel from ptenudetail where enutype='MORTREGSTATUS' and enuitemvalue=b.MORTREGSTATUS) as MORTREGSTATUS,"
                + "(select enuitemlabel from ptenudetail where enutype='NOMORTREASONCD' and enuitemvalue=b.NOMORTREASONCD) as NOMORTREASONCD,"
                + "(select enuitemlabel from ptenudetail where enutype='KEEPCONT' and enuitemvalue=b.KEEPCONT)as keepcont,"
                + "b.EXPRESSNO,b.EXPRESSENDSDATE,b.EXPRESSRTNDATE,"
                + " b.EXPRESSNOTE,"
    //            +"(select enuitemlabel from ptenudetail where enutype='RELAYFLAG' and enuitemvalue=b.RELAYFLAG) as RELAYFLAG,"
                + "(select enuitemlabel from ptenudetail where enutype='SENDFLAG' and enuitemvalue=b.SENDFLAG) as SENDFLAG,"
                + "b.MORTEXPIREDATE,b.MORTOVERRTNDATE,"
                + "b.PAPERRTNDATE,b.CHGPAPERDATE,b.CHGPAPERRTNDATE,b.CLRPAPERDATE,"
                + "(select enuitemlabel from ptenudetail where enutype='CHGPAPERREASONCD' and enuitemvalue=b.CHGPAPERREASONCD) as CHGPAPERREASONCD, "
                + "(select enuitemlabel from ptenudetail where enutype='CLRREASONCD' and enuitemvalue=b.CLRREASONCD) as CLRREASONCD, "
                + " b.CLRREASONREMARK,"
                + " b.DOCUMENTID,"
                + "(select enuitemlabel from ptenudetail where enutype='MORTSTATUS' and enuitemvalue=b.MORTSTATUS) as MORTSTATUS "
                + " from ln_loanapply a inner join ln_mortinfo b on a.loanid=b.loanid   "
                + " left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO "
                + " left join ptdept d on a.bankid=d.deptid "
                + " where  1=1 ";

        dbGrid.setfieldSQL(sql);
        // ������Ϣ
        dbGrid.setField("�������", "text", "8", "bankname", "true", "0");
        dbGrid.setField("���������", "text", "8", "cust_name", "true", "0");
        dbGrid.setField("��������", "text", "8", "ln_typ_name", "true", "0");
        dbGrid.setField("������", "money", "8", "RT_ORIG_LOAN_AMT", "true", "0");
        dbGrid.setField("��������", "text", "8", "RT_TERM_INCR", "true", "0");
        dbGrid.setField("���ʸ�������", "text", "8", "RATECALEVALUE", "true", "0");
        dbGrid.setField("�ſʽ", "text", "8", "RELEASECONDCD", "true", "0");
        dbGrid.setField("��������", "text", "8", "CUST_OPEN_DT", "true", "0");
        dbGrid.setField("��������", "text", "8", "EXPIRING_DT", "true", "0");
        dbGrid.setField("������ʽ", "text", "8", "GUARANTY_TYPE", "true", "0");
        //dbGrid.setField("�������ֵ", "text", "8", "RT_TERM_INCR", "true", "0");
        dbGrid.setField("������Ŀ���", "text", "10", "PROJ_NO", "true", "0");
        dbGrid.setField("������Ŀ����", "text", "12", "proj_name", "true", "0");
        dbGrid.setField("������Ŀ���", "text", "8", "PROJ_NAME_ABBR", "true", "0");
        dbGrid.setField("����������", "text", "12", "CORPNAME", "true", "0");
        dbGrid.setField("�ͻ�����", "text", "6", "custmgr_name", "true", "0");
        //��Ѻ��Ϣ

        dbGrid.setField("��Ѻ��������", "text", "8", "MORTDATE", "true", "0");
        dbGrid.setField("��Ѻ���", "text", "8", "MORTID", "true", "0");
        dbGrid.setField("��Ѻ��������", "text", "8", "MORTECENTERCD", "true", "0");
        dbGrid.setField("��Ѻ�Ǽ�״̬", "text", "8", "MORTREGSTATUS", "true", "0");
        dbGrid.setField("δ�����Ѻԭ�� ", "text", "8", "NOMORTREASONCD", "true", "0");
        dbGrid.setField("��������", "text", "8", "KEEPCONT", "true", "0");
        dbGrid.setField("��ݱ��", "text", "8", "EXPRESSNO", "true", "0");
        dbGrid.setField("��ݷ�������", "text", "8", "EXPRESSENDSDATE", "true", "0");
        dbGrid.setField("��ݻ�֤����", "text", "8", "EXPRESSRTNDATE", "true", "0");
        dbGrid.setField("��ݱ�ע", "text", "8", "EXPRESSNOTE", "true", "0");
    //    dbGrid.setField("���ɱ���Ѻ��־", "text", "8", "RELAYFLAG", "true", "0");
        dbGrid.setField("�ɱ�/���ɱ�", "text", "8", "SENDFLAG", "true", "0");
        dbGrid.setField("��Ѻ������", "text", "8", "MORTEXPIREDATE", "true", "0");
        dbGrid.setField("��Ѻ����������", "text", "8", "MORTOVERRTNDATE", "true", "0");
        dbGrid.setField("�������", "text", "8", "PAPERRTNDATE", "true", "0");
        dbGrid.setField("��֤��������", "text", "8", "CHGPAPERDATE", "true", "0");
        dbGrid.setField("��֤�黹����", "text", "8", "CHGPAPERRTNDATE", "true", "0");
        dbGrid.setField("����ȡ֤����", "text", "8", "CLRPAPERDATE", "true", "0");
        dbGrid.setField("��֤ԭ��", "text", "8", "CHGPAPERREASONCD", "true", "0");
        dbGrid.setField("����ȡ֤ԭ��", "text", "8", "CLRREASONCD", "true", "0");
        dbGrid.setField("����ȡ֤ԭ��ע", "text", "12", "CLRREASONREMARK", "true", "0");
        dbGrid.setField("��Ҫ�������", "text", "8", "DOCUMENTID", "true", "0");
        dbGrid.setField("��Ѻ��ת״̬", "text", "8", "MORTSTATUS", "true", "0");

        //dbGrid.setWhereStr("and floor(to_date('" + currdate + "','yyyy-mm-dd') - to_date(b.chgpaperdate,'yyyy-mm-dd')) >= " + daynum
        //    + "and (b.chgpaperrtndate is  null or b.chgpaperrtndate > '" +  currdate  + "' )"
        //    +" and b.chgpaperreasoncd = '01' and a.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) order by b.mortecentercd,a.bankid,a.cust_name  ");
        dbGrid.setWhereStr("  and floor(to_date('" + currdate + "','yyyy-mm-dd') - to_date(b.chgpaperdate,'yyyy-mm-dd')) >= " + daynum
            + "and (b.chgpaperrtndate is  null or b.chgpaperrtndate > '" +  currdate  + "' )"
            +" and b.chgpaperreasoncd = '01' and a.bankid in(select deptid from ptdept start with deptid='" + deptId + "' connect by prior deptid=parentdeptid) order by b.mortecentercd,a.bankid,a.cust_name  ");

        dbGrid.setpagesize(30);
        dbGrid.setdataPilotID("datapilot");
        dbGrid.setbuttons("����excel=excel,moveFirst,prevPage,nextPage,moveLast");


    %>
<body bgcolor="#ffffff" onLoad="body_resize()" onResize="body_resize();" class="Bodydefault">
<fieldset style="padding-top:-5px;padding-bottom:0px;margin-top:0px">
    <legend>��ѯ����</legend>
    <table border="0" cellspacing="0" cellpadding="0" width="100%">
        <form id="queryForm" name="queryForm">
            <tr>
                <td width="30%" nowrap="nowrap" class="lbl_right_padding">��������</td>
                <td width="70%" nowrap="nowrap" class="data_input"><input type="text" id="REPORTDATE"
                                                                          value="<%=currdate%>"
                                                                          name="REPORTDATE" onClick="WdatePicker()"
                                                                          fieldType="date" style="width:30%"></td>
                <td nowrap="nowrap" align="right"><input class="buttonGrooveDisable" name="cbRetrieve"
                                                         type="button" id="button"
                                                         onClick="cbRetrieve_Click(document.queryForm)"
                                                         onMouseOver="button_onmouseover()"
                                                         onMouseOut="button_onmouseout()" value="����">
                </td>
            </tr>
            <tr>
                <td width="30%" nowrap="nowrap" class="lbl_right_padding">��֤�������ڱȱ���������</td>
                <td width="70%" nowrap="nowrap" class="data_input">
                    <input type="text" id="DAYNUM" name="DAYNUM" value="<%=daynum%>" style="width:30%">
                    <span>�죨����</span>
                </td>
                <td nowrap="nowrap" align="right">
                    <input class="buttonGrooveDisable" name="Input" type="reset" value="����"
                           onMouseOver="button_onmouseover()" onMouseOut="button_onmouseout()">
                </td>
            </tr>
        </form>
    </table>
</fieldset>
<fieldset>
    <legend> ��ϸ��Ϣ</legend>
    <table width="100%">
        <tr>
            <td><%=dbGrid.getDBGrid()%>
            </td>
        </tr>
    </table>
</fieldset>
<FIELDSET>
    <LEGEND> ����</LEGEND>
    <table width="100%" class="title1">
        <tr>
            <td align="right"><%=dbGrid.getDataPilot()%>
            </td>
        </tr>
    </table>
</FIELDSET>
</body>
</html>
