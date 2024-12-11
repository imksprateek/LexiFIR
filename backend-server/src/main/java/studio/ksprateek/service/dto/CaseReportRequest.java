package studio.ksprateek.service.dto;

import lombok.Data;

import com.fasterxml.jackson.annotation.JsonProperty;

public class CaseReportRequest {
    @JsonProperty("what")
    private String incidentType;

    @JsonProperty("where")
    private String location;

    @JsonProperty("when")
    private String incidentTime;

    @JsonProperty("why")
    private String motive;

    @JsonProperty("who")
    private String involvedParties;

    @JsonProperty("how")
    private String incidentDescription;

    @JsonProperty("witness")
    private String witnessInformation;

    @JsonProperty("weapon")
    private String weaponUsed;

    // Constructors
    public CaseReportRequest() {}

    public CaseReportRequest(String incidentType, String location, String incidentTime,
                         String motive, String involvedParties, String incidentDescription,
                         String witnessInformation, String weaponUsed) {
        this.incidentType = incidentType;
        this.location = location;
        this.incidentTime = incidentTime;
        this.motive = motive;
        this.involvedParties = involvedParties;
        this.incidentDescription = incidentDescription;
        this.witnessInformation = witnessInformation;
        this.weaponUsed = weaponUsed;
    }

    // Getters and Setters
    public String getIncidentType() { return incidentType; }
    public void setIncidentType(String incidentType) { this.incidentType = incidentType; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getIncidentTime() { return incidentTime; }
    public void setIncidentTime(String incidentTime) { this.incidentTime = incidentTime; }

    public String getMotive() { return motive; }
    public void setMotive(String motive) { this.motive = motive; }

    public String getInvolvedParties() { return involvedParties; }
    public void setInvolvedParties(String involvedParties) { this.involvedParties = involvedParties; }

    public String getIncidentDescription() { return incidentDescription; }
    public void setIncidentDescription(String incidentDescription) { this.incidentDescription = incidentDescription; }

    public String getWitnessInformation() { return witnessInformation; }
    public void setWitnessInformation(String witnessInformation) { this.witnessInformation = witnessInformation; }

    public String getWeaponUsed() { return weaponUsed; }
    public void setWeaponUsed(String weaponUsed) { this.weaponUsed = weaponUsed; }
}
