package com.ccb.promotion;

import com.ccb.dao.LNPROMMGRINFO;
import com.ccb.dao.LNPROMOTIONCUSTOMERS;
import com.ccb.dao.LNTASKINFO;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import com.ccb.util.SeqUtil;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.db.RecordSet;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;

/**
 * Created by IntelliJ IDEA.
 * User: haiyuhuang
 * Date: 11-7-28
 * Time: ����5:07
 * To change this template use File | Settings | File Templates.
 */
public class promotionAction extends Action {
    // ��־����
    private static final Log logger = LogFactory.getLog(promotionAction.class);
    //Ӫ���ͻ���
    LNPROMOTIONCUSTOMERS lnpromcust = null;
    // ��ˮ��¼��
    LNTASKINFO task = null;
    //Ӫ���������
    LNPROMMGRINFO lnprommgrinfo = null;

    public int add() {
        lnpromcust = new LNPROMOTIONCUSTOMERS();
        //�ƽ�ͻ�˳���
        String promotionCustNo = "";
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                lnpromcust.init(i, req);
                promotionCustNo = SeqUtil.getPromontioncustno();
                lnpromcust.setPromcust_no(promotionCustNo);
                //���״̬��ʼΪ 0
                lnpromcust.setStatus(0);
                //����ʱ�� ����
                lnpromcust.setOperdate(BusinessDate.getTodaytime());
                //������Ա
                lnpromcust.setOperid2(this.getOperator().getOperid());
                //������
                lnpromcust.setBankid(this.getDept().getDeptid());

                if (lnpromcust.insert() < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }
                //��ˮ��־
                task = MortUtil.getTaskObj(req.getFieldValue(i, "promcust_no"), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_ADD);
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

    public int edit() {
        lnpromcust = new LNPROMOTIONCUSTOMERS();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                lnpromcust.init(i, req);
                //����ʱ�� ����
                lnpromcust.setOperdate(BusinessDate.getTodaytime());
                //������Ա
                lnpromcust.setOperid2(this.getOperator().getOperid());
                //Ӫ������
                lnpromcust.setCust_bankid(this.getDept().getDeptid());

                // ����ǰ�汾��
                int iBeforeVersion = 0;
                if (req.getFieldValue(i, "recVersion") != null && !req.getFieldValue(i, "recVersion").equals("")) {
                    iBeforeVersion = Integer.parseInt(req.getFieldValue(i, "recVersion"));
                }
                int iAfterVersion = 0;
                RecordSet rs = dc.executeQuery("select recversion from ln_promotioncustomers where PROMCUST_NO='"
                        + req.getFieldValue(i, "PROMCUST_NO") + "'");
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
                        lnpromcust.setRecversion(iBeforeVersion);
                    }
                }
                if (rs != null) {
                    rs.close();
                }
                //״̬Ϊ���ͨ��ʱ ��Ӫ��������Ϣ����Ӫ���������
                if (lnpromcust.getStatus() == 2) {
                    LNPROMOTIONCUSTOMERS templnpromcust = LNPROMOTIONCUSTOMERS.findFirst("where PROMCUST_NO='" + req.getFieldValue(i, "PROMCUST_NO") + "'");
                    //��֤Ӫ����������Ƿ��Ѵ��ڸ�Ӫ��������
                    boolean promgrIsExist = dc.isExist("select 1 from ln_prommgrinfo t where t.prommgr_name='" + templnpromcust.getPrommgr_name() + "'" +
                            " and t.deptid='" + templnpromcust.getBankid() + "'");
                    if (!promgrIsExist) {
                        lnprommgrinfo = new LNPROMMGRINFO();
                        String tempprommgrid = SeqUtil.getPrommgrid();
                        lnprommgrinfo.setDeptid(templnpromcust.getBankid());
                        lnprommgrinfo.setPrommgr_name(templnpromcust.getPrommgr_name());
                        lnprommgrinfo.setPrommgr_id(tempprommgrid);
                        //��Ӫ������id��Ϣ������Ӫ���ͻ���
                        lnpromcust.setPrommgr_id(tempprommgrid);
                        if (lnprommgrinfo.insert() < 0) {
                            this.res.setType(0);
                            this.res.setResult(false);
                            this.res.setMessage(PropertyManager.getProperty("300"));
                            return -1;
                        }
                    }

                }
                if (lnpromcust.updateByWhere(" where PROMCUST_NO='" + req.getFieldValue(i, "PROMCUST_NO") + "'") < 0) {
                    this.res.setType(0);
                    this.res.setResult(false);
                    this.res.setMessage(PropertyManager.getProperty("300"));
                    return -1;
                }

                //��ˮ��־
                task = MortUtil.getTaskObj(req.getFieldValue(i, "promcust_no"), req.getFieldValue(i, "busiNode"), CcbLoanConst.OPER_EDIT);
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
}
