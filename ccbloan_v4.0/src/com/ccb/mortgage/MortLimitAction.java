package com.ccb.mortgage;

/**
 * <p>Title: 后台业务组件</p>
 *
 * <p>Description: 后台业务组件</p>
 *
 * <p>Copyright: Copyright (c) 2010</p>
 *
 * <p>Company: 公司</p>
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
    // 日志对象
    private static final Log logger = LogFactory.getLog(MortLimitAction.class);
    //参数对象
    LNMORTLIMIT mortLimit = null;
    // 废号管理对象
    SYSSEQDISCARD seqInfoDiscard = null;

    // 流水记录表
    LNTASKINFO task = null;

    /**
     * <p/>
     * 抵押信息增加接口
     * <p/>
     * 成功或失败均返回消息
     * <p/>
     * 部门id、用户id、操作时间均在后台赋值
     *
     * @return
     */
    public int add() {
        mortLimit = new LNMORTLIMIT();
        // 取出抵押编号
        String mortID = "";
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {

                // 初始化数据bean
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
     * 抵押信息编辑接口
     * <p/>
     * 除了更新页面上的值之外，用户id、操作时间也一起更新；
     * <p/>
     * 更新前进行版本号检查，控制并发问题
     *
     * @return
     */
    public int edit() {

        mortLimit = new LNMORTLIMIT();
        for (int i = 0; i < this.req.getRecorderCount(); i++) {
            try {
                // 初始化数据bean
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
                this.res.setMessage("处理失败：" + ex1.getMessage());
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
     * 删除接口
     * <p/>
     * 删除一条记录后，抵押编号要保存进废弃号码管理表，以备下次继续使用
     */
    public int delete() {
        seqInfoDiscard = new SYSSEQDISCARD();

        try {
            // 抵押编号
            String mortID = req.getFieldValue("mortID");
            // 抵押编号得不到的情况下提示操作失败
            if (mortID == null || mortID.equalsIgnoreCase("null")) {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }

            /** 抵押编号保存进废弃号码管理表 */
            // 编号类型
            seqInfoDiscard.setBhlx(CcbLoanConst.MORTTYPE);
            // 抵押编号
            seqInfoDiscard.setDiscardno(mortID);
            // 使用标志: 未使用状态；
            seqInfoDiscard.setUseflg(0);
            // 原关系业务序号:贷款申请序号
            seqInfoDiscard.setOseqno(req.getFieldValue("loanID"));
            // 进表日期
            seqInfoDiscard.setIndate(BusinessDate.getNowDay());
            // 进表人员
            seqInfoDiscard.setInoperid(this.getOperator().getOperid());
            // 进表类型
            seqInfoDiscard.setDotype("delete");

            if (seqInfoDiscard.insert() < 0) {
                this.res.setType(0);
                this.res.setResult(false);
                this.res.setMessage(PropertyManager.getProperty("300"));
                return -1;
            }

            // 删除抵押信息
            dc.executeUpdate("delete from ln_mortinfo where mortid='" + mortID + "'");
            // 流水日志表
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
     * 如果用户直接退出抵押管理页面，则把已生成的抵押编号放进废弃表中以备下次使用
     * <p/>
     */
    public int saveMortID_bak() {
        seqInfoDiscard = new SYSSEQDISCARD();

        try {
            // 抵押编号
            String mortID = req.getFieldValue("mortID");
            /** 抵押编号保存进废弃号码管理表 */
            // 业务类型
            seqInfoDiscard.setBhlx(CcbLoanConst.MORTTYPE);
            // 编号
            seqInfoDiscard.setDiscardno(mortID);
            // 使用标志: 未使用状态；
            seqInfoDiscard.setUseflg(0);
            // 原关系业务序号:贷款申请序号
            seqInfoDiscard.setOseqno(req.getFieldValue("loanID"));

            /** 先判断废号管理表中有无该没有使用的序号，如果没有则增加 */
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
     * 批量快递
     * <p/>
     * 除了更新页面上的值之外，用户id、操作时间也一起更新；
     * <p/>
     * 更新前进行版本号检查，控制并发问题
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
