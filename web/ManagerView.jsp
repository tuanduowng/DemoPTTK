
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quản lý rạp chiếu phim</title>

        <style>
            body {
                font-family: Arial, sans-serif;
                background: #f4f6f9;
                margin: 0;
            }

            .container {
                width: 800px;
                margin: 80px auto;
                background: white;
                padding: 35px;
                border-radius: 10px;
                box-shadow: 0 2px 10px #ddd;
            }

            h1 {
                color: #263238;
            }

            .menu {
                display: flex;
                gap: 20px;
                margin-top: 30px;
            }

            .menu a {
                flex: 1;
                padding: 25px;
                text-align: center;
                text-decoration: none;
                color: white;
                background: #1976d2;
                border-radius: 8px;
                font-weight: bold;
            }

            .menu a:hover {
                background: #125ca1;
            }
        </style>
    </head>

    <body>

        <div class="container">

            <h1>Hệ thống quản lý rạp chiếu phim</h1>

            <div class="menu">

                <a href="CreateScheduleView.jsp">
                    Lên lịch chiếu
                </a>

            </div>

        </div>

    </body>
</html>
