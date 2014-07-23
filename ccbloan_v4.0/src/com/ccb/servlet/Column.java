package com.ccb.servlet;

/**
 * Created with IntelliJ IDEA.
 * User: vincent
 * Date: 13-4-17
 * Time: ÏÂÎç4:39
 * To change this template use File | Settings | File Templates.
 */
import java.io.Serializable;

public class Column implements Serializable{

    private String header;
    private int width;
    private String name;
    private String align;
    private String render;


    public Column(String header, int width, String name, String align,
                  String render) {
        super();
        this.header = header;
        this.width = width;
        this.name = name;
        this.align = align;
        this.render = render;
    }

    public Column(){
        super();
    }
    public String getHeader() {
        return header;
    }
    public void setHeader(String header) {
        this.header = header;
    }
    public int getWidth() {
        return width;
    }
    public void setWidth(int width) {
        this.width = width;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getAlign() {
        return align;
    }
    public void setAlign(String align) {
        this.align = align;
    }
    public String getRender() {
        return render;
    }
    public void setRender(String render) {
        this.render = render;
    }
}