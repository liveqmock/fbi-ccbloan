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
    // ��־����
    private static final Log logger = LogFactory.getLog(ArchiveFlowAction.class);
    // ������Ϣ����
    LNARCHIVEFLOW flow = null;
    // ��ˮ��־��
    LNTASKINFO task = null;

    public int add() {
        flow = new LNARCHIVEFLOW();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                String[] flowsnArr = req.getFieldValue(i, "flowsn").split("\r\n");

                //����Ƿ����������Ϣ
                for (String flowsn : flowsnArr) {
                    LNARCHIVEINFO lnarchiveinfo = LNARCHIVEINFO.findFirst(" where flowsn='" + flowsn + "'");
                    if (lnarchiveinfo == null) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ARCHIVE_FLOW���ʧ��, �˱ʴ�������δ��ʼ������ˮ�ţ�" + flowsn);
                        return -1;
                    }
                }

                String flowstat = req.getFieldValue(i, "flowstat");
                String remark = req.getFieldValue(i, "AF_REMARK");
                for (String flowsn : flowsnArr) {
                    String operid = this.getOperator().getOperid();
                    String operdate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
                    String opertime = new SimpleDateFormat("HH:mm:ss").format(new Date());

                    //20150113 zr for �����������ձ��� �޸�ͬһ��ˮ�ŵ���һ����λ��ת����Ϣ
                    LNARCHIVEFLOW lastflow = LNARCHIVEFLOW.findFirst(" where flowsn = '" + flowsn.trim() + "' order by operdate desc, opertime desc");
                    if (lastflow != null) {
                        lastflow.setOperidnext(operid);
                        lastflow.setOperdatenext(operdate);
                        lastflow.setOpertimenext(opertime);
                        lastflow.updateByWhere(" where pkid='" + lastflow.getPkid() + "'");
                    }

                    //�������̱�
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

                    //��ȡ��λID
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
                        this.res.setMessage("LN_ARCHIVE_FLOW���ʧ�ܡ�");
                        return -1;
                    }


                    // ��ˮ��־��
                    task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:ADD", CcbLoanConst.OPER_ADD);
                    task.setOperid(operid);
                    task.setBankid(this.getOperator().getDeptid());
                    if (task.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("������־�������.");
                        return -1;
                    }
                    Thread.sleep(50);
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�����쳣.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("����ɹ�.");
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

                //�������̱�
                LNARCHIVEFLOW flow = LNARCHIVEFLOW.findFirst(" where pkid='" + pkid + "'");
                if (flow != null) {
                    if (!"20".equals(flow.getFlowstat())) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("�ǹ���״̬�²��ܽ�����ֹ����");
                        return -1;
                    }
                    flow.setRecversion(flow.getRecversion() + 1);
                    flow.setIsclosed("1");
                    flow.setOperdateclose(operdate);
                    flow.setOpertimeclose(opertime);
                    if (flow.updateByWhere(" where pkid='" + pkid + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("��ֹʧ�ܡ�");
                        return -1;
                    }
                } else {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("��ֹʧ��, δ�ҵ���Ӧ��¼��");
                    return -1;
                }


                // ��ˮ��־��
                task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:CLOSE", "CLOSE");
                task.setOperid(operid);
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("������־�������.");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�����쳣.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("����ɹ�.");
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

                //�������̱�
                LNARCHIVEFLOW flow = LNARCHIVEFLOW.findFirst(" where pkid='" + pkid + "'");
                if (flow != null) {
                    flow.setRecversion(flow.getRecversion() + 1);
                    flow.setIsclosed("0");
                    flow.setOperdateclose("");
                    flow.setOpertimeclose("");
                    if (flow.updateByWhere(" where pkid='" + pkid + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ARCHIVE_FLOW������ֹʧ�ܡ�");
                        return -1;
                    }
                }else {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("������ֹʧ��, δ�ҵ���Ӧ��¼��");
                    return -1;
                }


                // ��ˮ��־��
                task = MortUtil.getTaskObj(flow.getPkid(), "ArchiveFlowAction:UNCLOSE", "UNCLOSE");
                task.setOperid(operid);
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("������־�������.");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�����쳣.");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("����ɹ�.");
        return 0;
    }
}
