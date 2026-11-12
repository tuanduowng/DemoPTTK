
package model;

public class Room {

    private int id;
    private String roomName;
    private String roomType;
    private int capacity;

    public Room() {
    }

    public Room(int id, String roomName, String roomType, int capacity) {
        this.id = id;
        this.roomName = roomName;
        this.roomType = roomType;
        this.capacity = capacity;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getRoomType() {
        return roomType;
    }

    public void setRoomType(String roomType) {
        this.roomType = roomType;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }
}
