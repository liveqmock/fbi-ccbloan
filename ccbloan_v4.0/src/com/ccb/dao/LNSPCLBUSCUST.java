package com.ccb.dao;
import java.util.*;
import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;
public class LNSPCLBUSCUST extends AbstractBasicBean implements Cloneable {
     public static List find(String sSqlWhere) {           return new LNSPCLBUSCUST().findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere) {           return new LNSPCLBUSCUST().findAndLockByWhere(sSqlWhere);      }       public static LNSPCLBUSCUST findFirst(String sSqlWhere) {           return (LNSPCLBUSCUST)new LNSPCLBUSCUST().findFirstByWhere(sSqlWhere);      }       public static LNSPCLBUSCUST findFirstAndLock(String sSqlWhere) {           return (LNSPCLBUSCUST)new LNSPCLBUSCUST().findFirstAndLockByWhere(sSqlWhere);      }            public static RecordSet findRecordSet(String sSqlWhere) {           return new LNSPCLBUSCUST().findRecordSetByWhere(sSqlWhere);      }       public static List find(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSCUST bean = new LNSPCLBUSCUST();           bean.setAutoRelease(isAutoRelease);           return bean.findByWhere(sSqlWhere);      }       public static List findAndLock(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSCUST bean = new LNSPCLBUSCUST();           bean.setAutoRelease(isAutoRelease);           return bean.findAndLockByWhere(sSqlWhere);      }       public static LNSPCLBUSCUST findFirst(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSCUST bean = new LNSPCLBUSCUST();           bean.setAutoRelease(isAutoRelease);           return (LNSPCLBUSCUST)bean.findFirstByWhere(sSqlWhere);      }       public static LNSPCLBUSCUST findFirstAndLock(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSCUST bean = new LNSPCLBUSCUST();           bean.setAutoRelease(isAutoRelease);           return (LNSPCLBUSCUST)bean.findFirstAndLockByWhere(sSqlWhere);      }       public static RecordSet findRecordSet(String sSqlWhere,boolean isAutoRelease) {           LNSPCLBUSCUST bean = new LNSPCLBUSCUST();           bean.setAutoRelease(isAutoRelease);           return bean.findRecordSetByWhere(sSqlWhere);      }      public static List findByRow(String sSqlWhere,int row) {           return new LNSPCLBUSCUST().findByWhereByRow(sSqlWhere,row);      } String custno;
String custname;
String bustype;
String bankid;
String operid;
String modifyoperid;
String loantype;
String applyid;
String applymarriage;
String matename;
String basisremark;
String operdate;
String changertype;
String changerid;
String changersex;
String changerage;
String changerunit;
String changeraddr;
String changertel;
String changerhousehold;
String changerculture;
String changermarriage;
String changerhealth;
double obmi;
double obfi;
int orginalperson;
double orginalavg;
String taxrate;
double changerincome;
double changerfamilyincome;
int changerfamilynum;
double changeravgincome;
String deir;
String taxregno;
String busilicno;
String orgcode;
String remark;
String applyidcardtype;
String applybirthday;
int applyage;
String applysex;
String applyaddr;
String applytel1;
String applytel2;
String applyothertel1;
String applyothertel2;
String applyregister;
String applyculture;
String applyhealth;
String applytel;
String addname1;
String addname2;
String mateidcard;
String matetel;
String modifydate;
String changername;
double orgrinlloanamt;
double loanintamt;
String changebgdate;
String changeenddate;
String createdate;
int seq;
double mateincome;
String beforebgdate;
String beforeenddate;
String operatingcenter;
String customermanager;
String agencies;
String marketingmanager;
String matesex;
public static final String TABLENAME ="ln_spclbus_cust";
private String operate_mode = "add";
public ChangeFileds cf = new ChangeFileds();
public String getTableName() {return TABLENAME;}
public void addObject(List list,RecordSet rs) {
LNSPCLBUSCUST abb = new LNSPCLBUSCUST();
abb.custno=rs.getString("custno");abb.setKeyValue("CUSTNO",""+abb.getCustno());
abb.custname=rs.getString("custname");abb.setKeyValue("CUSTNAME",""+abb.getCustname());
abb.bustype=rs.getString("bustype");abb.setKeyValue("BUSTYPE",""+abb.getBustype());
abb.bankid=rs.getString("bankid");abb.setKeyValue("BANKID",""+abb.getBankid());
abb.operid=rs.getString("operid");abb.setKeyValue("OPERID",""+abb.getOperid());
abb.modifyoperid=rs.getString("modifyoperid");abb.setKeyValue("MODIFYOPERID",""+abb.getModifyoperid());
abb.loantype=rs.getString("loantype");abb.setKeyValue("LOANTYPE",""+abb.getLoantype());
abb.applyid=rs.getString("applyid");abb.setKeyValue("APPLYID",""+abb.getApplyid());
abb.applymarriage=rs.getString("applymarriage");abb.setKeyValue("APPLYMARRIAGE",""+abb.getApplymarriage());
abb.matename=rs.getString("matename");abb.setKeyValue("MATENAME",""+abb.getMatename());
abb.basisremark=rs.getString("basisremark");abb.setKeyValue("BASISREMARK",""+abb.getBasisremark());
abb.operdate=rs.getString("operdate");abb.setKeyValue("OPERDATE",""+abb.getOperdate());
abb.changertype=rs.getString("changertype");abb.setKeyValue("CHANGERTYPE",""+abb.getChangertype());
abb.changerid=rs.getString("changerid");abb.setKeyValue("CHANGERID",""+abb.getChangerid());
abb.changersex=rs.getString("changersex");abb.setKeyValue("CHANGERSEX",""+abb.getChangersex());
abb.changerage=rs.getString("changerage");abb.setKeyValue("CHANGERAGE",""+abb.getChangerage());
abb.changerunit=rs.getString("changerunit");abb.setKeyValue("CHANGERUNIT",""+abb.getChangerunit());
abb.changeraddr=rs.getString("changeraddr");abb.setKeyValue("CHANGERADDR",""+abb.getChangeraddr());
abb.changertel=rs.getString("changertel");abb.setKeyValue("CHANGERTEL",""+abb.getChangertel());
abb.changerhousehold=rs.getString("changerhousehold");abb.setKeyValue("CHANGERHOUSEHOLD",""+abb.getChangerhousehold());
abb.changerculture=rs.getString("changerculture");abb.setKeyValue("CHANGERCULTURE",""+abb.getChangerculture());
abb.changermarriage=rs.getString("changermarriage");abb.setKeyValue("CHANGERMARRIAGE",""+abb.getChangermarriage());
abb.changerhealth=rs.getString("changerhealth");abb.setKeyValue("CHANGERHEALTH",""+abb.getChangerhealth());
abb.obmi=rs.getDouble("obmi");abb.setKeyValue("OBMI",""+abb.getObmi());
abb.obfi=rs.getDouble("obfi");abb.setKeyValue("OBFI",""+abb.getObfi());
abb.orginalperson=rs.getInt("orginalperson");abb.setKeyValue("ORGINALPERSON",""+abb.getOrginalperson());
abb.orginalavg=rs.getDouble("orginalavg");abb.setKeyValue("ORGINALAVG",""+abb.getOrginalavg());
abb.taxrate=rs.getString("taxrate");abb.setKeyValue("TAXRATE",""+abb.getTaxrate());
abb.changerincome=rs.getDouble("changerincome");abb.setKeyValue("CHANGERINCOME",""+abb.getChangerincome());
abb.changerfamilyincome=rs.getDouble("changerfamilyincome");abb.setKeyValue("CHANGERFAMILYINCOME",""+abb.getChangerfamilyincome());
abb.changerfamilynum=rs.getInt("changerfamilynum");abb.setKeyValue("CHANGERFAMILYNUM",""+abb.getChangerfamilynum());
abb.changeravgincome=rs.getDouble("changeravgincome");abb.setKeyValue("CHANGERAVGINCOME",""+abb.getChangeravgincome());
abb.deir=rs.getString("deir");abb.setKeyValue("DEIR",""+abb.getDeir());
abb.taxregno=rs.getString("taxregno");abb.setKeyValue("TAXREGNO",""+abb.getTaxregno());
abb.busilicno=rs.getString("busilicno");abb.setKeyValue("BUSILICNO",""+abb.getBusilicno());
abb.orgcode=rs.getString("orgcode");abb.setKeyValue("ORGCODE",""+abb.getOrgcode());
abb.remark=rs.getString("remark");abb.setKeyValue("REMARK",""+abb.getRemark());
abb.applyidcardtype=rs.getString("applyidcardtype");abb.setKeyValue("APPLYIDCARDTYPE",""+abb.getApplyidcardtype());
abb.applybirthday=rs.getString("applybirthday");abb.setKeyValue("APPLYBIRTHDAY",""+abb.getApplybirthday());
abb.applyage=rs.getInt("applyage");abb.setKeyValue("APPLYAGE",""+abb.getApplyage());
abb.applysex=rs.getString("applysex");abb.setKeyValue("APPLYSEX",""+abb.getApplysex());
abb.applyaddr=rs.getString("applyaddr");abb.setKeyValue("APPLYADDR",""+abb.getApplyaddr());
abb.applytel1=rs.getString("applytel1");abb.setKeyValue("APPLYTEL1",""+abb.getApplytel1());
abb.applytel2=rs.getString("applytel2");abb.setKeyValue("APPLYTEL2",""+abb.getApplytel2());
abb.applyothertel1=rs.getString("applyothertel1");abb.setKeyValue("APPLYOTHERTEL1",""+abb.getApplyothertel1());
abb.applyothertel2=rs.getString("applyothertel2");abb.setKeyValue("APPLYOTHERTEL2",""+abb.getApplyothertel2());
abb.applyregister=rs.getString("applyregister");abb.setKeyValue("APPLYREGISTER",""+abb.getApplyregister());
abb.applyculture=rs.getString("applyculture");abb.setKeyValue("APPLYCULTURE",""+abb.getApplyculture());
abb.applyhealth=rs.getString("applyhealth");abb.setKeyValue("APPLYHEALTH",""+abb.getApplyhealth());
abb.applytel=rs.getString("applytel");abb.setKeyValue("APPLYTEL",""+abb.getApplytel());
abb.addname1=rs.getString("addname1");abb.setKeyValue("ADDNAME1",""+abb.getAddname1());
abb.addname2=rs.getString("addname2");abb.setKeyValue("ADDNAME2",""+abb.getAddname2());
abb.mateidcard=rs.getString("mateidcard");abb.setKeyValue("MATEIDCARD",""+abb.getMateidcard());
abb.matetel=rs.getString("matetel");abb.setKeyValue("MATETEL",""+abb.getMatetel());
abb.modifydate=rs.getString("modifydate");abb.setKeyValue("MODIFYDATE",""+abb.getModifydate());
abb.changername=rs.getString("changername");abb.setKeyValue("CHANGERNAME",""+abb.getChangername());
abb.orgrinlloanamt=rs.getDouble("orgrinlloanamt");abb.setKeyValue("ORGRINLLOANAMT",""+abb.getOrgrinlloanamt());
abb.loanintamt=rs.getDouble("loanintamt");abb.setKeyValue("LOANINTAMT",""+abb.getLoanintamt());
abb.changebgdate=rs.getString("changebgdate");abb.setKeyValue("CHANGEBGDATE",""+abb.getChangebgdate());
abb.changeenddate=rs.getString("changeenddate");abb.setKeyValue("CHANGEENDDATE",""+abb.getChangeenddate());
abb.createdate=rs.getTimeString("createdate");abb.setKeyValue("CREATEDATE",""+abb.getCreatedate());
abb.seq=rs.getInt("seq");abb.setKeyValue("SEQ",""+abb.getSeq());
abb.mateincome=rs.getDouble("mateincome");abb.setKeyValue("MATEINCOME",""+abb.getMateincome());
abb.beforebgdate=rs.getString("beforebgdate");abb.setKeyValue("BEFOREBGDATE",""+abb.getBeforebgdate());
abb.beforeenddate=rs.getString("beforeenddate");abb.setKeyValue("BEFOREENDDATE",""+abb.getBeforeenddate());
abb.operatingcenter=rs.getString("operatingcenter");abb.setKeyValue("OPERATINGCENTER",""+abb.getOperatingcenter());
abb.customermanager=rs.getString("customermanager");abb.setKeyValue("CUSTOMERMANAGER",""+abb.getCustomermanager());
abb.agencies=rs.getString("agencies");abb.setKeyValue("AGENCIES",""+abb.getAgencies());
abb.marketingmanager=rs.getString("marketingmanager");abb.setKeyValue("MARKETINGMANAGER",""+abb.getMarketingmanager());
abb.matesex=rs.getString("matesex");abb.setKeyValue("MATESEX",""+abb.getMatesex());
list.add(abb);
abb.operate_mode = "edit";
}public String getCustno() { if ( this.custno == null ) return ""; return this.custno;}
public String getCustname() { if ( this.custname == null ) return ""; return this.custname;}
public String getBustype() { if ( this.bustype == null ) return ""; return this.bustype;}
public String getBankid() { if ( this.bankid == null ) return ""; return this.bankid;}
public String getOperid() { if ( this.operid == null ) return ""; return this.operid;}
public String getModifyoperid() { if ( this.modifyoperid == null ) return ""; return this.modifyoperid;}
public String getLoantype() { if ( this.loantype == null ) return ""; return this.loantype;}
public String getApplyid() { if ( this.applyid == null ) return ""; return this.applyid;}
public String getApplymarriage() { if ( this.applymarriage == null ) return ""; return this.applymarriage;}
public String getMatename() { if ( this.matename == null ) return ""; return this.matename;}
public String getBasisremark() { if ( this.basisremark == null ) return ""; return this.basisremark;}
public String getOperdate() { if ( this.operdate == null ) return ""; return this.operdate;}
public String getChangertype() { if ( this.changertype == null ) return ""; return this.changertype;}
public String getChangerid() { if ( this.changerid == null ) return ""; return this.changerid;}
public String getChangersex() { if ( this.changersex == null ) return ""; return this.changersex;}
public String getChangerage() { if ( this.changerage == null ) return ""; return this.changerage;}
public String getChangerunit() { if ( this.changerunit == null ) return ""; return this.changerunit;}
public String getChangeraddr() { if ( this.changeraddr == null ) return ""; return this.changeraddr;}
public String getChangertel() { if ( this.changertel == null ) return ""; return this.changertel;}
public String getChangerhousehold() { if ( this.changerhousehold == null ) return ""; return this.changerhousehold;}
public String getChangerculture() { if ( this.changerculture == null ) return ""; return this.changerculture;}
public String getChangermarriage() { if ( this.changermarriage == null ) return ""; return this.changermarriage;}
public String getChangerhealth() { if ( this.changerhealth == null ) return ""; return this.changerhealth;}
public double getObmi() { return this.obmi;}
public double getObfi() { return this.obfi;}
public int getOrginalperson() { return this.orginalperson;}
public double getOrginalavg() { return this.orginalavg;}
public String getTaxrate() { if ( this.taxrate == null ) return ""; return this.taxrate;}
public double getChangerincome() { return this.changerincome;}
public double getChangerfamilyincome() { return this.changerfamilyincome;}
public int getChangerfamilynum() { return this.changerfamilynum;}
public double getChangeravgincome() { return this.changeravgincome;}
public String getDeir() { if ( this.deir == null ) return ""; return this.deir;}
public String getTaxregno() { if ( this.taxregno == null ) return ""; return this.taxregno;}
public String getBusilicno() { if ( this.busilicno == null ) return ""; return this.busilicno;}
public String getOrgcode() { if ( this.orgcode == null ) return ""; return this.orgcode;}
public String getRemark() { if ( this.remark == null ) return ""; return this.remark;}
public String getApplyidcardtype() { if ( this.applyidcardtype == null ) return ""; return this.applyidcardtype;}
public String getApplybirthday() { if ( this.applybirthday == null ) return ""; return this.applybirthday;}
public int getApplyage() { return this.applyage;}
public String getApplysex() { if ( this.applysex == null ) return ""; return this.applysex;}
public String getApplyaddr() { if ( this.applyaddr == null ) return ""; return this.applyaddr;}
public String getApplytel1() { if ( this.applytel1 == null ) return ""; return this.applytel1;}
public String getApplytel2() { if ( this.applytel2 == null ) return ""; return this.applytel2;}
public String getApplyothertel1() { if ( this.applyothertel1 == null ) return ""; return this.applyothertel1;}
public String getApplyothertel2() { if ( this.applyothertel2 == null ) return ""; return this.applyothertel2;}
public String getApplyregister() { if ( this.applyregister == null ) return ""; return this.applyregister;}
public String getApplyculture() { if ( this.applyculture == null ) return ""; return this.applyculture;}
public String getApplyhealth() { if ( this.applyhealth == null ) return ""; return this.applyhealth;}
public String getApplytel() { if ( this.applytel == null ) return ""; return this.applytel;}
public String getAddname1() { if ( this.addname1 == null ) return ""; return this.addname1;}
public String getAddname2() { if ( this.addname2 == null ) return ""; return this.addname2;}
public String getMateidcard() { if ( this.mateidcard == null ) return ""; return this.mateidcard;}
public String getMatetel() { if ( this.matetel == null ) return ""; return this.matetel;}
public String getModifydate() { if ( this.modifydate == null ) return ""; return this.modifydate;}
public String getChangername() { if ( this.changername == null ) return ""; return this.changername;}
public double getOrgrinlloanamt() { return this.orgrinlloanamt;}
public double getLoanintamt() { return this.loanintamt;}
public String getChangebgdate() { if ( this.changebgdate == null ) return ""; return this.changebgdate;}
public String getChangeenddate() { if ( this.changeenddate == null ) return ""; return this.changeenddate;}
public String getCreatedate() {  if ( this.createdate == null ) { return ""; } else { return this.createdate.trim().split(" ")[0];} }public String getCreatedateTime() {  if ( this.createdate == null ) return ""; return this.createdate.split("\\.")[0];}
public int getSeq() { return this.seq;}
public double getMateincome() { return this.mateincome;}
public String getBeforebgdate() { if ( this.beforebgdate == null ) return ""; return this.beforebgdate;}
public String getBeforeenddate() { if ( this.beforeenddate == null ) return ""; return this.beforeenddate;}
public String getOperatingcenter() { if ( this.operatingcenter == null ) return ""; return this.operatingcenter;}
public String getCustomermanager() { if ( this.customermanager == null ) return ""; return this.customermanager;}
public String getAgencies() { if ( this.agencies == null ) return ""; return this.agencies;}
public String getMarketingmanager() { if ( this.marketingmanager == null ) return ""; return this.marketingmanager;}
public String getMatesex() { if ( this.matesex == null ) return ""; return this.matesex;}
public void setCustno(String custno) { sqlMaker.setField("custno",custno,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCustno().equals(custno)) cf.add("custno",this.custno,custno); } this.custno=custno;}
public void setCustname(String custname) { sqlMaker.setField("custname",custname,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCustname().equals(custname)) cf.add("custname",this.custname,custname); } this.custname=custname;}
public void setBustype(String bustype) { sqlMaker.setField("bustype",bustype,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBustype().equals(bustype)) cf.add("bustype",this.bustype,bustype); } this.bustype=bustype;}
public void setBankid(String bankid) { sqlMaker.setField("bankid",bankid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBankid().equals(bankid)) cf.add("bankid",this.bankid,bankid); } this.bankid=bankid;}
public void setOperid(String operid) { sqlMaker.setField("operid",operid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperid().equals(operid)) cf.add("operid",this.operid,operid); } this.operid=operid;}
public void setModifyoperid(String modifyoperid) { sqlMaker.setField("modifyoperid",modifyoperid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getModifyoperid().equals(modifyoperid)) cf.add("modifyoperid",this.modifyoperid,modifyoperid); } this.modifyoperid=modifyoperid;}
public void setLoantype(String loantype) { sqlMaker.setField("loantype",loantype,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getLoantype().equals(loantype)) cf.add("loantype",this.loantype,loantype); } this.loantype=loantype;}
public void setApplyid(String applyid) { sqlMaker.setField("applyid",applyid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyid().equals(applyid)) cf.add("applyid",this.applyid,applyid); } this.applyid=applyid;}
public void setApplymarriage(String applymarriage) { sqlMaker.setField("applymarriage",applymarriage,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplymarriage().equals(applymarriage)) cf.add("applymarriage",this.applymarriage,applymarriage); } this.applymarriage=applymarriage;}
public void setMatename(String matename) { sqlMaker.setField("matename",matename,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMatename().equals(matename)) cf.add("matename",this.matename,matename); } this.matename=matename;}
public void setBasisremark(String basisremark) { sqlMaker.setField("basisremark",basisremark,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBasisremark().equals(basisremark)) cf.add("basisremark",this.basisremark,basisremark); } this.basisremark=basisremark;}
public void setOperdate(String operdate) { sqlMaker.setField("operdate",operdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperdate().equals(operdate)) cf.add("operdate",this.operdate,operdate); } this.operdate=operdate;}
public void setChangertype(String changertype) { sqlMaker.setField("changertype",changertype,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangertype().equals(changertype)) cf.add("changertype",this.changertype,changertype); } this.changertype=changertype;}
public void setChangerid(String changerid) { sqlMaker.setField("changerid",changerid,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerid().equals(changerid)) cf.add("changerid",this.changerid,changerid); } this.changerid=changerid;}
public void setChangersex(String changersex) { sqlMaker.setField("changersex",changersex,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangersex().equals(changersex)) cf.add("changersex",this.changersex,changersex); } this.changersex=changersex;}
public void setChangerage(String changerage) { sqlMaker.setField("changerage",changerage,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerage().equals(changerage)) cf.add("changerage",this.changerage,changerage); } this.changerage=changerage;}
public void setChangerunit(String changerunit) { sqlMaker.setField("changerunit",changerunit,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerunit().equals(changerunit)) cf.add("changerunit",this.changerunit,changerunit); } this.changerunit=changerunit;}
public void setChangeraddr(String changeraddr) { sqlMaker.setField("changeraddr",changeraddr,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangeraddr().equals(changeraddr)) cf.add("changeraddr",this.changeraddr,changeraddr); } this.changeraddr=changeraddr;}
public void setChangertel(String changertel) { sqlMaker.setField("changertel",changertel,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangertel().equals(changertel)) cf.add("changertel",this.changertel,changertel); } this.changertel=changertel;}
public void setChangerhousehold(String changerhousehold) { sqlMaker.setField("changerhousehold",changerhousehold,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerhousehold().equals(changerhousehold)) cf.add("changerhousehold",this.changerhousehold,changerhousehold); } this.changerhousehold=changerhousehold;}
public void setChangerculture(String changerculture) { sqlMaker.setField("changerculture",changerculture,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerculture().equals(changerculture)) cf.add("changerculture",this.changerculture,changerculture); } this.changerculture=changerculture;}
public void setChangermarriage(String changermarriage) { sqlMaker.setField("changermarriage",changermarriage,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangermarriage().equals(changermarriage)) cf.add("changermarriage",this.changermarriage,changermarriage); } this.changermarriage=changermarriage;}
public void setChangerhealth(String changerhealth) { sqlMaker.setField("changerhealth",changerhealth,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangerhealth().equals(changerhealth)) cf.add("changerhealth",this.changerhealth,changerhealth); } this.changerhealth=changerhealth;}
public void setObmi(double obmi) { sqlMaker.setField("obmi",""+obmi,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getObmi()!=obmi) cf.add("obmi",this.obmi+"",obmi+""); } this.obmi=obmi;}
public void setObfi(double obfi) { sqlMaker.setField("obfi",""+obfi,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getObfi()!=obfi) cf.add("obfi",this.obfi+"",obfi+""); } this.obfi=obfi;}
public void setOrginalperson(int orginalperson) { sqlMaker.setField("orginalperson",""+orginalperson,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getOrginalperson()!=orginalperson) cf.add("orginalperson",this.orginalperson+"",orginalperson+""); } this.orginalperson=orginalperson;}
public void setOrginalavg(double orginalavg) { sqlMaker.setField("orginalavg",""+orginalavg,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getOrginalavg()!=orginalavg) cf.add("orginalavg",this.orginalavg+"",orginalavg+""); } this.orginalavg=orginalavg;}
public void setTaxrate(String taxrate) { sqlMaker.setField("taxrate",taxrate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getTaxrate().equals(taxrate)) cf.add("taxrate",this.taxrate,taxrate); } this.taxrate=taxrate;}
public void setChangerincome(double changerincome) { sqlMaker.setField("changerincome",""+changerincome,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getChangerincome()!=changerincome) cf.add("changerincome",this.changerincome+"",changerincome+""); } this.changerincome=changerincome;}
public void setChangerfamilyincome(double changerfamilyincome) { sqlMaker.setField("changerfamilyincome",""+changerfamilyincome,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getChangerfamilyincome()!=changerfamilyincome) cf.add("changerfamilyincome",this.changerfamilyincome+"",changerfamilyincome+""); } this.changerfamilyincome=changerfamilyincome;}
public void setChangerfamilynum(int changerfamilynum) { sqlMaker.setField("changerfamilynum",""+changerfamilynum,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getChangerfamilynum()!=changerfamilynum) cf.add("changerfamilynum",this.changerfamilynum+"",changerfamilynum+""); } this.changerfamilynum=changerfamilynum;}
public void setChangeravgincome(double changeravgincome) { sqlMaker.setField("changeravgincome",""+changeravgincome,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getChangeravgincome()!=changeravgincome) cf.add("changeravgincome",this.changeravgincome+"",changeravgincome+""); } this.changeravgincome=changeravgincome;}
public void setDeir(String deir) { sqlMaker.setField("deir",deir,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getDeir().equals(deir)) cf.add("deir",this.deir,deir); } this.deir=deir;}
public void setTaxregno(String taxregno) { sqlMaker.setField("taxregno",taxregno,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getTaxregno().equals(taxregno)) cf.add("taxregno",this.taxregno,taxregno); } this.taxregno=taxregno;}
public void setBusilicno(String busilicno) { sqlMaker.setField("busilicno",busilicno,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBusilicno().equals(busilicno)) cf.add("busilicno",this.busilicno,busilicno); } this.busilicno=busilicno;}
public void setOrgcode(String orgcode) { sqlMaker.setField("orgcode",orgcode,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOrgcode().equals(orgcode)) cf.add("orgcode",this.orgcode,orgcode); } this.orgcode=orgcode;}
public void setRemark(String remark) { sqlMaker.setField("remark",remark,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getRemark().equals(remark)) cf.add("remark",this.remark,remark); } this.remark=remark;}
public void setApplyidcardtype(String applyidcardtype) { sqlMaker.setField("applyidcardtype",applyidcardtype,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyidcardtype().equals(applyidcardtype)) cf.add("applyidcardtype",this.applyidcardtype,applyidcardtype); } this.applyidcardtype=applyidcardtype;}
public void setApplybirthday(String applybirthday) { sqlMaker.setField("applybirthday",applybirthday,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplybirthday().equals(applybirthday)) cf.add("applybirthday",this.applybirthday,applybirthday); } this.applybirthday=applybirthday;}
public void setApplyage(int applyage) { sqlMaker.setField("applyage",""+applyage,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getApplyage()!=applyage) cf.add("applyage",this.applyage+"",applyage+""); } this.applyage=applyage;}
public void setApplysex(String applysex) { sqlMaker.setField("applysex",applysex,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplysex().equals(applysex)) cf.add("applysex",this.applysex,applysex); } this.applysex=applysex;}
public void setApplyaddr(String applyaddr) { sqlMaker.setField("applyaddr",applyaddr,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyaddr().equals(applyaddr)) cf.add("applyaddr",this.applyaddr,applyaddr); } this.applyaddr=applyaddr;}
public void setApplytel1(String applytel1) { sqlMaker.setField("applytel1",applytel1,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplytel1().equals(applytel1)) cf.add("applytel1",this.applytel1,applytel1); } this.applytel1=applytel1;}
public void setApplytel2(String applytel2) { sqlMaker.setField("applytel2",applytel2,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplytel2().equals(applytel2)) cf.add("applytel2",this.applytel2,applytel2); } this.applytel2=applytel2;}
public void setApplyothertel1(String applyothertel1) { sqlMaker.setField("applyothertel1",applyothertel1,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyothertel1().equals(applyothertel1)) cf.add("applyothertel1",this.applyothertel1,applyothertel1); } this.applyothertel1=applyothertel1;}
public void setApplyothertel2(String applyothertel2) { sqlMaker.setField("applyothertel2",applyothertel2,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyothertel2().equals(applyothertel2)) cf.add("applyothertel2",this.applyothertel2,applyothertel2); } this.applyothertel2=applyothertel2;}
public void setApplyregister(String applyregister) { sqlMaker.setField("applyregister",applyregister,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyregister().equals(applyregister)) cf.add("applyregister",this.applyregister,applyregister); } this.applyregister=applyregister;}
public void setApplyculture(String applyculture) { sqlMaker.setField("applyculture",applyculture,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyculture().equals(applyculture)) cf.add("applyculture",this.applyculture,applyculture); } this.applyculture=applyculture;}
public void setApplyhealth(String applyhealth) { sqlMaker.setField("applyhealth",applyhealth,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplyhealth().equals(applyhealth)) cf.add("applyhealth",this.applyhealth,applyhealth); } this.applyhealth=applyhealth;}
public void setApplytel(String applytel) { sqlMaker.setField("applytel",applytel,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getApplytel().equals(applytel)) cf.add("applytel",this.applytel,applytel); } this.applytel=applytel;}
public void setAddname1(String addname1) { sqlMaker.setField("addname1",addname1,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAddname1().equals(addname1)) cf.add("addname1",this.addname1,addname1); } this.addname1=addname1;}
public void setAddname2(String addname2) { sqlMaker.setField("addname2",addname2,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAddname2().equals(addname2)) cf.add("addname2",this.addname2,addname2); } this.addname2=addname2;}
public void setMateidcard(String mateidcard) { sqlMaker.setField("mateidcard",mateidcard,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMateidcard().equals(mateidcard)) cf.add("mateidcard",this.mateidcard,mateidcard); } this.mateidcard=mateidcard;}
public void setMatetel(String matetel) { sqlMaker.setField("matetel",matetel,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMatetel().equals(matetel)) cf.add("matetel",this.matetel,matetel); } this.matetel=matetel;}
public void setModifydate(String modifydate) { sqlMaker.setField("modifydate",modifydate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getModifydate().equals(modifydate)) cf.add("modifydate",this.modifydate,modifydate); } this.modifydate=modifydate;}
public void setChangername(String changername) { sqlMaker.setField("changername",changername,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangername().equals(changername)) cf.add("changername",this.changername,changername); } this.changername=changername;}
public void setOrgrinlloanamt(double orgrinlloanamt) { sqlMaker.setField("orgrinlloanamt",""+orgrinlloanamt,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getOrgrinlloanamt()!=orgrinlloanamt) cf.add("orgrinlloanamt",this.orgrinlloanamt+"",orgrinlloanamt+""); } this.orgrinlloanamt=orgrinlloanamt;}
public void setLoanintamt(double loanintamt) { sqlMaker.setField("loanintamt",""+loanintamt,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getLoanintamt()!=loanintamt) cf.add("loanintamt",this.loanintamt+"",loanintamt+""); } this.loanintamt=loanintamt;}
public void setChangebgdate(String changebgdate) { sqlMaker.setField("changebgdate",changebgdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangebgdate().equals(changebgdate)) cf.add("changebgdate",this.changebgdate,changebgdate); } this.changebgdate=changebgdate;}
public void setChangeenddate(String changeenddate) { sqlMaker.setField("changeenddate",changeenddate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getChangeenddate().equals(changeenddate)) cf.add("changeenddate",this.changeenddate,changeenddate); } this.changeenddate=changeenddate;}
public void setCreatedate(String createdate) { sqlMaker.setField("createdate",createdate,Field.DATE); if (this.operate_mode.equals("edit")) { if (!this.getCreatedate().equals(createdate)) cf.add("createdate",this.createdate,createdate); } this.createdate=createdate;}
public void setSeq(int seq) { sqlMaker.setField("seq",""+seq,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getSeq()!=seq) cf.add("seq",this.seq+"",seq+""); } this.seq=seq;}
public void setMateincome(double mateincome) { sqlMaker.setField("mateincome",""+mateincome,Field.NUMBER); if (this.operate_mode.equals("edit")) { if (this.getMateincome()!=mateincome) cf.add("mateincome",this.mateincome+"",mateincome+""); } this.mateincome=mateincome;}
public void setBeforebgdate(String beforebgdate) { sqlMaker.setField("beforebgdate",beforebgdate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBeforebgdate().equals(beforebgdate)) cf.add("beforebgdate",this.beforebgdate,beforebgdate); } this.beforebgdate=beforebgdate;}
public void setBeforeenddate(String beforeenddate) { sqlMaker.setField("beforeenddate",beforeenddate,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getBeforeenddate().equals(beforeenddate)) cf.add("beforeenddate",this.beforeenddate,beforeenddate); } this.beforeenddate=beforeenddate;}
public void setOperatingcenter(String operatingcenter) { sqlMaker.setField("operatingcenter",operatingcenter,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getOperatingcenter().equals(operatingcenter)) cf.add("operatingcenter",this.operatingcenter,operatingcenter); } this.operatingcenter=operatingcenter;}
public void setCustomermanager(String customermanager) { sqlMaker.setField("customermanager",customermanager,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getCustomermanager().equals(customermanager)) cf.add("customermanager",this.customermanager,customermanager); } this.customermanager=customermanager;}
public void setAgencies(String agencies) { sqlMaker.setField("agencies",agencies,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getAgencies().equals(agencies)) cf.add("agencies",this.agencies,agencies); } this.agencies=agencies;}
public void setMarketingmanager(String marketingmanager) { sqlMaker.setField("marketingmanager",marketingmanager,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMarketingmanager().equals(marketingmanager)) cf.add("marketingmanager",this.marketingmanager,marketingmanager); } this.marketingmanager=marketingmanager;}
public void setMatesex(String matesex) { sqlMaker.setField("matesex",matesex,Field.TEXT); if (this.operate_mode.equals("edit")) { if (!this.getMatesex().equals(matesex)) cf.add("matesex",this.matesex,matesex); } this.matesex=matesex;}
public void init(int i,ActionRequest actionRequest) throws Exception { if ( actionRequest.getFieldValue(i,"custno") !=null ) {this.setCustno(actionRequest.getFieldValue(i,"custno"));}
if ( actionRequest.getFieldValue(i,"custname") !=null ) {this.setCustname(actionRequest.getFieldValue(i,"custname"));}
if ( actionRequest.getFieldValue(i,"bustype") !=null ) {this.setBustype(actionRequest.getFieldValue(i,"bustype"));}
if ( actionRequest.getFieldValue(i,"bankid") !=null ) {this.setBankid(actionRequest.getFieldValue(i,"bankid"));}
if ( actionRequest.getFieldValue(i,"operid") !=null ) {this.setOperid(actionRequest.getFieldValue(i,"operid"));}
if ( actionRequest.getFieldValue(i,"modifyoperid") !=null ) {this.setModifyoperid(actionRequest.getFieldValue(i,"modifyoperid"));}
if ( actionRequest.getFieldValue(i,"loantype") !=null ) {this.setLoantype(actionRequest.getFieldValue(i,"loantype"));}
if ( actionRequest.getFieldValue(i,"applyid") !=null ) {this.setApplyid(actionRequest.getFieldValue(i,"applyid"));}
if ( actionRequest.getFieldValue(i,"applymarriage") !=null ) {this.setApplymarriage(actionRequest.getFieldValue(i,"applymarriage"));}
if ( actionRequest.getFieldValue(i,"matename") !=null ) {this.setMatename(actionRequest.getFieldValue(i,"matename"));}
if ( actionRequest.getFieldValue(i,"basisremark") !=null ) {this.setBasisremark(actionRequest.getFieldValue(i,"basisremark"));}
if ( actionRequest.getFieldValue(i,"operdate") !=null ) {this.setOperdate(actionRequest.getFieldValue(i,"operdate"));}
if ( actionRequest.getFieldValue(i,"changertype") !=null ) {this.setChangertype(actionRequest.getFieldValue(i,"changertype"));}
if ( actionRequest.getFieldValue(i,"changerid") !=null ) {this.setChangerid(actionRequest.getFieldValue(i,"changerid"));}
if ( actionRequest.getFieldValue(i,"changersex") !=null ) {this.setChangersex(actionRequest.getFieldValue(i,"changersex"));}
if ( actionRequest.getFieldValue(i,"changerage") !=null ) {this.setChangerage(actionRequest.getFieldValue(i,"changerage"));}
if ( actionRequest.getFieldValue(i,"changerunit") !=null ) {this.setChangerunit(actionRequest.getFieldValue(i,"changerunit"));}
if ( actionRequest.getFieldValue(i,"changeraddr") !=null ) {this.setChangeraddr(actionRequest.getFieldValue(i,"changeraddr"));}
if ( actionRequest.getFieldValue(i,"changertel") !=null ) {this.setChangertel(actionRequest.getFieldValue(i,"changertel"));}
if ( actionRequest.getFieldValue(i,"changerhousehold") !=null ) {this.setChangerhousehold(actionRequest.getFieldValue(i,"changerhousehold"));}
if ( actionRequest.getFieldValue(i,"changerculture") !=null ) {this.setChangerculture(actionRequest.getFieldValue(i,"changerculture"));}
if ( actionRequest.getFieldValue(i,"changermarriage") !=null ) {this.setChangermarriage(actionRequest.getFieldValue(i,"changermarriage"));}
if ( actionRequest.getFieldValue(i,"changerhealth") !=null ) {this.setChangerhealth(actionRequest.getFieldValue(i,"changerhealth"));}
if ( actionRequest.getFieldValue(i,"obmi") !=null && actionRequest.getFieldValue(i,"obmi").trim().length() > 0 ) {this.setObmi(Double.parseDouble(actionRequest.getFieldValue(i,"obmi")));}
if ( actionRequest.getFieldValue(i,"obfi") !=null && actionRequest.getFieldValue(i,"obfi").trim().length() > 0 ) {this.setObfi(Double.parseDouble(actionRequest.getFieldValue(i,"obfi")));}
if ( actionRequest.getFieldValue(i,"orginalperson") !=null && actionRequest.getFieldValue(i,"orginalperson").trim().length() > 0 ) {this.setOrginalperson(Integer.parseInt(actionRequest.getFieldValue(i,"orginalperson")));}
if ( actionRequest.getFieldValue(i,"orginalavg") !=null && actionRequest.getFieldValue(i,"orginalavg").trim().length() > 0 ) {this.setOrginalavg(Double.parseDouble(actionRequest.getFieldValue(i,"orginalavg")));}
if ( actionRequest.getFieldValue(i,"taxrate") !=null ) {this.setTaxrate(actionRequest.getFieldValue(i,"taxrate"));}
if ( actionRequest.getFieldValue(i,"changerincome") !=null && actionRequest.getFieldValue(i,"changerincome").trim().length() > 0 ) {this.setChangerincome(Double.parseDouble(actionRequest.getFieldValue(i,"changerincome")));}
if ( actionRequest.getFieldValue(i,"changerfamilyincome") !=null && actionRequest.getFieldValue(i,"changerfamilyincome").trim().length() > 0 ) {this.setChangerfamilyincome(Double.parseDouble(actionRequest.getFieldValue(i,"changerfamilyincome")));}
if ( actionRequest.getFieldValue(i,"changerfamilynum") !=null && actionRequest.getFieldValue(i,"changerfamilynum").trim().length() > 0 ) {this.setChangerfamilynum(Integer.parseInt(actionRequest.getFieldValue(i,"changerfamilynum")));}
if ( actionRequest.getFieldValue(i,"changeravgincome") !=null && actionRequest.getFieldValue(i,"changeravgincome").trim().length() > 0 ) {this.setChangeravgincome(Double.parseDouble(actionRequest.getFieldValue(i,"changeravgincome")));}
if ( actionRequest.getFieldValue(i,"deir") !=null ) {this.setDeir(actionRequest.getFieldValue(i,"deir"));}
if ( actionRequest.getFieldValue(i,"taxregno") !=null ) {this.setTaxregno(actionRequest.getFieldValue(i,"taxregno"));}
if ( actionRequest.getFieldValue(i,"busilicno") !=null ) {this.setBusilicno(actionRequest.getFieldValue(i,"busilicno"));}
if ( actionRequest.getFieldValue(i,"orgcode") !=null ) {this.setOrgcode(actionRequest.getFieldValue(i,"orgcode"));}
if ( actionRequest.getFieldValue(i,"remark") !=null ) {this.setRemark(actionRequest.getFieldValue(i,"remark"));}
if ( actionRequest.getFieldValue(i,"applyidcardtype") !=null ) {this.setApplyidcardtype(actionRequest.getFieldValue(i,"applyidcardtype"));}
if ( actionRequest.getFieldValue(i,"applybirthday") !=null ) {this.setApplybirthday(actionRequest.getFieldValue(i,"applybirthday"));}
if ( actionRequest.getFieldValue(i,"applyage") !=null && actionRequest.getFieldValue(i,"applyage").trim().length() > 0 ) {this.setApplyage(Integer.parseInt(actionRequest.getFieldValue(i,"applyage")));}
if ( actionRequest.getFieldValue(i,"applysex") !=null ) {this.setApplysex(actionRequest.getFieldValue(i,"applysex"));}
if ( actionRequest.getFieldValue(i,"applyaddr") !=null ) {this.setApplyaddr(actionRequest.getFieldValue(i,"applyaddr"));}
if ( actionRequest.getFieldValue(i,"applytel1") !=null ) {this.setApplytel1(actionRequest.getFieldValue(i,"applytel1"));}
if ( actionRequest.getFieldValue(i,"applytel2") !=null ) {this.setApplytel2(actionRequest.getFieldValue(i,"applytel2"));}
if ( actionRequest.getFieldValue(i,"applyothertel1") !=null ) {this.setApplyothertel1(actionRequest.getFieldValue(i,"applyothertel1"));}
if ( actionRequest.getFieldValue(i,"applyothertel2") !=null ) {this.setApplyothertel2(actionRequest.getFieldValue(i,"applyothertel2"));}
if ( actionRequest.getFieldValue(i,"applyregister") !=null ) {this.setApplyregister(actionRequest.getFieldValue(i,"applyregister"));}
if ( actionRequest.getFieldValue(i,"applyculture") !=null ) {this.setApplyculture(actionRequest.getFieldValue(i,"applyculture"));}
if ( actionRequest.getFieldValue(i,"applyhealth") !=null ) {this.setApplyhealth(actionRequest.getFieldValue(i,"applyhealth"));}
if ( actionRequest.getFieldValue(i,"applytel") !=null ) {this.setApplytel(actionRequest.getFieldValue(i,"applytel"));}
if ( actionRequest.getFieldValue(i,"addname1") !=null ) {this.setAddname1(actionRequest.getFieldValue(i,"addname1"));}
if ( actionRequest.getFieldValue(i,"addname2") !=null ) {this.setAddname2(actionRequest.getFieldValue(i,"addname2"));}
if ( actionRequest.getFieldValue(i,"mateidcard") !=null ) {this.setMateidcard(actionRequest.getFieldValue(i,"mateidcard"));}
if ( actionRequest.getFieldValue(i,"matetel") !=null ) {this.setMatetel(actionRequest.getFieldValue(i,"matetel"));}
if ( actionRequest.getFieldValue(i,"modifydate") !=null ) {this.setModifydate(actionRequest.getFieldValue(i,"modifydate"));}
if ( actionRequest.getFieldValue(i,"changername") !=null ) {this.setChangername(actionRequest.getFieldValue(i,"changername"));}
if ( actionRequest.getFieldValue(i,"orgrinlloanamt") !=null && actionRequest.getFieldValue(i,"orgrinlloanamt").trim().length() > 0 ) {this.setOrgrinlloanamt(Double.parseDouble(actionRequest.getFieldValue(i,"orgrinlloanamt")));}
if ( actionRequest.getFieldValue(i,"loanintamt") !=null && actionRequest.getFieldValue(i,"loanintamt").trim().length() > 0 ) {this.setLoanintamt(Double.parseDouble(actionRequest.getFieldValue(i,"loanintamt")));}
if ( actionRequest.getFieldValue(i,"changebgdate") !=null ) {this.setChangebgdate(actionRequest.getFieldValue(i,"changebgdate"));}
if ( actionRequest.getFieldValue(i,"changeenddate") !=null ) {this.setChangeenddate(actionRequest.getFieldValue(i,"changeenddate"));}
if ( actionRequest.getFieldValue(i,"createdate") !=null ) {this.setCreatedate(actionRequest.getFieldValue(i,"createdate"));}
if ( actionRequest.getFieldValue(i,"seq") !=null && actionRequest.getFieldValue(i,"seq").trim().length() > 0 ) {this.setSeq(Integer.parseInt(actionRequest.getFieldValue(i,"seq")));}
if ( actionRequest.getFieldValue(i,"mateincome") !=null && actionRequest.getFieldValue(i,"mateincome").trim().length() > 0 ) {this.setMateincome(Double.parseDouble(actionRequest.getFieldValue(i,"mateincome")));}
if ( actionRequest.getFieldValue(i,"beforebgdate") !=null ) {this.setBeforebgdate(actionRequest.getFieldValue(i,"beforebgdate"));}
if ( actionRequest.getFieldValue(i,"beforeenddate") !=null ) {this.setBeforeenddate(actionRequest.getFieldValue(i,"beforeenddate"));}
if ( actionRequest.getFieldValue(i,"operatingcenter") !=null ) {this.setOperatingcenter(actionRequest.getFieldValue(i,"operatingcenter"));}
if ( actionRequest.getFieldValue(i,"customermanager") !=null ) {this.setCustomermanager(actionRequest.getFieldValue(i,"customermanager"));}
if ( actionRequest.getFieldValue(i,"agencies") !=null ) {this.setAgencies(actionRequest.getFieldValue(i,"agencies"));}
if ( actionRequest.getFieldValue(i,"marketingmanager") !=null ) {this.setMarketingmanager(actionRequest.getFieldValue(i,"marketingmanager"));}
if ( actionRequest.getFieldValue(i,"matesex") !=null ) {this.setMatesex(actionRequest.getFieldValue(i,"matesex"));}
}public void init(ActionRequest actionRequest) throws Exception { this.init(0,actionRequest);}public void initAll(int i,ActionRequest actionRequest) throws Exception { this.init(i,actionRequest);}public void initAll(ActionRequest actionRequest) throws Exception { this.initAll(0,actionRequest);}public Object clone() throws CloneNotSupportedException { LNSPCLBUSCUST obj = (LNSPCLBUSCUST)super.clone();obj.setCustno(obj.custno);
obj.setCustname(obj.custname);
obj.setBustype(obj.bustype);
obj.setBankid(obj.bankid);
obj.setOperid(obj.operid);
obj.setModifyoperid(obj.modifyoperid);
obj.setLoantype(obj.loantype);
obj.setApplyid(obj.applyid);
obj.setApplymarriage(obj.applymarriage);
obj.setMatename(obj.matename);
obj.setBasisremark(obj.basisremark);
obj.setOperdate(obj.operdate);
obj.setChangertype(obj.changertype);
obj.setChangerid(obj.changerid);
obj.setChangersex(obj.changersex);
obj.setChangerage(obj.changerage);
obj.setChangerunit(obj.changerunit);
obj.setChangeraddr(obj.changeraddr);
obj.setChangertel(obj.changertel);
obj.setChangerhousehold(obj.changerhousehold);
obj.setChangerculture(obj.changerculture);
obj.setChangermarriage(obj.changermarriage);
obj.setChangerhealth(obj.changerhealth);
obj.setObmi(obj.obmi);
obj.setObfi(obj.obfi);
obj.setOrginalperson(obj.orginalperson);
obj.setOrginalavg(obj.orginalavg);
obj.setTaxrate(obj.taxrate);
obj.setChangerincome(obj.changerincome);
obj.setChangerfamilyincome(obj.changerfamilyincome);
obj.setChangerfamilynum(obj.changerfamilynum);
obj.setChangeravgincome(obj.changeravgincome);
obj.setDeir(obj.deir);
obj.setTaxregno(obj.taxregno);
obj.setBusilicno(obj.busilicno);
obj.setOrgcode(obj.orgcode);
obj.setRemark(obj.remark);
obj.setApplyidcardtype(obj.applyidcardtype);
obj.setApplybirthday(obj.applybirthday);
obj.setApplyage(obj.applyage);
obj.setApplysex(obj.applysex);
obj.setApplyaddr(obj.applyaddr);
obj.setApplytel1(obj.applytel1);
obj.setApplytel2(obj.applytel2);
obj.setApplyothertel1(obj.applyothertel1);
obj.setApplyothertel2(obj.applyothertel2);
obj.setApplyregister(obj.applyregister);
obj.setApplyculture(obj.applyculture);
obj.setApplyhealth(obj.applyhealth);
obj.setApplytel(obj.applytel);
obj.setAddname1(obj.addname1);
obj.setAddname2(obj.addname2);
obj.setMateidcard(obj.mateidcard);
obj.setMatetel(obj.matetel);
obj.setModifydate(obj.modifydate);
obj.setChangername(obj.changername);
obj.setOrgrinlloanamt(obj.orgrinlloanamt);
obj.setLoanintamt(obj.loanintamt);
obj.setChangebgdate(obj.changebgdate);
obj.setChangeenddate(obj.changeenddate);
obj.setCreatedate(obj.createdate);
obj.setSeq(obj.seq);
obj.setMateincome(obj.mateincome);
obj.setBeforebgdate(obj.beforebgdate);
obj.setBeforeenddate(obj.beforeenddate);
obj.setOperatingcenter(obj.operatingcenter);
obj.setCustomermanager(obj.customermanager);
obj.setAgencies(obj.agencies);
obj.setMarketingmanager(obj.marketingmanager);
obj.setMatesex(obj.matesex);
return obj;}}