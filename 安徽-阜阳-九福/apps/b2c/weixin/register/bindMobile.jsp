<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.openjweb.core.entity.*" %>
<%@ page import="com.openjweb.weixin.entity.*" %>
<%@ page import="java.util.*"%>
<%@ page import="org.openjweb.core.util.*"%>
<%@ page import="com.openjweb.weixin.pojo.*"%>
<%@ page import="com.openjweb.weixin.util.*"%>
<%@ page import="com.openjweb.weixin.service.*"%>
<%@ page import="org.openjweb.core.service.*" %>
<%@ page import="com.alipay.api.*" %>
<%@ page import="com.alipay.api.request.*" %>
<%@ page import="com.alipay.api.response.*" %>
<%@ page import="com.openjweb.b2c.entity.*" %>  
<%@ page import="com.alipay.factory.*" %>  
<%@ page import="com.alipay.constants.*" %>  


<%@ page import="org.openjweb.core.service.IDBSupportService"%> 
<%@ page import="org.openjweb.core.service.ServiceLocator"%> 
<%@ page import="org.openjweb.core.service.ws.*"%> 
<%@ page import="org.openjweb.core.entity.*"%> 
<%@ page import="org.springframework.remoting.rmi.RmiServiceExporter"%>
<%@ page import="java.util.*"%>
<%@ page import="org.openjweb.core.rmi.client.AccountService,org.openjweb.core.wf2.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.openjweb.core.webservice.xfire.*"%>
<%@ page import="java.lang.reflect.Proxy"%>
<%@ page import="com.baidu.yun.channel.sample.*"%>
<%@ page import="org.directwebremoting.json.JsonUtil"%>

<%@ include file="/apps/b2c/appStoreDesign/city/checkLogin.jsp"%> 


<%

String miniOpenId = request.getParameter("miniOpenId")==null?"":request.getParameter("miniOpenId");
String miniCode = request.getParameter("miniCode")==null?"":request.getParameter("miniCode");
String locationX = request.getParameter("locationX")==null?"":request.getParameter("locationX");
String locationY = request.getParameter("locationY")==null?"":request.getParameter("locationY");
String scene = request.getParameter("scene")==null?"":request.getParameter("scene");
String branchId = request.getParameter("branchId")==null?"":request.getParameter("branchId");
String salesId = request.getParameter("salesId")==null?"":request.getParameter("salesId");
//salesId="1234";
//branchId="0001";

System.out.println("bindMobile.jsp::入参::miniOpenId=" + miniOpenId);
System.out.println("bindMobile.jsp::入参::miniCode=" + miniCode);
System.out.println("bindMobile.jsp::入参::locationX=" + locationX);
System.out.println("bindMobile.jsp::入参::locationY=" + locationY);
System.out.println("bindMobile.jsp::入参::scene=" + scene);
System.out.println("bindMobile.jsp::入参::branchId=" + branchId);
System.out.println("bindMobile.jsp::入参::salesId=" + salesId);


//首先获取OpenID,根据OpenID判断是否已经注册
//检查当前的openid是否已经绑定手机
WeixinSceneLog logEnt = null;
String mobileNo = "";
String isValidMobile = "";
try
{
	String sql = "from WeixinSceneLog where toUser ='"+user.getUsername()+"'";
	System.out.println("bindMobile.jsp sql:"+sql);
	logEnt = (WeixinSceneLog)service.findSingleValueByHql(sql);
}
catch(Exception ex)
{}

if(logEnt!=null)
{
	System.out.println("logEnt非空");
}
else
{
	System.out.println("logEnt为空!..................");
}

if(logEnt!=null)
{
	mobileNo = logEnt.getMobileNo()==null?"":logEnt.getMobileNo();
	isValidMobile= logEnt.getIsValidMobile()==null?"":logEnt.getIsValidMobile();

}
else
{
	out.println("error");
	return;
}
//System.out.println(user.getUsername());
//System.out.println(mobileNo);
//System.out.println(isValidMobile);


//if(1==2) //开发调试先不跳转
if("Y".equals(isValidMobile)) //如果手机已验证则跳转到个人中心

