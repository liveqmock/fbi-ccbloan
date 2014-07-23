package com.ccb.servlet;

/**
 * Created with IntelliJ IDEA.
 * User: vincent
 * Date: 13-4-17
 * Time: ÏÂÎç4:36
 * To change this template use File | Settings | File Templates.
 */

import com.ccb.dao.LNARCHIVEINFO;
import pub.platform.db.ConnectionManager;
import pub.platform.db.DatabaseConnection;
import pub.platform.db.RecordSet;

import java.util.ArrayList;
import java.util.List;

public class LnArchiveInfoService {
    public static List<LNARCHIVEINFO> lnarchiveinfos = null;

    public LnArchiveInfoService(){
        getInfoList();
    }

    public static void getInfoList(){
        try {
            List<LNARCHIVEINFO> lnarchiveinfoList= new ArrayList<LNARCHIVEINFO>();
            DatabaseConnection conn = ConnectionManager.getInstance().get();
            RecordSet rs =  conn.executeQuery("select a.flowsn, a.cust_name, a.rt_orig_loan_amt, a.rt_term_incr " +
                    " from ln_archive_info a");
            int rsCount=0;
            while(rs.next()){
                LNARCHIVEINFO lnarchiveinfo = new LNARCHIVEINFO();
                lnarchiveinfo.setFlowsn(rs.getString("flowsn"));
                lnarchiveinfo.setCust_name(rs.getString("cust_name"));
                lnarchiveinfo.setRt_orig_loan_amt(rs.getDouble("rt_orig_loan_amt"));
                lnarchiveinfo.setRt_term_incr(rs.getInt("rt_term_incr"));
                lnarchiveinfoList.add(lnarchiveinfo);
            }
            lnarchiveinfos = lnarchiveinfoList;
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }


    public List<LNARCHIVEINFO> getIpsByCity(String flowsn){
        int size= lnarchiveinfos.size();
        List<LNARCHIVEINFO> ips=new ArrayList();
        for(int i=0; i<size; i++){
            if(lnarchiveinfos.get(i).getFlowsn().contains(flowsn))
                ips.add(lnarchiveinfos.get(i));
        }
        return ips;

    }
}
