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

import com.ccb.dao.LNARCHIVEINFO;
import com.ccb.dao.LNLOANAPPLY;
import com.ccb.dao.LNPROMOTIONCUSTOMERS;
import com.ccb.dao.LNTASKINFO;
import com.ccb.util.CcbLoanConst;
import com.ccb.util.SeqUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.DBUtil;
import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;

public class loanAction extends Action {
    // ��־����
    private static final Log logger = LogFactory.getLog(loanAction.class);
    // ������Ϣ����
    LNLOANAPPLY loan = null;
    // ��ˮ��־��
    LNTASKINFO task = null;
    //Ӫ���ͻ���
    LNPROMOTIONCUSTOMERS lnpromcust = null;

    /**
     * <p/>
     * ������Ϣ���ӽӿ�
     * <p/>
     * �ɹ���ʧ�ܾ�������Ϣ
     * <p/>
     * ����id���û�id������ʱ����ں�̨��ֵ
     *
     * @return
     */
    public int add() {
        loan = new LNLOANAPPLY();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��������������ظ�
                RecordSet rec = dc.executeQuery("select 1 from ln_loanapply where loanid='"
                        + req.getFieldValue(i, "loanid").trim() + "'");
                while (rec.next()) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("303") + "\r\n����������ţ�"
                            + req.getFieldValue(i, "loanid").trim());
                    return -1;
                }
                if (rec != null) {
                    rec.close();
                }

                // ��Ŀ�����Ҫ��飬�Ƿ��ں�����Ŀ���д��ڣ�
                if (!req.getFieldValue(i, "PROJ_NO").trim().equals("")) {
                    rec = dc.executeQuery(" select count(1) as count from LN_COOPPROJ where PROJ_NO='"
                            + req.getFieldValue(i, "PROJ_NO").trim() + "'");
                    while (rec.next()) {
                        if (rec.getInt(0) == 0) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage(PropertyManager.getProperty("306") + "\r\n��Ŀ��ţ�"
                                    + req.getFieldValue(i, "PROJ_NO").trim());
                            return -1;
                        }
                    }
                    if (rec != null) {
                        rec.close();
                    }
                }
                // ��ʼ������bean
                loan.initAll(i, req);
                // ����id
                loan.setDeptid(this.getDept().getDeptid());
                // ����ʱ��
                loan.setOperdate(BusinessDate.getToday());
                // �û�id
                loan.setOperid2(this.getOperator().getOperid());
                // �汾��
                loan.setRecversion(0);
                // �����ڲ����
                String nbxh = SeqUtil.getNbxh();
                loan.setNbxh(nbxh);
                // �����Ƿ������,1:����������
                loan.setNeedaddcd("1");
                // ���ֶ�Ӧƴ��
                loan.setCust_py(DBUtil.getSpell(this.dc, req.getFieldValue(i, "cust_name")));
                if (loan.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

                String promcust_no = req.getFieldValue(i, "PROMCUST_NO");
                if (StringUtils.isNotEmpty(promcust_no)) {//����Ӫ���ͻ���
                    lnpromcust = new LNPROMOTIONCUSTOMERS();
                    //���״̬���� �� �ѹ���������Ϣ
                    lnpromcust.setStatus(4);
                    lnpromcust.setLoanid(req.getFieldValue(i, "loanID"));
                    lnpromcust.setRt_orig_loan_amt(loan.getRt_orig_loan_amt());
                    lnpromcust.setBankid(loan.getBankid());                        //������
                    lnpromcust.setPrommgr_id(loan.getCustmgr_id());                //Ӫ������ID
                    lnpromcust.setCust_bankid(req.getFieldValue(i,"CUST_BANKID")); //��Ӫ����
                    lnpromcust.setCustmgr_id(req.getFieldValue(i,"REALCUSTMGR_ID"));//�ͻ�����Id
                    lnpromcust.setOperid2(this.getOperator().getOperid());
                    lnpromcust.setOperdate(BusinessDate.getTodaytime());
                    if (lnpromcust.updateByWhere(" where PROMCUST_NO='" + promcust_no + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("Ӫ���ͻ������ݸ��´���");
                        return -1;
                    }
                } else {//����Ӫ����Ϣ��������
                    lnpromcust = new LNPROMOTIONCUSTOMERS();
                    String promotionCustNo = SeqUtil.getPromontioncustno();
                    lnpromcust.setPromcust_no(promotionCustNo);
                    lnpromcust.setCust_name(loan.getCust_name());
                    lnpromcust.setLn_typ(loan.getLn_typ());
                    lnpromcust.setPrommgr_id(loan.getCustmgr_id());
                    lnpromcust.setRt_orig_loan_amt(loan.getRt_orig_loan_amt());
                    lnpromcust.setCustmgr_id(req.getFieldValue(i, "REALCUSTMGR_ID"));
                    lnpromcust.setStatus(4);
                    //����ʱ�� ����
                    lnpromcust.setOperdate(BusinessDate.getTodaytime());
                    //������Ա
                    lnpromcust.setOperid2(this.getOperator().getOperid());
                    //������
                    lnpromcust.setBankid(loan.getBankid());
                    //��Ӫ����
                    lnpromcust.setCust_bankid(req.getFieldValue(i, "CUST_BANKID"));
                    lnpromcust.setRt_term_incr(req.getFieldIntValue(i, "RT_TERM_INCR"));
                    lnpromcust.setLoanid(loan.getLoanid());
                    if (lnpromcust.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("Ӫ���ͻ����������ݴ������.");
                        return -1;
                    }
                }

                //20130222 zr ����������Ϣ���еĴ��������
                if (updateArchiveInfo_loanid(i) == -1) return -1;


                // ��ˮ��־��
                task = MortUtil.getTaskObj(nbxh, req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("������־�������.");
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                //ex1.printStackTrace();
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

    private int updateArchiveInfo_loanid(int i) {
        LNARCHIVEINFO lnarchiveinfo = new LNARCHIVEINFO();
        lnarchiveinfo = (LNARCHIVEINFO) lnarchiveinfo.findFirstByWhere(" where flowsn = '" + req.getFieldValue(i, "flowsn") + "'");
        if (lnarchiveinfo == null) {
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage("����ln_archive_info���loanid����");
            return -1;
        }

        if((lnarchiveinfo.getBankid()==null)||("".equals(lnarchiveinfo.getBankid()))){
            lnarchiveinfo.setBankid((req.getFieldValue(i,"BANKID")));
            lnarchiveinfo.setCustmgr_id(req.getFieldValue(i,"CUSTMGR_ID"));
        }

        lnarchiveinfo.setLoanid(req.getFieldValue(i, "loanID"));
        lnarchiveinfo.setRecversion(lnarchiveinfo.getRecversion() + 1);
        if (lnarchiveinfo.updateByWhere(" where flowsn='" + req.getFieldValue(i, "flowsn") + "'") < 0) {
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage("����ln_archive_info���loanid����");
            return -1;
        }
        return 0;
    }

    /**
     * <p/>
     * �༭�ӿ�
     * <p/>
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * <p/>
     * ����ǰ���а汾�ż�飬���Ʋ�������
     *
     * @return
     */
    public int edit() {

        loan = new LNLOANAPPLY();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��Ŀ�����Ҫ��飬�Ƿ��ں�����Ŀ���д��ڣ�
                if (!req.getFieldValue(i, "PROJ_NO").trim().equals("")) {
                    RecordSet rec = dc.executeQuery(" select count(1) as count from LN_COOPPROJ where PROJ_NO='"
                            + req.getFieldValue(i, "PROJ_NO").trim() + "'");
                    while (rec.next()) {
                        if (rec.getInt(0) == 0) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage(PropertyManager.getProperty("306") + "\r\n��Ŀ��ţ�"
                                    + req.getFieldValue(i, "PROJ_NO").trim());
                            return -1;
                        }
                    }
                    if (rec != null) {
                        rec.close();
                    }
                }
                // ��ʼ������bean
                loan.initAll(i, req);

                //20100504 zhan ����ظ�����Ŀ�����
                if (loan.getLoanid() != null && loan.getLoanid() != "") {
                    LNLOANAPPLY loantmp = loan.findFirst(" where  loanid = '" + loan.getLoanid() + "'");
                    if (loantmp != null) {
                        if (!loantmp.getNbxh().equals(loan.getNbxh())) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�޸Ĵ�����Ϣʱ���ִ���, �˴���������Ѵ��ڡ�");
                            return -1;
                        }
                    }
                }


                // ����ʱ��
                loan.setOperdate(BusinessDate.getToday());
                // ����id
                loan.setDeptid(this.getDept().getDeptid());
                // �û�id
                loan.setOperid2(this.getOperator().getOperid());
                // ���ֶ�Ӧƴ��
                loan.setCust_py(DBUtil.getSpell(this.dc, req.getFieldValue(i, "cust_name")));
                // ����ǰ�汾��
                int iBeforeVersion = 0;
                if (req.getFieldValue(i, "recVersion") != null && !req.getFieldValue(i, "recVersion").equals("")) {
                    iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                }
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_loanapply where nbxh='"
                        + req.getFieldValue(i, "nbxh") + "'");
                while (rs.next()) {
                    iAfterVersion = rs.getInt("recVersion");
                    if (iBeforeVersion != iAfterVersion) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("301"));
                        return -1;
                    } else {
                        // �汾�ż�1
                        iBeforeVersion = iBeforeVersion + 1;
                        loan.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }

                if (loan.updateByWhere(" where nbxh='" + req.getFieldValue(i, "nbxh") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

                //����Ӫ���ͻ��� ǰ�ͻ���ŵĴ��������
                String prev_promcust_no = req.getFieldValue(i, "prev_promcust_no");
                String promcust_no = req.getFieldValue(i, "PROMCUST_NO");
                if (StringUtils.isNotEmpty(prev_promcust_no)) {
                    if (!prev_promcust_no.equals(promcust_no)) {
                        LNPROMOTIONCUSTOMERS prev_lnpromcust = new LNPROMOTIONCUSTOMERS();
                        prev_lnpromcust.setLoanid("");
                        prev_lnpromcust.setStatus(2);
                        prev_lnpromcust.setOperid2(this.getOperator().getOperid());
                        prev_lnpromcust.setOperdate(BusinessDate.getTodaytime());
                        if (prev_lnpromcust.updateByWhere(" where PROMCUST_NO='" + prev_promcust_no + "'") < 0) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage(PropertyManager.getProperty("300"));
                            return -1;
                        }
                    }
                }
                //if����Ӫ���ͻ��� else �����¼�¼
                if (promcust_no != null && !StringUtils.isEmpty(promcust_no)) {
                    lnpromcust = new LNPROMOTIONCUSTOMERS();
//                    lnpromcust.init(i, req);
                    //���״̬���� �� �ѹ���������Ϣ
                    lnpromcust.setStatus(4);
                    lnpromcust.setLoanid(req.getFieldValue(i, "loanID"));
                    lnpromcust.setCust_name(loan.getCust_name());
                    lnpromcust.setRt_orig_loan_amt(loan.getRt_orig_loan_amt());
                    lnpromcust.setBankid(loan.getBankid());                        //������
                    lnpromcust.setPrommgr_id(loan.getCustmgr_id());                //Ӫ������ID
                    lnpromcust.setCust_bankid(req.getFieldValue(i,"CUST_BANKID")); //��Ӫ����
                    lnpromcust.setCustmgr_id(req.getFieldValue(i,"REALCUSTMGR_ID"));//�ͻ�����Id
                    lnpromcust.setOperid2(this.getOperator().getOperid());
                    lnpromcust.setOperdate(BusinessDate.getTodaytime());
                    if (lnpromcust.updateByWhere(" where PROMCUST_NO='" + promcust_no + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                } else {
                    lnpromcust = new LNPROMOTIONCUSTOMERS();
                    String promotionCustNo = SeqUtil.getPromontioncustno();
                    lnpromcust.setPromcust_no(promotionCustNo);
                    lnpromcust.setCust_name(loan.getCust_name());
                    lnpromcust.setLn_typ(loan.getLn_typ());
                    lnpromcust.setPrommgr_id(loan.getCustmgr_id());
                    lnpromcust.setRt_orig_loan_amt(loan.getRt_orig_loan_amt());
                    lnpromcust.setCustmgr_id(req.getFieldValue(i, "REALCUSTMGR_ID"));
                    lnpromcust.setStatus(4);
                    //����ʱ�� ����
                    lnpromcust.setOperdate(BusinessDate.getTodaytime());
                    //������Ա
                    lnpromcust.setOperid2(this.getOperator().getOperid());
                    //������
                    lnpromcust.setBankid(loan.getBankid());
                    //��Ӫ����
                    lnpromcust.setCust_bankid(req.getFieldValue(i, "CUST_BANKID"));
                    lnpromcust.setRt_term_incr(req.getFieldIntValue(i, "RT_TERM_INCR"));
                    lnpromcust.setLoanid(loan.getLoanid());
                    if (lnpromcust.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                }

                //20130222 zr ����������Ϣ���еĴ��������
                if (updateArchiveInfo_loanid(i) == -1) return -1;

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "nbxh"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
            } catch (Exception ex1) {
                logger.error(ex1.getMessage());
                ex1.printStackTrace();
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

    /**
     * <p/>
     * ɾ���ӿ�
     * <p/>
     * ɾ��һ����¼
     */
    public int delete() {
        loan = new LNLOANAPPLY();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                loan.initAll(i, req);
                // ɾ����Ϣ
                if (loan.deleteByWhere(" where nbxh='" + req.getFieldValue(i, "nbxh") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                //ɾ��Ӫ���ͻ���
                if (req.getFieldValue(i, "PROMCUST_NO") != null && !StringUtils.isEmpty(req.getFieldValue(i, "PROMCUST_NO"))) {
                    lnpromcust = new LNPROMOTIONCUSTOMERS();
//                    lnpromcust.init(i, req);
                    //���״̬���� �� �ѹ���������Ϣ
                    if (lnpromcust.deleteByWhere(" where PROMCUST_NO='" + req.getFieldValue(i, "PROMCUST_NO") + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "nbxh"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_DEL);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        return 0;
    }

    /**
     * ����
     */
    public int confirmCLM() {
        loan = new LNLOANAPPLY();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                // loan.initAll(i, req);
                loan.setCustmgr_id(this.getOperator().getOperid());
                // ---�汾�ż��--
                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_loanapply where nbxh='"
                        + req.getFieldValue(i, "nbxh") + "'");
                while (rs.next()) {
                    iAfterVersion = rs.getInt("recVersion");
                    if (iBeforeVersion != iAfterVersion) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("301"));
                        return -1;
                    } else {
                        // �汾�ż�1
                        iBeforeVersion = iBeforeVersion + 1;
                        loan.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }
                // ---�汾�ż��--
                // ������Ϣ
                if (loan.updateByWhere(" where nbxh='" + req.getFieldValue(i, "nbxh") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "nbxh"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_CLM);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }

    /**
     * �˻�
     */
    public int cancelCLM() {
        loan = new LNLOANAPPLY();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                // loan.initAll(i, req);
                loan.setCustmgr_id("");
                // ---�汾�ż��--
                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_loanapply where nbxh='"
                        + req.getFieldValue(i, "nbxh") + "'");
                while (rs.next()) {
                    iAfterVersion = rs.getInt("recVersion");
                    if (iBeforeVersion != iAfterVersion) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("301"));
                        return -1;
                    } else {
                        // �汾�ż�1
                        iBeforeVersion = iBeforeVersion + 1;
                        loan.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }
                // ---�汾�ż��--
                // ������Ϣ
                if (loan.updateByWhere(" where nbxh='" + req.getFieldValue(i, "nbxh") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "nbxh"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_BACK);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
            e.printStackTrace();
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage(PropertyManager.getProperty("300"));
            return -1;
        }

        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }
}
