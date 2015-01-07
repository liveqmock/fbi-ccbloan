package com.ccb.acctmng;

import com.ccb.dao.LNACCTINFO;
import com.ccb.dao.LNARCHIVEFLOW;
import com.ccb.dao.LNTASKINFO;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import com.ccb.util.SeqUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.util.StringUtil;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created with IntelliJ IDEA.
 * User: Lin Yong
 * Date: 13-11-6
 * Time: ����10:05
 */
public class AcctInfoAction extends Action {

    // ��־����
    private static final Log logger = LogFactory.getLog(AcctInfoAction.class);
    // ������Ϣ����
    LNACCTINFO acct = null;
    // ��ˮ��־��
    LNTASKINFO task = null;

    public int add() {
        acct = new LNACCTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��������������ظ�
                RecordSet rec = dc.executeQuery("select 1 from ln_acctinfo where loanid='"
                        + req.getFieldValue(i, "loanid").trim() + "'");
                while (rec.next()) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�ô���������ŵ��˻���Ϣϵͳ���Ѵ��ڣ�" + "\r\n����������ţ�"
                            + req.getFieldValue(i, "loanid").trim());
                    return -1;
                }
                if (rec != null) {
                    rec.close();
                }


                // ��ʼ������bean
                acct.initAll(i, req);
                acct.setOperdate(BusinessDate.getToday());
                acct.setOperid(this.getOperator().getOperid());
                acct.setPay_date(BusinessDate.getToday());
                acct.setPay_flag("0");
                acct.setReport_flag("0");
                acct.setPrint_flag("0");
                acct.setCancel_flag("0");
                acct.setRecversion(0);
                //20131106 linyong ֱ��ȡ��
                String acctid = SeqUtil.getAcctid();
                acct.setAcct_id(acctid);
                if (acct.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("LN_ACCTINFO���ʧ�ܣ���ˮ���ظ����ֶ���д����");
                    return -1;
                }

                // ��ˮ��־��
                //task = MortUtil.getTaskObj(acct.getFlowsn(), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task = MortUtil.getTaskObj(acct.getAcct_id(), "Acct01:ADD", CcbLoanConst.OPER_ADD);
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

    public int edit() {
        acct = new LNACCTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                acct.initAll(i, req);

                // ����ʱ��
                acct.setOperdate(BusinessDate.getToday());
                // �û�id
                acct.setOperid(this.getOperator().getOperid());
                // ����ǰ�汾��
                int iBeforeVersion = 0;
                if (req.getFieldValue(i, "recVersion") != null && !req.getFieldValue(i, "recVersion").equals("")) {
                    iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                }
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_acctinfo where acct_id='"
                        + req.getFieldValue(i, "acctid") + "'");
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
                        acct.setRecversion(iBeforeVersion);
                    }
                }
                if (acct.updateByWhere(" where acct_id='" + req.getFieldValue(i, "acctid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("����LN_ACCTINFO�����");
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
        acct = new LNACCTINFO();
        try {
            for (int i = 0; i < this.req.getRecorderCount(); i++) {
                acct.initAll(i, req);
                //�ж�������Ϣ
                RecordSet rs = dc.executeQuery("select count(*) as cnt from ln_archive_flow where flowsn='"
                        + req.getFieldValue(i, "flowsn") + "'");
                while (rs.next()) {
                    int cnt = rs.getInt("cnt");
                    if (cnt > 1) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("�˱ʴ����ѽ�����һ���̣�����ɾ����");
                        return -1;
                    }
                }

                //ɾ��������Ϣ��Ϣ��������Ϣ
                if (acct.deleteByWhere(" where flowsn='" + req.getFieldValue(i, "flowsn") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

                LNARCHIVEFLOW flow = new LNARCHIVEFLOW();
                flow.setFlowsn(req.getFieldValue(i, "flowsn"));
                if (flow.deleteByWhere(" where flowsn='" + req.getFieldValue(i, "flowsn") + "' ") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("ɾ������������Ϣ����.");
                    return -1;
                }

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "flowsn"), req.getFieldValue(i, "busiNode"),
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

    public int batchEdit() {

        acct = new LNACCTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                acct.initAll(i, req);
                String remark_old = "";

                // ����ǰ�汾��
                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recversion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion, remark from ln_acctinfo where acct_id='"
                        + req.getFieldValue(i, "acctid") + "'");
                while (rs.next()) {
                    iAfterVersion = rs.getInt("recVersion");
                    remark_old = rs.getString("remark");
                    if (iBeforeVersion != iAfterVersion) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("301"));
                        return -1;
                    } else {
                        iBeforeVersion = iBeforeVersion + 1;
                        acct.setRecversion(iBeforeVersion);
                    }
                }
                rs.close();

                String action = req.getFieldValue(i, "action_type");
                if (action.equals("pay_confirm")) {//����ȷ��
                    acct.setPay_operid(this.getOperator().getOperid());
                    acct.setPay_operdate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                    acct.setRemark(remark_old + "   ===�ɿ����ע:" + acct.getRemark());
                }

                if (acct.updateByWhere(" where acct_id='" + req.getFieldValue(i, "acctid") + "'") < 0) {
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

    /**
     * <p/>
     * ��ODSB��������
     *
     * @return
     */
    public int getAcctNo() {
        int rtn = 0;
        // ���¼�¼��
        int updateCnt = 0;
        acct = new LNACCTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                acct.initAll(i, req);
                String acct_amt = "";
                String strLoanid = req.getFieldValue(i,"strLoanid");
                System.out.println(strLoanid);
                acct_amt = req.getFieldValue("ACCT_AMT");
                String deptid = req.getFieldValue("DEPT_ID");
                try {
                    updateCnt = dc.executeUpdate(" select a.loanid from " +
                            " ODSBDATA.BF_AGT_LNP_REPAY_ACCT_PMIS@odsb a " +
//                            " BF_AGT_LNP_REPAY_ACCT_PMIS a " +
                            " where a.SUBSKIND=1 and SUBSORDER =1 " +
                            " and a.loanid in (" + strLoanid+
                            " )");
                    if (updateCnt <=0 ){
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("ί���˺Ų����ڣ�");
                        return -1;
                    }

                    updateCnt = dc.executeUpdate(" select a.loanid from " +
                            " LN_ODSB_REPAY_ACCT_PMIS a " +
                            " where a.loanid in (" + strLoanid+
                            " )");
                    if (updateCnt <=0 ){
                        rtn = dc.executeUpdate(" insert into LN_ODSB_REPAY_ACCT_PMIS  select " +
                                " LOANID," +
                                "NUM," +
                                "ODS_SRC_DT," +
                                "SUBSKIND," +
                                "FUNDCENTNO," +
                                "MANADEPT," +
                                "SUBSACNO," +
                                "ACNAME," +
                                "AWBK," +
                                "SUBSORDER," +
                                "ODS_LOAD_DT " +
                            " from  ODSBDATA.BF_AGT_LNP_REPAY_ACCT_PMIS@odsb a " +
//                                " from  BF_AGT_LNP_REPAY_ACCT_PMIS a " +
                                " where a.SUBSKIND=1 and SUBSORDER =1 " +
                                " and a.loanid in (" +  strLoanid+
                                " )");
                        dc.commit();
                        if (rtn < 0) {
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

                //
                RecordSet rs = dc.executeQuery("select *  from LN_ODSB_REPAY_ACCT_PMIS where loanid in ("
                        + strLoanid + ")");
                while (rs.next()) {
                    // ��ʼ������bean
                    acct = new LNACCTINFO();
                    acct.setOperdate(BusinessDate.getToday());
                    acct.setOperid(this.getOperator().getOperid());
                    acct.setPay_date(BusinessDate.getToday());
                    acct.setPay_flag("0");
                    acct.setReport_flag("0");
                    acct.setPrint_flag("0");
                    acct.setCancel_flag("0");
                    acct.setRecversion(0);
                    acct.setAcct_amt((new BigDecimal(acct_amt)).doubleValue());
                    acct.setLoanid(rs.getString("LOANID"));
                    acct.setAcct_no(rs.getString("SUBSACNO"));
                    acct.setAcct_name(rs.getString("ACNAME"));
                    acct.setAcct_bank(rs.getString("AWBK"));
                    acct.setDeptid(deptid);
                    //20131106 linyong ֱ��ȡ��
                    String acctid = SeqUtil.getAcctid();
                    acct.setAcct_id(acctid);
                    if (acct.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("LN_ACCTINFO���ʧ�ܣ���ˮ���ظ����ֶ���д����");
                        return -1;
                    }
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

    //��Ѻ���ڱ��ӡ�����еĽɷѱ���
    public int addAcctField() {

        String[] loanidArray= this.req.getFieldValue("strLoanid").split(",");
        for (int i = 0; i <loanidArray.length ; i++) {
            try {
                acct = new LNACCTINFO();
                // ��������������ظ�
                RecordSet rec = dc.executeQuery("select 1 from ln_acctinfo where loanid='"
                        + loanidArray[i].trim() + "'");
                while (rec.next()) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�ô���������ŵ��˻���Ϣϵͳ���Ѵ��ڣ�" + "\r\n����������ţ�"
                            + loanidArray[i].trim());
                    return -1;
                }
                if (rec != null) {
                    rec.close();
                }
                // ��ʼ������bean
                //acct.initAll(i, req);
                acct.setLoanid(loanidArray[i].trim());
                acct.setAcct_name(this.req.getFieldValue("clientNames").replaceAll("\\d\\.", "").split(" ")[i]);
                acct.setDeptid(this.getDept().getDeptid());
                if(!StringUtils.isBlank(this.req.getFieldValue("acct_amt"))){
                    acct.setAcct_amt(Double.parseDouble(this.req.getFieldValue("acct_amt")));
                }
                 acct.setRemark(this.req.getFieldValue("remark"));

                //acct.setAcct_bank();
                acct.setOperdate(BusinessDate.getToday());
                acct.setOperid(this.getOperator().getOperid());
                acct.setPay_date(BusinessDate.getToday());
                acct.setPay_flag("1");
                acct.setReport_flag("0");
                acct.setPrint_flag("0");
                acct.setCancel_flag("0");
                acct.setRecversion(0);
                //20131106 linyong ֱ��ȡ��
                String acctid = SeqUtil.getAcctid();
                acct.setAcct_id(acctid);
                if (acct.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("LN_ACCTINFO���ʧ�ܣ���ˮ���ظ����ֶ���д����");
                    return -1;
                }

                // ��ˮ��־��
                //task = MortUtil.getTaskObj(acct.getFlowsn(), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task = MortUtil.getTaskObj(acct.getAcct_id(), "Acct01:ADD", CcbLoanConst.OPER_ADD);
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
