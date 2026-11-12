
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ - Cinema</title>

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
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        .login {
            color: white;
            text-decoration: none;
            border: 1px solid white;
            padding: 9px 18px;
            border-radius: 5px;
        }

        .container {
            max-width: 900px;
            margin: 100px auto;
            padding: 30px;
            text-align: center;
        }

        .container h1 {
            margin-bottom: 15px;
        }

        .search-form {
            display: flex;
            max-width: 650px;
            margin: 35px auto;
        }

        .search-form input {
            flex: 1;
            padding: 14px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
            outline: none;
        }

        .search-form button {
            padding: 14px 25px;
            border: none;
            background: #e50914;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border-radius: 0 5px 5px 0;
        }

        .search-form button:hover {
            background: #b80710;
        }
    </style>
</head>

<body>

<header>
    <h2>CINEMA</h2>

    <!-- Chưa triển khai chức năng đăng nhập -->
    <a href="#" class="login">Đăng nhập</a>
</header>

<div class="container">

    <h1>Chào mừng đến với rạp chiếu phim</h1>

    <p>Tìm kiếm bộ phim mà bạn yêu thích</p>

    <form action="MovieListView.jsp"
          method="GET"
          class="search-form">

        <input type="text"
               name="keyword"
               placeholder="Nhập tên phim..."
               autocomplete="off">

        <button type="submit">Tìm kiếm</button>

    </form>

</div>

</body>
</html>
