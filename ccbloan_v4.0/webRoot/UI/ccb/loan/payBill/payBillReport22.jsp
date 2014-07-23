<!--
/*********************************************************************
* ��������: �򵥹��ʲ�ѯͳ��16 (��7)
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
    Log logger = LogFactory.getLog("payBillReport18.jsp");

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
    //ȫ�������� 371997709 �� 371997909 �� 371998009 (���ݣ�ƽ�ȣ�����)
    BigDecimal baseprice1 = new BigDecimal(0);
    BigDecimal baseprice2 = new BigDecimal(0);
    BigDecimal baseprice3 = new BigDecimal(0);
    //��Ӫ����
    BigDecimal jyzx_baseprice1 = new BigDecimal(0);
    BigDecimal jyzx_baseprice2 = new BigDecimal(0);
    BigDecimal jyzx_baseprice3 = new BigDecimal(0);
    try {
        do {
            // �������   �±���ģ��-��Ӫ����ͳ������
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            response.addHeader("Content-Disposition", "attachment; filename=" + "payBill22_" + new SimpleDateFormat("yyyyMMdd").format(new Date()) + ".xls");
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath + "payBill18.xls";
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
            String whereStr = " where 1=1  and lnlapp.LOANSTATE is not null and lnlapp.LOANSTATE <> '0'  ";
            if (!request.getParameter("CUST_OPEN_DT").trim().equals("")) {
                whereStr += " and lnlapp.CUST_OPEN_DT >='" + request.getParameter("CUST_OPEN_DT").trim() + "'";
            }
            if (!request.getParameter("CUST_OPEN_DT2").trim().equals("")) {
                whereStr += " and lnlapp.CUST_OPEN_DT <='" + request.getParameter("CUST_OPEN_DT2").trim() + "'";
            }

            String loantype1 = "lnlapp.ln_typ  in ('011','013')";
            String loantype2 = "lnlapp.ln_typ  in ('033','433')";
            String loantype3 = "lnlapp.ln_typ  in ('012','014','015','016','020','022','026','028','029','030','031','113','114','115','122')";

            //����ƽ��ֵ
            BigDecimal allOrgTotalAmt1 = new BigDecimal("0.00");
            BigDecimal allOrgTotalAmt2 = new BigDecimal("0.00");
            BigDecimal allOrgTotalAmt3 = new BigDecimal("0.00");
            BigDecimal averageRate1 = new BigDecimal("0.00");
            BigDecimal averageRate2 = new BigDecimal("0.00");
            BigDecimal averageRate3 = new BigDecimal("0.00");
            Double totalCnt1 = new Double(0);  //���ܻ���
            Double totalCnt2 = new Double(0);  //���ܻ���
            Double totalCnt3 = new Double(0);  //���ܻ���

            DatabaseConnection conn = ConnectionManager.getInstance().get();

            RecordSet rs = conn.executeQuery("select deptname from ptdept where deptid='" + deptId + "'");
            String deptName = "�ϼ�";
            while (rs.next()) {
                deptName = rs.getString(0);
            }
            rs.close();

            rs = conn.executeQuery("select enuitemexpand as name,to_number(enuitemvalue) as value from ptenudetail where enutype in('PAYBILLRPTPARAM','PAYBILLRPTPARAM1') ");
            while (rs.next()) {
                String name = rs.getString("name");
                BigDecimal value = BigDecimal.valueOf(rs.getDouble("value"));
                if ("weight".equals(name)) {
                    weight = value;
                } else if ("jyzx_baseprice1".equals(name)) {
                    jyzx_baseprice1 = value;
                } else if ("jyzx_baseprice2".equals(name)) {
                    jyzx_baseprice2 = value;
                } else if ("jyzx_baseprice3".equals(name)) {
                    jyzx_baseprice3 = value;
                }
            }
            rs.close();

            // ͳ�Ʋ�ѯ���
            String sql = ""
                    + " select cust_bankid,bankname,trunc(filldbl2/100,2) as filldbl2,(case when filldbl2 >= 95 then 1.05 when (filldbl2>=90 and filldbl2<95) then 1" +
                    "   when (filldbl2>=80 and filldbl2<90) then 0.95 when filldbl2<80 then 0.85 end) as coverweight," +
                    "   cnt1,cnt2,cnt3,amt1,amt2,amt3,round(rate1/amt1,2) as rate1,round(rate2/amt2,2) as rate2,round(rate3/amt3,2) as rate3 , " +
                    " rate1 as totalrate1, rate2 as totalrate2, rate3 as totalrate3 from ("
                    + " select t1.cust_bankid,ptdept.deptname as bankname,sum(t1.cnt1) as cnt1"
                    + " ,(case when sum(t1.cnt1)=0 then 0 else round(sum(t1.filldbl2_1)/sum(t1.cnt1),2) end) as filldbl2"
                    + " ,sum(t1.amt1) as amt1,sum(t1.rate1) as rate1,sum(t1.cnt2) as cnt2,sum(t1.amt2) as amt2,sum(t1.rate2) as rate2"
                    + " ,sum(t1.cnt3) as cnt3,sum(t1.amt3) as amt3,sum(t1.rate3) as rate3 from ("
                    + " select (case when fillstr10 = '3' then lnlapp.bankid when fillstr10 = '4' then pt.parentdeptid end) as cust_bankid"
                    + " ,lnlapp.bankid,pt.deptname," +
                    "   sum(case" +
                    "   when (" + loantype1 + ") then 1 else 0 end)*pt.filldbl2 as filldbl2_1," +
                    "   sum(case" +
                    "   when (" + loantype1 + ") then 1 else 0 end) as cnt1,"
                    + " sum(case"
                    + "       when (" + loantype1 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt1,"
                    + " sum(case"
                    + "       when (" + loantype1 + " ) then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate1," +
                    "   sum(case" +
                    "   when (" + loantype2 + ") then 1 else 0 end) as cnt2,"
                    + " sum(case"
                    + "       when (" + loantype2 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt2,"
                    + " sum(case"
                    + "       when (" + loantype2 + " ) then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate2," +
                    "   sum(case" +
                    "   when (" + loantype3 + ") then 1 else 0 end) as cnt3,"
                    + " sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt3,"
                    + "  sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate3  " +
                    "   from ln_loanapply lnlapp join ptdept pt on lnlapp.bankid = pt.deptid"
                    + whereStr
                    + " and lnlapp.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) " +
                    "   and (lnlapp.loanid in (select pcms.loanid from ln_promotioncustomers pcms where pcms.status='4') or pt.fillstr10='3')" +
                    "   and pt.fillstr10='4'" +
                    " group by lnlapp.bankid,pt.filldbl2,pt.deptname,pt.fillstr10,pt.parentdeptid" +
                    ") t1 join ptdept on t1.cust_bankid = ptdept.deptid"
                    + " group by cust_bankid, ptdept.deptname"
                    + " order by cust_bankid"
                    + " ) ";

            String sql1 = ""
                    + " select cust_bankid,bankname,trunc(filldbl2/100,2) as filldbl2,(case when filldbl2 >= 95 then 1.05 when (filldbl2>=90 and filldbl2<95) then 1" +
                    "   when (filldbl2>=80 and filldbl2<90) then 0.95 when filldbl2<80 then 0.85 end) as coverweight," +
                    "   cnt1,cnt2,cnt3,amt1,amt2,amt3,round(rate1/amt1,2) as rate1,round(rate2/amt2,2) as rate2,round(rate3/amt3,2) as rate3 , " +
                    " rate1 as totalrate1, rate2 as totalrate2, rate3 as totalrate3 from ("
                    + " select t1.cust_bankid,ptdept.deptname as bankname,sum(t1.cnt1) as cnt1"
                    + " ,(case when sum(t1.cnt1)=0 then 0 else round(sum(t1.filldbl2_1)/sum(t1.cnt1),2) end) as filldbl2"
                    + " ,sum(t1.amt1) as amt1,sum(t1.rate1) as rate1,sum(t1.cnt2) as cnt2,sum(t1.amt2) as amt2,sum(t1.rate2) as rate2"
                    + " ,sum(t1.cnt3) as cnt3,sum(t1.amt3) as amt3,sum(t1.rate3) as rate3 from ("
                    + " select (case when fillstr10 = '3' then lnlapp.bankid when fillstr10 = '4' then pt.parentdeptid end) as cust_bankid"
                    + " ,lnlapp.bankid,pt.deptname," +
                    "   sum(case" +
                    "   when (" + loantype1 + ") then 1 else 0 end)*pt.filldbl2 as filldbl2_1," +
                    "   sum(case" +
                    "   when (" + loantype1 + ") then 1 else 0 end) as cnt1,"
                    + " sum(case"
                    + "       when (" + loantype1 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt1,"
                    + " sum(case"
                    + "       when (" + loantype1 + " ) then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate1," +
                    "   sum(case" +
                    "   when (" + loantype2 + ") then 1 else 0 end) as cnt2,"
                    + " sum(case"
                    + "       when (" + loantype2 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt2,"
                    + " sum(case"
                    + "       when (" + loantype2 + " ) then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate2," +
                    "   sum(case" +
                    "   when (" + loantype3 + ") then 1 else 0 end) as cnt3,"
                    + " sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as amt3,"
                    + "  sum(case"
                    + "       when (" + loantype3 + ") then"
                    + "        RATECALEVALUE*rt_orig_loan_amt"
                    + "       else"
                    + "        null"
                    + "     end) as rate3  " +
                    "   from ln_loanapply lnlapp join ptdept pt on lnlapp.bankid = pt.deptid"
                    + whereStr
                    + " and lnlapp.bankid in(select deptid from ptdept start with deptid='371980000' connect by prior deptid=parentdeptid) " +
                    "   and (lnlapp.loanid in (select pcms.loanid from ln_promotioncustomers pcms where pcms.status='4') or pt.fillstr10='3')" +
                    "   and pt.fillstr10='4'" +
                    " group by lnlapp.bankid,pt.filldbl2,pt.deptname,pt.fillstr10,pt.parentdeptid" +
                    ") t1 join ptdept on t1.cust_bankid = ptdept.deptid"
                    + " group by cust_bankid, ptdept.deptname"
                    + " order by cust_bankid"
                    + " ) ";
            String sumsql = "select sum(cnt1) as cnt1,sum(cnt2) as cnt2,sum(cnt3) as cnt3,sum(amt1) as amt1 ,sum(amt2) as amt2, sum(amt3) as amt3, " +
                    "round(sum(totalrate1) / sum(amt1), 2) as rate1, round(sum(totalrate2) / sum(amt2), 2) as rate2, round(sum(totalrate3) / sum(amt3), 2) as rate3  from (" + sql1 + ")";

            rs = conn.executeQuery(sumsql);
            while (rs.next()) {
                allOrgTotalAmt1 = BigDecimal.valueOf(rs.getDouble("amt1"));
                allOrgTotalAmt2 = BigDecimal.valueOf(rs.getDouble("amt2"));
                allOrgTotalAmt3 = BigDecimal.valueOf(rs.getDouble("amt3"));
                averageRate1 = BigDecimal.valueOf(rs.getDouble("rate1"));
                averageRate2 = BigDecimal.valueOf(rs.getDouble("rate2"));
                averageRate3 = BigDecimal.valueOf(rs.getDouble("rate3"));
                totalCnt1 = rs.getDouble("cnt1");
                totalCnt2 = rs.getDouble("cnt2");
                totalCnt3 = rs.getDouble("cnt3");
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
                //�жϻ�������(��Ӫ���ġ�����ȫ����)   371997709 �� 371997909 �� 371998009
                String bankid = rs.getString("cust_bankid");
                BigDecimal price1 = new BigDecimal(0);
                BigDecimal price2 = new BigDecimal(0);
                BigDecimal price3 = new BigDecimal(0);
                /*if (bankid.equals("371997709") || bankid.equals("371997909") || bankid.equals("371998009")) {
                    price1 = baseprice1;
                    price2 = baseprice2;
                    price3 = baseprice3;
                } else {*/
                    price1 = jyzx_baseprice1;
                    price2 = jyzx_baseprice2;
                    price3 = jyzx_baseprice3;
