
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Showtime" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    List<Showtime> pendingShowtimes =
            (List<Showtime>) session.getAttribute("pendingShowtimes");

    if (pendingShowtimes == null) {
        pendingShowtimes = new ArrayList<>();
        session.setAttribute("pendingShowtimes", pendingShowtimes);
    }

    // Xử lý xóa suất chiếu khỏi danh sách tạm
    String action = request.getParameter("action");

    if ("delete".equals(action)) {

        try {
            int index = Integer.parseInt(
                    request.getParameter("index")
            );

            if (index >= 0 && index < pendingShowtimes.size()) {
                pendingShowtimes.remove(index);
            }

        } catch (NumberFormatException e) {
            // Không thực hiện nếu index không hợp lệ
        }

        response.sendRedirect("CreateScheduleView.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Lên lịch chiếu</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f6f9;
                margin: 0;
                padding: 30px;
            }

            .container {
                max-width: 1100px;
                margin: auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px #ddd;
            }

            h1 {
                color: #263238;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 25px;
            }

            th, td {
                padding: 12px;
                border: 1px solid #ddd;
                text-align: center;
            }

            th {
                background: #1976d2;
                color: white;
            }

            .button {
                display: inline-block;
                padding: 10px 16px;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                cursor: pointer;
                color: white;
                font-size: 14px;
            }

            .add {
                background: #2e7d32;
            }

            .edit {
                background: #f9a825;
            }

            .delete {
                background: #d32f2f;
            }

            .save {
                background: #1976d2;
                font-size: 16px;
            }

            .back {
                background: #757575;
            }

            .actions {
                margin-top: 25px;
                display: flex;
                justify-content: space-between;
            }

            .empty {
                text-align: center;
                padding: 30px;
                color: #777;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Lên lịch chiếu</h1>
            <%
            String scheduleMessage =
                    (String) session.getAttribute("scheduleMessage");

            String scheduleMessageType =
                    (String) session.getAttribute("scheduleMessageType");

            if (scheduleMessage != null) {
            %>

            <div style="padding: 12px;
                 margin: 15px 0;
                 border-radius: 5px;
                 background: <%= "success".equals(scheduleMessageType)
                        ? "#d4edda" : "#f8d7da" %>;
                 color: <%= "success".equals(scheduleMessageType)
                        ? "#155724" : "#721c24" %>;">
                <%= scheduleMessage %>
            </div>

            <%
                    session.removeAttribute("scheduleMessage");
                    session.removeAttribute("scheduleMessageType");
                }
            %>
            <p>
                Danh sách các suất chiếu đang chờ lưu vào hệ thống.
            </p>

            <a href="SelectMovieView.jsp"
               class="button add">
                + Thêm suất chiếu
            </a>

            <table>

                <tr>
                    <th>STT</th>
                    <th>Phim</th>
                    <th>Định dạng</th>
                    <th>Phòng</th>
                    <th>Thời gian bắt đầu</th>
                    <th>Thời gian kết thúc</th>
                    <th>Thao tác</th>
                </tr>

                <%
                    if (pendingShowtimes.isEmpty()) {
                %>

                <tr>
                    <td colspan="8" class="empty">
                        Chưa có suất chiếu nào được thêm.
                    </td>
                </tr>

                <%
                    } else {

                        for (int i = 0; i < pendingShowtimes.size(); i++) {

                            Showtime s = pendingShowtimes.get(i);
                %>

                <tr>

                    <td><%= i + 1 %></td>

                    <td>
                        <%= s.getMovie().getMovieTitle() %>
                    </td>

                    <td>
                        <%= s.getFormat().getFormatName() %>
                    </td>

                    <td>
                        <%= s.getRoom().getRoomName() %>
                    </td>

                    <td>
                        <%= s.getStartAt().toString().replace("T", " ") %>
                    </td>

                    <td>
                        <%= s.getEndAt().toString().replace("T", " ") %>
                    </td>

                    <td>

                        <a class="button edit"
                           href="SelectMovieView.jsp?editIndex=<%= i %>">
                            Sửa
                        </a>

                        <form action="CreateScheduleView.jsp"
                              method="post"
                              style="display:inline;">

                            <input type="hidden"
                                   name="action"
                                   value="delete">

                            <input type="hidden"
                                   name="index"
                                   value="<%= i %>">

                            <button type="submit"
                                    class="button delete"
                                    onclick="return confirm('Bạn có chắc muốn xóa suất chiếu này?');">
                                Xóa
                            </button>

                        </form>

                    </td>

                </tr>

                <%
                        }
                    }
                %>

            </table>

            <div class="actions">

                <a href="ManagerView.jsp"
                   class="button back">
                    Quay lại
                </a>

                <%
                    if (!pendingShowtimes.isEmpty()) {
                %>

                <form action="doSaveSchedule.jsp" method="post">

                    <button type="submit"
                            class="button save"
                            onclick="return confirm('Bạn có chắc muốn lưu toàn bộ lịch chiếu?');">
                        Lưu tất cả lịch chiếu
                    </button>

                </form>

                <%
                    }
                %>

            </div>

        </div>

    </body>
</html>
