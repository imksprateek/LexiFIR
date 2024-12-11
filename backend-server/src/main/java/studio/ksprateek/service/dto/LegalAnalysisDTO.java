package studio.ksprateek.service.dto;

import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

public class LegalAnalysisDTO {
    @JsonProperty("relatedSections")
    private List<LegalSection> legalSections;

    @JsonProperty("landmarkJudgments")
    private List<LandmarkCase> landmarkCases;

    // No-args constructor
    public LegalAnalysisDTO() {}

    // Nested class for Legal Sections with flexible property handling
    public static class LegalSection {
        @JsonProperty("sectionCode")
        private String section;
        @JsonProperty("description")
        private String description;

        @JsonProperty("relevanceScore")
        private String relevanceScore;

        @JsonProperty("reasoning")
        private String reasoning;

        // No-args constructor
        public LegalSection() {}

        // Getter and setter for known properties
        public String getSection() { return section; }
        public void setSection(String section) { this.section = section; }

        public String getDescription() { return description; }
        public void setDescription(String description) { this.description = description; }

        public String getRelevanceScore() { return relevanceScore; }
        public void setRelevanceScore(String relevanceScore) { this.relevanceScore = relevanceScore; }

        public String getReasoning() { return reasoning; }
        public void setReasoning(String reasoning) { this.reasoning = reasoning; }
    }

    // Nested class for Landmark Cases (similar structure)
    public static class LandmarkCase {
        @JsonProperty("title")
        private String caseRef;

        @JsonProperty("summary")
        private String keyInsights;

        @JsonProperty("url")
        private String officialReference;

        // Additional properties map
        private Map<String, Object> additionalProperties = new HashMap<>();

        // No-args constructor
        public LandmarkCase() {}

        // Getters and setters
        public String getCaseRef() { return caseRef; }
        public void setCaseRef(String caseRef) { this.caseRef = caseRef; }

        public String getKeyInsights() { return keyInsights; }
        public void setKeyInsights(String keyInsights) { this.keyInsights = keyInsights; }

        public String getOfficialReference() { return officialReference; }
        public void setOfficialReference(String officialReference) { this.officialReference = officialReference; }

        // Capture any additional properties
        @JsonAnySetter
        public void handleUnknownProperty(String key, Object value) {
            additionalProperties.put(key, value);
        }

        // Getter for additional properties if needed
        public Map<String, Object> getAdditionalProperties() {
            return additionalProperties;
        }
    }

    // Getters and setters for main class
    public List<LegalSection> getLegalSections() { return legalSections; }
    public void setLegalSections(List<LegalSection> legalSections) { this.legalSections = legalSections; }

    public List<LandmarkCase> getLandmarkCases() { return landmarkCases; }
    public void setLandmarkCases(List<LandmarkCase> landmarkCases) { this.landmarkCases = landmarkCases; }

}