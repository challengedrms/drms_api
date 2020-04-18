<%@ page contentType="text/html;charset=UTF-8" import="org.directwebremoting.json.JsonUtil,com.openjweb.b2c.entity.*,com.openjweb.alipay.sign.MD5,net.sf.json.*,org.openjweb.core.service.*,org.openjweb.core.entity.*,org.openjweb.core.util.*,org.openjweb.core.eai.util.*,java.util.*,javax.naming.*,javax.sql.*,java.sql.*,java.text.*,java.io.*,org.springframework.web.multipart.MultipartFile,org.springframework.web.multipart.MultipartHttpServletRequest,org.springframework.web.multipart.commons.CommonsMultipartResolver"%><%
	
	String act = request.getParameter("act");     //作业类型编号
	String brId = request.getParameter("brid"); //机构号
	String authCode = request.getParameter("authcode"); //安全秘钥
	String applyTime = request.getParameter("applytime"); //任务请求时间
	String signCode = request.getParameter("signcode"); //标识码
	String appVersion = request.getParameter("appversion"); //程序版本号
	String param = request.getParameter("param"); //获取传入的参数
	String reMsg = "";                            //向客户端返回json字符串
	
 	 //LogUtil.info(" request.getContentType(): ","---------------"+request.getContentType(),true);
	 LogUtil.info(" -----act: ","---------------"+act,true);
	 LogUtil.info(" -----brId: ","---------------"+brId,true);
	 LogUtil.info(" -----param: ","---------------"+param,true); 
	
	//check store time
	if(!StringUtil.isEmpty(applyTime)&& !checkApplyTime(applyTime))
	{
		//return ;
	}
	long time = System.currentTimeMillis();
	LogUtil.info("WS Start - "+brId,"act=" + act + ";time=" + time +";param=" + param,true);

	

	//api_Mkt_PushMsgList - 3.8.1	获取推送信息
	if ("api_Mkt_PushMsgList".equals(act)) 
	{
		reMsg = this.api_Mkt_PushMsgList(param,brId);
	}
 	

	//api_Coupon_QueryCouponPageList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryCouponPageList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryCouponPageList(param,brId);
	}
 	

	//api_Coupon_QueryCouponUseList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryCouponUseList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryCouponUseList(param,brId);
	}
 	


	//api_Coupon_QueryRedPacketsPageList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryRedPacketsPageList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryRedPacketsPageList(param,brId);
	}
 	

	//api_Customer_QueryCustomerPoint - 3.2.6	会员查询积分
	if ("api_Customer_QueryCustomerPoint".equals(act)) 
	{
		reMsg = this.api_Customer_QueryCustomerPoint(param,brId);
	}
 

	//api_Customer_QueryCustomerPointDetails - 3.2.7	查询积分明细
	if ("api_Customer_QueryCustomerPointDetails".equals(act)) 
	{
		reMsg = this.api_Customer_QueryCustomerPointDetails(param,brId);
	}
 
	//api_com_QueryShopList - 3.2.16	门店查询
	if ("api_com_QueryShopList".equals(act)) 
	{
		reMsg = this.api_com_QueryShopList(param,brId);
	}
 
	//api_Customer_ImBand - 3.2.16	绑定IM
	if ("api_Customer_ImBand".equals(act)) 
	{
		reMsg = this.api_Customer_ImBand(param,brId);
	}
 
	//api_Order_QueryOrder - 3.2.16	查询订单
	if ("api_Order_QueryOrder".equals(act)) 
	{
		reMsg = this.api_Order_QueryOrder(param,brId);
	}
    
	//api_Order_QueryOrderItem - 3.2.16	查询订单
	if ("api_Order_QueryOrderItem".equals(act)) 
	{
		reMsg = this.api_Order_QueryOrderItem(param,brId);
	}
    
	
	//uf_task_upload_01_0001 - 同步数据库端时间
	if ("01-0001".equals(act)) 
	{
		reMsg = this.getDataBaseTime();
	}
    
    //uf_task_upload_01_0003 - 申报前台的策略
    if("01-0003".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.updateBranchVersion(param,brId);
    }
    
    //uf_task_upload_73_0001 -取网络支付
    if("73-0001".equals(act)&&!StringUtil.isEmpty(brId))
    {
    	reMsg = this.getMobilePayAccount(brId);
    }
    
    //uf_task_upload_86_0002 -取后台的增量下发数据-形成“增量”字符串
    if("86-0002".equals(act)&&!StringUtil.isEmpty(brId))
    {
    	int br_row = 50;
    	reMsg = this.getTransferData(brId,br_row);
    }
    
    //uf_task_upload_86_1001 -取后台的增量下发数据-单个商品档案下载
    if("86-1001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getProduct(param,brId);	
    }
    
    //uf_task_upload_86_1002 -取后台的增量下发数据-调价单下载
    if("86-1002".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPrice(param,brId);
    }  
    
    //uf_task_upload_86_2001 -取后台2015版促销类型
    if("86-2001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionType(param,brId);
    }
  
	//api_Mkt_QueryPmList - 3.8.4	按时段查询促销活动[2012版]清单
	if ("api_Mkt_QueryPmList".equals(act)) 
	{
		reMsg = this.api_Mkt_QueryPmList(param,brId);
	}
   
    //uf_task_upload_86_1003 -取后台2012版促销单据
    if("86-1003".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionPlan2012(param,brId);
    }
    
    //uf_task_upload_86_2002 -取后台2015版促销单据
    if("86-2002".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionPlan(param,brId);
    }
    
    //uf_task_upload_87_0001 -查看后台销售数据记录条数
    if("87-0001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getSalesRecordByStore(param,brId);
    }

    //uf_task_upload_87_0009 -Upload PIV/PSL/PS/PIVE1/PSLE1
    if("87-0009".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.uploadSalesDataByStore(param, brId);
    }
    
    //uf_task_upload_89_0001 -接收门店上传数据包文件
    if("89-0001".equals(act) || (StringUtil.isEmpty(act) && StringUtil.isEmpty(brId)))
    {
    	//todo....
    	reMsg = this.uploadFileByStore(request);
    }
    
    //uf_task_upload_89_0003 -程序升级
    if("89-0003".equals(act)&&!StringUtil.isEmpty(brId))
    {
   		
   		reMsg = this.getUpgradeFile(brId,request);
    }
	
    if("YCT-SP".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.insertYctsShGoods(param, brId);
    }
    
    
    LogUtil.info("WS End - "+brId,"act=" + act + ";time=" + time +";reMsg="+reMsg,true);
    
	out.print(StringUtil.decodeUnicode(reMsg));
	
