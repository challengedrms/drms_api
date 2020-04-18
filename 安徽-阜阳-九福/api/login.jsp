<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.openjweb.alipay.sign.MD5"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="org.openjweb.core.service.*"%>
<%@ page import="org.openjweb.core.entity.*"%>
<%@ page import="org.openjweb.core.util.*"%>
<%@ page import="com.openjweb.weixin.entity.*"%>

<%@ page import="java.util.*"%>
<%@page import="org.directwebremoting.json.JsonUtil"%>

<%@page import="org.openjweb.core.util.*"%>
<%@page import="org.springframework.web.multipart.MultipartFile"%>
<%@page import="org.springframework.web.multipart.MultipartHttpServletRequest"%>
<%@page import="org.springframework.web.multipart.commons.CommonsMultipartResolver"%>
<%@page import="com.openjweb.cloud.redis.*"%>
<%@page import="com.openjweb.easemob.*"%>
<%@page import="java.io.*"%>

<%
	//因为传入密码，需要考虑使用https通道
	String act = request.getParameter("act");
	 
	String loginId = request.getParameter("loginId");
	String password = request.getParameter("password");
	 
	//act 参数  常量 
	final String validUser = "validUser";
	final String getValidCode = "getValidCode";
	final String regist = "regist";
	final String registCom = "registCom";
	final String login = "login";
	final String logout = "logout";
	final String getUserInfo = "getUserInfo";
	final String updateUserInfo = "updateUserInfo";
	String reMsg = "";
	
	//service
	IDBSupportService service = (IDBSupportService) ServiceLocator.getBean("IDBSupportService3");
	
	
	
	//检查用户账号正确性
	if (validUser.equals(act)) {
		reMsg = this.validUser(loginId, service);
	}
	else if (regist.equals(act))//个人注册
	{
		reMsg = this.regist(service, session, request);
	} 
	else if (registCom.equals(act))//企业注册
	{
		reMsg = this.registCom(service, session, request);
	}
	else if (login.equals(act))//登陆
	{
		reMsg = this.login(service, session, request);
	}
	else if (logout.equals(act))//注销 
	{
		reMsg = this.logout(service, session, request);
	} else if ("getNickName".equals(act)) {
		reMsg = this.getNickName("", "", request);
	}
    else if ("getValidCode".equals(act)) {
		reMsg = this.getValidCode(loginId, service, request);
	}
	else
    if ("registCom2".equals(act)) 
	{
		reMsg = reMsg = this.registCom2(service, session, request);
	}

	else
    if ("registWeixinCom".equals(act)) 
	{
		reMsg = reMsg = this.registWeixinCom(service, session, request);
	}

	else
    if ("getNickNameByMobile".equals(act)) //根据手机号查询昵称，手机号可以多个，中间以,隔开
	{
		reMsg = reMsg = this.getNickNameByMobile(service, session, request);
	} 

	else
    if ("bindMobile".equals(act)) //手机号与openID绑定
	{
		reMsg = reMsg = this.bindMobile(service, session, request);
	} 

	else
    if ("checkMemMobile".equals(act)) //手机号能否绑定
	{
		reMsg = reMsg = this.checkMemMobile(service, session, request);
	} 

	//else if ("logout".equals(act)) {
	//	reMsg = this.logout(loginId, request);
	//}
	System.out.println(reMsg);
	reMsg = reMsg.trim();
	//reMsg = reMsg.replace("此账号可用","");
	out.print(reMsg);

	//http://www.cnblogs.com/luxiaofeng54/archive/2011/03/14/1984026.html  xmpp协议
	//语音识别 讯飞
	//osforce
%>

