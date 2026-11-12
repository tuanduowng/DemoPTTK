
package dao;

import model.Room;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RoomFormatDAO extends DAO {

    public RoomFormatDAO() throws SQLException {
        super();
    }

    // Lấy tất cả phòng chiếu
    public List<Room> getAllRooms() throws SQLException {

        List<Room> rooms = new ArrayList<>();

        String sql = """
                SELECT *
                FROM tblRoom
                ORDER BY roomName
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Room room = new Room();

                room.setId(rs.getInt("id"));
                room.setRoomName(rs.getString("roomName"));
                room.setRoomType(rs.getString("roomType"));
                room.setCapacity(rs.getInt("capacity"));

                rooms.add(room);
            }
        }

        return rooms;
    }

    // Lấy thông tin phòng theo ID
    public Room getRoomById(int roomId) throws SQLException {

        String sql = """
                SELECT *
                FROM tblRoom
                WHERE id = ?
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, roomId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    Room room = new Room();

                    room.setId(rs.getInt("id"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setRoomType(rs.getString("roomType"));
                    room.setCapacity(rs.getInt("capacity"));

                    return room;
                }
            }
        }

        return null;
    }

    // Lấy các phòng hỗ trợ định dạng phim
    public List<Room> getRoomsByFormat(int formatId)
            throws SQLException {

        List<Room> rooms = new ArrayList<>();

        String sql = """
                SELECT r.id, r.roomName, r.roomType, r.capacity
                FROM tblRoom r
                JOIN tblRoomFormat rf
                    ON r.id = rf.tblRoomid
                WHERE rf.tblFormatid = ?
                ORDER BY r.roomName
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, formatId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Room room = new Room();

                    room.setId(rs.getInt("id"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setRoomType(rs.getString("roomType"));
                    room.setCapacity(rs.getInt("capacity"));

                    rooms.add(room);
                }
            }
        }

        return rooms;
    }
}
