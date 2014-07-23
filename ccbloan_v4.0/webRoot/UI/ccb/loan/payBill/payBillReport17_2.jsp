<!--
/*********************************************************************
* ��������: �򵥹��ʲ�ѯͳ��17 (��8)  
  20120524 zhanrui  ���ͻ������ѯ
* �� ��:
* ��������: 2011/03/06
* �� �� ��:
* �޸�����:
* �� Ȩ:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="jxl.Workbook" %>
<%@page import="jxl.WorkbookSettings" %>
<%@page import="jxl.format.Alignment" %>
<%@page import="jxl.format.Border" %>
<%@page import="jxl.format.BorderLineStyle" %>
<%@page import="jxl.format.VerticalAlignment" %>
<%@page import="jxl.write.*" %>
<%@page import="jxl.write.Number" %>
<%@page import="org.apache.commons.logging.Log" %>
<%@page import="org.apache.commons.logging.LogFactory" %>
<%@page import="pub.platform.advance.utils.PropertyManager" %>
<%@page import="pub.platform.db.ConnectionManager" %>
<%@page import="pub.platform.db.DatabaseConnection" %>
<%@page import="pub.platform.db.RecordSet" %>
<%@page import="pub.platform.form.config.SystemAttributeNames" %>
<%@page import="pub.platform.security.OperatorManager" %>
<%@page import="java.io.File" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Locale" %>
<%
    Log logger = LogFactory.getLog("payBillReport17.jsp");

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    final String RPTLABEL01 = "����ס������(��������ס����������ٽ���ס������)";
    final String RPTLABEL02 = "������ҵ����";
    final String RPTLABEL03 = "����������������������÷���������߶�������Ѷ�ȡ�����������������Ѻ����ȣ�";

    //�����������
    String startdate = request.getParameter("CUST_OPEN_DT").trim();
    String enddate = request.getParameter("CUST_OPEN_DT2").trim();

    //����Ȩֵ
    BigDecimal weight = new BigDecimal(5);
    //ÿ��Ԫ�򵥼۸��׼
    BigDecimal baseprice1 =  new BigDecimal(0);
    BigDecimal baseprice2 = new BigDecimal(0);
    BigDecimal baseprice3 = new BigDecimal(0);

    try {
        do {
            // �������
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            response.addHeader("Content-Disposition", "attachment; filename=" + "payBill17_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls");
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath + "payBill17.xls";
            File file = new File(rptName);
            // �ж�ģ���Ƿ����,���������˳�
            if (!file.exists()) {
                out.println(rptName + PropertyManager.getProperty("304"));
                break;
            }
            WorkbookSettings setting = new WorkbookSettings();
            Locale locale = new Locale("zh", "CN");
            setting.setLocale(locale);
            setting.setEncoding("ISO-8859-1");
            // �õ�excel��sheet
            File fileInput = new File(rptName);
            Workbook rw = Workbook.getWorkbook(fileInput, setting);
            // �õ���д��workbook
            WritableWorkbook wwb = Workbook.createWorkbook(response.getOutputStream(), rw, setting);
            // �õ���һ��������
            WritableSheet ws = wwb.getSheet(0);

            // ----------------�����ݿ��ȡ����д��excel��--------------------------------------------------------------------------------
            // ��ѯ�ַ���
            String whereStr = " where 1=1 and t.loanid = a.loanid  and t.LOANSTATE is not null and t.LOANSTATE <> '0' and a.custmgr_id is not null  ";
            if (!request.getParameter("CUST_OPEN_DT").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT >='" + request.getParameter("CUST_OPEN_DT").trim() + "'";
            }
            if (!request.getParameter("CUST_OPEN_DT2").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT <='" + request.getParameter("CUST_OPEN_DT2").trim() + "'";
            }

            String loantype1 = "t.ln_typ  in ('011','013')";
            String loantype2 = "t.ln_typ  in ('033','433')";
            String loantype3 = "t.ln_typ  in ('012','014','015','016','020','022','026','028','029','030','031','113','114','115','122')";

            //����ƽ��ֵ
            BigDecimal allOrgTotalAmt1 = new BigDecimal("0.00");
            BigDecimal allOrgTotalAmt2 = new BigDecimal("0.00");
            BigDecimal allOrgTotalAmt3 = new BigDecimal("0.00");
            BigDecimal averageRate1 = new BigDecimal("0.00");
            BigDecimal averageRate2 = new BigDecimal("0.00");
            BigDecimal averageRate3 = new BigDecimal("0.00");

            DatabaseConnection conn = ConnectionManager.getInstance().get();

            RecordSet rs = conn.executeQuery("select deptname from ptdept where deptid='" + deptId + "'");
            String deptName = "�ϼ�";
            while (rs.next()) {
                deptName = rs.getString(0);
            }
            rs.close();

            rs = conn.executeQuery("select enuitemexpand as name,to_number(enuitemvalue) as value from ptenudetail where enutype = 'PAYBILLRPTPARAM' ");
            while (rs.next()) {
                String name = rs.getString("name");
                BigDecimal value = BigDecimal.valueOf(rs.getDouble("value"));
                if ("weight".equals(name)) {
                    weight = value;
                }else if ("baseprice1".equals(name)) {
                    baseprice1 = value;
                }else if ("baseprice2".equals(name)) {
                    baseprice2 = value;
                }else if ("baseprice3".equals(name)) {
                    baseprice3 = value;
                }
            }
            rs.close();

            // ͳ�Ʋ�ѯ���
            String sql = ""
                    + " select bankid,bankname,custmgr_name,amt1,amt2,amt3,round(rate1/amt1,2) as rate1,round(rate2/amt2,2) as rate2,round(rate3/amt3,2) as rate3 , " +
                    " rate1 as totalrate1, rate2 as totalrate2, rate3 as totalrate3 from ("
                    + " select t.bankid,"
                    + " (select deptname from ptdept where deptid=t.bankid)as bankname,"
                    + " (select opername from ptoper where operid = a.custmgr_id) as custmgr_name,"
                    //+ " (case when (select prommgr_name from ln_prommgrinfo where prommgr_id = t.custmgr_id) is null then" +
                    //"               (select opername from ptoper where operid=t.custmgr_id) else" +
                    //"                (select prommgr_name from ln_prommgrinfo where prommgr_id = t.custmgr_id) end) as custmgr_name,"
                    + " sum(case"
                    + "       when (" + loantype1 + ") then"
                    + "        t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt1,"
                    + " sum(case"
                    + "       when (" + loantype1 + " ) then"
                    + "        RATECALEVALUE*t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate1,"
                    + " sum(case"
                    + "       when (" + loantype2 + ") then"
                    + "        t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt2,"
                    + " sum(case"
                    + "       when (" + loantype2 + " ) then"
                    + "        RATECALEVALUE*t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate2,"
                    + " sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt3,"
                    + "  sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        RATECALEVALUE*t.rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate3  "
                    + " from ln_loanapply t, ln_promotioncustomers a"
                    + whereStr
                    + " and t.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) "
                    + " group by t.bankid,a.custmgr_id"
                    + " order by t.bankid,a.custmgr_id"
                    + " ) ";

            String sumsql = "select sum(amt1) as amt1 ,sum(amt2) as amt2, sum(amt3) as amt3, round(sum(totalrate1) / sum(amt1), 2) as rate1, round(sum(totalrate2) / sum(amt2), 2) as rate2, round(sum(totalrate3) / sum(amt3), 2) as rate3  from (" + sql + ")";
            logger.info("BillRpt_17:" + sumsql);

            rs = conn.executeQuery(sumsql);
            while (rs.next()) {
                allOrgTotalAmt1 = BigDecimal.valueOf(rs.getDouble("amt1"));
                allOrgTotalAmt2 = BigDecimal.valueOf(rs.getDouble("amt2"));
                allOrgTotalAmt3 = BigDecimal.valueOf(rs.getDouble("amt3"));
                averageRate1 = BigDecimal.valueOf(rs.getDouble("rate1"));
                averageRate2 = BigDecimal.valueOf(rs.getDouble("rate2"));
                averageRate3 = BigDecimal.valueOf(rs.getDouble("rate3"));
            }
            rs.close();

            //��ʼ������
            rs = conn.executeQuery(sql);
            // �м�����
            int i = 0;
            // ������ÿ����¼������У�
            int step = 3;
            int cnt = i * step;
            // --------------������ʽ--------------------
            // ---������ʽ ���ж���----
            WritableFont NormalFont = new WritableFont(WritableFont.COURIER, 11);
            // ��������
            WritableCellFormat wcf_center = new WritableCellFormat(NormalFont);
            //  ����
            wcf_center.setBorder(Border.ALL, BorderLineStyle.THIN);
            //  ��ֱ����
            wcf_center.setVerticalAlignment(VerticalAlignment.CENTRE);
            //ˮƽ���ж���
            wcf_center.setAlignment(Alignment.CENTRE);
            wcf_center.setWrap(true);  //  �Ƿ���

            // ----��ֵ��ʽ ���Ҷ���---
            NumberFormat nf = new NumberFormat("#,###,###,##0.00");
            WritableCellFormat wcf_right = new WritableCellFormat(nf);
            wcf_right.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.NO_BOLD, false));

            // �߿���ʽ
            wcf_right.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);
            // ����
            wcf_right.setWrap(false);
            // ��ֱ����
            wcf_right.setVerticalAlignment(VerticalAlignment.CENTRE);
            // ˮƽ����
            wcf_right.setAlignment(Alignment.RIGHT);
            // �и�
            int rowHeight = 1000;
            // �ܽ��
            double totalAmt = 0;
            double totalAmt_1 = 0;
            double totalAmt_2 = 0;
            double totalAmt_3 = 0;
            // �ܸ�������
            double totalRate = 0;
            double totalRate_1 = 0;
            double totalRate_2 = 0;
            double totalRate_3 = 0;
            // ��ʼ��
            int beginRow = 4;
            // ��ʼ��
            int beginCol = 1;
            // �����¼������������������֮��
            int rowNum = 0;
            //��ͷ
            ws.setRowView(2, 600, false);

            jxl.format.CellFormat fmtPt = ws.getCell(1, 2).getCellFormat();

            startdate = startdate.substring(0, 4) + "��" + Integer.parseInt(startdate.substring(5, 7)) + "��" + Integer.parseInt(startdate.substring(8, 10)) + "��";
            enddate = enddate.substring(0, 4) + "��" + Integer.parseInt(enddate.substring(5, 7)) + "��" + Integer.parseInt(enddate.substring(8, 10)) + "��";
            Label lbl_t = new Label(1, 2, startdate + "-" + enddate, fmtPt);
            ws.addCell(lbl_t);

            //ִ���򵥼۸�Ԫ/��Ԫ��
            BigDecimal execAmtStandard;
            //����Ŷ��Ԫ��
            BigDecimal loanAmtWan;
            //��Ч����
            BigDecimal performPay;
            //������Ч����С��
            BigDecimal singleOrgPerformPaymPay = new BigDecimal(0);
            //��������Ч�����ܼ�
            BigDecimal allOrgPerformPaymPay = new BigDecimal(0);

            while (rs.next()) {
                rowNum++;
                cnt = i * step;
                if (i > 0) {
                    cnt = cnt - i;
                }
                // ����������
                String bankName = rs.getString("bankname");
                // �ͻ���������
                String custmgr_name = rs.getString("custmgr_name");

                // �ӵ�4�п�ʼд����
                //--------------------------��һ��--------------------------------
                int coloffset = 0;
                ws.setRowView(i + beginRow + cnt, rowHeight, false);
                // ��������
                Label lbl = new Label(beginCol, i + beginRow + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                //�ͻ���������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, RPTLABEL01, wcf_center);
                ws.addCell(lbl);
                // ���������
                Number nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("rate1"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("amt1"), wcf_right);
                ws.addCell(nLbl);
                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, baseprice1.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = baseprice1.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate1")), averageRate1, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //����Ŷ��Ԫ��
                loanAmtWan = BigDecimal.valueOf(rs.getDouble("amt1")).divide(new BigDecimal(10000));
                //nLbl = new Number(beginCol + 6, i + beginRow + cnt, loanAmtWan.doubleValue(), wcf_right);
                //ws.addCell(nLbl);
                //��Ч����
                performPay = loanAmtWan.multiply(execAmtStandard);
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, performPay.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ч���ʺϼ�
                singleOrgPerformPaymPay = new BigDecimal(0);
                singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);

                // �����ܶ�
                totalAmt += rs.getDouble("amt1");
                totalAmt_1 += rs.getDouble("amt1");
                // �����ܸ�������
                totalRate += rs.getDouble("rate1");
                totalRate_1 += rs.getDouble("rate1");
                //--------------------------�ڶ���--------------------------------
                coloffset = 0;
                ws.setRowView(i + beginRow + 1 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 1 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                //�ͻ���������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, RPTLABEL02, wcf_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, rs.getDouble("rate2"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, rs.getDouble("amt2"), wcf_right);
                ws.addCell(nLbl);

                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, baseprice2.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = baseprice2.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate2")), averageRate2, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //����Ŷ��Ԫ��
                loanAmtWan = BigDecimal.valueOf(rs.getDouble("amt2")).divide(new BigDecimal(10000));
                //nLbl = new Number(beginCol + 6, i + beginRow + 1 + cnt, loanAmtWan.doubleValue(), wcf_right);
                //ws.addCell(nLbl);
                //��Ч����
                performPay = loanAmtWan.multiply(execAmtStandard);
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, performPay.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ч���ʺϼ�
                singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);

                // �����ܶ�
                totalAmt += rs.getDouble("amt2");
                totalAmt_2 += rs.getDouble("amt2");
                // �����ܸ�������
                totalRate += rs.getDouble("rate2");
                totalRate_2 += rs.getDouble("rate2");
                //---------------------------������-------------------------------
                coloffset = 0;
                ws.setRowView(i + beginRow + 2 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 2 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                //�ͻ���������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);
                // �ͻ��������ƺϲ�
                ws.mergeCells(beginCol + coloffset, i + beginRow + cnt, beginCol + coloffset, i + beginRow + 2 + cnt);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, RPTLABEL03, wcf_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, rs.getDouble("rate3"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, rs.getDouble("amt3"), wcf_right);
                ws.addCell(nLbl);

                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, baseprice3.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = baseprice3.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate3")), averageRate3, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //����Ŷ��Ԫ��
                loanAmtWan = BigDecimal.valueOf(rs.getDouble("amt3")).divide(new BigDecimal(10000));
                //nLbl = new Number(beginCol + 6, i + beginRow + 2 + cnt, loanAmtWan.doubleValue(), wcf_right);
                //ws.addCell(nLbl);
                //��Ч����
                performPay = loanAmtWan.multiply(execAmtStandard);
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, performPay.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ч���ʺϼ�
                singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, singleOrgPerformPaymPay.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                // ��Ч���ʺϼƺϲ�
                ws.mergeCells(beginCol + coloffset, i + beginRow + cnt, beginCol + coloffset, i + beginRow + 2 + cnt);

                allOrgPerformPaymPay = allOrgPerformPaymPay.add(singleOrgPerformPaymPay);

                // �����ܶ�
                totalAmt += rs.getDouble("amt3");
                totalAmt_3 += rs.getDouble("amt3");
                // �����ܸ�������
                totalRate += rs.getDouble("rate3");
                totalRate_3 += rs.getDouble("rate3");
                // �м�������1
                i++;
            }


            /*
            20100726  zhanrui  ����ƽ��������
            */
            //-----------------------------------����ܼ�ֵ-------------------------------------------------------------------------

            // ----������ʾ--
            // ����������
            WritableCellFormat wcf_bold_center = new WritableCellFormat(new WritableFont(WritableFont.COURIER, 11, WritableFont.BOLD, false));
            wcf_bold_center.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_bold_center.setAlignment(Alignment.CENTRE);
            //wcf_bold_center.setBackground(jxl.format.Colour.GRAY_25);
            wcf_bold_center.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf_bold_center.setWrap(true);  //  �Ƿ���

            // ----������ʾ--
            WritableCellFormat wcf_bold_right = new WritableCellFormat(nf);
            //WritableCellFormat wcf_bold_right = new WritableCellFormat(new WritableFont(WritableFont.COURIER,11,WritableFont.BOLD,false));
            wcf_bold_right.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.BOLD, false));
            wcf_bold_right.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_bold_right.setAlignment(Alignment.RIGHT);
            //wcf_bold_right.setBackground(jxl.format.Colour.GRAY_25);
            wcf_bold_right.setVerticalAlignment(VerticalAlignment.CENTRE);


            //�������ܼ�   zhanrui 20110307
            ws.setRowView(i * step + beginRow, rowHeight, false);
            // ��������
            Label lbl = new Label(1, i * step + beginRow, "�������ϼ�", wcf_bold_center);
            ws.addCell(lbl);
            Number nLbl = new Number(beginCol + 8, i * step + beginRow, allOrgPerformPaymPay.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);


            cnt = i * step;
            cnt++;
            if (i > 0) {
                cnt = cnt - i;
            }
            // ����������
            String bankName = deptName;
            // �ӵ�4�п�ʼд����
            //--------------------------��һ��--------------------------------
            int coloffset = 0;
            ws.setRowView(i + beginRow + cnt, rowHeight, false);
            // ��������
            lbl = new Label(beginCol, i + beginRow + cnt, bankName, wcf_bold_center);
            ws.addCell(lbl);
            //�ϼ�
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
            ws.addCell(lbl);
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, RPTLABEL01, wcf_bold_center);
            ws.addCell(lbl);
            // ���������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, averageRate1.doubleValue(), wcf_bold_right);
            //lbl = new Label(beginCol + 2, i + beginRow + cnt, "ƽ��" + (totalRate_1 / rowNum) , wcf_bold_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, allOrgTotalAmt1.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, baseprice1.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = baseprice1.multiply(getRateFormula(averageRate1, averageRate1, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //����Ŷ��Ԫ��
            loanAmtWan = allOrgTotalAmt1.divide(new BigDecimal(10000));
            //nLbl = new Number(beginCol + 6, i + beginRow + cnt, loanAmtWan.doubleValue(), wcf_right);
            //ws.addCell(nLbl);
            //��Ч����
            performPay = loanAmtWan.multiply(execAmtStandard);
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, performPay.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ч���ʺϼ�
            singleOrgPerformPaymPay = new BigDecimal(0);

            singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);

            //---------------------------�ڶ���-------------------------------
            coloffset = 0;
            ws.setRowView(i + beginRow + 1 + cnt, rowHeight, false);
            // ��������
            lbl = new Label(beginCol, i + beginRow + 1 + cnt, bankName, wcf_bold_center);
            ws.addCell(lbl);
            //�ϼ�
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
            ws.addCell(lbl);
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, RPTLABEL02, wcf_bold_center);
            ws.addCell(lbl);
            // ���������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, averageRate2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, allOrgTotalAmt2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, baseprice2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = baseprice2.multiply(getRateFormula(averageRate2, averageRate2, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //����Ŷ��Ԫ��
            loanAmtWan = allOrgTotalAmt2.divide(new BigDecimal(10000));
            //nLbl = new Number(beginCol + 6, i + beginRow + 1 + cnt, loanAmtWan.doubleValue(), wcf_right);
            //ws.addCell(nLbl);
            //��Ч����
            performPay = loanAmtWan.multiply(execAmtStandard);
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, performPay.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ч���ʺϼ�
            singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);

            //---------------------------������-------------------------------
            coloffset = 0;
            ws.setRowView(i + beginRow + 2 + cnt, rowHeight, false);
            // ��������
            lbl = new Label(beginCol, i + beginRow + 2 + cnt, bankName, wcf_bold_center);
            ws.addCell(lbl);
            // �����ϲ�
            ws.mergeCells(beginCol, i + beginRow + cnt, beginCol, i + beginRow + 2 + cnt);
            //�ϼ�
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
            ws.addCell(lbl);
            //�ϼ� �ϲ�
            ws.mergeCells(beginCol + coloffset, i + beginRow + cnt, beginCol + coloffset, i + beginRow + 2 + cnt);
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, RPTLABEL03, wcf_bold_center);
            ws.addCell(lbl);
            // ���������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, averageRate3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, allOrgTotalAmt3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, baseprice3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = baseprice3.multiply(getRateFormula(averageRate3, averageRate3, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //����Ŷ��Ԫ��
            loanAmtWan = allOrgTotalAmt3.divide(new BigDecimal(10000));
            //nLbl = new Number(beginCol + 6, i + beginRow + 2 + cnt, loanAmtWan.doubleValue(), wcf_right);
            //ws.addCell(nLbl);
            //��Ч����
            performPay = loanAmtWan.multiply(execAmtStandard);
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, performPay.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ч���ʺϼ�
            singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, singleOrgPerformPaymPay.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ��Ч���ʺϼƺϲ�
            ws.mergeCells(beginCol + coloffset, i + beginRow + cnt, beginCol + coloffset, i + beginRow + 2 + cnt);

            // �м�������1
            i++;

            //--------------------------------�ر�excel����------------------------------------------------------------------------
            // �ر�excel
            wwb.write();
            wwb.close();
            rw.close();

            //--------------------------------�������-----------------------------------------------------------------------------
            // �������
            out.flush();
            out.close();
        } while (false);
    } catch (Exception e) {
        e.printStackTrace();
        logger.error("�򵥹��ʱ�����ִ���!",e);
    } finally {
        // �ͷ����ݿ�����
        ConnectionManager.getInstance().release();
    }
%>
<%!
    /**
     ���㹫ʽ��1+��T-R��*5��
     ����ʵ��ִ�����ʣ�T��
     ����ƽ�����ʣ�R��
     */
    BigDecimal getRateFormula(BigDecimal T, BigDecimal R, BigDecimal weight) {
        return T.subtract(R).multiply(weight).add(new BigDecimal("1"));
    }
%>