{
	//跳转到用户中心
	response.sendRedirect("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+ent.getAppId()+"&redirect_uri=https%3A%2F%2F"+ent.getDomainName()+"%2Fportal%2Fapps%2Fb2c%2Fweixin%2Fmemcenter%2FmemCenter.jsp&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect");
}
else
{
	//本页面绑定手机
}



%>

<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>注册新会员卡 </title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black" />
		<!--数字拨号-->
		<meta content="telephone=no" name="format-detection" />

		<link rel="stylesheet" type="text/css" href="css/reset.css" />
		<link rel="stylesheet" type="text/css" href="css/common.css"/>
		<link rel="stylesheet" type="text/css" href="css/register.css"/>
		<script src="js/jquery.1.7.2.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="js/buju.js" type="text/javascript" charset="utf-8"></script>
		<script type='text/javascript' src='/portal/dwr/util.js'></script>
        <script type='text/javascript' src='/portal/dwr/engine.js'></script>
        <script type='text/javascript' src='/portal/dwr/interface/SmsUtil.js'></script> 

		<script language="javascript">
		var memSex ="";
		var countdown = 60;
		
		</script>



		
		

	</head>

	<body>
		<div class="wrap">
			<section>
				<div class="classify box">
					<p class="sign">*</p>
					<p class="name">姓名</p>
					<input type="text" name="name" id="name" value="" placeholder="请填写您的姓名" class="input"/>
				</div>
				
				<div class="classify box">
					<p class="sign">*</p>
					<p class="name">手机号</p>
					<input type="number" name="mobileNo" id="mobileNo" value="" placeholder="请填写您的手机号" class="input"/>
				</div>
				
				<div class="classify box">
					<p class="sign"></p>
					<p class="name">性别</p>
					<div class="radio box">
						<div class="radioN box">
							<div class="radioInput">
								<input type="" name="" id="" value="" class="inp"/>
							</div>
							<p>男</p>
						</div>&nbsp;&nbsp;
						<div class="radioN box">
							<div class="radioInput">
								<input type="" name="" id="" value="" class="inp"/>
							</div>
							<p>女</p>
						</div>
						
					</div>
					
				</div>
				
				
				 <div class="classify box"> 
					<p class="sign">*</p>
					<div class="name">出生日期</div>
					<input type="date" name="birthday" id="birthday" value='<%=user.getBirthDay()==null?"":user.getBirthDay()%>'  style="width:200px;height:30px;font-size:15px;display:inline-block;text-align:left;background-color: #FFFFFF;margin-top: 0.16rem;"/>
				</div>

				<div class="classify box">
					<p class="sign"></p>
					<p class="name">小区</p>
					<input type="text" name="MemDistrict" id="MemDistrict" value="" placeholder="请输入小区" class="input"/>
				</div>
				
				
				
				<div class="classify box">
					<p class="sign"></p>
					<p class="name">备注</p>
					<input type="number" name="MemSales" id="MemSales" value='<%=salesId==null?"":salesId%>' placeholder="请输入备注" class="input"/>
				</div>

				
				<div class="classify code box">
					<p class="sign">*</p>
					<p class="name">验证码</p>
					<input type="number" name="validCode" id="validCode" value="" placeholder="请填写您的验证码" class="input countInput"/>
                    <input type="button" id="getValidCode" value="获取验证码" onclick="send_code()" class="countDown"/> 
					
				</div>
				
			</section>
			
			<p class="register"  onclick="doBindMobile()">立即注册</p>
		</div>
	</body>
	
	<script src="js/jquery.1.7.2.min.js" type="text/javascript" charset="utf-8"></script>
	<script language="javascript">


		function send_code() 
			{
				var mobile = $("#mobileNo").val();
				var validCode = $("#validCode").val();
				var birthday =  $("#birthday").val();
				var name =  $("#name").val();
				var MemDistrict =  $("#MemDistrict").val();
				var MemSales =  $("#MemSales").val();
				
				//alert('提交前检查性别为'+memSex);
				//alert("mobile:" + mobile + ";validCode:" + validCode + ";sex:" + memSex + ";birthday:" + birthday + ";name:" + name + ";MemDistrict:" + MemDistrict + ";MemSales:"+ MemSales);
				
				if(name==null || name== '' || name == undefined){
					alert("姓名不能为空！");
					return;
				}	

									
				//手机号验证
				if(mobile==null || mobile== '' || mobile == undefined)
				{
					//layer.msg("手机号不能为空！",{time: 3000, icon:5});
					alert("手机号不能为空！");
					return;
				}
				else
				{
					if(!isMobile(mobile) || mobile.length != 11)
					{
						//layer.msg("请填写正确的手机号！",{time: 3000, icon:5});
						alert("请填写正确的手机号！");
						return;
					}
				}
				
				//校验手机号
				 
                var isMob=  /^[1][3,4,5,6,7,8,9][0-9]{9}$/; //正则串，不要加引号
                
                if(isMob.test(mobile))
				{
                     
                }
                else
				{
					alert("请填写正确的手机号！");
                    return  ; //手机格式不正确
                }


				if(memSex==null || memSex== '' || memSex == undefined){
					alert("性别必须正确填写！");
					return;
				}	

				
				
				
				if(birthday==null || birthday== '' || birthday == undefined){
					alert("生日不能为空！");
					return;
				}	


				//提交
				$.ajax({
					type: "POST",
					url: '/portal/api/login.jsp',
					data:
					{
						act:'checkMemMobile',
						mobileOrEmail:mobile
					},
					async: false,
					success: function (data) 
					{
						
						var result =  eval ("(" + data + ")");  
						//alert("检查结果：" + result.isSuccess);
						 
						if("Y" == result.isSuccess){
							settime();
							//允许注册
							SmsUtil.sendRechargePwdValidateCode(document.getElementById("mobileNo").value,
							{
								callback:function(data)
								{
									if (data == "success")
									{
										//alert("短信验证码已发送到手机!");
										//$('#dialog2').show();
										// $('#shop-code').focus();
										//settime();
										
									}  
									else 
									{
										alert(data);
									}
								}
							}
							);


						}else{
							//layer.msg(result.errMsg,{time: 3000, icon:5});
							alert(result.errMsg);
							countdown =0;
							settime();
							return;
						}
					},
					error: function () {
						alert("检查手机能否注册，异常中止！");
						return;
					}
				});
			
				//time();
			}
			
			
			
function settime() { 
    if (countdown == 0) { 
		document.getElementById("getValidCode").disabled=false; 
        document.getElementById("getValidCode").value="获取验证码"; 
        document.getElementById("getValidCode").style.color = "f2f2f2";
        countdown = 60; 
        return;
    } else { 
		document.getElementById("getValidCode").disabled=true; 
        document.getElementById("getValidCode").value="重新发送(" + countdown + ")"; 
        countdown--; 
    } 
setTimeout(function() { 
    settime() }
    ,1000) 
}


		//表单提交
		function doBindMobile(){
			var mobile = $("#mobileNo").val();
			var validCode = $("#validCode").val();
			var birthday =  $("#birthday").val();
			var name =  $("#name").val();
			var MemDistrict =  $("#MemDistrict").val();
			var MemSales =  $("#MemSales").val();
			
			//alert('提交前检查性别为'+memSex);
			//alert("mobile:" + mobile + ";validCode:" + validCode + ";sex:" + memSex + ";birthday:" + birthday + ";name:" + name + ";MemDistrict:" + MemDistrict + ";MemSales:"+ MemSales);
			
			if(name==null || name== '' || name == undefined){
				alert("姓名不能为空！");
				return;
			}	

			if(memSex==null || memSex== '' || memSex == undefined){
				alert("性别必须正确填写！");
				return;
			}	

			
			
			//var password = $("#password").val();
			//var comformPassword = $("#comformPassword").val();
		    //手机号验证
			if(mobile==null || mobile== '' || mobile == undefined){
				//layer.msg("手机号不能为空！",{time: 3000, icon:5});
				alert("手机号不能为空！");
				return;
			}else{
				if(!isMobile(mobile) || mobile.length != 11){
					//layer.msg("请填写正确的手机号！",{time: 3000, icon:5});
					alert("请填写正确的手机号！");
					return;
				}
			}
			
			
			if(birthday==null || birthday== '' || birthday == undefined){
				alert("生日不能为空！");
				return;
			}			
			
			
			//验证码验证
			if(validCode==null || validCode=='' || validCode == undefined){
				//layer.msg("验证码不能为空！",{time: 3000, icon:5});
				alert("验证码不能为空！");
				return;
			}
			//密码验证
			//var patrn= /^[a-zA-Z0-9]{6,12}$/;  //密码的格式为6-12位，只能是字母、数字
		    //alert('a11111111111111111111111');
			
			//提交
			$.ajax({
				type: "POST",
				url: '/portal/api/login.jsp',
				data:
				{
					act:'bindMobile',
					loginId:'<%=user.getLoginId()%>',
				    openId:'<%=user.getUsername()%>',
					name:name,
					sex:memSex,
					birthday:birthday,
					mobileOrEmail:mobile,
					validCode:validCode,
					MemDistrict:MemDistrict,
					MemSales:MemSales,
					isSendRegistValidCode:'Y',
					locationX:'<%=locationX==null?"":locationX%>',
					locationY:'<%=locationY==null?"":locationY%>',
					branchId:'<%=branchId==null?"":branchId%>'
				},
				async: false,
				success: function (data) 
				{
					
					var result =  eval ("(" + data + ")");  
					 
					if("Y" == result.isSuccess){
						//获取验证码成功
						//layer.msg(result.errMsg,{time: 3000, icon:6});
						var url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=ent.getAppId()%>&redirect_uri=https%3A%2F%2F<%=ent.getDomainName()%>%2Fportal%2Fapps%2Fb2c%2Fweixin%2Fmemcenter%2FmemCenter.jsp&response_type=code&scope=snsapi_base&state=STATE#wechat_redirect";
						 
						window.location.href = url;
					}else{
						//layer.msg(result.errMsg,{time: 3000, icon:5});
						alert(result.errMsg);
					}
				},
				error: function () {
					//layer.msg("服务器异常！",{time: 3000, icon:5});
					alert("服务器异常！");
				}
			});
		}
		
		function isPasswd(s){
			var patrn=/^(\w){6,12}$/;
			if (!patrn.exec(s)) 
				return false
			return true
		}

		
		function isMobile(s){
			var patrn= /^[a-zA-Z0-9]{11,11}$/;  //Mobile的格式为11位，只能是数字
			if (!patrn.exec(s)) 
				return false
			return true
		}




$(function(){
//	radio  男女选择
	
	$(".radioInput").click(function(){
		var i = $(".radioInput").index(this);
		//alert("index(this):" + i);
		if($(this).is(":checked")){
			$(".inp").attr("checked",true);
			$(".radioInput").css("background-image","url(image/registerRadio1.png)");
			$(".inp").eq(i).attr("checked",false);
			$(this).css("background-image","url(image/registerRadio2.png)");
			
		}else{
			$(".inp").attr("checked",false);
			$(".radioInput").css("background-image","url(image/registerRadio2.png)");
			$(".inp").eq(i).attr("checked",true);
			$(this).css("background-image","url(image/registerRadio1.png)");
		}
		//alert("index(this):" + i);
		
		if ( i == 0)
		{
			memSex	= '0';
			//alert("0-choie:" + i + "value:" + memSex);
		}
		else
		{
			memSex	= '1';
			//alert("1-choie:" + i + "value:" + memSex);
		}
	})
	
	
	
	
	//立即注册 对勾
var bol = true;
		$(".explainImg").click(function(){
			if(bol == true){
				$(".explainImg").attr("src","image/registerSelect5.png");
				bol = false ;
			}else{
				$(".explainImg").attr("src","image/registerSelect3.png");
				bol = true;
			}
		})
})

	

	</script>

</html>