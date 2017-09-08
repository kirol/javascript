<%@page import="controller.TimesheetItem"%>
<%@page import="controller.PmtID"%>
<%@page import="com.mysql.fabric.xmlrpc.base.Data"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="controller.DatabaseProcessing" %>
<%@page import="controller.Member" %>
<%@page import="java.sql.ResultSet" %>
<%@page import="java.util.ArrayList" %>

<%@ page language="java" 
	contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"
%>
    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Adding Charge Codes</title>
<!-- Code here -->
<%
	String selectedLeadATTUID = request.getParameter("leadATTUID");
	int totalPMTIDDisplayedForEachMember = 10;

	DatabaseProcessing dbProcessing = DatabaseProcessing.getInstance();
	ArrayList<Member> teamLeads = DatabaseProcessing.getAllTeamLeads();
	ArrayList<Member> teamMembers = DatabaseProcessing.getAllMembersOfALead(selectedLeadATTUID);
	ArrayList<TimesheetItem> memberTimeSheetData = new ArrayList<TimesheetItem>();
	ArrayList<PmtID> pmtIDs = DatabaseProcessing.getallPMTID();
%>

<script src="scripts/jquery-3.2.0.js"></script>
<!-- 
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
-->
<!-- Dynamic data processing -->
<script>
	var leadsJSONStr = '{' +
	<%
		out.print("'\"leads\":[");
		for (int i = 0; i < teamLeads.size(); i++)
		{
			Member member = teamLeads.get(i);
			out.print("{");
			out.print("\"ATTUID\":\"" + member.getaTTUID() + "\", ");
			out.print("\"FullName\":\"" + member.getFullName() + "\", ");
			out.print("\"Team\":\"" + member.getTeam() + "\", ");
			out.print("\"Level\":\"" + member.getLevel() + "\", ");
			out.print("\"TeamLead\":\"" + member.getTeamLeadATTUID());
			if (i == (teamLeads.size() - 1))
				out.print("\"}");
			else
				out.print("\"},");
		}
		out.print("]'");	
	%>
	+ '}';

	var membersJSONStr = '{' +
	<%
		out.print("'\"members\":[");
		for (int i = 0; i < teamMembers.size(); i++)
		{
			Member member = teamMembers.get(i);
			out.print("{");
			out.print("\"ATTUID\":\"" + member.getaTTUID() + "\", ");
			out.print("\"FullName\":\"" + member.getFullName() + "\", ");
			out.print("\"Team\":\"" + member.getTeam() + "\", ");
			out.print("\"Level\":\"" + member.getLevel() + "\", ");
			out.print("\"TeamLead\":\"" + member.getTeamLeadATTUID());
			if (i == (teamMembers.size() -1))
				out.print("\"}");
			else
				out.print("\"},");
		}
		out.print("]'");	
	%>
	+ '}';
	
	var pmtIDJSONStr = '{' +
	<%
		out.print("'\"pmtids\":[");
		for (int i = 0; i < pmtIDs.size(); i++)
		{
			PmtID pmtid = pmtIDs.get(i);
			out.print("{");
			out.print("\"ID\":\"" + pmtid.getPmt_id() + "\", ");
			out.print("\"Title\":\"" + pmtid.getPmt_title() + "\", ");
			out.print("\"Description\":\"" + pmtid.getPmt_description());
			if (i == (pmtIDs.size() - 1))
				out.print("\"}");
			else
				out.print("\"},");
		}
		out.print("]'");	
	%>
	+ '}';
		
	var leadsJSON = JSON.parse(leadsJSONStr);
	var membersJSON = JSON.parse(membersJSONStr);
	var pmtIDsJSON = JSON.parse(pmtIDJSONStr);
</script>

<!-- helper functions -->
<script>
function setCurrentMonth()
{
	var today = new Date();
	var el = document.getElementById('month');
	el.value = "month_" + (today.getMonth()+1);
	document.getElementById("selectedMonth").value = today.getMonth()+1;
	//Get the last day of current month
	var d = new Date(today.getFullYear(), today.getMonth()+1, 0);
	document.getElementById("numberOfDaysInMonth").value = d.getDate();
}

function changeMonth(selectedMonth)
{
	document.getElementById("selectedMonth").value = parseInt(document.getElementById("month").value) + 1;
	//Get the last day of selected month /*TODO: do later*/
	//var d = new Date(today.getFullYear(), today.getMonth()+1, 0);
	//document.getElementById("numberOfDaysInMonth").value = d.getDate();
	
	document.getElementById("memberATTUID").value = "";
	document.getElementById("memberName").value = "";
}

