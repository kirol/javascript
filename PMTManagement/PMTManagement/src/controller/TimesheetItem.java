package controller;

public class TimesheetItem {
	String aTT_UID;
	String pmt_ID;
	int month;
	int year;
	double hoursOfDays[];
	 
	public TimesheetItem()
	{
		aTT_UID = "";
		pmt_ID = "";
		month = 0;
		year = 0;
		hoursOfDays = new double[32];
		for (int i = 0; i < 32; i++)
		{
			hoursOfDays[i] = 0;
		}
	}
	
	public String getaTT_UID() {
		return aTT_UID;
	}
	public void setaTT_UID(String aTT_UID) {
		this.aTT_UID = aTT_UID;
	}
	public String getPmt_ID() {
		return pmt_ID;
	}
	public void setPmt_ID(String pmt_ID) {
		this.pmt_ID = pmt_ID;
	}
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public double[] getHoursOfDays() {
		return hoursOfDays;
	}
	public void setHoursOfDays(double[] hoursOfDays) {
		this.hoursOfDays = hoursOfDays;
	}
}
