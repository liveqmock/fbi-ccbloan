package com.ccb.creditrating;

/**
 * ͳ�Ʊ�ģ��
 */
public class CountModel {
    private String deptName;//������
    private int ptNum;//��ͨƽ������
    private int jtNum;//����ƽ������
    private int gdNum;//�߶�ƽ������
    private int jhNum;//��ƽ������
    private int clNum;//����ƽ������
    private int qtNum;//����ƽ������
    private int hjNum;//�ϼ�����

    public CountModel(String deptName, int ptNum, int jtNum, int gdNum, int jhNum, int clNum, int qtNum, int hjNum) {
        this.deptName = deptName;
        this.ptNum = ptNum;
        this.jtNum = jtNum;
        this.gdNum = gdNum;
        this.jhNum = jhNum;
        this.clNum = clNum;
        this.qtNum = qtNum;
        this.hjNum = hjNum;
    }

    public String getDeptName() {
        return deptName;
    }

    public void setDeptName(String deptName) {
        this.deptName = deptName;
    }

    public int getPtNum() {
        return ptNum;
    }

    public void setPtNum(int ptNum) {
        this.ptNum = ptNum;
    }

    public int getJtNum() {
        return jtNum;
    }

    public void setJtNum(int jtNum) {
        this.jtNum = jtNum;
    }

    public int getGdNum() {
        return gdNum;
    }

    public void setGdNum(int gdNum) {
        this.gdNum = gdNum;
    }

    public int getJhNum() {
        return jhNum;
    }

    public void setJhNum(int jhNum) {
        this.jhNum = jhNum;
    }

    public int getClNum() {
        return clNum;
    }

    public void setClNum(int clNum) {
        this.clNum = clNum;
    }

    public int getQtNum() {
        return qtNum;
    }

    public void setQtNum(int qtNum) {
        this.qtNum = qtNum;
    }

    public int getHjNum() {
        return hjNum;
    }

    public void setHjNum(int hjNum) {
        this.hjNum = hjNum;
    }
}
