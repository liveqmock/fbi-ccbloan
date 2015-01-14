/*********************************************************************
* ��������: �򵥹���ͳ����Ŀ�� �������ʸ�������ͳ�Ʊ�--��Ȩ����
* ��������Ϊ5��
����ס������(��������ס����������ٽ���ס������)
�������Ѿ�Ӫ�������������Ѷ�ȡ�������ҵ������������������Ѻ����ȣ�
������ҵ�÷��������������ҵ�÷���������ٽ�����ҵ�÷����
����ס����Ѻ��ȴ���
���������ϼ�
* �� ��: zr
* ��������: 2013/01/08
* �޸����ڣ�2015/01/04 zhanrui
***********************************************************************/
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
<%@page import="java.util.List" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String deptId = omgr.getOperator().getPtDeptBean().getDeptid();

    try {
        do {
            //�õ�����ģ��
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptName = rptModelPath +  "payBillOrg2.xls";
            File file = new File(rptName);
            // �ж�ģ���Ƿ����,���������˳�
            if (!file.exists()) {
                out.println(rptName + PropertyManager.getProperty("304"));
                break;
            }
            // �������
            response.reset();
            response.setContentType("application/vnd.ms-excel");
            response.addHeader("Content-Disposition", "attachment; filename=" + "payBillOrg.xls");
            // ----------------------------����ģ�崴�������----------------------------------------------------------------
            WorkbookSettings setting = new WorkbookSettings();
            Locale locale = new Locale("zh", "CN");
            setting.setLocale(locale);
            setting.setEncoding("ISO-8859-1");
            File fileInput = new File(rptName);
            Workbook rw = Workbook.getWorkbook(fileInput, setting);
            WritableWorkbook wwb = Workbook.createWorkbook(response.getOutputStream(), rw, setting);
            WritableSheet ws = wwb.getSheet(0);

            // --------------������ʽ--------------------
            // ---������ʽ ���ж���----
            WritableFont NormalFont = new WritableFont(WritableFont.COURIER, 11);
            WritableCellFormat wcf_center = new WritableCellFormat(NormalFont);
            wcf_center.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_center.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf_center.setAlignment(Alignment.CENTRE);
            wcf_center.setWrap(true);  //  �Ƿ���

            // ----��ֵ��ʽ ���Ҷ���---
            NumberFormat nf = new NumberFormat("#,###,###,##0.00");
            NumberFormat nf_rate = new NumberFormat("#,###,###,##0.000000");
            WritableCellFormat wcf_right = new WritableCellFormat(nf);
            WritableCellFormat wcf_right_rate = new WritableCellFormat(nf_rate);
            wcf_right.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.NO_BOLD, false));
            wcf_right_rate.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.NO_BOLD, false));

            // ����������
            WritableCellFormat wcf_bold_center = new WritableCellFormat(new WritableFont(WritableFont.COURIER, 11, WritableFont.BOLD, false));
            wcf_bold_center.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_bold_center.setAlignment(Alignment.CENTRE);
            wcf_bold_center.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf_bold_center.setWrap(true);  //  �Ƿ���

            // ----������ʾ--
            WritableCellFormat wcf_bold_right = new WritableCellFormat(nf);
            wcf_bold_right.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.BOLD, false));
            wcf_bold_right.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_bold_right.setAlignment(Alignment.RIGHT);
            wcf_bold_right.setVerticalAlignment(VerticalAlignment.CENTRE);
            WritableCellFormat wcf_bold_right_rate = new WritableCellFormat(nf_rate);
            wcf_bold_right_rate.setFont(new WritableFont(WritableFont.COURIER, 11, WritableFont.BOLD, false));
            wcf_bold_right_rate.setBorder(Border.ALL, BorderLineStyle.THIN);
            wcf_bold_right_rate.setAlignment(Alignment.RIGHT);
            wcf_bold_right_rate.setVerticalAlignment(VerticalAlignment.CENTRE);

            // �߿���ʽ
            wcf_right.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);
            wcf_right.setWrap(false);
            wcf_right.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf_right.setAlignment(Alignment.RIGHT);
            wcf_right_rate.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);
            wcf_right_rate.setWrap(false);
            wcf_right_rate.setVerticalAlignment(VerticalAlignment.CENTRE);
            wcf_right_rate.setAlignment(Alignment.RIGHT);

            // �и�
            int rowHeight = 1000;
            // ��ʼ��
            int beginRow = 4;
            // ��ʼ��
            int beginCol = 1;

            //��ͷ
            String startdate = request.getParameter("CUST_OPEN_DT").trim();
            String enddate = request.getParameter("CUST_OPEN_DT2").trim();
            ws.setRowView(2, 600, false);

            jxl.format.CellFormat fmtPt = ws.getCell(1, 2).getCellFormat();

            startdate = startdate.substring(0, 4) + "��" + Integer.parseInt(startdate.substring(5, 7)) + "��" + Integer.parseInt(startdate.substring(8, 10)) + "��";
            enddate = enddate.substring(0, 4) + "��" + Integer.parseInt(enddate.substring(5, 7)) + "��" + Integer.parseInt(enddate.substring(8, 10)) + "��";
            Label lbl_t = new Label(1, 2, startdate + "-" + enddate, fmtPt);
            ws.addCell(lbl_t);

            //===================================================================
            // ���ѯ���������ַ���
            String whereStr = " where 1=1  and t.LOANSTATE is not null and t.LOANSTATE <> '0'  ";
            if (!request.getParameter("CUST_OPEN_DT").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT >='" + request.getParameter("CUST_OPEN_DT").trim() + "'";
            }
            if (!request.getParameter("CUST_OPEN_DT2").trim().equals("")) {
                whereStr += " and t.CUST_OPEN_DT <='" + request.getParameter("CUST_OPEN_DT2").trim() + "'";
            }

            List<String> itemtitleList = new ArrayList<String>();
            List<String> itemcriteriaList = new ArrayList<String>();

            DatabaseConnection conn = ConnectionManager.getInstance().get();
            //��ȡ����Ŀ����
            getItemConfig(itemtitleList, itemcriteriaList, conn);

            StringBuffer detailSql = new StringBuffer();
            //��ϸ����
            int itemSize = assembleSql(deptId, whereStr, itemcriteriaList, detailSql);

            String sql = detailSql.toString();
            System.out.println("sql=" + sql);

            RecordSet rs = conn.executeQuery(sql);

            //������������Ļ�������)
            int deptCount = 0;
            // �����������������
            int sheetRowCount = 0;

            while (rs.next()) {
                sheetRowCount = deptCount * itemSize;
                if (deptCount > 0) {
                    sheetRowCount = sheetRowCount - deptCount;
                }
                // ����������
                String bankName = rs.getString("bankname");
                int k = 0;
                for (String title : itemtitleList) {
                    outputOneXlsRow(title, ws, rs, deptCount, sheetRowCount, rowHeight, beginRow, k, beginCol, wcf_center, wcf_right, wcf_right_rate, bankName);
                    k++;
                }
                ws.mergeCells(beginCol, deptCount + beginRow + sheetRowCount, beginCol, deptCount + beginRow + itemSize - 1  + sheetRowCount);
                deptCount++;
            }

            //----��������������������ϼ�----------------------------------------------------------------
            rs = conn.executeQuery("select deptname, fillstr10 from ptdept where deptid='" + deptId + "'");
            String deptNameTmp = "";
            String deptLevel = "";
            while (rs.next()) {
                deptNameTmp = rs.getString(0);
                deptLevel = rs.getString(1);
            }
            //�ڵ�ǰ����Ϊ����ʱ��������ֱ�������Ļ��� (���������������� ���������)
            if (StringUtils.isNotEmpty(deptLevel) && "1".equals(deptLevel)) {
                rs = conn.executeQuery("select deptid, deptname from ptdept where fillstr10='3' and fillstr20 is not null");
                while (rs.next()) {
                    String deptIdTmp = rs.getString(0);
                    deptNameTmp = rs.getString(1);
                    deptCount = outputOneDeptTotal(deptIdTmp, ws, wcf_bold_center, wcf_bold_right, wcf_bold_right_rate,rowHeight, beginRow, beginCol, whereStr, itemtitleList, itemcriteriaList, conn, itemSize, deptCount, deptNameTmp);
                }
            }
            //�ڵ�ǰ����Ϊ����ֱ������ʱ��ֻ�����ǰ�����ĺϼ�
            if (StringUtils.isNotEmpty(deptLevel) && "3".equals(deptLevel)) {
                deptCount = outputOneDeptTotal(deptId, ws, wcf_bold_center, wcf_bold_right, wcf_bold_right_rate,rowHeight, beginRow, beginCol, whereStr, itemtitleList, itemcriteriaList, conn, itemSize, deptCount, deptNameTmp);
            }

            //----�̶�����з��кϼ�-------------------------------------------------------------------------
            deptCount = outputOneDeptTotal("371980000", ws, wcf_bold_center, wcf_bold_right, wcf_bold_right_rate,rowHeight, beginRow, beginCol, whereStr, itemtitleList, itemcriteriaList, conn, itemSize, deptCount, "�з���");


            wwb.write();
            wwb.close();
            rw.close();
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

