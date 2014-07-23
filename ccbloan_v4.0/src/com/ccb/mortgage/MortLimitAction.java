package com.ccb.mortgage;

/**
 * <p>Title: ��̨ҵ�����</p>
 *
 * <p>Description: ��̨ҵ�����</p>
 *
 * <p>Copyright: Copyright (c) 2010</p>
 *
 * <p>Company: ��˾</p>
 *
 * @author leonwoo
 * @version 1.0
 */

import com.ccb.dao.*;
import com.ccb.util.CcbLoanConst;
import com.ccb.util.SeqUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.db.SequenceManager;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;
import pub.platform.utils.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class MortLimitAction extends Action {
    // ��־����
    private static final Log logger = LogFactory.getLog(MortLimitAction.class);
    //��������
    LNMORTLIMIT mortLimit = null;
    // �ϺŹ������
    SYSSEQDISCARD seqInfoDiscard = null;

    // ��ˮ��¼��
    LNTASKINFO task = null;

    /**
     * <p/>
     * ��Ѻ��Ϣ���ӽӿ�
     * <p/>
     * �ɹ���ʧ�ܾ�������Ϣ
     * <p/>
     * ����id���û�id������ʱ����ں�̨��ֵ
     *
     * @return
     */
    public int add() {
        mortLimit = new LNMORTLIMIT();
        // ȡ����Ѻ���
        String mortID = "";
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {

                // ��ʼ������bean
                mortLimit.initAll(i, req);
                mortLimit .setLimitdate(Integer.parseInt(req.getFieldValue(i, "limitDate")));
                mortLimit.setMortecentercd(req.getFieldValue(i, "mortecentercd"));
                mortLimit.setLn_typ("009");

                if (mortLimit.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }
        }
        this.res.setResult(true);
        return 0;

    }

    /**
     * <p/>
     * ��Ѻ��Ϣ�༭�ӿ�
     * <p/>
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * <p/>
     * ����ǰ���а汾�ż�飬���Ʋ�������
     *
     * @return
     */
    public int edit() {

        mortLimit = new LNMORTLIMIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                mortLimit.initAll(i, req);
                mortLimit.setLimitdate(Integer.parseInt( req.getFieldValue(i, "limitDate")));

                if (mortLimit.updateByWhere(" where mortecentercd='" + req.getFieldValue(i, "mortecentercd") + "' and ln_typ='009'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
             } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                //this.res.setMessage(PropertyManager.getProperty("300"));
                this.res.setMessage("����ʧ�ܣ�" + ex1.getMessage());
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }

    /**
     * <p/>
     * ɾ���ӿ�
     * <p/>
     * ɾ��һ����¼�󣬵�Ѻ���Ҫ������������������Ա��´μ���ʹ��
     */
    public int delete() {
        seqInfoDiscard = new SYSSEQDISCARD();

        try {
            // ��Ѻ���
            String mortID = req.getFieldValue("mortID");
            // ��Ѻ��ŵò������������ʾ����ʧ��
            if (mortID == null || mortID.equalsIgnoreCase("null")) {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }

            /** ��Ѻ��ű���������������� */
            // �������
            seqInfoDiscard.setBhlx(CcbLoanConst.MORTTYPE);
            // ��Ѻ���
            seqInfoDiscard.setDiscardno(mortID);
            // ʹ�ñ�־: δʹ��״̬��
            seqInfoDiscard.setUseflg(0);
            // ԭ��ϵҵ�����:�����������
            seqInfoDiscard.setOseqno(req.getFieldValue("loanID"));
            // ��������
            seqInfoDiscard.setIndate(BusinessDate.getNowDay());
            // ������Ա
            seqInfoDiscard.setInoperid(this.getOperator().getOperid());
            // ��������
            seqInfoDiscard.setDotype("delete");

            if (seqInfoDiscard.insert() < 0) {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }

            // ɾ����Ѻ��Ϣ
            dc.executeUpdate("delete from ln_mortinfo where mortid='" + mortID + "'");
            // ��ˮ��־��
            task = MortUtil.getTaskObj(req.getFieldValue("loanid"), req.getFieldValue("busiNode"),
                    CcbLoanConst.OPER_DEL);
            task.setOperid(this.getOperator().getOperid());
            task.setBankid(this.getOperator().getDeptid());
            if (task.insert() < 0) {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        return 0;
    }

    /**
     * <p/>
     * ����û�ֱ���˳���Ѻ����ҳ�棬��������ɵĵ�Ѻ��ŷŽ����������Ա��´�ʹ��
     * <p/>
     */
    public int saveMortID_bak() {
        seqInfoDiscard = new SYSSEQDISCARD();

        try {
            // ��Ѻ���
            String mortID = req.getFieldValue("mortID");
            /** ��Ѻ��ű���������������� */
            // ҵ������
            seqInfoDiscard.setBhlx(CcbLoanConst.MORTTYPE);
            // ���
            seqInfoDiscard.setDiscardno(mortID);
            // ʹ�ñ�־: δʹ��״̬��
            seqInfoDiscard.setUseflg(0);
            // ԭ��ϵҵ�����:�����������
            seqInfoDiscard.setOseqno(req.getFieldValue("loanID"));

            /** ���жϷϺŹ���������޸�û��ʹ�õ���ţ����û�������� */
            RecordSet rs = dc.executeQuery("select 1 from sys_seq_discard where bhlx='" + CcbLoanConst.MORTTYPE
                    + "' and discardno='" + mortID + "' and useflg='0'");
            if (!rs.next()) {
                if (seqInfoDiscard.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
            } else {
                // do nothing
            }
            if (rs != null) {
                rs.close();
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error(e.getMessage());
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        return 0;
    }

    /**
     * <p/>
     * �������
     * <p/>
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * <p/>
     * ����ǰ���а汾�ż�飬���Ʋ�������
     *
     * @return
     */
    public int batchEdit() {

        mortLimit= new LNMORTLIMIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                mortLimit.initAll(i, req);
                String appt_remark_old = "";
                if (req.getFieldValue(i, "limitDate") != null) {
                    mortLimit.setLimitdate(Integer.parseInt(req.getFieldValue(i, "limitDate")));
                }
                if (mortLimit.updateByWhere(" where mortecentercd='" + req.getFieldValue(i, "mortecentercd") + "' and ln_typ='009'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }
        }

        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }
}
