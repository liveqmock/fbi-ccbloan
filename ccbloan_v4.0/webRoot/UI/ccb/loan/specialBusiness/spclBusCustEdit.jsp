<!--
/*********************************************************************
* ��������: ����ҵ��ͻ����Ϲ������
* �޸���: nanmeiying
* �޸�����: 2013/09/01
***********************************************************************/
-->
<%@page contentType="text/html; charset=GBK" %>
<%@include file="/global.jsp" %>
<%@page import="pub.platform.utils.BusinessDate" %>
<%@page import="pub.platform.utils.StringUtils" %>
<%@ page import="com.ccb.dao.LNSPCLBUSCUST" %>

<%
    OperatorManager omgr = (OperatorManager) session.getAttribute(SystemAttributeNames.USER_INFO_NAME);
    String custno = "";  //�ͻ���
    String doType = "";   // ��������

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
    <title>����ҵ��ͻ����Ϲ���</title>
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
            if(bustypeval=='99'){//����
                //�ñ�ע
                document.getElementById("basisremarktr").style.display="block";
                //�ñ�ע������Ϊ��
                document.getElementById("basisremark").setAttribute("isNull","false");
                isNotDelay();
                notRequired();
                sureNull();
            }else{
                //�ñ�ע����ʾ
                document.getElementById("basisremarktr").style.display="none";
                //�ñ�ע����Ϊ��
                document.getElementById("basisremark").setAttribute("isNull","true");
                //��ձ�ע
                document.getElementById("basisremark").value="";
             if(bustypeval=='10'){//ѡ�е������ڣ�չ�ڣ�
                 isDelay();
             }else{
                isNotDelay();
             }

             if(bustypeval=='50'||bustypeval=='60'||bustypeval=='70'){
                 //*��ʾ
                    required();
                 //������Ϊ��
                 notNull();
              }else{
                 //*����ʾ
                  notRequired();
                 //����Ϊ��
                 sureNull();
                }
            }
         }

         //ѡ�������ڣ�չ�ڣ���ʱ��
        function isDelay(){
            //ԭ���ʼ���� �������ڵ�tr
            document.getElementById("beforedatetr").style.display="block";
            //ԭ����Ŀ�ʼ���ڲ���Ϊ��
            document.getElementById("beforebgdate").setAttribute("isNull","false");
            //ԭ����Ľ������ڲ���Ϊ��
            document.getElementById("beforeenddate").setAttribute("isNull","false");
            //�ִ���Ŀ�ʼ��������
            document.getElementById("changedatetr").style.display="block";
            //�ִ���Ŀ�ʼ���ڲ���Ϊ��
            document.getElementById("changebgdate").setAttribute("isNull","false");
            //�ִ���Ľ������ڲ���Ϊ��
            document.getElementById("changeenddate").setAttribute("isNull","false");
            //ԭ������ ���ִ����� ��tr
            document.getElementById("orgrinlloanamttr").style.display="block";
            //ԭ������
            document.getElementById("orgrinlloanamt").setAttribute("isNull","false");
            //�ִ�����
            document.getElementById("loanintamt").setAttribute("isNull","false");
        }
        //ѡ������ڣ�չ�ڣ���ʱ��
        function isNotDelay(){
            //ԭ���ʼ���� �������ڵ�tr
            document.getElementById("beforedatetr").style.display="none";
            //ԭ����Ŀ�ʼ���ڲ���Ϊ��
            document.getElementById("beforebgdate").setAttribute("isNull","true");
            //ԭ����Ľ������ڲ���Ϊ��
            document.getElementById("beforeenddate").setAttribute("isNull","true");
            //�ִ���Ŀ�ʼ��������
            document.getElementById("changedatetr").style.display="none";
            //�ִ���Ŀ�ʼ���ڲ���Ϊ��
            document.getElementById("changebgdate").setAttribute("isNull","true");
            //�ִ���Ľ������ڲ���Ϊ��
            document.getElementById("changeenddate").setAttribute("isNull","true");
            //ԭ������ ���ִ����� ��tr
            document.getElementById("orgrinlloanamttr").style.display="none";
            //ԭ������
            document.getElementById("orgrinlloanamt").setAttribute("isNull","true");
            //�ִ�����
            document.getElementById("loanintamt").setAttribute("isNull","true");
            //�ִ��������
            document.getElementById("loanintamt").value="";
            // ԭ���������
            document.getElementById("orgrinlloanamt").value="";
            //����ִ��ʼ����
            document.getElementById("changebgdate").value="";
            //����ִ����������
            document.getElementById("changeenddate").value="";
            //���ԭ���ʼ����
            document.getElementById("beforebgdate").value="";
            //���ԭ�����������
            document.getElementById("beforeenddate").value="";
        }


        function sureNull(){
            //���������
            document.getElementById("changername").setAttribute("isNull","true");
            //�����֤������
            document.getElementById("changertype").setAttribute("isNull","true");
            //֤������
            document.getElementById("changerid").setAttribute("isNull","true");
            //�Ա�
            document.getElementById("changersex").setAttribute("isNull","true");
            //����
            document.getElementById("changerage").setAttribute("isNull","true");
            //��λ����
            document.getElementById("changerunit").setAttribute("isNull","true");
            //��ͥסַ
            document.getElementById("changeraddr").setAttribute("isNull","true");
            //�ֻ���
            document.getElementById("changertel").setAttribute("isNull","true");
            //��������
            document.getElementById("changerhousehold").setAttribute("isNull","true");
            //�Ļ��̶�
            document.getElementById("changerculture").setAttribute("isNull","true");
            //����״��
            document.getElementById("changermarriage").setAttribute("isNull","true");
            //����״��
            document.getElementById("changerhealth").setAttribute("isNull","true");
        }

        function notNull(){
            //���������
            document.getElementById("changername").setAttribute("isNull","false");
            //�����֤������
            document.getElementById("changertype").setAttribute("isNull","false");
            //֤������
            document.getElementById("changerid").setAttribute("isNull","false");
            //�Ա�
            document.getElementById("changersex").setAttribute("isNull","false");
            //����
            document.getElementById("changerage").setAttribute("isNull","false");
            //��λ����
            document.getElementById("changerunit").setAttribute("isNull","false");
            //��ͥסַ
            document.getElementById("changeraddr").setAttribute("isNull","false");
            //�ֻ���
            document.getElementById("changertel").setAttribute("isNull","false");
            //��������
            document.getElementById("changerhousehold").setAttribute("isNull","false");
            //�Ļ��̶�
            document.getElementById("changerculture").setAttribute("isNull","false");
            //����״��
            document.getElementById("changermarriage").setAttribute("isNull","false");
            //����״��
            document.getElementById("changerhealth").setAttribute("isNull","false");
        }

        //ѡ���Ƿ�����С����
        //����������  ������ʾ ����
        function required(){
            //���������
            document.getElementById("changernamespan").style.display="block";
            //�����֤������
            document.getElementById("changertypespan").style.display="block";
            //֤������
            document.getElementById("changeridspan").style.display="block";
            //�Ա�
            document.getElementById("changersexspan").style.display="block";
            //����
            document.getElementById("changeragespan").style.display="block";
            //��λ����
            document.getElementById("changerunitspan").style.display="block";
            //��ͥסַ
            document.getElementById("changeraddrspan").style.display="block";
            //�ֻ���
            document.getElementById("changertelspan").style.display="block";
            //��������
            document.getElementById("changerhouseholdspan").style.display="block";
            //�Ļ��̶�
            document.getElementById("changerculturespan").style.display="block";
            //����״��
            document.getElementById("changermarriagespan").style.display="block";
            //����״��
            document.getElementById("changerhealthspan").style.display="block";
        }

        //������
        function notRequired(){
            //���������
            document.getElementById("changernamespan").style.display="none";
            //�����֤������
            document.getElementById("changertypespan").style.display="none";
            //֤������
            document.getElementById("changeridspan").style.display="none";
            //�Ա�
            document.getElementById("changersexspan").style.display="none";
            //����
            document.getElementById("changeragespan").style.display="none";
            //��λ����
            document.getElementById("changerunitspan").style.display="none";
            //��ͥסַ
            document.getElementById("changeraddrspan").style.display="none";
            //�ֻ���
            document.getElementById("changertelspan").style.display="none";
            //��������
            document.getElementById("changerhouseholdspan").style.display="none";
            //�Ļ��̶�
            document.getElementById("changerculturespan").style.display="none";
            //����״��
            document.getElementById("changermarriagespan").style.display="none";
            //����״��
            document.getElementById("changerhealthspan").style.display="none";
        }

        //��֤�ֻ���
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

        //��֤����
        function checkAge(){
            var reg=/^[1-9]{1}\d{0,2}$/;
            var age=document.getElementById("changerage").value;
            if(age==""||age==null)
            {
                return;
            }
            if(!reg.test(age)){
                alert("������Ϣ���������ʽ����ȷ");
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
                alert("�������֤�Ÿ�ʽ���ԣ����������룡");
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

        //�����ż�����֤�ź�������ż���Ա�
        function checkMateID(input,matesexid) {
            var idStr = input.value;
            var re = new RegExp("\\d{17}([0-9]|X)");
            var b = re.test(idStr);
            if (!b || idStr.length > 18) {
                alert("��ż�����֤�Ÿ�ʽ���ԣ����������룡");
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
                alert("����д�����Ŀ�ʼ����");

                return;
            }
            var beginDate = new Date(bgdate.replace(/-/g,"/"));
            var endDate = new Date(enddate.replace(/-/g,"/"));
            if(beginDate >= endDate){
                alert("��ʼ���ڲ��ܴ��ڱ����Ľ�������");
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
        //��֤�ٷ���
        function checkPercent(obj){
            var val=obj.value;
            var reg=/^(0\.[0-9]\d*|[1-9]\d*(\.\d+)?)\%$/;
            if(val==""||val=="%"){
                obj.value="";
                return;
            }
            if(!reg.test(val)){
                alert("֧����������ȷ");
                obj.focus();
            }

        }
         //���%
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
                //������Ϣ����ż������
                document.getElementById("mateincome1").style.display="none";
                document.getElementById("mateincome2").style.display="none";
                document.getElementById("mateincome1").value="";
                //������Ϣ����ż����Ϣ
                for(var i=0;i<mateAllId.length;i++){
                    document.getElementById(mateAllId[i]).style.display="none";
                    document.getElementById(mateAllId[i]).value="";
                }
            }

        }
        //��ͥ�����Ƿ���ڱ��˺���ż��
        function checkAllMoney(obj){
            var changerincome=document.getElementById("changerincome").value;
            var marriateincome=document.getElementById("mateincome").value;
            var allincome=document.getElementById("changerfamilyincome").value;

            if(changerincome!=""&&marriateincome!=""&&allincome!=""){
               // alert("���������="+changerincome+"��ż����="+marriateincome+"��������="+allincome);
                if(parseInt(changerincome)+parseInt(marriateincome)<=parseInt(allincome)){
                    alert("��ͥ�����벻�ܴ��ڱ���˺���ż������֮��");
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
<!-- ������Ŀ״̬ -->
<input type="hidden" id="MYPROJSTATUS">
<br>
<fieldset>
    <legend>������Ϣ</legend>
    <table width="100%" cellspacing="0" border="0">
        <!-- �������� -->
        <input type="hidden" id="doType" value="<%=doType%>">
        <!-- �汾�� -->
        <input type="hidden" id="recVersion" value="">
        <!-- ϵͳ��־ʹ�� -->
        <input type="hidden" id="busiNode"/>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ͻ���</td>
            <td width="30%" class="data_input">
                <input type="text" id="custno" name="custno" value="auto" textLength="200" style="width:90%"
                       isNull="false" disabled="disabled">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ͻ���</td>
            <td width="30%" class="data_input">
                <input type="text" id="custname" name="custname" value="" textLength="20" style="width:90%"
                       isNull="false">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">֤������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">֤������</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyid" name="applyid" value="" textLength="50" style="width:90% " isNull="false"
                       onblur="checkID(this,'applybirthday','applyage','applysex');">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
            <td width="30%" class="data_input">
                <input type="text" id="applybirthday" name="applybirthday" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date" isNull="false" onchange="setAge(this,'applyage');">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyage" name="applyage" value="" textLength="3" style="width:90% " isNull="false" disabled="disabled">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�Ա�</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ͥ��ַ</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyaddr" name="applyaddr" value="" textLength="100" style="width:90% "
                       isNull="false">
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ֻ�1</td>
            <td width="30%" class="data_input">
                <input type="text" id="applytel1" name="applytel1" value="" textLength="11" style="width:90% "
                       isNull="false" onblur="checkTel('applytel1','������Ϣ���ֻ�1��ʽ����ȷ��')">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ֻ�2</td>
            <td width="30%" class="data_input">
                <input type="text" id="applytel2" name="applytel2" onblur="checkTel('applytel2','������Ϣ���ֻ�2��ʽ����ȷ��')" value="" textLength="11" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����绰1</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyothertel1" name="applyothertel1" value="" textLength="20" style="width:90% " isNull="false">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����绰2</td>
            <td width="30%" class="data_input">
                <input type="text" id="applyothertel2" name="applyothertel2" value="" textLength="20" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�Ļ��̶�</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����״��</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����״��</td>
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
    <legend>������Ϣһ</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԭ��������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ҵ������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ע</td>
            <td width="30%" colspan="3" class="data_input">
                <textarea  name="basisremark" rows="8" id="basisremark" value="" isNull="false" style="width:90%" textLength="1000" ></textarea>
                <span class="red_star">*</span>
            </td>
        </tr>
        <tr id="orgrinlloanamttr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԭ������</td>
            <td width="30%" class="data_input">
                <input type="text" id="orgrinlloanamt" name="orgrinlloanamt" onblur="checkDouble(this,'ԭ�������ʽ����ȷ')" value="" isNull="false" textLength="13" style="width:90% " isNull="false">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ִ�����</td>
            <td width="30%" class="data_input">
                <input type="text" id="loanintamt" name="loanintamt"  onblur="checkDouble(this,'�ִ������ʽ����ȷ')" value="" textLength="13" style="width:90% ">
                <span class="red_star">*</span>
            </td>
        </tr>

        <tr id="beforedatetr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԭ���ʼ����</td>
            <td width="30%" class="data_input">
                <input type="text" id="beforebgdate" name="beforebgdate" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԭ�����������</td>
            <td width="30%" class="data_input">
                <input type="text" id="beforeenddate" name="beforeenddate" value="" style="width:90%"  onchange="checkDate(this,'beforebgdate','beforeenddate');" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
        </tr>


        <tr id="changedatetr">
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ִ��ʼ����</td>
            <td width="30%" class="data_input">
                <input type="text" id="changebgdate" name="changebgdate" value="" style="width:90%" onClick="WdatePicker()"
                       fieldType="date">
                <span class="red_star">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ִ����������</td>
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
    <legend>������Ϣ��</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">���������</td>
            <td width="30%" class="data_input">
                <input type="text" id="changername" name="changername" value="" textLength="50"
                       style="width:90%; " >
                <span class="red_star" style="position: absolute; float:right;"   id="changernamespan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">֤������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">֤������</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerid" name="changerid" value="" textLength="50" style="width:90%;"
                       onchange="checkID(this,null,'changerage','changersex');">
                <span class="red_star" style="position: absolute; float:right;" id="changeridspan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�Ա�</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerage" name="changerage" onblur="checkAge()" value="" textLength="3" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changeragespan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��λ����</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerunit" name="changerunit" value="" textLength="50" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changerunitspan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ͥסַ</td>
            <td width="30%" class="data_input">
                <input type="text" id="changeraddr" name="changeraddr" value="" textLength="100" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changeraddrspan">*</span>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�ֻ���</td>
            <td width="30%" class="data_input">
                <input type="text" id="changertel" name="changertel" onblur="checkTel('changertel','������Ϣ�����ֻ��Ÿ�ʽ����ȷ��')" value="" textLength="11" style="width:90%;">
                <span class="red_star" style="position: absolute; float:right;" id="changertelspan">*</span>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�Ļ��̶�</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����״��</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����״��</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ż����</td>
            <td width="30%" class="data_input">
                <input type="text" id="matename" name="matename" value="" textLength="50"
                       style="width:90%; " >
                <%--<span class="red_star" style="position: absolute; float:right;" id="matenamespan">*</span>--%>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ż���֤��</td>
            <td width="30%" class="data_input">
                <input type="text" id="mateidcard" name="mateidcard" value="" textLength="50" style="width:90%;"
                       onchange="checkMateID(this,'matesex')">
                <%--<span class="red_star" style="position: absolute; float:right;" id="mateidcardspan">*</span>--%>
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ż��ϵ�绰</td>
            <td width="30%" class="data_input">
                <input type="text" id="matetel" name="matetel" onblur="checkTel('matetel','��ż��ϵ�绰��ʽ����ȷ��')" value="" textLength="11" style="width:90%;">
               <%-- <span class="red_star" style="position: absolute; float:right;" id="matetelspan">*</span>--%>
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ż�Ա�</td>
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
    <legend>������Ϣ��</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">ԭ�����������</td>
            <td width="30%" class="data_input">
                <input type="text" id="obmi" name="obmi" onblur="checkDouble(this,'ԭ������������ʽ����ȷ')" value="" textLength="13" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ͥ������</td>
            <td width="30%" class="data_input">
                <input type="text" id="obfi" name="obfi"  onblur="checkDouble(this,'��ͥ�������ʽ����ȷ')" value="" textLength="13" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ͥ�˿���</td>
            <td width="30%" class="data_input">
                <input type="text" onblur="setHouseAveIncome('obfi','orginalperson','orginalavg')" id="orginalperson" name="orginalperson" value="" textLength="3" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ͥ�˾�������</td>
            <td width="30%" class="data_input">
                <input type="text" id="orginalavg"  onblur="checkDouble(this,'��ͥ�˾��������ʽ����ȷ')" name="orginalavg" value="" textLength="13"
                       style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">���и�ծ֧�������</td>
            <td width="30%" class="data_input">
                <input type="text" id="taxrate"  name="taxrate" value=""
                       textLength="10" onfocus="addPercent(this)" onblur="checkPercent(this)" style="width:90% ">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>������Ϣ��</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�����Ա������</td>
            <td width="30%" class="data_input">
                <input type="text"  id="changerincome" name="changerincome"  onblur="checkDouble(this,'������������ʽ����ȷ');checkAllMoney(this)"   value="" textLength="13" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">������ͥ������</td>
            <td width="30%" class="data_input">
                <input type="text" id="changerfamilyincome" onblur="checkDouble(this,'���Ա��ͥ�������ʽ����ȷ');checkAllMoney(this)" name="changerfamilyincome" value="" textLength="13" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">������ͥ�˿���</td>
            <td width="30%" class="data_input">
                <input type="text" onblur="setHouseAveIncome('changerfamilyincome','changerfamilynum','changeravgincome')"  id="changerfamilynum" name="changerfamilynum"  value="" textLength="3" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">������ͥ�˾�������</td>
            <td width="30%" class="data_input">
                <input type="text" id="changeravgincome"  onblur="checkDouble(this,'���Ա��ͥ�˾��������ʽ����ȷ')" name="changeravgincome" value="" textLength="13"
                       style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������и�ծ֧�������</td>
            <td width="30%" class="data_input">
                <input type="text" id="deir" name="deir" value=""
                       textLength="10" onfocus="addPercent(this)" onblur="checkPercent(this)" style="width:90% ">
            </td>

            <td width="20%" id="mateincome1" nowrap="nowrap" class="lbl_right_padding">�������ż��������</td>
            <td width="30%" id="mateincome2" class="data_input">
                <input type="text" id="mateincome" name="mateincome" value=""
                       textLength="10"  onblur="checkDouble(this,'��ż�������ʽ����ȷ');checkAllMoney(this)" style="width:90% ">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>������Ϣ��</legend>
    <table width="100%" cellspacing="0" border="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">˰��Ǽ�֤��</td>
            <td width="30%" class="data_input">
                <input type="text" id="taxregno" name="taxregno" value="" textLength="50" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">Ӫҵִ�պ�</td>
            <td width="30%" class="data_input">
                <input type="text" id="busilicno" name="busilicno" value="" textLength="50" style="width:90% ">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��֯��������֤��</td>
            <td width="30%" class="data_input">
                <input type="text" id="orgcode" name="orgcode" value="" textLength="50" style="width:90% ">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����������</td>
            <td width="30%" class="data_input">
                <input type="text" id="bankid" name="bankid" value=""
                       textLength="50" style="width:90% " disabled="disabled">
            </td>
        </tr>

        <tr>
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">��Ӫ����</td>
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
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">�ͻ�����</td>
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
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">�������</td>
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
            <td width="15%" nowrap="nowrap" class="lbl_right_padding">Ӫ������</td>
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
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
            <td width="30%" class="data_input">
                <input type="text" id="operid" name="operid" value="" textLength="50" style="width:90% " disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�޸Ĺ�Ա</td>
            <td width="30%" class="data_input">
                <input type="text" id="modifyoperid" name="modifyoperid"
                       value="" textLength="50" style="width:90% " disabled="disabled">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��������</td>
            <td width="30%" class="data_input">
                <input type="text" id="operdate" name="operdate"
                       value="" style="width:90%" fieldType="date" disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">�޸�����</td>
            <td width="30%" class="data_input">
                <input type="text" id="modifydate" name="modifydate" value="" style="width:90%" disabled="disabled"
                       fieldType="date">
            </td>
        </tr>
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">��ע</td>
            <td width="30%" colspan="3" class="data_input">
                <textarea name="remark" rows="8" id="remark" value="" style="width:90%" textLength="1000"></textarea>
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>������Ϣ</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">������Ա</td>
            <td width="30%" class="data_input">
                <input type="text" value="<%=omgr.getOperatorName()%>" style="width:90%" disabled="disabled">
            </td>
            <td width="20%" nowrap="nowrap" class="lbl_right_padding">����ʱ��</td>
            <td width="30%" class="data_input">
                <input type="text" value="<%=BusinessDate.getToday() %>" style="width:90%" disabled="disabled">
            </td>
        </tr>
    </table>
</fieldset>
<br>
<fieldset>
    <legend>����</legend>
    <table width="100%" class="title1" cellspacing="0">
        <tr>
            <td align="center">
                <%if (doType.equals("select")) { %><!--��ѯ-->
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;�ر�&nbsp;&nbsp;&nbsp;"
                       onclick="window.close();">
                <%} else if (doType.equals("edit") || doType.equals("add")) { %>   <!--���ӣ��޸�-->
                <input id="savebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;����&nbsp;&nbsp;&nbsp;"
                       onclick="saveClick();">
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;"
                       onclick="window.close();">
                <%} else if (doType.equals("delete")) { %>  <!--ɾ��-->
                <input id="deletebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ɾ��&nbsp;&nbsp;&nbsp;"
                       onclick="deleteClick();">
                <input id="closebut" class="buttonGrooveDisable" onMouseOver="button_onmouseover()"
                       onmouseout="button_onmouseout()" type="button" value="&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;"
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
