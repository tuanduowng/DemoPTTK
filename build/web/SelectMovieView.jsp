
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="model.Movie" %>
<%@ page import="model.Format" %>
<%@ page import="model.Showtime" %>
<%@ page import="dao.MovieFormatDAO" %>
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

    int editIndex = -1;
    int selectedMovieId = -1;
    int selectedFormatId = -1;

    try {

        if (request.getParameter("editIndex") != null) {

            editIndex = Integer.parseInt(
                    request.getParameter("editIndex")
            );

            if (editIndex < 0 || editIndex >= pendingShowtimes.size()) {
                editIndex = -1;
            }
        }

        if (request.getParameter("movieId") != null) {

            selectedMovieId = Integer.parseInt(
                    request.getParameter("movieId")
            );
        }

        if (request.getParameter("formatId") != null) {

            selectedFormatId = Integer.parseInt(
                    request.getParameter("formatId")
            );
        }

        // Nếu đang sửa, lấy thông tin phim và định dạng cũ
        if (editIndex >= 0 && request.getParameter("movieId") == null) {

            Showtime old = pendingShowtimes.get(editIndex);

            selectedMovieId = old.getMovie().getId();
            selectedFormatId = old.getFormat().getId();
        }

    } catch (NumberFormatException e) {
        error = "Thông tin lựa chọn không hợp lệ.";
    }

    List<Movie> movies = new ArrayList<>();
    List<Format> formats = new ArrayList<>();
    Movie selectedMovie = null;

    try (MovieFormatDAO movieDAO = new MovieFormatDAO()) {

        movies = movieDAO.getAllMovies();

        if (selectedMovieId > 0) {

            selectedMovie = movieDAO.getMovieById(selectedMovieId);

            if (selectedMovie != null) {
                formats = movieDAO.getFormatsByMovieId(selectedMovieId);
            }
        }

    } catch (SQLException e) {
        error = "Không thể tải dữ liệu phim: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chọn phim</title>

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

            label {
                display: block;
                margin-top: 20px;
                margin-bottom: 8px;
                font-weight: bold;
            }

            select {
                width: 100%;
                padding: 12px;
                border: 1px solid #ccc;
                border-radius: 5px;
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
                <%= editIndex >= 0 ? "Sửa thông tin suất chiếu" : "Chọn phim chiếu" %>
            </h1>

            <p>Bước 1: Chọn phim và định dạng chiếu.</p>

            <% if (error != null) { %>

            <p class="error"><%= error %></p>

            <% } %>

            <!-- Form chọn phim -->
            <form action="SelectMovieView.jsp" method="get">

                <% if (editIndex >= 0) { %>

                <input type="hidden"
                       name="editIndex"
                       value="<%= editIndex %>">

                <% } %>

                <label>Chọn phim</label>

                <select name="movieId" required>

                    <option value="">-- Chọn phim --</option>

                    <% for (Movie movie : movies) { %>

                    <option value="<%= movie.getId() %>"
                            <%= selectedMovieId == movie.getId()
                            ? "selected" : "" %>>

                        <%= movie.getMovieTitle() %>

                    </option>

                    <% } %>

                </select>

                <div style="margin-top:15px;">

                    <button type="submit" class="button primary">
                        Chọn phim
                    </button>

                </div>

            </form>

            <% if (selectedMovie != null && !formats.isEmpty()) { %>

            <hr style="margin-top:25px;">

            <!-- Form chọn định dạng -->
            <form action="SelectShowtimeView.jsp" method="get">

                <input type="hidden"
                       name="movieId"
                       value="<%= selectedMovie.getId() %>">

                <input type="hidden"
                       name="editIndex"
                       value="<%= editIndex %>">

                <label>Định dạng chiếu</label>

                <select name="formatId" required>

                    <option value="">-- Chọn định dạng --</option>

                    <% for (Format format : formats) { %>

                    <option value="<%= format.getId() %>"
                            <%= selectedFormatId == format.getId()
                                ? "selected" : "" %>>

                        <%= format.getFormatName() %>

                    </option>

                    <% } %>

                </select>

                <div class="actions">

                    <a href="CreateScheduleView.jsp"
                       class="button secondary">
                        Quay lại
                    </a>

                    <button type="submit"
                            class="button primary">
                        Tiếp tục
                    </button>

                </div>

            </form>

            <% } else if (selectedMovie != null) { %>

            <p class="error">
                Phim này chưa được cấu hình định dạng chiếu.
            </p>

            <% } %>

        </div>

    </body>
</html>
