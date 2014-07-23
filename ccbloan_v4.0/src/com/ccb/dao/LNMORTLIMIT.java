package com.ccb.dao;
import java.util.*;
import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;
public class LNMORTLIMIT extends AbstractBasicBean implements Cloneable {
     public static List find(String sSqlWhere) {           return new LNMORTLIMIT().findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere) {           return new LNMORTLIMIT().findAndLockByWhere(sSqlWhere);      }       public static LNMORTLIMIT findFirst(String sSqlWhere) {           return (LNMORTLIMIT)new LNMORTLIMIT().findFirstByWhere(sSqlWhere);      }       public static LNMORTLIMIT findFirstAndLock(String sSqlWhere) {           return (LNMORTLIMIT)new LNMORTLIMIT().findFirstAndLockByWhere(sSqlWhere);      }            public static RecordSet findRecordSet(String sSqlWhere) {           return new LNMORTLIMIT().findRecordSetByWhere(sSqlWhere);      }       public static List find(String sSqlWhere,boolean isAutoRelease) {           LNMORTLIMIT bean = new LNMORTLIMIT();           bean.setAutoRelease(isAutoRelease);           return bean.findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere,boolean isAutoRelease) {           LNMORTLIMIT bean = new LNMORTLIMIT();           bean.setAutoRelease(isAutoRelease);           return bean.findAndLockByWhere(sSqlWhere);      }       public static LNMORTLIMIT findFirst(String sSqlWhere,boolean isAutoRelease) {           LNMORTLIMIT bean = new LNMORTLIMIT();           bean.setAutoRelease(isAutoRelease);           return (LNMORTLIMIT)bean.findFirstByWhere(sSqlWhere);      }       public static LNMORTLIMIT findFirstAndLock(String sSqlWhere,boolean isAutoRelease) {           LNMORTLIMIT bean = new LNMORTLIMIT();           bean.setAutoRelease(isAutoRelease);           return (LNMORTLIMIT)bean.findFirstAndLockByWhere(sSqlWhere);      }       public static RecordSet findRecordSet(String sSqlWhere,boolean isAutoRelease) {           LNMORTLIMIT bean = new LNMORTLIMIT();           bean.setAutoRelease(isAutoRelease);           return bean.findRecordSetByWhere(sSqlWhere);      }      public static List findByRow(String sSqlWhere,int row) {           return new LNMORTLIMIT().findByWhereByRow(sSqlWhere,row);      } String mortecentercd;
String ln_typ;
int limitdate;
String operdate;
String operid;
int recversion;
public static final String TABLENAME ="ln_mortlimit";
private String operate_mode = "add";
public ChangeFileds cf = new ChangeFileds();
public String getTableName() {return TABLENAME;}
public void addObject(List list,RecordSet rs) {
LNMORTLIMIT abb = new LNMORTLIMIT();
abb.mortecentercd=rs.getString("mortecentercd");abb.setKeyValue("MORTECENTERCD",""+abb.getMortecentercd());
abb.ln_typ=rs.getString("ln_typ");abb.setKeyValue("LN_TYP",""+abb.getLn_typ());
abb.limitdate=rs.getInt("limitdate");abb.setKeyValue("LIMITDATE",""+abb.getLimitdate());
abb.operdate=rs.getTimeString("operdate");abb.setKeyValue("OPERDATE",""+abb.getOperdate());
abb.operid=rs.getString("operid");abb.setKeyValue("OPERID",""+abb.getOperid());
abb.recversion=rs.getInt("recversion");abb.setKeyValue("RECVERSION",""+abb.getRecversion());
list.add(abb);
abb.operate_mode = "edit";
}public String getMortecentercd() { if ( this.mortecentercd == null ) return ""; return this.mortecentercd;}
public String getLn_typ() { if ( this.ln_typ == null ) return ""; return this.ln_typ;}
public int getLimitdate() { return this.limitdate;}
public String getOperdate() {  if ( this.operdate == null ) { return ""; } else { return this.operdate.trim().split(" ")[0];} }public String getOperdateTime() {  if ( this.operdate == null ) return ""; return this.operdate.split("\\.")[0];}
public String getOperid() { if ( this.operid == null ) return ""; return this.operid;}
public int getRecversion() { return this.recversion;}
public void setMortecentercd(String mortecentercd) { sqlMaker.setField("mortecentercd",mortecentercd,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMortecentercd().equals(mortecentercd)) cf.add("mortecentercd",this.mortecentercd,mortecentercd); } this.mortecentercd=mortecentercd;}
public void setLn_typ(String ln_typ) { sqlMaker.setField("ln_typ",ln_typ,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLn_typ().equals(ln_typ)) cf.add("ln_typ",this.ln_typ,ln_typ); } this.ln_typ=ln_typ;}
public void setLimitdate(int limitdate) { sqlMaker.setField("limitdate",""+limitdate,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getLimitdate()!=limitdate) cf.add("limitdate",this.limitdate+"",limitdate+""); } this.limitdate=limitdate;}
public void setOperdate(String operdate) { sqlMaker.setField("operdate",operdate,Field.DATE); if (this.operate_mode.equals("edit")) { if (!this.getOperdate().equals(operdate)) cf.add("operdate",this.operdate,operdate); } this.operdate=operdate;}
public void setOperid(String operid) { sqlMaker.setField("operid",operid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperid().equals(operid)) cf.add("operid",this.operid,operid); } this.operid=operid;}
public void setRecversion(int recversion) { sqlMaker.setField("recversion",""+recversion,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getRecversion()!=recversion) cf.add("recversion",this.recversion+"",recversion+""); } this.recversion=recversion;}
public void init(int i,ActionRequest actionRequest) throws Exception { if ( actionRequest.getFieldValue(i,"mortecentercd") !=null ) {this.setMortecentercd(actionRequest.getFieldValue(i,"mortecentercd"));}
if ( actionRequest.getFieldValue(i,"ln_typ") !=null ) {this.setLn_typ(actionRequest.getFieldValue(i,"ln_typ"));}
if ( actionRequest.getFieldValue(i,"limitdate") !=null && actionRequest.getFieldValue(i,"limitdate").trim().length() > 0 ) {this.setLimitdate(Integer.parseInt(actionRequest.getFieldValue(i,"limitdate")));}
if ( actionRequest.getFieldValue(i,"operdate") !=null ) {this.setOperdate(actionRequest.getFieldValue(i,"operdate"));}
if ( actionRequest.getFieldValue(i,"operid") !=null ) {this.setOperid(actionRequest.getFieldValue(i,"operid"));}
if ( actionRequest.getFieldValue(i,"recversion") !=null && actionRequest.getFieldValue(i,"recversion").trim().length() > 0 ) {this.setRecversion(Integer.parseInt(actionRequest.getFieldValue(i,"recversion")));}
}public void init(ActionRequest actionRequest) throws Exception { this.init(0,actionRequest);}public void initAll(int i,ActionRequest actionRequest) throws Exception { this.init(i,actionRequest);}public void initAll(ActionRequest actionRequest) throws Exception { this.initAll(0,actionRequest);}public Object clone() throws CloneNotSupportedException { LNMORTLIMIT obj = (LNMORTLIMIT)super.clone();obj.setMortecentercd(obj.mortecentercd);
obj.setLn_typ(obj.ln_typ);
obj.setLimitdate(obj.limitdate);
obj.setOperdate(obj.operdate);
obj.setOperid(obj.operid);
obj.setRecversion(obj.recversion);
return obj;}}