package com.ccb.insurance;

import com.ccb.dao.LNINSURANCE;
import com.ccb.dao.LNTASKINFO;
import com.ccb.mortgage.MortUtil;
import com.ccb.util.CcbLoanConst;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import pub.platform.advance.utils.PropertyManager;
import pub.platform.form.control.Action;
import pub.platform.utils.BusinessDate;

/**
 * Created by IntelliJ IDEA.
 * User: haiyuhuang
 * Date: 12-2-28
 * Time: ����4:17
 * To change this template use File | Settings | File Templates.
 */
public class insuranceAction extends Action {
    // ��־����
    private static final Log logger = LogFactory.getLog(insuranceAction.class);
    //20120228 ���յ���Ϣ��
    LNINSURANCE insurance = null;
    // ��ˮ��¼��
    LNTASKINFO task = null;

    public int add() {
        insurance = new LNINSURANCE();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                //20120228 add ���뱣�յ���Ϣ����
                String attendflag = req.getFieldValue(i, "attendflag");
                if (attendflag.equals("1")) {
                    insurance.setAttendflag(attendflag); //��������յ���־
                    insurance.setLoanid(req.getFieldValue(i, "loanid"));
                    insurance.setMortid(req.getFieldValue(i,"mortid"));
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
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), "000",
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
        this.res.setType(0);
        this.res.setResult(true);
        this.res.setMessage(PropertyManager.getProperty("200"));
        return 0;
    }

    public int edit() {
        insurance = new LNINSURANCE();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // ��ʼ������bean
                insurance.initAll(i, req);
                //20120228 add ���뱣�յ���Ϣ����
                String loanID = req.getFieldValue(i, "loanid");
                String mortID = req.getFieldValue(i, "mortid");
                String attendflag = req.getFieldValue(i, "attendflag");
                if (attendflag != null) {
                    insurance.setAttendflag(attendflag); //��������յ���־
                    insurance.setLoanid(loanID);
                    insurance.setMortid(mortID);
                    insurance.setOperid2(this.getOperator().getOperid());
                    insurance.setOperdate(BusinessDate.getToday());
                    if (insurance.updateByWhere(" where mortid='" + mortID + "'") < 0) {
                        this.res.setType(0);
                        this.res.setResult(false);
                        this.res.setMessage(PropertyManager.getProperty("300"));
                        return -1;
                    }
                }
                // ��ˮ��־��
                task = MortUtil.getTaskObj(req.getFieldValue(i, "loanid"), "000",
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
}
