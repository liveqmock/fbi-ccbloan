package com.ccb.dao;

import java.util.*;

import pub.platform.db.*;
import pub.platform.utils.*;
import pub.platform.db.AbstractBasicBean;

public class LNARCHIVEFLOW extends AbstractBasicBean implements Cloneable {
    public static List find(String sSqlWhere) {
        return new LNARCHIVEFLOW().findByWhere(sSqlWhere);
    }

    public static List findAndLock(String sSqlWhere) {
        return new LNARCHIVEFLOW().findAndLockByWhere(sSqlWhere);
    }

    public static LNARCHIVEFLOW findFirst(String sSqlWhere) {
        return (LNARCHIVEFLOW) new LNARCHIVEFLOW().findFirstByWhere(sSqlWhere);
    }

    public static LNARCHIVEFLOW findFirstAndLock(String sSqlWhere) {
        return (LNARCHIVEFLOW) new LNARCHIVEFLOW().findFirstAndLockByWhere(sSqlWhere);
    }

    public static RecordSet findRecordSet(String sSqlWhere) {
        return new LNARCHIVEFLOW().findRecordSetByWhere(sSqlWhere);
    }

    public static List find(String sSqlWhere, boolean isAutoRelease) {
        LNARCHIVEFLOW bean = new LNARCHIVEFLOW();
        bean.setAutoRelease(isAutoRelease);
        return bean.findByWhere(sSqlWhere);
    }

    public static List findAndLock(String sSqlWhere, boolean isAutoRelease) {
        LNARCHIVEFLOW bean = new LNARCHIVEFLOW();
        bean.setAutoRelease(isAutoRelease);
        return bean.findAndLockByWhere(sSqlWhere);
    }

    public static LNARCHIVEFLOW findFirst(String sSqlWhere, boolean isAutoRelease) {
        LNARCHIVEFLOW bean = new LNARCHIVEFLOW();
        bean.setAutoRelease(isAutoRelease);
        return (LNARCHIVEFLOW) bean.findFirstByWhere(sSqlWhere);
    }

    public static LNARCHIVEFLOW findFirstAndLock(String sSqlWhere, boolean isAutoRelease) {
        LNARCHIVEFLOW bean = new LNARCHIVEFLOW();
        bean.setAutoRelease(isAutoRelease);
        return (LNARCHIVEFLOW) bean.findFirstAndLockByWhere(sSqlWhere);
    }

    public static RecordSet findRecordSet(String sSqlWhere, boolean isAutoRelease) {
        LNARCHIVEFLOW bean = new LNARCHIVEFLOW();
        bean.setAutoRelease(isAutoRelease);
        return bean.findRecordSetByWhere(sSqlWhere);
    }

    public static List findByRow(String sSqlWhere, int row) {
        return new LNARCHIVEFLOW().findByWhereByRow(sSqlWhere, row);
    }

    String pkid;
    String flowsn;
    String operid;
    String roleid;
    String operdate;
    String opertime;
    String flowstat;
    String hanguptype;
    String hangupreason;
    String remark;
    int recversion;
    String operdatenext;
    String opertimenext;
    String operidnext;
    String roleidnext;
    String isclosed;
    String operdateclose;
    String opertimeclose;
    public static final String TABLENAME = "ln_archive_flow";
    private String operate_mode = "add";
    public ChangeFileds cf = new ChangeFileds();

    public String getTableName() {
        return TABLENAME;
    }

