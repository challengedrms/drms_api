﻿<%@ page contentType="text/html;charset=UTF-8" import="org.directwebremoting.json.JsonUtil,com.openjweb.b2c.entity.*,com.openjweb.alipay.sign.MD5,net.sf.json.*,org.openjweb.core.service.*,org.openjweb.core.entity.*,org.openjweb.core.util.*,org.openjweb.core.eai.util.*,java.util.*,javax.naming.*,javax.sql.*,java.sql.*,java.text.*,java.io.*,org.springframework.web.multipart.MultipartFile,org.springframework.web.multipart.MultipartHttpServletRequest,org.springframework.web.multipart.commons.CommonsMultipartResolver"%><%
	
	String act = request.getParameter("act");     //作业类型编号
	String brId = request.getParameter("brid"); //机构号
	String proId = request.getParameter("proid"); //商品号
	String dbType = request.getParameter("dbType"); //数据库类型
	String authCode = request.getParameter("authcode"); //安全秘钥
	String applyTime = request.getParameter("applytime"); //任务请求时间
	String signCode = request.getParameter("signcode"); //标识码
	String appVersion = request.getParameter("appversion"); //程序版本号
	String param = request.getParameter("param"); //获取传入的参数
	String reMsg = "";                            //向客户端返回json字符串
	
	//LogUtil.info(" request.getContentType(): ","---------------"+request.getContentType(),true);
	//LogUtil.info(" -----act: ","---------------"+act,true);
	//LogUtil.info(" -----brId: ","---------------"+brId,true);
	LogUtil.info(" -----dbType: ","---------------"+dbType,true);
	//LogUtil.info(" -----param: ","---------------"+param,true); 
	
	
	////实施上前检查
	////1.定好数据库连结 "java:comp/env/jdbc/jyzjk"	是否完成_____
	////2.定好数据库类型 dbType = 'SYBASE'				是否完成_____
	 
	if(!StringUtil.isEmpty(dbType)&&!"SYBASE".equals(dbType)&&!"ORACLE".equals(dbType)) 
	{
		dbType = "SYBASE";
	}
	else
	{
		dbType = "ORACLE";
	}
	
	////********如门店程序没有上传，则可以写死
	dbType = "SYBASE";
	
	//check store time
	if(!StringUtil.isEmpty(applyTime)&& !checkApplyTime(applyTime))
	{
		//return ;
	}
	
	long time = System.currentTimeMillis();
	LogUtil.info("任务开始【机构："+brId + "】",	"act=" + act + ";time=" + time +";param=" + param,true);

	
	//uf_task_upload_01_0001 - 同步数据库端时间
	if ("01-0001".equals(act)) 
	{
		reMsg = this.getDataBaseTime(dbType);
	}
	
	//uf_task_upload_01_0000 - 同步机构清单
	if ("01-0000".equals(act)) 
	{
		reMsg = this.getDataBaseBrList();
	}

    if("ZHZY-SP".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.insertZhzyProduct(param, brId);
    }
    
     if("ZHZY-RX".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.insertRx(param, brId);
    }
    

 
    //uf_task_upload_09_0001OJWAPI - update mem pot
    if("09-0001OJWAPI".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.uploadMemPotChange(param,brId);
    }
 
    //uf_task_upload_09_0002OJWAPI - get mem pot list
    if("09-0002OJWAPI".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getMemPotQuery(dbType,param,brId);
    }
	

	//api_Mkt_PushMsgList - 3.8.1	获取推送信息
	if ("api_Mkt_PushMsgList".equals(act)) 
	{
		reMsg = this.api_Mkt_PushMsgList(dbType,param,brId);
	}

	//api_com_QueryShopStockBrId - 3.8.1	巨硅电商库存接口-按机构号列库存
	if ("api_com_QueryShopStockBrId".equals(act)) 
	{
		reMsg = this.api_com_QueryShopStockBrId(param,brId);
	}

	//api_com_QueryShopStockPro - 3.8.1	巨硅电商库存接口-按机构号列库存
	if ("api_com_QueryShopStockPro".equals(act)) 
	{
		reMsg = this.api_com_QueryShopStockPro(param,brId,proId);
	}
	
 	//api_com_QueryShopStockProJson - 巨硅电商库存接口-按机构号+商品号 取库存
	if ("api_com_QueryShopStockProJson".equals(act)) 
	{
		reMsg = this.api_com_QueryShopStockProJson(param,brId);
	}
 

	//api_com_QueryShopStockProOrg - 3.8.1	巨硅电商库存接口-按机构号列库存
	if ("api_com_QueryShopStockProOrg".equals(act)) 
	{
		reMsg = this.api_com_QueryShopStockProOrg(param,brId,proId);
	}

 
	//api_com_QueryShopStockSum - 巨硅电商库存接口-按商品号 取库存
	if ("api_com_QueryShopStockSum".equals(act)) 
	{
		reMsg = this.api_com_QueryShopStockSum(param,brId,proId);
	}
	
	
  
	//api_com_InserOrder - 巨硅电商订单接口-接收电商推送订单到ERP 
	if ("api_com_InserOrder".equals(act)) 
	{
		reMsg = this.api_com_InserOrder(param,brId);
	}

	//api_Coupon_QueryCouponPageList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryCouponPageList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryCouponPageList(dbType,param,brId);
	}
 	

	//api_Coupon_QueryCouponUseList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryCouponUseList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryCouponUseList(dbType,param,brId);
	}
 	


	//api_Coupon_QueryRedPacketsPageList - 3.2.14	会员优惠券查询
	if ("api_Coupon_QueryRedPacketsPageList".equals(act)) 
	{
		reMsg = this.api_Coupon_QueryRedPacketsPageList(dbType,param,brId);
	}
 	

	//api_Customer_QueryCustomerPoint - 3.2.6	会员查询积分
	if ("api_Customer_QueryCustomerPoint".equals(act)) 
	{
		reMsg = this.api_Customer_QueryCustomerPoint(param,brId);
	}
 

	//api_Customer_QueryCustomerPointDetails - 3.2.7	查询积分明细
	if ("api_Customer_QueryCustomerPointDetails".equals(act)) 
	{
		reMsg = this.api_Customer_QueryCustomerPointDetails(dbType,param,brId);
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
		reMsg = this.api_Order_QueryOrder(dbType,param,brId);
	}
    
	//api_Order_QueryOrderItem - 3.2.16	查询订单
	if ("api_Order_QueryOrderItem".equals(act)) 
	{
		reMsg = this.api_Order_QueryOrderItem(param,brId);
	}
 
 
    
    //uf_task_upload_01_0003 - 申报前台的策略
    if("01-0003".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.updateBranchVersion(param,brId);
    }
    
    //uf_task_upload_73_0001 -取网络支付
    if("73-0001".equals(act)&&!StringUtil.isEmpty(brId))
    {
    	reMsg = this.getMobilePayAccount(dbType,brId);
    }
    
    //uf_task_upload_86_0002 -取后台的增量下发数据-形成“增量”字符串
    if("86-0002".equals(act)&&!StringUtil.isEmpty(brId))
    {
    	int br_row = 50;
    	reMsg = this.getTransferData(dbType,brId,br_row);
    }
    
    //uf_task_upload_86_1001 -取后台的增量下发数据-单个商品档案下载
    if("86-1001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getProduct(dbType,param,brId);	
    }
    
    //uf_task_upload_86_1002 -取后台的增量下发数据-调价单下载
    if("86-1002".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPrice(dbType,param,brId);
    }  
    
    
    //uf_task_upload_cz_crm_mem_attr -取后台的实时数据-会员数据下载
    if("cz_crm_mem_attr".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.cz_crm_mem_attr(param,brId);
    }  

    
    //uf_task_upload_cz_crm_mem_attr_rand -取后台的实时数据-会员数据下载
    if("cz_crm_mem_attr_rand".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.cz_crm_mem_attr_rand(param,brId);
    }  

	
	  
    //uf_task_upload_86-1005 -取后台的增量下发数据-加送下载
    if("86-1005".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionGift(dbType,param,brId);
    }  
    

    
    //uf_task_upload_86_2001 -取后台2015版促销类型
    if("86-2001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionType(param,brId);
    }
  
	//api_Mkt_QueryPmList - 3.8.4	按时段查询促销活动[2012版]清单
	if ("api_Mkt_QueryPmList".equals(act)) 
	{
		reMsg = this.api_Mkt_QueryPmList(dbType,param,brId);
	}
   
    //uf_task_upload_86_1003 -取后台2012版促销单据
    if("86-1003".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionPlan2012(dbType,param,brId);
    }
    
    //uf_task_upload_86_2002 -取后台2015版促销单据
    if("86-2002".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getPromotionPlan(dbType,param,brId);
    }
    
    //uf_task_upload_87_0001 -查看后台销售数据记录条数
    if("87-0001".equals(act)&&!StringUtil.isEmpty(brId)&&!StringUtil.isEmpty(param))
    {
    	reMsg = this.getSalesRecordByStore(dbType,param,brId);
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
   		
   		reMsg = this.getUpgradeFile(dbType,brId,request);
    }
    
    LogUtil.info("任务完成【机构："+brId + "】","act=" + act + ";time=" + time +";reMsg="+reMsg,true);
    
	out.print(StringUtil.decodeUnicode(reMsg));
	
