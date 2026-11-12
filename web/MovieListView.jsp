
<%@ page import="java.util.List" %>
<%@ page import="model.Movie" %>
<%@ page import="dao.MovieDAO" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%!
    // Hàm xử lý ký tự đặc biệt khi hiển thị dữ liệu
    public String escapeHTML(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    request.setCharacterEncoding("UTF-8");

    String keyword = request.getParameter("keyword");

    if (keyword == null) {
        keyword = "";
    }

    keyword = keyword.trim();

    List<Movie> movies = null;
    String error = null;

    // Chỉ tìm kiếm khi người dùng đã nhập từ khóa
    if (!keyword.isEmpty()) {

        try (MovieDAO dao = new MovieDAO()) {

            movies = dao.getMovieList(keyword);

        } catch (SQLException e) {

            error = "Không thể tìm kiếm phim: " + e.getMessage();

            application.log("Lỗi tìm kiếm phim", e);
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách phim - Cinema</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f5f5;
        }

        header {
            background: #20232a;
            color: white;
            padding: 20px 8%;
        }

        header a {
            color: white;
            text-decoration: none;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 0 20px;
        }

        .search-form {
            display: flex;
            max-width: 650px;
            margin: 25px 0;
        }

        .search-form input {
            flex: 1;
            padding: 12px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
        }

        .search-form button {
            padding: 12px 22px;
            border: none;
            background: #e50914;
            color: white;
            cursor: pointer;
            border-radius: 0 5px 5px 0;
        }

        .movie-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 25px;
            margin-top: 25px;
        }

        .movie-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .no-poster {
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #ddd;
            color: #666;
        }

        .movie-info {
            padding: 15px;
        }

        .movie-info h3 {
            margin-top: 0;
        }

        .message {
            margin-top: 25px;
            color: #666;
        }

        .error {
            color: #d00000;
        }

        .back {
            display: inline-block;
            margin-top: 25px;
            color: #333;
            text-decoration: none;
        }
    </style>
</head>

<body>

<header>
    <h2>
        <a href="HomeView.jsp">CINEMA</a>
    </h2>
</header>

<div class="container">

    <h2>Tìm kiếm phim</h2>

    <!-- Form tìm kiếm, giữ lại từ khóa cũ -->
    <form action="MovieListView.jsp"
          method="GET"
          class="search-form">

        <input type="text"
               name="keyword"
               value="<%= escapeHTML(keyword) %>"
               placeholder="Nhập tên phim..."
               autocomplete="off">

        <button type="submit">Tìm kiếm</button>

    </form>

    <%
        if (error != null) {
    %>

        <p class="message error">
            <%= escapeHTML(error) %>
        </p>

    <%
        } else if (keyword.isEmpty()) {
    %>

        <p class="message">
            Vui lòng nhập tên phim để tìm kiếm.
        </p>

    <%
        } else if (movies.isEmpty()) {
    %>

        <p class="message">
            Không tìm thấy phim phù hợp với từ khóa:
            <strong><%= escapeHTML(keyword) %></strong>
        </p>

    <%
        } else {
    %>

        <h3>
            Kết quả tìm kiếm cho:
            "<%= escapeHTML(keyword) %>"
        </h3>

        <p>Tìm thấy <%= movies.size() %> bộ phim.</p>

        <div class="movie-list">

            <% for (Movie movie : movies) { %>

                <div class="movie-card">

                    <% if (movie.getPoster() != null
                            && !movie.getPoster().trim().isEmpty()) { %>

                        <img
                            src="<%= request.getContextPath() %>/<%= escapeHTML(movie.getPoster()) %>"
                            alt="<%= escapeHTML(movie.getMovieTitle()) %>">

                    <% } else { %>

                        <div class="no-poster">
                            Chưa có poster
                        </div>

                    <% } %>

                    <div class="movie-info">

                        <h3>
                            <%= escapeHTML(movie.getMovieTitle()) %>
                        </h3>

                        <p>
                            Thời lượng:
                            <%= movie.getDuration() %> phút
                        </p>

                        <p>
                            Đạo diễn:
                            <%= escapeHTML(movie.getDirector()) %>
                        </p>

                        <p>
                            Trạng thái:
                            <%= movie.isNowShowing()
                                    ? "Đang chiếu"
                                    : "Không chiếu" %>
                        </p>

                    </div>

                </div>

            <% } %>

        </div>

    <%
        }
    %>

    <a href="HomeView.jsp" class="back">
        ← Quay lại trang chủ
    </a>

</div>

</body>
</html>
