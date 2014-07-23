package com.ccb.dao;
import java.util.*;
import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;
public class LNODSBREPAYACCTPMIS extends AbstractBasicBean implements Cloneable {
     public static List find(String sSqlWhere) {           return new LNODSBREPAYACCTPMIS().findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere) {           return new LNODSBREPAYACCTPMIS().findAndLockByWhere(sSqlWhere);      }       public static LNODSBREPAYACCTPMIS findFirst(String sSqlWhere) {           return (LNODSBREPAYACCTPMIS)new LNODSBREPAYACCTPMIS().findFirstByWhere(sSqlWhere);      }       public static LNODSBREPAYACCTPMIS findFirstAndLock(String sSqlWhere) {           return (LNODSBREPAYACCTPMIS)new LNODSBREPAYACCTPMIS().findFirstAndLockByWhere(sSqlWhere);      }            public static RecordSet findRecordSet(String sSqlWhere) {           return new LNODSBREPAYACCTPMIS().findRecordSetByWhere(sSqlWhere);      }       public static List find(String sSqlWhere,boolean isAutoRelease) {           LNODSBREPAYACCTPMIS bean = new LNODSBREPAYACCTPMIS();           bean.setAutoRelease(isAutoRelease);           return bean.findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere,boolean isAutoRelease) {           LNODSBREPAYACCTPMIS bean = new LNODSBREPAYACCTPMIS();           bean.setAutoRelease(isAutoRelease);           return bean.findAndLockByWhere(sSqlWhere);      }       public static LNODSBREPAYACCTPMIS findFirst(String sSqlWhere,boolean isAutoRelease) {           LNODSBREPAYACCTPMIS bean = new LNODSBREPAYACCTPMIS();           bean.setAutoRelease(isAutoRelease);           return (LNODSBREPAYACCTPMIS)bean.findFirstByWhere(sSqlWhere);      }       public static LNODSBREPAYACCTPMIS findFirstAndLock(String sSqlWhere,boolean isAutoRelease) {           LNODSBREPAYACCTPMIS bean = new LNODSBREPAYACCTPMIS();           bean.setAutoRelease(isAutoRelease);           return (LNODSBREPAYACCTPMIS)bean.findFirstAndLockByWhere(sSqlWhere);      }       public static RecordSet findRecordSet(String sSqlWhere,boolean isAutoRelease) {           LNODSBREPAYACCTPMIS bean = new LNODSBREPAYACCTPMIS();           bean.setAutoRelease(isAutoRelease);           return bean.findRecordSetByWhere(sSqlWhere);      }      public static List findByRow(String sSqlWhere,int row) {           return new LNODSBREPAYACCTPMIS().findByWhereByRow(sSqlWhere,row);      } String loanid;
int num;
String ods_src_dt;
String subskind;
String fundcentno;
String manadept;
String subsacno;
String acname;
String awbk;
int subsorder;
String ods_load_dt;
public static final String TABLENAME ="ln_odsb_repay_acct_pmis";
private String operate_mode = "add";
public ChangeFileds cf = new ChangeFileds();
public String getTableName() {return TABLENAME;}
public void addObject(List list,RecordSet rs) {
LNODSBREPAYACCTPMIS abb = new LNODSBREPAYACCTPMIS();
abb.loanid=rs.getString("loanid");abb.setKeyValue("LOANID",""+abb.getLoanid());
abb.num=rs.getInt("num");abb.setKeyValue("NUM",""+abb.getNum());
abb.ods_src_dt=rs.getString("ods_src_dt");abb.setKeyValue("ODS_SRC_DT",""+abb.getOds_src_dt());
abb.subskind=rs.getString("subskind");abb.setKeyValue("SUBSKIND",""+abb.getSubskind());
abb.fundcentno=rs.getString("fundcentno");abb.setKeyValue("FUNDCENTNO",""+abb.getFundcentno());
abb.manadept=rs.getString("manadept");abb.setKeyValue("MANADEPT",""+abb.getManadept());
abb.subsacno=rs.getString("subsacno");abb.setKeyValue("SUBSACNO",""+abb.getSubsacno());
abb.acname=rs.getString("acname");abb.setKeyValue("ACNAME",""+abb.getAcname());
abb.awbk=rs.getString("awbk");abb.setKeyValue("AWBK",""+abb.getAwbk());
abb.subsorder=rs.getInt("subsorder");abb.setKeyValue("SUBSORDER",""+abb.getSubsorder());
abb.ods_load_dt=rs.getString("ods_load_dt");abb.setKeyValue("ODS_LOAD_DT",""+abb.getOds_load_dt());
list.add(abb);
abb.operate_mode = "edit";
}public String getLoanid() { if ( this.loanid == null ) return ""; return this.loanid;}
public int getNum() { return this.num;}
public String getOds_src_dt() { if ( this.ods_src_dt == null ) return ""; return this.ods_src_dt;}
public String getSubskind() { if ( this.subskind == null ) return ""; return this.subskind;}
public String getFundcentno() { if ( this.fundcentno == null ) return ""; return this.fundcentno;}
public String getManadept() { if ( this.manadept == null ) return ""; return this.manadept;}
public String getSubsacno() { if ( this.subsacno == null ) return ""; return this.subsacno;}
public String getAcname() { if ( this.acname == null ) return ""; return this.acname;}
public String getAwbk() { if ( this.awbk == null ) return ""; return this.awbk;}
public int getSubsorder() { return this.subsorder;}
public String getOds_load_dt() { if ( this.ods_load_dt == null ) return ""; return this.ods_load_dt;}
public void setLoanid(String loanid) { sqlMaker.setField("loanid",loanid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLoanid().equals(loanid)) cf.add("loanid",this.loanid,loanid); } this.loanid=loanid;}
public void setNum(int num) { sqlMaker.setField("num",""+num,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getNum()!=num) cf.add("num",this.num+"",num+""); } this.num=num;}
public void setOds_src_dt(String ods_src_dt) { sqlMaker.setField("ods_src_dt",ods_src_dt,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOds_src_dt().equals(ods_src_dt)) cf.add("ods_src_dt",this.ods_src_dt,ods_src_dt); } this.ods_src_dt=ods_src_dt;}
public void setSubskind(String subskind) { sqlMaker.setField("subskind",subskind,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getSubskind().equals(subskind)) cf.add("subskind",this.subskind,subskind); } this.subskind=subskind;}
public void setFundcentno(String fundcentno) { sqlMaker.setField("fundcentno",fundcentno,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getFundcentno().equals(fundcentno)) cf.add("fundcentno",this.fundcentno,fundcentno); } this.fundcentno=fundcentno;}
public void setManadept(String manadept) { sqlMaker.setField("manadept",manadept,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getManadept().equals(manadept)) cf.add("manadept",this.manadept,manadept); } this.manadept=manadept;}
public void setSubsacno(String subsacno) { sqlMaker.setField("subsacno",subsacno,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getSubsacno().equals(subsacno)) cf.add("subsacno",this.subsacno,subsacno); } this.subsacno=subsacno;}
public void setAcname(String acname) { sqlMaker.setField("acname",acname,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAcname().equals(acname)) cf.add("acname",this.acname,acname); } this.acname=acname;}
public void setAwbk(String awbk) { sqlMaker.setField("awbk",awbk,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAwbk().equals(awbk)) cf.add("awbk",this.awbk,awbk); } this.awbk=awbk;}
public void setSubsorder(int subsorder) { sqlMaker.setField("subsorder",""+subsorder,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getSubsorder()!=subsorder) cf.add("subsorder",this.subsorder+"",subsorder+""); } this.subsorder=subsorder;}
public void setOds_load_dt(String ods_load_dt) { sqlMaker.setField("ods_load_dt",ods_load_dt,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOds_load_dt().equals(ods_load_dt)) cf.add("ods_load_dt",this.ods_load_dt,ods_load_dt); } this.ods_load_dt=ods_load_dt;}
public void init(int i,ActionRequest actionRequest) throws Exception { if ( actionRequest.getFieldValue(i,"loanid") !=null ) {this.setLoanid(actionRequest.getFieldValue(i,"loanid"));}
if ( actionRequest.getFieldValue(i,"num") !=null && actionRequest.getFieldValue(i,"num").trim().length() > 0 ) {this.setNum(Integer.parseInt(actionRequest.getFieldValue(i,"num")));}
if ( actionRequest.getFieldValue(i,"ods_src_dt") !=null ) {this.setOds_src_dt(actionRequest.getFieldValue(i,"ods_src_dt"));}
if ( actionRequest.getFieldValue(i,"subskind") !=null ) {this.setSubskind(actionRequest.getFieldValue(i,"subskind"));}
if ( actionRequest.getFieldValue(i,"fundcentno") !=null ) {this.setFundcentno(actionRequest.getFieldValue(i,"fundcentno"));}
if ( actionRequest.getFieldValue(i,"manadept") !=null ) {this.setManadept(actionRequest.getFieldValue(i,"manadept"));}
if ( actionRequest.getFieldValue(i,"subsacno") !=null ) {this.setSubsacno(actionRequest.getFieldValue(i,"subsacno"));}
if ( actionRequest.getFieldValue(i,"acname") !=null ) {this.setAcname(actionRequest.getFieldValue(i,"acname"));}
if ( actionRequest.getFieldValue(i,"awbk") !=null ) {this.setAwbk(actionRequest.getFieldValue(i,"awbk"));}
if ( actionRequest.getFieldValue(i,"subsorder") !=null && actionRequest.getFieldValue(i,"subsorder").trim().length() > 0 ) {this.setSubsorder(Integer.parseInt(actionRequest.getFieldValue(i,"subsorder")));}
if ( actionRequest.getFieldValue(i,"ods_load_dt") !=null ) {this.setOds_load_dt(actionRequest.getFieldValue(i,"ods_load_dt"));}
}public void init(ActionRequest actionRequest) throws Exception { this.init(0,actionRequest);}public void initAll(int i,ActionRequest actionRequest) throws Exception { this.init(i,actionRequest);}public void initAll(ActionRequest actionRequest) throws Exception { this.initAll(0,actionRequest);}public Object clone() throws CloneNotSupportedException { LNODSBREPAYACCTPMIS obj = (LNODSBREPAYACCTPMIS)super.clone();obj.setLoanid(obj.loanid);
obj.setNum(obj.num);
obj.setOds_src_dt(obj.ods_src_dt);
obj.setSubskind(obj.subskind);
obj.setFundcentno(obj.fundcentno);
obj.setManadept(obj.manadept);
obj.setSubsacno(obj.subsacno);
obj.setAcname(obj.acname);
obj.setAwbk(obj.awbk);
obj.setSubsorder(obj.subsorder);
obj.setOds_load_dt(obj.ods_load_dt);
return obj;}}