%><%!
	
	List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();


	private String insertZhzyProduct(String param,String brId) throws Exception
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
		
		String ls_pro_id;
		ls_pro_id=String.valueOf(dataGoods.get("his_id")); 
		String sqlfind = "select count(*) as cc from t_medicine where his_id = ?"; 
		list = this.query(sqlfind,new Object[]{ls_pro_id});
		
		if(list != null && list.size() > 0)
		{
			int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
			if(isValue == 0)
			{
				try
				{
					Connection conn = this.getConnection();

					sql ="insert into t_medicine(id,his_id,bar_code,name,name_py,model,manufacturer) ";
					sql = sql + "values(?,?,?,?,?,?,?)";
					
					Object[] parms = new Object[7];
					parms[0]=dataGoods.get("id");   //VARCHAR2
					parms[1]=dataGoods.get("his_id");   //VARCHAR2
					parms[2]=dataGoods.get("bar_code");   //VARCHAR2
					parms[3]=dataGoods.get("name");   //VARCHAR2
					parms[4]=dataGoods.get("name_py");   //VARCHAR2
					parms[5]=dataGoods.get("model");   //VARCHAR2
					parms[6]=dataGoods.get("manufacturer");   //VARCHAR2
					
					boolean flag = this.executeUpdate(conn,sql,parms,false,dataGoods.toString());
					if(!flag)
					{
						erCode = "-3";
						erMsg  = "Update t_medicine  Failed.";
						return this.getJson(hst,erCode,erMsg);
					}
					
					transCommit(conn);
					closeConn(conn);
					
					//sql = "select ID from t_medicine where GOOD_NO = ? ";

					//list = this.query(sql,new Object[]{ls_pro_id});
					//hst.put("data", list);					
				}
				catch(Exception exshgoods)
				{
					erCode = "-1";
					erMsg  = "Update t_medicine Failed.";
					LogUtil.info("Function insertZhzyProduct: ",WsConstant.WS_SAVE_DATA + exshgoods.toString(),true);
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
			erMsg  = "查t_medicine表失败.";
		}
			

		
		return this.getJson(hst,erCode,erMsg);
	}
	





	private String insertRx(String param,String brId) throws Exception
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "-1",erMsg = "处方同步到ERP失败！";
		Object[] parms;
		String sql;
		String dataJS;
		String ls_RxID;
		String ls_RxUUID;
		int i;
		boolean flag;

		JSONObject dataObjectAll;
		JSONObject dataObjectRow;
		
		dataObjectAll = JSONObject.fromObject(param);
		
		dataJS	= "" + dataObjectAll.get("dataHeader");
		
		dataObjectAll = JSONObject.fromObject(dataJS);
		
		ls_RxID	= ""+dataObjectAll.get("");
		ls_RxUUID	= ""+dataObjectAll.get("id");
		
		Connection conn = this.getConnection();

		//1、处理主档
		sql ="INSERT INTO t_prescription (id,prescription_id,outpatient_id,department,"
				+"status,patient,detail_count,date_prescription,date_created)"
				+" values (?,?,?,?,?,?,?,?,?)";
				
		//LogUtil.info("sql: ",sql,true);
		
		parms = new Object[9];
		parms[0]=dataObjectAll.get("id");					//VARCHAR2(30)
		parms[1]=dataObjectAll.get("RxID");					//VARCHAR2(200)
		parms[2]=dataObjectAll.get("PatientID");					//VARCHAR2(30)
		parms[3]=dataObjectAll.get("DepartID");				//VARCHAR2(30)
		parms[4]=dataObjectAll.get("Status");			//VARCHAR2(30)
		parms[5]=dataObjectAll.get("PatientName");				//VARCHAR2(30)
		parms[6]=dataObjectAll.get("DetailCount");				//NUMBER(18,2)
		parms[7]=parseToDate(dataObjectAll.get("DatePay"));	//DATE
		parms[8]=parseToDate(dataObjectAll.get("DateCreated"));		//DATE
		

		try
		{
			flag = this.executeUpdate(conn,sql,parms,false,dataObjectAll.toString());
			if(!flag)
			{
				erCode = "-11";
				erMsg  = "Insert t_prescription  Failed1.";
				
				conn.rollback();
				closeConn(conn);
				
				return this.getJson(hst,erCode,erMsg);
			}
		}
		catch(Exception ex_crm_01)
		{
			//LogUtil.info("*********: ", "*****",true);
			LogUtil.info("=========: ",ex_crm_01.toString(),true);
			//LogUtil.info("&&&&&&&&&: ",ex_crm_01.getMessage(),true);
		
			erCode = "-12";
			erMsg  = "Insert t_prescription  Failed2.";
			
			conn.rollback();
			closeConn(conn);
			
			return this.getJson(hst,erCode,erMsg);
		}

		//2、处方明细
		JSONArray dataRxProList= getArray(param,"dataGoods");

		for(i=0 ; i < dataRxProList.size(); i++)
		{
			dataObjectRow  = JSONObject.fromObject(dataRxProList.get(i));
			try
			{
				sql ="insert into t_prescription_detail (id,prescription_id,sequence,status,medicine_id,"
					+ "use_quantity,need_supply,date_created,date_modified) "
					+ "values(?,?,?,?,?,?,?,?,?)";
				
				parms = new Object[9];
				parms[0]=dataObjectRow.get("id");   //VARCHAR2
				parms[1]=dataObjectRow.get("RxID");   //VARCHAR2
				parms[2]=dataObjectRow.get("RowNo");   //VARCHAR2
				parms[3]=dataObjectRow.get("status");   //VARCHAR2
				parms[4]=dataObjectRow.get("ProUUID");   //VARCHAR2
				parms[5]=dataObjectRow.get("OutQty");   //VARCHAR2
				parms[6]=dataObjectRow.get("NeedSupply");   //VARCHAR2
				parms[7]=parseToDate(dataObjectRow.get("DateCreated"));   //VARCHAR2
				parms[8]=parseToDate(dataObjectRow.get("DataModified"));   //VARCHAR2
				
				//LogUtil.info("InsertSQL:",sql,true);
				//LogUtil.info("InsertSQL:",String.valueOf(parms[0]),true);
				
				flag = this.executeUpdate(conn,sql,parms,false,dataObjectRow.toString());
				if(!flag)
				{
					erCode = "-21";
					erMsg  = "Insert crm_dc_card_rule_detail  Failed1.";
					LogUtil.info("Insert crm_dc_card_rule_detail Failed1: ",	"",true);
					return this.getJson(hst,erCode,erMsg);
				}
			}
			catch(Exception ex_crm_02)
			{
				erCode = "-22";
				erMsg  = "Insert t_prescription_detail Failed2.";
				LogUtil.info("Insert t_prescription_detail Failed2: ",ex_crm_02.toString(),true);
				return this.getJson(hst,erCode,erMsg);
			}
		}

		transCommit(conn);
		closeConn(conn);
		
		erCode = "0";
		erMsg = "Insert RX  Successed.";
		return this.getJson(hst,erCode,erMsg);
	}

	private String api_com_ChangeShopStockPro(String param,String brId) throws Exception
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "-1",erMsg = "商城订单同步到ERP失败！";
		Object[] parms;
		String sql;
		String dataJS;
		String lsBillNo;
		int i;
		boolean flag;

		JSONObject dataObjectAll;
		JSONObject dataObjectRow;
		
		dataObjectAll = JSONObject.fromObject(param);
		
		dataJS	= "" + dataObjectAll.get("data");
		
		dataObjectAll = JSONObject.fromObject(dataJS);
		
		lsBillNo	= ""+dataObjectAll.get("BillNo");
		
		Connection conn = this.getConnection();

		//1、处理主档
		sql ="INSERT INTO pos.edi_head (edih_voucher_id,edih_type,edih_org_id,edih_tx_date,edih_ref_id1,edih_ref_id2,edih_ref_id3,"
				+"edih_ref_id4,edih_ref_id5,edih_memo,edih_input_user,edih_input_date,edih_flag ) "
				+" values (?,?,?,?,?,?,?,?,?,?,?,?,?)";
						
		parms = new Object[13];
		parms[0]=lsBillNo;					//VARCHAR2(30)
		parms[1]="ZD";					//VARCHAR2(200)
		parms[2]=dataObjectAll.get("BillOrgId");					//VARCHAR2(30)
		parms[3]=parseToDate(dataObjectAll.get("BillTxDate"));				//VARCHAR2(30)
		parms[4]="CRMDC|TR";			//edih_ref_id11	VARCHAR2(30)
		parms[5]=dataObjectAll.get("ReceName");				//edih_ref_id2	VARCHAR2(30)
		parms[6]=dataObjectAll.get("ReceTel");				//edih_ref_id3	VARCHAR2(30)
		parms[7]=dataObjectAll.get("BillMemo");				//edih_ref_id4	VARCHAR2(30)
		parms[8]=dataObjectAll.get("BillSelfTake");				//edih_ref_id5	VARCHAR2(30)
		parms[9]=dataObjectAll.get("ReceAddr");					//VARCHAR2(30)
		parms[10]="000000";					//VARCHAR2(30)
		parms[11]=parseToDate(dataObjectAll.get("BillTxDate"));					//VARCHAR2(30)
		parms[12]="0";					//VARCHAR2(30)
		

		try
		{
			flag = this.executeUpdate(conn,sql,parms,false,dataObjectAll.toString());
			if(!flag)
			{
				erCode = "-11";
				erMsg  = "Insert pos.edi_head Failed 1.";
				
				conn.rollback();
				closeConn(conn);
				
				return this.getJson(hst,erCode,erMsg);
			}
		}
		catch(Exception ex_crm_01)
		{
			//LogUtil.info("*********: ", "*****",true);
			LogUtil.info("=========: ",ex_crm_01.toString(),true);
			//LogUtil.info("&&&&&&&&&: ",ex_crm_01.getMessage(),true);
		
			erCode = "-12";
			erMsg  = "Insert pos.edi_head  Failed 2.";
			
			conn.rollback();
			closeConn(conn);
			
			return this.getJson(hst,erCode,erMsg);
		}

		//2、商城订单明细
		JSONArray dataProList= getArray(param,"ProList");

		for(i=0 ; i < dataProList.size(); i++)
		{
			dataObjectRow  = JSONObject.fromObject(dataProList.get(i));
			try
			{
				sql ="INSERT INTO pos.edi_detail (edid_voucher_id,edid_item,edid_pro_id,edid_batch_num, "
					+"edid_qty,edid_cost_price,edid_sale_price,edid_num1 )  "
					+"VALUES ( ?,?,?,?,?,?,?,?)";
				
				parms = new Object[8];
				parms[0]=lsBillNo;   //VARCHAR2
				parms[1]=dataObjectRow.get("SerialNo");   //VARCHAR2
				parms[2]=dataObjectRow.get("proid");   //VARCHAR2
				parms[3]="-";   //VARCHAR2
				parms[4]=dataObjectRow.get("SaleQty");   //VARCHAR2
				parms[5]=0;   //VARCHAR2
				parms[6]=dataObjectRow.get("SalePrcNew");   //VARCHAR2
				parms[7]=dataObjectRow.get("SalePrcOld");   //VARCHAR2
				
				//LogUtil.info("InsertSQL:",sql,true);
				//LogUtil.info("InsertSQL:",String.valueOf(parms[0]),true);
				
				flag = this.executeUpdate(conn,sql,parms,false,dataObjectRow.toString());
				if(!flag)
				{
					erCode = "-21";
					erMsg  = "Insert pos.edi_detail  Failed 1.";
					LogUtil.info("Insert pos.edi_detail Failed 1: ",	"",true);
					return this.getJson(hst,erCode,erMsg);
				}
			}
			catch(Exception ex_crm_02)
			{
				erCode = "-22";
				erMsg  = "Insert pos.edi_detail Failed 2.";
				LogUtil.info("Insert pos.edi_detail: ",ex_crm_02.toString(),true);
				return this.getJson(hst,erCode,erMsg);
			}
		}

		transCommit(conn);
		closeConn(conn);
		
		erCode = "0";
		erMsg = "Insert 商城订单 Successed.";
		return this.getJson(hst,erCode,erMsg);
	}

	
   	//api_com_InserOrder - 巨硅电商订单接口-接收电商推送订单到ERP 
	private String api_com_InserOrder(String param,String brId) throws Exception
	{
		String erCode = "0",erMsg = "Query Data Success.";
		Hashtable hst = new Hashtable();
		
		try
		{
		    Connection conn = this.getConnection();
			
		    JSONArray JA_orderList= getArray(param,"orderList");

		    if(JA_orderList == null || JA_orderList.size() == 0) 
		    {
				erCode	= "-1";
				erMsg	= "orderList is null";
		    	return this.getJson(hst,erCode,erMsg);
		    }

			boolean BorderList = api_com_InserOrder_act(conn,JA_orderList);
			
			if(BorderList)
			{
				transCommit(conn);
			}
			else
			{
				closeConn(conn);
	   	        erCode = "-1";
	   	        erMsg  = "Update orderList Data Failed.";
			}
		}
		catch(Exception ex)
		{
			erCode = "-1";
   	        erMsg  = "Update orderList Data Failed.";
			//this.recordExcInfo("api_com_InserOrder",WsConstant.WS_SAVE_DATA,ex.toString());
			//LogUtil.info("Function api_com_InserOrder: ",WsConstant.WS_SAVE_DATA + ex.toString(),true);
		}

		return this.getJson(hst,erCode,erMsg);
	}
	
	//save orderList data.
	private boolean api_com_InserOrder_act(Connection conn,JSONArray JA_In)
	{
		boolean isSuccess = true;
		long	l_line;
		String sql = "insert into pos.ec_jg_order(ejo_orderId,ejo_orderCode,ejo_userId,ejo_orgCode,ejo_consignee,ejo_address,ejo_tel,ejo_orderAmount,ejo_payAmount,ejo_postTime,ejo_payTime, "
				+"ejo_province,ejo_city,ejo_area,ejo_productName,ejo_productCode,ejo_skuQty,ejo_skuCode,ejo_productPrice,ejo_line,ejo_status) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		String sqlEdiH = "INSERT INTO pos.edi_head (edih_voucher_id,edih_type,edih_org_id,edih_tx_date,edih_ref_id1,edih_ref_id2,edih_ref_id3,"
				+"edih_ref_id4,edih_ref_id5,edih_memo,edih_input_user,edih_input_date,edih_audit_user,edih_audit_date,edih_flag ) "
				+"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		String sqlEdiD = "INSERT INTO pos.edi_detail (edid_voucher_id,edid_item,edid_pro_id,edid_batch_num,edid_made_date,edid_valid_date, "
				+"edid_qty,edid_cost_price,edid_sale_price,edid_location,edid_package,edid_memo,edid_sup_pro_id,edid_class1, "
				+"edid_class2,edid_class3,edid_num1,edid_num2,edid_num3 )  "
				+"VALUES ( ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				

		for(int i=0 ; i < JA_In.size(); i++)
		{
			JSONObject JO_orderList_row  = JSONObject.fromObject(JA_In.get(i));
			
			Object[] parms = new Object[21];
			parms[0]=JO_orderList_row.get("orderId");	
			parms[1]=JO_orderList_row.get("orderCode");	
			parms[2]=JO_orderList_row.get("userId");	
			parms[3]=JO_orderList_row.get("orgCode");	
			parms[4]=JO_orderList_row.get("consignee");	
			parms[5]=JO_orderList_row.get("address");	
			parms[6]=JO_orderList_row.get("tel");	
			parms[7]=JO_orderList_row.get("orderAmount");	
			parms[8]=JO_orderList_row.get("payAmount");	
			parms[9]=JO_orderList_row.get("postTime");	
			parms[10]=JO_orderList_row.get("payTime");	
			parms[11]=JO_orderList_row.get("province");	
			parms[12]=JO_orderList_row.get("city");	
			parms[13]=JO_orderList_row.get("area");	

			JSONArray JA_orderList_line = JO_orderList_row.getJSONArray("orderLineList"); 
		
			l_line	= 0;
			for(int j=0 ; j < JA_orderList_line.size(); j++)
			{
				JSONObject JO_orderList_line  = JSONObject.fromObject(JA_orderList_line.get(j));

				parms[14]=JO_orderList_line.get("productName");	
				parms[15]=JO_orderList_line.get("productCode");	
				parms[16]=JO_orderList_line.get("skuQty");	
				parms[17]=JO_orderList_line.get("skuId");	
				parms[18]=JO_orderList_line.get("productPrice");	
				
				l_line++;
				
				parms[19]=l_line;
				parms[20]="N";
				
				 if(!this.executeUpdate(conn,sql,parms,false,JO_orderList_row.toString()))
				 {
					 isSuccess = false;
					 break;
				 }
			}
		}
		
		return isSuccess;
	}
			
	
   	//87-0009.Upload Sales Data By Store.
	private String uploadSalesDataByStore(String param,String brId) throws Exception
	{
		String erCode = "0",erMsg = "Query Data Success.";
		Hashtable hst = new Hashtable();
		try
		{
			if ("0.00}]}".equals(param.substring(param.length()-7)))
			{
				param=param.replaceAll("\"psle_num2\":\"0.00", "\"psle_num2\":\"0.00\"");
				LogUtil.info("Function uploadSalesDataByStore2: ",   "**********************************",true);
				LogUtil.info("Function uploadSalesDataByStore2: ",   "**********************************",true);
				LogUtil.info("########",   param,true);
				LogUtil.info("Function uploadSalesDataByStore2: ",   "**********************************",true);
				LogUtil.info("Function uploadSalesDataByStore2: ",   "**********************************",true);
			}
			
		    JSONArray dataPiv= getArray(param,"dataPiv");
		    JSONArray dataPsl= getArray(param,"dataPsl");
		    if((dataPiv == null || dataPiv.size() == 0) && (dataPsl == null || dataPsl.size() == 0))
		    {
		    	return this.getJson(hst,erCode,erMsg);
		    }
		    Connection conn = this.getConnection();
			List<Object> dPiv = insertDataPiv(conn,dataPiv);
			boolean sa = Boolean.parseBoolean(String.valueOf(dPiv.get(0)));
			boolean dPsl = insertDataPsl(conn,dataPsl);
			boolean dPs = insertDataPs(conn,getArray(param,"dataPs"));
			boolean dPivel = insertDataPive1(conn,getArray(param,"dataPive1"));
			boolean dPslel = insertDataPsle1(conn,getArray(param,"dataPsle1"));

			String billNo = String.valueOf(dPiv.get(1));
			java.sql.Date date = java.sql.Date.valueOf(String.valueOf(dPiv.get(2)));
			boolean dPivp = insertInvProcess(conn,brId,billNo,date);
			
			if(sa && dPsl&&dPs && dPivel && dPslel && dPivp)
			{
				transCommit(conn);
				closeConn(conn);
			}
			else
			{
				closeConn(conn);
	   	        erCode = "-1";
	   	        erMsg  = "Update Sales Data Failed.";
			
				if (!sa) 
				{
					erMsg  = erMsg+"|PIV";
				}
				
				if (!dPsl) 
				{
					erMsg  = erMsg+"|PSL";
				}
				
				if (!dPs) 
				{
					erMsg  = erMsg+"|PS";
				}
				
				if (!dPivel) 
				{
					erMsg  = erMsg+"|PIVE1";
				}
				
				if (!dPslel) 
				{
					erMsg  = erMsg+"|PSLE1";
				}
				
				if (!dPivp) 
				{
					erMsg  = erMsg+"|PIVP";
				}
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
	
	//save p_inv for sales data.
	private List<Object> insertDataPiv(Connection conn,JSONArray json) throws Exception
	{
		List<Object> list = new ArrayList<Object>();
		JSONObject dataPiv  = JSONObject.fromObject(json.get(0));
		String sql = "";

		sql = "delete from pos.p_sale where psl_bill_no = ? AND psl_br_id = ? AND psl_date = ? ";
		
		Object[] parmsDel = new Object[3];
		parmsDel[0]=dataPiv.get("piv_bill_no");          //VARCHAR2(6) 
		parmsDel[1]=dataPiv.get("piv_br_id");            //VARCHAR2(8)
		parmsDel[2]=parseToDate(dataPiv.get("piv_date"));//DATE
		
		if(!this.executeUpdate(conn,sql,parmsDel,false,dataPiv.toString()))
		{
			LogUtil.info("PSL处理:","删除失败",true); 
			//isSuccess = false;
			//break;
		}
		else
		{
			LogUtil.info("PSL处理:","删除成功",true); 
		}

		sql = "delete from pos.package_sale where ps_bill_no = ? AND ps_br_id = ? AND ps_date = ? ";
				
		if(!this.executeUpdate(conn,sql,parmsDel,false,dataPiv.toString()))
		{
			LogUtil.info("PS处理:","删除失败",true); 
			//isSuccess = false;
			//break;
		}
		else
		{
			LogUtil.info("PS处理:","删除成功",true); 
		}

		sql = "delete from pos.p_inv where piv_bill_no = ? AND piv_br_id = ? AND piv_date = ? ";
		
		if(!this.executeUpdate(conn,sql,parmsDel,false,dataPiv.toString()))
		{
			LogUtil.info("PIV处理:","删除失败",true); 
			//isSuccess = false;
			//break;
		}
		else
		{
			LogUtil.info("PIV处理:","删除成功",true); 
		}

		sql = "delete from pos.p_inv_ext1 where pive_bill_no = ? AND pive_br_id = ? AND pive_date = ? ";
		
		if(!this.executeUpdate(conn,sql,parmsDel,false,dataPiv.toString()))
		{
			LogUtil.info("PIVE1处理:","删除失败",true); 
			//isSuccess = false;
			//break;
		}
		else
		{
			LogUtil.info("PIVE1处理:","删除成功",true); 
		}

		sql = "delete from pos.p_sale_ext1 where psle_bill_no = ? AND psle_br_id = ? AND psle_date = ? ";
		
		if(!this.executeUpdate(conn,sql,parmsDel,false,dataPiv.toString()))
		{
			LogUtil.info("PSLE1处理:","删除失败",true); 
			//isSuccess = false;
			//break;
		}
		else
		{
			LogUtil.info("PSLE1处理:","删除成功",true); 
		}
		
		sql = "insert into pos.p_inv(piv_bill_no,piv_br_id,piv_date,piv_time,piv_emp,piv_zk_amt,piv_ys_amt,piv_rmb_zl,piv_rmb,piv_fe_flag,piv_fe_amt,"
			+"piv_fe_rmb,piv_dyq,piv_ykq,piv_dzhb_kh,piv_dzhb_emp,piv_dzhb,piv_yfk_no,piv_yfk,piv_zkk_no,piv_zkl,piv_zkk,piv_zp_no,piv_zp,piv_hyk_no,"
			+"piv_hyk_zkl,piv_hyk,piv_flag,piv_xs,piv_ms,piv_discount,piv_rl,piv_bzl) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		Object[] parms = new Object[33];
		parms[0]=dataPiv.get("piv_bill_no");   //VARCHAR2(6)
		parms[1]=dataPiv.get("piv_br_id");     //VARCHAR2(8)
		parms[2]=parseToDate(dataPiv.get("piv_date"));//DATE
		parms[3]=dataPiv.get("piv_time");      //VARCHAR2(8)
		parms[4]=dataPiv.get("piv_emp");       //VARCHAR2(6)
		parms[5]=Double.parseDouble(dataPiv.get("piv_zk_amt").toString());    //NUMBER(12,3)
		parms[6]=Double.parseDouble(dataPiv.get("piv_ys_amt").toString());    //NUMBER(12,3)
		parms[7]=Double.parseDouble(dataPiv.get("piv_rmb_zl").toString());    //NUMBER(12,3)
		parms[8]=Double.parseDouble(dataPiv.get("piv_rmb").toString());       //NUMBER(12,3)
		parms[9]=dataPiv.get("piv_fe_flag");   //VARCHAR2(3)
		parms[10]=Double.parseDouble(dataPiv.get("piv_fe_amt").toString());   //NUMBER(12,3)
		parms[11]=Double.parseDouble(dataPiv.get("piv_fe_rmb").toString());   //NUMBER(12,3)
		parms[12]=Double.parseDouble(dataPiv.get("piv_dyq").toString());      //NUMBER(12,3)
		parms[13]=Double.parseDouble(dataPiv.get("piv_ykq").toString());      //NUMBER(12,3)
		parms[14]=dataPiv.get("piv_dzhb_kh");  //VARCHAR2(20)
		parms[15]=dataPiv.get("piv_dzhb_emp"); //VARCHAR2(15)
		parms[16]=Double.parseDouble(dataPiv.get("piv_dzhb").toString());     //NUMBER(12,3)
		parms[17]=dataPiv.get("piv_yfk_no");   //VARCHAR2(15)
		parms[18]=Double.parseDouble(dataPiv.get("piv_yfk").toString());      //NUMBER(12,3)
		parms[19]=dataPiv.get("piv_zkk_no");   //VARCHAR2(15)
		parms[20]=Double.parseDouble(dataPiv.get("piv_zkl").toString());      //NUMBER(3,2)
		parms[21]=Double.parseDouble(dataPiv.get("piv_zkk").toString());     //NUMBER(12,3)
		parms[22]=dataPiv.get("piv_zp_no");    //VARCHAR2(20)
		parms[23]=Double.parseDouble(dataPiv.get("piv_zp").toString());       //NUMBER(12,3)
		parms[24]=dataPiv.get("piv_hyk_no");   //VARCHAR2(15)
		parms[25]=Double.parseDouble(dataPiv.get("piv_hyk_zkl").toString());  //NUMBER(3,2)
		parms[26]=Double.parseDouble(dataPiv.get("piv_hyk").toString());      //NUMBER(12,3)
		parms[27]=dataPiv.get("piv_flag");     //VARCHAR2(1)
		parms[28]=Double.parseDouble(dataPiv.get("piv_xs").toString());       //NUMBER(3)
		parms[29]=Double.parseDouble(dataPiv.get("piv_ms").toString());       //NUMBER(3)
		parms[30]=Double.parseDouble(dataPiv.get("piv_discount").toString()); //NUMBER(3,2)
		parms[31]=Double.parseDouble(dataPiv.get("piv_rl").toString());       //NUMBER(3,2)
		parms[32]=Double.parseDouble(dataPiv.get("piv_bzl").toString());      //NUMBER(12,3)
		
		boolean flag = this.executeUpdate(conn,sql,parms,false,dataPiv.toString());

			if(!flag)
			{
				LogUtil.info("PIV处理1:","插入失败",true); 
				LogUtil.info("PIV处理1:",String.valueOf(parseToDate(dataPiv.get("piv_date"))),true); 
			}
		
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
			String sql = "insert into pos.p_sale(psl_bill_no,psl_br_id,psl_date,psl_serial,psl_pro_id,psl_qty,psl_prc2,psl_prc1,psl_flag,psl_amt,psl_zs, "
					+"psl_st_code,psl_batch_num) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[13];
			parms[0]=dataPsl.get("psl_bill_no");     //VARCHAR2(6)
			parms[1]=dataPsl.get("psl_br_id");       //VARCHAR2(8)
			parms[2]=parseToDate(dataPsl.get("psl_date"));//DATE
			parms[3]=Double.parseDouble(dataPsl.get("psl_serial").toString());      //NUMBER(4)
			parms[4]=dataPsl.get("psl_pro_id");      //VARCHAR2(13)
			parms[5]=Double.parseDouble(dataPsl.get("psl_qty").toString());         //NUMBER(12,3)
			parms[6]=Double.parseDouble(dataPsl.get("psl_prc2").toString());        //NUMBER(12,3)
			parms[7]=Double.parseDouble(dataPsl.get("psl_prc1").toString());        //NUMBER(12,3)
			parms[8]=dataPsl.get("psl_flag");        //VARCHAR2(1)
			parms[9]=Double.parseDouble(dataPsl.get("psl_amt").toString());         //NUMBER(16,3)
			parms[10]=Double.parseDouble(dataPsl.get("psl_zs").toString());         //NUMBER(3,2)
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
			String sql = "insert into pos.package_sale(ps_br_id,ps_date,ps_bill_no,ps_serial,ps_pro_id,ps_qty,ps_type,ps_sale_pro_id) "
					      +" values(?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[8];
			parms[0]=dataPs.get("ps_br_id");              //VARCHAR2(8)
			parms[1]=parseToDate(dataPs.get("ps_date"));  //DATE
			parms[2]=dataPs.get("ps_bill_no");            //VARCHAR2(6)
			parms[3]=dataPs.get("ps_serial");             //VARCHAR2(6)
			parms[4]=dataPs.get("ps_pro_id");             //VARCHAR2(13)
			parms[5]=Double.parseDouble(dataPs.get("ps_qty").toString());                //NUMBER(12,4)
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
			String sql = "insert into pos.p_inv_ext1(pive_bill_no,pive_br_id,pive_date,pive_type,pive_varch1,pive_amt1,pive_amt2, "
					     +"pive_varch2,pive_varch3,pive_varch4,pive_varch5) values(?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[11];
			parms[0]=dataPive1.get("pive_bill_no");          //VARCHAR2(6) 
			parms[1]=dataPive1.get("pive_br_id");            //VARCHAR2(8)
			parms[2]=parseToDate(dataPive1.get("pive_date"));//DATE
			parms[3]=dataPive1.get("pive_type");             //VARCHAR2(20)
			parms[4]=dataPive1.get("pive_varch1");           //VARCHAR2(50)
			parms[5]=Double.parseDouble(dataPive1.get("pive_amt1").toString());             //NUMBER(12,3)
			parms[6]=Double.parseDouble(dataPive1.get("pive_amt2").toString());             //NUMBER(12,3)
			parms[7]=dataPive1.get("pive_varch2");           //VARCHAR2(255)
			parms[8]=dataPive1.get("pive_varch3");           //VARCHAR2(12)
			parms[9]=dataPive1.get("pive_varch4");           //VARCHAR2(12)
			parms[10]=dataPive1.get("pive_varch5");          //VARCHAR2(255)
			
			if(!this.executeUpdate(conn,sql,parms,false,dataPive1.toString()))
			{
				LogUtil.info("PIVE1处理:","插入失败",true); 
				isSuccess = false;
				break;
			}
			else
			{
				LogUtil.info("PIVE1处理:","插入成功",true); 
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
			String sql = "insert into pos.p_sale_ext1(psle_bill_no,psle_br_id,psle_date,psle_serial,psle_type,psle_pro_id,psle_char1, "
					+"psle_char2,psle_char3,psle_num1,psle_num2) values(?,?,?,?,?,?,?,?,?,?,?)";
			
			Object[] parms = new Object[11];
			parms[0]=dataPsle1.get("psle_bill_no");          //VARCHAR2(6)
			parms[1]=dataPsle1.get("psle_br_id");            //VARCHAR2(8) 
			parms[2]=parseToDate(dataPsle1.get("psle_date"));//DATE
			parms[3]=Double.parseDouble(dataPsle1.get("psle_serial").toString());           //NUMBER(3)
			parms[4]=dataPsle1.get("psle_type");             //VARCHAR2(20)
			parms[5]=dataPsle1.get("psle_pro_id");           //VARCHAR2(13)
			parms[6]=dataPsle1.get("psle_char1");            //VARCHAR2(30) 
			parms[7]=dataPsle1.get("psle_char2");            //VARCHAR2(30)
			parms[8]=dataPsle1.get("psle_char3");            //VARCHAR2(30)
			parms[9]=Double.parseDouble(dataPsle1.get("psle_num1").toString());             //NUMBER(8,2)
			parms[10]=Double.parseDouble(dataPsle1.get("psle_num2").toString());            //NUMBER(8,2)
			
			if(!this.executeUpdate(conn,sql,parms,false,dataPsle1.toString()))
			{
				isSuccess = false;
				break;
			}
		}
		return isSuccess;
	}
	
	//After upload sales data,insert p_inv_process table.
	private boolean insertInvProcess(Connection conn,String brId,String billNo,java.sql.Date date)
	{
		boolean isSuccess = false;
		String sql = "select count(*) as cc from pos.p_inv_process where pivp_br_id = ? and pivp_bill_no = ? and pivp_date = ?"; 
		list = this.query(sql,new Object[]{brId,billNo,date});
		
		if(list != null && list.size() > 0)
		{
			int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
			if(isValue == 0)
			{
				sql = "insert into pos.p_inv_process(pivp_bill_no,pivp_br_id,pivp_date,pivp_stock1,pivp_mem1,pivp_bi1,pivp_sync_date) values(?,?,?,?,?,?,?)";
				Object[] parms = new Object[7];
				parms[0] = billNo;
			    parms[1] = brId;
	    		parms[2] = date;
   				parms[3] = "NNNNNNNNNN";
				parms[4] = "NNNNNNNNNN"; 
				parms[5] = "NNNNNNNNNN";
				parms[6] = new java.sql.Date(System.currentTimeMillis());
				boolean flag = this.executeUpdate(conn,sql,parms,false,sql);
				if(!flag)
				{  
					this.recordExcInfo("insertInvProcess",WsConstant.WS_SAVE_DATA,billNo+"||"+brId+"||"+StringUtil.date2Str(date));
					LogUtil.info("Function insertInvProcess: ",WsConstant.WS_SAVE_DATA,true);
					isSuccess = false;
				}
				else
				{
					isSuccess = true;
				}
			}
		}
		return isSuccess;
	}
	
	
	
	//87-0001.get Upload Sale Record. //param="{\"data\":[{\"piv_bill_no\":\"010059\",\"piv_date\":\"20140825\"}]}";
	private String getSalesRecordByStore(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select (select count(*) from pos.p_inv where piv_br_id = ? and piv_date = ? and piv_bill_no = ? ) as piv_hq, "
					+"(select count(*) from pos.p_sale where psl_br_id = ? and psl_date = ? and psl_bill_no = ? ) as psl_hq, "
					+"(select  count(*) from pos.package_sale where ps_br_id = ? and ps_date = ? and ps_bill_no  = ? ) as ps_hq, "
					+"(select  count(*) from pos.p_inv_ext1 where pive_br_id  = ? and pive_date = ? and pive_bill_no= ? ) as pive1_hq, "
					+"(select count(*) from pos.p_sale_ext1 where psle_br_id  = ? and psle_date = ? and psle_bill_no= ? ) as psle1_hq  "
					+"from pos.system_var";
		}
		else
		{
			sql = "select (select count(*) from pos.p_inv where piv_br_id = ? and piv_date = ? and piv_bill_no = ? ) as piv_hq, "
				 +"(select count(*) from pos.p_sale where psl_br_id = ? and psl_date = ? and psl_bill_no = ? ) as psl_hq, "
				 +"(select  count(*) from pos.package_sale where ps_br_id = ? and ps_date = ? and ps_bill_no  = ? ) as ps_hq, "
				 +"(select  count(*) from pos.p_inv_ext1 where pive_br_id  = ? and pive_date = ? and pive_bill_no= ? ) as pive1_hq, "
				 +"(select count(*) from pos.p_sale_ext1 where psle_br_id  = ? and psle_date = ? and psle_bill_no= ? ) as psle1_hq  "
				 +"from dual";
		}
		
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


	//cz_crm_mem_attr	//param="{\"data\":[{\"memNo\":\"80000008\",\"memMp\":\"13523923920\",\"memTel\":\"02310900111\",\"memName\":\"张三\"}]}";
	private String cz_crm_mem_attr(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String lsMemNo="";
		String lsMemMp="";
		String lsMemTel="";
		String lsMemName="";
		String sql="";
		Integer	liCount=0;

		try
		{
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			
			lsMemNo = String.valueOf(jsonObj.get("memNo"));
			lsMemMp = String.valueOf(jsonObj.get("memMp"));
			lsMemTel = String.valueOf(jsonObj.get("memTel"));
			lsMemName = String.valueOf(jsonObj.get("memName"));
			
			if (StringUtil.isEmpty(lsMemNo))
			{
				liCount	= liCount+1;
			}
			
			if (StringUtil.isEmpty(lsMemMp))
			{
				liCount	= liCount+1;
			}
			
			if (StringUtil.isEmpty(lsMemTel))
			{
				liCount	= liCount+1;
			}
			
			if (StringUtil.isEmpty(lsMemName))
			{
				liCount	= liCount+1;
			}
			
		   //LogUtil.info("liCount=",String.valueOf(liCount),true);

			if (liCount >= 3)
			{
				if (!StringUtil.isEmpty(lsMemNo))
				{
					sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
							+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
							+"where mc.mc_id = ?  and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
					list = this.query(sql,new Object[]{lsMemNo});
				}
				else
				{
					if (!StringUtil.isEmpty(lsMemMp))
					{
						sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
								+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
								+"where mp.mp_mobile_phone = ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
						list = this.query(sql,new Object[]{lsMemMp});
					}
					else
					{
						if (!StringUtil.isEmpty(lsMemTel))
						{
							sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
									+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
									+"where nvl(mp.mp_tel,'-') = ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
							list = this.query(sql,new Object[]{lsMemTel});
						}
						else
						{
							sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
									+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
									+"where mp.mp_name = ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
							list = this.query(sql,new Object[]{lsMemName});
						}
					}
				}
			}
			else
			{
				if (StringUtil.isEmpty(lsMemNo))
				{
					lsMemNo	= "%";
				}
				
				if (StringUtil.isEmpty(lsMemMp))
				{
					lsMemMp	= "%";
				}
				
				if (StringUtil.isEmpty(lsMemTel))
				{
					lsMemTel	= "%";
				}
				
				if (StringUtil.isEmpty(lsMemName))
				{
					lsMemName	= "%";
				}
				sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
						+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
						+"where mc.mc_id like ?  and mp.mp_mobile_phone like ? and nvl(mp.mp_tel,'-') like ? and mp.mp_name like ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
				list = this.query(sql,new Object[]{lsMemNo,lsMemMp,lsMemTel,lsMemName});
			}


		   //LogUtil.info("sql=",sql,true);
		   //LogUtil.info("lsMemNo=",lsMemNo,true);
		   //LogUtil.info("lsMemMp=",lsMemMp,true);
		   //LogUtil.info("lsMemTel=",lsMemTel,true);
		   //LogUtil.info("lsMemName=",lsMemName,true);

					

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


	//cz_crm_mem_attr_rand-随机获取会员	//param="{\"data\":[{\"data\":[{\"memNo\":"13523923920","memMp":"","memTel":"","memName":""}]}]}";
	private String cz_crm_mem_attr_rand(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String lsCardId="";
		String lsQueryId="";
		String sql="";
		int isValue=0;

		try
		{
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			lsQueryId = String.valueOf(jsonObj.get("memNo"));

			//and mp_name <> '?'
			sql ="SELECT mp_id,mp_personal_id FROM pos.mem_personal SAMPLE (1) WHERE ROWNUM = 1  and mp_personal_id <> mp_id and mp_personal_id is not null and mp_personal_id not in ( '-','?','+',' ','-*','.-','-+','-.')";
		   //LogUtil.info("lsQueryId=",lsQueryId,true);
		   //LogUtil.info("sql=",sql,true);

			list = this.query(sql);
			if(list != null && list.size() >0)
			{
				lsCardId = String.valueOf(list.get(0).get("mp_id"));				
			}

			if (!StringUtil.isEmpty(lsCardId))
			{
					sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id "
							+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br  "
							+"where mp.mp_mobile_phone = ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id ";
					list = this.query(sql,new Object[]{lsCardId});
			}

		}
		catch(Exception ex)
		{
		   erCode = "0";
		   erMsg   = "No Record.";
		   hst.put("data",new ArrayList());
		   LogUtil.info("Function czCrmMemAttrRand: ",ex.toString(),true);
		   return this.getJson(hst,erCode,erMsg);
		}
		
		hst.put("data",list);
		return this.getJson(hst,erCode,erMsg);
	}



	//cz_crm_mem_attr_single	//param="{\"data\":[{\"query_id\":\"00000001\"}]}";
	private String cz_crm_mem_attr_single(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String lsCardId="";
		String lsQueryId="";
		String sql="";
		int isValue=0;

		try
		{
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			lsQueryId = String.valueOf(jsonObj.get("query_id"));

			sql ="select count(*) as cc from pos.mem_card where mc_id = ?";
		   //LogUtil.info("lsQueryId=",lsQueryId,true);
		   //LogUtil.info("sql=",sql,true);

			list = this.query(sql,new Object[]{lsQueryId});
			if(list != null && list.size() >0)
			{
				isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
				if(isValue > 0)
				{
					lsCardId = lsQueryId;
		  			//LogUtil.info("lsCardId=inputcardid",lsCardId,true);
				}
				else
				{
					sql ="select count(*) as cc from pos.mem_personal where mp_mobile_phone = ?";
					
					list = this.query(sql,new Object[]{lsQueryId});
					if(list != null && list.size() >0)
					{
						isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
							
						if(isValue > 0)
						{
							sql ="select max(mc_id) as mc_id from pos.mem_personal,pos.mem_card where mp_mobile_phone = ? and mp_id = mc_mem_id";
							
							list = this.query(sql,new Object[]{lsQueryId});
							if(list != null && list.size() >0)
							{
								lsCardId = String.valueOf(list.get(0).get("mc_id"));
								//LogUtil.info("lsCardId=inputMobilePhone",lsCardId,true);
							}
						}
						else
						{
							
							list = new ArrayList();
						}
					}
				}
			}

			if (!StringUtil.isEmpty(lsCardId))
			{
					sql ="select mc.mc_id as mem_card_id,mc.mc_mem_id as mem_id,mp.mp_name as mem_name,mp.mp_sum_amount as mem_amt,mp.mp_sum_pot as mem_pot,mp.mp_mobile_phone as mp_mobile_phone,mc.mc_class as mem_class,mcl.mcl_name as mem_class_name,mc_table_status as mem_valid_flag,to_char(mp.mp_birth,'yyyy/mm/dd') as mp_birth,mp.mp_discount_flag as mp_discount_flag,mp.mp_personal_id,mp.mp_sex,mp.mp_address,br.br_prior,mp.mp_br_id  "
							+"from pos.mem_card mc,pos.mem_personal mp,pos.mem_class mcl,pos.branch br "
							+"where mc.mc_id = ? and mc.mc_mem_id = mp.mp_id and mc.mc_class = mcl.mcl_id and mp.mp_br_id = br.br_id  ";
					//LogUtil.info("lsCardId3=",lsCardId,true);
					list = this.query(sql,new Object[]{lsCardId});
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
	    String sql = "insert into pos.sys_transfer(st_br_id,st_date,st_type,st_filedata,st_process,st_send_date,st_send_user) values(?,?,?,empty_blob(),?,?,?)";
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
			//ORACLE FOR UPDATE可以,SYBASE不行
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
	            sql = "update pos.sys_transfer set st_filedata = ? where st_br_id = ? and st_date = ? and st_type = ?";
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
	private String getUpgradeFile(String dbType,String brId,HttpServletRequest request) throws Exception
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String baseUrl= request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath();
       	String url = baseUrl + "/api/b2c/files/";
		//step1 get upgrade task no.
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql ="select sgp_task_id,convert(char(10),sgp_valid_date,111) as sgp_valid_date,sgp_version,sgp_input_user,convert(char(10),sgp_input_date,111)||' '||convert(char(8),sgp_input_date, 8) as sgp_input_date, "
				+"sgp_audit_user,convert(char(10),sgp_audit_date,111)||' '||convert(char(8),sgp_input_date, 8) as sgp_audit_date,sgp_status "
				+"from pos.sys_goup_plan,pos.sys_goup_branch "
				+"where sgp_task_id = sgb_task_id and sgp_status = '1' and sgb_sync_flag = 'N' "
				+"and sgb_br_id = ?  and rownum =1 order by sgp_valid_date ";
		}
		else
		{
			sql ="select sgp_task_id,to_char(sgp_valid_date,'yyyy/mm/dd') as sgp_valid_date,sgp_version,sgp_input_user,to_char(sgp_input_date,'yyyy/mm/dd HH24:mm:ss') as sgp_input_date, "
				+"sgp_audit_user,to_char(sgp_audit_date,'yyyy/mm/dd HH24:mm:ss') as sgp_audit_date,sgp_status "
				+"from pos.sys_goup_plan,pos.sys_goup_branch "
				+"where sgp_task_id = sgb_task_id and sgp_status = '1' and sgb_sync_flag = 'N' "
				+"and sgb_br_id = ?  and rownum =1 order by sgp_valid_date ";
		}
		
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
	       		this.updateSyncData(dbType,brId, fileName);
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
	private String getPrice(String dbType,String param,String brId)
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
					if("SYBASE".equals(dbType)) 
					{
						sql ="select prc_pro_id,prc_retail_price1,prc_retail_price2,prc_member_price1,prc_member_price2,convert(char(10),prc_start_date,111) as prc_start_date "
							+"from pos.price_header ph,pos.price_detail_product pd "
							+"where ph.prc_id = pd.prc_id and ph.prc_id = ? ";
					}
					else
					{
						sql ="select prc_pro_id,prc_retail_price1,prc_retail_price2,prc_member_price1,prc_member_price2,to_char(prc_start_date,'yyyy/mm/dd') as prc_start_date "
							+"from pos.price_header ph,pos.price_detail_product pd "
							+"where ph.prc_id = pd.prc_id and ph.prc_id = ? ";
					}

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



	//86-1005.get changing PGI.  //param="{\"data\":[{\"pgi_id\":\"PM1408999980002\"}]}";
	private String getPromotionGift(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		try
		{
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			String sql ="select count(*) as cc from pos.promotion_gift_branch where pgb_id = ? and pgb_br_id = ? ";
			list = this.query(sql,new Object[]{jsonObj.get("pgi_id"),brId});
			if(list != null && list.size() >0)
			{
				int isValue = Integer.parseInt(String.valueOf(list.get(0).get("cc"))) ;
				if(isValue > 0)
				{
					if("SYBASE".equals(dbType)) 
					{
						sql ="select pgi_rowno,pgi_con_amt1,pgi_pro_id,pgi_price,pgi_qty,pgi_mode,convert(char(10),pgi_sdate, 111) as pgi_sdate,"
							+"convert(char(10),pgi_edate, 111) as pgi_edate,pgi_con_type,pgi_con_id,pgi_con_mp1,pgi_res_mode,pgi_res_type,pgi_valid  "
							+"from pos.promotion_gift ph "
							+"where ph.pgi_id = ? ";
					}
					else
					{
						sql ="select pgi_rowno,pgi_con_amt1,pgi_pro_id,pgi_price,pgi_qty,pgi_mode,to_char(pgi_sdate,'yyyy/mm/dd') as pgi_sdate,"
							+"to_char(pgi_edate,'yyyy/mm/dd') as pgi_edate,pgi_con_type,pgi_con_id,pgi_con_mp1,pgi_res_mode,pgi_res_type,pgi_valid  "
							+"from pos.promotion_gift ph "
							+"where ph.pgi_id = ? ";
					}
					list = this.query(sql,new Object[]{jsonObj.get("pgi_id")});
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
	private String api_Mkt_QueryPmList(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select pnh_id,convert(char(10),pnh_start_date,111) as pnh_start_date,convert(char(10),pnh_end_date,111) as pnh_end_date,pnh_pm_code, "
		             +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,convert(char(10),pnh_plan_end,111) as pnh_plan_end,pnh_memo "
		             +"from pos.promotion_header,pos.promotion_mix where pnh_start_date >=? and pnh_start_date <= ? and pnh_pm_code = pm_code ";
		}
		else
		{
			sql = "select pnh_id,to_char(pnh_start_date,'yyyy/mm/dd') as pnh_start_date,to_char(pnh_end_date,'yyyy/mm/dd') as pnh_end_date,pnh_pm_code, "
		             +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,to_char(pnh_plan_end,'yyyy/mm/dd') as pnh_plan_end,pnh_memo "
		             +"from pos.promotion_header,pos.promotion_mix where pnh_start_date >=? and pnh_start_date <= ? and pnh_pm_code = pm_code ";
		}


		list = this.query(sql,new Object[]{jsonObj.get("QuerySDate"),jsonObj.get("QueryEDate")});
		hst.put("data", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	
   //86-1003. get promotion plan. //param="{\"data\":[{\"pm_id\":\"CX16020011\"}]}";
   //分三PART返回
   private String getPromotionPlan2012_3p(String dbType,String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			String sql = "";
			
			if("SYBASE".equals(dbType)) 
			{
				sql = "select pnh_id,convert(char(10),pnh_start_date,111) as pnh_start_date,convert(char(10),pnh_end_date,111) as pnh_end_date,pnh_pm_code, "
					 +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,convert(char(10),pnh_plan_end,111) as pnh_plan_end,pnh_memo "
					 +"from pos.promotion_header,pos.promotion_mix where pnh_id =? and pnh_pm_code = pm_code ";
			}
			else
			{
				sql = "select pnh_id,to_char(pnh_start_date,'yyyy/mm/dd') as pnh_start_date,to_char(pnh_end_date,'yyyy/mm/dd') as pnh_end_date,pnh_pm_code, "
					 +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,to_char(pnh_plan_end,'yyyy/mm/dd') as pnh_plan_end,pnh_memo "
					 +"from pos.promotion_header,pos.promotion_mix where pnh_id =? and pnh_pm_code = pm_code ";
			}

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
	
	
	
   //86-1003. get promotion plan. //param="{\"data\":[{\"pm_id\":\"CX16020011\"}]}";
   private String getPromotionPlan2012(String dbType,String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		   
			String sql = "";
			
			if("SYBASE".equals(dbType)) 
			{
				sql = "select pnh_id,convert(char(10),pnh_start_date,111) as pnh_start_date,convert(char(10),pnh_end_date,111) as pnh_end_date,pnh_pm_code, "
					 +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,convert(char(10),pnh_plan_end,111) as pnh_plan_end,pnh_memo "
					 +"from pos.promotion_header,pos.promotion_mix where pnh_id =? and pnh_pm_code = pm_code ";
			}
			else
			{
				sql = "select pnh_id,to_char(pnh_start_date,'yyyy/mm/dd') as pnh_start_date,to_char(pnh_end_date,'yyyy/mm/dd') as pnh_end_date,pnh_pm_code, "
					 +"pm_apply_to,pm_remark,pnh_level,pnh_time_valid,pnh_time_start,pnh_time_end,to_char(pnh_plan_end,'yyyy/mm/dd') as pnh_plan_end,pnh_memo "
					 +"from pos.promotion_header,pos.promotion_mix where pnh_id =? and pnh_pm_code = pm_code ";
			}



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
   private String getPromotionPlan(String dbType,String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

			String sql = "";
			
			if("SYBASE".equals(dbType)) 
			{
				
				sql = "select pph_name,convert(char(10),pph_date_start,111) as pph_date_start,convert(char(10),pph_date_end,111) as pph_date_end,pph_date_cancel,pph_time_valid,pph_time_start, "
					 +"pph_time_end,pph_pm_type,pph_pm_priority,pph_pm_customer,pph_mem_class, pph_campaign_id,pph_reward_mode,pph_pm_status, pph_pop_desc,pph_sale_desc "
					 +"from pos.pm_plan_header where pph_pm_id =? ";
			}
			else
			{
				sql = "select pph_name,to_char(pph_date_start,'yyyy/mm/dd') as pph_date_start,to_char(pph_date_end,'yyyy/mm/dd') as pph_date_end,pph_date_cancel,pph_time_valid,pph_time_start, "
					 +"pph_time_end,pph_pm_type,pph_pm_priority,pph_pm_customer,pph_mem_class, pph_campaign_id,pph_reward_mode,pph_pm_status, pph_pop_desc,pph_sale_desc "
					 +"from pos.pm_plan_header where pph_pm_id =? ";
			}


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
	private String getProduct(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		try
		{
			JSONObject jsonObj=JSONObject.fromObject(this.getArray(param,"data").get(0));
			String sql = "";
			
			if("SYBASE".equals(dbType)) 
			{
				sql = "select pro_name, pro_sname,pro_spec,pro_unit,pro_normal_price,pro_change_price, "   
					+ "pro_discount,pro_packet_compose,pro_print_code,pro_class,pro_city,pro_unit_cost, "
					+ "pro_pym,pro_table_status ,pro_brand,pro_supplier,pro_register_no,pro_special_code, "
					+ "pro_factory, 0 as ldec_ext_n1,0 as ldec_ext_n2,0 as ldec_ext_n3, "
					+ "pa_old_id,pa_class1,pa_style,pas_name,vpa_attr, "
					+ "isnull((select st_normal_price from pos.store where  st_br_id= ? and st_pro_id = ?),pro_normal_price) as st_normal_price, "
					+ "isnull((select st_mem_price from pos.store where  st_br_id=? and st_pro_id = ?),0) as st_mem_price  "
					+ "from pos.product,pos.product_attr,pos.product_attr_set,pos.view_product_attr where "
					+ "pro_id *= pa_pro_id and pa_style *= pas_id  and pa_pro_id *= vpa_pro_id and  pro_id=? ";
			}
			else
			{
				sql = "select pro_name, pro_sname,pro_spec,pro_unit,pro_normal_price,pro_change_price, "   
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
			}
			
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
	private String getTransferData(String dbType,String brId,int brRow)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		//step1:change flag to W.
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "update pos.data_transfer_sync set dts_flag='W' where dts_org_id = ? and dts_flag = 'N' ";
		}
		else
		{
			// and rownum < ?  or   and rownum < 200
			sql = "update pos.data_transfer_sync set dts_flag='W' where dts_org_id = ? and dts_flag = 'N' ";
		}

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
	private String getMobilePayAccount(String dbType,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select '支付**SQB商户ID**'||bap_store_id || '||支付**SQB_APP_ID**'||bap_app_id || '||支付**SQB_APP_KEY**'||bap_app_key as paySet " 
				+"from pos.branch_attr_pay where bap_id = ? ";
		}
		else
		{
			sql = "select concat('支付**SQB商户ID**', bap_store_id) || concat('||支付**SQB_APP_ID**',bap_app_id) || concat('||支付**SQB_APP_KEY**',bap_app_key) as paySet " 
				+"from pos.branch_attr_pay where bap_id = ? ";
		}

		list = this.query(sql,new Object[]{brId});
		if(list != null && list.size() > 0)
		{
			sql = "update pos.branch_attr_pay set bap_sync_date = sysdate where bap_id = ? ";
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
		sql = "update pos.branch_attr set bra_ext_c09 = ?,bra_ext_c10= ? where bra_id = ?";
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
	private String getDataBaseTime(String dbType)
    {
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "";
		
		if (1==2)
		{
			if("SYBASE".equals(dbType)) 
			{
				sql = "select convert(char(10),getdate(), 111)||' '||convert(char(8),getdate(), 8) as time from pos.system_var";
			}
			else
			{
				sql = "select to_char(sysdate,'yyyy-mm-dd hh24:mm:ss') as time from dual";
			}
		}
		else
		{
			if("SYBASE".equals(dbType)) 
			{
				sql = "select '2099/12/31 '||convert(char(8),getdate(), 8) as time from pos.system_var";
			}
			else
			{
				sql = "select '2099/12/31 '||to_char(sysdate,'hh24:mm:ss') as time from dual";
			}
		}

		list = this.query(sql);
		
		hst.put("data", list);
		return this.getJson(hst,erCode,erMsg);
	}
	    
	//01-0000.Get BrList from ws.
	private String getDataBaseBrList()
    {
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql = "select br_id as br_id,br_name as br_name from pos.branch";
		list = this.query(sql);
		
		hst.put("data", list);
		return this.getJson(hst,erCode,erMsg);
	}


 	
   //09-0002. member pot query //param="{\"data\":[{\"memNo\":\"0200001\"}]}";
   private String getMemPotQuery(String dbType,String param,String brId)
   {
	   Hashtable hst = new Hashtable();
	   String erCode = "0",erMsg = "Query Data Success.";
	   try
	   {
			JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
			String sql = "";
			
			if("SYBASE".equals(dbType)) 
			{
				sql = "select mc_mem_id,mc_table_status,mp_br_id,mp_name,mp_personal_id,convert(char(10),mp_birth, 111) as mp_birth, "
					+ "mp_tel,mp_address,mp_mobile_phone "
					+"from pos.mem_card,pos.mem_personal where mc_id = ? and mp_id =mc_mem_id ";
			}
			else
			{
				sql = "select mc_mem_id,mc_table_status,mp_br_id,mp_name,mp_personal_id,to_char(mp_birth,'yyyy/mm/dd') as mp_birth, "
					+ "mp_tel,mp_address,mp_mobile_phone "
					+"from pos.mem_card,pos.mem_personal where mc_id = ? and mp_id =mc_mem_id ";
			}
			
						 
						 
		    list = this.query(sql,new Object[]{jsonObj.get("memNo")});
			if(null == list || list.size() == 0)
			{
				erCode = "0";
				erMsg   = "No Record.";
				hst.put("data",new ArrayList());
			}
			else
			{
				hst.put("dataH",list);//mem attr
				
			
				if("SYBASE".equals(dbType)) 
				{
					sql = "SELECT "
							+"		'-' mtx_type, "
							+"		mth_br_id,    "
							+"		convert(char(10),mth_tx_date, 111) as mth_tx_date,  "  
							+"		mth_type,    "
							+"		mth_tx_amt,   " 
							+"		mth_tx_pot,  "
							+"		mth_tx_prepay, "
							+"		mth_tx_buy_times, "
							+"		mth_voucher_id "
						+"FROM		pos.mem_transaction_header   "
						+"WHERE		mth_card_id like ? 	AND "
						+"			mth_type		NOT IN ('04','05','06','07')  "
						+"union all "
						+"SELECT "
						+"			'+' mtx_type, "
						+"			mth_br_id,    "
						+"			convert(char(10),mth_tx_date, 111) as mth_tx_date,    "
						+"			mth_type,    "
						+"			mth_tx_amt,    "
						+"			mth_tx_pot,  "
						+"			mth_tx_prepay, "
						+"			mth_tx_buy_times, "
						+"			mth_voucher_id "
						+"FROM		pos.mem_transaction_header   "
						+"WHERE		mth_card_id like ? 	AND "
						+"			mth_type		IN  ('04','05','06','07') "
						+"union all "
						+"SELECT '+' mtx_type, "
						+"			mts_br_id, "
						+"			convert(char(10),mts_tx_date, 111) as mts_tx_date, "
						+"			'00' mth_type, "
						+"			mts_total_amt, "
						+"			mts_total_pot, "
						+"			0, "
						+"			0, "
						+"			'               '   mth_voucher_id "
						+"	FROM	pos.mem_tx_summary, "
						+"			pos.mem_card  "
						+"	WHERE	mts_mem_id = mc_mem_id and "
						+"			mc_id like ? ";
				}
				else
				{
					sql = "SELECT "
							+"		'-' mtx_type, "
							+"		mth_br_id,    "
							+"		to_char(mth_tx_date,'yyyy/mm/dd') as mth_tx_date,  "  
							+"		mth_type,    "
							+"		mth_tx_amt,   " 
							+"		mth_tx_pot,  "
							+"		mth_tx_prepay, "
							+"		mth_tx_buy_times, "
							+"		mth_voucher_id "
						+"FROM		pos.mem_transaction_header   "
						+"WHERE		mth_card_id like ? 	AND "
						+"			mth_type		NOT IN ('04','05','06','07')  "
						+"union all "
						+"SELECT "
						+"			'+' mtx_type, "
						+"			mth_br_id,    "
						+"			to_char(mth_tx_date,'yyyy/mm/dd') as mth_tx_date,    "
						+"			mth_type,    "
						+"			mth_tx_amt,    "
						+"			mth_tx_pot,  "
						+"			mth_tx_prepay, "
						+"			mth_tx_buy_times, "
						+"			mth_voucher_id "
						+"FROM		pos.mem_transaction_header   "
						+"WHERE		mth_card_id like ? 	AND "
						+"			mth_type		IN  ('04','05','06','07') "
						+"union all "
						+"SELECT '+' mtx_type, "
						+"			mts_br_id, "
						+"			to_char(mts_tx_date,'yyyy/mm/dd') as mts_tx_date, "
						+"			'00' mth_type, "
						+"			mts_total_amt, "
						+"			mts_total_pot, "
						+"			0, "
						+"			0, "
						+"			'               '   mth_voucher_id "
						+"	FROM	pos.mem_tx_summary, "
						+"			pos.mem_card  "
						+"	WHERE	mts_mem_id = mc_mem_id and "
						+"			mc_id like ? ";
				}
															
				list = this.query(sql,new Object[]{jsonObj.get("memNo"),jsonObj.get("memNo"),jsonObj.get("memNo")});
				hst.put("dataP",list); //mem pot list
			}
	   }
	   catch(Exception ex)
	   {
		 erCode = "0";
		 erMsg   = "No Record.";
		 hst.put("data",new ArrayList());
		 LogUtil.info("Function getMemPotQuery: ",ex.toString(),true);
	     return this.getJson(hst,erCode,erMsg);
	   }
	   
		return this.getJson(hst,erCode,erMsg);
   }
	    
	
   	//09-0001 change mem pot
	private String uploadMemPotChange(String param,String brId) throws Exception
	{
		String erCode = "0",erMsg = "Query Data Success.";
		Hashtable hst = new Hashtable();
		try
		{
		    Connection conn = this.getConnection();
		    JSONArray dataPot= getArray(param,"data");
		    if((dataPot == null || dataPot.size() == 0) )
		    {
		    	return this.getJson(hst,erCode,erMsg);
		    }

			JSONObject dataPotChange  = JSONObject.fromObject(dataPot.get(0));
			String sql ="insert into pos.mem_transaction_header(mth_br_id,mth_tx_date,mth_voucher_id,mth_card_id,mth_type,mth_tx_amt,mth_tx_count,mth_tx_pot,"
					+"mth_update_user,mth_update_date,mth_flag) "
					+"values(?,?,?,?,?,0,0,?,?,?,?)";
			
			
			//"data":[{"memNo":"' + fs_card_id + '","BranchId":"' + fs_br_id + '","SaleDate":"' + string(fdt_sale_date,'YYYYMMDD') + '","VoucherId":"' + fs_voucher_id + 
			//'","UseType":"' + fs_type + '","UsePot":' + string(fdec_tx_pot,'0.000') + ',"UseOperator":"' + fs_user_id + '","UseTime":"' + string(fdt_use_time,'YYYYMMDD') + 
			//'","UseFlag":"' + fs_use_flag + '"}]}
			Object[] parms = new Object[9];
			parms[0]=dataPotChange.get("BranchId");   					//mth_br_id
			parms[1]=parseToDate(dataPotChange.get("SaleDate"));     	//mth_tx_date
			parms[2]=dataPotChange.get("VoucherId");					//mth_voucher_id
			parms[3]=dataPotChange.get("memNo");      //mth_card_id
			parms[4]=dataPotChange.get("UseType");       //mth_type
			parms[5]=dataPotChange.get("UsePot");    //mth_tx_pot
			parms[6]=dataPotChange.get("UseOperator");    //mth_update_user
			parms[7]=parseToDate(dataPotChange.get("UseTime"));    //mth_update_date
			parms[8]=dataPotChange.get("UseFlag");       //mth_flag
			
			boolean flag = this.executeUpdate(conn,sql,parms,false,dataPotChange.toString());
				
			if(flag)
			{
				transCommit(conn);
			}
			else
			{
				closeConn(conn);
				LogUtil.info("Function recordErrorInfo: ",WsConstant.RECORD_ERROR_INFO ,true);
	   	        erCode = "-2";
	   	        erMsg  = "Update Mem Pot Change Failed.";
			}
		}
		catch(Exception ex)
		{
			erCode = "-1";
   	        erMsg  = "Update Mem Pot Change Failed.";
			//this.recordExcInfo("uploadSalesDataByStore",WsConstant.WS_SAVE_DATA,ex.toString());
			LogUtil.info("Function uploadMemPotChange: ",WsConstant.WS_SAVE_DATA + ex.toString(),true);
		}

		return this.getJson(hst,erCode,erMsg);
	}




	private String api_Mkt_PushMsgList(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql;
		String sql2;
		boolean flag;
		
		//brId = "0001";
		

		//step1:change flag to W.
		//String sql = "update pos.crm_push_msg_list set crm_pml_sync_flag ='W' where crm_pml_sync_flag = 'N' and rownum < ? ";
		//System.out.println("a...........................................................................");
		sql = "update pos.crm_push_msg_list set crm_pml_sync_flag ='W' where crm_pml_sync_flag = 'N' and '**' <> ? ";
        
		try
		{

   		 flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
			return "error";//临时测试。。。。。。。。。。。。。。。。
		}
		//if(1==1)return "ssssss";//测试
  		//System.out.println("b...........................................................................");
 		//System.out.println(brId);

		if(!flag)
   		{
   			erCode = "-3";
   	        erMsg  = "Update pos.crm_push_msg_list to W Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}
		
   		
		// or crm_pml_sync_flag='Y' test add this to return all data
		if("SYBASE".equals(dbType)) 
		{
			sql = "select crm_pml_id as MsgId,crm_pml_title as MsgTitle,crm_pml_apply_to as MsgToMemId,crm_pml_weixin as WeiXinId,crm_pml_other_id as OtherId,"
				+ "crm_pml_type as TypeId,convert(char(10),crm_pml_send_time, 111)||' '||convert(char(8),crm_pml_send_time, 8) as SendTime,crm_pml_content1 as MsgContent1,crm_pml_content2 as MsgContent2, "
				+ "crm_pml_content3 as MsgContent3,crm_pml_content4 as MsgContent4,crm_pml_amt as MsgAmt,crm_pml_qty as MsgQty "
				+ "from pos.crm_push_msg_list where crm_pml_sync_flag='W'";
		}
		else
		{
			sql = "select crm_pml_id as MsgId,crm_pml_title as MsgTitle,crm_pml_apply_to as MsgToMemId,crm_pml_weixin as WeiXinId,crm_pml_other_id as OtherId,"
				+ "crm_pml_type as TypeId,to_char(crm_pml_send_time,'yyyy/mm/dd hh24:mm:ss') as SendTime,crm_pml_content1 as MsgContent1,crm_pml_content2 as MsgContent2, "
				+ "crm_pml_content3 as MsgContent3,crm_pml_content4 as MsgContent4,crm_pml_amt as MsgAmt,crm_pml_qty as MsgQty "
				+ "from pos.crm_push_msg_list where crm_pml_sync_flag='W'";
		}
					
		//sql = "select br_id,br_name,br_come_under from pos.branch where br_id = ?";
		//sql = "select crm_pml_id as MsgId,crm_pml_title as MsgTitle,crm_pml_apply_to as MsgToMemId,crm_pml_amt from pos.crm_push_msg_list";

		//list = this.query(sql,new Object[]{brId});
  		list = this.query(sql);
  		
   		//step3:change flag to Y
   		sql = "update pos.crm_push_msg_list set crm_pml_sync_flag='Y' where crm_pml_sync_flag = 'W' and '**' <> ? ";
        //sql = "update pos.branch set br_come_under = '4' where br_id = ? ";
  		flag = this.executeUpdate(this.getConnection(),sql,new Object[]{brId});
   		if(!flag)
   		{
   	        erCode = "-3";
   	        erMsg  = "Update pos.crm_push_msg_list to Y Failed.";
   	        return this.getJson(hst,erCode,erMsg);
   		}

		hst.put("PushMsgList", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	   
	
	private String api_com_QueryShopStockBrId(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql;
 
		sql = "select br_region1 as ShopCode,pro_check_no as ProId,st_on_hand_qty as OnHandQty from pos.store,pos.product,pos.branch where st_pro_id = pro_id and pro_check_no <> 'N' AND br_region1 = ? and   st_br_id = br_id and st_on_hand_qty >= 0";

		list = this.query(sql,new Object[]{brId});
 
		hst.put("StockList", list);

		return this.getJson(hst,erCode,erMsg);
	}	

	
	private String api_com_QueryShopStockPro(String param,String brId,String proId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql;
 
		sql = "select br_region1 as ShopCode,pro_check_no as ProId,st_on_hand_qty as OnHandQty from pos.store,pos.product,pos.branch where br_region1 = ? and br_id = st_br_id and pro_check_no <> 'N' and pro_check_no = ? and pro_id = st_pro_id";

		list = this.query(sql,new Object[]{brId,proId});
 
		hst.put("StockList", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	private String api_com_QueryShopStockProJson(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String	sql;
		
		System.out.println("------param---------"+param);
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		String  ls_BrId = String.valueOf(jsonObj.get("BrId"));
		String  ls_ProId = String.valueOf(jsonObj.get("ProId"));
		Object	obj_BrId = jsonObj.get("BrId");
		System.out.println("转换前:ls_BrId:["+ls_BrId + "] ls_ProId:[" + ls_ProId + "] obj_BrId:" + obj_BrId);
		    
		if("".equals(ls_BrId)||"null".equals(ls_BrId)||StringUtil.isEmpty(ls_BrId))
		{
			ls_BrId = "-";
		}
		    
		if("".equals(ls_ProId)||"null".equals(ls_ProId)||StringUtil.isEmpty(ls_ProId))
		{
			ls_ProId = "-";
		}
		    
		System.out.println("转换后:ls_BrId:["+ls_BrId + "] ls_ProId:[" + ls_ProId + "]");
		
		sql = "select st_br_id as ShopCode,st_pro_id as ProId,st_on_hand_qty as OnHandQty from pos.store where st_br_id = ? and st_pro_id = ?";

		list = this.query(sql,new Object[]{ls_BrId,ls_ProId});

		hst.put("StockPro", list);
		
		erMsg	= "转换后:ls_BrId:["+ls_BrId + "] ls_ProId:[" + ls_ProId + "]";

		return this.getJson(hst,erCode,erMsg);
	}	

	
	private String api_com_QueryShopStockProOrg(String param,String brId,String proId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		String sql;

		sql = "select br_region1 as ShopCode,st_on_hand_qty as OnHandQty from pos.store,pos.branch,pos.product where pro_check_no <> 'N' and pro_check_no = ? and pro_id = st_pro_id and st_on_hand_qty > 0 and st_br_id = br_id and br_region1 is not null";

		list = this.query(sql,new Object[]{proId});
 
		hst.put("StockOrgList", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	   
	private String api_com_QueryShopStockSum(String param,String brId,String proId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		    
		
		String sql = "select pro_check_no as ProId,sum(st_on_hand_qty) as OnHandQty "
					+ "from pos.store,pos.product,pos.branch "
					+ "where st_pro_id = pro_id and pro_check_no <> 'N' and pro_check_no = ? and st_br_id = br_id and br_region1 is not null group by pro_check_no";

		list = this.query(sql,new Object[]{proId});

		hst.put("StockProSum", list);

		return this.getJson(hst,erCode,erMsg);
	}	

	  	
	private String api_Coupon_QueryCouponPageList(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		//System.out.println("------param---------"+param);
		    
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		    
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
				+ "ppr_remain_amt as CouponOrignal,to_char(ppr_sdate,'yyyy/mm/dd') as BeginDate,to_char(ppr_edate,'yyyy/mm/dd') as EndDate, "
				+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
				+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type <> '5001'";
		}
		else
		{
			sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
				+ "ppr_remain_amt as CouponOrignal,convert(char(10),ppr_sdate,111) as BeginDate,convert(char(10),ppr_edate,111) as EndDate, "
				+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
				+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type <> '5001'";
		}
		

		list = this.query(sql,new Object[]{ls_CustCode});

		hst.put("Records", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Coupon_QueryCouponUseList(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		//System.out.println("------param---------"+param);
		    
		String  ls_prepaidid = String.valueOf(jsonObj.get("PrepaidId"));
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select ppu_use_type,ppu_use_org,br_name,ppu_use_bill,ppu_use_amt,convert(char(10),ppu_input_date,111) as ppu_input_date,ppu_pay_mode,ppu_shift "
				+ " from pos.promotion_prepaid_use,pos.branch "
				+ "where ppu_id = ? and ppu_use_org = br_id order by ppu_input_date,ppu_use_type";
		}
		else
		{
			sql = "select ppu_use_type,ppu_use_org,br_name,ppu_use_bill,ppu_use_amt,to_char(ppu_input_date,'yyyy/mm/dd') as ppu_input_date,ppu_pay_mode,ppu_shift "
				+ " from pos.promotion_prepaid_use,pos.branch "
				+ "where ppu_id = ? and ppu_use_org = br_id order by ppu_input_date,ppu_use_type";
		}
		    
		list = this.query(sql,new Object[]{ls_prepaidid});

		hst.put("Records", list);
		
		//erMsg	= sql;
	

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Coupon_QueryRedPacketsPageList(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		//System.out.println("------param---------"+param);
		    
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
				+ "ppr_remain_amt as CouponOrignal,convert(char(10),ppr_sdate,111) as BeginDate,convert(char(10),ppr_edate,111) as EndDate, "
				+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
				+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type = '5001'";;
		}
		else
		{
			sql = "select '私用券' as CouponApplyTo,'1' as CouponType,ppr_id as CouponCode,ppr_remain_amt as CouponMoney,"
				+ "ppr_remain_amt as CouponOrignal,to_char(ppr_sdate,'yyyy/mm/dd') as BeginDate,to_char(ppr_edate,'yyyy/mm/dd') as EndDate, "
				+ "ppr_type as CouponUseCondId,pcc_name as CouponUseCondName,ppr_belong_memo as Remark from pos.promotion_prepaid,pos.promotion_card_class "
				+ "where ppr_belong_name = '会员卡' and ppr_belong_memo = ? and ppr_type = pcc_type and ppr_type = '5001'";;
		}
		    
		
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
		//System.out.println("------param---------"+param);
		    
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
	
	
	private String api_Customer_QueryCustomerPointDetails(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		
		//如果不传入则为null
		//System.out.println("------param---------"+param);
		    
		String  ls_Mobile = String.valueOf(jsonObj.get("Mobile"));
		String  ls_CustCode = String.valueOf(jsonObj.get("CustCode"));
		String  ls_StartDate = String.valueOf(jsonObj.get("StartDate"));
		String  ls_EndDate = String.valueOf(jsonObj.get("EndDate"));
		    
		if("".equals(ls_Mobile)||"null".equals(ls_Mobile)||StringUtil.isEmpty(ls_Mobile))
		{
			ls_Mobile = "---------";
		}
		
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select convert(char(10),mts_tx_date,111) as CreateTime,'消费积分' as ChangeType,convert(char(8),getdate(),112)||'SUM' as RefCode,mts_br_id as ShopCode,br_name as ShopName,"
				+ "mts_total_pot as UserPoint from pos.mem_tx_summary,pos.branch "
				+ "where mts_mem_id = ? and mts_br_id = br_id  union all "
				+ "select convert(char(10),mth_tx_date,111) as CreateTime,(case mth_type when   '00' then '正常销售' when '01' then '积分换购'  when '04' then '限次预付/消费' when '05' then '人工调整' else '其他' end) as ChangeType,mth_voucher_id as RefCode,mth_br_id as ShopCode,br_name as ShopName,"
				+ "(case mth_type when   '00' then 1 when   '04' then 1 when '05' then 1  else -1 end)*mth_tx_pot as UserPoint from pos.mem_transaction_header,pos.branch "
				+ "where mth_card_id = ? and mth_br_id = br_id and mth_type in ('00','01','04','05')";
		}
		else
		{
			sql = "select to_char(mts_tx_date,'yyyy/mm/dd') as CreateTime,'消费积分' as ChangeType,to_char(sysdate,'yyyymmdd')||'SUM' as RefCode,mts_br_id as ShopCode,br_name as ShopName,"
				+ "mts_total_pot as UserPoint from pos.mem_tx_summary,pos.branch "
				+ "where mts_mem_id = ? and mts_br_id = br_id  union all "
				+ "select to_char(mth_tx_date,'yyyy/mm/dd') as CreateTime,(case mth_type when   '00' then '正常销售' when '01' then '积分换购'  when '04' then '限次预付/消费' when '05' then '人工调整' else '其他' end) as ChangeType,mth_voucher_id as RefCode,mth_br_id as ShopCode,br_name as ShopName,"
				+ "(case mth_type when   '00' then 1 when   '04' then 1 when '05' then 1  else -1 end)*mth_tx_pot as UserPoint from pos.mem_transaction_header,pos.branch "
				+ "where mth_card_id = ? and mth_br_id = br_id and mth_type in ('00','01','04','05')";
		}

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
		//System.out.println("------param---------"+param);
		    
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
		//System.out.println("------param---------"+param);
		    
		String sql = "select mp_id as CustCode,mp_name as CustName,mp_sex as Sex,mp_mobile_phone as Mobile,mp_tel as Phone,mp_email_address as Email,mp_qq as QQ, "
					+ "mp_br_id as ShopCode "
					+ "from pos.mem_personal "
					+ "where mp_mobile_phone = ?";

		list = this.query(sql,new Object[]{ls_mobile});

		hst.put("Customer", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Order_QueryOrder(String dbType,String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));

		String  pBillNo = String.valueOf(jsonObj.get("OrderCode"));
		String  pShopCode = String.valueOf(jsonObj.get("ShopCode"));
		
		//如果不传入则为null
		//System.out.println("------param---------"+param);
		    
		if("".equals(pBillNo)||"null".equals(pBillNo)||StringUtil.isEmpty(pBillNo))
		{
			pBillNo = "%";
		}
		    
		if("".equals(pShopCode)||"null".equals(pShopCode)||StringUtil.isEmpty(pShopCode))
		{
			pShopCode = "%";
		}
		
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "select convert(char(10),piv_date,111) as OrderDate,piv_time as OrderTime,convert(char(8),piv_date,112)||'-'||piv_br_id||'-'||piv_bill_no as OrderCode,piv_br_id as ShopCode,br_name as ShopName,"
				+ "piv_hyk_no as CustCode,'TEST' as CustName,'TEST' as Mobile,'TEST' as ProvName,'TEST' as CityName,'TEST' as CountyName," 
				+ "'TEST' as Address,'TEST' as PayMode,piv_ys_amt as OrderMoney,0 as ScoreMoney,piv_dyq as CouponMoney,0 as OtherMoney,"
				+ "0 as OrderPoint,0 as UsedPoint, convert(char(10),piv_date,111) || ' '|| piv_time as BuyTime,'TEST' as BuyerMeno,"
				+ "'TEST' as InnerMeno,0 as GoodsNum from pos.p_inv,pos.branch "
				+ "where piv_hyk_no like ? and piv_br_id like ? and piv_bill_no like ? and piv_date >= ? and piv_date <= ? and br_id = piv_br_id";
		}
		else
		{
			sql = "select to_char(piv_date,'yyyy/mm/dd') as OrderDate,piv_time as OrderTime,to_char(piv_date,'yyyymmdd')||'-'||piv_br_id||'-'||piv_bill_no as OrderCode,piv_br_id as ShopCode,br_name as ShopName,"
				+ "piv_hyk_no as CustCode,'TEST' as CustName,'TEST' as Mobile,'TEST' as ProvName,'TEST' as CityName,'TEST' as CountyName," 
				+ "'TEST' as Address,'TEST' as PayMode,piv_ys_amt as OrderMoney,0 as ScoreMoney,piv_dyq as CouponMoney,0 as OtherMoney,"
				+ "0 as OrderPoint,0 as UsedPoint, to_char(piv_date,'yyyy/mm/dd') || ' '|| piv_time as BuyTime,'TEST' as BuyerMeno,"
				+ "'TEST' as InnerMeno,0 as GoodsNum from pos.p_inv,pos.branch "
				+ "where piv_hyk_no like ? and piv_br_id like ? and piv_bill_no like ? and piv_date >= ? and piv_date <= ? and br_id = piv_br_id";
		}

		list = this.query(sql,new Object[]{jsonObj.get("VIPCardNo"),pShopCode,pBillNo,jsonObj.get("OrderSDate"),jsonObj.get("OrderEDate")});

		hst.put("data", list);

		return this.getJson(hst,erCode,erMsg);
	}	
	
	
	private String api_Order_QueryOrderItem(String param,String brId)
	{
		Hashtable hst = new Hashtable(); 
		String erCode = "0",erMsg = "Query Data Success.";
		JSONObject jsonObj =  JSONObject.fromObject(this.getArray(param,"data").get(0));
		
		//System.out.println("------param---------"+param);

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
		String dsName = "java:comp/env/jdbc/jyzjk";//Name of the data source.
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
			return JDBCUtil.query("java:comp/env/jdbc/jyzjk", sql, 0, 0,"sybase", null);
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
			return JDBCUtil.query("java:comp/env/jdbc/jyzjk", sql, 0, 0,"sybase", parms);
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
			if(conn==null)
			{
				System.out.println("空链接..................");
			}
			else
			{
				System.out.println("非空链接..................");
			}
			//测试 
			//if(1==1)return false;//不测试时去掉
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
			//LogUtil.info("Function executeUpdate: ",WsConstant.DB_UPDATE_SQL +"Json: " + json + ex.toString(),true);
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
		String sql = "insert into pos.sys_log_ws(err_id,err_title,err_info,err_time,err_person,err_program) values(?,?,?,?,?,?)";
		
		if (1==2)
		{
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
	}
	
	//After get upgrade program. 
	private void updateSyncData(String dbType,String brId,String taskId)
	{
		String sql = "";
		
		if("SYBASE".equals(dbType)) 
		{
			sql = "update pos.sys_goup_branch set sgb_sync_flag='Y',sgb_sync_date = getdate() where sgb_br_id = ? and sgb_task_id = ? ";
		}
		else
		{
			sql = "update pos.sys_goup_branch set sgb_sync_flag='Y',sgb_sync_date = sysdate where sgb_br_id = ? and sgb_task_id = ? ";
		}

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
