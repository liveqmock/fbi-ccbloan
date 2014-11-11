<!--
/*********************************************************************
* ��������:
* �� ��: zhanrui
* ��������: 2012-04-07
* �� �� ��:
* �޸�����:
* �� Ȩ:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="net.sf.jxls.report.ReportManager" %>
<%@page import="net.sf.jxls.report.ReportManagerImpl" %>
<%@page import="net.sf.jxls.transformer.XLSTransformer" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@page import="pub.platform.advance.utils.PropertyManager" %>
<%@page import="pub.platform.db.ConnectionManager" %>
<%@page import="pub.platform.db.DatabaseConnection" %>
<%@page import="pub.platform.form.config.SystemAttributeNames" %>
<%@page import="pub.platform.security.OperatorManager" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%
    Log logger = LogFactory.getLog("flowInfoReport.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
//����do while�ṹ�������������м����������˳�������
    try {
        do {
            // �������
            String startdate = request.getParameter("MORTEXPIREDATE");

            response.reset();
            response.setContentType("application/vnd.ms-excel");
            String exportName = new String("����ǩԼ�ſ��Ѻ��.xls".getBytes(), "ISO8859-1");
            response.addHeader("Content-Disposition", "attachment; filename=" + exportName);
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptTemplateName = rptModelPath + "signLoanMortOrg.xls";
            File file = new File(rptTemplateName);
            // �ж�ģ���Ƿ����,���������˳�
            if (!file.exists()) {
                out.println(rptTemplateName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String reportdate = df.format(date);
            //reportdate = reportdate.substring(0,4)+"��"+reportdate.substring(4,6)+"��"+reportdate.substring(6,8)+"��";
            beans.put("currdate", reportdate);
            beans.put("reportdate", "��������:" + reportdate); //����TITLEʹ��

            DatabaseConnection conn = ConnectionManager.getInstance().get();
            ReportManager reportManager = new ReportManagerImpl(conn.getConnection(), beans);

            String sql="select sum(orgallcount) orgallcount , sum(orgcount) orgcount,parentdeptid,bankname,bankid from (\n" +
                    "select aa.orgallcount,aa.orgcount,aa.parentdeptid,deptname as bankname ,deptid as bankid  from (  \n" +
                    " select q.parentdeptid,sum(p.orgAllCount) orgallcount,sum(p.orgCount) orgcount from \n" +
                    "(select f.bankid,f.bankname,nvl(f.orgAllCount,0) orgAllCount,nvl(g.orgCount,0) orgCount from  \n" +
                    "(select distinct a.deptid as bankid from ptdept a ) e, \n" +
                    "(select  a.bankid,d.deptname as bankname,count(*) orgAllCount \n" +
                    "from ln_loanapply a  \n" +
                    "inner join ln_mortinfo b on a.loanid=b.loanid \n" +
                    "left join ptdept d on a.bankid=d.deptid   \n" +
                    "where 1=1  and b.mortdate>='2014-08-01' and b.releasecondcd='03' \n" +
                    "group by a.bankid,d.deptname \n" +
                    "order by a.bankid,d.deptname ) f ,  \n" +
                    "(select a.bankid,d.deptname as bankname,count(*) orgCount \n" +
                    "from ln_loanapply a  \n" +
                    "inner join ln_mortinfo b on a.loanid=b.loanid     \n" +
                    "left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO   \n" +
                    "left join ptdept d on a.bankid=d.deptid\n" +
                    "where 1=1  and b.mortdate>='2014-08-01' and b.releasecondcd='03' \n" +
                    "and b.mortregstatus in ('2','3') \n" +
                    "group by a.bankid,d.deptname \n" +
                    "order by a.bankid,d.deptname) g \n" +
                    "where e.bankid = f.bankid(+) \n" +
                    "and e.bankid = g.bankid(+) \n" +
                    "and (f.orgAllCount is not null or  \n" +
                    "g.orgCount is not null)) p,\n" +
                    "(select distinct a.deptid,a.parentdeptid,a.deptname from ptdept a ) q\n" +
                    "where p.bankid(+)=q.deptid \n" +
                    "and q.parentdeptid not in('371981610','371981620')\n" +
                    "group by q.parentdeptid\n" +
                    "Union\n" +
                    "select * from\n" +
                    "(select f.bankid,f.orgAllCount,g.orgCount from  \n" +
                    "(select distinct a.deptid as bankid from ptdept a ) e, \n" +
                    "(select  a.bankid,d.deptname as bankname,count(*) orgAllCount \n" +
                    "from ln_loanapply a  \n" +
                    "inner join ln_mortinfo b on a.loanid=b.loanid \n" +
                    "left join ptdept d on a.bankid=d.deptid   \n" +
                    "where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' \n" +
                    "group by a.bankid,d.deptname \n" +
                    "order by a.bankid,d.deptname ) f ,  \n" +
                    "(select a.bankid,d.deptname as bankname,count(*) orgCount \n" +
                    "from ln_loanapply a  \n" +
                    "inner join ln_mortinfo b on a.loanid=b.loanid     \n" +
                    "left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO   \n" +
                    "left join ptdept d on a.bankid=d.deptid   \n" +
                    "where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' \n" +
                    "and b.mortregstatus in ('2','3') \n" +
                    "group by a.bankid,d.deptname \n" +
                    "order by a.bankid,d.deptname)g \n" +
                    "where e.bankid = f.bankid(+) \n" +
                    "and e.bankid = g.bankid(+) \n" +
                    "and (f.orgAllCount is not null or  \n" +
                    "g.orgCount is not null) ) h\n" +
                    "where 1=1 and h.bankid not in(select distinct parentdeptid from ptdept where parentdeptid in('371981610','371980000','0','371981620'))\n" +
                    "and h.bankid in (select distinct deptid from ptdept where parentdeptid in('371981610','371981620'))\n" +
                    ") aa left join ptdept t on t.deptid=aa.parentdeptid ) where  orgCount<>0 or orgallcount<>0 group by parentdeptid,bankname,bankid\n" +
                    "\n" +
                    "  \n";


            /*
            String sql=" select aa.orgallcount,aa.orgcount,aa.parentdeptid,deptname as bankname,deptid as bankid from (" +
                    " select q.parentdeptid,sum(p.orgAllCount) orgallcount,sum(p.orgCount) orgcount from " +
                    "(select f.bankid,f.bankname,f.orgAllCount,g.orgCount from  " +
                    "(select distinct a.deptid as bankid from ptdept a ) e, " +
                    "(select  a.bankid,d.deptname as bankname,count(*) orgAllCount " +
                    "from ln_loanapply a  " +
                    "inner join ln_mortinfo b on a.loanid=b.loanid  " +
                    "left join ptdept d on a.bankid=d.deptid   " +
                    "where 1=1  and b.mortdate>='2014-08-01' and b.releasecondcd='03' " +
                    "group by a.bankid,d.deptname " +
                    "order by a.bankid,d.deptname ) f ,  " +
                    "(select a.bankid,d.deptname as bankname,count(*) orgCount " +
                    "from ln_loanapply a  " +
                    "inner join ln_mortinfo b on a.loanid=b.loanid     " +
                    "left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO   " +
                    "left join ptdept d on a.bankid=d.deptid " +
                    "where 1=1  and b.mortdate>='2014-08-01' and b.releasecondcd='03'" +
                    "and b.mortregstatus in ('2','3')  " +
                    "group by a.bankid,d.deptname " +
                    "order by a.bankid,d.deptname) g " +
                    "where e.bankid = f.bankid(+) " +
                    "and e.bankid = g.bankid(+) " +
                    "and (f.orgAllCount is not null or  " +
                    "g.orgCount is not null)) p," +
                    "(select distinct a.deptid,a.parentdeptid,a.deptname from ptdept a ) q " +
                    "where p.bankid(+)=q.deptid " +
                    "and q.parentdeptid not in('371981610','371980000','0','371981620') " +
                    "group by q.parentdeptid " +
                    "Union " +
                    "select * from " +
                    "(select f.bankid,f.orgAllCount,g.orgCount from  " +
                    "(select distinct a.deptid as bankid from ptdept a ) e, " +
                    "(select  a.bankid,d.deptname as bankname,count(*) orgAllCount " +
                    "from ln_loanapply a  " +
                    "inner join ln_mortinfo b on a.loanid=b.loanid " +
                    "left join ptdept d on a.bankid=d.deptid   " +
                    "where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' " +
                    "group by a.bankid,d.deptname " +
                    "order by a.bankid,d.deptname ) f , " +
                    "(select a.bankid,d.deptname as bankname,count(*) orgCount " +
                    "from ln_loanapply a  " +
                    "inner join ln_mortinfo b on a.loanid=b.loanid     " +
                    "left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO   " +
                    "left join ptdept d on a.bankid=d.deptid   " +
                    "where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' " +
                    "and b.mortregstatus in ('2','3') " +
                    "group by a.bankid,d.deptname " +
                    "order by a.bankid,d.deptname) g " +
                    "where e.bankid = f.bankid(+) " +
                    "and e.bankid = g.bankid(+) " +
                    "and (f.orgAllCount is not null or  " +
                    "g.orgCount is not null) ) h " +
                    "where h.bankid not in(select distinct parentdeptid from ptdept where parentdeptid not in('371981610','371980000','0','371981620'))\n" +
                    "and h.bankid in (select distinct deptid from ptdept where parentdeptid in('371981610','371981620'))\n" +
                    ") aa right join ptdept t on t.deptid=aa.parentdeptid" ;
            */
            /*
            String sql ="select f.bankid,f.bankname,f.orgAllCount,g.orgCount from " +
                    "  (select distinct a.deptid as bankid from ptdept a ) e," +
                    "  (select  a.bankid,d.deptname as bankname,count(*) orgAllCount" +
                    "  from ln_loanapply a " +
                    "  inner join ln_mortinfo b on a.loanid=b.loanid" +
                    "  left join ptdept d on a.bankid=d.deptid  " +
                    "  where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03'" +
                    "  group by a.bankid,d.deptname" +
                    "  order by a.bankid,d.deptname ) f , " +
                    "  (select a.bankid,d.deptname as bankname,count(*) orgCount" +
                    "  from ln_loanapply a " +
                    "  inner join ln_mortinfo b on a.loanid=b.loanid    " +
                    "  left join ln_coopproj c on a.PROJ_NO=c.PROJ_NO  " +
                    "  left join ptdept d on a.bankid=d.deptid  " +
                    "  where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03'" +
                    "  and b.mortregstatus in ('2','3')" +
                    "  group by a.bankid,d.deptname" +
                    "  order by a.bankid,d.deptname)g" +
                    "  where e.bankid = f.bankid(+)" +
                    "  and e.bankid = g.bankid(+)" +
                    "  and (f.orgAllCount is not null or " +
                    "  g.orgCount is not null)";
            */
            List reportList = new ArrayList();
            reportList = reportManager.exec(sql);
            beans.put("records",reportList);


            XLSTransformer transformer = new XLSTransformer();
            InputStream is = new BufferedInputStream(new FileInputStream(rptTemplateName));
            HSSFWorkbook workbook = transformer.transformXLS(is, beans);
            OutputStream os = response.getOutputStream();
            workbook.write(os);
            is.close();
            out.flush();
            out.close();

        } while (false);
    } catch (Exception e) {
        logger.error("���ɱ���ʱ���ִ���", e);
        out.write("ϵͳ������ִ���" + e.getMessage());
    } finally {
        //TODO: ����
        ConnectionManager.getInstance().release();
    }
%>
