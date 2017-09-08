<%@page import="controller.DatabaseProcessing" %>
<%@page import="controller.TimesheetItem" %>
<%@page import="org.json.simple.JSONObject" %>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<% 
	//System.out.println("TEST RP - method: " + request.getParameter("method"));
	//System.out.println("TEST RP - att_uid: " + request.getParameter("att_uid"));
	//System.out.println("TEST RP - pmt_id: " + request.getParameter("pmt_id"));
	//System.out.println("TEST RP - year: " + request.getParameter("year"));
	//System.out.println("TEST RP - month: " + request.getParameter("month"));

	String pmt_id = request.getParameter("pmt_id");
	String method = request.getParameter("method");
	String att_uid = request.getParameter("att_uid");
	int month = Integer.parseInt(request.getParameter("month"));
	int year = Integer.parseInt(request.getParameter("year"));
	
	if (method.length() != 0 && pmt_id.length() != 0)
	{
		if (method.equals("getTimeSheetData"))
		{
			TimesheetItem timesheetItem = DatabaseProcessing.loadTimeSheetData(att_uid, pmt_id, month, year);
			JSONObject jsonObj = new JSONObject();
			if ( timesheetItem != null)
			{
				jsonObj.put("isAvailable", "True");
				jsonObj.put("att_uid", timesheetItem.getaTT_UID());
				jsonObj.put("pmt_id", timesheetItem.getPmt_ID());
				jsonObj.put("year", timesheetItem.getYear());
				jsonObj.put("month", timesheetItem.getMonth());
				for (int i = 0; i < 31; i++)
				{
					jsonObj.put("" + (i+1), timesheetItem.getHoursOfDays()[i]);
				}
				jsonObj.put("total_hours", timesheetItem.getHoursOfDays()[31]);
				
			} else
			{
				jsonObj.put("isAvailable", "False");
				jsonObj.put("att_uid", att_uid);
				jsonObj.put("pmt_id", pmt_id);
				jsonObj.put("year", year);
				jsonObj.put("month", month);
			}
			
			response.setContentType("application/json");
			response.getWriter().write(jsonObj.toJSONString());
		}
		
		if (method.equals("add"))
		{
			//System.out.println(pmt_id + " - " + att_uid + " - " + month + " - " + year);
			TimesheetItem timesheetItem = new TimesheetItem();
			timesheetItem.setPmt_ID(pmt_id);
			timesheetItem.setaTT_UID(att_uid);
			timesheetItem.setMonth(month);
			timesheetItem.setYear(year);
			
			DatabaseProcessing.insertPMTData(timesheetItem, true);
			//System.out.println(pmt_id);
		}
		
		if (method.equals("remove"))
		{
			//System.out.println(pmt_id + " - " + att_uid + " - " + month + " - " + year);
			
			TimesheetItem timesheetItem = new TimesheetItem();
			timesheetItem.setPmt_ID(pmt_id);
			timesheetItem.setaTT_UID(att_uid);
			timesheetItem.setMonth(month);
			timesheetItem.setYear(year);
			
			DatabaseProcessing.removePMTData(timesheetItem);
		}
		
		if (method.equals("update"))
		{
			int dayToUpdate = Integer.parseInt(request.getParameter("day"));
			double hoursToUpdate = Double.parseDouble(request.getParameter("hours"));

			TimesheetItem timesheetItem = new TimesheetItem();
			timesheetItem.setPmt_ID(pmt_id);
			timesheetItem.setaTT_UID(att_uid);
			timesheetItem.setMonth(month);
			timesheetItem.setYear(year);
			timesheetItem.getHoursOfDays()[dayToUpdate-1] = hoursToUpdate;
			
			DatabaseProcessing.updatePMTData(timesheetItem, dayToUpdate, hoursToUpdate);
		}
	}
%>