function setCurrentYear()
{
	var today = new Date();
	var el = document.getElementById('year');
	el.value = "year_" + (today.getFullYear());
	document.getElementById("selectedYear").value = today.getFullYear();
}

function changeYear(selectedYear)
{
	document.getElementById("selectedYear").value = parseInt(document.getElementById("month").value) + 1;
	document.getElementById("memberATTUID").value = "";
	document.getElementById("memberName").value = "";
}

function addTeamLeads()
{
	//console.log("TEST " + Object.keys(leadsJSON.leads).length);
	//alert(leadsJSON1.leads[0].Level);
	var leadSelectObj = document.getElementById("TeamLeads");
	for (i = 0; i < Object.keys(leadsJSON.leads).length; i++)
	{
		//console.log("TEST " + leadsJSON.leads[i].Level);
		var opt = document.createElement('option');
	    opt.value = leadsJSON.leads[i].ATTUID;
	    opt.text = leadsJSON.leads[i].FullName;
	    //opt.innerHTML = LeadsJSON.leads[i].FullName;
	    leadSelectObj.add(opt);
	}
	
	<% out.println("leadSelectObj.value = '" + selectedLeadATTUID + "';" ); %>
	leadSelectObj.disabled = true;
}

function addTeamMembersNames(memberElementID)
{
	var memberSelectObj = document.getElementById(memberElementID);
	for (i = 0; i < Object.keys(membersJSON.members).length; i++)
	{
		//console.log("TEST " + leadsJSON.leads[i].Level);
		var opt = document.createElement('option');
	    opt.value = membersJSON.members[i].ATTUID;
	    opt.text = membersJSON.members[i].FullName;
	    memberSelectObj.add(opt);
	}
}

function changeMemberName(selectedMN)
{
	var el = document.getElementById("member_memberATTUID");
	el.value = selectedMN.value;
	
	if (document.getElementById("member_memberName").value == "")
	{
		$("#add_more_pmtid").prop("disabled", true);
		disablePMTID("member_pmtid_0", "input[name=member_pmtid_0_inputs]", false);
	} else
	{
		disablePMTID("member_pmtid_0", "input[name=member_pmtid_0_inputs]", true);
	}
}

function addTeamMembersATTUID(memberElementID)
{
	var memberSelectObj = document.getElementById(memberElementID);
	for (i = 0; i < Object.keys(membersJSON.members).length; i++)
	{
		//console.log("TEST " + leadsJSON.leads[i].Level);
		var opt = document.createElement('option');
	    opt.value = membersJSON.members[i].ATTUID;
	    opt.text = membersJSON.members[i].ATTUID;
	    memberSelectObj.add(opt);
	}
}

function changeMemberATTUID(selectedATTUID)
{
	var el = document.getElementById("member_memberName");
	el.value = selectedATTUID.value;
	
	if (document.getElementById("member_memberName").value == "")
	{
		$("#add_more_pmtid").prop("disabled", true);
		disablePMTID("member_pmtid_0", "input[name=member_pmtid_0_inputs]", false);
	} else
	{
		disablePMTID("member_pmtid_0", "input[name=member_pmtid_0_inputs]", true);
	}
}

function addPMTIDs(selectedPMTIDElement)
{
	var pmtidSelectObj = document.getElementById(selectedPMTIDElement);
	for (i = 0; i < Object.keys(pmtIDsJSON.pmtids).length; i++)
	{
		var opt = document.createElement('option');
	    opt.value = pmtIDsJSON.pmtids[i].ID;
	    opt.text = pmtIDsJSON.pmtids[i].ID;
	    pmtidSelectObj.add(opt);
	}
}

function disablePMTID(pmtIDSelectID, pmtidInputNames, onlyDateInput)
{
	$("#" + pmtIDSelectID).val("");
	$("#" + pmtIDSelectID).prop("disabled", !onlyDateInput);
	$(pmtidInputNames).prop("disabled", true);
	$(pmtidInputNames).val("");
}

function enablePMTID(pmtIDSelectID, pmtidInputNames, onlyDateInput)
{
	if (!onlyDateInput)
	{
		$(pmtIDSelectID).prop("disabled", false);
		$(pmtidInputNames).prop("disabled", false);
	}
	else
	{
		$(pmtidInputNames).prop("disabled", false);
	}
	$(pmtidInputNames).val("");
}

