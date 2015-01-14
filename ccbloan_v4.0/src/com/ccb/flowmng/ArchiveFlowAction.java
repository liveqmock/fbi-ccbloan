package com.ccb.flowmng;

import com.ccb.dao.LNARCHIVEFLOW;
import com.ccb.dao.LNARCHIVEINFO;
import com.ccb.dao.LNTASKINFO;
import com.ccb.dao.PTOPERROLE;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.form.control.Action;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class ArchiveFlowAction extends Action {
    // 日志对象
    private static final Log logger = LogFactory.getLog(ArchiveFlowAction.class);
    // 贷款信息对象
    LNARCHIVEFLOW flow = null;
    // 流水日志表
    LNTASKINFO task = null;

    public int add() {
        flow = new LNARCHIVEFLOW();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                String[] flowsnArr = req.getFieldValue(i, "flowsn").split("\r\n");

                //检查是否存在主档信息
                for (String flowsn : flowsnArr) {
                    LNARCHIVEINFO lnarchiveinfo = LNARCHIVEINFO.findFirst(" where flowsn='" + flowsn + "'");
                    if (lnarchiveinfo == null) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ARCHIVE_FLOW添加失败, 此笔贷款资料未初始化，流水号：" + flowsn);
                        return -1;
                    }
                }

                String flowstat = req.getFieldValue(i, "flowstat");
                String remark = req.getFieldValue(i, "AF_REMARK");
                for (String flowsn : flowsnArr) {
                    String operid = this.getOperator().getOperid();
                    String operdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                    String opertime = new SimpleDateFormat("HH:mm:ss").format(new Date());

                    //20150113 zr for 田琨工作量日报表 修改同一流水号的上一个岗位的转交信息
                    LNARCHIVEFLOW lastflow = LNARCHIVEFLOW.findFirst(" where flowsn = '" + flowsn.trim() + "' order by operdate desc, opertime desc");
                    if (lastflow != null) {
                        lastflow.setOperidnext(operid);
                        lastflow.setOperdatenext(operdate);
                        lastflow.setOpertimenext(opertime);
                        lastflow.updateByWhere(" where pkid='" + lastflow.getPkid() + "'");
                    }

                    //档案流程表
                    LNARCHIVEFLOW flow = new LNARCHIVEFLOW();
                    flow.setPkid(UUID.randomUUID().toString());
                    flow.setFlowsn(flowsn.trim());
                    flow.setFlowstat(flowstat);
                    flow.setHanguptype("");
                    flow.setHangupreason("");
                    flow.setRemark(remark);
                    flow.setOperdate(operdate);
                    flow.setOpertime(opertime);
                    flow.setOperid(operid);
                    flow.setRecversion(0);
                    flow.setIsclosed("0");

                    //获取岗位ID
                    flow.setRoleid("");
                    PTOPERROLE ptoperrole = PTOPERROLE.findFirst(" where operid='" + operid + "' and roleid like 'WF%'");
                    if (ptoperrole != null) {
                        flow.setRoleid(ptoperrole.getRoleid());
                    } else {
                        ptoperrole = PTOPERROLE.findFirst(" where operid='" + operid + "'");
                        if (ptoperrole != null)
                            flow.setRoleid(ptoperrole.getRoleid());
                    }

                    if (flow.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ARCHIVE_FLOW添加失败。");
                        return -1;
                    }


                    // 流水日志表
                    task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:ADD", CcbLoanConst.OPER_ADD);
                    task.setOperid(operid);
                    task.setBankid(this.getOperator().getDeptid());
                    if (task.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("操作日志表处理错误.");
                        return -1;
                    }
                    Thread.sleep(50);
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("处理异常.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("处理成功.");
        return 0;
    }

    public int close() {
        flow = new LNARCHIVEFLOW();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                String pkid = req.getFieldValue(i, "pkid").trim();

                String operid = this.getOperator().getOperid();
                String operdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                String opertime = new SimpleDateFormat("HH:mm:ss").format(new Date());

                //档案流程表
                LNARCHIVEFLOW flow = LNARCHIVEFLOW.findFirst(" where pkid='" + pkid + "'");
                if (flow != null) {
                    if (!"20".equals(flow.getFlowstat())) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("非挂起状态下不能进行终止处理。");
                        return -1;
                    }
                    flow.setRecversion(flow.getRecversion() + 1);
                    flow.setIsclosed("1");
                    flow.setOperdateclose(operdate);
                    flow.setOpertimeclose(opertime);
                    if (flow.updateByWhere(" where pkid='" + pkid + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("终止失败。");
                        return -1;
                    }
                } else {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("终止失败, 未找到对应记录。");
                    return -1;
                }


                // 流水日志表
                task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:CLOSE", "CLOSE");
                task.setOperid(operid);
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("操作日志表处理错误.");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("处理异常.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("处理成功.");
        return 0;
    }
    public int unclose() {
        flow = new LNARCHIVEFLOW();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                String pkid = req.getFieldValue(i, "pkid").trim();

                String operid = this.getOperator().getOperid();
                String operdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                String opertime = new SimpleDateFormat("HH:mm:ss").format(new Date());

                //档案流程表
                LNARCHIVEFLOW flow = LNARCHIVEFLOW.findFirst(" where pkid='" + pkid + "'");
                if (flow != null) {
                    flow.setRecversion(flow.getRecversion() + 1);
                    flow.setIsclosed("0");
                    flow.setOperdateclose("");
                    flow.setOpertimeclose("");
                    if (flow.updateByWhere(" where pkid='" + pkid + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ARCHIVE_FLOW撤销终止失败。");
                        return -1;
                    }
                }else {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("撤销终止失败, 未找到对应记录。");
                    return -1;
                }


                // 流水日志表
                task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:UNCLOSE", "UNCLOSE");
                task.setOperid(operid);
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("操作日志表处理错误.");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("处理异常.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("处理成功.");
        return 0;
    }
}
