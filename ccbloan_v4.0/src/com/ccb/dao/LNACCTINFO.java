package com.ccb.dao;
import java.util.*;
import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;
public class LNACCTINFO extends AbstractBasicBean implements Cloneable {
     public static List find(String sSqlWhere) {           return new LNACCTINFO().findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere) {           return new LNACCTINFO().findAndLockByWhere(sSqlWhere);      }       public static LNACCTINFO findFirst(String sSqlWhere) {           return (LNACCTINFO)new LNACCTINFO().findFirstByWhere(sSqlWhere);      }       public static LNACCTINFO findFirstAndLock(String sSqlWhere) {           return (LNACCTINFO)new LNACCTINFO().findFirstAndLockByWhere(sSqlWhere);      }            public static RecordSet findRecordSet(String sSqlWhere) {           return new LNACCTINFO().findRecordSetByWhere(sSqlWhere);      }       public static List find(String sSqlWhere,boolean isAutoRelease) {           LNACCTINFO bean = new LNACCTINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere,boolean isAutoRelease) {           LNACCTINFO bean = new LNACCTINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findAndLockByWhere(sSqlWhere);      }       public static LNACCTINFO findFirst(String sSqlWhere,boolean isAutoRelease) {           LNACCTINFO bean = new LNACCTINFO();           bean.setAutoRelease(isAutoRelease);           return (LNACCTINFO)bean.findFirstByWhere(sSqlWhere);      }       public static LNACCTINFO findFirstAndLock(String sSqlWhere,boolean isAutoRelease) {           LNACCTINFO bean = new LNACCTINFO();           bean.setAutoRelease(isAutoRelease);           return (LNACCTINFO)bean.findFirstAndLockByWhere(sSqlWhere);      }       public static RecordSet findRecordSet(String sSqlWhere,boolean isAutoRelease) {           LNACCTINFO bean = new LNACCTINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findRecordSetByWhere(sSqlWhere);      }      public static List findByRow(String sSqlWhere,int row) {           return new LNACCTINFO().findByWhereByRow(sSqlWhere,row);      } String acct_id;
String acct_name;
String loanid;
String acct_no;
String acct_bank;
double acct_amt;
String pay_date;
String appt_type;
String pay_flag;
String report_flag;
String print_flag;
String cancel_flag;
int recversion;
String remark;
String operid;
String operdate;
String pay_operid;
String pay_operdate;
String deptid;
String print_time;
public static final String TABLENAME ="ln_acctinfo";
private String operate_mode = "add";
public ChangeFileds cf = new ChangeFileds();
public String getTableName() {return TABLENAME;}
public void addObject(List list,RecordSet rs) {
LNACCTINFO abb = new LNACCTINFO();
abb.acct_id=rs.getString("acct_id");abb.setKeyValue("ACCT_ID",""+abb.getAcct_id());
abb.acct_name=rs.getString("acct_name");abb.setKeyValue("ACCT_NAME",""+abb.getAcct_name());
abb.loanid=rs.getString("loanid");abb.setKeyValue("LOANID",""+abb.getLoanid());
abb.acct_no=rs.getString("acct_no");abb.setKeyValue("ACCT_NO",""+abb.getAcct_no());
abb.acct_bank=rs.getString("acct_bank");abb.setKeyValue("ACCT_BANK",""+abb.getAcct_bank());
abb.acct_amt=rs.getDouble("acct_amt");abb.setKeyValue("ACCT_AMT",""+abb.getAcct_amt());
abb.pay_date=rs.getString("pay_date");abb.setKeyValue("PAY_DATE",""+abb.getPay_date());
abb.appt_type=rs.getString("appt_type");abb.setKeyValue("APPT_TYPE",""+abb.getAppt_type());
abb.pay_flag=rs.getString("pay_flag");abb.setKeyValue("PAY_FLAG",""+abb.getPay_flag());
abb.report_flag=rs.getString("report_flag");abb.setKeyValue("REPORT_FLAG",""+abb.getReport_flag());
abb.print_flag=rs.getString("print_flag");abb.setKeyValue("PRINT_FLAG",""+abb.getPrint_flag());
abb.cancel_flag=rs.getString("cancel_flag");abb.setKeyValue("CANCEL_FLAG",""+abb.getCancel_flag());
abb.recversion=rs.getInt("recversion");abb.setKeyValue("RECVERSION",""+abb.getRecversion());
abb.remark=rs.getString("remark");abb.setKeyValue("REMARK",""+abb.getRemark());
abb.operid=rs.getString("operid");abb.setKeyValue("OPERID",""+abb.getOperid());
abb.operdate=rs.getString("operdate");abb.setKeyValue("OPERDATE",""+abb.getOperdate());
abb.pay_operid=rs.getString("pay_operid");abb.setKeyValue("PAY_OPERID",""+abb.getPay_operid());
abb.pay_operdate=rs.getString("pay_operdate");abb.setKeyValue("PAY_OPERDATE",""+abb.getPay_operdate());
abb.deptid=rs.getString("deptid");abb.setKeyValue("DEPTID",""+abb.getDeptid());
abb.print_time=rs.getString("print_time");abb.setKeyValue("PRINT_TIME",""+abb.getPrint_time());
list.add(abb);
abb.operate_mode = "edit";
}public String getAcct_id() { if ( this.acct_id == null ) return ""; return this.acct_id;}
public String getAcct_name() { if ( this.acct_name == null ) return ""; return this.acct_name;}
public String getLoanid() { if ( this.loanid == null ) return ""; return this.loanid;}
public String getAcct_no() { if ( this.acct_no == null ) return ""; return this.acct_no;}
public String getAcct_bank() { if ( this.acct_bank == null ) return ""; return this.acct_bank;}
public double getAcct_amt() { return this.acct_amt;}
public String getPay_date() { if ( this.pay_date == null ) return ""; return this.pay_date;}
public String getAppt_type() { if ( this.appt_type == null ) return ""; return this.appt_type;}
public String getPay_flag() { if ( this.pay_flag == null ) return ""; return this.pay_flag;}
public String getReport_flag() { if ( this.report_flag == null ) return ""; return this.report_flag;}
public String getPrint_flag() { if ( this.print_flag == null ) return ""; return this.print_flag;}
public String getCancel_flag() { if ( this.cancel_flag == null ) return ""; return this.cancel_flag;}
public int getRecversion() { return this.recversion;}
public String getRemark() { if ( this.remark == null ) return ""; return this.remark;}
public String getOperid() { if ( this.operid == null ) return ""; return this.operid;}
public String getOperdate() { if ( this.operdate == null ) return ""; return this.operdate;}
public String getPay_operid() { if ( this.pay_operid == null ) return ""; return this.pay_operid;}
public String getPay_operdate() { if ( this.pay_operdate == null ) return ""; return this.pay_operdate;}
public String getDeptid() { if ( this.deptid == null ) return ""; return this.deptid;}
public String getPrint_time() { if ( this.print_time == null ) return ""; return this.print_time;}
public void setAcct_id(String acct_id) { sqlMaker.setField("acct_id",acct_id,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAcct_id().equals(acct_id)) cf.add("acct_id",this.acct_id,acct_id); } this.acct_id=acct_id;}
public void setAcct_name(String acct_name) { sqlMaker.setField("acct_name",acct_name,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAcct_name().equals(acct_name)) cf.add("acct_name",this.acct_name,acct_name); } this.acct_name=acct_name;}
public void setLoanid(String loanid) { sqlMaker.setField("loanid",loanid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLoanid().equals(loanid)) cf.add("loanid",this.loanid,loanid); } this.loanid=loanid;}
public void setAcct_no(String acct_no) { sqlMaker.setField("acct_no",acct_no,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAcct_no().equals(acct_no)) cf.add("acct_no",this.acct_no,acct_no); } this.acct_no=acct_no;}
public void setAcct_bank(String acct_bank) { sqlMaker.setField("acct_bank",acct_bank,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAcct_bank().equals(acct_bank)) cf.add("acct_bank",this.acct_bank,acct_bank); } this.acct_bank=acct_bank;}
public void setAcct_amt(double acct_amt) { sqlMaker.setField("acct_amt",""+acct_amt,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getAcct_amt()!=acct_amt) cf.add("acct_amt",this.acct_amt+"",acct_amt+""); } this.acct_amt=acct_amt;}
public void setPay_date(String pay_date) { sqlMaker.setField("pay_date",pay_date,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPay_date().equals(pay_date)) cf.add("pay_date",this.pay_date,pay_date); } this.pay_date=pay_date;}
public void setAppt_type(String appt_type) { sqlMaker.setField("appt_type",appt_type,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAppt_type().equals(appt_type)) cf.add("appt_type",this.appt_type,appt_type); } this.appt_type=appt_type;}
public void setPay_flag(String pay_flag) { sqlMaker.setField("pay_flag",pay_flag,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPay_flag().equals(pay_flag)) cf.add("pay_flag",this.pay_flag,pay_flag); } this.pay_flag=pay_flag;}
public void setReport_flag(String report_flag) { sqlMaker.setField("report_flag",report_flag,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getReport_flag().equals(report_flag)) cf.add("report_flag",this.report_flag,report_flag); } this.report_flag=report_flag;}
public void setPrint_flag(String print_flag) { sqlMaker.setField("print_flag",print_flag,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPrint_flag().equals(print_flag)) cf.add("print_flag",this.print_flag,print_flag); } this.print_flag=print_flag;}
public void setCancel_flag(String cancel_flag) { sqlMaker.setField("cancel_flag",cancel_flag,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCancel_flag().equals(cancel_flag)) cf.add("cancel_flag",this.cancel_flag,cancel_flag); } this.cancel_flag=cancel_flag;}
public void setRecversion(int recversion) { sqlMaker.setField("recversion",""+recversion,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getRecversion()!=recversion) cf.add("recversion",this.recversion+"",recversion+""); } this.recversion=recversion;}
public void setRemark(String remark) { sqlMaker.setField("remark",remark,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getRemark().equals(remark)) cf.add("remark",this.remark,remark); } this.remark=remark;}
public void setOperid(String operid) { sqlMaker.setField("operid",operid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperid().equals(operid)) cf.add("operid",this.operid,operid); } this.operid=operid;}
public void setOperdate(String operdate) { sqlMaker.setField("operdate",operdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperdate().equals(operdate)) cf.add("operdate",this.operdate,operdate); } this.operdate=operdate;}
public void setPay_operid(String pay_operid) { sqlMaker.setField("pay_operid",pay_operid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPay_operid().equals(pay_operid)) cf.add("pay_operid",this.pay_operid,pay_operid); } this.pay_operid=pay_operid;}
public void setPay_operdate(String pay_operdate) { sqlMaker.setField("pay_operdate",pay_operdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPay_operdate().equals(pay_operdate)) cf.add("pay_operdate",this.pay_operdate,pay_operdate); } this.pay_operdate=pay_operdate;}
public void setDeptid(String deptid) { sqlMaker.setField("deptid",deptid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getDeptid().equals(deptid)) cf.add("deptid",this.deptid,deptid); } this.deptid=deptid;}
public void setPrint_time(String print_time) { sqlMaker.setField("print_time",print_time,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getPrint_time().equals(print_time)) cf.add("print_time",this.print_time,print_time); } this.print_time=print_time;}
public void init(int i,ActionRequest actionRequest) throws Exception { if ( actionRequest.getFieldValue(i,"acct_id") !=null ) {this.setAcct_id(actionRequest.getFieldValue(i,"acct_id"));}
if ( actionRequest.getFieldValue(i,"acct_name") !=null ) {this.setAcct_name(actionRequest.getFieldValue(i,"acct_name"));}
if ( actionRequest.getFieldValue(i,"loanid") !=null ) {this.setLoanid(actionRequest.getFieldValue(i,"loanid"));}
if ( actionRequest.getFieldValue(i,"acct_no") !=null ) {this.setAcct_no(actionRequest.getFieldValue(i,"acct_no"));}
if ( actionRequest.getFieldValue(i,"acct_bank") !=null ) {this.setAcct_bank(actionRequest.getFieldValue(i,"acct_bank"));}
if ( actionRequest.getFieldValue(i,"acct_amt") !=null && actionRequest.getFieldValue(i,"acct_amt").trim().length() > 0 ) {this.setAcct_amt(Double.parseDouble(actionRequest.getFieldValue(i,"acct_amt")));}
if ( actionRequest.getFieldValue(i,"pay_date") !=null ) {this.setPay_date(actionRequest.getFieldValue(i,"pay_date"));}
if ( actionRequest.getFieldValue(i,"appt_type") !=null ) {this.setAppt_type(actionRequest.getFieldValue(i,"appt_type"));}
if ( actionRequest.getFieldValue(i,"pay_flag") !=null ) {this.setPay_flag(actionRequest.getFieldValue(i,"pay_flag"));}
if ( actionRequest.getFieldValue(i,"report_flag") !=null ) {this.setReport_flag(actionRequest.getFieldValue(i,"report_flag"));}
if ( actionRequest.getFieldValue(i,"print_flag") !=null ) {this.setPrint_flag(actionRequest.getFieldValue(i,"print_flag"));}
if ( actionRequest.getFieldValue(i,"cancel_flag") !=null ) {this.setCancel_flag(actionRequest.getFieldValue(i,"cancel_flag"));}
if ( actionRequest.getFieldValue(i,"recversion") !=null && actionRequest.getFieldValue(i,"recversion").trim().length() > 0 ) {this.setRecversion(Integer.parseInt(actionRequest.getFieldValue(i,"recversion")));}
if ( actionRequest.getFieldValue(i,"remark") !=null ) {this.setRemark(actionRequest.getFieldValue(i,"remark"));}
if ( actionRequest.getFieldValue(i,"operid") !=null ) {this.setOperid(actionRequest.getFieldValue(i,"operid"));}
if ( actionRequest.getFieldValue(i,"operdate") !=null ) {this.setOperdate(actionRequest.getFieldValue(i,"operdate"));}
if ( actionRequest.getFieldValue(i,"pay_operid") !=null ) {this.setPay_operid(actionRequest.getFieldValue(i,"pay_operid"));}
if ( actionRequest.getFieldValue(i,"pay_operdate") !=null ) {this.setPay_operdate(actionRequest.getFieldValue(i,"pay_operdate"));}
if ( actionRequest.getFieldValue(i,"deptid") !=null ) {this.setDeptid(actionRequest.getFieldValue(i,"deptid"));}
if ( actionRequest.getFieldValue(i,"print_time") !=null ) {this.setPrint_time(actionRequest.getFieldValue(i,"print_time"));}
}public void init(ActionRequest actionRequest) throws Exception { this.init(0,actionRequest);}public void initAll(int i,ActionRequest actionRequest) throws Exception { this.init(i,actionRequest);}public void initAll(ActionRequest actionRequest) throws Exception { this.initAll(0,actionRequest);}public Object clone() throws CloneNotSupportedException { LNACCTINFO obj = (LNACCTINFO)super.clone();obj.setAcct_id(obj.acct_id);
obj.setAcct_name(obj.acct_name);
obj.setLoanid(obj.loanid);
obj.setAcct_no(obj.acct_no);
obj.setAcct_bank(obj.acct_bank);
obj.setAcct_amt(obj.acct_amt);
obj.setPay_date(obj.pay_date);
obj.setAppt_type(obj.appt_type);
obj.setPay_flag(obj.pay_flag);
obj.setReport_flag(obj.report_flag);
obj.setPrint_flag(obj.print_flag);
obj.setCancel_flag(obj.cancel_flag);
obj.setRecversion(obj.recversion);
obj.setRemark(obj.remark);
obj.setOperid(obj.operid);
obj.setOperdate(obj.operdate);
obj.setPay_operid(obj.pay_operid);
obj.setPay_operdate(obj.pay_operdate);
obj.setDeptid(obj.deptid);
obj.setPrint_time(obj.print_time);
return obj;}}