function doSelectPMTID(selectedPMTID, pmtidInputNames)
{	
	var isSelected = false;
	var currentATTUID = document.getElementById("member_memberATTUID").value;
	var selectedMonth = document.getElementById("selectedMonth").value;
	var selectedYear = document.getElementById("selectedYear").value;
	var currentSelectedPMT = document.getElementById(selectedPMTID.id).value;
	var oldSelectedPMTID = document.getElementById("last_" + selectedPMTID.id).value;
	
	if (currentSelectedPMT == "")
	{
		if (document.getElementById("numberOfDisplayedPMT").value == 1)
		{
			$("#add_more_pmtid").prop("disabled", true);
		}
		disablePMTID(selectedPMTID.id, pmtidInputNames, true);
		if ( oldSelectedPMTID != "")
		{
			removeLastPMTID(currentATTUID, oldSelectedPMTID, selectedMonth, selectedYear)
		}
	}
	else
	{
		$("#add_more_pmtid").prop("disabled", false);
		//console.log("SSSS" + selectedPMTID.id.slice(0, -1));
		var str1 = selectedPMTID.id.slice(0, -1);
		var currentPMTIDIndex = parseInt(selectedPMTID.id.slice(-1));
		for (var i = 0 ; i < 10; i++)
		{
			if (i != currentPMTIDIndex)
			{
				if (currentSelectedPMT == $("#" + str1 + i).val())
				{
					isSelected = true;
				}
			}
		}

		if (!isSelected)
		{
			enablePMTID(selectedPMTID.id, pmtidInputNames, true);
			addNewPMTID(currentATTUID, document.getElementById(selectedPMTID.id).value, selectedMonth, selectedYear);
	
			if ( oldSelectedPMTID != currentSelectedPMT)
			{
				if (oldSelectedPMTID != "")
				{
					removeLastPMTID(currentATTUID, oldSelectedPMTID, selectedMonth, selectedYear);
				}
				document.getElementById("last_" + selectedPMTID.id).value = currentSelectedPMT;
				oldSelectedPMTID = document.getElementById("last_" + selectedPMTID.id).value;
				//console.log("Now writing last pmt: " + oldSelectedPMTID);
			}
		} else
		{
			alert("PMT ID is selected.");
			document.getElementById(selectedPMTID.id).selectedIndex = -1;
			//disablePMTID(selectedPMTID.id, pmtidInputNames, true);
		}
	}
}

function doUpdateHoursForDay(hoursOfDayInputObject, pmtid_ID, day)
{
	var currentATTUID = document.getElementById("member_memberATTUID").value;
	var selectedMonth = document.getElementById("selectedMonth").value;
	var selectedYear = document.getElementById("selectedYear").value;
	var currentPMTID = document.getElementById(pmtid_ID).value;
	var dayToUpdate = day;
	var hoursToUpdate = document.getElementById(hoursOfDayInputObject.id).value;
	if (!isNaN(hoursToUpdate))
	{
		if (hoursToUpdate == "")
			updateHoursForDay(currentATTUID, currentPMTID, selectedMonth, selectedYear, dayToUpdate, 0);
		else
			updateHoursForDay(currentATTUID, currentPMTID, selectedMonth, selectedYear, dayToUpdate, hoursToUpdate);	
	}
	else
	{
		alert("Please input the number only.");
		$("#" + hoursOfDayInputObject.id).val($("#" + hoursOfDayInputObject.id).val().slice(0,-1));
		//alert($("\"#" + hoursOfDayInputObject.id + "\"").val());
	}
}

function getTimeSheetData(att_uid, pmt_id, month, year)
{
	//var _timesheetData;
	return $.ajax(
			{
				type: "POST",
				url: "dataProcessing.jsp",
				data:
				{
					method: 'getTimeSheetData',
					pmt_id: pmt_id,
					att_uid: att_uid,
					month: month,
					year: year,
					async: true,
				    cache: false,
				    success: function(data) {}
				}
			});
}

function addNewPMTID(att_uid, pmt_id, month, year)
{
	$.ajax(
	{
		type: "POST",
		url: "dataProcessing.jsp",
		data:
		{
			method: 'add',
			pmt_id: pmt_id,
			att_uid: att_uid,
			month: month,
			year: year,
			async: true,
		    cache: false,
		    success: function(data) {
				console.log("added ok!!! " + pmt_id + "- " + att_uid + " - " + month + " - " +year);
		    }
		}
	});
}

function updateHoursForDay(att_uid, pmt_id, month, year, day, hours)
{
	console.log("updating.....");
	$.ajax(
	{
		type: "POST",
		url: "dataProcessing.jsp",
		data:
		{
			method: 'update',
			pmt_id: pmt_id,
			att_uid: att_uid,
			month: month,
			year: year,
			day: day,
			hours: hours,
			async: true,
		    cache: false,
		    success: function(data) {
				console.log("update ok!!! " + pmt_id + " - " + att_uid + " - " + month + " - " + year);
		    }
		}
	});
}

