
package controller;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import com.mysql.jdbc.Connection;
import com.mysql.jdbc.PreparedStatement;
import com.mysql.jdbc.Statement;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;

public class DatabaseProcessing {
	public static DatabaseProcessing instance = null;
	
	public static final String DB = "pmtmanagementdb";
	public static final String dbUser = "thanhtran";
	public static final String dbUserPass = "123456789";
	public static final String dbServer = "localhost"; //"192.168.56.102";
	public static final String dbServerPort = "3306";	
	public static final String jdbcStr = "jdbc:mysql://" + dbServer + ":" + dbServerPort + "/" + DB;
	
	public static Connection dbConn = null;
	
	static String sqlGetAllTeamLeads = "SELECT * FROM member WHERE Level='LEAD'";
	static String sqlGetAllTeamMembers = "SELECT * FROM member";
	static String sqlGetAllMembersOfALead = "SELECT * FROM member WHERE LeadATTUID=";
	static String sqlGetAllPMTIDs = "SELECT * FROM pmt";
	static String sqlPSGetTimeSheetData = "SELECT * FROM timesheet where ATT_UID = ? AND PMT_ID = ? AND Month = ? AND Year = ?";
	static String sqlPSInsertMember = "INSERT INTO `member` (`ATTUID`, `FullName`, `Password`, `Team`, `Level`) VALUES (?,?,?,?,?)"; 
	static String sqlPSGetMemberHashedPassword = "SELECT Password FROM `member` WHERE ATTUID = ?";
	
