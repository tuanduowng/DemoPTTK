
package model;

public class Format {

    private int id;
    private String formatName;
    private String description;

    public Format() {
    }

    public Format(int id, String formatName, String description) {
        this.id = id;
        this.formatName = formatName;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFormatName() {
        return formatName;
    }

    public void setFormatName(String formatName) {
        this.formatName = formatName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
