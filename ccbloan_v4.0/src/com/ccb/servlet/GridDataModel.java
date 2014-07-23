package com.ccb.servlet;

/**
 * Created with IntelliJ IDEA.
 * User: vincent
 * Date: 13-4-17
 * Time: 下午4:32
 * To change this template use File | Settings | File Templates.
 */
import com.ccb.dao.LNARCHIVEINFO;

import java.util.ArrayList;
import java.util.List;

public class GridDataModel<T> {
    // 显示的总数
    private int total;
    // 行数据
    private List<T> rows = new ArrayList<T>();

    private List<LNARCHIVEINFO> colmodel = new ArrayList<LNARCHIVEINFO>();

    public List<LNARCHIVEINFO> getColmodel() {
        return colmodel;
    }

    public void setColmodel(List<LNARCHIVEINFO> colmodel) {
        this.colmodel = colmodel;
    }

    public List<T> getRows() {
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

}
