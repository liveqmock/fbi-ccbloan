<!--
/*********************************************************************
* ��������: �򵥹���ͳ����Ŀ15 ����
* �� ��:
* ��������: 2010/10/22
* �� �� ��:
* �޸�����:
* �� Ȩ:
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@page import="com.ccb.util.CcbLoanConst" %>
<%@page import="jxl.Workbook" %>
<%@page import="jxl.WorkbookSettings" %>
<%@page import="jxl.format.Alignment" %>
<%@page import="jxl.format.Border" %>
<%@page import="jxl.format.BorderLineStyle" %>
<%@page import="jxl.format.VerticalAlignment" %>
<%@page import="jxl.write.*" %>
<%@page import="jxl.write.Number" %>
<%@page import="pub.platform.advance.utils.PropertyManager" %>
<%@page import="pub.platform.db.ConnectionManager" %>
<%@page import="pub.platform.db.DatabaseConnection" %>
<%@page import="pub.platform.db.RecordSet" %>
<%@page import="pub.platform.form.config.SystemAttributeNames" %>
<%@page import="pub.platform.security.OperatorManager" %>
<%@page import="java.io.File" %>
<%@page import="java.util.Locale" %>
<%

    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    final String RPTLABEL01 = "����ס������(��������ס����������ٽ���ס������)";
    final String RPTLABEL02 = "������ҵ����";
    final String RPTLABEL03 = "����������������������÷���������߶�������Ѷ�ȡ�����������������Ѻ����ȣ�";

//����do while�ṹ�������������м����������˳�������
    try {
        do {
            // �������
            response.reset();
            response.setContentType("application/vnd.ms-excel");
//            response.addHeader("Content-Disposition", "attachment; filename=" + CcbLoanConst.RPT_PAY_BILL_12 + ".xls");
            response.addHeader("Content-Disposition", "attachment; filename=" + "payBill15.xls");
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath + "payBill15.xls";
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
            String whereStr = " where 1=1  and t.LOANSTATE is not null and t.LOANSTATE <> '0' and t.custmgr_id is not null  ";
            if (!request.getParameter("CUST_OPEN_DT").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT >='" + request.getParameter("CUST_OPEN_DT").trim() + "'";
            }
            if (!request.getParameter("CUST_OPEN_DT2").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT <='" + request.getParameter("CUST_OPEN_DT2").trim() + "'";
            }

            String loantype1 = "t.ln_typ  in ('011','013')";
            String loantype2 = "t.ln_typ  in ('033','433')";
            String loantype3 = "t.ln_typ  in ('012','014','015','016','020','022','026','028','029','030','031','113','114','115','122')";

            DatabaseConnection conn = ConnectionManager.getInstance().get();
            RecordSet rs = conn.executeQuery("select deptname from ptdept where deptid='" + deptId + "'");
            String deptName = "�ϼ�";
            while (rs.next()) {
                deptName = rs.getString(0);
            }

            // ͳ�Ʋ�ѯ���
            String sql = ""
                    + " select bankid,bankname,custmgr_name,amt1,amt2,amt3,round(rate1/amt1,2) as rate1,round(rate2/amt2,2) as rate2,round(rate3/amt3,2) as rate3 , " +
                    " rate1 as totalrate1, rate2 as totalrate2, rate3 as totalrate3 from ("
                    + " select t.bankid,"
                    + " (select deptname from ptdept where deptid=t.bankid)as bankname,"
                    + " (select opername from ptoper where operid=t.custmgr_id)as custmgr_name,"
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
                    + "     end) as rate1,"
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
                    + "     end) as rate2,"
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
                    + "     end) as rate3  "
                    + " from ln_loanapply t"
                    //+" where t.custmgr_id ='xujian.qd'"
                    + whereStr
                    + " and t.bankid in(select deptid from ptdept start with deptid='" + omgr.getOperator().getDeptid() + "' connect by prior deptid=parentdeptid) "
                    + " group by bankid,custmgr_id"
                    + " order by bankid,custmgr_id"
                    + " ) ";

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
            String startdate = request.getParameter("CUST_OPEN_DT").trim();
            String enddate = request.getParameter("CUST_OPEN_DT2").trim();
            ws.setRowView(2, 600, false);

            jxl.format.CellFormat fmtPt = ws.getCell(1, 2).getCellFormat();

            startdate = startdate.substring(0, 4) + "��" + Integer.parseInt(startdate.substring(5, 7)) + "��" + Integer.parseInt(startdate.substring(8, 10)) + "��";
            enddate = enddate.substring(0, 4) + "��" + Integer.parseInt(enddate.substring(5, 7)) + "��" + Integer.parseInt(enddate.substring(8, 10)) + "��";
            Label lbl_t = new Label(1, 2, startdate + "-" + enddate, fmtPt);
            ws.addCell(lbl_t);

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
                ws.setRowView(i + beginRow + cnt, rowHeight, false);
                // ��������
                Label lbl = new Label(beginCol, i + beginRow + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                //�ͻ���������
                lbl = new Label(beginCol + 1, i + beginRow + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + cnt, RPTLABEL01, wcf_center);
                ws.addCell(lbl);
                // ���������
                Number nLbl = new Number(beginCol + 3, i + beginRow + cnt, rs.getDouble("rate1"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + cnt, rs.getDouble("amt1"), wcf_right);
                ws.addCell(nLbl);
                // �����ܶ�
                totalAmt += rs.getDouble("amt1");
                totalAmt_1 += rs.getDouble("amt1");
                // �����ܸ�������
                totalRate += rs.getDouble("rate1");
                totalRate_1 += rs.getDouble("rate1");
                //---------------------------�ڶ���-------------------------------
                ws.setRowView(i + beginRow + 1 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 1 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                // �ͻ���������
                lbl = new Label(beginCol + 1, i + beginRow + 1 + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);

                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + 1 + cnt, RPTLABEL02, wcf_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + 3, i + beginRow + 1 + cnt, rs.getDouble("rate2"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + 1 + cnt, rs.getDouble("amt2"), wcf_right);
                ws.addCell(nLbl);
                // �����ܶ�
                totalAmt += rs.getDouble("amt2");
                totalAmt_3 += rs.getDouble("amt2");
                // �����ܸ�������
                totalRate += rs.getDouble("rate2");
                totalRate_3 += rs.getDouble("rate2");
                //---------------------------������-------------------------------
                ws.setRowView(i + beginRow + 2 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 2 + cnt, bankName, wcf_center);
                ws.addCell(lbl);
                // �����ϲ�
                ws.mergeCells(beginCol, i + beginRow + cnt, beginCol, i + beginRow + 2 + cnt);
                // �ͻ���������
                lbl = new Label(beginCol + 1, i + beginRow + 2 + cnt, custmgr_name, wcf_center);
                ws.addCell(lbl);
                // �ͻ��������ƺϲ�
                ws.mergeCells(beginCol + 1, i + beginRow + cnt, beginCol + 1, i + beginRow + 2 + cnt);

                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + 2 + cnt, RPTLABEL03, wcf_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + 3, i + beginRow + 2 + cnt, rs.getDouble("rate3"), wcf_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + 2 + cnt, rs.getDouble("amt3"), wcf_right);
                ws.addCell(nLbl);
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

            sql = "select sum(amt1) as amt1 ,sum(amt2) as amt2, sum(amt3) as amt3, round(sum(totalrate1) / sum(amt1), 2) as rate1, round(sum(totalrate2) / sum(amt2), 2) as rate2, round(sum(totalrate3) / sum(amt3), 2) as rate3  from (" + sql + ")";

            rs = conn.executeQuery(sql);
            while (rs.next()) {

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

                cnt = i * step;
                if (i > 0) {
                    cnt = cnt - i;
                }
                // ����������
                String bankName = deptName;
                // �ӵ�4�п�ʼд����
                //--------------------------��һ��--------------------------------
                ws.setRowView(i + beginRow + cnt, rowHeight, false);
                // ��������
                Label lbl = new Label(beginCol, i + beginRow + cnt, bankName, wcf_bold_center);
                ws.addCell(lbl);
                // �ϼ�
                lbl = new Label(beginCol+1, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + cnt, RPTLABEL01, wcf_bold_center);
                ws.addCell(lbl);
                // ���������
                Number nLbl = new Number(beginCol + 3, i + beginRow + cnt, rs.getDouble("rate1"), wcf_bold_right);
                //lbl = new Label(beginCol + 2, i + beginRow + cnt, "ƽ��" + (totalRate_1 / rowNum) , wcf_bold_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + cnt, rs.getDouble("amt1"), wcf_bold_right);
                ws.addCell(nLbl);
                //---------------------------�ڶ���-------------------------------
                ws.setRowView(i + beginRow + 1 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 1 + cnt, bankName, wcf_bold_center);
                ws.addCell(lbl);
                // �ϼ�
                lbl = new Label(beginCol+1, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
                ws.addCell(lbl);
                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + 1 + cnt, RPTLABEL02, wcf_bold_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + 3, i + beginRow + 1 + cnt, rs.getDouble("rate2"), wcf_bold_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + 1 + cnt, rs.getDouble("amt2"), wcf_bold_right);
                ws.addCell(nLbl);
                //---------------------------������-------------------------------
                ws.setRowView(i + beginRow + 2 + cnt, rowHeight, false);
                // ��������
                lbl = new Label(beginCol, i + beginRow + 2 + cnt, bankName, wcf_bold_center);
                ws.addCell(lbl);
                // �����ϲ�
                ws.mergeCells(beginCol, i + beginRow + cnt, beginCol, i + beginRow + 2 + cnt);
                // �ϼ�
                lbl = new Label(beginCol+1, i + beginRow + cnt, "�ϼ�", wcf_bold_center);
                ws.addCell(lbl);
                // �ϲ�
                ws.mergeCells(beginCol + 1, i + beginRow + cnt, beginCol + 1, i + beginRow + 2 + cnt);
                // ��������
                lbl = new Label(beginCol + 2, i + beginRow + 2 + cnt, RPTLABEL03, wcf_bold_center);
                ws.addCell(lbl);
                // ���������
                nLbl = new Number(beginCol + 3, i + beginRow + 2 + cnt, rs.getDouble("rate3"), wcf_bold_right);
                ws.addCell(nLbl);
                // ����Ŷ�
                nLbl = new Number(beginCol + 4, i + beginRow + 2 + cnt, rs.getDouble("amt3"), wcf_bold_right);
                ws.addCell(nLbl);
                // �м�������1
                i++;
            }


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
    } finally {
        // �ͷ����ݿ�����
        ConnectionManager.getInstance().release();
    }
%>