//                }
                // ����������
                String bankName = rs.getString("bankname");
                // �ӵ�4�п�ʼд����
                //--------------------------��һ��--------------------------------
                int coloffset = 0;
                ws.setRowView(i + beginRow + cnt, rowHeight, false);
                // ��������
                Label lbl = new Label(beginCol, i + beginRow + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, RPTLABEL01, wcf_center);
                ws.addCell(lbl);
                //���´����
                Number nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("cnt1"), wcf_center);
                ws.addCell(nLbl);
                // ����ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("rate1"), wcf_right);
                ws.addCell(nLbl);
                //�ൺ����ʵ��ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, averageRate1.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("amt1")/10000, wcf_right);
                ws.addCell(nLbl);
                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, price1.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = price1.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate1")), averageRate1, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ʒ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("filldbl2"), wcf_right);
                ws.addCell(nLbl);
                //����ϵ��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, rs.getDouble("coverweight"), wcf_right);
                ws.addCell(nLbl);
                //����Ŷ��Ԫ��
                loanAmtWan = BigDecimal.valueOf(rs.getDouble("amt1")).divide(new BigDecimal(10000));
                //nLbl = new Number(beginCol + 6, i + beginRow + cnt, loanAmtWan.doubleValue(), wcf_right);
                //ws.addCell(nLbl);
                //��Ч����
                performPay = loanAmtWan.multiply(execAmtStandard).multiply(BigDecimal.valueOf(rs.getDouble("coverweight")));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, performPay.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ч���ʺϼ�
                singleOrgPerformPaymPay = new BigDecimal(0);
                singleOrgPerformPaymPay = singleOrgPerformPaymPay.add(performPay);

                //--------------------------�ڶ���--------------------------------
                coloffset = 0;
                ws.setRowView(i + beginRow + 1 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 1 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, RPTLABEL02, wcf_center);
                ws.addCell(lbl);
                //���´����
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, rs.getDouble("cnt2"), wcf_center);
                ws.addCell(nLbl);
                // ����ʵ��ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, rs.getDouble("rate2"), wcf_right);
                ws.addCell(nLbl);
                //�ൺ����ʵ��ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, averageRate2.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, rs.getDouble("amt2")/10000, wcf_right);
                ws.addCell(nLbl);

                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, price2.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = price2.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate2")), averageRate2, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ʒ������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, "", wcf_right);
                ws.addCell(lbl);
                //����ϵ��
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, "", wcf_right);
                ws.addCell(lbl);
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

                //---------------------------������-------------------------------
                coloffset = 0;
                ws.setRowView(i + beginRow + 2 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 2 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                // �����ϲ�
                ws.mergeCells(beginCol, i + beginRow + cnt, beginCol, i + beginRow + 2 + cnt);
                // ��������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, RPTLABEL03, wcf_center);
                ws.addCell(lbl);
                //���´����
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, rs.getDouble("cnt3"), wcf_center);
                ws.addCell(nLbl);
                // ����ʵ��ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, rs.getDouble("rate3"), wcf_right);
                ws.addCell(nLbl);
                //�ൺ����ʵ��ִ������
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, averageRate3.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, rs.getDouble("amt3")/10000, wcf_right);
                ws.addCell(nLbl);

                //ÿ��Ԫ�򵥼۸񣨻�׼��
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, price3.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //ִ���򵥼۸�Ԫ/��Ԫ��
                execAmtStandard = price3.multiply(getRateFormula(BigDecimal.valueOf(rs.getDouble("rate3")), averageRate3, weight));
                nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, execAmtStandard.doubleValue(), wcf_right);
                ws.addCell(nLbl);
                //��Ʒ������
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, "", wcf_right);
                ws.addCell(lbl);
                //����ϵ��
                lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, "", wcf_right);
                ws.addCell(lbl);
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
            Number nLbl = new Number(beginCol + 11, i * step + beginRow, allOrgPerformPaymPay.doubleValue(), wcf_bold_right);
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
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, RPTLABEL01, wcf_bold_center);
            ws.addCell(lbl);
            //���´����
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, totalCnt1, wcf_center);
            ws.addCell(nLbl);
            // ����ʵ��ִ������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, averageRate1.doubleValue(), wcf_bold_right);
            //lbl = new Label(beginCol + 2, i + beginRow + cnt, "ƽ��" + (totalRate_1 / rowNum) , wcf_bold_right);
            ws.addCell(nLbl);
            //�ൺ����ʵ��ִ������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, averageRate1.doubleValue(), wcf_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, allOrgTotalAmt1.doubleValue()/10000, wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, jyzx_baseprice1.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = jyzx_baseprice1.multiply(getRateFormula(averageRate1, averageRate1, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ʒ������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, "", wcf_right);
            ws.addCell(lbl);
            //����ϵ��
            lbl = new Label(beginCol + ++coloffset, i + beginRow + cnt, "", wcf_right);
            ws.addCell(lbl);
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
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, RPTLABEL02, wcf_bold_center);
            ws.addCell(lbl);
            //���´����
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, totalCnt2, wcf_center);
            ws.addCell(nLbl);
            // ����ʵ��ִ������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, averageRate2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ����ʵ��ִ������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, averageRate2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, allOrgTotalAmt2.doubleValue()/10000, wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, jyzx_baseprice2.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = jyzx_baseprice2.multiply(getRateFormula(averageRate2, averageRate2, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 1 + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ʒ������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, "", wcf_right);
            ws.addCell(lbl);
            //����ϵ��
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 1 + cnt, "", wcf_right);
            ws.addCell(lbl);
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
            // ��������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, RPTLABEL03, wcf_bold_center);
            ws.addCell(lbl);
            //���´����
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, totalCnt3, wcf_center);
            ws.addCell(nLbl);
            // ���������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, averageRate3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // �ൺ����ʵ��ִ������
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, averageRate3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            // ����Ŷ�
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, allOrgTotalAmt3.doubleValue()/10000, wcf_bold_right);
            ws.addCell(nLbl);

            //ÿ��Ԫ�򵥼۸񣨻�׼��
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, jyzx_baseprice3.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //ִ���򵥼۸�Ԫ/��Ԫ��
            execAmtStandard = jyzx_baseprice3.multiply(getRateFormula(averageRate3, averageRate3, weight));
            nLbl = new Number(beginCol + ++coloffset, i + beginRow + 2 + cnt, execAmtStandard.doubleValue(), wcf_bold_right);
            ws.addCell(nLbl);
            //��Ʒ������
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, "", wcf_right);
            ws.addCell(lbl);
            //����ϵ��
            lbl = new Label(beginCol + ++coloffset, i + beginRow + 2 + cnt, "", wcf_right);
            ws.addCell(lbl);
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
        logger.error("�򵥹��ʱ�����ִ���!", e);
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