package com.ccb.creditrating;

/**
 * <p>Title: ��̨ҵ�����</p>
 * <p>Description: ��̨ҵ�����</p>
 * <p>Copyright: Copyright (c) 2010</p>
 * <p>Company: ��˾</p>
 * @author
 * @version 1.0
 */

import com.ccb.dao.*;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.db.ConnectionManager;
import pub.platform.db.DatabaseConnection;
import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;
import pub.platform.utils.StringUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

public class creditratAction extends Action {
    LNPCIF pcif = null;
    LNUNCOMCREDIT uncomcredit = null;
    LNPSCOREMODEL lnpscoremodel = null;
    LNTASKINFO task = null;
    LNPSCOREDETAIL lnpscoredetail = null;
    ConnectionManager cm = ConnectionManager.getInstance();
    DatabaseConnection dc = cm.get();
    private static final Log logger = LogFactory.getLog(creditratAction.class);

    /**
     * ���ӿͻ���Ϣ
     *
     * @return
     */
    public int add() {
        pcif = new LNPCIF();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                pcif.initAll(i, req); // ��ʼ������bean
                LNPCIF lnpcifTmp = LNPCIF.findFirst(" where  idno = '" + pcif.getIdno() + "' and recsta = '1' ");
                if (lnpcifTmp != null) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("���ӿͻ����ִ���, �˿ͻ��Ѵ��ڣ�");
                    return -1;
                }

