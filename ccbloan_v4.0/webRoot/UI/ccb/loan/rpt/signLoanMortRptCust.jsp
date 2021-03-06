<!--
/*********************************************************************
* 功能描述:
* 作 者: zhanrui
* 开发日期: 2012-04-07
* 修 改 人:
* 修改日期:
* 版 权:
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
//采用do while结构便于在主流程中监测错误发生后退出主程序；
    try {
        do {
            // 输出报表
            String startdate = request.getParameter("MORTEXPIREDATE");

            response.reset();
            response.setContentType("application/vnd.ms-excel");
            String exportName = new String("机构签约放款抵押率.xls".getBytes(), "ISO8859-1");
            response.addHeader("Content-Disposition", "attachment; filename=" + exportName);
            // ----------------------------根据模板创建输出流----------------------------------------------------------------
            //得到报表模板
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptTemplateName = rptModelPath + "signLoanMortCust.xls";
            File file = new File(rptTemplateName);
            // 判断模板是否存在,不存在则退出
            if (!file.exists()) {
                out.println(rptTemplateName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String reportdate = df.format(date);
            //reportdate = reportdate.substring(0,4)+"年"+reportdate.substring(4,6)+"月"+reportdate.substring(6,8)+"日";
            beans.put("currdate", reportdate);
            beans.put("reportdate", "出表日期:" + reportdate); //报表TITLE使用

            DatabaseConnection conn = ConnectionManager.getInstance().get();
            ReportManager reportManager = new ReportManagerImpl(conn.getConnection(), beans);

            String sql ="select h.bankid,i.bankname,custmgr_name,orgallcount,orgcount from  " +
                    "  (select e.bankid,f.custmgr_name,f.orgAllCount,g.orgCount from  " +
                    "  (select a.deptid as bankid,a.prommgr_id from ln_prommgrinfo a ) e, " +
                    "  (select a.custmgr_id, (select prommgr_name from ln_prommgrinfo where prommgr_id=a.custmgr_id) as custmgr_name,count(*) orgAllCount " +
                    "  from ln_loanapply a  " +
                    "  inner join ln_mortinfo b on a.loanid=b.loanid     " +
                    "  left join ptdept d on a.bankid=d.deptid   " +
                    "  where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' " +
                    "  group by a.custmgr_id, a.custmgr_id) f,  " +
                    "  (select a.custmgr_id, (select prommgr_name from ln_prommgrinfo where prommgr_id=a.custmgr_id) as custmgr_name, count(*) orgCount " +
                    "  from ln_loanapply a  " +
                    "  inner join ln_mortinfo b on a.loanid=b.loanid     " +
                    "  left join ptdept d on a.bankid=d.deptid   " +
                    "  where 1=1  and b.mortdate>='"+startdate+"' and b.releasecondcd='03' " +
                    "  and b.mortregstatus in ('2','3') " +
                    "  group by a.custmgr_id, a.custmgr_id) g " +
                    "  where e.prommgr_id=f.custmgr_id(+) " +
                    "  and e.prommgr_id = g.custmgr_id(+) " +
                    "  and (f.orgAllCount is not null or  " +
                    "    g.orgCount is not null)) h, " +
                    "  (select a.deptid as bankid,a.deptname as bankname from ptdept a) i " +
                    "  where h.bankid = i.bankid(+) " +
                    "  order by i.bankid ";

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
        logger.error("生成报表时出现错误。", e);
        out.write("系统处理出现错误：" + e.getMessage());
    } finally {
        //TODO: 链接
        ConnectionManager.getInstance().release();
    }
%>
