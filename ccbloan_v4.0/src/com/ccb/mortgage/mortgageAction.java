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
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.db.SequenceManager;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;

import com.ccb.util.CcbLoanConst;
import com.ccb.util.SeqUtil;
import pub.platform.utils.StringUtils;

import java.util.Date;

public class mortgageAction extends Action {
    // ��־����
    private static final Log logger = LogFactory.getLog(mortgageAction.class);
    // ��Ѻ��Ϣ����
    LNMORTINFO mortInfo = null;
    //20120228 ���յ���Ϣ��
    LNINSURANCE insurance = null;
    // �ϺŹ������
    SYSSEQDISCARD seqInfoDiscard = null;
    // ������Ϣ����
    LNLOANAPPLY loan = null;
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
        mortInfo = new LNMORTINFO();
        insurance = new LNINSURANCE();
        // ȡ����Ѻ���
        String mortID = "";
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {

                // ��ʼ������bean
                mortInfo.initAll(i, req);
                // ����id
                mortInfo.setDeptid(this.getDept().getDeptid());
                // ����ʱ��
                mortInfo.setOperdate(BusinessDate.getToday());
                // �û�id
                mortInfo.setOperid(this.getOperator().getOperid());
                // �Ǽ�״̬
                // mortInfo.setMortstatus(CcbLoanConst.NODE_DOING);
                mortInfo.setMortstatus(CcbLoanConst.MORT_FLOW_REGISTED);

                //20130608 zhan ���ӵ�ѺԤԼ״̬�ĳ�ʼ��
                mortInfo.setApptstatus("01");  //��ԤԼ����
                /*
                //������������ɽ��������ī���������ϡ��������ݡ���������ס������(����ס������011���������÷�����014)��Ѻ��ת״̬Ϊ���ѵǼ����ϡ��ģ���ѺԤԼ������״̬�Զ���Ϊ���������Ѻ��������֮���Ѻ��ת״̬Ϊ���ѵǼ����ϡ��Ķ��Զ���Ϊ����ԤԼ���롱��
                String mortecentercd = req.getFieldValue(i, "MORTECENTERCD");
                if ("05".equals(mortecentercd) //��ɽ
                        || "06".equals(mortecentercd) //����
                        || "07".equals(mortecentercd) //��ī
                        || "08".equals(mortecentercd) //����
                        || "12".equals(mortecentercd) //����
                        ) {
                    //���Ҵ�������
                    loan = (LNLOANAPPLY) new LNLOANAPPLY().findFirstByWhere(" where loanid='" + req.getFieldValue(i, "loanid") + "'");
                    if (loan == null) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage("δ���ҵ��ñʵ�Ѻ��Ӧ�Ĵ�����Ϣ����ȷ�ϸñʴ����Ƿ���ɾ����loanid=" + req.getFieldValue(i, "loanid"));
                        return -1;
                    }

                    if ("011".equals(loan.getLn_typ()) || "014".equals(loan.getLn_typ())) {
                        mortInfo.setApptstatus("50");  //�������Ѻ
                        //�����Զ�ԤԼ��
                        mortInfo.setAppt_valid_flag("1");  //��Ч��¼
                        mortInfo.setAppt_over_flag("0");  //����δ���
                    }
                }
                */


                // δ���׵�Ѻԭ�� Ĭ��ֵ������
                //mortInfo.setNomortreasoncd("99");
                // δ���׵�Ѻԭ�� Ĭ��ֵ��δ���� ��20100722 zhanrui��
                //mortInfo.setNomortreasoncd("09");
                // TODO δ�����Ѻԭ�� Ĭ��ֵ��δ���� ��20110704 zxb��
                // TODO δ�����Ѻԭ��ֻ����8���û�С�δ���͡�һ�� , ��ʱ����Ϊ��
                //mortInfo.setNomortreason("δ����");
                mortInfo.setNomortreasoncd(" ");

                // ��Ѻ�Ǽ�״̬ Ĭ��Ϊ��δ�Ǽǣ�1
                mortInfo.setMortregstatus("1");
                // �汾��
                mortInfo.setRecversion(0);

                // ��Ѻ������
                // String mortExpireDate = getMortExpireDate(req);
                String releasecondcd = req.getFieldValue(i, "RELEASECONDCD");
                String mortExpireDate = MortUtil.getMortExpireDate(releasecondcd, req
                        .getFieldValue(i, "MORTDATE"), dc, req.getFieldValue(i, "loanID"), req.getFieldValue(i,
                        "MORTECENTERCD"));

                // TODO:��Ѻ������ȡ��������£������ֵ
                // ��Ѻ����������ʧ��
                // if ("".equals(mortExpireDate)) {
                // this.res.setType(0);
                // this.res.setResult(false);
                // this.res.setMessage(PropertyManager.getProperty("305"));
                // return -1;
                // }

                mortInfo.setMortexpiredate(mortExpireDate);

                //20100403 zhan
                //���ΪǩԼ�� ͬʱ���µ�Ѻ����������
                if (releasecondcd.equals("03") || releasecondcd.equals("06")) {
                    mortInfo.setMortoverrtndate(mortExpireDate);
                }

                // �Ƿ�ӷϺű�ȡֵ
                boolean discardFlg = false;

                /*
                20100423 zhan  ȡ���ϺŹ���

                RecordSet rs = dc.executeQuery("select discardno from sys_seq_discard where bhlx='"
                        + CcbLoanConst.MORTTYPE + "' and useflg='0' order by discardno asc ");
                if (rs.next()) {
                    discardFlg = true;
                    mortID = rs.getString("discardno");
                } else {
                    mortID = SeqUtil.getMortID();
                }
                if (rs != null) {
                    rs.close();
                }
                */
                //20100423 zhan ȡ���ϺŹ��� ֱ��ȡ��
                mortID = SeqUtil.getMortID();
                mortInfo.setMortid(mortID);

                if (mortInfo.insert() < 0) {
                    // ------�����ɵĵ�Ѻ��Ž��ϺŹ����--------
                    seqInfoDiscard = new SYSSEQDISCARD();
                    // ʹ�ñ�־��δʹ��
                    seqInfoDiscard.setUseflg(0);
                    // �����������
                    seqInfoDiscard.setNseqno(req.getFieldValue(i, "loanid"));
                    // ����ʱ��
                    seqInfoDiscard.setIndate(BusinessDate.getNowDay());
                    // ���������Ա
                    seqInfoDiscard.setInoperid(this.getOperator().getOperid());
                    // ��Ѻ���
                    seqInfoDiscard.setDiscardno(mortID);
                    // �Ϻ�������
                    seqInfoDiscard.setBhlx(CcbLoanConst.MORTTYPE);
                    // ��������
                    seqInfoDiscard.setDotype("add");

                    if (seqInfoDiscard.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }

                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

                //20120228 add ���뱣�յ���Ϣ����
                String attendflag = req.getFieldValue(i, "attendflag");
                if (attendflag.equals("1")) {
                    insurance.setAttendflag(attendflag); //��������յ���־
                    insurance.setLoanid(req.getFieldValue(i, "loanid"));
                    insurance.setMortid(mortID);
//                    0=δ��⣻1=����⣻2=�ѽ���
                    insurance.setInsurancests("0");
                    insurance.setOperid2(this.getOperator().getOperid());
                    insurance.setOperdate(BusinessDate.getToday());
                    if (insurance.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                }

                // �жϸ�����Ƿ�ӷ�����ȡ�ã����������·ϺŹ����
                if (discardFlg) {
                    seqInfoDiscard = new SYSSEQDISCARD();
                    // ʹ�ñ�־����ʹ��
                    seqInfoDiscard.setUseflg(1);
                    seqInfoDiscard.setNseqno(req.getFieldValue(i, "loanid"));
                    seqInfoDiscard.setUsedate(BusinessDate.getNowDay());
                    seqInfoDiscard.setUseoperid(this.getOperator().getOperid());
                    // �ô������������Ը�Ψһ
                    if (seqInfoDiscard.updateByWhere(" where  bhlx='" + CcbLoanConst.MORTTYPE + "' and discardno='"
                            + mortID + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                }
                // ���´�����Ϣ��
                loan = new LNLOANAPPLY();
                loan.init(i, req);
                if (loan.updateByWhere(" where loanid='" + req.getFieldValue(i, "loanid") + "'") <= 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("���´����ķſʽʧ�ܣ���ȷ�ϸñʴ����Ƿ���ɾ����loanid=" + req.getFieldValue(i, "loanid"));
                    return -1;
                }

                //���µ�����Ϣ���е�mortid
                LNARCHIVEINFO lnarchiveinfo = new LNARCHIVEINFO();
                lnarchiveinfo.setMortid(mortID);
                if (lnarchiveinfo.updateByWhere(" where loanid='" + req.getFieldValue(i, "loanid") + "'") < 0) {
                    logger.error("δ�ҵ���Ӧ��LN_ARCHIVE_INFO��¼�������Ǿ����ݡ�");
                }

                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), CcbLoanConst.BUSINODE_010,
                        CcbLoanConst.OPER_ADD);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
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
        // this.res.setType(0);
        // this.res.setResult(true);
        // this.res.setMessage(PropertyManager.getProperty("200"));
        // return 0;

        this.res.setFieldName("mortID");
        this.res.setFieldType("text");
        this.res.setEnumType("0");
        this.res.setFieldValue(mortID);
        this.res.setType(4);
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

        mortInfo = new LNMORTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                mortInfo.initAll(i, req);
                /*
                 * // ---����δ�����Ѻԭ�����״̬�޸�--- // �����ѽ��塢�ѳ��� ��Ѻ�Ǽ�״̬��Ϊ���������ȡ֤�Ǽǡ��ѽ���ȡ֤
                 * if (req.getFieldValue(i, "NOMORTREASONCD") != null) { if
                 * (req.getFieldValue(i, "NOMORTREASONCD").equals("08") ||
                 * req.getFieldValue(i, "NOMORTREASONCD").equals("17")) { //
                 * �ѽ���ȡ֤ mortInfo.setMortstatus("50"); } }
                 */
                // ---����δ�����Ѻԭ�����״̬�޸�---
                // �����ѽ��塢�ѳ��� ��Ѻ�Ǽ�״̬��Ϊ���������ȡ֤�Ǽǡ��ѽ���ȡ֤
                if (req.getFieldValue(i, "NOMORTREASONCD") != null) {
                    if (req.getFieldValue(i, "NOMORTREASONCD").equals("08")) {
                        // δ��Ѻ�����ѽ���
                        mortInfo.setMortstatus(CcbLoanConst.MORT_FLOW_NOMORT_CLEARED);
                    } else if (req.getFieldValue(i, "NOMORTREASONCD").equals("17")) {
                        // �ѳ���
                        mortInfo.setMortstatus(CcbLoanConst.MORT_FLOW_NOMORT_GETBOOK);
                    }
                }

                //��Ѻ��Ÿ��� 20140424 linyong
                if (req.getFieldValue(i, "boxid") != null) {
                    mortInfo.setBoxid(req.getFieldValue(i, "boxid"));
                }
                //��Ѻ��ע���� 20140424 linyong
                if (req.getFieldValue(i, "expressnote") != null) {
                    mortInfo.setExpressnote(req.getFieldValue(i, "expressnote"));
                }
               //20100403  zhan   ����
                //�ڴ������п��������ɱ���Ѻʱ ͬʱ����δ�����Ѻԭ�� �޸�Ϊ �����п�������:04
                String sendflag = req.getFieldValue(i, "SENDFLAG");
                if (sendflag != null) {
                    //����Ϊ���ַ�������Ϊ��0������Ϊ��1��
                    if (sendflag.equals("0")) {
                        // bankflag=1 ����   03������δ��Ѻ 20110928 haiyu
                        // bankflag=2 ����   04 ���п�����
                        String bankflag = req.getFieldValue(i, "bankflag");
                        if (bankflag == null) {
                            RecordSet projRs = dc.executeQuery("select b.bankflag from ln_loanapply a,ln_coopproj b where a.proj_no=b.proj_no and a.loanid = '"
                                    + req.getFieldValue(i, "loanid") + "'");
                            while (projRs.next()) {
                                bankflag = projRs.getString("bankflag");
                            }
                            projRs.close();
                        }
                        if (bankflag.equals("1")) {
                            mortInfo.setNomortreasoncd("03");
                        } else if (bankflag.equals("2")) {
                            mortInfo.setNomortreasoncd("04");
                        }
                    } else if (sendflag.equals("1")) {
                        //���ÿո� ��ʱ����=null �޷�ͳ�� 20110928 haiyu
                        mortInfo.setNomortreasoncd(" ");
                        //��Ϊ�ɱ���Ѻʱ�������Ϊ�ո� 20140424 linyong
                        mortInfo.setBoxid(" ");
                    } else if (sendflag.equals("A")) {
                        //���ÿո� ��ʱ����=null �޷�ͳ�� 20130408
                        mortInfo.setNomortreasoncd(" ");
                    }
                }

                //20130608 zhan ����
                //���е�Ѻ��ת״̬Ϊ��Ȩ֤����⡱�� ��ѺԤԼ������״̬Ҳ�Զ���Ϊ��Ȩ֤����⡱
                if (CcbLoanConst.MORT_FLOW_SAVED.equals(mortInfo.getMortstatus())) {
                    mortInfo.setApptstatus("90");  //Ȩ֤�����
                    mortInfo.setAppt_over_flag("1"); //����ԤԼȫ��������������
                }
                //20130721 zhan �پ�
                //���е�Ѻ��ת״̬Ϊ���ѽ�֤��֤���ģ� ��ѺԤԼ������״̬Ҳ�Զ���Ϊ���ѽ�֤��֤��
                if (CcbLoanConst.MORT_FLOW_CHANGED_RETURN.equals(mortInfo.getMortstatus())) {
                    mortInfo.setApptstatus("91");  //�ѽ�֤��֤
                    mortInfo.setAppt_over_flag("1"); //����ԤԼȫ��������������
                }
                //20130624 zhan �پ�
                //��Ѻ״̬����Ѻ����ǩ��(20A)------>ԤԼ״̬����ԤԼ����
                if (CcbLoanConst.MORT_FLOW_DATA_SIGNIN.equals(mortInfo.getMortstatus())) {
                    mortInfo.setApptstatus("01");  //��ԤԼ����
                }


                // ����ʱ��
                mortInfo.setOperdate(BusinessDate.getToday());
                // �û�id
                mortInfo.setOperid(this.getOperator().getOperid());

                boolean isNeedCheckRecversion = true;
                // ����ǰ�汾��
                int iBeforeVersion = 0;
                if (req.getFieldValue(i, "recVersion") != null && !req.getFieldValue(i, "recVersion").equals("")) {
                    iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                } else {
                    //20130816 zr  ��req��δ�� recversion��ֵ����ʱ��Ϊ�ǲ���Ҫ���汾��飨�����ƣ�
                    isNeedCheckRecversion = false;
                }

                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion,documentid,deptid from ln_mortinfo where mortid='"
                        + req.getFieldValue(i, "mortid") + "'");
                while (rs.next()) {
                    iAfterVersion = rs.getInt("recVersion");
                    if (iBeforeVersion != iAfterVersion) {
                        if (isNeedCheckRecversion) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage(PropertyManager.getProperty("301"));
                            return -1;
                        }else{
                            logger.error("[ERRTYPE=1111]recversion������morid=" + req.getFieldValue(i, "mortid"));
                        }
                    }
                    // �汾�ż�1
                    iBeforeVersion = iBeforeVersion + 1;
                    mortInfo.setRecversion(iBeforeVersion);

                    //20130619 zr
                    //��Ҫ������Ŵ�������ȼ���Ƿ��б�������б������������ͬdeptid�º����Ƿ��ظ�
                    String uiDocumentid = req.getFieldValue(i, "documentid");
                    if (uiDocumentid != null && !"".equals(uiDocumentid)) {
                        String dbDeptid = rs.getString("deptid") == null ? "" : rs.getString("deptid");
                        String dbDocumentid = rs.getString("documentid") == null ? "" : rs.getString("documentid");
                        if (!dbDocumentid.equals(uiDocumentid)) {//�б��
                            rs = dc.executeQuery("select count(*) as cnt  from ln_mortinfo where mortid !='"
                                    + req.getFieldValue(i, "mortid") + "'"
                                    + " and deptid='" + dbDeptid + "' "
                                    + " and documentid='" + uiDocumentid + "' ");
                            while (rs.next()) {
                                int count = rs.getInt("cnt");
                                if (count > 0) {
                                    this.res.setType(0);
                                    this.res.setResult(false);
                                    this.res.setMessage("��Ҫ��������ظ���");
                                    return -1;
                                }
                            }
                        }
                    } else {
                        //ֵΪ�յ���������֣�1����ֵ��Ϊ�� 2��ԭֵ��Ϊ�գ�����Ϊ�գ����⴦��ͨ���п��ܷ�����
                        //�ݲ�����.
                    }
                }
                if (rs != null) {
                    rs.close();
                }

                if (mortInfo.updateByWhere(" where mortid='" + req.getFieldValue(i, "mortid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), req.getFieldValue(i, "busiNode"),
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

        mortInfo = new LNMORTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                mortInfo.initAll(i, req);
                // ����ʱ��
                mortInfo.setOperdate(BusinessDate.getToday());
                // �û�id
                mortInfo.setOperid(this.getOperator().getOperid());
                // ���
                if (req.getFieldValue(i, "boxid") != null) {
                    mortInfo.setBoxid(req.getFieldValue(i, "boxid"));
                }
                // ����ǰ�汾��
                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_mortinfo where mortid='"
                        + req.getFieldValue(i, "mortid") + "'");
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
                        mortInfo.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }

                if (mortInfo.updateByWhere(" where mortid='" + req.getFieldValue(i, "mortid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), req.getFieldValue(i, "busiNode"),
                        CcbLoanConst.OPER_BATCHEDIT);
                task.setOperid(this.getOperator().getOperid());
                task.setBankid(this.getOperator().getDeptid());
                if (task.insert() < 0) {
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
     * �޸ĵ�Ѻ��Ϣ�еĴ��������
     * <p/>
     * ����ǰ���а汾�ż�飬���Ʋ�������
     *
     * @return
     */
    public int editLoanId() {

        mortInfo = new LNMORTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                mortInfo.initAll(i, req);

                LNMORTINFO mortTmp = mortInfo.findFirst(" where  loanid = '" + mortInfo.getLoanid() + "'");
                if (mortTmp != null) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�޸Ĵ�������ų��ִ���, ��������ѹ�����:" + mortTmp.getMortid() + "�ŵ�Ѻ��");
                    return -1;
                }

                LNLOANAPPLY loanTmp = new LNLOANAPPLY();
                loanTmp = loanTmp.findFirst(" where  loanid = '" + mortInfo.getLoanid() + "'");
                if (loanTmp == null) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage("�޸Ĵ�������ų��ִ���, ������Ų����ڡ�");
                    return -1;
                }


                // ����ʱ��
                mortInfo.setOperdate(BusinessDate.getToday());
                // �û�id
                mortInfo.setOperid(this.getOperator().getOperid());
                // ����ǰ�汾��
                int iBeforeVersion = 0;
                if (req.getFieldValue(i, "recVersion") != null && !req.getFieldValue(i, "recVersion").equals("")) {
                    iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                }
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_mortinfo where mortid='"
                        + req.getFieldValue(i, "mortid") + "'");
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
                        mortInfo.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }

                if (mortInfo.updateByWhere(" where mortid='" + req.getFieldValue(i, "mortid") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), req.getFieldValue(i, "busiNode"),
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

    //���ݵ�Ѻ��Ϣ���deptid �ֱ�������Ҫ����������С�
    public int generateDocumentID() {
        mortInfo = new LNMORTINFO();
        try {
            String sn = "";
            String mortid = req.getFieldValue(0, "mortid");
            mortInfo = (LNMORTINFO) mortInfo.findFirstByWhere(" where mortid='" + mortid + "'");
            if (mortInfo != null) {
                String temp = "" + SequenceManager.nextID("DOCID_" + mortInfo.getDeptid());
                sn = StringUtils.toDateFormat(new Date(), "yyyy") + StringUtils.addPrefix(temp, "0", 5);
                this.res.setFieldName("docid");
                this.res.setFieldType("text");
                this.res.setEnumType("0");
                this.res.setFieldValue(sn);
                this.res.setType(4);
                this.res.setResult(true);
            } else {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage("��Ҫ�����������ʧ��, �ñʵ�Ѻ������:" + req.getFieldValue(0, "mortid"));
                return -1;
            }
        } catch (Exception e) {
            logger.error("��Ҫ�����������ʧ��:", e);
            this.res.setType(0);
            this.res.setResult(false);
            this.res.setMessage("��Ҫ�����������ʧ��:" + e.getMessage());
            return -1;
        }
        return 0;
    }

    /**
     * ���Ǽ�
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * ����ǰ���а汾�ż�飬���Ʋ�������
     * @return
     */
    public int boxEdit() {

        mortInfo = new LNMORTINFO();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                mortInfo.initAll(i, req);
                // ����ʱ��
                mortInfo.setOperdate(BusinessDate.getToday());
                // �û�id
                mortInfo.setOperid(this.getOperator().getOperid());
                // ���
                if (req.getFieldValue(i, "boxid") != null) {
                    mortInfo.setBoxid(req.getFieldValue(i, "boxid"));
                }
                // ��ע
                if (req.getFieldValue(i, "EXPRESSNOTE") != null) {
                    mortInfo.setExpressnote(req.getFieldValue(i, "EXPRESSNOTE"));
                }
                //��������
                String doType = req.getFieldValue(i, "doType");
                // ����ǰ�汾��
                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_mortinfo where mortid="
                        + req.getFieldValue(i, "strMortid") + "");
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
                        mortInfo.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }

                if (mortInfo.updateByWhere(" where mortid=" + req.getFieldValue(i, "strMortid") + "") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "strMortid"), "170",
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
     * ���Ǽ�
     * ���˸���ҳ���ϵ�ֵ֮�⣬�û�id������ʱ��Ҳһ����£�
     * ����ǰ���а汾�ż�飬���Ʋ�������
     * @return
     */
    public int boxBatchEdit() {


        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                //��������
                String doType = req.getFieldValue(i, "doType");
                // �汾��
//                int iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion,mortid,RELEASECONDCD from ln_mortinfo where mortid in ("
                       + req.getFieldValue(i, "strMortid") + ") ");
                while (rs.next()) {


                    mortInfo = new LNMORTINFO();

                    String releasecondcd = "";
                    //��Ϊ��ϴ���ʱ����ӵ�Ѻ���ʱ��ֱ�ӽ���ת״̬��Ϊ��ݲ�����ǩ��        linyong20140424
                    releasecondcd = rs.getString("RELEASECONDCD");
                    if(("04".equals(releasecondcd))||("05".equals(releasecondcd))||("06".equals(releasecondcd))){
                        //���������ǩ��
                        mortInfo.setMortstatus(CcbLoanConst.MORT_FLOW_DATA_SIGNIN);
                    }
                    // ��ʼ������bean
                    mortInfo.initAll(i, req);
                    // ����ʱ��
                    mortInfo.setOperdate(BusinessDate.getToday());
                    // �û�id
                    mortInfo.setOperid(this.getOperator().getOperid());
                    // ���
                    if (req.getFieldValue(i, "boxid") != null) {
                        mortInfo.setBoxid(req.getFieldValue(i, "boxid"));
                    }
                    // ��ע
                    if (req.getFieldValue(i, "EXPRESSNOTE") != null) {
                        mortInfo.setExpressnote(req.getFieldValue(i, "EXPRESSNOTE"));
                    }
                    iAfterVersion = rs.getInt("recVersion");
                    iAfterVersion = iAfterVersion + 1;
                    mortInfo.setRecversion(iAfterVersion);
                    if (mortInfo.updateByWhere(" where mortid='" + rs.getString("mortid") + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                    // ��ˮ��־��
                    task = MortUtil.getTaskObj(rs.getString("mortid"), "170",
                            CcbLoanConst.OPER_BATCHEDIT);
                    task.setOperid(this.getOperator().getOperid());
                    task.setBankid(this.getOperator().getDeptid());
                    if (task.insert() < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }

                }
                if (rs != null) {
                    rs.close();
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
