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