<%!
    //ͨ��deptid ����˻����Ļ�����Ϣ
    private int outputOneDeptTotal(String deptId, WritableSheet ws, WritableCellFormat wcf_bold_center,
                                   WritableCellFormat wcf_bold_right,
                                   WritableCellFormat wcf_bold_right_rate,
                                   int rowHeight, int beginRow, int beginCol,
                                   String whereStr,
                                   List<String> itemtitleList, List<String> itemcriteriaList,
                                   DatabaseConnection conn, int itemSize, int row, String deptName) throws WriteException {
        RecordSet rs;
        int cnt;
        StringBuilder totalSql = new StringBuilder("select sysdate");
        assembleSqlHeader(itemcriteriaList, totalSql);

        StringBuffer  detailSql = new StringBuffer();
        assembleSql(deptId, whereStr, itemcriteriaList, detailSql);
        totalSql.append(" from (" + detailSql.toString() + ")");
        //�ϼ�ʱ�õ��Ļ����嵥
        String totalDeptName = deptName + "(�ϼ�)";

        String sql = totalSql.toString();
        System.out.println("totalsql=" + sql);

        rs = conn.executeQuery(sql);
        while (rs.next()) {
            cnt = row * itemSize;
            if (row > 0) {
                cnt = cnt - row;
            }
            int k = 0;
            for (String title : itemtitleList) {
                outputOneXlsRow(title, ws, rs, row, cnt, rowHeight, beginRow, k, beginCol, wcf_bold_center, wcf_bold_right, wcf_bold_right_rate, totalDeptName);
                k++;
            }
            ws.mergeCells(beginCol, row + beginRow + cnt, beginCol, row + beginRow + itemSize - 1  + cnt);
            row++;
        }
        return row;
    }

    private void assembleSqlHeader(List<String> itemcriteriaList, StringBuilder totalSql) {
        int step = 0;
        for (String criterion : itemcriteriaList) {
            step++;
            totalSql.append(",sum(amt" + step + ") as amt" + step);
            totalSql.append(", decode(sum(amt" +
                    step + "), 0, 0, " +
                    " round(sum(totalrate" + step + ")/sum(amt" + step + "),6))" +
                    " as rate" + step + " ");
            totalSql.append(", decode(sum(amt" +
                    step + "), 0, 0, " +
                    " round(sum(totalwrate" + step + ")/sum(amt" + step + "),6))" +
                    " as wrate" + step + " ");
        }
    }

    private int assembleSql(String deptId, String whereStr, List<String> itemcriteriaList, StringBuffer selectSQl) {
        int step = 0;
        //ͳ����Ŀ��
        int itemSize = 0;
        selectSQl.append("select bankid,bankname");
        for (String criterion : itemcriteriaList) {
            step++;
            itemSize++;
            selectSQl.append(",amt" + step);
            selectSQl.append(",(case when amt" +  step + "=0 then 0 else round(rate" + step + "/amt" + step + ",6) end)as rate" + step + " ");
            selectSQl.append(",(case when amt" +  step + "=0 then 0 else round(wrate" + step + "/amt" + step + ",6) end)as wrate" + step + " ");
            selectSQl.append(",rate" + step + " as totalrate" + step);
            selectSQl.append(",wrate" + step + " as totalwrate" + step);
        }
        selectSQl.append(" from (select t.bankid, (select deptname from ptdept where deptid = t.bankid) as bankname ");
        step = 0;
        for (String criterion : itemcriteriaList) {
            step++;
            selectSQl.append(
                    " ,sum(case"
                            + "       when (" + criterion + ") then"
                            + "        rt_orig_loan_amt"
                            + "       else"
                            + "        null"
                            + "     end) as amt" + step

                            + "  ,sum(case"
                            + "       when (" + criterion + ") then"
                            + "        (interate)*rt_orig_loan_amt"
                            + "       else"
                            + "        null"
                            + "     end) as wrate" + step     //wrate=weighted rate  ��Ȩ����   20150104 zr

                            + "  ,sum(case"
                            + "       when (" + criterion + ") then"
                            + "        (interate/5.6)*rt_orig_loan_amt"
                            + "       else"
                            + "        null"
                            + "     end) as rate" + step
                            + " "
            );
        }
        selectSQl.append(" from ln_loanapply t ");
        selectSQl.append(whereStr + " and t.bankid in(select deptid from ptdept start with deptid='" + deptId + "' connect by prior deptid=parentdeptid) ");
        selectSQl.append(" group by bankid order by bankid) ");
        return itemSize;
    }

    private void getItemConfig(List<String> itemtitleList, List<String> itemcriteriaList, DatabaseConnection conn) {
        //ͳ�������������
        String configSql = "select t.enuitemlabel as itemtitle, t.enuitemdesc as itemcriteria" +
                "  from PTENUDETAIL t" +
                " where t.enutype = 'PAYBILL_INTRRATE' " +
                " order by t.enuitemvalue";
        RecordSet configRs = conn.executeQuery(configSql);

        while (configRs.next()) {
            String itemtitle = configRs.getString("itemtitle");
            String itemcriteria = configRs.getString("itemcriteria");
            itemcriteriaList.add(itemcriteria);
            itemtitleList.add(itemtitle);
        }
    }

    private void outputOneXlsRow(String RPTLABEL01,
                                 WritableSheet ws, RecordSet rs,
                                 int i, int cnt,
                                 int rowHeight,
                                 int beginRow, int rowOffset, int beginCol,
                                 WritableCellFormat wcf_center,
                                 WritableCellFormat wcf_right,
                                 WritableCellFormat wcf_right_rate,
                                 String bankName) throws WriteException {
        ws.setRowView(i + beginRow + rowOffset + cnt, rowHeight, false);
        // ��������
        Label lbl = new Label(beginCol, i + beginRow + rowOffset + cnt, bankName, wcf_center);
        ws.addCell(lbl);
        // ��������
        lbl = new Label(beginCol + 1, i + beginRow + rowOffset + cnt, RPTLABEL01, wcf_center);
        ws.addCell(lbl);
        // ��Ȩ���������
        Number nLbl = new Number(beginCol + 2, i + beginRow + rowOffset + cnt, rs.getDouble("wrate" + (rowOffset + 1)), wcf_right_rate);
        ws.addCell(nLbl);
        // ���������
        nLbl = new Number(beginCol + 3, i + beginRow + rowOffset + cnt, rs.getDouble("rate" + (rowOffset + 1)), wcf_right_rate);
        ws.addCell(nLbl);
        // ����Ŷ�
        nLbl = new Number(beginCol + 4, i + beginRow + rowOffset + cnt, rs.getDouble("amt" + (rowOffset + 1)), wcf_right);
        ws.addCell(nLbl);
    }
%>