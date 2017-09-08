package controller;

public class Member {
	String aTTUID;
	String fullName;
	String team;
	String Level;
	String leadATTUID;
		
	public String getaTTUID() {
		return aTTUID;
	}
	public void setaTTUID(String aTTUID) {
		this.aTTUID = aTTUID;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getTeam() {
		return team;
	}
	public void setTeam(String team) {
		this.team = team;
	}
	public String getLevel() {
		return Level;
	}
	public void setLevel(String level) {
		Level = level;
	}
	public String getTeamLeadATTUID() {
		return leadATTUID;
	}
	public void setTeamLeadATTUID(String leadATTUID) {
		this.leadATTUID = leadATTUID;
	}
}
