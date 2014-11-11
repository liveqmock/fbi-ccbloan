package com.ccb.dao;
import java.util.*;
import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;
public class LNSPCLBUSINFO extends AbstractBasicBean implements Cloneable {
     public static List find(String sSqlWhere) {           return new LNSPCLBUSINFO().findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere) {           return new LNSPCLBUSINFO().findAndLockByWhere(sSqlWhere);      }       public static LNSPCLBUSINFO findFirst(String sSqlWhere) {           return (LNSPCLBUSINFO)new LNSPCLBUSINFO().findFirstByWhere(sSqlWhere);      }       public static LNSPCLBUSINFO findFirstAndLock(String sSqlWhere) {           return (LNSPCLBUSINFO)new LNSPCLBUSINFO().findFirstAndLockByWhere(sSqlWhere);      }            public static RecordSet findRecordSet(String sSqlWhere) {           return new LNSPCLBUSINFO().findRecordSetByWhere(sSqlWhere);      }       public static List find(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSINFO bean = new LNSPCLBUSINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSINFO bean = new LNSPCLBUSINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findAndLockByWhere(sSqlWhere);      }       public static LNSPCLBUSINFO findFirst(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSINFO bean = new LNSPCLBUSINFO();           bean.setAutoRelease(isAutoRelease);           return (LNSPCLBUSINFO)bean.findFirstByWhere(sSqlWhere);      }       public static LNSPCLBUSINFO findFirstAndLock(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSINFO bean = new LNSPCLBUSINFO();           bean.setAutoRelease(isAutoRelease);           return (LNSPCLBUSINFO)bean.findFirstAndLockByWhere(sSqlWhere);      }       public static RecordSet findRecordSet(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSINFO bean = new LNSPCLBUSINFO();           bean.setAutoRelease(isAutoRelease);           return bean.findRecordSetByWhere(sSqlWhere);      }      public static List findByRow(String sSqlWhere,int row) {           return new LNSPCLBUSINFO().findByWhereByRow(sSqlWhere,row);      } String flowsn;
String cust_name;
String ln_typ;
String bankid;
String cust_bankid;
String realcustmgr_id;
String custmgr_id;
String operid;
String operdate;
int recversion;
String remark;
String loanid;
String mortid;
String bustype;
public static final String TABLENAME ="ln_spclbus_info";
private String operate_mode = "add";
public ChangeFileds cf = new ChangeFileds();
public String getTableName() {return TABLENAME;}
public void addObject(List list,RecordSet rs) {
LNSPCLBUSINFO abb = new LNSPCLBUSINFO();
abb.flowsn=rs.getString("flowsn");abb.setKeyValue("FLOWSN",""+abb.getFlowsn());
abb.cust_name=rs.getString("cust_name");abb.setKeyValue("CUST_NAME",""+abb.getCust_name());
abb.ln_typ=rs.getString("ln_typ");abb.setKeyValue("LN_TYP",""+abb.getLn_typ());
abb.bankid=rs.getString("bankid");abb.setKeyValue("BANKID",""+abb.getBankid());
abb.cust_bankid=rs.getString("cust_bankid");abb.setKeyValue("CUST_BANKID",""+abb.getCust_bankid());
abb.realcustmgr_id=rs.getString("realcustmgr_id");abb.setKeyValue("REALCUSTMGR_ID",""+abb.getRealcustmgr_id());
abb.custmgr_id=rs.getString("custmgr_id");abb.setKeyValue("CUSTMGR_ID",""+abb.getCustmgr_id());
abb.operid=rs.getString("operid");abb.setKeyValue("OPERID",""+abb.getOperid());
abb.operdate=rs.getString("operdate");abb.setKeyValue("OPERDATE",""+abb.getOperdate());
abb.recversion=rs.getInt("recversion");abb.setKeyValue("RECVERSION",""+abb.getRecversion());
abb.remark=rs.getString("remark");abb.setKeyValue("REMARK",""+abb.getRemark());
abb.loanid=rs.getString("loanid");abb.setKeyValue("LOANID",""+abb.getLoanid());
abb.mortid=rs.getString("mortid");abb.setKeyValue("MORTID",""+abb.getMortid());
abb.bustype=rs.getString("bustype");abb.setKeyValue("BUSTYPE",""+abb.getBustype());
list.add(abb);
abb.operate_mode = "edit";
}public String getFlowsn() { if ( this.flowsn == null ) return ""; return this.flowsn;}
public String getCust_name() { if ( this.cust_name == null ) return ""; return this.cust_name;}
public String getLn_typ() { if ( this.ln_typ == null ) return ""; return this.ln_typ;}
public String getBankid() { if ( this.bankid == null ) return ""; return this.bankid;}
public String getCust_bankid() { if ( this.cust_bankid == null ) return ""; return this.cust_bankid;}
public String getRealcustmgr_id() { if ( this.realcustmgr_id == null ) return ""; return this.realcustmgr_id;}
public String getCustmgr_id() { if ( this.custmgr_id == null ) return ""; return this.custmgr_id;}
public String getOperid() { if ( this.operid == null ) return ""; return this.operid;}
public String getOperdate() { if ( this.operdate == null ) return ""; return this.operdate;}
public int getRecversion() { return this.recversion;}
public String getRemark() { if ( this.remark == null ) return ""; return this.remark;}
public String getLoanid() { if ( this.loanid == null ) return ""; return this.loanid;}
public String getMortid() { if ( this.mortid == null ) return ""; return this.mortid;}
public String getBustype() { if ( this.bustype == null ) return ""; return this.bustype;}
public void setFlowsn(String flowsn) { sqlMaker.setField("flowsn",flowsn,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getFlowsn().equals(flowsn)) cf.add("flowsn",this.flowsn,flowsn); } this.flowsn=flowsn;}
public void setCust_name(String cust_name) { sqlMaker.setField("cust_name",cust_name,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCust_name().equals(cust_name)) cf.add("cust_name",this.cust_name,cust_name); } this.cust_name=cust_name;}
public void setLn_typ(String ln_typ) { sqlMaker.setField("ln_typ",ln_typ,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLn_typ().equals(ln_typ)) cf.add("ln_typ",this.ln_typ,ln_typ); } this.ln_typ=ln_typ;}
public void setBankid(String bankid) { sqlMaker.setField("bankid",bankid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBankid().equals(bankid)) cf.add("bankid",this.bankid,bankid); } this.bankid=bankid;}
public void setCust_bankid(String cust_bankid) { sqlMaker.setField("cust_bankid",cust_bankid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCust_bankid().equals(cust_bankid)) cf.add("cust_bankid",this.cust_bankid,cust_bankid); } this.cust_bankid=cust_bankid;}
public void setRealcustmgr_id(String realcustmgr_id) { sqlMaker.setField("realcustmgr_id",realcustmgr_id,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getRealcustmgr_id().equals(realcustmgr_id)) cf.add("realcustmgr_id",this.realcustmgr_id,realcustmgr_id); } this.realcustmgr_id=realcustmgr_id;}
public void setCustmgr_id(String custmgr_id) { sqlMaker.setField("custmgr_id",custmgr_id,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCustmgr_id().equals(custmgr_id)) cf.add("custmgr_id",this.custmgr_id,custmgr_id); } this.custmgr_id=custmgr_id;}
public void setOperid(String operid) { sqlMaker.setField("operid",operid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperid().equals(operid)) cf.add("operid",this.operid,operid); } this.operid=operid;}
public void setOperdate(String operdate) { sqlMaker.setField("operdate",operdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperdate().equals(operdate)) cf.add("operdate",this.operdate,operdate); } this.operdate=operdate;}
public void setRecversion(int recversion) { sqlMaker.setField("recversion",""+recversion,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getRecversion()!=recversion) cf.add("recversion",this.recversion+"",recversion+""); } this.recversion=recversion;}
public void setRemark(String remark) { sqlMaker.setField("remark",remark,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getRemark().equals(remark)) cf.add("remark",this.remark,remark); } this.remark=remark;}
public void setLoanid(String loanid) { sqlMaker.setField("loanid",loanid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLoanid().equals(loanid)) cf.add("loanid",this.loanid,loanid); } this.loanid=loanid;}
public void setMortid(String mortid) { sqlMaker.setField("mortid",mortid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMortid().equals(mortid)) cf.add("mortid",this.mortid,mortid); } this.mortid=mortid;}
public void setBustype(String bustype) { sqlMaker.setField("bustype",bustype,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBustype().equals(bustype)) cf.add("bustype",this.bustype,bustype); } this.bustype=bustype;}
public void init(int i,ActionRequest actionRequest) throws Exception { if ( actionRequest.getFieldValue(i,"flowsn") !=null ) {this.setFlowsn(actionRequest.getFieldValue(i,"flowsn"));}
if ( actionRequest.getFieldValue(i,"cust_name") !=null ) {this.setCust_name(actionRequest.getFieldValue(i,"cust_name"));}
if ( actionRequest.getFieldValue(i,"ln_typ") !=null ) {this.setLn_typ(actionRequest.getFieldValue(i,"ln_typ"));}
if ( actionRequest.getFieldValue(i,"bankid") !=null ) {this.setBankid(actionRequest.getFieldValue(i,"bankid"));}
if ( actionRequest.getFieldValue(i,"cust_bankid") !=null ) {this.setCust_bankid(actionRequest.getFieldValue(i,"cust_bankid"));}
if ( actionRequest.getFieldValue(i,"realcustmgr_id") !=null ) {this.setRealcustmgr_id(actionRequest.getFieldValue(i,"realcustmgr_id"));}
if ( actionRequest.getFieldValue(i,"custmgr_id") !=null ) {this.setCustmgr_id(actionRequest.getFieldValue(i,"custmgr_id"));}
if ( actionRequest.getFieldValue(i,"operid") !=null ) {this.setOperid(actionRequest.getFieldValue(i,"operid"));}
if ( actionRequest.getFieldValue(i,"operdate") !=null ) {this.setOperdate(actionRequest.getFieldValue(i,"operdate"));}
if ( actionRequest.getFieldValue(i,"recversion") !=null && actionRequest.getFieldValue(i,"recversion").trim().length() > 0 ) {this.setRecversion(Integer.parseInt(actionRequest.getFieldValue(i,"recversion")));}
if ( actionRequest.getFieldValue(i,"remark") !=null ) {this.setRemark(actionRequest.getFieldValue(i,"remark"));}
if ( actionRequest.getFieldValue(i,"loanid") !=null ) {this.setLoanid(actionRequest.getFieldValue(i,"loanid"));}
if ( actionRequest.getFieldValue(i,"mortid") !=null ) {this.setMortid(actionRequest.getFieldValue(i,"mortid"));}
if ( actionRequest.getFieldValue(i,"bustype") !=null ) {this.setBustype(actionRequest.getFieldValue(i,"bustype"));}
}public void init(ActionRequest actionRequest) throws Exception { this.init(0,actionRequest);}public void initAll(int i,ActionRequest actionRequest) throws Exception { this.init(i,actionRequest);}public void initAll(ActionRequest actionRequest) throws Exception { this.initAll(0,actionRequest);}public Object clone() throws CloneNotSupportedException { LNSPCLBUSINFO obj = (LNSPCLBUSINFO)super.clone();obj.setFlowsn(obj.flowsn);
obj.setCust_name(obj.cust_name);
obj.setLn_typ(obj.ln_typ);
obj.setBankid(obj.bankid);
obj.setCust_bankid(obj.cust_bankid);
obj.setRealcustmgr_id(obj.realcustmgr_id);
obj.setCustmgr_id(obj.custmgr_id);
obj.setOperid(obj.operid);
obj.setOperdate(obj.operdate);
obj.setRecversion(obj.recversion);
obj.setRemark(obj.remark);
obj.setLoanid(obj.loanid);
obj.setMortid(obj.mortid);
obj.setBustype(obj.bustype);
return obj;}}