                int custSeq = 0;
                RecordSet rs = dc.executeQuery("select max(seq) as maxSeq from ln_pcif");
                while (rs.next()) {
                    custSeq = rs.getInt("maxSeq") + 1;
                }
                String coopSeq = StringUtils.toDateFormat(new Date(), "yyyyMMdd") + StringUtils.addPrefix(custSeq + "", "0", 9);
                pcif.setCustno(coopSeq);
                pcif.setDeptid(this.getDept().getDeptid());  // ����������
                pcif.setOperdate(BusinessDate.getToday());    // ����ʱ��
                pcif.setOperid(this.getOperator().getOperid());   // ������Աid
                pcif.setSeq(custSeq);
                if (pcif.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("��ӿͻ�ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(coopSeq, req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("��ˮ��־���ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("���ӿͻ����ִ���");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("��ӿͻ�ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("��ӿͻ��ɹ���");
        return 0;
    }

    /**
     * �ͻ���Ϣ�༭�ӿ�
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * ����ǰ���а汾�ż�飬���Ʋ�������
     *
     * @return
     */
    public int edit() {
        pcif = new LNPCIF();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                pcif.initAll(i, req); // ��ʼ������bean

                pcif.setUpddate(BusinessDate.getToday());    //�޸�ʱ��
                pcif.setUpdoperid(this.getOperator().getOperid());   // �޸Ĺ�Ա

                if (pcif.updateByWhere(" where custno='" + req.getFieldValue(i, "custno") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("���¿ͻ���Ϣʧ�ܣ�");
                    return -1;
                }

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "custno"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("��ˮ��־���ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("�༭�ͻ���Ϣ���ִ���");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("���¿ͻ���Ϣʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("���¿ͻ���Ϣ�ɹ���");
        return 0;
    }

    //�༭�ͻ��ȼ���Ϣ
    public int editCreditLevel() {

        LNCREATLOG lncreatlog = new LNCREATLOG();
        lnpscoredetail = new LNPSCOREDETAIL();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                lnpscoredetail.initAll(i, req);// ��ʼ������bean
                LNUNCOMCREDIT uncomcreditTmp = LNUNCOMCREDIT.findFirst(" where  idno = '" + lnpscoredetail.getIdno() + "' and recsta = '1'");
                if (uncomcreditTmp != null) {
                    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
                    String validitytime = uncomcreditTmp.getEnddate();
                    Date tempdate = format.parse(validitytime);
                    tempdate.setDate(tempdate.getDate() - 30);
                    String validitytimeTwo = format.format(tempdate);
                    Date sysDate = new Date();
                    if (validitytime.length() > 0) {
                        if (validitytimeTwo.compareTo(format.format(sysDate)) <= 0 && validitytime.compareTo(format.format(sysDate)) >= 0) {
                            this.res.setMessage("�˿ͻ��ڷ���ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + validitytime + " �����Լ�¼��");
                        } else if (validitytimeTwo.compareTo(format.format(sysDate)) > 0) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�˿ͻ��ڷ���ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + validitytime + " �������ѻ��壬�������Ч�ڣ�");
                            return -1;
                        } else if (validitytime.compareTo(format.format(sysDate)) < 0) {
                            this.res.setMessage("�˿ͻ��ڷ���ͨ�����������Ѵ����������ѹ��ڣ�");
                        }
                    } else {
                        this.res.setMessage("�˿ͻ��ڷ���ͨ�����������Ѵ��ڵ�δ���");
                    }
                }

                String finbegdate = lnpscoredetail.getFinbegdate();
                String finenddate = lnpscoredetail.getFinenddate();
                int finBegYear = Integer.parseInt(finbegdate.substring(0, 4));
                int finEndYear = Integer.parseInt(finenddate.substring(0, 4));
                int finBegMonth = Integer.parseInt(finbegdate.substring(5, 7));
                int finEndMonth = Integer.parseInt(finenddate.substring(5, 7));
                String timeLimit = ((finEndYear - finBegYear) * 12 + finEndMonth - finBegMonth) + "";
                lnpscoredetail.setTimelimit(timeLimit);

                if ("".equals(lnpscoredetail.getDocid())) {
                    rs = dc.executeQuery("select to_char(sysdate,'yyyy') || lpad(seq_n.nextval,9,'0') as docid from dual");
                    while (rs.next()) {
                        lnpscoredetail.setDocid(rs.getString("docid"));
                    }
                }

                if (lnpscoredetail.updateByWhere(" where creditratingno='" + req.getFieldValue(i, "creditratingno") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�༭ʧ�ܣ�");
                    return -1;
                }

                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                Date validitytime = null;
                LNPCIF lnpcif = LNPCIF.findFirst("where custno='" + lnpscoredetail.getCustno() + "'");
                lnpcif.setValiditytime(lnpscoredetail.getFinenddate());
                try {
                    Date dateTemp = simpleDateFormat.parse(lnpscoredetail.getFinenddate());
                    validitytime = new Date(dateTemp.getYear(), dateTemp.getMonth(), dateTemp.getDate() - 30);
                } catch (ParseException e) {
                    e.printStackTrace();
                }
                lnpcif.setValiditytimetwo(simpleDateFormat.format(validitytime));
                lnpcif.updateByWhere("where custno='" + lnpscoredetail.getCustno() + "'");

                // ��ˮ��־��
                RecordSet rs = dc.executeQuery("select t.newdate as datevalue from ln_creatlog t where t.creditratingno = '" + lnpscoredetail.getCreditratingno() + "' and t.opertime = (select max(lc.opertime) from ln_creatlog lc where lc.creditratingno = t.creditratingno)");
                String datevalue = "";
                while (rs.next()) {
                    datevalue = rs.getTimeString("datevalue");
                }
                lncreatlog.setCreditratingno(lnpscoredetail.getCreditratingno());
                lncreatlog.setOpername(this.getOperator().getOpername());
                lncreatlog.setOpertime(BusinessDate.getToday());
                lncreatlog.setOlddate(datevalue);
                lncreatlog.setCreattype("0");
                lncreatlog.setNewdate(lnpscoredetail.getFinenddate());
                if (lncreatlog.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����־ʧ�ܣ�");
                    return -1;
                }

                task = MortUtil.getTaskObj(req.getFieldValue(i, "custno"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("�༭ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�༭ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    /**
     * �ͻ���Ϣ��ΪʧЧ�ӿ�
     *
     * @return
     */
    public int delete() {
        pcif = new LNPCIF();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                pcif.initAll(i, req); // ��ʼ������bean
                if (dc.executeUpdate("update ln_pcif set recsta = '2' where custno = '" + pcif.getCustno() + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("ɾ��ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "custno"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }

            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("ɾ���ͻ�ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("ɾ���ͻ�ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    //�������еı��溯��
    public int savePscoreDetail() {
        lnpscoredetail = new LNPSCOREDETAIL();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                lnpscoredetail.initAll(i, req); // ��ʼ������bean
                if (lnpscoredetail.updateByWhere(" where creditratingno='" + req.getFieldValue(i, "creditratingno") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("����ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "creditratingno"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("����ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("����ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    //�Է���ͨ����������ϵ�з���
    public int addUncomcredit() {
        uncomcredit = new LNUNCOMCREDIT();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                uncomcredit.initAll(i, req); // ��ʼ������bean
                RecordSet rs1 = dc.executeQuery("select max(t.enddate) as latestdate from ln_uncomcredit t where t.idno = '" + uncomcredit.getIdno() + "' and t.recsta = '1' ");
                while (rs1.next()) {
                    Date latestDate = rs1.getCalendar("latestdate");
                    if (latestDate != null) {
                        Date latestDate2 = new Date(latestDate.getYear(), latestDate.getMonth(), latestDate.getDate() - 30);
                        Date temp = new Date();
                        if (temp.before(latestDate2)) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�˿ͻ��Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(latestDate) + " �������ѻ��壬�������Ч�ڣ�");
                            return -1;
                        } else if (temp.after(latestDate2) && temp.before(latestDate)) {
                            this.res.setMessage("�˿ͻ��Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(latestDate) + " �����Լ�¼��");
                        } else if (temp.after(latestDate)) {
                            this.res.setMessage("�˿ͻ��Ѵ����������ѹ��ڣ�");
                        }
                    }
                }
                LNPCIF lnpcifTmp = LNPCIF.findFirst(" where  idno = '" + uncomcredit.getIdno() + "' and recsta  = '1' ");
                if (lnpcifTmp != null) {
                    if (lnpcifTmp.getValiditytime().length() > 0) {
                        Date validitytime = format.parse(lnpcifTmp.getValiditytime());
                        Date validitytimeTwo = format.parse(lnpcifTmp.getValiditytimetwo());
                        Date sysDate = new Date();
                        if (sysDate.before(validitytimeTwo)) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(validitytime) + " �������ѻ��壬����ϵ���У�");
                            return -1;
                        } else if (sysDate.after(validitytimeTwo) && sysDate.before(validitytime)) {
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(validitytime) + " ���������ţ�");
                        } else if (sysDate.after(validitytime)) {
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ѹ��ڣ�");
                        }
                    } else {
                        this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ��ڵ�δ���ţ�");
                    }
                }
                // �ͻ����
                int custseqnum = 0;
                RecordSet rs = dc.executeQuery("select max(seqnum) as custmax from ln_uncomcredit where judgedeptid = '" + this.getDept().getDeptid() + "' and (to_char(sysdate,'yyyy-mm-dd') = to_char(judgedate,'yyyy-mm-dd')) and recsta = '1' ");
                while (rs.next()) {
                    custseqnum = rs.getInt("custmax") + 1;
                }
                String coopSeq = this.getDept().getDeptid() + StringUtils.toDateFormat(new Date(), "yyyyMMdd") + StringUtils.addPrefix(custseqnum + "", "0", 3);
                String pkid = UUID.randomUUID().toString();
                uncomcredit.setPkid(pkid);
                uncomcredit.setCreditratingno(coopSeq);
                uncomcredit.setJudgedeptid(this.getDept().getDeptid());  // ����������
                uncomcredit.setJudgedate(BusinessDate.getToday());    // ����ʱ��
                uncomcredit.setJudgeoperid(this.getOperator().getOperid());   // ������Աid
                uncomcredit.setSeqnum(custseqnum);
                if (uncomcredit.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("���ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(uncomcredit.getIdno(), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("���ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("���ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    public int appendUncomcredit() {
        uncomcredit = new LNUNCOMCREDIT();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                uncomcredit.initAll(i, req); // ��ʼ������bean
                if (!uncomcredit.getJudgetype().equals("01")) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�˲���ֻ�����ڼ������ţ�");
                    return -1;
                }
                RecordSet rs1 = dc.executeQuery("select max(t.enddate) as latestdate from ln_uncomcredit t where t.idno = '" + uncomcredit.getIdno() + "' and t.recsta = '1'");
                while (rs1.next()) {
                    Date latestDate = rs1.getCalendar("latestdate");
                    if (latestDate != null) {
                        Date latestDate2 = new Date(latestDate.getYear(), latestDate.getMonth(), latestDate.getDate() - 30);
                        Date temp = new Date();
                        if (temp.before(latestDate2)) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�˿ͻ��Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(latestDate) + " �������ѻ��壬�������Ч�ڣ�");
                            return -1;
                        } else if (temp.after(latestDate2) && temp.before(latestDate)) {
                            this.res.setMessage("�˿ͻ��Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(latestDate) + " �����Լ�¼��");
                        } else if (temp.after(latestDate)) {
                            this.res.setMessage("�˿ͻ��Ѵ����������ѹ��ڣ�");
                        }
                    }
                }
                LNPCIF lnpcifTmp = LNPCIF.findFirst(" where  idno = '" + uncomcredit.getIdno() + "' and recsta = '1'");
                if (lnpcifTmp != null) {
                    if (lnpcifTmp.getValiditytime().length() > 0) {
                        Date validitytime = format.parse(lnpcifTmp.getValiditytime());
                        Date validitytimeTwo = format.parse(lnpcifTmp.getValiditytimetwo());
                        Date sysDate = new Date();
                        if (sysDate.before(validitytimeTwo)) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(validitytime) + " �������ѻ��壬����ϵ���У�");
                            return -1;
                        } else if (sysDate.after(validitytimeTwo) && sysDate.before(validitytime)) {
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ţ�\r\n ��Ч��Ϊ��" + format.format(validitytime) + " ���������ţ�");
                        } else if (sysDate.after(validitytime)) {
                            this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ����������ѹ��ڣ�");
                        }
                    } else {
                        this.res.setMessage("�˿ͻ�����ͨ�����������Ѵ��ڵ�δ���ţ�");
                    }
                }
                String creditratingno = uncomcredit.getCreditratingno();
                int seqNum = Integer.parseInt(creditratingno.substring(creditratingno.length() - 3));
                String pkid = UUID.randomUUID().toString();
                uncomcredit.setPkid(pkid);
                uncomcredit.setJudgedeptid(this.getDept().getDeptid());  // ����������
                uncomcredit.setJudgedate(BusinessDate.getToday());    // ����ʱ��
                uncomcredit.setJudgeoperid(this.getOperator().getOperid());   // ������Աid
                uncomcredit.setSeqnum(seqNum);
                if (uncomcredit.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("׷��ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(uncomcredit.getIdno(), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("׷�ӿͻ�ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("׷�ӿͻ�ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    public int editUncomcredit() {
        uncomcredit = new LNUNCOMCREDIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                uncomcredit.initAll(i, req); // ��ʼ������bean
                if (uncomcredit.updateByWhere(" where pkid='" + req.getFieldValue(i, "pkid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�༭ʧ�ܣ�");
                    return -1;
                }

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "pkid"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }

            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("�༭ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�༭ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    public int deleteUncomcredit() {
        uncomcredit = new LNUNCOMCREDIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                uncomcredit.initAll(i, req); // ��ʼ������bean
                if (dc.executeUpdate("update ln_uncomcredit set recsta = '2' where pkid = '" + uncomcredit.getPkid() + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("����ʧ�ܣ�");
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "creditratingno"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }
            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("ɾ���ͻ�ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("ɾ���ͻ�ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("�����ɹ���");
        return 0;
    }

    /**
     * ����ͨ���
     *
     * @return
     */
    public int uncomcreditCheck() {
        LNCREATLOG lncreatlog = new LNCREATLOG();
        uncomcredit = new LNUNCOMCREDIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                uncomcredit.initAll(i, req); // ��ʼ������bean
                String docID = null;
                if (uncomcredit.getJudgetype().equals("01")) {
                    String sqlMinDocid = "select min(t.docid) as mindocid from ln_uncomcredit t where t.judgetype = '01' and t.creditratingno = '" + uncomcredit.getCreditratingno() + "'";
                    rs = dc.executeQuery(sqlMinDocid);
                    while (rs.next()) {
                        docID = rs.getString("mindocid");
                    }
                }

                if (docID == null) {
                    docID = uncomcredit.getDocid();
                }

                if ("".equals(docID)) {
                    rs = dc.executeQuery("select to_char(sysdate,'yyyy') || lpad(seq_n.nextval,9,'0') as docid from dual");
                    while (rs.next()) {
                        docID = rs.getString("docid");
                    }
                }
                uncomcredit.setDocid(docID);
                if (uncomcredit.updateByWhere(" where pkid='" + req.getFieldValue(i, "pkid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("���ʧ�ܣ�");
                    return -1;
                }

                // ��ˮ��־��
                RecordSet rs = dc.executeQuery("select t.newdate as datevalue from ln_creatlog t where t.creditratingno = '" + uncomcredit.getCreditratingno() + "' and t.opertime = (select max(lc.opertime) from ln_creatlog lc where lc.creditratingno = t.creditratingno)");
                String datevalue = "";
                while (rs.next()) {
                    datevalue = rs.getTimeString("datevalue");
                }
                lncreatlog.setCreditratingno(uncomcredit.getCreditratingno());
                lncreatlog.setOpername(this.getOperator().getOpername());
                lncreatlog.setOpertime(BusinessDate.getToday());
                lncreatlog.setOlddate(datevalue);
                lncreatlog.setCreattype("1");
                lncreatlog.setNewdate(uncomcredit.getEnddate());
                if (lncreatlog.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("��Ӳ�����־ʧ�ܣ�");
                    return -1;
                }

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "pkid"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_EDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�����ˮ��־ʧ�ܣ�");
                    return -1;
                }

            } catch (Exception ex1) {
                ex1.printStackTrace();
                logger.error("�༭ʧ�ܣ�");
                logger.error(ex1.getMessage());
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("�༭ʧ�ܣ�");
                return -1;
            }
        }
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage("��˳ɹ���");
        return 0;
    }
}