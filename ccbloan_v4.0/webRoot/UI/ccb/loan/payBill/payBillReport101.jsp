<!--
/*********************************************************************
* ��������:�򵥹��� ����ͳ�Ʊ�m
* ��������: 2013-04-20
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="net.sf.jxls.report.ReportManager" %>
<%@page import="net.sf.jxls.report.ReportManagerImpl" %>
<%@page import="net.sf.jxls.transformer.XLSTransformer" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFSheet" %>
<%@page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@page import="org.apache.poi.ss.util.CellRangeAddress" %>
<%@page import="pub.platform.advance.utils.PropertyManager" %>
<%@page import="pub.platform.db.ConnectionManager" %>
<%@page import="pub.platform.db.DatabaseConnection" %>
<%@ page import="pub.platform.form.config.SystemAttributeNames" %>
<%@ page import="pub.platform.security.OperatorManager" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    Log logger = LogFactory.getLog("payBillReport101.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    try {
        do {
            // �������
            String startdate = request.getParameter("MORTEXPIREDATE");
            String enddate = request.getParameter("MORTEXPIREDATE2");
            String baseval1 = request.getParameter("baseval1");
            String baseval2 = request.getParameter("baseval2");
            String baseval3 = request.getParameter("baseval3");
            String baseval4 = request.getParameter("baseval4");
//            String baseval5 = request.getParameter("baseval5");
            double value1 = Double.parseDouble(baseval1);
            double value2 = Double.parseDouble(baseval2);
            double value3 = Double.parseDouble(baseval3);
            double value4 = Double.parseDouble(baseval4);
//            double value5 = Double.parseDouble(baseval5);

            response.reset();
            response.setContentType("application/vnd.ms-excel");
            String exportName = new String("�����򵥹�������ͳ�Ʊ�.xls".getBytes(), "ISO8859-1");
            response.addHeader("Content-Disposition", "attachment; filename=" + exportName);
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptTemplateName = rptModelPath + "payBill101.xls";
            File file = new File(rptTemplateName);
            // �ж�ģ���Ƿ����,���������˳�
            if (!file.exists()) {
                out.println(rptTemplateName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();
            int startdateflag = 0;
            if (startdate != null && !startdate.equals("")) {
                beans.put("startdate", startdate);
            } else {
                beans.put("startdate", "1000-01-01");
                startdateflag = 1;  //δ������ʼ����
            }
            int enddateflag = 0;
            if (enddate != null && !enddate.equals("")) {
                beans.put("enddate", enddate);
            } else {
                beans.put("enddate", "9000-01-01");
                enddateflag = 1;   //δ�����ֹ����
            }

            if (startdateflag == 1 && enddateflag == 0) {
                beans.put("condidate", " ������������:" + enddate);
            } else if (startdateflag == 0 && enddateflag == 1) {
                beans.put("condidate", " ��ʼ��������:" + startdate);
            } else if (startdateflag == 0 && enddateflag == 0) {
                beans.put("condidate",  startdate + "��" + enddate);
            } else {
                beans.put("condidate", " ");
            }

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String reportdate = df.format(date);
            //reportdate = reportdate.substring(0,4)+"��"+reportdate.substring(4,6)+"��"+reportdate.substring(6,8)+"��";
            beans.put("currdate", reportdate);
            beans.put("reportdate", "��������:" + reportdate); //����TITLEʹ��

            beans.put("baseval1", value1);
            beans.put("baseval2", value2);
            beans.put("baseval3", value3);
            beans.put("baseval4", value4);
//            beans.put("baseval5", value5);

            DatabaseConnection conn = ConnectionManager.getInstance().get();
            ReportManager reportManager = new ReportManagerImpl(conn.getConnection(), beans);

            beans.put("rm", reportManager);
            beans.put("deptid", omgr.getOperator().getDeptid());
            beans.put("title1", "����ס������");
            beans.put("title2", "�����ٽ��״���");
            beans.put("title3", "����֧ũ����");
            beans.put("title4", "�������������");

            String sql = "        select sum_bankid," +
                    "           sum(case" +
                    "                 when (ln_typ in ('011')) then" +
                    "                  1" +
                    "                 else" +
                    "                  0" +
                    "               end) as cnt1," +
                    "           sum(case" +
                    "                 when (ln_typ in ('011')) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt1," +
                    "           sum(case" +
                    "                 when (ln_typ in ('011')) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate1," +
                    "" +
                    "           sum(case" +
                    "                 when (ln_typ in ('013')) then" +
                    "                  1" +
                    "                 else" +
                    "                  0" +
                    "               end) as cnt2," +
                    "           sum(case" +
                    "                 when (ln_typ in ('013')) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt2," +
                    "           sum(case" +
                    "                 when (ln_typ in ('013')) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate2," +
                    "" +
                    "           sum(case" +
                    "                 when (ln_typ in ('011','013')) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt12," +
                    "           sum(case" +
                    "                 when (ln_typ in ('011','013')) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate12," +
                    "" +
                    "           sum(case" +
                    "                 when (ln_typ in ('033', '433') and ln_prod_cod in ('0183','4183')) then" +
                    "                  1" +
                    "                 else" +
                    "                  0" +
                    "               end) as cnt3," +
                    "           sum(case" +
                    "                 when (ln_typ in ('033', '433') and ln_prod_cod in ('0183','4183')) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt3," +
                    "           sum(case" +
                    "                 when (ln_typ in ('033', '433') and ln_prod_cod in ('0183','4183')) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate3," +
                    "" +
                    "           sum(case" +
                    "                 when (ln_typ not in ('011', '013', '033', '433', '117', '119') or (ln_typ in ('033', '433') and ln_prod_cod not in ('0183','4183'))) then" +
                    "                  1" +
                    "                 else" +
                    "                  0" +
                    "               end) as cnt4," +
                    "           sum(case" +
                    "                 when (ln_typ not in ('011', '013', '033', '433', '117', '119') or (ln_typ in ('033', '433') and ln_prod_cod not in ('0183','4183'))) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt4," +
                    "           sum(case" +
                    "                 when (ln_typ not in ('011', '013', '033', '433', '117', '119') or (ln_typ in ('033', '433') and ln_prod_cod not in ('0183','4183'))) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate4," +
                    "" +
                    "           sum(case" +
                    "                 when (ln_typ not in ('011', '013', '117', '119')) then" +
                    "                  rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as amt34," +
                    "           sum(case" +
                    "                 when (ln_typ not in ('011', '013',  '117', '119')) then" +
                    "                  ratecalevalue * rt_orig_loan_amt" +
                    "                 else" +
                    "                  null" +
                    "               end) as rate34" +
                    "      from loandata";

            beans.put("sql", sql);

            XLSTransformer transformer = new XLSTransformer();
            InputStream is = new BufferedInputStream(new FileInputStream(rptTemplateName));
            HSSFWorkbook workbook = transformer.transformXLS(is, beans);
            OutputStream os = response.getOutputStream();
            workbook.write(os);
            is.close();
            out.flush();
            out.close();

            //�޸�ö��Ĭ��ֵ
            conn.executeUpdate("update ptenudetail t set t.enuitemexpand='" + baseval1 + "' where t.enutype='BIZPARAM' and t.enuitemvalue='PayBillRpt101_1'");
            conn.executeUpdate("update ptenudetail t set t.enuitemexpand='" + baseval2 + "' where t.enutype='BIZPARAM' and t.enuitemvalue='PayBillRpt101_2'");
            conn.executeUpdate("update ptenudetail t set t.enuitemexpand='" + baseval3 + "' where t.enutype='BIZPARAM' and t.enuitemvalue='PayBillRpt101_3'");
            conn.executeUpdate("update ptenudetail t set t.enuitemexpand='" + baseval4 + "' where t.enutype='BIZPARAM' and t.enuitemvalue='PayBillRpt101_4'");
//            conn.executeUpdate("update ptenudetail t set t.enuitemexpand='" + baseval5 + "' where t.enutype='BIZPARAM' and t.enuitemvalue='PayBillRpt101_5'");
        } while (false);
    } catch (Exception e) {
        logger.error("���ɱ���ʱ���ִ���", e);
        out.write("ϵͳ������ִ���" + e.getMessage());
    } finally {
        //TODO: ����
        ConnectionManager.getInstance().release();
    }
%>
