<!--
/*********************************************************************
* 功能描述: 特殊业务客户资料管理操作
* 修改人: nanmeiying
* 修改日期: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.utils.BusinessDate" %>
<%@page import="pub.platform.utils.StringUtils" %>
<%@ page import="com.ccb.dao.LNSPCLBUSCUST" %>

<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String custno = "";  //客户号
    String doType = "";   // 操作类型

    if (request.getParameter("custno") != null) {
        custno = request.getParameter("custno");
    }
    if (request.getParameter("doType") != null)
        doType = request.getParameter("doType");

    LNSPCLBUSCUST bean = new LNSPCLBUSCUST();
    if (custno != null) {
        bean = LNSPCLBUSCUST.findFirst("where custno='" + custno + "'");
        if (bean != null) {
//            bean.setAge(Calendar.getInstance().get(Calendar.YEAR) - Integer.parseInt(bean.getBirthday().substring(0, 4)));
            StringUtils.getLoadForm(bean, out);
        }
    }
%>
<html>
<head>
    <META http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>特殊业务客户资料管理</title>
    <script language="javascript" src="/UI/support/tabpane.js"></script>
    <script language="javascript" src="/UI/support/common.js"></script>
    <script language="javascript" src="/UI/support/DataWindow.js"></script>
    <script language="javascript" src="/UI/support/pub.js"></script>
    <script language="javascript" src="spclBusCustEdit.js"></script>
    <script type="text/javascript">
        function load(){
            change();
            marriage();
           // reselectRealCustMgr();
        }

        document.onkeydown = function TabReplace() {
            if (event.keyCode == 13) {
                if (event.srcElement.tagName != 'BUTTON')
                    event.keyCode = 9;
                else
                    event.srcElement.click();
            }
        }

        function change(){
            var bustypeval=document.getElementById("bustype").value;
            if(bustypeval=='99'){//其他
                //让备注
                document.getElementById("basisremarktr").style.display="block";
                //让备注不可以为空
                document.getElementById("basisremark").setAttribute("isNull","false");
                isNotDelay();
                notRequired();
                sureNull();
            }else{
                //让备注不显示
                document.getElementById("basisremarktr").style.display="none";
                //让备注可以为空
                document.getElementById("basisremark").setAttribute("isNull","true");
                //清空备注
                document.getElementById("basisremark").value="";
             if(bustypeval=='10'){//选中的是延期（展期）
                 isDelay();
             }else{
                isNotDelay();
             }

             if(bustypeval=='50'||bustypeval=='60'||bustypeval=='70'){
                 //*显示
                    required();
                 //不可以为空
                 notNull();
              }else{
                 //*不显示
                  notRequired();
                 //可以为空
                 sureNull();
                }
            }
         }

         //选项是延期（展期）的时候
        function isDelay(){
            //原贷款开始日期 结束日期的tr
            document.getElementById("beforedatetr").style.display="block";
            //原贷款的开始日期不能为空
            document.getElementById("beforebgdate").setAttribute("isNull","false");
            //原贷款的结束日期不能为空
            document.getElementById("beforeenddate").setAttribute("isNull","false");
            //现贷款的开始结束日期
            document.getElementById("changedatetr").style.display="block";
            //现贷款的开始日期不能为空
            document.getElementById("changebgdate").setAttribute("isNull","false");
            //现贷款的结束日期不能为空
            document.getElementById("changeenddate").setAttribute("isNull","false");
            //原贷款金额 和现贷款金额 的tr
            document.getElementById("orgrinlloanamttr").style.display="block";
            //原贷款金额
            document.getElementById("orgrinlloanamt").setAttribute("isNull","false");
            //现贷款金额
            document.getElementById("loanintamt").setAttribute("isNull","false");
        }
        //选项不是延期（展期）的时候
        function isNotDelay(){
            //原贷款开始日期 结束日期的tr
            document.getElementById("beforedatetr").style.display="none";
            //原贷款的开始日期不能为空
            document.getElementById("beforebgdate").setAttribute("isNull","true");
            //原贷款的结束日期不能为空
            document.getElementById("beforeenddate").setAttribute("isNull","true");
            //现贷款的开始结束日期
            document.getElementById("changedatetr").style.display="none";
            //现贷款的开始日期不能为空
            document.getElementById("changebgdate").setAttribute("isNull","true");
            //现贷款的结束日期不能为空
            document.getElementById("changeenddate").setAttribute("isNull","true");
            //原贷款金额 和现贷款金额 的tr
            document.getElementById("orgrinlloanamttr").style.display="none";
            //原贷款金额
            document.getElementById("orgrinlloanamt").setAttribute("isNull","true");
            //现贷款金额
            document.getElementById("loanintamt").setAttribute("isNull","true");
            //现贷款金额清空
            document.getElementById("loanintamt").value="";
            // 原贷款金额清空
            document.getElementById("orgrinlloanamt").value="";
            //清空现贷款开始日期
            document.getElementById("changebgdate").value="";
            //清空现贷款结束日期
            document.getElementById("changeenddate").value="";
            //清空原贷款开始日期
            document.getElementById("beforebgdate").value="";
            //清空原贷款结束日期
            document.getElementById("beforeenddate").value="";
        }


        function sureNull(){
            //变更人姓名
            document.getElementById("changername").setAttribute("isNull","true");
            //变更人证件类型
            document.getElementById("changertype").setAttribute("isNull","true");
            //证件号码
            document.getElementById("changerid").setAttribute("isNull","true");
            //性别
            document.getElementById("changersex").setAttribute("isNull","true");
            //年龄
            document.getElementById("changerage").setAttribute("isNull","true");
            //单位名称
            document.getElementById("changerunit").setAttribute("isNull","true");
            //家庭住址
            document.getElementById("changeraddr").setAttribute("isNull","true");
            //手机号
            document.getElementById("changertel").setAttribute("isNull","true");
            //户口性质
            document.getElementById("changerhousehold").setAttribute("isNull","true");
            //文化程度
            document.getElementById("changerculture").setAttribute("isNull","true");
            //婚姻状况
            document.getElementById("changermarriage").setAttribute("isNull","true");
            //健康状况
            document.getElementById("changerhealth").setAttribute("isNull","true");
        }

        function notNull(){
            //变更人姓名
            document.getElementById("changername").setAttribute("isNull","false");
            //变更人证件类型
            document.getElementById("changertype").setAttribute("isNull","false");
            //证件号码
            document.getElementById("changerid").setAttribute("isNull","false");
            //性别
            document.getElementById("changersex").setAttribute("isNull","false");
            //年龄
            document.getElementById("changerage").setAttribute("isNull","false");
            //单位名称
            document.getElementById("changerunit").setAttribute("isNull","false");
            //家庭住址
            document.getElementById("changeraddr").setAttribute("isNull","false");
            //手机号
            document.getElementById("changertel").setAttribute("isNull","false");
            //户口性质
            document.getElementById("changerhousehold").setAttribute("isNull","false");
            //文化程度
            document.getElementById("changerculture").setAttribute("isNull","false");
            //婚姻状况
            document.getElementById("changermarriage").setAttribute("isNull","false");
            //健康状况
            document.getElementById("changerhealth").setAttribute("isNull","false");
        }

        //选项是否必填的小红星
        //必填的情况下  红星显示 必填
        function required(){
            //变更人姓名
            document.getElementById("changernamespan").style.display="block";
            //变更人证件类型
            document.getElementById("changertypespan").style.display="block";
            //证件号码
            document.getElementById("changeridspan").style.display="block";
            //性别
            document.getElementById("changersexspan").style.display="block";
            //年龄
            document.getElementById("changeragespan").style.display="block";
            //单位名称
            document.getElementById("changerunitspan").style.display="block";
            //家庭住址
            document.getElementById("changeraddrspan").style.display="block";
            //手机号
            document.getElementById("changertelspan").style.display="block";
            //户口性质
            document.getElementById("changerhouseholdspan").style.display="block";
            //文化程度
            document.getElementById("changerculturespan").style.display="block";
            //婚姻状况
            document.getElementById("changermarriagespan").style.display="block";
            //健康状况
            document.getElementById("changerhealthspan").style.display="block";
        }

        //不必填
        function notRequired(){
            //变更人姓名
            document.getElementById("changernamespan").style.display="none";
            //变更人证件类型
            document.getElementById("changertypespan").style.display="none";
            //证件号码
            document.getElementById("changeridspan").style.display="none";
            //性别
            document.getElementById("changersexspan").style.display="none";
            //年龄
            document.getElementById("changeragespan").style.display="none";
            //单位名称
            document.getElementById("changerunitspan").style.display="none";
            //家庭住址
            document.getElementById("changeraddrspan").style.display="none";
            //手机号
            document.getElementById("changertelspan").style.display="none";
            //户口性质
            document.getElementById("changerhouseholdspan").style.display="none";
            //文化程度
            document.getElementById("changerculturespan").style.display="none";
            //婚姻状况
            document.getElementById("changermarriagespan").style.display="none";
            //健康状况
            document.getElementById("changerhealthspan").style.display="none";
        }

        //验证手机号
        function checkTel(id,msg){
            var reg=/^[1][1-9]{1}\d{9}$/;
            var obj=document.getElementById(id);
            if(obj.value==""||obj.value==null){
                return;
            }
            if(!reg.test(obj.value)){
                alert(msg);
                obj.focus();
            }
        }

        //验证年龄
        function checkAge(){
            var reg=/^[1-9]{1}\d{0,2}$/;
            var age=document.getElementById("changerage").value;
            if(age==""||age==null)
            {
                return;
            }
            if(!reg.test(age)){
                alert("附加信息二的年龄格式不正确");
                document.getElementById("changerage").focus();
            }
        }

        function checkDouble(obj,msg){
            var reg=/^[0-9]+(\.[0-9]+)?$/;
            var val=obj.value;
            if(val==""||val==null){
                return;
            }

            if(!reg.test(val)){
                obj.focus();
                alert(msg);
            }
        }

        function checkID(input,birthdayid,ageid,sexid) {
            var idType = document.getElementById("applyidcardtype").value;
           // alert(idType)
            if (idType != "01") {
                return;
            }
            var idStr = input.value;
            var re = new RegExp("\\d{17}([0-9]|X)");
            var b = re.test(idStr);
            if (!b || idStr.length > 18) {
                alert("输入身份证号格式不对，请重新输入！");
                input.focus();
                return;
            }else{
                var birthday=idStr.substr(6,8);
                var year=birthday.substr(0,4);
                var month=birthday.substr(4,2);
                var date=birthday.substr(6,2);

                if(birthdayid!=null) {
                    document.getElementById(birthdayid).value = year + "-" + month + "-" + date;
                }
                document.getElementById(ageid).value = new Date().getFullYear() - parseInt(year)
                var sexValue = parseInt(idStr.charAt(16));
                if (sexValue % 2 == 0) {
                    document.getElementById(sexid).value = "0";
                } else {
                    document.getElementById(sexid).value = "1";
                }

            }
        }

        //检查配偶的身份证号和设置配偶的性别
        function checkMateID(input,matesexid) {
            var idStr = input.value;
            var re = new RegExp("\\d{17}([0-9]|X)");
            var b = re.test(idStr);
            if (!b || idStr.length > 18) {
                alert("配偶的身份证号格式不对，请重新输入！");
                input.focus();
                return;
            }else{
                var sexValue = parseInt(idStr.charAt(16));
                if (sexValue % 2 == 0) {
                    document.getElementById(matesexid).value = "0";
                } else {
                    document.getElementById(matesexid).value = "1";
                }

            }
        }



        function checkDate(obj,changebgdate,changeenddate){
            var bgdate=document.getElementById(changebgdate).value;
            var enddate=document.getElementById(changeenddate).value;
            if(bgdate==null||bgdate==""){
                document.getElementById("changeenddate").value="";
                document.getElementById(changebgdate).focus();
                alert("请填写变更后的开始日期");

                return;
            }
            var beginDate = new Date(bgdate.replace(/-/g,"/"));
            var endDate = new Date(enddate.replace(/-/g,"/"));
            if(beginDate >= endDate){
                alert("开始日期不能大于变更后的结束日期");
                obj.focus();
            }
        }

        function setAge(input,ageid) {

            var btValue = input.value;
            var ageNode = document.getElementById(ageid);
            if (btValue == "") {
                ageNode.value = 0;
            } else {
                ageNode.value = new Date().getFullYear() - parseInt(btValue.substring(0, 4));
            }
        }

        function setHouseAveIncome(homeincome,homepersons,homeavg) {
            if(document.getElementById(homeincome).value!=""&&document.getElementById(homepersons).value!="") {
                var homeincomeValue = parseInt(document.getElementById(homeincome).value);
                var homepersonsValue = parseInt(document.getElementById(homepersons).value);
                    document.getElementById(homeavg).value = parseInt(homeincomeValue / homepersonsValue);

            }
        }
        //验证百分数
        function checkPercent(obj){
            var val=obj.value;
            var reg=/^(0\.[0-9]\d*|[1-9]\d*(\.\d+)?)\%$/;
            if(val==""||val=="%"){
                obj.value="";
                return;
            }
            if(!reg.test(val)){
                alert("支出比例不正确");
                obj.focus();
            }

        }
         //添加%
        function addPercent(obj){
            var val=obj.value;
            if(val==""||val=="%")
            obj.value="%";
        }

        function marriage(){
            var val=document.getElementById("changermarriage").value;
            var mateAllId=["matename","mateidcard","matetel","matesex"];
            if(val=='1'||val=='2')
            {
                document.getElementById("mateincome1").style.display="block";
                document.getElementById("mateincome2").style.display="block";
                for(var i=0;i<mateAllId.length;i++){
                    document.getElementById(mateAllId[i]).style.display="block";
                }

            }else{
                //附加信息四配偶的收入
                document.getElementById("mateincome1").style.display="none";
                document.getElementById("mateincome2").style.display="none";
                document.getElementById("mateincome1").value="";
                //附加信息二配偶的信息
                for(var i=0;i<mateAllId.length;i++){
                    document.getElementById(mateAllId[i]).style.display="none";
                    document.getElementById(mateAllId[i]).value="";
                }
            }

        }
        //家庭收入是否大于本人和配偶的
        function checkAllMoney(obj){
            var changerincome=document.getElementById("changerincome").value;
            var marriateincome=document.getElementById("mateincome").value;
            var allincome=document.getElementById("changerfamilyincome").value;

            if(changerincome!=""&&marriateincome!=""&&allincome!=""){
               // alert("变更人收入="+changerincome+"配偶收入="+marriateincome+"所有收入="+allincome);
                if(parseInt(changerincome)+parseInt(marriateincome)<=parseInt(allincome)){
                    alert("家庭月收入不能大于变更人和配偶月收入之和");
                   obj.onfocus();
                }
            }
        }

        function focus(){
           return true;
        }

        function parseToInt(input) {
            input.value = parseInt(input.value);
        }

    </script>
</head>
<body bgcolor="#ffffff" onLoad="formInit();load();" class="Bodydefault">
<form id="editForm" name="editForm">
<!-- 合作项目状态 -->
<input type="hidden" id="MYPROJSTATUS">
<br>
<fieldset>
    <legend>基本信息</legend>
    <table width="100%" cellspacing="0" border="0">
        <!-- 操作类型 -->
        <input type="hidden" id="doType" value="<%=doType%>">
        <!-- 版本号 -->
        <input type="hidden" id="recVersion" value="">
        <!-- 系统日志使用 -->
        <input type="hidden" id="busiNode"/>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">客户号</td>
            <td width="30%" class="data_input">
                <input type="text" id="custno" name="custno" value="auto" textLength="200" style="width:90%"
                       isNull="false" disabled="disabled">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">客户名</td>
            <td width="30%" class="data_input">
                <input type="text" id="custname" name="custname" value="" textLength="20" style="width:90%"
                       isNull="false">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">证件类型</td>
            <td width="30%" class="data_input">
                <%
                    ZtSelect zs = new ZtSelect("applyidcardtype", "idtype", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">证件号码</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyid" name="applyid" value="" textLength="50" style="width:90% " isNull="false"
                       onblur="checkID(this,'applybirthday','applyage','applysex');">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">出生日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="applybirthday" name="applybirthday" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date" isNull="false" onchange="setAge(this,'applyage');">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">年龄</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyage" name="applyage" value="" textLength="3" style="width:90% " isNull="false" disabled="disabled">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">性别</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("applysex", "sex", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">家庭地址</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyaddr" name="applyaddr" value="" textLength="100" style="width:90% "
                       isNull="false">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">手机1</td>
            <td width="30%" class="data_input">
                <input type="text" id="applytel1" name="applytel1" value="" textLength="11" style="width:90% "
                       isNull="false" onblur="checkTel('applytel1','基本信息的手机1格式不正确！')">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">手机2</td>
            <td width="30%" class="data_input">
                <input type="text" id="applytel2" name="applytel2" onblur="checkTel('applytel2','基本信息的手机2格式不正确！')" value="" textLength="11" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">其他电话1</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyothertel1" name="applyothertel1" value="" textLength="20" style="width:90% " isNull="false">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">其他电话2</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyothertel2" name="applyothertel2" value="" textLength="20" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">户口性质</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("applyregister", "livetype", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">文化程度</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("applyculture", "education", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">婚姻状况</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("applymarriage", "marista", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">健康状况</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("applyhealth", "health", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>附加信息一</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">原贷款种类</td>
            <td width="30%" class="data_input">
                <%
                    ZtSelect ztSelect = new ZtSelect("loantype", "", "");
                    ztSelect.setSqlString("select code_id as value ,code_desc as text  from ln_odsb_code_desc where code_type_id='053'");
                    ztSelect.addAttr("style", "width: 90%");
                    ztSelect.addAttr("fieldType", "text");
                    //zs.addAttr("isNull","false");
                    ztSelect.addOption("", "");
                    out.print(ztSelect);
                %>
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">申请业务种类</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("bustype", " ", "");
                    zs.setSqlString("select EnuItemValue as value,EnuItemLabel as text from ptEnuDetail where EnuType = 'SPCLBUSTYPE' order by EnuItemValue");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("isNull", "false");
                    zs.addAttr("onchange","change()");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star">*</span>
            </td>
        </tr>

        <tr id="basisremarktr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">备注</td>
            <td width="30%" colspan="3" class="data_input">
                <textarea  name="basisremark" rows="8" id="basisremark" value="" isNull="false" style="width:90%" textLength="1000" ></textarea>
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr id="orgrinlloanamttr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">原贷款金额</td>
            <td width="30%" class="data_input">
                <input type="text" id="orgrinlloanamt" name="orgrinlloanamt" onblur="checkDouble(this,'原贷款金额格式不正确')" value="" isNull="false" textLength="13" style="width:90% " isNull="false">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">现贷款金额</td>
            <td width="30%" class="data_input">
                <input type="text" id="loanintamt" name="loanintamt"  onblur="checkDouble(this,'现贷款金额格式不正确')" value="" textLength="13" style="width:90% ">
                <span class="red_star">*</span>
            </td>
        </tr>

        <tr id="beforedatetr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">原贷款开始日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="beforebgdate" name="beforebgdate" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">原贷款结束日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="beforeenddate" name="beforeenddate" value="" style="width:90%"  onchange="checkDate(this,'beforebgdate','beforeenddate');" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
        </tr>


        <tr id="changedatetr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">现贷款开始日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="changebgdate" name="changebgdate" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">现贷款结束日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="changeenddate" name="changeenddate" value="" style="width:90%"  onchange="checkDate(this,'changebgdate','changeenddate');" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
        </tr>

    </table>
</fieldset>
<br>
<fieldset>
    <legend>附加信息二</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更人姓名</td>
            <td width="30%" class="data_input">
                <input type="text" id="changername" name="changername" value="" textLength="50"
                       style="width:90%; " >
                <span class="red_star" style="position: absolute; float:right;"   id="changernamespan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">证件类型</td>
            <td width="30%" class="data_input">
                <%
                    ZtSelect ztSelect1 = new ZtSelect("changertype", "idtype", "");
                    ztSelect1.addAttr("style", "width: 90%");
                    ztSelect1.addAttr("fieldType", "text");
                    //ztSelect1.addAttr("style", "float: left;");
                    ztSelect1.addOption("", "");
                    out.print(ztSelect1);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changertypespan">*</span>
            </td>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">证件号码</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerid" name="changerid" value="" textLength="50" style="width:90%;"
                       onchange="checkID(this,null,'changerage','changersex');">
                <span class="red_star" style="position: absolute; float:right;" id="changeridspan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">性别</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("changersex", "sex", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changersexspan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">年龄</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerage" name="changerage" onblur="checkAge()" value="" textLength="3" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changeragespan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">单位名称</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerunit" name="changerunit" value="" textLength="50" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changerunitspan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">家庭住址</td>
            <td width="30%" class="data_input">
                <input type="text" id="changeraddr" name="changeraddr" value="" textLength="100" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changeraddrspan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">手机号</td>
            <td width="30%" class="data_input">
                <input type="text" id="changertel" name="changertel" onblur="checkTel('changertel','附加信息二的手机号格式不正确！')" value="" textLength="11" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changertelspan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">户口性质</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("changerhousehold", "livetype", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changerhouseholdspan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">文化程度</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("changerculture", "education", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changerculturespan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">婚姻状况</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("changermarriage", "marista", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("onchange", "marriage(this)");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changermarriagespan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">健康状况</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("changerhealth", "health", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <span class="red_star" style="position: absolute; float:right;" id="changerhealthspan">*</span>
            </td>
        </tr>

        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">配偶姓名</td>
            <td width="30%" class="data_input">
                <input type="text" id="matename" name="matename" value="" textLength="50"
                       style="width:90%; " >
                <%--<span class="red_star" style="position: absolute; float:right;" id="matenamespan">*</span>--%>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">配偶身份证号</td>
            <td width="30%" class="data_input">
                <input type="text" id="mateidcard" name="mateidcard" value="" textLength="50" style="width:90%;"
                       onchange="checkMateID(this,'matesex')">
                <%--<span class="red_star" style="position: absolute; float:right;" id="mateidcardspan">*</span>--%>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">配偶联系电话</td>
            <td width="30%" class="data_input">
                <input type="text" id="matetel" name="matetel" onblur="checkTel('matetel','配偶联系电话格式不正确！')" value="" textLength="11" style="width:90%;">
               <%-- <span class="red_star" style="position: absolute; float:right;" id="matetelspan">*</span>--%>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">配偶性别</td>
            <td width="30%" class="data_input">
                <%
                    zs = new ZtSelect("matesex", "sex", "");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    //zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %>
                <%--<span class="red_star" style="position: absolute; float:right;" id="matesexspan">*</span>--%>
            </td>
        </tr>

    </table>
</fieldset>
<br>
<fieldset>
    <legend>附加信息三</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">原借款人月收入</td>
            <td width="30%" class="data_input">
                <input type="text" id="obmi" name="obmi" onblur="checkDouble(this,'原借款人月收入格式不正确')" value="" textLength="13" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">家庭月收入</td>
            <td width="30%" class="data_input">
                <input type="text" id="obfi" name="obfi"  onblur="checkDouble(this,'家庭月收入格式不正确')" value="" textLength="13" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">家庭人口数</td>
            <td width="30%" class="data_input">
                <input type="text" onblur="setHouseAveIncome('obfi','orginalperson','orginalavg')" id="orginalperson" name="orginalperson" value="" textLength="3" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">家庭人均月收入</td>
            <td width="30%" class="data_input">
                <input type="text" id="orginalavg"  onblur="checkDouble(this,'家庭人均月收入格式不正确')" name="orginalavg" value="" textLength="13"
                       style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">所有负债支出收入比</td>
            <td width="30%" class="data_input">
                <input type="text" id="taxrate"  name="taxrate" value=""
                       textLength="10" onfocus="addPercent(this)" onblur="checkPercent(this)" style="width:90% ">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>附加信息四</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更人员月收入</td>
            <td width="30%" class="data_input">
                <input type="text"  id="changerincome" name="changerincome"  onblur="checkDouble(this,'变更人月收入格式不正确');checkAllMoney(this)"   value="" textLength="13" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更后家庭月收入</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerfamilyincome" onblur="checkDouble(this,'变更员家庭月收入格式不正确');checkAllMoney(this)" name="changerfamilyincome" value="" textLength="13" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更后家庭人口数</td>
            <td width="30%" class="data_input">
                <input type="text" onblur="setHouseAveIncome('changerfamilyincome','changerfamilynum','changeravgincome')"  id="changerfamilynum" name="changerfamilynum"  value="" textLength="3" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更后家庭人均月收入</td>
            <td width="30%" class="data_input">
                <input type="text" id="changeravgincome"  onblur="checkDouble(this,'变更员家庭人均月收入格式不正确')" name="changeravgincome" value="" textLength="13"
                       style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">变更后所有负债支出收入比</td>
            <td width="30%" class="data_input">
                <input type="text" id="deir" name="deir" value=""
                       textLength="10" onfocus="addPercent(this)" onblur="checkPercent(this)" style="width:90% ">
            </td>

            <td width="20%" id="mateincome1" nowrap="nowrap" class="lbl_right_padding">变更后配偶的月收入</td>
            <td width="30%" id="mateincome2" class="data_input">
                <input type="text" id="mateincome" name="mateincome" value=""
                       textLength="10"  onblur="checkDouble(this,'配偶月收入格式不正确');checkAllMoney(this)" style="width:90% ">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>附加信息五</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">税务登记证号</td>
            <td width="30%" class="data_input">
                <input type="text" id="taxregno" name="taxregno" value="" textLength="50" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">营业执照号</td>
            <td width="30%" class="data_input">
                <input type="text" id="busilicno" name="busilicno" value="" textLength="50" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">组织机构代码证号</td>
            <td width="30%" class="data_input">
                <input type="text" id="orgcode" name="orgcode" value="" textLength="50" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">建立机构号</td>
            <td width="30%" class="data_input">
                <input type="text" id="bankid" name="bankid" value=""
                       textLength="50" style="width:90% " disabled="disabled">
            </td>
        </tr>

        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">经营中心</td>
            <td width="35%" class="data_input">
                <%
                    zs = new ZtSelect("operatingcenter", "", "");
                    zs.setSqlString("select deptid, deptname  from ptdept where FILLSTR10='3'"
                            + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                            + " connect by prior deptid = parentdeptid order by deptid");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("onchange", "reSelectCustBank()");
                    zs.addOption("", "");
                    zs.addAttr("isNull", "true");
                    out.print(zs);
                %>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">客户经理</td>
            <td width="35%" class="data_input">

                <%
                    ZtSelect  zss = new ZtSelect("customermanager", "", "");
                 %>
                <%
                    if("edit".equals(doType)) {
                        zss.setSqlString("select OPERID as value ,OPERNAME as text  from ptoper t where t.deptid='" + bean.getOperatingcenter() + "'");
                    }
                %>
                <%
                    zss.addAttr("style", "width: 90%");
                    zss.addAttr("fieldType", "text");
                    zss.addAttr("isNull", "true");
                    zss.addOption("", "");
                    out.print(zss);
                %>
            </td>
        </tr>
        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">经办机构</td>
            <td width="35%" class="data_input">

                <%
                    zs = new ZtSelect("agencies", "", "");
                    zs.setSqlString("select deptid, deptname  from ptdept"
                            + " start with deptid = '" + omgr.getOperator().getDeptid() + "'"
                            + " connect by prior deptid = parentdeptid  order by FILLSTR20,deptid");
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("onchange", "reSelect()");
                    zs.addOption("", "");
                    zs.addAttr("isNull", "false");
                    out.print(zs);
                %><span class="red_star">*</span>
            </td>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">营销经理</td>
            <td width="35%" class="data_input">

                <%
                    zs = new ZtSelect("marketingmanager", "", "");
                %>
                <%
                    if("edit".equals(doType)) {
                        zs.setSqlString("select t.prommgr_id as value,t.prommgr_name as text from ln_prommgrinfo t  where t.deptid='" + bean.getAgencies()+ "' order by prommgr_id desc ");
                    }
                %>
                <%
                    zs.addAttr("style", "width: 90%");
                    zs.addAttr("fieldType", "text");
                    zs.addAttr("onchange", "promMgrReSelect()");
                    zs.addAttr("isNull", "false");
                    zs.addOption("", "");
                    out.print(zs);
                %><span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">建立柜员</td>
            <td width="30%" class="data_input">
                <input type="text" id="operid" name="operid" value="" textLength="50" style="width:90% " disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">修改柜员</td>
            <td width="30%" class="data_input">
                <input type="text" id="modifyoperid" name="modifyoperid"
                       value="" textLength="50" style="width:90% " disabled="disabled">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">建立日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="operdate" name="operdate"
                       value="" style="width:90%" fieldType="date" disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">修改日期</td>
            <td width="30%" class="data_input">
                <input type="text" id="modifydate" name="modifydate" value="" style="width:90%" disabled="disabled"
                       fieldType="date">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">备注</td>
            <td width="30%" colspan="3" class="data_input">
                <textarea name="remark" rows="8" id="remark" value="" style="width:90%" textLength="1000"></textarea>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>操作信息</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作人员</td>
            <td width="30%" class="data_input">
                <input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%" disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">操作时间</td>
            <td width="30%" class="data_input">
                <input type="text" value="<%=BusinessDate.getToday() %>" style="width:90%" disabled="disabled">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>操作</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td align="center">
                <%if (doType.equals("select")) { %><!--查询-->
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;关闭&nbsp;&nbsp;&nbsp;"
                       onclick="window.close();">
                <%} else if (doType.equals("edit") || doType.equals("add")) { %>   <!--增加，修改-->
                <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;保存&nbsp;&nbsp;&nbsp;"
                       onclick="saveClick();">
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;"
                       onclick="window.close();">
                <%} else if (doType.equals("delete")) { %>  <!--删除-->
                <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;删除&nbsp;&nbsp;&nbsp;"
                       onclick="deleteClick();">
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;取消&nbsp;&nbsp;&nbsp;"
                       onclick="window.close();">
                <%} %>
            </td>
        </tr>
    </table>
</fieldset>
<br>
</form>
</body>
</html>