    public void addObject(List list, RecordSet rs) {
        LNARCHIVEFLOW abb = new LNARCHIVEFLOW();
        abb.pkid = rs.getString("pkid");
        abb.setKeyValue("PKID", "" + abb.getPkid());
        abb.flowsn = rs.getString("flowsn");
        abb.setKeyValue("FLOWSN", "" + abb.getFlowsn());
        abb.operid = rs.getString("operid");
        abb.setKeyValue("OPERID", "" + abb.getOperid());
        abb.roleid = rs.getString("roleid");
        abb.setKeyValue("ROLEID", "" + abb.getRoleid());
        abb.operdate = rs.getString("operdate");
        abb.setKeyValue("OPERDATE", "" + abb.getOperdate());
        abb.opertime = rs.getString("opertime");
        abb.setKeyValue("OPERTIME", "" + abb.getOpertime());
        abb.flowstat = rs.getString("flowstat");
        abb.setKeyValue("FLOWSTAT", "" + abb.getFlowstat());
        abb.hanguptype = rs.getString("hanguptype");
        abb.setKeyValue("HANGUPTYPE", "" + abb.getHanguptype());
        abb.hangupreason = rs.getString("hangupreason");
        abb.setKeyValue("HANGUPREASON", "" + abb.getHangupreason());
        abb.remark = rs.getString("remark");
        abb.setKeyValue("REMARK", "" + abb.getRemark());
        abb.recversion = rs.getInt("recversion");
        abb.setKeyValue("RECVERSION", "" + abb.getRecversion());
        abb.operdatenext = rs.getString("operdatenext");
        abb.setKeyValue("OPERDATENEXT", "" + abb.getOperdatenext());
        abb.opertimenext = rs.getString("opertimenext");
        abb.setKeyValue("OPERTIMENEXT", "" + abb.getOpertimenext());
        abb.operidnext = rs.getString("operidnext");
        abb.setKeyValue("OPERIDNEXT", "" + abb.getOperidnext());
        abb.roleidnext = rs.getString("roleidnext");
        abb.setKeyValue("ROLEIDNEXT", "" + abb.getRoleidnext());
        abb.isclosed = rs.getString("isclosed");
        abb.setKeyValue("ISCLOSED", "" + abb.getIsclosed());
        abb.operdateclose = rs.getString("operdateclose");
        abb.setKeyValue("OPERDATECLOSE", "" + abb.getOperdateclose());
        abb.opertimeclose = rs.getString("opertimeclose");
        abb.setKeyValue("OPERTIMECLOSE", "" + abb.getOpertimeclose());
        list.add(abb);
        abb.operate_mode = "edit";
    }

    public String getPkid() {
        if (this.pkid == null) return "";
        return this.pkid;
    }

    public String getFlowsn() {
        if (this.flowsn == null) return "";
        return this.flowsn;
    }

    public String getOperid() {
        if (this.operid == null) return "";
        return this.operid;
    }

    public String getRoleid() {
        if (this.roleid == null) return "";
        return this.roleid;
    }

    public String getOperdate() {
        if (this.operdate == null) return "";
        return this.operdate;
    }

    public String getOpertime() {
        if (this.opertime == null) return "";
        return this.opertime;
    }

    public String getFlowstat() {
        if (this.flowstat == null) return "";
        return this.flowstat;
    }

    public String getHanguptype() {
        if (this.hanguptype == null) return "";
        return this.hanguptype;
    }

    public String getHangupreason() {
        if (this.hangupreason == null) return "";
        return this.hangupreason;
    }

    public String getRemark() {
        if (this.remark == null) return "";
        return this.remark;
    }

    public int getRecversion() {
        return this.recversion;
    }

    public String getOperdatenext() {
        if (this.operdatenext == null) return "";
        return this.operdatenext;
    }

    public String getOpertimenext() {
        if (this.opertimenext == null) return "";
        return this.opertimenext;
    }

    public String getOperidnext() {
        if (this.operidnext == null) return "";
        return this.operidnext;
    }

    public String getRoleidnext() {
        if (this.roleidnext == null) return "";
        return this.roleidnext;
    }

    public String getIsclosed() {
        if (this.isclosed == null) return "";
        return this.isclosed;
    }

    public String getOperdateclose() {
        if (this.operdateclose == null) return "";
        return this.operdateclose;
    }

    public String getOpertimeclose() {
        if (this.opertimeclose == null) return "";
        return this.opertimeclose;
    }