<%!

    /*private String logout(String loginId, HttpServletRequest request) 
	{
		String errCode = "0";
		String errMsg = "注销成功!";
		String jsonData = "";
		//注销需要做身份认证，否则不安全
		String sign = request.getParameter("sign");
		String jsessionId = request.getParameter("jsessionId");
		if(sign==null)sign="";
		if(jsessionId==null)jsessionId="";
		//判断loginId sign和 jessionId的正确性
		try
		{
			RedisCacheUtil.del("jsession-"+loginId);
            RedisCacheUtil.del("jsession-"+jsessionId);
		}
		catch(Exception ex)
		{
			errCode ="-1";
			errMsg = "注销失败!";

		}
		Hashtable hst = new Hashtable();
		hst.put("errCode",errCode);
        hst.put("errMsg",errMsg);
		try
		{
			jsonData = JsonUtil.toJson(hst); 

		}
		catch(Exception ex)
		{
		}


	 
	}*/



    /**
	 * 检查用户账号正确性  
	 */
	private String validUser(String loginId, IDBSupportService service) {
		//System.out.println("validUser 1.................");
		String reMsg = "";
		JSONObject resultJson = new JSONObject();
		JSONObject dataJson = new JSONObject();
		String errCode="0";

		boolean isValid = false;
		String msg = "";
		String status = "";//success/exception", // 操作状态
		boolean isLogin = false; // 是否（登录/匿名） 
		//1.检查账号格式是否正确。。。。。。。。。。
		//if ("".equals(loginId)) {
		//	msg = "用户名不能为空";
		//} else {
		//	isValid = true;
		//}

         isValid =(RegExpUtil.isEmail(loginId)||RegExpUtil.isMobileNo(loginId));
		 if(!isValid)
		 {
			 errCode="-1";
			 msg = "用户账号必须是邮箱或手机!";
		 }
		 
		if (isValid) {
			//2.如果格式正确检查账号是否已经被注册
			int userCount = 0;
			try {
				System.out.println("select count(*) from CommUser where loginId='" + loginId + "' or userMobile='"+loginId+"' or userEmail='"+loginId+"'");
				userCount = Integer.parseInt(String.valueOf( service.findSingleValueByHql("select count(*) from CommUser where loginId='" + loginId + "' or userMobile='"+loginId+"' or userEmail='"+loginId+"' or username='"+loginId+"'")));
				 
			} catch (Exception e) {
				e.printStackTrace();
			}
			if (userCount == 0) {
				isValid = true;

				msg = "此账号可用";
			} else {
				isValid = false;
				errCode="-1";
				msg = "此账号已经被注册";
			}
		}
		 
		dataJson.accumulate("loginId", loginId).accumulate("isValid", String.valueOf(isValid)).accumulate("msg", msg);

		resultJson.accumulate("data", dataJson).accumulate("status", status).accumulate("login", isLogin).accumulate("errCode", errCode).accumulate("errMsg", msg);
		reMsg = resultJson.toString(1, 1);
		
		
		return reMsg;
	}

	/**
	 * 根据注册时填写的手机或邮箱获取验证码  
	 */
	private String getValidCode(String loginId, IDBSupportService service, HttpServletRequest request) 
	{
		 
		//生成验证码
		double rand = Math.random();
		int i = (int) (rand * 1000000);
		String validCode = "000000" + String.valueOf(i);
		 
		validCode = validCode.substring(validCode.length() - 6);// 验证码
		 
		//存入缓存中 --放入session中有个问题，如果客户端不是html客户端，例如app的模式，用httpclient难以确保在一个session会话里
		request.getSession().setAttribute("currentMobileValidateCode", validCode);
		 
		
		try
		{
			 
			RedisCacheUtil.setKeyValue("registValidCode-"+loginId,validCode,300);//在redis缓存中存储注册验证码
		   
		}
		catch(Exception ex)
		{}
		System.out.println("存放的验证码:");
		System.out.println(validCode);
		String msg ="";
		String errCode ="0";
        
		//向手机或邮箱发送验证码。 。。。。。。。。 
		if(loginId.indexOf("@")>-1)
		{
			 
			//邮件发送
			try
			{
				msg = "验证码已发送到邮箱！";
				MailUtil.sendMailValidCode(loginId,validCode);
				
			}
			catch(Exception ex)
			{
				msg="验证码发送失败!";
				errCode="-1";
				System.out.println("验证码邮件发送失败！");
			}
		}
		else
		
		{
			 
			if(loginId!=null&&loginId.trim().length()==11&&StringUtil.isInt(loginId))
			{
				msg = "验证码已发送到手机!";
				//System.out.println("是手机号......");
				//短信发送时验证码在方法内部生成
			    //SmsUtil.sendRechargePwdValidateCode(loginId,request);
				SmsUtil.sendValidateCode2(loginId,validCode,request);//这个方法可以从外部传入验证码
			}
			else
			{
				msg = "请填写注册账号（手机或邮箱）！";
				errCode="-1";
			}
		}
         
		//返回数据 
		String reMsg = "";
		JSONObject resultJson = new JSONObject();
		JSONObject dataJson = new JSONObject();

		String status = "";//success/exception", // 操作状态
		boolean isLogin = false; // 是否（登录/匿名） 
		dataJson.accumulate("loginId", loginId).accumulate("validCode", validCode);

		resultJson.accumulate("data", dataJson).accumulate("status", status).accumulate("login", isLogin).accumulate("msg", msg).accumulate("errCode", "0").accumulate("errMsg", msg);
		reMsg = resultJson.toString(1, 1);
		return reMsg;
	}

	/**
	 * 个人注册   
	 */
	private String regist(IDBSupportService service, HttpSession session, HttpServletRequest request) {
		System.out.println("个人注册开始。。。。。。。。。。。。。");
		//SecurityUtil 生成jsessionid 
		//CatchUtil 得到ip 时间戳，priKey等返回 
		String reMsg = "";

		String errCode = "0";//0表示无错误
		String errMsg = "注册成功";//错误信息
		String isSuccess = "N";
		//String verifyCode = (String)SessionUtil.getAttribute("rand", request);
		String verifyCode = null;
		try
		{
			verifyCode = (String)SessionUtil.getAttribute("currentMobileValidateCode", request);
		}
		catch(Exception ex)
		{
			//没有生成验证码
		}
		//System.out.println("验证码::::::");
		//System.out.println(verifyCode);
		//
		//String verifyCode = (String) request.getSession().getAttribute("rand")==null?(String)request.getAttribute("rand"):(String) request.getSession().getAttribute("rand");
		Hashtable<String, Object> table = new Hashtable<String, Object>();

		//解析客户端发送过来的用户信息 
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
	    /* 	
		Long isloginId = (Long)service.findSingleValueByHql("select count(*) from CommUser where loginId = '" +loginId+"'");
		if(isloginId >0){
			errCode = "11";
			errMsg = "用户帐号已经存在";
			isSuccess = "N";
		} 
		*/

		String password = request.getParameter("password") == null ? "" : request.getParameter("password");//登录密码
		String confirmPwd = request.getParameter("confirmPwd") == null ? "" : request.getParameter("confirmPwd");//确认密码
		String nickName = request.getParameter("nickName") == null ? "" : request.getParameter("nickName");//用户昵称
		String mobileOrEmail = request.getParameter("mobileOrEmail") == null ? "" : request.getParameter("mobileOrEmail");//用户邮箱
		String validCode = request.getParameter("validCode") == null ? "" : request.getParameter("validCode");//验证码
		String userType = request.getParameter("userType") == null ? "" : request.getParameter("userType");//用户类型 （预留，用于区分个人用户、商家、公司等）
		String inviteCode = request.getParameter("inviteCode")==null?"":request.getParameter("inviteCode");//邀请码
		String easemobToken = request.getParameter("easemobToken");//环信token,为了降低应用的耦合度，这里不直接获取环信token
    	String easemobOrgName = request.getParameter("easemobOrgName");//环信接口的orgName
	    String easemobAppName = request.getParameter("easemobAppName");//环信接口的应用名
		String md5Password = Password.MD5EncodePass(password);//口令加密处理 
		String deviceId = request.getParameter("deviceId");//设备号，仅针对app
		String homeName = request.getParameter("homeName")==null?"":request.getParameter("homeName");//用于区分是商城还是实体店首页
        String pageCode = request.getParameter("pageCode")==null?"":request.getParameter("pageCode");//页面编码
        String stCode = request.getParameter("stCode")==null?"":request.getParameter("stCode");//店铺编码


		//System.out.println(password+"-"+md5Password);
		//从缓存中获取 注册验证码与用户输入做比较 
		//System.out.println("验证码:"+verifyCode);
		//System.out.println("输入"+validCode);
		//判断用户账号格式是否正确
        if(!RegExpUtil.isEmail(loginId)&&!RegExpUtil.isMobileNo(loginId))
		{
			//System.out.println("-----------注册账号:");
			//System.out.println(loginId);

			//验证码错误返回
			errCode = "-1";
			errMsg = "用户账号必须为手机或邮箱！";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
			table.put("homeName", homeName);
			table.put("stCode", stCode);
			table.put("pageCode", pageCode);
			 
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex) 
			{
			
		    }
			 
		    return reMsg;

		}
	    
        String redisValidCode = "";
		
        String isSendValidCode = ServiceLocator.getSysConfigService().getStringValueByParmName("isSendRegistValidCode"); 

        if("Y".equals(isSendValidCode)) //注册时需要做手机验证码校验
		{
			try
		    {
			    redisValidCode =  RedisCacheUtil.getKeyValue("registValidCode-"+loginId);//获取redis中的验证码，这个和SessionUtil的有什么不同
				System.out.println("redisValidCode:"+redisValidCode);
                System.out.println("verifyCode:"+verifyCode);//
		    }
		    catch(Exception ex)
		    {
    			errCode = "-4";
	    		errMsg = "读取缓存失败！";
		    	isSuccess = "N";
	     	    table.put("errCode", errCode);
		        table.put("errMsg", errMsg);
		        table.put("isSuccess", isSuccess);
				table.put("homeName", homeName);
		    	table.put("stCode", stCode);
		    	table.put("pageCode", pageCode);
		        //put 验证信息 
		        try 
			    {
			        reMsg = JsonUtil.toJson(table);
		        } 
			    catch (Exception ex1) 
			    {
			    }
		        return reMsg;
    		}
	    	if (verifyCode==null||verifyCode.equals("")||verifyCode.equals("null")||!verifyCode.equalsIgnoreCase(validCode)) 
		    {
			    //验证码错误返回
			    errCode = "-3";
			    errMsg = "验证码不正确！";
			    isSuccess = "N";
	     	    table.put("errCode", errCode);
		        table.put("errMsg", errMsg);
		        table.put("isSuccess", isSuccess);
				table.put("homeName", homeName);
		    	table.put("stCode", stCode);
			    table.put("pageCode", pageCode);
		        //put 验证信息 
		        try 
			    {
			        reMsg = JsonUtil.toJson(table);
		        } 
			    catch (Exception ex) 
			    {
			    }
		        return reMsg;
		    } 
		}

		if (password==null||confirmPwd==null||!password.equals(confirmPwd)) 
		{
			//验证码错误返回
			errCode = "4";
			errMsg = "两次口令输入不一致";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
			table.put("homeName", homeName);
			table.put("stCode", stCode);
			table.put("pageCode", pageCode);
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex) 
			{
			
		    }
		    return reMsg;
		}

		
		//生成用户实例
		CommUser user = new CommUser();
		try {
			Long userId=service.getSerial();// 一个长整型的唯一主键
			String uuid = StringUtil.getUUID();
			//String userTel =uuid.substring(1, 20);//手机号字段规定长20
			user.setUserId(userId); // 一个长整型的唯一主键
			user.setRowId(uuid);// 生成一个32位的UUID字符串
			//user.setIsInUse("Y");//个人注册改为不启用后台登录
			user.setIsInUse("N");//个人注册改为不启用后台登录
			user.setIsPortalMember("Y");
			user.setLoginId(loginId);// 设置一个登陆帐号
			user.setPassword(md5Password);
			user.setNickName(nickName);
			user.setUserType(userType);
			if(inviteCode!=null&&inviteCode.trim().length()>0)
			{
				user.setFirstChannelCode(inviteCode);//此字段暂时用作邀请码,限十位以内的字符或数字
			}
			if(deviceId!=null&&deviceId.trim().length()>0)
			{
				user.setUsername(deviceId);//设备号
			}
			else
			{
			    user.setUsername(user.getLoginId());//这个必须是唯一的
			}
			user.setComId("C0001");//网站会员的单位为C0001
			//根据userType和mobileOrEmail 判断用户是以何种方式注册的 并设置相应的值
			if(loginId.matches("[\\w]+@[\\w]+.[\\w]+")){
				user.setUserMobile(uuid);//注册时，如果是邮箱注册，则把邮箱添加到邮箱里面
				user.setUserEmail(loginId);
				user.setIsEmailValid("Y");
			}else{
				user.setUserMobile(loginId);//注册时，如果是手机这添加手机号,到手机里面
				user.setRegistMobile(loginId);
				user.setUserEmail(String.valueOf(userId)+"@openjweb.com");//默认一个用户邮箱
				user.setIsMobileValid("Y");
			}
			user.setEmpNo(uuid);
			String sUpdateDt = StringUtil.getCurrentDateTime();
			user.setCreateDt(sUpdateDt);
			service.saveOrUpdate(user);
			
			// 将新的用户信息保存到数据库中
			//下面增加环信用户
			try
			{
				//环信口令更改
				if(easemobOrgName!=null&&easemobOrgName.trim().length()>0
						&&easemobAppName!=null&&easemobAppName.trim().length()>0)
					{
						String token = "";
						try
						{
							token = EasemobUtil.getAccessToken("https://a1.easemob.com/",easemobOrgName,easemobAppName) ;
						}
						catch(Exception ex11){}
					String easemobJson = EasemobUtil.registUser("https://a1.easemob.com/",easemobOrgName,easemobAppName,token,loginId,password,nickName);
					//System.out.println(easemobJson);//暂时不解析返回结果
				}
				else
				{
					System.out.println("不创建环信账号......");
				}
			}
			catch(Exception ex3)
			{
			}
			isSuccess = "Y";
		} catch (Exception e) {
			errCode = "1";
			errMsg = "注册失败,可能账号已被注册!";
			isSuccess = "N";
		}
		table.put("errCode", errCode);
		table.put("errMsg", errMsg);
		table.put("isSuccess", isSuccess);
		table.put("homeName", homeName);
		table.put("stCode", stCode);
		table.put("pageCode", pageCode);
		//put 验证信息 
		try {
			reMsg = JsonUtil.toJson(table);
		} catch (Exception ex) {
			
		}
		return reMsg;
	}

	//2015.4.20 基于微信商城
	private String registWeixinCom(IDBSupportService service, HttpSession session, HttpServletRequest request) 
	{
		String rowId = StringUtil.getUUID();
		String jsonData = "";//返回的json
		String errCode = "0";
		String errMsg = "注册成功!";
		String isSuccess = "N";
		String verifyCode = "";
		String picRand = "";//session中的图片验证码
		 
		

		Hashtable hst = new Hashtable();
 

		//下面获取注册参数
	   // System.out.println("获取注册参数!");
		String comName = request.getParameter("comName") == null ? "" : request.getParameter("comName"); 
		//System.out.println("单位名称::::::::::::::::");
		System.out.println(comName);
		String comAbbrName = request.getParameter("comAbbrName") == null ? "" : request.getParameter("comAbbrName");
		//System.out.println("单位简称:");
		//System.out.println(comAbbrName);
		String mobileNo = request.getParameter("contactMobile") ==null?"":request.getParameter("contactMobile");//手机号
		String contactName = request.getParameter("contactName") ==null?"":request.getParameter("contactName"); 
		String comType = request.getParameter("comType") ==null?"":request.getParameter("comType");//公司类型
		String mobileValidCode = request.getParameter("validCode")==null?"":request.getParameter("validCode");// 
		String picValidCode = request.getParameter("rand")==null?"":request.getParameter("rand");//图片验证码
		String openId = request.getParameter("openId")==null?"":request.getParameter("openId");
		String province = request.getParameter("province")==null?"":request.getParameter("province");
		String city = request.getParameter("city")==null?"":request.getParameter("city");
		String district = request.getParameter("district")==null?"":request.getParameter("district");
		String bankType = request.getParameter("bankType")==null?"":request.getParameter("bankType");
		String bankName = request.getParameter("bankName")==null?"":request.getParameter("bankName");
		String bankComName = request.getParameter("bankComName")==null?"":request.getParameter("bankComName");
		String bankAcctNo = request.getParameter("bankAcctNo")==null?"":request.getParameter("bankAcctNo");
		String postCode = request.getParameter("postNo")==null?"":request.getParameter("postNo");
        String comAddr = request.getParameter("comAddr")==null?"":request.getParameter("comAddr");
		String registCapital = request.getParameter("registCapital")==null?"":request.getParameter("registCapital");
        String comIntroduce = request.getParameter("comIntroduce")==null?"":request.getParameter("comIntroduce");
		String xpos = request.getParameter("xpos")==null?"":request.getParameter("xpos");
        String ypos = request.getParameter("ypos")==null?"":request.getParameter("ypos");
        
 
		
	   
		//校验图片验证码
		/*if(picRand==null||picValidCode==null||!picValidCode.equals(picRand))
		{
			errCode = "-3";
			errMsg ="图片验证码错误!";
			System.out.println(picRand);
            System.out.println(picValidCode);

			hst.put("errCode",errCode);
			hst.put("errMsg",errMsg);
			try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex1)
			{
			}
			return jsonData;

		}*/
		//校验手机验证码
		/*System.out.println("手机验证码:");
		System.out.println(verifyCode);
		if (verifyCode==null||verifyCode.equals("")||verifyCode.equals("null")||!verifyCode.equalsIgnoreCase(mobileValidCode)) 
		{
			//验证码错误返回
			errCode = "-4";
			errMsg = "手机验证码不正确！";
			 
	     	hst.put("errCode", errCode);
		    hst.put("errMsg", errMsg);
		    //put 验证信息 
		    try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex1)
			{
			}
			return jsonData;
		}*/
		//下面开始核对密码和确认密码，另外应该做密码强度校验
		 //检查口令
		 

		CommCompany comEnt = null;
		try
		{
			comEnt = (CommCompany)service.findSingleValueByHql("from CommCompany where registLoginId='"+openId+"'");
			comEnt.setComName(comName);
		    comEnt.setComAbbrName(comAbbrName);
		    comEnt.setRowId(rowId);
		    comEnt.setContactName(contactName);
		    comEnt.setContactMobile(mobileNo);
		    comEnt.setRegistLoginId(openId);
			comEnt.setProvinceId(province);
			comEnt.setCityId(city);
			comEnt.setCountyId(district);
			comEnt.setBankType(bankType);
			comEnt.setBankName(bankName);
			comEnt.setBankComName(bankComName);
			comEnt.setBankAcctNo(bankAcctNo);
			comEnt.setPostNo(postCode);
			comEnt.setComAddr(comAddr);
			comEnt.setComIntroduce(comIntroduce);
			comEnt.setComType(comType);
            comEnt.setContactInfo(contactName);
			try
			{
				comEnt.setComXpos(new Double(xpos));
				comEnt.setComYpos(new Double(ypos));
			}
			catch(Exception ex1)
			{
			}
			
			try
			{
				comEnt.setRegistCapital(new Long(registCapital));
			}
			catch(Exception ex2){}


		    service.saveOrUpdate(comEnt);
			hst.put("errCode","0");
		    hst.put("errMsg","修改成功!");      
		
		}
		catch(Exception ex)
		{
			hst.put("errCode","-1");
		    hst.put("errMsg","修改失败!");      
		}
        if(comEnt==null)
		{
			long tableSerial = 0;
			try
			{
				tableSerial = service.getJdbcTemplate().queryForLong("select table_serial from comm_table_def where table_name='comm_company'");
			    tableSerial++;
			    service.getJdbcTemplate().execute("update comm_table_def set table_serial=table_serial+1 where table_name='comm_company'");
			}
			catch(Exception ex)
			{
				hst.put("errCode","-1");
		        hst.put("errMsg","注册失败，获取公司序列号错误!");    
				try
		        {
			        jsonData = JsonUtil.toJson(hst);
		        }
		        catch(Exception ex1)
		        {
		        }
		        return jsonData;

			}
			String pkId = "0000000"+String.valueOf(tableSerial);
			pkId = "S"+pkId.substring(pkId.length()-6);
			comEnt = new CommCompany();
		    comEnt.setComName(comName);
		    comEnt.setComAbbrName(comAbbrName);
		    comEnt.setRowId(rowId);
		    comEnt.setContactName(contactName);
		    comEnt.setContactMobile(mobileNo);
		    comEnt.setRegistLoginId(openId);
			comEnt.setPkId(pkId);
			comEnt.setProvinceId(province);
			comEnt.setCityId(city);
			comEnt.setCountyId(district);
			comEnt.setBankType(bankType);
			comEnt.setBankName(bankName);
			comEnt.setBankComName(bankComName);
			comEnt.setBankAcctNo(bankAcctNo);
			comEnt.setPostNo(postCode);
			comEnt.setComAddr(comAddr);
			comEnt.setComIntroduce(comIntroduce);
			try
			{
				comEnt.setComXpos(new Double(xpos));
				comEnt.setComYpos(new Double(ypos));
			}
			catch(Exception ex)
			{
			}
			 
			try
			{
				comEnt.setRegistCapital(new Long(registCapital));
			}
			catch(Exception ex){}

		    
			try
			{
				 service.saveOrUpdate(comEnt);
			     hst.put("errCode","0");
		         hst.put("errMsg","注册成功!");      
			}
			catch(Exception ex)
			{
				 hst.put("errCode","-1");
		         hst.put("errMsg","注册失败!");      
			}
		}
         

        try
		{
			jsonData = JsonUtil.toJson(hst);
		}
		catch(Exception ex)
		{
		}
		return jsonData;
	}

    
	//新版
	private String registCom2(IDBSupportService service, HttpSession session, HttpServletRequest request) 
	{
		/*
		alter table comm_company add regist_login_id varchar2(40);
        alter table comm_company add regist_mobile_no varchar2(20);
		 alter table comm_company add regist_md5_pwd varchar2(80);

		*/
		System.out.println("新版本企业注册");
		String jsonData = "";//返回的json
		String errCode = "0";
		String errMsg = "注册成功!";
		String isSuccess = "N";
		String verifyCode = "";
		String picRand = "";//session中的图片验证码
		 
		

		Hashtable hst = new Hashtable();
        try
		{
			picRand = (String)session.getAttribute("rand");
			System.out.println("会话中的图片验证码:");
			System.out.println(picRand);
		}
		catch(Exception ex)
		{
			errCode ="-1";
			errMsg = "没有图片验证码!";
			hst.put("errCode",errCode);
			hst.put("errMsg",errMsg);      
            try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex1)
			{
			}
			return jsonData;
		}


		try
		{
			verifyCode = (String)SessionUtil.getAttribute("currentMobileValidateCode", request);
		}
		catch(Exception ex)
		{
			//没有生成验证码
			errCode = "-2";
			errMsg = "没有手机验证码!";
			hst.put("errCode",errCode);
			hst.put("errMsg",errMsg);
			try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex1)
			{
			}
			return jsonData;
			
		}
		//下面获取注册参数
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
		String password = request.getParameter("password") == null ? "" : request.getParameter("password");//登录密码
		String confirmPwd = request.getParameter("confirmPwd") == null ? "" : request.getParameter("confirmPwd");//确认密码
		String comName = request.getParameter("comName") == null ? "" : request.getParameter("comName");//用户昵称,对于企业注册，为公司名
		String mobileNo = request.getParameter("mobileNo") ==null?"":request.getParameter("mobileNo");//手机号
		String comType = request.getParameter("comType") ==null?"":request.getParameter("comType");//公司类型
		String mobileValidCode = request.getParameter("validCode")==null?"":request.getParameter("validCode");// 
		String picValidCode = request.getParameter("rand")==null?"":request.getParameter("rand");//图片验证码
	    System.out.println(loginId);
        System.out.println(password);
		System.out.println(confirmPwd);
		System.out.println(comName);
		System.out.println(mobileNo);
		System.out.println(comType);
		System.out.println(mobileValidCode);
		System.out.println(picValidCode);
		//校验图片验证码
		if(picRand==null||picValidCode==null||!picValidCode.equals(picRand))
		{
			errCode = "-3";
			errMsg ="图片验证码错误!";
			System.out.println(picRand);
            System.out.println(picValidCode);

			hst.put("errCode",errCode);
			hst.put("errMsg",errMsg);
			try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex)
			{
			}
			return jsonData;

		}
		//校验手机验证码
		System.out.println("手机验证码:");
		System.out.println(verifyCode);
		if (verifyCode==null||verifyCode.equals("")||verifyCode.equals("null")||!verifyCode.equalsIgnoreCase(mobileValidCode)) 
		{
			//验证码错误返回
			errCode = "-4";
			errMsg = "手机验证码不正确！";
			 
	     	hst.put("errCode", errCode);
		    hst.put("errMsg", errMsg);
		    //put 验证信息 
		    try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex)
			{
			}
			return jsonData;
		}
		//下面开始核对密码和确认密码，另外应该做密码强度校验
		 //检查口令
		if (password==null||confirmPwd==null||!password.equals(confirmPwd)) 
		{
			//验证码错误返回
			errCode = "-5";
			errMsg = "密码位空或两次口令输入不一致";
		 
	     	hst.put("errCode", errCode);
		    hst.put("errMsg", errMsg);
		    //put 验证信息 
		    try
			{
				jsonData = JsonUtil.toJson(hst);
			}
			catch(Exception ex)
			{
			}
			return jsonData;
		}

		String md5Password = Password.MD5EncodePass(password);//口令加密处理 

		HashMap map = new HashMap();
		map.put("loginId",loginId); //登录账号
		map.put("md5Password",md5Password);//md5口令
		map.put("comName",comName);//公司名
		map.put("comType",comType);//公司类型
		map.put("mobileNo",mobileNo);
    	ICommCompanyService comService = (ICommCompanyService)ServiceLocator.getBean("ICommCompanyService");
		try
		{
			comService.registCom2(map,request);
		}
		catch(Exception ex2)
		{
			//以后再区分不同的失败原因
			errCode ="-1";
			errMsg = "注册公司失败!";
			 
			ex2.printStackTrace();
		}
		hst.put("errCode",errCode);
		hst.put("errMsg",errMsg);      
        try
		{
			jsonData = JsonUtil.toJson(hst);
		}
		catch(Exception ex3)
		{
		}
		return jsonData;
	}

	/**
	 * 企业注册    comm_user  comm_company   ----旧版
	 */
	private String registCom(IDBSupportService service, HttpSession session, HttpServletRequest request) {
		System.out.println("企业注册开始。。。。。。。。。。。。。");
		//SecurityUtil 生成jsessionid 
		//CatchUtil 得到ip 时间戳，priKey等返回 
		String reMsg = "";

		String errCode = "0";//0表示无错误
		String errMsg = "注册成功";//错误信息
		String isSuccess = "N";
		String verifyCode = "";
		//String verifyCode = (String) request.getSession().getAttribute("rand");
		try
		{
			verifyCode = (String)SessionUtil.getAttribute("currentMobileValidateCode", request);
		}
		catch(Exception ex)
		{
			//没有生成验证码
		}

		Hashtable<String, Object> table = new Hashtable<String, Object>();

		//解析客户端发送过来的用户信息 
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
		String password = request.getParameter("password") == null ? "" : request.getParameter("password");//登录密码
		String confirmPwd = request.getParameter("confirmPwd") == null ? "" : request.getParameter("confirmPwd");//确认密码
		String nickName = request.getParameter("nickName") == null ? "" : request.getParameter("nickName");//用户昵称
		String mobileOrEmail = request.getParameter("mobileOrEmail") == null ? "" : request.getParameter("mobileOrEmail");//用户邮箱
		String validCode = request.getParameter("validCode") == null ? "" : request.getParameter("validCode");//验证码
		String userType = request.getParameter("userType") == null ? "" : request.getParameter("userType");//用户类型 （预留，用于区分个人用户、商家、公司等）
		String userEmail = request.getParameter("userEmail") == null ? "":request.getParameter("userEmail"); //联系人邮箱
		String deptId = request.getParameter("deptId") == null ? "":request.getParameter("deptId"); //联系人所属部门
		String contactName = request.getParameter("contactName") == null ? "":request.getParameter("contactName"); //联系人姓名
		String contactMobile = request.getParameter("contactMobile") == null ? "":request.getParameter("contactMobile"); //联系人手机
		String contactTel = request.getParameter("contactTel") == null ? "":request.getParameter("contactTel"); //联系人固定电话
		String comName = request.getParameter("comName") == null ? "":request.getParameter("comName"); //公司名称
		String comAddr = request.getParameter("comAddr") == null ? "":request.getParameter("comAddr"); //公司详细地址
		String comAddrName = request.getParameter("comAddrName") == null ? "":request.getParameter("comAddrName"); //公司地区
		String comTel = request.getParameter("comTel") == null ? "":request.getParameter("comTel"); //公司固定电话
		String orderMobiles = request.getParameter("orderMobiles") == null ? "":request.getParameter("orderMobiles"); //订单通知人手机
		
		String md5Password = Password.MD5EncodePass(password);//口令加密处理 
		//判断用户账号格式是否正确
        if(!RegExpUtil.isEmail(loginId)&&!RegExpUtil.isMobileNo(loginId))
		{
			//验证码错误返回
			errCode = "-1";
			errMsg = "用户账号必须为手机或邮箱！";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
			System.out.println("格式错误啊!");
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex2) 
			{
			
		    }
			 
		    return reMsg;

		}
        //检查验证码
		if (verifyCode==null||verifyCode.equals("")||verifyCode.equals("null")||!verifyCode.equalsIgnoreCase(validCode)) 
		{
			//验证码错误返回
			errCode = "3";
			errMsg = "验证码不正确！";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex3) 
			{
			
		    }
		    return reMsg;
		} 
        //检查口令
		if (password==null||confirmPwd==null||!password.equals(confirmPwd)) 
		{
			//验证码错误返回
			errCode = "4";
			errMsg = "两次口令输入不一致";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex4) 
			{
			
		    }
		    return reMsg;
		}
		//另外还要检查用户信息是否为空、公司名称是否为空
		if(loginId==null||loginId.trim().length()==0)
		{
			//填写用户校验信息
		}
		if(comName==null||comName.trim().length()==0)
		{
			//填写公司校验信息
		}

		System.out.println("提交用户信息");
		//下面放到事务中提交
		HashMap map = new HashMap();
		map.put("loginId",loginId); //登录账号
		map.put("md5Password",md5Password);
		map.put("nickName",nickName);
		map.put("userType",userType);
		map.put("deptId",deptId);
		map.put("userEmail",userEmail);
		map.put("contactName",contactName);
		map.put("contactMobile",contactMobile);
        map.put("contactTel",contactTel);
        map.put("comName",comName);
		map.put("comAddrName",comAddrName);
		map.put("comAddr",comAddr);
		map.put("comTel",comTel);
		map.put("orderMobiles",orderMobiles);
		ICommCompanyService comService = (ICommCompanyService)ServiceLocator.getBean("ICommCompanyService");
		
		try
		{
			comService.registCom(map,request);
			
		}
		catch(Exception ex5)
		{
			errCode ="-1";
			errMsg = "注册公司失败!";
			ex5.printStackTrace();
		}
		//errCode = hst1.get("errCode").toString();
		//errMsg = hst1.get("errMsg").toString();
		//需要将参数赋值到Map传入到业务逻辑中执行
		/*
		//生成用户实例
		CommUser user = new CommUser();
		CommCompany company = new CommCompany();
		try {
			Long userId=service.getSerial();// 一个长整型的唯一主键
			String comId = service.getSerial().toString();//单位编码
			String uuid = StringUtil.getUUID(); //service.getSerial().toString()
			String userTel = uuid; // uuid.substring(0, 20);//手机号字段规定长20
			user.setComId(comId); //company.pk-id = user.com-id
			user.setUserId(userId); // 一个长整型的唯一主键
			user.setRowId(uuid);// 生成一个32位的UUID字符串
			user.setIsInUse("Y");
			user.setLoginId(loginId);// 设置一个登陆帐号
			user.setPassword(md5Password);
			user.setNickName(nickName);
			user.setUserType(userType);//用户类型
			user.setDeptId(deptId);//所属部门
			user.setUsername(user.getLoginId());
			//根据userType和mobileOrEmail 判断用户是以何种方式注册的 并设置相应的值
			user.setUserEmail(userEmail); //联系人邮箱
			if(loginId.matches("[\\w]+@[\\w]+.[\\w]+"))
			{
				user.setUserEmail(userEmail);//注册时，如果是邮箱注册，则把邮箱添加到邮箱里面
				user.setUserMobile(uuid);
			}else
			{
				//手机

				user.setUserMobile(loginId);//注册时，如果是手机这添加手机号,到手机里面
			    user.setUserEmail(uuid);
				user.setRegistMobile(loginId);
			} 
			 
			user.setUserMobile(userTel);//注册时，如果是邮箱注册，则把邮箱添加到邮箱里面
			String sUpdateDt = StringUtil.getCurrentDateTime();
			user.setCreateDt(sUpdateDt);
			user.setIsPortalMember("Y");
			user.setEmpNo(uuid);//以后是否考虑将员工工号、邮箱、手机改为非唯一且可空
			//企业信息录入
			company.setContactName(contactName);//联系人名称
			company.setPkId(comId); //公司编码
			company.setCreateDt(StringUtil.getCurrentDateTime());//创建帐号时间
			company.setContactMobile(contactMobile);//联系人手机
			company.setContactTel(contactTel);//联系人固定电话
			company.setComName(comName);//公司名称
			company.setComAddr(comAddrName+comAddr);//公司地区
			company.setComTel(comTel);//公司电话
			company.setOrderMobiles(orderMobiles);//订单通知人手机
			
			company.setCreateDt(sUpdateDt);
			service.saveOrUpdate(user);// 将新的用户信息保存到数据库中
			service.saveOrUpdate(company);

			try
			{
				//企业用户也插入网站会员角色吗??
				System.out.println("开始插入企业网站会员角色....");
				CommUserRole roleEnt = new CommUserRole();
	            roleEnt.setCreateDt(StringUtil.getCurrentDateTime());
	            roleEnt.setSerialNo(service.getSerial() );
	            roleEnt.setRoleId(new Long(505715));
	            roleEnt.setUserId(userId);
            	service.saveOrUpdate(roleEnt);
			}
			catch(Exception ex6)
			{
				ex6.printStackTrace();
				System.out.println("开始插入网站会员角色异常....");
			}

			try
			{
				//对于企业要增加一个企业基本权限
				//企业用户也插入网站会员角色吗??
				//要增加一个权限，否则用户访问个人中心出错
				 
				CommComAuth comAuthEnt = new CommComAuth();
				comAuthEnt.setPkId(service.getSerial().toString());
				comAuthEnt.setRowId(StringUtil.getUUID());
				comAuthEnt.setAuthCode("AUTH_PCENTER_MYINFO");
	            comAuthEnt.setCreateDt(StringUtil.getCurrentDateTime());
				comAuthEnt.setIsValid("Y");
				comAuthEnt.setComId(comId);
            	service.saveOrUpdate(comAuthEnt);
			}
			catch(Exception ex7)
			{
				ex7.printStackTrace();
				System.out.println("开始插入网站会员角色异常....");
			}

			isSuccess = "Y";
		} catch (Exception ex) {
			errCode = "1";
			errMsg = "注册出错";
			isSuccess = "N";
		}*/
		table.put("errCode", errCode);
		table.put("errMsg", errMsg);
		table.put("isSuccess", isSuccess);
		//put 验证信息 
		try {
			reMsg = JsonUtil.toJson(table);
		} catch (Exception ex) {
			
		}
		return reMsg;
	}

	/**
	 * 登陆    
	 */
	private String login(IDBSupportService service, HttpSession session, HttpServletRequest request) //throws Exception
	{
		//http://www.wxgjc.com/portal/api/login.jsp?act=login&loginId=18600510596&loginType=weixinMobile&weixinServiceAccount=C0001-1&password=xxx 
		Hashtable hst = new Hashtable();
		String sJson = "";
		CommUser user = null;
		
		//http://localhost:8088/portal/api/login.jsp?act=login&loginId=admin&password=aljwbz
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
		//检测卖家端APP是否有数据流传入
		StringBuffer appJson = new StringBuffer();
		//检查卖家端APP流写入
       
		String line = null ;
		String appType ="";
		String sellerName = "";
		String appPwd = "";//app端传入的口令
		String password = request.getParameter("password") == null ? "" : request.getParameter("password");//登录密码
		String deviceToken = "";//APP的DeviceToken
		
        try 
		{
			////--ac002b1c-28a9-42a7-8e71-49bb0c4c7590Content-Disposition: form-data; name="mobileType"Content-Length: 7ANDROID--ac002b1c-28a9-42a7-8e71-49bb0c4c7590Content-Disposition: form-data; name="password"Content-Length: 8Hello321--ac002b1c-28a9-42a7-8e71-49bb0c4c7590Content-Disposition: form-data; name="deviceToken"Content-Length: 0--ac002b1c-28a9-42a7-8e71-49bb0c4c7590Content-Disposition: form-data; name="sellerName"Content-Length: 5admin--ac002b1c-28a9-42a7-8e71-49bb0c4c7590--
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null ) 
			{
				//System.out.println(line);
                appJson.append(line);
				if(line.indexOf("Content-Length")>-1)appJson.append(";;;");
            }
			
			System.out.println("卖家端APP传入:");
			System.out.println(appJson);
			if(appJson.indexOf("ANDROID--")>-1)
			{
			    appType = "ANDROID";//安卓版
			}
			String substr = appJson.substring(appJson.indexOf("name=\"password\"Content-Length:")+"name=\"password\"Content-Length:".length());
			String slen = substr.substring(0,substr.indexOf(";;;"));
			int len = Integer.parseInt(slen.trim());
			
			//System.out.println(len);
			appPwd = substr.substring(substr.indexOf(";;;")+3,substr.indexOf(";;;")+3+len);
			password = appPwd;
			System.out.println("口令"+appPwd);
			//用户名:
			substr = appJson.substring(appJson.indexOf("name=\"sellerName\"Content-Length:")+"name=\"sellerName\"Content-Length:".length());
			
			slen = substr.substring(0,substr.indexOf(";;;"));
			System.out.println(slen);
			len = Integer.parseInt(slen.trim());
			System.out.println("卖家子串："+substr);
			sellerName = substr.substring(substr.indexOf(";;;")+3,substr.indexOf(";;;")+3+len);
			System.out.println("APP 传入的卖家端 APP登录账号:");
			System.out.println(sellerName);
			System.out.println(loginId);
			loginId = sellerName;
			
			//deviceToken:
			try
			{
				//有时第一次没有或得到deviceToken
				substr = appJson.substring(appJson.indexOf("name=\"deviceToken\"Content-Length:")+"name=\"deviceToken\"Content-Length:".length());
			    slen =substr.substring(0,substr.indexOf(";;;"));
			    len = Integer.parseInt(slen.trim());
				System.out.println("deviceToken长度:");
				System.out.println(len);
			    deviceToken = substr.substring(substr.indexOf(";;;")+3,substr.indexOf(";;;")+3+len);
			    
			    System.out.println("APP 传入的deviceToken:");
			    System.out.println(deviceToken);

			}
			catch(Exception ex)
			{
			}
			 
        }
        catch (Exception e) 
		{
            //System.out.println( "Error reading JSON string: " + e.toString());
        }

		

		 
		//对于手机号不是登录账号的情况，根据手机号查询登录账号
		String loginType = request.getParameter("loginType")==null?"":request.getParameter("loginType");//
		String originLoginId = loginId;
		if("weixinMobile".equals(loginType))
		{
			String weixinServiceAccount = request.getParameter("weixinServiceAccount")==null?"":request.getParameter("weixinServiceAccount");
			//微信域名
			//因为有多公司域名的问题，所以根据手机查登录账号还要有对应的域名
			try
			{
				loginId = service.getJdbcTemplate().queryForObject("select login_id from weixin_scene_log where mobile_no='"+loginId+"' and ent_account_id='"+weixinServiceAccount+"'",String.class).toString();
			}
			catch(Exception ex)
			{
				System.out.println("取微信账号失败:"+ex.toString());
			}

		}
		else
		if(deviceToken!=null&&deviceToken.trim().length()>0)
		{
			//如果有deviceToken传入说明是APP调用，暂定为app卖家版，登录账号为手机号
			try
			{
				String domainName = CMSUtil.getDomainName(request);
				String tmpComId = service.getJdbcTemplate().queryForObject("select com_id from weixin_service_account where domain_name='"+domainName+"'",String.class).toString();
				loginId =  service.getJdbcTemplate().queryForObject("select login_id from weixin_scene_log where mobile_no='"+loginId+"' and com_id='"+tmpComId+"'",String.class).toString();
			}
			catch(Exception ex)
			{
				System.out.println("手机APP登录失败!!");
			}
		}
		/*System.out.println("loginID:::::::::::");
		System.out.println(loginId);
		Enumeration enu=request.getParameterNames();  
        while(enu.hasMoreElements()){  
            String paraName=(String)enu.nextElement();  
            System.out.println(paraName+": "+request.getParameter(paraName));  
        }*/
		if(loginId==null||loginId.trim().length()==0)
		{
			//没有传入登录账号
			hst.put("errCode", "-1");
			hst.put("errMsg", "没有此用户!");
		    //String sJson = "";
		    try 
			{
			    sJson = JsonUtil.toJson(hst);
			} 
			catch (Exception ex3) 
			{
			}
			if(appType!=null&&appType.trim().length()>0)
			{
				//错误测试地址：http://www.fm4321.com/seller/sellerApi/Api/loginCheck?sellerName=18813035210&password=12345&deviceToken=ANDROID&mobileType=0
				return "{\"result\":0,\"msg\":\"用户名/密码错误\"}";//卖家APP格式
			}
			return sJson;
		}

		System.out.println("开始登陆校验......");
		String jsessionId = "";
		
		 
		try 
		{
			//登录后构造内存凭证
			//临时增加一个用户校验，以后放到SecurityUtil
			//暂时先在这里增加用户校验，以后合并到SecurityUtil
			//String tmpLoginId = "";
			String nickName ="";
			try
			{
				//tmpLoginId = service.getJdbcTemplate().queryForObject("select login_id from comm_user where login_id='"+loginId+"'",String.class).toString();
				System.out.println("api/login.jsp:");
				String sql = "";
				if(deviceToken!=null&&deviceToken.trim().length()>0)
				{
					sql = "from CommUser where loginId='"+loginId+"'  ";
				}
				else
				{
					//sql = "from CommUser where loginId='"+loginId+"' and isInUse = 'Y' "; //暂时不增加isInUse='Y'的限制。
					sql = "from CommUser where loginId='"+loginId+"'  "; //
				}
				System.out.println(sql);
				
			    user = (CommUser)service.findSingleValueByHql(sql);
				//如果有deviceToken,则保存deviceToken
				if(deviceToken!=null&&deviceToken.trim().length()>0)
				{
					try
					{
                        user.setDeviceToken(deviceToken);
						user.setMobileType(appType);
						service.saveOrUpdate(user);
					}
					catch(Exception ex111)
					{
					}
				}
			}
			catch(Exception ex)
			{
				hst.put("errCode", "-1");
				hst.put("errMsg", "没有此用户!");
		    	//String sJson = "";
		    	try {
				    sJson = JsonUtil.toJson(hst);
			    } catch (Exception ex3) {
				//System.out.println("a.........");

			    }
			    return sJson;

			}
			System.out.println("api/login.jsp1...........................");
			jsessionId = SecurityUtil.login(loginId, password, "", "", "IDBSupportService3", request);//尝试登录。
			System.out.println("取出jsessionId:"+jsessionId);
			System.out.println("api/login.jsp2...........................");
			try
			{
				System.out.println("登陆后记录的jsession-"+loginId+":");
				String saveSession = (String)RedisCacheUtil.get("jsession-"+loginId);
				//把rowId返回方便用户聊天
				System.out.println(saveSession);
				System.out.println("-------------------");
			
			}
			catch(Exception ex)
			{
			}
		} catch (Exception ex2) {

			hst.put("errCode", "-2");
			hst.put("errMsg", "登录失败:"+ex2.toString());
			//String sJson = "";
			try {
				sJson = JsonUtil.toJson(hst);
			} catch (Exception ex3) {
				//System.out.println("a.........");
			}
			return sJson;
		}
		//System.out.println("登陆校验后，获取缓存中的登陆信息:jsession_" + jsessionId);
		String cacheValue = "";
		try 
		{
			//cacheValue = CacheUtil.getCache("jsession_" + jsessionId, "session", request);
			System.out.println("login时jsession为:");
			System.out.println(jsessionId);
		    cacheValue = RedisCacheUtil.get("jsession-"+jsessionId).toString();
		} catch (Exception ex3) {
			//System.out.println("获取缓存失败。。。。。");
			//return "";
			hst.put("errCode", "-3");
			hst.put("errMsg", "登录失败:"+ex3.toString());
			//String sJson = "";
			try {
				sJson = JsonUtil.toJson(hst);
			} catch (Exception ex) {
				//System.out.println("a.........");

			}
		}
		//System.out.println("缓存信息:");
		//System.out.println(cacheValue);

		//解析缓存内容
		if (cacheValue != null && cacheValue.trim().length() > 0) 
		{
			System.out.println("从redis中找到缓存::::::");
			System.out.println(cacheValue);
			String[] tmpArray = cacheValue.split("____");
			//String loginId = tmpArray[0];
			String priKey = tmpArray[1];
			System.out.println("priKey未解密:" + priKey);
			
			try
			{
			    priKey = org.openjweb.core.util.DesUtils.decode(priKey, jsessionId);
			//解密的priKey  ---这个可以吗，这个是否有有效期
			}
			catch(Exception ex111)
			{
			}
			System.out.println(priKey);
			//String ip = request.getRemoteAddr();//远程地址
			String ip = "";
			//路由应该获得真实地址
			try
			{
				ip = request.getHeader("X-Real-IP").toString();//需要启动nginx
			}
			catch(Exception ex)
			{
				ip = request.getRemoteAddr();//远程地址
			}
			System.out.println("IP:" + ip);
			hst.put("errCode", "0");
			hst.put("errMsg", "登录成功!");
			hst.put("ip", ip);
			hst.put("jsessionId", jsessionId);
			hst.put("loginId", loginId);
			hst.put("nickName", user.getNickName()==null?"":user.getNickName());
			hst.put("priKey", priKey);
			hst.put("domain",tmpArray[2]);//根站点域名
			hst.put("originLoginId",originLoginId);//原始登录口令
			//查询用户的角色
			String roleSql = "select a.comm_code from comm_roles a ,comm_user b,comm_user_role c where b.login_id='"+loginId
				+"'  and c.user_id=b.user_id  and a.role_id=c.role_id";
			String roleIds = "";
			try
			{
				List<Map<String,Object>> roleList = service.getJdbcTemplate().queryForList(roleSql);
				if(roleList!=null&&roleList.size()>0)
				{
					for(int ii=0;ii<roleList.size();ii++)
					{
						String tmpRole = "";
						Map curMap = roleList.get(ii);
						if("oracle".equals(service.getRdbmsType()))
						{
							tmpRole = curMap.get("COMM_CODE").toString();
						}
						else
						{
							tmpRole =  curMap.get("comm_code").toString();
						}
						roleIds +=  tmpRole+",";
					}
					if(roleIds.endsWith(","))roleIds = roleIds.substring(0,roleIds.length()-1);
				}
			}
			catch(Exception ex1111)
			{
				//System.out.println("xxxxxxxxxxxxx");
			}
			System.out.println(roleIds);
			String signMsg = user.getSignMsg()==null?"":user.getSignMsg();
			signMsg = signMsg.replace("'","");
            signMsg = signMsg.replace("\"","");
            hst.put("signMsg",signMsg);
			hst.put("inviteCode",user.getFirstChannelCode()==null?"":user.getFirstChannelCode());
			String photo = user.getPsnPhotoPath()==null?"":user.getPsnPhotoPath();
			hst.put("photo",photo);
			hst.put("roles",roleIds);//用户的角色列表，逗号分隔，返回前台用于菜单授权
			hst.put("comId",user.getComId()==null?"":user.getComId());
			
			
			//下面增加遗漏注册的环信用户
			String easemobOrgName = request.getParameter("easemobOrgName");
            String easemobAppName = request.getParameter("easemobAppName");
			try
			{
				//环信口令更改
				if(easemobOrgName!=null&&easemobOrgName.trim().length()>0
						&&easemobAppName!=null&&easemobAppName.trim().length()>0)
					{
						String token = "";
						try
						{
							token = EasemobUtil.getAccessToken("https://a1.easemob.com/",easemobOrgName,easemobAppName) ;
						}
						catch(Exception ex11){}
					String easemobJson = EasemobUtil.registUser("https://a1.easemob.com/",easemobOrgName,easemobAppName,token,
						loginId,password,user.getNickName()==null?loginId:user.getNickName());
					//System.out.println(easemobJson);//暂时不解析返回结果
				}
				else
				{
					//System.out.println("不创建环信账号......");
				}
			}
			catch(Exception ex33)
			{
			}

			//String rowId --返回rowId方便用户聊天


			String rowId = "";
			try
			{
				rowId = service.getJdbcTemplate().queryForObject("select row_id from comm_user where login_id='"+loginId+"'",String.class).toString();
			}
			catch(Exception ex)
			{}
			hst.put("rowId",rowId);
			//hst.put("expire",tmpArray[2]);//超时秒数
			//hst.put("timeStamp", tmpArray[2]);//登录时间 --暂时不要登录时间
			//String sJson = "";
			try 
			{
				sJson = JsonUtil.toJson(hst);
			} 
			catch (Exception ex) 
			{
			}
			if(appType!=null&&appType.trim().length()>0)
			{
				//登录成功，如果是APP 卖家版

				 return "{\"result\":1,\"msg\":\"成功登录\",\"data\":{\"storeState\":1,\"provinceId\":\"11\",\"areaInfo\":\"北京市市辖区顺义区\",\"gradeId\":\"3152cf6ea23d4990b0b8130ebef4c5fd\",\"cityId\":\"1101\",\"storeZy\":\"所有\",\"nameAuth\":0,\"praiseRate\":0.0,\"storeDesccredit\":5.0,\"storeKeywords\":\"衣品天成\",\"alipayAccountNumber\":\"admin\",\"storeLogo\":\"/upload/img/store/slide/1505125861303.jpg\",\"storeAuth\":0,\"storeClick\":134,\"token\":\"4CF5777D689C57C93096B95C1329CAAC\",\"description\":\"主营服饰类商品\",\"scId\":\"6b30f69e66484fdaa9b4026be7dcfaa5\",\"memberName\":\"admin\",\"bankAccountName\":\"张三\",\"storeRecommend\":0,\"storeName\":\"衣品天成\",\"storeTel\":\"65543456\",\"storeCollect\":4,\"storeSales\":153,\"storeAddress\":\"美惠大厦\",\"bankName\":\"建行\",\"storeLabel\":\"/upload/img/store/slide/1505125848842.png\",\"bankCode\":\"2142142141221\",\"storeZip\":\"111222\",\"storeCredit\":4,\"storeDescription\":\"衣品天成\",\"alipayName\":\"张三\",\"bankAccountNumber\":\"我的\",\"memberId\":\"5b8b78a07f034483819b0d3f1ceaabdc\",\"storeBanner\":\"/upload/img/store/slide/1489686251104.png\",\"storeId\":\"73947166753d454d8bc7c6e65a3c7267\",\"storeTheme\":\"style1\",\"storeCode\":\"/upload/img/storetwocode//upload/img/storetwocode/1489068163603.png\"}}";
				//return "{\"result\":0,\"msg\":\"用户名/密码错误\"}";//卖家APP格式
			}
			return sJson;

		} else {
			hst.put("errCode", "-4");
			hst.put("errMsg", "没有获取到登录信息!");
			//String sJson = "";
			try {
				sJson = JsonUtil.toJson(hst);
			} catch (Exception ex) {
				//System.out.println("a.........");
			}
			if(appType!=null&&appType.trim().length()>0)
			{
				return "{\"result\":0,\"msg\":\"用户名/密码错误\"}";//卖家APP格式
			}
			return sJson;
		}
	}

	/**
	 * 注销  --身份校验算法开发完以后再加身份识别
	 */
	private String logout(IDBSupportService service, HttpSession session, HttpServletRequest request) 
	{
		//http://localhost:8088/portal/api/login.jsp?act=logout&loginId=abao
		String errCode ="0";
		String errMsg = "注销成功!";

		//String reMsg = "";
		String jsonData ="";
		String sign = request.getParameter("sign");
		if(sign==null)sign="";

		JSONObject resultJson = new JSONObject(); //返回的json
		JSONObject dataJson = new JSONObject(); //data部分json    
		String isSuccess = "N";//是否成功 ，Y是 N否 
		String jsessionId_s = request.getRequestedSessionId(); //会话的 ID，类似公钥，可在url中传输。注销前一直保存 。
		String privateKey = StringUtil.getUUID();// 返回一个私钥，通过jsession和privateKey,时间戳等参数构造accessToken,在服务器端解密判定身份合法性。注销前一直保存
		long timeStamp = System.currentTimeMillis();//时间戳
		String ip = request.getRemoteAddr();//服务器端识别的本地IP，注销前一直保存。
		String accessToken_s = "";

		//解析客户端发送过来的用户信息 
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
		String jsessionId = request.getParameter("jsessionId") == null ? "" : request.getParameter("jsessionId");//sessionid
		String accessToken_c = request.getParameter("accessToken") == null ? "" : request.getParameter("accessToken");//登录密码

		try
		{
			RedisCacheUtil.del("jsession-"+loginId);
            RedisCacheUtil.del("jsession-"+jsessionId);
		}
		catch(Exception ex)
		{
			errCode ="-1";
			errMsg = "注销失败!";

		}


		session.invalidate();//这个是针对会话的，要清理，另外也要清理redis
		//旧版的注释掉
		/*isSuccess = "Y";
		dataJson.accumulate("isSuccess", isSuccess);

		String status = "";//success/exception", // 操作状态
		boolean isLogin = false;

		resultJson.accumulate("data", dataJson).accumulate("status", status).accumulate("login", isLogin);

		reMsg = resultJson.toString(1, 1);*/
		Hashtable hst = new Hashtable();
		hst.put("loginId",loginId);//退出人登录账号
		//是否也要查询退出人的32位ID
		hst.put("errCode",errCode);
        hst.put("errMsg",errMsg);
		try
		{
			jsonData = JsonUtil.toJson(hst); 

		}
		catch(Exception ex)
		{
		}


		return jsonData;
	}

	private String getNickName(String type, String jsessionId, HttpServletRequest request) {
		//暂时不处理cache模式
		CommUser user = SessionUtil.getCommUser(request);
		String loginId = "";
		String nickName = "";
		String sJson = "";
		String isPortalMember = "";
		if (user != null) {
			loginId = user.getLoginId();
			if (loginId == null)
				loginId = "";
			nickName = user.getNickName();
			if (nickName == null)
				nickName = "";
			isPortalMember = user.getIsPortalMember() == null ? "" : user.getIsPortalMember();
			if ("".equals(isPortalMember))
				isPortalMember = "N";

		}
		Hashtable hst = new Hashtable();
		hst.put("errCode", "0");
		hst.put("errMsg", "");
		hst.put("nickName", nickName);
		hst.put("loginId", loginId);
		hst.put("isPortalMember", isPortalMember);//

		try {
			sJson = JsonUtil.toJson(hst);
		} catch (Exception ex) {

		}
		return sJson;

	}
	
	 
		 
	private String getNickNameByMobile(IDBSupportService service, HttpSession session, HttpServletRequest request) 
	{
		//http://localhost:8088/portal/api/login.jsp?act=getNickNameByMobile&mobiles=admin,18600510596,abao
		//根据手机号查询昵称，手机号可以多个，中间以,隔开,此接口查的是将手机号作为登录账号
		Hashtable hst = new Hashtable();
		String mobiles = request.getParameter("mobiles");//手机号
		String jsonData = "";
		if(mobiles!=null&&mobiles.trim().length()>0)
		{
		}
		else
		{
			hst.put("errCode", "-1");
		    hst.put("errMsg", "没有传手机号");
		 	try 
			{
			    jsonData = JsonUtil.toJson(hst);
		    } 
			catch (Exception ex) 
			{
			}
		    return jsonData;
		}
		mobiles = mobiles.trim();
        String[] mobileArray = mobiles.split(",");//手机号码列表
		String[] names = new String[mobileArray.length];
		for(int i=0;i<names.length;i++)
		{
			try
			{
				String name = service.getJdbcTemplate().queryForObject("select nick_name from comm_user where login_id='"+mobileArray[i]+"'",String.class).toString();
			    names[i]=name;
			}
			catch(Exception ex)
			{
				names[i]="";
			}
		}
				
		hst.put("errCode", "0");
		hst.put("errMsg", "");
		hst.put("data",names); 
		try {
			jsonData = JsonUtil.toJson(hst);
		} catch (Exception ex) {

		}
		return jsonData;

	} 


	/**
	 * 个人注册   
	 */
	private String bindMobile(IDBSupportService service, HttpSession session, HttpServletRequest request) {
		 
		String reMsg = "";
		String errCode = "0";//0表示无错误
		String errMsg = "绑定成功";//错误信息
		String isSuccess = "N";
		String memCardId="00000000";
		int		iErpMpCount = 0;
		String erpMpId ="          ";
		
	    
		Hashtable<String, Object> table = new Hashtable<String, Object>();

		//解析客户端发送过来的用户信息 
		String loginId = request.getParameter("loginId") == null ? "" : request.getParameter("loginId");//登录账号
		String openId =  request.getParameter("openId") == null ? "" : request.getParameter("openId");//openId
        String name =  request.getParameter("name") == null ? "" : request.getParameter("name");	
        String sex =  request.getParameter("sex") == null ? "1" : request.getParameter("sex");	
        String birthday =  request.getParameter("birthday") == null ? "" : request.getParameter("birthday");	
 		String mobileOrEmail = request.getParameter("mobileOrEmail") == null ? "" : request.getParameter("mobileOrEmail");//用户邮箱
		String validCode = request.getParameter("validCode") == null ? "" : request.getParameter("validCode");//验证码
		String NeedValidCode =  request.getParameter("isSendRegistValidCode") == null ? "" : request.getParameter("isSendRegistValidCode");	

		String MemDistrict =  request.getParameter("MemDistrict") == null ? "" : request.getParameter("MemDistrict");	
        String MemSales =  request.getParameter("MemSales") == null ? "" : request.getParameter("MemSales");	
 	
        String locationX =  request.getParameter("locationX") == null ? "" : request.getParameter("locationX");	
        String locationY =  request.getParameter("locationY") == null ? "" : request.getParameter("locationY");	
        String branchId =  request.getParameter("branchId") == null ? "" : request.getParameter("branchId");	

		birthday = birthday.replace("/","-");
		
		//System.out.println("loginId:"+loginId);
		//System.out.println("openId:"+openId);
		//System.out.println("name:"+name);
		//System.out.println("sex:"+sex);
		//System.out.println("birthday:"+birthday);
		//System.out.println("mobileOrEmail:"+mobileOrEmail);
		//System.out.println("validCode:"+validCode);
		//System.out.println("NeedValidCode:"+NeedValidCode);
		
		//System.out.println("MemDistrict:"+MemDistrict);
		//System.out.println("MemSales:"+MemSales);
		System.out.println("login.jsp::locationX:"+locationX);
		System.out.println("login.jsp::locationY:"+locationY);
		System.out.println("login.jsp::branchId:"+branchId);
		
		
	    /* 	
		Long isloginId = (Long)service.findSingleValueByHql("select count(*) from CommUser where loginId = '" +loginId+"'");
		if(isloginId >0){
			errCode = "11";
			errMsg = "用户帐号已经存在";
			isSuccess = "N";
		} 
		*/

		//String password = request.getParameter("password") == null ? "" : request.getParameter("password");//登录密码
		//String confirmPwd = request.getParameter("confirmPwd") == null ? "" : request.getParameter("confirmPwd");//确认密码
		 
		String homeName = request.getParameter("homeName")==null?"":request.getParameter("homeName");//用于区分是商城还是实体店首页
        String pageCode = request.getParameter("pageCode")==null?"":request.getParameter("pageCode");//页面编码
        String stCode = request.getParameter("stCode")==null?"":request.getParameter("stCode");//店铺编码


		//判断用户账号格式是否正确
		 
       /* if(!RegExpUtil.isEmail(mobileOrEmail)&&!RegExpUtil.isMobileNo(mobileOrEmail))
		{
			//System.out.println("-----------注册账号:");
			//System.out.println(loginId);

			//验证码错误返回
			errCode = "-1";
			errMsg = "用户账号必须为手机或邮箱！";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
			table.put("homeName", homeName);
			 
			table.put("pageCode", pageCode);
			 
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex0101) 
			{
			
		    }
			 
		    return reMsg;

		}
		 System.out.println("bind3............");
		 */
	    
        if("Y".equals(NeedValidCode)) //注册时需要做手机验证码校验
		{
			//System.out.println("bind4............");
			//取当前手机号的验证码
			String verifyCode = null;
			try
			{
				verifyCode = (String)SessionUtil.getAttribute("currentMobileValidateCode", request);
			}
			catch(Exception ex0102)
			{
				errCode = "-4";
				errMsg = "读取缓存失败！";
				isSuccess = "N";
				table.put("errCode", errCode);
				table.put("errMsg", errMsg);
				table.put("isSuccess", isSuccess);
				table.put("homeName", homeName);
				 
				table.put("pageCode", pageCode);
				//put 验证信息 
				try 
				{
					reMsg = JsonUtil.toJson(table);
				} 
				catch (Exception ex010201) 
				{
				}
				return reMsg;
			}
			
	    	if (validCode==null||validCode.equals("")||validCode.equals("null")||!validCode.equalsIgnoreCase(verifyCode)) 
		    {
			    //验证码错误返回
			    errCode = "-3";
			    errMsg = "验证码不正确！";
			    isSuccess = "N";
	     	    table.put("errCode", errCode);
		        table.put("errMsg", errMsg);
		        table.put("isSuccess", isSuccess);
				table.put("homeName", homeName);
		    	 
			    table.put("pageCode", pageCode);
		        //put 验证信息 
		        try 
			    {
			        reMsg = JsonUtil.toJson(table);
		        } 
			    catch (Exception ex0103) 
			    {
			    }
		        return reMsg;
		    } 
		}

		System.out.println("login.jsp::保存会员数据到ERP-开始");

		//写入ERP数据库
		IDBSupportService service10 = (IDBSupportService) ServiceLocator.getBean("IDBSupportService10");
		
		//1.1.机构编码
		try
		{
			String sqlCountBranch = "select count(*) from pos.branch where br_id = '" + branchId + "'";
			System.out.println("login.jsp::取机构pos.branch存在情况:" + sqlCountBranch);
			iErpMpCount = service10.getJdbcTemplate().queryForInt(sqlCountBranch);	

			if (iErpMpCount == 0)
			{
				branchId	= "8888";
			}
		}
		catch (Exception ex0105)
		{
			ex0105.printStackTrace();
			errCode = "-1";
			errMsg = "取机构pos.branch存在情况-失败！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex010501) 
			{
			}
			return reMsg;
		}
		
		//1.2.再读取会员档案存在情况
		try
		{
			String sqlCountMp = "select count(*) from pos.mem_personal";
			sqlCountMp = sqlCountMp + "	WHERE mp_mobile_phone = '" + mobileOrEmail + "'";
			System.out.println("login.jsp::取ERP会员表mem_personal-会员存在情况:" + sqlCountMp);
			iErpMpCount = service10.getJdbcTemplate().queryForInt(sqlCountMp);			
		}
		catch (Exception ex0105)
		{
			ex0105.printStackTrace();
			errCode = "-1";
			errMsg = "取ERP会员表mem_personal-会员存在情况-失败！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex010501) 
			{
			}
			return reMsg;
		}
		
		//1.3.写入会员表
		String StrMpId="";
		
		try {
			if (iErpMpCount > 1)
			{
				//绑定卡号
				System.out.println("login.jsp::会员存在多条MP数据:" + iErpMpCount);
				StrMpId = service10.getJdbcTemplate().queryForObject("select max(mp_id) from pos.mem_personal where  mp_mobile_phone = '" + mobileOrEmail + "'",String.class).toString();
			}
			else 
			{
				if (iErpMpCount == 1)
				{
					System.out.println("login.jsp::会员存在一条MP数据:" + iErpMpCount);
					StrMpId = service10.getJdbcTemplate().queryForObject("select mp_id from pos.mem_personal where  mp_mobile_phone = '" + mobileOrEmail + "'",String.class).toString();
				}
				else 
				{
					StrMpId = mobileOrEmail;
					
					try
					{
						String sql = "";
						String StrMemClass = service10.getJdbcTemplate().queryForObject("select svs_item_name from pos.sys_var_set where svs_group_id ='会员管理' and svs_item_id = '发卡卡类'",String.class).toString();
						String StrMemDisType = service10.getJdbcTemplate().queryForObject("select svs_item_name from pos.sys_var_set where svs_group_id ='会员管理' and svs_item_id = '发卡折扣类型'",String.class).toString();

						//生成会员数据
						sql = "insert into pos.mem_personal";
						sql = sql + "(mp_id,mp_br_id,mp_name,mp_personal_id,mp_sex,";
						sql = sql + "mp_birth,mp_tel,mp_address,mp_zip,mp_origanization,";
						sql = sql + "mp_profession_id,mp_education_id,mp_region,mp_class,mp_discount_flag,";
						sql = sql + "mp_sum_amount,mp_update_user_id,mp_update_date,mp_table_status,mp_email_address,";
						sql = sql + "mp_mobile_phone,mp_office_tel,mp_bp_call,mp_other_tel,mp_http_address,";
						sql = sql + "mp_marriage,mp_medical_card,mp_family_num,mp_apply_date,mp_sale_id,";
						sql = sql + "mp_sum_pot,mp_org_type,mp_card_ref1,mp_card_ref2,mp_income_start,";
						sql = sql + "mp_income_end,mp_qq,mp_msn,mp_password,mp_access,";
						sql = sql + "mp_addr_province,mp_addr_city,mp_addr_zone,mp_mobile_graph,mp_total_pot,";
						sql = sql + "mp_back_money,mp_index) values (";
						sql = sql + "'" + mobileOrEmail + "','" + branchId + "','" + name + "',NULL,'" + sex + "',";
						sql = sql + "'" + birthday + "',NULL,'" + MemDistrict + "',NULL,'" + branchId + "',";
						sql = sql + "NULL,NULL,NULL,'" + StrMemClass + "','" + StrMemDisType + "',";
						sql = sql + "0,'000000',getdate(),'0',NULL,";
						sql = sql + "'" + mobileOrEmail + "',NULL,NULL,NULL,CONVERT(char(10),getdate(),111),";
						sql = sql + "NULL,NULL,'1',getdate(),'" + MemSales + "',";
						sql = sql + "0,NULL,NULL,NULL,NULL,";
						sql = sql + "NULL,NULL,NULL,NULL,'xcx',";
						sql = sql + "NULL,NULL,'" + MemDistrict + "',NULL,0,";
						sql = sql + "NULL,NULL)";

						
						System.out.println("login.jsp::写ERP会员主表(MP):" + sql);
						service10.getJdbcTemplate().execute(sql);			
					}
					catch (Exception ExInsertMp)
					{
						 
						ExInsertMp.printStackTrace();
						errCode = "-1";
						errMsg = "写ERP会员主表(MP)失败，请稍后重试!";
						isSuccess = "N";
						
						table.put("errCode", errCode);
						table.put("errMsg", errMsg);
						table.put("isSuccess", isSuccess);
						
						
						//put 验证信息 
						try 
						{
							reMsg = JsonUtil.toJson(table);
							//System.out.println(reMsg);
						} catch (Exception ExInsertMp2) 
						{
						}

						return reMsg;
					}
				}
			}
		}
		catch (Exception ExInsertMp3) 
				{
				}
		
		System.out.println("login.jsp::写ERP会员主表(MP)-完成!会员卡号：" + StrMpId);
		
		//2.再读取会员卡号
		try
		{
			String sqlCheckMc = "select count(*) from pos.mem_card where mc_id = '" + StrMpId + "'";
			System.out.println("login.jsp::取ERP会员卡清单(MC):" + sqlCheckMc);
			iErpMpCount = service10.getJdbcTemplate().queryForInt(sqlCheckMc);			
		}
		catch (Exception ExCountMc)
		{
			 
			ExCountMc.printStackTrace();
			errCode = "-1";
			errMsg = "取ERP会员卡清单(MC)失败！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			

			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ExCountMc2) 
			{
			}


			return reMsg;
		}
		
		System.out.println("login.jsp::会员存在MC数据:" + iErpMpCount);
		
		
		if (iErpMpCount < 1)
		{
			
			try
			{
				String sql = "";
				String StrMemClass = service10.getJdbcTemplate().queryForObject("select svs_item_name from pos.sys_var_set where svs_group_id ='会员管理' and svs_item_id = '发卡卡类'",String.class).toString();
				String StrMemDisType = service10.getJdbcTemplate().queryForObject("select svs_item_name from pos.sys_var_set where svs_group_id ='会员管理' and svs_item_id = '发卡折扣类型'",String.class).toString();

				//生成会员数据
				sql = "insert into pos.mem_card";
				sql = sql + "(mc_id,mc_mem_id,mc_class,mc_sum_amount,mc_last_purchase,";
				sql = sql + "mc_discount_rate,mc_money,mc_pa_money_rate,mc_fee,mc_end_date,";
				sql = sql + "mc_flag,mc_grant_user_id,mc_start_date,mc_table_status,mc_update_user_id,";
				sql = sql + "mc_update_date,mc_dm,mc_blacklist,mc_message,mc_extend,";
				sql = sql + "mc_grant_date,mc_pot,mc_calc_date,mc_pot_date,mc_first_purchase,";
				sql = sql + "mc_first_org,mc_first_bill,mc_first_saleman) values (";
				sql = sql + "'" + StrMpId + "','" + StrMpId + "','" + StrMemClass + "',0,NULL,";
				sql = sql + "0,0,0,0,'2099/12/31',";
				sql = sql + "'0','000000',getdate(),'0','000000',";
				sql = sql + "getdate(),'1','0','0','0',";
				sql = sql + "getdate(),0,NULL,NULL,NULL,";
				sql = sql + "NULL,NULL,NULL)";

				
				System.out.println("login.jsp::写ERP会员卡表(MC):" + sql);
				service10.getJdbcTemplate().execute(sql);			
			}
			catch (Exception ExInsertMC)
			{
				 
				ExInsertMC.printStackTrace();
				errCode = "-1";
				errMsg = "写ERP会员卡表(MC)失败，请稍后重试!";
				isSuccess = "N";
				
				table.put("errCode", errCode);
				table.put("errMsg", errMsg);
				table.put("isSuccess", isSuccess);

				//put 验证信息 
				try 
				{
					reMsg = JsonUtil.toJson(table);
					//System.out.println(reMsg);
				} catch (Exception ExInsertMC2) 
				{
				}

				return reMsg;
			}
		}
		
		
		//1.1.写入临时表,临时表上加触发器
		try
		{
			String sql = "";
			
			if (1 == 2)
			{
			sql = "insert into pos.mem_online_register (mor_cust_id,mor_login_id,mor_openid,mor_name,mor_birthday,mor_sex,mor_district,mor_sales_id,mor_mobile,mor_br_id,mor_longitude,mor_latitude)  values(";
			sql = sql + "'AHJF','" + loginId + "','" + openId + "','" + name + "',to_date('" + birthday + "','yyyy-mm-dd'),'" + sex + "',";
			sql = sql + "'" + MemDistrict + "','" + MemSales + "','" + mobileOrEmail + "','" + branchId + "',to_number('" + locationX + "'),to_number('" + locationY + "'))";
			}
			else
			{
			sql = "insert into pos.mem_online_register (mor_cust_id,mor_login_id,mor_openid,mor_name,mor_birthday,mor_sex,";
			sql = sql + "mor_district,mor_sales_id,mor_mobile,mor_br_id,mor_longitude,mor_latitude,mor_mem_id)  values(";
			sql = sql + "'AHJF','" + loginId + "','" + openId + "','" + name + "','" + birthday + "','" + sex + "',";
			sql = sql + "'" + MemDistrict + "','" + MemSales + "','" + mobileOrEmail + "','" + branchId + "',";
			sql = sql + "convert(numeric(18,14),'" + locationX + "'),convert(numeric(18,14),'" + locationY + "'),'" + StrMpId + "')";
			}
			
			
			System.out.println("login.jsp::写ERP中间表pos.mem_online_register:" + sql);
			service10.getJdbcTemplate().execute(sql);			
		}
		catch (Exception ex0104)
		{
			 
			ex0104.printStackTrace();
			errCode = "-1";
			errMsg = "生成会员表MOR失败，请稍后重试!";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);

			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex01042) 
			{
			}

			return reMsg;
		}
		
		System.out.println("login.jsp::写ERP中间表pos.mem_online_register-完成");
		
	
		
		//2.再读取会员卡号
		memCardId = mobileOrEmail;
		
		try
		{
			String sqlCheckMp = "select count(*) from pos.mem_online_register where mor_cust_id = 'AHJF' and mor_login_id = '" + loginId + "' and mor_openid = '" + openId + "'";
			System.out.println("login.jsp::取ERP中间表:" + sqlCheckMp);
			iErpMpCount = service10.getJdbcTemplate().queryForInt(sqlCheckMp);			
		}
		catch (Exception ex0105)
		{
			 
			ex0105.printStackTrace();
			errCode = "-1";
			errMsg = "取ERP会员中间表生成状况失败！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex010501) 
			{
			}
			return reMsg;
		}
		
		if (iErpMpCount < 1)
		{
			errCode = "-1";
			errMsg = "生成ERP会员中间表mem_online_register失败！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex0106) 
			{
			}
			return reMsg;
		}
		else
		{
			try
			{
				String sqlGetMpId = "select mor_mem_id from pos.mem_online_register where mor_cust_id = 'AHJF' and mor_login_id = '" + loginId + "' and mor_openid = '" + openId + "'";
				System.out.println("login.jsp::取ERP中间表的会员卡号:" + sqlGetMpId);
				erpMpId = service10.getJdbcTemplate().queryForObject(sqlGetMpId,String.class).toString();
			}
			catch (Exception ex0107)
			{
				 
				ex0107.printStackTrace();
				errCode = "-1";
				errMsg = "取手机对应会员档的会员卡号失败！";
				isSuccess = "N";
				
				
				table.put("errCode", errCode);
				table.put("errMsg", errMsg);
				table.put("isSuccess", isSuccess);
				
				
				
				//put 验证信息 
				try 
				{
					reMsg = JsonUtil.toJson(table);
					//System.out.println(reMsg);
				} catch (Exception ex010701) 
				{
				}
				return reMsg;
			}
			memCardId = erpMpId;
		}

		System.out.println("login.jsp::memCardId:" + memCardId);








		
		//1.1.写入临时表,临时表上加触发器
		try
		{
			String sql = "";
			
			//插入储值卡明细表
			sql = "INSERT INTO pos.promotion_prepaid ";
			sql = sql + "(ppr_type,ppr_id,ppr_belong_org,ppr_password,ppr_question,";  
			sql = sql + "ppr_answer,ppr_belong_name,ppr_belong_memo,ppr_sdate,ppr_edate,";
			sql = sql + "ppr_remain_amt,ppr_valid,ppr_error_times,ppr_input_user,ppr_input_date,";
			sql = sql + "ppr_valid_user,ppr_valid_date,ppr_id_real,ppr_attr_class,ppr_attr_id,";
			sql = sql + "ppr_generate_id,ppr_use_memo) ";
			sql = sql + "select ";
			sql = sql + "vbi_id,vbi_id|| convert(char(8),getdate(),112)||substring(convert(char(8),getdate(),108),1,2)||substring(convert(char(8),getdate(),108),4,2)||substring(convert(char(8),getdate(),108),7,2)||substring(vbi_serial,1,4),";
			sql = sql + "'" + branchId + "','','',";
			sql = sql + "'','会员卡','" + StrMpId + "',dateadd(day,	vbi_sday	,convert(datetime,convert(char(10),getdate(),	112),112)) ,dateadd(day,	vbi_eday	,convert(datetime,convert(char(10),getdate(),	112),112)),";
			sql = sql + "vbi_amt, 'Y',0,'000000',getdate(),";
			sql = sql + "NULL,NULL,vbi_id|| convert(char(8),getdate(),112)||substring(convert(char(8),getdate(),108),1,2)||substring(convert(char(8),getdate(),108),4,2)||substring(convert(char(8),getdate(),108),7,2)||substring(vbi_serial,1,4),'不管','',";
			sql = sql + "vbi_serial,vbi_memo ";
			sql = sql + "from pos.voucher_basic_info,pos.branch ";
			
			////方案1、按上级机构分
			//sql = sql + "where vbi_area = br_prior and br_id = '0001' ";
			////方案2、按机构商圈分
			sql = sql + "where vbi_area = br_area_code and br_id = '" + branchId + "' ";
			sql = sql + "order by	vbi_serial";
			
			
			System.out.println("login.jsp::写ERP储值表pos.promotion_prepaid:" + sql);
			service10.getJdbcTemplate().execute(sql);			
		}
		catch (Exception ex0104)
		{
			 
			ex0104.printStackTrace();
			errCode = "-1";
			errMsg = "写ERP储值表pos.promotion_prepaid失败，请稍后重试!";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);

			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex01042) 
			{
			}

			return reMsg;
		}
		
		System.out.println("login.jsp::写ERP储值表pos.promotion_prepaid-完成");
		
	

		
		
		
		
	
		//生成用户实例
		WeixinSceneLog logEnt = null;
		CommUser user = null;
		try
		{
			System.out.println("login.jsp::保存会员数据到平台-开始");
			user = (CommUser)service.findSingleValueByHql("from CommUser where loginId = '"+loginId+"'");
			user.setBirthDay(birthday);
			user.setUserSex(sex);
			user.setRealName(name);
			user.setEmpNo(memCardId);		
			
			logEnt = (WeixinSceneLog)service.findSingleValueByHql("from WeixinSceneLog where toUser = '"+openId+"'");
			logEnt.setMobileNo(mobileOrEmail);
			logEnt.setRealName(name);
			logEnt.setIsValidMobile("Y");
			logEnt.setP7OpenId(MemDistrict);
			logEnt.setP8OpenId(MemSales);
			service.saveOrUpdate(logEnt);
			service.saveOrUpdate(user);
			isSuccess ="Y";
			 
		}
		catch(Exception ex0108)
		{
			 
			ex0108.printStackTrace();
			errCode = "-4";
			errMsg = "database error！";
			isSuccess = "N";
	     	table.put("errCode", errCode);
		    table.put("errMsg", errMsg);
		    table.put("isSuccess", isSuccess);
			table.put("homeName", homeName);
		   
			table.put("pageCode", pageCode);
		    //put 验证信息 
		    try 
			{
			    reMsg = JsonUtil.toJson(table);
		    } 
			catch (Exception ex010801) 
			{
			}
		    return reMsg;
		}
		 
		System.out.println("login.jsp::保存会员数据到平台-完成");
		 
		table.put("errCode", errCode);
		table.put("errMsg", errMsg);
		table.put("isSuccess", isSuccess);
		table.put("homeName", homeName);
		 
		table.put("pageCode", pageCode);
		
		//put 验证信息 
		try {
			reMsg = JsonUtil.toJson(table);
			System.out.println(reMsg);
		} catch (Exception ex0109) {
			
		}
		return reMsg;
	}

	/**
	 * 手机能否注册   
	 */
	private String checkMemMobile(IDBSupportService service, HttpSession session, HttpServletRequest request) {
		 
		String reMsg = "";
		String errCode = "-1";//0表示无错误 1-重复
		String errMsg = "不可以注册";//错误信息
		String isSuccess = "N";
		Long	MemCount = new Long(0);
		Long	MemRegCount = new Long(0);
		
	    
		Hashtable<String, Object> table = new Hashtable<String, Object>();

		//解析客户端发送过来的用户信息 
 		String mobileOrEmail = request.getParameter("mobileOrEmail") == null ? "" : request.getParameter("mobileOrEmail");//用户邮箱
		System.out.println("login.jsp::checkMemMobile::mobileOrEmail:"+mobileOrEmail);
		
		try
		{
			MemRegCount = service.getJdbcTemplate().queryForLong("select count(*) from weixin_scene_log where mobile_no = '" + mobileOrEmail + "'");
			System.out.println("login.jsp::checkMemMobile::MemRegCount(检查OJW平台是否注册过):" + MemRegCount);
		}
		catch (Exception ex)
		{
			 
			ex.printStackTrace();
			errCode = "-2";
			errMsg = "检查手机是否注册过时发生异常！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex1) 
			{
			}
			return reMsg;
		}
		
		
		if (MemRegCount > 0)
		{
			errCode = "2";
			errMsg = "手机号[" + mobileOrEmail + "]已注册过，请更换手机号码后再试";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex1) 
			{
			}
			return reMsg;
		}
		
		IDBSupportService service10 = (IDBSupportService) ServiceLocator.getBean("IDBSupportService10");
		
		try
		{
			MemCount = service10.getJdbcTemplate().queryForLong("select count(*) from pos.mem_personal where mp_mobile_phone = '" + mobileOrEmail + "'");
			System.out.println("login.jsp::checkMemMobile::MemCount:" + MemCount);
		}
		catch (Exception ex)
		{
			 
			ex.printStackTrace();
			errCode = "-1";
			errMsg = "检查手机是否注册过时异常！";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex1) 
			{
			}
			return reMsg;
		}

		if (MemCount >1)
		{
			errCode = "1";
			errMsg = "手机号[" + mobileOrEmail + "]已办过[" + MemCount.toString() + "]张会员卡，无需重复办卡";
			isSuccess = "N";
			
			table.put("errCode", errCode);
			table.put("errMsg", errMsg);
			table.put("isSuccess", isSuccess);
			
			
			//put 验证信息 
			try 
			{
				reMsg = JsonUtil.toJson(table);
				//System.out.println(reMsg);
			} catch (Exception ex1) 
			{
			}
			return reMsg;
		}
		
		errCode = "0";
		errMsg = "检查手机是否注册-通过！";
		isSuccess = "Y";

		table.put("errCode", errCode);
		table.put("errMsg", errMsg);
		table.put("isSuccess", isSuccess);
		
		
		//put 验证信息 
		try 
		{
			reMsg = JsonUtil.toJson(table);
			//System.out.println(reMsg);
		} catch (Exception ex) 
		{
		}
		return reMsg;
	}

	
	
	%>
