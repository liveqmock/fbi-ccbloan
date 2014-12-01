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
<%@ page import="pub.platform.db.RecordSet" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Log logger = LogFactory.getLog("acctInfoReport.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
//采用do while结构便于在主流程中监测错误发生后退出主程序；
    try {
        do {
            // 输出报表
            String acctid = request.getParameter("acctid");

            response.reset();
            response.setContentType("application/vnd.ms-excel");
            String exportName = new String("汇总明细单.xls".getBytes(), "ISO8859-1");
            response.addHeader("Content-Disposition", "attachment; filename=" + exportName);
            // ----------------------------根据模板创建输出流----------------------------------------------------------------
            //得到报表模板
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptTemplateName = rptModelPath + "acctInfoReport.xls";
            File file = new File(rptTemplateName);
            // 判断模板是否存在,不存在则退出
            if (!file.exists()) {
                out.println(rptTemplateName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();
            String strWhere = "";
            if (acctid != null && !acctid.equals("")) {
                strWhere = " and a.acct_id in ("+acctid+")";
            }

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String reportdate = df.format(date);
            //reportdate = reportdate.substring(0,4)+"年"+reportdate.substring(4,6)+"月"+reportdate.substring(6,8)+"日";
            beans.put("currdate", reportdate);
            beans.put("reportdate", "出表日期:" + reportdate); //报表TITLE使用
            DatabaseConnection conn = ConnectionManager.getInstance().get();
            ReportManager reportManager = new ReportManagerImpl(conn.getConnection(), beans);

            String sql ="select rownum,aa.* from (select a.acct_id, ( select deptname from ptdept where deptid=b.bankid )as deptname, " +
                    "             a.loanid, b.cust_name,  " +
                    "             ( select code_desc as text  from ln_odsb_code_desc where code_type_id='053' and code_id = b.ln_typ ) ln_typ,  " +
                    "             b.rt_orig_loan_amt,( select proj_name from ln_coopproj where proj_no=b.proj_no ) proj_name, " +
                    "             ( select enuitemlabel from PTENUDETAIL where enutype = 'APPTTYPE' and enuitemvalue = a.appt_type) appt_type, " +
                    "             a.acct_name,a.acct_no,a.acct_bank,a.acct_amt,a.pay_date,a.operid,a.recversion  " +
                    "             from ln_acctinfo a  " +
                    "             inner join ln_loanapply b on a.loanid = b.loanid   " +
                    "             where 1 =1 "+  strWhere +
                    "             order by a.print_time )aa ";

            List reportList = new ArrayList();
            reportList = reportManager.exec(sql);
            beans.put("records",reportList);

            String strSql = "select sum(a.acct_amt) amt from ln_acctinfo a " +
                    "             inner join ln_loanapply b on a.loanid = b.loanid   " +
                    "             where 1 =1 "+  strWhere;
            RecordSet rs = conn.executeQuery(strSql);
            while (rs.next()) {
                BigDecimal bigAmt = new BigDecimal(rs.getString("amt"));
                beans.put("totalAmt", bigAmt);
            }

            int updateCnt = 0;
            updateCnt = conn.executeUpdate("update ln_acctinfo a set a.report_flag='1' where a.acct_id in("+acctid+")");
            if(updateCnt<0){
                out.write("生成报表时出现错误。");
            }

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
