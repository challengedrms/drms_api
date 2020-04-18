<%@ page contentType="text/html;charset=utf-8" %>
<%@ page import="org.openjweb.core.service.IDBSupportService"%> 
<%@ page import="org.openjweb.core.service.ServiceLocator"%> 
<%@ page import="org.openjweb.core.service.ws.*"%> 
<%@ page import="org.openjweb.core.entity.*"%> 
<%@ page import="org.springframework.remoting.rmi.RmiServiceExporter"%>
<%@ page import="org.openjweb.core.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.openjweb.core.rmi.client.AccountService,org.openjweb.core.wf2.*"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@ page import="org.openjweb.core.webservice.xfire.*"%>
<%@ page import="java.lang.reflect.Proxy"%>
<%@ page import="org.openjweb.core.util.*"%>
<%@ page import="com.baidu.yun.channel.sample.*"%>
<%@ page import="org.directwebremoting.json.JsonUtil"%>
<%@ include file="/apps/b2c/appStoreDesign/city/checkLogin.jsp"%>
<%
String sql = "";
WeixinSceneLog logEnt = null;
try
{
	sql = "from WeixinSceneLog where toUser ='"+user.getUsername()+"'";
	//System.out.println("bindMobile.jsp sql:"+sql);
	logEnt = (WeixinSceneLog)service.findSingleValueByHql(sql);
	
	//因为可能修改了用户信息,重新查询用户
	user = (CommUser)service.findSingleValueByHql("from CommUser where username='"+user.getUsername()+"'");
}
catch(Exception ex)
{}


IDBSupportService service10 = (IDBSupportService) ServiceLocator.getBean("IDBSupportService10");



int couponCount = 0;
int potCount = 0;


try
{
	//sql = "select sum(mp_sum_pot) from pos.mem_personal,pos.mem_online_register where mor_login_id='"+user.getLoginId()+"' and mor_mobile= mp_mobile_phone";
	//sql = "select count(*) from pos.product";
	sql = "select sum(mp_sum_pot) from pos.mem_personal,pos.mem_online_register where mor_login_id='"+user.getLoginId()+"' and mor_mem_id= mp_id";
	//System.out.println("memCenter.jsp::会员积分数SQL::"+sql);
	potCount = service10.getJdbcTemplate().queryForInt(sql);
}
catch(Exception ex)
{}


try
{
	//sql = "select count(*) from pos.branch";
	//sql = "select count(*) from pos.mem_personal,pos.mem_online_register,pos.promotion_prepaid where mor_login_id='"+user.getLoginId()+"' and mor_mobile= mp_mobile_phone and ppr_belong_name = '会员卡' and  mp_id = ppr_belong_name";
	//sql = "select count(*) from pos.mem_personal,pos.mem_online_register,pos.promotion_prepaid where mor_login_id='"+user.getLoginId()+"' and mor_mem_id= mp_id and ppr_belong_name = '会员卡' and  mp_id = ppr_belong_memo and ppr_valid = 'Y' and ppr_edate >= to_date('2018-07-25','yyyy-mm-dd')";
	if (1==1)
	{
		sql = "select count(*) from pos.promotion_prepaid where ppr_belong_name = '会员卡' and  ppr_belong_memo = '" + user.getEmpNo() + "' and ppr_valid = 'Y' and ppr_edate >= convert(char(10),getdate(),	112)";
	}
	else
	{
		sql = "select count(*) from pos.promotion_prepaid where ppr_belong_name = '会员卡' and  ppr_belong_memo = '" + user.getEmpNo() + "' and ppr_valid = 'Y' and ppr_edate >= to_date(to_char(sysdate,'yyyy-mm-dd'),'yyyy-mm-dd')";
	}
	System.out.println("memCenter.jsp::优惠券张数SQL:"+sql);
	couponCount = service10.getJdbcTemplate().queryForInt(sql);
}
catch(Exception ex)
{}


				
%>
<!DOCTYPE html>
<html>

	<head>
		<meta charset="UTF-8">
		<title>首页</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes" />
		<meta name="apple-mobile-web-app-status-bar-style" content="black" />
		<!--数字拨号-->
		<meta content="telephone=no" name="format-detection" />

		<link rel="stylesheet" type="text/css" href="css/reset.css" />
		<link rel="stylesheet" type="text/css" href="css/common.css"/>
		<link rel="stylesheet" type="text/css" href="css/home.css" />
		<script src="js/jquery.1.7.2.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="js/buju.js" type="text/javascript" charset="utf-8"></script>

	</head>

	<body>
		<div class="wrap">
			<!--头部-->
			<header class="">
				<div class="hTitle box">
					<img src="img/h-b1.ahjf.jpg"/>
					<p class="fs32">九福药房零售连锁有限公司</p>
				</div>
				<div class="hName ">
					<a href="/portal/apps/b2c/weixin/memcenter/memCenterScan.jsp">
					<img src=<%=user.getPsnPhotoPath()%> style="width:70px;height: 70px;border-radius: 50%;" />
					<p class="name fs32"><%=user.getRealName()%></p>
					<p class="phone fs28"><%=logEnt.getMobileNo()%></p>
					</a>
				</div>
				<!--
				<div class="card box">
					<img src="img/h-b4.png"/>
						<a href="/portal/apps/b2c/weixin/memcenter/memCenterScan.jsp">
					<p class="fs28">卡号：<%=user.getEmpNo()%></p>
				</a>
				</div>
				-->
			</header>
			<!--中间-->
			<section>
				<!--查询各状态的订单数-->
				
				<div class="section1 box">
					<div class="ticket">
						<a href="/portal/apps/b2c/weixin/memcenter/ticketList.jsp?memCardId=<%=user.getEmpNo()%>">
						<p class="tNum fs32"><%=couponCount%></p>
						<p class="tText fs32">优惠券</p>
						</a>
					</div>
					<div class="ticket">
						<a href="">
						<p class="tNum fs32"><%=potCount%></p>
						<p class="tText fs32">积分</p>
						</a>
					</div>
				</div>
				<!--个性化
				
				<div class="section2 box">
					<img src="img/h-icon1.png"/>
					<img src="img/h-icon2.png"/>
					<img src="img/h-icon3.png"/>
				</div>
				
				<div class="section2 section3 box">
					<img src="img/h-icon4.png"/>
					<img src="img/h-icon5.png"/>
					<img src="img/h-icon6.png"/>
					<img src="img/h-icon7.png"/>
					<img src="img/h-icon8.png"/>
					<img src="img/h-icon9.png"/>
				</div>
				
			</section>
			-->
			

			<!--尾部-->
			<div class="footerline"></div>
			<footer class="box">
				<a href="/portal/apps/b2c/weixin/memcenter/memCenter.jsp">
					<div class="cp-home"><img src="img/cp-home2.png" /></div>
				</a>
				
				<!--
				<a href="#">
					<div class="cp-mine"><img src="img/cp-mmine3.png" /></div>
				</a>
				-->
			</footer>
			</div>
			
	</body>  
	<script language="javascript">

	</script>

</html>