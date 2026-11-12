package dao;

import model.Showtime;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class ShowtimeDAO extends DAO {

    private static final int CLEANING_TIME = 15;

    public ShowtimeDAO() throws SQLException {
        super();
    }

    /**
     * Kiểm tra các suất chiếu trong danh sách có bị trùng thời gian trong cùng
     * một phòng hay không.
     *
     * @param showtimes danh sách suất chiếu cần kiểm tra
     * @return true nếu bị trùng, false nếu không trùng
     */
    public static boolean hasConflictInList(List<Showtime> showtimes) {

        if (showtimes == null || showtimes.size() < 2) {
            return false;
        }

        for (int i = 0; i < showtimes.size(); i++) {

            Showtime a = showtimes.get(i);

            if (a == null || a.getRoom() == null
                    || a.getStartAt() == null || a.getEndAt() == null) {
                return true;
            }

            for (int j = i + 1; j < showtimes.size(); j++) {

                Showtime b = showtimes.get(j);

                if (b == null || b.getRoom() == null
                        || b.getStartAt() == null || b.getEndAt() == null) {
                    return true;
                }

                // Chỉ kiểm tra nếu hai suất chiếu cùng phòng
                if (a.getRoom().getId() != b.getRoom().getId()) {
                    continue;
                }

                LocalDateTime startA = a.getStartAt();
                LocalDateTime endA = a.getEndAt();

                LocalDateTime startB = b.getStartAt();
                LocalDateTime endB = b.getEndAt();

                // Có tính thêm 15 phút vệ sinh phòng
                boolean conflict
                        = startA.isBefore(endB.plusMinutes(CLEANING_TIME))
                        && startB.isBefore(endA.plusMinutes(CLEANING_TIME));

                if (conflict) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Lưu danh sách suất chiếu vào database.
     *
     * @param showtimes danh sách suất chiếu cần lưu
     * @return true nếu lưu thành công, false nếu dữ liệu không hợp lệ
     */
    public boolean saveAllShowtimes(List<Showtime> showtimes)
            throws SQLException {

        // 1. Kiểm tra danh sách đầu vào
        if (showtimes == null || showtimes.isEmpty()) {
            return false;
        }

        // 2. Kiểm tra dữ liệu từng suất chiếu
        for (Showtime s : showtimes) {

            if (s == null
                    || s.getMovie() == null
                    || s.getRoom() == null
                    || s.getFormat() == null
                    || s.getMovie().getId() <= 0
                    || s.getRoom().getId() <= 0
                    || s.getFormat().getId() <= 0
                    || s.getStartAt() == null
                    || s.getEndAt() == null
                    || !s.getStartAt().isBefore(s.getEndAt())) {

                return false;
            }
        }

        // 3. Kiểm tra trùng lịch giữa các suất chiếu trong danh sách
        if (hasConflictInList(showtimes)) {
            return false;
        }

        boolean originalAutoCommit = conn.getAutoCommit();

        try {

            // 4. Bắt đầu transaction
            conn.setAutoCommit(false);

            /*
             * 5. Khóa các phòng liên quan.
             * Sắp xếp ID phòng tăng dần để hạn chế deadlock.
             */
            Set<Integer> roomIds = new TreeSet<>();

            for (Showtime s : showtimes) {
                roomIds.add(s.getRoom().getId());
            }

            String lockRoomSQL
                    = "SELECT id FROM tblroom WHERE id = ? FOR UPDATE";

            try (PreparedStatement ps = conn.prepareStatement(lockRoomSQL)) {

                for (int roomId : roomIds) {

                    ps.setInt(1, roomId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }

            // 6. Chuẩn bị các câu truy vấn kiểm tra
            String movieSQL
                    = "SELECT duration FROM tblmovie "
                    + "WHERE id = ? AND nowShowing = TRUE";

            String movieFormatSQL
                    = "SELECT 1 FROM tblmovieformat "
                    + "WHERE tblMovieid = ? AND tblFormatid = ? "
                    + "LIMIT 1";

            String roomFormatSQL
                    = "SELECT 1 FROM tblroomformat "
                    + "WHERE tblRoomid = ? AND tblFormatid = ? "
                    + "LIMIT 1";

            String conflictSQL
                    = "SELECT 1 "
                    + "FROM tblshowtime "
                    + "WHERE tblRoomid = ? "
                    + "AND startAt < DATE_ADD(?, INTERVAL 15 MINUTE) "
                    + "AND endAt > DATE_SUB(?, INTERVAL 15 MINUTE) "
                    + "LIMIT 1";

            try (
                    PreparedStatement moviePS
                    = conn.prepareStatement(movieSQL); PreparedStatement movieFormatPS
                    = conn.prepareStatement(movieFormatSQL); PreparedStatement roomFormatPS
                    = conn.prepareStatement(roomFormatSQL); PreparedStatement conflictPS
                    = conn.prepareStatement(conflictSQL)) {

                for (Showtime s : showtimes) {

                    int movieId = s.getMovie().getId();
                    int roomId = s.getRoom().getId();
                    int formatId = s.getFormat().getId();

                    // 6.1. Kiểm tra phim có đang được phép lên lịch không
                    moviePS.setInt(1, movieId);

                    int duration;

                    try (ResultSet rs = moviePS.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }

                        duration = rs.getInt("duration");
                    }

                    if (duration <= 0
                            || !s.getStartAt().plusMinutes(duration)
                                    .equals(s.getEndAt())) {

                        conn.rollback();
                        return false;
                    }

                    // 6.2. Kiểm tra phim có hỗ trợ định dạng chiếu không
                    movieFormatPS.setInt(1, movieId);
                    movieFormatPS.setInt(2, formatId);

                    try (ResultSet rs = movieFormatPS.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }

                    // 6.3. Kiểm tra phòng có hỗ trợ định dạng chiếu không
                    roomFormatPS.setInt(1, roomId);
                    roomFormatPS.setInt(2, formatId);

                    try (ResultSet rs = roomFormatPS.executeQuery()) {

                        if (!rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }

                    // 6.4. Kiểm tra trùng lịch với database
                    conflictPS.setInt(1, roomId);

                    conflictPS.setTimestamp(
                            2, Timestamp.valueOf(s.getEndAt())
                    );

                    conflictPS.setTimestamp(
                            3, Timestamp.valueOf(s.getStartAt())
                    );

                    try (ResultSet rs = conflictPS.executeQuery()) {

                        if (rs.next()) {
                            conn.rollback();
                            return false;
                        }
                    }
                }
            }

            // 7. Thêm tất cả suất chiếu vào database
            String insertSQL
                    = "INSERT INTO tblshowtime "
                    + "(startAt, endAt, saleStatus, "
                    + "tblMovieid, tblRoomid, tblFormatid) "
                    + "VALUES (?, ?, 'SELLING', ?, ?, ?)";

            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {

                for (Showtime s : showtimes) {

                    ps.setTimestamp(
                            1, Timestamp.valueOf(s.getStartAt())
                    );

                    ps.setTimestamp(
                            2, Timestamp.valueOf(s.getEndAt())
                    );

                    ps.setInt(3, s.getMovie().getId());
                    ps.setInt(4, s.getRoom().getId());
                    ps.setInt(5, s.getFormat().getId());

                    ps.addBatch();
                }

                ps.executeBatch();
            }

            // 8. Xác nhận transaction
            conn.commit();

            return true;

        } catch (SQLException | RuntimeException e) {

            // Có lỗi thì hoàn tác toàn bộ transaction
            conn.rollback();

            throw e;

        } finally {

            // Khôi phục trạng thái autoCommit ban đầu
            conn.setAutoCommit(originalAutoCommit);
        }
    }
}
