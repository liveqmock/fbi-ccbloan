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
            String enddate = request.getParameter("MORTEXPIREDATE2");

            response.reset();
            response.setContentType("application/vnd.ms-excel");
            String exportName = new String("签约、回执放款抵押登记综合完成率.xls".getBytes(), "ISO8859-1");
            response.addHeader("Content-Disposition", "attachment; filename=" + exportName);
            // ----------------------------根据模板创建输出流----------------------------------------------------------------
            //得到报表模板
            String rptModelPath = PropertyManager.getProperty("REPORT_ROOTPATH");
            String rptTemplateName = rptModelPath + "loanAll.xls";
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

            String sql ="select h.parentdeptid as bankid,j.deptname as bankname,nvl(h.allCnt2011_1+i.allCnt2011_2,0) as allCnt2011," +
                    " nvl(h.nortnCnt2011_1+i.nortnCnt2011_2,0) as nortnCnt2011," +
                    " nvl(h.allCnt2012_1+i.allCnt2012_2,0) as allCnt2012,nvl(h.nortnCnt2012_1+i.nortnCnt2012_2,0) as nortnCnt2012" +
                    " from " +
                    " (select g.parentdeptid,sum(nvl(f.allCnt2011,0)) as allCnt2011_1 ,sum(nvl(f.nortnCnt2011,0)) as nortnCnt2011_1," +
                    "  sum(nvl(f.allCnt2012,0)) as allCnt2012_1,sum(nvl(f.nortnCnt2012,0)) as nortnCnt2012_1" +
                    "  from (select distinct a.deptid,a.parentdeptid,a.deptname from ptdept a ) g, " +
                    "  (select e.bankid,(select deptname from ptdept where deptid= e.bankid) as bankname, allCnt2011, " +
                    "  nortnCnt2011,allCnt2012, nortnCnt2012" +
                    "  from (select distinct a.deptid as bankid from ptdept a ) e," +
                    "  (select a.bankid, count(*) as nortnCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) a," +
                    "  (select a.bankid, count(*) as allCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) b," +
                    "  (select a.bankid, count(*) as nortnCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) c," +
                    "  (select a.bankid, count(*) as allCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) d" +
                    "          " +
                    "  where e.bankid = a.bankid(+) " +
                    "  and e.bankid = b.bankid(+)  " +
                    "  and e.bankid = c.bankid(+)  " +
                    "  and e.bankid = d.bankid(+)  " +
                    "  and (a.nortnCnt2011 is not null" +
                    "  or b.allCnt2011 is not null" +
                    "  or c.nortnCnt2012 is not null" +
                    "  or d.allCnt2012 is not null)" +
                    "  order by bankid )f" +
                    "  where g.deptid = f.bankid(+)" +
                    "  and g.parentdeptid not in('371981610','371980000','0','371981620')" +
                    "  group by g.parentdeptid) h," +
                    "  (select g.parentdeptid,sum(nvl(f.allCnt2011,0)) as allCnt2011_2 ,sum(nvl(f.nortnCnt2011,0)) as nortnCnt2011_2," +
                    "  sum(nvl(f.allCnt2012,0)) as allCnt2012_2,sum(nvl(f.nortnCnt2012,0)) as nortnCnt2012_2" +
                    "  from (select distinct a.deptid,a.parentdeptid,a.deptname from ptdept a ) g, " +
                    "  (select e.bankid,(select deptname from ptdept where deptid= e.bankid) as bankname, allCnt2011, " +
                    "  nortnCnt2011,allCnt2012, nortnCnt2012" +
                    "  from (select distinct a.deptid as bankid from ptdept a ) e," +
                    "  (select a.bankid, count(*) as nortnCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) a," +
                    "  (select a.bankid, count(*) as allCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) b," +
                    "  (select a.bankid, count(*) as nortnCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) c," +
                    "  (select a.bankid, count(*) as allCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) d" +
                    "          " +
                    "  where e.bankid = a.bankid(+) " +
                    "  and e.bankid = b.bankid(+)  " +
                    "  and e.bankid = c.bankid(+)  " +
                    "  and e.bankid = d.bankid(+)  " +
                    "  and (a.nortnCnt2011 is not null" +
                    "  or b.allCnt2011 is not null" +
                    "  or c.nortnCnt2012 is not null" +
                    "  or d.allCnt2012 is not null)" +
                    "  order by bankid )f" +
                    "  where g.parentdeptid = f.bankid(+)" +
                    "  and g.parentdeptid not in('371981610','371980000','0','371981620')" +
                    "  group by g.parentdeptid )i," +
                    "  (select deptid,deptname from ptdept)j" +
                    "" +
                    "  where h.parentdeptid = i.parentdeptid" +
                    "  and h.parentdeptid = j.deptid" +
                    "  union" +
                    "  select * from " +
                    "  (select e.bankid,(select deptname from ptdept where deptid= e.bankid) as bankname, allCnt2011, " +
                    "  nortnCnt2011,allCnt2012, nortnCnt2012" +
                    "  from (select distinct a.deptid as bankid from ptdept a ) e," +
                    "  (select a.bankid, count(*) as nortnCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) a," +
                    "  (select a.bankid, count(*) as allCnt2011" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt <= '"+startdate+"'" +
                    "  and a.cust_open_dt <> '1899-12-31'" +
                    "  group by a.bankid) b," +
                    "  (select a.bankid, count(*) as nortnCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and b.mortregstatus = 1" +
                    "  and b.nomortreasoncd not in( '08','17')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) c," +
                    "  (select a.bankid, count(*) as allCnt2012" +
                    "  from ln_loanapply a, ln_mortinfo b" +
                    "  where a.loanid = b.loanid" +
                    "  and a.rt_orig_loan_amt > 0" +
                    "  and b.releasecondcd in ('02','03')" +
                    "  and a.cust_open_dt >= '"+startdate+"'" +
                    "  and a.cust_open_dt < '"+enddate+"'" +
                    "  group by a.bankid) d" +
                    "          " +
                    "  where e.bankid = a.bankid(+) " +
                    "  and e.bankid = b.bankid(+)  " +
                    "  and e.bankid = c.bankid(+)  " +
                    "  and e.bankid = d.bankid(+)  " +
                    "  and (a.nortnCnt2011 is not null" +
                    "  or b.allCnt2011 is not null" +
                    "  or c.nortnCnt2012 is not null" +
                    "  or d.allCnt2012 is not null)" +
                    "  order by bankid) f" +
                    "  where f.bankid not in(select distinct parentdeptid from ptdept where parentdeptid not in('371981610','371980000','0','371981620'))" +
                    "  and f.bankid in (select distinct deptid from ptdept where parentdeptid in('371981610','371981620'))";

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
