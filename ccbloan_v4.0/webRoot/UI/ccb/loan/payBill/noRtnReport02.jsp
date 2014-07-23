<!--
/*********************************************************************
* ��������: ǩԼ�ſ��δ��֤���˱�һ
* �� ��:
* ��������:
* �� �� ��:
* �޸�����:
* �� Ȩ:
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
<%@ page import="java.io.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    Log logger = LogFactory.getLog("noRtnReport01.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
//����do while�ṹ�������������м����������˳�������
    try {
        do {
            // �������
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            response.addHeader("Content-Disposition", "attachment; filename=" + CcbLoanConst.NORTN_RPT_MODEL_02 + ".xls");
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath + CcbLoanConst.NORTN_RPT_MODEL_02 + ".xls";
            File file = new File(rptName);
            // �ж�ģ���Ƿ����,���������˳�
            if (!file.exists()) {
                out.println(rptName + PropertyManager.getProperty("304"));
                break;
            }

            Map beans = new HashMap();

            String startdate = request.getParameter("ACCTOPENDATE1");
            String enddate = request.getParameter("ACCTOPENDATE2");
            String basedate_kaohe = request.getParameter("basedate_kaohe");
            beans.put("basedate_kaohe", basedate_kaohe);

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
                beans.put("condidate", " ��������:" + startdate + "��" + enddate);
            } else {
                beans.put("condidate", " ");
            }

            Date date = new Date();
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            String reportdate = df.format(date);
            //reportdate = reportdate.substring(0,4)+"��"+reportdate.substring(4,6)+"��"+reportdate.substring(6,8)+"��";
            beans.put("reportdate", "��������:" + reportdate);

            //����ͳ�Ʊ�����

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
        logger.error("����ǩԼ�ſ��֤���˱��ʱ���ִ���");
        e.printStackTrace();
    } finally {
        //todo: ����
        ConnectionManager.getInstance().release();
    }
%>