	protected DatabaseProcessing()
	{
		try {
			Class.forName("com.mysql.jdbc.Driver");
			dbConn = (Connection) DriverManager.getConnection(jdbcStr, dbUser, dbUserPass);
			dbConn.setAutoCommit(false);
			if(!dbConn.isClosed())
		         System.out.println("Successfully connected to " + "MySQL server using TCP/IP...");
		
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static DatabaseProcessing getInstance()
	{
		if (instance == null)
		{
			instance = new DatabaseProcessing();
		}
		return instance;
	}
	
	public static ResultSet doExecuteQuery(String queryStr)
	{
		ResultSet _rs = null;
		try {
			Statement st = (Statement) dbConn.createStatement();
			_rs = st.executeQuery(queryStr);
			dbConn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return _rs;
	}
	
	public static void doExecuteUpdate(String queryStr)
	{
		try {
			Statement st = (Statement) dbConn.createStatement();
			st.executeUpdate(queryStr);
			dbConn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static int doRegisterUser(String fullName, String aTTUID, String hashedPassword)
	{
		//Default team as empty string, default level as MEMBER
		int statusCode = 0;
		try
		{
			PreparedStatement pS = (PreparedStatement) dbConn.prepareStatement(sqlPSInsertMember);
			pS.setString(1, aTTUID);
			pS.setString(2, fullName);
			pS.setString(3, hashedPassword);
			pS.setString(4, "");
			pS.setString(5, "MEMBER");
			
			pS.executeUpdate();
			dbConn.commit();
		} catch (MySQLIntegrityConstraintViolationException e)
		{
			System.out.println("Error message: " + e.getMessage());
			if (e.getMessage().indexOf("Duplicate entry") >= 0)
			{
				statusCode = -1;
			}
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("TEST - " + e.getSQLState());
			System.out.println(e.getMessage());
			statusCode = -9;
		}
		
		return statusCode;
	}
	
	public static String getMemberHashedPassword(String aTTUID)
	{
		String memberHashedPassword = "";
		try
		{
			PreparedStatement pS = (PreparedStatement) dbConn.prepareStatement(sqlPSGetMemberHashedPassword);
			pS.setString(1, aTTUID);
			
			ResultSet rs = pS.executeQuery();
			dbConn.commit();
			rs.beforeFirst();
			if (rs.isBeforeFirst())
			{
				if(rs.next())
				{
					memberHashedPassword = rs.getString(1);
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("TEST - " + e.getSQLState());
			System.out.println(e.getMessage());
		}
		
		return memberHashedPassword;
	}
	
	public static ArrayList<Member> getAllTeamLeads()
	{
		ArrayList<Member> teamLeads = new ArrayList<Member>();
		ResultSet rs = doExecuteQuery(sqlGetAllTeamLeads);
		try {
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					//System.out.println("TEST: " + rs.getString("FullName"));
					Member _member = new Member();
					_member.setaTTUID(rs.getString("ATTUID"));
					_member.setFullName(rs.getString("FullName"));
					_member.setTeam(rs.getString("Team"));
					_member.setLevel(rs.getString("Level"));
					_member.setTeamLeadATTUID(rs.getString("LeadATTUID"));
					
					teamLeads.add(_member);
				}
			}
			else
			{
				System.out.println("NO MEMBER ROW......");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return teamLeads;
	}
	
	public static ArrayList<Member> getAllTeamMembers()
	{
		ArrayList<Member> teamMembers = new ArrayList<Member>();
		ResultSet rs = doExecuteQuery(sqlGetAllTeamMembers);
		
		try {
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					//System.out.println("TEST: " + rs.getString("FullName"));
					Member _member = new Member();
					_member.setaTTUID(rs.getString("ATTUID"));
					_member.setFullName(rs.getString("FullName"));
					_member.setTeam(rs.getString("Team"));
					_member.setLevel(rs.getString("Level"));
					_member.setTeamLeadATTUID(rs.getString("LeadATTUID"));
					
					teamMembers.add(_member);
				}
			}
			else
			{
				System.out.println("NO MEMBER ROW......");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return teamMembers;
	}
	
	public static ArrayList<PmtID> getallPMTID()
	{
		ArrayList<PmtID> pmtIDs = new ArrayList<PmtID>();
		
		try {		
			ResultSet rs = doExecuteQuery(sqlGetAllPMTIDs);
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					//System.out.println("TEST: " + rs.getString("FullName"));
					PmtID pmtID = new PmtID();
					pmtID.setPmt_id(rs.getString("ID"));
					pmtID.setPmt_title(rs.getString("Title"));
					pmtID.setPmt_description(rs.getString("Description"));
					
					pmtIDs.add(pmtID);
				}
			}
			else
			{
				System.out.println("NO PMT ROW......");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return pmtIDs;
	}
	
	public static ArrayList<Member> getAllMembersOfALead(String leadATTUID)
	{
		ArrayList<Member> teamMembers = new ArrayList<Member>();
		ResultSet rs = doExecuteQuery(sqlGetAllMembersOfALead + "'" + leadATTUID + "'");
		
		try {
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					//System.out.println("TEST: " + rs.getString("FullName"));
					Member _member = new Member();
					_member.setaTTUID(rs.getString("ATTUID"));
					_member.setFullName(rs.getString("FullName"));
					_member.setTeam(rs.getString("Team"));
					_member.setLevel(rs.getString("Level"));
					_member.setTeamLeadATTUID(rs.getString("LeadATTUID"));
					
					teamMembers.add(_member);
				}
			}
			else
			{
				System.out.println("NO MEMBER ROW......");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return teamMembers;
	}
	
	public static boolean isPMTIDExisted(TimesheetItem timesheetItem)
	{
		boolean isExisted = false;
		//String _pmtid = timesheetItem.getPmt_ID();
		int _month = timesheetItem.getMonth();
		int _year = timesheetItem.getYear();
		String _attUID = timesheetItem.getaTT_UID();
		
		//SQL query - check if exist
		String sqlCheckPMTIDExisted = "SELECT `PMT_ID` FROM `timesheet` WHERE `ATT_UID`=\"" + _attUID + "\" AND `Month`=" + _month + " AND `Year`="+ _year;
		
		try {
			ResultSet rs = doExecuteQuery(sqlCheckPMTIDExisted);
			if (rs.isBeforeFirst())
			{
				isExisted = true;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return isExisted;
	}
	
	public static TimesheetItem loadTimeSheetData(String aTTUID, String pmtID, int month, int year)
	{
		DatabaseProcessing.getInstance();
		
		TimesheetItem timesheetItem = null;
		try {
			PreparedStatement pS = (PreparedStatement) dbConn.prepareStatement(sqlPSGetTimeSheetData);
			pS.setString(1, aTTUID);
			pS.setString(2, pmtID);
			pS.setInt(3, month);
			pS.setInt(4, year);
			
			ResultSet rs = pS.executeQuery();
			dbConn.commit();
			rs.beforeFirst();
			if (rs.isBeforeFirst())
			{
				rs.next();
				
				timesheetItem = new TimesheetItem();
				timesheetItem.setaTT_UID(aTTUID);
				timesheetItem.setPmt_ID(pmtID);
				timesheetItem.setMonth(month);
				timesheetItem.setYear(year);
				//System.out.println("neee - " + rs.toString());
				for (int i = 1; i < 32; i++)
				{
					//System.out.println((rs != null) ? rs.getDouble("" + i) : "null");
					//System.out.println("ttt - " + i);
					timesheetItem.getHoursOfDays()[i-1] = rs.getDouble("" + i); 
				}
				timesheetItem.getHoursOfDays()[31] = rs.getDouble("TOTAL_HOURS");
			}
			//dbConn.setAutoCommit(true);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			//System.out.println("TEST - " + e.getSQLState());
			//System.out.println(e.getMessage());
		}
		
		return timesheetItem;
	}
	
	public static void insertPMTData(TimesheetItem timesheetItem, boolean isTemporary)
	{
		String _pmtid = timesheetItem.getPmt_ID();
		int _month = timesheetItem.getMonth();
		int _year = timesheetItem.getYear();
		String _attUID = timesheetItem.getaTT_UID();
		double[] _hoursOfDays;
		
		if (isTemporary)
		{
			TimesheetItem newTimesheetItem = new TimesheetItem();
			_hoursOfDays = newTimesheetItem.getHoursOfDays();
		}
		else
		{ 
			_hoursOfDays = timesheetItem.getHoursOfDays();
		}	
		//Insert
		String sqlInsertPMTID = "INSERT INTO `timesheet` (`ATT_UID`, `PMT_ID`, `Month`, `Year`, "; 
		for (int i = 1; i < 32; i++) sqlInsertPMTID += "`" + i + "`, ";
		sqlInsertPMTID += " `TOTAL_HOURS`) VALUES (";
		sqlInsertPMTID += "\"" + _attUID + "\", ";
		sqlInsertPMTID += "\"" + _pmtid + "\", ";
		sqlInsertPMTID += _month + ", ";
		sqlInsertPMTID += _year + ", ";
		for (int i = 0; i < 31; i++) sqlInsertPMTID += String.format("%.2f, ", _hoursOfDays[i]);
		sqlInsertPMTID += String.format("%.2f", _hoursOfDays[31]) + ")";
		
		doExecuteUpdate(sqlInsertPMTID);
	}
	
	public static void removePMTData(TimesheetItem timesheetItem)
	{
		String _pmtid = timesheetItem.getPmt_ID();
		int _month = timesheetItem.getMonth();
		int _year = timesheetItem.getYear();
		String _attUID = timesheetItem.getaTT_UID();
		
		String sqlDeletePMTID = "DELETE FROM `timesheet` WHERE `ATT_UID`=\"" +
								_attUID + "\" AND `PMT_ID`=\"" + _pmtid + "\" AND `Month`=" +
								_month + " AND `Year`=" + _year;
		
		doExecuteUpdate(sqlDeletePMTID);
	}
	
	public static void updatePMTData(TimesheetItem timesheetItem, int dayToUpdate, double hoursToUpdate)
	{
		String _pmtid = timesheetItem.getPmt_ID();
		int _month = timesheetItem.getMonth();
		int _year = timesheetItem.getYear();
		String _attUID = timesheetItem.getaTT_UID();
		double _totalHours = 0;
		
		String sqlUpdatePMTID = "UPDATE `timesheet` SET `" + dayToUpdate + "`=" + String.format("%.2f", hoursToUpdate)
								+ "WHERE `ATT_UID`=\"" + _attUID + "\" AND `PMT_ID`=\"" + _pmtid 
								+ "\" AND `Month`=" + _month + " AND `Year`=" + _year;
		
		doExecuteUpdate(sqlUpdatePMTID);
		
		//update total hours
		String sqlGetAllDaysOfPMTID = "SELECT ";
		for (int i = 1; i < 31; i++) sqlGetAllDaysOfPMTID += "`" + i + "`, ";
		sqlGetAllDaysOfPMTID += "`31` from `timesheet` ";
		sqlGetAllDaysOfPMTID += "WHERE `ATT_UID`=\"" + _attUID + "\" AND `PMT_ID`=\"" + _pmtid 
				+ "\" AND `Month`=" + _month + " AND `Year`=" + _year;
		
		ResultSet rs = doExecuteQuery(sqlGetAllDaysOfPMTID);
		try {
			
			if (rs.isBeforeFirst())
			{
				while (rs.next())
				{
					for (int i = 1; i <32; i++)
					{
						//System.out.println((rs != null) ? rs.getDouble("" + i) : "null");
						_totalHours += rs.getDouble("" + i);
					}
				}
			}
		} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
		}
		
		String sqlUpdatePMTIDTotalHours = "UPDATE `timesheet` SET `TOTAL_HOURS`=" + String.format("%.2f", _totalHours)
		+ "WHERE `ATT_UID`=\"" + _attUID + "\" AND `PMT_ID`=\"" + _pmtid 
		+ "\" AND `Month`=" + _month + " AND `Year`=" + _year;

		doExecuteUpdate(sqlUpdatePMTIDTotalHours);
	}
}
 