function removeLastPMTID(att_uid, pmt_id, month, year)
{
	$.ajax(
	{
		type: "POST",
		url: "dataProcessing.jsp",
		data:
		{
			method: 'remove',
			pmt_id: pmt_id,
			att_uid: att_uid,
			month: month,
			year: year,
			async: true,
		    cache: false,
		    success: function(data) {
				console.log("remove ok!!! " + pmt_id + " - " + att_uid + " - " + month + " - " +year);
		    }
		}
	});	
}

function doAddMorePMTID()
{
	//console.log("TEST1 - " + document.getElementById("numberOfDisplayedPMT").value)
	document.getElementById("numberOfDisplayedPMT").value = parseInt(document.getElementById("numberOfDisplayedPMT").value) + 1
	//console.log("TEST2 - " + document.getElementById("numberOfDisplayedPMT").value)
	var currentPMTIDIndex = parseInt(document.getElementById("numberOfDisplayedPMT").value) - 1;
	var newNumberOfPMTID = currentPMTIDIndex + 1;
	console.log(document.getElementById("numberOfDisplayedPMT").value);
	$("#member_pmtid_" + newNumberOfPMTID + "_hoursOfDate").fadeIn(1000);
	disablePMTID("member_pmtid_" + newNumberOfPMTID, "input[name=member_pmtid_" + newNumberOfPMTID + "_inputs]", true);
}

function doAddMoreMembers(memberToAdd, currentMemberToAddButton)
{
	if (document.getElementById('currentDisplayedMembersOfALead').value < 30)
	{
		document.getElementById('currentDisplayedMembersOfALead').value = parseInt(document.getElementById('currentDisplayedMembersOfALead').value) + 1;
		$("#" + memberToAdd).fadeIn(1000);
		currentMemberToAddButton.disabled = true;
		console.log("TEST: " + document.getElementById('currentDisplayedMembersOfALead').value);
	}
}

function loadData()
{
	loadDefault()
}

function loadDefault()
{
	document.getElementById("member_memberName").value = "";
	disablePMTID("member_pmtid_0", "input[name=member_pmtid_0_inputs]", false);
	document.getElementById("numberOfDisplayedPMT").value = 1;
	<% 
		for (int i = 1; i < totalPMTIDDisplayedForEachMember; i++)
		{
			out.println("$(\"#member_pmtid_" + i + "_hoursOfDate\").hide();");
			out.println("disablePMTID(\"member_pmtid_" + i + "\", \"input[name=member_pmtid_" + i + "_inputs]\", true);");
		}
	%>
}

function doInitialization()
{
	setCurrentMonth();
	setCurrentYear();
	addTeamLeads();
	addTeamMembersNames('member_memberName');
	addTeamMembersATTUID('member_memberATTUID');
	//$("#add_more_pmtid").prop("disabled", true);
	<%
		for (int i = 0; i < totalPMTIDDisplayedForEachMember; i++)
		{
			out.print("addPMTIDs('member_pmtid_" + i + "');");
		}
	%>
	loadData();
}

function isPMTIDIsSelected()
{
	var isSelected = false;
	
	
	return isSelected;
}
</script>

<!-- jQuery and other libraries functions -->
<script>
//$(window).load(function(){
//	document.write("<div id='overlay'>");
//	document.write("<img src='images/loading.gif' alt='Loading' />");
//	document.write("/div>");
//	$('#overlay').show();
//});
//Checking page inactivity
function redirectToLoginPage()
{
	window.location.replace("/PMTManagement/login.jsp");
}

var timeoutTime = 900000; //Page will be log out after 15 minutes
var timeoutTimer = setTimeout(redirectToLoginPage, timeoutTime);
function disableF5(e) { if ((e.which || e.keyCode) == 116 || (e.which || e.keyCode) == 82) e.preventDefault(); };

$(document).ready(function(){
	doInitialization();
	$('body').bind('mousedown keydown', function(event) {
        clearTimeout(timeoutTimer);
        timeoutTimer = setTimeout(redirectToLoginPage, timeoutTime);
    });
});

$(document).on("keydown", disableF5); //disable F5 key
</script>
</head>

