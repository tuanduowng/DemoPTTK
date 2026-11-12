
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="model.Movie" %>
<%@ page import="model.Room" %>
<%@ page import="model.Format" %>
<%@ page import="model.Showtime" %>
<%@ page import="dao.MovieFormatDAO" %>
<%@ page import="dao.RoomFormatDAO" %>
<%@ page import="dao.ShowtimeDAO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    List<Showtime> pendingShowtimes =
            (List<Showtime>) session.getAttribute("pendingShowtimes");

    if (pendingShowtimes == null) {
        pendingShowtimes = new ArrayList<>();
        session.setAttribute("pendingShowtimes", pendingShowtimes);
    }

    String error = null;

    int movieId = -1;
    int formatId = -1;
    int editIndex = -1;

    Movie movie = null;
    Format format = null;

    List<Room> rooms = new ArrayList<>();

    int selectedRoomId = -1;
    String selectedStartAt = "";

    DateTimeFormatter inputFormatter =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    try {

        movieId = Integer.parseInt(request.getParameter("movieId"));
        formatId = Integer.parseInt(request.getParameter("formatId"));

        if (request.getParameter("editIndex") != null) {
            editIndex = Integer.parseInt(
                    request.getParameter("editIndex")
            );
        }

        if (editIndex < -1 || editIndex >= pendingShowtimes.size()) {
            throw new IllegalArgumentException(
                    "Suất chiếu cần sửa không tồn tại."
            );
        }

        // Nếu đang sửa, lấy thời gian và phòng cũ làm giá trị mặc định
        if ("GET".equalsIgnoreCase(request.getMethod()) && editIndex >= 0) {

            Showtime old = pendingShowtimes.get(editIndex);

            selectedRoomId = old.getRoom().getId();

            selectedStartAt = old.getStartAt().format(inputFormatter);
        }

        // Lấy dữ liệu phim, định dạng và phòng
        try (MovieFormatDAO movieDAO = new MovieFormatDAO();
             RoomFormatDAO roomDAO = new RoomFormatDAO()) {

            movie = movieDAO.getMovieById(movieId);

            if (movie == null) {
                throw new IllegalArgumentException("Không tìm thấy phim.");
            }

            List<Format> formats =
                    movieDAO.getFormatsByMovieId(movieId);

            for (Format f : formats) {

                if (f.getId() == formatId) {
                    format = f;
                    break;
                }
            }

            if (format == null) {
                throw new IllegalArgumentException(
                        "Phim không hỗ trợ định dạng đã chọn."
                );
            }

            rooms = roomDAO.getRoomsByFormat(formatId);

            // Xử lý khi người dùng gửi form thêm hoặc sửa
            if ("POST".equalsIgnoreCase(request.getMethod())) {

                selectedRoomId = Integer.parseInt(
                        request.getParameter("roomId")
                );

                selectedStartAt = request.getParameter("startAt");

                LocalDateTime startAt =
                        LocalDateTime.parse(
                                selectedStartAt,
                                inputFormatter
                        );

                LocalDateTime endAt =
                        startAt.plusMinutes(movie.getDuration());

                Room selectedRoom = null;

                for (Room r : rooms) {

                    if (r.getId() == selectedRoomId) {
                        selectedRoom = r;
                        break;
                    }
                }

                if (selectedRoom == null) {
                    throw new IllegalArgumentException(
                            "Phòng không hỗ trợ định dạng đã chọn."
                    );
                }

                // Tạo đối tượng suất chiếu mới
                Showtime newShowtime = new Showtime(
                        movie,
                        selectedRoom,
                        format,
                        startAt,
                        endAt,
                        "SELLING"
                );

                /*
                 * Tạo bản sao danh sách để kiểm tra.
                 * Không sửa danh sách Session trước khi biết kết quả.
                 */
                List<Showtime> checkList =
                        new ArrayList<>(pendingShowtimes);

                if (editIndex >= 0) {

                    // Thay suất chiếu cũ trong danh sách kiểm tra
                    checkList.set(editIndex, newShowtime);

                } else {

                    // Thêm suất chiếu mới vào danh sách kiểm tra
                    checkList.add(newShowtime);
                }

                // Kiểm tra trùng với các suất chiếu đang lưu tạm
                if (ShowtimeDAO.hasConflictInList(checkList)) {

                    error = "Suất chiếu bị trùng với một suất chiếu khác "
                            + "trong cùng phòng hoặc không đủ 15 phút "
                            + "vệ sinh phòng.";

                } else {

                    // Không trùng thì mới cập nhật danh sách thật
                    if (editIndex >= 0) {

                        pendingShowtimes.set(editIndex, newShowtime);

                    } else {

                        pendingShowtimes.add(newShowtime);
                    }

                    session.setAttribute(
                            "pendingShowtimes",
                            pendingShowtimes
                    );

                    response.sendRedirect("CreateScheduleView.jsp");
                    return;
                }
            }
        }

    } catch (Exception e) {

        error = e.getMessage();

        if (error == null || error.isBlank()) {
            error = "Có lỗi xảy ra khi xử lý thông tin suất chiếu.";
        }
    }

    String minDateTime = LocalDateTime.now().format(inputFormatter);
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chọn thời gian chiếu</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f6f9;
                padding: 30px;
            }

            .container {
                max-width: 700px;
                margin: auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px #ddd;
            }

            h1 {
                color: #263238;
            }

            .info {
                background: #e3f2fd;
                padding: 15px;
                border-radius: 6px;
                margin: 20px 0;
            }

            label {
                display: block;
                margin-top: 20px;
                margin-bottom: 8px;
                font-weight: bold;
            }

            select, input {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 5px;
                box-sizing: border-box;
            }

            .button {
                padding: 11px 18px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                cursor: pointer;
                color: white;
                font-size: 14px;
            }

            .primary {
                background: #1976d2;
            }

            .secondary {
                background: #757575;
            }

            .error {
                color: #d32f2f;
                margin-top: 15px;
            }

            .actions {
                display: flex;
                justify-content: space-between;
                margin-top: 30px;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <h1>
                <%= editIndex >= 0 ? "Sửa suất chiếu" : "Chọn thời gian chiếu" %>
            </h1>

            <% if (error != null) { %>

            <p class="error"><%= error %></p>

            <% } %>

            <% if (movie != null && format != null) { %>

            <div class="info">

                <p>
                    <strong>Phim:</strong>
                    <%= movie.getMovieTitle() %>
                </p>

                <p>
                    <strong>Thời lượng:</strong>
                    <%= movie.getDuration() %> phút
                </p>

                <p>
                    <strong>Định dạng:</strong>
                    <%= format.getFormatName() %>
                </p>

            </div>

            <form action="SelectShowtimeView.jsp" method="post">

                <input type="hidden"
                       name="movieId"
                       value="<%= movieId %>">

                <input type="hidden"
                       name="formatId"
                       value="<%= formatId %>">

                <input type="hidden"
                       name="editIndex"
                       value="<%= editIndex %>">

                <label>Chọn phòng chiếu</label>

                <select name="roomId" required>

                    <option value="">-- Chọn phòng --</option>

                    <% for (Room room : rooms) { %>

                    <option value="<%= room.getId() %>"
                            <%= selectedRoomId == room.getId()
                                        ? "selected" : "" %>>

                        <%= room.getRoomName() %>
                        - <%= room.getRoomType() %>
                        - <%= room.getCapacity() %> chỗ

                    </option>

                    <% } %>

                </select>

                <label>Thời gian bắt đầu</label>

                <input type="datetime-local"
                       name="startAt"
                       value="<%= selectedStartAt %>"
                       min="<%= minDateTime %>"
                       required>

                <p style="color:#777; font-size:13px;">
                    Thời gian kết thúc sẽ được tự động tính
                    dựa trên thời lượng phim.
                </p>

                <div class="actions">

                    <a href="SelectMovieView.jsp?movieId=<%= movieId %>&editIndex=<%= editIndex %>"
                       class="button secondary">
                        Quay lại
                    </a>

                    <button type="submit"
                            class="button primary">
                        <%= editIndex >= 0
                            ? "Cập nhật suất chiếu"
                            : "Thêm suất chiếu" %>
                    </button>

                </div>

            </form>

            <% if (rooms.isEmpty()) { %>

            <p class="error">
                Không có phòng nào hỗ trợ định dạng chiếu này.
            </p>

            <% } %>

            <% } %>

        </div>

    </body>
</html>
