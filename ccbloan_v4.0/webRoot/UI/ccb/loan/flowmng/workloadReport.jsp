<!--
/*********************************************************************
* 功能描述: 流程工作量统计  按日
* 作 者: zr
* 开发日期:20150112
* 修 改 人:
* 修改日期:
* 版 权:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
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
<%@ page import="pub.platform.utils.BusinessDate" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.*" %>
<%@ page import="org.joda.time.DateTime" %>
<%
    Log logger = LogFactory.getLog("miscReport04.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
//采用do while结构便于在主流程中监测错误发生后退出主程序；
    try {
        do {
            String startdate = request.getParameter("MORTEXPIREDATE");
            String reportdate = request.getParameter("MORTEXPIREDATE2");

            // 输出报表
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            response.addHeader("Content-Disposition", "attachment; filename=workloadRpt-" +reportdate + ".xls");
            // ----------------------------根据模板创建输出流----------------------------------------------------------------
            //得到报表模板
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath  + "workloadRpt.xls";
            File file = new File(rptName);
            // 判断模板是否存在,不存在则退出
            if (!file.exists()) {
                out.println(rptName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();

            DateTime dateTime = new DateTime(reportdate);
            String lastday = dateTime.minusDays(1).toString("yyyy-MM-dd");
            String nextday = dateTime.plusDays(1).toString("yyyy-MM-dd");

            beans.put("startdate", startdate);
            beans.put("lastday", lastday);
            beans.put("nextday", nextday);
            beans.put("condidate", " ");

            beans.put("reportdate", reportdate); //报表TITLE使用

            //生成统计表数据
            DatabaseConnection conn = ConnectionManager.getInstance().get();

            ReportManager reportManager = new ReportManagerImpl(conn.getConnection(), beans);
            beans.put("rm", reportManager);
            beans.put("deptid", omgr.getOperator().getDeptid());


            XLSTransformer transformer = new XLSTransformer();
            InputStream is = new BufferedInputStream(new FileInputStream(rptName));
            HSSFWorkbook workbook = transformer.transformXLS(is, beans);
            OutputStream os = response.getOutputStream();
            workbook.write(os);
            is.close();
            out.flush();
            out.close();
        } while (false);
    } catch (Exception e) {
        logger.error("个贷流程工作量统计表处理错误。", e);
    } finally {
        ConnectionManager.getInstance().release();
    }
%>