<body bgcolor="#E6E6FA">
<center><H1>Charge Codes Management</H1></center>
<hr/>
<div align='center' id='leadsInfo'>
	MONTH <select id="month" name="month" onchange="changeMonth(this)">
		<% 
			//int cMonth = Calendar.getInstance().get(Calendar.MONTH);
			//int maxDayOfMonth = Calendar.getInstance().getActualMaximum(Calendar.DAY_OF_MONTH);
			String[] monthStrs = {
					   "January",      
					   "February",
					   "March",        
					   "April",        
					   "May",          
					   "June",         
					   "July",         
					   "August",       
					   "September",    
					   "October",      
					   "November",     
					   "December"
					   };
			
			for (int i = 0; i < 12; i++)
			{
				out.println("<option value=\"month_" + (i + 1) + "\">" + monthStrs[i] + "</option>");
			}
		%>
	</select>
	YEAR <select id="year" name="year" onchange="changeYear(this)"> 
		<%
			int[] years = { 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025 };
			for (int i = 0; i < years.length; i++)
			{
				out.println("<option value=\"year_" + years[i] + "\">" + years[i] + "</option>");
			}
		%>
	</select>
	
	<br/><br/>
	LEAD
	<select id="TeamLeads" name="TeamLeads" onchange="changeTeamLeads(this)">
	<option value=""></option>
	</select>
	<br/><br/>
</div>

<div id='member'>
	<fieldset style='width:1100px;' >
	<legend>Charge Code</legend>
	<center>
	Name&nbsp;
	<select style='width:200px;' id='member_memberName' name='memberName' onchange='changeMemberName(this)'>
		<option value=''></option>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	ATT UID&nbsp;
	<select style='width:70px;' id='member_memberATTUID' name='memberATTUID' onchange='changeMemberATTUID(this)'>
		<option value=''></option>
	</select>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<input type='button' id='add_more_pmtid' style='width:120px;' value='Add More PMT ID' disabled='true' onclick='doAddMorePMTID();' />
	<table>
		<tr id='member_date'>
		<td align='center'>PMT ID</td>
		<%
			for (int i = 0; i < 31; i++)
			{
				if (i < 9)	
					out.println("<td align='center'>0" + (i+1) + "</td>");
				else
					out.println("<td align='center'>" + (i+1) + "</td>");
			}
		%>
		</tr>
		<%
			for (int i = 0; i < totalPMTIDDisplayedForEachMember; i++)
			{
				out.println("<tr id='member_pmtid_" + i + "_hoursOfDate'>");
				out.println("<td align='center'>"); 
				out.println("<select id='member_pmtid_" + i + "' name='pmtid' onchange='doSelectPMTID(this, " + "\"input[name=member_pmtid_" + i + "_inputs]\");' >");
			
				out.println("<option value=''></option>");
				out.println("</select>");
				for (int k = 0; k < 31; k++)
				{
					out.print("<td align='center'>");
					out.print("<input id='member_pmtid_" + i + "_date_" + k + "' name='member_pmtid_" + i + "_inputs'" + " type='text' maxlength='4' style='width:30px;text-align: center;' oninput='doUpdateHoursForDay(this, \"member_pmtid_" + i + "\", " + (k+1) + ");' />");
					out.print("</td>");
				}
				out.println("</tr>");
			}
		%>
	</table>
	</center>
	</fieldset>
	<!--  load data -->
	<fieldset style="width:1100px; ">
	<legend>Team Members</legend>
	<table style="border: 1px solid black; border-collapse: collapse;">
	<tr>
	<%
		out.println("<th align='center' style='width:70px;'>PMT ID</th>");
		for (int i = 1; i < 32; i++)
		{
			if (i < 10)	
				out.println("<th align='center' style='width:30px;'>0" + i + "</th>");
			else
				out.println("<th align='center' style='width:30px;'>" + i + "</th>");
		}
		out.println("<th align='center' style='width:90px;'>Total Hours</th>");
		
	%>
	</tr>
	</table>
	</fieldset>
	
</div>	
<!-- Storing variable here -->
<input type='text' id='numberOfDaysInMonth' hidden />
<input type='text' id='selectedYear' hidden />
<input type='text' id='selectedMonth' hidden />
<input type='text' id='leadsString' hidden />
<input type='text' id='membersString' hidden />
<input type='number' id='numberOfDisplayedPMT' value='0' hidden />
<input type='text' id='hasTimeSheetToLoad' hidden />

<%
for (int i = 0; i < totalPMTIDDisplayedForEachMember; i++)
{
	out.print("<input type='text' id='last_member_pmtid_" + i + "' value='' hidden />");
}
%>
<center><div id='copyrightlbl' hidden>Developed by Thanh Tran - 2017</div></center>
</body>
</html>