%><%!
	
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
	
   	//87-0009.Upload Sales Data By Store.
	private String uploadSalesDataByStore(String param,String brId) throws Exception
	{
		String erCode = "0",erMsg = "Query Data Success.";
		Hashtable hst = new Hashtable();
		try
		{
		    Connection conn = this.getConnection();
		    JSONArray dataPiv= getArray(param,"dataPiv");
		    JSONArray dataPsl= getArray(param,"dataPsl");
		    if((dataPiv == null || dataPiv.size() == 0) && (dataPsl == null || dataPsl.size() == 0))
		    {
		    	return this.getJson(hst,erCode,erMsg);
		    }
			List<Object> dPiv = insertDataPiv(conn,dataPiv);
			boolean sa = Boolean.parseBoolean(String.valueOf(dPiv.get(0)));
			boolean dPsl = insertDataPsl(conn,dataPsl);
			boolean dPs = insertDataPs(conn,getArray(param,"dataPs"));
			boolean dPivel = insertDataPive1(conn,getArray(param,"dataPive1"));
			boolean dPslel = insertDataPsle1(conn,getArray(param,"dataPsle1"));
			if(sa && dPs && dPivel && dPivel && dPslel)
			{
				transCommit(conn);
				//After upload sales data,insert p_inv_process table.
				String billNo = String.valueOf(dPiv.get(1));
				java.sql.Date date = java.sql.Date.valueOf(String.valueOf(dPiv.get(2)));
				insertInvProcess(brId,billNo,date);
			}
			else
			{
				closeConn(conn);
	   	        erCode = "-1";
	   	        erMsg  = "Update Sales Data Failed.";
			}
		}
		catch(Exception ex)
		{
			erCode = "-1";
   	        erMsg  = "Update Sales Data Failed.";
			this.recordExcInfo("uploadSalesDataByStore",WsConstant.WS_SAVE_DATA,ex.toString());
			LogUtil.info("Function uploadSalesDataByStore: ",WsConstant.WS_SAVE_DATA + ex.toString(),true);
		}

		return this.getJson(hst,erCode,erMsg);
	}
	
	private String insertYctsShGoods(String param,String brId) throws Exception
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql;

		JSONArray dataGoodsArray= getArray(param,"dataGoods");
		if((dataGoodsArray == null || dataGoodsArray.size() == 0))
		{
			return this.getJson(hst,erCode,erMsg);
		}
		
		JSONObject dataGoods  = JSONObject.fromObject(dataGoodsArray.get(0));
		
		String ls_exist,ls_pro_id;
		ls_exist=String.valueOf(dataGoods.get("action")); 
		ls_pro_id=String.valueOf(dataGoods.get("goodno")); 
		String sqlfind = "select count(*) as cc from sh_goods where GOOD_NO = ?"; 
		list = this.query(sqlfind,new Object[]{ls_pro_id});
		
		if(list != null && list.size() > 0)
		{
			int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
			if(isValue == 0)
			{
				try
				{
					Connection conn = this.getConnection();

					sql ="insert into sh_goods(CLS_ID,GOOD_NO,IS_RECOMMEND,IS_SALE_NOW,SHIP_TYPE,PAY_TYPES,SALE_POINT,SALE_CNT,BUY_CNT,IS_QY,VIEW_ORDER,NAME,PRICE,STOCK,RENDER_PRICE,GOOD_UNIT,GOOD_SPEC,LAST_MODIFY_DATE,CREATE_DATE) ";
					sql = sql + "values(3,?,0,0,2,'0',0,0,0,'Y','0',?,?,-999,?,?,?,?,?)";
					
					Object[] parms = new Object[8];
					parms[0]=dataGoods.get("goodno");   //VARCHAR2
					parms[1]=dataGoods.get("name");   //VARCHAR2
					parms[2]=dataGoods.get("price");   //NUMERIC(12,3)
					parms[3]=dataGoods.get("price");   //NUMERIC(12,3)
					parms[4]=dataGoods.get("goodunit");   //VARCHAR2
					parms[5]=dataGoods.get("goodspec");   //VARCHAR2
					parms[6]=parseToDate(dataGoods.get("lastmodifydate"));   //DATE
					parms[7]=parseToDate(dataGoods.get("createdate"));   //DATE
					
					boolean flag = this.executeUpdate(conn,sql,parms,false,dataGoods.toString());
					if(!flag)
					{
						erCode = "-3";
						erMsg  = "Update test_cz  Failed.";
						return this.getJson(hst,erCode,erMsg);
					}
					
					transCommit(conn);
					closeConn(conn);
					
					sql = "select ID from sh_goods where GOOD_NO = ? ";

					list = this.query(sql,new Object[]{ls_pro_id});
					hst.put("data", list);					
				}
				catch(Exception exshgoods)
				{
					erCode = "-1";
					erMsg  = "Update sh_goods Failed.";
					LogUtil.info("Function insertYctsShGoods: ",WsConstant.WS_SAVE_DATA + exshgoods.toString(),true);
				}
			}
			else
			{
				erCode = "-5";
				erMsg  = "数据已存在.";
			}
		}
		else
		{
			erCode = "-6";
			erMsg  = "查sh_goods表失败.";
		}
			

		
		return this.getJson(hst,erCode,erMsg);
	}
	
	
	//save p_inv for sales data.
	private List<Object> insertDataPiv(Connection conn,JSONArray json) throws Exception
	{
		List<Object> list = new ArrayList<Object>();
		JSONObject dataPiv  = JSONObject.fromObject(json.get(0));
		String sql ="insert into p_inv(piv_bill_no,piv_br_id,piv_date,piv_time,piv_emp,piv_zk_amt,piv_ys_amt,piv_rmb_zl,piv_rmb,piv_fe_flag,piv_fe_amt,"
				+"piv_fe_rmb,piv_dyq,piv_ykq,piv_dzhb_kh,piv_dzhb_emp,piv_dzhb,piv_yfk_no,piv_yfk,piv_zkk_no,piv_zkl,piv_zkk,piv_zp_no,piv_zp,piv_hyk_no,"
				+"piv_hyk_zkl,piv_hyk,piv_flag,piv_xs,piv_ms,piv_discount,piv_rl,piv_bzl) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		Object[] parms = new Object[33];
		parms[0]=dataPiv.get("piv_bill_no");   //VARCHAR2(6)
		parms[1]=dataPiv.get("piv_br_id");     //VARCHAR2(8)
		parms[2]=parseToDate(dataPiv.get("piv_date"));//DATE
		parms[3]=dataPiv.get("piv_time");      //VARCHAR2(8)
		parms[4]=dataPiv.get("piv_emp");       //VARCHAR2(6)
		parms[5]=dataPiv.get("piv_zk_amt");    //NUMBER(12,3)
		parms[6]=dataPiv.get("piv_ys_amt");    //NUMBER(12,3)
		parms[7]=dataPiv.get("piv_rmb_zl");    //NUMBER(12,3)
		parms[8]=dataPiv.get("piv_rmb");       //NUMBER(12,3)
		parms[9]=dataPiv.get("piv_fe_flag");   //VARCHAR2(3)
		parms[10]=dataPiv.get("piv_fe_amt");   //NUMBER(12,3)
		parms[11]=dataPiv.get("piv_fe_rmb");   //NUMBER(12,3)
		parms[12]=dataPiv.get("piv_dyq");      //NUMBER(12,3)
		parms[13]=dataPiv.get("piv_ykq");      //NUMBER(12,3)
		parms[14]=dataPiv.get("piv_dzhb_kh");  //VARCHAR2(20)
		parms[15]=dataPiv.get("piv_dzhb_emp"); //VARCHAR2(15)
		parms[16]=dataPiv.get("piv_dzhb");     //NUMBER(12,3)
		parms[17]=dataPiv.get("piv_yfk_no");   //VARCHAR2(15)
		parms[18]=dataPiv.get("piv_yfk");      //NUMBER(12,3)
		parms[19]=dataPiv.get("piv_zkk_no");   //VARCHAR2(15)
		parms[20]=dataPiv.get("piv_zkl");      //NUMBER(3,2)
		parms[21]=dataPiv.get("piv_zkk");     //NUMBER(12,3)
		parms[22]=dataPiv.get("piv_zp_no");    //VARCHAR2(20)
		parms[23]=dataPiv.get("piv_zp");       //NUMBER(12,3)
		parms[24]=dataPiv.get("piv_hyk_no");   //VARCHAR2(15)
		parms[25]=dataPiv.get("piv_hyk_zkl");  //NUMBER(3,2)
		parms[26]=dataPiv.get("piv_hyk");      //NUMBER(12,3)
		parms[27]=dataPiv.get("piv_flag");     //VARCHAR2(1)
		parms[28]=dataPiv.get("piv_xs");       //NUMBER(3)
		parms[29]=dataPiv.get("piv_ms");       //NUMBER(3)
		parms[30]=dataPiv.get("piv_discount"); //NUMBER(3,2)
		parms[31]=dataPiv.get("piv_rl");       //NUMBER(3,2)
		parms[32]=dataPiv.get("piv_bzl");      //NUMBER(12,3)
		
		boolean flag = this.executeUpdate(conn,sql,parms,false,dataPiv.toString());
		
		list.add(flag);     //Is succeed
		list.add(parms[0]); //Bill no
		list.add(parms[2]); //Sale date
		
		return list;
	}
	
	//save p_sale for sales data.
	private boolean insertDataPsl(Connection conn,JSONArray json)
	{
		boolean isSuccess = true;
		
		for(int i=0 ; i < json.size(); i++)
		{
			JSONObject dataPsl  = JSONObject.fromObject(json.get(i));
			String sql = "insert into p_sale(psl_bill_no,psl_br_id,psl_date,psl_serial,psl_pro_id,psl_qty,psl_prc2,psl_prc1,psl_flag,psl_amt,psl_zs, "
					+"psl_st_code,psl_batch_num) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[13];
			parms[0]=dataPsl.get("psl_bill_no");     //VARCHAR2(6)
			parms[1]=dataPsl.get("psl_br_id");       //VARCHAR2(8)
			parms[2]=parseToDate(dataPsl.get("psl_date"));//DATE
			parms[3]=dataPsl.get("psl_serial");      //NUMBER(4)
			parms[4]=dataPsl.get("psl_pro_id");      //VARCHAR2(13)
			parms[5]=dataPsl.get("psl_qty");         //NUMBER(12,3)
			parms[6]=dataPsl.get("psl_prc2");        //NUMBER(12,3)
			parms[7]=dataPsl.get("psl_prc1");        //NUMBER(12,3)
			parms[8]=dataPsl.get("psl_flag");        //VARCHAR2(1)
			parms[9]=dataPsl.get("psl_amt");         //NUMBER(16,3)
			parms[10]=dataPsl.get("psl_zs");         //NUMBER(3,2)
			parms[11]=dataPsl.get("psl_st_code");    //VARCHAR2(15)
			parms[12]=dataPsl.get("psl_batch_num");  //VARCHAR2(30)
			
			 if(!this.executeUpdate(conn,sql,parms,false,dataPsl.toString()))
			 {
				 isSuccess = false;
				 break;
			 }
		}
		return isSuccess;
	}
	
	//save package_sale for sales data.
	private boolean insertDataPs(Connection conn,JSONArray json)
	{
		boolean isSuccess = true;
		for(int i=0 ; i < json.size(); i++)
		{
			JSONObject dataPs  = JSONObject.fromObject(json.get(i));
			String sql = "insert into package_sale(ps_br_id,ps_date,ps_bill_no,ps_serial,ps_pro_id,ps_qty,ps_type,ps_sale_pro_id) "
					      +" values(?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[8];
			parms[0]=dataPs.get("ps_br_id");              //VARCHAR2(8)
			parms[1]=parseToDate(dataPs.get("ps_date"));  //DATE
			parms[2]=dataPs.get("ps_bill_no");            //VARCHAR2(6)
			parms[3]=dataPs.get("ps_serial");             //VARCHAR2(6)
			parms[4]=dataPs.get("ps_pro_id");             //VARCHAR2(13)
			parms[5]=dataPs.get("ps_qty");                //NUMBER(12,4)
			parms[6]=dataPs.get("ps_type");               //VARCHAR2(1)
			parms[7]=dataPs.get("ps_sale_pro_id");        //VARCHAR2(13)
			
			if(!this.executeUpdate(conn,sql,parms,false,dataPs.toString()))
			{
				isSuccess = false;
				break;
			}
		}
		return isSuccess;
	}
	
	//save p_inv_ext1 for sales data.
	private boolean insertDataPive1(Connection conn,JSONArray json)
	{
		boolean isSuccess = true;
		for(int i=0 ; i < json.size(); i++)
		{
			JSONObject dataPive1  = JSONObject.fromObject(json.get(i));
			String sql = "insert into p_inv_ext1(pive_bill_no,pive_br_id,pive_date,pive_type,pive_varch1,pive_amt1,pive_amt2, "
					     +"pive_varch2,pive_varch3,pive_varch4,pive_varch5) values(?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[11];
			parms[0]=dataPive1.get("pive_bill_no");          //VARCHAR2(6) 
			parms[1]=dataPive1.get("pive_br_id");            //VARCHAR2(8)
			parms[2]=parseToDate(dataPive1.get("pive_date"));//DATE
			parms[3]=dataPive1.get("pive_type");             //VARCHAR2(20)
			parms[4]=dataPive1.get("pive_varch1");           //VARCHAR2(50)
			parms[5]=dataPive1.get("pive_amt1");             //NUMBER(12,3)
			parms[6]=dataPive1.get("pive_amt2");             //NUMBER(12,3)
			parms[7]=dataPive1.get("pive_varch2");           //VARCHAR2(255)
			parms[8]=dataPive1.get("pive_varch3");           //VARCHAR2(12)
			parms[9]=dataPive1.get("pive_varch4");           //VARCHAR2(12)
			parms[10]=dataPive1.get("pive_varch5");          //VARCHAR2(255)
			
			if(!this.executeUpdate(conn,sql,parms,false,dataPive1.toString()))
			{
				isSuccess = false;
				break;
			}
		}

		return isSuccess;
	}
	
	//save p_sale_ext1 for sales data.
	private boolean insertDataPsle1(Connection conn,JSONArray json)
	{
		boolean isSuccess = true;
		for(int i=0 ; i < json.size(); i++)
		{
			JSONObject dataPsle1  = JSONObject.fromObject(json.get(i));
			String sql = "insert into p_sale_ext1(psle_bill_no,psle_br_id,psle_date,psle_serial,psle_type,psle_pro_id,psle_char1, "
					+"psle_char2,psle_char3,psle_num1,psle_num2) values(?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[11];
			parms[0]=dataPsle1.get("psle_bill_no");          //VARCHAR2(6)
			parms[1]=dataPsle1.get("psle_br_id");            //VARCHAR2(8) 
			parms[2]=parseToDate(dataPsle1.get("psle_date"));//DATE
			parms[3]=dataPsle1.get("psle_serial");           //NUMBER(3)
			parms[4]=dataPsle1.get("psle_type");             //VARCHAR2(20)
			parms[5]=dataPsle1.get("psle_pro_id");           //VARCHAR2(13)
			parms[6]=dataPsle1.get("psle_char1");            //VARCHAR2(30) 
			parms[7]=dataPsle1.get("psle_char2");            //VARCHAR2(30)
			parms[8]=dataPsle1.get("psle_char3");            //VARCHAR2(30)
			parms[9]=dataPsle1.get("psle_num1");             //NUMBER(8,2)
			parms[10]=dataPsle1.get("psle_num2");            //NUMBER(8,2)
			
			if(!this.executeUpdate(conn,sql,parms,false,dataPsle1.toString()))
			{
				isSuccess = false;
				break;
			}
		}
		return true;
	}
	
	//After upload sales data,insert p_inv_process table.
	private void insertInvProcess(String brId,String billNo,java.sql.Date date)
	{
		String sql = "select count(*) as cc from pos.p_inv_process where pivp_br_id = ? and pivp_bill_no = ? and pivp_date = ?"; 
		list = this.query(sql,new Object[]{brId,billNo,date});
		
		if(list != null && list.size() > 0)
		{
			int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
			if(isValue > 0)
			{
				sql = "insert into p_inv_process(pivp_bill_no,pivp_br_id,pivp_date,pivp_stock1,pivp_mem1,pivp_bi1,pivp_sync_date) values(?,?,?,?,?,?,?)";
				Object[] parms = new Object[7];
				parms[0] = billNo;
			    parms[1] = brId;
	    		parms[2] = date;
   				parms[3] = "NNNNNNNNNN";
				parms[4] = "NNNNNNNNNN"; 
				parms[5] = "NNNNNNNNNN";
				parms[6] = new java.sql.Date(System.currentTimeMillis());//only get yyyy-mm-dd
				boolean flag = this.executeUpdate(this.getConnection(),sql,parms);
				if(!flag)
				{  
					this.recordExcInfo("insertInvProcess",WsConstant.WS_SAVE_DATA,billNo+"||"+brId+"||"+StringUtil.date2Str(date));
					LogUtil.info("Function insertInvProcess: ",WsConstant.WS_SAVE_DATA,true);
				}
			}
		}
	}
	
	//87-0001.get Upload Sale Record. //param="{\"data\":[{\"piv_bill_no\":\"010059\",\"piv_date\":\"20140825\"}]}";
	private String getSalesRecordByStore(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "select (select count(*) from pos.p_inv where piv_br_id = ? and piv_date = ? and piv_bill_no = ? ) as piv_hq, "
				+"(select count(*) from pos.p_sale where psl_br_id = ? and psl_date = ? and psl_bill_no = ? ) as psl_hq, "
				+"(select  count(*) from pos.package_sale where ps_br_id = ? and ps_date = ? and ps_bill_no  = ? ) as ps_hq, "
				+"(select  count(*) from pos.p_inv_ext1 where pive_br_id  = ? and pive_date = ? and pive_bill_no= ? ) as pive1_hq, "
				+"(select count(*) from pos.p_sale_ext1 where psle_br_id  = ? and psle_date = ? and psle_bill_no= ? ) as psle1_hq  "
				+"from dual";
		Object[] parms = new Object[15];
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		try
		{
			JSONObject jo =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			Object  obj = jo.get("piv_date");
			if(obj != null)
			{
				java.sql.Date pDate = new java.sql.Date(sdf.parse(String.valueOf(obj)).getTime());
				String pBillNo = String.valueOf(jo.get("piv_bill_no"));
				parms[0] = brId;  parms[1] = pDate;   parms[2] = pBillNo;
				parms[3] = brId;  parms[4] = pDate;   parms[5] = pBillNo;
				parms[6] = brId;  parms[7] = pDate;   parms[8] = pBillNo;
				parms[9] = brId;  parms[10] = pDate;  parms[11] = pBillNo;
				parms[12] =brId;  parms[13] = pDate;  parms[14] = pBillNo;
				
				list = this.query(sql,parms);
			}
		}
		catch(Exception ex)
		{
			this.recordExcInfo("uploadSalesDataByStore",WsConstant.WS_PARSE_JSON,ex.toString());
			LogUtil.info("Function getSalesRecordByStore: ",WsConstant.WS_PARSE_JSON + ex.toString(),true);
			
			hst.put("data",new ArrayList());
			return this.getJson(hst,erCode,erMsg);
		}
		
		hst.put("data",list);
		return this.getJson(hst,erCode,erMsg);
	}
	
	//89-0001.Receive the upload file store.
	private String uploadFileByStore(HttpServletRequest request)
	{
		Hashtable hst = new Hashtable();
		String erCode = "0",erMsg = "Query Data Success.";
		
		CommonsMultipartResolver commonsMultipartResolver = new CommonsMultipartResolver(request.getSession().getServletContext());
		commonsMultipartResolver.setDefaultEncoding("utf-8");
		
		if(commonsMultipartResolver.isMultipart(request))
		{
			int len = request.getContentLength();
		    MultipartHttpServletRequest multipartRequest  = commonsMultipartResolver.resolveMultipart(request);
		    String brId = multipartRequest.getParameter("brid");
		    String act = multipartRequest.getParameter("act");
		    String param = multipartRequest.getParameter("param");
		    
		    /* LogUtil.info("--------brId:-------- ",brId,true);
		    LogUtil.info("--------act:--------- ",act,true);
		    LogUtil.info("--------param:--------- ",param,true); */
		    hst.put("data", new ArrayList());
		    
		    if(!"89-0001".equals(act))
		    {
		    	erCode = "-1";
		    	erMsg ="Can not find act:"+act;
		    	return this.getJson(hst,erCode,erMsg);
		    }
		    
		    List<MultipartFile> files = multipartRequest.getFiles("uploadFile");// 获得文件
		 /** This get file stream download to files     
		    try
		    {
		    	if(!files.isEmpty())
		    	{
					for(int k = 0; k < 1; k++)
					{
						String path = request.getSession().getServletContext().getRealPath("/api/b2c/upload/");
						String filePath = "";
						InputStream is = ((MultipartFile)files.get(k)).getInputStream();
						String str = ((MultipartFile)files.get(k)).getOriginalFilename();
						filePath = path +"/"+str;  
						FileOutputStream file = new FileOutputStream(filePath);
						int len1 = (int) ((MultipartFile)files.get(k)).getSize();
						
						LogUtil.info("Function uploadFileByStore:---getOriginalFilename--- ",str,true);
				 			
						byte[] buffer = new byte[len];
						while ( (len = is.read(buffer)) != -1) {
							file.write(buffer, 0, len);
						}
			 			
						file.close();
				        is.close();
					}
		    	}
		    }
		    catch(Exception ex)
		    {
		    	LogUtil.info("Function uploadFileByStore: ",WsConstant.WS_SAVE_FILE + ex.toString(),true);
		    }  
		   */
		  
	    //step1: insert null blob
	    java.sql.Timestamp  stTime = java.sql.Timestamp.valueOf(StringUtil.getCurrentDateTime());
		JSONObject jo =  JSONObject.fromObject(this.getArray(param,"data").get(0));   
	    String sql = "insert into sys_transfer(st_br_id,st_date,st_type,st_filedata,st_process,st_send_date,st_send_user) values(?,?,?,empty_blob(),?,?,?)";
	    Object [] params = new Object[6];
		params[0] = brId;
		params[1] = stTime;
		params[2] = "MDUP";
		params[3] = "N";
		params[4] = stTime;
		params[5] = jo.get("senduser");
		
		boolean flag = this.executeUpdate(this.getConnection(),sql,params);
		if(!flag)
		{
			LogUtil.info("Function uploadFileByStore step1: ",WsConstant.RECORD_ERROR_INFO ,true);
		}
		else
		{
			//step2: query blob,get blob Cursor
			sql = "select st_filedata from pos.sys_transfer where st_br_id = ? and st_date = ? and st_type = ? for update ";
			Object [] obj = new Object[3];
			obj[0] = brId;
			obj[1] = stTime;
			obj[2] = "MDUP";
			
			List<Map<String, Object>> listF = this.query(sql,obj);	
			//LogUtil.info("---------listF------------: ",listF.get(0).toString() ,true);
			
			oracle.sql.BLOB blob  = (oracle.sql.BLOB) listF.get(0).get("st_filedata");
			
			try
			{
				//step3: stream write to blob
				InputStream is = ((MultipartFile)files.get(0)).getInputStream();
	            OutputStream out = blob.getBinaryOutputStream();
	            byte[] buffer = new byte[len];
				while ( (len = is.read(buffer)) != -1) {
					out.write(buffer, 0, len);
				}
				is.close();
	            out.close(); 
	            
	            //step4: write blob to database
	            sql = "update sys_transfer set st_filedata = ? where st_br_id = ? and st_date = ? and st_type = ?";
	            Connection conn = this.getConnection();
	            conn.setAutoCommit(true);
	            PreparedStatement ps = conn.prepareStatement(sql);
	            ps.setBlob(1, blob);     //st_filedata
	            ps.setString(2, brId); //brid
	            ps.setTimestamp(3,stTime); //st_date  
	            ps.setString(4,"MDUP"); //st_type
	            ps.executeUpdate();
	            //transCommit(conn);
	            
	            /* SQLException - 无效的列索引
	            Object [] object = new Object[4];
	            object[0] = blob;
	            object[1] = "0001";
	            object[2] = time;
	            object[3] = "MDUP";
	            flag = this.executeUpdate(this.getConnection(),sql,params);
	            if(!flag)
	    		{
	    			LogUtil.info("Function uploadFileByStore step4:  ","update sys_transfer " ,true);
	    		} 
				 */
	            
				 //test(brId,stTime,String.valueOf(jo.get("filename"))); 
			}
			catch(Exception ex)
			{
				LogUtil.info("Function uploadFileByStore step5:  ",ex.toString() ,true);
				erCode = "-1";
				erMsg  ="Can not save act: "+act;
				
				return this.getJson(hst,erCode,erMsg);
			}
			
			
		}

	   }	
		
		
		return this.getJson(hst,erCode,erMsg);
		
	}
	
	
	//89-0003. upgrade store file.
	private String getUpgradeFile(String brId,HttpServletRequest request) throws Exception
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String baseUrl= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
       	String url = baseUrl + "/api/b2c/files/";
		//step1 get upgrade task no.
		String sql ="select sgp_task_id,to_char(sgp_valid_date,'yyyy/mm/dd') as sgp_valid_date,sgp_version,sgp_input_user,to_char(sgp_input_date,'yyyy/mm/dd HH:mm:ss') as sgp_input_date, "
				+"sgp_audit_user,to_char(sgp_audit_date,'yyyy/mm/dd HH:mm:ss') as sgp_audit_date,sgp_status "
				+"from pos.sys_goup_plan,pos.sys_goup_branch "
				+"where sgp_task_id = sgb_task_id and sgp_status = '1' and sgb_sync_flag = 'N' "
				+"and sgb_br_id = ?  and rownum =1 order by sgp_valid_date ";
		list = this.query(sql,new Object[]{brId});
		try
		{
			//step2 get files
			String fileName = String.valueOf(list.get(0).get("sgp_task_id"));
			String path = request.getSession().getServletContext().getRealPath("/api/b2c/files/");
			//if file not exist,download. 
	       	File fi = new File(path + "/" + fileName +".arj");
	       	if(!fi.exists())
	       	{
	       		FileOutputStream file = new FileOutputStream(fi.getAbsolutePath());
	    	    sql ="select sgp_filedata from pos.sys_goup_plan,pos.sys_goup_branch "
	    			        +"where sgp_task_id = sgb_task_id and sgp_status = '1' and sgb_sync_flag = 'N' "
	    			        +"and sgb_br_id = ?  and rownum =1 order by sgp_valid_date ";
	    	    List<Map<String, Object>> listF = this.query(sql,new Object[]{brId});
	    		oracle.sql.BLOB blob  = (oracle.sql.BLOB) listF.get(0).get("sgp_filedata");
	    		InputStream is = blob.getBinaryStream();
	    		try
	    		{
	    			int len = (int) blob.length();
	    			byte[] buffer = new byte[len];
	    			while ( (len = is.read(buffer)) != -1) {
	    				file.write(buffer, 0, len);
	    			}
	    		}
	    		catch(Exception ex)
	    		{
	    			LogUtil.info("Function getUpgradeFile: ",WsConstant.WS_SAVE_FILE + ex.toString(),true);
	    		}
	    		finally
	    		{
	    			file.close();
	    	        is.close();
	    		}
	       	}
			//After get upgrade program. 
	       	if (!StringUtil.isEmpty(fileName))
	       	{
	       		this.updateSyncData(brId, fileName);
	       	}
	       	
	       	Map<String,Object> map = new HashMap();
			map.put("sgp_task_id",list.get(0).get("sgp_task_id"));
			map.put("sgp_valid_date",list.get(0).get("sgp_valid_date"));
			map.put("sgp_version",list.get(0).get("sgp_version"));
			map.put("sgp_input_user",list.get(0).get("sgp_input_user"));
			map.put("sgp_input_date",list.get(0).get("sgp_input_date"));
			map.put("sgp_audit_user",list.get(0).get("sgp_audit_user"));
			map.put("sgp_audit_date",list.get(0).get("sgp_audit_date"));
			map.put("sgp_status",list.get(0).get("sgp_status"));
			map.put("url",url+fi.getName());
			list = new ArrayList<Map<String, Object>>();
			list.add(map);
		}
		catch(Exception ex)
		{
			LogUtil.info("Function getUpgradeFile: ", WsConstant.NO_UPGRADE_PROGRAM + ex.toString(),true);
   			erCode = "0";
   	        erMsg  = "No Record.";
   	        hst.put("data", new ArrayList<Map<String, Object>>());
   	        
			return this.getJson(hst,erCode,erMsg);
		}

		hst.put("data",list);
		return this.getJson(hst,erCode,erMsg);
	}

	//86-1002.get changing price bill.  //param="{\"data\":[{\"prc_id\":\"TJ1408999980002\"}]}";
	private String getPrice(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		try
		{
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			String sql ="select count(*) as cc from pos.price_detail_branch where prc_id = ? and prc_br_id = ? ";
			list = this.query(sql,new Object[]{jsonObj.get("prc_id"),brId});
			if(list != null && list.size() >0)
			{
				int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
				if(isValue > 0)
				{
					sql ="select prc_pro_id,prc_retail_price1,prc_retail_price2,prc_member_price1,prc_member_price2,to_char(prc_start_date,'yyyy/mm/dd') as prc_start_date "
							+"from pos.price_header ph,pos.price_detail_product pd "
							+"where ph.prc_id = pd.prc_id and ph.prc_id = ? ";
					list = this.query(sql,new Object[]{jsonObj.get("prc_id")});
				}
				else
				{
					list = new ArrayList();
				}
			}
		}
		catch(Exception ex)
		{
		   erCode = "0";
		   erMsg   = "No Record.";
		   hst.put("data",new ArrayList());
		   LogUtil.info("Function getPrice: ",ex.toString(),true);
		   return this.getJson(hst,erCode,erMsg);
		}
		
		hst.put("data",list);
		return this.getJson(hst,erCode,erMsg);
	}
	
   //86-2001.get promotion type. //param="{\"data\":[{\"type_id\":\"10541\"}]}";
   private String getPromotionType(String param,String brId)
   {
	   Hashtable hst = new Hashtable(); 
	   String erCode = "0",erMsg = "Query Data Success.";
	   JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
	   String sql = "select pt_name,pt_priority,pt_apply_to,pt_level,pt_class from pos.pm_type where pt_type_id = ? ";
	   list = this.query(sql,new Object[]{jsonObj.get("type_id")});
	   
	   hst.put("data", list);
	   return this.getJson(hst,erCode,erMsg);
   }
	
	//api_Mkt_QueryPmList 3.8.4	按时段查询促销活动[2012版]清单
	private String api_Mkt_QueryPmList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		String sql = "select pnh_id,STR_REPLACE(convert(char(10),pnh_start_date,111),'/','-') as pnh_start_date,STR_REPLACE(convert(char(10),pnh_end_date,111),'/','-') as pnh_end_date,pnh_pm_code, "
		             +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,STR_REPLACE(convert(char(10),pnh_plan_end,111),'/','-') as pnh_plan_end,pnh_memo "
		             +"from pos.promotion_header,pos.promotion_mix where pnh_start_date >=? and pnh_start_date <= ? and pnh_pm_code = pm_code ";

		list = this.query(sql,new Object[]{jsonObj.get("QuerySDate"),jsonObj.get("QueryEDate")});
		hst.put("data", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
   //86-1003. get promotion plan. //param="{\"data\":[{\"pm_id\":\"CX16020011\"}]}";
   private String getPromotionPlan2012(String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
		   JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		   String sql = "select pnh_id,STR_REPLACE(convert(char(10),pnh_start_date,111),'/','-') as pnh_start_date,STR_REPLACE(convert(char(10),pnh_end_date,111),'/','-') as pnh_end_date,pnh_pm_code, "
		                 +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,STR_REPLACE(convert(char(10),pnh_plan_end,111),'/','-') as pnh_plan_end,pnh_memo "
		                 +"from pos.promotion_header,pos.promotion_mix where pnh_id =? and pnh_pm_code = pm_code ";
		    list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
			if(null == list || list.size() == 0)
			{
				erCode = "0";
				erMsg   = "No Record.";
				hst.put("data",new ArrayList());
			}
			else
			{
				hst.put("dataH",list);//promotion header
				
				sql = "select pnh_pro_id,pro_name,pro_spec,pro_unit,pro_city, pnh_price, pnh_group,pnh_qty  "
						+"from pos.promotion_detail_product,pos.product where	pnh_id	= ? and pnh_pro_id = pro_id order by pnh_pro_id";
				list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
				hst.put("dataP",list); //promotion product
				
				sql = "select pnh_store_id,br_name as pnh_store_name "
				      +"from pos.promotion_detail_branch,pos.branch where pnh_id	= ? and pnh_store_id = br_id  order by pnh_store_id";
				list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
				hst.put("dataC",list); //promotion entity
			}
	   }
	   catch(Exception ex)
	   {
		 erCode = "0";
		 erMsg   = "No Record.";
		 hst.put("data",new ArrayList());
		 LogUtil.info("Function getPromotionPlan: ",ex.toString(),true);
	     return this.getJson(hst,erCode,erMsg);
	   }
	   
		return this.getJson(hst,erCode,erMsg);
   }
	
	
   //86-2002. get promotion plan. //param="{\"data\":[{\"pm_id\":\"CX16020011\"}]}";
   private String getPromotionPlan(String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
		   JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		   String sql = "select pph_name,to_char(pph_date_start,'yyyy/mm/dd') as pph_date_start,to_char(pph_date_end,'yyyy/mm/dd') as pph_date_end,pph_date_cancel,pph_time_valid,pph_time_start, "
		                 +"pph_time_end,pph_pm_type,pph_pm_priority,pph_pm_customer,pph_mem_class, pph_campaign_id,pph_reward_mode,pph_pm_status, pph_pop_desc,pph_sale_desc "
		                 +"from pos.pm_plan_header where pph_pm_id =? ";
		    list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
			if(null == list || list.size() == 0)
			{
				erCode = "0";
				erMsg   = "No Record.";
				hst.put("data",new ArrayList());
			}
			else
			{
				hst.put("dataH",list);//promotion header
				
				sql = "select ppdp_pro_id, ppdp_group, ppdp_qty,ppdp_price, ppdp_pot_num,ppdp_pot_rate,ppdp_pm_include,ppdp_sale_desc, "
						+"ppdp_ext_n1,ppdp_ext_n2,ppdp_ext_n3,ppdp_ext_s1,ppdp_ext_s2, ppdp_ext_s3 "
						+"from pos.pm_plan_detail_product where	ppdp_pm_id	= ? order by ppdp_pro_id";
				list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
				hst.put("dataP",list); //promotion product
				
				sql = "select ppde_entity_type, ppde_entity_id,ppde_group,ppde_con_n1,ppde_res_n1, ppde_res_s1, ppde_con_n2,ppde_res_n2, ppde_res_s2 "
				      +"from pos.pm_plan_detail_entity where ppde_pm_id	= ? order by ppde_entity_type,ppde_entity_id";
				list = this.query(sql,new Object[]{jsonObj.get("pm_id")});
				hst.put("dataC",list); //promotion entity
			}
	   }
	   catch(Exception ex)
	   {
		 erCode = "0";
		 erMsg   = "No Record.";
		 hst.put("data",new ArrayList());
		 LogUtil.info("Function getPromotionPlan: ",ex.toString(),true);
	     return this.getJson(hst,erCode,erMsg);
	   }
	   
		return this.getJson(hst,erCode,erMsg);
   }
	
	
	
	//86-1001.get product. //param ="{\"data\":[{\"pro_id\":\"022236\"}]}";
	private String getProduct(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		try
		{
			JSONObject jsonObj=JSONObject.fromObject(this.getArray(param,"data").get(0));
			/*
			String sql = "select pro_name, pro_sname,pro_spec,pro_unit,pro_normal_price,pro_change_price, "   
					    + "pro_discount,pro_packet_compose,pro_print_code,pro_class,pro_city,pro_unit_cost, "
					    + "pro_pym,pro_table_status ,pro_brand,pro_supplier,pro_register_no,pro_special_code, "
					    + "pro_factory, 0 as ldec_ext_n1,0 as ldec_ext_n2,0 as ldec_ext_n3, "
					    + "pa_old_id,pa_class1,pa_style,pas_name,vpa_attr, "
					    + "nvl((select st_normal_price from pos.store where  st_br_id= ? and st_pro_id = ?),pro_normal_price) as st_normal_price, "
					    + "nvl((select st_mem_price from pos.store where  st_br_id=? and st_pro_id = ?),0) as st_mem_price  "
					    + "from pos.product "
					    + "left join pos.product_attr on pro_id = pa_pro_id "
					    + "left join pos.product_attr_set on pa_style = pas_id "
					    + "left join pos.view_product_attr on pa_pro_id = vpa_pro_id where pro_id=? ";
			*/
			String sql = "select pro_name, pro_sname,pro_spec,pro_unit,pro_normal_price,pro_change_price, "   
					    + "pro_discount,pro_packet_compose,pro_print_code,pro_class,pro_city,pro_unit_cost, "
					    + "pro_pym,pro_table_status ,pro_brand,pro_supplier,pro_register_no,pro_special_code, "
					    + "pro_factory, 0 as ldec_ext_n1,0 as ldec_ext_n2,0 as ldec_ext_n3, "
					    + "pa_old_id,pa_class1,pa_style,pas_name,vpa_attr, "
					    + "isnull((select st_normal_price from pos.store where  st_br_id= ? and st_pro_id = ?),pro_normal_price) as st_normal_price, "
					    + "isnull((select st_mem_price from pos.store where  st_br_id=? and st_pro_id = ?),0) as st_mem_price  "
					    + "from pos.product,pos.product_attr,pos.product_attr_set,pos.view_product_attr where "
					    + "pro_id *= pa_pro_id and pa_style *= pas_id  and pa_pro_id *= vpa_pro_id and  pro_id=? ";
			
			Object [] params = new Object[5];
			params[0] = brId; params[1] = jsonObj.get("pro_id");
			params[2] = brId; params[3] = jsonObj.get("pro_id");
			params[4] =jsonObj.get("pro_id");
			list = this.query(sql,params);
			//erMsg = sql;
			
		}
		catch(Exception ex)
		{
			 erCode = "0";
			 erMsg   = "No Record.";
			 hst.put("data",new ArrayList());
			 LogUtil.info("Function getProduct: ",ex.toString(),true);
		     return this.getJson(hst,erCode,erMsg);
		}

	   hst.put("data",list);		
	   return this.getJson(hst,erCode,erMsg);
	}
    
	//86-0002.get transfer data with brid and rownum.
	private String getTransferData(String brId,int brRow)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		//step1:change flag to W.
		//String sql = "update data_transfer_sync set dts_flag='W' where dts_org_id = ? and dts_flag = 'N' and rownum < ? ";
		String sql = "update pos.data_transfer_sync set dts_flag='W' where dts_org_id = ? and dts_flag = 'N' ";
   		boolean flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
   		if(!flag)
   		{
   			erCode = "-3";
   	        erMsg  = "Update Data_transfer_sync to W Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}
   		
   		//step2:get all data
   		sql = "select * from pos.data_transfer_sync where dts_org_id = ? and dts_flag ='W' ";
   		list = this.query(sql,new Object[]{brId});
   		
   		//step3:change flag to Y
  		sql = "update pos.data_transfer_sync set dts_flag='Y' where dts_org_id = ? and dts_flag = 'W' ";
  		flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
   		if(!flag)
   		{
   	        erCode = "-3";
   	        erMsg  = "Update Data_transfer_sync to Y Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}
   
   		hst.put("data", null == list ? "":list);
	   return this.getJson(hst,erCode,erMsg);
	}
	
	//73-0001.Mobile Payment Account
	private String getMobilePayAccount(String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "select concat('支付**SQB商户ID**', bap_store_id) || concat('||支付**SQB_APP_ID**',bap_app_id) || concat('||支付**SQB_APP_KEY**',bap_app_key) as paySet " 
				+"from pos.branch_attr_pay where bap_id = ? ";
		list = this.query(sql,new Object[]{brId});
		if(list != null && list.size() > 0)
		{
			sql = "update branch_attr_pay set bap_sync_date = sysdate where bap_id = ? ";
	   		boolean flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
	   		if(!flag)
	   		{
	   			erCode = "-3";
	   	        erMsg  = "Update Branch_attr_pay Failed.";
	   	        return this.getJson(hst,erCode,erMsg);
	   		}
		}
		
		hst.put("data", list);
		return this.getJson(hst,erCode,erMsg);
	}

    //01-0003.update branch_attr version. //param ="{\"data\":[{\"br_version\":\"9.2.1||P.450710.21\"}]}";
    private String updateBranchVersion(String param,String brId)
	{
    	Hashtable hst = new Hashtable();
    	String erCode = "0",erMsg = "Query Data Success.";
		//step1.get big version.
		String sql = "select bra_ext_c10 from pos.branch_attr where bra_id = ?";
		list = this.query(sql,new Object[]{brId});
		String baseVersion = (String.valueOf(list.get(0).get("bra_ext_c10"))).split("\\|\\|")[0];
		//step2.update version.
		JSONObject jsonObj=JSONObject.fromObject(this.getArray(param,"data").get(0));
		sql = "update branch_attr set bra_ext_c09 = ?,bra_ext_c10= ? where bra_id = ?";
   		Object[] parms = new Object[3];
   		parms[0] = StringUtil.getCurrentDateTime();
   		parms[1] = baseVersion +"||" + jsonObj.get("br_version");
   		parms[2] = brId;
   		
   		boolean flag = this.executeUpdate(this.getConnection(),sql,parms);
   		if(!flag)
   		{
   			erCode = "-3";
   	        erMsg  = "Save branch_attr Database Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}
    	
	   return this.getJson(hst,erCode,erMsg);
	}
	    
	//01-0001.Get database time from ws.
	private String getDataBaseTime()
    {
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		//String sql = "select to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') as time from dual";
		String sql = "select STR_REPLACE(convert(char(10),getdate(), 111),'/','-')||' '||convert(char(100),getdate(), 8) as time from pos.system_var";
		list = this.query(sql);
		
		hst.put("data", list);
		return this.getJson(hst,erCode,erMsg);
	}

	
	private String api_Mkt_PushMsgList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		
		//step1:change flag to W.
		//String sql = "update pos.crm_push_msg_list set crm_pml_sync_flag ='W' where crm_pml_sync_flag = 'N' and rownum < ? ";
		String sql = "update pos.crm_push_msg_list set crm_pml_sync_flag ='W' where crm_pml_sync_flag = 'N' and '**' <> ? ";
   		boolean flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
   		if(!flag)
   		{
   			erCode = "-3";
   	        erMsg  = "Update pos.crm_push_msg_list to W Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}
   		
		// or crm_pml_sync_flag='Y' test add this to return all data
		sql = "select crm_pml_id as MsgId,crm_pml_title as MsgTitle,crm_pml_apply_to as MsgToMemId,crm_pml_weixin as WeiXinId,crm_pml_other_id as OtherId,"
					+ "crm_pml_type as TypeId,convert(char(10),crm_pml_send_time, 111)||' '||convert(char(100),crm_pml_send_time, 8) as SendTime,crm_pml_content1 as MsgContent1,crm_pml_content2 as MsgContent2, "
					+ "crm_pml_content3 as MsgContent3,crm_pml_content4 as MsgContent4,crm_pml_amt as MsgAmt,crm_pml_qty as MsgQty "
					+ "from pos.crm_push_msg_list where crm_pml_sync_flag='W'  ";

		list = this.query(sql);
  		
   		//step3:change flag to Y
   		sql = "update pos.crm_push_msg_list set crm_pml_sync_flag='Y' where crm_pml_sync_flag = 'W' and '**' <> ? ";
   		flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
   		if(!flag)
   		{
   	        erCode = "-3";
   	        erMsg  = "Update pos.crm_push_msg_list to Y Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}

		hst.put("PushMsgList", list);
		//hst.put("data", null == list ? "":list);

		return this.getJson(hst,erCode,erMsg);
	}	
	   
	
	private String api_Coupon_QueryCouponPageList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		    
		
		String sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
					+ "ppr_remain_amt as CouponOrignal,STR_REPLACE(convert(char(10),ppr_sdate,111),'/','-') as BeginDate,STR_REPLACE(convert(char(10),ppr_edate,111),'/','-') as EndDate, "
					+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
					+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type <> '5001'";

		list = this.query(sql,new Object[]{ls_CustCode});

		hst.put("Records", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Coupon_QueryCouponUseList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_prepaidid = String.valueOf(jsonObj.get("PrepaidId"));
		    
		
		String sql = "select ppu_use_type,ppu_use_org,br_name,ppu_use_bill,ppu_use_amt,STR_REPLACE(convert(char(10),ppu_input_date,111),'/','-') as ppu_input_date,ppu_pay_mode,ppu_shift "
					+ " from pos.promotion_prepaid_use,pos.branch "
					+ "where ppu_id = ? and ppu_use_org = br_id order by ppu_input_date,ppu_use_type";

		list = this.query(sql,new Object[]{ls_prepaidid});

		hst.put("Records", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Coupon_QueryRedPacketsPageList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		    
		
		String sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
					+ "ppr_remain_amt as CouponOrignal,STR_REPLACE(convert(char(10),ppr_sdate,111),'/','-') as BeginDate,STR_REPLACE(convert(char(10),ppr_edate,111),'/','-') as EndDate, "
					+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
					+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type = '5001'";;

		list = this.query(sql,new Object[]{ls_CustCode});

		hst.put("Records", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Customer_QueryCustomerPoint(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_Mobile = String.valueOf(jsonObj.get("Mobile"));
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		String  ls_VIPCardNo = String.valueOf(jsonObj.get("VIPCardNo"));
		    
		if("".equals(ls_Mobile)||"null".equals(ls_Mobile)||StringUtil.isEmpty(ls_Mobile))
		{
			ls_Mobile = "---------";
		}
		
		String sql = "select mp_sum_pot as PointUseFul,mp_total_pot as PointTotal,mp_sum_amount as AmtTotal,mp_back_money as AmtFeedBack "
					+ "from pos.mem_personal "
					+ "where mp_mobile_phone = ?";

		list = this.query(sql,new Object[]{ls_Mobile});

		hst.put("PointItem", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Customer_QueryCustomerPointDetails(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_Mobile = String.valueOf(jsonObj.get("Mobile"));
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		String  ls_StartDate = String.valueOf(jsonObj.get("StartDate"));
		String  ls_EndDate = String.valueOf(jsonObj.get("EndDate"));
		    
		if("".equals(ls_Mobile)||"null".equals(ls_Mobile)||StringUtil.isEmpty(ls_Mobile))
		{
			ls_Mobile = "---------";
		}
		
		String sql = "select STR_REPLACE(convert(char(10),mts_tx_date,111),'/','-') as CreateTime,'消费积分' as ChangeType,convert(char(8),getdate(),112)||'SUM' as RefCode,mts_br_id as ShopCode,br_name as ShopName,"
					+ "mts_total_pot as UserPoint from pos.mem_tx_summary,pos.branch "
					+ "where mts_mem_id = ? and mts_br_id = br_id  union all "
					+ "select STR_REPLACE(convert(char(10),mth_tx_date,111),'/','-') as CreateTime,(case mth_type when   '00' then '正常销售' when '01' then '积分换购'  when '04' then '限次预付/消费' when '05' then '人工调整' else '其他' end) as ChangeType,mth_voucher_id as RefCode,mth_br_id as ShopCode,br_name as ShopName,"
					+ "(case mth_type when   '00' then 1 when   '04' then 1 when '05' then 1  else -1 end)*mth_tx_pot as UserPoint from pos.mem_transaction_header,pos.branch "
					+ "where mth_card_id = ? and mth_br_id = br_id and mth_type in ('00','01','04','05')";

		list = this.query(sql,new Object[]{ls_CustCode,ls_CustCode});

		hst.put("PointLog", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	

	
	private String api_com_QueryShopList(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String  ls_BrId = String.valueOf(jsonObj.get("BrId"));
		String  ls_BrName = String.valueOf(jsonObj.get("BrName"));
		    
		if("".equals(ls_BrId)||"null".equals(ls_BrId)||StringUtil.isEmpty(ls_BrId))
		{
			ls_BrId = "%";
		}
		    
		if("".equals(ls_BrName)||"null".equals(ls_BrName)||StringUtil.isEmpty(ls_BrName))
		{
			ls_BrName = "%";
		}
		
		String sql = "select br_id as ShopCode,br_name as ShopName,br_addr as Address,br_tel as Phone,br_shop_stime||'-'||br_shop_etime as BusinessTime,br_longitude as Longitude,br_latitude as Latitude "
					+ "from pos.branch "
					+ "where br_id like ? and br_name like ?";

		list = this.query(sql,new Object[]{ls_BrId,ls_BrName});

		hst.put("ShopList", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Customer_ImBand(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		String  ls_mobile = String.valueOf(jsonObj.get("Mobile"));
		String  ls_imtype = String.valueOf(jsonObj.get("ImType"));
		String  ls_imid = String.valueOf(jsonObj.get("ImId"));
		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		String sql = "select mp_id as CustCode,mp_name as CustName,mp_sex as Sex,mp_mobile_phone as Mobile,mp_tel as Phone,mp_email_address as Email,mp_qq as QQ, "
					+ "mp_br_id as ShopCode "
					+ "from pos.mem_personal "
					+ "where mp_mobile_phone = ?";

		list = this.query(sql,new Object[]{ls_mobile});

		hst.put("Customer", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Order_QueryOrder(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		String  pBillNo = String.valueOf(jsonObj.get("OrderCode"));
		String  pShopCode = String.valueOf(jsonObj.get("ShopCode"));
		
		//如果不传入则为null
		System.out.println("------param---------"+param);
		    
		if("".equals(pBillNo)||"null".equals(pBillNo)||StringUtil.isEmpty(pBillNo))
		{
			pBillNo = "%";
		}
		    
		if("".equals(pShopCode)||"null".equals(pShopCode)||StringUtil.isEmpty(pShopCode))
		{
			pShopCode = "%";
		}
		
		String sql = "select STR_REPLACE(convert(char(10),piv_date,111),'/','-') as OrderDate,piv_time as OrderTime,convert(char(8),piv_date,112)||'-'||piv_br_id||'-'||piv_bill_no as OrderCode,piv_br_id as ShopCode,br_name as ShopName,"
					+ "piv_hyk_no as CustCode,'TEST' as CustName,'TEST' as Mobile,'TEST' as ProvName,'TEST' as CityName,'TEST' as CountyName," 
					+ "'TEST' as Address,'TEST' as PayMode,piv_ys_amt as OrderMoney,0 as ScoreMoney,piv_dyq as CouponMoney,0 as OtherMoney,"
					+ "0 as OrderPoint,0 as UsedPoint, STR_REPLACE(convert(char(10),piv_date,111),'/','-') || ' '|| piv_time as BuyTime,'TEST' as BuyerMeno,"
					+ "'TEST' as InnerMeno,0 as GoodsNum from pos.p_inv,pos.branch "
					+ "where piv_hyk_no like ? and piv_br_id like ? and piv_bill_no like ? and piv_date >= ? and piv_date <= ? and br_id = piv_br_id";

		list = this.query(sql,new Object[]{jsonObj.get("VIPCardNo"),pShopCode,pBillNo,jsonObj.get("OrderSDate"),jsonObj.get("OrderEDate")});

		hst.put("data", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Order_QueryOrderItem(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		
		System.out.println("------param---------"+param);

		String  pBillNo = String.valueOf(jsonObj.get("OrderCode"));
		
		if("".equals(pBillNo)||"null".equals(pBillNo)||StringUtil.isEmpty(pBillNo))
		{
			erCode = "0";
			erMsg = "入参单据号为空.";
			//return this.getJson(hst,erCode,erMsg);
		}
		
		//split
		String ls_date = pBillNo.split("-")[0];
		String ls_br_id = pBillNo.split("-")[1];
		String ls_bill_no = pBillNo.split("-")[2];
		
		//date convert 
		//java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
		//date = new java.sql.Date(new SimpleDateFormat("yyyyMMdd").parse(ls_date).getTime());	
		
		//如果不传入则为null
		//System.out.println("------pBillNo---------"+pBillNo);
		//System.out.println("------ls_date---------"+ls_date);
		//System.out.println("------ls_br_id---------"+ls_br_id);
		//System.out.println("------ls_bill_no---------"+ls_bill_no);
		//System.out.println("------date---------"+date);
		
		String sql = "select psl_serial as BillRowNo,psl_pro_id as SKU,psl_qty as Qty,psl_batch_num as BatchNum,pro_print_code as ProductNo,"
					+ "pro_name as ProductName,pro_brand as BrandCode,brand_name as BrandName,psl_prc2 as SalesPrice,psl_prc1 as OriginalPrice," 
					+ "psl_amt as TotalMoney,'N' as IsGift,'' as Memo "
					+ "from pos.p_sale,pos.product,pos.brand "
					+ "where psl_br_id = ? and psl_bill_no = ? and psl_date = ? and psl_pro_id = pro_id and pro_brand = brand_id";
					

		list = this.query(sql,new Object[]{ls_br_id,ls_bill_no,ls_date});

		hst.put("data", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	

	//Parse String to Json Array.
	private JSONArray getArray(String param,String key)
	{
		JSONArray ja = null;
		try
		{
			JSONObject jo = JSONObject.fromObject(param);
			ja = jo.getJSONArray(key);
		}
		catch(Exception ex)
		{
   	        this.recordExcInfo("getArray",ex.toString(),param);
			LogUtil.info("Function getArray: ", WsConstant.WS_PARSE_JSON +param+ex.toString(),true);
		}
		return ja;
	}
	
	//Get Database Connection.
	private Connection getConnection()
	{
		Connection conn =  null;
		String dsName = "java:comp/env/jdbc/mysqlyctzk";//Name of the data source.
		try
		{
			InitialContext ctx = new InitialContext();  
			DataSource ds = (DataSource)ctx.lookup(dsName);//datasourceName
	    	ctx.close();
	    	conn = ds.getConnection();//Get data in a data source connection.
			conn.setAutoCommit(false);//Settings are not automatically commit the transaction.
		}
		catch(Exception ex)
		{
			LogUtil.info("Function getConnection: ", WsConstant.WS_CONN_DB + ex.toString(),true);
		}
		
		return conn;
	}
	
	//Transfer Json To String without list.
	private String getJson(Hashtable hst,String erCode,String erMsg)
	{
		hst.put("erCode", erCode);
		hst.put("erMsg", erMsg);
		try 
		{
			return JsonUtil.toJson(hst);//return JSONObject.fromObject(hst).toString();
		}
		catch (Exception ex1) 
		{
			this.recordExcInfo("getJson",ex1.toString(),"");//record error information to database.
			LogUtil.info("Function getJson: ",WsConstant.WS_PARSE_JSON + ex1.toString(),true);
			return "";
		}
	}
	
	//Query Data Transfer List without param.
	private List<Map<String, Object>> query(String sql)
	{
		try 
		{
			return JDBCUtil.query("java:comp/env/jdbc/mysqlyctzk", sql, 0, 0,"sybase", null);
		}
		catch (Exception ex) 
		{
			LogUtil.info("Function query: ", WsConstant.DB_QUERY_SQL + ex.toString(),true);
			return null;
		}
	}
	
	//Query Data Transfer List with param.
	private List<Map<String, Object>> query(String sql,Object[] parms)
	{
		try 
		{
			return JDBCUtil.query("java:comp/env/jdbc/mysqlyctzk", sql, 0, 0,"sybase", parms);
		}
		catch (Exception ex) 
		{
			LogUtil.info("Function query: ",WsConstant.DB_QUERY_SQL + ex.toString(),true);
			return null;
		}
	}
	
	//Insert Update Delete Operation.
	private boolean executeUpdate(Connection conn,String sql,Object[] parms)
	{
		try
		{
		    JDBCUtil.executeUpdate(conn,sql,parms);
		    conn.commit();
		}
		catch(Exception ex)
		{
			try
			{
			    conn.rollback();//Roll back the transaction
			}
			catch(Exception ex1)
			{
				LogUtil.info("Function executeUpdate: ",WsConstant.DB_ROLL_BACK + ex1.toString(),true);
				return false;
			}
			this.recordExcInfo("executeUpdate","sql:" + sql + ";parms: " + parms +";ex: "+ex.toString(),"");//record error information to database.
			LogUtil.info("Function executeUpdate: ",WsConstant.DB_UPDATE_SQL + ex.toString(),true);
	        return false;
		}
	    finally
		{
		    try
		    {
			   conn.close();//release of the database connection
		    }
		    catch(Exception ex)
		    {
		    	LogUtil.info("Function executeUpdate: ",WsConstant.CLOSE_CONN + ex.toString(),true);
		    	return false;
			}
		}
		return true;
	}
	
	//Insert Update Delete Operation without commit.
	private boolean executeUpdate(Connection conn,String sql,Object[] parms,boolean isCommit,String json)
	{
		try
		{
		    JDBCUtil.executeUpdate(conn,sql,parms);
		    if(isCommit)
		    {
		    	conn.commit();
		    }
		}
		catch(Exception ex)
		{
			try
			{
			    conn.rollback();//Roll back the transaction
			}
			catch(Exception ex1)
			{
				LogUtil.info("Function executeUpdate: ",WsConstant.DB_ROLL_BACK + ex1.toString(),true);
				return false;
			}
			this.recordExcInfo("executeUpdate",ex.toString(),json);//record error information to database.
			LogUtil.info("Function executeUpdate: ",WsConstant.DB_UPDATE_SQL +"Json: " + json + ex.toString(),true);
	        return false;
		}
	    finally
		{
	    	if(isCommit)
		    {
			    try
			    {
				   conn.close();//release of the database connection
			    }
			    catch(Exception ex)
			    {
			    	LogUtil.info("Function executeUpdate: ",WsConstant.CLOSE_CONN + ex.toString(),true);
			    	return false;
				}
		    }
		}
		return true;
	}
	
	//Transaction Commit.
	private void transCommit(Connection conn)
	{
	    try
	    {
	    	conn.commit();
	    }
	    catch(Exception ex)
	    {
	    	LogUtil.info("Function transCommit: ",WsConstant.WS_SAVE_DATA + ex.toString(),true);
			try
			{
			    conn.rollback();//Roll back the transaction
			}
			catch(Exception ex1)
			{
				LogUtil.info("Function transCommit: ",WsConstant.DB_ROLL_BACK + ex.toString(),true);
			}
		}
	    finally
	    {
		    try
		    {
			   conn.close();//release of the database connection
		    }
		    catch(Exception ex)
		    {
		    	LogUtil.info("Function transCommit: ",WsConstant.CLOSE_CONN + ex.toString(),true);
			}
	    }
	}
	
	//close Connection.
	private void closeConn(Connection conn)
	{
	    try
	    {
		   conn.close();//release of the database connection
	    }
	    catch(Exception ex)
	    {
	    	LogUtil.info("Function closeConn: ",WsConstant.CLOSE_CONN + ex.toString(),true);
		}
	}
	
	//Parse Object To Date.
	private java.sql.Date parseToDate(Object obj)
	{
		java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
		try
		{
			String  pDate = String.valueOf(obj);
			date = new java.sql.Date(new SimpleDateFormat("yyyyMMdd").parse(pDate).getTime());	
		}
		catch(Exception ex)
		{
			LogUtil.info("Function parseToDate: ",WsConstant.PARSE_TO_DATE + ex.toString(),true);
		}
		return date;
	}
	
	//Check time difference between server and stores. //applyTime = "20160531103602";
	private boolean checkApplyTime(String applyTime)
	{
		//SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		try
		{
			long m = (System.currentTimeMillis() - sdf.parse(applyTime).getTime())/(1000 * 60);
			
			if(m/(60*24)>= 1)
			{
				LogUtil.info("Function checkApplyTime: ","WS Store Time Error,Need Adjustment......",true);
				return false;
			}
			
		}
		catch(Exception ex)
		{
			LogUtil.info("Function checkApplyTime: ",WsConstant.CHECK_APPLY_TIME + ex.toString(),true);
		}
		
		return true;
	}
	
	//Exception information record to database.
	private void recordExcInfo(String title,String info,String program)
	{
		String sql = "insert into tsc_log_record(err_id,err_title,err_info,err_time,err_person,err_program) values(?,?,?,?,?,?)";
		Object [] params = new Object[6];
		params[0] = StringUtil.getUUID();
		params[1] = title;
		params[2] = info;
		params[3] = new java.sql.Date(System.currentTimeMillis());
		params[4] = "WS";
		params[5] = program;
		boolean flag = this.executeUpdate(this.getConnection(),sql,params);
		if(!flag)
		{
			LogUtil.info("Function recordErrorInfo: ",WsConstant.RECORD_ERROR_INFO ,true);
		}
	}
	
	//After get upgrade program. 
	private void updateSyncData(String brId,String taskId)
	{
		String sql = "update sys_goup_branch set sgb_sync_flag='Y',sgb_sync_date = sysdate where sgb_br_id = ? and sgb_task_id = ? ";
   		boolean flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId,taskId});
		if(!flag)
		{
			LogUtil.info("Function updateSyncData: ","brId:"+brId+";taskId: "+taskId+": "+WsConstant.DB_UPDATE_SQL ,true);
		}
	}
	
	
	private void test(String brId,java.sql.Timestamp stTime,String filename) throws Exception
	{
       	String path = "D:/project/openjweb/webapps/api/b2c/upload/";
		
		try
		{
	       	File fi = new File(path + "/" + filename);
	       	if(!fi.exists())
	       	{
	       		FileOutputStream file = new FileOutputStream(fi.getAbsolutePath());
	    	    String sql ="select st_filedata from pos.sys_transfer where st_br_id = ? and st_date = ? and st_type = ?  ";
	    	    List<Map<String, Object>> listF = this.query(sql,new Object[]{brId,stTime,"MDUP"});
	    	    
	    	    System.out.println("------st_filedata---------"+listF.get(0));
	    	    
	    		oracle.sql.BLOB blob  = (oracle.sql.BLOB) listF.get(0).get("st_filedata");
	    		InputStream is = blob.getBinaryStream();
	    		try
	    		{
	    			int len = (int) blob.length();
	    			byte[] buffer = new byte[len];
	    			while ( (len = is.read(buffer)) != -1) {
	    				file.write(buffer, 0, len);
	    			}
	    		}
	    		catch(Exception ex)
	    		{
	    			LogUtil.info("Function getUpgradeFile: ",WsConstant.WS_SAVE_FILE + ex.toString(),true);
	    		}
	    		finally
	    		{
	    			file.close();
	    	        is.close();
	    		}
	       	}
		}
		catch(Exception ex)
		{
			
		}

	}	
	
%><%!
public class WsConstant{
	public static final String RECORD_ERROR_INFO =  "WS Exception Information Record To Database Failed......" ;
	public static final String CHECK_APPLY_TIME = "WS Apply Time Parse Failed......";
	public static final String PARSE_TO_DATE = "WS  Sql Data Parse Failed......";
	public static final String CLOSE_CONN  = "WS Conn Close Failed......";
	public static final String DB_ROLL_BACK = "WS Roll Back Failed......";
	public static final String DB_UPDATE_SQL = "WS Execute Update SqlSyntax Error......";
	public static final String DB_QUERY_SQL = "WS Database Query Error......";
	public static final String WS_PARSE_JSON = "WS Parse Json Failed......";
	public static final String WS_SAVE_DATA = "WS Save Data Failed......";
	public static final String WS_CONN_DB =  "WS Conn DataBase Failed For Database......";
	public static final String WS_SAVE_FILE = "WS Save File Failed.....";
	public static final String NO_UPGRADE_PROGRAM = "WS NO Upgrade Program or SqlSyntax Error.....";
	
}
%>