    public void setPkid(String pkid) {
        sqlMaker.setField("pkid", pkid, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getPkid().equals(pkid)) cf.add("pkid", this.pkid, pkid);
        }
        this.pkid = pkid;
    }

    public void setFlowsn(String flowsn) {
        sqlMaker.setField("flowsn", flowsn, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getFlowsn().equals(flowsn)) cf.add("flowsn", this.flowsn, flowsn);
        }
        this.flowsn = flowsn;
    }

    public void setOperid(String operid) {
        sqlMaker.setField("operid", operid, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOperid().equals(operid)) cf.add("operid", this.operid, operid);
        }
        this.operid = operid;
    }

    public void setRoleid(String roleid) {
        sqlMaker.setField("roleid", roleid, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getRoleid().equals(roleid)) cf.add("roleid", this.roleid, roleid);
        }
        this.roleid = roleid;
    }

    public void setOperdate(String operdate) {
        sqlMaker.setField("operdate", operdate, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOperdate().equals(operdate)) cf.add("operdate", this.operdate, operdate);
        }
        this.operdate = operdate;
    }

    public void setOpertime(String opertime) {
        sqlMaker.setField("opertime", opertime, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOpertime().equals(opertime)) cf.add("opertime", this.opertime, opertime);
        }
        this.opertime = opertime;
    }

    public void setFlowstat(String flowstat) {
        sqlMaker.setField("flowstat", flowstat, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getFlowstat().equals(flowstat)) cf.add("flowstat", this.flowstat, flowstat);
        }
        this.flowstat = flowstat;
    }

    public void setHanguptype(String hanguptype) {
        sqlMaker.setField("hanguptype", hanguptype, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getHanguptype().equals(hanguptype)) cf.add("hanguptype", this.hanguptype, hanguptype);
        }
        this.hanguptype = hanguptype;
    }

    public void setHangupreason(String hangupreason) {
        sqlMaker.setField("hangupreason", hangupreason, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getHangupreason().equals(hangupreason)) cf.add("hangupreason", this.hangupreason, hangupreason);
        }
        this.hangupreason = hangupreason;
    }

    public void setRemark(String remark) {
        sqlMaker.setField("remark", remark, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getRemark().equals(remark)) cf.add("remark", this.remark, remark);
        }
        this.remark = remark;
    }

    public void setRecversion(int recversion) {
        sqlMaker.setField("recversion", "" + recversion, Field.NUMBER);
        if (this.operate_mode.equals("edit")) {
            if (this.getRecversion() != recversion) cf.add("recversion", this.recversion + "", recversion + "");
        }
        this.recversion = recversion;
    }

    public void setOperdatenext(String operdatenext) {
        sqlMaker.setField("operdatenext", operdatenext, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOperdatenext().equals(operdatenext)) cf.add("operdatenext", this.operdatenext, operdatenext);
        }
        this.operdatenext = operdatenext;
    }

    public void setOpertimenext(String opertimenext) {
        sqlMaker.setField("opertimenext", opertimenext, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOpertimenext().equals(opertimenext)) cf.add("opertimenext", this.opertimenext, opertimenext);
        }
        this.opertimenext = opertimenext;
    }

    public void setOperidnext(String operidnext) {
        sqlMaker.setField("operidnext", operidnext, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOperidnext().equals(operidnext)) cf.add("operidnext", this.operidnext, operidnext);
        }
        this.operidnext = operidnext;
    }

    public void setRoleidnext(String roleidnext) {
        sqlMaker.setField("roleidnext", roleidnext, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getRoleidnext().equals(roleidnext)) cf.add("roleidnext", this.roleidnext, roleidnext);
        }
        this.roleidnext = roleidnext;
    }

    public void setIsclosed(String isclosed) {
        sqlMaker.setField("isclosed", isclosed, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getIsclosed().equals(isclosed)) cf.add("isclosed", this.isclosed, isclosed);
        }
        this.isclosed = isclosed;
    }

    public void setOperdateclose(String operdateclose) {
        sqlMaker.setField("operdateclose", operdateclose, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOperdateclose().equals(operdateclose))
                cf.add("operdateclose", this.operdateclose, operdateclose);
        }
        this.operdateclose = operdateclose;
    }

    public void setOpertimeclose(String opertimeclose) {
        sqlMaker.setField("opertimeclose", opertimeclose, Field.TEXT);
        if (this.operate_mode.equals("edit")) {
            if (!this.getOpertimeclose().equals(opertimeclose))
                cf.add("opertimeclose", this.opertimeclose, opertimeclose);
        }
        this.opertimeclose = opertimeclose;
    }

    public void init(int i, ActionRequest actionRequest) throws Exception {
        if (actionRequest.getFieldValue(i, "pkid") != null) {
            this.setPkid(actionRequest.getFieldValue(i, "pkid"));
        }
        if (actionRequest.getFieldValue(i, "flowsn") != null) {
            this.setFlowsn(actionRequest.getFieldValue(i, "flowsn"));
        }
        if (actionRequest.getFieldValue(i, "operid") != null) {
            this.setOperid(actionRequest.getFieldValue(i, "operid"));
        }
        if (actionRequest.getFieldValue(i, "roleid") != null) {
            this.setRoleid(actionRequest.getFieldValue(i, "roleid"));
        }
        if (actionRequest.getFieldValue(i, "operdate") != null) {
            this.setOperdate(actionRequest.getFieldValue(i, "operdate"));
        }
        if (actionRequest.getFieldValue(i, "opertime") != null) {
            this.setOpertime(actionRequest.getFieldValue(i, "opertime"));
        }
        if (actionRequest.getFieldValue(i, "flowstat") != null) {
            this.setFlowstat(actionRequest.getFieldValue(i, "flowstat"));
        }
        if (actionRequest.getFieldValue(i, "hanguptype") != null) {
            this.setHanguptype(actionRequest.getFieldValue(i, "hanguptype"));
        }
        if (actionRequest.getFieldValue(i, "hangupreason") != null) {
            this.setHangupreason(actionRequest.getFieldValue(i, "hangupreason"));
        }
        if (actionRequest.getFieldValue(i, "remark") != null) {
            this.setRemark(actionRequest.getFieldValue(i, "remark"));
        }
        if (actionRequest.getFieldValue(i, "recversion") != null && actionRequest.getFieldValue(i, "recversion").trim().length() > 0) {
            this.setRecversion(Integer.parseInt(actionRequest.getFieldValue(i, "recversion")));
        }
        if (actionRequest.getFieldValue(i, "operdatenext") != null) {
            this.setOperdatenext(actionRequest.getFieldValue(i, "operdatenext"));
        }
        if (actionRequest.getFieldValue(i, "opertimenext") != null) {
            this.setOpertimenext(actionRequest.getFieldValue(i, "opertimenext"));
        }
        if (actionRequest.getFieldValue(i, "operidnext") != null) {
            this.setOperidnext(actionRequest.getFieldValue(i, "operidnext"));
        }
        if (actionRequest.getFieldValue(i, "roleidnext") != null) {
            this.setRoleidnext(actionRequest.getFieldValue(i, "roleidnext"));
        }
        if (actionRequest.getFieldValue(i, "isclosed") != null) {
            this.setIsclosed(actionRequest.getFieldValue(i, "isclosed"));
        }
        if (actionRequest.getFieldValue(i, "operdateclose") != null) {
            this.setOperdateclose(actionRequest.getFieldValue(i, "operdateclose"));
        }
        if (actionRequest.getFieldValue(i, "opertimeclose") != null) {
            this.setOpertimeclose(actionRequest.getFieldValue(i, "opertimeclose"));
        }
    }

    public void init(ActionRequest actionRequest) throws Exception {
        this.init(0, actionRequest);
    }

    public void initAll(int i, ActionRequest actionRequest) throws Exception {
        this.init(i, actionRequest);
    }

    public void initAll(ActionRequest actionRequest) throws Exception {
        this.initAll(0, actionRequest);
    }

    public Object clone() throws CloneNotSupportedException {
        LNARCHIVEFLOW obj = (LNARCHIVEFLOW) super.clone();
        obj.setPkid(obj.pkid);
        obj.setFlowsn(obj.flowsn);
        obj.setOperid(obj.operid);
        obj.setRoleid(obj.roleid);
        obj.setOperdate(obj.operdate);
        obj.setOpertime(obj.opertime);
        obj.setFlowstat(obj.flowstat);
        obj.setHanguptype(obj.hanguptype);
        obj.setHangupreason(obj.hangupreason);
        obj.setRemark(obj.remark);
        obj.setRecversion(obj.recversion);
        obj.setOperdatenext(obj.operdatenext);
        obj.setOpertimenext(obj.opertimenext);
        obj.setOperidnext(obj.operidnext);
        obj.setRoleidnext(obj.roleidnext);
        obj.setIsclosed(obj.isclosed);
        obj.setOperdateclose(obj.operdateclose);
        obj.setOpertimeclose(obj.opertimeclose);
        return obj;
    }
}