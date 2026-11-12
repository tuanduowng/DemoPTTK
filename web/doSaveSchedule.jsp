
<%@ page import="java.util.List" %>
<%@ page import="model.Showtime" %>
<%@ page import="dao.ShowtimeDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    // Chỉ chấp nhận phương thức POST
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect("CreateScheduleView.jsp");
        return;
    }

    // Lấy danh sách suất chiếu tạm từ session
    List<Showtime> pendingShowtimes =
            (List<Showtime>) session.getAttribute("pendingShowtimes");

    String message;
    String messageType;

    // Kiểm tra danh sách
    if (pendingShowtimes == null || pendingShowtimes.isEmpty()) {

        message = "Không có suất chiếu nào để lưu.";
        messageType = "error";

    } else {

        try (ShowtimeDAO dao = new ShowtimeDAO()) {

            // Lưu toàn bộ danh sách xuống database
            boolean success = dao.saveAllShowtimes(pendingShowtimes);

            if (success) {

                // Xóa danh sách tạm sau khi lưu thành công
                session.removeAttribute("pendingShowtimes");

                message = "Thêm danh sách lịch chiếu thành công!";
                messageType = "success";

            } else {

                // Giữ lại danh sách để người dùng kiểm tra
                message = "Không thể lưu lịch chiếu. "
                        + "Vui lòng kiểm tra thông tin phim, phòng "
                        + "và lịch chiếu bị trùng.";

                messageType = "error";
            }

        } catch (SQLException e) {

            message = "Lỗi database: " + e.getMessage();
            messageType = "error";

        }
    }

    // Lưu thông báo vào session
    session.setAttribute("scheduleMessage", message);
    session.setAttribute("scheduleMessageType", messageType);

    // Điều hướng theo kết quả
    if ("success".equals(messageType)) {
%>
        <script>
            alert("Thêm danh sách lịch chiếu thành công!");
            window.location.href = "ManagerView.jsp";
        </script>
<%
    } else {
        response.sendRedirect("CreateScheduleView.jsp");
    }
%>
